
#import "AttachmentMailViewController_iPad.h"
#import "ShowMailViewController_iPad.h"
#import "Define.h"
#import "CommonUtil.h"
#import "SharpScanPrintAppDelegate.h"
#import "RootViewController_iPad.h"
#import "PrintPictViewController_iPad.h"
#import "MailServerData.h"
#import "MailServerDataManager.h"
#import <Foundation/NSRegularExpression.h>
#import <QuartzCore/QuartzCore.h>

@interface ShowMailViewController_iPad ()

@property (nonatomic,assign) BOOL isCanceled;
@property (nonatomic,assign) BOOL isFirstLoad;
@property (nonatomic,assign) BOOL isImageLoaded;
@property (nonatomic,assign) BOOL hasImgData;
@property (nonatomic,assign) BOOL hasAttFile;

@end

@implementation ShowMailViewController_iPad

@synthesize messageListView;
@synthesize emailBody;
@synthesize imageToolBar;
@synthesize imageOnOffButton;
@synthesize imageAttachButton;
@synthesize imageSelectButton;
@synthesize uid;
@synthesize imageOn;
@synthesize attachMove;
@synthesize attachFileName;
@synthesize m_pstrSelectedMail;
@synthesize delegate;
@synthesize attachmentDirectory;

#define kWebViewButtonSize              CGSizeMake(60, 40)              // 戻る、進むボタンのサイズ
#define kURLTextFieldSizeHeight         30.0f                           // URL入力欄の(テキストフィールド)高さ
#define kURLRequestTimeoutInterval      60.0f                           // リクエストタイムアウト(秒)

- (id)init
{
    self = [super init];
    if (self) {
        // Initialization code
        imageOn = NO;
        attachMove = NO;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // imgタグの画像を表示しないようにキャッシュのURLを変更する
    [self cacheBlock];
    
    // タイトル設定
    CGRect frame = CGRectMake(0, 0, 400, 44);
    UILabel* lblTitle = [[UILabel alloc]initWithFrame:frame];
    lblTitle.backgroundColor = [UIColor clearColor];
    lblTitle.textColor = NAVIGATION_TITLE_COLOR;
    lblTitle.font = [UIFont boldSystemFontOfSize:20];
    lblTitle.textAlignment = NSTextAlignmentCenter;
    lblTitle.text = S_TITLE_EMAIL_PRINT;
    lblTitle.adjustsFontSizeToFitWidth = YES;
    self.navigationItem.titleView = lblTitle;
    
    // メインビュー初期化
    // iPad用 戻るボタン表示(横向き右側の場合非表示)
    self.navigationItem.hidesBackButton = NO;
    
    UIBarButtonItem * barItemBack = [[UIBarButtonItem alloc] initWithTitle:S_BUTTON_BACK style:UIBarButtonItemStylePlain target:self action:@selector(backBtnAction)];
    
    self.navigationItem.backBarButtonItem = barItemBack;
    [self.navigationItem setLeftBarButtonItem: barItemBack];
    
    // 閉じるボタン追加
    UIBarButtonItem* btnClose = [[UIBarButtonItem alloc] initWithTitle:S_BUTTON_CLOSE style:UIBarButtonItemStylePlain target:self action:@selector(cancelAction)];
    [self.navigationItem setRightBarButtonItem: btnClose];
    
    m_print = NO;
    m_related = NO;
    
    self.isCanceled = NO;
    self.isFirstLoad = YES;
    self.isImageLoaded = NO;
    self.hasImgData = NO;
    self.hasAttFile = NO;
    self.mailFormatArrayOfPages = [[NSMutableArray alloc]init];
    // Toolbar
    imageToolBar.barStyle = TOOLBAR_BARSTYLE;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    // 縦表示の時はメニューボタンを表示
    [self.navigationItem setLeftBarButtonItem:nil animated:NO];
    SharpScanPrintAppDelegate* pAppDelegate = (SharpScanPrintAppDelegate*)[[UIApplication sharedApplication] delegate];
    [pAppDelegate setPortraitMenuButton];
    // iPad用
    [imageOnOffButton setTitle: nil];
    [imageOnOffButton setImage:[UIImage imageNamed:S_ICON_PRINT_ACQUIRE]];
    [imageAttachButton setTitle: nil];
    [imageAttachButton setImage:[UIImage imageNamed:S_ICON_PRINT_ATTACHED]];
    [imageSelectButton setTitle: nil];
    [imageSelectButton setImage:[UIImage imageNamed:S_ICON_PRINT_SELECT]];

    if (!self.attachMove) {
        // しばらくお待ちくださいダイアログを出す（メール開封時）
        [self createProgressionAlertWithMessage:nil message: MSG_WAIT withCancel:YES];
    }
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self performSelectorInBackground:@selector(bkMethod) withObject:nil];
}

- (void)bkMethod {
    if (!self.attachMove) {
        // 画面遷移後に画像を取得する
        self.account = [self mailServerConnect];
        if(self.account) {
            // Webビューのデリゲートを指定
            emailBody.delegate = self;
            
            // データ取得
            [self getMailMessage];
            [self setImageFlags];
            
            // データ取得完了のため、切断しておく
            if([self.account isConnected]){
                [self.account disconnect];
            }
            self.account = nil;
            
            [self.inbox disconnect];
            self.inbox = nil;
            
        } else {
            if (alert != nil && (int)alert.tag == 10) {
                [alert dismissViewControllerAnimated:YES completion:^{
                }];
                alert = nil;
            }
        }
    }
}

- (void)viewDidDisappear:(BOOL)animated
{
    // アラートが出ているなら消しておく
    [alert dismissViewControllerAnimated:YES completion:^{
    }];
    
    [super viewDidDisappear:animated];
}

- (void)dealloc
{
    cache.bImageOff = NO;
    [cache removeAllCachedResponses];
    self.delegate = nil;
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

-(void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)FromInterfaceOrientation
{
    if (FromInterfaceOrientation == UIInterfaceOrientationPortrait ||
        FromInterfaceOrientation == UIInterfaceOrientationPortraitUpsideDown)
	{
		// 縦向き
	}
	else
	{
		// 横向きから縦向きに変更
        [self setPortraitMenu:nil];
        // 戻るボタンを表示
        UIBarButtonItem * barItemBack = [UIBarButtonItem new];
        barItemBack.title = S_BUTTON_BACK;
        self.navigationItem.backBarButtonItem = barItemBack;
	}
}

// iPad用
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // 横向きの場合
    if(interfaceOrientation == UIInterfaceOrientationLandscapeLeft || interfaceOrientation == UIInterfaceOrientationLandscapeRight)
    {
        // 縦向き表示時のメニューPopOverが表示されていたら閉じる
        [self dismissMenuPopOver:NO];
        // メニューボタンは削除
        [self setPortraitMenu:nil];
    }
    
    return YES;
}

#pragma mark - create pdf
// Webページ印刷
- (void)creatMailPdfPages {
    // 印刷用に拡大なしで再読み込み
    m_print = YES;

    //TODO: 遷移する
    if (self.delegate == nil) {
        // printSelectで開いているので、先に遷移させる
        NSNotification *n = [NSNotification notificationWithName:MP_ENTER_BUTTON_PUSHED1 object:self];
        NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
        [nc postNotification:n];
    }
    
//    [self performSelector:@selector(creatMailPdfPages2) withObject:nil afterDelay:1.0];
    // iPad用
    [self creatMailPdfPages2];

}

