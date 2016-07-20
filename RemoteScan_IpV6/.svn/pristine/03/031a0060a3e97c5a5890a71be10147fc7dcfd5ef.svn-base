#import "HttpManeger.h"
#import "Define.h"


@implementation HttpManeger

//
// アクセサメソッドの自動合成(ゲッターとセッターの役割)
//
@synthesize		myname;				// 宛先名（必須）
@synthesize		user;				// ユーザ名
@synthesize		password;			// パスワード
@synthesize		format;				// ファイル形式
@synthesize		serchStr;			// 検索文字（必須）
@synthesize		ipAder;				// IPアドレス
@synthesize		mfpipAder;			// MFP IPアドレス
@synthesize		errMsg;				// エラー内容

#pragma mark -
#pragma mark HttpManeger delegete

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
    
	if (!receivedData)
	{
		receivedData	  = [[NSMutableData alloc] init];
	}
	if (!notificationData)
	{
		notificationData = [[NSMutableDictionary alloc] init];
	}
	
    return self;						// 初期化処理の終了した self を戻す
}

//
// アプリケーションの終了直前に呼ばれるメソッド
//
- (void)dealloc
{
	LOG_METHOD;
    
    // 親クラスの解放処理を呼び出す
}


#pragma mark -
#pragma mark HttpManeger

//
// HTTP POST 送信 : MFP に対して プロファイルの登録
// 引数 userAuthentication：ユーザ認証(0:無効/1:有効)
//
- (void)addPostRequest:(int) userAuthentication
{
	LOG_METHOD;
	
	
	@autoreleasepool
    {
        
        postMode	= HTTP_POST_ADD;
        userAuthen	= userAuthentication;
        
        //
        // POST データの作成
        //
        NSMutableURLRequest* request = [[NSMutableURLRequest alloc] init];
        [self makePostData:request];
        TRACE(@"POST データの作成 完了");
        
        //
        // URLコネクションを作る
        //
        urlconnection = [NSURLConnection connectionWithRequest:request delegate:self];
        TRACE(@"URLコネクション 完了");
        
        //
        // タイマー開始
        //
        tm =[NSTimer scheduledTimerWithTimeInterval:POST_TIMEOUT
                                             target:self
                                           selector:@selector(timerHandler:)
                                           userInfo:nil
                                            repeats:NO];
        TRACE(@"タイマー開始");
	}
    
}

//
// HTTP POST 送信 : MFP に対して プロファイルの更新
//
- (void)modPostRequest
{
	LOG_METHOD;
    
	@autoreleasepool
    {
        
        postMode = HTTP_POST_MOD;
        
        //
        // POST データの作成
        //
        NSMutableURLRequest* request = [[NSMutableURLRequest alloc] init];
        [self makePostData:request];
        
        //
        // URLコネクションを作る
        //
        [NSURLConnection connectionWithRequest:request delegate:self];
        
        
        //
        // タイマー開始
        //
        tm =[NSTimer scheduledTimerWithTimeInterval:POST_TIMEOUT
                                             target:self
                                           selector:@selector(timerHandler:)
                                           userInfo:nil
                                            repeats:NO];
        TRACE(@"タイマー開始");
	}
}

