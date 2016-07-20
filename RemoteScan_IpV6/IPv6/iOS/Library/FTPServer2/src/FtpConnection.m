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

//********************************************************************************
//* FTP Command Wroking Routine's
//********************************************************************************
#import "FtpConnection.h"
#import "DiddyFtpServer.h"


@implementation FtpConnection

@synthesize transferMode;
@synthesize currentFile;	
@synthesize currentDir;
@synthesize rnfrFilename;
//@synthesize myDictionary;


-(id)initWithAsyncSocket:(AsyncSocket*)newSocket forServer:(id)myServer 

{
	self = [super init ];
	if (self)
	{
		connectionSocket = [newSocket retain ];
		server = myServer;
		[connectionSocket setDelegate:self ];
		[connectionSocket writeData:DATASTR(@"220 MyFTP server ready.\r\n") withTimeout:-1 tag:0 ];					
		[connectionSocket readDataToData:[AsyncSocket CRLFData] withTimeout:READ_TIMEOUT tag:FTP_CLIENT_REQUEST ];		
		dataListeningSocket = nil;
		dataPort=2001;
		transferMode = pasvftp;
		queuedData = [[ NSMutableArray alloc ] init ];								
		self.currentDir = [ server.baseDir copy];												
		currentFile = nil;	
		currentFileHandle = nil;													
		rnfrFilename = nil; 
		currentUser = nil;
//		self.myDictionary = [[NSMutableDictionary alloc]init];
		NSLog(@"FC: Current Directory starting at %@",currentDir );
	}
	return self;
}

-(void)dealloc

{
	if(connectionSocket)
	{
		[connectionSocket setDelegate:nil];
		[connectionSocket disconnect];
		[connectionSocket release];
	}
	
	if(dataListeningSocket){														
		[dataListeningSocket setDelegate:nil];
		[dataListeningSocket disconnect];
		[dataListeningSocket release];
		
	}
	if(dataSocket)
	{
		[dataSocket setDelegate:nil];
		[dataSocket disconnect];
		[dataSocket release];
		
	}
	if(dataConnection)[dataConnection release];
	
	if(queuedData)[queuedData release];
	if(currentFile)[currentFile release];
	if(currentUser)[currentUser release];
	[currentDir release];
	if(currentFileHandle) [currentFileHandle release];
//	if(myDictionary) [myDictionary release];
		
	[super dealloc];
}
#pragma mark STATE 

-(NSString*)connectionAddress

{
	return [connectionSocket connectedHost];
	
}

#pragma mark CHOOSE DATA SOCKET 

-(BOOL)openDataSocket:(int)portNumber

{
	NSString *responseString = nil;
	NSError	 *error			 = nil;		
	NSString *responseNumber = nil;	
	
	if (dataSocket)																			
	{ 
		[dataSocket release]; 
		dataSocket = nil; 
	} 
	dataSocket = [ [ AsyncSocket alloc ] initWithDelegate:self ];                           
	if (dataConnection) 
	{ 
		[dataConnection release]; 
		dataConnection = nil; 
	} 

	switch (transferMode) {
		case portftp:
			dataPort = portNumber;
			responseString = [ NSString stringWithFormat:@"200 PORT command successful."];
			[ dataSocket connectToHost:[self connectionAddress] onPort:portNumber error:&error ];
			
			dataConnection = [[ FtpDataConnection alloc ] initWithAsyncSocket:dataSocket forConnection:self withQueuedData:queuedData ];	
			responseNumber = [ NSString stringWithFormat:@"200"];
			break;
			
		case lprtftp:					
			dataPort = portNumber;
			responseString = [ NSString stringWithFormat:@"228 Entering Long Passive Mode 	(af, hal, h1, h2, h3,..., pal, p1, p2...)", dataPort >>8, dataPort & 0xff];
			[ dataSocket connectToHost:[self connectionAddress] onPort:portNumber error:&error ];
			dataConnection = [[ FtpDataConnection alloc ] initWithAsyncSocket:dataSocket forConnection:self withQueuedData:queuedData ];	
			responseNumber = [ NSString stringWithFormat:@"228"];
			break;
			
		case eprtftp:
			dataPort = portNumber;
			responseString = @"200 EPRT command successful.";
			[ dataSocket connectToHost:[self connectionAddress] onPort:portNumber error:&error ];
			dataConnection = [[ FtpDataConnection alloc ] initWithAsyncSocket:dataSocket forConnection:self withQueuedData:queuedData ];	
			responseNumber = [ NSString stringWithFormat:@"200"];
			break;
			
		case pasvftp:
			dataPort = [ self choosePasvDataPort ];
			NSString *address = [ [connectionSocket localHost ] stringByReplacingOccurrencesOfString:@"." withString:@"," ]; 
			responseString = [ NSString stringWithFormat:@"227 Entering Passive Mode (%@,%d,%d)",address, dataPort >>8, dataPort & 0xff];				
			[ dataSocket acceptOnPort: dataPort error:&error  ];
			dataConnection = nil;  
			responseNumber = [ NSString stringWithFormat:@"227"];
			break;
			
		case epsvftp:
			dataPort = [ self choosePasvDataPort ];
			responseString = [ NSString stringWithFormat:@"229 Entering Extended Passive Mode (|||%d|)", dataPort ];				
			[ dataSocket acceptOnPort: dataPort error:&error  ];
			
			dataConnection = nil;  
			responseNumber = [ NSString stringWithFormat:@"229"];
			break;
			
			
		default:
			break;
	}
	NSLog( @"-- %@", [ error localizedDescription ] );
	
	[ self sendMessage:responseString ];
	
	NSMutableDictionary *myDictionary = [[NSMutableDictionary alloc]init ];
	[ myDictionary	setObject:@"Response"		forKey:@"DATAINFO" ];
	[ myDictionary	setObject:responseNumber	forKey:@"POSTDATA" ];
	[ server		callTestMethod:myDictionary];
	[ myDictionary	removeAllObjects]; // del
	[ myDictionary	release ];
	
	return YES;
}

-(int)choosePasvDataPort

{
	struct timeval tv;
    unsigned short int seed[3];
	
    gettimeofday(&tv, NULL);
    seed[0] = (tv.tv_sec >> 16) & 0xFFFF;
    seed[1] = tv.tv_sec & 0xFFFF;
    seed[2] = tv.tv_usec & 0xFFFF;
    seed48(seed);
	
	int portNumber;
	portNumber = (lrand48() % 64512) + 1024;
		
	return portNumber;																
	
}

#pragma mark ASYNCSOCKET DATACONNECTION 

-(BOOL)onSocketWillConnect:(AsyncSocket *)sock 

