
#import "TwainRemoteScanBeforePictViewController.h"
#import "SharpScanPrintAppDelegate.h"
#import "ScanAfterPictViewController.h"
#import "TempDataTableViewController.h"
#import "ProfileDataManager.h"

@interface TwainRemoteScanBeforePictViewController ()

@end

@implementation TwainRemoteScanBeforePictViewController

@synthesize rssViewData;
@synthesize rsManager;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    // デフォルト値を設定　//TODO:（仮）
    self.scanPosition = ScanPositionPlaten;
    self.direction = DirectionFromTop;
    self.resolution = Resolution75;
    self.colorMode = ColorModeFullColor;
//    self.threshold = kThresholdValue;
    self.colorDepth = kColorDepthValue;
    [self getThreshold];
    self.paperSize = PaperSizeA4;
    self.computerName = @"TestComputer";
    self.timeoutSec = kTimeoutValue;
    
    
    m_pPrinterInfo = [[PrinterData alloc] init];
    
    // メインビュー初期化
    [super InitView:[CommonUtil getSSID] menuBtnNum:PrvMenuIDSeventh];
    
    // スキャナーの設定情報を取得
    [self createConnectUrl];
    
    // ボタン1をスクロールビュー内に配置し直す
    [self replaceMenuButton:PrvMenuIDFirst];

    // ボタン2をスクロールビュー内に配置し直す
    [self replaceMenuButton:PrvMenuIDSecond];
    
    // メニュー作成
    NSString* pstrBtnName = S_BUTTON_NO_SCANNER;      // ボタン名称
    NSString* pstrInitValue;    // 表示初期値
    NSString* pstrIconName;     // アイコン名称
    
    for (NSInteger nCnt = PrvMenuIDThird; nCnt <= PrvMenuIDSeventh; nCnt++)
    {
        switch (nCnt)
        {
            case PrvMenuIDThird:
                pstrBtnName = S_BUTTON_REMOTE_COLORMODE;
                pstrInitValue = S_RS_XML_COLORMODE_AUTO;
                pstrIconName = S_ICON_RS_COLORMODE;
                break;
            case PrvMenuIDFourth:
                pstrBtnName = S_BUTTON_MANUSCRIPT;
                pstrInitValue = S_RS_XML_AUTO;
                pstrIconName = S_ICON_RS_MANUSCRIPT;
                break;
            case PrvMenuIDFifth:
                pstrBtnName = S_BUTTON_BOTH;
                pstrInitValue = S_RS_XML_DUPLEX_MODE_SIMPLEX;
                pstrIconName = S_ICON_RS_BOTHSIDES;
                break;
//            case PrvMenuIDSixth:
//                pstrBtnName = S_BUTTON_FORMAT;
//                pstrInitValue = S_RS_XML_FILE_FORMAT_PDF;
//                pstrIconName = S_ICON_RS_FORMAT;
//                break;
            case PrvMenuIDSixth:
                pstrBtnName = S_BUTTON_RESOLUTION;
                pstrInitValue = S_RS_XML_RESOLUTION_200;
                pstrIconName = S_ICON_RS_PPI;
                break;
            case PrvMenuIDSeventh:
                pstrBtnName = S_BUTTON_OTHER;
                pstrInitValue = nil;
                pstrIconName = S_ICON_RS_OTHERSETTING;
                break;
            default:
                break;
        }
        self.IsBeforeView = NO;
        [super CreateMenu:nCnt
                  btnName:pstrBtnName
                initValue:pstrInitValue
                 iconName:pstrIconName];
        
        // メニューボタンをスクロールビュー内に配置し直す
        [self replaceMenuButton:nCnt];
    }
    
    // 端末設定のビューをスクロール画面に追加する
    // ラベルをスクロールビューに配置
    CGRect viewRectLbl = (CGRect){remoteSwitchLbl.frame.origin.x ,self.m_pbtnSeventh.frame.origin.y + self.m_pbtnSeventh.frame.size.height ,180 ,30};
    [remoteSwitchLbl removeFromSuperview];
    [remoteSwitchLbl setFrame:viewRectLbl];
    [menuScrollView addSubview:remoteSwitchLbl];
    
    // スイッチをスクロールビューに配置
    CGRect viewRect = (CGRect){remoteSwt.frame.origin.x ,self.m_pbtnSeventh.frame.origin.y + self.m_pbtnSeventh.frame.size.height + 5};
    [remoteSwt removeFromSuperview];
    [remoteSwt setFrame:viewRect];
    [menuScrollView addSubview:remoteSwt];
    
    
    // メニュースクロールビューの設定
    menuScrollView.delegate = self;
    menuScrollView.contentSize = (CGSize){menuScrollView.frame.size.width, self.m_pbtnSeventh.frame.origin.y + self.m_pbtnSeventh.frame.size.height + 50};
    menuScrollView.bounces = NO;
    [self scrollViewDidScroll:menuScrollView animated:NO];
    
    // メニューのビューを指定
    //iphone用
    //    m_pMenuView = menuScrollView;
    [m_pMenuView addSubview:menuScrollView];
    
    if([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0)
    {   // iOS7以上なら
        m_pMenuView.transform = CGAffineTransformMakeTranslation(0, 90);
        m_pMenuButtonView.transform = CGAffineTransformMakeTranslation(0, 90);
    }
    
    // 吹き出し
    //    UIImage* fukidashiImg = [UIImage imageNamed:@"fukidashi.png"];
    //    fukidashiView = [[UIImageView alloc]initWithImage:fukidashiImg];
    //    fukidashiView.frame = (CGRect){CGPointZero, fukidashiImg.size.width, m_pbtnThird.frame.size.height};
    //    [menuScrollView addSubview:fukidashiView];
    //    DLog(@"fukidashiView.frame:%@", NSStringFromCGRect(fukidashiView.frame));
    //
    //    // 初期は未選択なので、設定表示ビューと吹き出しを非表示
    //    settingView.hidden = fukidashiView.hidden = YES;
    
    
    //
	// PROFILE情報の取得
	//
    profileDataManager = [[ProfileDataManager alloc] init];
    ProfileData *profileData = nil;
    profileData = [profileDataManager loadProfileDataAtIndex:0];
    
    // 表示名、確認コードの取得
    //    strProfileName = [[CommonUtil trimString:profileData.profileName halfCharNumber:MAXPROFILENAMELENGTH] copy];
    strProfileName = [profileData.profileName copy];
    if(!profileData.autoCreateVerifyCode || profileData.verifyCode == nil || [profileData.verifyCode isEqualToString:@""])
    {
        strVerifyCode = [[CommonUtil createRandomNumber:9999] copy];
    }
    else
    {
        strVerifyCode = [profileData.verifyCode copy];
    }
    
    // リモートスキャン中フラグを初期化
    bRemoteScanRunning = NO;
    strOriginalSize = @"unknown";
    
    bDoReleaseUiSessionId = YES;
    
    // 初回エラーフラグの初期化
    bFirstErr_Network = YES;
    
//    // ボタンを非活性にする
//    [self setAllButtonEnable:NO];
    
    if([self getIPAdder])
    {
        
//        [self rsGetJobSettableElements];
        
//        [self startGetMfpIf];
        
    } else {
        // WIFI接続なしエラー
        [self showErrorAlertOnMainThreadWithMessage:MSG_NETWORK_ERR tag:TW_ALERT_TAG_WIFI_NO_CONNECTION];
    }
    
    // キーボード監視
    [self registerForKeyboardNotifications];
    
    self.view.backgroundColor = BACKGROUND_COLOR;// TableViewに合わせた背景を設定
    if([[[UIDevice currentDevice] systemVersion] floatValue] >= 6.0 &&
       [[[UIDevice currentDevice] systemVersion] floatValue] < 7.0 &&
       UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
    {// iOS6のiPhoneだけ
        UITableView *tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
        [self.view addSubview:tableView];
        [self.view sendSubviewToBack:tableView];
    }

}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];

    // メインビュー初期化
    [super InitView:[CommonUtil getSSID] menuBtnNum:PrvMenuIDSeventh];
    
    // とりあえず
//    m_pManuscriptVC = nil;
    selectedVC = nil;
    
    //    BOOL iPhoneSize4inches = [self.view.superview frame].size.height >= 500;
    BOOL iPhoneSize4inches = [[UIScreen mainScreen] bounds].size.height >= 500;
    if(iPhoneSize4inches){
        
        CGRect frame = CGRectMake(0,7,self.view.frame.size.width, 562);
        menuScrollView.frame = frame;
    }
    else
    {
        CGRect frame = CGRectMake(0,7,self.view.frame.size.width,326);
        menuScrollView.frame = frame;
    };
    
    if(bNavRightBtn)
    {
        if([self getIPAdder])
        {
            
            [self rsGetJobSettableElements];
            
//            [self startGetMfpIf];
            
        } else {
            // WIFI接続なしエラー
            [self showErrorAlertOnMainThreadWithMessage:MSG_NETWORK_ERR tag:TW_ALERT_TAG_WIFI_NO_CONNECTION];
        }
    }

}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

// メニューをスクロールビュー内に再配置する
-(void)replaceMenuButton:(int)menuId
{
    UIButton* btn = nil;
    
    switch (menuId)
    {
        case PrvMenuIDFirst:
            btn = self.m_pbtnFirst;
            break;
        case PrvMenuIDSecond:
            btn = self.m_pbtnSecond;
            break;
        case PrvMenuIDThird:
            btn = self.m_pbtnThird;
            break;
        case PrvMenuIDFourth:
            btn = self.m_pbtnFourth;
            break;
        case PrvMenuIDFifth:
            btn = self.m_pbtnFifth;
            break;
        case PrvMenuIDSixth:
            btn = self.m_pbtnSixth;
            break;
        case PrvMenuIDSeventh:
            btn = self.m_pbtnSeventh;
            break;
//        case PrvMenuIDEighth:
//            btn = self.m_pbtnEighth;
//            break;
        default:
            break;
    }
    
    if(btn){
        // ボタンを再配置
        [self replaceToScrollView:btn];
        //        DLog(@"btn.frame:%@", NSStringFromCGRect(btn.frame));
    }
}
-(void)replaceToScrollView:(UIView*)view
{
    if(view){
        // ボタンを現在の位置から削除
        [view removeFromSuperview];
        
        // スクロールビューに配置
        CGRect viewRect = view.frame;
        viewRect.origin.x -= menuScrollView.frame.origin.x;
        viewRect.origin.y -= menuScrollView.frame.origin.y;
        [view setFrame:viewRect];
        [menuScrollView addSubview:view];
    }
}

- (void)createConnectUrl
{
    if(selectMfpRSPortNo == nil || [selectMfpRSPortNo isEqualToString:@""]){
        selectMfpRSPortNo = @"10080";
    }
    
    connectUrl = [[NSURL alloc]initWithString:[NSString stringWithFormat:@"http://%@:%d/", selectMfpIpAddress, [selectMfpRSPortNo intValue]]];
    
    DLog(@"connectURL: %@", connectUrl);
}


-(BOOL)getIPAdder
{
    BOOL result = YES;
    
    self.iPaddr	= @"";
    self.iPaddr	= [CommonUtil getIPAdder];
    
    unsigned int len = [[self.iPaddr stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] length];
    if (len <= 0)
    {
        result = NO;
    }
    
    return  result;
}


-(void)setAllButtonEnable:(BOOL) enable
{
    self.m_pbtnFirst.enabled = enable;
    // スキャナーボタンは制御しない
    //    m_pbtnSecond.enabled = enable;
    self.m_pbtnThird.enabled = enable;
    self.m_pbtnFourth.enabled = enable;
    self.m_pbtnFifth.enabled = enable;
    self.m_pbtnSixth.enabled = enable;
    self.m_pbtnSeventh.enabled = enable;
    self.m_pbtnEighth.enabled = enable;
}

-(void)setFirstButtonEnable
{
    self.m_pbtnFirst.enabled = YES;
}

// 濃度レベルからしきい値を返す
- (void)getThreshold
{
//    switch (self.colorDepth) {
//        case 1:
//            self.threshold = 1;
//            break;
//        case 2:
//            self.threshold = 65;
//            break;
//        case 3:
//            self.threshold = 128;
//            break;
//        case 4:
//            self.threshold = 191;
//            break;
//        case 5:
//            self.threshold = 254;
//            break;
//            
//        default:
//            break;
//    }
    switch (self.colorDepth) {
        case 1:
            self.threshold = 42;
            break;
        case 2:
            self.threshold = 85;
            break;
        case 3:
            self.threshold = 128;
            break;
        case 4:
            self.threshold = 171;
            break;
        case 5:
            self.threshold = 214;
            break;
            
        default:
            break;
    }
}

#pragma mark - Getter
-(RSGetJobSettableElementsManager*)rsManager{
    return rsManager;
}

#pragma mark - Rotate Event
- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration
{
    // 下位のビューコントローラにも回転通知を送る
    if(selectedVC){
        [selectedVC willRotateToInterfaceOrientation:toInterfaceOrientation duration:duration];
    }
}
-(void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation
{
    // スクロールボタンの判定
    [self scrollViewDidScroll:menuScrollView animated:NO];
}

#pragma mark - Menu Button Action
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
        [self CreateAllert:nil message:MSG_SCAN_REQ_ERR btnTitle:MSG_BUTTON_OK];
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
        [super CreateAllert:nil message:[NSString stringWithFormat:@"%@\r\n\r\n%@", MSG_SCAN_CONFIRM, MSG_SCAN_CONFIRM_FREESIZE ] btnTitle:MSG_BUTTON_CANCEL withTag:99];
    }else{
        [super CreateAllert:nil message:MSG_SCAN_CONFIRM btnTitle:MSG_BUTTON_CANCEL withTag:99];
    }
    
    return;

//////
    // 押下時に非活性にし、1秒後に活性に戻す
    self.m_pbtnFirst.enabled = NO;
    [self performSelector:@selector(setFirstButtonEnable) withObject:nil afterDelay:1.0f];
    
    // 処理中あるいは処理中断フラグ=TRUEの場合は何もしない
    if (self.m_pThread || m_bAbort)
    {
        return;
    }
    
//    // 長尺の場合はチェック
//    if([[rssViewData.originalSize getSelectValue] isEqualToString:@"long"])
//    {
//        if([[rssViewData.duplexData getSelectValue] isEqualToString:@"duplex+book"]
//           || [[rssViewData.duplexData getSelectValue] isEqualToString:@"duplex+tablet"])
//        {
//            //　GetDeviceStatusのポーリング処理は続行する
//            [super CreateAllert:nil message:MSG_REMOTESCAN_NOTUSE btnTitle:MSG_BUTTON_OK];
//            return;
//        }
//    }
    
//    // 原稿サイズと保存サイズの整合性をチェック
//    PaperSetMatrix* paperMatrix = [[PaperSetMatrix alloc] init];
//    [paperMatrix setMatirx];
//    
//    BOOL paperSetCheck =  [paperMatrix originalSize:[rssViewData.originalSize getSelectValue]
//                                           sendSize:[rssViewData.sendSize getSelectValue]
//                                           rotation:[rssViewData.rotation getSelectValue]];
//    
//    
//    if (!paperSetCheck)
//    {
//        [self CreateAllert:nil message:MSG_REMOTESCAN_PAPER_SETTING_ERR btnTitle:MSG_BUTTON_OK];
//        return;
//    }
    
