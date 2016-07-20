//
//  AsyncSocket.m
//
//  This class is in the public domain.
//  Originally created by Dustin Voss on Wed Jan 29 2003.
//  Updated and maintained by Deusty Designs and the Mac development community.
//
//  http://code.google.com/p/cocoaasyncsocket/
//

#import "AsyncSocket.h"
#import <sys/socket.h>
#import <netinet/in.h>
#import <netinet6/in6.h>
#import <arpa/inet.h>
#import <netdb.h>

#if TARGET_OS_IPHONE
#import <CFNetwork/CFNetwork.h>
#endif

#pragma mark Declarations

#define READQUEUE_CAPACITY	5           
#define WRITEQUEUE_CAPACITY 5           
#define READALL_CHUNKSIZE	256         
#define WRITE_CHUNKSIZE    (1024 * 4)   

NSString *const AsyncSocketException = @"AsyncSocketException";
NSString *const AsyncSocketErrorDomain = @"AsyncSocketErrorDomain";

static NSString *getaddrinfoLock = @"lock";

enum AsyncSocketFlags
{
	kEnablePreBuffering   = 1 << 0,   
	kMysrvCallConnectDeleg  = 1 << 1,   
	kMysrvPassConnectMethod = 1 << 2,   
	kForbidReadsWrites    = 1 << 3,   
	kDisconnectSoon       = 1 << 4,   
	kClosingWithError     = 1 << 5,   
};

@interface AsyncSocket (Private)

- (CFSocketRef) createAcceptSocketForAddress:(NSData *)addr error:(NSError **)errPtr;
- (BOOL) createSocketForAddress:(NSData *)remoteAddr error:(NSError **)errPtr;
- (BOOL) attachSocketsToRunLoop:(NSRunLoop *)runLoop error:(NSError **)errPtr;
- (BOOL) configureSocketAndReturnError:(NSError **)errPtr;
- (BOOL) connectSocketToAddress:(NSData *)remoteAddr error:(NSError **)errPtr;
- (void) doAcceptWithSocket:(CFSocketNativeHandle)newSocket;
- (void) doSocketOpen:(CFSocketRef)sock withCFSocketError:(CFSocketError)err;

- (BOOL) createStreamsFromNative:(CFSocketNativeHandle)native error:(NSError **)errPtr;
- (BOOL) createStreamsToHost:(NSString *)hostname onPort:(UInt16)port error:(NSError **)errPtr;
- (BOOL) attachStreamsToRunLoop:(NSRunLoop *)runLoop error:(NSError **)errPtr;
- (BOOL) configureStreamsAndReturnError:(NSError **)errPtr;
- (BOOL) openStreamsAndReturnError:(NSError **)errPtr;
- (void) doStreamOpen;
- (BOOL) setSocketFromStreamsAndReturnError:(NSError **)errPtr;

- (void) closeWithError:(NSError *)err;
- (void) recoverUnreadData;
- (void) emptyQueues;
- (void) close;

- (NSError *) getErrnoError;
- (NSError *) getAbortError;
- (NSError *) getStreamError;
- (NSError *) getSocketError;
- (NSError *) getReadMaxedOutError;
- (NSError *) getReadTimeoutError;
- (NSError *) getWriteTimeoutError;
- (NSError *) errorFromCFStreamError:(CFStreamError)err;

- (BOOL) isSocketConnected;
- (BOOL) areStreamsConnected;
- (NSString *) connectedHost: (CFSocketRef)socket;
- (UInt16) connectedPort: (CFSocketRef)socket;
- (NSString *) localHost: (CFSocketRef)socket;
- (UInt16) localPort: (CFSocketRef)socket;
- (NSString *) addressHost: (CFDataRef)cfaddr;
- (UInt16) addressPort: (CFDataRef)cfaddr;

- (void) doBytesAvailable;
- (void) completeCurrentRead;
- (void) endCurrentRead;
- (void) scheduleDequeueRead;
- (void) maybeDequeueRead;
- (void) doReadTimeout:(NSTimer *)timer;

- (void) doSendBytes;
- (void) completeCurrentWrite;
- (void) endCurrentWrite;
- (void) scheduleDequeueWrite;
- (void) maybeDequeueWrite;
- (void) maybeScheduleDisconnect;
- (void) doWriteTimeout:(NSTimer *)timer;

- (void) doCFCallback:(CFSocketCallBackType)type forSocket:(CFSocketRef)sock withAddress:(NSData *)address withData:(const void *)pData;
- (void) doCFReadStreamCallback:(CFStreamEventType)type forStream:(CFReadStreamRef)stream;
- (void) doCFWriteStreamCallback:(CFStreamEventType)type forStream:(CFWriteStreamRef)stream;

@end

static void MyCFSocketCallback (CFSocketRef, CFSocketCallBackType, CFDataRef, const void *, void *);
static void MyCFReadStreamCallback (CFReadStreamRef stream, CFStreamEventType type, void *pInfo);
static void MyCFWriteStreamCallback (CFWriteStreamRef stream, CFStreamEventType type, void *pInfo);

#pragma mark -

@interface AsyncReadPacket : NSObject
{
@public
	NSMutableData *buffer;
	CFIndex bytesDone;
	NSTimeInterval timeout;
	CFIndex maxLength;
	long tag;
	NSData *term;
	BOOL readAllAvailableData;
}
- (id)initWithData:(NSMutableData *)d
		   timeout:(NSTimeInterval)t
			   tag:(long)i
  readAllAvailable:(BOOL)a
		terminator:(NSData *)e
	  	 maxLength:(CFIndex)m;

- (unsigned)readLengthForTerm;

- (unsigned)prebufferReadLengthForTerm;
- (CFIndex)searchForTermAfterPreBuffering:(CFIndex)numBytes;

- (void)dealloc;
@end

@implementation AsyncReadPacket

- (id)initWithData:(NSMutableData *)d
		   timeout:(NSTimeInterval)t
			   tag:(long)i
  readAllAvailable:(BOOL)a
		terminator:(NSData *)e
         maxLength:(CFIndex)m
{
	if(self = [super init])
	{
		buffer = [d retain];
		timeout = t;
		tag = i;
		readAllAvailableData = a;
		term = [e copy];
		bytesDone = 0;
		maxLength = m;
	}
	return self;
}

- (unsigned)readLengthForTerm
{
	NSAssert(term != nil, @"Searching for term in data when there is no term.");
	
	
	unsigned result = [term length];
	
	CFIndex i = MAX(0, (CFIndex)(bytesDone - [term length] + 1));
	CFIndex j = MIN([term length] - 1, bytesDone);
	
	while(i < bytesDone)
	{
		const void *subBuffer = [buffer bytes] + i;
		
		if(memcmp(subBuffer, [term bytes], j) == 0)
		{
			result = [term length] - j;
			break;
		}
		
		i++;
		j--;
	}
	
	if(maxLength > 0)
	{
		return MIN(result, (maxLength - bytesDone));
	}
	else
	{
		return result;
	}
	
}

- (unsigned)prebufferReadLengthForTerm
{
	if(maxLength > 0)
	{
		return MIN(READALL_CHUNKSIZE, (maxLength - bytesDone));
	}
	else
	{
		return READALL_CHUNKSIZE;
	}
	
}

- (CFIndex)searchForTermAfterPreBuffering:(CFIndex)numBytes
{
	NSAssert(term != nil, @"Searching for term in data when there is no term.");
	
	CFIndex i = MAX(0, (CFIndex)(bytesDone - numBytes - [term length] + 1));
	
	while(i + [term length] <= bytesDone)
	{
		const void *subBuffer = [buffer bytes] + i;
		
		if(memcmp(subBuffer, [term bytes], [term length]) == 0)
		{
			return bytesDone - (i + [term length]);
		}
		
		i++;
	}
	
	return -1;
}

- (void)dealloc
{
	[buffer release];
	[term release];
	[super dealloc];
}

@end

#pragma mark -

@interface AsyncWritePacket : NSObject
{
@public
	NSData *buffer;
	CFIndex bytesDone;
	long tag;
	NSTimeInterval timeout;
}
- (id)initWithData:(NSData *)d timeout:(NSTimeInterval)t tag:(long)i;
- (void)dealloc;
@end

@implementation AsyncWritePacket

- (id)initWithData:(NSData *)d timeout:(NSTimeInterval)t tag:(long)i;
{
	if(self = [super init])
	{
		buffer = [d retain];
		timeout = t;
		tag = i;
		bytesDone = 0;
	}
	return self;
}

- (void)dealloc
{
	[buffer release];
	[super dealloc];
}

@end

#pragma mark -

@implementation AsyncSocket

- (id)init
{
	return [self initWithDelegate:nil userData:0];
}

- (id)initWithDelegate:(id)delegate
{
	return [self initWithDelegate:delegate userData:0];
}