- (void)creatMailPdfPages2 {
    
    // ---------- 描画準備処理 ----------
    NSString * widthStr = [emailBody stringByEvaluatingJavaScriptFromString: @"document.body.scrollWidth;"];
    NSString * heightStr = [emailBody stringByEvaluatingJavaScriptFromString: @"document.body.scrollHeight;"];
    
	int pageWidth = [widthStr intValue];
	int pageHeight = [heightStr intValue];
    
    if (pageWidth == 0 || pageHeight == 0) {
        
        // 印刷不可アラート表示
        [self showAlertForPrintError];
        
        return;
    }
    
    // 横サイズ決定
    int pdfWidth = pageWidth;
    
    // 横サイズを基準に縦サイズを決める(横 : 縦 = 1 : √2)
    double pdfHeight = pageWidth * sqrt(2.0f);
    
    // ページ数を算出(端数切り上げ)
	pages = ceil(pageHeight / pdfHeight);
    
    // 最終ページの高さ
    int pdfLastPageHeight = ceil(pageHeight % (int)pdfHeight);
    
    UIScrollView * scrollViewInWebView = nil;
    
    if ([[[emailBody subviews] lastObject] isKindOfClass: [UIScrollView class]]) {
        // UIWebView内のスクロールビューを取得する
        // (UIWebViewのscrollViewプロパティはiOS4.3で使用不可のためこの方法で取得する)
        scrollViewInWebView = [[emailBody subviews] lastObject];
    }
    // スクロールビューが取得出来なかった場合
    else {
        // ありえないはず
        return;
    }
    
    // ズームスケールを保持
    CGFloat minZoomScale = scrollViewInWebView.minimumZoomScale;
    CGFloat maxZoomScale = scrollViewInWebView.maximumZoomScale;
    CGFloat zoomScale = scrollViewInWebView.zoomScale;
    
    // 背景色を保持
    UIColor * backgroundColor = emailBody.backgroundColor;
    
    // 最終ページの余白部分に印刷される色を調整
    emailBody.backgroundColor = [UIColor whiteColor];
    
    // アスペクト取得
    CGFloat ratioAspect = pdfWidth / scrollViewInWebView.contentSize.width;
    
    // アクペクトからズームを調整
    // （ユーザーのピンチ操作後にWebViewのframeを変更すると画面が崩れるのでズームで対応する）
    scrollViewInWebView.minimumZoomScale = scrollViewInWebView.minimumZoomScale * ratioAspect;
    scrollViewInWebView.maximumZoomScale = scrollViewInWebView.maximumZoomScale * ratioAspect;
    [scrollViewInWebView setZoomScale: (scrollViewInWebView.zoomScale * ratioAspect)
                             animated: NO];
    
    // WebViewの表示状態を保持
    CGPoint webViewContentsOffset = scrollViewInWebView.contentOffset;

    // ---------- 描画処理 ----------
    
    // PDFファイル出力開始
    UIGraphicsBeginPDFContextToFile([self getSavePdfFilePath], CGRectZero, nil);
    
	for (int i = 0; i < pages; i++) {
        CGFloat pageHeight = pdfHeight;
        
        // PDF 1ページ分のサイズを設定する
        UIGraphicsBeginPDFPageWithInfo(CGRectMake(0, 0, pdfWidth, pageHeight), nil);
        
        // コンテキスト取得
		CGContextRef currentContext = UIGraphicsGetCurrentContext();
        for (int y = 0; y < pdfHeight; y += emailBody.frame.size.height) {
            
            for (int x = 0; x < pdfWidth; x += emailBody.frame.size.width) {
                //DLog(@"x %d, y %d", x, y);
                //DLog(@"x %d, y + (pdfHeight * i) %f", x, y + (pdfHeight * i));
                
                // コンテキストに描画する位置を調整する
                CGContextTranslateCTM(currentContext, x, y);
                
                // ページ毎にキャプチャー位置をずらす(WebViewをスクロールさせていく)
                [scrollViewInWebView setContentOffset: CGPointMake(x, y + (pdfHeight * i))
                                             animated: NO];
                
                // WebViewに表示しているコンテキストを描画
                [emailBody.layer renderInContext: currentContext];
                
                // コンテキストに描画する位置を元に戻す
                // （移動は相対的に行わないといけない。
                // 　連続して位置を調整する場合は別途計算が必要なので一旦元の位置に戻す）
                CGContextTranslateCTM(currentContext, -x, -y);
            }
        }
        
        // 最終ページの場合
        if (i + 1 == pages) {
            // 余白の高さ
            CGFloat spaceHeight = (pdfHeight - pdfLastPageHeight);
            
            // 余白を塗りつぶす色
            CGContextSetFillColorWithColor(currentContext, [UIColor whiteColor].CGColor);
            
            // 余白塗りつぶし
            CGContextFillRect(currentContext, CGRectMake(0,
                                                         pdfHeight - spaceHeight,
                                                         pdfWidth,
                                                         spaceHeight));
        }
    }
    
    // PDF出力終了
	UIGraphicsEndPDFContext();
    
    // ---------- 描画後始末処理 ----------
    
    // WebViewを初期設定に戻す
    scrollViewInWebView.contentOffset = webViewContentsOffset;
    
    // 背景色を戻す
    emailBody.backgroundColor = backgroundColor;
    
    // ズームスケールを戻す
    scrollViewInWebView.minimumZoomScale = minZoomScale;
    scrollViewInWebView.maximumZoomScale = maxZoomScale;
    [scrollViewInWebView setZoomScale: zoomScale
                             animated: NO];
    
    // 印刷画面へ遷移
    [self movePrintPictView];
}

#pragma mark move to print view
// 印刷画面へ遷移
- (void)movePrintPictView {
    if(delegate){
        if([delegate respondsToSelector:@selector(mailPrint:upLoadMailView:)])
        {
            // メインスレッドで行う
            [self performSelector:@selector(ActionMainThread) withObject:nil afterDelay:0.1];
        }
    }else {
        NSNotification *n = [NSNotification notificationWithName:MP_ENTER_BUTTON_PUSHED2 object:self];
        NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
        [nc postNotification:n];
        @autoreleasepool {
            // しばらくおまちくださいダイアログを閉じる
            if(alert != nil)
            {
                [alert dismissViewControllerAnimated:YES completion:^{
                }];
                alert = nil;
            }
        }
        
    }
    
}

- (void)ActionMainThread
{
    [self uploadMailView];
    
    // しばらくおまちくださいダイアログを閉じる
    @autoreleasepool {
        if(alert != nil)
        {
            [alert dismissViewControllerAnimated:YES completion:^{
            }];
            alert = nil;
        }
    }
}

-(void)uploadMailView
{
    // デリゲートメソッドの呼び出し(モーダルビューも閉じる)
    [delegate mailPrint:self upLoadMailView:[self getSavePdfFilePath]];
}

