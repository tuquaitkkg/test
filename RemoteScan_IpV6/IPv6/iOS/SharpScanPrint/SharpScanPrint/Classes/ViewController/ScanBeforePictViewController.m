
#import "ScanBeforePictViewController.h"
#import "Define.h"
#import "ProfileDataManager.h"
#import "CommonUtil.h"
#import "ScanAfterPictViewController.h"
#import "TempDataTableViewController.h"
#import "SharpScanPrintAppDelegate.h"
#import "RemoteScanBeforePictViewController.h"


@implementation ScanBeforePictViewController

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
@synthesize scanerPickerRow;
//@synthesize bRemoteSwitchTap;

@synthesize selectedPrinterPrimaryKey;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
        // Custom initialization
        // 変数初期化
        [super InitObject];
        self.scanerPickerRow = -1;
        selectedPrinterPrimaryKey = nil;
    }
    self.selectInd = -1;
    
    return self;
}

- (void)dealloc
{
    SharpScanPrintAppDelegate* appDelegate = (SharpScanPrintAppDelegate*)[[UIApplication sharedApplication] delegate];
    appDelegate.IsRun = FALSE;
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
    // Do any additional setup after loading the view from its nib.
    
    // PrinterDataManagerクラス初期化
    m_pPrinterMgr = [[PrinterDataManager alloc] init];
    
    // PrintOutDataManagerクラス初期化
    m_pPrintOutMgr = [[PrintOutDataManager alloc] init];
	//
	// CommonManager クラスのインスタンス取得
	//
	commanager = [[CommonManager alloc]init];
    
    // メインビュー初期化
    [super InitView:[CommonUtil getSSID]
         menuBtnNum:PrvMenuIDSecond];
    
    // メニュー作成
    NSString* pstrBtnName = S_BUTTON_NO_SCANNER;      // ボタン名称
    NSString* pstrInitValue;    // 表示初期値
    NSString* pstrIconName;     // アイコン名称
    
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
    if(scanerPickerRow < 0){
        self.scanerPickerRow = m_pPrinterMgr.DefaultMFPIndex;
    }
    printerData = [m_pPrinterMgr LoadPrinterDataAtIndexInclude2:scanerPickerRow];
    m_bButtonEnable = NO;
    if (printerData != nil)
    {
        pstrInitValue = [printerData getPrinterName];
        m_bButtonEnable = YES;
        selectMfpIpAddress = [printerData.IpAddress copy];
        selectMfpRSPortNo = [printerData.RSPortNo copy];
        
    }
    for (NSInteger nCnt = PrvMenuIDFirst; nCnt <= PrvMenuIDSecond; nCnt++)
    {
        switch (nCnt)
        {
            case PrvMenuIDFirst:
                if(printerData != nil)
                {
                    pstrBtnName = S_BUTTON_SCAN;
                }
                pstrInitValue = [printerData getPrinterName];
                pstrIconName = S_ICON_SCAN_SCAN;
                break;
            case PrvMenuIDSecond:
                if(printerData != nil)
                {
                    pstrBtnName = S_BUTTON_SCANNER;
                }
                pstrInitValue = [printerData getPrinterName];
                pstrIconName = S_ICON_SCAN_SCANNER;
                //				m_nSelPickerRow2 = m_pPrinterMgr.DefaultMFPIndex;
				self.m_nSelPickerRow2 = scanerPickerRow;
                break;
            default:
                break;
        }
        self.IsBeforeView = YES;
        self.bRemoteScanSwitch = printerData.IsCapableRemoteScan;
        [super CreateMenu:nCnt
                  btnName:pstrBtnName
                initValue:pstrInitValue
                 iconName:pstrIconName];
    }
    
    // 選択可能なプリンターが存在しない場合
    if(printerData == nil)
    {
        SharpScanPrintAppDelegate* appDelegate = (SharpScanPrintAppDelegate*)[[UIApplication sharedApplication] delegate];
        // 処理実行フラグON
        appDelegate.IsRun = TRUE;
        m_isScanStop = TRUE;
        //
        // アラート表示
        //
        [self makeAlert:nil message:MSG_NO_SCANNER cancelBtnTitle:MSG_BUTTON_OK okBtnTitle:nil tag:0];
        // 解放
    }
    
    // ボタン2の下に"端末側からスキャナーの設定を行う"スイッチとラベルを配置
    CGPoint putPt = self.m_pbtnSecond.frame.origin;
    putPt.x += 10;
    putPt.y += self.m_pbtnSecond.frame.size.height + 5;
    
    // 端末設定のビューをスクロール画面に追加する
    // ラベルをスクロールビューに配置
    remoteSwitchLbl = [[UILabel alloc]initWithFrame:(CGRect){putPt,180,30}];
    remoteSwitchLbl.backgroundColor = [UIColor clearColor];
    remoteSwitchLbl.autoresizingMask = self.m_pbtnFirst.autoresizingMask;
    remoteSwitchLbl.adjustsFontSizeToFitWidth = YES;
    remoteSwitchLbl.minimumScaleFactor = 4 / remoteSwitchLbl.font.pointSize;
    remoteSwitchLbl.text = S_LABEL_REMOTESWITCH;
    [m_pMenuView addSubview:remoteSwitchLbl];
    
    // スイッチをスクロールビューに配置
    remoteSwt = [[UISwitch alloc]init];
    putPt = remoteSwitchLbl.frame.origin;
    putPt.x += [[UIScreen mainScreen] bounds].size.width - (remoteSwt.frame.size.width + 20);
    putPt.y += 20;
    remoteSwt.center = putPt;
    remoteSwt.autoresizingMask = self.m_pbtnFirst.autoresizingMask;
    remoteSwt.on = ([self isMemberOfClass:[RemoteScanBeforePictViewController class]]);
    [remoteSwt addTarget:self action:@selector(tapRemoteSwt:) forControlEvents:UIControlEventValueChanged];
    
    [m_pMenuView addSubview:remoteSwt];

    
    
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
    
	if (m_bFirstLoad)
	{
        if (!self.isRemoteScan) {
            
            [super AnimationShowStartMenu];
        }
		m_bFirstLoad = FALSE;
	}
    bNavRightBtn = NO;
}