//    // MFPがJAM中の場合は、エラーとする
//    if([strOriginalSize isEqualToString:@"JAM"])
//    {
//        [self CreateAllert:nil message:MSG_REMOTESCAN_JAMMING_ERR btnTitle:MSG_BUTTON_OK];
//        return;
//    }
//    
////    SharpScanPrintAppDelegate* appDelegate = (SharpScanPrintAppDelegate*)[[UIApplication sharedApplication] delegate];
////    appDelegate.IsRun = TRUE;
//    
//    m_isScanStop = FALSE;
//    
//    // プリンタ情報が取得できなければ何もしない
//    PrinterData* printerData = nil;
//    printerData = [m_pPrinterMgr LoadPrinterDataAtIndexInclude2:self.m_nSelPickerRow2];
//    if (printerData == nil)
//    {
//        m_isScanStop = TRUE;
//        [self CreateAllert:nil message:MSG_SCAN_REQ_ERR btnTitle:MSG_BUTTON_OK];
//        return;
//    }
//    
//    if([self getIPAdder])
//    {
////        nStatus = RSSTATUS_REQUESTUISESSIONID;
////        nSetDeviceRetryCount = 0;
//        
//        // しばらくお待ちくださいダイアログを出す
//        [self createProgressionAlertWithMessage:nil message: MSG_WAIT withCancel:YES];
//        alert.tag = TW_ALERT_TAG_SETDEVICECONTEXT_WAIT;
//        
//        [self rsRequestUISessionId];
//    } else {
//        [self showNetworkAlert];
//    }
 
//    // しばらくお待ちくださいダイアログを出す
//    [self createProgressionAlertWithMessage:nil message: MSG_WAIT withCancel:YES];
//    alert.tag = TW_ALERT_TAG_SETDEVICECONTEXT_WAIT;
//
//    // 確認用
//    //取り込み用
////    _tsc = [[TwainSocketController alloc]initWithHost:@"192.168.0.100" portNo:@(52000) scanPosition:ScanPositionPlaten direction:DirectionFromTop resolution:Resolution75 colorMode:ColorModeGrayscale threshold:kThresholdValue paperSize:PaperSizeA4 computerName:@"TestComputer" timeoutSec:kTimeoutValue delegate:self];
//    _tsc = [[TwainSocketController alloc]initWithHost:@"192.168.0.100" portNo:@(52000) scanPosition:ScanPositionSPFoneSide direction:DirectionFromTop resolution:Resolution75 colorMode:ColorModeGrayscale threshold:kThresholdValue paperSize:PaperSizeA4 computerName:@"TestComputer" timeoutSec:kTimeoutValue delegate:self];
//    //準備用
//    //_tsc = [[TwainSocketController alloc]initForModeSenseWithHost:@"192.168.0.100" portNo:@(52000) timeoutSec:kTimeoutValue delegate:self];
//    [_tsc sendGreetingMessage];
////    OperationRole;
}

// カラーモード
- (IBAction)OnMenuThirdButton:(id)sender
{
    // ReleaseUiSessionIdをしないフラグをたてる
    bDoReleaseUiSessionId = NO;
    NSArray *array = [[NSArray alloc] initWithObjects:@"フルカラー", @"グレースケール", @"白黒２値", nil];
//    NSArray *array = [rssViewData.colorMode getSelectableArray];
    DLog(@"array:%@",[array description]);
//    m_pColorModeVC = [[TRSS_ColorModeViewController alloc]initWithColorModeArray:[rssViewData.colorMode getSelectableArray] delegate:self];
    m_pColorModeVC = [[TRSS_ColorModeViewController alloc]initWithColorModeArray:array delegate:self];
    
//    m_pColorModeVC.nSelectedIndexRow = [rssViewData.colorMode getSelectIndex];
    /**/
    
    [self.navigationController pushViewController:m_pColorModeVC animated:YES];
}

// 原稿
- (IBAction)OnMenuFourthButton:(id)sender
{
    // ReleaseUiSessionIdをしないフラグをたてる
    bDoReleaseUiSessionId = NO;
    
//    RemoteScanSettingViewData * rssViewData_local = [[RemoteScanSettingViewData alloc] initWithRSSettableElementsData:
//                                                     [rsManager rsSettableElementsData]];
    
    //    NSArray* originalSizeArray = [rssViewData.originalSize getSelectableArray];
//    NSArray *array = [[NSArray alloc] initWithObjects:@"", nil];
    // ファイルに保存されているデータから原稿サイズのみ取得し直す
//    NSArray* originalSizeArray = [rssViewData_local.originalSize getSelectableArray];
    NSArray* originalSizeArray = [[NSArray alloc] initWithObjects:S_RS_XML_ORIGINAL_SIZE_A3, S_RS_XML_ORIGINAL_SIZE_A4, S_RS_XML_ORIGINAL_SIZE_A4_R, S_RS_XML_ORIGINAL_SIZE_A5, S_RS_XML_ORIGINAL_SIZE_A5_R, S_RS_XML_ORIGINAL_SIZE_B4, S_RS_XML_ORIGINAL_SIZE_B5, S_RS_XML_ORIGINAL_SIZE_B5_R, S_RS_XML_ORIGINAL_SIZE_LEDGER, S_RS_XML_ORIGINAL_SIZE_LETTER, S_RS_XML_ORIGINAL_SIZE_LETTER_R, S_RS_XML_ORIGINAL_SIZE_8_1_2X13_2_5, S_RS_XML_ORIGINAL_SIZE_LEGAL, S_RS_XML_ORIGINAL_SIZE_INVOICE, S_RS_XML_ORIGINAL_SIZE_INVOICE_R, S_RS_XML_ORIGINAL_SIZE_FOOLSCAP, S_RS_XML_ORIGINAL_SIZE_8K, S_RS_XML_ORIGINAL_SIZE_16K, S_RS_XML_ORIGINAL_SIZE_16KR, S_RS_XML_ORIGINAL_SIZE_LONG, S_RS_XML_ORIGINAL_SIZE_8_1_2X13_1_2, S_RS_XML_ORIGINAL_SIZE_JAPANESE_POSTCARD_A6, nil];

//    NSArray* sendSizeArray = [rssViewData.sendSize getSelectableArray];
    NSArray* sendSizeArray = [[NSArray alloc] initWithObjects:S_RS_XML_ORIGINAL_SIZE_A3, S_RS_XML_ORIGINAL_SIZE_A4, S_RS_XML_ORIGINAL_SIZE_A4_R, S_RS_XML_ORIGINAL_SIZE_A5, S_RS_XML_ORIGINAL_SIZE_A5_R, S_RS_XML_ORIGINAL_SIZE_B4, S_RS_XML_ORIGINAL_SIZE_B5, S_RS_XML_ORIGINAL_SIZE_B5_R, S_RS_XML_ORIGINAL_SIZE_LEDGER, S_RS_XML_ORIGINAL_SIZE_LETTER, S_RS_XML_ORIGINAL_SIZE_LETTER_R, S_RS_XML_ORIGINAL_SIZE_8_1_2X13_2_5, S_RS_XML_ORIGINAL_SIZE_LEGAL, S_RS_XML_ORIGINAL_SIZE_INVOICE, S_RS_XML_ORIGINAL_SIZE_INVOICE_R, S_RS_XML_ORIGINAL_SIZE_FOOLSCAP, S_RS_XML_ORIGINAL_SIZE_8K, S_RS_XML_ORIGINAL_SIZE_16K, S_RS_XML_ORIGINAL_SIZE_16KR, S_RS_XML_ORIGINAL_SIZE_LONG, S_RS_XML_ORIGINAL_SIZE_8_1_2X13_1_2, S_RS_XML_ORIGINAL_SIZE_JAPANESE_POSTCARD_A6, nil];
    m_pManuscriptVC = [[TRSS_ManuscriptViewController alloc]initWithManuscriptTypeArray:originalSizeArray saveSizeArray:sendSizeArray delegate:self];
    
    NSString* paperName = [rsManager.rsSettableElementsData.originalSizeData.getCapableOptions objectForKey:strOriginalSize];
    if(paperName)
    {
        [m_pManuscriptVC setStrOriginalSize:paperName];
    }else if([strOriginalSize isEqualToString:@"unknown"] || [strOriginalSize isEqualToString:@"JAM"]){
        m_pManuscriptVC.strOriginalSize = S_RS_UNKNOWN;
    }else{
        [m_pManuscriptVC setStrOriginalSize:strOriginalSize];
    }
    
    [self.navigationController pushViewController:m_pManuscriptVC animated:YES];
}

// カスタムサイズリスト
- (void)OnCustomSizeList
{
    // ReleaseUiSessionIdをしないフラグをたてる
    bDoReleaseUiSessionId = NO;
    
//    NSArray *array = [[NSArray alloc] initWithObjects:@"フルカラー", @"グレースケール", @"白黒２値", nil];
//    m_pCustomSizeListVC = [[RSS_CustomSizeListViewController alloc] initWithStyle:UITableViewStyleGrouped];
    m_pCustomSizeListVC = [[TRSS_CustomSizeListViewController alloc] initWithStyle:UITableViewStyleGrouped];
    [self.navigationController pushViewController:m_pCustomSizeListVC animated:YES];
}

// 両面
- (IBAction)OnMenuFifthButton:(id)sender
{
    // ReleaseUiSessionIdをしないフラグをたてる
    bDoReleaseUiSessionId = NO;
    
    NSArray *array = [[NSArray alloc] initWithObjects:@"原稿台", @"原稿送り装置（片面）", @"原稿送り装置（両面 - 左右開き）", @"原稿送り装置（両面 - 上下開き）", nil];
//    m_pBothOrOneSideVC = [[TRSS_BothOrOneSideViewController alloc] initWithDuplexDataArray: rssViewData.duplexData.getSelectableArray delegate:self];
    m_pBothOrOneSideVC = [[TRSS_BothOrOneSideViewController alloc] initWithDuplexDataArray: array delegate:self];
    [self.navigationController pushViewController:m_pBothOrOneSideVC animated:YES];
}

//// フォーマット
//- (IBAction)OnMenuSixthButton:(id)sender
//{
//    // ReleaseUiSessionIdをしないフラグをたてる
//    bDoReleaseUiSessionId = NO;
//    
////    //    m_pFormatVC = [[RSS_FormatViewController alloc] init];
////    m_pFormatVC = [[RSS_FormatViewController alloc]initWithDelegate:self];
////    m_pFormatVC.view.frame = settingView.bounds;
////    [self.navigationController pushViewController:m_pFormatVC animated:YES];
////    selectedVC = m_pFormatVC; //Keyboardのアニメーション検出用
//}

// 解像度
//- (IBAction)OnMenuSeventhButton:(id)sender
- (IBAction)OnMenuSixthButton:(id)sender
{
    // ReleaseUiSessionIdをしないフラグをたてる
    bDoReleaseUiSessionId = NO;
    
    NSArray *array = [[NSArray alloc] initWithObjects:@"75x75dpi", @"100x100dpi", @"150x150dpi", @"200x200dpi", @"300x300dpi", @"400x400dpi", @"600x600dpi", nil];
//    m_pResolutionVC = [[TRSS_ResolutionViewController alloc] initWithResolutionArray:[rssViewData.resolution getSelectableArray] delegate: self];
    m_pResolutionVC = [[TRSS_ResolutionViewController alloc] initWithResolutionArray:array delegate: self];
    [self.navigationController pushViewController:m_pResolutionVC animated:YES];
}

// その他の設定
//- (IBAction)OnMenuEighthButton:(id)sender
- (IBAction)OnMenuSeventhButton:(id)sender
{
    // ReleaseUiSessionIdをしないフラグをたてる
    bDoReleaseUiSessionId = NO;
    
    m_pOtherVC = [[TRSS_OtherViewController alloc]initWithColorDepthArray:[rssViewData.exposureMode getSelectableArray] blankPageArray:[rssViewData.specialMode getSelectableArray] delegate:self];
    [self.navigationController pushViewController:m_pOtherVC animated:YES];
}

// アクションシート決定ボタン押下
- (IBAction)OnMenuDecideButton:(id)sender
{
    // Picker選択値設定
    [self setPickerValue];
    
}

// ナビゲーションバー 設定ボタン押下
- (IBAction)OnNavBarRightButton:(id)sender
{
//    nStatus = RSSTATUS_INIT;
    
    [self stopGetDeviceStatusPolling];
    
    [super OnNavBarRightButton:(id)sender];
}