//
// POST データの作成
//
- (void)makePostData:(NSMutableURLRequest *)request
{
	@autoreleasepool
    {
        
        //
        // POST 先URL を指定
        //
        NSString *str			= nil;
        NSString *encode		= nil;
        
        // ggt_hidden(1)
        if ( postMode == HTTP_POST_ADD )
        {
            // 新規
            if ( userAuthen == HTTP_USERA_INVALID )
            {
                // ユーザ認証：無効
                str  = [NSString stringWithFormat:@"http://%@/%@", self.mfpipAder, POST_ADD_HTML];
                [request setURL:[NSURL URLWithString:str]];
            }
            else
            {
                // ユーザ認証：有効
                str  = [NSString stringWithFormat:@"http://%@/%@", self.mfpipAder, POST_ADD_NST];
                [request setURL:[NSURL URLWithString:str]];
            }
        }
        else
        {
            // 更新
            str  = [NSString stringWithFormat:@"http://%@/%@\?profid=4", self.mfpipAder, POST_MOD_NST];
            [request setURL:[NSURL URLWithString:str]];
        }
		
        //
        // タイムアウト値を指定 (仕様で、240 以下は240 になる->よって、タイマーで監視する)
        //
        [request setTimeoutInterval:POST_TIMEOUT];
        [request setHTTPShouldHandleCookies:FALSE];
        
        //
        // HTTP メソッドを指定
        //
        [request setHTTPMethod:@"POST"];
        
        //
        // ヘッダを追記
        //
        [request addValue:@"application/x-www-form-urlencoded" forHTTPHeaderField: @"Content-Type"];
        [request addValue:@"NO-ALERT" forHTTPHeaderField: @"X-SC-PROFILE"];
        
        NSMutableData *body = [NSMutableData data];
        
        // ユーザ認証：無効時
        if ( userAuthen == HTTP_USERA_INVALID )
        {
            // 登録モード		: addrDeskWebChange=&
            str  = @"addrDeskWebChange=&";
            [body appendData:[str dataUsingEncoding:NSUTF8StringEncoding]];
            
            // ヘルプボタン	: helpbtn (str  =  @"helpbtn=ヘルプ(I)&";)
            str  = @"helpbtn=ヘルプ(I)&";
            // URLエンコード
            encode	= ((NSString*)CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(
                                                                                            kCFAllocatorDefault,
                                                                                            (CFStringRef)str,
                                                                                            NULL,
                                                                                            NULL,
                                                                                            kCFStringEncodingUTF8)));
            [body appendData:[encode dataUsingEncoding:NSUTF8StringEncoding]];
            
            
            // 宛先のタイプ	: ggt_select(2)&
            str  = @"ggt_select(2)&";
            [body appendData:[str dataUsingEncoding:NSUTF8StringEncoding]];
            
            // 検索番号		: comprofSearchNo
            str  = @"comprofSearchNo=&";
            [body appendData:[str dataUsingEncoding:NSUTF8StringEncoding]];
        }
		
        // *************
        // 宛先名（必須）	: ggt_textbox(4)=xxx&
        // *************
        str				= [NSString stringWithFormat:@"ggt_textbox(4)=%@", self.myname];
        encode	= nil;
        encode	= ((NSString*)CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(
                                                                                        kCFAllocatorDefault,
                                                                                        (CFStringRef)str,
                                                                                        NULL,
                                                                                        NULL,
                                                                                        kCFStringEncodingUTF8)));
        str	= [self stringByURLEncoding:encode];
        str = [str stringByAppendingString:@"&"];
        [body appendData:[str dataUsingEncoding:NSUTF8StringEncoding]];
        
        // *************
        // 検索文字（必須）	: ggt_textbox(5)=xxx&
        // *************
        str		= [NSString stringWithFormat:@"ggt_textbox(5)=%@", self.serchStr];
        encode	= ((NSString*)CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(
                                                                                        kCFAllocatorDefault,
                                                                                        (CFStringRef)str,
                                                                                        NULL,
                                                                                        NULL,
                                                                                        kCFStringEncodingUTF8)));
        str	= [self stringByURLEncoding:encode];
        str = [str stringByAppendingString:@"&"];
        [body appendData:[str dataUsingEncoding:NSUTF8StringEncoding]];
        
        // ユーザ認証：無効時
        if ( userAuthen == HTTP_USERA_INVALID )
        {
            // キー名称		: ggt_textbox(6)
            str  = @"ggt_textbox(6)=&";
            [body appendData:[str dataUsingEncoding:NSUTF8StringEncoding]];
            
            // ユーザーインデックス	: ggt_select(7) (１：ユーザ１〜６：ユーザ６）
            str  = @"ggt_select(7)=1&";
            [body appendData:[str dataUsingEncoding:NSUTF8StringEncoding]];
        }
        
        // 得意先インデックス	: ggt_checkbox(8)（１：オン）
        str  = @"ggt_checkbox(8)=1&";
        [body appendData:[str dataUsingEncoding:NSUTF8StringEncoding]];
		
        // *************
        // IPアドレス	: ggt_textbox(9)
        // *************
        str  = @"ggt_textbox(9)=";
        str	 = [[str stringByAppendingString:self.ipAder]stringByAppendingString:@"&"];
        [body appendData:[str dataUsingEncoding:NSUTF8StringEncoding]];
        
        // ポート番号（必須）		: ggt_textbox(10) 4687固定
        str  = @"ggt_textbox(10)=";
        str	 = [[str stringByAppendingString:S_FTP_PORT]stringByAppendingString:@"&"];
        [body appendData:[str dataUsingEncoding:NSUTF8StringEncoding]];
        
        // 後処理ディレクトリ		: ggt_textbox(11)
        str  = @"ggt_textbox(11)=&";
        [body appendData:[str dataUsingEncoding:NSUTF8StringEncoding]];
        
        // ユーザ認証：無効時
        if ( userAuthen == HTTP_USERA_INVALID )
        {
            // ファイル形式（０：PDF）	: ggt_select(12)
            str  = @"ggt_select(12)=0&";
            [body appendData:[str dataUsingEncoding:NSUTF8StringEncoding]];
            
            // 圧縮形式（２：MMR（G４））: ggt_select(13)
            str  = @"ggt_select(13)=2&";
            [body appendData:[str dataUsingEncoding:NSUTF8StringEncoding]];
            
            // カラーグレースケール		: ggt_select(15)（１：中圧縮）
            str  = @"ggt_select(15)=1&";
            [body appendData:[str dataUsingEncoding:NSUTF8StringEncoding]];
        }
		
        // *************
        // ユーザ名				: ggt_textbox(16)
        // *************
        str  = @"ggt_textbox(16)=";
        str	 = [[str stringByAppendingString:self.user] stringByAppendingString:@"&"];
        [body appendData:[str dataUsingEncoding:NSUTF8StringEncoding]];
        
        // *************
        // パスワード				: ggt_textbox(17)
        // *************
        str  = @"ggt_textbox(17)=";
        str	 = [[str stringByAppendingString:self.password] stringByAppendingString:@"&"];
        [body appendData:[str dataUsingEncoding:NSUTF8StringEncoding]];
        
        // *************
        // パスワードを変更するチェック	: ggt_checkbox(18)（１：オン）
        // *************
        NSUInteger len = [self.password length];
        if (len > 0 )
        {
            str  = @"ggt_checkbox(18)=1&";
            [body appendData:[str dataUsingEncoding:NSUTF8StringEncoding]];
        }
        
        // action
        str  = @"action=desksubmitbtn&";
        [body appendData:[str dataUsingEncoding:NSUTF8StringEncoding]];
        
        // ユーザ認証：無効時
        if ( userAuthen == HTTP_USERA_INVALID )
        {
            // ggt_hidden(1)
            if ( postMode == HTTP_POST_ADD )
            {
                // 新規
                str  = @"ggt_hidden(1)=&";
                [body appendData:[str dataUsingEncoding:NSUTF8StringEncoding]];
            }
            else
            {
                // 更新
                str  = @"ggt_hidden(1)=4&";
                [body appendData:[str dataUsingEncoding:NSUTF8StringEncoding]];
            }
            
            // ggt_hidden(100)
            str  = @"ggt_hidden(100)=0";
            [body appendData:[str dataUsingEncoding:NSUTF8StringEncoding]];
        }
		
        //
        //	内容物追加
        //
        [request setHTTPBody:body];
        
	}
}

