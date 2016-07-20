
#import "ScanBeforePictViewController_iPad.h"
#import "Define.h"
#import "ProfileDataManager.h"
#import "CommonUtil.h"
#import "ScanAfterPictViewController_iPad.h"
#import "TempDataTableViewController_iPad.h"
// iPad用
//#import "SharpScanPrintAppDelegate.h"
#import "SharpScanPrintAppDelegate.h"
// iPad用
#import "RemoteScanBeforePictViewController_iPad.h"

@implementation ScanBeforePictViewController_iPad

//
// アクセサメソッドの自動合成(ゲッターとセッターの役割)
//
@synthesize baseDir;							// ホームディレクトリ/Documments/
@synthesize iPaddr;								// IPアドレス
@synthesize ScanFileName;						// スキャンファイル名称
@synthesize mfp_iPaddr;							// MFPIPアドレス
@synthesize selectInd;							// 選択位置
@synthesize isDelProfile = m_IsDelProfile;                       // プロファイル削除フラグ
@synthesize isModProfile = m_IsModProfile;
@synthesize isRecComp = m_IsRecComp;                       // プロファイル削除フラグ
@synthesize ScanUser = m_ScanUser;
@synthesize ScanPass = m_ScanPass;
@synthesize isShowAlert = m_isShowAlert;        // 初期表示時のアラート表示フラグ
@synthesize isShowMenu = m_isShowMenu;          // 初期表示時のメニュー表示フラグ
@synthesize scanerPickerRow;
@synthesize canceled;

@synthesize selectedPrinterPrimaryKey;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
        // Custom initialization
        // 変数初期化
        [super InitObject];
        self.isShowAlert = YES;
        self.canceled = NO;
        
        self.scanerPickerRow = -1;
        selectedPrinterPrimaryKey = nil;
    }
    self.selectInd = -1;
    
    return self;
}