// 印刷用PDFファイルの削除
- (void)deletePrintPDFFile {
    
    // PDFファイルを削除
    [[NSFileManager defaultManager] removeItemAtPath: [self getSavePdfFilePath]
                                               error: NULL];
    // attachFile(pdfで利用される画像）の削除
    if(attachFileName)
    {
        for (NSString* attachFile in attachFileName)
        {
            [[NSFileManager defaultManager] removeItemAtPath: [self getSaveAttachFilePathWithFilename:attachFile]
                                                       error: NULL];
            DLog(@"delete imagefile %@", attachFile);
        }
    }
}

// PDF出力ファイルパス取得
- (NSString *)getSavePdfFilePath {
    // PDF出力ファイルパス設定
    TempFile * localTempFile = [[TempFile alloc]initWithPrintDataPdf];
    return localTempFile.tempFilePath;
}

// PDF用画像ファイルの出力先パス取得
- (NSString *)getSaveAttachFilePathWithFilename:(NSString*)attachFilename {
    // PDF出力ファイルパス設定
    TempFile * localTempFile = [[TempFile alloc]initWithFileName:attachFilename];
    return localTempFile.tempFilePath;
}

- (IBAction)imageOnOff:(id)sender {
    
    // しばらくお待ちくださいダイアログを出す（画像取得時）
    [self createProgressionAlertWithMessage:nil message: MSG_WAIT withCancel:NO];
    
    // imgタグを表示できるように戻す
    cache.bImageOff = NO;
    [[NSURLCache sharedURLCache] removeAllCachedResponses];
    
    // imgを表示するフラグをオンにする
    self.imageOn = YES;
    
    // バックグラウンドで読み込む
    [self performSelectorInBackground:@selector(startGetImage) withObject:nil];
}

- (IBAction)imageAttach:(id)sender {
    // しばらくお待ちくださいダイアログを出す（メール開封時）
    [self createProgressionAlertWithMessage:nil message: MSG_WAIT withCancel:NO];
    
    [self performSelector:@selector(imageAttach) withObject:nil afterDelay:0.5];
}

- (void)imageAttach
{
    // 添付ファイルをダウンロード
    [self downloadAttachmentFile];
    
    // メール本文印刷画面経由で、添付ファイルイメージボタンを押下した場合
    if (self.delegate) {
        // 遷移元画面から渡されたIDをもとに遷移先のViewControllerを決定する
        AttachmentMailViewController_iPad* pViewController = nil;
        
        pViewController = [[AttachmentMailViewController_iPad alloc] init];
        pViewController.delegate = self.delegate;
        //メール添付ファイル表示画面への遷移時にメール添付のルートディレクトリを渡します
        pViewController.attachmentDirectory = [[TempAttachmentDirectory alloc]initWithDirectoryPath:[TempAttachmentFileUtility getRootDir]];

        // 添付ファイル一覧遷移フラグをオンにする
        self.attachMove = YES;
        
        // しばらくおまちくださいダイアログを閉じる
        [alert dismissViewControllerAnimated:YES completion:^{
            //*** 一旦、モーダルを閉じて、別モーダルで添付ファイル一覧を表示する
            if([delegate respondsToSelector:@selector(mailPrint:showAttachmentMailView:)]){
                // デリゲートメソッドの呼び出し(モーダルビューも閉じる)
                [delegate mailPrint:self showAttachmentMailView:pViewController];
            }
        }];
        
    }else {
        // しばらくおまちくださいダイアログを閉じる
        [alert dismissViewControllerAnimated:YES completion:^{
            NSNotification *n = [NSNotification notificationWithName:MP_SHOW_ATTACHMENT_BUTTON_PUSHED object:self];
            NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
            [nc postNotification:n];
        }];
    }
    
}

// 選択ボタン
- (IBAction)imageSelect:(id)sender
{
    //連打防止のためボタンを非活性に
    self.imageSelectButton.enabled = NO;
    self.imageOnOffButton.enabled  = NO;
    self.imageAttachButton.enabled = NO;
    
    [self creatMailPdfPages];
}

- (void)startGetImage
{
    self.account = [self mailServerConnect];
    if(self.account) {
        // データ取得
        [self getMailMessage];
        [self setImageFlags];
        
        // データ取得完了のため、切断しておく
        if([self.account isConnected]){
            [self.account disconnect];
        }
        self.account = nil;
        
        [self.inbox disconnect];
        self.inbox = nil;
    }

    // しばらくおまちくださいダイアログを閉じる
    @autoreleasepool {
        if(alert != nil)
        {
            [alert dismissViewControllerAnimated:YES completion:^{
            }];
            alert = nil;
        }
    }
}

