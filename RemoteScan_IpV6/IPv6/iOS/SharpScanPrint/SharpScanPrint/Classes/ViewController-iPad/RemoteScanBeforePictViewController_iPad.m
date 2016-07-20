
#import "RemoteScanBeforePictViewController_iPad.h"
#import "SharpScanPrintAppDelegate.h"
#import "Define.h"
#import "ProfileDataManager.h"
#import "CommonUtil.h"
#import "RSHttpCommunicationManager.h"
#import "RootViewController_iPad.h"
#import "PaperSetMatrix.h"

#import <QuartzCore/QuartzCore.h>

@interface RemoteScanBeforePictViewController_iPad ()

@end

@implementation RemoteScanBeforePictViewController_iPad

@synthesize rssViewData;

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

    m_pPrinterInfo = [[PrinterData alloc] init];

    // UINavigationBar 44px のずれを無くす
    self.navigationController.navigationBar.translucent = NO;
    self.navigationController.navigationBar.barStyle = NAVIGATION_BARSTYLE;
    
    // メインビュー初期化
    [super InitView:[CommonUtil getSSID] menuBtnNum:PrvMenuIDEighth hidesBackButton:NO hidesSettingButton:YES];

    // 設定表示ビューの設定
    settingView.backgroundColor = [UIColor clearColor];
    settingView.layer.cornerRadius = 10.0f;
    settingView.layer.borderWidth = 2.0f;
//    settingView.layer.borderColor = UIColor.LightGray.CGColor;
    settingView.layer.shadowOpacity = 0.2; // 濃さを指定
    settingView.layer.shadowOffset = CGSizeMake(10.0, 10.0); // 影までの距離を指定

    // 戻るボタン(次のビュー用)
    UIBarButtonItem * barItemBack = [UIBarButtonItem new];
    barItemBack.title = S_BUTTON_BACK;
    self.navigationItem.backBarButtonItem = barItemBack;

    // スキャナーの設定情報を取得
    [self createConnectUrl];

    // ボタン１のラベルを変更
    [self.m_pbtnFirst setTitle:S_BUTTON_REMOTESCAN_READY forState:UIControlStateNormal];