//[***
// settingViewのクリア //今は呼ばれない
- (void)clearSettingView
{
    for(UIView* v in [settingView.subviews reverseObjectEnumerator]){
        [v removeFromSuperview];
    }
    
    self.view.backgroundColor = BACKGROUND_COLOR;// TableViewに合わせた背景を設定
    if([[[UIDevice currentDevice] systemVersion] floatValue] >= 6.0 &&
       [[[UIDevice currentDevice] systemVersion] floatValue] < 7.0 &&
       UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
    {// iOS6のiPhoneだけ
        UITableView *tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
        [self.view addSubview:tableView];
        [self.view sendSubviewToBack:tableView];
    }
    
}

// 設定情報の更新
-(void)updateSetting
{
    // ボタン名称の設定
    // カラーモード
    if(![[rssViewData.originalSize getSelectValue] isEqualToString:@"long"])
    {
//        [self.m_pbtnThird setTitle:[NSString stringWithFormat:S_BUTTON_REMOTE_COLORMODE, [rssViewData.colorMode getSelectValueName]] forState:UIControlStateNormal];
    }
    else
    {
        // 長尺が設定されている場合はボタン表示名を変更する
//        [self.m_pbtnThird setTitle:[NSString stringWithFormat:S_BUTTON_REMOTE_COLORMODE, [rssViewData.colorMode getSpecifiedValueName:@"monochrome"]] forState:UIControlStateNormal];
    }
    
//    // 原稿
//    [self.m_pbtnFourth setTitle:[NSString stringWithFormat:S_BUTTON_MANUSCRIPT, [rssViewData.originalSize getSelectValueName]] forState:UIControlStateNormal];
//    
//    // 両面
//    [self.m_pbtnFifth setTitle:[NSString stringWithFormat:S_BUTTON_BOTH, [rssViewData.duplexData getSelectValueName]] forState:UIControlStateNormal];
//    
//    // フォーマット
//    [self.m_pbtnSixth setTitle:[NSString stringWithFormat:S_BUTTON_FORMAT, [rssViewData.formatData getSelectFileFormatValueName]] forState:UIControlStateNormal];
//    
//    // 解像度
//    if(!([rssViewData.formatData getSelectCompactPdfTypeIndex] != 0
//         &&([[rssViewData.formatData getSelectFileFormatValue] rangeOfString:@"pdf"].location != NSNotFound)))
//    {
//        [self.m_pbtnSeventh setTitle:[NSString stringWithFormat:S_BUTTON_RESOLUTION, [rssViewData.resolution getSelectValueName]] forState:UIControlStateNormal];
//    }
//    else
//    {
//        [self.m_pbtnSeventh setTitle:[NSString stringWithFormat:S_BUTTON_RESOLUTION, [rssViewData.resolution getSpecifiedValueName:@"300"]] forState:UIControlStateNormal];
//        
//    }
}

// Picker選択値設定
-(void)setPickerValue
{
    switch (m_nSelPicker)
    {
        case PrvMenuIDSecond:
        {
            // プリンタ情報取得
            PrinterData* printerData = nil;
            printerData = [m_pPrinterMgr LoadPrinterDataAtIndexInclude2:self.m_nSelPickerRow2];
            
            if(![selectMfpIpAddress isEqualToString:[printerData IpAddress]])
            {
//                nStatus = RSSTATUS_INIT;
                
                selectMfpIpAddress = [[printerData IpAddress] copy];
                selectMfpRSPortNo = [[printerData RSPortNo] copy];
                
                [self createConnectUrl];
                
                // リモートスキャン中フラグを初期化
                bRemoteScanRunning = NO;
                bRemoteScanCanceled = YES;
                strOriginalSize = @"";
                
                // GetJobSettableElementsを止める
//                if(rsManager)
//                {
//                    rsManager.parserDelegate = nil;
//                    rsManager = nil;
//                }
                
                // GetDeviceStatusを止める
                [self stopGetDeviceStatusPolling];
                
                // リモートスキャン対応MFPかチェックする
                if(printerData.IsCapableRemoteScan)
                {
                    // アクションシート非表示
                    [m_pactsheetMenu dismissWithClickedButtonIndex:-1 animated:NO];
                    
                    // リモートスキャン対応MFPなら画面はボタン名を更新のみ
                    // ボタン名称に反映
                    NSString* pstrFirstBtnTitle = [[NSString alloc]initWithFormat: S_BUTTON_REMOTESCAN, selectMfpIpAddress];
                    [self.m_pbtnFirst setTitle:pstrFirstBtnTitle forState:UIControlStateNormal];
                    
                    NSString* pstrSecondBtnTitle = [[NSString alloc]initWithFormat: S_BUTTON_SCANNER, selectMfpIpAddress];
                    [self.m_pbtnSecond setTitle:pstrSecondBtnTitle forState:UIControlStateNormal];
                    
                    scanerPickerRow = self.m_nSelPickerRow2;
                    m_nSelPicker = PrvMenuIDNone;
                    
                    
                    [self performSelector:@selector(reloadRemoteScanView) withObject:nil afterDelay:0.3f];
                    
                } else {
                    // 通常の取り込み画面に切り替える
                    [self remoteScanToNomalScan];
                }
            }
        }
            break;
    }
    
    [super setPickerValue];
    
}

-(void)reloadRemoteScanView
{
    [self viewDidAppear:NO];
}
#pragma mark - Move NamalScan
// 通常の取り込み画面へ遷移
-(void)remoteScanToNomalScan
{
    
    // 遷移前に開いているビューをアニメーションで閉じる
    m_bShowMenu = YES;
    bRemoteScanSwitch = YES;
    [super AnimationShowMenu];
    [UIView animateWithDuration:0.3
                     animations:^{
                         menuScrollView.contentOffset = CGPointZero;
                     }];
    // アニメーションが完了後に、通常の取り込み画面に遷移する
    [self performSelector:@selector(moveNomalScan) withObject:nil afterDelay:0.3f];
    
}

// 通常の取り込み画面へ遷移(remoteScanToNomalScanでビューを閉じておくこと)
-(void)moveNomalScan
{
    ScanBeforePictViewController *pScanBeforePictViewController;
    
    // 通常の取り込み画面へ遷移
    pScanBeforePictViewController = [[ScanBeforePictViewController alloc] init];
    // 初期で選択するスキャナーを設定する
    pScanBeforePictViewController.scanerPickerRow = self.m_nSelPickerRow2;
    
    id vcNew = pScanBeforePictViewController;
    
    // プリンタ情報取得
    PrinterData* printerData = nil;
    
    //プリンタ情報更新
    m_pPrinterMgr.PrinterDataList = [m_pPrinterMgr ReadPrinterData];
    
    printerData = [m_pPrinterMgr LoadPrinterDataAtIndexInclude2:scanerPickerRow];
    printerData.IsCapableRemoteScan = NO;
    // 表示している画面遷移の履歴を入れ替える
    NSArray *parrViewControllers = self.navigationController.viewControllers;
    NSArray *parrNewViewControllers = [NSArray arrayWithObjects:[parrViewControllers objectAtIndex:0],vcNew, nil];
    
    [self.navigationController setViewControllers:parrNewViewControllers];
}

// ***]

#pragma mark - Navigation Bar Controll
// バーボタンのデフォルトアクション
- (void) barBtnDefaultAction:(UIBarButtonItem*)btn
{
    
}

// バーボタンをセット
- (void) setBarBtnWithTitle:(NSString*)title target:(id)target action:(SEL)action isLeft:(BOOL)isLeft
{
    if(!target){
        target = self;
    }
    if(!action){
        action = @selector(barBtnDefaultAction:);
    }
    
    UIBarButtonItem* barBtn = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonItemStylePlain target:target action:action];
    barBtn.title = title;
    
    // 左右判定
    if(isLeft){
        [self.navigationItem setLeftBarButtonItem:barBtn];
    }else{
        [self.navigationItem setRightBarButtonItem:barBtn];
    }
}

// ナビゲーションバーを設定する
- (void) setNavigationBarTitle:(NSString*)title leftButton:(UIBarButtonItem*)leftBtn rightButton:(UIBarButtonItem*)rightBtn
{
    if(title){
        self.navigationItem.title = title;
    }
    
    if(leftBtn){
        self.navigationItem.leftBarButtonItem = leftBtn;
    }
    
    if(rightBtn){
        self.navigationItem.rightBarButtonItem = rightBtn;
    }
}

// 縦表示時のメニューボタン設定
- (void)setPortraitMenu:(UIBarButtonItem *)barButtonItem
{
    [self.navigationItem setLeftBarButtonItem:barButtonItem animated:NO];
}

#pragma mark - RSManager
// 取得したリモートスキャン情報の解析完了通知
-(void)rsManagerDidFinishParsing:(RSHttpCommunicationManager*)manager
{
    DLog(@"rsManagerDidFinishParsing %@", [manager class]);
    // セッションIDの取得完了
    if([manager isKindOfClass:[RSRequestUISessionIdManager class]])
    {
        manager.parserDelegate = nil;
        RSRequestUISessionIdManager* m = (RSRequestUISessionIdManager*)manager;
        if(m.sessionId){
            sessionId = m.sessionId;
            strVKey = @"";  // vkeyを再作成する用
        }
        DLog(@"RequestUISessionId Complete : %@", sessionId);
        
//        switch (nStatus) {
//            case TRSSTATUS_REQUESTUISESSIONID:
//            default:
//                nStatus = TRSSTATUS_SETDEVICECONTEXT_START;
//                break;
//        }
        
        // SetDeviceContextを実行
        [self rsSetDeviceContextStart];
    }
    
    // 設定可能な項目の取得完了
    else if([manager isKindOfClass:[RSGetJobSettableElementsManager class]])
    {
        manager.parserDelegate = nil;
        [self didFinishRSGetJobSettableElementsManagerParsing];
        DLog(@"GetJobSettableElements Complete");
        
        // しばらくおまちくださいダイアログを閉じる
        if(alert != nil)
        {
            [alert dismissWithClickedButtonIndex:2 animated:NO];
            alert = nil;
        }
        
//        // ポーリングタイマー停止
//        [self stopGetDeviceStatusPolling];
        
//        // デバイスにセットされている用紙サイズ取得ポーリングを開始
//        originalSizePollingTimer = [NSTimer scheduledTimerWithTimeInterval:2 target:self selector:@selector(rsGetDeviceStatusPolling) userInfo:nil repeats:YES];
    }
    
//    // 複合機の状態を取得完了
//    else if([manager isKindOfClass:[RSGetDeviceStatusManager class]])
//    {
//        RSGetDeviceStatusManager* m = (RSGetDeviceStatusManager*)manager;
//        
//        // 現在セットされている用紙の読み込み可能サイズを保持する
//        pstrDetectableMinWidth = m.detectableMinWidth;
//        pstrDetectableMinHeight = m.detectableMinHeight;
//        
//        // 現在セットされている原稿サイズがunknownか判別フラグを保持する
//        bFeederSize = ![m.feederSize isEqualToString:@"unknown"];
//        bPlatenSize = ![m.platenSize isEqualToString:@"unknown"];
//        // 現在セットされている用紙サイズを保存する
//        if([strOriginalSize isEqualToString:@""])
//        {
//            //                bSetPaper = ![m.size isEqualToString:@"unknown"];
//            bSetPaper = ![m.feederSize isEqualToString:@"unknown"];
//        }
//        //            strOriginalSize = m.size;
//        if([m.feederSize isEqualToString:@""] || !bFeederSize)
//        {
//            // feederSizeが空かunknownならplatenSizeを設定する
//            strOriginalSize = m.platenSize;
//            
//        }else
//        {
//            // feederSizeを設定する
//            strOriginalSize = m.feederSize;
//        }
//        
//        // 原稿サイズ取得ポーリング
//        DLog(@"strOriginalSize:%@, %d", strOriginalSize, [strOriginalSize isEqualToString:@"unknown"]);
//        BOOL valueChange = (bSetPaper != ![strOriginalSize isEqualToString:@"unknown"]);
//        bSetPaper = ![strOriginalSize isEqualToString:@"unknown"];
//        if(valueChange && [[rssViewData.originalSize getSelectValue] isEqualToString:@"auto"])
//        {
//            [self setManuscriptStartEnabled:bSetPaper];
//        }
//        
//        // 原稿設定画面に反映
//        if(m_pManuscriptVC){
//            // 原稿サイズリストから表示用文字列を取得
//            NSString* paperName = [rsManager.rsSettableElementsData.originalSizeData.getCapableOptions objectForKey:strOriginalSize];
//            if(paperName){
//                m_pManuscriptVC.strOriginalSize = paperName;
//            }else if([strOriginalSize isEqualToString:@"unknown"] || [strOriginalSize isEqualToString:@"JAM"]){
//                m_pManuscriptVC.strOriginalSize = S_RS_UNKNOWN;
//            }else{
//                m_pManuscriptVC.strOriginalSize = strOriginalSize;
//            }
//        }
//        
//        if([[rssViewData.originalSize getSelectValue] isEqualToString:@"auto"])
//        {
//            // 原稿サイズが自動の場合、原稿のボタンタイトルに検知サイズを表示する
//            NSString* pstrBtnTitle;
//            if(![strOriginalSize isEqualToString:@"unknown"] && ![strOriginalSize isEqualToString:@"JAM"])
//            {
//                // 用紙検知あり
//                pstrBtnTitle = [[NSString alloc]initWithFormat: @"%@(%@)",[rssViewData.originalSize getSelectValueName], [rsManager.rsSettableElementsData.originalSizeData.getCapableOptions objectForKey:strOriginalSize]];
//            } else {
//                // 用紙検知なし
//                pstrBtnTitle = [[NSString alloc]initWithFormat: @"%@(%@)",[rssViewData.originalSize getSelectValueName], S_RS_UNKNOWN];
//            }
//            
//            [self.m_pbtnFourth setTitle:[NSString stringWithFormat:S_BUTTON_MANUSCRIPT, pstrBtnTitle] forState:UIControlStateNormal];
//        }
//
//        // ステータスごとの処理
//        switch (nStatus) {
//            case TRSSTATUS_SETDEVICECONTEXT_WAIT:
//                // SetDeviceContext中はCurrentModeをチェックする
//                if(![m.currentMode isEqualToString:@"remoteScanJob"])
//                {
//                    if (m_palert != nil) {
//                        [m_palert dismissWithClickedButtonIndex:2 animated:NO];
//                        m_palert = nil;
//                    }
//                    nStatus = TRSSTATUS_SETDEVICECONTEXT_END;
//                    [self showResourceNotFoundAlert];
//                }
//                break;
//            case TRSSTATUS_EXECUTEJOB:
//                if(![m.currentMode isEqualToString:@"remoteScanJob"])
//                {
//                    nStatus = TRSSTATUS_SETDEVICECONTEXT_END;
//                    [self showResourceNotFoundAlert];
//                    
//                    // ポーリングタイマー停止
//                    [self stopGetDeviceStatusPolling];
//                    
//                    // デバイスにセットされている用紙サイズ取得ポーリングを開始
//                    originalSizePollingTimer = [NSTimer scheduledTimerWithTimeInterval:2 target:self selector:@selector(rsGetDeviceStatusPolling) userInfo:nil repeats:YES];
//
//                } else {
//                    // リモートスキャンシーケンス開始
//                    m_palert = nil;
//                    bRemoteScanRunning = YES;
//                    bRemoteScanCanceled = NO;
//                    bIsJamHassei = NO;
//                    bIsJamKaisho = NO;
//                    
//                    // FTPサーバ起動
//                    [self startFtpServer];
//                    [self rsExecuteJob];
//                }
//                break;
//            default:
//                break;
//        }
//    }
//    
//    // 端末情報の通知(スクリーンロック開始)完了
//    // スクリーンロック解除完了
//    else if([manager isKindOfClass:[RSSetDeviceContextManager class]])
//    {
//        
//        manager.parserDelegate = nil;
//        
//        if(nStatus == RSSTATUS_SETDEVICECONTEXT_RETRY)
//        {
//            nStatus = RSSTATUS_SETDEVICECONTEXT_START;
//        }
//        
//        switch (nStatus) {
//            case RSSTATUS_SETDEVICECONTEXT_START:
//                // 表示中のアラートを消す
//                [self performSelectorOnMainThread:@selector(closeAlert) withObject:nil waitUntilDone:NO];
//                
//                bShowingManuscriptDialog = YES;
//                
//                if((![strOriginalSize isEqualToString:@""] && ![strOriginalSize isEqualToString:@"unknown"]) || ![[rssViewData.originalSize getSelectValue] isEqualToString:@"auto"])
//                {
//                    [self setManuscriptStartEnabled:YES];
//                }else{
//                    if([[rssViewData.originalSize getSelectValue] isEqualToString:@"auto"])
//                    {
//                        // どちらかがunknownなら取り込むボタンありダイアログを表示する
//                        if(bFeederSize || bPlatenSize)
//                        {
//                            [self setManuscriptStartEnabled:YES];
//                        }else{
//                            [self setManuscriptStartEnabled:NO];
//                        }
//                    }else{
//                        [self setManuscriptStartEnabled:NO];
//                    }
//                }
//                nStatus = RSSTATUS_SETDEVICECONTEXT_WAIT;
//                break;
//                
//            default:
//                [self rsReleaseUISessionId];
//                break;
//        }
//    
//    }
//    
//    // スキャンジョブの開始完了
//    else if([manager isKindOfClass:[RSExecuteJobManager class]])
//    {
//        manager.parserDelegate = nil;
//        RSExecuteJobManager* m = (RSExecuteJobManager*)manager;
//        jobId = m.jobId;
//        
//        // 実行中のジョブステータスを取得
//        [self rsGetJobStatus];
//    }
//    
//    // セッションID解放完了
//    else if([manager isKindOfClass:[RSReleaseUISessionIdManager class]])
//    {
//        manager.parserDelegate = nil;
//        
//        sessionId = nil;
//        
//        switch (nStatus) {
//            case RSSTATUS_EXECUTEJOB_COMPLETE:
//                // スキャン終了
//                [alert dismissWithClickedButtonIndex:2 animated:NO];
//                
//                // スキャン成功
//                // 現在のリモートスキャン設定を保存する
//                [rssViewData saveRemoteScanSettings];
//                
//                // FTPで受信したファイルがあるか？
//                if(super.ScanFileName != nil)
//                {
//                    // 完了通知
//                    [super CreateCompleteAlert];
//                    //                bDoReset = YES;
//                    nStatus = RSSTATUS_INIT;
//                }
//                else
//                {
//                }
//                break;
//                
//            default:
//                break;
//        }
//    }
//    
//    // キャンセルジョブ完了
//    else if([manager isKindOfClass:[RSCancelJobManager class]])
//    {
//        manager.parserDelegate = nil;
//        jobId = nil;
//        
//        [super CreateAllert:nil message:MSG_REMOTESCAN_CANCELING btnTitle:MSG_BUTTON_OK];
//        
//        nStatus = RSSTATUS_SETDEVICECONTEXT_END;
//        [self rsSetDeviceContextEnd];
//        
//        // ポーリングタイマー停止
//        [self stopGetDeviceStatusPolling];
//        
//        // デバイスにセットされている用紙サイズ取得ポーリングを開始
//        originalSizePollingTimer = [NSTimer scheduledTimerWithTimeInterval:2 target:self selector:@selector(rsGetDeviceStatusPolling) userInfo:nil repeats:YES];
//    }
//    
//    // レジュームジョブ完了
//    else if([manager isKindOfClass:[RSResumeJobManager class]])
//    {
//        manager.parserDelegate = nil;
//    }
//    else if([manager isKindOfClass:[RSmfpifManager class]])
//    {
//        //        manager
//        m_pPrinterInfo.IsCapableRemoteScan = [mfpManager isCapableRemoteScan];
//        [self startGetMfpIfService];
//        
//    }
//    else if([manager isKindOfClass:[RSmfpifServiceManager class]])
//    {
//        m_pPrinterInfo.RSPortNo = [mfpServiceManager.portNo copy];
//        
//        // ダイアログ表示のため、ちょっとだけ待つ
//        [NSThread sleepForTimeInterval:1.0];
//        [m_palert dismissWithClickedButtonIndex:1 animated:NO];
//        m_palert = nil;
//        
//        PrinterData* printerData = [m_pPrinterMgr LoadPrinterDataAtIndexInclude2:self.m_nSelPickerRow2];
//        
//        // デバイスがリモートスキャン対応か確認する
//        if (m_pPrinterInfo.IsCapableRemoteScan) {
//            NSLog(@"[printerData RSPortNo]:%@ m_pPrinterInfo.RSPortNo:%@", [printerData RSPortNo], mfpServiceManager.portNo);
//            if (![[printerData RSPortNo] isEqualToString:mfpServiceManager.portNo]) {
//                // ポート番号が変わっている場合は新しい番号を上書きする
//                m_pPrinterInfo = [m_pPrinterMgr LoadPrinterDataAtIndexInclude2:self.m_nSelPickerRow2];
//                m_pPrinterInfo.RSPortNo = mfpServiceManager.portNo;
//                [self savePrinterData];
//            }
//            
//            [super AnimationShowStartMenu];
//            
//        }else {
//            
//            [self showErrorAlertOnMainThreadWithMessage:MSG_REMOTESCAN_NOTSUPPORT tag:ALERT_TAG_REMOTE_Result];
//            
//            //            [super AnimationShowStartMenu];
//            
//            
//        }
//    }
}

