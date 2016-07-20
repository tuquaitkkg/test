
#import "SendExSitePictViewController_iPad.h"
#import "PrintPictViewController_iPad.h"
#import "Define.h"
#import "RootViewController_iPad.h"
// iPad用
#import "SharpScanPrintAppDelegate.h"
// iPad用


@implementation SendExSitePictViewController_iPad

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
    //[super InitView:S_TITLE_SEND
    //     menuBtnNum:PrvMenuIDFirst];
    [super InitView:S_TITLE_SEND menuBtnNum:PrvMenuIDFirst hidesBackButton:YES hidesSettingButton:YES];
    // iPad用
    
	// メニュー作成
    NSString* pstrBtnName = nil;        // ボタン名称
    //NSString* pstrInitValue = nil;    // 表示初期値 // iPad用
    NSString* pstrIconName = nil;       // アイコン名称
    NSString* pstrLabelName = nil;      // ラベル名称 iPad用
    
    for (NSInteger nCnt = PrvMenuIDFirst; nCnt <= PrvMenuIDFirst; nCnt++)
    {
        switch (nCnt)
        {
            case PrvMenuIDFirst:
                pstrBtnName = S_BUTTON_SEND_IPAD;
                //pstrInitValue = @""; // iPad用
                pstrIconName = S_ICON_SEND_SEND;
                break;
            default:
                break;
        }
        
        // iPad用
        //[super CreateMenu:nCnt
        //          btnName:pstrBtnName
        //        initValue:pstrInitValue
        //         iconName:pstrIconName];
        [super CreateMenu:nCnt
                  btnName:pstrBtnName
                 iconName:pstrIconName
                  lblName:pstrLabelName];
        // iPad用
	}
    // CommonManagerクラス生成
    m_pCmnMgr = [[CommonManager alloc] init];
    
    // ボタンを2行表示するかチェック
    [m_pCmnMgr btnTwoLineChange:self.m_pbtnFirst];
	
    // iPad用
	////設定ボタン非表示設定
	//[self.navigationItem setRightBarButtonItem:nil animated:YES];
    // iPad用
    
    // スレッド開始
    [super StartThread];
	
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
            self.IsSendExSitePictView = YES;
            // ファイル表示
            [super ShowFile:self.SelFilePath];}
        
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
    
    [self performSelector:@selector(popRootView) withObject:nil afterDelay:0.1];
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
}

- (void)popRootView
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
