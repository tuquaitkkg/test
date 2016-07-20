//
//  AsyncSocket.h
//
//  This class is in the public domain.
//  Originally created by Dustin Voss on Wed Jan 29 2003.
//  Updated and maintained by Deusty Designs and the Mac development community.
//
//  http://code.google.com/p/cocoaasyncsocket/
//

#import <Foundation/Foundation.h>

@class AsyncSocket;
@class AsyncReadPacket;
@class AsyncWritePacket;

extern NSString *const AsyncSocketException;
extern NSString *const AsyncSocketErrorDomain;

enum AsyncSocketError
{
	AsyncSocketCFSocketError = kCFSocketError,	
	AsyncSocketNoError = 0,						
	AsyncSocketCanceledError,					
	AsyncSocketReadMaxedOutError,               
	AsyncSocketReadTimeoutError,
	AsyncSocketWriteTimeoutError
};
typedef enum AsyncSocketError AsyncSocketError;

@interface NSObject (AsyncSocketDelegate)

- (void)onSocket:(AsyncSocket *)sock willDisconnectWithError:(NSError *)err;

- (void)onSocketMySrvDisconnect:(AsyncSocket *)sock;

- (void)onSocket:(AsyncSocket *)sock mysrvAcceptNewSocket:(AsyncSocket *)newSocket;

- (NSRunLoop *)onSocket:(AsyncSocket *)sock wantsRunLoopForNewSocket:(AsyncSocket *)newSocket;

- (BOOL)onSocketWillConnect:(AsyncSocket *)sock;

- (BOOL)onReadStreamEnded:(AsyncSocket *)sock;

- (void)onSocket:(AsyncSocket *)sock mysrvConnectToHost:(NSString *)host port:(UInt16)port;

- (void)onSocket:(AsyncSocket *)sock mysrvReadData:(NSData *)data withTag:(long)tag;

- (void)onSocket:(AsyncSocket *)sock mysrvReadPartialDataOfLength:(CFIndex)partialLength tag:(long)tag;

- (void)onSocket:(AsyncSocket *)sock mysrvWriteDataWithTag:(long)tag;

@end

@interface AsyncSocket : NSObject
{
	CFSocketRef theSocket;             
	CFSocketRef theSocket6;            
	CFReadStreamRef theReadStream;
	CFWriteStreamRef theWriteStream;
	
	CFRunLoopSourceRef theSource;      
	CFRunLoopSourceRef theSource6;     
	CFRunLoopRef theRunLoop;
	CFSocketContext theContext;
	
	NSMutableArray *theReadQueue;
	AsyncReadPacket *theCurrentRead;
	NSTimer *theReadTimer;
	NSMutableData *partialReadBuffer;
	
	NSMutableArray *theWriteQueue;
	AsyncWritePacket *theCurrentWrite;
	NSTimer *theWriteTimer;
	
	id theDelegate;
	Byte theFlags;
	
	long theUserData;
}

- (id)init;
- (id)initWithDelegate:(id)delegate;
- (id)initWithDelegate:(id)delegate userData:(long)userData;

- (NSString *)description;

- (id)delegate;
- (BOOL)canSafelySetDelegate;
- (void)setDelegate:(id)delegate;

- (long)userData;
- (void)setUserData:(long)userData;

- (CFSocketRef)getCFSocket;
- (CFReadStreamRef)getCFReadStream;
- (CFWriteStreamRef)getCFWriteStream;

- (BOOL)acceptOnPort:(UInt16)port error:(NSError **)errPtr;
- (BOOL)acceptOnAddress:(NSString *)hostaddr port:(UInt16)port error:(NSError **)errPtr;
- (BOOL)connectToHost:(NSString *)hostname onPort:(UInt16)port error:(NSError **)errPtr;
- (BOOL)connectToAddress:(NSData *)remoteAddr error:(NSError **)errPtr;

- (void)disconnect;

- (void)disconnectAfterWriting;

- (BOOL)isConnected;

- (NSString *)connectedHost;
- (UInt16)connectedPort;

- (NSString *)localHost;
- (UInt16)localPort;

- (BOOL)isIPv4;
- (BOOL)isIPv6;

- (void)readDataToLength:(CFIndex)length withTimeout:(NSTimeInterval)timeout tag:(long)tag;

- (void)readDataToData:(NSData *)data withTimeout:(NSTimeInterval)timeout tag:(long)tag;

- (void)readDataToData:(NSData *)data withTimeout:(NSTimeInterval)timeout maxLength:(CFIndex)length tag:(long)tag;

- (void)readDataWithTimeout:(NSTimeInterval)timeout tag:(long)tag;

- (void)writeData:(NSData *)data withTimeout:(NSTimeInterval)timeout tag:(long)tag;

- (float)progressOfReadReturningTag:(long *)tag bytesDone:(CFIndex *)done total:(CFIndex *)total;
- (float)progressOfWriteReturningTag:(long *)tag bytesDone:(CFIndex *)done total:(CFIndex *)total;

- (void)enablePreBuffering;

- (NSData *)unreadData;

+ (NSData *)CRLFData;   // 0x0D0A
+ (NSData *)CRData;     // 0x0D
+ (NSData *)LFData;     // 0x0A
+ (NSData *)ZeroData;   // 0x00

@end
