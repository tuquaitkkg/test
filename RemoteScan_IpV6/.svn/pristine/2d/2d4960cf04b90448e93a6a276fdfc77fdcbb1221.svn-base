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

#import <UIKit/UIKit.h>

#import "AsyncSocket.h"

#import "FtpDataConnection.h"
#import "FtpDefines.h"
#include <sys/time.h>
#include <time.h>


@class DiddyFtpServer;

@interface FtpConnection : NSObject
{
	AsyncSocket			*connectionSocket;					
	DiddyFtpServer			*server;							
	AsyncSocket			*dataListeningSocket;				
	AsyncSocket         *dataSocket;						
	FtpDataConnection	*dataConnection;					
	
	NSArray				*msgComponents;						
	UInt16				dataPort;
	int					transferMode;
	NSMutableArray		*queuedData;	
	NSString			*currentUser;						
	NSString			*currentDir;						
	NSString			*currentFile;						
	NSFileHandle		*currentFileHandle;					
	NSString            *rnfrFilename;
//	NSMutableDictionary *myDictionary;
}


-(id)initWithAsyncSocket:(AsyncSocket*)newSocket forServer:(id)myServer ;

#pragma mark STATE
@property(readwrite)int transferMode;
@property(readwrite, retain ) NSString *currentFile;
@property(readwrite, retain ) NSString *currentDir;
@property(readwrite, retain ) NSString *rnfrFilename;
//@property(readwrite, retain ) NSMutableDictionary *myDictionary;

-(NSString*)connectionAddress;

#pragma mark ASYNCSOCKET DATACONN 

-(BOOL)openDataSocket:(int)portNumber;
-(int)choosePasvDataPort;
-(BOOL)onSocketWillConnect:(AsyncSocket *)sock;
-(void)onSocket:(AsyncSocket *)sock mysrvAcceptNewSocket:(AsyncSocket *)newSocket;

#pragma mark ASYNCSOCKET FTPCLIENT CONNECTION 
-(void)onSocket:(AsyncSocket*)sock mysrvReadData:(NSData*)data withTag:(long)tag;
-(void)onSocket:(AsyncSocket*)sock mysrvWriteDataWithTag:(long)tag;
-(void)sendMessage:(NSString*)ftpMessage;							
-(void)sendDataString:(NSString*)dataString;								
-(void)sendData:(NSMutableData*)data;
-(void)mysrvReceiveDataWritten;										
-(void)mysrvReceiveDataRead;											
-(void)mysrvFinishReading;											

#pragma mark PROCESS 
-(void)processDataRead:(NSData*)data;
-(void)processCommand;

#pragma mark COMMANDS 
-(void)doQuit:(id)sender arguments:(NSArray*)arguments;
-(void)doUser:(id)sender arguments:(NSArray*)arguments;
-(void)doPass:(id)sender arguments:(NSArray*)arguments;
-(void)doStat:(id)sender arguments:(NSArray*)arguments;
-(void)doFeat:(id)sender arguments:(NSArray*)arguments;
-(void)doList:(id)sender arguments:(NSArray*)arguments;
-(void)doPwd:(id)sender arguments:(NSArray*)arguments;
-(void)doNoop:(id)sender arguments:(NSArray*)arguments;
-(void)doSyst:(id)sender arguments:(NSArray*)arguments;
-(void)doLprt:(id)sender arguments:(NSArray*)arguments;
-(void)doPasv:(id)sender arguments:(NSArray*)arguments;
-(void)doEpsv:(id)sender arguments:(NSArray*)arguments;
-(void)doPort:(id)sender arguments:(NSArray*)arguments;
-(void)doNlst:(id)sender arguments:(NSArray*)arguments;
-(void)doStor:(id)sender arguments:(NSArray*)arguments;
-(void)doRetr:(id)sender arguments:(NSArray*)arguments;
-(void)doDele:(id)sender arguments:(NSArray*)arguments;
-(void)doMlst:(id)sender arguments:(NSArray*)arguments;
-(void)doSize:(id)sender arguments:(NSArray*)arguments;
-(void)doMkdir:(id)sender arguments:(NSArray*)arguments;
-(void)doCdUp:(id)sender arguments:(NSArray*)arguments;
-(void)doRnfr:(id)sender arguments:(NSArray*)arguments;
-(void)doRnto:(id)sender arguments:(NSArray*)arguments;

#pragma mark UTITILITES
-(NSString*)makeFilePathFrom:(NSString*)filename;
-(unsigned long long)fileSize:(NSString*)filePath;
-(NSString*)fileNameFromArgs:(NSArray*)arguments;
- (Boolean)changedCurrentDirectoryTo:(NSString *)newDirectory;
-(Boolean)canChangeDirectoryTo:(NSString *)testDirectory;
- (Boolean)accessibleFilePath:(NSString*)filePath;															
- (Boolean)validNewFilePath:(NSString*)filePath;
- (NSString *)visibleCurrentDir;
-(NSString *)rootedPath:(NSString*)path;

@end
