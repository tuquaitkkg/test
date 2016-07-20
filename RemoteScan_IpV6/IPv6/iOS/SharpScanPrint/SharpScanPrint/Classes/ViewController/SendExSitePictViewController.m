
#import "SendExSitePictViewController.h"
#import "MulitPrintPictPreViewController.h"
#import "PrintPictViewController.h"
#import "Define.h"
#import "RootViewController.h"
#import "SharpScanPrintAppDelegate.h"

@implementation SendExSitePictViewController

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
    [super InitView:S_TITLE_SEND
         menuBtnNum:PrvMenuIDFirst];
    
    // タイトル設定
    CGSize size = [S_TITLE_SEND sizeWithFont:[UIFont boldSystemFontOfSize:20]];
    CGRect frame = CGRectMake(0, 0, size.width, 44);
    UILabel* lblTitle = [[UILabel alloc]initWithFrame:frame];
    lblTitle.backgroundColor = [UIColor clearColor];
    lblTitle.textColor = NAVIGATION_TITLE_COLOR;
    lblTitle.font = [UIFont boldSystemFontOfSize:20];
    lblTitle.textAlignment = NSTextAlignmentCenter;
    lblTitle.adjustsFontSizeToFitWidth = YES;
    lblTitle.text = S_TITLE_SEND;
    self.navigationItem.titleView = lblTitle;
    
	// メニュー作成
    NSString* pstrBtnName;      // ボタン名称
    NSString* pstrInitValue;    // 表示初期値
    NSString* pstrIconName;     // アイコン名称
    
    for (NSInteger nCnt = PrvMenuIDFirst; nCnt <= PrvMenuIDFirst; nCnt++)
    {
        switch (nCnt)
        {
            case PrvMenuIDFirst:
                pstrBtnName = S_BUTTON_SEND;
                // 印刷前プレビュー画面(複数)の場合は、「他アプリで確認」のボタン名に変更
                if ([self isKindOfClass:[MulitPrintPictPreViewController class]]) {
                    pstrBtnName = S_BUTTON_OTHER_APP;
                }
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

// 画面非表示前処理
- (void)viewWillDisappear:(BOOL)animated
{
	//デフォルト処理
	[super viewWillDisappear:animated];
    //スレッド終了
	[self StopThread];
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
            self.IsSendExSitePictView = YES;
            // ファイル表示
            [super ShowFile:self.SelFilePath];
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
- (IBAction)OnMenuFirstButton:(id)sender
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
	BOOL isShow = [m_diCtrl presentOpenInMenuFromRect:CGRectZero inView:self.view animated:YES];
	
	if(!isShow)
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
    
    [self performSelector:@selector(popRootView) withObject:nil afterDelay:0.1];
}

// 処理実行フラグをOFFにする
- (void)appDelegateIsRunOff {
    // ボタンタップ時の処理
    SharpScanPrintAppDelegate* appDelegate = (SharpScanPrintAppDelegate*)[[UIApplication sharedApplication] delegate];
    // 処理実行フラグOFF
    appDelegate.IsRun = FALSE;
}

- (void)popRootView
{
    [self.navigationController popToRootViewControllerAnimated:NO];
}

@end