// 通信エラー時のレスポンスを処理する
-(void)rsManagerDidFailWithError:(RSHttpCommunicationManager*)manager
{
//    DLog(@"rsManagerDidFailWithError %@", [manager class]);
//    NSString* strErrorManagerName =@"";
//    // セッションIDの取得完了
//    if([manager isKindOfClass:[RSRequestUISessionIdManager class]])
//    {
//        strErrorManagerName = @"RSRequestUISessionIdManager";
//        
//        
//        switch (nStatus) {
//            case RSSTATUS_REQUESTUISESSIONID:
//            default:
//                
//                if([manager.errCode isEqualToString:@"NETWORK_ERROR"] ||
//                   [manager.errCode isEqualToString:@"WIFI_ERROR"])
//                {
//                    [self showNetworkAlert];
//                    
//                } else if([manager.errCode isEqualToString:@"ServerBusy"]) {
//                    [self showErrorAlertOnMainThreadWithMessage:MSG_REMOTESCAN_SESSIONID_GET_ERROR tag:ALERT_TAG_WIFI_NO_CONNECTION];
//                    
//                } else if([manager.errCode isEqualToString:@"XML_PARSE_ERROR"] ||
//                          [manager.errCode isEqualToString:@"WIFI_ERROR"] ||
//                          [manager.errCode isEqualToString:@"InvalidArgs"] ||
//                          [manager.errCode isEqualToString:@"OperationFailed"]
//                          ) {
//                    
//                    [self showErrorAlertOnMainThreadWithMessage:MSG_REMOTESCAN_NETWORK_ERROR tag:ALERT_TAG_WIFI_NO_CONNECTION];
//                    
//                } else {
//                    [self showErrorAlertOnMainThreadWithMessage:MSG_REMOTESCAN_NETWORK_ERROR tag:ALERT_TAG_WIFI_NO_CONNECTION];
//                }
//                break;
//        }
//    }
//    
//    // 設定可能な項目の取得完了
//    else if([manager isKindOfClass:[RSGetJobSettableElementsManager class]])
//    {
//        strErrorManagerName = @"RSGetJobSettableElementsManager";
//        
//        if([manager.errCode isEqualToString:@"NETWORK_ERROR"] ||
//           [manager.errCode isEqualToString:@"WIFI_ERROR"] ||
//           [manager.errCode isEqualToString:@"XML_PARSE_ERROR"] ||
//           [manager.errCode isEqualToString:@"InvalidArgs"] ||
//           [manager.errCode isEqualToString:@"OperationFailed"]
//           )
//        {
//            [m_palert dismissWithClickedButtonIndex:2 animated:NO];
//            m_palert = nil;
//            
//            [self showErrorAlertOnMainThreadWithMessage:MSG_REMOTESCAN_NETWORK_ERROR_AND_EXIT tag:ALERT_TAG_NETWORKERROR_AND_EXIT];
//            
//        } else if([manager.errCode isEqualToString:@"ActionNotSupported"]){
//            [self showNotSupportedAlertAndStopPolling:NO];
//        } else {
//            [self showErrorAlertOnMainThreadWithMessage:MSG_REMOTESCAN_NETWORK_ERROR_AND_EXIT tag:ALERT_TAG_NETWORKERROR_AND_EXIT];
//        }
//        
//        if(m_pactsheetMenu && [m_pactsheetMenu isVisible])
//        {
//            // アクションシート非表示
//            [m_pactsheetMenu dismissWithClickedButtonIndex:-1 animated:NO];
//        }
//    }
//    
//    // 複合機の状態を取得完了
//    else if([manager isKindOfClass:[RSGetDeviceStatusManager class]])
//    {
//        strErrorManagerName = @"RSGetDeviceStatusManager";
//        
//        switch (nStatus) {
//            case RSSTATUS_SETDEVICECONTEXT_WAIT:
//                // 何かしらエラーの場合、
//                if(m_palert != nil)
//                {
//                    [m_palert dismissWithClickedButtonIndex:2 animated:NO];
//                    m_palert = nil;
//                }
//                [self showErrorAlertOnMainThreadWithMessage:MSG_REMOTESCAN_NETWORK_ERROR tag:ALERT_TAG_GETDEVICESTATUS_FAILED];
//                
//                nStatus = RSSTATUS_GETDEVICESTATUS;
//                
//                break;
//                
//            case RSSTATUS_EXECUTEJOB:
//                // 何かしらエラーの場合、
//                [self showErrorAlertOnMainThreadWithMessage:MSG_REMOTESCAN_NETWORK_ERROR tag:ALERT_TAG_WIFI_NO_CONNECTION];
//                
//                nStatus = RSSTATUS_GETDEVICESTATUS;
//                
//                // デバイスにセットされている用紙サイズ取得ポーリングを開始
//                // ポーリングタイマー停止
//                [self stopGetDeviceStatusPolling];
//                
//                // デバイスにセットされている用紙サイズ取得ポーリングを開始
//                bRemoteScanRunning = NO;
//                originalSizePollingTimer = [NSTimer scheduledTimerWithTimeInterval:2 target:self selector:@selector(rsGetDeviceStatusPolling) userInfo:nil repeats:YES];
//                
//            default:
//                break;
//        }
//    }
//    
//    // 端末情報の通知(スクリーンロック開始)完了
//    // スクリーンロック解除完了
//    else if([manager isKindOfClass:[RSSetDeviceContextManager class]])
//    {
//        strErrorManagerName = @"RSSetDeviceContextManager";
//        
//        if(nStatus == RSSTATUS_SETDEVICECONTEXT_RETRY)
//        {
//            nStatus = RSSTATUS_SETDEVICECONTEXT_START;
//        }
//        
//        switch (nStatus) {
//            case RSSTATUS_SETDEVICECONTEXT_START:
//                
//                if([manager.errCode isEqualToString:@"NETWORK_ERROR"] ||
//                   [manager.errCode isEqualToString:@"WIFI_ERROR"])
//                {
//                    [self showNetworkAlert];
//                    nStatus = RSSTATUS_RELEASEUISESSIONID;
//                    [self rsReleaseUISessionId];
//                    
//                } else if([manager.errCode isEqualToString:@"XML_PARSE_ERROR"] ||
//                          [manager.errCode isEqualToString:@"WIFI_ERROR"] ||
//                          [manager.errCode isEqualToString:@"InvalidArgs"] ||
//                          [manager.errCode isEqualToString:@"OperationFailed"] ||
//                          [manager.errCode isEqualToString:@"VKeyIsNotValid"]
//                          ){
//                    [self showErrorAlertOnMainThreadWithMessage:MSG_REMOTESCAN_NETWORK_ERROR tag:ALERT_TAG_WIFI_NO_CONNECTION];
//                    nStatus = RSSTATUS_RELEASEUISESSIONID;
//                    [self rsReleaseUISessionId];
//                    
//                } else if([manager.errCode isEqualToString:@"Forbidden"]) {
//                    // リモートスキャン禁止
//                    //                    [self showNotSupportedAlertAndStopPolling:NO];
//                    [self showErrorAlertOnMainThreadWithMessage:MSG_REMOTESCAN_FORBIDDEN tag:ALERT_TAG_NOT_SUPPORTED];
//                    nStatus = RSSTATUS_RELEASEUISESSIONID;
//                    [self rsReleaseUISessionId];
//                    
//                } else if([manager.errCode isEqualToString:@"ScreenIsNotHome"])
//                {
//                    [self showErrorAlertOnMainThreadWithMessage:MSG_REMOTESCAN_SCREENISNOTHOME tag: ALERT_TAG_RSSETDEVICECONTEXTMANAGER_ERROR];
//                    nStatus = RSSTATUS_RELEASEUISESSIONID;
//                    [self rsReleaseUISessionId];
//                    
//                }
//                else if([manager.errCode isEqualToString:@"NotAuthenticated"])
//                {
//                    [self showErrorAlertOnMainThreadWithMessage:MSG_REMOTESCAN_NOTAUTHENTICATED tag:ALERT_TAG_RSSETDEVICECONTEXTMANAGER_ERROR];
//                    nStatus = RSSTATUS_RELEASEUISESSIONID;
//                    [self rsReleaseUISessionId];
//                    
//                }
//                else if([manager.errCode isEqualToString:@"ScreenIsNotLogin"])
//                {
//                    [self showErrorAlertOnMainThreadWithMessage:MSG_REMOTESCAN_SCREENISNOTLOGIN tag:ALERT_TAG_RSSETDEVICECONTEXTMANAGER_ERROR];
//                    nStatus = RSSTATUS_RELEASEUISESSIONID;
//                    [self rsReleaseUISessionId];
//                    
//                }
//                else if([manager.errCode isEqualToString:@"RemoteScanNotReady"])
//                {
//                    // 1wモード対応
//                    if(nSetDeviceRetryCount < 3)
//                    {
//                        nSetDeviceRetryCount++;
//                        nStatus = RSSTATUS_SETDEVICECONTEXT_RETRY;
//                        [self performSelector:@selector(rsSetDeviceContextStartRetry) withObject:nil afterDelay:10.0f];
//                        // ReleaseUISessionIdはしない
//                    } else {
//                        // リトライ失敗
//                        [self showErrorAlertOnMainThreadWithMessage:MSG_REMOTESCAN_NETWORK_ERROR tag:ALERT_TAG_WIFI_NO_CONNECTION];
//                        nStatus = RSSTATUS_RELEASEUISESSIONID;
//                        [self rsReleaseUISessionId];
//                    }
//                }
//                else
//                {
//                    [self showScanFailedAlert];
//                    nStatus = RSSTATUS_RELEASEUISESSIONID;
//                    [self rsReleaseUISessionId];
//                }
//                
//                break;
//                
//            case RSSTATUS_SETDEVICECONTEXT_END:
//            default:
//                [self rsReleaseUISessionId];
//                break;
//        }
//    }
//    
//    // スキャンジョブの開始完了
//    else if([manager isKindOfClass:[RSExecuteJobManager class]])
//    {
//        strErrorManagerName = @"RSExecuteJobManager";
//        
//        if([manager.errCode isEqualToString:@"NETWORK_ERROR"] || [manager.errCode isEqualToString:@"WIFI_ERROR"])
//        {
//            // ネットワークエラー
//            [self showNetworkAlert];
//        }
//        else if([manager.errCode isEqualToString:@"XML_PARSE_ERROR"])
//        {
//            // 取り込み失敗
//            [self showScanFailedAlert];
//        }
//        else if([manager.errCode isEqualToString:@"ActionNotSupported"])
//        {
//            // リモートスキャン未対応
//            [self showNotSupportedAlertAndStopPolling:NO];
//        }
//        else if([manager.errCode isEqualToString:@"AccessDenied"])
//        {
//            [self showErrorAlertOnMainThreadWithMessage:MSG_REMOTESCAN_ACCESSDENIED_MAIN tag:ALERT_TAG_EXECUTEJOB_ACCESSDENIED];
//        }
//        else if([manager.errCode isEqualToString:@"LimitReached"])
//        {
//            // 出力可能枚数の上限に到達
//            [self showErrorAlertOnMainThreadWithMessage:MSG_REMOTESCAN_LIMITREACHED tag:ALERT_TAG_SCAN_FAILED];
//        }
//        else if([manager.errCode isEqualToString:@"OriginalNotDetected"])
//        {
//            // 用紙未検知
//            [self showErrorAlertOnMainThreadWithMessage:MSG_REMOTESCAN_ORIGINALNOTDETECTED tag:ALERT_TAG_ORIGINAL_NOT_DETECTED_EXECUTE];
//        }
//        
//        else if([manager.errCode isEqualToString:@"InvalidArgs"] ||
//                [manager.errCode isEqualToString:@"OperationFailed"])
//        {
//            // 取り込み失敗
//            [self showScanFailedAlert];
//        }
//        else if([manager.errCode isEqualToString:@"VKeyIsNotValid"] )
//        {
//            // 取り込み失敗
//            [self showResourceNotFoundAlert];
//        }
//        else
//        {
//            // 取り込み失敗
//            [self showScanFailedAlert];
//        }
//        // FTPサーバを停止
//        [self stopFtpServer];
//        
//        [self rsSetDeviceContextEnd];
//        
//        nStatus = RSSTATUS_GETDEVICESTATUS;
//        // デバイスにセットされている用紙サイズ取得ポーリングを開始
//        // ポーリングタイマー停止
//        [self stopGetDeviceStatusPolling];
//        
//        // デバイスにセットされている用紙サイズ取得ポーリングを開始
//        bRemoteScanRunning = NO;
//        originalSizePollingTimer = [NSTimer scheduledTimerWithTimeInterval:2 target:self selector:@selector(rsGetDeviceStatusPolling) userInfo:nil repeats:YES];
//        
//    }
//    
//    // スキャンジョブの開始完了
//    else if([manager isKindOfClass:[RSGetJobStatusManager class]])
//    {
//        strErrorManagerName = @"RSGetJobStatusManager";
//        
//        if([manager.errCode isEqualToString:@"ResourceNotFound"])
//        {
//            // jobid不備
//            [self showResourceNotFoundAlert];
//        }
//        else if([manager.errCode isEqualToString:@"NETWORK_ERROR"] ||
//                [manager.errCode isEqualToString:@"WIFI_ERROR"] ||
//                [manager.errCode isEqualToString:@"InvalidArgs"] ||
//                [manager.errCode isEqualToString:@"OperationFailed"])
//        {
//            [self showScanFailedAlert];
//        }
//        
//        nStatus = RSSTATUS_SETDEVICECONTEXT_END;
//        [self rsSetDeviceContextEnd];
//        
//        // JobStatusポーリング終了
//        ((RSGetJobStatusManager*)manager).endThread = YES;
//        manager.parserDelegate = nil;
//        
//        // デバイスにセットされている用紙サイズ取得ポーリングを開始
//        // ポーリングタイマー停止
//        [self stopGetDeviceStatusPolling];
//        
//        // デバイスにセットされている用紙サイズ取得ポーリングを開始
//        bRemoteScanRunning = NO;
//        originalSizePollingTimer = [NSTimer scheduledTimerWithTimeInterval:2 target:self selector:@selector(rsGetDeviceStatusPolling) userInfo:nil repeats:YES];
//    }
//    
//    // セッションID解放完了
//    else if([manager isKindOfClass:[RSReleaseUISessionIdManager class]])
//    {
//        strErrorManagerName = @"RSReleaseUISessionIdManager";
//        
//        manager.parserDelegate = nil;
//        
//        sessionId = nil;
//        
//        switch (nStatus) {
//            case RSSTATUS_EXECUTEJOB_COMPLETE:
//                // スキャン終了
//                [alert dismissWithClickedButtonIndex:2 animated:NO];
//                
//                // スキャン成功
//                // 現在のリモートスキャン設定を保存する
//                [rssViewData saveRemoteScanSettings];
//                
//                // FTPで受信したファイルがあるか？
//                if(super.ScanFileName != nil)
//                {
//                    // 完了通知
//                    [super CreateCompleteAlert];
//                    //                bDoReset = YES;
//                    nStatus = RSSTATUS_INIT;
//                }
//                else
//                {
//                }
//                break;
//                
//            default:
//                break;
//        }
//    }
//    
//    // キャンセルジョブ完了
//    else if([manager isKindOfClass:[RSCancelJobManager class]])
//    {
//        strErrorManagerName = @"RSCancelJobManager";
//        jobId = nil;
//        
//        if([manager.errCode isEqualToString:@"NETWORK_ERROR"]
//           || [manager.errCode isEqualToString:@"WIFI_ERROR"])
//        {
//            // ネットワークエラー
//            [self showScanFailedAlert];
//        }else if([manager.errCode isEqualToString:@"ResourceNotFound"]){
//            // jobid不備 正常として処理
//            [super CreateAllert:nil message:MSG_REMOTESCAN_CANCELING btnTitle:MSG_BUTTON_OK];
//        }else{
//            // 取り込み失敗
//            [self showScanFailedAlert];
//        }
//        
//        // デバイスにセットされている用紙サイズ取得ポーリングを開始
//        // ポーリングタイマー停止
//        [self stopGetDeviceStatusPolling];
//        
//        nStatus = RSSTATUS_SETDEVICECONTEXT_END;
//        [self rsSetDeviceContextEnd];
//        
//        // デバイスにセットされている用紙サイズ取得ポーリングを開始
//        bRemoteScanRunning = NO;
//        originalSizePollingTimer = [NSTimer scheduledTimerWithTimeInterval:2 target:self selector:@selector(rsGetDeviceStatusPolling) userInfo:nil repeats:YES];
//    }
//    
//    // レジュームジョブ完了
//    else if([manager isKindOfClass:[RSResumeJobManager class]])
//    {
//        strErrorManagerName = @"RSResumeJobManager";
//        
//        if([manager.errCode isEqualToString:@"NETWORK_ERROR"] || [manager.errCode isEqualToString:@"WIFI_ERROR"])
//        {
//            // ネットワークエラー
//            [self showNetworkAlert];
//            nStatus = RSSTATUS_SETDEVICECONTEXT_END;
//            [self rsSetDeviceContextEnd];
//        }
//        else if([manager.errCode isEqualToString:@"XML_PARSE_ERROR"])
//        {
//            // 取り込み失敗
//            [self showScanFailedAlert];
//            nStatus = RSSTATUS_SETDEVICECONTEXT_END;
//            [self rsSetDeviceContextEnd];
//        }
//        else if([manager.errCode isEqualToString:@"ResourceNotFound"] || [manager.errCode isEqualToString:@"InvalidArgs"] || [manager.errCode isEqualToString:@"OperationFailed"])
//        {
//            // 何もしない
//            // エラーハンドリングはGetJobStatusで行う
//        }
//        else if([manager.errCode isEqualToString:@"OriginalNotDetected"])
//        {
//            // 用紙未挿入
//            [self showErrorAlertOnMainThreadWithMessage:MSG_REMOTESCAN_ORIGINALNOTDETECTED_CONFIRM tag:ALERT_TAG_ORIGINAL_NOT_DETECTED];
//        }
//        
//    }
//    
//    DLog(@"%@: %@, %d, %@, %@", @"error",strErrorManagerName, manager.isErr, manager.errCode, manager.errMessage);
//    
}