//
// HTTP POST 送信 : MFP に対して プロファイルの削除
//
- (void)delPostRequest
{
	LOG_METHOD;
    
	@autoreleasepool
    {
        NSString *str			= nil;
        
        postMode = HTTP_POST_DEL;
        
        //
        // URLを指定する
        //
        NSMutableURLRequest* request = [[NSMutableURLRequest alloc] init];
        str  = [NSString stringWithFormat:@"http://%@/%@", self.mfpipAder, POST_DEL_NST];
        [request setURL:[NSURL URLWithString:str]];
        [request setHTTPMethod:@"POST"];
        
        //
        // ヘッダを追記
        //
        [request addValue:@"application/x-www-form-urlencoded" forHTTPHeaderField: @"Content-Type"];
        [request addValue:@"NO-ALERT" forHTTPHeaderField: @"X-SC-PROFILE"];
        
        //
        //	内容部作成
        //
        NSMutableData *body = [NSMutableData data];
        
        // *************
        // 宛先名（必須）	: ggt_textbox(1)
        // *************
        str  = [NSString stringWithFormat:@"ggt_textbox(1)=%@", self.myname];
        // URLエンコード
        NSString *encode = (NSString*)CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(
                                                                                                kCFAllocatorDefault,
                                                                                                (CFStringRef)str,
                                                                                                NULL,
                                                                                                NULL,
                                                                                                kCFStringEncodingUTF8
                                                                                                ));
        str	= [self stringByURLEncoding:encode];
        str = [str stringByAppendingString:@"&"];
        [body appendData:[str dataUsingEncoding:NSUTF8StringEncoding]];
        
        // action		: deletebtn
        str  = @"action=deletebtn";
        [body appendData:[str dataUsingEncoding:NSUTF8StringEncoding]];
        
        //
        //	内容物追加
        //
        [request setHTTPBody:body];
        TRACE(@"POST データの作成 完了");
        
        //
        // URLコネクションを作る
        //
        urlconnection = [NSURLConnection connectionWithRequest:request delegate:self];
        TRACE(@"URLコネクション 完了");
        
        //
        // タイマー開始
        //
        tm =[NSTimer scheduledTimerWithTimeInterval:POST_TIMEOUT
                                             target:self
                                           selector:@selector(timerHandler:)
                                           userInfo:nil
                                            repeats:NO];
        TRACE(@"タイマー開始");
	}
}

//
//レスポンスを受け取ったときに呼び出されるデリゲート
//
// １）　URLが間違っている（ドメイン以下が間違っている）
// →404のレスポンスを受け取る. didFailWithErrorは呼ばれずに他のdelegateメソッドが呼ばれる。
//
// ２）　URLが間違っている（ドメイン部分が間違っている）
// →didFailWithErrorが呼ばれる。(他のdelegateメソッドは呼ばれない)
//
// ３）　そもそもネットワークが利用できない状況
// →didFailWithErrorが呼ばれる。(他のdelegateメソッドは呼ばれない)
//
- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
#if 1
	// debug出力
	if ([response isKindOfClass:[NSHTTPURLResponse class]])
	{
		// NSHTTPURLResponse の場合のみHTTPヘッダ情報へアクセス
		TRACE(@"レスポンス受信: %@", [(NSHTTPURLResponse *)response allHeaderFields]);
	}
#endif
	
	@autoreleasepool
    {
        @try
        {
            BOOL disconnect		= NO;
            
            //
            // レスポンスコードの判定
            //
            switch([(NSHTTPURLResponse *)response statusCode])
            {
                case 200:	// Success!
                case 206:
                    break;
                case 304:
                    self.errMsg		= @"Content is not modified.";
                    disconnect		= YES;
                    break;
                case 404:
                    self.errMsg		= @"Content has not found.";
                    disconnect		= YES;
                    break;
                case 416:
                    self.errMsg		= @"Range is mismatch.";
                    disconnect		= YES;
                    break;
                default:
                    self.errMsg		= @"Unknown error.";
                    disconnect		= YES;
                    break;
            }
            
            if( disconnect )
            {
                //
                // 通知：URLが間違っている（ドメイン以下が間違っている）
                //
                
                [tm invalidate];								// タイマー停止
                TRACE(@"タイマー停止");
                
                NSString *error = nil;
                switch(postMode)
                {
                    case HTTP_POST_ADD:
                    case HTTP_POST_MOD:
                        //
                        // 登録 or 更新
                        //
                        if ( userAuthen == HTTP_USERA_INVALID )
                        {
                            // ユーザ認証：無効
                            error = [NSString stringWithFormat:@"%zd:%@\r\n%@",
                                     [(NSHTTPURLResponse *)response statusCode],
                                     self.errMsg, POST_ADD_HTML];
                        }
                        else
                        {
                            // ユーザ認証：有効
                            error = [NSString stringWithFormat:@"%zd:%@\r\n%@",
                                     [(NSHTTPURLResponse *)response statusCode],
                                     self.errMsg, POST_ADD_NST];
                        }
                        break;
                        
                    case HTTP_POST_DEL:
                        //
                        // プロファイル削除
                        //
                        error = [NSString stringWithFormat:@"%zd:%@\r\n%@",
                                 [(NSHTTPURLResponse *)response statusCode],
                                 self.errMsg, POST_DEL_NST];
                        break;
                        
                    default:
                        break;
                }
                [notificationData setObject:@"3"	forKey:@"HTTP_RETURN"];
                [notificationData setObject:error	forKey:@"HTTP_ERROR"];
                [self callHttpInternalErrorNotification:notificationData];
                [notificationData	removeAllObjects];		// 削除
                // 解放
                [connection cancel];						//
                return;
            }
            
        }
        @catch (NSException *exception)
        {
            DLog(@"[HTTPManager didReceiveResponse]タイムアウト クロス");
        }
        @finally
        {
        }
    }
}

