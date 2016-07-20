
#import "SettingShowDeviceViewController_iPad.h"
#import "Define.h"
#import "PrinterDataManager.h"
#import "CommonUtil.h"
#import "SharpScanPrintAppDelegate.h"
#import "SwitchDataCell.h"
#import "PrintOutDataManager.h"
#import "ProfileDataManager.h"
#import "RemoteScanDataManager.h"

@implementation SettingShowDeviceViewController_iPad

@synthesize PrinterInfo = m_pPrinterInfo;
@synthesize NameCell = m_pNameCell;
@synthesize DeviceNameCell = m_pDeviceNameCell;
@synthesize IpAddressCell = m_pIpAddressCell;
@synthesize PortNoCell = m_pPortNoCell;
@synthesize PlaceCell = m_pPlaceCell;
@synthesize DefaultMFPCell = m_pDefaultMFPCell;
@synthesize ExclusionListCell = m_pExclusionListCell;
@synthesize AutoScan = m_bAutoScan;
@synthesize ConfigScannerSetting = m_pConfigScannerSetting;
@synthesize DispName = m_pDispName;
@synthesize AutoVerifyCode = m_pAutoVerifyCode;
@synthesize VerifyCode = m_pVerifyCode;
@synthesize RemoteScanSettingReset = m_pRemoteScanSettingReset;

#pragma mark -
#pragma mark View lifecycle


- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self)
    {
        // Custom initialization
        isComplete = NO;
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
    
    // セルのラインを表示する
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    
    if (m_pPrinterInfo == nil)
    {
        // 手動で追加時
        m_bAddNew = TRUE;
        m_pPrinterInfo = [[PrinterData alloc] init] ;
        [m_pPrinterInfo setFtpPortNo:N_NUM_FTP_PORT_NO];    // FTPポートNo
        [m_pPrinterInfo setRawPortNo:N_NUM_RAWPRINT_PORT_NO]; // RawポートNo
        [m_pPrinterInfo setHostName:@""];                   // ホスト名
        [m_pPrinterInfo setPortNo:@""];                     // サービスに割当てられたポートNo
        [m_pPrinterInfo setServiceName:@""];                // サービス名
    }
    else
    {
        // 編集時
        m_bAddNew = FALSE;
    }
    
    // ナビゲーションバー
    // タイトル設定
    /*
     if (!m_bAddNew)
     {
     self.navigationItem.title = [m_pPrinterInfo getPrinterName];
     }
     else
     {
     self.navigationItem.title = S_TITLE_SETTING_ADD;
     }
     */
    // タイトル設定
    CGRect frame = CGRectMake(0, 0, 650, 44);
    UILabel* lblTitle = [[UILabel alloc]initWithFrame:frame];
    lblTitle.backgroundColor = [UIColor clearColor];
    lblTitle.textColor = NAVIGATION_TITLE_COLOR;
    lblTitle.font = [UIFont boldSystemFontOfSize:14];
    if ([S_LANG isEqualToString:S_LANG_JA])
    {
        // 国内版の場合、表示文字を小さくする
        lblTitle.adjustsFontSizeToFitWidth = YES;
        lblTitle.minimumScaleFactor = 7 / lblTitle.font.pointSize;
    }
    lblTitle.textAlignment = NSTextAlignmentCenter;
    if(!m_bAddNew)
    {
        lblTitle.text = [m_pPrinterInfo getPrinterName];
    }
    else
    {
        lblTitle.text = S_TITLE_SETTING_ADD;
    }
    lblTitle.lineBreakMode = NSLineBreakByTruncatingTail;
    self.navigationItem.titleView = lblTitle;
    
    // 戻るボタンの名称変更
    UIBarButtonItem * barItemBack = [UIBarButtonItem new];
    barItemBack.title = S_BUTTON_BACK;
    self.navigationItem.backBarButtonItem = barItemBack;
    
    // 保存ボタン追加
    UIBarButtonItem* btnSave = [[UIBarButtonItem alloc] initWithTitle:S_BUTTON_SAVEVAL style:UIBarButtonItemStyleDone target:self action:@selector(OnNavBarRightButton:)];
    self.navigationItem.rightBarButtonItem = btnSave;
    
    // 色変更
    //self.navigationController.navigationBar.tintColor = [UIColor blackColor];
    
    //リストを自動で更新したか確認する
    if ([CommonUtil isAutoScanPrinter:[m_pPrinterInfo HostName]])
    {
        //自動スキャン
        m_bAutoScan = YES;
    }
    else
    {
        //手動スキャン
        m_bAutoScan = NO;
    }
    
    // リモートスキャン対応可否のチェック
    if(m_bAddNew)
    {
        isCapableRemoteScan = NO;
    }
    else
    {
        isCapableRemoteScan = [m_pPrinterInfo IsCapableRemoteScan];
    }
    
    // iPad用
    // Headerの高さを指定
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0.0, 0.0, self.view.frame.size.width, 23.0)];
    self.tableView.tableHeaderView = headerView;
    // iPad用
    //
    // PROFILE情報の取得
    //
    ProfileDataManager *profileDataManager = [[ProfileDataManager alloc] init];
    ProfileData *profileData = nil;
    profileData = [profileDataManager loadProfileDataAtIndex:0];
    
    autoVerifyOn = !profileData.autoCreateVerifyCode;
    
    // 設定クリアフラグ初期化
    isRSSettingClear = NO;
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
    // iPad用
	self.PrinterInfo = nil;
    self.PortNoCell = nil;
    // iPad用
}

/*
 - (void)viewWillAppear:(BOOL)animated
 {
 [super viewWillAppear:animated];
 }
 */

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

/*
 - (void)viewWillDisappear:(BOOL)animated
 {
 [super viewWillDisappear:animated];
 }
 */

/*
 - (void)viewDidDisappear:(BOOL)animated
 {
 [super viewDidDisappear:animated];
 }
 */


// iPad用
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return YES;
}
// iPad用


// ナビゲーションバー 登録ボタン押下
- (IBAction)OnNavBarRightButton:(id)sender
{
    NSString* pstrPrinterName = @"";
    
    // 手動登録MFPの編集時
    if(!m_bAutoScan && !m_bAddNew)
    {
        pstrInitIPAddress = [[m_pPrinterInfo getIPAddress] copy];
        pstrInitPrimaryKey = [[m_pPrinterInfo PrimaryKey] copy];
    }
    
    if ([self CheckError])
	{
		return;
	}

    // 新規追加時と手動登録MFPの編集時
    if(m_bAddNew || !m_bAutoScan)
    {
        // IPアドレスの入力値を格納
        [m_pPrinterInfo setIpAddress:m_pIpAddressCell.EditCellValue.textField.text];
        // プライマリーキーの値を設定
        [m_pPrinterInfo setPrimaryKey:pstrPrimaryKey];
    }
    
    // プリンタ情報設定
    pstrPrinterName = m_pNameCell.EditCellValue.textField.text;
    if ((pstrPrinterName == nil || [pstrPrinterName isEqualToString:@""]) && !m_bAddNew)
    {
        //空白の場合はIPアドレスを名称に設定する(新規手動追加の場合は除く)
        [m_pPrinterInfo setPrinterName:[m_pPrinterInfo IpAddress]];
    }
    else
    {
        //名称
        [m_pPrinterInfo setPrinterName:pstrPrinterName];
    }
    
    // 製品名
    [m_pPrinterInfo setProductName:m_pDeviceNameCell.EditCellValue.textField.text];
    
    // 設置場所
    [m_pPrinterInfo setPlace:m_pPlaceCell.EditCellValue.textField.text];
    
    // FTPポートNo
    //
    // PROFILE情報の取得
    //
    ProfileDataManager *profileDataManager = [[ProfileDataManager alloc] init];
    ProfileData *profileData = nil;
    profileData = [profileDataManager loadProfileDataAtIndex:0];
    
    // 設定画面でRawPrintを使用するをONにしている場合
    if(profileData.useRawPrintMode)
    {
        [m_pPrinterInfo setRawPortNo:m_pPortNoCell.EditCellValue.textField.text];
    }
    else
    {
        [m_pPrinterInfo setFtpPortNo:m_pPortNoCell.EditCellValue.textField.text];
    }
    
    // 除外リストに追加
    BOOL isExclusionList = FALSE;
    if(self.ExclusionListCell.switchField.on == YES)
    {
        isExclusionList = TRUE;
    }
    m_pPrinterInfo.ExclusionList = isExclusionList;
    
    // リモートスキャン機能
    if ((m_bAddNew || !m_bAutoScan)) {
        [self startGetMfpIf];
    }
    else
    {
        [self savePrinterData];
    }
    
    // リモートスキャン設定クリア判定
    //    if(m_pRemoteScanSettingReset.switchField.on){
    //        [[RemoteScanDataManager sharedManager] removeRemoteScanSettings];
    //    }
    
}