-(NSString *)getHTMLString :(NSString *) part{
    CTCoreMessage *aMessage = self.selectedMessage; // 選択した１件分のメール情報
    
    //メールのヘッダ部分の記述をする部分です。
    // get mail_from message
    CTCoreAddress* aFromAddress = [[aMessage from] anyObject]; //first one
    NSString* fromText = [@"" stringByAppendingFormat: @"%@&lt;%@&gt;", [aFromAddress name], [aFromAddress email]];
    DLog(@"from: %@,%@",[aFromAddress name], [aFromAddress email]);
    // make mail_to Text
    NSEnumerator *enumerator = [[aMessage to] objectEnumerator];
    CTCoreAddress* aToAddress = [enumerator nextObject]; //first one
    NSString * nameString = [[NSString alloc]init];
    NSString * emailString = [[NSString alloc]init];
    if(![aToAddress name]){
        nameString = @"";
    }
    if(![aToAddress email]){
        emailString = @"";
    }
    NSString* toText = [@"" stringByAppendingFormat:@"%@&lt;%@&gt;",nameString,emailString];
    DLog(@"  to: %@,%@",[aToAddress name], [aToAddress email]);
    
    while ((aToAddress = [enumerator nextObject]) != nil) {
        toText = [toText stringByAppendingFormat: @",%@&lt;%@&gt;",nameString, emailString];
    }
    // make mail_cc Text
    NSEnumerator *enumeratorCc = [[aMessage cc] objectEnumerator];
    CTCoreAddress* aCcAddress = [enumeratorCc nextObject]; //first one
    NSString* ccText = [@"" stringByAppendingFormat:@"%@&lt;%@&gt;", [aCcAddress name], [aCcAddress email]];
    DLog(@"  cc: %@,%@",[aCcAddress name], [aCcAddress email]);
    Boolean* existCc = false;
    if(aCcAddress){  //first oneの時点でCcが存在するか判定する
        existCc = true;
    }
    while ((aCcAddress = [enumeratorCc nextObject]) != nil) {
        ccText = [ccText stringByAppendingFormat: @",%@&lt;%@&gt;", [aCcAddress name], [aCcAddress email]];
    }
    // 日付のフォーマット指定
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setLocale:[NSLocale systemLocale]];        // 12時間表示にならないように
    [formatter setTimeZone:[NSTimeZone systemTimeZone]];  // localeを再設定する。
    [formatter setDateFormat:@"yyyy/MM/dd HH:mm:ss"];
    NSString* dateText;
    if([aMessage senderDate] != nil)
    {
        dateText = [NSString stringWithString:[formatter stringFromDate:[aMessage senderDate]]];
    }else
    {
        dateText = @"";
    }
    
    NSString* emailLabelForm = nil;
    if(existCc == false)
    {
        emailLabelForm = [@" " stringByAppendingFormat: @"%@: %%@\n %@: %%@\n %@: %%@\n %@: %%@",
                          S_EMAIL_HEADER_SUBJECT,
                          S_EMAIL_HEADER_FROM,
                          S_EMAIL_HEADER_DATE,
                          S_EMAIL_HEADER_TO];
    }else{
        emailLabelForm = [@" " stringByAppendingFormat: @"%@: %%@\n %@: %%@\n %@: %%@\n %@: %%@\n %@: %%@",
                          S_EMAIL_HEADER_SUBJECT,
                          S_EMAIL_HEADER_FROM,
                          S_EMAIL_HEADER_DATE,
                          S_EMAIL_HEADER_TO,
                          S_EMAIL_HEADER_CC];
    }
    
    NSString* headerTextRapper = @"<pre>%@</pre><hr style='background:#A0A0B0; border:0; height:1px' />";
    NSString* plainTextForm  = @"<html><head></head><body><table><tr><td style=\"width: 600px;word-break: break-all;\">%@</td></tr></table></div></body></html>";
    NSString* headerText = [[NSString alloc]initWithFormat: emailLabelForm,
                            [aMessage subject],
                            fromText,
                            dateText,
                            toText,
                            ccText
                            ];
    
    headerText = [@"" stringByAppendingFormat:headerTextRapper, headerText];
    
    NSString* messageText = [aMessage body];
    DLog(@"message body \n %@",messageText);
    NSString* htmlText    = [aMessage htmlBody];
    
    // plain textならばHTML化する
    if(htmlText == nil || [htmlText isEqualToString:@""])
    {
        // 空白と改行を置換する
        messageText = [messageText stringByReplacingOccurrencesOfString:@"\n" withString:@"<BR>"];
        messageText = [messageText stringByReplacingOccurrencesOfString:@" " withString:@"&nbsp;"];
        
        htmlText = [[NSString alloc] initWithFormat: plainTextForm, messageText];
    }
    
    // contentTypeを取得するおまじない
    [aMessage fetchBodyStructure];
    // contentTypeを取得する
    NSString* m_pstrContentType = [aMessage.mime.content contentType];
    DLog(@"m_pstrContentType:%@",m_pstrContentType);
    
    // text/html、text/plain、multipartを含むcontentType以外の場合は、本文の表示対象外とする
    if([m_pstrContentType isEqualToString:@"text/html"] || [m_pstrContentType isEqualToString:@"text/plain"] || [m_pstrContentType hasPrefix:@"multipart"] )
    {
        
        if ([m_pstrContentType isEqualToString:@"multipart/related"]) {
            m_related = YES;
        }
        // HTMLにヘッダー情報を追加する(<body>タグの直後に挿入)
        NSString *headerTemplate = [@"$1" stringByAppendingString: headerText];
        NSError *error = NULL;
        NSRegularExpression *regexHeader = [NSRegularExpression regularExpressionWithPattern: @"(<body[^>]*>)"
                                                                                     options: nil
                                                                                       error: &error];
        DLog(@"htmlText:%@",htmlText);
        
        NSTextCheckingResult *match = [regexHeader firstMatchInString:htmlText
                                                              options:0
                                                                range:NSMakeRange(0,[htmlText length])];
        if (!match) {// multipart/mixedでbodyタグがない場合
            // htmlタグ、bodyタグをつける
            htmlText = [NSString stringWithFormat:@"<html><body>%@</body></html>",htmlText];
            DLog(@"htmlText:%@",htmlText);
        }
        htmlText = [regexHeader stringByReplacingMatchesInString: htmlText
                                                         options: 0
                                                           range: NSMakeRange(0, [htmlText length])
                                                    withTemplate: headerTemplate];
    }
    if([part isEqualToString:@"header"]){
        return headerText;
    }else
    return htmlText;
}