- (void)dealloc
{
    
    // iPad用
    //SharpScanPrintAppDelegate* appDelegate = (SharpScanPrintAppDelegate*)[[UIApplication sharedApplication] delegate];
    SharpScanPrintAppDelegate* appDelegate = (SharpScanPrintAppDelegate*)[[UIApplication sharedApplication] delegate];
    // iPad用
    appDelegate.IsRun = FALSE;
    // iPad用
    if (nil != commanager)
    {
        commanager = nil;
    }
    if (nil != profileDataManager)
    {
        profileDataManager = nil;
    }
    if (nil != m_pPrinterMgr)
    {
        m_pPrinterMgr = nil;
    }
    if (nil != m_pPrintOutMgr)
    {
        m_pPrintOutMgr = nil;
    }
    // iPad用
    if (nil != selectMfpIpAddress)
    {
        selectMfpIpAddress = nil;
    }
    if (nil != selectMfpRSPortNo)
    {
        selectMfpRSPortNo = nil;
    }
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
    
    // UINavigationBar 44px のずれを無くす
    self.navigationController.navigationBar.translucent = NO;
    self.navigationController.navigationBar.barStyle = NAVIGATION_BARSTYLE;
    
    // PrinterDataManagerクラス初期化
    m_pPrinterMgr = [[PrinterDataManager alloc] init];
    
    // PrintOutDataManagerクラス初期化
    m_pPrintOutMgr = [[PrintOutDataManager alloc] init];
	//
	// CommonManager クラスのインスタンス取得
	//
	commanager = [[CommonManager alloc]init];
    
    
    // メインビュー初期化
    // iPad用 戻るボタン表示
    //[super InitView:S_TITLE_SCAN
    //     menuBtnNum:PrvMenuIDSecond];
    [super InitView:[CommonUtil getSSID] menuBtnNum:PrvMenuIDSecond hidesBackButton:NO hidesSettingButton:NO];
    // iPad用
    
    // メニュー作成
    NSString* pstrBtnName = S_BUTTON_NO_SCANNER;      // ボタン名称
    //NSString* pstrInitValue = nil;        // 表示初期値  // iPad用
    NSString* pstrIconName = nil;           // アイコン名称
    NSString* pstrLabelName = nil;          // ラベル名称 iPad用
    
    // プリンタ情報取得
    PrinterData* printerData = nil;
    
    // 最新プライマリキー取得
    NSString* pstrKey = [m_pPrintOutMgr GetLatestPrimaryKey];
    // 接続先WiFiの最新プライマリキー取得
    NSString* pstrKeyForCurrentWiFi = [m_pPrintOutMgr GetLatestPrimaryKeyForCurrentWiFi];
    // 選択中MFP取得
    [m_pPrinterMgr SetDefaultMFPIndex:pstrKey PrimaryKeyForCurrrentWifi:pstrKeyForCurrentWiFi];
    // 選択中MFP情報取得
    //    printerData = [m_pPrinterMgr LoadPrinterDataAtIndex2:m_pPrinterMgr.DefaultMFPIndex];
    if(scanerPickerRow < 0)
    {
        self.scanerPickerRow  = m_pPrinterMgr.DefaultMFPIndex;
        
        PrinterData* printerData = nil;
        printerData = [m_pPrinterMgr LoadPrinterDataAtIndexInclude2:scanerPickerRow];
        
    }
    printerData = [m_pPrinterMgr LoadPrinterDataAtIndexInclude2:scanerPickerRow];
    
    m_bButtonEnable = NO;
    if (printerData != nil)
    {
        //pstrInitValue = [printerData PrinterName]; // iPad用
        m_bButtonEnable = YES;
        selectMfpIpAddress = [printerData.IpAddress copy];
        selectMfpRSPortNo = [printerData.RSPortNo copy];
    }
    for (NSInteger nCnt = PrvMenuIDFirst; nCnt <= PrvMenuIDFourth; nCnt++)
    {
        switch (nCnt)
        {
            case PrvMenuIDFirst:
                // iPad用
                //if(printerData != nil)
                //{
                //    pstrBtnName = S_BUTTON_SCAN;
                //}
                //pstrInitValue = [printerData PrinterName];
                pstrBtnName = S_BUTTON_SCAN_IPAD;
                // iPad用
                pstrIconName = S_ICON_SCAN_SCAN;
                break;
            case PrvMenuIDSecond:
                // iPad用
                //if(printerData != nil)
                //{
                //    pstrBtnName = S_BUTTON_SCANNER;
                //}
                //pstrInitValue = [printerData PrinterName];
                pstrBtnName = S_BUTTON_NO_SCANNER;
                if (printerData != nil)
                {
                    pstrBtnName = [printerData getPrinterName];
                }
                pstrLabelName = S_LABEL_SCANER_IPAD;
                // iPad用
                pstrIconName = S_ICON_SCAN_SCANNER;
				self.m_nSelPickerRow2 = scanerPickerRow;
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
    
    // 選択可能なプリンターが存在しない場合
    if(printerData == nil)
    {
        // iPad用
        //SharpScanPrintAppDelegate* appDelegate = (SharpScanPrintAppDelegate*)[[UIApplication sharedApplication] delegate];
        SharpScanPrintAppDelegate* appDelegate = (SharpScanPrintAppDelegate*)[[UIApplication sharedApplication] delegate];
        // iPad用
        // 処理実行フラグON
        appDelegate.IsRun = TRUE;
        m_isScanStop = TRUE;
        // iPad用
        // 折り返し表示
        self.m_pbtnSecond.titleLabel.lineBreakMode = NSLineBreakByWordWrapping;
        self.m_pbtnSecond.titleLabel.font = [UIFont systemFontOfSize:N_BUTTON_FONT_SIZE_LITTLE];
        [self performSelector:@selector(CreateNoScannerAlert) withObject:nil afterDelay:0.0];
        // iPad用
    }
    
    // ボタン1の上に"端末側からスキャナーの設定を行う"スイッチとラベルを配置
    CGPoint putPt = self.m_pbtnFirst.frame.origin;
    putPt.y -= 75;
    remoteSwitchBaseView = [[UIView alloc]initWithFrame:(CGRect){putPt,180,80}];
    remoteSwitchBaseView.autoresizingMask = self.m_pbtnFirst.autoresizingMask;
//    remoteSwitchBaseView.hidden = !printerData.IsCapableRemoteScan;
    [self.view addSubview:remoteSwitchBaseView];
    
    UILabel* remoteSwitchLbl = [[UILabel alloc]initWithFrame:(CGRect){0,0,180,30}];
    remoteSwitchLbl.backgroundColor = [UIColor clearColor];
    remoteSwitchLbl.autoresizingMask = self.m_pbtnFirst.autoresizingMask;
    remoteSwitchLbl.adjustsFontSizeToFitWidth = YES;
    remoteSwitchLbl.minimumScaleFactor = 4 / remoteSwitchLbl.font.pointSize;
    remoteSwitchLbl.text = S_LABEL_REMOTESWITCH;
    [remoteSwitchBaseView addSubview:remoteSwitchLbl];
    
    UISwitch* remoteSwt = [[UISwitch alloc]init];
    putPt = remoteSwitchLbl.center;
    putPt.y += 35;
    remoteSwt.center = putPt;
    remoteSwt.autoresizingMask = self.m_pbtnFirst.autoresizingMask;
    remoteSwt.on = ([self isMemberOfClass:[RemoteScanBeforePictViewController_iPad class]]);
    [remoteSwt addTarget:self action:@selector(tapRemoteSwt:) forControlEvents:UIControlEventValueChanged];
    [remoteSwitchBaseView addSubview:remoteSwt];
    
//    //
//	// 通知センタ登録
//	//
//	NSNotificationCenter* center;
//	center = [NSNotificationCenter defaultCenter];
//    
//    // 重複防止
//    //    [nc removeObserver:self];
//    [center removeObserver:self name:@"setFTPReceiveResponceNotification" object:nil];
//    [center removeObserver:self name:@"setHttpAddResponceNotification" object:nil];
//    [center removeObserver:self name:@"setHttpModResponceNotification" object:nil];
//    [center removeObserver:self name:@"setHttpDelResponceNotification" object:nil];
//    [center removeObserver:self name:@"setHTTPInternalErrorNotification" object:nil];
//
//	// FTP
//	[center addObserver:self selector:@selector(FtpReceiveResponceNotification:)  name:@"setFTPReceiveResponceNotification"  object:nil];
//	// HTTP
//	[center addObserver:self selector:@selector(HttpAddResponceNotification:)   name:@"setHttpAddResponceNotification"   object:nil];
//	[center addObserver:self selector:@selector(HttpModResponceNotification:)   name:@"setHttpModResponceNotification"   object:nil];
//	[center addObserver:self selector:@selector(HttpDelResponceNotification:)   name:@"setHttpDelResponceNotification"   object:nil];
//	[center addObserver:self selector:@selector(HttpInternalErrorNotification:) name:@"setHTTPInternalErrorNotification" object:nil];
    
}

//画面表示前処理
- (void)viewWillAppear:(BOOL)animated
{
    //
	// 通知センタ登録
	//
	NSNotificationCenter* center;
	center = [NSNotificationCenter defaultCenter];
    
    // 重複防止
    //    [nc removeObserver:self];
    [center removeObserver:self name:@"setFTPReceiveResponceNotification" object:nil];
    [center removeObserver:self name:@"setHttpAddResponceNotification" object:nil];
    [center removeObserver:self name:@"setHttpModResponceNotification" object:nil];
    [center removeObserver:self name:@"setHttpDelResponceNotification" object:nil];
    [center removeObserver:self name:@"setHTTPInternalErrorNotification" object:nil];
    
	// FTP
	[center addObserver:self selector:@selector(FtpReceiveResponceNotification:)  name:@"setFTPReceiveResponceNotification"  object:nil];
	// HTTP
	[center addObserver:self selector:@selector(HttpAddResponceNotification:)   name:@"setHttpAddResponceNotification"   object:nil];
	[center addObserver:self selector:@selector(HttpModResponceNotification:)   name:@"setHttpModResponceNotification"   object:nil];
	[center addObserver:self selector:@selector(HttpDelResponceNotification:)   name:@"setHttpDelResponceNotification"   object:nil];
	[center addObserver:self selector:@selector(HttpInternalErrorNotification:) name:@"setHTTPInternalErrorNotification" object:nil];

    // メインビュー初期化
    // iPad用 戻るボタン表示
    [super InitView:[CommonUtil getSSID]
         menuBtnNum:PrvMenuIDSecond
    hidesBackButton:NO
 hidesSettingButton:NO
   setHiddenNoImage:YES];
    
    //NO Image表示
    [super setNoImageHidden:NO];
    
    // iPad用
    // 縦表示の時はメニューボタンを表示
    SharpScanPrintAppDelegate* pAppDelegate = (SharpScanPrintAppDelegate*)[[UIApplication sharedApplication] delegate];
    [pAppDelegate setPortraitMenuButton];
    // iPad用
    
    // iPad用
	//NSString* pstrTitle = S_BUTTON_NO_SCANNER;			// ボタン表示名称
    //NSString* pstrBtnName = @"";        // ボタン名称
    //NSString* pstrInitValue = @"";      // 表示初期値
    // iPad用
    NSString* pstrInitValue = S_BUTTON_NO_SCANNER;      // 表示初期値
    
    // プリンタ情報取得
    PrinterData* printerData = nil;
    
    //プリンタ情報更新
    m_pPrinterMgr.PrinterDataList = [m_pPrinterMgr ReadPrinterData];
    // 最新プライマリキー取得
    NSString* pstrKey = [m_pPrintOutMgr GetLatestPrimaryKey];
    // 接続先WiFiの最新プライマリキー取得
    NSString* pstrKeyForCurrentWiFi = [m_pPrintOutMgr GetLatestPrimaryKeyForCurrentWiFi];
    // 選択中MFP取得
    [m_pPrinterMgr SetDefaultMFPIndex:pstrKey PrimaryKeyForCurrrentWifi:pstrKeyForCurrentWiFi];
    // 選択中MFP情報取得
    //    printerData = [m_pPrinterMgr LoadPrinterDataAtIndex2:m_pPrinterMgr.DefaultMFPIndex];
    
    NSInteger num = [m_pPrinterMgr GetPrinterIndexForKey:selectedPrinterPrimaryKey];
    PrinterData* printer1;
    if(num >= 0 ) {
        printer1 = [m_pPrinterMgr LoadPrinterDataAtIndexInclude2:num];
        scanerPickerRow = num;
    } else {
        printer1 = nil;
        selectedPrinterPrimaryKey = nil;
        scanerPickerRow = -1;
    }
    if (printer1!=nil) {
        // 選ばれてたMFPがまだある場合、そのMFPを選ぶ
        printerData = printer1;
        self.scanerPickerRow = [m_pPrinterMgr GetPrinterIndexForKey:printerData.PrimaryKey];
    } else {
        scanerPickerRow = m_pPrinterMgr.DefaultMFPIndex;
        PrinterData* defaultPrinter = [m_pPrinterMgr LoadPrinterDataAtIndexInclude2:m_pPrinterMgr.DefaultMFPIndex];
        if(defaultPrinter != nil) {
            // なくなってたら、デフォルトMFPを選ぶ
            printerData = defaultPrinter;
            self.scanerPickerRow = [m_pPrinterMgr GetPrinterIndexForKey:printerData.PrimaryKey];
            selectedPrinterPrimaryKey = printerData.PrimaryKey;
        } else {
            // 一つもない場合は、「ありません」にする
            printerData = nil;
        }
    }
    
    m_bButtonEnable = NO;
    if (printerData != nil)
    {
        pstrInitValue = [printerData getPrinterName];
        m_bButtonEnable = YES;
        selectMfpIpAddress = [printerData.IpAddress copy];
        selectMfpRSPortNo = [printerData.RSPortNo copy];
    }
    //    if([CommonUtil isCapableRemoteScan:printerData] && [self isMemberOfClass:[ScanBeforePictViewController_iPad class]])
    if(printerData.IsCapableRemoteScan)
    {
        remoteSwitchBaseView.hidden = NO;
    }else
    {
        remoteSwitchBaseView.hidden = YES;
    }
    
    // iPad用
    /*
     // ボタン表示名称更新
     for (NSInteger nCnt = PrvMenuIDFirst; nCnt <= PrvMenuIDSecond; nCnt++)
     {
     switch (nCnt)
     {
     case PrvMenuIDFirst:
     pstrBtnName = S_BUTTON_SCAN;
     pstrTitle = [[[NSString alloc]initWithFormat: pstrBtnName, pstrInitValue] autorelease];
     [self.m_pbtnFirst setTitle:pstrTitle forState:UIControlStateNormal];
     break;
     
     case PrvMenuIDSecond:
     pstrBtnName = S_BUTTON_SCANNER;
     pstrTitle = [[[NSString alloc]initWithFormat: pstrBtnName, pstrInitValue] autorelease];
     [self.m_pbtnSecond setTitle:pstrTitle forState:UIControlStateNormal];
     self.m_nSelPickerRow2 = nIndex;
     break;
     
     default:
     break;
     }
     }
     */
    [self.m_pbtnSecond setTitle:pstrInitValue forState:UIControlStateNormal];
    self.m_nSelPickerRow2 = scanerPickerRow;
    // iPad用
    
    // ボタンを2行表示するかチェック
    [commanager btnTwoLineChange:self.m_pbtnFirst];
    
    // 選択可能なスキャナーが存在しない場合はボタンを非活性にする。
    if([self isKindOfClass:[RemoteScanBeforePictViewController_iPad class]])
    {
        [self.m_pbtnFirst setEnabled:self.m_pbtnFirst.enabled];
    }else
    {
        [self.m_pbtnFirst setEnabled:YES];
    }
    
    [self.m_pbtnSecond setEnabled:YES];
    self.m_pbtnSecond.titleLabel.lineBreakMode = NSLineBreakByTruncatingTail;
    //self.m_pbtnSecond.titleLabel.lineBreakMode = NSLineBreakByTruncatingMiddle;
    self.m_pbtnSecond.titleLabel.font = [UIFont systemFontOfSize:N_BUTTON_FONT_SIZE_DEFAULT];
    self.m_pbtnSecond.titleLabel.adjustsFontSizeToFitWidth = YES;
    if (![S_LANG isEqualToString:S_LANG_JA])
    {
        //海外版の場合
        self.m_pbtnSecond.titleLabel.minimumScaleFactor = N_BUTTON_FONT_SIZE_DEFAULT / self.m_pbtnSecond.titleLabel.font.pointSize;
    }
    else
    {
        // 国内版の場合、表示文字を小さくする
        self.m_pbtnSecond.titleLabel.minimumScaleFactor = 12 / self.m_pbtnSecond.titleLabel.font.pointSize;
    }
    if(printerData == nil)
    {
        [self.m_pbtnFirst setEnabled:NO];
        [self.m_pbtnSecond setEnabled:NO];
        // iPad用 折り返し表示
        self.m_pbtnSecond.titleLabel.lineBreakMode = NSLineBreakByWordWrapping;
        self.m_pbtnSecond.titleLabel.font = [UIFont systemFontOfSize:N_BUTTON_FONT_SIZE_LITTLE];
    }
    self.isRemoteScan = NO;

}

// iPad用 不要のためコメントアウト
// 画面表示後処理
- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    // ナビゲーションバー上ボタンのマルチタップを制御する
    for (UIView * view in self.navigationController.navigationBar.subviews) {
        if ([view isKindOfClass: [UIView class]]) {
            [view setExclusiveTouch:YES];
        }
    }
    
    /*
     if (m_bFirstLoad)
     {
     // アニメーション開始
     [super AnimationShowStartMenu];
     m_bFirstLoad = FALSE;
     }
     */
    //	if (m_bFirstLoad)
    //	{
    //        if (!self.isRemoteScan) {
    //
    ////            [super AnimationShowStartMenu];
    //        }
    //		m_bFirstLoad = FALSE;
    //	}
    
    if(m_isShowMenu)
    {
        m_isShowMenu = false;
        // 縦表示の時はメニューボタンを表示
        SharpScanPrintAppDelegate* pAppDelegate = (SharpScanPrintAppDelegate*)[[UIApplication sharedApplication] delegate];
        UINavigationController* pRootNavController = [pAppDelegate.splitViewController.viewControllers objectAtIndex:0];
        RootViewController_iPad* rootViewController = (RootViewController_iPad*)[pRootNavController.viewControllers objectAtIndex:0];
        UIInterfaceOrientation orientation = [[UIApplication sharedApplication] statusBarOrientation];
        if(orientation == UIDeviceOrientationPortrait || orientation == UIDeviceOrientationPortraitUpsideDown)
        {
            [rootViewController performSelector:@selector(ShowMenuPopOverView) withObject:nil afterDelay:0.3];
        }
    }
    bNavRightBtn = NO;
}
// iPad用

// 画面非表示前処理
- (void)viewWillDisappear:(BOOL)animated
{
    // NSNotificationCenter 重複防止
    NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
    [nc removeObserver:self name:@"setFTPReceiveResponceNotification" object:nil];
    [nc removeObserver:self name:@"setHttpAddResponceNotification" object:nil];
    [nc removeObserver:self name:@"setHttpModResponceNotification" object:nil];
    [nc removeObserver:self name:@"setHttpDelResponceNotification" object:nil];
    [nc removeObserver:self name:@"setHTTPInternalErrorNotification" object:nil];

	//デフォルト処理
	[super viewWillDisappear:animated];
    //スレッド終了
	[self StopThread];

}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // e.g. myOutlet = nil;
    // iPad用
    if (nil != commanager)
    {
        commanager = nil;
    }
    if (nil != baseDir)
    {
        baseDir = nil;
    }
    if (nil != ScanFileName)
    {
        ScanFileName = nil;
    }
    if (nil != iPaddr)
    {
        iPaddr = nil;
    }
    if (nil != mfp_iPaddr)
    {
        mfp_iPaddr = nil;
    }
    if (nil != profileDataManager)
    {
        profileDataManager = nil;
    }
    if (nil != m_pPrinterMgr)
    {
        m_pPrinterMgr = nil;
    }
    if (nil != m_pPrintOutMgr)
    {
        m_pPrintOutMgr = nil;
    }
    // iPad用
    if (nil != m_pLblNoImage)
    {
        m_pLblNoImage = nil;
    }
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    // iPad用
    // Popoverが表示されていたら閉じる
    [m_popOver dismissPopoverAnimated:NO];
    
    //return (interfaceOrientation == UIInterfaceOrientationPortrait);
    return YES;
    // iPad用
}
//
//
// tag固定
- (void) createProgressionAlertWithMessage:(NSString *)titles message:(NSString *)messages withCancel:(BOOL)cancel
{
	//TRACE(@"messages[%@]", messages);
    
	//@selector(doadd:) @"Cancel"
    
	// Create the progress bar and add it to the alert
	if (cancel)
	{
        [self makeAlert:nil message:messages cancelBtnTitle:MSG_BUTTON_CANCEL okBtnTitle:nil tag:10];
        
	}
	else
	{
        [self makeAlert:nil message:messages cancelBtnTitle:nil okBtnTitle:nil tag:98];
	}
    
}