//    // アイコン変更
//    NSString* scanReadyIcon = S_ICON_RS_SCANREADY;
//    [self.m_pbtnFirst setImage:[UIImage imageNamed:scanReadyIcon] forState:UIControlStateNormal];

    // ボタン2をスクロールビュー内に配置し直す
    [self replaceMenuButton:PrvMenuIDSecond];

    // メニュー作成
    NSString* pstrBtnName = S_BUTTON_NO_SCANNER;      // ボタン名称
    NSString* pstrIconName;     // アイコン名称
    NSString* pstrLabelName;    // ラベル名称 iPad用
    for (NSInteger nCnt = PrvMenuIDThird; nCnt <= PrvMenuIDEighth; nCnt++)
    {
        switch (nCnt)
        {
            case PrvMenuIDThird:
                pstrBtnName = S_RS_XML_COLORMODE_AUTO;
                pstrLabelName = S_TITLE_COLORMODE;
                pstrIconName = S_ICON_RS_COLORMODE;
                break;
            case PrvMenuIDFourth:
                pstrBtnName = S_RS_XML_AUTO;
                pstrLabelName = S_TITLE_MANUSCRIPT;
                pstrIconName = S_ICON_RS_MANUSCRIPT;
                break;
            case PrvMenuIDFifth:
                pstrBtnName = S_RS_XML_DUPLEX_MODE_SIMPLEX;
                pstrLabelName = S_TITLE_BOTH;
                pstrIconName = S_ICON_RS_BOTHSIDES;
                break;
            case PrvMenuIDSixth:
                pstrBtnName = S_RS_XML_FILE_FORMAT_PDF;
                pstrLabelName = S_TITLE_FORMAT;
                pstrIconName = S_ICON_RS_FORMAT;
                break;
            case PrvMenuIDSeventh:
                pstrBtnName = S_RS_XML_RESOLUTION_200;
                pstrLabelName = S_TITLE_RESOLUTION;
                pstrIconName = S_ICON_RS_PPI;
                break;
            case PrvMenuIDEighth:
                pstrBtnName = S_BUTTON_OTHER;
                pstrLabelName = nil;
                pstrIconName = nil;
                break;
            default:
                break;
        }

        [super CreateMenu:nCnt
                  btnName:pstrBtnName
                 iconName:pstrIconName
                  lblName:pstrLabelName];

        // メニューボタンをスクロールビュー内に配置し直す
        [self replaceMenuButton:nCnt];
    }

    // メニュースクロールビューの設定
    menuScrollView.delegate = self;
    menuScrollView.contentSize = (CGSize){menuScrollView.frame.size.width, self.m_pbtnEighth.frame.origin.y + self.m_pbtnEighth.frame.size.height};
    menuScrollView.bounces = NO;
    [self scrollViewDidScroll:menuScrollView animated:NO];

    // メニューのビューを指定
    m_pMenuView = menuScrollView;


    // 吹き出し
    UIImage* fukidashiImg = [UIImage imageNamed:@"fukidashi.png"];
    fukidashiView = [[UIImageView alloc]initWithImage:fukidashiImg];
    fukidashiView.frame = (CGRect){CGPointZero, fukidashiImg.size.width, self.m_pbtnThird.frame.size.height};
    [menuScrollView addSubview:fukidashiView];
    DLog(@"fukidashiView.frame:%@", NSStringFromCGRect(fukidashiView.frame));

    // 初期は未選択なので、設定表示ビューと吹き出しを非表示
    settingView.hidden = fukidashiView.hidden = YES;

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
    nStatus = RSSTATUS_GETJOBSETTABLEELEMENTS_IPAD;

    // 初回エラーフラグの初期化
    bFirstErr_Network = YES;

    // ボタンを非活性にする
    [self setAllButtonEnable:NO];
    
    if([self getIPAdder])
    {
        nStatus = RSSTATUS_GETJOBSETTABLEELEMENTS_IPAD;
//        // しばらくお待ちくださいダイアログを出す
//        [self createProgressionAlertWithMessage:nil message: MSG_WAIT withCancel:YES];
//        alert.tag = ALERT_TAG_WAIT_IPAD;
        
        [self startGetMfpIf];
    } else {
        // WIFI接続なし時エラー
        [self showErrorAlertOnMainThreadWithMessage:MSG_NETWORK_ERR tag:ALERT_TAG_WIFI_NO_CONNECTION_IPAD];
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
    [super InitView:[CommonUtil getSSID] menuBtnNum:PrvMenuIDEighth hidesBackButton:NO hidesSettingButton:YES];
    
    [self doReset];
    // スクロールボタンの表示/非表示
    [self scrollViewDidScroll:menuScrollView animated:NO];
    
    if(m_pManuscriptVC){
        if([m_pManuscriptVC isKindOfClass:[RSS_ManuscriptViewController_iPad class]]){
            
            [self clearSettingView];
            
            NSString* paperName = [rsManager.rsSettableElementsData.originalSizeData.getCapableOptions objectForKey:strOriginalSize];
            if(paperName){
                m_pManuscriptVC.strOriginalSize = paperName;
            }else if([strOriginalSize isEqualToString:@"unknown"] || [strOriginalSize isEqualToString:@"JAM"]){
                m_pManuscriptVC.strOriginalSize = S_RS_UNKNOWN;
            }else{
                m_pManuscriptVC.strOriginalSize = strOriginalSize;
            }
            
            [settingView addSubview:m_pManuscriptVC.view];
            
            // ここでデータの更新を行う(RSS_ManuscriptViewController_iPadクラスのviewWillAppearを参照)
            // なぜか addSubview で viewWillAppear がコールされないので自前でコールする
            // (初回に原稿画面を表示する際の addSubviewではコールされる)
            [m_pManuscriptVC viewWillAppear:animated];
            
            self.navigationItem.title = S_TITLE_MANUSCRIPT;
            selectedVC = m_pManuscriptVC;
            // タイマーの確認
            if(originalSizePollingTimer == nil)
            {
                if(![originalSizePollingTimer isValid])
                {
                    // デバイスにセットされている用紙サイズ取得ポーリングを開始
                    originalSizePollingTimer = [NSTimer scheduledTimerWithTimeInterval:2 target:self selector:@selector(rsGetDeviceStatusPolling) userInfo:nil repeats:YES];
                }
            }
        }
    }

    // 原稿を再表示する（カスタムサイズの内容が変更されている場合など）
    if ([[rssViewData.originalSize getSelectValueName] length]) {
        [self.m_pbtnFourth setTitle:[rssViewData.originalSize getSelectValueName] forState:UIControlStateNormal];
    }
    
    if(bNavRightBtn)
    {
        if([self getIPAdder])
        {
            
            [self rsGetJobSettableElements];
            
//            [self startGetMfpIf];
            [self performSelector:@selector(startGetMfpIf) withObject:nil afterDelay:0.5];

        } else {
            // WIFI接続なしエラー
            [self showErrorAlertOnMainThreadWithMessage:MSG_NETWORK_ERR tag:ALERT_TAG_WIFI_NO_CONNECTION_IPAD];
        }
        bNavRightBtn = NO;
    }

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

// メニューをスクロールビュー内に再配置する
-(void)replaceMenuButton:(NSInteger)menuId
{
    UIButton* btn = nil;
    UILabel* lbl = nil;
    UIImageView* img = nil;
    switch (menuId)
    {
        case PrvMenuIDSecond:
            btn = self.m_pbtnSecond;
            lbl = m_plblSecond;
            img = m_pimgSecond;
            break;
        case PrvMenuIDThird:
            btn = self.m_pbtnThird;
            lbl = m_plblThird;
            img = m_pimgThird;
            break;
        case PrvMenuIDFourth:
            btn = self.m_pbtnFourth;
            lbl = m_plblFourth;
            img = m_pimgFourth;
            break;
        case PrvMenuIDFifth:
            btn = self.m_pbtnFifth;
            lbl = m_plblFifth;
            img = m_pimgFifth;
            break;
        case PrvMenuIDSixth:
            btn = self.m_pbtnSixth;
            lbl = m_plblSixth;
            img = m_pimgSixth;
            break;
        case PrvMenuIDSeventh:
            btn = self.m_pbtnSeventh;
            lbl = m_plblSeventh;
            img = m_pimgSeventh;
            break;
        case PrvMenuIDEighth:
            btn = self.m_pbtnEighth;
            break;
        default:
            break;
    }

    if(btn){
        // ボタンを再配置
        [self replaceToScrollView:btn];
        DLog(@"btn.frame:%@", NSStringFromCGRect(btn.frame));
        // ラベルを再配置
        [self replaceToScrollView:lbl];
        DLog(@"lbl.frame:%@", NSStringFromCGRect(lbl.frame));
        // アイコンを再配置
        [self replaceToScrollView:img];
        DLog(@"img.frame:%@", NSStringFromCGRect(img.frame));
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

-(void)viewWillDisappear:(BOOL)animated
{
    DLog(@"viewWillDisappear");

    // 遅延実行処理をキャンセル
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(startGetMfpIf) object:nil];
//
//    // オブジェクト存在時は解放する
//    if ( pollingRsManager ) {
//        [pollingRsManager disconnect];  // ポーリングキャンセル
//        pollingRsManager.parserDelegate = nil;
//        pollingRsManager = nil;
//    }
//    
//    // キャンセル
//    if (requestUISessionIdManager) {
//        [requestUISessionIdManager disconnect];
//        requestUISessionIdManager.parserDelegate = nil;
//        requestUISessionIdManager = nil;
//    }
//    if (rsManager) {
//        [rsManager disconnect];
//        rsManager.parserDelegate = nil;
//        rsManager = nil;
//    }
//    if (mfpManager) {
//        [mfpManager disconnect];
//        mfpManager.parserDelegate = nil;
//        mfpManager = nil;
//    }
//    if (mfpServiceManager) {
//        [mfpServiceManager disconnect];
//        mfpServiceManager.parserDelegate = nil;
//        mfpServiceManager = nil;
//    }
//    rssViewData = nil;
//
    [super viewWillDisappear:animated];
}
-(void)viewDidDisappear:(BOOL)animated
{
    DLog(@"viewDidDisappear");
    [super viewDidDisappear:animated];
}

- (void)viewDidUnload
{
    selectedVC = nil;

    if(pollingRsManager){
        [pollingRsManager disconnect];  // ポーリングキャンセル
        pollingRsManager.parserDelegate = nil;
        pollingRsManager = nil;
    }

    if(m_pColorModeVC){
        m_pColorModeVC = nil;
    }

    if(m_pManuscriptVC){
        m_pManuscriptVC.parentVCDelegate = nil;
        m_pManuscriptVC = nil;
    }

    if(m_pBothOrOneSideVC){
        m_pBothOrOneSideVC = nil;
    }

    if(m_pFormatVC){
        m_pFormatVC = nil;
    }

    if(m_pResolutionVC){
        m_pResolutionVC = nil;
    }

    if(m_pOtherVC){
        m_pOtherVC = nil;
    }

    if (rsManager) {
        rsManager.parserDelegate = nil;
        rsManager.delegate = nil;
        rsManager = nil;
    }

    if (releaseUISessionIdManager) {
        releaseUISessionIdManager.parserDelegate = nil;
        releaseUISessionIdManager = nil;
    }
    
    if (requestUISessionIdManager) {
        requestUISessionIdManager.parserDelegate = nil;
        requestUISessionIdManager = nil;
    }

    if (setDeviceContextManager) {
        setDeviceContextManager.parserDelegate = nil;
        setDeviceContextManager = nil;
    }

    if (executeJobManager) {
        executeJobManager.parserDelegate = nil;
        executeJobManager = nil;
    }

    if (getJobStatusManager) {
        getJobStatusManager.parserDelegate = nil;
        getJobStatusManager = nil;
    }
    
    if (cancelJobManager) {
        cancelJobManager.parserDelegate = nil;
        cancelJobManager = nil;
    }

    if (resumeJobManager) {
        resumeJobManager.parserDelegate = nil;
        resumeJobManager = nil;
    }

    settingView = nil;
    menuScrollView = nil;
    menuUpBtn = nil;
    menuDownBtn = nil;
    whiteView = nil;
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
	return YES;
}

- (void)dealloc {
    // キーボード監視を終了
    [self removeForKeyboardNotifications];

    if ( pollingRsManager ) {
        [pollingRsManager disconnect];  // ポーリングキャンセル
        pollingRsManager.parserDelegate = nil;
        pollingRsManager = nil;
    }
    if (rsManager) {
        rsManager.parserDelegate = nil;
        rsManager.delegate = nil;
        rsManager = nil;
    }
    if (requestUISessionIdManager) {
        [requestUISessionIdManager disconnect];
        requestUISessionIdManager.parserDelegate = nil;
        requestUISessionIdManager = nil;
    }
    if (mfpManager) {
        [mfpManager disconnect];
        mfpManager.parserDelegate = nil;
        mfpManager = nil;
    }
    if (mfpServiceManager) {
        [mfpServiceManager disconnect];
        mfpServiceManager.parserDelegate = nil;
        mfpServiceManager = nil;
    }
    if (releaseUISessionIdManager) {
        releaseUISessionIdManager.parserDelegate = nil;
    }
    if (setDeviceContextManager) {
        setDeviceContextManager.parserDelegate = nil;
    }
    if (executeJobManager) {
        executeJobManager.parserDelegate = nil;
    }
    if (getJobStatusManager) {
        getJobStatusManager.parserDelegate = nil;
    }
    if (cancelJobManager) {
        cancelJobManager.parserDelegate = nil;
    }
    if (resumeJobManager) {
        resumeJobManager.parserDelegate = nil;
    }
    
}

-(void)doReset
{
    if(nStatus == RSSTATUS_INIT_IPAD)
    {
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
        if(scanerPickerRow < 0){
            scanerPickerRow = m_pPrinterMgr.DefaultMFPIndex;
        }
        if(!self.canceled)
        {
            printerData = [m_pPrinterMgr LoadPrinterDataAtIndexInclude2:scanerPickerRow];
        
            // リモートスキャン対応MFPかどうかチェック
            if(![CommonUtil isCapableRemoteScan:printerData])
            {
            // リモートスキャン非対応MFPなので通常取り込みが面へ遷移
                [self performSelector:@selector(remoteScanToNomalScan) withObject:nil afterDelay:0.5f];
                return;
            }
        }
        self.canceled = NO;
        
        // 取り込み後画面からキャンセルで戻ってきたときなど、
        // やり直す
        
        // ボタンを非活性にする
        [self setAllButtonEnable:NO];
        
        if([self getIPAdder])
        {
            nStatus = RSSTATUS_GETJOBSETTABLEELEMENTS_IPAD;
            if(!bNavRightBtn)
            {
                // しばらくお待ちくださいダイアログを出す
                [self createProgressionAlertWithMessage:nil message: MSG_WAIT withCancel:YES tag:ALERT_TAG_WAIT_IPAD];
            }
            
            // ボタンを非活性にする
            [self setAllButtonEnable:NO];
            
            [self createConnectUrl];
            
            // リモートスキャン中フラグを初期化
            bRemoteScanRunning = NO;
            bRemoteScanCanceled = YES;
            strOriginalSize = @"unknown";
            
            // 先頭処理からやり直し
            nStatus = RSSTATUS_GETJOBSETTABLEELEMENTS_IPAD;
            [self rsGetJobSettableElements];
            
            // 設定画面から戻ってきた場合は記憶しておかない
            m_pManuscriptVC = nil;
            m_pColorModeVC = nil;
            m_pManuscriptVC = nil;
            m_pCustomSizeListVC = nil;
            m_pBothOrOneSideVC = nil;
            m_pFormatVC = nil;
            m_pResolutionVC = nil;
            m_pOtherVC = nil;
            // 設定ビューの非表示
            settingView.hidden = fukidashiView.hidden = YES;
            whiteView.hidden = NO;
            self.navigationItem.title = [CommonUtil getSSID];
        } else {
            // WIFI接続なし時エラー
            [self showErrorAlertOnMainThreadWithMessage:MSG_REMOTESCAN_NETWORK_ERROR_AND_EXIT tag:ALERT_TAG_NETWORKERROR_AND_EXIT_IPAD];
        }
        //
        // PROFILE情報の取得
        //
        profileDataManager = [[ProfileDataManager alloc] init];
        ProfileData *profileData = nil;
        profileData = [profileDataManager loadProfileDataAtIndex:0];
        
        // 表示名、確認コードの取得
//        strProfileName = [[CommonUtil trimString:profileData.profileName halfCharNumber:MAXPROFILENAMELENGTH] copy];
        strProfileName = [profileData.profileName copy];
        if(!profileData.autoCreateVerifyCode || profileData.verifyCode == nil || [profileData.verifyCode isEqualToString:@""])
        {
            strVerifyCode = [[CommonUtil createRandomNumber:9999] copy];
        }
        else
        {
            strVerifyCode = [profileData.verifyCode copy];
        }
    }
}

// 準備完了メッセージボックス表示
- (void)CreateAllertWithCancelAndOtherButton:(NSString*)pstrTitle
                       message:(NSString*)pstrMsg
                cancelBtnTitle:(NSString*)pstrCancelBtnTitle
                 startBtnTitle:(NSString*)pstrStartBtnTitle
                       withTag:(NSInteger)nTag
{
    SharpScanPrintAppDelegate* appDelegate = (SharpScanPrintAppDelegate*)[[UIApplication sharedApplication] delegate];
    // 処理実行フラグON
    appDelegate.IsRun = TRUE;

    [self makePictureAlert:nil message:pstrMsg cancelBtnTitle:pstrCancelBtnTitle okBtnTitle:pstrStartBtnTitle tag:nTag showFlg:YES];
}

- (void)createConnectUrl
{
    if(selectMfpRSPortNo == nil || [selectMfpRSPortNo isEqualToString:@""]){
        selectMfpRSPortNo = @"10080";
    }
    
    NSDictionary *dicIPAddr = [CommonUtil getIPAddrDicForComm:selectMfpIpAddress port:selectMfpRSPortNo];
    connectUrl = [[NSURL alloc]initWithString:[NSString stringWithFormat:@"http://%@:%d/", [CommonUtil optIPAddrForComm:[dicIPAddr objectForKey:S_TARGET_IPADDRESS_DIC_KEY]], [selectMfpRSPortNo intValue]]];
    
    DLog(@"connectURL: %@", connectUrl);
}

- (void)setManuscriptStartEnabled:(BOOL) enabled
{
    if (bShowingManuscriptDialog)
    {
        if (picture_alert != nil) {
            [picture_alert dismissViewControllerAnimated:YES completion:^{
                [self alertButtonDismiss:picture_alert tagIndex:picture_alert.tag buttonIndex:2];
                [self checkVerifyCode:enabled];
            }];
            picture_alert = nil;
        } else {
            [self checkVerifyCode:enabled];
        }
    }
}

- (void)checkVerifyCode:(BOOL) enabled
{
    // 確認コードがnilの場合は空文字列を表示する
    NSString * showVerifyCode = strVerifyCode ? strVerifyCode : @"";
    NSString* strMessage = [[NSString alloc] init];
    if (enabled)
    {
        strMessage = [NSString stringWithFormat:MSG_REMOTESCAN_CONFIRM, strProfileName, showVerifyCode];
        if ([rssViewData.specialMode isMultiCropOn]) {
            strMessage = [strMessage stringByAppendingString:[NSString stringWithFormat:@"\n\n%@", MSG_REMOTESCAN_CONFIRM_MULTICROP_ALERT]];
        }
        [self CreateAllertWithCancelAndOtherButton:nil message:strMessage cancelBtnTitle:MSG_BUTTON_CANCEL startBtnTitle:S_RS_SCAN withTag:ALERT_TAG_SCANBEFORE_IPAD];
    }
    else
    {
        strMessage = [NSString stringWithFormat:MSG_REMOTESCAN_WAIT, strProfileName, showVerifyCode];
        [self CreateAllertWithCancelAndOtherButton:nil message:strMessage cancelBtnTitle:MSG_BUTTON_CANCEL startBtnTitle:nil withTag:ALERT_TAG_SCANBEFORE_IPAD];
    }
    bShowingManuscriptDialog = YES;
}

- (void)setJammingDialogEnabled:(BOOL) enabled count:(NSString*) jamCount
{
    if(enabled)
    {
        NSString* strMessage = [NSString stringWithString:MSG_REMOTESCAN_JAMCLEAR];

        if (picture_alert != nil) {

            if([picture_alert.message isEqualToString:strMessage])
            {
                // 既にJAM解消ダイアログが出ていれば何もしない
                return;
            }

            [picture_alert dismissViewControllerAnimated:YES completion:^{
                [self alertButtonDismiss:picture_alert tagIndex:picture_alert.tag buttonIndex:2];
                [self CreateAllertWithCancelAndOtherButton:nil message:strMessage cancelBtnTitle:MSG_BUTTON_CANCEL startBtnTitle:S_RS_SCAN withTag:ALERT_TAG_JAMMING_IPAD];
            }];
            picture_alert = nil;
        } else {
            [self CreateAllertWithCancelAndOtherButton:nil message:strMessage cancelBtnTitle:MSG_BUTTON_CANCEL startBtnTitle:S_RS_SCAN withTag:ALERT_TAG_JAMMING_IPAD];
        }
    }
    else
    {
        NSString* strMessage = [NSString stringWithFormat:MSG_REMOTESCAN_JAMED, jamCount];
        if (picture_alert != nil) {

            if([picture_alert.message isEqualToString:strMessage])
            {
                // 既に同一ダイアログが出ていれば何もしない
                return;
            }

            [picture_alert dismissViewControllerAnimated:YES completion:^{
                [self alertButtonDismiss:picture_alert tagIndex:picture_alert.tag buttonIndex:2];
                [self CreateAllertWithCancelAndOtherButton:nil message:strMessage cancelBtnTitle:MSG_BUTTON_CANCEL startBtnTitle:nil withTag:ALERT_TAG_JAMMING_IPAD];
            }];
            picture_alert = nil;
        } else {
            [self CreateAllertWithCancelAndOtherButton:nil message:strMessage cancelBtnTitle:MSG_BUTTON_CANCEL startBtnTitle:nil withTag:ALERT_TAG_JAMMING_IPAD];
        }
    }
}

// FTPサーバ起動
-(void)startFtpServer
{
    // FTP 接続
    ftpmanager = [[FtpServerManager  alloc] init];	// インスタンス取得
    super.ScanFileName	= nil;

    // Debug用に固定
    m_ScanUser = S_FTP_USER;
    m_ScanPass = self.ScanPass;
    
    // デバック時はパスワードを固定
//    m_ScanPass = S_FTP_SPECIAL_PASSWORD;

    [ftpmanager	startFTP:m_ScanUser
            requserpass	:m_ScanPass
            initWithPort:N_FTP_PORT
                 withDir:self.baseDir
            notifyObject:self];
}

// FTPサーバ終了
-(void)stopFtpServer
{
    if(ftpmanager)
    {
        [ftpmanager stopFTP];
        ftpmanager = nil;
    }
}

-(void)setAllButtonEnable:(BOOL) enable
{
    self.m_pbtnFirst.enabled = enable;
    // スキャナーボタンは制御しない
//    self.m_pbtnSecond.enabled = enable;
    self.m_pbtnThird.enabled = enable;
    if ([rssViewData.specialMode isMultiCropOn]) {
        self.m_pbtnFourth.enabled = NO;
        self.m_pbtnFifth.enabled = NO;
    }
    else {
        self.m_pbtnFourth.enabled = enable;
        self.m_pbtnFifth.enabled = enable;
    }
    self.m_pbtnSixth.enabled = enable;
    self.m_pbtnSeventh.enabled = enable;
    self.m_pbtnEighth.enabled = enable;
}

-(void)setFirstButtonEnable
{
    self.m_pbtnFirst.enabled = YES;
}

//-(void)setChangeSelectMfp:(BOOL) value
//{
//    bChangeSelectMfp = value;
//}

// フォーマット画面のパスワードのチェックを行い、エラーダイアログを表示する
-(BOOL)isValidPdfPassword
{
    BOOL result = YES;
    
    // 暗号化がオフの場合はチェックしない
    if (![rssViewData.formatData isEncript])
    {
        return YES;
    }
    
    // フォーマットがpdf以外の場合は暗号化の設定ができないため、パスワードのチェックをしない
    NSString *selectedFormat = [rssViewData.formatData getDisplayFormatKey:rssViewData.colorMode
                                                              originalSize:rssViewData.originalSize];
    if (![selectedFormat isEqualToString:@"pdf"])
    {
        return YES;
    }
    
    if(selectedVC && selectedVC == m_pFormatVC && [rssViewData.formatData isEncript])
    {
        // 暗号化PDF時のパスワードチェック
        NSString* encPassword = [rssViewData.formatData getSelectEncryptValue];
        if([encPassword isEqualToString:@""])
        {
            // 必須ですエラー
            result = NO;
            
            [self makeTmpExAlert:nil message:[NSString stringWithFormat:MSG_REQUIRED_ERR, SUBMSG_PDFPASSWORD_ERR] cancelBtnTitle:MSG_BUTTON_OK okBtnTitle:nil tag:0];

            
        } else if([encPassword length] > 32)
        {
            // 最大長エラー
            result = NO;
            
            [self makeTmpExAlert:nil message:[NSString stringWithFormat:MSG_LENGTH_ERR, SUBMSG_PDFPASSWORD_ERR, SUBMSG_PDFPASSWORD_MAXLENGTH] cancelBtnTitle:MSG_BUTTON_OK okBtnTitle:nil tag:0];

        } else if(![CommonUtil isAplhanumeric:encPassword])
        {
            // 半角英数字以外エラー
            DLog(@"暗号化パスワードフォーマット");
            result = NO;
            
            [self makeTmpExAlert:nil message:[NSString stringWithFormat:MSG_CHAR_TYPE_ERR, SUBMSG_PDFPASSWORD_ERR, SUBMSG_PDFPASSWORD_FORMAT] cancelBtnTitle:MSG_BUTTON_OK okBtnTitle:nil tag:0];
        }
    }
    
    return result;
}

-(BOOL)getIPAdder
{
    BOOL result = YES;
    
    self.iPaddr	= @"";
    NSDictionary *dicIPAddr = [CommonUtil getIPAddrDicForComm:selectMfpIpAddress port:selectMfpRSPortNo];
    self.iPaddr = [dicIPAddr objectForKey:S_MY_IPADDRESS_DIC_KEY];
    
    NSUInteger len = [[self.iPaddr stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] length];
    if (len <= 0)
    {
        result = NO;
    }
    
    return  result;
}

-(BOOL)isRemoteScanRunning
{
    return NO;
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
    // 押下時に非活性にし、1秒後に活性に戻す
    self.m_pbtnFirst.enabled = NO;
    [self performSelector:@selector(setFirstButtonEnable) withObject:nil afterDelay:1.0f];
    
    // 処理中あるいは処理中断フラグ=TRUEの場合は何もしない
    if (m_pThread || m_bAbort)
    {
        return;
    }
    
    // パスワードの入力チェック
    if(![self isValidPdfPassword])
    {
        return;
    }
    
    // 原稿サイズと保存サイズの整合性をチェック処理用
    PaperSetMatrix* paperMatrix = [[PaperSetMatrix alloc] init];
    [paperMatrix setMatirx];
    BOOL paperSetCheck =  [paperMatrix originalSize:[rssViewData.originalSize getSelectValue]
                                           sendSize:[rssViewData.sendSize getSelectValue]
                                           rotation:[rssViewData.rotation getSelectValue]];
    
    BOOL originalSizeLong = [rssViewData.originalSize isLong];
    BOOL duplex = [[rssViewData.duplexData getSelectValue] isEqualToString:@"duplex+book"]
    || [[rssViewData.duplexData getSelectValue] isEqualToString:@"duplex+tablet"];
    BOOL specialMode = [[rssViewData.specialMode getSelectValue] isEqualToString:@"blank_page_skip"]
    || [[rssViewData.specialMode getSelectValue] isEqualToString:@"blank_and_back_shadow_skip"];
    
    BOOL originalSizeManual = [[rssViewData.originalSize getSelectValue] isEqualToString:@"japanese_postcard_a6"]
    || [[rssViewData.originalSize getSelectValue] isEqualToString:@"extraSize1"]
    || [[rssViewData.originalSize getSelectValue] isEqualToString:@"extraSize2"]
    || [[rssViewData.originalSize getSelectValue] isEqualToString:@"extraSize3"]
    || [[rssViewData.originalSize getSelectValue] isEqualToString:@"extraSize4"];
    
    BOOL originalSizeCustom = [[rssViewData.originalSize getSelectValue] isEqualToString:@"customSize1"]
    || [[rssViewData.originalSize getSelectValue] isEqualToString:@"customSize2"]
    || [[rssViewData.originalSize getSelectValue] isEqualToString:@"customSize3"]
    || [[rssViewData.originalSize getSelectValue] isEqualToString:@"customSize4"]
    || [[rssViewData.originalSize getSelectValue] isEqualToString:@"customSize5"];
    
    // 選択した原稿サイズの横、縦
    NSInteger nSelectSizeWidth = 0;
    NSInteger nSelectSizeHeight = 0;
    {
        if([[rssViewData.originalSize getSelectValue]rangeOfString:@"extraSize"].location != NSNotFound)
        {
            nSelectSizeWidth = [[rssViewData.extraSizeListData getCustomPaperSizeData:[rssViewData.originalSize getSelectValue]]getMilliWidth];
            nSelectSizeHeight = [[rssViewData.extraSizeListData getCustomPaperSizeData:[rssViewData.originalSize getSelectValue]]getMilliHeight];
            
        }else if([[rssViewData.originalSize getSelectValue]rangeOfString:@"customSize"].location != NSNotFound)
        {
            nSelectSizeWidth = [[rssViewData.customSizeListData getCustomPaperSizeData:[rssViewData.originalSize getSelectValue]]getMilliWidth];
            nSelectSizeHeight = [[rssViewData.customSizeListData getCustomPaperSizeData:[rssViewData.originalSize getSelectValue]]getMilliHeight];
            
        }else if([[rssViewData.originalSize getSelectValue]rangeOfString:@"japanese_postcard_a6"].location != NSNotFound)
        {
            nSelectSizeWidth = JAPANESE_POSTCARD_A6_WIDTH;
            nSelectSizeHeight = JAPANESE_POSTCARD_A6_HEIGHT;
        }
    }
    
    if([strOriginalSize isEqualToString:@"JAM"])
    {
        // MFPがJAM中の場合は、エラーとする
        [self CreateAllert:nil message:MSG_REMOTESCAN_JAMMING_ERR btnTitle:MSG_BUTTON_OK];
        return;
    }else if (!paperSetCheck)
    {
        [self CreateAllert:nil message:MSG_REMOTESCAN_PAPER_SETTING_ERR btnTitle:MSG_BUTTON_OK];
        return;
    } else if(duplex && originalSizeLong) {
        // 両面オンかつ長尺
        
        //　GetDeviceStatusのポーリング処理は続行する
        [super CreateAllert:nil message:MSG_REMOTESCAN_NOTUSE btnTitle:MSG_BUTTON_OK];
        return;
        
    } else if(specialMode && originalSizeLong) {
        // 白紙とばしオンかつ長尺
        
        //　GetDeviceStatusのポーリング処理は続行する
        [super CreateAllert:nil message:MSG_REMOTESCAN_NOTUSE btnTitle:MSG_BUTTON_OK];
        return;
    } else if(duplex && (originalSizeManual || (originalSizeCustom && (nSelectSizeWidth < [pstrDetectableMinWidth intValue] || nSelectSizeHeight < [pstrDetectableMinHeight intValue])))) {
        // 両面オンかつ（マニュアルサイズまたは、検知可能サイズより小さいカスタムサイズ）
        
        //　GetDeviceStatusのポーリング処理は続行する
        [super CreateAllert:nil message:MSG_REMOTESCAN_NOTUSE btnTitle:MSG_BUTTON_OK];
        return;
    }
    
    SharpScanPrintAppDelegate* appDelegate = (SharpScanPrintAppDelegate*)[[UIApplication sharedApplication] delegate];
    appDelegate.IsRun = TRUE;

    m_isScanStop = FALSE;

    // プリンタ情報が取得できなければ何もしない
    PrinterData* printerData = nil;
    printerData = [m_pPrinterMgr LoadPrinterDataAtIndexInclude2:self.m_nSelPickerRow2];
    if (printerData == nil)
    {
        m_isScanStop = TRUE;
        [self CreateAllert:nil message:MSG_SCAN_REQ_ERR btnTitle:MSG_BUTTON_OK];
        return;
    }
    
    if([self getIPAdder])
    {
        nStatus = RSSTATUS_REQUESTUISESSIONID_IPAD;
        nSetDeviceRetryCount = 0;
        
        // しばらくお待ちくださいダイアログを出す
        [self createProgressionAlertWithMessage:nil message: MSG_WAIT withCancel:YES tag:ALERT_TAG_SETDEVICECONTEXT_WAIT_IPAD];
        
        [self rsRequestUISessionId];
    } else {
        [self showNetworkAlert];
    }

}

// カラーモード
- (IBAction)OnMenuThirdButton:(id)sender
{
    // パスワードの入力チェック
    if(![self isValidPdfPassword])
    {
        return;
    }

    if(selectedVC && selectedVC == m_pColorModeVC){

        if(!settingView.hidden){
            // 設定ビューの非表示設定はアニメーション後に設定している

            self.navigationItem.title = [CommonUtil getSSID];

            // メニュービュー非表示アニメーション
            [self hideMenuViewAnimation];

        }else{
            // 設定ビューの表示
            settingView.hidden = fukidashiView.hidden = !settingView.hidden;
            whiteView.hidden = ! settingView.hidden;

            self.navigationItem.title = S_TITLE_COLORMODE;

            // メニュービュー表示アニメーション
            [self showMenuViewAnimation];

        }

    }else{

        if(!m_pColorModeVC){
            // カラーモードリスト作成
            m_pColorModeVC = [[RSS_ColorModeViewController_iPad alloc]initWithColorModeArray:[rssViewData.colorMode getSelectableArray] delegate:self];
//            m_pColorModeVC.nSelectedIndexRow = [rssViewData.colorMode getSelectIndex];
        }
        else
        {
            // TODO
        }

        [self clearSettingView];
        [settingView addSubview:m_pColorModeVC.view];
        self.navigationItem.title = S_TITLE_COLORMODE;

        // テーブルビューのサイズを端末の向き（縦横）に合うように調整
        m_pColorModeVC.view.frame = CGRectMake(0, 0, settingView.frame.size.width, settingView.frame.size.height);

        selectedVC = m_pColorModeVC;

        // 吹き出しを表示
        UIButton* menubtn = (UIButton*)sender;
        fukidashiView.center = (CGPoint){0,menubtn.center.y};
        [menuScrollView addSubview:fukidashiView];

        if ( settingView.hidden ) {
            // メニュービュー表示アニメーション
            [self showMenuViewAnimation];
        }

        settingView.hidden = fukidashiView.hidden = NO;
        whiteView.hidden = ! settingView.hidden;
    }
}

// 原稿
- (IBAction)OnMenuFourthButton:(id)sender
{
    // パスワードの入力チェック
    if(![self isValidPdfPassword])
    {
        return;
    }

    if(selectedVC && selectedVC == m_pManuscriptVC){

        if(!settingView.hidden){
            // 設定ビューの非表示設定はアニメーション後に設定している

            self.navigationItem.title = [CommonUtil getSSID];

            // メニュービュー非表示アニメーション
            [self hideMenuViewAnimation];

        }else{
            // 設定ビューの表示
            settingView.hidden = fukidashiView.hidden = !settingView.hidden;
            whiteView.hidden = ! settingView.hidden;

            self.navigationItem.title = S_TITLE_MANUSCRIPT;

            // メニュービュー表示アニメーション
            [self showMenuViewAnimation];

        }

    }else{
        
        //原稿サイズ
        NSArray* originalSizeArray = [rssViewData.originalSize getSelectableArray];
        //保存サイズ
        NSArray* sendSizeArray = [rssViewData.sendSize getSelectableArray];
        //原稿サイズ設定画面生成
        m_pManuscriptVC = [[RSS_ManuscriptViewController_iPad alloc]initWithManuscriptTypeArray:originalSizeArray saveSizeArray:sendSizeArray delegate:self];
        //
        NSString* paperName = [rsManager.rsSettableElementsData.originalSizeData.getCapableOptions objectForKey:strOriginalSize];
        //
        if(paperName){
            m_pManuscriptVC.strOriginalSize = paperName;
        }else if([strOriginalSize isEqualToString:@"unknown"] || [strOriginalSize isEqualToString:@"JAM"]){
            m_pManuscriptVC.strOriginalSize = S_RS_UNKNOWN;
        }else{
            m_pManuscriptVC.strOriginalSize = strOriginalSize;
        }
        
        [self clearSettingView];
        [settingView addSubview:m_pManuscriptVC.view];
        self.navigationItem.title = S_TITLE_MANUSCRIPT;

        // テーブルビューのサイズを端末の向き（縦横）に合うように調整
        m_pManuscriptVC.view.frame = CGRectMake(0, 0, settingView.frame.size.width, settingView.frame.size.height);

        selectedVC = m_pManuscriptVC;

        // 吹き出しを表示
        UIButton* menubtn = (UIButton*)sender;
        fukidashiView.center = (CGPoint){0,menubtn.center.y};
        [menuScrollView addSubview:fukidashiView];

        if ( settingView.hidden ) {
            // メニュービュー表示アニメーション
            [self showMenuViewAnimation];
        }

        settingView.hidden = fukidashiView.hidden = NO;
        whiteView.hidden = ! settingView.hidden;

    }
}
// カスタムサイズリスト
- (void)OnCustomSizeList
{
    m_pCustomSizeListVC = [[RSS_CustomSizeListViewController_iPad alloc] initWithStyle:UITableViewStyleGrouped delegate:self];
    [self.navigationController pushViewController:m_pCustomSizeListVC animated:YES];

    selectedVC = nil;
}

// 両面
- (IBAction)OnMenuFifthButton:(id)sender
{
    // パスワードの入力チェック
    if(![self isValidPdfPassword])
    {
        return;
    }
    
    if(selectedVC && selectedVC == m_pBothOrOneSideVC){

        if(!settingView.hidden){
            // 設定ビューの非表示設定はアニメーション後に設定している

            self.navigationItem.title = [CommonUtil getSSID];

            // メニュービュー非表示アニメーション
            [self hideMenuViewAnimation];

        }else{
            // 設定ビューの表示
            settingView.hidden = fukidashiView.hidden = !settingView.hidden;
            whiteView.hidden = ! settingView.hidden;

            self.navigationItem.title = S_TITLE_BOTH;

            // メニュービュー表示アニメーション
            [self showMenuViewAnimation];

        }
    }else{

        // すでに作成されている場合でも作成しなおすように変更。リストの内容や状態に変更がある可能性があるため。マルチクロップ対応。
        m_pBothOrOneSideVC = [[RSS_BothOrOneSideViewController_iPad alloc]initWithDuplexDataArray:rssViewData.duplexData.getSelectableArray delegate:self];
        [self clearSettingView];
        [settingView addSubview:m_pBothOrOneSideVC.view];
        self.navigationItem.title = S_TITLE_BOTH;

        // テーブルビューのサイズを端末の向き（縦横）に合うように調整
        m_pBothOrOneSideVC.view.frame = CGRectMake(0, 0, settingView.frame.size.width, settingView.frame.size.height);

        selectedVC = m_pBothOrOneSideVC;

        // 吹き出しを表示
        UIButton* menubtn = (UIButton*)sender;
        fukidashiView.center = (CGPoint){0,menubtn.center.y};
        [menuScrollView addSubview:fukidashiView];

        if ( settingView.hidden ) {
            // メニュービュー表示アニメーション
            [self showMenuViewAnimation];
        }

        settingView.hidden = fukidashiView.hidden = NO;
        whiteView.hidden = ! settingView.hidden;

    }
}

// フォーマット
- (IBAction)OnMenuSixthButton:(id)sender
{
    // パスワードの入力チェック
    if(![self isValidPdfPassword])
    {
        return;
    }

    if(selectedVC && selectedVC == m_pFormatVC){

        if(!settingView.hidden){
            // 設定ビューの非表示設定はアニメーション後に設定している

            self.navigationItem.title = [CommonUtil getSSID];

            // メニュービュー非表示アニメーション
            [self hideMenuViewAnimation];

        }else{
            // 設定ビューの表示
            settingView.hidden = fukidashiView.hidden = !settingView.hidden;
            whiteView.hidden = ! settingView.hidden;

            self.navigationItem.title = S_TITLE_FORMAT;

            // メニュービュー表示アニメーション
            [self showMenuViewAnimation];

        }

    }else{

        // すでに作成されている場合でも作成しなおすように変更。リストの内容や状態に変更がある可能性があるため。マルチクロップ対応。
        m_pFormatVC = [[RSS_FormatViewController_iPad alloc]initWithDelegate:self];
        m_pFormatVC.view.frame = settingView.bounds;
        [self clearSettingView];
        [settingView addSubview:m_pFormatVC.view];
        self.navigationItem.title = S_TITLE_FORMAT;

        // テーブルビューのサイズを端末の向き（縦横）に合うように調整
        m_pFormatVC.view.frame = CGRectMake(0, 0, settingView.frame.size.width, settingView.frame.size.height);

        selectedVC = m_pFormatVC;

        // 吹き出しを表示
        UIButton* menubtn = (UIButton*)sender;
        fukidashiView.center = (CGPoint){0,menubtn.center.y};
        [menuScrollView addSubview:fukidashiView];

        if ( settingView.hidden ) {
            // メニュービュー表示アニメーション
            [self showMenuViewAnimation];
        }

        settingView.hidden = fukidashiView.hidden = NO;
        whiteView.hidden = ! settingView.hidden;

    }
}

// 解像度
- (IBAction)OnMenuSeventhButton:(id)sender
{
    // パスワードの入力チェック
    if(![self isValidPdfPassword])
    {
        return;
    }

    if(selectedVC && selectedVC == m_pResolutionVC){

        if(!settingView.hidden){
            // 設定ビューの非表示設定はアニメーション後に設定している

            self.navigationItem.title = [CommonUtil getSSID];

            // メニュービュー非表示アニメーション
            [self hideMenuViewAnimation];

        }else{
            // 設定ビューの表示
            settingView.hidden = fukidashiView.hidden = !settingView.hidden;
            whiteView.hidden = ! settingView.hidden;

            self.navigationItem.title = S_TITLE_RESOLUTION;

            // メニュービュー表示アニメーション
            [self showMenuViewAnimation];

        }

    }else{
        
        // すでに作成されている場合でも作成しなおすように変更。リストの内容や状態に変更がある可能性があるため。マルチクロップ対応。
        m_pResolutionVC = [[RSS_ResolutionViewController_iPad alloc]initWithResolutionArray:[rssViewData.resolution getSelectableArray] delegate:self];
        m_pResolutionVC.parentVCDelegate = self;
        [self clearSettingView];
        [settingView addSubview:m_pResolutionVC.view];
        self.navigationItem.title = S_TITLE_RESOLUTION;

        // テーブルビューのサイズを端末の向き（縦横）に合うように調整
        m_pResolutionVC.view.frame = CGRectMake(0, 0, settingView.frame.size.width, settingView.frame.size.height);

        selectedVC = m_pResolutionVC;

        // 吹き出しを表示
        UIButton* menubtn = (UIButton*)sender;
        fukidashiView.center = (CGPoint){0,menubtn.center.y};
        [menuScrollView addSubview:fukidashiView];

        if ( settingView.hidden ) {
            // メニュービュー表示アニメーション
            [self showMenuViewAnimation];
        }

        settingView.hidden = fukidashiView.hidden = NO;
        whiteView.hidden = ! settingView.hidden;

    }
}

// その他の設定
- (IBAction)OnMenuEighthButton:(id)sender
{
    // パスワードの入力チェック
    if(![self isValidPdfPassword])
    {
        return;
    }

    if(selectedVC && selectedVC == m_pOtherVC){

        if(!settingView.hidden){
            // 設定ビューの非表示設定はアニメーション後に設定している

            self.navigationItem.title = [CommonUtil getSSID];

            // メニュービュー非表示アニメーション
            [self hideMenuViewAnimation];

        }else{
            // 設定ビューの表示
            settingView.hidden = fukidashiView.hidden = !settingView.hidden;
            whiteView.hidden = ! settingView.hidden;

            self.navigationItem.title = S_TITLE_OTHER;

            // メニュービュー表示アニメーション
            [self showMenuViewAnimation];

        }

    }else{

        if(!m_pOtherVC){
            m_pOtherVC = [[RSS_OtherViewController_iPad alloc]initWithColorDepthArray:[rssViewData.exposureMode getSelectableArray] blankPageArray:[rssViewData.specialMode.blankPageSkipData getSelectableArray] delegate:self];
        }
        [self clearSettingView];
        [settingView addSubview:m_pOtherVC.view];
        self.navigationItem.title = S_TITLE_OTHER;

        // テーブルビューのサイズを端末の向き（縦横）に合うように調整
        m_pOtherVC.view.frame = CGRectMake(0, 0, settingView.frame.size.width, settingView.frame.size.height);

        selectedVC = m_pOtherVC;

        // 吹き出しを表示
        UIButton* menubtn = (UIButton*)sender;
        fukidashiView.center = (CGPoint){0,menubtn.center.y};
        [menuScrollView addSubview:fukidashiView];

        if ( settingView.hidden ) {
            // メニュービュー表示アニメーション
            [self showMenuViewAnimation];
        }

        settingView.hidden = fukidashiView.hidden = NO;
        whiteView.hidden = ! settingView.hidden;

    }
}

// ボタン押下関数
// ナビゲーションバー 設定ボタン押下
- (IBAction)OnNavBarRightButton:(id)sender
{
//    bDoReset = YES;
    nStatus = RSSTATUS_INIT_IPAD;
    [self stopGetDeviceStatusPolling];

//    bChangeSelectMfp = YES;
    [super OnNavBarRightButton:(id)sender];
}

// settingViewのクリア
- (void)clearSettingView
{
    for(UIView* v in [settingView.subviews reverseObjectEnumerator]){
        [v removeFromSuperview];
    }

    // 背景設定
    UITableView *tv = [[UITableView alloc] initWithFrame:self.view.frame style:UITableViewStyleGrouped];
    tv.autoresizingMask = settingView.autoresizingMask;

//    UIView *backgroundView = tv.backgroundView;
    tv.frame = CGRectMake(0, 0, settingView.frame.size.width, settingView.frame.size.height);
    tv.layer.cornerRadius = 10.0f;
//    tv.layer.cornerRadius = 15.0f;
    [settingView addSubview:tv];
//    CGRect backgroundFrame = (CGRect){CGPointZero,settingView.frame.size};
//    [backgroundView setFrame:backgroundFrame];
    [settingView sendSubviewToBack:tv];

}

// 設定情報の更新
-(void)updateSetting
{
    // ボタン名称の設定
    // カラーモード
    [self updateBtnThirdSetting];
    
    // 原稿
    [self.m_pbtnFourth setTitle:[rssViewData.originalSize getSelectValueName] forState:UIControlStateNormal];

    // 両面
    [self.m_pbtnFifth setTitle:[rssViewData.duplexData getSelectValueName] forState:UIControlStateNormal];
    // フォーマット
    [self.m_pbtnSixth setTitle:[rssViewData.formatData getDisplayFormatName:rssViewData.colorMode originalSize:rssViewData.originalSize] forState:UIControlStateNormal];
    // 解像度
    NSString *resolutionKey = [rssViewData.resolution getSelectResolutionKey:rssViewData.formatData
                                                                   colorMode:rssViewData.colorMode
                                                                originalSize:rssViewData.originalSize];
    NSString *resolutionValue = [rssViewData.resolution getSpecifiedValueName:resolutionKey];
    [self.m_pbtnSeventh setTitle:resolutionValue
                        forState:UIControlStateNormal];
}

-(void)updateBtnThirdSetting
{
    // ボタン名称の設定
    // カラーモード
    NSString *colorModeKey = [rssViewData.colorMode getSelectColorModeKey:rssViewData.originalSize];
    NSString *colorModeValue = [rssViewData.colorMode getSpecifiedValueName:colorModeKey];
    [self.m_pbtnThird setTitle:colorModeValue forState:UIControlStateNormal];
}

-(void)setPickerValue
{
    switch (m_nSelPicker)
    {
        case PrvMenuIDSecond:
        {
            // プリンタ情報取得
            PrinterData* printerData = nil;
            printerData = [m_pPrinterMgr LoadPrinterDataAtIndexInclude2:self.m_nSelPickerRow2];
            selectedPrinterPrimaryKey = printerData.PrimaryKey;

            if(![selectMfpIpAddress isEqualToString:[printerData IpAddress]])
            {
//                bDoReset = YES;
                nStatus = RSSTATUS_INIT_IPAD;
                // 選択MFPが変わった場合
//                bChangeSelectMfp = YES;
//                [self rsReleaseUISessionId];
//                bDoGetJobSettableElements = YES;

                //selectMfpIpAddress = [[CommonUtil optIPAddrForComm:[printerData IpAddress]] copy];
                selectMfpIpAddress = [[printerData IpAddress] copy];
                selectMfpRSPortNo = [[printerData RSPortNo] copy];
                
                [self createConnectUrl];
                
                // リモートスキャン中フラグを初期化
                bRemoteScanRunning = NO;
                bRemoteScanCanceled = YES;
                strOriginalSize = @"";
                
                // GetJobSettableElementsを止める
                if (rsManager) {
                    rsManager.parserDelegate = nil;
                    rsManager = nil;
                }
                
                // GetDeviceStatusを止める
                [self stopGetDeviceStatusPolling];
                
                // リモートスキャン対応MFPかチェックする
                if(printerData.IsCapableRemoteScan)
                {
                    [self doReset];
//                    [self viewWillAppear:NO];
                } else {
                    // 通常の取り込み画面に切り替える
//                    [self remoteScanToNomalScan];
                    [self performSelector:@selector(remoteScanToNomalScan) withObject:nil afterDelay:0.5f];
                }
            }
            break;
        }
    }

    [super setPickerValue];
}

// 通常の取り込み画面へ遷移
-(void)remoteScanToNomalScan
{
    // 念のためポップオーバーが出てたら閉じる
    [self popoverClose];
    
    // プリンタ情報取得
//    PrinterData* printerData = [[[PrinterData alloc] init] autorelease];
//    printerData = [m_pPrinterMgr LoadPrinterDataAtIndexInclude2:self.m_nSelPickerRow2];

    // 通常の取り込み画面へ遷移
    SharpScanPrintAppDelegate* pAppDelegate = (SharpScanPrintAppDelegate*)[[UIApplication sharedApplication] delegate];
    UINavigationController* pRootNavController = [pAppDelegate.splitViewController.viewControllers objectAtIndex:0];
    RootViewController_iPad* rootViewController = (RootViewController_iPad*)[pRootNavController.viewControllers objectAtIndex:0];

    ScanBeforePictViewController_iPad* pScanViewController = [[ScanBeforePictViewController_iPad alloc] init];

    // 初期で選択するスキャナーを設定する
    pScanViewController.scanerPickerRow  = self.m_nSelPickerRow2;
    
    pScanViewController.selectedPrinterPrimaryKey = selectedPrinterPrimaryKey;
    
    [rootViewController ChangeDetailView:pScanViewController];
}

// メニュービュー表示アニメーション
- (void)showMenuViewAnimation {

    settingView.alpha = 0.0f;
    fukidashiView.alpha = 0.0f;

    [UIView animateWithDuration:0.25f delay:0.0f options:UIViewAnimationOptionCurveLinear animations:^{

        settingView.alpha = 1.0f;
        fukidashiView.alpha = 1.0f;

    } completion:^(BOOL finished) {


    }];

}

// メニュービュー非表示アニメーション
- (void)hideMenuViewAnimation {

    settingView.alpha = 1.0f;
    fukidashiView.alpha = 1.0f;

    [UIView animateWithDuration:0.25f delay:0.0f options:UIViewAnimationOptionCurveLinear animations:^{

        settingView.alpha = 0.0f;
        fukidashiView.alpha = 0.0f;

    } completion:^(BOOL finished) {

        if (finished) {

            // 設定ビューの非表示
            settingView.hidden = fukidashiView.hidden = !settingView.hidden;
            whiteView.hidden = ! settingView.hidden;
        }

    }];

}

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
        
        if(nStatus == RSSTATUS_RELEASEUISESSIONID_IPAD)return;
        
        switch (nStatus) {
            case RSSTATUS_REQUESTUISESSIONID_IPAD:
            default:
                nStatus = RSSTATUS_SETDEVICECONTEXT_START_IPAD;
                break;
        }
        
        // SetDeviceContextを実行
        [self rsSetDeviceContextStart];
    }

    // 設定可能な項目の取得完了
    else if([manager isKindOfClass:[RSGetJobSettableElementsManager class]])
    {
        // しばらくおまちくださいダイアログを閉じる
        if(ex_alert != nil)
        {
            // iPadの場合、しばらくおまちくださいダイアログを閉じる処理を以下で行う
            [self performSelector:@selector(callCloseAlert) withObject:nil afterDelay:1.0f];
        }
        
        [self popoverClose];
        [m_pManuscriptVC popoverClose];
        [m_pFormatVC popoverClose];
        [m_pOtherVC popoverClose];
        
        // 成功した場合は全画面のリセットを行う
        m_pManuscriptVC = nil;
        m_pColorModeVC = nil;
        m_pManuscriptVC = nil;
        m_pCustomSizeListVC = nil;
        m_pBothOrOneSideVC = nil;
        m_pFormatVC = nil;
        m_pResolutionVC = nil;
        m_pOtherVC = nil;
        
        // 設定ビューの非表示
        settingView.hidden = fukidashiView.hidden = YES;
        whiteView.hidden = NO;
        self.navigationItem.title = [CommonUtil getSSID];

        manager.parserDelegate = nil;
        [self didFinishRSGetJobSettableElementsManagerParsing];

        // ポーリングタイマー停止
        [self stopGetDeviceStatusPolling];
        
        // デバイスにセットされている用紙サイズ取得ポーリングを開始
        originalSizePollingTimer = [NSTimer scheduledTimerWithTimeInterval:2 target:self selector:@selector(rsGetDeviceStatusPolling) userInfo:nil repeats:YES];
    }

    // 複合機の状態を取得完了
    else if([manager isKindOfClass:[RSGetDeviceStatusManager class]])
    {
        RSGetDeviceStatusManager* m = (RSGetDeviceStatusManager*)manager;
        
        // 現在セットされている用紙の読み込み可能サイズを保持する
        pstrDetectableMinWidth = m.detectableMinWidth;
        pstrDetectableMinHeight = m.detectableMinHeight;
        
        // 現在セットされている原稿サイズがunknownか判別フラグを保持する
        bFeederSize = ![m.feederSize isEqualToString:@"unknown"];
        bPlatenSize = ![m.platenSize isEqualToString:@"unknown"];
        
        // 現在セットされている用紙サイズを保存する
        if([strOriginalSize isEqualToString:@""])
        {
            //                bSetPaper = ![m.size isEqualToString:@"unknown"];
            bSetPaper = ![m.feederSize isEqualToString:@"unknown"];
        }
        //            strOriginalSize = m.size;
        if([m.feederSize isEqualToString:@""] || !bFeederSize)
        {
            // feederSizeが空かunknownならplatenSizeを設定する 
            strOriginalSize = m.platenSize;
        }else
        {                
            // feederSizeを設定する
            strOriginalSize = m.feederSize;
        }
        
        // 原稿サイズ取得ポーリング
        DLog(@"strOriginalSize:%@, %d", strOriginalSize, [strOriginalSize isEqualToString:@"unknown"]);
        BOOL valueChange = (bSetPaper != ![strOriginalSize isEqualToString:@"unknown"]);
        bSetPaper = ![strOriginalSize isEqualToString:@"unknown"];
        // メッセージダイアログ表示
        if(valueChange  && [[rssViewData.originalSize getSelectValue] isEqualToString:@"auto"] && ![rssViewData.specialMode isMultiCropOn])
        {
            [self setManuscriptStartEnabled:bSetPaper];
        }
        
        // 原稿設定画面に反映
        if(m_pManuscriptVC){
            // 原稿サイズリストから表示用文字列を取得
            NSString* paperName = [rsManager.rsSettableElementsData.originalSizeData.getCapableOptions objectForKey:strOriginalSize];
            if(paperName){
                m_pManuscriptVC.strOriginalSize = paperName;
            }else if([strOriginalSize isEqualToString:@"unknown"] || [strOriginalSize isEqualToString:@"JAM"]){
                m_pManuscriptVC.strOriginalSize = S_RS_UNKNOWN;
            }else{
                m_pManuscriptVC.strOriginalSize = strOriginalSize;
            }
        }
        
        if([[rssViewData.originalSize getSelectValue] isEqualToString:@"auto"])
        {
            // 原稿サイズが自動の場合、原稿のボタンタイトルに検知サイズを表示する
            NSString* pstrBtnTitle;
            if ([rssViewData.specialMode isMultiCropOn])
            {
                // マルチクロップONの場合は検知サイズは表示しない
                pstrBtnTitle = [[NSString alloc]initWithFormat: @"%@",[rssViewData.originalSize getSelectValueName]];
            }
            else if(![strOriginalSize isEqualToString:@"unknown"] && ![strOriginalSize isEqualToString:@"JAM"])
            {
                // 用紙検知あり
                if([rsManager.rsSettableElementsData.originalSizeData.getCapableOptions objectForKey:strOriginalSize])
                {
                    //サイズ確定
                    pstrBtnTitle = [[NSString alloc]initWithFormat: @"%@(%@)",[rssViewData.originalSize getSelectValueName], [rsManager.rsSettableElementsData.originalSizeData.getCapableOptions objectForKey:strOriginalSize]];
                }
                else
                {
                    //サイズ未確定
                    pstrBtnTitle = [[NSString alloc]initWithFormat: @"%@",[rssViewData.originalSize getSelectValueName]];
                    
                }
            } else {
                // 用紙検知なし
                pstrBtnTitle = [[NSString alloc]initWithFormat: @"%@(%@)",[rssViewData.originalSize getSelectValueName], S_RS_UNKNOWN];
            }
            
            [self.m_pbtnFourth setTitle:pstrBtnTitle forState:UIControlStateNormal];
            
        }
        
        // ステータスごとの処理
        switch (nStatus) {
            case RSSTATUS_SETDEVICECONTEXT_WAIT_IPAD:
                // SetDeviceContext中はCurrentModeをチェックする
                if(![m.currentMode isEqualToString:@"remoteScanJob"])
                {
                    if (picture_alert != nil) {
                        [picture_alert dismissViewControllerAnimated:YES completion:^{
                            [self alertButtonDismiss:picture_alert tagIndex:picture_alert.tag buttonIndex:2];
                            nStatus = RSSTATUS_SETDEVICECONTEXT_END_IPAD;
                            [self showResourceNotFoundAlert];
                        }];
                    } else {
                        nStatus = RSSTATUS_SETDEVICECONTEXT_END_IPAD;
                        [self showResourceNotFoundAlert];
                    }
                }
                break;
            case RSSTATUS_EXECUTEJOB_IPAD:
                if(![m.currentMode isEqualToString:@"remoteScanJob"])
                {
                    nStatus = RSSTATUS_SETDEVICECONTEXT_END_IPAD;
                    [self showResourceNotFoundAlert];
                    
                    // ポーリングタイマー停止
                    [self stopGetDeviceStatusPolling];
                    
                    // デバイスにセットされている用紙サイズ取得ポーリングを開始
                    originalSizePollingTimer = [NSTimer scheduledTimerWithTimeInterval:2 target:self selector:@selector(rsGetDeviceStatusPolling) userInfo:nil repeats:YES];
                    
                } else {
                    // リモートスキャンシーケンス開始
                    picture_alert = nil;
                    bRemoteScanRunning = YES;
                    bRemoteScanCanceled = NO;
                    bIsJamHassei = NO;
                    bIsJamKaisho = NO;
                    
                    // FTPサーバ起動
                    [self startFtpServer];
                    [self rsExecuteJob];
                }
                break;
            default:
                break;
        }
    }

    // 端末情報の通知(スクリーンロック開始)完了
    // スクリーンロック解除完了
    else if([manager isKindOfClass:[RSSetDeviceContextManager class]])
    {
        manager.parserDelegate = nil;
        
        if(nStatus == RSSTATUS_SETDEVICECONTEXT_RETRY_IPAD)
        {
            nStatus = RSSTATUS_SETDEVICECONTEXT_START_IPAD;
        }
        
        switch (nStatus) {
            case RSSTATUS_SETDEVICECONTEXT_START_IPAD:
                if (ex_alert != nil) {
                    // アラートを閉じる
                    [ex_alert dismissViewControllerAnimated:YES completion:^{
                        [self alertButtonPushed:nil tagIndex:ex_alert.tag buttonIndex:2];
                        [self checkManuscriptStartEnabled];
                    }];
                    ex_alert = nil;
                } else {
                    [self checkManuscriptStartEnabled];
                }
                break;
                
            default:
                [self rsReleaseUISessionId];
                break;
        }
        
    }

    // スキャンジョブの開始完了
    else if([manager isKindOfClass:[RSExecuteJobManager class]])
    {
        manager.parserDelegate = nil;
        RSExecuteJobManager* m = (RSExecuteJobManager*)manager;
        jobId = m.jobId;

        // 実行中のジョブステータスを取得
        [self rsGetJobStatus];
    }

    // セッションID解放完了
    else if([manager isKindOfClass:[RSReleaseUISessionIdManager class]])
    {
        manager.parserDelegate = nil;

        sessionId = nil;
        
        switch (nStatus) {
            case RSSTATUS_EXECUTEJOB_COMPLETE_IPAD:
            {
                // スキャン終了
                dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                    // スキャン成功
                    // 現在のリモートスキャン設定を保存する
                    [rssViewData saveRemoteScanSettings];
                    
                    // FTPで受信したファイルがあるか？
                    if(super.ScanFileName != nil)
                    {
                        // 完了通知
                        [super CreateCompleteAlert];
                        //                bDoReset = YES;
                        nStatus = RSSTATUS_INIT_IPAD;
                        scanerPickerRow = -1;
                    }
                    else
                    {
                    }
                });
                
                break;
            }
            default:
                break;
        }
    }

    // キャンセルジョブ完了
    else if([manager isKindOfClass:[RSCancelJobManager class]])
    {
        manager.parserDelegate = nil;
        jobId = nil;
        
        [super CreateAllert:nil message:MSG_REMOTESCAN_CANCELING btnTitle:MSG_BUTTON_OK];

        nStatus = RSSTATUS_SETDEVICECONTEXT_END_IPAD;
        [self rsSetDeviceContextEnd];

        // ポーリングタイマー停止
        [self stopGetDeviceStatusPolling];
        
        // デバイスにセットされている用紙サイズ取得ポーリングを開始
        originalSizePollingTimer = [NSTimer scheduledTimerWithTimeInterval:2 target:self selector:@selector(rsGetDeviceStatusPolling) userInfo:nil repeats:YES];
    }

    // レジュームジョブ完了
    else if([manager isKindOfClass:[RSResumeJobManager class]])
    {
        manager.parserDelegate = nil;
    }
    else if([manager isKindOfClass:[RSmfpifManager class]])
    {
        //        manager
        if([mfpManager isCapableNetScan]){
            m_pPrinterInfo.IsCapableRemoteScan = [mfpManager isCapableRemoteScan];
        }
        [self startGetMfpIfService];
        
    }
    else if([manager isKindOfClass:[RSmfpifServiceManager class]])
    {
        m_pPrinterInfo.RSPortNo = [mfpServiceManager.portNo copy];
        
        // ダイアログ表示のため、ちょっとだけ待つ
        [NSThread sleepForTimeInterval:1.0];
        [picture_alert dismissViewControllerAnimated:YES completion:^{
            [self alertButtonDismiss:picture_alert tagIndex:picture_alert.tag buttonIndex:1];
        }];
        picture_alert = nil;
        
        PrinterData* printerData = [m_pPrinterMgr LoadPrinterDataAtIndexInclude2:self.m_nSelPickerRow2];
        
        // デバイスがリモートスキャン対応か確認する
        if (m_pPrinterInfo.IsCapableRemoteScan) {
            NSLog(@"[printerData RSPortNo]:%@ m_pPrinterInfo.RSPortNo:%@", [printerData RSPortNo], mfpServiceManager.portNo);
            if (![[printerData RSPortNo] isEqualToString:mfpServiceManager.portNo]) {
                // ポート番号が変わっている場合は新しい番号を上書きする
                m_pPrinterInfo = [m_pPrinterMgr LoadPrinterDataAtIndexInclude2:self.m_nSelPickerRow2];
                m_pPrinterInfo.RSPortNo = mfpServiceManager.portNo;
                [self savePrinterData];
            }
            
//            [super AnimationShowStartMenu];
            
            [self rsGetJobSettableElements];
        }else {
            
            [self showErrorAlertOnMainThreadWithMessage:MSG_REMOTESCAN_NOTSUPPORT tag:ALERT_TAG_REMOTE_Result_IPAD];
            
            //            [super AnimationShowStartMenu];
            
            
        }
    }
}