{
	NSLog(@"FC:onSocketWillConnect");
	[ sock readDataWithTimeout:READ_TIMEOUT tag:0 ];

	return YES;
}


-(void)onSocket:(AsyncSocket *)sock mysrvAcceptNewSocket:(AsyncSocket *)newSocket		

{
	NSLog(@"FC:New Connection -- should be for the data port");
	
	dataConnection = [[ FtpDataConnection alloc ] initWithAsyncSocket:newSocket forConnection:self  withQueuedData:queuedData];	
}


#pragma mark ASYNCSOCKET FTPCLIENT CONNECTION 

-(void)onSocket:(AsyncSocket*)sock mysrvReadData:(NSData*)data withTag:(long)tag			

{
	NSLog(@"FC:mysrvReadData");
	
	[ connectionSocket readDataToData:[AsyncSocket CRLFData] withTimeout:READ_TIMEOUT tag:FTP_CLIENT_REQUEST ];		
	[ self processDataRead:data ];

}

-(void)onSocket:(AsyncSocket*)sock mysrvWriteDataWithTag:(long)tag						

{
	[ connectionSocket readDataToData:[AsyncSocket CRLFData] withTimeout:READ_TIMEOUT tag:FTP_CLIENT_REQUEST ];	
}

-(void)sendMessage:(NSString*)ftpMessage				

{
	NSLog(@">%@",ftpMessage );

	NSMutableData *dataString = [[ ftpMessage dataUsingEncoding:NSUTF8StringEncoding ] mutableCopy];				
	[ dataString appendData:[AsyncSocket CRLFData] ];												
	[ connectionSocket writeData:dataString withTimeout:READ_TIMEOUT tag:FTP_CLIENT_REQUEST ];
	[dataString release];
	[ connectionSocket readDataToData:[AsyncSocket CRLFData] withTimeout:READ_TIMEOUT tag:FTP_CLIENT_REQUEST ];	
	
}

-(void)sendDataString:(NSString*)dataString

{
	NSMutableString *message = [[NSMutableString alloc] initWithString:dataString];
	CFStringNormalize((CFMutableStringRef)message, kCFStringNormalizationFormC);
	NSMutableData *data = [[ message dataUsingEncoding:server.clientEncoding ] mutableCopy];				
	[message release];

	if (dataConnection )
	{
		NSLog(@"FC:sendData");
		[ dataConnection writeData:data ];
		
	}
	else
	{
		[ queuedData addObject:data ];
	}
	[data release];
	
}

-(void)sendData:(NSMutableData*)data

{
	if (dataConnection )
	{
		NSLog(@"FC:sendData");
		[ dataConnection writeData:data ];
	}
	else
	{
		[ queuedData addObject:data ];
	}
	
}

-(void)mysrvReceiveDataWritten			

{
	NSLog(@"SENDING COMPLETED");
	
	[ self sendMessage:@"226 Transfer complete." ];
	[ dataConnection closeConnection ];

	NSMutableDictionary *myDictionary = [[NSMutableDictionary alloc]init ];
	[ myDictionary	setObject:@"Response"	forKey:@"DATAINFO" ];
	[ myDictionary	setObject:@"226"		forKey:@"POSTDATA" ];
	[ server		callTestMethod:myDictionary];
	[ myDictionary	removeAllObjects]; // del
	[ myDictionary	release ];
}


-(void)mysrvReceiveDataRead			

{
	NSLog(@"FC:mysrvReceiveDataRead");
	
	if ( currentFileHandle != nil )
	{
//		NSLog(@"**++ FC:Writing File to %@", currentFile );
		NSLog(@"**++ FC:Writing File" );
		[ currentFileHandle writeData:dataConnection.receivedData ];
	}
	else
	{
		NSLog(@"Couldnt write data");
	}
	
}

-(void)mysrvFinishReading							

{
	if (currentFile)
	{
		NSLog(@"Closing File Handle");
		[currentFile release];
		currentFile = nil;
	}
	else
	{
		NSLog(@"FC:Data Sent but not sure where its for ");
	}
	
	[ self sendMessage:@"226 Transfer complete." ];
	
	NSMutableDictionary *myDictionary = [[NSMutableDictionary alloc]init ];
	[ myDictionary	setObject:@"Response"	forKey:@"DATAINFO" ];
	[ myDictionary	setObject:@"226"		forKey:@"POSTDATA" ];
	[ server		callTestMethod:myDictionary ];
	[ myDictionary	removeAllObjects]; // del
	[ myDictionary	release ];
	
	if ( currentFileHandle != nil )
	{
		NSLog(@"Closing File Handle");
		
		[ currentFileHandle closeFile ];								
		[ currentFileHandle release ];
		currentFileHandle = nil;
		[ server mysrvReceiveFileListChanged];
	}
	
	dataConnection.connectionState = clientQuiet;
}


#pragma mark PROCESS 

-(void)processDataRead:(NSData*)data			

{	
	NSData	 *strData	  = [data subdataWithRange:NSMakeRange(0, [data length] - 2)];				
	NSString *crlfmessage = [[[NSString alloc] initWithData:strData encoding:server.clientEncoding] autorelease];
	NSString *message;
	
    message = [ crlfmessage stringByTrimmingCharactersInSet:[NSCharacterSet newlineCharacterSet ]];
    NSLog(@"<%@",message );
    msgComponents = [message componentsSeparatedByString:@" "];
    
    [ self processCommand ];
    
    if (![@"QUIT"isEqualToString:message])
    {
        [connectionSocket readDataToData:[AsyncSocket CRLFData] withTimeout:-1 tag:0 ];
    }
}


-(void)processCommand 

{
	NSString *commandString =  [ msgComponents objectAtIndex:0];
	
	if ([ commandString length ] > 0)																
	{
		NSString *commandSelector = [ [[server commands] objectForKey:[commandString lowercaseString] ] stringByAppendingString:@"arguments:"];
		
		if ( commandSelector )																		
		{
			SEL action = NSSelectorFromString(commandSelector);										
			
			if ( [ self respondsToSelector:action ])												
			{
				[self performSelector:action withObject:self withObject:msgComponents ];			
			}
			else
			{			
				NSString *outputString =[ NSString stringWithFormat:@"500 '%@': command not understood.", commandString ];
				[ self sendMessage:outputString ];
				
				NSMutableDictionary *myDictionary = [[NSMutableDictionary alloc]init];
				[ myDictionary	setObject:@"Response"	forKey:@"DATAINFO" ];
				[ myDictionary	setObject:@"500"		forKey:@"POSTDATA" ];
				[ server		callTestMethod:myDictionary ];
				[ myDictionary	removeAllObjects]; // del
				[ myDictionary	release ];
				
				NSLog(@"DONT UNDERSTAND");
			}
		}
		else			
		{
			NSString *outputString =[ NSString stringWithFormat:@"500 '%@': command not understood.", commandString ];
			[ self sendMessage:outputString ];
			
			NSMutableDictionary *myDictionary = [[NSMutableDictionary alloc]init ];
			[ myDictionary	setObject:@"Response"	forKey:@"DATAINFO" ];
			[ myDictionary	setObject:@"500"		forKey:@"POSTDATA" ];
			[ server		callTestMethod:myDictionary ];
			[ myDictionary	removeAllObjects]; // del
			[ myDictionary	release ];
		}
	}
	else
	{
		
	}
	
}


