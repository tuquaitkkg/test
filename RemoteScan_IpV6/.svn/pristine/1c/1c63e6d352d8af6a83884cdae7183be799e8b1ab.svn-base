#import <UIKit/UIKit.h>


#define REQRESINFO		@"DATAINFO"
#define POSTDATAINFO	@"POSTDATA"
#define FILENAMEINFO	@"FILENAME"
#define QUIT_TIMEOUT	90							// タイムアウト時間(sec)

@interface FtpServer : NSObject
{
	
}

//
// メソッドの宣言
//
- (id)initWithPort:(unsigned)serverPort withDir:(NSString *)aDirectory notifyObject:(id)sender requsername:(NSString*)aUserName requserpass:(NSString*)aUserPass;
#pragma warning FTPサーバエンコーディング指定
- (id)initWithPort:(unsigned)serverPort withDir:(NSString *)aDirectory notifyObject:(id)sender requsername:(NSString*)aUserName requserpass:(NSString*)aUserPass encoding:(NSStringEncoding)encoding;
- (void)stopFtpServer;

@end

@interface FtpServerManager : NSObject
{
	//
	// インスタンス変数宣言
	//
	NSString				*username;					// ユーザ名
	NSString				*userpass;					// パスワード
	unsigned				port;						// ポート番号(20000 固定)
	NSString				*baseDir;					// ホームディレクトリ/Documments/

	FtpServer				*theServer;					//　ftp サーバ
	id						notificationObject;			// 通知
	NSTimer					*tm;						// タイマー
	unsigned				completeFlg;				// 
}

//
// プロパティの宣言
//
@property (nonatomic, copy  ) NSString	*username;		// ユーザ名
@property (nonatomic, copy  ) NSString	*userpass;		// パスワード
@property (nonatomic)		  unsigned	port;			// ポート番号(20000 固定)
@property (nonatomic, copy  ) NSString	*baseDir;		// ホームディレクトリ/Documments/

//
// メソッドの宣言
//
- (void)startFTP:(NSString*)username requserpass:(NSString*)userpass initWithPort:(unsigned)port withDir:(NSString*)baseDir notifyObject:(id)notifi;
- (void)stopFTP;
- (void)reqresInfomationPost:(NSMutableDictionary *)aDictionary;

#pragma mark NOTIFICATIONS
- (void)callFTPResult:(NSMutableDictionary *)aDictionary;

@end
