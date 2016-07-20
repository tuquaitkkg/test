
#import "WebPagePrintViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "Define.h"
#import "SharpScanPrintAppDelegate.h"
#import "PrintPictViewController.h"
#import "TempFile.h"
#import "TempFileUtility.h"

#define kWebViewButtonSize              CGSizeMake(40, 40)              // 戻る、進むボタンのサイズ
#define kURLTextFieldSizeHeight         30.0f                           // URL入力欄の(テキストフィールド)高さ

#define kDefaultDisplayURL              @"http://www.google.com/"     // 初期表示URL
#define kURLRequestTimeoutInterval      60.0f                           // リクエストタイムアウト(秒)

#define kJavaScriptViewPort             @"var element = document.createElement('meta');" \
                                        "element.name = 'viewport';" \
                                        "element.content = 'width = %f" \
                                        "  initial-scale = 1.0, " \
                                        "  minimum-scale = 0.5, " \
                                        "  maximum-scale = 2.0, " \
                                        "  user-scalable = yes';" \
                                        "var head = document.getElementsByTagName('head')[0];" \
                                        "head.appendChild(element);"

@interface WebPagePrintViewController ()

// フレーム初期化
- (void)initFrame;

// Webページ印刷
- (BOOL)printWebPage;

// 印刷不可アラート表示
- (void)showAlertForPrintError;

// 印刷画面へ遷移
- (void)movePrintPictView;

// 印刷用PDFファイルの削除
- (void)deletePrintPDFFile;

// PDF出力ファイルパス取得
- (NSString *)getSavePdfFilePath;

// Webページのロードが完了しているか
- (BOOL)isFinishLoadForWebPage;

// 印刷確認アラート表示
- (void)showAlertForConfirmPrint;

// 印刷処理
- (void)printFunction;

@end

@implementation WebPagePrintViewController

@synthesize delegate;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {

    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // UINavigationBar 44px のずれを無くす
    self.navigationController.navigationBar.translucent = NO;
    self.navigationController.navigationBar.barStyle = NAVIGATION_BARSTYLE;
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    // タイトル設定
    CGRect frame = CGRectMake(0, 0, 400, 44);
    UILabel* lblTitle = [[UILabel alloc]initWithFrame:frame];
    lblTitle.backgroundColor = [UIColor clearColor];
    lblTitle.textColor = NAVIGATION_TITLE_COLOR;
    lblTitle.font = [UIFont boldSystemFontOfSize:20];
    lblTitle.textAlignment = NSTextAlignmentCenter;
    lblTitle.text = S_PRINT_SEL_WEBPAGE;
    lblTitle.adjustsFontSizeToFitWidth = YES;
    self.navigationItem.titleView = lblTitle;
    
    // 印刷ボタン追加
    // ★TODO:他言語化
    UIBarButtonItem * printButton = [[UIBarButtonItem alloc] initWithTitle: S_IMAGE_FILE_SELECT
                                                                      style: UIBarButtonItemStyleDone
                                                                     target: self
                                                                     action: @selector(printButtonAction:)];
    self.navigationItem.rightBarButtonItem = printButton;
    self.navigationItem.rightBarButtonItem.enabled = YES;
    
//    // 戻るボタンの名称変更
//    UIBarButtonItem * barItemBack = [UIBarButtonItem new];
//    barItemBack.title = S_BUTTON_BACK;
//    self.navigationItem.backBarButtonItem = barItemBack;

    // ナビゲーションバー左側にキャンセルボタンを設定
    UIBarButtonItem* btnClose = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel
                                                                              target:self
                                                                              action:@selector(cancelAction)];
    self.navigationItem.leftBarButtonItem = btnClose;
    
    // WebView
    m_webView = [[UIWebView alloc] init];
    m_webView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    // ピンチ操作による拡大縮小はJavaScriptで可能にする