- (id)initWithDelegate:(id)delegate userData:(long)userData
{
	if(self = [super init])
	{
		theFlags = 0x00;
		theDelegate = delegate;
		theUserData = userData;
		
		theSocket		= NULL;
		theSource		= NULL;
		theSocket6		= NULL;
		theSource6		= NULL;
		theRunLoop		= NULL;
		theReadStream	= NULL;
		theWriteStream	= NULL;
		
		theReadQueue	= [[NSMutableArray alloc] initWithCapacity:READQUEUE_CAPACITY];
		theCurrentRead	= nil;
		theReadTimer	= nil;
		
		partialReadBuffer = [[NSMutableData alloc] initWithCapacity:READALL_CHUNKSIZE];
		
		theWriteQueue = [[NSMutableArray alloc] initWithCapacity:WRITEQUEUE_CAPACITY];
		theCurrentWrite	= nil;
		theWriteTimer	= nil;
		
		NSAssert(sizeof(CFSocketContext) == sizeof(CFStreamClientContext), @"CFSocketContext != CFStreamClientContext");
		theContext.version = 0;
		theContext.info		= self;
		theContext.retain	= nil;
		theContext.release	= nil;
		theContext.copyDescription = nil;
	}
	return self;
}


- (void)dealloc
{
	[self close];
	[theReadQueue	release];
	[theWriteQueue	release];
	[NSObject cancelPreviousPerformRequestsWithTarget:theDelegate selector:@selector(onSocketMySrvDisconnect:) object:self];
	[NSObject cancelPreviousPerformRequestsWithTarget:self];
	[super dealloc];
}

#pragma mark Accessors

- (long)userData
{
	return theUserData;
}

- (void)setUserData:(long)userData
{
	theUserData = userData;
}

- (id)delegate
{
	return theDelegate;
}

- (void)setDelegate:(id)delegate
{
	theDelegate = delegate;
}

- (BOOL)canSafelySetDelegate
{
	return ([theReadQueue count] == 0 && [theWriteQueue count] == 0 && theCurrentRead == nil && theCurrentWrite == nil);
}

- (CFSocketRef)getCFSocket
{
	if(theSocket)
		return theSocket;
	else
		return theSocket6;
}

- (CFReadStreamRef)getCFReadStream
{
	return theReadStream;
}

- (CFWriteStreamRef)getCFWriteStream
{
	return theWriteStream;
}

- (float)progressOfReadReturningTag:(long *)tag bytesDone:(CFIndex *)done total:(CFIndex *)total
{
	if (!theCurrentRead) return NAN;
	
	BOOL hasTotal = (theCurrentRead->readAllAvailableData == NO && theCurrentRead->term == nil);
	
	CFIndex d = theCurrentRead->bytesDone;
	CFIndex t = hasTotal ? [theCurrentRead->buffer length] : 0;
	if (tag != NULL)   *tag	= theCurrentRead->tag;
	if (done != NULL)  *done = d;
	if (total != NULL) *total = t;
	float ratio = (float)d/(float)t;
	return isnan(ratio) ? 1.0 : ratio; 
}

- (float)progressOfWriteReturningTag:(long *)tag bytesDone:(CFIndex *)done total:(CFIndex *)total
{
	if (!theCurrentWrite) return NAN;
	CFIndex d = theCurrentWrite->bytesDone;
	CFIndex t = [theCurrentWrite->buffer length];
	if (tag != NULL)   *tag = theCurrentWrite->tag;
	if (done != NULL)  *done = d;
	if (total != NULL) *total = t;
	return (float)d/(float)t;
}

#pragma mark Configuration

- (void)enablePreBuffering
{
	theFlags |= kEnablePreBuffering;
}

#pragma mark Connection

- (BOOL)acceptOnPort:(UInt16)port error:(NSError **)errPtr
{
	return [self acceptOnAddress:nil port:port error:errPtr];
}

- (BOOL)acceptOnAddress:(NSString *)hostaddr port:(UInt16)port error:(NSError **)errPtr
{
	if (theDelegate == NULL)
	{
		[NSException raise:AsyncSocketException format:@"Attempting to accept without a delegate. Set a delegate first."];
	}
	
	if (theSocket != NULL || theSocket6 != NULL)
	{
		[NSException raise:AsyncSocketException format:@"Attempting to accept while connected or accepting connections. Disconnect first."];
	}
	
	NSData *address = nil, *address6 = nil;
	if(hostaddr == nil || ([hostaddr length] == 0))
	{
		
        NSString *portStr = [NSString stringWithFormat:@"%hu", port];
        struct addrinfo hints;
        struct addrinfo *res0 = NULL;
        struct addrinfo *res;
        
        memset(&hints, 0, sizeof(hints));
        hints.ai_family = AF_UNSPEC;
        hints.ai_socktype = SOCK_STREAM;
        hints.ai_flags = AI_PASSIVE;
        int error = getaddrinfo(NULL, [portStr UTF8String], &hints, &res0);
        if(error)
        {
            if(errPtr)
            {
                NSString *errMsg = [NSString stringWithCString:gai_strerror(error) encoding:NSASCIIStringEncoding];
                NSDictionary *info = [NSDictionary dictionaryWithObject:errMsg forKey:NSLocalizedDescriptionKey];
                
                *errPtr = [NSError errorWithDomain:@"kCFStreamErrorDomainNetDB" code:error userInfo:info];
            }
        }
        
        for (res = res0; res != NULL; res = res->ai_next) {
            
            if (res != NULL) {
                
                if(!address && (res->ai_family == AF_INET))
                {
                    address = [NSData dataWithBytes:res->ai_addr length:res->ai_addrlen];
                }
                else if(!address6 && (res->ai_family == AF_INET6))
                {
                    address6 = [NSData dataWithBytes:res->ai_addr length:res->ai_addrlen];
                }
            }
        }
        freeaddrinfo(res0);
        
        if(!address && !address6) return NO;
	}
	else if([hostaddr isEqualToString:@"localhost"] || [hostaddr isEqualToString:@"loopback"])
	{
		
        NSString *portStr = [NSString stringWithFormat:@"%hu", port];
        struct addrinfo hints;
        struct addrinfo *res0 = NULL;
        struct addrinfo *res;
        
        memset(&hints, 0, sizeof(hints));
        hints.ai_family = AF_UNSPEC;
        hints.ai_socktype = SOCK_STREAM;
        int error = getaddrinfo(NULL, [portStr UTF8String], &hints, &res0);
        if(error)
        {
            if(errPtr)
            {
                NSString *errMsg = [NSString stringWithCString:gai_strerror(error) encoding:NSASCIIStringEncoding];
                NSDictionary *info = [NSDictionary dictionaryWithObject:errMsg forKey:NSLocalizedDescriptionKey];
                
                *errPtr = [NSError errorWithDomain:@"kCFStreamErrorDomainNetDB" code:error userInfo:info];
            }
        }
        
        for (res = res0; res != NULL; res = res->ai_next) {
            
            if (res != NULL) {
                
                if(!address && (res->ai_family == AF_INET))
                {
                    address = [NSData dataWithBytes:res->ai_addr length:res->ai_addrlen];
                }
                else if(!address6 && (res->ai_family == AF_INET6))
                {
                    address6 = [NSData dataWithBytes:res->ai_addr length:res->ai_addrlen];
                }
            }
        }
        freeaddrinfo(res0);
        
        if(!address && !address6) return NO;
	}
	else
	{
		NSString *portStr = [NSString stringWithFormat:@"%hu", port];
		
		@synchronized (getaddrinfoLock)
		{
			struct addrinfo hints, *res, *res0;
			
			memset(&hints, 0, sizeof(hints));
			hints.ai_family   = PF_UNSPEC;
			hints.ai_socktype = SOCK_STREAM;
			hints.ai_protocol = IPPROTO_TCP;
			hints.ai_flags    = AI_PASSIVE;
			
			int error = getaddrinfo([hostaddr UTF8String], [portStr UTF8String], &hints, &res0);
			
			if(error)
			{
				if(errPtr)
				{
					NSString *errMsg = [NSString stringWithCString:gai_strerror(error) encoding:NSASCIIStringEncoding];
					NSDictionary *info = [NSDictionary dictionaryWithObject:errMsg forKey:NSLocalizedDescriptionKey];
					
					*errPtr = [NSError errorWithDomain:@"kCFStreamErrorDomainNetDB" code:error userInfo:info];
				}
			}
			
			for(res = res0; res; res = res->ai_next)
			{
				if(!address && (res->ai_family == AF_INET))
				{
					
					address = [NSData dataWithBytes:res->ai_addr length:res->ai_addrlen];
				}
				else if(!address6 && (res->ai_family == AF_INET6))
				{
					
					address6 = [NSData dataWithBytes:res->ai_addr length:res->ai_addrlen];
				}
			}
			freeaddrinfo(res0);
		}
		
		if(!address && !address6) return NO;
	}
	
	if (address)
	{
		theSocket = [self createAcceptSocketForAddress:address error:errPtr];
		if (theSocket == NULL) goto Failed;
	}
	
	if (address6)
	{
		theSocket6 = [self createAcceptSocketForAddress:address6 error:errPtr];
		
#if !TARGET_OS_IPHONE
		if (theSocket6 == NULL) goto Failed;
#endif
	}
	
	[self attachSocketsToRunLoop:nil error:nil];
	
	int reuseOn = 1;
	if (theSocket)	setsockopt(CFSocketGetNative(theSocket), SOL_SOCKET, SO_REUSEADDR, &reuseOn, sizeof(reuseOn));
	if (theSocket6)	setsockopt(CFSocketGetNative(theSocket6), SOL_SOCKET, SO_REUSEADDR, &reuseOn, sizeof(reuseOn));
	
	CFSocketError err;
	if (theSocket)
	{
		err = CFSocketSetAddress (theSocket, (CFDataRef)address);
		if (err != kCFSocketSuccess) goto Failed;
	}
	
	if(port == 0 && theSocket && theSocket6)
	{
		UInt16 chosenPort = [self localPort:theSocket];
		
		struct sockaddr_in6 *pSockAddr6 = (struct sockaddr_in6 *)[address6 bytes];
		pSockAddr6->sin6_port = htons(chosenPort);
    }
	
	if (theSocket6)
	{
		err = CFSocketSetAddress (theSocket6, (CFDataRef)address6);
		if (err != kCFSocketSuccess) goto Failed;
		
	}
	
	theFlags |= kMysrvPassConnectMethod;
	return YES;
	
Failed:;
	if(errPtr) *errPtr = [self getSocketError];
	if(theSocket != NULL)
	{
		CFSocketInvalidate(theSocket);
		CFRelease(theSocket);
		theSocket = NULL;
	}
	if(theSocket6 != NULL)
	{
		CFSocketInvalidate(theSocket6);
		CFRelease(theSocket6);
		theSocket6 = NULL;
	}
	return NO;
}