- (void)checkManuscriptStartEnabled
{
    bShowingManuscriptDialog = YES;
    
    if((![strOriginalSize isEqualToString:@""] && ![strOriginalSize isEqualToString:@"unknown"]) || ![[rssViewData.originalSize getSelectValue] isEqualToString:@"auto"] || [rssViewData.specialMode isMultiCropOn])
    {
        [self setManuscriptStartEnabled:YES];
    }else{
        if([[rssViewData.originalSize getSelectValue] isEqualToString:@"auto"])
        {
            // どちらかがunknownなら取り込むボタンありダイアログを表示する
            if(bFeederSize || bPlatenSize)
            {
                [self setManuscriptStartEnabled:YES];
            }else{
                [self setManuscriptStartEnabled:NO];
            }
        }else{
            [self setManuscriptStartEnabled:NO];
        }
    }
    nStatus = RSSTATUS_SETDEVICECONTEXT_WAIT_IPAD;
}

// 通信エラー時のレスポンスを処理する
-(void)rsManagerDidFailWithError:(RSHttpCommunicationManager*)manager
{
    DLog(@"rsManagerDidFailWithError %@", [manager class]);
    NSString* strErrorManagerName =@"";
    // セッションIDの取得完了
    if([manager isKindOfClass:[RSRequestUISessionIdManager class]])
    {
        strErrorManagerName = @"RSRequestUISessionIdManager";
        
        switch (nStatus) {
            case RSSTATUS_REQUESTUISESSIONID_IPAD:
            default:
                
                if([manager.errCode isEqualToString:@"NETWORK_ERROR"] ||
                   [manager.errCode isEqualToString:@"WIFI_ERROR"])
                {
                    [self showNetworkAlert];
                } else if([manager.errCode isEqualToString:@"ServerBusy"]) {
                    [self showErrorAlertOnMainThreadWithMessage:MSG_REMOTESCAN_SESSIONID_GET_ERROR tag:ALERT_TAG_WIFI_NO_CONNECTION_IPAD];
                    
                } else if([manager.errCode isEqualToString:@"XML_PARSE_ERROR"] ||
                          [manager.errCode isEqualToString:@"WIFI_ERROR"] ||
                          [manager.errCode isEqualToString:@"InvalidArgs"] ||
                          [manager.errCode isEqualToString:@"OperationFailed"]
                          ) {
                    
                    [self showErrorAlertOnMainThreadWithMessage:MSG_REMOTESCAN_NETWORK_ERROR tag:ALERT_TAG_WIFI_NO_CONNECTION_IPAD];

                } else {
                    [self showErrorAlertOnMainThreadWithMessage:MSG_REMOTESCAN_NETWORK_ERROR tag:ALERT_TAG_WIFI_NO_CONNECTION_IPAD];
                }
                
                break;
        }

    }

    // 設定可能な項目の取得完了
    else if([manager isKindOfClass:[RSGetJobSettableElementsManager class]] ||
            [manager isKindOfClass:[RSmfpifManager class]] ||
            [manager isKindOfClass:[RSmfpifServiceManager class]])
    {
        strErrorManagerName = @"RSGetJobSettableElementsManager";
        
        if([manager.errCode isEqualToString:@"NETWORK_ERROR"] ||
           [manager.errCode isEqualToString:@"WIFI_ERROR"] ||
           [manager.errCode isEqualToString:@"XML_PARSE_ERROR"] ||
           [manager.errCode isEqualToString:@"InvalidArgs"] ||
           [manager.errCode isEqualToString:@"OperationFailed"]
           )
        {
            [picture_alert dismissViewControllerAnimated:YES completion:^{
                [self alertButtonDismiss:picture_alert tagIndex:picture_alert.tag buttonIndex:2];
                [self showErrorAlertOnMainThreadWithMessage:MSG_REMOTESCAN_NETWORK_ERROR_AND_EXIT tag:ALERT_TAG_NETWORKERROR_AND_EXIT_IPAD];
            }];
            picture_alert = nil;
            
        } else if([manager.errCode isEqualToString:@"ActionNotSupported"]){
            [self showNotSupportedAlertAndStopPolling:NO];
        } else {
            [self showErrorAlertOnMainThreadWithMessage:MSG_REMOTESCAN_NETWORK_ERROR_AND_EXIT tag:ALERT_TAG_NETWORKERROR_AND_EXIT_IPAD];
        }
    }

    // 複合機の状態を取得完了
    else if([manager isKindOfClass:[RSGetDeviceStatusManager class]])
    {
        strErrorManagerName = @"RSGetDeviceStatusManager";

        switch (nStatus) {
            case RSSTATUS_SETDEVICECONTEXT_WAIT_IPAD:
                // 何かしらエラーの場合、
                if(picture_alert != nil)
                {
                    [picture_alert dismissViewControllerAnimated:YES completion:^{
                        [self alertButtonDismiss:picture_alert tagIndex:picture_alert.tag buttonIndex:2];
                        [self showErrorAlertOnMainThreadWithMessage:MSG_REMOTESCAN_NETWORK_ERROR tag:ALERT_TAG_GETDEVICESTATUS_FAILED_IPAD];
                        
                        nStatus = RSSTATUS_GETDEVICESTATUS_IPAD;
                    }];
                    picture_alert = nil;
                } else {
                    [self showErrorAlertOnMainThreadWithMessage:MSG_REMOTESCAN_NETWORK_ERROR tag:ALERT_TAG_GETDEVICESTATUS_FAILED_IPAD];
                    
                    nStatus = RSSTATUS_GETDEVICESTATUS_IPAD;
                }
                
                break;
                
            case RSSTATUS_EXECUTEJOB_IPAD:
                // 何かしらエラーの場合、
                [self showErrorAlertOnMainThreadWithMessage:MSG_REMOTESCAN_NETWORK_ERROR tag:ALERT_TAG_WIFI_NO_CONNECTION_IPAD];
                
                nStatus = RSSTATUS_GETDEVICESTATUS_IPAD;
                
                // デバイスにセットされている用紙サイズ取得ポーリングを開始
                // ポーリングタイマー停止
                [self stopGetDeviceStatusPolling];
                
                // デバイスにセットされている用紙サイズ取得ポーリングを開始
                bRemoteScanRunning = NO;
                originalSizePollingTimer = [NSTimer scheduledTimerWithTimeInterval:2 target:self selector:@selector(rsGetDeviceStatusPolling) userInfo:nil repeats:YES];

            default:
                break;
        }
    }

    // 端末情報の通知(スクリーンロック開始)完了
    // スクリーンロック解除完了
    else if([manager isKindOfClass:[RSSetDeviceContextManager class]])
    {
        strErrorManagerName = @"RSSetDeviceContextManager";
        
        if(nStatus == RSSTATUS_SETDEVICECONTEXT_RETRY_IPAD)
        {
            nStatus = RSSTATUS_SETDEVICECONTEXT_START_IPAD;
        }
        
        switch (nStatus) {
            case RSSTATUS_SETDEVICECONTEXT_START_IPAD:
                
                if([manager.errCode isEqualToString:@"NETWORK_ERROR"] ||
                   [manager.errCode isEqualToString:@"WIFI_ERROR"])
                {
                    [self showNetworkAlert];
                    nStatus = RSSTATUS_RELEASEUISESSIONID_IPAD;
                    [self rsReleaseUISessionId];
                    
                } else if([manager.errCode isEqualToString:@"XML_PARSE_ERROR"] ||
                          [manager.errCode isEqualToString:@"WIFI_ERROR"] ||
                          [manager.errCode isEqualToString:@"InvalidArgs"] ||
                          [manager.errCode isEqualToString:@"OperationFailed"] ||
                          [manager.errCode isEqualToString:@"VKeyIsNotValid"]
                          ){
                    [self showErrorAlertOnMainThreadWithMessage:MSG_REMOTESCAN_NETWORK_ERROR tag:ALERT_TAG_WIFI_NO_CONNECTION_IPAD];
                    nStatus = RSSTATUS_RELEASEUISESSIONID_IPAD;
                    [self rsReleaseUISessionId];
                    
                } else if([manager.errCode isEqualToString:@"Forbidden"]) {
                    // リモートスキャン禁止
//                    [self showNotSupportedAlertAndStopPolling:NO];
                    [self showErrorAlertOnMainThreadWithMessage:MSG_REMOTESCAN_FORBIDDEN tag:ALERT_TAG_NOT_SUPPORTED_IPAD];
                    nStatus = RSSTATUS_RELEASEUISESSIONID_IPAD;
                    [self rsReleaseUISessionId];
                    
                } else if([manager.errCode isEqualToString:@"ScreenIsNotHome"])
                {
                    [self showErrorAlertOnMainThreadWithMessage:MSG_REMOTESCAN_SCREENISNOTHOME tag: ALERT_TAG_RSSETDEVICECONTEXTMANAGER_ERROR_IPAD];
                    nStatus = RSSTATUS_RELEASEUISESSIONID_IPAD;
                    [self rsReleaseUISessionId];
                    
                }
                else if([manager.errCode isEqualToString:@"NotAuthenticated"])
                {
                    [self showErrorAlertOnMainThreadWithMessage:MSG_REMOTESCAN_NOTAUTHENTICATED tag:ALERT_TAG_RSSETDEVICECONTEXTMANAGER_ERROR_IPAD];
                    nStatus = RSSTATUS_RELEASEUISESSIONID_IPAD;
                    [self rsReleaseUISessionId];
                    
                }
                else if([manager.errCode isEqualToString:@"ScreenIsNotLogin"])
                {
                    [self showErrorAlertOnMainThreadWithMessage:MSG_REMOTESCAN_SCREENISNOTLOGIN tag:ALERT_TAG_RSSETDEVICECONTEXTMANAGER_ERROR_IPAD];
                    nStatus = RSSTATUS_RELEASEUISESSIONID_IPAD;
                    [self rsReleaseUISessionId];
                    
                }
                else if([manager.errCode isEqualToString:@"RemoteScanNotReady"])
                {
                    // 1wモード対応
                    if(nSetDeviceRetryCount < 3)
                    {
                        nSetDeviceRetryCount++;
                        nStatus = RSSTATUS_SETDEVICECONTEXT_RETRY_IPAD;
                        [self performSelector:@selector(rsSetDeviceContextStartRetry) withObject:nil afterDelay:10.0f];
                        // ReleaseUISessionIdはしない
                    } else {
                        // リトライ失敗
                        [self showErrorAlertOnMainThreadWithMessage:MSG_REMOTESCAN_NETWORK_ERROR tag:ALERT_TAG_WIFI_NO_CONNECTION_IPAD];
                        nStatus = RSSTATUS_RELEASEUISESSIONID_IPAD;
                        [self rsReleaseUISessionId];
                    }
                }
                else
                {
                    [self showScanFailedAlert];
                    nStatus = RSSTATUS_RELEASEUISESSIONID_IPAD;
                    [self rsReleaseUISessionId];
                }
                
                break;
                
            case RSSTATUS_SETDEVICECONTEXT_END_IPAD:
            default:
                [self rsReleaseUISessionId];
                
                break;
        }
    }

    // スキャンジョブの開始完了
    else if([manager isKindOfClass:[RSExecuteJobManager class]])
    {
        strErrorManagerName = @"RSExecuteJobManager";

        if([manager.errCode isEqualToString:@"NETWORK_ERROR"] || [manager.errCode isEqualToString:@"WIFI_ERROR"])
        {
            // ネットワークエラー
            [self showNetworkAlert];
        }
        else if([manager.errCode isEqualToString:@"XML_PARSE_ERROR"])
        {
            // 取り込み失敗
            [self showScanFailedAlert];
        }
        else if([manager.errCode isEqualToString:@"ActionNotSupported"])
        {
            // リモートスキャン未対応
            [self showNotSupportedAlertAndStopPolling:NO];
        }
        else if([manager.errCode isEqualToString:@"AccessDenied"])
        {
            [self showErrorAlertOnMainThreadWithMessage:MSG_REMOTESCAN_ACCESSDENIED_MAIN tag:ALERT_TAG_EXECUTEJOB_ACCESSDENIED_IPAD];
        }
        else if([manager.errCode isEqualToString:@"LimitReached"])
        {
            // 出力可能枚数の上限に到達
            [self showErrorAlertOnMainThreadWithMessage:MSG_REMOTESCAN_LIMITREACHED tag:ALERT_TAG_SCAN_FAILED_IPAD];
        }
        else if([manager.errCode isEqualToString:@"OriginalNotDetected"])
        {
            // 用紙未検知
            [self showErrorAlertOnMainThreadWithMessage:MSG_REMOTESCAN_ORIGINALNOTDETECTED tag:ALERT_TAG_ORIGINAL_NOT_DETECTED_EXECUTE_IPAD];
        }
        
        else if([manager.errCode isEqualToString:@"InvalidArgs"] ||
                [manager.errCode isEqualToString:@"OperationFailed"])
        {
            // 取り込み失敗
            [self showScanFailedAlert];
        }
        else if([manager.errCode isEqualToString:@"VKeyIsNotValid"] )
        {
            // 取り込み失敗
            [self showResourceNotFoundAlert];
        }
        else
        {
            // 取り込み失敗
            [self showScanFailedAlert];
        }
        
        // FTPサーバを停止
        [self stopFtpServer];
        
        [self rsSetDeviceContextEnd];
        
        nStatus = RSSTATUS_GETDEVICESTATUS_IPAD;
        // デバイスにセットされている用紙サイズ取得ポーリングを開始
        // ポーリングタイマー停止
        [self stopGetDeviceStatusPolling];
        
        // デバイスにセットされている用紙サイズ取得ポーリングを開始
        bRemoteScanRunning = NO;
        originalSizePollingTimer = [NSTimer scheduledTimerWithTimeInterval:2 target:self selector:@selector(rsGetDeviceStatusPolling) userInfo:nil repeats:YES];
    }

    // スキャンジョブの開始完了
    else if([manager isKindOfClass:[RSGetJobStatusManager class]])
    {
        strErrorManagerName = @"RSGetJobStatusManager";

        if([manager.errCode isEqualToString:@"ResourceNotFound"])
        {
            // jobid不備
            [self showResourceNotFoundAlert];
        }
        else if([manager.errCode isEqualToString:@"NETWORK_ERROR"] ||
                [manager.errCode isEqualToString:@"WIFI_ERROR"] ||
                [manager.errCode isEqualToString:@"InvalidArgs"] ||
                [manager.errCode isEqualToString:@"OperationFailed"])
        {
            [self showScanFailedAlert];
        }
        
        nStatus = RSSTATUS_SETDEVICECONTEXT_END_IPAD;
        [self rsSetDeviceContextEnd];
        
        // JobStatusポーリング終了
        ((RSGetJobStatusManager*)manager).endThread = YES;
        manager.parserDelegate = nil;
        
        // デバイスにセットされている用紙サイズ取得ポーリングを開始
        // ポーリングタイマー停止
        [self stopGetDeviceStatusPolling];
        
        // デバイスにセットされている用紙サイズ取得ポーリングを開始
        bRemoteScanRunning = NO;
        originalSizePollingTimer = [NSTimer scheduledTimerWithTimeInterval:2 target:self selector:@selector(rsGetDeviceStatusPolling) userInfo:nil repeats:YES];


    }

    // セッションID解放完了
    else if([manager isKindOfClass:[RSReleaseUISessionIdManager class]])
    {
        strErrorManagerName = @"RSReleaseUISessionIdManager";

        manager.parserDelegate = nil;
        
        sessionId = nil;
        
        switch (nStatus) {
            case RSSTATUS_EXECUTEJOB_COMPLETE_IPAD:
            {
                // Backgroundで起動されたキャッシュ作成スレッドの終了をまつ
                while (self.createCacheCount > 0) {
                    // NSRunLoop へ制御を戻す
                    [[NSRunLoop currentRunLoop] runUntilDate:[NSDate dateWithTimeIntervalSinceNow:0.5]];
                }
             
                // スキャン終了
                dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                    // スキャン成功
                    // 現在のリモートスキャン設定を保存する
                    [rssViewData saveRemoteScanSettings];
                    
                    // FTPで受信したファイルがあるか？
                    if(super.ScanFileName != nil)
                    {
                        // 完了通知
                        [super CreateCompleteAlert];
                        //                bDoReset = YES;
                        nStatus = RSSTATUS_INIT_IPAD;
                    }
                    else
                    {
                    }
                    
                });
                break;
            }
            default:
                break;
        }
    }

    // キャンセルジョブ完了
    else if([manager isKindOfClass:[RSCancelJobManager class]])
    {
        strErrorManagerName = @"RSCancelJobManager";
        jobId = nil;

        if([manager.errCode isEqualToString:@"NETWORK_ERROR"]
           || [manager.errCode isEqualToString:@"WIFI_ERROR"])
        {
            // ネットワークエラー
            [self showScanFailedAlert];
        }else if([manager.errCode isEqualToString:@"ResourceNotFound"]){
            // jobid不備 正常として処理
            [super CreateAllert:nil message:MSG_REMOTESCAN_CANCELING btnTitle:MSG_BUTTON_OK];
        }else{
            // 取り込み失敗
            [self showScanFailedAlert];
        }
        
        // デバイスにセットされている用紙サイズ取得ポーリングを開始
        // ポーリングタイマー停止
        [self stopGetDeviceStatusPolling];
        
        nStatus = RSSTATUS_SETDEVICECONTEXT_END_IPAD;
        [self rsSetDeviceContextEnd];
        
        // デバイスにセットされている用紙サイズ取得ポーリングを開始
        bRemoteScanRunning = NO;
        originalSizePollingTimer = [NSTimer scheduledTimerWithTimeInterval:2 target:self selector:@selector(rsGetDeviceStatusPolling) userInfo:nil repeats:YES];
    }

    // レジュームジョブ完了
    else if([manager isKindOfClass:[RSResumeJobManager class]])
    {
        strErrorManagerName = @"RSResumeJobManager";

        if([manager.errCode isEqualToString:@"NETWORK_ERROR"] || [manager.errCode isEqualToString:@"WIFI_ERROR"])
        {
            // ネットワークエラー
            [self showNetworkAlert];
            nStatus = RSSTATUS_SETDEVICECONTEXT_END_IPAD;
            [self rsSetDeviceContextEnd];
        }
        else if([manager.errCode isEqualToString:@"XML_PARSE_ERROR"])
        {
            // 取り込み失敗
            [self showScanFailedAlert];
            nStatus = RSSTATUS_SETDEVICECONTEXT_END_IPAD;
            [self rsSetDeviceContextEnd];
        }
        else if([manager.errCode isEqualToString:@"ResourceNotFound"] || [manager.errCode isEqualToString:@"InvalidArgs"] || [manager.errCode isEqualToString:@"OperationFailed"])
        {
            // 何もしない
            // エラーハンドリングはGetJobStatusで行う
        }
        else if([manager.errCode isEqualToString:@"OriginalNotDetected"])
        {
            // 用紙未挿入
            [self showErrorAlertOnMainThreadWithMessage:MSG_REMOTESCAN_ORIGINALNOTDETECTED_CONFIRM tag:ALERT_TAG_ORIGINAL_NOT_DETECTED_IPAD];
        }

    }

    DLog(@"%@: %@, %d, %@, %@", @"error",strErrorManagerName, manager.isErr, manager.errCode, manager.errMessage);

}