// tag指定
- (void) createProgressionAlertWithMessage:(NSString *)titles message:(NSString *)messages withCancel:(BOOL)cancel tag:(NSInteger)tag
{
    if (cancel)
    {
        [self makeAlert:nil message:messages cancelBtnTitle:MSG_BUTTON_CANCEL okBtnTitle:nil tag:tag];
    }
    else
    {
        [self makeAlert:nil message:messages cancelBtnTitle:nil okBtnTitle:nil tag:tag];
    }
}

// アラート表示
- (void)makeAlert:(NSString*)pstrTitle
          message:(NSString*)pstrMsg
   cancelBtnTitle:(NSString*)cancelBtnTitle
       okBtnTitle:(NSString*)okBtnTitle
              tag:(NSInteger)tag
{
    ex_alert = [ExAlertController alertControllerWithTitle:pstrTitle
                                                   message:pstrMsg
                                            preferredStyle:UIAlertControllerStyleAlert];
    ex_alert.tag = tag;
    
    // Cancel用のアクションを生成
    if (cancelBtnTitle != nil) {
        UIAlertAction *cancelAction =
        [UIAlertAction actionWithTitle:cancelBtnTitle
                                 style:UIAlertActionStyleCancel
                               handler:^(UIAlertAction * action) {
                                   
                                   // ボタンタップ時の処理
                                   [self alertButtonPushed:ex_alert tagIndex:tag buttonIndex:0];
                               }];
        // コントローラにアクションを追加
        [ex_alert addAction:cancelAction];
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
                                   [self alertButtonPushed:ex_alert tagIndex:tag buttonIndex:okIndex];
                               }];
        // コントローラにアクションを追加
        [ex_alert addAction:okAction];
    }
    // アラート表示処理
    [self presentViewController:ex_alert animated:YES completion:nil];
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
    
    // iPad用
    SharpScanPrintAppDelegate* appDelegate = (SharpScanPrintAppDelegate*)[[UIApplication sharedApplication] delegate];
    appDelegate.IsRun = TRUE;
    
    m_isScanStop = FALSE;
    
    // プリンタ情報が取得できなければ何もしない
    PrinterData* printerData = nil;
    printerData = [m_pPrinterMgr LoadPrinterDataAtIndexInclude2:self.m_nSelPickerRow2];
    if (printerData == nil)
    {
        m_isScanStop = TRUE;
        [self makeAlert:nil message:MSG_SCAN_REQ_ERR cancelBtnTitle:MSG_BUTTON_OK okBtnTitle:nil tag:0];
        return;
    }
    
    self.canceled = [self isKindOfClass:[RemoteScanBeforePictViewController_iPad class]];
    if(!printerData.isCapableNetScan){
        [self makeAlert:nil message:MSG_NETSCAN_NOTSUPPORT cancelBtnTitle:MSG_BUTTON_OK okBtnTitle:nil tag:0];
        return;
    }
    //内部領域の残容量が100MB以下の場合にメッセージを表示
    float limitSize = 100.0;
    float lFreeSize = 0.0;
	NSNumber *freeSize = nil;
	NSError *error = nil;
	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	NSDictionary *dict = [[NSFileManager defaultManager] attributesOfFileSystemForPath:[paths lastObject] error:&error];
	freeSize = [dict objectForKey:NSFileSystemFreeSize];
    lFreeSize = [freeSize floatValue]/1024.0/1024.0-200.0;
    if (limitSize >= lFreeSize) {
        [self makeAlert:nil message:[NSString stringWithFormat:@"%@\r\n\r\n%@", MSG_SCAN_CONFIRM, MSG_SCAN_CONFIRM_FREESIZE ] cancelBtnTitle:MSG_BUTTON_CANCEL okBtnTitle:MSG_BUTTON_OK tag:99];
    }else{
        [self makeAlert:nil message:MSG_SCAN_CONFIRM cancelBtnTitle:MSG_BUTTON_CANCEL okBtnTitle:MSG_BUTTON_OK tag:99];
    }
    
}