//    m_webView.scalesPageToFit = YES;
    m_webView.delegate = self;
    [self.view addSubview: m_webView];
    
    // 戻るボタン
    m_backButton = [UIButton buttonWithType: UIButtonTypeRoundedRect];
    // ★TODO:画像に置き換え
    [m_backButton setBackgroundImage:[UIImage imageNamed:S_ICON_PREVIOUS] forState:UIControlStateNormal];
    //[m_backButton setTitle: @"戻る" forState: UIControlStateNormal];
    m_backButton.enabled = NO;
    m_backButton.exclusiveTouch = YES;
    [m_backButton addTarget: self
                     action: @selector(touchBackButtonAction:)
           forControlEvents: UIControlEventTouchUpInside];
    [self.view addSubview: m_backButton];
    
    // 進むボタン
    m_forwardButton = [UIButton buttonWithType: UIButtonTypeRoundedRect];
    // ★TODO:画像に置き換え
    [m_forwardButton setBackgroundImage:[UIImage imageNamed:S_ICON_NEXT] forState:UIControlStateNormal];
    //[m_forwardButton setTitle: @"進む" forState: UIControlStateNormal];
    m_forwardButton.enabled = NO;
    m_forwardButton.exclusiveTouch = YES;
    [m_forwardButton addTarget: self
                        action: @selector(touchForwardButtonAction:)
              forControlEvents: UIControlEventTouchUpInside];
    [self.view addSubview: m_forwardButton];

    // URL入力欄
    m_urlTextField = [[UITextField alloc] init];
    m_urlTextField.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    m_urlTextField.borderStyle = UITextBorderStyleRoundedRect;
    m_urlTextField.keyboardType = UIKeyboardTypeURL;
    m_urlTextField.keyboardAppearance = UIKeyboardAppearanceLight;
    m_urlTextField.placeholder = @"http://";
    m_urlTextField.delegate = self;
    m_urlTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
    [self.view addSubview: m_urlTextField];

    // 初期表示URL
    NSString * urlString = kDefaultDisplayURL;
    NSURL * url = [NSURL URLWithString: urlString];
    NSURLRequest * urlRequest = [NSURLRequest requestWithURL: url
                                                 cachePolicy: NSURLRequestUseProtocolCachePolicy
                                             timeoutInterval: kURLRequestTimeoutInterval];
    [m_webView loadRequest: urlRequest];

}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self initFrame];
    
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];

}

- (void)dealloc
{
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;

    // 印刷用PDFファイルの削除
//    [self deletePrintPDFFile];

    [m_urlTextField resignFirstResponder];
    m_urlTextField.delegate = nil;
    m_urlTextField = nil;
    
    m_webView.delegate = nil;
    [m_webView stopLoading];
    m_webView = nil;

}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark -
#pragma mark ボタンタップアクション

// 選択ボタンタップイベント
- (void)printButtonAction:(UIBarButtonItem *)sender {
    
    // Webページのロードが完了していない場合
    if ( ! [self isFinishLoadForWebPage] ) {
        
        // 印刷確認アラート表示
        [self showAlertForConfirmPrint];
        
        // 以降は処理しない
        return;
    }

    // 印刷処理
    [self printFunction];
    
}

// 戻るボタンタップイベント
- (void)touchBackButtonAction:(UIButton *)sender {
    [m_webView goBack];
}

// 進むボタンタップイベント
- (void)touchForwardButtonAction:(UIButton *)sender {
    [m_webView goForward];
}

#pragma mark -
#pragma mark UITextFieldDelegate Method

// キーボードReturnキータップイベント
- (BOOL)textFieldShouldReturn:(UITextField*)textField {
    
    // 入力された文字列でWebサイトにジャンプする
    if (textField.text.length != 0) {
        NSString* strTextField = textField.text;
        if ([strTextField hasPrefix:@"http://"] == FALSE && [strTextField hasPrefix:@"https://"] == FALSE) {
            strTextField = [NSString stringWithFormat:@"http://%@", strTextField];
        }
        NSURL * url = [NSURL URLWithString: strTextField];
        NSURLRequest * urlRequest = [NSURLRequest requestWithURL: url
                                                     cachePolicy: NSURLRequestUseProtocolCachePolicy
                                                 timeoutInterval: kURLRequestTimeoutInterval];
        [m_webView loadRequest: urlRequest];
        
    }
    
    [textField resignFirstResponder];
    return YES;
}

#pragma mark -
#pragma mark UIWebViewDelegate Method

- (BOOL)webView:(UIWebView *)webView
shouldStartLoadWithRequest:(NSURLRequest *)request
 navigationType:(UIWebViewNavigationType)navigationType {
    
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    
    return YES;
}

- (void)webViewDidStartLoad:(UIWebView *)webView {

    
}