- (BOOL)connectToHost:(NSString*)hostname onPort:(UInt16)port error:(NSError **)errPtr
{
	if(theDelegate == NULL)
	{
		NSString *message = @"Attempting to connect without a delegate. Set a delegate first.";
		[NSException raise:AsyncSocketException format:message];
	}
	
	if(theSocket != NULL || theSocket6 != NULL)
	{
		NSString *message = @"Attempting to connect while connected or accepting connections. Disconnect first.";
		[NSException raise:AsyncSocketException format:message];
	}
	
	BOOL pass = YES;
	
	if(pass && ![self createStreamsToHost:hostname onPort:port error:errPtr]) pass = NO;
	if(pass && ![self attachStreamsToRunLoop:nil error:errPtr])               pass = NO;
	if(pass && ![self configureStreamsAndReturnError:errPtr])                 pass = NO;
	if(pass && ![self openStreamsAndReturnError:errPtr])                      pass = NO;
	
	if(pass)
		theFlags |= kMysrvPassConnectMethod;
	else
		[self close];
	
	return pass;
}

- (BOOL)connectToAddress:(NSData *)remoteAddr error:(NSError **)errPtr
{
	if (theDelegate == NULL)
	{
		NSString *message = @"Attempting to connect without a delegate. Set a delegate first.";
		[NSException raise:AsyncSocketException format:message];
	}
	
	if (theSocket != NULL || theSocket6 != NULL)
	{
		NSString *message = @"Attempting to connect while connected or accepting connections. Disconnect first.";
		[NSException raise:AsyncSocketException format:message];
	}
	
	BOOL pass = YES;
	
	if(pass && ![self createSocketForAddress:remoteAddr error:errPtr])   pass = NO;
	if(pass && ![self attachSocketsToRunLoop:nil error:errPtr])          pass = NO;
	if(pass && ![self configureSocketAndReturnError:errPtr])             pass = NO;
	if(pass && ![self connectSocketToAddress:remoteAddr error:errPtr])   pass = NO;
	
	if(pass)
		theFlags |= kMysrvPassConnectMethod;
	else
		[self close];
	
	return pass;
}

#pragma mark Socket Implementation:

- (CFSocketRef)createAcceptSocketForAddress:(NSData *)addr error:(NSError **)errPtr
{
	struct sockaddr *pSockAddr = (struct sockaddr *)[addr bytes];
	int addressFamily = pSockAddr->sa_family;
	
	CFSocketRef socket = CFSocketCreate(kCFAllocatorDefault,
										addressFamily,
										SOCK_STREAM,
										0,
										kCFSocketAcceptCallBack,                
										(CFSocketCallBack)&MyCFSocketCallback,  
										&theContext);
	
	if(socket == NULL)
	{
		if(errPtr) *errPtr = [self getSocketError];
	}
	
	return socket;
}

- (BOOL)createSocketForAddress:(NSData *)remoteAddr error:(NSError **)errPtr
{
	struct sockaddr *pSockAddr = (struct sockaddr *)[remoteAddr bytes];
	
	if(pSockAddr->sa_family == AF_INET)
	{
		theSocket = CFSocketCreate(NULL,                                   
								   PF_INET,                                
								   SOCK_STREAM,                            
								   IPPROTO_TCP,                            
								   kCFSocketConnectCallBack,               
								   (CFSocketCallBack)&MyCFSocketCallback,  
								   &theContext);                           
		
		if(theSocket == NULL)
		{
			if (errPtr) *errPtr = [self getSocketError];
			return NO;
		}
	}
	else if(pSockAddr->sa_family == AF_INET6)
	{
		theSocket6 = CFSocketCreate(NULL,                                   
								    PF_INET6,                               
								    SOCK_STREAM,                            
								    IPPROTO_TCP,                            
								    kCFSocketConnectCallBack,               
								    (CFSocketCallBack)&MyCFSocketCallback,  
								    &theContext);                           
		
		if(theSocket6 == NULL)
		{
			if (errPtr) *errPtr = [self getSocketError];
			return NO;
		}
	}
	else
	{
		if (errPtr) *errPtr = [self getSocketError];
		return NO;
	}
	
	return YES;
}

- (BOOL)attachSocketsToRunLoop:(NSRunLoop *)runLoop error:(NSError **)errPtr
{
	
	theRunLoop = (runLoop == nil) ? CFRunLoopGetCurrent() : [runLoop getCFRunLoop];
	
	if(theSocket)
	{
		theSource  = CFSocketCreateRunLoopSource (kCFAllocatorDefault, theSocket, 0);
		CFRunLoopAddSource (theRunLoop, theSource, kCFRunLoopDefaultMode);
	}
	
	if(theSocket6)
	{
		theSource6 = CFSocketCreateRunLoopSource (kCFAllocatorDefault, theSocket6, 0);
		CFRunLoopAddSource (theRunLoop, theSource6, kCFRunLoopDefaultMode);
	}
	
	return YES;
}

- (BOOL)configureSocketAndReturnError:(NSError **)errPtr
{
	
	if([theDelegate respondsToSelector:@selector(onSocketWillConnect:)])
	{
		if([theDelegate onSocketWillConnect:self] == NO)
		{
			if (errPtr) *errPtr = [self getAbortError];
			return NO;
		}
	}
	return YES;
}

- (BOOL)connectSocketToAddress:(NSData *)remoteAddr error:(NSError **)errPtr
{
	
	
	if(theSocket)
	{
		CFSocketError err = CFSocketConnectToAddress(theSocket, (CFDataRef)remoteAddr, -1);
		if(err != kCFSocketSuccess)
		{
			if (errPtr) *errPtr = [self getSocketError];
			return NO;
		}
	}
	else if(theSocket6)
	{
		CFSocketError err = CFSocketConnectToAddress(theSocket6, (CFDataRef)remoteAddr, -1);
		if(err != kCFSocketSuccess)
		{
			if (errPtr) *errPtr = [self getSocketError];
			return NO;
		}
	}
	
	return YES;
}

- (void)doAcceptWithSocket:(CFSocketNativeHandle)newNative
{
	AsyncSocket *newSocket = [[[[self class] alloc] initWithDelegate:theDelegate] autorelease];
	
	
	
	if(newSocket)
	{
		if ([theDelegate respondsToSelector:@selector(onSocket:mysrvAcceptNewSocket:)])
			[theDelegate onSocket:self mysrvAcceptNewSocket:newSocket];
		
		NSRunLoop *runLoop = nil;
		if ([theDelegate respondsToSelector:@selector(onSocket:wantsRunLoopForNewSocket:)])
			runLoop = [theDelegate onSocket:self wantsRunLoopForNewSocket:newSocket];
		
		BOOL pass = YES;
		
		if(pass && ![newSocket createStreamsFromNative:newNative error:nil]) pass = NO;
		if(pass && ![newSocket attachStreamsToRunLoop:runLoop error:nil])    pass = NO;
		if(pass && ![newSocket configureStreamsAndReturnError:nil])          pass = NO;
		if(pass && ![newSocket openStreamsAndReturnError:nil])               pass = NO;
		
		if(pass)
			newSocket->theFlags |= kMysrvPassConnectMethod;
		else {
			
			[newSocket close];
		}
		
	}
}