// メニューボタン２押下
- (IBAction)OnMenuSecondButton:(id)sender
{
    // 処理中あるいは処理中断フラグ=TRUEの場合は何もしない
    if (m_pThread || m_bAbort)
    {
        return;
    }
    
    // プリンタ数が０の場合は何もしない
    if ([m_pPrinterMgr CountOfPrinterData] == 0)
    {
        return;
    }
    
    // プリンタ一覧
    PrinterData* printerData = nil;
    //    NSMutableArray* parrPickerRow = [[NSMutableArray alloc] initWithCapacity:[m_pPrinterMgr CountOfPrinterData]];
    NSMutableArray* parrPickerRow = [[NSMutableArray alloc] initWithCapacity:[m_pPrinterMgr CountOfPrinterDataInclude]];
    
    //    for (NSInteger nIndex = 0; nIndex < [m_pPrinterMgr CountOfPrinterData]; nIndex++)
    for (NSInteger nIndex = 0; nIndex < [m_pPrinterMgr CountOfPrinterDataInclude]; nIndex++)
    {
        //        printerData = [m_pPrinterMgr LoadPrinterDataAtIndex2:nIndex];
        printerData = [m_pPrinterMgr LoadPrinterDataAtIndexInclude2:nIndex];
        [parrPickerRow addObject:[printerData getPrinterName]];
    }
    
    // ピッカー表示
    [super ShowPickerView:PrvMenuIDSecond
               pickerMenu:parrPickerRow];
    
    
    //[printerData release];
}

// iPad用
/*
 // アクションシート決定ボタン押下
 - (IBAction)OnMenuDecideButton:(id)sender
 {
 
 NSString* pstrScanner;
 NSString* pstrTitle;
 
 switch (m_nSelPicker)
 {
 case PrvMenuIDFirst:
 break;
 case PrvMenuIDSecond:
 // ボタン名称に反映
 pstrScanner = [m_parrPickerRow objectAtIndex:self.m_nSelPickerRow2];
 pstrTitle = [[[NSString alloc]initWithFormat: S_BUTTON_SCAN, pstrScanner] autorelease];
 [self.m_pbtnFirst setTitle:pstrTitle forState:UIControlStateNormal];
 
 pstrTitle = [[[NSString alloc]initWithFormat: S_BUTTON_SCANNER, pstrScanner] autorelease];
 [self.m_pbtnSecond setTitle:pstrTitle forState:UIControlStateNormal];
 m_nSelPicker = PrvMenuIDNone;
 break;
 case PrvMenuIDThird:
 m_nSelPicker = PrvMenuIDNone;
 break;
 case PrvMenuIDFourth:
 m_nSelPicker = PrvMenuIDNone;
 break;
 case PrvMenuIDNone:
 break;
 default:
 break;
 }
 // アクションシート非表示
 [m_pactsheetMenu dismissWithClickedButtonIndex:-1 animated:YES];
 }
 */

// ナビゲーションバー 設定ボタン押下
- (IBAction)OnNavBarRightButton:(id)sender
{
    
    scanerPickerRow = -1;
    [super OnNavBarRightButton:(id)sender];
}


-(void)setPickerValue
{
    switch (m_nSelPicker)
    {
        case PrvMenuIDFirst:
            break;
        case PrvMenuIDSecond:
        {
            // プリンタ情報取得
            PrinterData* printerData = nil;
            printerData = [m_pPrinterMgr LoadPrinterDataAtIndexInclude2:self.m_nSelPickerRow2];
            selectedPrinterPrimaryKey = printerData.PrimaryKey;
            
            if(![selectMfpIpAddress isEqualToString:[printerData IpAddress]])
            {
                // 選択MFPが変わった場合
                selectMfpIpAddress = [printerData.IpAddress copy];
                selectMfpRSPortNo = [printerData.RSPortNo copy];
                // リモートスキャン対応MFPかチェックする
                if(printerData.IsCapableRemoteScan)
                    // MFPのリモートスキャン設定の状態をチェックする
                    if([CommonUtil isCapableRemoteScan:printerData])
                    {
                        // リモートスキャンに切り替える
                        //                        [self nomalScanToRemoteScan];
                        [self performSelector:@selector(nomalScanToRemoteScan) withObject:nil afterDelay:0.5f];
                    }
                    else
                    {
                        // リモートスキャン切替スイッチ表示
                        remoteSwitchBaseView.hidden = NO;
                    }
                    else
                    {
                        // リモートスキャン切替スイッチ非表示
                        remoteSwitchBaseView.hidden = YES;
                    }
            }
            
            [self.m_pbtnSecond setTitle:m_pstrPickerValue forState:UIControlStateNormal];
            m_nSelPicker = PrvMenuIDNone;
            break;
            
        }
        case PrvMenuIDThird:
            m_nSelPicker = PrvMenuIDNone;
            break;
        case PrvMenuIDFourth:
            m_nSelPicker = PrvMenuIDNone;
            break;
        case PrvMenuIDNone:
            break;
        default:
            break;
    }
}

// リモートスキャンに切り替える
-(void)nomalScanToRemoteScan
{
    // 通常の取り込み画面へ遷移
    SharpScanPrintAppDelegate* pAppDelegate = (SharpScanPrintAppDelegate*)[[UIApplication sharedApplication] delegate];
    UINavigationController* pRootNavController = [pAppDelegate.splitViewController.viewControllers objectAtIndex:0];
    RootViewController_iPad* rootViewController = (RootViewController_iPad*)[pRootNavController.viewControllers objectAtIndex:0];
    
    RemoteScanBeforePictViewController_iPad* pScanViewController = [[RemoteScanBeforePictViewController_iPad alloc] init];
    
    // 選択するスキャナーを設定する
    pScanViewController.scanerPickerRow  = self.m_nSelPickerRow2;
    
    pScanViewController.selectedPrinterPrimaryKey = selectedPrinterPrimaryKey;
    
    [rootViewController ChangeDetailView:pScanViewController];
}

- (IBAction)tapRemoteSwt:(UISwitch*)sender {
    // リモートスキャンスイッチ切替
    if(sender.on){
        //プリンタ情報更新
        m_pPrinterMgr.PrinterDataList = [m_pPrinterMgr ReadPrinterData];
        
        // リモートスキャンをオンにする
        [self nomalScanToRemoteScan];
    }
}

// iPad用
#pragma mark -
#pragma mark HTTP Function

//
// HTTP POST 送信(登録)
//
- (void)addPost:(int) userAuthentication
{
	//TRACE(@"HTTP POST 送信(登録)");
    
	@autoreleasepool
    {
        
        //
        // アラート表示
        //
        [self createProgressionAlertWithMessage:nil message: MSG_REG_PROFILE withCancel:NO];
        
        //
        // PROFILE情報の取得
        //
        profileDataManager = [[ProfileDataManager alloc] init];
        ProfileData *profileData = nil;
        profileData = [profileDataManager loadProfileDataAtIndex:0];
        
        
        //
        //選択された MFP情報の取得
        //
        // プリンタ情報取得
        PrinterData* printerData = nil;
        //    printerData = [m_pPrinterMgr LoadPrinterDataAtIndex2:self.m_nSelPickerRow2];
        printerData = [m_pPrinterMgr LoadPrinterDataAtIndexInclude2:self.m_nSelPickerRow2];
        NSDictionary *dicIPAddr = [CommonUtil getIPAddrDicForComm:[printerData IpAddress] port:[NSString stringWithFormat:@"%@", [NSNumber numberWithInt:80]]];
        self.mfp_iPaddr = [CommonUtil optIPAddrForComm:[dicIPAddr objectForKey:S_TARGET_IPADDRESS_DIC_KEY]];
        if (printerData.addDic == nil) {
            //
            // HTTP POSTデータの設定：
            //
            httpMgr			= [[HttpManeger alloc] init];       // インスタンス取得
            httpMgr.myname		= profileData.profileName;		// 宛先名（必須）
            httpMgr.user		= m_ScanUser;                   // ユーザ名
            httpMgr.password	= m_ScanPass;                   // パスワード
            httpMgr.serchStr	= profileData.serchString;		// 検索文字（必須）
            httpMgr.ipAder		= self.iPaddr;					// IPアドレス
            httpMgr.mfpipAder	= self.mfp_iPaddr;				// MFP IPアドレス
            
            self.isDelProfile = FALSE;
            self.isModProfile = FALSE;
            //
            // HTTP POST 送信
            //
            [httpMgr addPostRequest:userAuthentication];		// HTTP POST 送信 : MFP に対して プロファイルの登録
        } else {
            // レガシーMFP
            //
            // HTTP POSTデータの設定：
            //
            httpLegacyMgr               = [[HttpLegacyManeger alloc] init];     // インスタンス取得
            httpLegacyMgr.myname		= profileData.profileName;              // 宛先名（必須）
            httpLegacyMgr.user          = m_ScanUser;                           // ユーザ名
            httpLegacyMgr.password      = m_ScanPass;                           // パスワード
            httpLegacyMgr.serchStr      = profileData.serchString;              // 検索文字（必須）
            httpLegacyMgr.ipAder		= self.iPaddr;                          // IPアドレス
            httpLegacyMgr.mfpipAder     = self.mfp_iPaddr;                      // MFP IPアドレス
            httpLegacyMgr.addDic        = printerData.addDic;                   // post時のキー情報
            httpLegacyMgr.updateDic     = printerData.updateDic;                // post時のキー情報
            httpLegacyMgr.deleteDic     = printerData.deleteDic;                // post時のキー情報
            
            self.isDelProfile = FALSE;
            self.isModProfile = FALSE;
            //
            // HTTP POST 送信
            //
            [httpLegacyMgr addPostRequest:userAuthentication];		// HTTP POST 送信 : MFP に対して プロファイルの登録
        }
	}
    
	return;
    
}