// ジョブステータス取得通知
-(void)rsManager:(RSGetJobStatusManager*)manager gotJobStatus:(int)status
{
//    DLog(@"JOB STATUS: %d", status);
//    if(bRemoteScanCanceled)
//    {
//        // アプリ側キャンセル時
//        manager.endThread = YES;
//        manager.parserDelegate = nil;
//        return;
//    }
//    switch (status) {
//        case E_RS_JOB_STATUS_STARTED:   // 開始されました。
//            // 処理開始　または　JAM解消後スタート済み（MFPからのボタン押下でステータスが変わる可能性あり）
//            bIsJamHassei = NO;
//            bIsJamKaisho = NO;
//            
//            if(m_palert != nil)
//            {
//                [m_palert dismissWithClickedButtonIndex:2 animated:NO];
//                m_palert = nil;
//            }
//            
//            if(alert != nil)
//            {
//                alert.message = MSG_REMOTESCAN_DOING;
//            }
//            else
//            {
//                m_palert = nil;
//                [self createProgressionAlertWithMessage:nil message: MSG_REMOTESCAN_DOING withCancel:YES];
//            }
//            
//            break;
//            
//        case E_RS_JOB_STATUS_SCANNED:   // 原稿の読み取りが完了しました。（スキャンメッセージカスタマイズ使用時のみ）
//            // JAM解消後
//            if(!bIsJamKaisho)
//            {
//                bIsJamKaisho = YES;
//                if(m_palert != nil)
//                {
//                    [m_palert dismissWithClickedButtonIndex:2 animated:NO];
//                    m_palert = nil;
//                }
//                
//                if(alert != nil)
//                {
//                    [alert dismissWithClickedButtonIndex:2 animated:NO];
//                }
//                
//                [self setJammingDialogEnabled:YES count:nil];
//            }
//            
//            break;
//            
//        case E_RS_JOB_STATUS_QUEUED:    // 全原稿の読み取りが完了しました。（送信予約状態）
//            break;
//            
//        case E_RS_JOB_STATUS_STOPPED:   // スキャンJAM発生
//        {
//            if(!bIsJamHassei)
//            {
//                bIsJamHassei = YES;
//                if(m_palert != nil)
//                {
//                    [m_palert dismissWithClickedButtonIndex:2 animated:NO];
//                    m_palert = nil;
//                }
//                
//                if(alert != nil)
//                {
//                    [alert dismissWithClickedButtonIndex:2 animated:NO];
//                }
//                
//                [self setJammingDialogEnabled:NO count:manager.strPageCount];
//            }
//            
//        }
//            break;
//            
//        case E_RS_JOB_STATUS_CANCELED:  // キャンセルされました。
//        {
//            // 取り込みファイルが存在するかチェック
//            BOOL isExistsScannedFile = NO;
//            
//            NSFileManager* fileManager = [NSFileManager defaultManager];
//            NSError* error;
//            NSArray* fileList = [fileManager contentsOfDirectoryAtPath:baseDir error:&error];
//            
//            // PNGFILE以外にファイルがある場合は取り込んだファイルが存在する
//            for (NSString* fileName in fileList) {
//                if (![fileName isEqualToString:@"PNGFILE"]) {
//                    isExistsScannedFile = YES;
//                    break;
//                }
//            }
//            
//            if(isExistsScannedFile)
//            {
//                // ファイルありのため、正常取り込みと同じ処理を行う
//                
//                // スクリーンロック解除
//                manager.parserDelegate = nil;
//                bRemoteScanRunning = NO;
//                
//                nStatus = RSSTATUS_EXECUTEJOB_COMPLETE;
//                [self rsSetDeviceContextEnd];
//                
//                [self stopFtpServer];
//            } else {
//                // ファイルがないので、キャンセルされた場合の処理を行う
//                manager.parserDelegate = nil;
//                bRemoteScanCanceled = YES;
//                [self stopFtpServer];
//                
//                nStatus = RSSTATUS_SETDEVICECONTEXT_END;
//                [self rsSetDeviceContextEnd];
//                
//                // ポーリングタイマー停止
//                [self stopGetDeviceStatusPolling];
//                
//                // デバイスにセットされている用紙サイズ取得ポーリングを開始
//                bRemoteScanRunning = NO;
//                originalSizePollingTimer = [NSTimer scheduledTimerWithTimeInterval:2 target:self selector:@selector(rsGetDeviceStatusPolling) userInfo:nil repeats:YES];
//                
//                if(m_palert != nil)
//                {
//                    [m_palert dismissWithClickedButtonIndex:2 animated:NO];
//                    m_palert = nil;
//                }
//                
//                if(alert != nil)
//                {
//                    [alert dismissWithClickedButtonIndex:2 animated:NO];
//                    
//                }
//                
//                [super CreateAllert:nil message:MSG_REMOTESCAN_CANCELED btnTitle:MSG_BUTTON_OK];
//                
//            }
//            break;
//        }
//        case E_RS_JOB_STATUS_FINISHED:  // 完了しました。
//            // スクリーンロック解除
//            manager.parserDelegate = nil;
//            bRemoteScanRunning = NO;
//            
//            nStatus = RSSTATUS_EXECUTEJOB_COMPLETE;
//            [self rsSetDeviceContextEnd];
//            
//            [self stopFtpServer];
//            
//            //            // セッションID解放
//            //            [self rsReleaseUISessionId];
//            
//            break;
//            
//        case E_RS_JOB_STATUS_ERROR_ALL_PAGE_BLANK:
//            // 全ページ白紙
//            manager.parserDelegate = nil;
//            bRemoteScanCanceled = YES;
//            [self stopFtpServer];
//            
//            nStatus = RSSTATUS_SETDEVICECONTEXT_END;
//            [self rsSetDeviceContextEnd];
//            
//            // ポーリングタイマー停止
//            [self stopGetDeviceStatusPolling];
//            
//            // デバイスにセットされている用紙サイズ取得ポーリングを開始
//            bRemoteScanRunning = NO;
//            originalSizePollingTimer = [NSTimer scheduledTimerWithTimeInterval:2 target:self selector:@selector(rsGetDeviceStatusPolling) userInfo:nil repeats:YES];
//            
//            if(m_palert != nil)
//            {
//                [m_palert dismissWithClickedButtonIndex:2 animated:NO];
//                m_palert = nil;
//            }
//            
//            if(alert != nil)
//            {
//                [alert dismissWithClickedButtonIndex:2 animated:NO];
//                
//            }
//            
//            [super CreateAllert:nil message:MSG_REMOTESCAN_ERROR_ALL_PAGE_BLANK btnTitle:MSG_BUTTON_OK];
//            
//            break;
//            
//        default:
//            nStatus = RSSTATUS_SETDEVICECONTEXT_END;
//            [self rsSetDeviceContextEnd];
//            [self showScanFailedAlert];
//            
//            // JobStatusポーリング終了
//            ((RSGetJobStatusManager*)manager).endThread = YES;
//            manager.parserDelegate = nil;
//            
//            // デバイスにセットされている用紙サイズ取得ポーリングを開始
//            // ポーリングタイマー停止
//            [self stopGetDeviceStatusPolling];
//            
//            // デバイスにセットされている用紙サイズ取得ポーリングを開始
//            bRemoteScanRunning = NO;
//            originalSizePollingTimer = [NSTimer scheduledTimerWithTimeInterval:2 target:self selector:@selector(rsGetDeviceStatusPolling) userInfo:nil repeats:YES];
//            break;
//    }
}


// 設定可能なパラメータの取得完了
-(void)didFinishRSGetJobSettableElementsManagerParsing
{
    rssViewData = [[TwainRemoteScanSettingViewData alloc] initWithRSSettableElementsData:[rsManager rsSettableElementsData]];
    
    // 設定情報を更新
    [self updateSetting];
    
    // ボタンを非活性にする
    [self setAllButtonEnable:YES];
}

