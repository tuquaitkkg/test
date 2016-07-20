/*
 DiddyFtpServer
 Copyright (C) 2008  Richard Dearlove ( Diddy )
 
 This library is free software; you can redistribute it and/or
 modify it under the terms of the GNU Lesser General Public
 License as published by the Free Software Foundation; either
 version 2.1 of the License, or (at your option) any later version.
 
 This library is distributed in the hope that it will be useful,
 but WITHOUT ANY WARRANTY; without even the implied warranty of
 MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
 Lesser General Public License for more details.
 
 You should have received a copy of the GNU Lesser General Public
 License along with this library; if not, write to the Free Software
 Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA  02110-1301  USA
 */

#import "DiddyFtpServer.h"

@implementation DiddyFtpServer

@synthesize listenSocket, connectedSockets, server, notificationObject, portNumber, delegate, commands, baseDir, connections;

@synthesize clientEncoding;
@synthesize changeRoot;
@synthesize userName;
@synthesize userPass;

- (id)initWithPort:(unsigned)serverPort withDir:(NSString *)aDirectory notifyObject:(id)sender requsername:(NSString*)aUserName requserpass:(NSString*)aUserPass encoding:(NSStringEncoding)encoding
{
	NSAutoreleasePool *pool			= [[NSAutoreleasePool alloc] init];
	
    if( self = [super init] )
	{
		
		NSError *error = nil;
		
		self.notificationObject = sender;
		
		NSString *plistPath = [[ NSBundle mainBundle ] pathForResource:@"ftp_commands" ofType:@"plist"];
		if ( ! [ [ NSFileManager defaultManager ] fileExistsAtPath:plistPath ] )
		{
			NSLog(@"ftp_commands.plist missing");
		}
		commands = [ [ NSDictionary alloc ] initWithContentsOfFile:plistPath];
		
		NSMutableArray *myConnections = [[NSMutableArray alloc] init];
		self.connections = myConnections;
		[myConnections release];
		
	    self.userName	= aUserName;
		self.userPass	= aUserPass;
        self.portNumber	= serverPort;
		NSLog(@"***** ftp initWithPort:user[%@]pass[%@]portNumber[%d] *****", aUserName, aUserPass, serverPort);
		
		AsyncSocket *myListenSocket = [[AsyncSocket alloc] initWithDelegate:self];
		self.listenSocket = myListenSocket;
		[myListenSocket release];
		
		NSLog(@"Listening on %u", portNumber);
		[listenSocket acceptOnPort:serverPort error:&error];
		
		NSMutableArray *myConnectedSockets = [[NSMutableArray alloc] initWithCapacity:1];
		self.connectedSockets = myConnectedSockets;
		[myConnectedSockets release];
		
		
		//		NSFileManager	*fileManager  = [ NSFileManager defaultManager ];
		//		NSString		*expandedPath = [ aDirectory stringByStandardizingPath ];
		
		
		//		if ([ fileManager changeCurrentDirectoryPath:expandedPath ])
		//		{
		//			self.baseDir = [[ fileManager currentDirectoryPath ] copy] ;
		//		}
		//		else
		//		{
		self.baseDir =  aDirectory;
		//		}
		
		self.changeRoot = false;
		
		
		self.clientEncoding = encoding;
    }
	[pool drain];
    return self;
}

- (id)initWithPort:(unsigned)serverPort withDir:(NSString*)aDirectory notifyObject:(id)sender requsername:(NSString*)aUserName requserpass:(NSString*)aUserPass

{
	return [self initWithPort:serverPort withDir:aDirectory notifyObject:sender requsername:aUserName requserpass:aUserPass encoding:NSShiftJISStringEncoding];
}

-(void)stopFtpServer

{
	if(listenSocket)[listenSocket disconnect];
	[connectedSockets removeAllObjects];
	[connections removeAllObjects];
	
}
#pragma mark ASYNCSOCKET DELEGATES

- (void)onSocket:(AsyncSocket *)sock mysrvAcceptNewSocket:(AsyncSocket *)newSocket

{
	
	FtpConnection *newConnection = [[[ FtpConnection alloc ] initWithAsyncSocket:newSocket forServer:self] autorelease];			
	[ connections addObject:newConnection ];			
	
	NSLog(@"FS:mysrvAcceptNewSocket  port:%i", [sock localPort]);
	
	if ([sock localPort] == portNumber )
	{
		NSLog(@"Connection on Server Port");
		
	}
	else
	{
		NSLog(@"--ERROR %i, %i", [sock localPort],portNumber);

	}
}


- (void)onSocket:(AsyncSocket *)sock mysrvConnectToHost:(NSString *)host port:(UInt16)port

{
	NSLog(@"FtpServer:mysrvConnectToHost  port:%i", [sock localPort]);
}

#pragma mark NOTIFICATIONS

-(void)mysrvReceiveFileListChanged

{
	if ([notificationObject respondsToSelector:@selector(mysrvReceiveFileListChanged)]) 
	{
		[notificationObject mysrvReceiveFileListChanged ];
	}
	
}

-(void)callTestMethod:(NSMutableDictionary *)aDictionary

{
	[ notificationObject reqresInfomationPost:aDictionary ];
}
#pragma mark CONNECTIONS

- (void)closeConnection:(id)theConnection

{
	[connections removeObject:theConnection ];
	
}


-(NSString*)createList:(NSString*)directoryPath

{ 
	return createList(directoryPath);
	
}


- (void)dealloc

{   
	NSLog(@"FtpServer - dealloc");
	if(listenSocket)
	{
		[listenSocket disconnect];
		[listenSocket release];
	}
	
	[connectedSockets	release];
	[notificationObject release];
	[connections	release];
	[commands		release];
	[baseDir		release];
	[userName		release];
	[userPass		release];
	[super dealloc];
	
}


@end
