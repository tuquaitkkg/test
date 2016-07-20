
#import "SendMailPictViewController_iPad.h"
#import "Define.h"
#import "CommonUtil.h"
// iPad用
#import "SharpScanPrintAppDelegate.h"
#import "RootViewController_iPad.h"
// iPad用

@implementation SendMailPictViewController_iPad

@synthesize m_diCtrl;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        // 変数初期化
        [super InitObject];
        
    }
    return self;
}


- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    // メインビュー初期化
    // iPad用 戻るボタン非表示
    //[super InitView:S_TITLE_SENDMAIL
    //     menuBtnNum:PrvMenuIDFirst];
    [super InitView:S_TITLE_SENDMAIL menuBtnNum:PrvMenuIDSeventh hidesBackButton:YES hidesSettingButton:YES];
    // iPad用
    
	// メニュー作成
    NSString* pstrBtnName = nil;        // ボタン名称
    //NSString* pstrInitValue = nil;    // 表示初期値 // iPad用
    NSString* pstrIconName = nil;       // アイコン名称
    NSString* pstrLabelName = nil;      // ラベル名称 iPad用
    
    for (NSInteger nCnt = PrvMenuIDFirst; nCnt <= PrvMenuIDSeventh; nCnt++)
    {
        switch (nCnt)
        {
            case PrvMenuIDFirst:
                //                pstrBtnName = S_BUTTON_SENDMAIL_IPAD;
                //                //pstrInitValue = @""; // iPad用
                //                pstrIconName = S_ICON_SENDMAIL_SEND;
                pstrBtnName = S_BUTTON_OTHER_APP;
                // iPad用
                pstrIconName = S_ICON_SEND_SEND;
                break;
            case PrvMenuIDSecond:
            case PrvMenuIDThird:
            case PrvMenuIDFourth:
            case PrvMenuIDFifth:
            case PrvMenuIDSixth:
                continue;
            case PrvMenuIDSeventh:
                //                pstrBtnName = S_BUTTON_OTHER_APP;
                //                // iPad用
                //                pstrIconName = S_ICON_SEND_SEND;
                pstrBtnName = S_BUTTON_SENDMAIL_IPAD;
                //pstrInitValue = @""; // iPad用
                pstrIconName = S_ICON_SENDMAIL_SEND;
                break;
            default:
                break;
        }
        
        // iPad用
        //[super CreateMenu:nCnt
        //        btnName:pstrBtnName
        //        initValue:pstrInitValue
        //        iconName:pstrIconName];
        [super CreateMenu:nCnt
                  btnName:pstrBtnName
                 iconName:pstrIconName
                  lblName:pstrLabelName];
        // iPad用
	}
	
    // 他アプリで開くの文言が長い場合は2行にする
    if ([self.m_pbtnFirst.titleLabel.text length] > 15) {
        self.m_pbtnFirst.titleLabel.lineBreakMode = NSLineBreakByWordWrapping;
        self.m_pbtnFirst.titleLabel.numberOfLines = 2;
        self.m_pbtnFirst.titleLabel.font = [UIFont systemFontOfSize:10];
    }

    // CommonManagerクラス生成
    m_pCmnMgr = [[CommonManager alloc] init];
    
    // ボタンを2行表示するかチェック
    [m_pCmnMgr btnTwoLineChange:self.m_pbtnFirst];
    [m_pCmnMgr btnTwoLineChange:self.m_pbtnSeventh];
    
    // iPad用
    //設定ボタン非表示設定
    [self.navigationItem setRightBarButtonItem:nil animated:YES];
    // iPad用
    
    // スレッド開始
    [super StartThread];
    
    
}

-(void)viewDidDisappear:(BOOL)animated
{
	m_diCtrl.delegate = nil;
    [m_diCtrl dismissMenuAnimated:NO];
    
    [super viewDidDisappear:animated];
    
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
    if(m_pCmnMgr != nil)
    {
        m_pCmnMgr = nil;
    }
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    // iPad用
    //return (interfaceOrientation == UIInterfaceOrientationPortrait);
    return YES;
    // iPad用
}
// スレッド
// 実行スレッド
- (void)ActionThread
{
    //リリースプール生成
	@autoreleasepool
    {
        
        if (!m_bAbort)
        {
            // ファイル表示
            [super ShowFile:self.SelFilePath];
            // 他アプリで確認ボタンは活性状態にする。
            [self.m_pbtnFirst setEnabled:YES];
        }
        
        // ファイル読み込みが完了、または処理が中断されるまで待つ
        while (!m_bFinLoad && !m_bAbort)
        {
            [NSThread sleepUntilDate: [NSDate dateWithTimeIntervalSinceNow: 0.1]];
        }
        
        //リリースプール解放
        m_bFinLoad = FALSE;
    }
}
// ボタン押下関数
//// メニューボタン１押下
//- (IBAction)OnMenuFirstButton:(id)sender
// メニューボタン7(他アプリに送る)押下