// ジョブステータス取得通知
-(void)rsManager:(RSGetJobStatusManager*)manager gotJobStatus:(int)status
{
    DLog(@"JOB STATUS: %d", status);
    if(bRemoteScanCanceled)
    {
        // アプリ側キャンセル時
        manager.endThread = YES;
        manager.parserDelegate = nil;

//        // セッションID解放
//        [self rsReleaseUISessionId];

        return;
    }
    switch (status) {
        case E_RS_JOB_STATUS_STARTED:   // 開始されました。
            // 処理開始　または　JAM解消後スタート済み（MFPからのボタン押下でステータスが変わる可能性あり）
            bIsJamHassei = NO;
            bIsJamKaisho = NO;

            if(picture_alert != nil)
            {
                [picture_alert dismissViewControllerAnimated:YES completion:^{
                    [self alertButtonDismiss:picture_alert tagIndex:picture_alert.tag buttonIndex:2];
                }];
                picture_alert = nil;
            }

            if(ex_alert != nil)
            {
                ex_alert.message = MSG_REMOTESCAN_DOING;
            }
            else
            {
                [self createProgressionAlertWithMessage:nil message: MSG_REMOTESCAN_DOING withCancel:YES];
            }

            break;

        case E_RS_JOB_STATUS_SCANNED:   // 原稿の読み取りが完了しました。（スキャンメッセージカスタマイズ使用時のみ）
            nStatus = RSSTATUS_EXECUTEJOB_JAMMED_IPAD;
            // JAM解消後
            if(!bIsJamKaisho)
            {
                bIsJamKaisho = YES;
                if(picture_alert != nil)
                {
                    [picture_alert dismissViewControllerAnimated:YES completion:^{
                        [self alertButtonDismiss:picture_alert tagIndex:picture_alert.tag buttonIndex:2];
                    }];
                    picture_alert = nil;
                }

                if(ex_alert != nil)
                {
                    [ex_alert dismissViewControllerAnimated:YES completion:^{
                        [self alertButtonPushed:ex_alert tagIndex:ex_alert.tag buttonIndex:2];
                    }];
                }

                [self setJammingDialogEnabled:YES count:nil];
            }

            break;

        case E_RS_JOB_STATUS_QUEUED:    // 全原稿の読み取りが完了しました。（送信予約状態）
            break;

        case E_RS_JOB_STATUS_STOPPED:   // スキャンJAM発生
        {
            nStatus = RSSTATUS_EXECUTEJOB_JAMMING_IPAD;
            
            if(!bIsJamHassei)
            {
                bIsJamHassei = YES;
                if(picture_alert != nil)
                {
                    [picture_alert dismissViewControllerAnimated:YES completion:^{
                        [self alertButtonDismiss:picture_alert tagIndex:picture_alert.tag buttonIndex:2];
                    }];
                    picture_alert = nil;
                }
                if(ex_alert != nil)
                {
                    [ex_alert dismissViewControllerAnimated:YES completion:^{
                        [self alertButtonPushed:ex_alert tagIndex:ex_alert.tag buttonIndex:2];
                    }];
                }

                [self setJammingDialogEnabled:NO count:manager.strPageCount];
            }

        }
            break;

        case E_RS_JOB_STATUS_CANCELED:  // キャンセルされました。
        {
            // 取り込みファイルが存在するかチェック
            BOOL isExistsScannedFile = NO;
            
            NSFileManager* fileManager = [NSFileManager defaultManager];
            NSError* error;
            NSArray* fileList = [fileManager contentsOfDirectoryAtPath:baseDir error:&error];
            
            // PNGFILE以外にファイルがある場合は取り込んだファイルが存在する
            for (NSString* fileName in fileList) {
                if (![fileName isEqualToString:@"PNGFILE"]) {
                    isExistsScannedFile = YES;
                    break;
                }
            }
            
            if(isExistsScannedFile)
            {
                // ファイルありのため、正常取り込みと同じ処理を行う
                nStatus = RSSTATUS_EXECUTEJOB_COMPLETE_IPAD;
                // スクリーンロック解除
                manager.parserDelegate = nil;
                bRemoteScanRunning = NO;
                
                nStatus = RSSTATUS_EXECUTEJOB_COMPLETE_IPAD;
                [self rsSetDeviceContextEnd];
                
                [self stopFtpServer];
            } else {
                // ファイルがないので、キャンセルされた場合の処理を行う
                nStatus = RSSTATUS_EXECUTEJOB_CANCELED_IPAD;
                manager.parserDelegate = nil;
                bRemoteScanCanceled = YES;
                [self stopFtpServer];
                
                nStatus = RSSTATUS_SETDEVICECONTEXT_END_IPAD;
                [self rsSetDeviceContextEnd];
                
                // ポーリングタイマー停止
                [self stopGetDeviceStatusPolling];
                
                // デバイスにセットされている用紙サイズ取得ポーリングを開始
                bRemoteScanRunning = NO;
                originalSizePollingTimer = [NSTimer scheduledTimerWithTimeInterval:2 target:self selector:@selector(rsGetDeviceStatusPolling) userInfo:nil repeats:YES];
                
                if(picture_alert != nil)
                {
                    [picture_alert dismissViewControllerAnimated:YES completion:^{
                        [self alertButtonDismiss:picture_alert tagIndex:picture_alert.tag buttonIndex:2];
                    }];
                    picture_alert = nil;
                }
                
                if(ex_alert != nil)
                {
                    [ex_alert dismissViewControllerAnimated:YES completion:^{
                        [self alertButtonPushed:ex_alert tagIndex:ex_alert.tag buttonIndex:2];
                    }];
                    
                }
                
                [super CreateAllert:nil message:MSG_REMOTESCAN_CANCELED btnTitle:MSG_BUTTON_OK];
            }
        }
            break;
        case E_RS_JOB_STATUS_FINISHED:  // 完了しました。
            nStatus = RSSTATUS_EXECUTEJOB_COMPLETE_IPAD;
            // スクリーンロック解除
            manager.parserDelegate = nil;
            bRemoteScanRunning = NO;

            nStatus = RSSTATUS_EXECUTEJOB_COMPLETE_IPAD;
            [self rsSetDeviceContextEnd];

            [self stopFtpServer];

            break;
        case E_RS_JOB_STATUS_ERROR_ALL_PAGE_BLANK:
            // 全ページ白紙
            manager.parserDelegate = nil;
            bRemoteScanCanceled = YES;
            [self stopFtpServer];
            
            nStatus = RSSTATUS_SETDEVICECONTEXT_END_IPAD;
            [self rsSetDeviceContextEnd];
            
            // ポーリングタイマー停止
            [self stopGetDeviceStatusPolling];
            
            // デバイスにセットされている用紙サイズ取得ポーリングを開始
            bRemoteScanRunning = NO;
            originalSizePollingTimer = [NSTimer scheduledTimerWithTimeInterval:2 target:self selector:@selector(rsGetDeviceStatusPolling) userInfo:nil repeats:YES];
            
            if(picture_alert != nil)
            {
                [picture_alert dismissViewControllerAnimated:YES completion:^{
                    [self alertButtonDismiss:picture_alert tagIndex:picture_alert.tag buttonIndex:2];
                }];
                picture_alert = nil;
            }
            
            if(ex_alert != nil)
            {
                [ex_alert dismissViewControllerAnimated:YES completion:^{
                    [self alertButtonPushed:ex_alert tagIndex:ex_alert.tag buttonIndex:2];
                }];
                
            }
            
            [super CreateAllert:nil message:MSG_REMOTESCAN_ERROR_ALL_PAGE_BLANK btnTitle:MSG_BUTTON_OK];
            break;

        default:
            nStatus = RSSTATUS_SETDEVICECONTEXT_END_IPAD;
            [self rsSetDeviceContextEnd];
            [self showScanFailedAlert];
            
            // JobStatusポーリング終了
            ((RSGetJobStatusManager*)manager).endThread = YES;
            manager.parserDelegate = nil;
            
            // デバイスにセットされている用紙サイズ取得ポーリングを開始
            // ポーリングタイマー停止
            [self stopGetDeviceStatusPolling];
            
            // デバイスにセットされている用紙サイズ取得ポーリングを開始
            bRemoteScanRunning = NO;
            originalSizePollingTimer = [NSTimer scheduledTimerWithTimeInterval:2 target:self selector:@selector(rsGetDeviceStatusPolling) userInfo:nil repeats:YES];

            break;
    }
}