//
// HTTP POST 送信(更新)
//
- (void)modPost
{
	//TRACE(@"HTTP POST 送信(更新)");
    
	@autoreleasepool
    {
        
        //
        // アラート表示
        //
        [self createProgressionAlertWithMessage:nil message: MSG_REG_PROFILE withCancel:NO];
        
        //
        // PROFILE情報の取得
        //
        profileDataManager = [[ProfileDataManager alloc] init];
        ProfileData *profileData = nil;
        profileData = [profileDataManager loadProfileDataAtIndex:0];
        
        //
        //選択された MFP情報の取得
        //
        PrinterData* printerData = nil;
        //    printerData = [m_pPrinterMgr LoadPrinterDataAtIndex2:self.m_nSelPickerRow2];
        printerData = [m_pPrinterMgr LoadPrinterDataAtIndexInclude2:self.m_nSelPickerRow2];
        NSDictionary *dicIPAddr = [CommonUtil getIPAddrDicForComm:[printerData IpAddress] port:[NSString stringWithFormat:@"%@", [NSNumber numberWithInt:80]]];
        self.mfp_iPaddr = [CommonUtil optIPAddrForComm:[dicIPAddr objectForKey:S_TARGET_IPADDRESS_DIC_KEY]];
        
        
        //
        // 設定
        //
        if (printerData.updateDic == nil) {
            //
            // HTTP POST：MFP にプロファイル登録
            //
            httpMgr			= [[HttpManeger alloc] init];	// インスタンス取得
            httpMgr.myname		= profileData.profileName;		// 宛先名（必須）
            httpMgr.user		= m_ScanUser;		// ユーザ名
            httpMgr.password	= m_ScanPass;		// パスワード
            httpMgr.serchStr	= profileData.serchString;		// 検索文字（必須）
            httpMgr.ipAder		= self.iPaddr;					// IPアドレス
            httpMgr.mfpipAder	= self.mfp_iPaddr;				// MFP IPアドレス
            
            //
            self.isDelProfile = FALSE;
            
            //
            // HTTP POST 送信
            //
            [httpMgr modPostRequest];		// HTTP POST 送信 : MFP に対して プロファイルの更新
        } else {
            // レガシーMFP
            //
            // HTTP POST：MFP にプロファイル登録
            //
            httpLegacyMgr           = [[HttpLegacyManeger alloc] init];	// インスタンス取得
            httpLegacyMgr.myname    = profileData.profileName;		// 宛先名（必須）
            httpLegacyMgr.user      = m_ScanUser;		// ユーザ名
            httpLegacyMgr.password  = m_ScanPass;		// パスワード
            httpLegacyMgr.serchStr	= profileData.serchString;		// 検索文字（必須）
            httpLegacyMgr.ipAder    = self.iPaddr;					// IPアドレス
            httpLegacyMgr.mfpipAder = self.mfp_iPaddr;				// MFP IPアドレス
            httpLegacyMgr.addDic        = printerData.addDic;                   // post時のキー情報
            httpLegacyMgr.updateDic     = printerData.updateDic;                // post時のキー情報
            httpLegacyMgr.deleteDic     = printerData.deleteDic;                // post時のキー情報
            
            //
            self.isDelProfile = FALSE;
            
            //
            // HTTP POST 送信
            //
            [httpLegacyMgr modPostRequest];		// HTTP POST 送信 : MFP に対して プロファイルの更新
        }
	}
    
	return;
    
}

//
// HTTP POST 送信(削除)
//
- (void)delPost:(uint)delayTime
{
	//TRACE(@"HTTP POST 送信(削除)");
    
    @autoreleasepool
    {
        
        //
        // アラート表示
        //
        [self createProgressionAlertWithMessage:nil message:MSG_DEL_PROFILE withCancel:NO];
        
        //
        // ランループの実行
        //
        [commanager myrunLoop:delayTime];
        
        //
        // PROFILE情報の取得
        //
        profileDataManager = [[ProfileDataManager alloc] init];
        ProfileData *profileData = nil;
        profileData = [profileDataManager loadProfileDataAtIndex:0];
        
        PrinterData* printerData = nil;
        //    printerData = [m_pPrinterMgr LoadPrinterDataAtIndex2:m_nSelPickerRow2];
        printerData = [m_pPrinterMgr LoadPrinterDataAtIndexInclude2:self.m_nSelPickerRow2];
        
        if (printerData.updateDic == nil) {
            //
            // HTTP POSTデータの設定：
            //
            httpMgr			= [[HttpManeger alloc] init];       // インスタンス取得
            httpMgr.myname		= profileData.profileName;		// 宛先名（必須）
            httpMgr.user		= m_ScanUser;                   // ユーザ名
            httpMgr.password	= m_ScanPass;                   // パスワード
            httpMgr.serchStr	= profileData.serchString;		// 検索文字（必須）
            httpMgr.ipAder		= self.iPaddr;					// IPアドレス
            httpMgr.mfpipAder	= self.mfp_iPaddr;				// MFP IPアドレス
            
            self.isDelProfile = TRUE;
            
            //
            // del : HTTP POST 送信
            //
            [httpMgr delPostRequest];
        } else {
            // レガシーMFP
            //
            // HTTP POSTデータの設定：
            //
            httpLegacyMgr           = [[HttpLegacyManeger alloc] init];	// インスタンス取得
            httpLegacyMgr.myname    = profileData.profileName;          // 宛先名（必須）
            httpLegacyMgr.user		= m_ScanUser;                       // ユーザ名
            httpLegacyMgr.password	= m_ScanPass;                       // パスワード
            httpLegacyMgr.serchStr	= profileData.serchString;          // 検索文字（必須）
            httpLegacyMgr.ipAder    = self.iPaddr;                      // IPアドレス
            httpLegacyMgr.mfpipAder	= self.mfp_iPaddr;                  // MFP IPアドレス
            httpLegacyMgr.addDic        = printerData.addDic;           // post時のキー情報
            httpLegacyMgr.updateDic     = printerData.updateDic;        // post時のキー情報
            httpLegacyMgr.deleteDic     = printerData.deleteDic;        // post時のキー情報
            
            self.isDelProfile = TRUE;
            
            //
            // del : HTTP POST 送信
            //
            [httpLegacyMgr delPostRequest];
        }
	}
}

#pragma mark -
#pragma mark FTP Function