//
// 	データを受け取ったときに呼び出されるデリゲート
//
- (void)connection:(NSURLConnection*)connection didReceiveData:(NSData*)data
{
	TRACE(@"データ受信");
    
	@autoreleasepool
    {
        
        //
        // レスポンスデータを保持
        //
        [receivedData appendData:data];
        
	}
}

//
// 	データのロードが完了したときに呼び出されるデリゲート(読み込み完了時に一回呼ばれる)
//
- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
//    DLog(@"connectionDidFinishLoading:%d", postMode);
	TRACE(@"読み込み完了");
    
	@autoreleasepool
    {
        
        int			rtn		= 0;
        
        [tm invalidate];								// タイマー停止
        TRACE(@"タイマー停止");
        
        //
        // 通知：
        //
        switch(postMode)
        {
            case HTTP_POST_ADD:		// プロファイル登録
                //
                // 登録(1) 結果判定
                //
                rtn = [self responceDataJudge_add];
#if 1
                TRACE(@"POST_ADD: 戻り値[%d]MSG:%@", rtn, self.errMsg);
#endif
                // 通知
                //
                [notificationData setObject: [NSString stringWithFormat:@"%d",rtn]
                                     forKey:@"HTTP_RETURN"];
                [notificationData setObject: self.errMsg	forKey:@"HTTP_ERRDATA"];
                [self callHttpAddResponceNotification:notificationData];
                break;
                
            case HTTP_POST_MOD:		// プロファイル更新
                //
                // 更新(2) 結果判定
                //
                rtn = [self responceDataJudge_mod];
#if 1
                TRACE(@"POST_MOD: %@",  self.errMsg);
#endif
                
                //
                // 通知
                //
                [notificationData setObject: [NSString stringWithFormat:@"%d",rtn]
                                     forKey:@"HTTP_RETURN"];
                [notificationData setObject: self.errMsg	forKey:@"HTTP_ERRDATA"];
                [self callHttpModResponceNotification:notificationData];
                break;
                
            case HTTP_POST_DEL:		// プロファイル削除
                //
                // 削除(3) 結果判定
                //
                rtn = [self responceDataJudge_del];
#if 1
                TRACE(@"POST_DEL: %@",  self.errMsg);
#endif
                
                //
                // 通知
                //
                [notificationData setObject: [NSString stringWithFormat:@"%d",rtn]
                                     forKey:@"HTTP_RETURN"];
                [notificationData setObject: self.errMsg	forKey:@"HTTP_ERRDATA"];
                [self callHttpDelResponceNotification:notificationData];
                break;
                
            default:
                break;
        }
        [notificationData removeAllObjects];		// 削除
        // 解放
        // 解放
        
	}
}

//
// 接続できなかったときに呼び出されたときのデリゲート
//
- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
	TRACE(@"Connection failed! Error - %@ %zd %@",
          [error domain],[error code],[error localizedDescription]);
    
	@autoreleasepool
    {
        @try
        {
            [tm invalidate];								// タイマー停止
            TRACE(@"タイマー停止");
            
            //
            // キャンセル時
            //
            if([error code] ==  NSURLErrorCancelled || [error code] ==  NSURLErrorTimedOut)
            {
                return;
            }
            
            //
            // 通知：ネットワークに接続されていない時等
            //
            [notificationData setObject:[NSString stringWithFormat:@"%d",postMode] forKey:@"HTTP_METHOD"];
            [notificationData setObject:@"4"	forKey:@"HTTP_RETURN"];
            [notificationData setObject:error	forKey:@"HTTP_ERROR"];
            [self callHttpInternalErrorNotification:notificationData];
            [notificationData removeAllObjects];		// 削除
            
            //
            // 解放処理
            //
            [urlconnection			cancel];				// キャンセル
            // 解放
            // 解放
            
        }
        @catch (NSException *exception)
        {
            TRACE(@"タイムアウト クロス");
        }
        @finally
        {
        }
    }
}