#pragma mark COMMANDS 

-(void)doQuit:(id)sender arguments:(NSArray*)arguments

{
	NSLog(@"Quit : %@",arguments);
	
	NSMutableDictionary *myDictionary = [[NSMutableDictionary alloc]init ];	
	[ myDictionary	setObject:@"Request"	forKey:@"DATAINFO" ];
	[ myDictionary	setObject:@"QUIT"		forKey:@"POSTDATA" ];										 
	[ server		callTestMethod: myDictionary];
	[ myDictionary	removeAllObjects]; // del

	[ self sendMessage:@"221- Data traffic for this session was 0 bytes in 0 files"];	
	[ self sendMessage:@"221 Thank you for using the FTP service on localhost." ];
	
	if(connectionSocket)
	{
		[connectionSocket disconnectAfterWriting ];				
	}
	
	[ myDictionary	setObject:@"Response"	forKey:@"DATAINFO" ];
	[ myDictionary	setObject:@"221"		forKey:@"POSTDATA" ];
	[ server		callTestMethod:myDictionary ];
	[ myDictionary	removeAllObjects]; // del
	[ myDictionary	release ];

	[ server closeConnection:self ];			
}

-(void)doUser:(id)sender arguments:(NSArray*)arguments

{
	
	NSMutableDictionary *myDictionary = [[NSMutableDictionary alloc]init ];
	[ myDictionary	setObject:@"Request"	forKey:@"DATAINFO" ];
	[ myDictionary	setObject:@"USER"		forKey:@"POSTDATA" ];
	[ server		callTestMethod:myDictionary ];
	[ myDictionary	removeAllObjects]; // del
	
	NSString *user =  [ arguments objectAtIndex:1 ];
	if ( [user isEqualToString:server.userName] ) {
		NSString *outputString = [ NSString stringWithFormat:@"331 Password required for %@", user ];
		[ sender sendMessage:outputString];
		
		[ myDictionary	removeAllObjects ];
		[ myDictionary	setObject:@"Response"	forKey:@"DATAINFO" ];
		[ myDictionary	setObject:@"331"		forKey:@"POSTDATA" ];
		[ server		callTestMethod:myDictionary ];
		[ myDictionary	removeAllObjects]; // del
	}
	else {
		NSString *outputString = [ NSString stringWithFormat:@"530 Not Logged in required for %@", user ];
		[ sender sendMessage:outputString];

		[ myDictionary	setObject:@"Response"	forKey:@"DATAINFO" ];
		[ myDictionary	setObject:@"530"		forKey:@"POSTDATA" ];
		[ server		callTestMethod:myDictionary ];
		[ myDictionary	removeAllObjects]; // del
	}
	[ myDictionary	release ];
}

-(void)doPass:(id)sender arguments:(NSArray*)arguments

{
	NSMutableDictionary *myDictionary = [[NSMutableDictionary alloc]init ];
	[ myDictionary	setObject:@"Request"	forKey:@"DATAINFO" ];
	[ myDictionary	setObject:@"PASS"		forKey:@"POSTDATA" ];
	[ server		callTestMethod:myDictionary ];
	[ myDictionary	removeAllObjects]; // del

	NSString *pass = [ arguments objectAtIndex:1 ]; 
	if ( [pass isEqualToString:server.userPass] ) {
		NSString *outputString = [ NSString stringWithFormat:@"230 User %@ logged in.", pass ];
		[ sender sendMessage:outputString];

		[ myDictionary	setObject:@"Response"	forKey:@"DATAINFO" ];
		[ myDictionary	setObject:@"230"		forKey:@"POSTDATA" ];
		[ server		callTestMethod:myDictionary ];
		[ myDictionary	removeAllObjects]; // del

	}
	else {
		NSString *outputString = [ NSString stringWithFormat:@"530 Not Logged in required for %@", pass ];
		[ sender sendMessage:outputString];

		[ myDictionary	setObject:@"Response"	forKey:@"DATAINFO" ];
		[ myDictionary	setObject:@"530"		forKey:@"POSTDATA" ];
		[ server		callTestMethod:myDictionary ];		
		[ myDictionary	removeAllObjects]; // del

	}
	[ myDictionary	release ];
}

-(void)doStat:(id)sender arguments:(NSArray*)arguments

{
	NSMutableDictionary *myDictionary = [[NSMutableDictionary alloc]init ];	
	[ myDictionary	setObject:@"Request"	forKey:@"DATAINFO" ];
	[ myDictionary	setObject:@"STAT"		forKey:@"POSTDATA" ];
	[ server		callTestMethod:myDictionary];
	[ myDictionary	removeAllObjects]; // del
	
	[ sender sendMessage:@"211-localhost FTP server status:"];	
	[ sender sendMessage:@"211 End of Status"];

	[ myDictionary	setObject:@"Response"	forKey:@"DATAINFO" ];
	[ myDictionary	setObject:@"211"		forKey:@"POSTDATA" ];
	[ server		callTestMethod:myDictionary ];
	[ myDictionary	removeAllObjects]; // del
	[ myDictionary	release ];
}

-(void)doFeat:(id)sender arguments:(NSArray*)arguments

{
	NSMutableDictionary *myDictionary = [[NSMutableDictionary alloc]init ];	
	[ myDictionary	setObject:@"Request"	forKey:@"DATAINFO" ];
	[ myDictionary	setObject:@"FEAT"		forKey:@"POSTDATA" ];
	[ server		callTestMethod:myDictionary ];
	[ myDictionary	removeAllObjects ];

	[ sender sendMessage:@"211-Features supported"];
	[ sender sendMessage:@"211 End"];

	[ myDictionary	setObject:@"Response"	forKey:@"DATAINFO" ];
	[ myDictionary	setObject:@"211"		forKey:@"POSTDATA" ];
	[ server		callTestMethod:myDictionary ];
	[ myDictionary	removeAllObjects]; // del
	[ myDictionary	release ];
}

-(void)doList:(id)sender arguments:(NSArray*)arguments