- (void)savePrinterData
{
    //
	// 自動解放プールの作成
	//
    @autoreleasepool
    {
        @try {
            // PrinterDataManagerクラス初期化
            PrinterDataManager* pPrinterMgr = [[PrinterDataManager alloc] init];
            NSInteger nSaveIdx = -1;
            
            // 手動登録MFPの編集時
            if(!m_bAddNew && !m_bAutoScan)
            {
                nSaveIdx = [pPrinterMgr GetPrinterIndexForKey:pstrInitPrimaryKey];
            }
            else
            {
                nSaveIdx = [pPrinterMgr GetPrinterIndexForKey:[m_pPrinterInfo PrimaryKey]];
            }
            
            if (nSaveIdx > -1)
            {
                if(!m_bAddNew)
                {
                    // 既存情報更新
                    [pPrinterMgr ReplacePrinterDataAtIndex:(NSUInteger)nSaveIdx
                                                 newObject:m_pPrinterInfo];
                }
                else
                {
                    // 既に登録されている場合は、エラーメッセージを表示する。
                    SharpScanPrintAppDelegate* appDelegate = (SharpScanPrintAppDelegate*)[[UIApplication sharedApplication] delegate];
                    // 処理実行フラグON
                    appDelegate.IsRun = TRUE;
                    
                    [self makeTmpExAlert:nil message:[NSString stringWithFormat:MSG_SAME_DEVICE_ERR, SUBMSG_HOSTNAME_ERR] cancelBtnTitle:MSG_BUTTON_OK okBtnTitle:nil tag:0];
                    return;
                }
            }
            else
            {
                // 最後尾に追加
                [pPrinterMgr AddPrinterDataAtIndex:[pPrinterMgr CountOfPrinterData]
                                         newObject:m_pPrinterInfo];
            }
            
            // DATファイルに保存
            [pPrinterMgr SavePrinterData];
            
            // DefaultMFP設定ONの場合、印刷／取り込み画面の選択中MFP情報を更新
            if(self.DefaultMFPCell.switchField.enabled && self.DefaultMFPCell.switchField.on && !self.ExclusionListCell.switchField.on)
            {
                PrintOutDataManager* pPrintOutMgr= [[PrintOutDataManager alloc] init];
                [pPrintOutMgr SetLatestPrimaryKey:[m_pPrinterInfo PrimaryKey]];
            }
            
            
            // リモートスキャン設定値の保存
            if(self.tableView.numberOfSections > 2)
            {
                ProfileDataManager *profileDataManager = [[ProfileDataManager alloc] init];
                ProfileData *profileData = nil;
                profileData = [profileDataManager loadProfileDataAtIndex:0];
                // スキャナーの動作設定
                // 端末側からスキャナーの設定を行う
                //            BOOL isConfigScannerSetting = FALSE;
                //            if(m_pConfigScannerSetting.switchField.on){
                //                isConfigScannerSetting = TRUE;
                //            }
                profileData.configScannerSetting = !m_pConfigScannerSetting.switchField.on;
                
                // 確認コードは自動で作成
                profileData.autoCreateVerifyCode = !m_pAutoVerifyCode.switchField.on;
                // 確認コード
                profileData.verifyCode = m_pVerifyCode.EditCellValue.textField.text;
                
                //
                // クラス値の変更
                //
                [profileDataManager replaceProfileDataAtIndex:0 newObject:profileData];
                
                //
                // 保存
                //
                [profileDataManager saveProfileData];
                
            }
        }
        @finally
        {
		}
	}
    
    // 前画面に戻る
    [self.navigationController popViewControllerAnimated:YES];
}

