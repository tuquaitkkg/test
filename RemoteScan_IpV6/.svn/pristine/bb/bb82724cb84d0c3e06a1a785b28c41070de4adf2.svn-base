//
//  FtpServer.m
//  myFtpServer
//
//  Created by SSL
//
//

#import "FtpServer.h"
#import "DiddyFtpServer.h"

@implementation FtpServer

- (id)initWithPort:(unsigned)serverPort withDir:(NSString *)aDirectory notifyObject:(id)sender requsername:(NSString*)aUserName requserpass:(NSString*)aUserPass encoding:(NSStringEncoding)encoding
{
	
    if( self = [super init] )
	{
		
		server = [[DiddyFtpServer alloc] initWithPort:serverPort withDir:aDirectory notifyObject:sender requsername:aUserName requserpass:aUserPass encoding:encoding];
		
    }

    return self;
}

- (id)initWithPort:(unsigned)serverPort withDir:(NSString *)aDirectory notifyObject:(id)sender requsername:(NSString*)aUserName requserpass:(NSString*)aUserPass
{
	return [self initWithPort:serverPort withDir:aDirectory notifyObject:sender requsername:aUserName requserpass:aUserPass encoding:NSShiftJISStringEncoding];
	
}

- (void)stopFtpServer
{
	[server stopFtpServer];
}

- (void)dealloc
{
	[server release];
	[super dealloc];
}

@end
