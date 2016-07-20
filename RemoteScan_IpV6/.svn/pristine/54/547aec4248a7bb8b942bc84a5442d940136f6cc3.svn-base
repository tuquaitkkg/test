
#import "ScanAfterPictViewController.h"
#import "Define.h"
#import "SharpScanPrintAppDelegate.h"
#import "RenameScanAfterDataViewController.h"

@implementation ScanAfterPictViewController

@synthesize SelImagePath;
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
                pstrBtnName = S_BUTTON_SAVE;
                // ToDo:内部メモリから最新プリンタ情報を取得する必要あり
                pstrIconName = S_ICON_SCAN_SAVE;
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
    //
	// [キャンセル]ボタンの追加（Navigation Item）
	//
	self.navigationItem.leftBarButtonItem	= [[UIBarButtonItem alloc]
                                               initWithTitle:S_BUTTON_CANCEL
                                               style:UIBarButtonItemStylePlain
                                               target:self
                                               action:@selector(doCancel:)];
    
    
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

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    // ナビゲーションバー上ボタンのマルチタップを制御する
    for (UIView * view in self.navigationController.navigationBar.subviews) {
        if ([view isKindOfClass: [UIView class]]) {
            [view setExclusiveTouch:YES];
        }
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
            m_bAfterView = YES;
            // ファイル表示
            [super ShowFile:self.tempFile.tempFilePath];
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
    
    // 画面遷移
    RenameScanAfterDataViewController* controller;
    controller = [[RenameScanAfterDataViewController alloc] initWithNibName:@"FileNameChangeViewController" bundle:nil];
    // 送り元
    controller.isMulti = NO;
    
    // 選択ファイルパス格納
    controller.tempFile = self.tempFile;
    controller.SelFileName = self.tempFile.tempFileName;
    controller.isDirectory = NO;
    
    // モーダル表示
    UINavigationController *navigationController = [[UINavigationController alloc]initWithRootViewController:controller];
    navigationController.navigationBar.barStyle = NAVIGATION_BARSTYLE;
    [navigationController setModalPresentationStyle:UIModalPresentationPageSheet];
    [self presentViewController:navigationController animated:YES completion:nil];
}


// キャンセル処理
-(IBAction)doCancel:(id)sender
{
    // ダイアログ表示
    SharpScanPrintAppDelegate* appDelegate = (SharpScanPrintAppDelegate*)[[UIApplication sharedApplication] delegate];
    // 処理実行フラグON
    appDelegate.IsRun = TRUE;
    
    UIAlertController *tempAlert = [UIAlertController alertControllerWithTitle:nil
                                                                       message:MSG_DEL_CONFIRM
                                                                preferredStyle:UIAlertControllerStyleAlert];
    
    // Cancel用のアクションを生成
    UIAlertAction *cancelAction =
    [UIAlertAction actionWithTitle:MSG_BUTTON_CANCEL
                             style:UIAlertActionStyleCancel
                           handler:^(UIAlertAction * action) {
                               
                               // ボタンタップ時の処理
                               [self alertButtonPushed:tempAlert tagIndex:2 buttonIndex:0];
                           }];
    
    // OK用のアクションを生成
    UIAlertAction *okAction =
    [UIAlertAction actionWithTitle:MSG_BUTTON_OK
                             style:UIAlertActionStyleDefault
                           handler:^(UIAlertAction * action) {
                               
                               // ボタンタップ時の処理
                               [self alertButtonPushed:tempAlert tagIndex:2 buttonIndex:1];
                           }];
    
    // コントローラにアクションを追加
    [tempAlert addAction:cancelAction];
    [tempAlert addAction:okAction];
    // アラート表示処理
    [self presentViewController:tempAlert animated:YES completion:nil];
}

// モーダル表示した画面を閉じ、TOPに戻る
- (void)OnClose
{
    [self dismissViewControllerAnimated:YES completion:nil];
    [self.navigationController popToRootViewControllerAnimated:YES];
}

// モーダル表示した画面を閉じる
- (void)OnCancel
{
    [self dismissViewControllerAnimated:YES completion:nil];
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

//ダイアログのボタン押下時
-(void)alertButtonPushed:(UIAlertController *)alertController tagIndex:(NSInteger)tagIndex buttonIndex:(NSInteger)buttonIndex{

    SharpScanPrintAppDelegate* appDelegate = (SharpScanPrintAppDelegate*)[[UIApplication sharedApplication] delegate];
    // 処理実行フラグOFF
    appDelegate.IsRun = FALSE;
    
    if(tagIndex == 1)
    {
        [self.navigationController popToRootViewControllerAnimated:YES];
    } else if(tagIndex == 2)
    {
        if(buttonIndex != 0){
            //削除処理
            //
            // ファイル削除
            //
            
            @autoreleasepool
            {
               [TempFileUtility deleteFile:self.tempFile];
            }
            
            [self.navigationController popViewControllerAnimated:YES];
        }
        
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