//
// FTP 開始
//
- (BOOL)startFTP
{
    DLog(@"<startFTP");
	//TRACE(@"FTP 開始");
    
	@autoreleasepool
    {
        
        //
        // PROFILE情報の取得
        //
        profileDataManager = [[ProfileDataManager alloc] init];
        ProfileData *profileData = nil;
        profileData = [profileDataManager loadProfileDataAtIndex:0];
        
        //
        // FTP 接続
        ftpmanager = [[FtpServerManager  alloc] init];	// インスタンス取得
        self.ScanFileName	= nil;
        
        [ftpmanager	startFTP:m_ScanUser
                requserpass	:m_ScanPass
                initWithPort:N_FTP_PORT
                   withDir		:self.baseDir
                notifyObject:self];
        
        //
        // アラート表示
        //
        //[self createProgressionAlertWithMessage:nil message:MSG_WAIT_SCAN withCancel:YES];
        //NSString *work= nil;
        //work = [MSG_WAIT_SCAN stringByAppendingString:@"\r\n\r\n\r\n"];
        
        // プリンタ情報取得
        scanerPickerRow = self.m_nSelPickerRow2;
        PrinterData* printerData = [m_pPrinterMgr LoadPrinterDataAtIndexInclude2:scanerPickerRow];
        if (printerData.IsCapableNovaLight) {
            [self makeAlert:nil message:MSG_WAIT_SCAN_NOVA_L cancelBtnTitle:MSG_BUTTON_CANCEL okBtnTitle:nil tag:10];
        } else {
            [self makeAlert:nil message:MSG_WAIT_SCAN cancelBtnTitle:MSG_BUTTON_CANCEL okBtnTitle:nil tag:10];
            
            // アラート内に検索文字と表示名を表示する
            NSString* pstrSearch = [NSString stringWithFormat:S_ALERT_SEARCH, profileData.serchString];
            NSString* pstrProfileName = [NSString stringWithFormat:S_ALERT_NAME, profileData.profileName];
            
            lblProfilaName = [[UILabel alloc] init];
            lblProfilaName.frame = CGRectMake(18.0f, 120.0f, 250.0f, 100.0f);
            lblProfilaName.backgroundColor = [UIColor clearColor];
            lblProfilaName.textColor = [UIColor whiteColor];
            lblProfilaName.font = [UIFont systemFontOfSize:14];
            lblProfilaName.textAlignment = NSTextAlignmentLeft;
            lblProfilaName.adjustsFontSizeToFitWidth = YES;
            lblProfilaName.minimumScaleFactor = 6 / lblProfilaName.font.pointSize;
            lblProfilaName.text = pstrProfileName;
            // ビューにラベル追加
            [ex_alert.view addSubview:lblProfilaName];
            
            lblSearch = [[UILabel alloc] init];
            lblSearch.frame = CGRectMake(18.0f, 140.0f, 250.0f, 100.0f);
            lblSearch.backgroundColor = [UIColor clearColor];
            lblSearch.textColor = [UIColor whiteColor];
            lblSearch.font = [UIFont systemFontOfSize:14];
            lblSearch.textAlignment = NSTextAlignmentLeft;
            lblSearch.adjustsFontSizeToFitWidth = YES;
            lblSearch.minimumScaleFactor = 6 / lblSearch.font.pointSize;
            lblSearch.text = pstrSearch;
            // ビューにラベル追加
            [ex_alert.view addSubview:lblProfilaName];
            
            
            if([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0)
            {   // iOS7以上なら
                // メッセージの改行をとる
                NSString *mess = [ MSG_WAIT_SCAN stringByReplacingOccurrencesOfString:@"\r\n\r\n\r\n\r\n\r\n" withString:@""];
                mess = [NSString stringWithFormat:@"%@\n%@\n%@", mess, pstrSearch, pstrProfileName];
                [ex_alert setMessage:mess];
                
            }
        }
        
	}
    DLog(@">startFTP");
    
	return YES;
}

#pragma mark -
#pragma mark HTTP Notification

//
// 通知：HTTP プロファイル登録
//
- (void) HttpAddResponceNotification:(NSNotification *)aNotification
{
    
    m_isScanStop = FALSE;
	@autoreleasepool
    {
        @try
        {
            NSString *postdata = [[aNotification userInfo] objectForKey:@"HTTP_RETURN"];
            if([postdata isEqualToString:@"1"] == YES)
            {
                //
                // 正常: OK
                //
                NSString *error;
                error = [[aNotification userInfo] valueForKey: @"HTTP_ERRDATA"];
                //TRACE(@"HTTP 通知 Error 1[%@]", error);
                
                // 解放
                // アラートを閉じる
                [ex_alert dismissViewControllerAnimated:YES completion:^{
                    // FTP 開始
                    [self startFTP];
                }];
            }
            else if([postdata isEqualToString:@"2"] == YES)
            {
                //
                // 異常: 送信先名はすでに存在
                // -> プロファイルの 更新
                NSString *error	= [[aNotification userInfo] valueForKey: @"HTTP_ERRDATA"];
                //TRACE(@"HTTP 通知 Error 2[%@]", error);
                
                error = MSG_REG_PROFILE_CONFIRM;
                
                // 解放
                // アラートを閉じる
                [ex_alert dismissViewControllerAnimated:YES completion:^{
                    // 強制上書きモードの取得
                    profileDataManager = [[ProfileDataManager alloc] init];
                    ProfileData *profileData = nil;
                    profileData = [profileDataManager loadProfileDataAtIndex:0];
                    
                    if(profileData.modifyMode)
                    {
                        // 強制上書きモード
                        // アラートを出さずに強制上書きモードで遷移させる
                        [self alertButtonPushed:ex_alert tagIndex:1 buttonIndex:1];
                        
                    }
                    else
                    {
                        // 上書き確認モード
                        //
                        // アラート表示
                        //
                        [self makeAlert:nil message:error cancelBtnTitle:MSG_BUTTON_CANCEL okBtnTitle:MSG_BUTTON_OK tag:1];
                    }
                }];
                
                
            }
            else if([postdata isEqualToString:@"3"] == YES)
            {
                // 解放
                // アラートを閉じる
                [ex_alert dismissViewControllerAnimated:YES completion:^{
                    //
                    // 異常: 認証エラー
                    //
                    [self addPost:HTTP_USERA_VALID];					// HTTP POST 送信(登録)
                }];

                
            }
            else
            {
                //
                // 異常: 上記以外
                // 中止
                
                //TRACE(@"HTTP 通知 Error 以外[%@]", error);
                
                // 解放
                
                NSString *pstrErrMsg;
                pstrErrMsg = MSG_REG_PROFILE_ERR;
                // エラーメッセージ切り替え
                if([postdata isEqualToString:@"6"] )
                {
                    pstrErrMsg = MSG_REG_PROFILE_ERR_SCANNER_PROCESSING;
                }
                

                // アラートを閉じる
                [ex_alert dismissViewControllerAnimated:YES completion:^{
                    // 取り込み終了後はスリープ状態可能に戻す
                    [UIApplication sharedApplication].idleTimerDisabled = NO;
                    
                    // アラートを表示
                    [self makeAlert:nil message:pstrErrMsg cancelBtnTitle:MSG_BUTTON_OK okBtnTitle:nil tag:0];
                }];
            }
        }
        @finally
        {
        }
    }
}

//
// 通知：HTTP プロファイル更新
//
- (void) HttpModResponceNotification:(NSNotification *)aNotification
{
	@autoreleasepool
    {
        @try
        {
            NSString *postdata = [[aNotification userInfo] objectForKey:@"HTTP_RETURN"];
            
            //国内版の場合、特別モード実行可能
            if ([S_LANG isEqualToString:S_LANG_JA])
            {
                NSUserDefaults* specialMode = [NSUserDefaults standardUserDefaults];
                
                if([specialMode boolForKey:S_SPECIALMODE_FLAG])
                {
                    postdata = @"1";
                }
            }
            if([postdata isEqualToString:@"1"] )
            {
                //
                // 正常: OK
                //
                NSString *error;
                error = [[aNotification userInfo] valueForKey: @"HTTP_ERRDATA"];
                //TRACE(@"HTTP 通知 Error 1[%@]", error);
                
                // 解放
                // アラートを閉じる
                [ex_alert dismissViewControllerAnimated:YES completion:^{
                    // FTP 開始
                    [self startFTP];
                }];
            }
            else
            {
                //
                // 異常: 上記以外
                // 中止
                NSString *error;
                error = [[aNotification userInfo] valueForKey: @"HTTP_ERRDATA"];
                //TRACE(@"HTTP 通知 Error 以外[%@]", error);
                
                NSString *pstrErrMsg;
                pstrErrMsg = MSG_REG_PROFILE_ERR;
                // エラーメッセージ切り替え
                if([postdata isEqualToString:@"4"] )
                {
                    pstrErrMsg = MSG_REG_PROFILE_ERR_SCANNER_PROCESSING;
                }
                
                // アラートを閉じる
                [ex_alert dismissViewControllerAnimated:YES completion:^{
                    // 取り込み終了後はスリープ状態可能に戻す
                    [UIApplication sharedApplication].idleTimerDisabled = NO;
                    
                    // アラートを表示
                    [self makeAlert:nil message:pstrErrMsg cancelBtnTitle:MSG_BUTTON_OK okBtnTitle:nil tag:0];
                }];

            }
        }
        @finally
        {
        }
    }
}

//
// 通知：HTTP プロファイル削除
//
- (void) HttpDelResponceNotification:(NSNotification *)aNotification
{
    
	@autoreleasepool
    {
        @try
        {
            NSString *postdata = [[aNotification userInfo] objectForKey:@"HTTP_RETURN"];
            
            //国内版の場合、特別モード実行可能
            if ([S_LANG isEqualToString:S_LANG_JA])
            {
                NSUserDefaults* specialMode = [NSUserDefaults standardUserDefaults];
                
                if([specialMode boolForKey:S_SPECIALMODE_FLAG])
                {
                    postdata = @"1";
                }
            }
            if([postdata isEqualToString:@"1"] )
            {
                //
                // 正常: OK
                //
                NSString *error;
                error = [[aNotification userInfo] valueForKey: @"HTTP_ERRDATA"];
                //TRACE(@"HTTP 通知 Error 1[%@]", error);
                
                
                if (!self.isRecComp) {
                    // キャンセル後はスリープ可能状態に戻す
                    [UIApplication sharedApplication].idleTimerDisabled = NO;
                    
                    // アラートを閉じる
                    [ex_alert dismissViewControllerAnimated:YES completion:^{
                        // アラートを表示
                        [self makeAlert:nil message:MSG_SCAN_CANCEL cancelBtnTitle:MSG_BUTTON_OK okBtnTitle:nil tag:0];
                    }];
                }
                else
                {
                    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                        // 取り込み完了アラート表示
                        [self CreateCompleteAlert];
                    });
                }
                
            }
            else
            {
                //
                // 異常: 上記以外
                //
                NSString *error;
                error = [[aNotification userInfo] valueForKey: @"HTTP_ERRDATA"];
                //TRACE(@"HTTP 通知 Error 以外[%@]", error);
                
                // 解放
                
                // 取り込み終了後はスリープ可能状態に戻す
                [UIApplication sharedApplication].idleTimerDisabled = NO;
                
                NSString *pstrErrMsg;
                pstrErrMsg = MSG_DEL_PROFILE_ERR;
                // エラーメッセージ切り替え
                if([postdata isEqualToString:@"4"] )
                {
                    pstrErrMsg = MSG_DEL_PROFILE_ERR_SCANNER_PROCESSING;
                }
                
                
                // アラートを閉じる
                [ex_alert dismissViewControllerAnimated:YES completion:^{
                    NSInteger tempTagIndex;
                    TempDataManager *tManager = [[TempDataManager alloc]init];
                    if([tManager countOfTempData] > 0){
                        tempTagIndex = 14;
                        // キャッシュファイルの作成
                        TempFile *tempFile = [[TempFile alloc]initWithFileName:self.ScanFileName];
                        [TempFileUtility createCacheFile:tempFile];
                    }else{
                        tempTagIndex = 15;
                    }
                    
                    // アラートを表示
                    [self makeAlert:nil message:pstrErrMsg cancelBtnTitle:nil okBtnTitle:MSG_BUTTON_OK tag:tempTagIndex];
                }];
            }
        }
        @finally
        {
        }
    }
    
}