- (void)doSocketOpen:(CFSocketRef)sock withCFSocketError:(CFSocketError)socketError
{
	NSParameterAssert ((sock == theSocket) || (sock == theSocket6));
	
	if(socketError == kCFSocketTimeout || socketError == kCFSocketError)
	{
		[self closeWithError:[self getSocketError]];
		return;
	}
	
	
	CFSocketNativeHandle nativeSocket = CFSocketGetNative(sock);
	
	
	CFSocketSetSocketFlags(sock, 0);
	
	
	
	
	
	
	
	
	CFSocketInvalidate(sock);
	CFRelease(sock);
	theSocket = NULL;
	theSocket6 = NULL;
	
	NSError *err;
	BOOL pass = YES;
	
	if(pass && ![self createStreamsFromNative:nativeSocket error:&err]) pass = NO;
	if(pass && ![self attachStreamsToRunLoop:nil error:&err])           pass = NO;
	if(pass && ![self openStreamsAndReturnError:&err])                  pass = NO;
	
	if(!pass)
	{
		[self closeWithError:err];
	}
}


#pragma mark Stream Implementation:


- (BOOL)createStreamsFromNative:(CFSocketNativeHandle)native error:(NSError **)errPtr
{
	
	CFStreamCreatePairWithSocket(kCFAllocatorDefault, native, &theReadStream, &theWriteStream);
	if (theReadStream == NULL || theWriteStream == NULL)
	{
		NSError *err = [self getStreamError];
		NSLog (@"AsyncSocket %p couldn't create streams from accepted socket: %@", self, err);
		if (errPtr) *errPtr = err;
		return NO;
	}
	
	
	CFReadStreamSetProperty(theReadStream, kCFStreamPropertyShouldCloseNativeSocket, kCFBooleanTrue);
	CFWriteStreamSetProperty(theWriteStream, kCFStreamPropertyShouldCloseNativeSocket, kCFBooleanTrue);
	
	return YES;
}

- (BOOL)createStreamsToHost:(NSString *)hostname onPort:(UInt16)port error:(NSError **)errPtr
{
	
	CFStreamCreatePairWithSocketToHost(kCFAllocatorDefault, (CFStringRef)hostname, port, &theReadStream, &theWriteStream);
	if (theReadStream == NULL || theWriteStream == NULL)
	{
		if (errPtr) *errPtr = [self getStreamError];
		return NO;
	}
	
	
	CFReadStreamSetProperty(theReadStream, kCFStreamPropertyShouldCloseNativeSocket, kCFBooleanTrue);
	CFWriteStreamSetProperty(theWriteStream, kCFStreamPropertyShouldCloseNativeSocket, kCFBooleanTrue);
	
	return YES;
}

- (BOOL)attachStreamsToRunLoop:(NSRunLoop *)runLoop error:(NSError **)errPtr
{
	
	theRunLoop = (runLoop == nil) ? CFRunLoopGetCurrent() : [runLoop getCFRunLoop];
	
	
	if (!CFReadStreamSetClient (theReadStream,
								kCFStreamEventHasBytesAvailable | kCFStreamEventErrorOccurred | kCFStreamEventEndEncountered | kCFStreamEventOpenCompleted,
								(CFReadStreamClientCallBack)&MyCFReadStreamCallback,
								(CFStreamClientContext *)(&theContext) ))
	{
		NSError *err = [self getStreamError];
		
		NSLog (@"AsyncSocket %p couldn't attach read stream to run-loop,", self);
		NSLog (@"Error: %@", err);
		
		if (errPtr) *errPtr = err;
		return NO;
	}
	CFReadStreamScheduleWithRunLoop (theReadStream, theRunLoop, kCFRunLoopDefaultMode);
	
	
	if (!CFWriteStreamSetClient (theWriteStream,
								 kCFStreamEventCanAcceptBytes | kCFStreamEventErrorOccurred | kCFStreamEventEndEncountered | kCFStreamEventOpenCompleted,
								 (CFWriteStreamClientCallBack)&MyCFWriteStreamCallback,
								 (CFStreamClientContext *)(&theContext) ))
	{
		NSError *err = [self getStreamError];
		
		NSLog (@"AsyncSocket %p couldn't attach write stream to run-loop,", self);
		NSLog (@"Error: %@", err);
		
		if (errPtr) *errPtr = err;
		return NO;
		
	}
	CFWriteStreamScheduleWithRunLoop (theWriteStream, theRunLoop, kCFRunLoopDefaultMode);
	
	return YES;
}

- (BOOL)configureStreamsAndReturnError:(NSError **)errPtr
{
	
	if([theDelegate respondsToSelector:@selector(onSocketWillConnect:)])
	{
		if([theDelegate onSocketWillConnect:self] == NO)
		{
			if (errPtr) *errPtr = [self getAbortError];
			return NO;
		}
	}
	return YES;
}

- (BOOL)openStreamsAndReturnError:(NSError **)errPtr
{
	BOOL pass = YES;
	
	if(pass && !CFReadStreamOpen (theReadStream))
	{
		NSLog (@"AsyncSocket %p couldn't open read stream,", self);
		pass = NO;
	}
	
	if(pass && !CFWriteStreamOpen (theWriteStream))
	{
		NSLog (@"AsyncSocket %p couldn't open write stream,", self);
		pass = NO;
	}
	
	if(!pass)
	{
		if (errPtr) *errPtr = [self getStreamError];
	}
	
	return pass;
}

- (void)doStreamOpen
{
	NSError *err = nil;
	if ([self areStreamsConnected] && !(theFlags & kMysrvCallConnectDeleg))
	{
		
		if (![self setSocketFromStreamsAndReturnError: &err])
		{
			NSLog (@"AsyncSocket %p couldn't get socket from streams, %@. Disconnecting.", self, err);
			[self closeWithError:err];
			return;
		}
		
		
		theFlags |= kMysrvCallConnectDeleg;
		if ([theDelegate respondsToSelector:@selector(onSocket:mysrvConnectToHost:port:)])
		{
			[theDelegate onSocket:self mysrvConnectToHost:[self connectedHost] port:[self connectedPort]];
		}
		
		
		[self maybeDequeueRead];
		[self maybeDequeueWrite];
	}
}

- (BOOL)setSocketFromStreamsAndReturnError:(NSError **)errPtr
{
	
	CFSocketNativeHandle native;
	CFDataRef nativeProp = CFReadStreamCopyProperty(theReadStream, kCFStreamPropertySocketNativeHandle);
	if(nativeProp == NULL)
	{
		if (errPtr) *errPtr = [self getStreamError];
		return NO;
	}
	
	CFDataGetBytes(nativeProp, CFRangeMake(0, CFDataGetLength(nativeProp)), (UInt8 *)&native);
	CFRelease(nativeProp);
	
	CFSocketRef socket = CFSocketCreateWithNative(kCFAllocatorDefault, native, 0, NULL, NULL);
	if(socket == NULL)
	{
		if (errPtr) *errPtr = [self getSocketError];
		return NO;
	}
	
	
	CFDataRef peeraddr = CFSocketCopyPeerAddress(socket);
	struct sockaddr *sa = (struct sockaddr *)CFDataGetBytePtr(peeraddr);
	
	if(sa->sa_family == AF_INET)
	{
		theSocket = socket;
	}
	else
	{
		theSocket6 = socket;
	}
	
	CFRelease(peeraddr);
	
	return YES;
}


#pragma mark Disconnect Implementation:



- (void)closeWithError:(NSError *)err
{
	theFlags |= kClosingWithError;
	
	if (theFlags & kMysrvPassConnectMethod)
	{
		
		[self recoverUnreadData];
		
		
		if ([theDelegate respondsToSelector:@selector(onSocket:willDisconnectWithError:)])
		{
			[theDelegate onSocket:self willDisconnectWithError:err];
		}
	}
	[self close];
}


- (void)recoverUnreadData
{
	if((theCurrentRead != nil) && (theCurrentRead->bytesDone > 0))
	{
		
		
		
		[partialReadBuffer replaceBytesInRange:NSMakeRange(0, 0)
									 withBytes:[theCurrentRead->buffer bytes]
										length:theCurrentRead->bytesDone];
	}
	
	[self emptyQueues];
}

- (void)emptyQueues
{
	if (theCurrentRead != nil)	[self endCurrentRead];
	if (theCurrentWrite != nil)	[self endCurrentWrite];
	[theReadQueue removeAllObjects];
	[theWriteQueue removeAllObjects];
	[NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(maybeDequeueRead) object:nil];
	[NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(maybeDequeueWrite) object:nil];
}


