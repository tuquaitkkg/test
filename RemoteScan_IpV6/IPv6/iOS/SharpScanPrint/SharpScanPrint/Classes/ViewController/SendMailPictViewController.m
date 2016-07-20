
#import "SendMailPictViewController.h"
#import "Define.h"
#import "CommonUtil.h"
#import "SharpScanPrintAppDelegate.h"

@implementation SendMailPictViewController

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
    [super InitView:S_TITLE_SENDMAIL
         menuBtnNum:PrvMenuIDSecond];
    
    // タイトル設定
    CGSize size = [S_TITLE_SENDMAIL sizeWithFont:[UIFont boldSystemFontOfSize:20]];
    CGRect frame = CGRectMake(0, 0, size.width, 44);
    UILabel* lblTitle = [[UILabel alloc]initWithFrame:frame];
    lblTitle.backgroundColor = [UIColor clearColor];
    lblTitle.textColor = NAVIGATION_TITLE_COLOR;
    lblTitle.font = [UIFont boldSystemFontOfSize:20];
    lblTitle.textAlignment = NSTextAlignmentCenter;
    lblTitle.text = S_TITLE_SENDMAIL;
    lblTitle.adjustsFontSizeToFitWidth = YES;
    self.navigationItem.titleView = lblTitle;
    
	// メニュー作成
    NSString* pstrBtnName;      // ボタン名称
    NSString* pstrInitValue;    // 表示初期値
    NSString* pstrIconName;     // アイコン名称
    
    for (NSInteger nCnt = PrvMenuIDFirst; nCnt <= PrvMenuIDSecond; nCnt++)
    {
        switch (nCnt)
        {
            case PrvMenuIDFirst:
                pstrBtnName = S_BUTTON_SENDMAIL;
                pstrInitValue = @"";
                pstrIconName = S_ICON_SENDMAIL_SEND;
                break;
            case PrvMenuIDSecond:
                pstrBtnName = S_BUTTON_OTHER_APP;
                pstrInitValue = @"";
                pstrIconName = S_ICON_SEND_SEND;
                break;
            default:
                break;
        }
        
        [super CreateMenu:nCnt
                  btnName:pstrBtnName
                initValue:pstrInitValue
                 iconName:pstrIconName];
	}
	
	//設定ボタン非表示設定
	[self.navigationItem setRightBarButtonItem:nil animated:YES];
    
    
    // スレッド開始
    [super StartThread];
    
    self.view.backgroundColor = BACKGROUND_COLOR;// TableViewに合わせた背景を設定
    if([[[UIDevice currentDevice] systemVersion] floatValue] >= 6.0 &&
       [[[UIDevice currentDevice] systemVersion] floatValue] < 7.0 &&
       UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
    {// iOS6のiPhoneだけ
        UITableView *tableView = [[UITableView alloc] initWithFrame:[[UIScreen mainScreen] bounds] style:UITableViewStyleGrouped];
        [self.view addSubview:tableView];
        [self.view sendSubviewToBack:tableView];
    }
    
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
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
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
            [self.m_pbtnSecond setEnabled:YES];
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
// メニューボタン１押下
//添付するボタン押下
- (IBAction)OnMenuFirstButton:(id)sender
{
    // 処理中あるいは処理中断フラグ=TRUEの場合は何もしない
    if (self.m_pThread || m_bAbort)
    {
        return;
    }
    
    Class mail = (NSClassFromString(@"MFMailComposeViewController"));
    if (mail != nil)
    {
        SharpScanPrintAppDelegate* appDelegate = (SharpScanPrintAppDelegate*)[[UIApplication sharedApplication] delegate];
        
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
            //メール作成画面表示
            [self showComposerSheet];
        }
    }
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
    }
}
-(void) setAlert:(NSString *) aDescription {
    SharpScanPrintAppDelegate* appDelegate = (SharpScanPrintAppDelegate*)[[UIApplication sharedApplication] delegate];
    // 処理実行フラグON
    appDelegate.IsRun = TRUE;
    
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil
                                                                             message:aDescription
                                                                      preferredStyle:UIAlertControllerStyleAlert];
    // Cancel用のアクションを生成
    UIAlertAction * cancelAction =
    [UIAlertAction actionWithTitle:MSG_BUTTON_OK
                             style:UIAlertActionStyleCancel
                           handler:^(UIAlertAction * action) {
                               
                               // ボタンタップ時の処理
                               [self appDelegateIsRunOff];
                           }];
    
    // コントローラにアクションを追加
    [alertController addAction:cancelAction];
    // アラート表示処理
    [self presentViewController:alertController animated:YES completion:nil];
    
}

// 「メールに添付する」ボタン押下時の処理
- (void)createAlertMailTemp {
    
    //
    // アラート表示
    //
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil
                                                                             message:MSG_MAIL_ATTACH_CONFIRM
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
                               [self appDelegateIsRunOff];
                               [self showComposerSheet];
                           }];
    
    // コントローラにアクションを追加
    [alertController addAction:cancelAction];
    [alertController addAction:okAction];
    // アラート表示処理
    [self presentViewController:alertController animated:YES completion:nil];
}

// 処理実行フラグをOFFにする
- (void)appDelegateIsRunOff {
    // ボタンタップ時の処理
    SharpScanPrintAppDelegate* appDelegate = (SharpScanPrintAppDelegate*)[[UIApplication sharedApplication] delegate];
    // 処理実行フラグOFF
    appDelegate.IsRun = FALSE;
}

// ボタン押下関数
// メニューボタン2押下
- (IBAction)OnMenuSecondButton:(id)sender
{
    // 処理中あるいは処理中断フラグ=TRUEの場合は何もしない
    if (self.m_pThread || m_bAbort)
    {
        return;
    }
	
	DLog(@"送るボタン押下");
	
	//表示中の画像は前画面で選択したファイル。
	NSString *urlString = self.SelFilePath;
	
	m_diCtrl = [UIDocumentInteractionController interactionControllerWithURL:[NSURL fileURLWithPath:urlString]];
	m_diCtrl.delegate = self;
	BOOL isShow = [m_diCtrl presentOpenInMenuFromRect:CGRectZero
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
    
    // エラーメッセージ表示
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil
                                                                             message:MSG_NO_SEND_APP
                                                                      preferredStyle:UIAlertControllerStyleAlert];
    
    // Cancel用のアクションを生成
    UIAlertAction * cancelAction =
    [UIAlertAction actionWithTitle:MSG_BUTTON_OK
                             style:UIAlertActionStyleCancel
                           handler:^(UIAlertAction * action) {
                               
                               // ボタンタップ時の処理
                               [self appDelegateIsRunOff];
                           }];
    
    // コントローラにアクションを追加
    [alertController addAction:cancelAction];
    // アラート表示処理
    [self presentViewController:alertController animated:YES completion:nil];
}

- (void)documentInteractionController:(UIDocumentInteractionController *)controller willBeginSendingToApplication:(NSString *)application {
	DLog(@"!!!!! Sending to: %@", application);
}

- (void)documentInteractionController:(UIDocumentInteractionController *)controller didEndSendingToApplication:(NSString *)application {
	//DLog(@"!!!!! Sent to: %@", application);
	[m_diCtrl dismissMenuAnimated:YES];
    
}
@end