{
	NSMutableDictionary *myDictionary = [[NSMutableDictionary alloc]init ];
	[ myDictionary	setObject:@"Request"	forKey:@"DATAINFO" ];
	[ myDictionary	setObject:@"LIST"		forKey:@"POSTDATA" ];
	[ server		callTestMethod:myDictionary ];
	[ myDictionary	removeAllObjects]; // del

	NSString *lsDir = [ self fileNameFromArgs:arguments] ;				
	NSString *listText;

	if ([lsDir length]<1) {
		lsDir = currentDir;
	}
	else {
		lsDir = [self rootedPath:lsDir ];
	}

	NSLog( @"doList currentDir(%@) changeRoot%d", lsDir, server.changeRoot );
	NSLog(@"Will list %@ ",lsDir);
	listText = [ [ server createList:lsDir] retain ];						

	[ sender sendMessage:@"150: Opening ASCII mode data connection for '/bin/ls'."];	
	[ sender sendDataString:listText  ];	
	
	[listText release ];
	
	[ myDictionary	setObject:@"Response"	forKey:@"DATAINFO" ];
	[ myDictionary	setObject:@"150"		forKey:@"POSTDATA" ];
	[ server		callTestMethod:myDictionary ];
	[ myDictionary	removeAllObjects]; // del
	[ myDictionary	release ];
}

-(void)doPwd:(id)sender arguments:(NSArray*)arguments

{
	NSMutableDictionary *myDictionary = [[NSMutableDictionary alloc]init ];
	[ myDictionary	setObject:@"Request"	forKey:@"DATAINFO" ];
	[ myDictionary	setObject:@"PWD"		forKey:@"POSTDATA" ];
	[ server		callTestMethod:myDictionary ];
	[ myDictionary	removeAllObjects]; // del
	
	NSString *cmdString = [ NSString stringWithFormat:@"257 \"%@\" is the current directory.", currentDir ]; 
	[ sender sendMessage:cmdString ];			

	[ myDictionary	setObject:@"Response"	forKey:@"DATAINFO" ];
	[ myDictionary	setObject:@"257"		forKey:@"POSTDATA" ];
	[ server		callTestMethod:myDictionary];
	[ myDictionary	removeAllObjects]; // del
	[ myDictionary	release ];
	
}

-(void)doNoop:(id)sender arguments:(NSArray*)arguments

{
	NSMutableDictionary *myDictionary = [[NSMutableDictionary alloc]init ];
	[ myDictionary	setObject:@"Request"	forKey:@"DATAINFO" ];
	[ myDictionary	setObject:@"NOOP"		forKey:@"POSTDATA" ];
	[ server		callTestMethod:myDictionary ];
	[ myDictionary	removeAllObjects]; // del

	[sender sendMessage:@"200 NOOP command successful." ];

	[ myDictionary	setObject:@"Response"	forKey:@"DATAINFO" ];
	[ myDictionary	setObject:@"200"		forKey:@"POSTDATA" ];
	[ server		callTestMethod:myDictionary] ;
	[ myDictionary	removeAllObjects]; // del
	[ myDictionary	release ];
	
}

-(void)doSyst:(id)sender arguments:(NSArray*)arguments

{
	NSMutableDictionary *myDictionary = [[NSMutableDictionary alloc]init ];
	[ myDictionary	setObject:@"Request"	forKey:@"DATAINFO" ];
	[ myDictionary	setObject:@"SYST"		forKey:@"POSTDATA" ];
	[ server		callTestMethod:myDictionary ];
	[ myDictionary	removeAllObjects]; // del

	[ sender sendMessage:@"215 UNIX Type: L8 Ver:0.01" ];

	[ myDictionary	setObject:@"Response"	forKey:@"DATAINFO"];
	[ myDictionary	setObject:@"215"		forKey:@"POSTDATA"];
	[ server		callTestMethod:myDictionary ];
	[ myDictionary	removeAllObjects]; // del
	[ myDictionary	release ];
}

-(void)doLprt:(id)sender arguments:(NSArray*)arguments

{	
	NSMutableDictionary *myDictionary = [[NSMutableDictionary alloc]init ];
	[ myDictionary	setObject:@"Request"	forKey:@"DATAINFO" ];
	[ myDictionary	setObject:@"LPRT"		forKey:@"POSTDATA" ];
	[ server		callTestMethod:myDictionary ];
	[ myDictionary	removeAllObjects]; // del
	[ myDictionary  release];
	
	NSString *socketDesc = [ arguments objectAtIndex:1 ] ;
	NSArray  *socketAddr = [ socketDesc componentsSeparatedByString:@"," ];

	int hb = [[socketAddr objectAtIndex:19] intValue ];
	int lb = [[socketAddr objectAtIndex:20] intValue ];

	NSLog(@"%d %d %d",hb <<8, hb,lb );
	int clientPort = (hb <<8 ) + lb;
		
	[ sender setTransferMode:lprtftp];
	[ sender openDataSocket:clientPort ];

}

-(void)doEprt:(id)sender arguments:(NSArray*)arguments

{
	NSMutableDictionary *myDictionary = [[NSMutableDictionary alloc]init ];
	[ myDictionary	setObject:@"Request"	forKey:@"DATAINFO" ];
	[ myDictionary	setObject:@"LPRT"		forKey:@"POSTDATA" ];
	[ server		callTestMethod:myDictionary ];
	[ myDictionary	removeAllObjects]; // del
	[ myDictionary  release ];

	NSString *socketDesc = [ arguments objectAtIndex:1 ] ;
	NSArray  *socketAddr = [ socketDesc componentsSeparatedByString:@"|" ];
	
	int clientPort = [[ socketAddr objectAtIndex:3 ] intValue ];
	
	NSLog(@"Got Send Port %d", clientPort );
	
	[ sender setTransferMode:eprtftp];
	[ sender openDataSocket:clientPort ];
}



-(void)doPasv:(id)sender arguments:(NSArray*)arguments

{
	NSMutableDictionary *myDictionary = [[NSMutableDictionary alloc]init ];
	[ myDictionary	setObject:@"Request"	forKey:@"DATAINFO" ];
	[ myDictionary	setObject:@"PASV"		forKey:@"POSTDATA" ];
	[ server		callTestMethod:myDictionary ];
	[ myDictionary	removeAllObjects]; // del
	[ myDictionary  release ];
	
	[ sender setTransferMode:pasvftp];
	[ sender openDataSocket:0 ];
}

-(void)doEpsv:(id)sender arguments:(NSArray*)arguments

{
	NSMutableDictionary *myDictionary = [[NSMutableDictionary alloc]init ];
	[ myDictionary	setObject:@"Request"	forKey:@"DATAINFO" ];
	[ myDictionary	setObject:@"EPSV"		forKey:@"POSTDATA" ];
	[ server		callTestMethod:myDictionary ];
	[ myDictionary	removeAllObjects]; // del
	[ myDictionary  release ];
	
	[ sender setTransferMode:epsvftp];
	[ sender openDataSocket:0 ];
}