- (void)close
{
	
	[self emptyQueues];
	[partialReadBuffer release];
	partialReadBuffer = nil;
	[NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(disconnect) object:nil];
	
	
	if (theReadStream != NULL)
	{
		CFReadStreamSetClient(theReadStream, kCFStreamEventNone, NULL, NULL);
		CFReadStreamUnscheduleFromRunLoop (theReadStream, theRunLoop, kCFRunLoopDefaultMode);
		CFReadStreamClose (theReadStream);
		CFRelease (theReadStream);
		theReadStream = NULL;
	}
	if (theWriteStream != NULL)
	{
		CFWriteStreamSetClient(theWriteStream, kCFStreamEventNone, NULL, NULL);
		CFWriteStreamUnscheduleFromRunLoop (theWriteStream, theRunLoop, kCFRunLoopDefaultMode);
		CFWriteStreamClose (theWriteStream);
		CFRelease (theWriteStream);
		theWriteStream = NULL;
	}
	
	
	if (theSocket != NULL)
	{
		CFSocketInvalidate (theSocket);
		CFRelease (theSocket);
		theSocket = NULL;
	}
	if (theSocket6 != NULL)
	{
		CFSocketInvalidate (theSocket6);
		CFRelease (theSocket6);
		theSocket6 = NULL;
	}
	if (theSource != NULL)
	{
		CFRunLoopRemoveSource (theRunLoop, theSource, kCFRunLoopDefaultMode);
		CFRelease (theSource);
		theSource = NULL;
	}
	if (theSource6 != NULL)
	{
		CFRunLoopRemoveSource (theRunLoop, theSource6, kCFRunLoopDefaultMode);
		CFRelease (theSource6);
		theSource6 = NULL;
	}
	theRunLoop = NULL;
	
	
	
	if (theFlags & kMysrvPassConnectMethod)
	{
		
		if ([theDelegate respondsToSelector: @selector(onSocketMySrvDisconnect:)])
		{
			[theDelegate performSelector:@selector(onSocketMySrvDisconnect:) withObject:self afterDelay:0];
		}
	}
	
	
	theFlags = 0x00;
}

- (void)disconnect
{
	[self close];
}

- (void)disconnectAfterWriting
{
	theFlags |= kForbidReadsWrites;
	theFlags |= kDisconnectSoon;
	[self maybeScheduleDisconnect];
}

- (NSData *)unreadData
{
	
	if(!(theFlags & kClosingWithError)) return nil;
	
	if(theReadStream == NULL) return nil;
	
	CFIndex totalBytesRead = [partialReadBuffer length];
	BOOL error = NO;
	while(!error && CFReadStreamHasBytesAvailable(theReadStream))
	{
		[partialReadBuffer increaseLengthBy:READALL_CHUNKSIZE];
		
		
		CFIndex bytesToRead = [partialReadBuffer length] - totalBytesRead;
		
		
		UInt8 *packetbuf = (UInt8 *)( [partialReadBuffer mutableBytes] + totalBytesRead );
		CFIndex bytesRead = CFReadStreamRead(theReadStream, packetbuf, bytesToRead);
		
		
		if(bytesRead < 0)
		{
			error = YES;
		}
		else
		{
			totalBytesRead += bytesRead;
		}
	}
	
	[partialReadBuffer setLength:totalBytesRead];
	
	return partialReadBuffer;
}


#pragma mark Errors


- (NSError *)getErrnoError
{
	NSString *errorMsg = [NSString stringWithUTF8String:strerror(errno)];
	NSDictionary *userInfo = [NSDictionary dictionaryWithObject:errorMsg forKey:NSLocalizedDescriptionKey];
	
	return [NSError errorWithDomain:NSPOSIXErrorDomain code:errno userInfo:userInfo];
}

- (NSError *)getSocketError
{
	NSString *errMsg = NSLocalizedStringWithDefaultValue(@"AsyncSocketCFSocketError",
														 @"AsyncSocket", [NSBundle mainBundle],
														 @"General CFSocket error", nil);
	
	NSDictionary *info = [NSDictionary dictionaryWithObject:errMsg forKey:NSLocalizedDescriptionKey];
	
	return [NSError errorWithDomain:AsyncSocketErrorDomain code:AsyncSocketCFSocketError userInfo:info];
}

- (NSError *) getStreamError
{
	CFStreamError err;
	if (theReadStream != NULL)
	{
		err = CFReadStreamGetError (theReadStream);
		if (err.error != 0) return [self errorFromCFStreamError: err];
	}
	
	if (theWriteStream != NULL)
	{
		err = CFWriteStreamGetError (theWriteStream);
		if (err.error != 0) return [self errorFromCFStreamError: err];
	}
	
	return nil;
}

- (NSError *)getAbortError
{
	NSString *errMsg = NSLocalizedStringWithDefaultValue(@"AsyncSocketCanceledError",
														 @"AsyncSocket", [NSBundle mainBundle],
														 @"Connection canceled", nil);
	
	NSDictionary *info = [NSDictionary dictionaryWithObject:errMsg forKey:NSLocalizedDescriptionKey];
	
	return [NSError errorWithDomain:AsyncSocketErrorDomain code:AsyncSocketCanceledError userInfo:info];
}

- (NSError *)getReadMaxedOutError
{
	NSString *errMsg = NSLocalizedStringWithDefaultValue(@"AsyncSocketReadMaxedOutError",
														 @"AsyncSocket", [NSBundle mainBundle],
														 @"Read operation reached set maximum length", nil);
	
	NSDictionary *info = [NSDictionary dictionaryWithObject:errMsg forKey:NSLocalizedDescriptionKey];
	
	return [NSError errorWithDomain:AsyncSocketErrorDomain code:AsyncSocketReadMaxedOutError userInfo:info];
}

- (NSError *)getReadTimeoutError
{
	NSString *errMsg = NSLocalizedStringWithDefaultValue(@"AsyncSocketReadTimeoutError",
														 @"AsyncSocket", [NSBundle mainBundle],
														 @"Read operation timed out", nil);
	
	NSDictionary *info = [NSDictionary dictionaryWithObject:errMsg forKey:NSLocalizedDescriptionKey];
	
	return [NSError errorWithDomain:AsyncSocketErrorDomain code:AsyncSocketReadTimeoutError userInfo:info];
}

- (NSError *)getWriteTimeoutError
{
	NSString *errMsg = NSLocalizedStringWithDefaultValue(@"AsyncSocketWriteTimeoutError",
														 @"AsyncSocket", [NSBundle mainBundle],
														 @"Write operation timed out", nil);
	
	NSDictionary *info = [NSDictionary dictionaryWithObject:errMsg forKey:NSLocalizedDescriptionKey];
	
	return [NSError errorWithDomain:AsyncSocketErrorDomain code:AsyncSocketWriteTimeoutError userInfo:info];
}

- (NSError *)errorFromCFStreamError:(CFStreamError)err
{
	if (err.domain == 0 && err.error == 0) return nil;
	
	
	NSString *domain = @"CFStreamError (unlisted domain)";
	NSString *message = nil;
	
	if(err.domain == kCFStreamErrorDomainPOSIX) {
		domain = NSPOSIXErrorDomain;
	}
	else if(err.domain == kCFStreamErrorDomainMacOSStatus) {
		domain = NSOSStatusErrorDomain;
	}
	else if(err.domain == kCFStreamErrorDomainMach) {
		domain = NSMachErrorDomain;
	}
	else if(err.domain == kCFStreamErrorDomainNetDB)
	{
		domain = @"kCFStreamErrorDomainNetDB";
		message = [NSString stringWithCString:gai_strerror(err.error) encoding:NSASCIIStringEncoding];
	}
	else if(err.domain == kCFStreamErrorDomainNetServices) {
		domain = @"kCFStreamErrorDomainNetServices";
	}
	else if(err.domain == kCFStreamErrorDomainSOCKS) {
		domain = @"kCFStreamErrorDomainSOCKS";
	}
	else if(err.domain == kCFStreamErrorDomainSystemConfiguration) {
		domain = @"kCFStreamErrorDomainSystemConfiguration";
	}
	else if(err.domain == kCFStreamErrorDomainSSL) {
		domain = @"kCFStreamErrorDomainSSL";
	}
	
	NSDictionary *info = nil;
	if(message != nil)
	{
		info = [NSDictionary dictionaryWithObject:message forKey:NSLocalizedDescriptionKey];
	}
	return [NSError errorWithDomain:domain code:err.error userInfo:info];
}


#pragma mark Diagnostics


- (BOOL)isConnected
{
	return [self isSocketConnected] && [self areStreamsConnected];
}

- (NSString *)connectedHost
{
	if(theSocket)
		return [self connectedHost:theSocket];
	else
		return [self connectedHost:theSocket6];
}

- (UInt16)connectedPort
{
	if(theSocket)
		return [self connectedPort:theSocket];
	else
		return [self connectedPort:theSocket6];
}

- (NSString *)localHost
{
	if(theSocket)
		return [self localHost:theSocket];
	else
		return [self localHost:theSocket6];
}

- (UInt16)localPort
{
	if(theSocket)
		return [self localPort:theSocket];
	else
		return [self localPort:theSocket6];
}