//
// 通知：HTTP プロファイル登録エラー
//
- (void) HttpInternalErrorNotification:(NSNotification *)aNotification
{
	NSString	*error = nil;
    
	//
	// 異常 ネットワークエラー系
	//
	@autoreleasepool
    {
        @try
        {
            if (self.isDelProfile)
            {
                // プロファイル削除時のエラー
                error	= MSG_DEL_PROFILE_ERR;
            }
            else
            {
                // プロファイル登録時のエラー
                error	= MSG_REG_PROFILE_ERR;
            }
        }
        @catch (NSException *exception)
        {
            if (self.isDelProfile)
            {
                // プロファイル削除時のエラー
                error	= MSG_DEL_PROFILE_ERR;
            }
            else
            {
                // プロファイル登録時のエラー
                error	= MSG_REG_PROFILE_ERR;
            }
        }
        @finally
        {
        }
    }
    
    
    // アラートを閉じる
    [ex_alert dismissViewControllerAnimated:YES completion:^{
        // 取り込み終了後はスリープ可能状態に戻す
        [UIApplication sharedApplication].idleTimerDisabled = NO;
        
        NSInteger tempTagIndex;
        // プロファイル削除の場合
        if (self.isDelProfile)
        {
            // 取り込みファイルがあれば
            TempDataManager *tManager = [[TempDataManager alloc]init];
            if([tManager countOfTempData] > 0)
            {
                tempTagIndex = 14;
            }
        }
        
        // アラートを表示
        [self makeAlert:nil message:error cancelBtnTitle:MSG_BUTTON_OK okBtnTitle:nil tag:tempTagIndex];
    }];
}

#pragma mark -
#pragma mark FTP Notification

//
// 通知：FTP 受信結果
//
- (void) FtpReceiveResponceNotification:(NSNotification *)aNotification
{
	NSString *postdata = [[aNotification userInfo] objectForKey:@"FTP_RETURN"];
    
    //	NSComparisonResult res	= [postdata compare:@"1"];
	if ([postdata isEqualToString:@"1"] == YES)
	{
        // 複数ファイル受信確認
        if (nil != self.ScanFileName)
        {
            TempFile *tempFile = [[TempFile alloc]initWithFileName:self.ScanFileName];
            //
            // PDF を PNG に保存
            //
            [TempFileUtility createRequiredAllImageFiles:tempFile];
            
            //            if(rtn != YES)
            //            {
            //                //TRACE(@"[SecondView]NG：PDF を PNG に保存[%@]", self.ScanFileName);
            //            }
            //            else
            //            {
            //                //TRACE(@"[SecondView]OK：PDF を PNG に保存[%@]", self.ScanFileName);
            //            }
            self.ScanFileName = nil;
        }
        
        //
		// 1:受信中
		//
		self.ScanFileName= [[aNotification userInfo] objectForKey:@"FTP_FILENAME"];
		//TRACE(@"1:受信中] %@", postdata, self.ScanFileName);
        
        lblProfilaName.text = @"";
        lblSearch.text = @"";
        
		//
		// アラート内容を変更
		//
        ex_alert.tag		= 11;
        ex_alert.title		= nil;
        ex_alert.message	= MSG_SCAN_DOING;
        m_IsAlertFlag = YES;
        
//        // アラートを閉じる
//        [ex_alert dismissViewControllerAnimated:YES completion:^{
//            // アラートを表示
//            [self makeAlert:nil message:MSG_SCAN_DOING cancelBtnTitle:MSG_BUTTON_CANCEL okBtnTitle:nil tag:11];
//        }];
        
	}
	else if ([postdata isEqualToString:@"3"] == YES)
	{
		//
		// 3:受信完了 OK
		//
		//TRACE(@"3:受信完了]");
        
        
        // アラートを閉じる
        [ex_alert dismissViewControllerAnimated:YES completion:^{
            // アラートを表示
            [self makeAlert:nil message:MSG_DID_SCAN cancelBtnTitle:nil okBtnTitle:nil tag:13];
            
            // 0.01秒待つ
            [NSThread sleepForTimeInterval:0.01];
            
            [self alertButtonPushed:nil tagIndex:13 buttonIndex:0];
        }];

	}
	else
	{
		//
		// 2:中断しました OK
		//
		//TRACE(@"2:中断しました]");
        
        // アラートを閉じる
        [ex_alert dismissViewControllerAnimated:YES completion:^{
            // アラートを表示
            [self makeAlert:nil message:MSG_DID_SCAN_ERR cancelBtnTitle:nil okBtnTitle:nil tag:11];
            
            // 0.01秒待つ
            [NSThread sleepForTimeInterval:0.01];
            
            // アラートを閉じる
            [ex_alert dismissViewControllerAnimated:YES completion:^{
                // アラートを閉じる時の処理
                [self alertButtonPushed:nil tagIndex:11 buttonIndex:0];
            }];
        }];
	}
}

