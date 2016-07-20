
#import "ScanAfterPictViewController_iPad.h"
#import "Define.h"
#import "SaveScanAfterDataViewController.h"
#import "RenameScanAfterDataViewController.h"
// iPad用
#import "SharpScanPrintAppDelegate.h"
// iPad用

@implementation ScanAfterPictViewController_iPad

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
    
    // 戻るボタンは非表示
    [self.navigationItem setHidesBackButton:YES];
    
    // メインビュー初期化
    // iPad用 戻るボタン表示
    //[super InitView:S_TITLE_SCAN
    //     menuBtnNum:PrvMenuIDFirst];
    [super InitView:S_TITLE_SCAN menuBtnNum:PrvMenuIDSeventh hidesBackButton:NO hidesSettingButton:YES];
    // iPad用
    
    // メニュー作成
    NSString* pstrBtnName = nil;            // ボタン名称
    //NSString* pstrInitValue = nil;        // 表示初期値 // iPad用
    NSString* pstrIconName = nil;           // アイコン名称
    NSString* pstrLabelName = nil;          // ラベル名称 iPad用
    
    for (NSInteger nCnt = PrvMenuIDFirst; nCnt <= PrvMenuIDSeventh; nCnt++)
    {
        switch (nCnt)
        {
            case PrvMenuIDFirst:
                //                pstrBtnName = S_BUTTON_SAVE;
                //                // ToDo:内部メモリから最新プリンタ情報を取得する必要あり
                //                pstrIconName = S_ICON_SCAN_SAVE;
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
                pstrBtnName = S_BUTTON_SAVE;
                // ToDo:内部メモリから最新プリンタ情報を取得する必要あり
                pstrIconName = S_ICON_SCAN_SAVE;
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
    
    //
	// [キャンセル]ボタンの追加（Navigation Item）
	//
	self.navigationItem.leftBarButtonItem	= [[UIBarButtonItem alloc]
                                               initWithTitle:S_BUTTON_CANCEL
                                               style:UIBarButtonItemStylePlain
                                               target:self
                                               action:@selector(doCancel:)];
    
    
    self.navigationItem.rightBarButtonItem = FALSE;
    // スレッド開始
    [super StartThread];
}

- (void)viewWillAppear:(BOOL)animated
{
    // pictureviewControllerのviewwillappearが実行されないいようにするために実装
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
- (IBAction)OnMenuSeventhButton:(id)sender
{
    // 処理中あるいは処理中断フラグ=TRUEの場合は何もしない
    if (m_pThread || m_bAbort)
    {
        return;
    }
    
    // 画面遷移
    RenameScanAfterDataViewController* controller;
    controller = [[RenameScanAfterDataViewController alloc] initWithNibName:@"FileNameChangeViewController" bundle:nil];
    controller.delegate = self;
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


//
// キャンセルボタン処理
//
-(IBAction)doCancel:(id)sender
{
    // ダイアログ表示
    SharpScanPrintAppDelegate* appDelegate = (SharpScanPrintAppDelegate*)[[UIApplication sharedApplication] delegate];
    // 処理実行フラグON
    appDelegate.IsRun = TRUE;
    
    [self makeTmpExAlert:nil message:MSG_DEL_CONFIRM cancelBtnTitle:MSG_BUTTON_CANCEL okBtnTitle:MSG_BUTTON_OK tag:2 showFlg:YES];
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
    
    return [super shouldAutorotateToInterfaceOrientation:interfaceOrientation];
    // iPad用
}

- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation
{
    [super didRotateFromInterfaceOrientation:fromInterfaceOrientation];
    
	// [キャンセル]ボタンの追加（Navigation Item）
	self.navigationItem.leftBarButtonItem	= [[UIBarButtonItem alloc]
                                               initWithTitle:S_BUTTON_CANCEL
                                               style:UIBarButtonItemStylePlain
                                               target:self
                                               action:@selector(doCancel:)];
}

// アラートボタン押下処理
-(void)alertButtonPushed:(UIAlertController *)alertController tagIndex:(NSInteger)tagIndex buttonIndex:(NSInteger)buttonIndex
{
    [self alertButtonClicked:alertController tagIndex:tagIndex buttonIndex:buttonIndex];
    [self alertButtonDismiss:alertController tagIndex:tagIndex buttonIndex:buttonIndex];
}

-(void)alertButtonClicked:(UIAlertController *)alertController tagIndex:(NSInteger)tagIndex buttonIndex:(NSInteger)buttonIndex
{
    if(tagIndex == 2)
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
        }
    }
}

-(void)alertButtonDismiss:(UIAlertController *)alertController tagIndex:(NSInteger)tagIndex buttonIndex:(NSInteger)buttonIndex
{
    // iPad用
    SharpScanPrintAppDelegate* appDelegate = (SharpScanPrintAppDelegate*)[[UIApplication sharedApplication] delegate];
    // 処理実行フラグOFF
    appDelegate.IsRun = FALSE;
    if(tagIndex == 2 && buttonIndex != 0)
    {
        [self.navigationController popViewControllerAnimated:YES];
    }
}

// 縦表示時のメニューボタン設定
- (void)setPortraitMenu:(UIBarButtonItem *)barButtonItem
{
    // 戻るボタンがあるためメニューを表示しない
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
    NSString *urlString = self.tempFile.tempFilePath;
	
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

#pragma mark FileNameChangeViewControllerDelegate
-(void)nameChange:(UIViewController*)viewController didNameChangeSuccess:(BOOL)bSuccess
{
    FileNameChangeViewController* nameChangeView = (FileNameChangeViewController*)viewController;
    
    // モーダルを閉じる
    [nameChangeView dismissViewControllerAnimated:YES completion:nil];
    
    // デリゲートをクリア
    nameChangeView.delegate = nil;
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