- (NSString *)connectedHost:(CFSocketRef)socket
{
	if (socket == NULL) return nil;
	CFDataRef peeraddr;
	NSString *peerstr = nil;
	
	if(socket && (peeraddr = CFSocketCopyPeerAddress(socket)))
	{
		peerstr = [self addressHost:peeraddr];
		CFRelease (peeraddr);
	}
	
	return peerstr;
}

- (UInt16)connectedPort:(CFSocketRef)socket
{
	if (socket == NULL) return 0;
	CFDataRef peeraddr;
	UInt16 peerport = 0;
	
	if(socket && (peeraddr = CFSocketCopyPeerAddress(socket)))
	{
		peerport = [self addressPort:peeraddr];
		CFRelease (peeraddr);
	}
	
	return peerport;
}

- (NSString *)localHost:(CFSocketRef)socket
{
	if (socket == NULL) return nil;
	CFDataRef selfaddr;
	NSString *selfstr = nil;
	
	if(socket && (selfaddr = CFSocketCopyAddress(socket)))
	{
		selfstr = [self addressHost:selfaddr];
		CFRelease (selfaddr);
	}
	
	return selfstr;
}

- (UInt16)localPort:(CFSocketRef)socket
{
	if (socket == NULL) return 0;
	CFDataRef selfaddr;
	UInt16 selfport = 0;
	
	if (socket && (selfaddr = CFSocketCopyAddress(socket)))
	{
		selfport = [self addressPort:selfaddr];
		CFRelease (selfaddr);
	}
	
	return selfport;
}

- (BOOL)isSocketConnected
{
	if(theSocket != NULL)
		return CFSocketIsValid(theSocket);
	else if(theSocket6 != NULL)
		return CFSocketIsValid(theSocket6);
	else
		return NO;
}

- (BOOL)areStreamsConnected
{
	CFStreamStatus s;
	
	if (theReadStream != NULL)
	{
		s = CFReadStreamGetStatus (theReadStream);
		if ( !(s == kCFStreamStatusOpen || s == kCFStreamStatusReading || s == kCFStreamStatusError) )
			return NO;
	}
	else return NO;
	
	if (theWriteStream != NULL)
	{
		s = CFWriteStreamGetStatus (theWriteStream);
		if ( !(s == kCFStreamStatusOpen || s == kCFStreamStatusWriting || s == kCFStreamStatusError) )
			return NO;
	}
	else return NO;
	
	return YES;
}

- (NSString *)addressHost:(CFDataRef)cfaddr
{
	if (cfaddr == NULL) return nil;
	
	struct sockaddr *pSockAddr = (struct sockaddr *) CFDataGetBytePtr (cfaddr);
	char hbuf[NI_MAXHOST];
    char sbuf[NI_MAXSERV];
    // ホストアドレスを文字列に変換する。
    if (getnameinfo(pSockAddr, pSockAddr->sa_len, hbuf, sizeof(hbuf), sbuf, sizeof(sbuf), NI_NUMERICHOST | NI_NUMERICSERV) != 0) {
        
        [NSException raise: NSInternalInconsistencyException
                    format: @"Cannot convert address to string."];
        
    }
    
	return [NSString stringWithCString:hbuf encoding:NSASCIIStringEncoding];
}

- (UInt16)addressPort:(CFDataRef)cfaddr
{
	if (cfaddr == NULL) return 0;
    struct sockaddr_in6 *pAddr = (struct sockaddr_in6 *) CFDataGetBytePtr(cfaddr);
	return ntohs (pAddr->sin6_port);
}

- (BOOL)isIPv4
{
	return (theSocket != NULL);
}

- (BOOL)isIPv6
{
	return (theSocket6 != NULL);
}

- (NSString *)description
{
	static const char *statstr[] = { "not open", "opening", "open", "reading", "writing", "at end", "closed", "has error" };
	CFStreamStatus rs = (theReadStream != NULL) ? CFReadStreamGetStatus (theReadStream) : 0;
	CFStreamStatus ws = (theWriteStream != NULL) ? CFWriteStreamGetStatus (theWriteStream) : 0;
	NSString *peerstr, *selfstr;
	CFDataRef peeraddr = NULL, peeraddr6 = NULL, selfaddr = NULL, selfaddr6 = NULL;
	
	if (theSocket || theSocket6)
	{
		if (theSocket)  peeraddr  = CFSocketCopyPeerAddress(theSocket);
		if (theSocket6) peeraddr6 = CFSocketCopyPeerAddress(theSocket6);
		
		if(theSocket6 && theSocket)
		{
			peerstr = [NSString stringWithFormat: @"%@/%@ %u", [self addressHost:peeraddr], [self addressHost:peeraddr6], [self addressPort:peeraddr]];
		}
		else if(theSocket6)
		{
			peerstr = [NSString stringWithFormat: @"%@ %u", [self addressHost:peeraddr6], [self addressPort:peeraddr6]];
		}
		else
		{
			peerstr = [NSString stringWithFormat: @"%@ %u", [self addressHost:peeraddr], [self addressPort:peeraddr]];
		}
		
		if(peeraddr)  CFRelease(peeraddr);
		if(peeraddr6) CFRelease(peeraddr6);
		peeraddr = NULL;
		peeraddr6 = NULL;
	}
	else peerstr = @"nowhere";
	
	if (theSocket || theSocket6)
	{
		if (theSocket)  selfaddr  = CFSocketCopyAddress (theSocket);
		if (theSocket6) selfaddr6 = CFSocketCopyAddress (theSocket6);
		
		if (theSocket6 && theSocket)
		{
			selfstr = [NSString stringWithFormat: @"%@/%@ %u", [self addressHost:selfaddr], [self addressHost:selfaddr6], [self addressPort:selfaddr]];
		}
		else if (theSocket6)
		{
			selfstr = [NSString stringWithFormat: @"%@ %u", [self addressHost:selfaddr6], [self addressPort:selfaddr6]];
		}
		else
		{
			selfstr = [NSString stringWithFormat: @"%@ %u", [self addressHost:selfaddr], [self addressPort:selfaddr]];
		}
		
		if(selfaddr)  CFRelease(selfaddr);
		if(selfaddr6) CFRelease(selfaddr6);
		selfaddr = NULL;
		selfaddr6 = NULL;
	}
	else selfstr = @"nowhere";
	
	NSMutableString *ms = [[NSMutableString alloc] init];
	[ms appendString: [NSString stringWithFormat:@"<AsyncSocket %p", self]];
	[ms appendString: [NSString stringWithFormat:@" local %@ remote %@ ", selfstr, peerstr]];
	[ms appendString: [NSString stringWithFormat:@"has queued %d reads %d writes, ", [theReadQueue count], [theWriteQueue count] ]];
	
	if (theCurrentRead == nil)
		[ms appendString: @"no current read, "];
	else
	{
		int percentDone;
		if ([theCurrentRead->buffer length] != 0)
			percentDone = (float)theCurrentRead->bytesDone /
			(float)[theCurrentRead->buffer length] * 100.0;
		else
			percentDone = 100;
		
		[ms appendString: [NSString stringWithFormat:@"currently read %u bytes (%d%% done), ",
						   [theCurrentRead->buffer length],
						   theCurrentRead->bytesDone ? percentDone : 0]];
	}
	
	if (theCurrentWrite == nil)
		[ms appendString: @"no current write, "];
	else
	{
		int percentDone;
		if ([theCurrentWrite->buffer length] != 0)
			percentDone = (float)theCurrentWrite->bytesDone /
			(float)[theCurrentWrite->buffer length] * 100.0;
		else
			percentDone = 100;
		
		[ms appendString: [NSString stringWithFormat:@"currently written %u (%d%%), ",
						   [theCurrentWrite->buffer length],
						   theCurrentWrite->bytesDone ? percentDone : 0]];
	}
	
	[ms appendString: [NSString stringWithFormat:@"read stream %p %s, write stream %p %s", theReadStream, statstr [rs], theWriteStream, statstr [ws] ]];
	if (theFlags & kDisconnectSoon) [ms appendString: @", will disconnect soon"];
	if (![self isConnected]) [ms appendString: @", not connected"];
	
	[ms appendString: @">"];
	
	return [ms autorelease];
}


#pragma mark Reading


- (void)readDataToLength:(CFIndex)length withTimeout:(NSTimeInterval)timeout tag:(long)tag;
{
	if(length == 0) return;
	if(theFlags & kForbidReadsWrites) return;
	
	NSMutableData *buffer = [[NSMutableData alloc] initWithLength:length];
	AsyncReadPacket *packet = [[AsyncReadPacket alloc] initWithData:buffer
															timeout:timeout
																tag:tag
												   readAllAvailable:NO
														 terminator:nil
														  maxLength:length];
	
	[theReadQueue addObject:packet];
	[self scheduleDequeueRead];
	
	[packet release];
	[buffer release];
}

- (void)readDataToData:(NSData *)data withTimeout:(NSTimeInterval)timeout tag:(long)tag
{
	[self readDataToData:data withTimeout:timeout maxLength:-1 tag:tag];
}