//添付するボタン押下
- (IBAction)OnMenuSeventhButton:(id)sender
{
    // 処理中あるいは処理中断フラグ=TRUEの場合は何もしない
    if (m_pThread || m_bAbort)
    {
        return;
    }
    
    Class mail = (NSClassFromString(@"MFMailComposeViewController"));
    if (mail != nil)
    {
        // iPad用
        //SharpScanPrintAppDelegate* appDelegate = (SharpScanPrintAppDelegate*)[[UIApplication sharedApplication] delegate];
        SharpScanPrintAppDelegate* appDelegate = (SharpScanPrintAppDelegate*)[[UIApplication sharedApplication] delegate];
        // iPad用
        
        //メールの設定がされているかどうかチェック
        if (![mail canSendMail])
        {
            // 処理実行フラグON
            appDelegate.IsRun = TRUE;
            [self setAlert:MSG_MAIL_START_ERR];
        }
        // ファイルサイズチェック
        else if(![self canSendFileSize])
        {
            // 処理実行フラグON
            appDelegate.IsRun = TRUE;
            
            // 「メールに添付する」ボタン押下時の処理
            [self createAlertMailTemp];
        }
        else
        {
            [self showComposerSheet];
        }
    }
}

// 「メールに添付する」ボタン押下時の処理
- (void)createAlertMailTemp {
    [self makeTmpExAlert:nil message:MSG_MAIL_ATTACH_CONFIRM cancelBtnTitle:MSG_BUTTON_CANCEL okBtnTitle:MSG_BUTTON_OK tag:20 showFlg:YES];
}

-(BOOL) canSendFileSize
{
    NSFileManager *lFileManager	= [NSFileManager defaultManager];
    NSError			*err			= nil;
    NSDictionary *attr	= [lFileManager attributesOfItemAtPath:self.SelFilePath error:&err];
    // ファイルサイズ取得
    NSNumber *filesize	= [attr objectForKey:NSFileSize];
    
    NSNumber *sendFileSize = [NSNumber numberWithInt:1048576];
    
    BOOL isSend = YES;
    if([filesize compare:sendFileSize] == NSOrderedDescending)
    {
        isSend = NO;
    }
    
    return isSend;
}

/**
 * メール作成画面表示
 */
-(void) showComposerSheet
{
    MFMailComposeViewController *picker = [[MFMailComposeViewController alloc] init];
    picker.navigationBar.barStyle = NAVIGATION_BARSTYLE;
    picker.mailComposeDelegate = self;
    [picker setSubject:[self.SelFilePath lastPathComponent]];
    NSData *myData  = [NSData dataWithContentsOfFile:self.SelFilePath];
    
    NSString *strMimeType = @"";
    
    // pdfの場合
    if([CommonUtil pdfExtensionCheck:self.SelFilePath])
    {
        strMimeType = @"application/pdf";
    }
    else if([CommonUtil jpegExtensionCheck:self.SelFilePath])
    {
        strMimeType = @"image/jpeg";
    }
    else if([CommonUtil tiffExtensionCheck:self.SelFilePath])
    {
        strMimeType = @"image/tiff";
    }
    else
    {
        strMimeType = @"text/plain";
    }
    
    DLog(@"%@",strMimeType);
    
    //添付画像を付ける
    [picker addAttachmentData:myData mimeType:strMimeType fileName:[self.SelFilePath lastPathComponent]];
    [self presentViewController:picker animated:YES completion:nil];
    
}
- (void)mailComposeController:(MFMailComposeViewController*)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError*)error
{
    BOOL isSend = FALSE;
    
    switch (result){
        case MFMailComposeResultCancelled:
            //キャンセルした場合
            break;
        case MFMailComposeResultSaved:
            //保存した場合
            break;
        case MFMailComposeResultSent:
            //送信した場合
            isSend = TRUE;
            break;
        default:
            break;
    }
    [self dismissViewControllerAnimated:YES completion:nil];
    if(isSend)
    {
        [self.navigationController popToRootViewControllerAnimated:YES];
        // iPad用
        SharpScanPrintAppDelegate* pAppDelegate = (SharpScanPrintAppDelegate*)[[UIApplication sharedApplication] delegate];
        
        // 左側のViewを取得
        UINavigationController* pRootNavController = [pAppDelegate.splitViewController.viewControllers objectAtIndex:0];
        RootViewController_iPad* rootViewController = (RootViewController_iPad*)[pRootNavController.viewControllers objectAtIndex:0];
        // 左側のViewを遷移前の状態に戻す
        [rootViewController popRootView];
        // iPad用
    }
}
-(void) setAlert:(NSString *) aDescription {
    SharpScanPrintAppDelegate* appDelegate = (SharpScanPrintAppDelegate*)[[UIApplication sharedApplication] delegate];
    // 処理実行フラグON
    appDelegate.IsRun = TRUE;
    
    [self makeTmpExAlert:nil message:aDescription cancelBtnTitle:MSG_BUTTON_OK okBtnTitle:nil tag:0 showFlg:YES];
}