//
// 登録(1) 結果判定
// 戻り値  1: 正常
//		  2: 異常(入力された送信先名はすでに存在)
//		  3: 異常(認証エラー)
//		  4: 異常(電源OFF)
//		  5: 異常(上記以外)
//        6: 異常(本体が処理中)
//
- (int) responceDataJudge_add
{
	//	《正常》
	//	<div class="main">
	//	  <p class="ok"></p>
	
	//	《異常》
	//	<div class="main">
	//	  <p class="err"> "ERROR[949]:&nbsp;入力された送信先名はすでに存在します。送信先名を変更してください。"<br>
	@autoreleasepool
    {
        @try
        {
            NSRange range;
            NSRange	range_next;
            NSString *strData	= [[NSString alloc]initWithData:receivedData encoding:NSUTF8StringEncoding];
            self.errMsg			= @"登録に失敗しました。";
#if 1
            TRACE(@"%@", strData);
#endif
            
            int rtn = [self responceDataJudge_title:strData];
            if ( rtn != 0 )
            {
                return rtn;
            }
            
            //
            // タイトルのチェックが正常な場合
            //
            range_next	= NSMakeRange(0, [strData length]);
            range		= [strData rangeOfString: @"<div class=\"main\">"
                                    options: NSCaseInsensitiveSearch
                                     range : range_next];
            if(!(range.location != NSNotFound)) {
                range		= [strData rangeOfString: @"<div id=\"main\""
                                         options: NSCaseInsensitiveSearch
                                          range : range_next];
            }
            
            if (range.location != NSNotFound)
            {
                //
                // プロファイルの登録結果の err 判定？
                // 次の検索範囲を見つかった文字列よりも後からになるようにする
                //
                range_next.location	= range.location + range.length;
                range_next.length	= [strData length] - range_next.location;
                range				= [strData rangeOfString: @"<p class=\"err\""
                                          options: NSCaseInsensitiveSearch
                                           range : range_next];
                if (range.location != NSNotFound)
                {
                    // 見つかった
                    range_next.location	= range.location + range.length;
                    range_next.length	= [strData length] - range_next.location;
                    range				= [strData rangeOfString: @"<br>"
                                              options: NSCaseInsensitiveSearch
                                               range : range_next];
                    if (range.location != NSNotFound)
                    {
                        // 見つかった
                        range.length	= range.location - range_next.location;
                        range.location	= range_next.location;
                        self.errMsg		= [strData substringWithRange:range];
                        
                        // エラー番号取得
                        if ([self getHttpErrNO:self.errMsg] == 949)
                        {
                            return 2;
                        }
                        //                    // エラー番号取得
                        //					if ([self getHttpErrNO:self.errMsg] == 5000)
                        //					{
                        //						return 6;
                        //					}
                        return 6;
                    }
                }
                else
                {
                    // 見つからない
                    range = [strData rangeOfString: @"<p class=\"OK\""
                                           options: NSCaseInsensitiveSearch
                                           range  : range_next];
                    if (range.location != NSNotFound)
                    {
                        // 見つかった
                        self.errMsg	= MSG_BUTTON_OK;
                        return 1;
                    }
                }
            }
            //		else
            //		{
            //			//<p>
            //			//本体にアクセスできません。しばらくしてから試みてください。
            //			//</p>
            //
            //			//
            //			// エラー：MFP 電源OFF
            //			//
            //			range_next	= NSMakeRange(0, [strData length]);
            //			range		= [strData rangeOfString: @"<p>"
            //									options: NSCaseInsensitiveSearch
            //									 range : range_next];
            //			if (range.location != NSNotFound)
            //			{
            //				//
            //				// 見つかった
            //				//
            //				range_next.location	= range.location + range.length;
            //				range_next.length	= [strData length] - range_next.location;
            //				range				= [strData rangeOfString: @"</p>"
            //										  options: NSCaseInsensitiveSearch
            //										   range : range_next];
            //				if (range.location != NSNotFound)
            //				{
            //					range.length	= range.location - range_next.location;
            //					range.location	= range_next.location;
            //					self.errMsg		= [strData substringWithRange:range];
            //				}
            //			}
            //		}
            return 5;
        }
        @finally
        {
		}
	}
}