//画面表示前処理
- (void)viewWillAppear:(BOOL)animated
{
    
    //
	// 通知センタ登録
	//
	NSNotificationCenter* nc;
	nc = [NSNotificationCenter defaultCenter];
    
    // 重複防止
    //    [nc removeObserver:self];
    [nc removeObserver:self name:@"setFTPReceiveResponceNotification" object:nil];
    [nc removeObserver:self name:@"setHttpAddResponceNotification" object:nil];
    [nc removeObserver:self name:@"setHttpModResponceNotification" object:nil];
    [nc removeObserver:self name:@"setHttpDelResponceNotification" object:nil];
    [nc removeObserver:self name:@"setHTTPInternalErrorNotification" object:nil];
    
	// FTP
	[nc addObserver:self selector:@selector(FtpReceiveResponceNotification:)  name:@"setFTPReceiveResponceNotification"  object:nil];
	// HTTP
	[nc addObserver:self selector:@selector(HttpAddResponceNotification:)   name:@"setHttpAddResponceNotification"   object:nil];
	[nc addObserver:self selector:@selector(HttpModResponceNotification:)   name:@"setHttpModResponceNotification"   object:nil];
	[nc addObserver:self selector:@selector(HttpDelResponceNotification:)   name:@"setHttpDelResponceNotification"   object:nil];
	[nc addObserver:self selector:@selector(HttpInternalErrorNotification:) name:@"setHTTPInternalErrorNotification" object:nil];

    
    
    // メインビュー初期化
    [super InitView:[CommonUtil getSSID]
         menuBtnNum:PrvMenuIDSecond
   setHiddenNoImage:YES];
    
    //NO Image表示
    [super setNoImageHidden:NO];
    
	NSString* pstrTitle = S_BUTTON_NO_SCANNER;			// ボタン表示名称
    NSString* pstrBtnName = @"";        // ボタン名称
    NSString* pstrInitValue = @"";      // 表示初期値
    
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
    
    // リモートスキャン対応MFPかチェックする
    if(printerData.IsCapableRemoteScan)
    {
        //        remoteSwitchBaseView.hidden = NO;
        remoteSwitchLbl.hidden = NO;
        remoteSwt.hidden = NO;
        
        if(bNavRightBtn)
        {
            m_bShowMenu = NO;
            bRemoteScanSwitch = YES;
//            [super AnimationShowMenu];
        }
    }else
    {
        //        remoteSwitchBaseView.hidden = YES;
        remoteSwitchLbl.hidden = YES;
        remoteSwt.hidden = YES;
        if(bNavRightBtn)
        {
            m_bShowMenu = NO;
            bRemoteScanSwitch = NO;
            [super AnimationShowMenu];
        }
    }
    
	// ボタン表示名称更新
	for (NSInteger nCnt = PrvMenuIDFirst; nCnt <= PrvMenuIDSecond; nCnt++)
    {
        switch (nCnt)
        {
            case PrvMenuIDFirst:
                if(printerData != nil)
                {
                    pstrBtnName = S_BUTTON_SCAN;
                    if([self isKindOfClass:[RemoteScanBeforePictViewController class]])
                    {
                        pstrTitle = [[NSString alloc]initWithFormat: S_BUTTON_REMOTESCAN, pstrInitValue];
                    }else
                    {
                        pstrTitle = [[NSString alloc]initWithFormat: pstrBtnName, pstrInitValue];
                    }
                }
				[self.m_pbtnFirst setTitle:pstrTitle forState:UIControlStateNormal];
                self.m_pbtnFirst.titleLabel.lineBreakMode = NSLineBreakByTruncatingTail;
                self.m_pbtnFirst.titleLabel.adjustsFontSizeToFitWidth = YES;
                
                if (![S_LANG isEqualToString:S_LANG_JA])
                {
                    // 海外版の場合
                    self.m_pbtnFirst.titleLabel.minimumScaleFactor = [UIFont systemFontSize] / self.m_pbtnFirst.titleLabel.font.pointSize;
                }
                else
                {
                    // 国内版の場合、表示文字を小さくする
                    self.m_pbtnFirst.titleLabel.minimumScaleFactor = 7 / self.m_pbtnFirst.titleLabel.font.pointSize;
                }
				break;
                
            case PrvMenuIDSecond:
                if(printerData != nil)
                {
                    pstrBtnName = S_BUTTON_SCANNER;
                    pstrTitle = [[NSString alloc]initWithFormat: pstrBtnName, pstrInitValue];
                }
				[self.m_pbtnSecond setTitle:pstrTitle forState:UIControlStateNormal];
                self.m_pbtnSecond.titleLabel.lineBreakMode = NSLineBreakByTruncatingTail;
                self.m_pbtnSecond.titleLabel.adjustsFontSizeToFitWidth = YES;
                
                if (![S_LANG isEqualToString:S_LANG_JA])
                {
                    // 海外版の場合
                    self.m_pbtnSecond.titleLabel.minimumScaleFactor = [UIFont systemFontSize] / self.m_pbtnSecond.titleLabel.font.pointSize;
                }
                else
                {
                    // 国内版の場合、表示文字を小さくする
                    self.m_pbtnSecond.titleLabel.minimumScaleFactor = 7 / self.m_pbtnSecond.titleLabel.font.pointSize;
                }
                //				m_nSelPickerRow2 = m_pPrinterMgr.DefaultMFPIndex;
                self.m_nSelPickerRow2 = scanerPickerRow;
                break;
                
            default:
                break;
        }
    }
    
    
    
    // 選択可能なスキャナーが存在しない場合はボタンを非活性にする。
    if([self isKindOfClass:[RemoteScanBeforePictViewController class]])
    {
        [self.m_pbtnFirst setEnabled:self.m_pbtnFirst.enabled];
    }else
    {
        [self.m_pbtnFirst setEnabled:YES];
    }
    [self.m_pbtnSecond setEnabled:YES];
    if(printerData == nil)
    {
        [self.m_pbtnFirst setEnabled:NO];
        [self.m_pbtnSecond setEnabled:NO];
    }
    self.isRemoteScan = NO;
}