// アラートボタン押下処理
-(void)alertButtonPushed:(UIAlertController *)alertController tagIndex:(NSInteger)tagIndex buttonIndex:(NSInteger)buttonIndex
{
    [self alertButtonClicked:alertController tagIndex:tagIndex buttonIndex:buttonIndex];
    [self alertButtonDismiss:alertController tagIndex:tagIndex buttonIndex:buttonIndex];
}

-(void)alertButtonClicked:(UIAlertController *)alertController tagIndex:(NSInteger)tagIndex buttonIndex:(NSInteger)buttonIndex
{
}

-(void)alertButtonDismiss:(UIAlertController *)alertController tagIndex:(NSInteger)tagIndex buttonIndex:(NSInteger)buttonIndex
{
    // iPad用
    SharpScanPrintAppDelegate* appDelegate = (SharpScanPrintAppDelegate*)[[UIApplication sharedApplication] delegate];
    // 処理実行フラグOFF
    appDelegate.IsRun = FALSE;
    
    if(buttonIndex != 0)
    {
        switch (tagIndex)
        {
            case 20:
                [self showComposerSheet];
                break;
            default:
                break;
        }
    }
}

// ボタン押下関数
//// メニューボタン7(他アプリに送る)押下
//- (IBAction)OnMenuSeventhButton:(id)sender
// メニューボタン１押下
- (IBAction)OnMenuFirstButton:(id)sender
{
    // 処理中あるいは処理中断フラグ=TRUEの場合は何もしない
    if (m_pThread || m_bAbort)
    {
        return;
    }
	
	DLog(@"送るボタン押下");
	
	//表示中の画像は前画面で選択したファイル。
	NSString *urlString = self.SelFilePath;
	
	m_diCtrl = [UIDocumentInteractionController interactionControllerWithURL:[NSURL fileURLWithPath:urlString]];
	m_diCtrl.delegate = self;
    
    
    UIButton *btn = (UIButton *)sender;
    BOOL isShow = [m_diCtrl presentOpenInMenuFromRect:btn.frame
                                               inView:self.view
                                             animated:YES];
    if (!isShow)
    {
        //ひとつも対応するアプリがない場合
        DLog(@"isShow:False");
        
        // 他アプリ連携先が存在しない場合の処理
        [self createAlertNotExistApplication];
    }
}

// 他アプリ連携先が存在しない場合の処理
- (void)createAlertNotExistApplication {
    SharpScanPrintAppDelegate* appDelegate = (SharpScanPrintAppDelegate*)[[UIApplication sharedApplication] delegate];
    // 処理実行フラグON
    appDelegate.IsRun = TRUE;
    
    [self makeTmpExAlert:nil message:MSG_NO_SEND_APP cancelBtnTitle:MSG_BUTTON_OK okBtnTitle:nil tag:0 showFlg:YES];
}

- (void)documentInteractionController:(UIDocumentInteractionController *)controller willBeginSendingToApplication:(NSString *)application {
	DLog(@"!!!!! Sending to: %@", application);
}

- (void)documentInteractionController:(UIDocumentInteractionController *)controller didEndSendingToApplication:(NSString *)application {
	//DLog(@"!!!!! Sent to: %@", application);
	[m_diCtrl dismissMenuAnimated:YES];
    
    //    [self performSelector:@selector(popRootView) withObject:nil afterDelay:0.1];
}

- (void)popRootView
{
    //	[self.navigationController popToRootViewControllerAnimated:YES];
    //
    //    // iPad用
    //    SharpScanPrintAppDelegate* pAppDelegate = (SharpScanPrintAppDelegate*)[[UIApplication sharedApplication] delegate];
    //
    //    // 左側のViewを取得
    //    UINavigationController* pRootNavController = [pAppDelegate.splitViewController.viewControllers objectAtIndex:0];
    //    RootViewController_iPad* rootViewController = (RootViewController_iPad*)[pRootNavController.viewControllers objectAtIndex:0];
    //    // 左側のViewを遷移前の状態に戻す
    //    [rootViewController popRootView];
    //    // iPad用
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
