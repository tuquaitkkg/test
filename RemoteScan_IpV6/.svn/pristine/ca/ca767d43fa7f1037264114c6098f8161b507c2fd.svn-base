
#import "ScanAfterPreViewController.h"
#import "Define.h"
#import "SharpScanPrintAppDelegate.h"

@implementation ScanAfterPreViewController

@synthesize resource;						// 表示ファイル
@synthesize fileType;							// ファイル形式
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
    [super InitView:S_TITLE_SCAN
         menuBtnNum:PrvMenuIDFirst];
    // メニュー作成
    NSString* pstrBtnName = nil;        // ボタン名称
    NSString* pstrInitValue = nil;      // 表示初期値
    NSString* pstrIconName = nil;       // アイコン名称
    
    for (NSInteger nCnt = PrvMenuIDFirst; nCnt <= PrvMenuIDFirst; nCnt++)
    {
        switch (nCnt)
        {
            case PrvMenuIDFirst:
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
    
    
    self.navigationItem.rightBarButtonItem = FALSE;
    
    self.view.backgroundColor = BACKGROUND_COLOR;// TableViewに合わせた背景を設定
    if([[[UIDevice currentDevice] systemVersion] floatValue] >= 6.0 &&
       [[[UIDevice currentDevice] systemVersion] floatValue] < 7.0 &&
       UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
    {// iOS6のiPhoneだけ
        UITableView *tableView = [[UITableView alloc] initWithFrame:[[UIScreen mainScreen] bounds] style:UITableViewStyleGrouped];
        [self.view addSubview:tableView];
        [self.view sendSubviewToBack:tableView];
    }
    
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
        
        // ファイル情報
        
        if (!m_bAbort)
        {
            // ファイル表示
            [super ShowFile:self.tempFile.tempFilePath];
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
// メニューボタン2押下
- (IBAction)OnMenuFirstButton:(id)sender
{
    // 処理中あるいは処理中断フラグ=TRUEの場合は何もしない
    if (self.m_pThread || m_bAbort)
    {
        return;
    }
	
	DLog(@"送るボタン押下");
	
	//表示中の画像は前画面で選択したファイル。
    NSString *urlString = self.tempFile.tempFilePath;
	
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

// 処理実行フラグをOFFにする
- (void)appDelegateIsRunOff {
    // ボタンタップ時の処理
    SharpScanPrintAppDelegate* appDelegate = (SharpScanPrintAppDelegate*)[[UIApplication sharedApplication] delegate];
    // 処理実行フラグOFF
    appDelegate.IsRun = FALSE;
}

- (void)documentInteractionController:(UIDocumentInteractionController *)controller willBeginSendingToApplication:(NSString *)application {
	DLog(@"!!!!! Sending to: %@", application);
}

- (void)documentInteractionController:(UIDocumentInteractionController *)controller didEndSendingToApplication:(NSString *)application {
	//DLog(@"!!!!! Sent to: %@", application);
	[m_diCtrl dismissMenuAnimated:YES];
    
}
@end