// 設定可能なパラメータの取得完了
-(void)didFinishRSGetJobSettableElementsManagerParsing
{
    rssViewData = [[RemoteScanSettingViewData alloc] initWithRSSettableElementsData:[rsManager rsSettableElementsData]];

    // 設定情報を更新
    [self updateSetting];

    // ボタンを活性にする
    [self setAllButtonEnable:YES];
}

//ダイアログのボタン押下時
-(void)alertButtonPushed:(UIAlertController *)alertController tagIndex:(NSInteger)tagIndex buttonIndex:(NSInteger)buttonIndex{
    [self alertButtonDismiss:alertController tagIndex:tagIndex buttonIndex:buttonIndex];
}

-(void)alertButtonDismiss:(UIAlertController *)alertController tagIndex:(NSInteger)tagIndex buttonIndex:(NSInteger)buttonIndex{

    if(tagIndex == ALERT_TAG_SCANBEFORE_IPAD){

        bShowingManuscriptDialog = NO;

        switch (buttonIndex) {
            case 0: {
                // キャンセルボタン押下
                // スキャンしない
                // 処理実行フラグOFF
                bRemoteScanCanceled = YES;
//                bShowingManuscriptDialog = NO;

                SharpScanPrintAppDelegate* appDelegate = (SharpScanPrintAppDelegate*)[[UIApplication sharedApplication] delegate];
                appDelegate.IsRun = FALSE;
                //m_palert = nil;

                nStatus = RSSTATUS_SETDEVICECONTEXT_END_IPAD;
                [self rsSetDeviceContextEnd];

                break;
            }
            case 1:
                // スキャン開始
                m_IsModProfile = FALSE;

                picture_alert = nil;

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
                        [self makeTmpExAlert:nil message:MSG_NETWORK_ERR cancelBtnTitle:nil okBtnTitle:MSG_BUTTON_OK tag:0];
                        
                        nStatus = RSSTATUS_SETDEVICECONTEXT_END_IPAD;
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
                    
                    // チェック用
                    BOOL originalSizeManual = [[rssViewData.originalSize getSelectValue] isEqualToString:@"japanese_postcard_a6"] || [[rssViewData.originalSize getSelectValue] isEqualToString:@"extraSize1"] || [[rssViewData.originalSize getSelectValue] isEqualToString:@"extraSize2"] || [[rssViewData.originalSize getSelectValue] isEqualToString:@"extraSize3"] || [[rssViewData.originalSize getSelectValue] isEqualToString:@"extraSize4"];
                    
                    BOOL originalSizeCustom = [[rssViewData.originalSize getSelectValue] isEqualToString:@"customSize1"] || [[rssViewData.originalSize getSelectValue] isEqualToString:@"customSize2"] || [[rssViewData.originalSize getSelectValue] isEqualToString:@"customSize3"] || [[rssViewData.originalSize getSelectValue] isEqualToString:@"customSize4"] || [[rssViewData.originalSize getSelectValue] isEqualToString:@"customSize5"];
                    
                    // 選択した原稿サイズの横、縦
                    NSInteger nSelectSizeWidth = 0;
                    NSInteger nSelectSizeHeight = 0;
                    {
                        if ([[rssViewData.originalSize getSelectValue] rangeOfString:@"extraSize"].location != NSNotFound)
                        {
                            nSelectSizeWidth = [[rssViewData.extraSizeListData getCustomPaperSizeData:[rssViewData.originalSize getSelectValue]] getMilliWidth];
                            nSelectSizeHeight = [[rssViewData.extraSizeListData getCustomPaperSizeData:[rssViewData.originalSize getSelectValue]] getMilliHeight];
                        }
                        else if ([[rssViewData.originalSize getSelectValue] rangeOfString:@"customSize"].location != NSNotFound)
                        {
                            nSelectSizeWidth = [[rssViewData.customSizeListData getCustomPaperSizeData:[rssViewData.originalSize getSelectValue]] getMilliWidth];
                            nSelectSizeHeight = [[rssViewData.customSizeListData getCustomPaperSizeData:[rssViewData.originalSize getSelectValue]] getMilliHeight];
                        }
                        else if ([[rssViewData.originalSize getSelectValue] rangeOfString:@"japanese_postcard_a6"].location != NSNotFound)
                        {
                            nSelectSizeWidth = JAPANESE_POSTCARD_A6_WIDTH;
                            nSelectSizeHeight = JAPANESE_POSTCARD_A6_HEIGHT;
                        }
                    }

                    if ([rssViewData.specialMode isMultiCropOn] && bFeederSize)
                    {
                        // マルチクロップONでfeederがunknown以外の場合
                        
                        //　GetDeviceStatusのポーリング処理は続行し、ExecuteJobを実行しない。
                        [self makeTmpExAlert:nil message:MSG_REMOTESCAN_USESTAND cancelBtnTitle:nil okBtnTitle:MSG_BUTTON_OK tag:0];
                        
                        nStatus = RSSTATUS_SETDEVICECONTEXT_END_IPAD;
                        [self rsSetDeviceContextEnd];
                        
                        return;
                    
                    }
                    else if([rssViewData.originalSize isLong])
                    {
                        // 長尺の場合はチェック
                        
                        // platenがunknown以外、feederがunknownの場合（OCのみ検知ありの場合）
                        if(!bFeederSize && bPlatenSize)
                        {
                            //　GetDeviceStatusのポーリング処理は続行し、ExecuteJobを実行しない。
                            [self makeTmpExAlert:nil message:MSG_REMOTESCAN_USEFEEDER cancelBtnTitle:nil okBtnTitle:MSG_BUTTON_OK tag:0];
                            
                            nStatus = RSSTATUS_SETDEVICECONTEXT_END_IPAD;
                            [self rsSetDeviceContextEnd];
                            
                            return;
                        }
                    } else if([[rssViewData.duplexData getSelectValue] isEqualToString:@"duplex+book"]
                        || [[rssViewData.duplexData getSelectValue] isEqualToString:@"duplex+tablet"])
                    {
                        // 両面の場合はチェック
                        
                        // feederがunknownの場合（OCのみ検知ありの場合または、DF / OC共に検知なしの場合）
                        if(!bFeederSize)
                        {
                            // かつ、L判、名刺、カードを選択している場合
                            if ([[rssViewData.originalSize getSelectValue] isEqualToString:@"extraSize1"] ||
                                [[rssViewData.originalSize getSelectValue] isEqualToString:@"extraSize2"]||
                                [[rssViewData.originalSize getSelectValue] isEqualToString:@"extraSize4"]) {
                                
                                [self CreateAllert:nil message:MSG_REMOTESCAN_NOTUSE btnTitle:MSG_BUTTON_OK];
                            } else {
                                //　GetDeviceStatusのポーリング処理は続行し、ExecuteJobを実行しない。
                                [self makeTmpExAlert:nil message:MSG_REMOTESCAN_USEFEEDER cancelBtnTitle:nil okBtnTitle:MSG_BUTTON_OK tag:0];
                            }
                            
                            nStatus = RSSTATUS_SETDEVICECONTEXT_END_IPAD;
                            [self rsSetDeviceContextEnd];
                        
                            return;
                        }
                    }
                    else if ([[rssViewData.duplexData getSelectValue] hasPrefix:@"simplex"] && (originalSizeManual || (originalSizeCustom && (nSelectSizeWidth < [pstrDetectableMinWidth intValue] || nSelectSizeHeight < [pstrDetectableMinHeight intValue]))) && bFeederSize)
                    {
                        NSString *message;
                        if (bPlatenSize)
                        {
                            message = MSG_REMOTESCAN_REMOVEDOCUMENT;
                        }
                        else
                        {
                            message = MSG_REMOTESCAN_USESTAND;
                        }
                        
                        //　GetDeviceStatusのポーリング処理は続行し、ExecuteJobを実行しない。
                        [self makeTmpExAlert:nil message:message cancelBtnTitle:nil okBtnTitle:MSG_BUTTON_OK tag:0];
                    
                        nStatus = RSSTATUS_SETDEVICECONTEXT_END_IPAD;
                        [self rsSetDeviceContextEnd];
                    
                        return;
                    }
                    
                    //GetDeviceStatusを止める
                    [self stopGetDeviceStatusPolling];
                    
                    nStatus = RSSTATUS_EXECUTEJOB_IPAD;
                    // ExecuteJob実施前に一度だけGetDeviceStatusをする
                    [self rsGetDeviceStatus];

                    [self createProgressionAlertWithMessage:nil message: MSG_REMOTESCAN_DOING withCancel:YES];
                }
                    @finally
                {

                }
                break;
            case 2:
                // 自動ダイアログ切り替え用　何もしない
                //m_palert = nil;
                bShowingManuscriptDialog = YES;
                break;
            default:
                break;
        }
    }else if(tagIndex == ALERT_TAG_SCANPROGRESS_IPAD){
        //プログレスダイアログ
        switch (buttonIndex) {
            case 1:
                // 成功？
                break;
            case 0:
                // キャンセル
                bRemoteScanCanceled = YES;
                bRemoteScanRunning = NO;
                ex_alert = nil;
                picture_alert = nil;
                
                // ExecuteJobの戻りがかえる前にCancelJobが実行されないように待つ
                
                if(jobId == nil)
                {
                    // 別スレッドで実行
                    cancelJobWaitTimer = [NSTimer scheduledTimerWithTimeInterval:1.0f target:self selector:@selector(doCancelJob:) userInfo:[[NSDictionary alloc] init] repeats:NO];
                }
                else
                {
                    [self stopFtpServer];
                    [self rsCancelJob];
                }

                break;
            case 2:
                // アプリによる自動キャンセル時
                //alert = nil;
            default:
                break;
        }

    }else if(tagIndex == ALERT_TAG_FAILED_REQUESTUISESSIONID_IPAD){
        // 通常取り込み画面へ遷移する
    }else if(tagIndex == ALERT_TAG_JAMMING_IPAD){
        switch (buttonIndex) {
            case 0:
                ex_alert = nil;
                picture_alert = nil;
                // キャンセル
                bRemoteScanCanceled = YES;
                bRemoteScanRunning = NO;
                [self stopFtpServer];
                [self rsCancelJob];

                break;
            case 1:
                ex_alert = nil;
                picture_alert = nil;
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
    }else if(tagIndex == ALERT_TAG_WIFI_NO_CONNECTION_IPAD){
        // wi-fi接続エラー
        bFirstErr_Network = NO;

        // シーケンスのキャンセル
        if(bRemoteScanRunning){
            bRemoteScanCanceled = YES;
            bRemoteScanRunning = NO;
            [self stopFtpServer];
        }
        

        if(ex_alert){
            // アラートを閉じる
            [ex_alert dismissViewControllerAnimated:YES completion:^{
                [self alertButtonPushed:nil tagIndex:ex_alert.tag buttonIndex:2];
            }];
            ex_alert = nil;
        }

        // ポーリングタイマー停止
        [self stopGetDeviceStatusPolling];
        
        // ポーリング開始
        originalSizePollingTimer = [NSTimer scheduledTimerWithTimeInterval:2 target:self selector:@selector(rsGetDeviceStatusPolling) userInfo:nil repeats:YES];

        
    }else if(tagIndex == ALERT_TAG_ORIGINAL_NOT_DETECTED_EXECUTE_IPAD){
        // シーケンスのキャンセル
        bRemoteScanCanceled = YES;
        bRemoteScanRunning = NO;
        [self stopFtpServer];
        ex_alert = nil;
        picture_alert = nil;

    }else if(tagIndex == ALERT_TAG_SCAN_FAILED_IPAD || tagIndex == ALERT_TAG_RESOURCE_NOT_FOUND_IPAD){
        // 取り込み失敗

        // シーケンスのキャンセル
        bRemoteScanCanceled = YES;
        bRemoteScanRunning = NO;
        [self stopFtpServer];
        ex_alert = nil;
        picture_alert = nil;
        
    }else if(tagIndex == ALERT_TAG_NOT_SUPPORTED_IPAD){
        // 通常取り込み画面へ遷移
        ex_alert = nil;
        picture_alert = nil;
        [self remoteScanToNomalScan];
        
    }else if(tagIndex == ALERT_TAG_RSSETDEVICECONTEXTMANAGER_ERROR_IPAD){
        // SetDeviceContextで失敗
        // ダイアログ閉じるだけ

    }else if(tagIndex == ALERT_TAG_NOT_SUPPORTED_AND_STOP_IPAD){
        // リモートスキャン未対応、ポーリングを停止する
        ex_alert = nil;

        // ポーリングタイマー停止
        [self stopGetDeviceStatusPolling];
        
        [self remoteScanToNomalScan];

    }else if(tagIndex == ALERT_TAG_ORIGINAL_NOT_DETECTED_IPAD){
        // 用紙未検知

        if(buttonIndex == 0){
            // キャンセル

            // シーケンスのキャンセル
            bRemoteScanCanceled = YES;
            bRemoteScanRunning = NO;
            [self stopFtpServer];

            [self rsCancelJob];

            // ポーリングタイマー停止
            [self stopGetDeviceStatusPolling];
            
            // ポーリング開始
            originalSizePollingTimer = [NSTimer scheduledTimerWithTimeInterval:2 target:self selector:@selector(rsGetDeviceStatusPolling) userInfo:nil repeats:YES];

            ex_alert = nil;
            picture_alert = nil;
            
        }else{
            [self createProgressionAlertWithMessage:nil message: MSG_REMOTESCAN_DOING withCancel:YES];
            // 再度取り込み処理
            [self rsResumeJob];
        }

    }else if(tagIndex == ALERT_TAG_WAIT_IPAD){

        ex_alert = nil;
        picture_alert = nil;
        // キャンセル処理が必要
        [rsManager updateDataCancel];
    }else if(tagIndex == ALERT_TAG_NETWORKERROR_AND_EXIT_IPAD){
        // 通常取り込み画面へ遷移
        ex_alert = nil;
        picture_alert = nil;
        [self remoteScanToNomalScan];
    }else if(tagIndex == ALERT_TAG_SETDEVICECONTEXT_WAIT_IPAD){
        switch (buttonIndex) {
            case 0:
                // RequestUISessionID,SetDeviceContextのキャンセル
                ex_alert = nil;
                picture_alert = nil;
                if (nStatus == RSSTATUS_SETDEVICECONTEXT_START_IPAD ||
                    nStatus == RSSTATUS_SETDEVICECONTEXT_RETRY_IPAD ||
                    nStatus == RSSTATUS_SETDEVICECONTEXT_WAIT_IPAD||
                    nStatus == RSSTATUS_REQUESTUISESSIONID_IPAD)
                {
                    nStatus = RSSTATUS_RELEASEUISESSIONID_IPAD;
                    [self rsReleaseUISessionId];
                }
                break;
            default:
                break;
        }
    }else if(tagIndex == ALERT_TAG_EXECUTEJOB_ACCESSDENIED_IPAD) {
        // 何もしない
    }else if(tagIndex == ALERT_TAG_GETDEVICESTATUS_FAILED_IPAD
             ) {
        // リモートスキャン中断、通常取り込み画面へ遷移
        ex_alert = nil;
        
        // ポーリングタイマー停止
        [self stopGetDeviceStatusPolling];
        [self remoteScanToNomalScan];
        
    }else if(tagIndex == ALERT_TAG_REMOTE_CHECK_IPAD) {
        if (buttonIndex == 0) {
//            // ボタン非活性でリモートモードを開く
//            [super AnimationShowStartMenu];
        }
        
    }else if(tagIndex == ALERT_TAG_REMOTE_Result_IPAD) {
        // リモートスキャン未対応、ポーリングを停止する
        ex_alert = nil;
        
        // 取り込み失敗
        [self remoteScanToNomalScan];

    }else{
        // その他のボタン
        [super alertButtonPushed:alertController tagIndex:tagIndex buttonIndex:buttonIndex];
        ex_alert = nil;
        picture_alert = nil;
    }
}