-(void)doPort:(id)sender arguments:(NSArray*)arguments

{
	int hb, lb;

	NSMutableDictionary *myDictionary = [[NSMutableDictionary alloc]init ];
	[ myDictionary	setObject:@"Request"	forKey:@"DATAINFO" ];
	[ myDictionary	setObject:@"PORT"		forKey:@"POSTDATA" ];
	[ server		callTestMethod:myDictionary ];
	[ myDictionary	removeAllObjects]; // del
	[ myDictionary  release ];
	
	NSString *socketDesc = [ arguments objectAtIndex:1 ] ;
	NSArray *socketAddr = [ socketDesc componentsSeparatedByString:@"," ];
	
	hb = [[socketAddr objectAtIndex:4] intValue ];
	lb = [[socketAddr objectAtIndex:5] intValue ];
	
	
	int clientPort = (hb <<8 ) + lb;
	
	[ sender setTransferMode:portftp];
	[ sender openDataSocket:clientPort ];
}


-(void)doOpts:(id)sender arguments:(NSArray*)arguments

{
	NSMutableDictionary *myDictionary = [[NSMutableDictionary alloc]init];
	[ myDictionary	setObject:@"Request"	forKey:@"DATAINFO" ];
	[ myDictionary	setObject:@"OPTS"		forKey:@"POSTDATA" ];
	[ server		callTestMethod:myDictionary ];
	[ myDictionary	removeAllObjects]; // del

	NSString *cmd = [ arguments objectAtIndex:1 ];
	NSString *cmdstr = [ NSString stringWithFormat:@"502 Unknown command '%@'",cmd ];
	[ sender sendMessage:cmdstr ];

	[ myDictionary	setObject:@"Response"	forKey:@"DATAINFO" ];
	[ myDictionary	setObject:@"502"		forKey:@"POSTDATA" ];
	[ server		callTestMethod:myDictionary ];
	[ myDictionary	removeAllObjects]; // del
	[ myDictionary	release ];
	
}

-(void)doType:(id)sender arguments:(NSArray*)arguments

{
	NSMutableDictionary *myDictionary = [[NSMutableDictionary alloc]init ];
	[ myDictionary	setObject:@"Request"	forKey:@"DATAINFO" ];
	[ myDictionary	setObject:@"TYPE"		forKey:@"POSTDATA" ];
	[ server		callTestMethod:myDictionary ];
	[ myDictionary	removeAllObjects]; // del
	
	NSString *cmd =  [ arguments objectAtIndex:1 ];
	NSString *cmdstr = [ NSString stringWithFormat:@"200 Type set to  %@.",cmd ];
	[ sender sendMessage:cmdstr ];
	
	[ myDictionary	setObject:@"Response"	forKey:@"DATAINFO" ];
	[ myDictionary	setObject:@"200"		forKey:@"POSTDATA" ];
	[ server		callTestMethod:myDictionary ];
	[ myDictionary	removeAllObjects]; // del
	[ myDictionary	release ];
	
}

-(void)doCwd:(id)sender arguments:(NSArray*)arguments

{
	NSMutableDictionary *myDictionary = [[NSMutableDictionary alloc]init ];
	[ myDictionary	setObject:@"Request"	forKey:@"DATAINFO" ];
	[ myDictionary	setObject:@"CWD"		forKey:@"POSTDATA" ];
	[ server		callTestMethod:myDictionary ];
	[ myDictionary	removeAllObjects]; // del
	
	NSString *cwdDir = [ self fileNameFromArgs:arguments] ;				
	if ([cwdDir isEqualToString:@".."])
	{
		NSLog(@"Asked to go up a directory");
	}
	else
	{
		currentDir = [[ self fileNameFromArgs:arguments] copy ];				
		NSLog(@"currentDir is now %@",currentDir );
	}
	[ sender sendMessage:@"250 CWD command successful." ];

	[ myDictionary	setObject:@"Response"	forKey:@"DATAINFO" ];
	[ myDictionary	setObject:@"250"		forKey:@"POSTDATA" ];
	[ server		callTestMethod:myDictionary	];
	[ myDictionary	removeAllObjects]; // del
	[ myDictionary	release ];
}

-(void)doNlst:(id)sender arguments:(NSArray*)arguments

{
	NSMutableDictionary *myDictionary = [[NSMutableDictionary alloc]init ];
	[ myDictionary	setObject:@"Request"	forKey:@"DATAINFO" ];
	[ myDictionary	setObject:@"NLST"		forKey:@"POSTDATA" ];
	[ server		callTestMethod:myDictionary ];
	[ myDictionary	removeAllObjects]; // del
	[ myDictionary	release ];

	[ self doList:sender arguments:arguments ];
}

-(void)doStor:(id)sender arguments:(NSArray*)arguments

{	
	NSAutoreleasePool *pool			= [[NSAutoreleasePool alloc] init];

	NSFileManager	*fs = [NSFileManager defaultManager];	
	NSString		*filename = [ self fileNameFromArgs:arguments];		
	NSString		*cmdstr;										

	NSMutableDictionary *myDictionary = [[NSMutableDictionary alloc]init ];
	[ myDictionary	removeAllObjects ];
	[ myDictionary	setObject:@"Request"	forKey:@"DATAINFO" ];
	[ myDictionary	setObject:@"STOR"		forKey:@"POSTDATA" ];
	[ myDictionary	setObject:filename 		forKey:@"FILENAME" ];
	[ server		callTestMethod:myDictionary ];	
	[ myDictionary	removeAllObjects]; // del
	
	self.currentFile = [self makeFilePathFrom:filename];														
	

	if ( [self validNewFilePath:self.currentFile] )																
	{		
		
		if ([fs createFileAtPath:self.currentFile contents:nil attributes:nil]==YES)								
		{
			currentFileHandle = [[ NSFileHandle fileHandleForWritingAtPath:currentFile] retain];				
			cmdstr   = [ NSString stringWithFormat:@"150 Opening BINARY mode data connection for '%@'.",filename ];	
		}
		else
		{
			cmdstr = [ NSString stringWithFormat:@"553 %@: Permission denied.", filename ];

			[ myDictionary	setObject:@"Response"	forKey:@"DATAINFO" ];
			[ myDictionary	setObject:@"553"		forKey:@"POSTDATA" ];
			[ server		callTestMethod:myDictionary ];
			[ myDictionary	removeAllObjects]; // del
		}
	}
	else
	{
		
		cmdstr = [ NSString stringWithFormat:@"553 %@: Permission denied.", filename ];

		[ myDictionary	setObject:@"Response"	forKey:@"DATAINFO" ];
		[ myDictionary	setObject:@"553"		forKey:@"POSTDATA" ];
		[ server		callTestMethod:myDictionary ];
		[ myDictionary	removeAllObjects]; // del
	}
	[ myDictionary	release ];

	NSLog(@"FC:doStor  %@", currentFile );
	
	[sender sendMessage:cmdstr];
																									
	if (dataConnection )																			
	{
		NSLog(@"FC:setting connection state to clientSending");
		dataConnection.connectionState = clientSending;
	}
	else
	{
		NSLog(@"FC:Erorr  Cant set connection state to Client Sending : no Connection yet ");
	}
	[pool drain];
}