- (void)setImageFlags {
    int mountedImagesNumber = 0;
    NSUInteger attachedImagesNumber = 0;
    int attachedNotImageNumber = 0;
    NSUInteger imgTagCount;
    NSOperationQueue *queue = [NSOperationQueue mainQueue];
    CTCoreMessage *aMessage = self.selectedMessage; // 選択した１件分のメール情報
    
    // get mail_from message
    CTCoreAddress* aFromAddress = [[aMessage from] anyObject]; //first one
    NSString* fromText = [@"" stringByAppendingFormat: @"%@&lt;%@&gt;", [aFromAddress name], [aFromAddress email]];
    DLog(@"from: %@,%@",[aFromAddress name], [aFromAddress email]);
    // make mail_to Text
    NSEnumerator *enumerator = [[aMessage to] objectEnumerator];
    CTCoreAddress* aToAddress = [enumerator nextObject]; //first one
    NSString* toText = [@"" stringByAppendingFormat:@"%@&lt;%@&gt;", [aToAddress name], [aToAddress email]];
    DLog(@"  to: %@,%@",[aToAddress name], [aToAddress email]);
    while ((aToAddress = [enumerator nextObject]) != nil) {
        toText = [toText stringByAppendingFormat: @",%@&lt;%@&gt;", [aToAddress name], [aToAddress email]];
    }
    // make mail_cc Text
    NSEnumerator *enumeratorCc = [[aMessage cc] objectEnumerator];
    CTCoreAddress* aCcAddress = [enumeratorCc nextObject]; //first one
    NSString* ccText = [@"" stringByAppendingFormat:@"%@&lt;%@&gt;", [aCcAddress name], [aCcAddress email]];
    DLog(@"  cc: %@,%@",[aCcAddress name], [aCcAddress email]);
    Boolean* existCc = false;
    if(aCcAddress != nil){  //first oneの時点でCcが存在するか判定する
        existCc = true;
    }
    while ((aCcAddress = [enumeratorCc nextObject]) != nil) {
        ccText = [ccText stringByAppendingFormat: @",%@&lt;%@&gt;", [aCcAddress name], [aCcAddress email]];
    }
    // 日付のフォーマット指定
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setLocale:[NSLocale systemLocale]];        // 12時間表示にならないように
    [formatter setTimeZone:[NSTimeZone systemTimeZone]];  // localeを再設定する。
    [formatter setDateFormat:@"yyyy/MM/dd HH:mm:ss"];
    NSString* dateText;
    if([aMessage senderDate] != nil)
    {
        dateText = [NSString stringWithString:[formatter stringFromDate:[aMessage senderDate]]];
    }else
    {
        dateText = @"";
    }
    
    NSString* emailLabelForm = nil;
    if(existCc == false)
    {
        emailLabelForm = [@" " stringByAppendingFormat: @"%@: %%@<BR> %@: %%@<BR> %@: %%@<BR> %@: %%@",
                          S_EMAIL_HEADER_SUBJECT,
                          S_EMAIL_HEADER_FROM,
                          S_EMAIL_HEADER_DATE,
                          S_EMAIL_HEADER_TO];
    }else{
        emailLabelForm = [@" " stringByAppendingFormat: @"%@: %%@<BR> %@: %%@<BR> %@: %%@<BR> %@: %%@<BR> %@: %%@",
                          S_EMAIL_HEADER_SUBJECT,
                          S_EMAIL_HEADER_FROM,
                          S_EMAIL_HEADER_DATE,
                          S_EMAIL_HEADER_TO,
                          S_EMAIL_HEADER_CC];
    }
    
    NSString* headerTextRapper = @"<table><tr><td style=\"word-break: break-all; line-height: 26px;\"><font size=\"4\">%@</font></td></tr></table><hr style='background:#A0A0B0; border:0; height:1px' />";
    NSString* plainTextForm  = @"<html><head></head><body><table><tr><td style=\"word-break: break-all;\"><font size=\"4\">%@</font></td></tr></table></div></body></html>";
    NSString* headerText = [[NSString alloc]initWithFormat: emailLabelForm,
                            [aMessage subject],
                            fromText,
                            dateText,
                            toText,
                            ccText
                            ];
    
    headerText = [@"" stringByAppendingFormat:headerTextRapper, headerText];
    
    NSString* messageText = [aMessage body];
    DLog(@"message body \n %@",messageText);
    NSString* htmlText    = [aMessage htmlBody];
    
    NSArray* attFiles = [aMessage attachments]; //添付ファイルリスト
    // TODO:印刷対象外のファイルもカウントしているので要変更
    DLog(@"Number of attachment [%lu]",(unsigned long)[attFiles count]);
    DLog(@"Attachment [%@]",attFiles);
    
    // plain textならばHTML化する
    
    
    if(htmlText == nil || [htmlText isEqualToString:@""])
    {
        self.mailFormat = @"text";
        // 空白と改行を置換する
        messageText = [messageText stringByReplacingOccurrencesOfString:@"\n" withString:@"<BR>"];
        messageText = [messageText stringByReplacingOccurrencesOfString:@" " withString:@"&nbsp;"];
        
        htmlText = [[NSString alloc] initWithFormat: plainTextForm, messageText];
    } else {
        self.mailFormat = @"html";
    }
    
    // contentTypeを取得するおまじない
    [aMessage fetchBodyStructure];
    // contentTypeを取得する
    NSString* m_pstrContentType = [aMessage.mime.content contentType];
    DLog(@"m_pstrContentType:%@",m_pstrContentType);

    // text/html、text/plain、multipartを含むcontentType以外の場合は、本文の表示対象外とする
    if([m_pstrContentType isEqualToString:@"text/html"] || [m_pstrContentType isEqualToString:@"text/plain"] || [m_pstrContentType hasPrefix:@"multipart"] )
    {
        
        if ([m_pstrContentType isEqualToString:@"multipart/related"]) {
            m_related = YES;
        }
        // HTMLにヘッダー情報を追加する(<body>タグの直後に挿入)
        NSString *headerTemplate = [@"$1" stringByAppendingString: headerText];
        NSError *error = NULL;
        NSRegularExpression *regexHeader = [NSRegularExpression regularExpressionWithPattern: @"(<body[^>]*>)"
                                                                                     options: nil
                                                                                       error: &error];
        DLog(@"htmlText:%@",htmlText);
        
        NSTextCheckingResult *match = [regexHeader firstMatchInString:htmlText
                                                              options:0
                                                                range:NSMakeRange(0,[htmlText length])];
        if (!match) {// multipart/mixedでbodyタグがない場合
            // htmlタグ、bodyタグをつける
            htmlText = [NSString stringWithFormat:@"<html><body>%@</body></html>",htmlText];
            DLog(@"htmlText:%@",htmlText);
        }
        
        htmlText = [regexHeader stringByReplacingMatchesInString: htmlText
                                                         options: 0
                                                           range: NSMakeRange(0, [htmlText length])
                                                    withTemplate: headerTemplate];
        
        NSRegularExpression *regexImageIndex = [NSRegularExpression regularExpressionWithPattern: @"cid:([^@]*)[^'\"]*"
                                                                                         options: NSRegularExpressionCaseInsensitive
                                                                                           error: &error];
        NSRegularExpression *regexImageSub = [NSRegularExpression regularExpressionWithPattern: @"cid:([^@]*)@.*"
                                                                                       options: NSRegularExpressionCaseInsensitive
                                                                                         error: &error];
        NSUInteger cidCount = [regexImageIndex numberOfMatchesInString:htmlText options:nil range: NSMakeRange(0, [htmlText length])];
        
        //cidを取ってくる
        NSArray *matches = [regexImageIndex matchesInString:htmlText
                                                    options:0
                                                      range:NSMakeRange(0, [htmlText length])];
        attachFileName = [[NSMutableArray alloc] init];
        NSMutableArray * cidArray = [[NSMutableArray alloc]init];
        for (NSTextCheckingResult *match in matches) {
            DLog(@"attachment range = %@", match);
            NSString* cidString = [htmlText substringWithRange: [match range]];
            [cidArray addObject:cidString];
            DLog(@"attachment strings = %@", cidString);
            [attachFileName addObject:
             [regexImageSub stringByReplacingMatchesInString: cidString
                                                     options: 0
                                                       range: NSMakeRange(0, [cidString length])
                                                withTemplate: @"$1"]];
        }
        
        DLog(@"cid count = %lu", (unsigned long)cidCount);
        DLog(@"attachment name = \n %@ \n\n", attachFileName);
        
        // 正規表現のオブジェクトを生成する。
        // imgタグが対象htmlに含まれているかを確認する
        // (?i):大文字小文字を区別しない
        NSRegularExpression *regexp01 = [NSRegularExpression regularExpressionWithPattern:@"(<)((?i)img.*?src)(.*?)(>)"
                                                                                  options: NSRegularExpressionCaseInsensitive
                                                                                    error: &error];
        
        
        // 正規表現にマッチした件数分、結果が取得できる。
        imgTagCount = [regexp01 numberOfMatchesInString:htmlText
                                                options:0
                                                  range:NSMakeRange(0, [htmlText length])];
        DLog(@"imgTagCount = %lu",(unsigned long)imgTagCount);
        
        // TempAttachmentFileフォルダーにファイルがあれば削除
        [[NSFileManager defaultManager] removeItemAtPath:[CommonUtil tmpAttachmentDir] error:NULL];	// ディレクトリ削除
        
        // image表示の場合アタッチメントを取り出し、一時ファイルに置きHTMLファイルのイメージ参照先を変更する。
        
        NSArray* att = [aMessage attachments];
        DLog(@"Number of attachment [%lu]",(unsigned long)[att count]);
        DLog(@"Attachment [%@]",att);
        
        attachedImagesNumber = att.count;
        for(int i = 0; i < att.count; i++)
        {
            //埋め込み画像名取得のためMIMEを取得
            CTMIME_SinglePart * singlePart = [[att objectAtIndex:i] part];
            CTCoreAttachment* ctat = [[att objectAtIndex:i] fetchFullAttachment];
            NSString* nstr = [ctat decodedFilename];
            if (![CommonUtil extensionFileCheck:nstr]) {
                attachedNotImageNumber ++;
            }
            if(singlePart.contentId){
                mountedImagesNumber ++;

                CTCoreAttachment* ctat = [[att objectAtIndex:i] fetchFullAttachment];
                NSString* nstr = [ctat decodedFilename];
                //印刷可能な拡張子の場合
                if ([nstr hasSuffix:@".zip"]){
                    attachedImagesNumber ++;
                }
            }
        }
        if (imageOn && cidCount > 0) {
            // image表示の場合アタッチメントを取り出し、一時ファイルに置きHTMLファイルのイメージ参照先を変更する。
            
            NSArray* att = [aMessage attachments];
            DLog(@"Number of attachment [%lu]",(unsigned long)[att count]);
            DLog(@"Attachment [%@]",att);

            NSString *documentRoot  = [TempFile getTmpDir];
            if ([att count] > 0)
            {
                for(int i = 0; i < [att count]; i++)
                {
                    //埋め込み画像名取得のためMIMEを取得
                    CTMIME_SinglePart * singlePart = [[att objectAtIndex:i] part];
                    NSString *fileNameFromCTCore;
                    if(singlePart.contentId){
                        if(!singlePart.filename){
                            fileNameFromCTCore =[CommonUtil createFileName:@".img"];
                        }
                        else{
                            fileNameFromCTCore = singlePart.filename;
                        }
                        CTCoreAttachment* ctat = [[att objectAtIndex:i] fetchFullAttachment];
                        NSString* attachedImageNameFromCTCore;
                        //cid:を含むファイル名（と扱われているが画像ファイルの名前でないもの）を取得する。
                        attachedImageNameFromCTCore = [@"cid:" stringByAppendingString: singlePart.contentId];
                        attachedImageNameFromCTCore = [attachedImageNameFromCTCore stringByReplacingOccurrencesOfString:@"<" withString:@""];
                        attachedImageNameFromCTCore = [attachedImageNameFromCTCore stringByReplacingOccurrencesOfString:@">" withString:@""];
                        //CTCoreクラスにより画像の実データを取得し、htmlの当該部分を書き換える
                        [ctat writeToFile:[documentRoot stringByAppendingPathComponent:fileNameFromCTCore]];
                        NSString *imageFilePath = [[@"file://" stringByAppendingFormat:@"%@/",documentRoot] stringByAppendingString:fileNameFromCTCore];
                        htmlText = [htmlText stringByReplacingOccurrencesOfString:attachedImageNameFromCTCore withString:imageFilePath];
                    }
                }
            }
        }
        
    } else {
        // ヘッダーのみ表示する
        htmlText = headerText;
        [self showAlertError:MSG_MAIL_NOTSUPPORT_ERR];
    }
    
    //表示用フラグを更新する webからのimg埋め込みまたは画像の埋め込みがある場合
    if(imgTagCount > 0 || mountedImagesNumber > 0){
        self.hasImgData = YES;
    }
    //添付画像の数＝（CTCoreが返してくる総画像数-実際埋め込まれているcidを持ってる画像数-in line など名無しattached fileの数）
    if(attachedImagesNumber - mountedImagesNumber -attachedNotImageNumber > 0){
        self.hasAttFile = YES;
    }
    // キャンセルが押されたかどうかの分岐処理
    if (self.isCanceled == NO) {
        [queue addOperationWithBlock:^(){
            [self.emailBody loadHTMLString: htmlText baseURL: nil];
        }];
        self.isFirstLoad = NO;
        if (imageOn) {
            // 画像を取得したのでOFF
            self.isImageLoaded = YES;
        }
    }
    [self performSelectorOnMainThread: @selector(updateToolBar)
                           withObject: nil
                        waitUntilDone: YES];
    if (self.isCanceled) {
        if (alert != nil) {
            [alert dismissViewControllerAnimated:YES completion:^{
            }];
        }
    }
}