// 入力チェック
- (NSInteger)CheckError
{
	NSInteger nRet = ERR_SUCCESS;
	NSString* pstrMessage = @"";
	NSString* pstrText = @"";
    NSString* subMsg = nil;
	
    // 名称チェック
    if (nRet == ERR_SUCCESS)
    {
        nRet = [CommonUtil IsDeviceName:self.NameCell.EditCellValue.textField.text];
        pstrText = SUBMSG_DEVICENAME_ERR;
        subMsg = SUBMSG_LOGINNAME_FORMAT;
        
        if (nRet == ERR_SUCCESS)
        {
            // 絵文字チェック
            if ( [CommonUtil IsUsedEmoji: self.NameCell.EditCellValue.textField.text] ) {
                nRet = ERR_INVALID_CHAR_TYPE;
                pstrText = SUBMSG_DEVICENAME_ERR;
                subMsg = SUBMSG_EMOJI;
            }
        }
    }
    //製品名チェック
    if (nRet == ERR_SUCCESS)
    {
        nRet = [CommonUtil IsProductName:self.DeviceNameCell.EditCellValue.textField.text];
        pstrText = SUBMSG_DEVICEINPUTNAME_ERR;
        subMsg = SUBMSG_DEVICENAME_FORMAT;
        
        if (nRet == ERR_SUCCESS)
        {
            // 絵文字チェック
            if ( [CommonUtil IsUsedEmoji: self.DeviceNameCell.EditCellValue.textField.text] ) {
                nRet = ERR_INVALID_CHAR_TYPE;
                pstrText = SUBMSG_DEVICEINPUTNAME_ERR;
                subMsg = SUBMSG_EMOJI;
            }
        }
    }
    
    //ポート番号チェック
    if (nRet == ERR_SUCCESS)
    {
        nRet = [CommonUtil IsPortNo:self.PortNoCell.EditCellValue.textField.text];
        pstrText = SUBMSG_PORT_ERR;
    }

    //IPアドレスチェック（新規追加時と手動登録MFPの編集時）
    pstrPrimaryKey = pstrInitPrimaryKey;
    if (((m_bAddNew) || ((!m_bAutoScan && ![pstrInitIPAddress isEqualToString:self.IpAddressCell.EditCellValue.textField.text]))) && (nRet == ERR_SUCCESS))
    {
#ifdef IPV6_VALID
        // 入力チェック
        if ([CommonUtil strLength:self.IpAddressCell.EditCellValue.textField.text] <= 0) {
            nRet = ERR_NO_INPUT;
            pstrText = SUBMSG_HOSTNAME_ERR;
        }
    
        // 文字数チェック 半角255文字チェック
        if ([CommonUtil strLength:self.IpAddressCell.EditCellValue.textField.text] > 255) {
            nRet = ERR_OVER_INPUT;
            pstrText = SUBMSG_HOSTNAME_ERR;
            subMsg = SUBMSG_HOSTNAME_LEN_ERR;
        }
        
        // 半角英数記号チェック
        if (nRet == ERR_SUCCESS) {
            if (![CommonUtil isAplhaNumericSymbol:self.IpAddressCell.EditCellValue.textField.text]) {
                nRet = ERR_INVALID_CHAR_TYPE;
                pstrText = SUBMSG_HOSTNAME_ERR;
                subMsg = SUBMSG_HOSTNAME_LEN_ERR;
            }
        }
#else
        nRet = [CommonUtil isIPAddr:self.IpAddressCell.EditCellValue.textField.text];
        pstrText = SUBMSG_IPADDR_ERR;
#endif
        
        if(nRet == ERR_SUCCESS)
        {
#ifdef IPV6_VALID
            // プライマリキーの設定
            if (![CommonUtil isValidIPv4StringFormat:m_pIpAddressCell.EditCellValue.textField.text] &&
                ![CommonUtil isValidIPv6StringFormat:m_pIpAddressCell.EditCellValue.textField.text]) {
                
                // 入力された値がホスト名の場合(IPアドレス形式でない場合)
                pstrPrimaryKey = [m_pIpAddressCell.EditCellValue.textField.text stringByAppendingString:@"@Manual"];
            }
            else {
                pstrPrimaryKey = m_pIpAddressCell.EditCellValue.textField.text;
            }
#else
            pstrPrimaryKey = m_pIpAddressCell.EditCellValue.textField.text;
#endif
            
            // 重複チェック
            // PrinterDataManagerクラス初期化
            PrinterDataManager* pPrinterMgr = [[PrinterDataManager alloc] init];
            NSInteger nSaveIdx = -1;
            nSaveIdx = [pPrinterMgr GetPrinterIndexForKey:pstrPrimaryKey];
            if (nSaveIdx > -1)
            {
                nRet = ERR_INPUT_DUPULICATE;
                pstrText = SUBMSG_HOSTNAME_ERR;
            }
            else if (self.DefaultMFPCell.switchField.on)
            {
                // 重複してないので置き換える
                PrintOutDataManager* pPrintOutMgr= [[PrintOutDataManager alloc] init];
                [pPrintOutMgr SetLatestPrimaryKey:pstrPrimaryKey];
            }
            
        }
    }
    
    //設置場所チェック
    if (nRet == ERR_SUCCESS)
    {
        nRet = [CommonUtil IsPlace:self.PlaceCell.EditCellValue.textField.text];
        pstrText = SUBMSG_DEVICEPLACE_ERR;
        subMsg = SUBMSG_DEVICENAME_FORMAT;
        
        if (nRet == ERR_SUCCESS)
        {
            // 絵文字チェック
            if ( [CommonUtil IsUsedEmoji: self.PlaceCell.EditCellValue.textField.text] ) {
                nRet = ERR_INVALID_CHAR_TYPE;
                pstrText = SUBMSG_DEVICEPLACE_ERR;
                subMsg = SUBMSG_EMOJI;
            }
        }
    }
    
    //確認コード入力チェック
    if (nRet == ERR_SUCCESS)
    {
        // 確認コードが表示されている場合
        if(self.tableView.numberOfSections > 2 && !autoVerifyOn)
        {
            if(m_pVerifyCode.EditCellValue.textField.text == nil)
            {
                //　PROFILE情報に確認コードが定義されていない場合デフォルトに設定(default値 @"0000")
                //
                // PROFILE情報の取得
                //
                ProfileDataManager *profileDataManager = [[ProfileDataManager alloc] init];
                ProfileData *profileData = nil;
                profileData = [profileDataManager loadProfileDataAtIndex:0];
                if(profileData.verifyCode)
                {
                    profileData.verifyCode = @"0000";
                }
            }
            else
            {
                nRet = [CommonUtil checkVerifyCode:m_pVerifyCode.EditCellValue.textField.text];
                pstrText = SUBMSG_VERIFY_CODE_ERR;
            }
        }
    }
	
	// エラーメッセージ表示
	if (nRet != ERR_SUCCESS)
	{
		switch (nRet)
		{
			case ERR_NO_INPUT:	// 未入力
				pstrMessage = [NSString stringWithFormat:MSG_REQUIRED_ERR, pstrText];
				break;
			case ERR_INVALID_FORMAT:	// 入力形式不正
                if( [pstrText isEqualToString:SUBMSG_DEVICENAME_ERR] ){
                    pstrMessage = [NSString stringWithFormat:MSG_FORMAT_ERR, pstrText, subMsg];
                } else if ([pstrText isEqualToString:SUBMSG_DEVICEINPUTNAME_ERR]){
                    pstrMessage = [NSString stringWithFormat:MSG_FORMAT_ERR, pstrText, subMsg];
                } else if ([pstrText isEqualToString:SUBMSG_DEVICEPLACE_ERR]){
                    pstrMessage = [NSString stringWithFormat:MSG_FORMAT_ERR, pstrText, subMsg];
                } else if ([pstrText isEqualToString:SUBMSG_IPADDR_ERR]){
                    pstrMessage = [NSString stringWithFormat:MSG_FORMAT_ERR, pstrText, SUBMSG_IPADDR_FORMAT];
                }
				break;
			case ERR_INVALID_CHAR_TYPE:	// 文字種不正
                if( [pstrText isEqualToString:SUBMSG_DEVICENAME_ERR] ){
                    pstrMessage = [NSString stringWithFormat:MSG_CHAR_TYPE_ERR, pstrText, subMsg];
                } else if ([pstrText isEqualToString:SUBMSG_DEVICEINPUTNAME_ERR]){
                    pstrMessage = [NSString stringWithFormat:MSG_CHAR_TYPE_ERR, pstrText, subMsg];
                } else if ([pstrText isEqualToString:SUBMSG_DEVICEPLACE_ERR]){
                    pstrMessage = [NSString stringWithFormat:MSG_CHAR_TYPE_ERR, pstrText, subMsg];
                } else if ([pstrText isEqualToString:SUBMSG_HOSTNAME_ERR])
                {
                    pstrMessage = [NSString stringWithFormat:MSG_CHAR_TYPE_ERR, SUBMSG_HOSTNAME_ERR, SUBMSG_HOSTNAME_LEN_ERR];
                }
                else if ([pstrText isEqualToString:SUBMSG_PORT_ERR])
                {
                    pstrMessage = [NSString stringWithFormat:MSG_CHAR_TYPE_ERR, SUBMSG_PORT_ERR, SUBMSG_ONLY_HALFCHAR_NUMBER];
                }
                else if ([pstrText isEqualToString:SUBMSG_VERIFY_CODE_ERR])
                {
                    pstrMessage = [NSString stringWithFormat:MSG_CHAR_TYPE_ERR, SUBMSG_VERIFY_CODE_ERR, SUBMSG_ONLY_HALFCHAR_NUMBER];
                }
				break;
			case ERR_OVER_NUM_RANGE:	// 数値範囲外
                if( [pstrText isEqualToString:SUBMSG_DEVICENAME_ERR] ){
                    pstrMessage = [NSString stringWithFormat:MSG_LENGTH_ERR, pstrText, subMsg];
                } else if ([pstrText isEqualToString:SUBMSG_DEVICEINPUTNAME_ERR]){
                    pstrMessage = [NSString stringWithFormat:MSG_LENGTH_ERR, pstrText, subMsg];
                } else if ([pstrText isEqualToString:SUBMSG_DEVICEPLACE_ERR]){
                    pstrMessage = [NSString stringWithFormat:MSG_LENGTH_ERR, pstrText, subMsg];
                }else if( [pstrText isEqualToString:SUBMSG_PORT_ERR] ){
                    pstrMessage = [NSString stringWithFormat:MSG_NUM_RANGE_ERR, SUBMSG_PORT_ERR, SUBMSG_PORTNO_RANGE];
                } else if ( [pstrText isEqualToString:SUBMSG_VERIFY_CODE_ERR] ){
                    pstrMessage = [NSString stringWithFormat:MSG_LENGTH_ERR, SUBMSG_VERIFY_CODE_ERR, SUBMSG_VERIFY_CODE_RANGE];
                }
				break;
            case ERR_INPUT_DUPULICATE:  // 重複
                pstrMessage = [NSString stringWithFormat:MSG_SAME_DEVICE_ERR, SUBMSG_HOSTNAME_ERR];
                break;
            case ERR_OVER_INPUT:        // 文字数超過
                pstrMessage = [NSString stringWithFormat:MSG_LENGTH_ERR, pstrText, SUBMSG_HOSTNAME_LEN_ERR];
                break;
			default:
				break;
		}
        
        // iPad用
        SharpScanPrintAppDelegate* appDelegate = (SharpScanPrintAppDelegate*)[[UIApplication sharedApplication] delegate];
        // 処理実行フラグON
        appDelegate.IsRun = TRUE;
        
        [self makeTmpExAlert:nil message:pstrMessage cancelBtnTitle:MSG_BUTTON_OK okBtnTitle:nil tag:0];
	}
	
	return nRet;
}