-(void)doRetr:(id)sender arguments:(NSArray*)arguments			

{
	NSAutoreleasePool *pool			= [[NSAutoreleasePool alloc] init];

	BOOL isDir;
	NSString *cmdstr; 
	
	NSMutableDictionary *myDictionary = [[NSMutableDictionary alloc]init ];
	[ myDictionary	setObject:@"Request"	forKey:@"DATAINFO" ];
	[ myDictionary	setObject:@"RETR"		forKey:@"POSTDATA" ];
	[ server		callTestMethod:myDictionary ];
	[ myDictionary	removeAllObjects]; // del
	
	NSString *filename = [self fileNameFromArgs:arguments];		
	NSString *filePath = [self makeFilePathFrom:filename];			
	
	NSLog(@"FC:doRetr: %@", filePath );

	
	if ( [self accessibleFilePath:filePath ] )					
	{
		if ( [ [ NSFileManager defaultManager] fileExistsAtPath:filePath isDirectory: &isDir ])			
		{
			if ( isDir ){																				
				[ sender sendMessage: [NSString stringWithFormat:@"550 %@: Not a plain file.",filename]];
			}
			else																						
			{	
				NSMutableData   *fileData = [[ NSMutableData dataWithContentsOfFile:filePath ] retain];										
				cmdstr = [ NSString stringWithFormat:@"150 Opening BINARY mode data connection for '%@'.",filename ];
				[ sender sendMessage:cmdstr];
				[ sender sendData:fileData  ];																								
				[ fileData release ];
				
				[ myDictionary	setObject:@"Response"	forKey:@"DATAINFO" ];
				[ myDictionary	setObject:@"150"		forKey:@"POSTDATA" ];
				[ server		callTestMethod:myDictionary ];
				[ myDictionary	removeAllObjects]; // del
			}		
		}
	}
	else			
	{
		cmdstr = [ NSString stringWithFormat:@"50 %@ No such file or directory.",filename ];		
		NSLog(@"FC:doRetr: file %@ doesnt' exist ", filePath);
		[sender sendMessage:cmdstr];
	}
	[ myDictionary	release ];
	[pool drain];

}


-(void)doDele:(id)sender arguments:(NSArray*)arguments

{
	NSAutoreleasePool *pool			= [[NSAutoreleasePool alloc] init];

	NSString *cmdStr;
	NSError  *error;
	NSString *filename =[self fileNameFromArgs:arguments];		
	NSString *filePath = [self makeFilePathFrom:filename];
	
	NSLog(@"filename is %@",filename);

	NSMutableDictionary *myDictionary = [[NSMutableDictionary alloc]init ];
	[ myDictionary	setObject:@"Request"	forKey:@"DATAINFO" ];
	[ myDictionary	setObject:@"DELE"		forKey:@"POSTDATA" ];
	[ server		callTestMethod:myDictionary ];
	[ myDictionary	removeAllObjects]; // del
	
	if ( [self accessibleFilePath:filePath ])						
	{				
		if ([[ NSFileManager defaultManager ] removeItemAtPath:filePath error:&error ])
		{
			cmdStr = [ NSString stringWithFormat:@"250 DELE command successful.",filename ];
			[ server mysrvReceiveFileListChanged];				

			[ myDictionary	setObject:@"Response"	forKey:@"DATAINFO" ];
			[ myDictionary	setObject:@"250"		forKey:@"POSTDATA" ];
			[ server		callTestMethod:myDictionary ];
			[ myDictionary	removeAllObjects]; // del
		}
		else
		{
			cmdStr = [ NSString stringWithFormat:@"550 DELE command unsuccessful.",filename ];					

			[ myDictionary	setObject:@"Response"	forKey:@"DATAINFO" ];
			[ myDictionary	setObject:@"550"		forKey:@"POSTDATA" ];
			[ server		callTestMethod:myDictionary ];
			[ myDictionary	removeAllObjects]; // del
		}
	}
	else
	{
		cmdStr = [ NSString stringWithFormat:@"550 %@ No such file or directory.", filename];

		[ myDictionary	setObject:@"Response"	forKey:@"DATAINFO" ];
		[ myDictionary	setObject:@"550"		forKey:@"POSTDATA" ];
		[ server		callTestMethod:myDictionary ];
		[ myDictionary	removeAllObjects]; // del
	}
	[ myDictionary	release ];
	[ sender sendMessage:cmdStr	];	
	
	[pool drain];
}

-(void)doMlst:(id)sender arguments:(NSArray*)arguments

{
	NSMutableDictionary *myDictionary = [[NSMutableDictionary alloc]init ];
	[ myDictionary	setObject:@"Request"	forKey:@"DATAINFO" ];
	[ myDictionary	setObject:@"MLST"		forKey:@"POSTDATA" ];
	[ server		callTestMethod:myDictionary ];
	[ myDictionary	removeAllObjects]; // del

	NSString *filename = [self fileNameFromArgs: arguments];
	NSString *cmdstr = [ NSString stringWithFormat:@"150 Opening BINARY mode data connection for '%@'.",filename ];
	
	[sender sendMessage:cmdstr];										

	[ myDictionary	setObject:@"Response"	forKey:@"DATAINFO" ];
	[ myDictionary	setObject:@"150"		forKey:@"POSTDATA" ];
	[ server		callTestMethod:myDictionary ];
	[ myDictionary	removeAllObjects]; // del
	[ myDictionary	release ];
}

-(void)doSize:(id)sender arguments:(NSArray*)arguments