//
// レスポンスデータの判定 タイトル
// 戻り値
//  0:正常 / 3:認証エラー / 4:電源OFFエラー / 5:以外(エラー)
//
- (int) responceDataJudge_title:(NSString *)strData
{
	//	《正常》
	//	<title>アドレス帳 - MX-3600FN</title>
	
	//	《異常》
	//	<title>エラー - MX-3600FN</title>   : 電源OFF
	//  <title>ログイン - MX-3600FN</title> : 認証エラー
	@autoreleasepool
    {
        @try
        {
            NSString *title_prefix = @"<title>";
            NSArray *titles_login = [NSArray arrayWithObjects:@"ログイン", @"Login", @"Login", @"Inicio de Sesión", @"Connexion", @"Login",
                                     @"Nome di accesso", @"Aanmelden", @"Inloggning", @"Innlogging", @"Sisäänkirjautuminen",
                                     @"Login", @"Belépés", @"Přihlášení", @"Login", @"Вход в систему", @"Σύνδεση", @"Início de Sessão", @"Giriş",
                                     @"Prihlásiť sa", @"Conectare", @"PIETEIKŠ.", @"Início de Sessão", @"登录", @"登入",
                                     @"Inici de sessió", nil];
            NSArray *titles_error = [NSArray arrayWithObjects:@"エラー", @"Error", @"Error", @"Error", @"Erreur", @"Fehler", @"Errore",
                                     @"Fout", @"Fel", @"Feil", @"Virhe", @"Fejl", @"Hiba", @"Chyba", @"Błąd", @"Ошибка", @"Σφάλμα", @"Erro",
                                     @"Hata", @"Chyba", @"Eroare", @"Kļūda", @"Erro", @"错误", @"錯誤", @"Error", nil];
            NSArray *titles_addressbook = [NSArray arrayWithObjects:@"アドレス帳", @"Address Book", @"Address Book", @"Libreta de Direcciones",
                                           @"Carnet d&#39;adresses", @"Adressbuch", @"Rubrica", @"Adresboek", @"Adressbok",
                                           @"Adressebok", @"Osoitekirja", @"Adressebog", @"Címtár", @"Adresář", @"Książka Adresowa",
                                           @"Адресная Книга", @"Βιβλ. Διευθ.", @"Livro De Endereços", @"Adres Defterı", @"Tel. zoznam", @"Agendă",
                                           @"Adrešu grāmata", @"Livro de Endereços", @"地址簿", @"位址目錄", @"Llibreta d&#39;adreces", nil];
            
            NSRange range;
            NSRange	range_next;
            //		NSString *strData	= [[[NSString alloc]initWithData:receivedData encoding:NSUTF8StringEncoding]autorelease];
            for(__strong id title in titles_addressbook)
            {
                title = [title_prefix stringByAppendingString:title];
                // アドレス帳 か？
                range_next	= NSMakeRange(0, [strData length]);
                range		= [strData rangeOfString: title
                                        options: NSCaseInsensitiveSearch
                                         range : range_next];
                if (range.location != NSNotFound)
                {
                    return 0;
                    
                }
            }
            for(__strong id title in titles_login)
            {
                title = [title_prefix stringByAppendingString:title];
                // 認証エラー か？
                range_next	= NSMakeRange(0, [strData length]);
                range		= [strData rangeOfString: title
                                        options: NSCaseInsensitiveSearch
                                         range : range_next];
                if (range.location != NSNotFound)
                {
                    //<div><label id="ggtLblId10010" class="labelNormal">
                    //管理者権限のページを開く場合は、権限を持つユーザーでログインしてください。
                    //</label></div>
                    
                    //
                    // エラー：認証エラー
                    //
                    range_next	= NSMakeRange(0, [strData length]);
                    range		= [strData rangeOfString: @"id=\"ggtLblId10010\" class=\"labelNormal\">"
                                            options: NSCaseInsensitiveSearch
                                             range : range_next];
                    if (range.location != NSNotFound)
                    {
                        //
                        // 見つかった
                        //
                        range_next.location	= range.location + range.length;
                        range_next.length	= [strData length] - range_next.location;
                        range				= [strData rangeOfString: @"</label>"
                                                  options: NSCaseInsensitiveSearch
                                                   range : range_next];
                        if (range.location != NSNotFound)
                        {
                            range.length	= range.location - range_next.location;
                            range.location	= range_next.location;
                            self.errMsg		= [strData substringWithRange:range];
                        }
                    }
                    return 3;
                    
                }
            }
            
            for(__strong id title in titles_error)
            {
                title = [title_prefix stringByAppendingString:title];
                // 電源OFF か？
                range_next	= NSMakeRange(0, [strData length]);
                range		= [strData rangeOfString: title
                                        options: NSCaseInsensitiveSearch
                                         range : range_next];
                if (range.location != NSNotFound)
                {
                    //<p>
                    //本体にアクセスできません。しばらくしてから試みてください。
                    //</p>
                    
                    //
                    // エラー：MFP 電源OFF
                    //
                    range_next	= NSMakeRange(0, [strData length]);
                    range		= [strData rangeOfString: @"<p>"
                                            options: NSCaseInsensitiveSearch
                                             range : range_next];
                    if (range.location != NSNotFound)
                    {
                        //
                        // 見つかった
                        //
                        range_next.location	= range.location + range.length;
                        range_next.length	= [strData length] - range_next.location;
                        range				= [strData rangeOfString: @"</p>"
                                                  options: NSCaseInsensitiveSearch
                                                   range : range_next];
                        if (range.location != NSNotFound)
                        {
                            range.length	= range.location - range_next.location;
                            range.location	= range_next.location;
                            self.errMsg		= [strData substringWithRange:range];
                        }
                    }
                    return 4;
                    
                }
            }
            
            return 0;
            
        }
        @finally
        {
		}
	}
}