// 添付ファイルをダウンロード
- (void)downloadAttachmentFile
{
    // TempAttachmentFileフォルダーがなかったら作成
    [TempAttachmentFileUtility createRequiredDirectories];
    NSString* attachmentfile = [TempAttachmentFileUtility getRootDir];
    CTCoreMessage *aMessage = self.selectedMessage; // 選択した１件分のメール情報
    
    // contentTypeを取得するおまじない

    NSArray* att = [aMessage attachments];

    if ([att count] > 0 )
    {
        for(int i = 0; i < [att count]; i++)
        {
            
            //埋め込み画像名取得のためMIMEを取得
            CTMIME_SinglePart * singlePart = [[att objectAtIndex:i] part];
            if(!singlePart.contentId && singlePart.filename){
                CTCoreAttachment* ctat = [[att objectAtIndex:i] fetchFullAttachment];
                NSString* nstr = [ctat decodedFilename];
                //印刷可能な拡張子の場合 or ZIP形式の場合 一時的にファイルに書き出す
                if ([CommonUtil extensionFileCheck:nstr]) {
                    [ctat writeToFile:[attachmentfile stringByAppendingPathComponent:nstr]];
                }else if ([nstr hasSuffix:@".zip"]){
                    NSString * path = [attachmentfile stringByAppendingPathComponent: [NSString stringWithFormat:@"DIR-%@", nstr]];
                    [ctat writeToFile:path];
                }
            }
        }
    }
    if(self.account){
        [self.account performSelectorInBackground:@selector(disconnect) withObject:nil];
    }
}

- (void)updateToolBar {
    [self.imageOnOffButton setEnabled:NO];
    [self.imageSelectButton setEnabled:YES];
    [self.imageAttachButton setEnabled:NO];
    
    if (self.isCanceled && self.isFirstLoad) {
        [self.imageSelectButton setEnabled:NO];
    }
    
    if (self.isImageLoaded == NO && self.hasImgData) {
        self.imageOn = NO;
        if (!self.isCanceled) {
            [self.imageOnOffButton setEnabled:YES];
        }
    }
    
    if (self.hasAttFile) {
        if (!self.isCanceled) {
            [self.imageAttachButton setEnabled:YES];
        }
    }
}

// 縦表示時のメニューボタン設定
- (void)setPortraitMenu:(UIBarButtonItem *)barButtonItem
{
    if (barButtonItem != nil) {
        barButtonItem.title = S_BUTTON_FILE_LIST;
        [self.navigationItem setLeftBarButtonItem:barButtonItem animated:YES];
    }
}
// iPad用

- (CTCoreAccount*)mailServerConnect
{
    CTCoreAccount* anAccount = [[CTCoreAccount alloc] init];
    MailServerDataManager* manager = [[MailServerDataManager alloc]init];
    MailServerData* mailServerData = [manager loadMailServerDataAtIndex:0];
    
    BOOL noError;
    if((mailServerData.accountName == nil) || (mailServerData.accountPassword == nil))
    {
        noError = NO;
    }
    else
    {
        NSDictionary *dicIPAddr = [CommonUtil getIPAddrDicForComm:mailServerData.hostname port:mailServerData.imapPortNo];
        NSString *strIPaddr = [dicIPAddr objectForKey:S_TARGET_IPADDRESS_DIC_KEY];
#ifdef IPV6_VALID
        if ([CommonUtil isValidIPv6StringFormat:strIPaddr]) {
            // IPv6アドレスの場合は非省略形式にする
            strIPaddr = [CommonUtil convertOmitIPv6ToFullIPv6:strIPaddr];
        }
#endif
        if ([strIPaddr length] < 1) {
            noError = NO;
        }
        else {
            noError =
            [anAccount connectToServer: strIPaddr
                                  port: [mailServerData.imapPortNo intValue]
                        connectionType: (mailServerData.bSSL)?CONNECTION_TYPE_TLS:CONNECTION_TYPE_PLAIN
                              authType: IMAP_AUTH_TYPE_PLAIN
                                 login: [CommonUtil decryptString:[CommonUtil base64Decoding:mailServerData.accountName] withKey:S_KEY_PJL]
                              password: [CommonUtil decryptString:[CommonUtil base64Decoding:mailServerData.accountPassword] withKey:S_KEY_PJL]
             ];
        }
    }
    
    DLog(@"(show)account = %@",anAccount);
    DLog(@"getmail access server %@%@", (noError == YES)?@"OK.":@"NG\n error = ",anAccount.lastError);
    if(noError)
    {
        return anAccount;
    }
    else
    {
        [self popupSendingErrorAlertError: anAccount.lastError];
        return nil;
    }
}