// 画面非表示前処理
- (void)viewWillDisappear:(BOOL)animated
{
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
    // Release any retained subviews of the main view.
    // e.g. myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
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
- (void) createProgressionAlertWithMessage:(NSString *)titles
                                   message:(NSString *)messages
                                withCancel:(BOOL)cancel
                                       tag:(NSInteger)tag
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
    if (self.m_pThread || m_bAbort)
    {
        return;
    }
    
    SharpScanPrintAppDelegate* appDelegate = (SharpScanPrintAppDelegate*)[[UIApplication sharedApplication] delegate];
    appDelegate.IsRun = TRUE;
    
    m_isScanStop = FALSE;
    
    // プリンタ情報が取得できなければ何もしない
    PrinterData* printerData = nil;
    //    printerData = [m_pPrinterMgr LoadPrinterDataAtIndex2:m_nSelPickerRow2];
    printerData = [m_pPrinterMgr LoadPrinterDataAtIndexInclude2:self.m_nSelPickerRow2];
    if (printerData == nil)
    {
        m_isScanStop = TRUE;
        [self makeAlert:nil message:MSG_SCAN_REQ_ERR cancelBtnTitle:MSG_BUTTON_OK okBtnTitle:nil tag:0];
        return;
    }
    //ネットスキャン非対応時にはメッセージを出して終わり
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
        [self makeAlert:nil
                message:[NSString stringWithFormat:@"%@\r\n\r\n%@", MSG_SCAN_CONFIRM, MSG_SCAN_CONFIRM_FREESIZE]
         cancelBtnTitle:MSG_BUTTON_CANCEL
             okBtnTitle:MSG_BUTTON_OK
                    tag:99];
    }else{
        [self makeAlert:nil
                message:MSG_SCAN_CONFIRM
         cancelBtnTitle:MSG_BUTTON_CANCEL
             okBtnTitle:MSG_BUTTON_OK
                    tag:99];
    }
    
}