//
// 更新(2) 結果判定
//
- (int) responceDataJudge_mod
{
	NSRange range;
	NSRange	range_next;
	NSString *strData	= [[NSString alloc]initWithData:receivedData encoding:NSUTF8StringEncoding];
	self.errMsg			= MSG_SCAN_CANCEL;
	
	//
	// 登録結果ありか？
	//
	//	range	= [strData rangeOfString: @"<div class=\"main\">"];
	range_next	= NSMakeRange(0, [strData length]);
	range		= [strData rangeOfString: @"<div class=\"main\">" 
							options: NSCaseInsensitiveSearch
							 range : range_next];
    if(range.location == NSNotFound) {
        range		= [strData rangeOfString: @"<div id=\"main\""
                                options: NSCaseInsensitiveSearch
                                 range : range_next];
    }
	if (range.location != NSNotFound)
	{
		//
		// err か？
		// 次の検索範囲を見つかった文字列よりも後からになるようにする
		//
		range_next.location	= range.location + range.length;
		range_next.length	= [strData length] - range_next.location;
		range				= [strData rangeOfString: @"<p class=\"err\""
								  options: NSCaseInsensitiveSearch
								   range : range_next];
		if (range.location != NSNotFound)
		{
			//
			// 見つかった
			//
			range_next.location	= range.location + range.length;
			range_next.length	= [strData length] - range_next.location;
			range				= [strData rangeOfString: @"<br>" 
									  options: NSCaseInsensitiveSearch
									   range : range_next];
			if (range.location != NSNotFound)
			{
				range.length	= range.location - range_next.location;
				range.location	= range_next.location;
				self.errMsg		= [strData substringWithRange:range];
                
				
                //                // エラー番号取得
                //                if ([self getHttpErrNO:self.errMsg] == 5000)
                //                {
                //                    return 4;
                //                }
                
                return 4;
			}
		}
		
		//
		// OK か？
		//
		range = [strData rangeOfString: @"<p class=\"OK\""
							   options: NSCaseInsensitiveSearch
							   range  : range_next];
		if (range.location != NSNotFound)
		{
			// 見つかった
			self.errMsg	= MSG_BUTTON_OK;
			return 1;
		}
	}
	
	return 3;
}

//
// 削除(3) 結果判定
//
- (int) responceDataJudge_del
{
	//	《1:正常》
	//	<div class="main">
	//	  <p class="ok"> "正常に処理されました。"<br>
	
	//	《2:異常》(ERROR[5000]以外の場合)
	//	<div class="main">
	//	  <p class="err"> "ERROR[5000]: 本体が処理中のため、この機能を実行することはできません。"<br>
    
    //  《4:異常》(ERROR[5000]の場合)
	//	<div class="main">
	//	  <p class="err"> "ERROR[5000]: 本体が処理中のため、この機能を実行することはできません。"<br>
	@autoreleasepool
    {
        @try
        {
            NSRange range;
            NSRange	range_next;
            NSString *strData	= [[NSString alloc]initWithData:receivedData encoding:NSUTF8StringEncoding];
            self.errMsg			= MSG_DEL_PROFILE_ERR;
#if 0
            TRACE(@"%@", strData);
#endif
            
            //
            // 登録結果ありか？
            //
            range_next	= NSMakeRange(0, [strData length]);
            range		= [strData rangeOfString: @"<div class=\"main\">" 
                                    options: NSCaseInsensitiveSearch
                                     range : range_next];
            if(range.location == NSNotFound) {
                range		= [strData rangeOfString: @"<div id=\"main\""
                                        options: NSCaseInsensitiveSearch
                                         range : range_next];
            }
            if (range.location != NSNotFound)
            {
                //
                // err か？
                // 次の検索範囲を見つかった文字列よりも後からになるようにする
                //
                range_next.location	= range.location + range.length;
                range_next.length	= [strData length] - range_next.location;
                range				= [strData rangeOfString: @"<p class=\"err\""
                                          options: NSCaseInsensitiveSearch
                                           range : range_next];
                if (range.location != NSNotFound)
                {
                    //
                    // 見つかった
                    //
                    range_next.location	= range.location + range.length;
                    range_next.length	= [strData length] - range_next.location;
                    range				= [strData rangeOfString: @"<br>" 
                                              options: NSCaseInsensitiveSearch
                                               range : range_next];
                    if (range.location != NSNotFound)
                    {
                        range.length	= range.location - range_next.location;
                        range.location	= range_next.location;
                        self.errMsg		= [strData substringWithRange:range];
                        
                        //                    // エラー番号取得
                        //					if ([self getHttpErrNO:self.errMsg] == 5000)
                        //					{
                        //						return 4;
                        //					}
                        return 4;
                    }
                }
                
                //
                // OK か？
                //
                range = [strData rangeOfString: @"<p class=\"OK\""
                                       options: NSCaseInsensitiveSearch
                                       range  : range_next];
                if (range.location != NSNotFound)
                {
                    // 見つかった
                    self.errMsg	= MSG_BUTTON_OK;
                    return 1;
                }
            }
            return 3;
        }
        @finally
        {
		}
	}	
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
            NSString *error		= nil;
            
            self.errMsg	= @"Time out Error.";
            
            //
            // タイマー停止
            //
            [tm invalidate];
            TRACE(@"タイマー停止");
            
            //
            // 通知
            //
            error = [NSString stringWithFormat:@"%@:%@\r\n%@", @(NSURLErrorTimedOut), self.errMsg, self.mfpipAder];
            [notificationData setObject:@"3"	forKey:@"HTTP_RETURN"];
            [notificationData setObject:error	forKey:@"HTTP_ERROR"];
            [self callHttpInternalErrorNotification:notificationData];
            [notificationData removeAllObjects];		// 削除
            
            //
            // 解放処理
            //
            [urlconnection		cancel];				// キャンセル
            // 解放
            // 解放
            
        }
        @catch (NSException *exception)
        {
            DLog(@"[HTTPManager timerHandler]タイムアウト クロス");
        }
        @finally
        {
        }
    }
}


#pragma mark -
#pragma mark NOTIFICATIONS

//
// HTTP 結果通知：プロファイル登録
//
-(void)callHttpAddResponceNotification:(NSMutableDictionary *)aDictionary
{
    DLog(@"callHttpAddResponceNotification");
	[[NSNotificationCenter defaultCenter] postNotificationName:@"setHttpAddResponceNotification" object:self userInfo:aDictionary];
}