// メールを取得する
- (void)getMailMessage
{
    //CTCoreFolder *inbox;
    self.inbox = [self.account folderWithPath:m_pstrSelectedMail];
    if(self.inbox) {
        self.selectedMessage = [self.inbox messageWithUID:uid];
        //[inbox disconnect];
    }

}

- (void)popRootView
{
    [self.navigationController popToRootViewControllerAnimated:YES];
}

- (void) dismissMenuPopOver:(BOOL)bAnimated
{
    SharpScanPrintAppDelegate* pAppDelegate = (SharpScanPrintAppDelegate*)[[UIApplication sharedApplication] delegate];
    UINavigationController* pRootNavController = [pAppDelegate.splitViewController.viewControllers objectAtIndex:0];
    RootViewController_iPad* rootViewController = (RootViewController_iPad*)[pRootNavController.viewControllers objectAtIndex:0];
    
    // 縦向き表示時のメニューPopOverが表示されていたら閉じる
    [rootViewController dismissMenuPopOver:bAnimated];
}
//iPad用

-(void)popupSendingErrorAlertError:(NSError*) conError
{
    SharpScanPrintAppDelegate* appDelegate = (SharpScanPrintAppDelegate*)[[UIApplication sharedApplication] delegate];
    // 処理実行フラグON
    appDelegate.IsRun = TRUE;
    
    [self makeAlert:nil message:[self mailCoreErrorStringFromError: conError] cancelBtnTitle:S_BUTTON_CLOSE okBtnTitle:nil tag:1];
}

// 印刷不可アラート表示
- (void)showAlertForPrintError {
    SharpScanPrintAppDelegate* appDelegate = (SharpScanPrintAppDelegate*)[[UIApplication sharedApplication] delegate];
    // 処理実行フラグON
    appDelegate.IsRun = TRUE;
    
    [[NSOperationQueue mainQueue] addOperationWithBlock:^(){
        
        // ★TODO:他言語化
        [self makeAlert:nil message:MSG_CANNOT_PRINT_WEB_PAGE cancelBtnTitle:nil okBtnTitle:MSG_BUTTON_OK tag:0];
    }];
}

// エラーアラート表示
- (void)showAlertError :(NSString*)errMsg{
    SharpScanPrintAppDelegate* appDelegate = (SharpScanPrintAppDelegate*)[[UIApplication sharedApplication] delegate];
    // 処理実行フラグON
    appDelegate.IsRun = TRUE;
    
    [[NSOperationQueue mainQueue] addOperationWithBlock:^(){
        
        [self makeAlert:nil message:errMsg cancelBtnTitle:nil okBtnTitle:MSG_BUTTON_OK tag:1];
    }];
}

-(void)alertButtonDismiss:(UIAlertController *)alertController tagIndex:(NSInteger)tagIndex buttonIndex:(NSInteger)buttonIndex
{
    SharpScanPrintAppDelegate* appDelegate = (SharpScanPrintAppDelegate*)[[UIApplication sharedApplication] delegate];
    // 処理実行フラグoff
    appDelegate.IsRun = FALSE;
    
    if(tagIndex == 10 && buttonIndex == 0)
    {//キャンセルボタン
        [self updateToolBar];
    } else if(tagIndex == 1) {
        // 前の画面に戻る
        [self.navigationController popViewControllerAnimated:YES];
    }
}

-(void)alertButtonClicked:(UIAlertController *)alertController tagIndex:(NSInteger)tagIndex buttonIndex:(NSInteger)buttonIndex
{
    SharpScanPrintAppDelegate* appDelegate = (SharpScanPrintAppDelegate*)[[UIApplication sharedApplication] delegate];
    // 処理実行フラグoff
    appDelegate.IsRun = FALSE;

    switch (tagIndex)
    {
        case 10:
        {
            DLog(@"Cancel Pushed");
            self.isCanceled = YES;
            [self createNoCancelWaitAlert];
        }
        default:
            break;
    }
}

// アラートボタン押下処理
-(void)alertButtonPushed:(UIAlertController *)alertController tagIndex:(NSInteger)tagIndex buttonIndex:(NSInteger)buttonIndex
{
    [self alertButtonClicked:alertController tagIndex:tagIndex buttonIndex:buttonIndex];
    [self alertButtonDismiss:alertController tagIndex:tagIndex buttonIndex:buttonIndex];
}

- (void)viewDidUnload {
    imageToolBar = nil;
    imageOnOffButton = nil;
    imageAttachButton = nil;
    imageSelectButton = nil;
    [super viewDidUnload];
}

- (NSString*) mailCoreErrorStringFromError:(NSError*)errCode
{
    NSString *description = MSG_EMAIL_CONNECT_ERROR;
    return description;
}

// Webページのロードの開始前
#pragma mark -
#pragma mark UIWebViewDelegate Method
- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    
    // リンクがクリックされたとき
    if(navigationType == UIWebViewNavigationTypeLinkClicked)
    {
        // Webページの読み込み処理は行わない
        return NO;
    }
    return YES;
}

// Webページのロードの開始直後
- (void)webViewDidStartLoad:(UIWebView *)webView {
    if (!m_print) {
        self.emailBody.hidden = YES;
    }
}