#pragma mark - UIAlertViewDelegate
//
// アラートボタンによる処理(アラートが閉じた後に呼ばれるメソッド)
//
- (void)alertView:(UIAlertView *)alerts didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    DLog(@"buttonIndex: %d, Tag:%d", buttonIndex, alerts.tag);
    
    if(alerts.tag == TW_ALERT_TAG_SCANBEFORE){
        
//        bShowingManuscriptDialog = NO;
        
        switch (buttonIndex) {
            case 0: {
                // キャンセルボタン押下
                // スキャンしない
                // 処理実行フラグOFF
                bRemoteScanCanceled = YES;
                
                SharpScanPrintAppDelegate* appDelegate = (SharpScanPrintAppDelegate*)[[UIApplication sharedApplication] delegate];
                appDelegate.IsRun = FALSE;
                m_palert = nil;
                
//                nStatus = RSSTATUS_SETDEVICECONTEXT_END;
                [self rsSetDeviceContextEnd];
                
                break;
            }
            case 1:
                // スキャン開始
                m_IsModProfile = FALSE;
                
                m_palert = nil;
                
                // 取り込み中はスリープ状態にしない
                [UIApplication sharedApplication].idleTimerDisabled = YES;
                
                // tempフォルダにファイルがあれば削除
                [[NSFileManager defaultManager] removeItemAtPath:[CommonUtil tmpDir] error:NULL];	// ディレクトリ削除
                
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
                if(![self getIPAdder])
                {
                    UIAlertView *alertview =  [[UIAlertView alloc] initWithTitle:nil message:MSG_NETWORK_ERR
                                                                        delegate:self
                                                               cancelButtonTitle:nil
                                                               otherButtonTitles:MSG_BUTTON_OK, nil];
                    [alertview performSelectorOnMainThread:@selector(show) withObject:nil waitUntilDone:NO];
                    
//                    nStatus = RSSTATUS_SETDEVICECONTEXT_END;
                    [self rsSetDeviceContextEnd];
                    
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
                
                // しばらくお待ちくださいダイアログを出す
                [self createProgressionAlertWithMessage:nil message: MSG_WAIT withCancel:YES];
                alert.tag = TW_ALERT_TAG_SETDEVICECONTEXT_WAIT;
                
                // 確認用
                //取り込み用
//                _tsc = [[TwainSocketController alloc]initWithHost:@"192.168.0.100"
//                                                           portNo:@(52000)
//                                                     scanPosition:ScanPositionPlaten
//                                                        direction:DirectionFromTop
//                                                       resolution:Resolution75
//                                                        colorMode:ColorModeGrayscale
//                                                        threshold:kThresholdValue
//                                                        paperSize:PaperSizeA4
//                                                     computerName:@"TestComputer"
//                                                       timeoutSec:kTimeoutValue
//                                                         delegate:self];
                
                _tsc = [[TwainSocketController alloc]initWithHost:@"192.168.0.100"
                                                           portNo:@(52000)
                                                     scanPosition:self.scanPosition
                                                        direction:self.direction
                                                       resolution:self.resolution
                                                        colorMode:self.colorMode
                                                        threshold:self.threshold
                                                        paperSize:self.paperSize
                                                     computerName:self.computerName
                                                       timeoutSec:self.timeoutSec
                                                         delegate:self];
                
//                //準備用
//                _tsc = [[TwainSocketController alloc]initForModeSenseWithHost:@"192.168.0.100"
//                                                                       portNo:@(52000)
//                                                                   timeoutSec:kTimeoutValue
//                                                                     delegate:self];
                [_tsc sendGreetingMessage];

                // 原稿サイズがはがき、固定カスタムサイズ、新規カスタムサイズの場合はチェック
//                if([[rssViewData.originalSize getSelectValue] isEqualToString:@"japanese_postcard_a6"]
//                   || [[rssViewData.originalSize getSelectValue] isEqualToString:@"extraSize1"]
//                   || [[rssViewData.originalSize getSelectValue] isEqualToString:@"extraSize2"]
//                   || [[rssViewData.originalSize getSelectValue] isEqualToString:@"extraSize3"]
//                   || [[rssViewData.originalSize getSelectValue] isEqualToString:@"extraSize4"]
//                   || [[rssViewData.originalSize getSelectValue] isEqualToString:@"customSize1"]
//                   || [[rssViewData.originalSize getSelectValue] isEqualToString:@"customSize2"]
//                   || [[rssViewData.originalSize getSelectValue] isEqualToString:@"customSize3"]
//                   || [[rssViewData.originalSize getSelectValue] isEqualToString:@"customSize4"]
//                   || [[rssViewData.originalSize getSelectValue] isEqualToString:@"customSize5"])
//                {
//                    // 選択したサイズの横、縦
//                    NSInteger nSelectSizeWidth = 0;
//                    NSInteger nSelectSizeHeight = 0;
//                    
//                    if([[rssViewData.originalSize getSelectValue]rangeOfString:@"extraSize"].location != NSNotFound)
//                    {
//                        nSelectSizeWidth = [[rssViewData.extraSize getCustomPaperSizeData:[rssViewData.originalSize getSelectValue]]getMilliWidth];
//                        
//                        nSelectSizeHeight = [[rssViewData.extraSize getCustomPaperSizeData:[rssViewData.originalSize getSelectValue]]getMilliHeight];
//                        
//                    }
//                    else if([[rssViewData.originalSize getSelectValue]rangeOfString:@"customSize"].location != NSNotFound)
//                    {
//                        nSelectSizeWidth = [[rssViewData.customSize getCustomPaperSizeData:[rssViewData.originalSize getSelectValue]]getMilliWidth];
//                        
//                        nSelectSizeHeight = [[rssViewData.customSize getCustomPaperSizeData:[rssViewData.originalSize getSelectValue]]getMilliHeight];
//                        
//                    }else if([[rssViewData.originalSize getSelectValue]rangeOfString:@"japanese_postcard_a6"].location != NSNotFound)
//                    {
//                        nSelectSizeWidth = JAPANESE_POSTCARD_A6_WIDTH;
//                        nSelectSizeHeight = JAPANESE_POSTCARD_A6_HEIGHT;
//                    }
//                    
//                    // 選択サイズの縦、横どちらかが読み取りサイズ以下の場合
//                    if(nSelectSizeWidth < [pstrDetectableMinWidth intValue] || nSelectSizeHeight < [pstrDetectableMinHeight intValue])
//                    {
//                        
//                        // 両面の場合はチェック
//                        if([[rssViewData.duplexData getSelectValue] isEqualToString:@"duplex+book"]
//                           || [[rssViewData.duplexData getSelectValue] isEqualToString:@"duplex+tablet"])
//                        {
//                            // platenがunknown以外、feederがunknownの場合（OCのみ検知ありの場合）
//                            if(!bFeederSize && bPlatenSize)
//                            {
//                                //　GetDeviceStatusのポーリング処理は続行し、ExecuteJobを実行しない。
//                                UIAlertView *alertview =  [[UIAlertView alloc] initWithTitle:nil message:MSG_REMOTESCAN_NOTUSE
//                                                                                    delegate:self
//                                                                           cancelButtonTitle:nil
//                                                                           otherButtonTitles:MSG_BUTTON_OK, nil];
//                                [alertview performSelectorOnMainThread:@selector(show) withObject:nil waitUntilDone:NO];
//                                
//                                nStatus = RSSTATUS_SETDEVICECONTEXT_END;
//                                [self rsSetDeviceContextEnd];
//                                
//                                return;
//                            }
//                        }
//                        
//                        // どちらも"unknown"以外の場合（DF / OC共に検知ありの場合）
//                        if(bFeederSize && bPlatenSize)
//                        {
//                            // GetDeviceStatusのポーリング処理は続行し、ExecuteJobを実行しない。
//                            UIAlertView *alertview =  [[UIAlertView alloc] initWithTitle:nil message:MSG_REMOTESCAN_REMOVEDOCUMENT
//                                                                                delegate:self
//                                                                       cancelButtonTitle:nil
//                                                                       otherButtonTitles:MSG_BUTTON_OK, nil];
//                            [alertview performSelectorOnMainThread:@selector(show) withObject:nil waitUntilDone:NO];
//                            
//                            nStatus = RSSTATUS_SETDEVICECONTEXT_END;
//                            [self rsSetDeviceContextEnd];
//                            
//                            return;
//                        }
//                        // platenがunknown、feederがunknown以外の場合（DFのみ検知ありの場合）
//                        else if(bFeederSize && !bPlatenSize)
//                        {
//                            //　GetDeviceStatusのポーリング処理は続行し、ExecuteJobを実行しない。
//                            UIAlertView *alertview =  [[UIAlertView alloc] initWithTitle:nil message:MSG_REMOTESCAN_USESTAND
//                                                                                delegate:self
//                                                                       cancelButtonTitle:nil
//                                                                       otherButtonTitles:MSG_BUTTON_OK, nil];
//                            [alertview performSelectorOnMainThread:@selector(show) withObject:nil waitUntilDone:NO];
//                            
//                            nStatus = RSSTATUS_SETDEVICECONTEXT_END;
//                            [self rsSetDeviceContextEnd];
//                            
//                            return;
//                        }
//                        // platenがunknown以外、feederがunknownの場合（OCのみ検知ありの場合）
//                        else if(!bFeederSize && bPlatenSize)
//                        {
//                            // GetDeviceStatusのポーリング処理を終了し、ExecuteJobを実行する。
//                        }
//                        // platenがunknown、feederがunknownの場合（DF / OC共に検知なしの場合）
//                        else if(!bFeederSize && !bPlatenSize)
//                        {
//                            //GetDeviceStatusのポーリング処理を終了し、ExecuteJobを実行する。
//                        }
//                    }
//                    
//                }
                
//                // 長尺の場合はチェック
//                if([[rssViewData.originalSize getSelectValue] isEqualToString:@"long"])
//                {
//                    // platenがunknown以外、feederがunknownの場合（OCのみ検知ありの場合）
//                    if(!bFeederSize && bPlatenSize)
//                    {
//                        //　GetDeviceStatusのポーリング処理は続行し、ExecuteJobを実行しない。
//                        UIAlertView *alertview =  [[UIAlertView alloc] initWithTitle:nil message:MSG_REMOTESCAN_USEFEEDER
//                                                                            delegate:self
//                                                                   cancelButtonTitle:nil
//                                                                   otherButtonTitles:MSG_BUTTON_OK, nil];
//                        [alertview performSelectorOnMainThread:@selector(show) withObject:nil waitUntilDone:NO];
//                        
//                        nStatus = RSSTATUS_SETDEVICECONTEXT_END;
//                        [self rsSetDeviceContextEnd];
//                        
//                        return;
//                    }
//                }
                
//                // 両面の場合はチェック
//                if([[rssViewData.duplexData getSelectValue] isEqualToString:@"duplex+book"]
//                   || [[rssViewData.duplexData getSelectValue] isEqualToString:@"duplex+tablet"])
//                {
//                    // feederがunknownの場合（OCのみ検知ありの場合または、DF / OC共に検知なしの場合）
//                    if(!bFeederSize)
//                    {
//                        //　GetDeviceStatusのポーリング処理は続行し、ExecuteJobを実行しない。
//                        UIAlertView *alertview =  [[UIAlertView alloc] initWithTitle:nil message:MSG_REMOTESCAN_USEFEEDER
//                                                                            delegate:self
//                                                                   cancelButtonTitle:nil
//                                                                   otherButtonTitles:MSG_BUTTON_OK, nil];
//                        [alertview performSelectorOnMainThread:@selector(show) withObject:nil waitUntilDone:NO];
//                        
//                        nStatus = RSSTATUS_SETDEVICECONTEXT_END;
//                        [self rsSetDeviceContextEnd];
//                        
//                        return;
//                    }
//                }
//                
//                //GetDeviceStatusを止める
//                if(originalSizePollingTimer != nil)
//                {
//                    if([originalSizePollingTimer isValid]){
//                        [originalSizePollingTimer invalidate];
//                        originalSizePollingTimer = nil;
//                    }
//                }
//                
//                nStatus = RSSTATUS_EXECUTEJOB;
//                // ExecuteJob実施前に一度だけGetDeviceStatusをする
//                [self rsGetDeviceStatus];
//                
//                [self createProgressionAlertWithMessage:nil message: MSG_REMOTESCAN_DOING withCancel:YES];
            }
                @finally
            {
                
            }
                break;
            case 2:
                // 自動ダイアログ切り替え用　何もしない
                m_palert = nil;
                break;
            default:
                break;
        }
    }else if(alerts.tag == TW_ALERT_TAG_SCANPROGRESS){
        //プログレスダイアログ
        switch (buttonIndex) {
            case 1:
                // 成功？
                break;
            case 0:
                // キャンセル
                bRemoteScanCanceled = YES;
                bRemoteScanRunning = NO;
                alert = nil;
                m_palert = nil;
                
                // ExecuteJobの戻りがかえる前にCancelJobが実行されないように待つ
                
//                if(jobId == nil)
//                {
//                    // 別スレッドで実行
//                    cancelJobWaitTimer = [NSTimer scheduledTimerWithTimeInterval:1.0f target:self selector:@selector(doCancelJob:) userInfo:[[NSDictionary alloc] init] repeats:NO];
//                }
//                else
//                {
//                    [self stopFtpServer];
//                    [self rsCancelJob];
//                }
                
                //                [super CreateAllert:nil message:MSG_REMOTESCAN_CANCELING btnTitle:@"OK"];
                
                break;
            case 2:
                // アプリによる自動キャンセル時
                alert = nil;
                //                m_palert = nil;//GetJobStatusでアラートが裏で開いたままになるのでコメントアウト
            default:
                break;
        }
        
    }else if(alerts.tag == TW_ALERT_TAG_FAILED_REQUESTUISESSIONID){
        // 通常取り込み画面へ遷移する
    }else if(alerts.tag == TW_ALERT_TAG_JAMMING){
        switch (buttonIndex) {
            case 0:
                alert = nil;
                m_palert = nil;
                // キャンセル
                bRemoteScanCanceled = YES;
                bRemoteScanRunning = NO;
//                [self stopFtpServer];
                [self rsCancelJob];
                
                //                [super CreateAllert:nil message:MSG_REMOTESCAN_CANCELING btnTitle:@"OK"];
                
                break;
            case 1:
                alert = nil;
                m_palert = nil;
                [self createProgressionAlertWithMessage:nil message: MSG_REMOTESCAN_DOING withCancel:YES];
                // ResumeJob開始
                [self rsResumeJob];
                
                break;
            case 2:
                // アプリによる自動キャンセル時
                break;
            default:
                break;
        }
    }else if(alerts.tag == TW_ALERT_TAG_WIFI_NO_CONNECTION){
        // wi-fi接続エラー
        bFirstErr_Network = NO;
        
        // シーケンスのキャンセル
        if(bRemoteScanRunning){
            bRemoteScanCanceled = YES;
            bRemoteScanRunning = NO;
//            [self stopFtpServer];
        }
        
        if(alert){
            [alert dismissWithClickedButtonIndex:2 animated:NO];
            alert = nil;
        }
        
        // ポーリングタイマー停止
        [self stopGetDeviceStatusPolling];
        
        // ポーリング開始
//        originalSizePollingTimer = [NSTimer scheduledTimerWithTimeInterval:2 target:self selector:@selector(rsGetDeviceStatusPolling) userInfo:nil repeats:YES];
        
    }else if(alerts.tag == TW_ALERT_TAG_ORIGINAL_NOT_DETECTED_EXECUTE){
        // シーケンスのキャンセル
        bRemoteScanCanceled = YES;
        bRemoteScanRunning = NO;
//        [self stopFtpServer];
        alert = nil;
        m_palert = nil;
        
    }else if(alerts.tag == TW_ALERT_TAG_SCAN_FAILED || alerts.tag == TW_ALERT_TAG_RESOURCE_NOT_FOUND){
        // 取り込み失敗
        
        // シーケンスのキャンセル
        bRemoteScanCanceled = YES;
        bRemoteScanRunning = NO;
//        [self stopFtpServer];
        alert = nil;
        m_palert = nil;
        
        //        // ポーリングタイマー停止
        //        if(originalSizePollingTimer != nil)
        //        {
        //            if([originalSizePollingTimer isValid]){
        //                [originalSizePollingTimer invalidate];
        //                originalSizePollingTimer = nil;
        //            }
        //        }
        
        //        nStatus = RSSTATUS_SETDEVICECONTEXT_END;
        //        [self rsSetDeviceContextEnd];
        
    }else if(alerts.tag == TW_ALERT_TAG_NOT_SUPPORTED){
        // 取り込み失敗
        [self remoteScanToNomalScan];
    }else if(alerts.tag == TW_ALERT_TAG_NETWORKERROR_AND_EXIT){
        [self remoteScanToNomalScan];
    }else if(alerts.tag == TW_ALERT_TAG_RSSETDEVICECONTEXTMANAGER_ERROR){
        // SetDeviceContextで失敗
        // ダイアログ閉じるだけ
        
    }else if(alerts.tag == TW_ALERT_TAG_NOT_SUPPORTED_AND_STOP){
        // リモートスキャン未対応、ポーリングを停止する
        alert = nil;
        
        // ポーリングタイマー停止
        [self stopGetDeviceStatusPolling];
        [self remoteScanToNomalScan];
        
    }else if(alerts.tag == TW_ALERT_TAG_ORIGINAL_NOT_DETECTED){
        // 用紙未検知
        
        if(buttonIndex == alerts.cancelButtonIndex){
            // キャンセル
            
            // シーケンスのキャンセル
            bRemoteScanCanceled = YES;
            bRemoteScanRunning = NO;
//            [self stopFtpServer];
            
            [self rsCancelJob];
            
            // ポーリングタイマー停止
            [self stopGetDeviceStatusPolling];
            
            // ポーリング開始
//            originalSizePollingTimer = [NSTimer scheduledTimerWithTimeInterval:2 target:self selector:@selector(rsGetDeviceStatusPolling) userInfo:nil repeats:YES];
            
            alert = nil;
            m_palert = nil;
        }else{
            [self createProgressionAlertWithMessage:nil message: MSG_REMOTESCAN_DOING withCancel:YES];
            // 再度取り込み処理
            [self rsResumeJob];
        }
        
    }else if(alerts.tag == TW_ALERT_TAG_WAIT){
        
        alert = nil;
        m_palert = nil;
//        // キャンセル処理が必要
//        [rsManager updateDataCancel];
    }else if(alerts.tag == TW_ALERT_TAG_SETDEVICECONTEXT_WAIT){
        switch (buttonIndex) {
            case 1:
                // RequestUISessionID,SetDeviceContextのキャンセル
                alert = nil;
                m_palert = nil;
//                if (nStatus == RSSTATUS_SETDEVICECONTEXT_START || nStatus == RSSTATUS_SETDEVICECONTEXT_RETRY || nStatus == RSSTATUS_SETDEVICECONTEXT_WAIT) {
//                    nStatus = RSSTATUS_RELEASEUISESSIONID;
//                    [self rsReleaseUISessionId];
//                }
                break;
            default:
                break;
        }
    }else if(alerts.tag == TW_ALERT_TAG_EXECUTEJOB_ACCESSDENIED) {
        // 何もしない
    }else if(alerts.tag == TW_ALERT_TAG_GETDEVICESTATUS_FAILED) {
        // リモートスキャン中断、通常取り込み画面へ遷移
        alert = nil;
        
        // ポーリングタイマー停止
        [self stopGetDeviceStatusPolling];
        [self remoteScanToNomalScan];
        
    }else if(alerts.tag == TW_ALERT_TAG_REMOTE_CHECK) {
        if (buttonIndex == 0) {
            // ボタン非活性でリモートモードを開く
            [super AnimationShowStartMenu];
        }
        
    }else if(alerts.tag == TW_ALERT_TAG_REMOTE_Result) {
        // リモートスキャン未対応、ポーリングを停止する
        alert = nil;
        
        // 取り込み失敗
        [self remoteScanToNomalScan];

    }else{
        // その他のボタン
        [super alertView:alerts didDismissWithButtonIndex:buttonIndex];
        alert = nil;
        m_palert = nil;
    }
}