- (void)readDataToData:(NSData *)data withTimeout:(NSTimeInterval)timeout maxLength:(CFIndex)length tag:(long)tag
{
	if(data == nil || [data length] == 0) return;
	if(length >= 0 && length < [data length]) return;
	if(theFlags & kForbidReadsWrites) return;
	
	NSMutableData *buffer = [[NSMutableData alloc] initWithLength:0];
	AsyncReadPacket *packet = [[AsyncReadPacket alloc] initWithData:buffer
															timeout:timeout
																tag:tag 
												   readAllAvailable:NO 
														 terminator:data
														  maxLength:length];
	
	[theReadQueue addObject:packet];
	[self scheduleDequeueRead];
	
	[packet release];
	[buffer release];
}

- (void)readDataWithTimeout:(NSTimeInterval)timeout tag:(long)tag
{
	if (theFlags & kForbidReadsWrites) return;
	
	NSMutableData *buffer = [[NSMutableData alloc] initWithLength:0];
	AsyncReadPacket *packet = [[AsyncReadPacket alloc] initWithData:buffer
															timeout:timeout
																tag:tag
												   readAllAvailable:YES
														 terminator:nil
														  maxLength:-1];
	
	[theReadQueue addObject:packet];
	[self scheduleDequeueRead];
	
	[packet release];
	[buffer release];
}

- (void)scheduleDequeueRead
{
	[self performSelector:@selector(maybeDequeueRead) withObject:nil afterDelay:0];
}

- (void)maybeDequeueRead
{
	
	
	if(theCurrentRead == nil && [theReadQueue count] != 0 && theReadStream != NULL)
	{
		
		AsyncReadPacket *newPacket = [theReadQueue objectAtIndex:0];
		theCurrentRead = [newPacket retain];
		[theReadQueue removeObjectAtIndex:0];
		
		
		if(theCurrentRead->timeout >= 0.0)
		{
			theReadTimer = [NSTimer scheduledTimerWithTimeInterval:theCurrentRead->timeout
															target:self 
														  selector:@selector(doReadTimeout:)
														  userInfo:nil
														   repeats:NO];
		}
		
		
		[self doBytesAvailable];
	}
}

- (BOOL)hasBytesAvailable
{
	return ([partialReadBuffer length] > 0) || CFReadStreamHasBytesAvailable(theReadStream);
}

- (CFIndex)readIntoBuffer:(UInt8 *)buffer maxLength:(CFIndex)length
{
	if([partialReadBuffer length] > 0)
	{
		
		CFIndex bytesToRead = MIN(length, [partialReadBuffer length]);
		
		
		memcpy(buffer, [partialReadBuffer bytes], bytesToRead);
		
		
		[partialReadBuffer replaceBytesInRange:NSMakeRange(0, bytesToRead) withBytes:NULL length:0];
		
		return bytesToRead;
	}
	else
	{
		return CFReadStreamRead(theReadStream, buffer, length);
	}
}

- (void)doBytesAvailable
{
	
	
	if(theCurrentRead != nil && theReadStream != NULL)
	{
#if 1
#define BUFFERSIZE (1024*1024) 
		NSMutableData *buffer = [[NSMutableData alloc] initWithLength:BUFFERSIZE]; 
		while ( theReadStream && CFReadStreamHasBytesAvailable(theReadStream) ){
			
			CFIndex readSize =  CFReadStreamRead( theReadStream, (UInt8*)[buffer bytes], BUFFERSIZE );
			if ( readSize > 0 ){
				if([theDelegate respondsToSelector:@selector(onSocket:mysrvReadData:withTag:)])
				{
					

					NSData *buffer_;
					if ( readSize == BUFFERSIZE ){
						
						buffer_ = buffer;
					}
					else{
						
						buffer_ = [[NSData alloc] initWithBytesNoCopy: (void*)[buffer bytes] length: readSize freeWhenDone:NO];
					}
					[theDelegate onSocket:self mysrvReadData: buffer_ withTag:theCurrentRead->tag];
					if ( readSize < BUFFERSIZE ){
						[buffer_ release];
					}
				}
			}
			else if ( readSize <= 0 )
			{
				break;
			}
		}
		[buffer release];
#else
		CFIndex totalBytesRead = 0;
		
		BOOL done = NO;
		BOOL socketError = NO;
		BOOL maxoutError = NO;
		
		while(!done && !socketError && !maxoutError && [self hasBytesAvailable])
		{
			BOOL mysrvPreBuffer = NO;
			
			
			if(theCurrentRead->readAllAvailableData == YES)
			{
				
				
				
				
				unsigned buffInc = READALL_CHUNKSIZE - ([theCurrentRead->buffer length] - theCurrentRead->bytesDone);
				[theCurrentRead->buffer increaseLengthBy:buffInc];
			}
			
			
			
			
			if(theCurrentRead->term != nil)
			{
				
				
				
				if(([partialReadBuffer length] > 0) || !(theFlags & kEnablePreBuffering))
				{
					unsigned maxToRead = [theCurrentRead readLengthForTerm];
					
					unsigned bufInc = maxToRead - ([theCurrentRead->buffer length] - theCurrentRead->bytesDone);
					[theCurrentRead->buffer increaseLengthBy:bufInc];
				}
				else
				{
					mysrvPreBuffer = YES;
					unsigned maxToRead = [theCurrentRead prebufferReadLengthForTerm];
					
					unsigned buffInc = maxToRead - ([theCurrentRead->buffer length] - theCurrentRead->bytesDone);
					[theCurrentRead->buffer increaseLengthBy:buffInc];
					
				}
			}
			
			
			CFIndex bytesToRead = [theCurrentRead->buffer length] - theCurrentRead->bytesDone;
			
			
			UInt8 *subBuffer = (UInt8 *)([theCurrentRead->buffer mutableBytes] + theCurrentRead->bytesDone);
			CFIndex bytesRead = [self readIntoBuffer:subBuffer maxLength:bytesToRead];
			
			
			if(bytesRead < 0)
			{
				socketError = YES;
			}
			else
			{
				
				theCurrentRead->bytesDone += bytesRead;
				
				
				totalBytesRead += bytesRead;
			}
			
			
			if(theCurrentRead->readAllAvailableData != YES)
			{
				if(theCurrentRead->term != nil)
				{
					if(mysrvPreBuffer)
					{
						
						CFIndex overflow = [theCurrentRead searchForTermAfterPreBuffering:bytesRead];
						
						if(overflow > 0)
						{
							
							NSMutableData *buffer = theCurrentRead->buffer;
							const void *overflowBuffer = [buffer bytes] + theCurrentRead->bytesDone - overflow;
							
							[partialReadBuffer appendBytes:overflowBuffer length:overflow];
							
							
							
							theCurrentRead->bytesDone -= overflow;
						}
						
						done = (overflow >= 0);
					}
					else
					{
						
						int termlen = [theCurrentRead->term length];
						if(theCurrentRead->bytesDone >= termlen)
						{
							const void *buf = [theCurrentRead->buffer bytes] + (theCurrentRead->bytesDone - termlen);
							const void *seq = [theCurrentRead->term bytes];
							done = (memcmp (buf, seq, termlen) == 0);
						}
					}
					
					if(!done && theCurrentRead->maxLength >= 0 && theCurrentRead->bytesDone >= theCurrentRead->maxLength)
					{
						
						maxoutError = YES;
					}
				}
				else
				{
					
					done = ([theCurrentRead->buffer length] == theCurrentRead->bytesDone);
				}
			}
			
		}
		
		if(theCurrentRead->readAllAvailableData && theCurrentRead->bytesDone > 0)
			done = YES;	
		
		if(done)
		{
			[self completeCurrentRead];
			if (!socketError) [self scheduleDequeueRead];
		}
		else if(theCurrentRead->bytesDone > 0)
		{
			
			if ([theDelegate respondsToSelector:@selector(onSocket:mysrvReadPartialDataOfLength:tag:)])
			{
				[theDelegate onSocket:self mysrvReadPartialDataOfLength:totalBytesRead tag:theCurrentRead->tag];
			}
		}
		
		if(socketError)
		{
			CFStreamError err = CFReadStreamGetError(theReadStream);
			[self closeWithError:[self errorFromCFStreamError:err]];
			return;
		}
		if(maxoutError)
		{
			[self closeWithError:[self getReadMaxedOutError]];
			return;
		}
#endif		
	}
}


- (void)completeCurrentRead
{
	NSAssert (theCurrentRead, @"Trying to complete current read when there is no current read.");
	
	[theCurrentRead->buffer setLength:theCurrentRead->bytesDone];
	if([theDelegate respondsToSelector:@selector(onSocket:mysrvReadData:withTag:)])
	{
		[theDelegate onSocket:self mysrvReadData:theCurrentRead->buffer withTag:theCurrentRead->tag];
	}
	
	if (theCurrentRead != nil) [self endCurrentRead]; 
}