-(void)alertButtonPushed:(UIAlertController *)alertController tagIndex:(NSInteger)tagIndex buttonIndex:(NSInteger)buttonIndex
{
    //	NSMutableDictionary *myDictionary = [[NSMutableDictionary alloc]init];
    NSFileManager*  fileManager	= [NSFileManager defaultManager];
    
    //
    // PROFILE情報の取得
    //
    profileDataManager = [[ProfileDataManager alloc] init];
    ProfileData *profileData = nil;
    profileData = [profileDataManager loadProfileDataAtIndex:0];
    
    // iPad用
    SharpScanPrintAppDelegate* appDelegate = (SharpScanPrintAppDelegate*)[[UIApplication sharedApplication] delegate];
    // iPad用
    
    switch (tagIndex)
    {
        case 1:
            // HTTP プロファイル登録で表示名が既にある場合
            //TRACE(@"[SecondView]alert HTTP 登録（既に登録されている）続行 押下");
            
            if (buttonIndex != 0)
            {
                //self.isModProfile = TRUE;
                //[self delPost:DELEY_TIME_1];		// HTTP プロファイル削除
                [self modPost]; // プロファイル更新
            }
            else
            {
                m_isScanStop = TRUE;
            }
            
            break;
            
        case 10:
            // ScantoFTP待ち中にキャンセルされた場合
            //TRACE(@"[SecondView]alert ScantoFTP待ち中にキャンセル 押下");
            if ((int)ex_alert.tag == 11) {
                // ファイル受信中にキャンセルされた場合の暫定処理
                [self alertButtonPushed:nil tagIndex:11 buttonIndex:0];
            } else {
                self.isRecComp = FALSE;
                // FTP STOP
                [ftpmanager stopFTP];			// FTP  停止
                [self delPost:DELEY_TIME_2];		// HTTP プロファイル削除
            }
            break;
            
        case 11: {
            // ファイル受信中にキャンセルされた場合
            //TRACE(@"[SecondView]alert 受信中にキャンセル 押下");
            self.isRecComp = FALSE;
            [ftpmanager stopFTP];				// FTP  停止
            [self delPost:DELEY_TIME_5];		// HTTP プロファイル削除
            // ファイル削除
            //
            // TempDataManager クラスのインスタンス取得
            //
            TempDataManager *tempManager = [[TempDataManager alloc]init];
            if([tempManager removeFile] != YES)
            {
            }
            break;
            
        }
        case 13:
            // ファイル受信完了でOKされた場合
            self.isRecComp = TRUE;
            //TRACE(@"[SecondView]alert ファイル受信完了でOK 押下");
            
            // 1秒待つ
            [NSThread sleepForTimeInterval:1.0];
            
            [ftpmanager stopFTP];				// FTP  停止
            
            if(!profileData.delMode)
            {
                // アラートを閉じる
                [ex_alert dismissViewControllerAnimated:YES completion:^{
                    [self delPost:DELEY_TIME_2];		// HTTP プロファイル削除
                }];
            }
            else
            {
                // 取り込み終了後はスリープ可能状態に戻す
                [UIApplication sharedApplication].idleTimerDisabled = NO;
                dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                    // 取り込み完了アラート表示
                    [self CreateCompleteAlert];
                });

            }
            break;
        case 14:
        {
            // 内部メモリへの保存
            // プライマリキー
            if(profileData.autoSelectMode)
            {
                PrinterData* printerData = nil;
                printerData = [m_pPrinterMgr LoadPrinterDataAtIndexInclude2:self.m_nSelPickerRow2];
                [m_pPrintOutMgr SetLatestPrimaryKey:[printerData PrimaryKey]];
            }
            
            TempDataManager *tManager = [[TempDataManager alloc]init];
            if([tManager countOfTempData] == 0)
            {
                m_isScanStop = FALSE;
                //
                // 取り込みファイルが0件だった場合
                //
                UIAlertController *tempAlert = [UIAlertController alertControllerWithTitle:nil
                                                                                   message:MSG_NO_SCAN_FILE
                                                                            preferredStyle:UIAlertControllerStyleAlert];
                // OK用のアクションを生成
                UIAlertAction *okAction =
                [UIAlertAction actionWithTitle:MSG_BUTTON_OK
                                         style:UIAlertActionStyleDefault
                                       handler:^(UIAlertAction * action) {
                                           
                                           // ボタンタップ時の処理
                                           [self alertButtonPushed:tempAlert tagIndex:0 buttonIndex:0];
                                       }];
                
                // コントローラにアクションを追加
                [tempAlert addAction:okAction];
                // アラート表示処理
                [self presentViewController:tempAlert animated:YES completion:nil];
                
                // アラート表示前に取り込みボタンを非活性にになっていたら活性に戻す
                if(self.m_pbtnFirst.enabled == NO)
                {
                    [self.m_pbtnFirst setEnabled:YES];
                }
            }
            else
            {
                appDelegate.IsRun = FALSE;
                m_isScanStop = FALSE;
                // iPad用
                TempDataManager *tManager = [[TempDataManager alloc]init];
                if([tManager countOfTempData] > 0)
                {
                    //
                    // PDF を PNG に保存
                    //
                    TempFile *tempFile = [[TempFile alloc]initWithFileName:ScanFileName];
                    BOOL bCreate = [TempFileUtility createThumbnailFile:tempFile];

                    //
                    // スキャンデータを読み込み、一覧に画面遷移
                    //
                    //TempDataManager *tManager = [TempDataManager sharedTempDataManager];
                    if (bCreate && ([tManager countOfTempData] > 1))
                    {
                        // 一覧遷移
                        // ナビゲーションバー ボタン押下可能
                        self.navigationController.navigationBar.userInteractionEnabled = YES;
                        TempDataTableViewController_iPad* tempDataTableViewController;
                        // iPad用
                        tempDataTableViewController = [[TempDataTableViewController_iPad alloc] init];
                        tempDataTableViewController.bSetTitle = TRUE;
                        // iPad用
                        tempDataTableViewController.isScan = TRUE;
                        tempDataTableViewController.prevViewController = self;
                        [self.navigationController pushViewController:tempDataTableViewController animated:YES];
                    }
                    else
                    {
                        // ナビゲーションバー ボタン押下可能
                        self.navigationController.navigationBar.userInteractionEnabled = YES;
                        
                        //
                        // 選択行の読み込み
                        //
                        TempData *aTempData = nil;
                        aTempData	= [tManager loadTempDataAtIndexPath:0];
                        
                        ScanAfterPictViewController_iPad* scanpViewController;
                        scanpViewController = [[ScanAfterPictViewController_iPad alloc] init];
                        //
                        // 呼び出し画面のプロパティ設定
                        //
                        TempFile *localTempFile = [[TempFile alloc]initWithFileName:aTempData.fname];
                        scanpViewController.tempFile = localTempFile;
                        [self.navigationController pushViewController:scanpViewController animated:YES];
                    }
                    scanerPickerRow = -1;
                }
            }
            
            m_IsAlertFlag = NO;
            
            break;
        }
            
        case 15:
        {
            // プロファイルの削除に失敗
            TempDataManager *tManager = [[TempDataManager alloc]init];
            if(self.isRecComp && [tManager countOfTempData] == 0)
            {
                m_isScanStop = FALSE;
                //
                // 取込み完了かつ、取り込みファイルが0件だった場合
                //
                UIAlertController *tempAlert = [UIAlertController alertControllerWithTitle:nil
                                                                                   message:MSG_NO_SCAN_FILE
                                                                            preferredStyle:UIAlertControllerStyleAlert];
                // OK用のアクションを生成
                UIAlertAction *okAction =
                [UIAlertAction actionWithTitle:MSG_BUTTON_OK
                                         style:UIAlertActionStyleDefault
                                       handler:^(UIAlertAction * action) {
                                           
                                           // ボタンタップ時の処理
                                           [self alertButtonPushed:tempAlert tagIndex:0 buttonIndex:0];
                                       }];
                
                // コントローラにアクションを追加
                [tempAlert addAction:okAction];
                // アラート表示処理
                [self presentViewController:tempAlert animated:YES completion:nil];
            }
            
            break;
        }
            
        case 99:
            if(buttonIndex != 0)
            {
                
                m_IsModProfile = FALSE;
                
                // 取り込み中はスリープ状態にしない
                [UIApplication sharedApplication].idleTimerDisabled = YES;
                
                // iPad用
                /*
                 // メニュー表示を非表示に動作
                 if(m_bShowMenu)
                 {
                 [self AnimationShowMenu];
                 }
                 */
                // iPad用
                
                // tempフォルダにファイルがあれば削除
                [fileManager removeItemAtPath:[CommonUtil tmpDir] error:NULL];	// ディレクトリ削除
                
                // ディレクトリ作成
                self.baseDir = [CommonUtil tmpDir];
                @try
                {
                    //
                    // MFPを使用するが選択されているかをチェック
                    //
                    self.selectInd = self.m_nSelPickerRow2;
                    
                    //
                    // IP アドレスチェック
                    //
                    NSDictionary *dicIPaddr = [CommonUtil getIPAddrDicForComm:selectMfpIpAddress port:[NSString stringWithFormat:@"%@", [NSNumber numberWithInt:80]]];
                    self.iPaddr	= [dicIPaddr objectForKey:S_MY_IPADDRESS_DIC_KEY];  // POSTする自端末IPv6アドレスには括弧はつけない。
                    
                    NSUInteger len = [[self.iPaddr stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] length];
                    if (len <= 0)
                    {
                        UIAlertController *tempAlert = [UIAlertController alertControllerWithTitle:nil
                                                                                           message:MSG_NETWORK_ERR
                                                                                    preferredStyle:UIAlertControllerStyleAlert];
                        // OK用のアクションを生成
                        UIAlertAction *okAction =
                        [UIAlertAction actionWithTitle:MSG_BUTTON_OK
                                                 style:UIAlertActionStyleDefault
                                               handler:^(UIAlertAction * action) {
                                                   
                                                   // ボタンタップ時の処理
                                                   [self alertButtonPushed:tempAlert tagIndex:0 buttonIndex:0];
                                               }];
                        
                        // コントローラにアクションを追加
                        [tempAlert addAction:okAction];
                        // アラート表示処理
                        [self presentViewController:tempAlert animated:YES completion:nil];
                        
                        return;
                    }
                    
                    self.ScanUser = S_FTP_USER;
                    NSString *uuid = [[CommonUtil CreatUUID] copy];
                    self.ScanPass = [uuid substringWithRange:NSMakeRange(0,10)];
                    //国内版の場合、特別モード実行可能
                    if ([S_LANG isEqualToString:S_LANG_JA])
                    {
                        NSUserDefaults* specialMode = [NSUserDefaults standardUserDefaults];
                        
                        if([specialMode boolForKey:S_SPECIALMODE_FLAG])
                        {
                            self.ScanPass = S_FTP_SPECIAL_PASSWORD;
                        }
                    }
                    
                    //
                    // HTTP POST 送信(登録)
                    //
                    [self addPost:HTTP_USERA_VALID];
                }
                @finally
                {
                    
                }
            }
            else
            {
                // 処理実行フラグOFF
                appDelegate.IsRun = FALSE;
            }
            break;
        case 98:
            break;
        default:
            m_isScanStop = TRUE;
            break;
    }
    if(m_isScanStop || !m_bResult)
    {
        appDelegate.IsRun = FALSE;
        m_isScanStop = FALSE;
        m_bResult = TRUE;
    }

}

- (void)CreateCompleteAlert
{
    // アラート表示前にキャッシュファイルの作成
    // キャッシュファイルの作成
    TempFile *tempFile = [[TempFile alloc]initWithFileName:self.ScanFileName];
    [TempFileUtility createRequiredAllImageFiles:tempFile];
    
    // アラート表示前に取り込みボタンを非活性にしておく
    [self.m_pbtnFirst setEnabled:NO];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        // アラートを閉じる
        [ex_alert dismissViewControllerAnimated:YES completion:^{
            // 0.01秒待つ
            [NSThread sleepForTimeInterval:0.01];
            
            // アラートを出さずに遷移させる
            [self alertButtonPushed:nil tagIndex:14 buttonIndex:0];
        }];
    });
}

// iPad用
- (void)CreateNoScannerAlert
{
    if(self.isShowAlert)
    {
        //
        // アラート表示
        //
        SharpScanPrintAppDelegate* appDelegate = (SharpScanPrintAppDelegate*)[[UIApplication sharedApplication] delegate];
        // 処理実行フラグON
        appDelegate.IsRun = TRUE;
        
        [self makeAlert:nil message:MSG_NO_SCANNER cancelBtnTitle:MSG_BUTTON_OK okBtnTitle:nil tag:0];
    }
}
// iPad用
// 縦表示時のメニューボタン設定
- (void)setPortraitMenu:(UIBarButtonItem *)barButtonItem
{
    [self.navigationItem setLeftBarButtonItem:barButtonItem animated:YES];
}

// 回転が開始する前に行う処理
- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration
{
    // iOS6以前のみ、ダイアログサイズの調整を行う
    if(m_IsAlertFlag && !isIOS7Later)
    {
        if([ex_alert.message isEqualToString:MSG_SCAN_DOING])
        {
            // 受信中です。メッセージ表示中に回転が行われた場合にダイアログサイズの調整
            NSString *pstrIndention = @"\r\n\r\n\r\n\r\n\r\n";
            NSString *pstrMsg = [pstrIndention stringByAppendingFormat:MSG_SCAN_DOING];
            pstrMsg = [pstrMsg stringByAppendingString:pstrIndention];
            
            ex_alert.message = pstrMsg;
            m_IsAlertFlag = NO;
        }
    }
}

- (void)setPrevScanner
{
    self.scanerPickerRow = self.m_nSelPickerRow2;
    self.canceled = YES;
}
@end