- (void)webViewDidFinishLoad:(UIWebView *)webView {
    
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;

    m_backButton.enabled = [webView canGoBack];
    m_forwardButton.enabled = [webView canGoForward];
    
    m_urlTextField.text = webView.request.URL.absoluteString;
    
    // 画面の向きを考慮して横サイズに合わせる
    NSString * javaScriptViewPort = [NSString stringWithFormat: kJavaScriptViewPort, webView.frame.size.width];

    [m_webView stringByEvaluatingJavaScriptFromString: javaScriptViewPort];

}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error {

    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;

    m_backButton.enabled = [webView canGoBack];
    m_forwardButton.enabled = [webView canGoForward];

    DLog(@"error %@", error);
    
    // キャンセル時以外の場合
    if ([error code] != NSURLErrorCancelled) {
        SharpScanPrintAppDelegate* appDelegate = (SharpScanPrintAppDelegate*)[[UIApplication sharedApplication] delegate];
        // 処理実行フラグON
        appDelegate.IsRun = TRUE;
        
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil
                                                                                 message:[error localizedDescription]
                                                                          preferredStyle:UIAlertControllerStyleAlert];

        // OK用のアクションを生成
        UIAlertAction * okAction =
        [UIAlertAction actionWithTitle:MSG_BUTTON_OK
                                 style:UIAlertActionStyleDefault
                               handler:^(UIAlertAction * action) {
                                   
                                   // ボタンタップ時の処理
                                   [self appDelegateIsRunOff];
                               }];
        
        // コントローラにアクションを追加
        [alertController addAction:okAction];
        [self presentViewController:alertController animated:YES completion:nil];
        
    }

}

#pragma mark -
#pragma mark Private Method

// フレーム初期化
- (void)initFrame {
    
    m_webView.frame = CGRectMake(0,
                                 kWebViewButtonSize.height,
                                 self.view.frame.size.width,
                                 self.view.frame.size.height - kWebViewButtonSize.height);
    
    m_backButton.frame = CGRectMake(0,
                                    0,
                                    kWebViewButtonSize.width,
                                    kWebViewButtonSize.height);
    
    m_forwardButton.frame = CGRectMake(m_backButton.frame.size.width,
                                       0,
                                       kWebViewButtonSize.width,
                                       kWebViewButtonSize.height);
    
    m_urlTextField.frame = CGRectMake(m_backButton.frame.size.width + m_forwardButton.frame.size.width,
                                      (kWebViewButtonSize.height - kURLTextFieldSizeHeight) / 2,
                                      self.view.frame.size.width - m_backButton.frame.size.width - m_forwardButton.frame.size.width,
                                      kURLTextFieldSizeHeight);
}