// メニューボタン２（プリンタ選択）押下
- (IBAction)OnMenuSecondButton:(id)sender
{
    // 処理中あるいは処理中断フラグ=TRUEの場合は何もしない
    if (self.m_pThread || m_bAbort)
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
}

// アクションシート決定ボタン押下
- (void)OnMenuDecideButton:(id)sender
{
    // Picker選択値設定
    [self setPickerValue];
}

// アクションシートキャンセルボタン押下
- (void)OnMenuCancelButton:(id)sender
{
    [super OnMenuCancelButton:sender];
}

// ナビゲーションバー 設定ボタン押下
- (IBAction)OnNavBarRightButton:(id)sender
{
    
    scanerPickerRow = -1;
    [super OnNavBarRightButton:(id)sender];
}

// Picker選択値設定
-(void)setPickerValue
{
    NSString* pstrScanner;
    NSString* pstrTitle;
    
    //ピッカー非表示
    [_pickerModalBaseView dismissAnimated:YES];
   
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
                {
                    // MFPのリモートスキャン設定の状態をチェックする
                    if([CommonUtil isCapableRemoteScan:printerData])
                    {
                        // リモートスキャンに切り替える
                        [self nomalScanToRemoteScan];
                    }
                    else
                    {
                        // リモートスキャン切替スイッチ表示
                        //                        remoteSwitchBaseView.hidden = NO;
                        remoteSwitchLbl.hidden = NO;
                        remoteSwt.hidden = NO;
                        m_bShowMenu = NO;
                        bRemoteScanSwitch = YES;
                        [super AnimationShowMenu];
                    }
                }
                else
                {
                    // リモートスキャン切替スイッチ非表示
                    //                    remoteSwitchBaseView.hidden = YES;
                    remoteSwitchLbl.hidden = YES;
                    remoteSwt.hidden = YES;
                    m_bShowMenu = NO;
                    bRemoteScanSwitch = NO;
                    [super AnimationShowMenu];
                }
            }
            
            // ボタン名称に反映
            pstrScanner = [m_parrPickerRow objectAtIndex:self.m_nSelPickerRow2];
            if([self isKindOfClass:[RemoteScanBeforePictViewController class]])
            {
                pstrTitle = [[NSString alloc]initWithFormat: S_BUTTON_REMOTESCAN, pstrScanner];
            }
            else {
                pstrTitle = [[NSString alloc]initWithFormat: S_BUTTON_SCAN, pstrScanner];
            }
            
            [self.m_pbtnFirst setTitle:pstrTitle forState:UIControlStateNormal];
            
            pstrTitle = [[NSString alloc]initWithFormat: S_BUTTON_SCANNER, pstrScanner];
            [self.m_pbtnSecond setTitle:pstrTitle forState:UIControlStateNormal];
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
#pragma mark - Move RemoteScan
// リモートスキャンに切り替える
-(void)nomalScanToRemoteScan
{
    //プリンタ情報更新
    m_pPrinterMgr.PrinterDataList = [m_pPrinterMgr ReadPrinterData];

    // 処理中あるいは処理中断フラグ=TRUEの場合は何もしない
    if (self.m_pThread || m_bAbort)
    {
        return;
    }
    m_bShowMenu = YES;
    bRemoteScanSwitch = YES;
    [super AnimationShowMenu];
    
    [self performSelector:@selector(moveRemoteScan) withObject:nil afterDelay:0.3f];
}