{
	NSString *cmdStr;
	NSString *filename = [self fileNameFromArgs: arguments];									
	NSString *filePath = [self makeFilePathFrom:filename];										

	NSMutableDictionary *myDictionary = [[NSMutableDictionary alloc]init ];
	[ myDictionary	setObject:@"Request"	forKey:@"DATAINFO" ];
	[ myDictionary	setObject:@"SIZE"		forKey:@"POSTDATA" ];
	[ server		callTestMethod:myDictionary ];
	[ myDictionary	removeAllObjects]; // del

	if ([self accessibleFilePath:filePath])														
	{
		if ([self fileSize:filePath] < 10240)													
		{
			cmdStr = [ NSString stringWithFormat:@"213 %qu",[self fileSize:filePath] ];			

			[ myDictionary	setObject:@"Response"	forKey:@"DATAINFO" ];
			[ myDictionary	setObject:@"213"		forKey:@"POSTDATA" ];
			[ server		callTestMethod:myDictionary ];
			[ myDictionary	removeAllObjects]; // del
		}
		else
		{
			cmdStr = [ NSString stringWithFormat:@"550 %@ file too large for SIZE.",filename ];

			[ myDictionary	setObject:@"Response"	forKey:@"DATAINFO" ];
			[ myDictionary	setObject:@"550"		forKey:@"POSTDATA" ];
			[ server		callTestMethod:myDictionary ];
			[ myDictionary	removeAllObjects]; // del
		}		
	}
	else
	{
		cmdStr = [ NSString stringWithFormat:@"550 %@ No such file or directory.",filename ];	

		[ myDictionary	setObject:@"Response"	forKey:@"DATAINFO" ];
		[ myDictionary	setObject:@"550"		forKey:@"POSTDATA" ];
		[ server		callTestMethod:myDictionary ];
		[ myDictionary	removeAllObjects]; // del
	}

	[ myDictionary	release ];
	[ sender sendMessage:cmdStr];

}



-(void)doMkdir:(id)sender arguments:(NSArray*)arguments

{
	NSLog(@"current dir is %@",currentDir);
	NSAutoreleasePool *pool			= [[NSAutoreleasePool alloc] init];
	
	NSString *cmdStr = nil;
	NSString		*p  = [self makeFilePathFrom:[self fileNameFromArgs:arguments]];
	NSFileManager	*fs = [NSFileManager defaultManager];
	
	NSMutableDictionary *myDictionary = [[NSMutableDictionary alloc]init ];
	[ myDictionary	setObject:@"Request"	forKey:@"DATAINFO" ];
	[ myDictionary	setObject:@"MKDIR"		forKey:@"POSTDATA" ];
	[ server		callTestMethod:myDictionary ];
	[ myDictionary	removeAllObjects]; // del
	
	if ( [self validNewFilePath:p ])										
	{			
		if( [fs fileExistsAtPath:p isDirectory:nil] )
		{
			cmdStr = [ NSString stringWithFormat:@"Error %@ exists",[self fileNameFromArgs:arguments] ];	
		}
		else
		{
			[fs createDirectoryAtPath:p withIntermediateDirectories:YES attributes:nil error:nil]; 
			cmdStr = [ NSString stringWithFormat:@"250 MKD command successful."];	

			[ myDictionary	setObject:@"Response"	forKey:@"DATAINFO" ];
			[ myDictionary	setObject:@"250"		forKey:@"POSTDATA" ];
			[ server		callTestMethod:myDictionary ];
			[ myDictionary	removeAllObjects]; // del
		}
	}
	
	[ myDictionary	release ];
	[ sender sendMessage:cmdStr];

	[pool drain];
}


-(void)doCdUp:(id)sender arguments:(NSArray*)arguments

{
	NSLog(@"CurrentDir is %@",[self visibleCurrentDir]);
	
	NSString *upDir=[[self visibleCurrentDir] stringByDeletingLastPathComponent];

	NSMutableDictionary *myDictionary = [[NSMutableDictionary alloc]init ];
	[ myDictionary	setObject:@"Request"	forKey:@"DATAINFO" ];
	[ myDictionary	setObject:@"CDUP"		forKey:@"POSTDATA" ];
	[ server		callTestMethod:myDictionary ];
	[ myDictionary	removeAllObjects]; // del
	
	if ( [self changedCurrentDirectoryTo:upDir] )											
	{
		[sender sendMessage:@"250 CDUP command successful."]; 		

		[ myDictionary	setObject:@"Response"	forKey:@"DATAINFO" ];
		[ myDictionary	setObject:@"250"		forKey:@"POSTDATA" ];
		[ server		callTestMethod:myDictionary ];
		[ myDictionary	removeAllObjects]; // del
	}
	else
	{
		
		[ sender sendMessage:@"550 CDUP command failed." ];									

		[ myDictionary	setObject:@"Response"	forKey:@"DATAINFO" ];
		[ myDictionary	setObject:@"550"		forKey:@"POSTDATA" ];
		[ server		callTestMethod:myDictionary ];
		[ myDictionary	removeAllObjects]; // del
	}
	[ myDictionary	release ];
}


-(void)doRnfr:(id)sender arguments:(NSArray*)arguments

{		
	NSAutoreleasePool *pool			= [[NSAutoreleasePool alloc] init];

	self.rnfrFilename = [self makeFilePathFrom:[self fileNameFromArgs:arguments]];

	NSMutableDictionary *myDictionary = [[NSMutableDictionary alloc]init ];
	[ myDictionary	setObject:@"Request"	forKey:@"DATAINFO" ];
	[ myDictionary	setObject:@"RNFR"		forKey:@"POSTDATA" ];
	[ server		callTestMethod:myDictionary ];
	[ myDictionary	removeAllObjects]; // del
	
	if ( [ self accessibleFilePath:self.rnfrFilename ] )										
	{
				
		if ( [[ NSFileManager defaultManager] fileExistsAtPath: rnfrFilename ] )
		{
			[ sender sendMessage:@"350 RNFR command successful." ];

			[ myDictionary	setObject:@"Response"	forKey:@"DATAINFO" ];
			[ myDictionary	setObject:@"350"		forKey:@"POSTDATA" ];
			[ server		callTestMethod:myDictionary ];
			[ myDictionary	removeAllObjects]; // del
		}
		else {
			[ sender sendMessage:@"550 RNFR command failed." ];

			[ myDictionary	setObject:@"Response"	forKey:@"DATAINFO" ];
			[ myDictionary	setObject:@"550"		forKey:@"POSTDATA" ];
			[ server		callTestMethod:myDictionary ];
			[ myDictionary	removeAllObjects]; // del
		}
	}
	[ myDictionary	release ];

	[pool drain];
}


-(void)doRnto:(id)sender arguments:(NSArray*)arguments

