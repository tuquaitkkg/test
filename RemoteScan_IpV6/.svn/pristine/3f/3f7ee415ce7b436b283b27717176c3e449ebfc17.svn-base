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

#import "FtpDataConnection.h"
#import "FtpConnection.h"


@implementation FtpDataConnection

@synthesize receivedData;
@synthesize connectionState;


-(id)initWithAsyncSocket:(AsyncSocket*)newSocket forConnection:(id)aConnection withQueuedData:(NSMutableArray*)queuedData

{
	self = [super init ];
	if (self)
	{
		dataSocket = [newSocket retain ];						
		ftpConnection = aConnection;
	
		[ dataSocket setDelegate:self ];
		
		if ( [queuedData count ] )
		{
			NSLog(@"FC:Write Queued Data");
			[self writeQueuedData:queuedData ];
			[ queuedData removeAllObjects ];					
		}
		
		[ dataSocket readDataWithTimeout:READ_TIMEOUT tag:FTP_CLIENT_REQUEST ];
		dataListeningSocket	= nil;
		receivedData		= nil; 
		connectionState		= clientQuiet;						
	}
	return self;
}

-(void)dealloc

{
	[dataSocket release];
	[dataListeningSocket release];
	[dataConnection release];
	
	[super dealloc];
}

-(void)writeString:(NSString*)dataString

{
	NSLog(@"FDC:writeStringData");
	
	NSMutableData *data = [[ dataString dataUsingEncoding:NSUTF8StringEncoding ] mutableCopy];				
	[ data appendData:[AsyncSocket CRLFData] ];										
	
	[ dataSocket writeData:data withTimeout:READ_TIMEOUT tag:FTP_CLIENT_REQUEST ];		
	[ dataSocket readDataWithTimeout:READ_TIMEOUT tag:FTP_CLIENT_REQUEST ];
	[data release];
}


-(void)writeData:(NSMutableData*)data

{
	NSLog(@"FDC:writeData");

	connectionState = clientReceiving;														
	
	[ dataSocket writeData:data withTimeout:READ_TIMEOUT tag:FTP_CLIENT_REQUEST ];	
	
	[ dataSocket readDataWithTimeout:READ_TIMEOUT tag:FTP_CLIENT_REQUEST ];
}

-(void)writeQueuedData:(NSMutableArray*)queuedData

{
	for (NSMutableData* data in queuedData)
	{
		[self writeData:data ];
	}
}


-(void)closeConnection

{
	NSLog(@"FDC:closeConnection");
	[ dataSocket disconnect  ];

}
#pragma mark ASYNCSOCKET DELEGATES

-(BOOL)onSocketWillConnect:(AsyncSocket *)sock 

{

	NSLog(@"FDC:onSocketWillConnect");
	[ dataSocket readDataWithTimeout:READ_TIMEOUT tag:0 ];
	return YES;
}


-(void)onSocket:(AsyncSocket *)sock mysrvAcceptNewSocket:(AsyncSocket *)newSocket

{
	NSLog(@"FDC:New Connection -- shouldn't be called");

}




-(void)onSocket:(AsyncSocket*)sock mysrvReadData:(NSData*)data withTag:(long)tag

{	
	NSLog(@"FDC:mysrvReadData");

	[ dataSocket readDataWithTimeout:READ_TIMEOUT tag:FTP_CLIENT_REQUEST ];	
	
	receivedData = [NSMutableData dataWithData:[ data retain]];
	
	[ftpConnection mysrvReceiveDataRead ];
	connectionState = clientSent;
}



-(void)onSocket:(AsyncSocket*)sock mysrvWriteDataWithTag:(long)tag

{
	NSLog(@"FDC:mysrvWriteData");
	[ ftpConnection mysrvReceiveDataWritten ];				

	[ dataSocket readDataWithTimeout:READ_TIMEOUT tag:FTP_CLIENT_REQUEST ];
}


-(void)onSocket:(AsyncSocket *)sock willDisconnectWithError:(NSError *)err

{
	NSLog(@"FDC:willDisconnect");

	if ( connectionState == clientSending )
	{
		NSLog(@"FDC::mysrv FinishReading");
		
	}
	else
	{
		NSLog(@"FDC: we werent expecting this as we never set clientSending  prob late coming up");
	}

	[ ftpConnection mysrvFinishReading ];																				
}

- (BOOL)onReadStreamEnded:(AsyncSocket*)sock
{
	NSLog( @"FDC: onReadStreamEnded %d(clientSending is %d)", connectionState, clientSending );

	if ( connectionState == clientSent || connectionState == clientSending )
	{
		NSLog( @"FDC: onReadStreamEnded YES");
		return YES;
	}
	
	NSLog( @"FDC: onReadStreamEnded NO");
	return NO;
}

@end