// 処理中アラート表示
- (void)CreateProgressAlert:(NSString *)pstrTitle
                    message:(NSString *)pstrMessage
                 withCancel:(BOOL)bCancel
{
	@autoreleasepool
    {
        
        if (bCancel)
        {
            [self makeAlert:nil message:pstrMessage cancelBtnTitle:MSG_BUTTON_CANCEL okBtnTitle:nil tag:1];
        }
        else
        {
            [self makeAlert:nil message:pstrMessage cancelBtnTitle:nil okBtnTitle:nil tag:1];
        }
	}
}

// アラートボタン押下処理
-(void)alertButtonPushed:(UIAlertController *)alertController tagIndex:(NSInteger)tagIndex buttonIndex:(NSInteger)buttonIndex
{
    [self alertButtonClicked:alertController tagIndex:tagIndex buttonIndex:buttonIndex];
    [self alertButtonDismiss:alertController tagIndex:tagIndex buttonIndex:buttonIndex];
}

-(void)alertButtonClicked:(UIAlertController *)alertController tagIndex:(NSInteger)tagIndex buttonIndex:(NSInteger)buttonIndex
{
    switch (tagIndex) {
        case 1:
            switch (buttonIndex){
                case 0:
                    //SNMP検索
                    // キャンセル押下時
                    [mfpManager disconnect];
                    mfpManager = NULL;
                    [mfpServiceManager disconnect];
                    mfpServiceManager = NULL;
                    isEnd = YES;
                    break;
                default:
                    break;
            }
            break;
        case 2:
            switch (buttonIndex) {
                case 0:
                    // キャンセル
                    break;
                    
                case 1:
                    // 登録
                    isComplete = YES;
                    break;
                    
                default:
                    break;
            }
        case 3:
            switch (buttonIndex) {
                case 0:
                    // キャンセル
                    break;
                    
                case 1:
                    // 登録
                    isComplete = YES;
                    break;
                    
                default:
                    break;
            }
        case 4:
            switch (buttonIndex) {
                case 0:
                    // キャンセル
                    break;
                    
                case 1:
                    // 設定をリセットする
                    [[RemoteScanDataManager sharedManager] removeRemoteScanSettings];
                    break;
                    
                default:
                    break;
            }
        default:
            break;
    }
}

-(void)alertButtonDismiss:(UIAlertController *)alertController tagIndex:(NSInteger)tagIndex buttonIndex:(NSInteger)buttonIndex
{
    // iPad用
    SharpScanPrintAppDelegate* appDelegate = (SharpScanPrintAppDelegate*)[[UIApplication sharedApplication] delegate];
    // 処理実行フラグOFF
    appDelegate.IsRun = FALSE;
}


- (void)startGetMfpIf
{
    SharpScanPrintAppDelegate* appDelegate = (SharpScanPrintAppDelegate*)[[UIApplication sharedApplication] delegate];
    // 処理実行フラグON
    appDelegate.IsRun = TRUE;
    
    [self CreateProgressAlert:nil message:MSG_SETTING_DEVICE_GETMFP withCancel:YES];
    
    NSDictionary *dicIPAddr = [CommonUtil getIPAddrDicForComm:m_pIpAddressCell.EditCellValue.textField.text
                                                         port:[NSString stringWithFormat:@"%@", [NSNumber numberWithInteger:80]]];
    NSURL* url = [NSURL URLWithString: [NSString stringWithFormat:@"http://%@:%d/", [CommonUtil optIPAddrForComm:[dicIPAddr objectForKey:S_TARGET_IPADDRESS_DIC_KEY]], 80]];
    mfpManager = [[RSmfpifManager alloc] initWithURL:url];
    
    mfpManager.parserDelegate = self;
    [mfpManager updateData];
    
}

