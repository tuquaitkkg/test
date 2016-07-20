
#import "ArrangePictViewController.h"
#import "SharpScanPrintAppDelegate.h"
#import "Define.h"
#import "CommonUtil.h"

@implementation ArrangePictViewController

@synthesize SelImagePath;
@synthesize IndexPath;
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
    [super InitView:S_TITLE_ARRANGE
         menuBtnNum:PrvMenuIDSecond];
    // メニュー作成
    NSString* pstrBtnName = nil;        // ボタン名称
    NSString* pstrInitValue = nil;      // 表示初期値
    NSString* pstrIconName = nil;       // アイコン名称
    
    for (NSInteger nCnt = PrvMenuIDFirst; nCnt <= PrvMenuIDSecond; nCnt++)
    {
        switch (nCnt)
        {
            case PrvMenuIDFirst:
                pstrBtnName = S_BUTTON_DEL;
                //内部メモリから最新プリンタ情報を取得する必要あり
                pstrIconName = S_ICON_ARRANGE_DEL;
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

    self.navigationItem.rightBarButtonItem = FALSE;
    // スレッド開始
    [super StartThread];
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
- (IBAction)OnMenuFirstButton:(id)sender
{
    // 処理中あるいは処理中断フラグ=TRUEの場合は何もしない
    if (self.m_pThread || m_bAbort)
    {
        return;
    }
    
    // 「ファイルを削除する」ボタン押下時の処理
    [self createAlertFileDelete];
}

// 「ファイルを削除する」ボタン押下時の処理
- (void)createAlertFileDelete {
    SharpScanPrintAppDelegate* appDelegate = (SharpScanPrintAppDelegate*)[[UIApplication sharedApplication] delegate];
    // 処理実行フラグON
    appDelegate.IsRun = TRUE;
    
    //
    // アラート表示
    //
    alert = [UIAlertController alertControllerWithTitle:nil
                                                message:MSG_DEL_CONFIRM
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
                               [self okButtonPushed];
                           }];
    
    // コントローラにアクションを追加
    [alert addAction:cancelAction];
    [alert addAction:okAction];
    // アラート表示処理
    [self presentViewController:alert animated:YES completion:nil];
}

// 処理実行フラグをOFFにする
- (void)appDelegateIsRunOff {
    // ボタンタップ時の処理
    SharpScanPrintAppDelegate* appDelegate = (SharpScanPrintAppDelegate*)[[UIApplication sharedApplication] delegate];
    // 処理実行フラグOFF
    appDelegate.IsRun = FALSE;
}

// OKボタンタップ時の処理(削除用)
- (void)okButtonPushed {
    DLog(@"OKボタン押下");
    ScanDataManager *scanManager = [[ScanDataManager alloc]init];
    [scanManager reGetScanData];  //　現在のデータを取ってくる
    
    //
    // ファイル削除
    //
    ScanFile *deleteScanFile = [[ScanFile alloc] initWithScanFilePath:self.SelFilePath];
    BOOL bRet = [ScanFileUtility deleteFile:deleteScanFile];
    if (bRet == YES)
    {
        
        //
        // 完了した場合
        //
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil
                                                                                 message:MSG_DEL_COMPLETE
                                                                          preferredStyle:UIAlertControllerStyleAlert];
        // OK用のアクションを生成
        UIAlertAction * okAction =
        [UIAlertAction actionWithTitle:MSG_BUTTON_OK
                                 style:UIAlertActionStyleDefault
                               handler:^(UIAlertAction * action) {
                                   
                                   // ボタンタップ時の処理
                                   [self appDelegateIsRunOff];
                                   [self.navigationController popViewControllerAnimated:YES];
                               }];
        
        // コントローラにアクションを追加
        [alertController addAction:okAction];
        // アラート表示処理
        [self presentViewController:alertController animated:YES completion:nil];
        
    }
    else
    {
        //
        // 削除に失敗した場合
        //
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil
                                                                                 message:MSG_DEL_ERR
                                                                          preferredStyle:UIAlertControllerStyleAlert];
        // NG用のアクションを生成
        UIAlertAction * ngAction =
        [UIAlertAction actionWithTitle:MSG_BUTTON_OK
                                 style:UIAlertActionStyleDefault
                               handler:^(UIAlertAction * action) {
                                   
                                   // ボタンタップ時の処理
                                   [self appDelegateIsRunOff];
                               }];
        
        // コントローラにアクションを追加
        [alertController addAction:ngAction];
        // アラート表示処理
        [self presentViewController:alertController animated:YES completion:nil];
        return;
        
    }
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
	BOOL isShow = [m_diCtrl presentOpenInMenuFromRect:CGRectZero inView:self.view animated:YES];

    if(!isShow)
    {//ひとつも対応するアプリがない場合
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
