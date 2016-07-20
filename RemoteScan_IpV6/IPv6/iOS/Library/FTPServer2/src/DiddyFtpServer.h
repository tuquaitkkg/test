
#import <UIKit/UIKit.h>


#import "AsyncSocket.h"
#import "FtpDefines.h"
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


#import "FtpConnection.h"
#import "list.h"

@interface DiddyFtpServer : NSObject {
	
	AsyncSocket		*listenSocket;
	NSMutableArray	*connectedSockets;
	id				server;
	id				notificationObject;
	
	int				portNumber;
    id				delegate;	
	
    NSMutableArray *connections;
	
	NSDictionary	*commands;
	NSString		*baseDir;
	Boolean			changeRoot;							
	int				clientEncoding;						
	NSString*		userName;
	NSString*		userPass;
}
- (id)initWithPort:(unsigned)serverPort withDir:(NSString *)aDirectory notifyObject:(id)sender requsername:(NSString*)aUserName requserpass:(NSString*)aUserPass;
- (id)initWithPort:(unsigned)serverPort withDir:(NSString *)aDirectory notifyObject:(id)sender requsername:(NSString*)aUserName requserpass:(NSString*)aUserPass encoding:(NSStringEncoding)encoding;
- (void)stopFtpServer;

#pragma mark ASYNCSOCKET DELEGATES
- (void)onSocket:(AsyncSocket *)sock mysrvAcceptNewSocket:(AsyncSocket *)newSocket;
- (void)onSocket:(AsyncSocket *)sock mysrvConnectToHost:(NSString *)host port:(UInt16)port;

#pragma mark NOTIFICATIONS
- (void)mysrvReceiveFileListChanged;
-(void)callTestMethod:(NSMutableDictionary *)aDictionary;

#pragma mark CONNECTIONS
- (void)closeConnection:(id)theConnection;
- (NSString *)createList:(NSString *)directoryPath;

@property (readwrite, retain) AsyncSocket *listenSocket;
@property (readwrite, retain) NSMutableArray *connectedSockets;
@property (readwrite, retain) id server;
@property (readwrite, retain) id notificationObject;
@property (readwrite) int portNumber;
@property (readwrite, retain) id delegate;
@property (readwrite, retain) NSMutableArray *connections;
@property (readwrite, retain) NSDictionary *commands;
@property (copy)	  NSString *baseDir;
@property (readwrite) Boolean changeRoot;
@property (readwrite) int clientEncoding;
@property(copy)NSString *userName;
@property(copy)NSString *userPass;

@end