//
// HTTP 結果通知：プロファイル更新
//
-(void)callHttpModResponceNotification:(NSMutableDictionary *)aDictionary
{
	[[NSNotificationCenter defaultCenter] postNotificationName:@"setHttpModResponceNotification" object:self userInfo:aDictionary];
}

//
// HTTP 結果通知：プロファイル削除
//
-(void)callHttpDelResponceNotification:(NSMutableDictionary *)aDictionary
{
	[[NSNotificationCenter defaultCenter] postNotificationName:@"setHttpDelResponceNotification" object:self userInfo:aDictionary];
}

//
// HTTP 結果通知：ネットワークエラー or URLが間違っている（ドメイン以下が間違っている）
//
-(void)callHttpInternalErrorNotification:(NSMutableDictionary *)aDictionary
{
	[[NSNotificationCenter defaultCenter] postNotificationName:@"setHTTPInternalErrorNotification" object:self userInfo:aDictionary];
}

//
// URLエンコード
//
-(NSString *)stringByURLEncoding:(NSString *)originalString
{
	NSArray *escapeChars = [NSArray arrayWithObjects:
                            @"&"
							,@"+"
							,nil];
	
	NSArray *replaceChars = [NSArray arrayWithObjects:
							 @"%26"
                             ,@"%2B"
                             ,nil];
	
	NSMutableString *encodedString;
	encodedString = [NSMutableString stringWithString:originalString];
    
	TRACE(@"encodedString：%@", encodedString);
    
	for(int i=0; i<[escapeChars count]; i++)
	{
		[encodedString replaceOccurrencesOfString:[escapeChars objectAtIndex:i]
                                       withString:[replaceChars objectAtIndex:i]
                                          options:NSLiteralSearch
                                            range:NSMakeRange(0, [encodedString length])];
	}
	
	return [NSString stringWithString: encodedString];
}

//
// エラー番号取得
//
- (int)getHttpErrNO:(NSString*)orgData
{
	// <p class="err"> "ERROR[949]:&nbsp;入力された送信先名はすでに存在します。送信先名を変更してください。"<br>
	
	int rtn = 0;
	
	@autoreleasepool
    {
        @try
        {
            NSRange range;
            NSRange	range_next;
            
            //
            // 登録結果ありか？
            //
            range_next	= NSMakeRange(0, [orgData length]);
            range		= [orgData rangeOfString: @"[" 
                                    options: NSCaseInsensitiveSearch
                                     range : range_next];
            if (range.location != NSNotFound)
            {
                //
                // 見つかった
                // 次の検索範囲を見つかった文字列よりも後からになるようにする
                //
                range_next.location	= range.location + range.length;
                range_next.length	= [orgData length] - range_next.location;
                range				= [orgData rangeOfString: @"]" 
                                          options: NSCaseInsensitiveSearch
                                           range : range_next];
                if (range.location != NSNotFound)
                {
                    // 見つかった
                    range.length	= range.location - range_next.location;
                    range.location	= range_next.location;
                    rtn	= [[orgData substringWithRange:range]intValue];
                }
            }
            TRACE(@"getHttpErrNO[%d]", rtn);
            
            return rtn;
        }
        @finally
        {
		}
	}	
}


@end


#if 0
typedef enum
{
	NSURLErrorUnknown = -1,
	NSURLErrorCancelled = -999,
	NSURLErrorBadURL = -1000,
	NSURLErrorTimedOut = -1001,
	NSURLErrorUnsupportedURL = -1002,
	NSURLErrorCannotFindHost = -1003,
	NSURLErrorCannotConnectToHost = -1004,
	NSURLErrorDataLengthExceedsMaximum = -1103,
	NSURLErrorNetworkConnectionLost = -1005,
	NSURLErrorDNSLookupFailed = -1006,
	NSURLErrorHTTPTooManyRedirects = -1007,
	NSURLErrorResourceUnavailable = -1008,
	NSURLErrorNotConnectedToInternet = -1009,
	NSURLErrorRedirectToNonExistentLocation = -1010,
	NSURLErrorBadServerResponse = -1011,
	NSURLErrorUserCancelledAuthentication = -1012,
	NSURLErrorUserAuthenticationRequired = -1013,
	NSURLErrorZeroByteResource = -1014,
	NSURLErrorFileDoesNotExist = -1100,
	NSURLErrorFileIsDirectory = -1101,
	NSURLErrorNoPermissionsToReadFile = -1102,
	NSURLErrorSecureConnectionFailed = -1200,
	NSURLErrorServerCertificateHasBadDate = -1201,
	NSURLErrorServerCertificateUntrusted = -1202,
	NSURLErrorServerCertificateHasUnknownRoot = -1203,
	NSURLErrorServerCertificateNotYetValid = -1204,
	NSURLErrorClientCertificateRejected = -1205,
	NSURLErrorCannotLoadFromNetwork = -2000,
	NSURLErrorCannotCreateFile = -3000,
	NSURLErrorCannotOpenFile = -3001,
	NSURLErrorCannotCloseFile = -3002,
	NSURLErrorCannotWriteToFile = -3003,
	NSURLErrorCannotRemoveFile = -3004,
	NSURLErrorCannotMoveFile = -3005,
	NSURLErrorDownloadDecodingFailedMidStream = -3006,
	NSURLErrorDownloadDecodingFailedToComplete = -3007
}
#endif