// キャンセルジョブ（別スレッド）
-(void) doCancelJob:(NSTimer*) timer
{
    int count = 0;
    
    if(timer.userInfo != nil)
    {
        if([timer.userInfo objectForKey:@"count"] != nil)
        {
            count = [[timer.userInfo objectForKey:@"count"] intValue];
        }
        if(count > 100)
        {
            [self stopFtpServer];
            [self rsCancelJob];
            return;
        }
    }
    
    if(jobId == nil)
    {
        NSMutableDictionary* dic = [[NSMutableDictionary alloc] init];
        [dic setObject:[NSString stringWithFormat:@"%d", count+1] forKey:@"count"];
        
        // （再帰的に呼び出す）
        cancelJobWaitTimer = [NSTimer scheduledTimerWithTimeInterval:0.1f target:self selector:@selector(doCancelJob:) userInfo:dic repeats:NO];
    }
    else
    {
        [self stopFtpServer];
        [self rsCancelJob];
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
    if ( requestUISessionIdManager ) {
        requestUISessionIdManager.parserDelegate = nil;
        requestUISessionIdManager = nil;
    }
    
    bScreenLock = NO;
    requestUISessionIdManager = [[RSRequestUISessionIdManager alloc]initWithURL:connectUrl];
    requestUISessionIdManager.parserDelegate = self;
    [requestUISessionIdManager updateData];

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
    if(nStatus == RSSTATUS_SETDEVICECONTEXT_RETRY_IPAD)
    {
        [self rsSetDeviceContext:YES];
    }
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
    
    // オブジェクト存在時は解放する
    if ( setDeviceContextManager ) {
        setDeviceContextManager.parserDelegate = nil;
        setDeviceContextManager = nil;
    }
    
    setDeviceContextManager = [[RSSetDeviceContextManager alloc]initWithURL:connectUrl];
    setDeviceContextManager.parserDelegate = self;
    if(bScreenLockStart){
        bScreenLock = YES;
        // スクリーンロック開始
        [setDeviceContextManager updateData:YES remoteScanHost:strProfileName remoteScanCode:strVerifyCode remoteScanTimeOut:30 vkey:[self vkey]];
    }else{
        bScreenLock = NO;
        // スクリーンロック終了
        [setDeviceContextManager updateData:NO remoteScanHost:nil remoteScanCode:nil remoteScanTimeOut:0 vkey:[self vkey]];
    }

}
// 3.複合機の状態を取得
-(void)rsGetDeviceStatus
{
    DLog(@"func:%s", __func__);

    if(![self isShowRemoteScanView])
    {
        return;
    }
    
    // オブジェクト存在時は解放する
    if ( pollingRsManager ) {        
        [pollingRsManager disconnect];  // ポーリングキャンセル
        pollingRsManager.parserDelegate = nil;
        pollingRsManager = nil;
    }
    
    pollingRsManager = [[RSGetDeviceStatusManager alloc]initWithURL:connectUrl];
    pollingRsManager.parserDelegate = self;
    [pollingRsManager updateData];
}

// 4.スキャンジョブの開始
-(void)rsExecuteJob
{
    DLog(@"func:%s", __func__);

    if(![self isShowRemoteScanView])
    {
        return;
    }
    
    // オブジェクト存在時は解放する
    if ( executeJobManager ) {
        executeJobManager.parserDelegate = nil;
        executeJobManager = nil;
    }
    
    executeJobManager = [[RSExecuteJobManager alloc]initWithURL:connectUrl];
    executeJobManager.parserDelegate = self;

    // 設定値をまとめる
    NSMutableDictionary* dic = [rssViewData getExecuteJobParameter];

    [dic setObject:[self vkey] forKey:@"vkey"];

    [dic setObject:[NSString stringWithFormat:@"%@:%@", [CommonUtil optIPAddrForComm:iPaddr], S_FTP_PORT] forKey:@"ftpHost"];
    [dic setObject:S_FTP_USER forKey:@"ftpUsername"];
    [dic setObject:m_ScanPass forKey:@"ftpPassword"];
    
    BOOL isContain1 = NO;
    BOOL isContain2 = NO;
    BOOL isContain3 = NO;
    // 1. 原稿サイズが自動以外
    if(![[rssViewData.originalSize getSelectValue] isEqualToString:@"auto"])
    {
        isContain1 = YES;
    }
    // 2. platen、feeder共にunknownの場合（DF / OC共に検知なしの場合）
    if(!bFeederSize && !bPlatenSize)
    {
        isContain2 = YES;
    }
    // 3. GetJobSettableElementsで取得したオリジナルソースの値にプラテンが存在する
    for (NSString* key in [[rsManager rsSettableElementsData].originalSourceData getCapableOptionsKeys]) {
        if ([key isEqualToString:@"platen"]) {
            // プラテンあり
            isContain3 = YES;
            break;
        }
    }
    // 3つ共にTrueの場合、ExecuteJobのパラメータとして、オリジナルソース＝プラテンを追加する
    if (isContain1 && isContain2 && isContain3) {
        [dic setObject:@"platen" forKey:@"OriginalSource"];
    }

    // 開始
    [executeJobManager updateData:dic];

}

// 6.ジョブステータス取得ポーリングを開始
-(void)rsGetJobStatus
{
    DLog(@"func:%s", __func__);

    if(![self isShowRemoteScanView])
    {
        return;
    }

    // オブジェクト存在時は解放する
    if ( getJobStatusManager ) {
        getJobStatusManager.parserDelegate = nil;
        getJobStatusManager = nil;
    }

    getJobStatusManager = [[RSGetJobStatusManager alloc]initWithURL:connectUrl];
    getJobStatusManager.parserDelegate = self;
    [getJobStatusManager startPollingThreadWithJobId:jobId timeInterval:2 delegate:self];

}

// 7.セッションのリリース
-(void)rsReleaseUISessionId
{
    DLog(@"func:%s", __func__);

    if(sessionId)
    {
        // オブジェクト存在時は解放する
        if ( releaseUISessionIdManager ) {
            releaseUISessionIdManager.parserDelegate = nil;
            releaseUISessionIdManager = nil;
        }

        releaseUISessionIdManager = [[RSReleaseUISessionIdManager alloc]initWithURL:connectUrl];
        releaseUISessionIdManager.parserDelegate = self;
        [releaseUISessionIdManager updateData:sessionId];
        sessionId = nil;
    }
}

// 8.リモートスキャン終了処理
-(void)rsFinish
{
    bRemoteScanRunning = NO;

    // 処理実行フラグOFF
    SharpScanPrintAppDelegate* appDelegate = (SharpScanPrintAppDelegate*)[[UIApplication sharedApplication] delegate];
    appDelegate.IsRun = FALSE;

}

// ジョブのキャンセル
-(void)rsCancelJob
{
    DLog(@"func:%s", __func__);
    
    // オブジェクト存在時は解放する
    if ( cancelJobManager ) {
        cancelJobManager.parserDelegate = nil;
        cancelJobManager = nil;
    }

    cancelJobManager = [[RSCancelJobManager alloc]initWithURL:connectUrl];
    cancelJobManager.parserDelegate = self;
    [cancelJobManager updateData:jobId];
}

// ジョブのレジューム
-(void)rsResumeJob
{
    DLog(@"func:%s", __func__);
    
    // オブジェクト存在時は解放する
    if ( resumeJobManager ) {
        resumeJobManager.parserDelegate = nil;
        resumeJobManager = nil;
    }
    
    resumeJobManager = [[RSResumeJobManager alloc]initWithURL:connectUrl];
    resumeJobManager.parserDelegate = self;

    [resumeJobManager updateData:jobId originalSize:[rssViewData.originalSize getSelectValue] sendSize:[rssViewData.sendSize getSelectValue] resolution:[rssViewData.resolution getSelectValue] exposureMode:[rssViewData.exposureMode getSelectValue] exposureLevel:[rssViewData.exposureLevel selectValue]];
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
            if(!pollingRsManager){
                DLog(@"func:%s", __func__);
                pollingRsManager = [[RSGetDeviceStatusManager alloc]initWithURL:connectUrl];
                pollingRsManager.parserDelegate = self;
            }
            [pollingRsManager updateData];
    }

    // リモートスキャン画面でなければポーリングを終了する
    if(![self isShowRemoteScanView])
    {
        [self stopGetDeviceStatusPolling];
    }
}