// Webページ印刷
- (BOOL)printWebPage {

    // ---------- 描画準備処理 ----------

    NSString * widthStr = [m_webView stringByEvaluatingJavaScriptFromString: @"document.body.scrollWidth;"];
    NSString * heightStr = [m_webView stringByEvaluatingJavaScriptFromString: @"document.body.scrollHeight;"];
    
	int pageWidth = [widthStr intValue];
	int pageHeight = [heightStr intValue];
    
    DLog(@"pageWidth %d", pageWidth);
    DLog(@"pageHeight %d", pageHeight);
    
    if (pageWidth == 0 || pageHeight == 0) {
        DLog(@"ページサイズ取得不可");
        
        // 印刷不可アラート表示
        [self showAlertForPrintError];
        
        return NO;
    }
    
    // 横サイズ決定
    int pdfWidth = pageWidth;
    DLog(@"pdfWidth %d", pdfWidth);
    
    // 横サイズを基準に縦サイズを決める(横 : 縦 = 1 : √2)
    double pdfHeight = pageWidth * sqrt(2.0f);
    DLog(@"pdfHeight %f", pdfHeight);

    // ページ数を算出(端数切り上げ)
	int pages = ceil(pageHeight / pdfHeight);
    DLog(@"pages %d", pages);
    
    // 最終ページの高さ
    int pdfLastPageHeight = ceil(pageHeight % (int)pdfHeight);
    DLog(@"pdfLastPageHeight %d", pdfLastPageHeight);
    
    UIScrollView * scrollViewInWebView = nil;
    
    if ([[[m_webView subviews] lastObject] isKindOfClass: [UIScrollView class]]) {
        // UIWebView内のスクロールビューを取得する
        // (UIWebViewのscrollViewプロパティはiOS4.3で使用不可のためこの方法で取得する)
        scrollViewInWebView = [[m_webView subviews] lastObject];
    }
    // スクロールビューが取得出来なかった場合
    else {
        // ありえないはず
        return NO;
    }

    // ズームスケールを保持
    CGFloat minZoomScale = scrollViewInWebView.minimumZoomScale;
    CGFloat maxZoomScale = scrollViewInWebView.maximumZoomScale;
    CGFloat zoomScale = scrollViewInWebView.zoomScale;
    
    // 背景色を保持
    UIColor * backgroundColor = m_webView.backgroundColor;
    
    // 最終ページの余白部分に印刷される色を調整
    m_webView.backgroundColor = [UIColor whiteColor];

    // アスペクト取得
    CGFloat ratioAspect = pdfWidth / scrollViewInWebView.contentSize.width;
    DLog(@"ratioAspect %f", ratioAspect);
    
    // アクペクトからズームを調整
    // （ユーザーのピンチ操作後にWebViewのframeを変更すると画面が崩れるのでズームで対応する）
    scrollViewInWebView.minimumZoomScale = scrollViewInWebView.minimumZoomScale * ratioAspect;
    DLog(@"minimumZoomScale %f", scrollViewInWebView.minimumZoomScale);
    scrollViewInWebView.maximumZoomScale = scrollViewInWebView.maximumZoomScale * ratioAspect;
    DLog(@"maximumZoomScale %f", scrollViewInWebView.maximumZoomScale);
    [scrollViewInWebView setZoomScale: (scrollViewInWebView.zoomScale * ratioAspect)
                             animated: NO];
    DLog(@"zoomScale %f", scrollViewInWebView.zoomScale);

    // WebViewの表示状態を保持
    CGPoint webViewContentsOffset = scrollViewInWebView.contentOffset;
    
    // ---------- 描画処理 ----------

    // PDFファイル出力開始
    UIGraphicsBeginPDFContextToFile([self getSavePdfFilePath], CGRectZero, nil);

	for (int i = 0; i < pages; i++) {
        
        // PDF 1ページ分のサイズを設定する
        UIGraphicsBeginPDFPageWithInfo(CGRectMake(0, 0, pdfWidth, pdfHeight), nil);
        
        // コンテキスト取得
		CGContextRef currentContext = UIGraphicsGetCurrentContext();
        
        for (int y = 0; y < pdfHeight; y += m_webView.frame.size.height) {
            
            for (int x = 0; x < pdfWidth; x += m_webView.frame.size.width) {
                DLog(@"x %d, y %d", x, y);
                DLog(@"x %d, y + (pdfHeight * i) %f", x, y + (pdfHeight * i));
                
                // コンテキストに描画する位置を調整する
                CGContextTranslateCTM(currentContext, x, y);
                
                // ページ毎にキャプチャー位置をずらす(WebViewをスクロールさせていく)
                [scrollViewInWebView setContentOffset: CGPointMake(x, y + (pdfHeight * i))
                                             animated: NO];
                
                // WebViewに表示しているコンテキストを描画
                [m_webView.layer renderInContext: currentContext];
                
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
    m_webView.backgroundColor = backgroundColor;

    // ズームスケールを戻す
    scrollViewInWebView.minimumZoomScale = minZoomScale;
    scrollViewInWebView.maximumZoomScale = maxZoomScale;
    [scrollViewInWebView setZoomScale: zoomScale
                             animated: NO];

    return YES;
}

// 印刷不可アラート表示
- (void)showAlertForPrintError {
    SharpScanPrintAppDelegate* appDelegate = (SharpScanPrintAppDelegate*)[[UIApplication sharedApplication] delegate];
    // 処理実行フラグON
    appDelegate.IsRun = TRUE;
    
    // ★TODO:他言語化
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil
                                                                             message:MSG_CANNOT_PRINT_WEB_PAGE
                                                                      preferredStyle:UIAlertControllerStyleAlert];
    
    // OK用のアクションを生成
    UIAlertAction * okAction =
    [UIAlertAction actionWithTitle:MSG_BUTTON_OK
                             style:UIAlertActionStyleDefault
                           handler:^(UIAlertAction * action) {
                               
                               // ボタンタップ時の処理
                               [self appDelegateIsRunOff];
                           }];
    
    // コントローラにアクションを追加
    [alertController addAction:okAction];
    [self presentViewController:alertController animated:YES completion:nil];
    
}

// 印刷画面へ遷移
- (void)movePrintPictView {
    
//    PrintPictViewController * printPictViewController = nil;
//    printPictViewController = [[[PrintPictViewController alloc] init] autorelease];
//    printPictViewController.SelFilePath	= [self getSavePdfFilePath];
//    
//    [self.navigationController pushViewController: printPictViewController
//                                         animated: YES];
    if(delegate){
        if([delegate respondsToSelector:@selector(webPagePrint:upLoadWebView:)]){
            // デリゲートメソッドの呼び出し(モーダルビューも閉じる)
            [delegate webPagePrint:self upLoadWebView:[self getSavePdfFilePath]];
            
        }
    }
}

// 印刷用PDFファイルの削除
- (void)deletePrintPDFFile {
    
    // PDFファイルを削除
    TempFile * localTempFile = [[TempFile alloc]initWithPrintDataPdf];
    [TempFileUtility deleteFile:localTempFile];

}

// PDF出力ファイルパス取得
- (NSString *)getSavePdfFilePath {
    // PDF出力ファイルパス設定
    TempFile * localTempFile = [[TempFile alloc]initWithPrintDataPdf];
    return localTempFile.tempFilePath;
}

// Webページのロードが完了しているか
- (BOOL)isFinishLoadForWebPage {
    // ネットワークインジケータを表示している場合は
    // ロードが完了していないとみなす
    return ! [UIApplication sharedApplication].networkActivityIndicatorVisible;
}

// 印刷確認アラート表示
- (void)showAlertForConfirmPrint {
    SharpScanPrintAppDelegate* appDelegate = (SharpScanPrintAppDelegate*)[[UIApplication sharedApplication] delegate];
    // 処理実行フラグON
    appDelegate.IsRun = TRUE;
    
    
    // ★TODO:他言語化
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil
                                                                             message:MSG_CONFIRM_PRINT_WEB_PAGE
                                                                      preferredStyle:UIAlertControllerStyleAlert];
    
    // Cancel用のアクションを生成
    UIAlertAction * cancelAction =
    [UIAlertAction actionWithTitle:MSG_BUTTON_CANCEL
                             style:UIAlertActionStyleCancel
                           handler:^(UIAlertAction * action) {
                               
                               // ボタンタップ時の処理
                               [self appDelegateIsRunOff];
                           }];
    
    // OK用のアクションを生成
    UIAlertAction * okAction =
    [UIAlertAction actionWithTitle:MSG_BUTTON_OK
                             style:UIAlertActionStyleDefault
                           handler:^(UIAlertAction * action) {
                               
                               // ボタンタップ時の処理
                               // 印刷処理
                               [self printFunction];
                           }];
    
    // コントローラにアクションを追加
    [alertController addAction:cancelAction];
    [alertController addAction:okAction];
    // アラート表示処理
    [self presentViewController:alertController animated:YES completion:nil];
    
}

// 印刷処理
- (void)printFunction {
    
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    [m_webView stopLoading];
    
    // Webページ印刷
    BOOL ret = [self printWebPage];
    
    // Webページ印刷が失敗した場合は画面遷移しない
    if ( ! ret ) {
        return;
    }
    
    // 印刷画面へ遷移
    [self movePrintPictView];
    
}

// キャンセルし画面を閉じる
- (void)cancelAction
{
    if(delegate){
        if([delegate respondsToSelector:@selector(webPagePrint:didWebPagePrintSuccess:)]){
            // デリゲートメソッドの呼び出し(モーダルビューも閉じる)
            [delegate webPagePrint:self didWebPagePrintSuccess:NO];
        }
    }
}

// 処理実行フラグをOFFにする
- (void)appDelegateIsRunOff {
    // ボタンタップ時の処理
    SharpScanPrintAppDelegate* appDelegate = (SharpScanPrintAppDelegate*)[[UIApplication sharedApplication] delegate];
    // 処理実行フラグOFF
    appDelegate.IsRun = FALSE;
}

@end