#pragma mark - Network
// 1.セッションIDの取得
-(void)rsRequestUISessionId
{
    DLog(@"func:%s", __func__);
    
    if(![self isShowRemoteScanView])
    {
        return;
    }
    
    // オブジェクト存在時は解放する
//    if ( requestUISessionIdManager ) {
//        requestUISessionIdManager.parserDelegate = nil;
//        requestUISessionIdManager = nil;
//    }
    
//    bScreenLock = NO;
//    requestUISessionIdManager = [[RSRequestUISessionIdManager alloc]initWithURL:connectUrl];
//    requestUISessionIdManager.parserDelegate = self;
//    [requestUISessionIdManager updateData];
    
}
-(void)rsGetJobSettableElements
{
    DLog(@"func:%s", __func__);
    
    if(![self isShowRemoteScanView])
    {
        return;
    }
    
    // オブジェクト存在時は解放する
    if ( rsManager ) {
        rsManager.parserDelegate = nil;
        rsManager = nil;
    }
    
    rsManager = [[RSGetJobSettableElementsManager alloc]initWithURL:connectUrl];
    rsManager.parserDelegate = self;
    [rsManager updateData];
    
}
-(void)rsSetDeviceContextStartRetry
{
//    if(nStatus == RSSTATUS_SETDEVICECONTEXT_RETRY)
//    {
//        [self rsSetDeviceContext:YES];
//    }
}
// 2.端末情報通知（スクリーンロック開始）
-(void)rsSetDeviceContextStart
{
    [self rsSetDeviceContext:YES];
}
// 5.スクリーンロックの解除
-(void)rsSetDeviceContextEnd
{
    [self rsSetDeviceContext:NO];
}
-(void)rsSetDeviceContext:(BOOL)bScreenLockStart
{
    DLog(@"func:%s", __func__);
    
    if(![self isShowRemoteScanView])
    {
        return;
    }
    
//    // オブジェクト存在時は解放する
//    if ( setDeviceContextManager ) {
//        setDeviceContextManager.parserDelegate = nil;
//        setDeviceContextManager = nil;
//    }
//    
//    setDeviceContextManager = [[RSSetDeviceContextManager alloc]initWithURL:connectUrl];
//    setDeviceContextManager.parserDelegate = self;
//    if(bScreenLockStart){
//        bScreenLock = YES;
//        // スクリーンロック開始
//        [setDeviceContextManager updateData:YES remoteScanHost:strProfileName remoteScanCode:strVerifyCode remoteScanTimeOut:30 vkey:[self vkey]];
//    }else{
//        bScreenLock = NO;
//        // スクリーンロック終了
//        [setDeviceContextManager updateData:NO remoteScanHost:nil remoteScanCode:nil remoteScanTimeOut:0 vkey:[self vkey]];
//    }
    
}
// 3.複合機の状態を取得
-(void)rsGetDeviceStatus
{
    DLog(@"func:%s", __func__);
    
    if(![self isShowRemoteScanView])
    {
        return;
    }
    
//    // オブジェクト存在時は解放する
//    if ( pollingRsManager ) {
//        [pollingRsManager disconnect];  // ポーリングキャンセル
//        pollingRsManager.parserDelegate = nil;
//        pollingRsManager = nil;
//    }
//    
//    pollingRsManager = [[RSGetDeviceStatusManager alloc]initWithURL:connectUrl];
//    pollingRsManager.parserDelegate = self;
//    [pollingRsManager updateData];
}

// 4.スキャンジョブの開始
-(void)rsExecuteJob
{
    DLog(@"func:%s", __func__);
    
    if(![self isShowRemoteScanView])
    {
        return;
    }
    
//    // オブジェクト存在時は解放する
//    if ( executeJobManager ) {
//        executeJobManager.parserDelegate = nil;
//        executeJobManager = nil;
//    }
//    
//    executeJobManager = [[RSExecuteJobManager alloc]initWithURL:connectUrl];
//    executeJobManager.parserDelegate = self;
//    
//    // 設定値をまとめる
//    NSMutableDictionary* dic = [rssViewData getExecuteJobParameter];
//    
//    [dic setObject:[self vkey] forKey:@"vkey"];
//    
//    [dic setObject:[NSString stringWithFormat:@"%@:%@", iPaddr, S_FTP_PORT] forKey:@"ftpHost"];
//    [dic setObject:S_FTP_USER forKey:@"ftpUsername"];
//    //    [dic setObject:S_FTP_SPECIAL_PASSWORD forKey:@"ftpPassword"];
//    [dic setObject:m_ScanPass forKey:@"ftpPassword"];
//    
//    BOOL isContain1 = NO;
//    BOOL isContain2 = NO;
//    BOOL isContain3 = NO;
//    // 1. 原稿サイズが自動以外
//    if(![[rssViewData.originalSize getSelectValue] isEqualToString:@"auto"])
//    {
//        isContain1 = YES;
//    }
//    // 2. platen、feeder共にunknownの場合（DF / OC共に検知なしの場合）
//    if(!bFeederSize && !bPlatenSize)
//    {
//        isContain2 = YES;
//    }
//    // 3. GetJobSettableElementsで取得したオリジナルソースの値にプラテンが存在する
//    for (NSString* key in [[rsManager rsSettableElementsData].originalSourceData getCapableOptionsKeys]) {
//        if ([key isEqualToString:@"platen"]) {
//            // プラテンあり
//            isContain3 = YES;
//            break;
//        }
//    }
//    // 3つ共にTrueの場合、ExecuteJobのパラメータとして、オリジナルソース＝プラテンを追加する
//    if (isContain1 && isContain2 && isContain3) {
//        [dic setObject:@"platen" forKey:@"OriginalSource"];
//    }
//    
//    // 開始
//    [executeJobManager updateData:dic];
    
}

// 6.ジョブステータス取得ポーリングを開始
-(void)rsGetJobStatus
{
    DLog(@"func:%s", __func__);
    
    if(![self isShowRemoteScanView])
    {
        return;
    }
    
//    // オブジェクト存在時は解放する
//    if ( getJobStatusManager ) {
//        getJobStatusManager.parserDelegate = nil;
//        getJobStatusManager = nil;
//    }
//    
//    getJobStatusManager = [[RSGetJobStatusManager alloc]initWithURL:connectUrl];
//    getJobStatusManager.parserDelegate = self;
//    [getJobStatusManager startPollingThreadWithJobId:jobId timeInterval:2 delegate:self];
}

// 7.セッションのリリース
-(void)rsReleaseUISessionId
{
    DLog(@"func:%s", __func__);
    
    
//    if(sessionId)
//    {
//        // オブジェクト存在時は解放する
//        if ( releaseUISessionIdManager ) {
//            releaseUISessionIdManager.parserDelegate = nil;
//            releaseUISessionIdManager = nil;
//        }
//        
//        releaseUISessionIdManager = [[RSReleaseUISessionIdManager alloc]initWithURL:connectUrl];
//        releaseUISessionIdManager.parserDelegate = self;
//        [releaseUISessionIdManager updateData:sessionId];
//        sessionId = nil;
//    }
}

// 8.リモートスキャン終了処理
-(void)rsFinish
{
    bRemoteScanRunning = NO;
    
//    // 処理実行フラグOFF
//    SharpScanPrintAppDelegate* appDelegate = (SharpScanPrintAppDelegate*)[[UIApplication sharedApplication] delegate];
//    appDelegate.IsRun = FALSE;
    
}

// ジョブのキャンセル
-(void)rsCancelJob
{
    DLog(@"func:%s", __func__);
    
//    // オブジェクト存在時は解放する
//    if ( cancelJobManager ) {
//        cancelJobManager.parserDelegate = nil;
//        cancelJobManager = nil;
//    }
//    
//    cancelJobManager = [[RSCancelJobManager alloc]initWithURL:connectUrl];
//    cancelJobManager.parserDelegate = self;
//    [cancelJobManager updateData:jobId];
}

// ジョブのレジューム
-(void)rsResumeJob
{
    DLog(@"func:%s", __func__);
    
//    // オブジェクト存在時は解放する
//    if ( resumeJobManager ) {
//        resumeJobManager.parserDelegate = nil;
//        resumeJobManager = nil;
//    }
//    
//    resumeJobManager = [[RSResumeJobManager alloc]initWithURL:connectUrl];
//    resumeJobManager.parserDelegate = self;
//    [resumeJobManager updateData:jobId :@"auto" :@"auto" :@"200" :@"text" :0];
}

// セッションIDからvkeyに変換する
-(NSString*)vkey{
    if(strVKey == nil || [strVKey isEqualToString:@""])
    {
        strVKey = [[CommonUtil createVkey:sessionId] copy];
    }
    return strVKey;
}

// デバイスにセットされている用紙サイズをポーリングして取得する
-(void)rsGetDeviceStatusPolling
{
    // リモートスキャンシーケンス中はポーリングしない
    if(!bRemoteScanRunning){
//        if(!pollingRsManager){
//            DLog(@"func:%s", __func__);
//            pollingRsManager = [[RSGetDeviceStatusManager alloc]initWithURL:connectUrl];
//            pollingRsManager.parserDelegate = self;
//        }
//        [pollingRsManager updateData];
    }
    
    // リモートスキャン画面でなければポーリングを終了する
    if(![self isShowRemoteScanView])
    {
//        if(originalSizePollingTimer != nil)
//        {
//            if([originalSizePollingTimer isValid]){
//                [originalSizePollingTimer invalidate];
//                originalSizePollingTimer = nil;
//            }
//        }
    }
}

-(void)stopGetDeviceStatusPolling
{
//    if(originalSizePollingTimer != nil)
//    {
//        if([originalSizePollingTimer isValid]){
//            [originalSizePollingTimer invalidate];
//            originalSizePollingTimer = nil;
//        }
//        
//        if(pollingRsManager != nil)
//        {
//            if ( pollingRsManager )
//            {
//                [pollingRsManager disconnect];  // ポーリングキャンセル
//                pollingRsManager.parserDelegate = nil;
//                pollingRsManager = nil;
//            }
//        }
//    }
}

-(BOOL)isShowRemoteScanView
{
    BOOL result = YES;
    
//    if(![self.navigationController.visibleViewController isKindOfClass:[RemoteScanBeforePictViewController class]] &&
//       ![self.navigationController.visibleViewController isKindOfClass:[RSS_ColorModeViewController class]] &&
//       ![self.navigationController.visibleViewController isKindOfClass:[RSS_ManuscriptViewController class]] &&
//       ![self.navigationController.visibleViewController isKindOfClass:[RSS_CustomSizeListViewController class]] &&
//       ![self.navigationController.visibleViewController isKindOfClass:[RSS_CustomSizeSettingViewController class]] &&
//       ![self.navigationController.visibleViewController isKindOfClass:[RSS_BothOrOneSideViewController class]] &&
//       ![self.navigationController.visibleViewController isKindOfClass:[RSS_FormatViewController class]] &&
//       ![self.navigationController.visibleViewController isKindOfClass:[RSS_ResolutionViewController class]] &&
//       ![self.navigationController.visibleViewController isKindOfClass:[RSS_OtherViewController class]])
//    {
//        result = NO;
//    }
    
    return result;
}

#pragma mark - Show Error Alert
// メインスレッドでエラーアラートを表示
-(void)showErrorAlertOnMainThreadWithMessage:(NSString*)message tag:(int)tag
{
    // 表示中のアラートを消す
    [self performSelectorOnMainThread:@selector(closeAlert) withObject:nil waitUntilDone:NO];
    
    // ボタンの設定
    NSString* cancelTitle = nil;
    NSString* otherTitle = MSG_BUTTON_OK;
    if(tag == TW_ALERT_TAG_ORIGINAL_NOT_DETECTED){
        cancelTitle = MSG_BUTTON_CANCEL;
        otherTitle = S_BUTTON_SCAN_IPAD;
    }
    
    UIAlertView *alertview =  [[UIAlertView alloc] initWithTitle:nil
                                                         message:message
                                                        delegate:self
                                               cancelButtonTitle:cancelTitle
                                               otherButtonTitles:otherTitle, nil];
    alertview.tag = tag;
    [alertview performSelectorOnMainThread:@selector(show) withObject:nil waitUntilDone:NO];
}

// 表示中のアラートを消す
- (void)closeAlert {
    if (alert != nil) {
        [alert dismissWithClickedButtonIndex:2 animated:NO];
        alert = nil;
    }
}

