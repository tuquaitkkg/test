#import "FtpServerManager.h"
#import "Define.h"


@implementation FtpServerManager

//
// アクセサメソッドの自動合成(ゲッターとセッターの役割)
//
@synthesize username;								// ユーザ名	
@synthesize userpass;								// パスワード
@synthesize port;									// ポート番号(20000 固定)
@synthesize baseDir;								// ホームディレクトリ/Documments/

#pragma mark -
#pragma mark FtpServerManager delegete

//
// イニシャライザ定義
//
- (id)init
{
	LOG_METHOD;
    
    if ((self = [super init]) == nil)
	{
        return nil;
    }
	
    return self;					// 初期化処理の終了した self を戻す
}

//
// アプリケーションの終了直前に呼ばれるメソッド
//
- (void) dealloc
{
	LOG_METHOD;
	
    // 親クラスの解放処理を呼び出す
}


#pragma mark -
#pragma mark FtpServerManager

//
// ftp STart
//
- (void)startFTP:(NSString*)user requserpass:(NSString*)pass initWithPort:(unsigned)portno withDir:(NSString*)Dir notifyObject:(id)notifi;
{
	LOG_METHOD;
	
	completeFlg = 0;
	self.username	= user;
	self.userpass	= pass;
	self.port		= portno;
	self.baseDir	= Dir;
	notificationObject	= notifi;
    
	//
	// FTP START
	//
    DLog(@"FTP2");
#pragma warning FTPサーバエンコーディング指定
//	theServer	= [[ FtpServer alloc ]	initWithPort:self.port
//                                        withDir		:self.baseDir
//                                     notifyObject:self
//                                     requsername	:self.username
//                                     requserpass	:self.userpass];
    
    NSStringEncoding encodingString = [self getStringEncodingById:S_LANG];

	theServer	= [[ FtpServer alloc ]	initWithPort:self.port
                                        withDir		:self.baseDir
                                     notifyObject:self
                                     requsername	:self.username
                                     requserpass	:self.userpass
									   encoding		:encodingString
				   ];
}

-(NSStringEncoding)getStringEncodingById:(NSString*) langId
{
    if([langId isEqualToString:S_LANG_JA])
    {
        return NSShiftJISStringEncoding;
    }
//    簡体字は、FTPサーバライブラリーが対応していないため、コメントアウトしておく
//    if([langId isEqualToString:S_LANG_ZN_CH])
//    {
//        return CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingGB_2312_80);
//    }
    if([langId isEqualToString:S_LANG_ZN_TW])
    {
        return CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingBig5);
    }
    if([langId isEqualToString:S_LANG_HU] || [langId isEqualToString:S_LANG_PL] || [langId isEqualToString:S_LANG_CS] || [langId isEqualToString:S_LANG_SK])
    {
        return NSWindowsCP1250StringEncoding;//Latin2
    }
    if([langId isEqualToString:S_LANG_TR])
    {
        return NSWindowsCP1254StringEncoding;//Latin5
    }
    if([langId isEqualToString:S_LANG_RU])
    {
        return NSWindowsCP1251StringEncoding;//KOI8-R
    }
    if([langId isEqualToString:S_LANG_EL])
    {
        return NSWindowsCP1253StringEncoding;//iSO-8859-7
    }
    
    // その他はLatin1
    return NSWindowsCP1252StringEncoding;//Latin1
}
//
// ftp Stop
//
-(void)stopFTP
{
	LOG_METHOD;
	
	[theServer	stopFtpServer];
    
}

//
// ftp responce
//
-(void)reqresInfomationPost:(NSMutableDictionary *)aDictionary
{
	//
	// REQUEST RESPNCE INFO
	//
	NSString *requestdata	= [ aDictionary objectForKey:REQRESINFO];
	NSString *postdata		= [ aDictionary objectForKey:POSTDATAINFO];
    
	DLog(@"requestdata:%@", requestdata);
	DLog(@"postdata   :%@", postdata);
    DLog(@"postdata   :%@", aDictionary);
	//
	// 通知内容を判断
	//
	NSComparisonResult	res	= [requestdata compare:@"Request"];
	if (res == NSOrderedSame)
	{
		// POST DATA INFO
		NSString			*postdata = [ aDictionary objectForKey:POSTDATAINFO];
		//
		// 要求
		//
		res	= [postdata compare:@"STOR"];
		if (res == NSOrderedSame)
		{
			TRACE(@"[FTP Manager]reqresInfomationPost 1:受信中");
            
			//
			// タイマー停止
			//
            if (nil != tm)
            {
                [tm invalidate];
                tm = nil;
                completeFlg = 0;
            }
            
			NSString	*filename = [ aDictionary objectForKey:FILENAMEINFO];
			NSMutableDictionary *myDictionary = [[NSMutableDictionary alloc]init];
			[myDictionary setObject:@"1"		forKey:@"FTP_RETURN"];
			[myDictionary setObject:filename	forKey:@"FTP_FILENAME"];
			[self callFTPResult:myDictionary];
		}
		
		res	= [postdata compare:@"QUIT"];
		if (res == NSOrderedSame)
		{
			TRACE(@"[FTP Manager]reqresInfomationPost 3:QUIT");
			
			//
			// タイマー停止
			//
			[tm invalidate];
            tm = nil;
            
			if (completeFlg == 1)
            {
                completeFlg = 2;
                // 通知
                NSMutableDictionary *myDictionary = [[NSMutableDictionary alloc]init];
                [myDictionary setObject:@"3"		forKey:@"FTP_RETURN"];
                [self callFTPResult:myDictionary];
            }
		}
		
	}
    
	res	= [requestdata compare:@"Response"];
	if (res == NSOrderedSame && completeFlg == 0)
	{
		//
		// 受信
		//
		res	= [postdata compare:@"226"];
		if (res == NSOrderedSame)
		{
			TRACE(@"[FTP Manager]reqresInfomationPost 2:受信完了");
            
			completeFlg = 1;
			//
			// タイマー開始
			//
			tm =[NSTimer scheduledTimerWithTimeInterval:QUIT_TIMEOUT
                                                 target:self
                                               selector:@selector(timerHandler:)
                                               userInfo:nil
                                                repeats:NO];
			TRACE(@"タイマー開始 完了");
		}
	}
}

#pragma mark -
#pragma mark NOTIFICATIONS

//
// HTTP 結果通知
//
-(void)callFTPResult:(NSMutableDictionary *)aDictionary
{
	[[NSNotificationCenter defaultCenter] postNotificationName:@"setFTPReceiveResponceNotification" object:self userInfo:aDictionary];
}

#pragma mark -
#pragma mark TIMERHANDLER

//
//- (void)timerHandler
//
-(void)timerHandler:(NSTimer*)timer
{
	TRACE(@"タイムアウト");
	
	@autoreleasepool
    {
        @try
        {
            // 通知
            NSMutableDictionary *myDictionary = [[NSMutableDictionary alloc]init];
            [myDictionary setObject:@"2" forKey:@"FTP_RETURN"];
            [self callFTPResult:myDictionary];
            
        }
        @finally
        {
        }
    }
}

@end