-(void)stopGetDeviceStatusPolling
{
    if(originalSizePollingTimer != nil)
    {
        if([originalSizePollingTimer isValid]){
            [originalSizePollingTimer invalidate];
            originalSizePollingTimer = nil;
        }
        
        if(pollingRsManager != nil)
        {
            if ( pollingRsManager )
            {        
                [pollingRsManager disconnect];  // ポーリングキャンセル
                pollingRsManager.parserDelegate = nil;
                pollingRsManager = nil;
            }
        }
    }
}

-(BOOL)isShowRemoteScanView
{
    BOOL result = YES;

    SharpScanPrintAppDelegate* appDelegate = (SharpScanPrintAppDelegate*)[[UIApplication sharedApplication] delegate];

    if([appDelegate.splitViewController.viewControllers count] > 1)
    {
        UINavigationController* navi = [appDelegate.splitViewController.viewControllers objectAtIndex:1];
        UIViewController* cont = navi.topViewController;
        if(![cont isKindOfClass:[RemoteScanBeforePictViewController_iPad class]]){
            result = NO;
            
            // UIAlertController対応した場合に、現在見えているコントローラーがUIAlertControllerになってしまうので、
            // この処理を入れてリモートスキャンできるようする
            if ([self.navigationController.visibleViewController isKindOfClass:[UIAlertController class]]) {
                result = YES;
            }
        }
    }
    else
    {
        result = NO;
    }

    return result;
}