// ネットワークアラートを表示
-(void)showNetworkAlert
{
    [self showErrorAlertOnMainThreadWithMessage:MSG_NETWORK_ERR tag:TW_ALERT_TAG_WIFI_NO_CONNECTION];
}

// 取り込み失敗アラートを表示
-(void)showScanFailedAlert
{
    [self showErrorAlertOnMainThreadWithMessage:MSG_REMOTESCAN_SCANFAIL tag:TW_ALERT_TAG_SCAN_FAILED];
}

// リモートスキャン未対応・リモートスキャン禁止アラートを表示
-(void)showNotSupportedAlertAndStopPolling:(BOOL)bStop
{
    int tag = (bStop ? TW_ALERT_TAG_NOT_SUPPORTED_AND_STOP : TW_ALERT_TAG_NOT_SUPPORTED);
    [self showErrorAlertOnMainThreadWithMessage:MSG_REMOTESCAN_NOTSUPPORT tag:tag];
}

// リモートスキャンでなくなったので取り込み中止アラートを表示
-(void)showResourceNotFoundAlert
{
    bRemoteScanCanceled = YES;
    [self showErrorAlertOnMainThreadWithMessage:MSG_REMOTESCAN_ACCESSDENIED tag:TW_ALERT_TAG_RESOURCE_NOT_FOUND];
}

#pragma mark -
#pragma mark FTP Notification

//
// 通知：FTP 受信結果
//
- (void) FtpReceiveResponceNotification:(NSNotification *)aNotification
{
    DLog(@"func:%s", __func__);
    
    NSString *postdata = [[aNotification userInfo] objectForKey:@"FTP_RETURN"];
    
	if ([postdata isEqualToString:@"1"] == YES)
	{
        // 複数ファイル受信確認
        if (nil != super.ScanFileName)
        {
            [commanager createCacheFile:baseDir filename:super.ScanFileName];
            //
            // PDF を PNG に保存
            //
            [commanager createThumbnail:baseDir filename:super.ScanFileName page:1 width:100 height:120 saveDir:baseDir isCache:YES];
            
            super.ScanFileName = nil;
        }
        
        //
		// 1:受信中
		//
		super.ScanFileName= [[aNotification userInfo] objectForKey:@"FTP_FILENAME"];
	}
	else if ([postdata isEqualToString:@"3"] == YES)
	{
		//
		// 3:受信完了 OK
		//
        
        // 受信完了後の処理は、GetJobStatusがFINISHになった後に実施する
	}
	else
	{
		//
		// 2:中断しました OK
		//
	}
    //    [super FtpReceiveResponceNotification:aNotification];
}

#pragma mark - Keyboard Event
// キーボードの監視を開始
- (void)registerForKeyboardNotifications
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
}

// キーボードの監視を終了
- (void)removeForKeyboardNotifications
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
}

// キーボード出現
- (void)keyboardWillShow:(NSNotification*)aNotification
{
    if(selectedVC){
//        if([selectedVC isKindOfClass:[RSS_FormatViewController class]]){
//            // フォーマットの場合、イベントを送る
//            [(RSS_FormatViewController*)selectedVC keyboardWillShow:aNotification];
//        }
    }
}

// キーボード消滅
- (void)keyboardWillHide:(NSNotification*)aNotification
{
    if(selectedVC){
//        if([selectedVC isKindOfClass:[RSS_FormatViewController class]]){
//            // フォーマットの場合、イベントを送る
//            [(RSS_FormatViewController*)selectedVC keyboardWillHide:aNotification];
//        }
    }
}


#pragma mark - Menu ScrollView Manage
-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    [self scrollViewDidScroll:scrollView animated:YES];
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView animated:(BOOL)animated
{
    UIButton* btn = nil;
    BOOL btnOn = 0;
    
    // 上ボタン表示判定
    if(scrollView.contentOffset.y > 0){
        if(menuUpBtn.alpha == 0.0){
            // 表示する
            btnOn = YES;
            btn = menuUpBtn;
        }
    }else{
        if(menuUpBtn.alpha == 1.0){
            // 非表示にする
            btnOn = NO;
            btn = menuUpBtn;
        }
    }
    if(btn){
        // 表示を切り替える
        [self showButton:btn on:btnOn animated:animated];
        btn = nil;
    }
    
    
    // 下ボタン表示判定
    if(scrollView.contentOffset.y + scrollView.frame.size.height < scrollView.contentSize.height){
        if(menuDownBtn.alpha == 0.0){
            // 表示する
            btnOn = YES;
            btn = menuDownBtn;
        }
    }else{
        if(menuDownBtn.alpha == 1.0){
            // 非表示にする
            btnOn = NO;
            btn = menuDownBtn;
        }
    }
    if(btn){
        // 表示を切り替える
        [self showButton:btn on:btnOn animated:animated];
        btn = nil;
    }
    
}
-(void)showButton:(UIButton*)btn on:(BOOL)on animated:(BOOL)animated
{
    if(animated){
        // アニメーション
        [UIView animateWithDuration:0.3
                         animations:^{
                             btn.alpha = (on ? 1.0 : 0.0);
                         }];
    }else{
        btn.alpha = (on ? 1.0 : 0.0);
    }
}

#pragma mark - UIButton Action
//- (IBAction)tapMenuUpBtn:(UIButton *)sender {
//    // 最上部までスクロール
//    [UIView animateWithDuration:0.3
//                     animations:^{
//                         menuScrollView.contentOffset = CGPointZero;
//                     }];
//}
//
//- (IBAction)tapMenuDownBtn:(UIButton *)sender {
//    // 最下部までスクロール
//    [UIView animateWithDuration:0.3
//                     animations:^{
//                         menuScrollView.contentOffset = CGPointMake(0, menuScrollView.contentSize.height - menuScrollView.frame.size.height);
//                     }];
//}

- (IBAction)tapRemoteSwt:(UISwitch*)sender {
    // リモートスキャンスイッチ切替
    if(!sender.on){
        // リモートスキャンをオフにする
        [self remoteScanToNomalScan];
    }
}

// メニュー表示ボタン押下
- (IBAction)OnShowMenuButton:(id)sender
{
    // 処理中あるいは処理中断フラグ=TRUEの場合は何もしない
    if (self.m_pThread || m_bAbort)
    {
        return;
    }
    [super AnimationShowMenu];
    if(!m_bShowMenu)
    {
        // 最上部までスクロール
        [UIView animateWithDuration:0.3
                         animations:^{
                             menuScrollView.contentOffset = CGPointZero;
                         }];
        menuScrollView.scrollEnabled = NO;
        
    }
    else
    {
        menuScrollView.scrollEnabled = YES;
    }
}

// バックグラウンドになった時に実行
- (void)DidBackgroundEnter
{
    DLog(@"DidBacGround");
    
    // 実行中はバックグラウンドになっても処理を継続
    bgTask = [[UIApplication sharedApplication] beginBackgroundTaskWithExpirationHandler:^{
        [[UIApplication sharedApplication] endBackgroundTask:bgTask];
        bgTask = UIBackgroundTaskInvalid;
    }];
    
    // ExecuteJob後
    if(bRemoteScanRunning)
    {
        // 取り込み処理を続行する
    }
    else
    {
        // ポーリングタイマー停止
        [self stopGetDeviceStatusPolling];
        
        if(m_palert != nil)
        {
            [m_palert dismissWithClickedButtonIndex:2 animated:NO];
            m_palert = nil;
        }
        
        if(alert != nil)
        {
            [alert dismissWithClickedButtonIndex:2 animated:NO];
            
        }
        
        // SetDeviceContext実施からExecuteJob実施まで
        if(bScreenLock)
        {
//            nStatus = RSSTATUS_SETDEVICECONTEXT_END;
            [self rsSetDeviceContextEnd];
        }
        
        // SetDeviceContext前
        bRemoteScanCanceled = YES;
        //        [self rsReleaseUISessionId];
        
    }
    
}

// バックグラウンドから復帰した時に実行
- (void)WillForegroundEnter
{
    // 終了後はバックグラウンド処理を終了する
    [self EndBackgroundTask];
    
    if(bRemoteScanRunning)
    {
        // 取り込み処理を続行する
    }
    else
    {
        //        // GetJobSettableElementsはスキップ
        //        bDoGetJobSettableElements = NO;
        //
        //        bDoRetryExecuteJob = NO;
        //
        //        // ボタンを非活性にする
        //        [self setAllButtonEnable:NO];
        //
        //        unsigned int len = [[[CommonUtil getIPAdder] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] length];
        //        if (0 < len)
        //        {
        //            // しばらくお待ちくださいダイアログを出す
        //            [self createProgressionAlertWithMessage:nil message: MSG_WAIT withCancel:YES];
        //            alert.tag = ALERT_TAG_WAIT;
        //        }
        //
        //        // 2秒後に再実行
        //        [self performSelector:@selector(rsRequestUISessionId) withObject:nil afterDelay:2.0f];
        
        // ポーリングタイマー停止
        [self stopGetDeviceStatusPolling];
        
        // デバイスにセットされている用紙サイズ取得ポーリングを開始
//        originalSizePollingTimer = [NSTimer scheduledTimerWithTimeInterval:2 target:self selector:@selector(rsGetDeviceStatusPolling) userInfo:nil repeats:YES];
    }
}

// バックグラウンド処理が終わった時に呼び出す
-(void)EndBackgroundTask
{
    [[UIApplication sharedApplication] endBackgroundTask:bgTask];
    bgTask = UIBackgroundTaskInvalid;
}

#pragma mark - TwainSocketControllerDelegate

//Scan成功
- (void)scanSuccess:(NSArray *)scanFilePathArray {
    // アラートを消す
    [self closeAlert];
    DLog(@"scanSuccess %@",scanFilePathArray);
    
//    TempDataManager *tManager = [[TempDataManager alloc]init];
//    if([tManager countOfTempData] > 0){
//        //
//        // 選択行の読み込み
//        //
//        TempData *aTempData = nil;
//        aTempData	= [tManager loadTempDataAtIndexPath:0];
//        ScanAfterPictViewController* scanpViewController;
//        scanpViewController = [[ScanAfterPictViewController alloc] init];
//        //
//        // 呼び出し画面のプロパティ設定
//        //
//        scanpViewController.SelFilePath	= [NSString stringWithFormat:@"%@/%@",self.baseDir,aTempData.fname];
//        scanpViewController.SelImagePath = [self.baseDir stringByAppendingPathComponent:[CommonUtil thumbnailPath:aTempData.fname]];
//        [self.navigationController pushViewController:scanpViewController animated:YES];
//    }
    
    ////////////////////////////////////
    if ([scanFilePathArray count] == 0) {
        return;
    }
//    self.isExit = FALSE;
//    NSString* pdf_file = [[self.siteUrl path]lastPathComponent];
    for (NSString *scanFilePath in scanFilePathArray) {
        NSString* pdf_file = [scanFilePath lastPathComponent];
        NSString *dirpath = [CommonUtil tmpDir];
        
        NSString* checkFileName = [pdf_file stringByDeletingPathExtension];
        NSString* extension = [pdf_file pathExtension];
        
        if(checkFileName.length + extension.length + 1 > 200){
            // ファイル名が長いので変更
            NSFileManager* fm = [NSFileManager defaultManager];
            
            // リネームパス作成
            NSString* toPath = [dirpath stringByAppendingPathComponent:[checkFileName substringToIndex:200 - extension.length - 1]];
            toPath = [toPath stringByAppendingPathExtension:extension];
            
            if([fm isExecutableFileAtPath:toPath]){
                // 名前の重複
                toPath = [dirpath stringByAppendingPathComponent:[checkFileName substringToIndex:195 - extension.length - 1]];
                for(int i = 1; i < 1000; i++){
                    NSString* tempToPath = nil;
                    tempToPath = [toPath stringByAppendingPathExtension:extension];
                    if(![fm isExecutableFileAtPath:tempToPath]){
                        // ファイル名の確定
                        toPath = tempToPath;
                        break;
                    }
                }
            }
            
            // 最終ファイル名保存
            pdf_file = [toPath lastPathComponent];
        }
        
        NSString *path = [NSString stringWithFormat:@"%@/%@",dirpath, pdf_file];
        
        commanager = [[CommonManager alloc]init];
//    [commanager moveFile:[self.siteUrl path] :path];
        [commanager moveFile:scanFilePath :path];
    }
    ///////////////////////
    //
    // PROFILE情報の取得
    //
    profileDataManager = [[ProfileDataManager alloc] init];
    ProfileData *profileData = nil;
//    profileData = [profileDataManager loadProfileDataAtIndex:0];
    
    // 内部メモリへの保存
    // プライマリキー
    if(profileData.autoSelectMode)
    {
        PrinterData* printerData = nil;
        //                printerData = [m_pPrinterMgr LoadPrinterDataAtIndex2:m_nSelPickerRow2];
        printerData = [m_pPrinterMgr LoadPrinterDataAtIndexInclude2:self.m_nSelPickerRow2];
        [m_pPrintOutMgr SetLatestPrimaryKey:[printerData PrimaryKey]];
    }
    
    TempDataManager *tManager = [[TempDataManager alloc]init];
    if([tManager countOfTempData] == 0)
//    if([scanFilePathArray count] == 0)
    {
        m_isScanStop = FALSE;
        //
        // 取り込みファイルが0件だった場合
        //
        UIAlertView *alertview =  [[UIAlertView alloc] initWithTitle:nil message:MSG_NO_SCAN_FILE
                                                            delegate:self
                                                   cancelButtonTitle:nil
                                                   otherButtonTitles:MSG_BUTTON_OK, nil];
        [alertview performSelectorOnMainThread:@selector(show) withObject:nil waitUntilDone:NO];
        
        // アラート表示前に取り込みボタンを非活性にになっていたら活性に戻す
        if(self.m_pbtnFirst.enabled == NO)
        {
            [self.m_pbtnFirst setEnabled:YES];
        }
    }
    else
    {
//        appDelegate.IsRun = FALSE;
//        TempDataManager *tManager = [[TempDataManager alloc]init];
        if([tManager countOfTempData] > 0)
//        if([scanFilePathArray count] > 0)
        {
            //
            // PDF を PNG に保存
            //
            BOOL bCreate = [commanager createThumbnail:baseDir filename:self.ScanFileName page:1 width:100 height:120 saveDir:baseDir isCache:YES];
            
            //
            // スキャンデータを読み込み、一覧に画面遷移
            //
            //TempDataManager *tManager = [TempDataManager sharedTempDataManager];
            if (bCreate && ([tManager countOfTempData] > 1))
//            if (bCreate && ([scanFilePathArray count] > 1))
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
                scanpViewController.SelFilePath	= [NSString stringWithFormat:@"%@/%@",self.baseDir,aTempData.fname];
                scanpViewController.SelImagePath = [self.baseDir stringByAppendingPathComponent:[CommonUtil thumbnailPath:aTempData.fname]];
                [self.navigationController pushViewController:scanpViewController animated:YES];
            }
        }
    }
}

//Scan失敗
- (void)scanFailed:(NSString *)errorMessage {
    // アラートを消す
    [self closeAlert];
    DLog(@"%@",errorMessage);
}

//ModeSense成功
- (void)modeSenseSuccess:(ModeSenseInParam *)msip {
    DLog(@"%@",msip);
}

//ModeSense失敗
- (void)modeSenseFailed:(NSString *)errorMessage {
    DLog(@"%@",errorMessage);
}

@end
