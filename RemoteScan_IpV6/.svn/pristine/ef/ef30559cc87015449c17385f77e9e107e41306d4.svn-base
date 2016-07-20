//
//  FtpServer.h
//  myFtpServer
//
//  Created by SSL
//
//

#import <Foundation/Foundation.h>

@class DiddyFtpServer;

@interface FtpServer : NSObject
{
	DiddyFtpServer* server;
}
- (id)initWithPort:(unsigned)serverPort withDir:(NSString *)aDirectory notifyObject:(id)sender requsername:(NSString*)aUserName requserpass:(NSString*)aUserPass;
- (id)initWithPort:(unsigned)serverPort withDir:(NSString *)aDirectory notifyObject:(id)sender requsername:(NSString*)aUserName requserpass:(NSString*)aUserPass encoding:(NSStringEncoding)encoding;
- (void)stopFtpServer;
@end