#pragma mark - Show Error Alert
// メインスレッドでエラーアラートを表示
-(void)showErrorAlertOnMainThreadWithMessage:(NSString*)message tag:(int)tag
{
    // ボタンの設定
    NSString* cancelTitle = nil;
    NSString* otherTitle = MSG_BUTTON_OK;
    if(tag == ALERT_TAG_ORIGINAL_NOT_DETECTED_IPAD){
        cancelTitle = MSG_BUTTON_CANCEL;
        otherTitle = S_BUTTON_SCAN_IPAD;
    }

    if (ex_alert != nil) {
        // アラートを閉じる
        [ex_alert dismissViewControllerAnimated:YES completion:^{
            [self alertButtonPushed:nil tagIndex:ex_alert.tag buttonIndex:2];
            
            // アラート表示
            [self makeTmpExAlert:nil message:message cancelBtnTitle:cancelTitle okBtnTitle:otherTitle tag:tag];
        }];
        ex_alert = nil;
        
    } else {
        // アラート表示
        [self makeTmpExAlert:nil message:message cancelBtnTitle:cancelTitle okBtnTitle:otherTitle tag:tag];
    }
}

// 表示中のアラートを消す
- (void)closeAlert {
    if (ex_alert != nil) {
        // アラートを閉じる
        [ex_alert dismissViewControllerAnimated:YES completion:^{
            [self alertButtonPushed:nil tagIndex:ex_alert.tag buttonIndex:2];
        }];
        ex_alert = nil;
    }
}

// closeAlertを呼ぶ(delay処理用)
- (void)callCloseAlert {
    [self performSelectorOnMainThread:@selector(closeAlert) withObject:nil waitUntilDone:NO];
}

// アラート表示
- (void) makeTmpExAlert:(NSString*)pstrTitle
                message:(NSString*)pstrMsg
         cancelBtnTitle:(NSString*)cancelBtnTitle
             okBtnTitle:(NSString*)okBtnTitle
                    tag:(NSInteger)tag
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
    
    // アラート表示処理
    [self presentViewController:tmpAlert animated:YES completion:nil];
}

// ネットワークアラートを表示
-(void)showNetworkAlert
{
    [self showErrorAlertOnMainThreadWithMessage:MSG_NETWORK_ERR tag:ALERT_TAG_WIFI_NO_CONNECTION_IPAD];
}

// 取り込み失敗アラートを表示
-(void)showScanFailedAlert
{
    [self showErrorAlertOnMainThreadWithMessage:MSG_REMOTESCAN_SCANFAIL tag:ALERT_TAG_SCAN_FAILED_IPAD];
}

// リモートスキャン未対応・リモートスキャン禁止アラートを表示
-(void)showNotSupportedAlertAndStopPolling:(BOOL)bStop
{
    int tag = (bStop ? ALERT_TAG_NOT_SUPPORTED_AND_STOP_IPAD : ALERT_TAG_NOT_SUPPORTED_IPAD);
    [self showErrorAlertOnMainThreadWithMessage:MSG_REMOTESCAN_NOTSUPPORT tag:tag];
}

// リモートスキャンでなくなったので取り込み中止アラートを表示
-(void)showResourceNotFoundAlert
{
    bRemoteScanCanceled = YES;
    [self showErrorAlertOnMainThreadWithMessage:MSG_REMOTESCAN_ACCESSDENIED tag:ALERT_TAG_RESOURCE_NOT_FOUND_IPAD];
}

#pragma mark -
#pragma mark FTP Notification

//
// 通知：FTP 受信結果
//
- (void) createCacheAndThumbnail:(NSString*) filename
{
    
    TempFile * tempFile = [[TempFile alloc]initWithFileName:filename];
    [TempFileUtility createRequiredAllImageFiles:tempFile];
    
    self.createCacheCount--; // キャッシュ作成カウント
}
- (void) FtpReceiveResponceNotification:(NSNotification *)aNotification
{
    DLog(@"func:%s", __func__);

    NSString *postdata = [[aNotification userInfo] objectForKey:@"FTP_RETURN"];

	if ([postdata isEqualToString:@"1"] == YES)
	{
        // 複数ファイル受信確認
        if (nil != super.ScanFileName)
        {
            self.createCacheCount++; // キャッシュ作成カウント
            
            NSString *scanFileName = [[NSString alloc] initWithString:super.ScanFileName];
            dispatch_queue_t queue = dispatch_queue_create("jp.co.sharp.printsystem.SharpdeskMobile", DISPATCH_QUEUE_SERIAL);
            dispatch_sync(queue, ^{
                [self createCacheAndThumbnail:scanFileName];
            });
            
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
        if([selectedVC isKindOfClass:[RSS_FormatViewController_iPad class]]){
            // フォーマットの場合、イベントを送る
            [(RSS_FormatViewController_iPad*)selectedVC keyboardWillShow:aNotification];
        }
    }
}

// キーボード消滅
- (void)keyboardWillHide:(NSNotification*)aNotification
{
    if(selectedVC){
        if([selectedVC isKindOfClass:[RSS_FormatViewController_iPad class]]){
            // フォーマットの場合、イベントを送る
            [(RSS_FormatViewController_iPad*)selectedVC keyboardWillHide:aNotification];
        }
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
- (IBAction)tapMenuUpBtn:(UIButton *)sender {
    // 最上部までスクロール
    [UIView animateWithDuration:0.3
                     animations:^{
                         menuScrollView.contentOffset = CGPointZero;
                     }];
}

- (IBAction)tapMenuDownBtn:(UIButton *)sender {
    // 最下部までスクロール
    [UIView animateWithDuration:0.3
                     animations:^{
                         menuScrollView.contentOffset = CGPointMake(0, menuScrollView.contentSize.height - menuScrollView.frame.size.height);
                     }];
}

- (IBAction)tapRemoteSwt:(UISwitch*)sender {
    // リモートスキャンスイッチ切替
    if(!sender.on){
        // リモートスキャンをオフにする
//        bChangeSelectMfp = YES;
//        [self rsReleaseUISessionId];
        [self remoteScanToNomalScan];
    }
}

// ポップオーバーを閉じる
-(void)popoverClose
{
    if(m_popOver){
        if(m_popOver.popoverVisible){
            // popOverを閉じる
            [m_popOver dismissPopoverAnimated:YES];
        }
    }
    if (m_popOver != nil)
    {
        m_popOver = nil;
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
        
        if(picture_alert != nil)
        {
            [picture_alert dismissViewControllerAnimated:YES completion:^{
                [self alertButtonDismiss:picture_alert tagIndex:picture_alert.tag buttonIndex:2];
            }];
            picture_alert = nil;
        }
        
        if(ex_alert != nil)
        {
            [ex_alert dismissViewControllerAnimated:YES completion:^{
                [self alertButtonPushed:ex_alert tagIndex:ex_alert.tag buttonIndex:2];
            }];
        }
        
        // SetDeviceContext実施からExecuteJob実施まで
        if(bScreenLock)
        {
            nStatus = RSSTATUS_SETDEVICECONTEXT_END_IPAD;
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
    // 復帰後はバックグラウンド処理を終了する
    [self EndBackgroundTask];
    
    if(bRemoteScanRunning)
    {
        // 取り込み処理を続行する
    }
    else
    {
        // 初回はbDoGetJobSettableElementsを行う
//        bDoGetJobSettableElements = NO;
        
//        bDoRetryExecuteJob = NO;
        
//        // ボタンを非活性にする
//        [self setAllButtonEnable:NO];
//        
//        if(![self getIPAdder])
//        {
//            // しばらくお待ちくださいダイアログを出す
//            [self createProgressionAlertWithMessage:nil message: MSG_WAIT withCancel:YES];
//            alert.tag = ALERT_TAG_WAIT_IPAD;
//        }
        
//        // 2秒後に再実行
//        [self performSelector:@selector(rsRequestUISessionId) withObject:nil afterDelay:2.0f];
        
        // ポーリングタイマー停止
        [self stopGetDeviceStatusPolling];
        
        // デバイスにセットされている用紙サイズ取得ポーリングを開始
        originalSizePollingTimer = [NSTimer scheduledTimerWithTimeInterval:2 target:self selector:@selector(rsGetDeviceStatusPolling) userInfo:nil repeats:YES];
    }
}

// バックグラウンド処理が終わった時に呼び出す
-(void)EndBackgroundTask
{
    [[UIApplication sharedApplication] endBackgroundTask:bgTask];
    bgTask = UIBackgroundTaskInvalid;
}

#pragma mark - RSmfpifManager

- (void)startGetMfpIf
{
    [self makePictureAlert:nil message:MSG_SETTING_DEVICE_GETMFP cancelBtnTitle:MSG_BUTTON_CANCEL okBtnTitle:nil tag:ALERT_TAG_REMOTE_CHECK_IPAD showFlg:NO];

    // iOS8以降の場合（起動時にアラートを出そうとして固まってしまうためdispatch_asyncに変更）
    dispatch_async(dispatch_get_main_queue(), ^{
        // アラート表示処理
        [self presentViewController:picture_alert animated:YES completion:nil];
    });
    
    [self performSelector:@selector(startGetMfpIf2) withObject:nil afterDelay:0.5];
}

- (void)startGetMfpIf2
{
    // プリンタ情報取得
    PrinterData* printerData = [m_pPrinterMgr LoadPrinterDataAtIndexInclude2:self.m_nSelPickerRow2];
    
    NSDictionary *dicIPAddr = [CommonUtil getIPAddrDicForComm:[printerData IpAddress]
                                                         port:[NSString stringWithFormat:@"%@", [NSNumber numberWithInteger:80]]];
    NSURL* url = [NSURL URLWithString: [NSString stringWithFormat:@"http://%@:%d/", [CommonUtil optIPAddrForComm:[dicIPAddr objectForKey:S_TARGET_IPADDRESS_DIC_KEY]], 80]];
    mfpManager = [[RSmfpifManager alloc] initWithURL:url];
    
    mfpManager.parserDelegate = self;
    [mfpManager updateData];
    
}

//MFP情報を更新
- (void)startGetMfpIfService
{
    // プリンタ情報取得
    PrinterData* printerData = [m_pPrinterMgr LoadPrinterDataAtIndexInclude2:self.m_nSelPickerRow2];
    
    NSDictionary *dicIPAddr = [CommonUtil getIPAddrDicForComm:[printerData IpAddress]
                                                         port:[NSString stringWithFormat:@"%@", [NSNumber numberWithInteger:80]]];
    NSURL* url = [NSURL URLWithString: [NSString stringWithFormat:@"http://%@:%d/", [CommonUtil optIPAddrForComm:[dicIPAddr objectForKey:S_TARGET_IPADDRESS_DIC_KEY]], 80]];
    mfpServiceManager = [[RSmfpifServiceManager alloc] initWithURL:url];
    
    mfpServiceManager.parserDelegate = self;
    [mfpServiceManager updateData:mfpManager.serviceUrl];
    
}

- (void)savePrinterData
{
    //
	// 自動解放プールの作成
	//
    @try {
        @autoreleasepool
        {
            // PrinterDataManagerクラス初期化
            PrinterDataManager* pPrinterMgr = [[PrinterDataManager alloc] init];
            NSInteger nSaveIdx = -1;
            
            nSaveIdx = [pPrinterMgr GetPrinterIndexForKey:[m_pPrinterInfo PrimaryKey]];
            // 既存情報更新
            [pPrinterMgr ReplacePrinterDataAtIndex:(NSUInteger)nSaveIdx
                                         newObject:m_pPrinterInfo];
            
            // DATファイルに保存
            [pPrinterMgr SavePrinterData];
            }
	}
	@finally
	{
        
	}
    
}

@end