- (void)startGetMfpIfServiceWithFlags:(BOOL) setOsaHttpPortGetFlag
    setPrintReleaseDataReceiveGetFlag:(BOOL) setPrintReleaseDataReceiveGetFlag
                  setModelNameGetFlag:(BOOL) setModelNameGetFlag
                   setLocationGetFlag:(BOOL) setLocationGetFlag
{
    SharpScanPrintAppDelegate* appDelegate = (SharpScanPrintAppDelegate*)[[UIApplication sharedApplication] delegate];
    // 処理実行フラグON
    appDelegate.IsRun = TRUE;
    
    NSDictionary *dicIPAddr = [CommonUtil getIPAddrDicForComm:m_pIpAddressCell.EditCellValue.textField.text
                                                         port:[NSString stringWithFormat:@"%@", [NSNumber numberWithInteger:80]]];
    NSURL* url = [NSURL URLWithString: [NSString stringWithFormat:@"http://%@:%d/", [CommonUtil optIPAddrForComm:[dicIPAddr objectForKey:S_TARGET_IPADDRESS_DIC_KEY]], 80]];
    mfpServiceManager = [[RSmfpifServiceManager alloc] initWithURL:url];
    
    mfpServiceManager.setOsaHttpPortGetFlag = setOsaHttpPortGetFlag;
    mfpServiceManager.setPrintReleaseDataReceiveGetFlag = setPrintReleaseDataReceiveGetFlag;
    mfpServiceManager.setModelNameGetFlag = setModelNameGetFlag;    // 製品名
    mfpServiceManager.setLocationGetFlag = setLocationGetFlag;      // 設置場所
    
    mfpServiceManager.parserDelegate = self;
    [mfpServiceManager updateData:mfpManager.serviceUrl];
    
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    int cnt = 0;
    if(isCapableRemoteScan)
    {
        cnt = N_NUM_SECTION_SETTING_SHOW_INFO;
    }
    else
    {
        cnt = N_NUM_SECTION_SETTING_SHOW_INFO -2;
    }
    
    return cnt;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
	NSInteger nRet = 0;
	if(section == 0)
	{
        nRet = N_NUM_ROW_SETTING_SHOW_INFO_SEC1;
	}
	else if(section == 1)
	{
        /* 除外MFPリストは国内版のみ対応 */
        // 20121113 国内版でも除外リストは削除
        if (0)
        {
            nRet = N_NUM_ROW_SETTING_SHOW_INFO_SEC2;
        }
        else
        {
            nRet = N_NUM_ROW_SETTING_SHOW_INFO_SEC2 -1;
        }
	}
    else if(section == 2)
    {
        if(autoVerifyOn)
        { // 確認コードは自動で生成する場合は確認コードのcellを生成しない
            nRet = N_NUM_ROW_SETTING_SHOW_INFO_SEC3 -1;
        }else{
            nRet = N_NUM_ROW_SETTING_SHOW_INFO_SEC3;
        }
    }
    else if(section == 3)
    {
        nRet = 1;
    }
	return nRet;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    // 表示データをセルに設定
    if (indexPath.section == 0)
    {
        NSString *CellIdentifier = [NSString stringWithFormat:@"Cell%02ld%02ld", (long)indexPath.section, (long)indexPath.row];
        NSString* pstrTitle = @"";
        NSString* pstrValue = @"";
        
        // セル作成
        PrinterDetailDataCell *cell = (PrinterDetailDataCell*)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (cell)
        {
            //セルがすでに作成済みの場合は初期化処理を行わずに抜ける
            return cell;
        }
        
        NSInteger cellType = indexPath.row;
        switch (cellType)
        {
            case 0:
                pstrTitle = S_SETTING_DEVICE_NAME;
                pstrValue = [m_pPrinterInfo getPrinterName];
                
                if (self.NameCell == nil)
                {
                    m_pNameCell = [[PrinterDetailDataCell alloc] initWithStyle:UITableViewCellStyleDefault
                                                               reuseIdentifier:CellIdentifier
                                                                    isEditCell:YES];
                }
                
                cell = m_pNameCell;
                
                // 名称は入力可能
                [cell SetCellPrinterInfo:pstrTitle
                                   value:pstrValue
                           hasDisclosure:NO
                              IsEditCell:TRUE
                            keyboardType:UIKeyboardTypeNumbersAndPunctuation];
                // デリゲート
                cell.EditCellValue.textField.delegate = self;
                break;
            case 1:
                pstrTitle = S_SETTING_DEVICE_DEVICENAME;
                pstrValue = [m_pPrinterInfo ProductName];
                
                if (self.DeviceNameCell == nil)
                {
                    m_pDeviceNameCell = [[PrinterDetailDataCell alloc] initWithStyle:UITableViewCellStyleDefault
                                                                     reuseIdentifier:CellIdentifier
                                                                          isEditCell:YES];
                }
                
                cell = m_pDeviceNameCell;
                
                // 製品名は入力可能
                [cell SetCellPrinterInfo:pstrTitle
                                   value:pstrValue
                           hasDisclosure:NO
                              IsEditCell:TRUE
                            keyboardType:UIKeyboardTypeNumbersAndPunctuation];
                // デリゲート
                cell.EditCellValue.textField.delegate = self;
                break;
            case 2:
#ifdef IPV6_VALID
                pstrTitle = S_SETTING_DEVICE_HOSTNAME;
#else
                pstrTitle = S_SETTING_DEVICE_IP_ADDRESS;
#endif
                pstrValue = [m_pPrinterInfo IpAddress];
                
                BOOL isEditEnabled = (m_bAddNew || !m_bAutoScan);
                
                if (self.IpAddressCell == nil)
                {
                    m_pIpAddressCell = [[PrinterDetailDataCell alloc] initWithStyle:UITableViewCellStyleDefault
                                                                    reuseIdentifier:CellIdentifier
                                                                         isEditCell:isEditEnabled];
                }
                
                cell = m_pIpAddressCell;
                
                if(isEditEnabled){
                    
                    // IPアドレスは入力可能
                    [cell SetCellPrinterInfo:pstrTitle
                                       value:pstrValue
                               hasDisclosure:NO
                                  IsEditCell:TRUE
                                keyboardType:UIKeyboardTypeNumbersAndPunctuation];
                    
#ifndef IPV6_VALID
                    cell.EditCellValue.textField.placeholder = @"xxx.xxx.xxx.xxx";
#endif
                    // デリゲート
                    cell.EditCellValue.textField.delegate = self;
                }
                else {
                    // IPアドレスは入力不可
                    [cell SetCellPrinterInfo:pstrTitle
                                       value:pstrValue
                               hasDisclosure:NO
                                  IsEditCell:FALSE
                                keyboardType:UIKeyboardTypeNumbersAndPunctuation];
                }
                
                break;
            case 3: {
                pstrTitle = S_SETTING_DEVICE_PORT;
                // todo プロファイルのRawを確認し、Rawポートのデータを表示する
                //
                // PROFILE情報の取得
                //
                ProfileDataManager *profileDataManager = [[ProfileDataManager alloc] init];
                ProfileData *profileData = nil;
                profileData = [profileDataManager loadProfileDataAtIndex:0];
                
                // 設定画面でRawPrintを使用するをONにしている場合
                if(profileData.useRawPrintMode)
                {
                    pstrValue = [m_pPrinterInfo RawPortNo];
                }
                else
                {
                    pstrValue = [m_pPrinterInfo FtpPortNo];
                }
                
                if (self.PortNoCell == nil)
                {
                    m_pPortNoCell = [[PrinterDetailDataCell alloc] initWithStyle:UITableViewCellStyleDefault
                                                                 reuseIdentifier:CellIdentifier
                                                                      isEditCell:YES];
                }
                
                cell = m_pPortNoCell;
                
                // ポート番号は入力可能
                [cell SetCellPrinterInfo:pstrTitle
                                   value:pstrValue
                           hasDisclosure:NO
                              IsEditCell:TRUE
                            keyboardType:UIKeyboardTypeNumbersAndPunctuation];
                // デリゲート
                cell.EditCellValue.textField.delegate = self;
                break;
            }
            case 4:
                pstrTitle = S_SETTING_DEVICE_PLACE;
                pstrValue = [m_pPrinterInfo Place];
                
                if (self.PlaceCell == nil)
                {
                    m_pPlaceCell = [[PrinterDetailDataCell alloc] initWithStyle:UITableViewCellStyleDefault
                                                                reuseIdentifier:CellIdentifier
                                                                     isEditCell:YES];
                }
                
                cell = m_pPlaceCell;
                
                //設定場所は入力可能
                [cell SetCellPrinterInfo:pstrTitle
                                   value:pstrValue
                           hasDisclosure:NO
                              IsEditCell:TRUE
                            keyboardType:UIKeyboardTypeNumbersAndPunctuation];
                //デリゲート
                cell.EditCellValue.textField.delegate = self;
                break;
            default:
                break;
        }
        
        return cell;
    }
    else if(indexPath.section == 1)
    {
        if(indexPath.row == 0)
        {
            NSString* CellIdentifier = @"DefaultMFPCell";
            
            self.DefaultMFPCell = (SwitchDataCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
            if (self.DefaultMFPCell == nil)
            {
                self.DefaultMFPCell = [[SwitchDataCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
            }
            self.DefaultMFPCell.nameLabelCell.text		= S_SETTING_DEVICE_DEFAULT_MFP;
            self.DefaultMFPCell.switchField.on			= [m_pPrinterInfo DefaultMFP];
            
            if(![S_LANG isEqualToString:S_LANG_EN]){
                // 自動調整サイズを取得
                CGFloat actualFontSize;
                [self.DefaultMFPCell.nameLabelCell.text
                 sizeWithFont:self.DefaultMFPCell.nameLabelCell.font
                 minFontSize:(self.DefaultMFPCell.nameLabelCell.minimumScaleFactor * self.DefaultMFPCell.nameLabelCell.font.pointSize)
                 actualFontSize:&actualFontSize
                 forWidth:self.DefaultMFPCell.nameLabelCell.bounds.size.width
                 lineBreakMode:self.DefaultMFPCell.nameLabelCell.lineBreakMode];
                
                // 自動調整したフォントサイズが10以下なら、二段表示するか判定を行う
                if(actualFontSize < 11)
                {
                    int iFontSize = [self.DefaultMFPCell changeFontSize:self.DefaultMFPCell.nameLabelCell.text];
                    if (iFontSize != -1)
                    {
                        self.DefaultMFPCell.nameLabelCell.lineBreakMode = NSLineBreakByWordWrapping;
                        self.DefaultMFPCell.nameLabelCell.numberOfLines = 2;
                        [self.DefaultMFPCell.nameLabelCell setFont:[UIFont systemFontOfSize:iFontSize]];
                        // サイズ調整
                        CGRect frame =  self.DefaultMFPCell.nameLabelCell.frame;
                        frame.size.height = 36;
                        self.DefaultMFPCell.nameLabelCell.frame = frame;
                    }
                }
            } else {
                self.DefaultMFPCell.nameLabelCell.lineBreakMode = NSLineBreakByWordWrapping;
                self.DefaultMFPCell.nameLabelCell.numberOfLines = 2;
                // サイズ調整
                CGRect frame =  self.DefaultMFPCell.nameLabelCell.frame;
                frame.size.height = 36;
                self.DefaultMFPCell.nameLabelCell.frame = frame;
            }
            
            if(self.DefaultMFPCell.switchField.on)
            {
                // 選択中の場合は非活性
                self.DefaultMFPCell.switchField.enabled = false;
            }
            else
            {
                // PROFILE情報の取得
                ProfileDataManager *profileDataManager = [[ProfileDataManager alloc] init];
                ProfileData *profileData = nil;
                profileData = [profileDataManager loadProfileDataAtIndex:0];
                // プリンター/スキャナー自動切替がONの場合は非活性
                self.DefaultMFPCell.switchField.enabled = !profileData.autoSelectMode;
            }
            
            return self.DefaultMFPCell;
        }
        else if(indexPath.row == 1)
        {
            NSString* CellIdentifier = @"ExclusionListCell";
            
            self.ExclusionListCell = (SwitchDataCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
            if (self.ExclusionListCell == nil)
            {
                self.ExclusionListCell = [[SwitchDataCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
            }
            self.ExclusionListCell.nameLabelCell.text		= S_SETTING_DEVICE_ADD_EXCLUTIONLIST;
            self.ExclusionListCell.switchField.on			= m_pPrinterInfo.ExclusionList;
            
            if(![S_LANG isEqualToString:S_LANG_EN]){
                // 自動調整サイズを取得
                CGFloat actualFontSize;
                [self.ExclusionListCell.nameLabelCell.text
                 sizeWithFont:self.ExclusionListCell.nameLabelCell.font
                 minFontSize:(self.ExclusionListCell.nameLabelCell.minimumScaleFactor * self.ExclusionListCell.nameLabelCell.font.pointSize)
                 actualFontSize:&actualFontSize
                 forWidth:self.ExclusionListCell.nameLabelCell.bounds.size.width
                 lineBreakMode:self.ExclusionListCell.nameLabelCell.lineBreakMode];
                
                // 自動調整したフォントサイズが10以下なら、二段表示するか判定を行う
                if(actualFontSize < 11)
                {
                    int iFontSize = [self.ExclusionListCell changeFontSize:self.ExclusionListCell.nameLabelCell.text];
                    if (iFontSize != -1)
                    {
                        self.ExclusionListCell.nameLabelCell.lineBreakMode = NSLineBreakByWordWrapping;
                        self.ExclusionListCell.nameLabelCell.numberOfLines = 2;
                        [self.ExclusionListCell.nameLabelCell setFont:[UIFont systemFontOfSize:iFontSize]];
                        // サイズ調整
                        CGRect frame =  self.ExclusionListCell.nameLabelCell.frame;
                        frame.size.height = 36;
                        self.ExclusionListCell.nameLabelCell.frame = frame;
                    }
                }
            } else {
                self.ExclusionListCell.nameLabelCell.lineBreakMode = NSLineBreakByWordWrapping;
                self.ExclusionListCell.nameLabelCell.numberOfLines = 2;
                // サイズ調整
                CGRect frame =  self.ExclusionListCell.nameLabelCell.frame;
                frame.size.height = 36;
                self.ExclusionListCell.nameLabelCell.frame = frame;
            }
            
            // 自動スキャンでない機器の場合は、非活性
            if(!m_bAutoScan || m_bAddNew)
            {
                self.ExclusionListCell.switchField.enabled = NO;
            }
            
            return self.ExclusionListCell;
        }
    }
    else if(indexPath.section == 2)
    {
        NSString *CellIdentifier = [NSString stringWithFormat:@"Cell%02ld%02ld", (long)indexPath.section, (long)indexPath.row];
        
        // セル作成
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (cell == nil)
        {
            //
            // PROFILE情報の取得
            //
            ProfileDataManager *profileDataManager = [[ProfileDataManager alloc] init];
            ProfileData *profileData = nil;
            profileData = [profileDataManager loadProfileDataAtIndex:0];
            
            switch(indexPath.row){
                case 0:
                {
                    // 端末側からスキャナーの設定を行う
                    self.ConfigScannerSetting = [[SwitchDataCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
                    self.ConfigScannerSetting.nameLabelCell.text = S_SETTING_DEVICE_REMOTE_SCAN;
                    self.ConfigScannerSetting.switchField.on = !profileData.configScannerSetting;
                    cell = self.ConfigScannerSetting;
                    break;
                }
                    
                case 1:
                {
                    // 表示名
                    
                    if ( ! self.DispName ) {
                        m_pDispName = [[PrinterDetailDataCell alloc] initWithStyle:UITableViewCellStyleDefault
                                                                   reuseIdentifier:CellIdentifier
                                                                        isEditCell:NO];
                    }
                    
                    cell = m_pDispName;
                    
                    [(PrinterDetailDataCell *)cell SetCellPrinterInfo: S_SETTING_USERINFO_NAME
                                                                value: profileData.profileName
                                                        hasDisclosure: NO
                                                           IsEditCell: FALSE
                                                         keyboardType: UIKeyboardTypeNumbersAndPunctuation];
                    
                    break;
                }
                    
                case 2:
                {
                    // 確認コードは自動で作成
                    self.AutoVerifyCode = [[SwitchDataCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
                    self.AutoVerifyCode.nameLabelCell.text = S_SETTING_DEVICE_REMOTE_CODEAUTO;
                    self.AutoVerifyCode.switchField.on = autoVerifyOn;
                    //
                    self.AutoVerifyCode.switchField.tag = 2; // tag name?
                    [self.AutoVerifyCode.switchField addTarget:self action:@selector(changeSwitchValue:) forControlEvents:UIControlEventValueChanged];
                    //
                    
                    cell = self.AutoVerifyCode;
                    
                    break;
                }
                    
                case 3:
                {
                    if(self.AutoVerifyCode.switchField.on)
                    {
                        /*
                         // リセット
                         // セルの作成
                         self.RemoteScanSettingReset = [[[ButtonDataCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier]autorelease];
                         
                         //                        self.RemoteScanSettingReset.nameLabelCell.text = @"設定をリセットする";
                         [self.RemoteScanSettingReset.buttonCell setTitle:S_SETTING_DEVICE_REMOTE_RESET forState:UIControlStateNormal];
                         [self.RemoteScanSettingReset.buttonCell setTitle:S_SETTING_DEVICE_REMOTE_RESET forState:UIControlStateHighlighted];
                         
                         [self.RemoteScanSettingReset.buttonCell addTarget:self action:@selector(tapSettingButton:) forControlEvents:UIControlEventTouchUpInside];
                         
                         //デリゲート
                         cell = self.RemoteScanSettingReset;
                         */
                    } else {
                        // 確認コード
                        if(profileData.verifyCode == nil)
                        {
                            profileData.verifyCode = @"0000";
                        }
                        
                        if ( ! self.VerifyCode ) {
                            m_pVerifyCode = [[PrinterDetailDataCell alloc] initWithStyle:UITableViewCellStyleDefault
                                                                         reuseIdentifier:CellIdentifier
                                                                              isEditCell:YES];
                        }
                        
                        cell = m_pVerifyCode;
                        
                        [(PrinterDetailDataCell *)cell SetCellPrinterInfo: S_SETTING_DEVICE_REMOTE_CODE
                                                                    value: profileData.verifyCode
                                                            hasDisclosure: NO
                                                               IsEditCell: TRUE
                                                             keyboardType: UIKeyboardTypeNumbersAndPunctuation];
                        
                        //デリゲート
                        ((PrinterDetailDataCell *)cell).EditCellValue.textField.delegate = self;
                    }
                    
                    break;
                }
                default:
                    cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
                    break;
            }
        }
        
        return cell;
    }else// if(indexPath.section == 3)
    {
        NSString *CellIdentifier = [NSString stringWithFormat:@"Cell%02ld%02ld", (long)indexPath.section, (long)indexPath.row];
        
        // セル作成
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (cell == nil)
        {
            switch(indexPath.row){
                case 0:
                {
                    // リセット
                    // セルの作成
                    cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
                    [cell.textLabel setFont:[UIFont systemFontOfSize:14]];
                    [cell.textLabel setAdjustsFontSizeToFitWidth:TRUE];
                    cell.textLabel.textAlignment = NSTextAlignmentCenter;
                    cell.textLabel.text = S_SETTING_DEVICE_REMOTE_RESET;
                    cell.textLabel.textColor = self.navigationController.navigationBar.tintColor;
                    
                    if(![S_LANG isEqualToString:S_LANG_EN]){
                        // 自動調整サイズを取得
                        CGFloat actualFontSize;
                        [cell.textLabel.text
                         sizeWithFont:cell.textLabel.font
                         minFontSize:(cell.textLabel.minimumScaleFactor * cell.textLabel.font.pointSize)
                         actualFontSize:&actualFontSize
                         forWidth:cell.textLabel.bounds.size.width
                         lineBreakMode:cell.textLabel.lineBreakMode];
                        
                        // 自動調整したフォントサイズが10以下なら、二段表示するか判定を行う
                        if(actualFontSize < 11)
                        {
                            int iFontSize = [self.DefaultMFPCell changeFontSize:cell.textLabel.text];
                            if (iFontSize != -1)
                            {
                                cell.textLabel.lineBreakMode = NSLineBreakByWordWrapping;
                                cell.textLabel.numberOfLines = 2;
                                [cell.textLabel setFont:[UIFont systemFontOfSize:iFontSize]];
                                // サイズ調整
                                CGRect frame =  cell.textLabel.frame;
                                frame.size.height = 36;
                                cell.textLabel.frame = frame;
                            }
                        }
                    } else {
                        cell.textLabel.lineBreakMode = NSLineBreakByWordWrapping;
                        cell.textLabel.numberOfLines = 2;
                        // サイズ調整
                        CGRect frame =  cell.textLabel.frame;
                        frame.size.height = 36;
                        cell.textLabel.frame = frame;
                    }
                    
                    break;
                }
                    
                default:
                    cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
                    break;
            }
        }
        
        return cell;
    }
    
    return nil;
}

// 各セルの高さを設定
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return N_HEIGHT_SEL_DEFAULT;
}

// 各セクションのタイトルを決定する
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    if (section == 0)
    {
        return S_TITLE_SETTING_SHOW_INFO_SEC1;
    }
    else if(section == 1)
    {
        return S_TITLE_SETTING_ACTION;
    }
    else if(section == 2)
    {
        return S_TITLE_SETTING_REMOTE_SCAN;
    }
    else// if(section == 3)
    {
        return S_SETTING_DEVICE_REMOTE_RESET_HEADER;
    }
}

// ヘッダー表示前にフォントを設定
- (void)tableView:(UITableView *)tableView willDisplayHeaderView:(UIView *)view forSection:(NSInteger)section
{
    UITableViewHeaderFooterView *heView = (UITableViewHeaderFooterView *)view;
    heView.textLabel.font = [UIFont systemFontOfSize:N_TABLE_FONT_SIZE_HEADER];
}

// リセットボタン押下時
//-(IBAction)tapSettingButton:(id)sender
-(void)tapSettingButton
{
    // アラートを表示する 押下時 tag:4
    [self CreateAllertWithCancelAndOtherButton:nil message:MSG_SETTING_DEVICE_REMOTE_RESET cancelBtnTitle:MSG_BUTTON_CANCEL startBtnTitle:MSG_BUTTON_OK withTag:4];
}

// アラート表示
- (void)CreateAllertWithCancelAndOtherButton:(NSString*)pstrTitle
                                     message:(NSString*)pstrMsg
                              cancelBtnTitle:(NSString*)pstrCancelBtnTitle
                               startBtnTitle:(NSString*)pstrStartBtnTitle
                                     withTag:(NSInteger)nTag
{
    SharpScanPrintAppDelegate* appDelegate = (SharpScanPrintAppDelegate*)[[UIApplication sharedApplication] delegate];
    // 処理実行フラグON
    appDelegate.IsRun = TRUE;
    
    [self makeAlert:nil message:pstrMsg cancelBtnTitle:pstrCancelBtnTitle okBtnTitle:pstrStartBtnTitle tag:nTag];
}

/*
 // Override to support conditional editing of the table view.
 - (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
 {
 // Return NO if you do not want the specified item to be editable.
 return YES;
 }
 */

/*
 // Override to support editing the table view.
 - (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
 {
 if (editingStyle == UITableViewCellEditingStyleDelete) {
 // Delete the row from the data source
 [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
 }
 else if (editingStyle == UITableViewCellEditingStyleInsert) {
 // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
 }
 }
 */

/*
 // Override to support rearranging the table view.
 - (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
 {
 }
 */

/*
 // Override to support conditional rearranging of the table view.
 - (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
 {
 // Return NO if you do not want the item to be re-orderable.
 return YES;
 }
 */

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // セルの複数タップを制御する
    if ( ! [self.navigationController.visibleViewController isKindOfClass: [self class]] ) {
        DLog(@"visibleViewController is Invalid");
        return;
    }
    
	if(indexPath.section == 2 && indexPath.row == 4){
        // ハイライトの解除
        [tableView deselectRowAtIndexPath:[tableView indexPathForSelectedRow] animated:YES];
    }
    else if(indexPath.section == 3 && indexPath.row == 0)
    {
        // ハイライトの解除
        [tableView deselectRowAtIndexPath:[tableView indexPathForSelectedRow] animated:YES];
        
        [self tapSettingButton];
    }
}

// キーボードReturnキー押下イベント
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [self.NameCell.EditCellValue.textField resignFirstResponder];
    [self.DeviceNameCell.EditCellValue.textField resignFirstResponder];
    [self.IpAddressCell.EditCellValue.textField resignFirstResponder];
    [self.PortNoCell.EditCellValue.textField resignFirstResponder];
    [self.PlaceCell.EditCellValue.textField resignFirstResponder];
    [self.VerifyCode.EditCellValue.textField resignFirstResponder];
    return YES;
}

// iPad用
- (void)popRootView
{
    [self.navigationController popToRootViewControllerAnimated:YES];
}

// 縦表示時のメニューボタン設定
- (void)setPortraitMenu:(UIBarButtonItem *)barButtonItem
{
    // 戻るボタンがあるためメニューを表示しない
}
// iPad用

#pragma mark - RSHttpCommunicationManager delegate

-(void)rsManagerDidFinishParsing:(RSHttpCommunicationManager*)manager
{
    if([manager isKindOfClass:[RSmfpifManager class]])
    {
        m_pPrinterInfo.isCapableNetScan = [mfpManager isCapableNetScan];
        //ネットワークエラー
        if([mfpManager.errCode isEqualToString:@"NETWORK_ERROR"]){
            DLog(@"ネットワークエラー errorCode:%@",mfpManager.errCode);
            m_pPrinterInfo.isCapableNetScan = YES;
            [NSThread sleepForTimeInterval:1.0];
            [ex_alert dismissViewControllerAnimated:YES completion:nil];
        }
        //通信エラー（statusCodeが200番台以外）
        if(mfpManager.statusCodeNumber/100 != 2){
            DLog(@"通信 statusCode:%ld",(long)mfpManager.statusCodeNumber);
            m_pPrinterInfo.isCapableNetScan = YES;
            [NSThread sleepForTimeInterval:1.0];
            [ex_alert dismissViewControllerAnimated:YES completion:nil];
        }
        //xmlパース失敗
        if([mfpManager.errCode isEqualToString:@"XML_PARSE_ERROR"]){
            DLog(@"パースエラー errorCode:%@",mfpManager.errCode);
            m_pPrinterInfo.isCapableNetScan = YES;
            [NSThread sleepForTimeInterval:1.0];
            [ex_alert dismissViewControllerAnimated:YES completion:nil];
        }
        
        m_pPrinterInfo.isCapableNetScan = [mfpManager isCapableNetScan];
        if(m_pPrinterInfo.isCapableNetScan)
        {
            m_pPrinterInfo.IsCapableRemoteScan = [mfpManager isCapableRemoteScan];
        } else {
            // netscan=falseの場合は、スキャンが出来ないMFPのため、リモートスキャンも強制的に非対応にする
            m_pPrinterInfo.IsCapableRemoteScan = NO;
        }
        m_pPrinterInfo.IsCapableNovaLight = [mfpManager isCapableNovaLight];
        
        m_pPrinterInfo.addDic = mfpManager.addDic;
        m_pPrinterInfo.updateDic = mfpManager.updateDic;
        m_pPrinterInfo.deleteDic = mfpManager.deleteDic;
        
        m_pPrinterInfo.isCapablePrintRelease = [mfpManager isCapablePrintRelease];
        
        // 製品名、設置場所取得判定フラグ
        BOOL isNecessaryGetProductName = [self chkIsNecessaryGetProdctName];
        BOOL isNecessaryGetPlace = [self chkIsNecessaryGetPlace];
        
        if(m_pPrinterInfo.IsCapableRemoteScan || m_pPrinterInfo.isCapablePrintRelease
           || isNecessaryGetProductName || isNecessaryGetPlace){
            
            [self startGetMfpIfServiceWithFlags:m_pPrinterInfo.IsCapableRemoteScan
              setPrintReleaseDataReceiveGetFlag:m_pPrinterInfo.isCapablePrintRelease
                            setModelNameGetFlag:isNecessaryGetProductName
                             setLocationGetFlag:isNecessaryGetPlace];
            
        }else{
            
            // 名称が空白の場合
            if (m_bAddNew && [self isEmptyPrinterName]) {
                m_pPrinterInfo.PrinterName = [self margeProductName];
            }
            [NSThread sleepForTimeInterval:1.0];
            [ex_alert dismissViewControllerAnimated:YES completion:^{
                [self savePrinterData];
            }];
        }
    } else if([manager isKindOfClass:[RSmfpifServiceManager class]])
    {
        //ネットワークエラー
        if([manager.errCode isEqualToString:@"NETWORK_ERROR"]){
            DLog(@"ネットワークエラー errorCode:%@",mfpManager.errCode);
            m_pPrinterInfo.isCapableNetScan = YES;
            m_pPrinterInfo.IsCapableRemoteScan = NO;
        }
        //通信エラー（statusCodeが200番台以外）
        if(manager.statusCodeNumber/100 != 2){
            m_pPrinterInfo.isCapableNetScan = YES;
            m_pPrinterInfo.IsCapableRemoteScan = NO;
        }
        //xmlパース失敗
        if([manager.errCode isEqualToString:@"XML_PARSE_ERROR"]){
            m_pPrinterInfo.isCapableNetScan = YES;
            m_pPrinterInfo.IsCapableRemoteScan = NO;
        }

        // リモートスキャン
        if(m_pPrinterInfo.IsCapableRemoteScan) {
            // ポート番号取得できない場合
            if(!mfpServiceManager.portNo || [mfpServiceManager.portNo isEqualToString: @""])
            {
                m_pPrinterInfo.isCapableNetScan = YES;
                m_pPrinterInfo.IsCapableRemoteScan = NO;
            }
            m_pPrinterInfo.RSPortNo = [mfpServiceManager.portNo copy];
        }
        
        // プリントリリース
        if(m_pPrinterInfo.isCapablePrintRelease) {
            m_pPrinterInfo.enabledDataReceive = mfpServiceManager.enabledDataReceive;
        }
        
        // 製品名
        if (m_bAddNew && [self isEmptyProductName]) {
            m_pPrinterInfo.ProductName = mfpServiceManager.modelName;
        }
        // 設置場所
        if (m_bAddNew && [self isEmptyPlace]) {
            m_pPrinterInfo.Place = mfpServiceManager.location;
        }
        // 名称が空白の場合
        if (m_bAddNew && [self isEmptyPrinterName]) {
            m_pPrinterInfo.PrinterName = [self margeProductName];
        }
        
        // ダイアログ表示のため、ちょっとだけ待つ
        [NSThread sleepForTimeInterval:1.0];
        [ex_alert dismissViewControllerAnimated:YES completion:^{
            [self savePrinterData];
        }];
    }
    DLog(@"リモートスキャン:%d",mfpManager.isCapableRemoteScan);
    DLog(@"ネットスキャン:%d",mfpManager.isCapableNetScan);
}

-(void)rsManagerDidFailWithError:(RSHttpCommunicationManager*)manager
{
    if([manager isKindOfClass:[RSmfpifManager class]])
    {
        m_pPrinterInfo.IsCapableRemoteScan = NO;
        m_pPrinterInfo.IsCapableNovaLight = NO;
        m_pPrinterInfo.isCapableNetScan = YES;
    } else if([manager isKindOfClass:[RSmfpifServiceManager class]])
    {
        m_pPrinterInfo.IsCapableRemoteScan = NO;
        m_pPrinterInfo.IsCapableNovaLight = [mfpManager isCapableNovaLight];
        m_pPrinterInfo.isCapableNetScan = YES;
    }

    // 名称が空白の場合
    if (m_bAddNew && [self isEmptyPrinterName]) {
        m_pPrinterInfo.PrinterName = [self margeProductName];
    }

    // ダイアログ表示のため、ちょっとだけ待つ
    [NSThread sleepForTimeInterval:1.0];
    [ex_alert dismissViewControllerAnimated:YES completion:^{
        [self savePrinterData];
    }];
}

//
-(IBAction)changeSwitchValue:(UISwitch*)sender
{
    switch (sender.tag) {
            // 確認コードの自動生成のスイッチ変更時の処理
        case 2:
        {
            autoVerifyOn = sender.on;
            NSIndexPath* indexPath = [NSIndexPath indexPathForRow: 3 inSection:2];
            NSArray* indexPaths = [NSArray arrayWithObject:indexPath];
            NSInteger nRowsCount = [self.tableView numberOfRowsInSection:2];
            if(autoVerifyOn){
                if (nRowsCount == 4) {
                    // 確認コード入力欄の削除
                    [self.tableView deleteRowsAtIndexPaths: indexPaths withRowAnimation:UITableViewRowAnimationAutomatic];
                }
            }else{
                if (nRowsCount == 3) {
                    // 確認コード入力欄の追加
                    [self.tableView insertRowsAtIndexPaths: indexPaths withRowAnimation:UITableViewRowAnimationAutomatic];
                }
            }
            break;
        }
            
        default:
            return;
            break;
    }
    
}
//

- (void)setPrintType:(NSInteger)printType
{
    // デフォルトの印刷先を設定する
    PrintOutDataManager* printOutManager = [[PrintOutDataManager alloc]init];
    [printOutManager SetLatestPrintType:printType];
}



#pragma mark - add ProductName Place
/**
 @brief 名称が空白かどうか判定
 */
- (BOOL)isEmptyPrinterName {
    if ([CommonUtil strLength:[m_pPrinterInfo.PrinterName stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]]] == 0) {
        return YES;
    }
    return NO;
}

/**
 @brief 製品名が空白かどうか判定
 */
- (BOOL)isEmptyProductName {
    if ([CommonUtil strLength:[m_pPrinterInfo.ProductName stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]]] == 0) {
        return YES;
    }
    return NO;
}

/**
 @brief 設置場所が空白かどうか判定
 */
- (BOOL)isEmptyPlace {
    if ([CommonUtil strLength:[m_pPrinterInfo.Place stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]]] == 0) {
        return YES;
    }
    return NO;
}

/**
 @brief MFPIFServiceにて製品名を取得するかどうかのフラグ設定用
 */
- (BOOL)chkIsNecessaryGetProdctName {
    
    if (m_bAddNew) {
        return [self isEmptyProductName];
    }
    return NO;
}

/**
 @brief MFPIFServiceにて設置場所を取得するかどうかのフラグ設定用
 */
- (BOOL)chkIsNecessaryGetPlace {
    
    if (m_bAddNew) {
        return [self isEmptyPlace];
    }
    return NO;
}

/**
 @brief 製品名と設置場所、もしくはIPアドレスを組み合わせる
 */
- (NSString*)margeProductName {
    
    NSString *strRelust = [NSString string];
    
    ProfileDataManager* pManager = [[ProfileDataManager alloc]init];
    ProfileData* pData = [pManager loadProfileDataAtIndex:0];
    // 結合するのを設置場所かIPアドレスかの設定値判定
    if(pData.deviceNameStyle == SETTING_DEVICENAME_STYLE_LOCATION){
        // 製品名と設置場所を表示
        if([CommonUtil strLength:[[m_pPrinterInfo Place] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]]] == 0){
            // 設置場所が空の場合は製品名のみ
            // プリントサーバ名：製品名
            strRelust = [m_pPrinterInfo ProductName];
        }
        else
        {
            
            if ([CommonUtil strLength:[[m_pPrinterInfo ProductName] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]]] == 0) {
                // 製品名も設置場所も空の場合
                strRelust = [m_pPrinterInfo IpAddress];
            }
            else {
                // プリントサーバ名：製品名(設置場所)
                strRelust = [[[[m_pPrinterInfo ProductName] stringByAppendingString:@"("] stringByAppendingString:[m_pPrinterInfo Place]] stringByAppendingString:@")"];
            }
            
        }
        
    }else if(pData.deviceNameStyle == SETTING_DEVICENAME_STYLE_IP_ADDRESS){
        // 製品名とIPアドレスを表示
        if ([CommonUtil strLength:[[m_pPrinterInfo ProductName] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]]] == 0) {
            // 製品名が空の場合 プリントサーバ名：IPアドレス
            strRelust = [m_pPrinterInfo IpAddress];
        }
        else {
            // プリントサーバ名：製品名(IPアドレス)
            strRelust = [[[[m_pPrinterInfo ProductName] stringByAppendingString:@"("] stringByAppendingString:[m_pPrinterInfo IpAddress]] stringByAppendingString:@")"];
        }
    }
    
    // ここまでで設定した文字列が空白の場合はIPアドレスを設定する
    if ([CommonUtil strLength:[strRelust stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]]] == 0) {
        strRelust = [m_pPrinterInfo IpAddress];
    }
    
    return strRelust;
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

@end