- (void)endCurrentRead
{
	NSAssert (theCurrentRead, @"Trying to end current read when there is no current read.");
	
	[theReadTimer invalidate];
	theReadTimer = nil;
	
	[theCurrentRead release];
	theCurrentRead = nil;
}

- (void)doReadTimeout:(NSTimer *)timer
{
	if (timer != theReadTimer) return; 
	if (theCurrentRead != nil)
	{
		[self endCurrentRead];
	}
	[self closeWithError:[self getReadTimeoutError]];
}


#pragma mark Writing


- (void)writeData:(NSData *)data withTimeout:(NSTimeInterval)timeout tag:(long)tag;
{
	if (data == nil || [data length] == 0) return;
	if (theFlags & kForbidReadsWrites) return;
	
	AsyncWritePacket *packet = [[AsyncWritePacket alloc] initWithData:data timeout:timeout tag:tag];
	
	[theWriteQueue addObject:packet];
	[self scheduleDequeueWrite];
	
	[packet release];
}

- (void)scheduleDequeueWrite
{
	[self performSelector:@selector(maybeDequeueWrite) withObject:nil afterDelay:0];
}


- (void)maybeDequeueWrite
{
	if (theCurrentWrite == nil && [theWriteQueue count] != 0 && theWriteStream != NULL)
	{
		
		AsyncWritePacket *newPacket = [theWriteQueue objectAtIndex:0];
		theCurrentWrite = [newPacket retain];
		[theWriteQueue removeObjectAtIndex:0];
		
		
		if (theCurrentWrite->timeout >= 0.0)
		{
			theWriteTimer = [NSTimer scheduledTimerWithTimeInterval:theCurrentWrite->timeout
			                                                 target:self
			                                               selector:@selector(doWriteTimeout:)
			                                               userInfo:nil
			                                                repeats:NO];
		}
		
		
		[self doSendBytes];
	}
}

- (void)doSendBytes
{
	if (theCurrentWrite != nil && theWriteStream != NULL)
	{
		BOOL done = NO, error = NO;
		while (!done && !error && CFWriteStreamCanAcceptBytes (theWriteStream))
		{
			
			CFIndex bytesRemaining = [theCurrentWrite->buffer length] - theCurrentWrite->bytesDone;
			CFIndex bytesToWrite = (bytesRemaining < WRITE_CHUNKSIZE) ? bytesRemaining : WRITE_CHUNKSIZE;
			UInt8 *writestart = (UInt8 *)([theCurrentWrite->buffer bytes] + theCurrentWrite->bytesDone);
			
			
			CFIndex bytesWritten = CFWriteStreamWrite (theWriteStream, writestart, bytesToWrite);
			
			
			if (bytesWritten < 0)
			{
				bytesWritten = 0;
				error = YES;
			}
			
			
			theCurrentWrite->bytesDone += bytesWritten;
			done = ([theCurrentWrite->buffer length] == theCurrentWrite->bytesDone);
		}
		
		if(done)
		{
			[self completeCurrentWrite];
			if (!error) [self scheduleDequeueWrite];
		}
		
		if(error)
		{
			CFStreamError err = CFWriteStreamGetError (theWriteStream);
			[self closeWithError: [self errorFromCFStreamError:err]];
			return;
		}
	}
}


- (void)completeCurrentWrite
{
	NSAssert (theCurrentWrite, @"Trying to complete current write when there is no current write.");
	
	if ([theDelegate respondsToSelector:@selector(onSocket:mysrvWriteDataWithTag:)])
	{
		[theDelegate onSocket:self mysrvWriteDataWithTag:theCurrentWrite->tag];
	}
	
	if (theCurrentWrite != nil) [self endCurrentWrite]; 
}


- (void)endCurrentWrite
{
	NSAssert (theCurrentWrite, @"Trying to complete current write when there is no current write.");
	
	[theWriteTimer invalidate];
	theWriteTimer = nil;
	
	[theCurrentWrite release];
	theCurrentWrite = nil;
	
	[self maybeScheduleDisconnect];
}


- (void)maybeScheduleDisconnect
{
	if(theFlags & kDisconnectSoon)
	{
		if(([theWriteQueue count] == 0) && (theCurrentWrite == nil))
		{
			[self performSelector:@selector(disconnect) withObject:nil afterDelay:0];
		}
	}
}

- (void)doWriteTimeout:(NSTimer *)timer
{
	if (timer != theWriteTimer) return; 
	if (theCurrentWrite != nil)
	{
		[self endCurrentWrite];
	}
	[self closeWithError:[self getWriteTimeoutError]];
}


#pragma mark CF Callbacks


- (void)doCFSocketCallback:(CFSocketCallBackType)type
				 forSocket:(CFSocketRef)sock
			   withAddress:(NSData *)address
				  withData:(const void *)pData
{
	NSParameterAssert ((sock == theSocket) || (sock == theSocket6));
	
	switch (type)
	{
		case kCFSocketConnectCallBack:
			
			if(pData)
				[self doSocketOpen:sock withCFSocketError:kCFSocketError];
			else
				[self doSocketOpen:sock withCFSocketError:kCFSocketSuccess];
			break;
		case kCFSocketAcceptCallBack:
			[self doAcceptWithSocket: *((CFSocketNativeHandle *)pData)];
			break;
		default:
			NSLog (@"AsyncSocket %p received unexpected CFSocketCallBackType %d.", self, type);
			break;
	}
}

- (void)doCFReadStreamCallback:(CFStreamEventType)type forStream:(CFReadStreamRef)stream
{
	NSParameterAssert(theReadStream != NULL);
	
	CFStreamError err;
	switch (type)
	{
		case kCFStreamEventOpenCompleted:
			NSLog (@"doCFReadStreamCallback : kCFStreamEventOpenCompleted");
			[self doStreamOpen];
			break;
		case kCFStreamEventHasBytesAvailable:
			NSLog (@"doCFReadStreamCallback : kCFStreamEventHasBytesAvailable");
			[self doBytesAvailable];
			break;
		case kCFStreamEventEndEncountered:
			NSLog (@"doCFReadStreamCallback : kCFStreamEventEndEncountered");
		  if([theDelegate respondsToSelector:@selector(onReadStreamEnded:)]){
			  NSLog (@"doCFReadStreamCallback : kCFStreamEventEndEncountered 2");
			  if([theDelegate onReadStreamEnded:self] == NO) break;
		  }
		case kCFStreamEventErrorOccurred:
			NSLog (@"doCFReadStreamCallback : kCFStreamEventErrorOccurred");
			err = CFReadStreamGetError (theReadStream);
			[self closeWithError: [self errorFromCFStreamError:err]];
			break;
		default:
			NSLog (@"AsyncSocket %p received unexpected CFReadStream callback, CFStreamEventType %d.", self, type);
	}
}

- (void)doCFWriteStreamCallback:(CFStreamEventType)type forStream:(CFWriteStreamRef)stream
{
	NSParameterAssert(theWriteStream != NULL);
	
	CFStreamError err;
	switch (type)
	{
		case kCFStreamEventOpenCompleted:
			[self doStreamOpen];
			break;
		case kCFStreamEventCanAcceptBytes:
			[self doSendBytes];
			break;
		case kCFStreamEventErrorOccurred:
		case kCFStreamEventEndEncountered:
			err = CFWriteStreamGetError (theWriteStream);
			[self closeWithError: [self errorFromCFStreamError:err]];
			break;
		default:
			NSLog (@"AsyncSocket %p received unexpected CFWriteStream callback, CFStreamEventType %d.", self, type);
	}
}

static void MyCFSocketCallback (CFSocketRef sref, CFSocketCallBackType type, CFDataRef address, const void *pData, void *pInfo)
{
	NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
	
	AsyncSocket *socket = [[(AsyncSocket *)pInfo retain] autorelease];
	[socket doCFSocketCallback:type forSocket:sref withAddress:(NSData *)address withData:pData];
	
	[pool release];
}

static void MyCFReadStreamCallback (CFReadStreamRef stream, CFStreamEventType type, void *pInfo)
{
	NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
	
	AsyncSocket *socket = [[(AsyncSocket *)pInfo retain] autorelease];
	[socket doCFReadStreamCallback:type forStream:stream];
	
	[pool release];
}

static void MyCFWriteStreamCallback (CFWriteStreamRef stream, CFStreamEventType type, void *pInfo)
{
	NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
	
	AsyncSocket *socket = [[(AsyncSocket *)pInfo retain] autorelease];
	[socket doCFWriteStreamCallback:type forStream:stream];
	
	[pool release];
}


#pragma mark Class Methods



+ (NSData *)CRLFData
{
	return [NSData dataWithBytes:"\x0D\x0A" length:2];
}

+ (NSData *)CRData
{
	return [NSData dataWithBytes:"\x0D" length:1];
}

+ (NSData *)LFData
{
	return [NSData dataWithBytes:"\x0A" length:1];
}

+ (NSData *)ZeroData
{
	return [NSData dataWithBytes:"" length:1];
}

@end