-(void)moveRemoteScan
{
    RemoteScanBeforePictViewController *pRemoteScanViewController;
    
    // リモートスキャン画面へ遷移
    pRemoteScanViewController = [[RemoteScanBeforePictViewController alloc] init];
    // 初期で選択するスキャナーを設定する
    pRemoteScanViewController.scanerPickerRow = self.m_nSelPickerRow2;
    pRemoteScanViewController.selectedPrinterPrimaryKey = selectedPrinterPrimaryKey;
    
    id vcNew = pRemoteScanViewController;
    
    // 表示している画面遷移の履歴を入れ替える
    NSArray *parrViewControllers = self.navigationController.viewControllers;
    NSArray *parrNewViewControllers = [NSArray arrayWithObjects:[parrViewControllers objectAtIndex:0],vcNew, nil];
    
    [self.navigationController setViewControllers:parrNewViewControllers];
}

- (IBAction)tapRemoteSwt:(UISwitch*)sender {
    // リモートスキャンスイッチ切替
    if(sender.on){
        // リモートスキャンをオンにする
        [self nomalScanToRemoteScan];
    }
}

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
        //    printerData = [m_pPrinterMgr LoadPrinterDataAtIndex2:m_nSelPickerRow2];
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
        //    printerData = [m_pPrinterMgr LoadPrinterDataAtIndex2:m_nSelPickerRow2];
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
            httpMgr			= [[HttpManeger alloc] init];       // インスタンス取得
            httpMgr.myname		= profileData.profileName;		// 宛先名（必須）
            httpMgr.user		= m_ScanUser;                   // ユーザ名
            httpMgr.password	= m_ScanPass;                   // パスワード
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
            httpLegacyMgr.myname    = profileData.profileName;          // 宛先名（必須）
            httpLegacyMgr.user      = m_ScanUser;                       // ユーザ名
            httpLegacyMgr.password  = m_ScanPass;                       // パスワード
            httpLegacyMgr.serchStr	= profileData.serchString;          // 検索文字（必須）
            httpLegacyMgr.ipAder    = self.iPaddr;                      // IPアドレス
            httpLegacyMgr.mfpipAder = self.mfp_iPaddr;                  // MFP IPアドレス
            httpLegacyMgr.addDic        = printerData.addDic;           // post時のキー情報
            httpLegacyMgr.updateDic     = printerData.updateDic;        // post時のキー情報
            httpLegacyMgr.deleteDic     = printerData.deleteDic;        // post時のキー情報
            
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
            httpMgr			= [[HttpManeger alloc] init];	// インスタンス取得
            httpMgr.myname		= profileData.profileName;		// 宛先名（必須）
            httpMgr.user		= m_ScanUser;		// ユーザ名
            httpMgr.password	= m_ScanPass;		// パスワード
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
            httpLegacyMgr.myname    = profileData.profileName;		// 宛先名（必須）
            httpLegacyMgr.user		= m_ScanUser;		// ユーザ名
            httpLegacyMgr.password	= m_ScanPass;		// パスワード
            httpLegacyMgr.serchStr	= profileData.serchString;		// 検索文字（必須）
            httpLegacyMgr.ipAder    = self.iPaddr;					// IPアドレス
            httpLegacyMgr.mfpipAder	= self.mfp_iPaddr;				// MFP IPアドレス
            httpLegacyMgr.addDic        = printerData.addDic;                   // post時のキー情報
            httpLegacyMgr.updateDic     = printerData.updateDic;                // post時のキー情報
            httpLegacyMgr.deleteDic     = printerData.deleteDic;                // post時のキー情報
            
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
            [ex_alert.view addSubview:lblSearch];

            if([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0)
            {   // iOS7以上なら
                // メッセージの改行をとる
                NSString *mess = [ MSG_WAIT_SCAN stringByReplacingOccurrencesOfString:@"\r\n\r\n\r\n\r\n\r\n" withString:@""];
                mess = [NSString stringWithFormat:@"%@\n%@\n%@", mess, pstrSearch, pstrProfileName];
                [ex_alert setMessage:mess];
                
            }
        }
        
	}
    
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
                    [self startFTP];						// FTP 開始
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
                if(ex_alert != nil)
                {
                    // アラートを閉じる
                    [ex_alert dismissViewControllerAnimated:YES completion:^{
                        //
                        // 異常: 認証エラー
                        //
                        [self addPost:HTTP_USERA_VALID];					// HTTP POST 送信(登録)
                    }];
                } else {
                    //
                    // 異常: 認証エラー
                    //
                    [self addPost:HTTP_USERA_VALID];					// HTTP POST 送信(登録)
                }
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
                    [self startFTP];						// FTP 開始
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
                
                // 解放
                
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
        
        NSInteger tempTagIndex = 0;
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
            self.ScanFileName = nil;
        }
        
        //
		// 1:受信中
		//
		self.ScanFileName= [[aNotification userInfo] objectForKey:@"FTP_FILENAME"];
		//TRACE(@"1:受信中] %@", postdata, self.ScanFileName);
        
        // アラート内容を変更
        ex_alert.tag = 11;
        ex_alert.title = nil;
        ex_alert.message = MSG_SCAN_DOING;
        
        lblProfilaName.text = @"";
        lblSearch.text = @"";
        
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

