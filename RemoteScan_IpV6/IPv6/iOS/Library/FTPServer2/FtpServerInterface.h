#import <UIKit/UIKit.h>

@interface FtpServer : NSObject {
	
}
#define REQRESINFO @"DATAINFO"
#define POSTDATAINFO @"POSTDATA"
- (id)initWithPort:(unsigned)serverPort withDir:(NSString *)aDirectory notifyObject:(id)sender requsername:(NSString*)aUserName requserpass:(NSString*)aUserPass;
- (void)stopFtpServer;

@end