{
	NSMutableDictionary *myDictionary = [[NSMutableDictionary alloc]init ];
	[ myDictionary	setObject:@"Request"	forKey:@"DATAINFO" ];
	[ myDictionary	setObject:@"RNTO"		forKey:@"POSTDATA" ];
	[ server		callTestMethod:myDictionary ];
	[ myDictionary	removeAllObjects]; // del
	
	if ( self.rnfrFilename == nil ){
		[ sender sendMessage:@"550 RNTO command failed." ];

		[ myDictionary	setObject:@"Response"	forKey:@"DATAINFO" ];
		[ myDictionary	setObject:@"550"		forKey:@"POSTDATA" ];
		[ server		callTestMethod:myDictionary ];
		[ myDictionary	removeAllObjects]; // del
		[ myDictionary	release ];
		return;
	}
	
	NSAutoreleasePool *pool			= [[NSAutoreleasePool alloc] init];

	NSError *error;
	NSString *rntoFilename = [self makeFilePathFrom:[self fileNameFromArgs:arguments]];
	
	if ([self validNewFilePath:rntoFilename])													
	{	
		if ( [[ NSFileManager defaultManager] moveItemAtPath:rnfrFilename toPath: rntoFilename error:&error ] ){
			[ server mysrvReceiveFileListChanged];
			[ sender sendMessage:@"250 RNTO command successful." ];

			[ myDictionary	setObject:@"Response"	forKey:@"DATAINFO" ];
			[ myDictionary	setObject:@"250"		forKey:@"POSTDATA" ];
			[ server		callTestMethod:myDictionary ];
			[ myDictionary	removeAllObjects]; // del

		}
		else{
			NSString *errorString = [error localizedDescription];
			NSLog( @"RNTO failed %@", errorString );
			[ sender sendMessage:@"550 RNTO command failed." ];

			[ myDictionary	setObject:@"Response"	forKey:@"DATAINFO" ];
			[ myDictionary	setObject:@"550"		forKey:@"POSTDATA" ];
			[ server		callTestMethod:myDictionary ];
			[ myDictionary	removeAllObjects]; // del
		}
	}
	else
	{
		[ sender sendMessage:@"550 RNTO command failed." ];										

		[ myDictionary	setObject:@"Response"	forKey:@"DATAINFO" ];
		[ myDictionary	setObject:@"550"		forKey:@"POSTDATA" ];
		[ server		callTestMethod:myDictionary ];
		[ myDictionary	removeAllObjects]; // del
	}
	[ myDictionary	release ];

	[pool drain];
}


#pragma mark UTILITIES


-(NSString*)makeFilePathFrom:(NSString*)filename

{
	if ( [filename characterAtIndex:0] == '/' )						
	{
		if ( server.changeRoot )									
		{
			return [ [server.baseDir stringByAppendingPathComponent: filename] stringByResolvingSymlinksInPath ];
		}
		else
		{
			return [[filename copy] autorelease ];											
		}

	}
	else															
	{
		return [ currentDir stringByAppendingPathComponent:filename];					
	
	}
}


-(unsigned long long)fileSize:(NSString*)filePath

{
	NSAutoreleasePool *pool			= [[NSAutoreleasePool alloc] init];

	NSError *error;
	NSDictionary *fileAttribs = [ [ NSFileManager defaultManager ] attributesOfItemAtPath:filePath error:&error ];
	
	NSNumber *fileSize = [ fileAttribs valueForKey:NSFileSize ];
	NSLog(@"File size is %qu ", [fileSize unsignedLongLongValue]);
	[pool drain];
	
	return [ fileSize unsignedLongLongValue];
	
}

-(NSString*)fileNameFromArgs:(NSArray*)arguments

{
	NSString *filename = [NSString string];
	if ([arguments count] >1) {
		
		
		for ( int n=1; n<[arguments count]; n++) {														

            /*
             ハイフン始まりのファイル名の場合、ライブラリーがクラッシュする現象が発生しました。
             そのため、ハイフンで始まるかどうかのチェックは行わないようにしました。
             */
//			if (![[[arguments objectAtIndex:n] substringToIndex:1] isEqualToString:@"-"]) 
//			{
				if ([filename length]==0) {
					filename = [arguments objectAtIndex:n ];
				}
				else {
					filename = [ NSString stringWithFormat:@"%@ %@", filename, [arguments objectAtIndex:n ] ];						
				}

//			}
//			else {
//				NSLog(@"HYPHEN FOUND IGNORE");
//			}
		}
	}
	
	return  filename  ;			
}



- (Boolean)changedCurrentDirectoryTo:(NSString *)newDirectory 

{		
	NSAutoreleasePool *pool			= [[NSAutoreleasePool alloc] init];
	NSFileManager *fileManager = [ NSFileManager defaultManager ];
	
	NSString *currentDirectory = [ fileManager currentDirectoryPath ];  
	NSString *testDirectory, *expandedPath;
	

	expandedPath = [[self rootedPath:newDirectory ] retain ];
	
	if (![self canChangeDirectoryTo:expandedPath]) {
		return false;
	}
	
	if ( ! [ fileManager changeCurrentDirectoryPath:expandedPath ] )	
	{
		return false;													
	}
	
	testDirectory = [ fileManager currentDirectoryPath ];				
	
	if ( ! [ fileManager changeCurrentDirectoryPath:currentDirectory ] )
	{
		return false;													
	}
	

	self.currentDir = [ testDirectory copy ];								
	
	[ expandedPath release];
	[pool drain];
	
	return true;														
}

-(Boolean)canChangeDirectoryTo:(NSString *)testDirectory 

{
	if (  [server changeRoot] && ( ! [ testDirectory hasPrefix:server.baseDir ]) ) {
		return false;
	}
	else {
		return true;
	}
}

- (Boolean)accessibleFilePath:(NSString*)filePath						

{
	return [ [ NSFileManager defaultManager ] fileExistsAtPath:filePath ];
}

- (Boolean)validNewFilePath:(NSString*)filePath

{	
	return true;			
}

- (NSString *)visibleCurrentDir

{
	if ( server.changeRoot )											
	{
		int alength = [server.baseDir length ];							
		
		NSLog(@"Length is %u", alength );								
		NSString *aString = [ currentDir substringFromIndex:alength ];	
		
		if ( ! [ aString hasSuffix:@"/" ] )								
		{
			aString = [ aString stringByAppendingString:@"/" ];										
		}
		
		return aString;				
	}
	else
	{
		return currentDir;							
	}
}

-(NSString *)rootedPath:(NSString*)path

{
	NSString  *expandedPath;
	
	
	if ( [ path characterAtIndex:0 ] == '/')					
	{
		if ( server.changeRoot )										
		{
			expandedPath = [ [server.baseDir stringByAppendingPathComponent: path] stringByResolvingSymlinksInPath ];
		}
		else															
		{
			expandedPath = path;								
		}
	}
	else																
	{
		expandedPath =[[ currentDir  stringByAppendingPathComponent:path ] stringByResolvingSymlinksInPath];		
	}
	
	expandedPath = [ expandedPath stringByStandardizingPath ];
	
	return expandedPath; 
	
}
@end