//ダイアログのボタン押下時
-(void)alertButtonPushed:(UIAlertController *)alertController tagIndex:(NSInteger)tagIndex buttonIndex:(NSInteger)buttonIndex{

    NSFileManager*  fileManager	= [NSFileManager defaultManager];
    
    //
    // PROFILE情報の取得
    //
    profileDataManager = [[ProfileDataManager alloc] init];
    ProfileData *profileData = nil;
    profileData = [profileDataManager loadProfileDataAtIndex:0];
    
    SharpScanPrintAppDelegate* appDelegate = (SharpScanPrintAppDelegate*)[[UIApplication sharedApplication] delegate];
    
    switch (tagIndex)
    {
        case 1:
            // HTTP プロファイル登録で表示名が既にある場合
            //TRACE(@"[SecondView]alert HTTP 登録（既に登録されている）続行 押下");
            
            if (buttonIndex != 0)
            {
                [self modPost]; // プロファイル更新
            }
            else
            {
                m_isScanStop = TRUE;
            }
            
            break;
            
        case 10:
            if ((int)ex_alert.tag == 11) {
                // ファイル受信中にキャンセルされた場合の暫定処理
                [self alertButtonPushed:nil tagIndex:11 buttonIndex:0];
            } else {
                // ScantoFTP待ち中にキャンセルされた場合
                //TRACE(@"[SecondView]alert ScantoFTP待ち中にキャンセル 押下");
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
                    if (bCreate && ([tManager countOfTempData] > 1))
                    {
                        // 一覧遷移
                        // ナビゲーションバー ボタン押下可能
                        self.navigationController.navigationBar.userInteractionEnabled = YES;
                        TempDataTableViewController* tempDataTableViewController;
                        tempDataTableViewController = [[TempDataTableViewController alloc] initWithStyle:UITableViewStyleGrouped];
                        tempDataTableViewController.isScan = TRUE;
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
                        
                        ScanAfterPictViewController* scanpViewController;
                        scanpViewController = [[ScanAfterPictViewController alloc] init];
                        //
                        // 呼び出し画面のプロパティ設定
                        //
                        TempFile *localTempFile = [[TempFile alloc]initWithFileName:aTempData.fname];
                        scanpViewController.tempFile = localTempFile;
                        [self.navigationController pushViewController:scanpViewController animated:YES];
                    }
                }
            }
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
                
                // メニュー表示を非表示に動作
                if(m_bShowMenu)
                {
                    [self AnimationShowMenu];
                }
                
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
    TempFile *tempFile = [[TempFile alloc]initWithFileName:ScanFileName];
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

@end