// Webページのロードの完了後
- (void)webViewDidFinishLoad:(UIWebView *)webView {
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    if (m_print) {
        if (!self.isCanceled) {
            //TODO: 遷移する
            if (self.delegate == nil) {
                // printSelectで開いているので、先に遷移させる
                NSNotification *n = [NSNotification notificationWithName:MP_ENTER_BUTTON_PUSHED1 object:self];
                NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
                [nc postNotification:n];
            }
            
            [self performSelector:@selector(creatMailPdfPages2) withObject:nil afterDelay:1.0];
        }
    } else {
        self.emailBody.hidden = NO;
    }
    NSString * widthStr = [self.emailBody stringByEvaluatingJavaScriptFromString: @"document.body.scrollWidth;"];
    NSString * heightStr = [self.emailBody stringByEvaluatingJavaScriptFromString: @"document.body.scrollHeight;"];
    
	int pageWidth = [widthStr intValue];
	int pageHeight = [heightStr intValue];
    double pdfHeight = pageWidth * sqrt(2.0f);
    
    // メールの属性をページ分だけ格納しておく
	pages = ceil(pageHeight / pdfHeight);
    for(int i = 0;i < pages ;i ++){
        [self.mailFormatArrayOfPages addObject:self.mailFormat];
    }

    // しばらくおまちくださいダイアログを閉じる
    if(alert != nil)
    {
        // アラートを閉じる
        [alert dismissViewControllerAnimated:YES completion:^{
        }];
        alert = nil;
    }
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error {
    
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    
    DLog(@"error %@", error);
    
    // キャンセル時以外の場合
    if ([error code] != NSURLErrorCancelled) {
        
        // アラートを閉じる
        [alert dismissViewControllerAnimated:YES completion:^{
            SharpScanPrintAppDelegate* appDelegate = (SharpScanPrintAppDelegate*)[[UIApplication sharedApplication] delegate];
            // 処理実行フラグON
            appDelegate.IsRun = TRUE;
            
            [[NSOperationQueue mainQueue] addOperationWithBlock:^(){
                
                [self makeAlert:nil message:[error localizedDescription] cancelBtnTitle:nil okBtnTitle:MSG_BUTTON_OK tag:0];
            }];
        }];
    }
}

// imgタグの画像を表示しないようにキャッシュのURLを変更する
- (void)cacheBlock
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentationDirectory, NSUserDomainMask, YES);
    NSString *documentDirectory = [paths objectAtIndex:0];
    NSString *path = [documentDirectory stringByAppendingPathComponent:@"cache.dat"];
    
    NSUInteger discCapacity = 10 * 1024 * 1024;
    NSUInteger memoryCapacity = 512 * 1024;
    cache = [[FilteredWebCache alloc]initWithMemoryCapacity:memoryCapacity diskCapacity:discCapacity diskPath:path];
    cache.bImageOff = YES;
    [NSURLCache setSharedURLCache:cache];
    
}

- (void) createNoCancelWaitAlert
{
    SharpScanPrintAppDelegate* appDelegate = (SharpScanPrintAppDelegate*)[[UIApplication sharedApplication] delegate];
    // 処理実行フラグON
    appDelegate.IsRun = TRUE;

    [[NSOperationQueue mainQueue] addOperationWithBlock:^(){
        
        [self makeAlert:nil message:MSG_WAIT cancelBtnTitle:nil okBtnTitle:nil tag:10];
    }];
}

- (void) createProgressionAlertWithMessage:(NSString *)titles message:(NSString *)messages withCancel:(BOOL)cancel
{
    SharpScanPrintAppDelegate* appDelegate = (SharpScanPrintAppDelegate*)[[UIApplication sharedApplication] delegate];
    // 処理実行フラグON
    appDelegate.IsRun = TRUE;
    
    [[NSOperationQueue mainQueue] addOperationWithBlock:^(){
        
        // Create the progress bar and add it to the alert
        if (cancel)
        {
            self.isCanceled = NO;
            [self makeAlert:nil message:messages cancelBtnTitle:MSG_BUTTON_CANCEL okBtnTitle:nil tag:10];
        }
        else
        {
            [self makeAlert:nil message:messages cancelBtnTitle:nil okBtnTitle:nil tag:98];
        }
    }];
}

// キャンセルし画面を閉じる
- (void)cancelAction
{
    if(delegate){
        if([delegate respondsToSelector:@selector(mailPrint:upLoadMailView:)]){
            // デリゲートメソッドの呼び出し(モーダルビューも閉じる)
            [delegate mailPrint:self upLoadMailView:nil];
        }
    }else {
        NSNotification *n = [NSNotification notificationWithName:NK_CLOSE_BUTTON_PUSHED object:self];
        NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
        [nc postNotification:n];
    }
    [self.account performSelectorInBackground:@selector(disconnect) withObject:nil];
}

-(void)backBtnAction{
    //戻るボタン押下時に通信切断
    if(self.account){
        [self.account performSelectorInBackground:@selector(disconnect) withObject:nil];
    }
    [self.navigationController popViewControllerAnimated:YES];
}

// アラート表示
- (void)makeAlert:(NSString*)pstrTitle
          message:(NSString*)pstrMsg
   cancelBtnTitle:(NSString*)cancelBtnTitle
       okBtnTitle:(NSString*)okBtnTitle
              tag:(NSInteger)tag
{
    alert = [ExAlertController alertControllerWithTitle:pstrTitle
                                                message:pstrMsg
                                         preferredStyle:UIAlertControllerStyleAlert];
    alert.tag = tag;
    
    // Cancel用のアクションを生成
    if (cancelBtnTitle != nil) {
        UIAlertAction *cancelAction =
        [UIAlertAction actionWithTitle:cancelBtnTitle
                                 style:UIAlertActionStyleCancel
                               handler:^(UIAlertAction * action) {
                                   
                                   // ボタンタップ時の処理
                                   [self alertButtonPushed:alert tagIndex:tag buttonIndex:0];
                               }];
        // コントローラにアクションを追加
        [alert addAction:cancelAction];
    }
    
    // OK用のアクションを生成
    if (okBtnTitle != nil) {
        // OK用ボタンIndex
        NSInteger okIndex = (cancelBtnTitle == nil) ? 0 : 1;
        
        UIAlertAction *okAction =
        [UIAlertAction actionWithTitle:okBtnTitle
                                 style:UIAlertActionStyleDefault
                               handler:^(UIAlertAction * action) {
                                   
                                   // ボタンタップ時の処理
                                   [self alertButtonPushed:alert tagIndex:tag buttonIndex:okIndex];
                               }];
        // コントローラにアクションを追加
        [alert addAction:okAction];
    }
    // アラート表示処理
    [self presentViewController:alert animated:YES completion:nil];
}

// アラート表示
- (void) makeTmpExAlert:(NSString*)pstrTitle
                message:(NSString*)pstrMsg
         cancelBtnTitle:(NSString*)cancelBtnTitle
             okBtnTitle:(NSString*)okBtnTitle
                    tag:(NSInteger)tag
                showFlg:(BOOL)showFlg
{
    ExAlertController *tmpAlert = [ExAlertController alertControllerWithTitle:pstrTitle
                                                                      message:pstrMsg
                                                               preferredStyle:UIAlertControllerStyleAlert];
    tmpAlert.tag = tag;
    
    // Cancel用のアクションを生成
    if (cancelBtnTitle != nil) {
        UIAlertAction *cancelAction =
        [UIAlertAction actionWithTitle:cancelBtnTitle
                                 style:UIAlertActionStyleCancel
                               handler:^(UIAlertAction * action) {
                                   
                                   // ボタンタップ時の処理
                                   [self alertButtonPushed:tmpAlert tagIndex:tag buttonIndex:0];
                               }];
        // コントローラにアクションを追加
        [tmpAlert addAction:cancelAction];
    }
    
    // OK用のアクションを生成
    if (okBtnTitle != nil) {
        // OK用ボタンIndex
        NSInteger okIndex = (cancelBtnTitle == nil) ? 0 : 1;
        
        UIAlertAction *okAction =
        [UIAlertAction actionWithTitle:okBtnTitle
                                 style:UIAlertActionStyleDefault
                               handler:^(UIAlertAction * action) {
                                   
                                   // ボタンタップ時の処理
                                   [self alertButtonPushed:tmpAlert tagIndex:tag buttonIndex:okIndex];
                               }];
        // コントローラにアクションを追加
        [tmpAlert addAction:okAction];
    }
    
    if (showFlg) {
        // アラート表示処理
        [self presentViewController:tmpAlert animated:YES completion:nil];
    }
}

@end
