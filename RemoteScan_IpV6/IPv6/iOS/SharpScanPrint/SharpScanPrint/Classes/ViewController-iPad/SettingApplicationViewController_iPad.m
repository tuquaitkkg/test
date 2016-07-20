
#import "SettingApplicationViewController_iPad.h"
#import "Define.h"
#import "CommonUtil.h"
#import "SharpScanPrintAppDelegate.h"
#import "RootViewController_iPad.h"
#import "SettingSelInfoViewController_iPad.h"
#import "SettingRetentionInfoTableViewController.h"
#import "SettingDeviceNameInfoTableViewController.h"

#define RegularCell_HEIGHT 44

@interface SettingApplicationViewController_iPad ()
@property (nonatomic,strong) NSArray *deviceNameSettings;
@end

@implementation SettingApplicationViewController_iPad

//
// アクセサメソッドの自動合成(ゲッターとセッターの役割)
//
@synthesize		delmodeCell;        // プロファイル消さない
@synthesize		modifymodeCell;     // プロファイル上書き
@synthesize     saveExSiteFileCell; // 他アプリから受けたファイルを残す
@synthesize     autoSelectCell;     // このプリンター/スキャナーを選択
@synthesize     highQualityCell;    // 高品質で印刷する
@synthesize     updateSelectCell;   // 選択プリンター/スキャナーの更新
@synthesize     useRawPrintCell;    // 印刷にRawプリントを使用する
@synthesize     savePrintSettingCell;   // 印刷設定を記憶する
@synthesize     snmpSearchPublic;   // publicで検索する
@synthesize     snmpCommunityString; // Community String
@synthesize     retentionCell;           // リテンション
@synthesize     deviceNameCell;          // プリンター/スキャナーの名称
@synthesize     jobTimeOutCell;          // ジョブ送信のタイムアウト(秒)

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self)
    {
        // Custom initialization
    }
    return self;
}

- (void)dealloc
{
    // iPad用
    {
        manager = nil;
    }
    if (nil != commanager)
    {
        commanager = nil;
    }
    // iPad用
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
    
    NSString *obj0 = S_TITLE_SETTING_DEVICENAME_STYLE_LOCATION;
#ifdef IPV6_VALID
    NSString *obj1 = S_TITLE_SETTING_DEVICENAME_STYLE_HOSTNAME;
#else
    NSString *obj1 = S_TITLE_SETTING_DEVICENAME_STYLE_IP_ADDRESS;
#endif
    self.deviceNameSettings = @[obj0,obj1];
    
    // セルのラインを表示する
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    
    //
    // ProfileDataManager クラスのインスタンス取得
    //
    manager = [[ProfileDataManager alloc]init];
    
    //
    // CommonManager クラスのインスタンス取得
    //
    commanager = [[CommonManager alloc]init];
    
    // 色変更
    //self.navigationController.navigationBar.tintColor = [UIColor blackColor];
    
    self.navigationItem.title = S_TITLE_SETTING_APPLICATION;
    
    // iPad用
    // 戻るボタンの名称変更
    UIBarButtonItem * barItemBack = [UIBarButtonItem new];
    barItemBack.title = S_BUTTON_BACK;
    self.navigationItem.backBarButtonItem = barItemBack;
    //    self.navigationItem.hidesBackButton = YES; //戻るボタン非表示
    SharpScanPrintAppDelegate* pAppDelegate = (SharpScanPrintAppDelegate*)[[UIApplication sharedApplication] delegate];
    UINavigationController* pRootNavController = [pAppDelegate.splitViewController.viewControllers objectAtIndex:0];
    if ([pRootNavController.topViewController isKindOfClass:[SettingSelInfoViewController_iPad class]])
    {
        self.navigationItem.hidesBackButton = YES; //戻るボタン非表示
    }
    {//モーダル表示されたときは戻るボタンを表示する
        if([self.navigationController.viewControllers[0] isKindOfClass:[SettingSelInfoViewController_iPad class]])
        {
            SettingSelInfoViewController_iPad* settingSelInfoVC = (SettingSelInfoViewController_iPad*)self.navigationController.viewControllers[0];
            if(settingSelInfoVC.modalPresented)
            {
                self.navigationItem.hidesBackButton = NO; //戻るボタン表示
            }
        }
    }
    // iPad用
    
    //
    // [保存]ボタンの追加（Navigation Item）
    //
    UIBarButtonItem* btnSave = [[UIBarButtonItem alloc] initWithTitle:S_BUTTON_SAVEVAL style:UIBarButtonItemStyleDone target:self action:@selector(dosave:)];
    
    self.navigationItem.rightBarButtonItem	= btnSave;

    // ジョブ送信のタイムアウト(秒)のデフォルト値
    defaultJobTimeOut = N_NUM_DEFAULT_JOB_TIME_OUT;
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
    // iPad用
    if (nil != manager)
    {
        manager = nil;
    }
    if (nil != commanager)
    {
        commanager = nil;
    }
    // iPad用
}

// iPad用
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    // 現在のリテンション設定を取得する
    [self reloadRetentionSettings];
    
    // 縦表示の時はメニューボタンを表示
    SharpScanPrintAppDelegate* pAppDelegate = (SharpScanPrintAppDelegate*)[[UIApplication sharedApplication] delegate];
    [pAppDelegate setPortraitMenuButton];
}
// iPad用

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

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return N_NUM_SECTION_APPLICATION;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    NSInteger nRet = 0;
    // 取り込みの設定
    if(section == SCAN_SECTION_APPLICATION)
    {
        nRet = N_NUM_ROW_APPLICATION_SCAN_SECTION;
    }
    // 印刷の名称設定
    else if(section == PRINT_SECTION_APPLICATION)
    {
        nRet = N_NUM_ROW_APPLICATION_PRINT_SECTION;
    }
    // 共通設定
    else if(section == COMMON_SECTION_APPLICATION)
    {
        nRet = N_NUM_ROW_APPLICATION_COMMON_SECTION;
    }
    // SNMP設定
    else if(section == SNMP_SECTION_APPLICATION)
    {
        nRet = N_NUM_ROW_APPLICATION_SNMP_SECTION;
    }
    return nRet;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //
    // 自動解放プールの作成
    //
    @autoreleasepool
    {
        @try {
            // 取り込みの設定
            if (indexPath.section == SCAN_SECTION_APPLICATION){
                return [self getScanSection:tableView cellForRowAtIndexPath:indexPath];
                
            // 印刷の設定
            } else if(indexPath.section == PRINT_SECTION_APPLICATION) {
                return [self getPrintSection:tableView cellForRowAtIndexPath:indexPath];
                
            // 共通設定
            } else if(indexPath.section == COMMON_SECTION_APPLICATION) {
                return [self getCommonSection:tableView cellForRowAtIndexPath:indexPath];
                
            // SNMP設定
            } else if(indexPath.section == SNMP_SECTION_APPLICATION) {
                return [self getSnmpSection:tableView cellForRowAtIndexPath:indexPath];
                
            }
        }
        @finally
        {
        }
    }
    return nil; //ビルド警告回避用
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.section){
        case SNMP_SECTION_APPLICATION:
            switch (indexPath.row) {
                case SNMP_SECTION_COMMUNITY_STRING:
                    return self.snmpCommunityString.nameEditableCellMulti.frame.size.height+10;
                    break;
                default:
                    break;
            }
        default:
            break;
    }
    return RegularCell_HEIGHT;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // セルの複数タップを制御する
    if ( ! [self.navigationController.visibleViewController isKindOfClass: [self class]] ) {
        DLog(@"visibleViewController is Invalid");
        return;
    }
    
    SettingRetentionInfoTableViewController *pSettingRetentionInfoTableViewController;
    SettingDeviceNameInfoTableViewController *pSettingDeviceNameInfoTableViewController;
    
    // リテンション設定
    if (indexPath.section == PRINT_SECTION_APPLICATION) {
        if (indexPath.row == PRINT_SECTION_RETENTION_INFO) {
            pSettingRetentionInfoTableViewController = [[SettingRetentionInfoTableViewController alloc] initWithStyle:UITableViewStyleGrouped];
            [self.navigationController pushViewController:pSettingRetentionInfoTableViewController animated:YES];
        }
        
    // 自動追加プリンター／スキャナーの名称
    } else if(indexPath.section == COMMON_SECTION_APPLICATION) {
        if (indexPath.row == COMMON_SECTION_MFP_NAME) {
            pSettingDeviceNameInfoTableViewController = [[SettingDeviceNameInfoTableViewController alloc] initWithStyle:UITableViewStyleGrouped];
            
            pSettingDeviceNameInfoTableViewController.selectedIndex = [self.deviceNameSettings indexOfObject:self.deviceNameCell.detailTextLabelCell.text];
            pSettingDeviceNameInfoTableViewController.dataArray = self.deviceNameSettings;
            pSettingDeviceNameInfoTableViewController.delegate = self;
            
            [self.navigationController pushViewController:pSettingDeviceNameInfoTableViewController animated:YES];
        }
    }
}
//
// 各セクションのタイトルを決定する
//
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    NSString *title = @"";
    switch (section) {
        case SCAN_SECTION_APPLICATION:
            title = S_TITLE_SETTING_SCAN;
            break;
        case PRINT_SECTION_APPLICATION:
            title = S_TITLE_SETTING_PRINT;
            break;
        case COMMON_SECTION_APPLICATION:
            title = S_TITLE_SETTING_COMMON;
            break;
        case SNMP_SECTION_APPLICATION:
            title = S_TITLE_SETTING_SNMP;
            break;
        default:
            break;
    }
    return title;
}

// ヘッダー表示前にフォントを設定
- (void)tableView:(UITableView *)tableView willDisplayHeaderView:(UIView *)view forSection:(NSInteger)section
{
    UITableViewHeaderFooterView *heView = (UITableViewHeaderFooterView *)view;
    heView.textLabel.font = [UIFont systemFontOfSize:N_TABLE_FONT_SIZE_HEADER];
}

//
// 入力チェック
//
- (BOOL)profileChk:(ProfileData *)pData
{
    //
    // 自動解放プールの作成
    //
    @autoreleasepool
    {
        @try {
            NSString	*strerrMessage;

            // ジョブ送信のタイムアウト(秒)
            NSInteger nRet = ERR_SUCCESS;
            nRet = [CommonUtil IsJobTimeOut:pData.jobTimeOut];
            if(nRet != ERR_SUCCESS)
            {
                switch (nRet)
                {
                    case ERR_NO_INPUT:	// 未入力
                        strerrMessage = [NSString stringWithFormat:MSG_REQUIRED_ERR, SUBMSG_JOBTIMEOUT_ERR];
                        break;
                    case ERR_INVALID_CHAR_TYPE:	// 文字種不正
                        strerrMessage = [NSString stringWithFormat:MSG_CHAR_TYPE_ERR, SUBMSG_JOBTIMEOUT_ERR, SUBMSG_ONLY_HALFCHAR_NUMBER];
                        break;
                    case ERR_OVER_NUM_RANGE:	// 数値範囲外
                        strerrMessage = [NSString stringWithFormat:MSG_NUM_RANGE_ERR, SUBMSG_JOBTIMEOUT_ERR, SUBMSG_JOBTIMEOUT_RANGE];
                        break;
                    default:
                        break;
                }
                [self profileAlert:nil errMessage:strerrMessage];
                return NO;
            }
            
            // Community String
            NSArray* arrCommunityString = [pData.snmpCommunityString componentsSeparatedByString:@"\n"];
            NSMutableArray* strStrings =[[NSMutableArray alloc]init];
            for (NSString* strTmp in arrCommunityString) {
                if([strTmp length] > 0)
                {
                    [strStrings addObject:strTmp];
                }
            }
            
            int len = [CommonUtil strLength:pData.snmpCommunityString];
            
            // Community Stringの未入力チェック（publicで検索するのチェックがオフの場合のみ）
            if (self.snmpSearchPublic.switchField.on == NO) {
                // 必須チェック
                if (len <= 0 || [strStrings count]  == 0)
                {
                    strerrMessage = [NSString stringWithFormat:MSG_REQUIRED_ERR, SUBMSG_COMMUNITYSTRING_ERR];
                    [self profileAlert:nil errMessage:strerrMessage];
                    return NO;
                }
            }
            
            if([strStrings count]  > 10)
            {
                // Community Stringは最大10件まで
                strerrMessage = [NSString stringWithFormat:MSG_FORMAT_ERR, SUBMSG_COMMUNITYSTRING_ERR,SUBMSG_COMMUNITYSTRING_FORMAT];
                [self profileAlert:nil errMessage:strerrMessage];
                return NO;
            }
            
            for (NSString* strTmp in strStrings) {
                // Community Stringの文字種チェック
                if([CommonUtil isZen:strTmp] || [CommonUtil IsUsedEmoji: strTmp])
                {
                    strerrMessage = [NSString stringWithFormat:MSG_CHAR_TYPE_ERR, SUBMSG_COMMUNITYSTRING_ERR, SUBMSG_COMMUNITYSTRING_CHARTYPE];
                    [self profileAlert:nil errMessage:strerrMessage];
                    return NO;
                }
            }
            
            for (NSString* strTmp in strStrings) {
                // Community Stringの長さチェック
                len = [CommonUtil strLength:strTmp];
                if(len > 15)
                {
                    strerrMessage = [NSString stringWithFormat:MSG_LENGTH_ERR, SUBMSG_COMMUNITYSTRING_ERR,SUBMSG_COMMUNITYSTRING_LENGTH];
                    [self profileAlert:nil errMessage:strerrMessage];
                    return NO;
                }
            }
            
            return YES;
        }
        @finally
        {
        }
    }
}


//
// アラート表示
//
-(void)profileAlert:(NSString *)errTitle errMessage:(NSString *)errMessage
{
    // iPad用
    //SharpScanPrintAppDelegate* appDelegate = (SharpScanPrintAppDelegate*)[[UIApplication sharedApplication] delegate];
    SharpScanPrintAppDelegate* appDelegate = (SharpScanPrintAppDelegate*)[[UIApplication sharedApplication] delegate];
    // iPad用
    // 処理実行フラグON
    appDelegate.IsRun = TRUE;
    
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:errTitle
                                                                             message:errMessage
                                                                      preferredStyle:UIAlertControllerStyleAlert];
    // Cancel用のアクションを生成
    UIAlertAction *cancelAction =
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
    [super viewDidLoad];
    
}


//
// 保存ボタン処理
//
-(IBAction)dosave:(id)sender
{
    //
    //PROFILE情報を設定ファイルから取得
    //
    ProfileData *profileData = [manager loadProfileDataAtIndex:0];
    
    BOOL isDelMode = FALSE;
    if(self.delmodeCell.switchField.on == NO)
    {
        isDelMode = TRUE;
    }
    profileData.delMode     = isDelMode;
    BOOL isModifyMode = FALSE;
    if(self.modifymodeCell.switchField.on == YES)
    {
        isModifyMode = TRUE;
    }
    profileData.modifyMode     = isModifyMode;
    BOOL isSaveExSiteFile = FALSE;
    if(self.saveExSiteFileCell.switchField.on == YES)
    {
        isSaveExSiteFile = TRUE;
    }
    profileData.saveExSiteFileMode     = isSaveExSiteFile;
    BOOL isAutoSelectMode = FALSE;
    if(self.autoSelectCell.switchField.on == YES)
    {
        isAutoSelectMode = TRUE;
    }
    profileData.autoSelectMode     = isAutoSelectMode;
    BOOL isHighQualityMode = FALSE;
    if(self.highQualityCell.switchField.on == NO)
    {
        isHighQualityMode = TRUE;
    }
    profileData.highQualityMode     = isHighQualityMode;
    BOOL isUseRawPrintMode = FALSE;
    if(self.useRawPrintCell.switchField.on == YES)
    {
        isUseRawPrintMode = TRUE;
    }
    profileData.useRawPrintMode     = isUseRawPrintMode;
    // プリンター名称設定
    if (self.deviceNameCell) {
        profileData.deviceNameStyle = [self.deviceNameSettings indexOfObject:self.deviceNameCell.detailTextLabelCell.text];
        DLog(@"%ld",(long)profileData.deviceNameStyle);
    }
    
    // ジョブ送信のタイムアウト(秒)
    if (self.jobTimeOutCell) {
        profileData.jobTimeOut = self.jobTimeOutCell.nameEditableCell.textField.text;
    }
    
    BOOL isSnmpSearchPublicMode = FALSE;
    if(self.snmpSearchPublic.switchField.on == NO)
    {
        isSnmpSearchPublicMode = TRUE;
    }
    profileData.snmpSearchPublicMode     = isSnmpSearchPublicMode;
    profileData.snmpCommunityString = self.snmpCommunityString.nameEditableCellMulti.textView.text;
    
    // ユーザ名
    //
    // 自動解放プールの作成
    //
    @autoreleasepool
    {
        @try {
            //
            // 入力チェック
            //
            if ([self profileChk: profileData] != YES)
            {
                // エラー時
                return;
            }
            
            // CommunityString の編集（空行を省く）
            NSArray *strStrings = [profileData.snmpCommunityString componentsSeparatedByString:@"\n"];
            profileData.snmpCommunityString = @"";
            for (NSString* strTmp in strStrings) {
                if([strTmp length] != 0)
                {
                    if(![profileData.snmpCommunityString isEqualToString:@""])
                    {
                        profileData.snmpCommunityString = [profileData.snmpCommunityString stringByAppendingFormat:@"\n"];
                    }
                    //                profileData.snmpCommunityString = [profileData.snmpCommunityString stringByAppendingFormat:strTmp];
                    profileData.snmpCommunityString = [profileData.snmpCommunityString stringByAppendingString:strTmp];
                }
            }
            
            //
            // クラス値の変更
            //
            [manager replaceProfileDataAtIndex:0 newObject:profileData];
            
            //
            // 保存
            //
            if(![manager saveProfileData])
            {
                [self profileAlert:@"" errMessage:MSG_REG_USER_PROFILE_ERR];
                return;
            }
            
            SharpScanPrintAppDelegate* pAppDelegate = (SharpScanPrintAppDelegate*)[[UIApplication sharedApplication] delegate];
            if([pAppDelegate.splitViewController.viewControllers objectAtIndex:1] != self.navigationController)
            {
                // モーダル表示の場合
                // 右側のViewを遷移前の状態に戻す
                [self.navigationController popViewControllerAnimated:YES];
                
            } else {
                
                // iPad用
                // 前画面に戻る
                SharpScanPrintAppDelegate* pAppDelegate = (SharpScanPrintAppDelegate*)[[UIApplication sharedApplication] delegate];
                
                // 左側のViewを取得
                UINavigationController* pRootNavController = [pAppDelegate.splitViewController.viewControllers objectAtIndex:0];
                RootViewController_iPad* rootViewController = (RootViewController_iPad*)[pRootNavController.viewControllers objectAtIndex:0];
                // 左側のViewを遷移前の状態に戻す
                [rootViewController popRootView];
                
                //メニューボタンを表示フラグをたてる
                SettingSelInfoViewController_iPad* settingSelInfoViewController = (SettingSelInfoViewController_iPad*)[self.navigationController.viewControllers objectAtIndex:0];
                settingSelInfoViewController.m_bVisibleMenuButton = true;
                
                // 右側のViewを遷移前の状態に戻す
                [self.navigationController popViewControllerAnimated:YES];
                
                // iPad用
            }
        }
        @finally
        {
        }
    }
}

//
// Returnキーが押された時のイベント時
//
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    // キーボードを消す
    [textField resignFirstResponder];	// フォーカスを外す
    return YES;
}

// 処理実行フラグをOFFにする
- (void)appDelegateIsRunOff {
    // ボタンタップ時の処理
    SharpScanPrintAppDelegate* appDelegate = (SharpScanPrintAppDelegate*)[[UIApplication sharedApplication] delegate];
    // 処理実行フラグOFF
    appDelegate.IsRun = FALSE;
}

// iPad用
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return YES;
}

- (void)popRootView
{
    SettingSelInfoViewController_iPad* settingSelInfoViewController = (SettingSelInfoViewController_iPad*)[self.navigationController.viewControllers objectAtIndex:0];
    settingSelInfoViewController.m_bVisibleMenuButton = true;
    [self.navigationController popToRootViewControllerAnimated:YES];
}

// 縦表示時のメニューボタン設定
- (void)setPortraitMenu:(UIBarButtonItem *)barButtonItem
{
    SharpScanPrintAppDelegate* pAppDelegate = (SharpScanPrintAppDelegate*)[[UIApplication sharedApplication] delegate];
    UINavigationController* pRootNavController = [pAppDelegate.splitViewController.viewControllers objectAtIndex:0];
    if ([pRootNavController.topViewController isKindOfClass:[SettingSelInfoViewController_iPad class]])
    {
        
        if (barButtonItem != nil) {
            barButtonItem.title = S_BUTTON_SETTING;
        }
        [self.navigationItem setLeftBarButtonItem:barButtonItem animated:YES];
        
    }
}
// iPad用


// 取り込みの設定
- (UITableViewCell *)getScanSection:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    // プロファイルの自動削除
    if(indexPath.row == SCAN_SECTION_PROFILE_AUTO_DELETE) {
        return [self getProfileAutoDelete:tableView cellForRowAtIndexPath:indexPath];
        
    // プロファイルの強制上書き
    } else if(indexPath.row == SCAN_SECTION_PROFILE_OVERWRITE) {
        return [self getProfileOverwrite:tableView cellForRowAtIndexPath:indexPath];
        
    } else {
        return nil; //ビルド警告回避用
    }
}


// 印刷の設定
- (UITableViewCell *)getPrintSection:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    // 高品質で印刷する
    if(indexPath.row == PRINT_SECTION_HIGH_QUALITY) {
        return [self getHighQuality:tableView cellForRowAtIndexPath:indexPath];
        
    // 印刷にRawプリントを使用する
    } else if(indexPath.row == PRINT_SECTION_RAW_PRINT) {
        return [self getRawPrint:tableView cellForRowAtIndexPath:indexPath];
        
    // 他アプリから受けたファイルを残す
    } else if(indexPath.row == PRINT_SECTION_SAVE_INPUT_FILE) {
        return [self getSaveInputFile:tableView cellForRowAtIndexPath:indexPath];
        
    // ジョブ送信のタイムアウト(秒)
    } else if(indexPath.row == PRINT_SECTION_JOB_TIME_OUT) {
        return [self getJobTimeOut:tableView cellForRowAtIndexPath:indexPath];
        
    // リテンション
    } else if(indexPath.row == PRINT_SECTION_RETENTION_INFO) {
        return [self getRetentionInfo:tableView cellForRowAtIndexPath:indexPath];
        
    } else {
        return nil; //ビルド警告回避用
    }
}


// 共通設定
- (UITableViewCell *)getCommonSection:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    // プリンタ／スキャナー自動切替
    if(indexPath.row == COMMON_SECTION_MFP_AUTO_SWITCH) {
        return [self getAutoSwitch:tableView cellForRowAtIndexPath:indexPath];
        
    // プリンタ／スキャナーの名称
    } else if(indexPath.row == COMMON_SECTION_MFP_NAME) {
        return [self getDeviceNameInfo:tableView cellForRowAtIndexPath:indexPath];
        
    } else {
        return nil; //ビルド警告回避用
    }
}


// SNMP設定
- (UITableViewCell *)getSnmpSection:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    // publicで検索する
    if(indexPath.row == SNMP_SECTION_SEARCH_PUBLIC) {
        return [self getSearchPublic:tableView cellForRowAtIndexPath:indexPath];
        
    // Community String
    } else if(indexPath.row == SNMP_SECTION_COMMUNITY_STRING) {
        return [self getCommunityString:tableView cellForRowAtIndexPath:indexPath];
        
    } else {
        return nil; //ビルド警告回避用
    }
}


// プロファイルの自動削除
- (UITableViewCell *)getProfileAutoDelete:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *CellIdentifier = [NSString stringWithFormat:@"Cell%02ld%02ld", (long)indexPath.section, (long)indexPath.row];
    
    //
    //選択された PROFILE情報の取得
    //
    ProfileData *profileData = [manager loadProfileDataAtIndex:0];
    
    // セルがすでに作成済みの場合は初期化処理を行わずに抜ける
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell != nil)
    {
        return cell;
    }
    
    // ********************
    // 消さないモード
    // ********************
    if (self.delmodeCell) {
        return self.delmodeCell;
    }
    self.delmodeCell = (SwitchDataCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (self.delmodeCell == nil)
    {
        self.delmodeCell = [[SwitchDataCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }else{
        return self.delmodeCell;
    }
    self.delmodeCell.nameLabelCell.text		= S_SETTING_USERINFO_DELETE_MODE;
    self.delmodeCell.switchField.on			= !profileData.delMode;
    
    if(![S_LANG isEqualToString:S_LANG_EN]){
        // 自動調整サイズを取得
        CGFloat actualFontSize;
        [self.delmodeCell.nameLabelCell.text
         sizeWithFont:self.delmodeCell.nameLabelCell.font
         minFontSize:(self.delmodeCell.nameLabelCell.minimumScaleFactor * self.delmodeCell.nameLabelCell.font.pointSize)
         actualFontSize:&actualFontSize
         forWidth:self.delmodeCell.nameLabelCell.bounds.size.width
         lineBreakMode:self.delmodeCell.nameLabelCell.lineBreakMode];
        
        // 自動調整したフォントサイズが10以下なら、二段表示するか判定を行う
        if(actualFontSize < 11)
        {
            int iFontSize = [self.delmodeCell changeFontSize:self.delmodeCell.nameLabelCell.text];
            if (iFontSize != -1)
            {
                self.delmodeCell.nameLabelCell.lineBreakMode = NSLineBreakByWordWrapping;
                self.delmodeCell.nameLabelCell.numberOfLines = 2;
                [self.delmodeCell.nameLabelCell setFont:[UIFont systemFontOfSize:iFontSize]];
                
                // サイズ調整
                CGRect frame =  self.delmodeCell.nameLabelCell.frame;
                frame.size.height = 36;
                self.delmodeCell.nameLabelCell.frame = frame;
            }
        }
        
    } else {
        self.delmodeCell.nameLabelCell.lineBreakMode = NSLineBreakByWordWrapping;
        self.delmodeCell.nameLabelCell.numberOfLines = 2;
        
        // サイズ調整
        CGRect frame =  self.delmodeCell.nameLabelCell.frame;
        frame.size.height = 36;
        self.delmodeCell.nameLabelCell.frame = frame;
    }
    
    return self.delmodeCell;
}


// プロファイルの強制上書き
- (UITableViewCell *)getProfileOverwrite:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *CellIdentifier = [NSString stringWithFormat:@"Cell%02ld%02ld", (long)indexPath.section, (long)indexPath.row];
    
    //
    //選択された PROFILE情報の取得
    //
    ProfileData *profileData = [manager loadProfileDataAtIndex:0];
    
    // セルがすでに作成済みの場合は初期化処理を行わずに抜ける
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell != nil)
    {
        return cell;
    }
    
    // ********************
    // 強制上書きモード
    // ********************
    if (self.modifymodeCell) {
        return self.modifymodeCell;
    }
    self.modifymodeCell = (SwitchDataCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (self.modifymodeCell == nil)
    {
        self.modifymodeCell = [[SwitchDataCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }else{
        return self.modifymodeCell;
    }
    self.modifymodeCell.nameLabelCell.text		= S_SETTING_USERINFO_MODIFY_MODE;
    self.modifymodeCell.switchField.on			= profileData.modifyMode;
    
    if(![S_LANG isEqualToString:S_LANG_EN]){
        // 自動調整サイズを取得
        CGFloat actualFontSize;
        [self.modifymodeCell.nameLabelCell.text
         sizeWithFont:self.modifymodeCell.nameLabelCell.font
         minFontSize:(self.modifymodeCell.nameLabelCell.minimumScaleFactor * self.modifymodeCell.nameLabelCell.font.pointSize)
         actualFontSize:&actualFontSize
         forWidth:self.modifymodeCell.nameLabelCell.bounds.size.width
         lineBreakMode:self.modifymodeCell.nameLabelCell.lineBreakMode];
        
        // 自動調整したフォントサイズが10以下なら、二段表示するか判定を行う
        if(actualFontSize < 11)
        {
            int iFontSize = [self.modifymodeCell changeFontSize:self.modifymodeCell.nameLabelCell.text];
            if (iFontSize != -1)
            {
                self.modifymodeCell.nameLabelCell.lineBreakMode = NSLineBreakByWordWrapping;
                self.modifymodeCell.nameLabelCell.numberOfLines = 2;
                [self.modifymodeCell.nameLabelCell setFont:[UIFont systemFontOfSize:iFontSize]];
                
                // サイズ調整
                CGRect frame =  self.modifymodeCell.nameLabelCell.frame;
                frame.size.height = 36;
                self.modifymodeCell.nameLabelCell.frame = frame;
            }
        }
    } else {
        self.modifymodeCell.nameLabelCell.lineBreakMode = NSLineBreakByWordWrapping;
        self.modifymodeCell.nameLabelCell.numberOfLines = 2;
        
        // サイズ調整
        CGRect frame =  self.modifymodeCell.nameLabelCell.frame;
        frame.size.height = 36;
        self.modifymodeCell.nameLabelCell.frame = frame;
    }
    
    return self.modifymodeCell;
}


// 高品質で印刷する
- (UITableViewCell *)getHighQuality:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *CellIdentifier = [NSString stringWithFormat:@"Cell%02ld%02ld", (long)indexPath.section, (long)indexPath.row];
    
    //
    //選択された PROFILE情報の取得
    //
    ProfileData *profileData = [manager loadProfileDataAtIndex:0];
    
    // セルがすでに作成済みの場合は初期化処理を行わずに抜ける
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell != nil)
    {
        return cell;
    }
    
    // ********************
    // 高品質モード
    // ********************
    if (self.highQualityCell) {
        return self.highQualityCell;
    }
    self.highQualityCell = (SwitchDataCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (self.highQualityCell == nil)
    {
        self.highQualityCell = [[SwitchDataCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }else{
        return self.highQualityCell;
    }
    self.highQualityCell.nameLabelCell.text		= S_SETTING_USERINFO_HIGH_QUALITY;
    self.highQualityCell.switchField.on			= !profileData.highQualityMode;
    
    if(![S_LANG isEqualToString:S_LANG_EN]){
        // 自動調整サイズを取得
        CGFloat actualFontSize;
        [self.highQualityCell.nameLabelCell.text
         sizeWithFont:self.highQualityCell.nameLabelCell.font
         minFontSize:(self.highQualityCell.nameLabelCell.minimumScaleFactor * self.highQualityCell.nameLabelCell.font.pointSize)
         actualFontSize:&actualFontSize
         forWidth:self.highQualityCell.nameLabelCell.bounds.size.width
         lineBreakMode:self.highQualityCell.nameLabelCell.lineBreakMode];
        
        // 自動調整したフォントサイズが10以下なら、二段表示するか判定を行う
        if(actualFontSize < 11)
        {
            int iFontSize = [self.highQualityCell changeFontSize:self.highQualityCell.nameLabelCell.text];
            if (iFontSize != -1)
            {
                self.highQualityCell.nameLabelCell.lineBreakMode = NSLineBreakByWordWrapping;
                self.highQualityCell.nameLabelCell.numberOfLines = 2;
                [self.highQualityCell.nameLabelCell setFont:[UIFont systemFontOfSize:iFontSize]];
                
                // サイズ調整
                CGRect frame =  self.highQualityCell.nameLabelCell.frame;
                frame.size.height = 36;
                self.highQualityCell.nameLabelCell.frame = frame;
            }
        }
    } else {
        self.highQualityCell.nameLabelCell.lineBreakMode = NSLineBreakByWordWrapping;
        self.highQualityCell.nameLabelCell.numberOfLines = 2;
        
        // サイズ調整
        CGRect frame =  self.highQualityCell.nameLabelCell.frame;
        frame.size.height = 36;
        self.highQualityCell.nameLabelCell.frame = frame;
    }
    
    return self.highQualityCell;
}


// 印刷にRawプリントを使用する
- (UITableViewCell *)getRawPrint:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *CellIdentifier = [NSString stringWithFormat:@"Cell%02ld%02ld", (long)indexPath.section, (long)indexPath.row];
    
    //
    //選択された PROFILE情報の取得
    //
    ProfileData *profileData = [manager loadProfileDataAtIndex:0];
    
    // セルがすでに作成済みの場合は初期化処理を行わずに抜ける
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell != nil)
    {
        return cell;
    }
    
    // ********************
    // 印刷にRawプリントを使用する
    // ********************
    if (self.useRawPrintCell) {
        return self.useRawPrintCell;
    }
    self.useRawPrintCell = (SwitchDataCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (self.useRawPrintCell == nil)
    {
        self.useRawPrintCell = [[SwitchDataCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }else{
        return self.useRawPrintCell;
    }
    self.useRawPrintCell.nameLabelCell.text		= S_SETTING_USERINFO_USE_RAWPRINT;
    self.useRawPrintCell.switchField.on			= profileData.useRawPrintMode;
    
    if(![S_LANG isEqualToString:S_LANG_EN]){
        // 自動調整サイズを取得
        CGFloat actualFontSize;
        [self.useRawPrintCell.nameLabelCell.text
         sizeWithFont:self.useRawPrintCell.nameLabelCell.font
         minFontSize:(self.useRawPrintCell.nameLabelCell.minimumScaleFactor * self.useRawPrintCell.nameLabelCell.font.pointSize)
         actualFontSize:&actualFontSize
         forWidth:self.useRawPrintCell.nameLabelCell.bounds.size.width
         lineBreakMode:self.useRawPrintCell.nameLabelCell.lineBreakMode];
        
        // 自動調整したフォントサイズが10以下なら、二段表示するか判定を行う
        if(actualFontSize < 11)
        {
            int iFontSize = [self.useRawPrintCell changeFontSize:self.useRawPrintCell.nameLabelCell.text];
            if (iFontSize != -1)
            {
                self.useRawPrintCell.nameLabelCell.lineBreakMode = NSLineBreakByWordWrapping;
                self.useRawPrintCell.nameLabelCell.numberOfLines = 2;
                [self.useRawPrintCell.nameLabelCell setFont:[UIFont systemFontOfSize:iFontSize]];
                // サイズ調整
                CGRect frame =  self.useRawPrintCell.nameLabelCell.frame;
                frame.size.height = 36;
                self.useRawPrintCell.nameLabelCell.frame = frame;
            }
        }
    } else {
        self.useRawPrintCell.nameLabelCell.lineBreakMode = NSLineBreakByWordWrapping;
        self.useRawPrintCell.nameLabelCell.numberOfLines = 2;
        // サイズ調整
        CGRect frame =  self.useRawPrintCell.nameLabelCell.frame;
        frame.size.height = 36;
        self.useRawPrintCell.nameLabelCell.frame = frame;
    }
    
    return self.useRawPrintCell;
}


// 他アプリから受けたファイルを残す
- (UITableViewCell *)getSaveInputFile:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *CellIdentifier = [NSString stringWithFormat:@"Cell%02ld%02ld", (long)indexPath.section, (long)indexPath.row];
    
    //
    //選択された PROFILE情報の取得
    //
    ProfileData *profileData = [manager loadProfileDataAtIndex:0];
    
    // セルがすでに作成済みの場合は初期化処理を行わずに抜ける
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell != nil)
    {
        return cell;
    }
    
    // ********************
    // 他アプリから受けたファイルを残すモード
    // ********************
    if (self.saveExSiteFileCell) {
        return self.saveExSiteFileCell;
    }
    self.saveExSiteFileCell = (SwitchDataCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (self.saveExSiteFileCell == nil)
    {
        self.saveExSiteFileCell = [[SwitchDataCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }else{
        return self.saveExSiteFileCell;
    }
    self.saveExSiteFileCell.nameLabelCell.text		= S_SETTING_USERINFO_SAVE_OUTSIDE;
    self.saveExSiteFileCell.switchField.on			= profileData.saveExSiteFileMode;
    
    if(![S_LANG isEqualToString:S_LANG_EN]){
        // 自動調整サイズを取得
        CGFloat actualFontSize;
        [self.saveExSiteFileCell.nameLabelCell.text
         sizeWithFont:self.saveExSiteFileCell.nameLabelCell.font
         minFontSize:(self.saveExSiteFileCell.nameLabelCell.minimumScaleFactor * self.saveExSiteFileCell.nameLabelCell.font.pointSize)
         actualFontSize:&actualFontSize
         forWidth:self.saveExSiteFileCell.nameLabelCell.bounds.size.width
         lineBreakMode:self.saveExSiteFileCell.nameLabelCell.lineBreakMode];
        
        // 自動調整したフォントサイズが10以下なら、二段表示するか判定を行う
        if(actualFontSize < 11)
        {
            int iFontSize = [self.saveExSiteFileCell changeFontSize:self.saveExSiteFileCell.nameLabelCell.text];
            if (iFontSize != -1)
            {
                self.saveExSiteFileCell.nameLabelCell.lineBreakMode = NSLineBreakByWordWrapping;
                self.saveExSiteFileCell.nameLabelCell.numberOfLines = 2;
                [self.saveExSiteFileCell.nameLabelCell setFont:[UIFont systemFontOfSize:iFontSize]];
                
                // サイズ調整
                CGRect frame =  self.saveExSiteFileCell.nameLabelCell.frame;
                frame.size.height = 36;
                self.saveExSiteFileCell.nameLabelCell.frame = frame;
            }
        }
    } else {
        self.saveExSiteFileCell.nameLabelCell.lineBreakMode = NSLineBreakByWordWrapping;
        self.saveExSiteFileCell.nameLabelCell.numberOfLines = 2;
        
        // サイズ調整
        CGRect frame =  self.saveExSiteFileCell.nameLabelCell.frame;
        frame.size.height = 36;
        self.saveExSiteFileCell.nameLabelCell.frame = frame;
    }
    
    return self.saveExSiteFileCell;
}


// ジョブ送信のタイムアウト(秒)
- (UITableViewCell *)getJobTimeOut:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *CellIdentifier = [NSString stringWithFormat:@"Cell%02ld%02ld", (long)indexPath.section, (long)indexPath.row];

    //
    //選択された PROFILE情報の取得
    //
    ProfileData *profileData = [manager loadProfileDataAtIndex:0];

    // ************************
    // ジョブ送信のタイムアウト(秒)
    // ************************
    self.jobTimeOutCell = (ProfileDataCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (self.jobTimeOutCell == nil)
    {
        // ジョブ送信のタイムアウト(秒)のセルを生成
        self.jobTimeOutCell = [[ProfileDataCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier itemNumber:ITEM_NUMBER_JOB_TIME_OUT];

        // タイトルを設定する
        self.jobTimeOutCell.nameLabelCell.text = S_SETTING_APPLICATION_JOB_TIMEOUT;

        self.jobTimeOutCell.nameEditableCell.textField.delegate = self;

        // ジョブ送信のタイムアウト(秒)を設定する
        if ([profileData.jobTimeOut length] > 0) {
            self.jobTimeOutCell.nameEditableCell.textField.text	= profileData.jobTimeOut;
        }else{
            self.jobTimeOutCell.nameEditableCell.textField.text	= defaultJobTimeOut;
        }
        //self.jobTimeOutCell.nameEditableCell.textField.keyboardAppearance = UIKeyboardAppearanceAlert;
        self.jobTimeOutCell.nameEditableCell.textField.keyboardAppearance = UIKeyboardAppearanceLight;
        self.jobTimeOutCell.nameEditableCell.textField.keyboardType = UIKeyboardTypeNumbersAndPunctuation;
    }

    return self.jobTimeOutCell;
}


// リテンション情報
- (UITableViewCell *)getRetentionInfo:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *CellIdentifier = [NSString stringWithFormat:@"Cell%02ld%02ld", (long)indexPath.section, (long)indexPath.row];
    
    // ************************
    // リテンション情報
    // ************************
    self.retentionCell = (DetailTextLabelCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (self.retentionCell == nil)
    {
        // textLabelとdetailTextLabelを、1:1の比率で生成する(文言の長さに合わせて比率を調整すること)
        self.retentionCell = [[DetailTextLabelCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier textLabelRatio:1 detailTextLabelRatio:1];
        
        // タイトル(リテンション)を設定する
        self.retentionCell.textLabelCell.text = S_TITLE_RETENTION;

        // 現在のリテンション情報を取得する
        self.retentionCell.detailTextLabelCell.text = [self getDisplayCurrentRetentionSetting];
        
    } else {
        // セルがすでに作成済みの場合は初期化処理を行わず、値の更新のみ行う
        self.retentionCell.detailTextLabelCell.text = [self getDisplayCurrentRetentionSetting];
    }
    
    return self.retentionCell;
}


// プリンタ／スキャナー自動切替
- (UITableViewCell *)getAutoSwitch:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *CellIdentifier = [NSString stringWithFormat:@"Cell%02ld%02ld", (long)indexPath.section, (long)indexPath.row];
    
    //
    //選択された PROFILE情報の取得
    //
    ProfileData *profileData = [manager loadProfileDataAtIndex:0];
    
    // セルがすでに作成済みの場合は初期化処理を行わずに抜ける
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell != nil)
    {
        return cell;
    }
    
    // ********************
    // このプリンター/スキャナーを選択
    // ********************
    if (self.autoSelectCell) {
        return self.autoSelectCell;
    }
    self.autoSelectCell = (SwitchDataCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (self.autoSelectCell == nil)
    {
        self.autoSelectCell = [[SwitchDataCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }else{
        return self.autoSelectCell;
    }
    self.autoSelectCell.nameLabelCell.text		= S_SETTING_USERINFO_AUTOSELECT;
    self.autoSelectCell.switchField.on			= profileData.autoSelectMode;
    
    if(![S_LANG isEqualToString:S_LANG_EN]){
        // 自動調整サイズを取得
        CGFloat actualFontSize;
        [self.autoSelectCell.nameLabelCell.text
         sizeWithFont:self.autoSelectCell.nameLabelCell.font
         minFontSize:(self.autoSelectCell.nameLabelCell.minimumScaleFactor * self.autoSelectCell.nameLabelCell.font.pointSize)
         actualFontSize:&actualFontSize
         forWidth:self.autoSelectCell.nameLabelCell.bounds.size.width
         lineBreakMode:self.autoSelectCell.nameLabelCell.lineBreakMode];
        
        // 自動調整したフォントサイズが10以下なら、二段表示するか判定を行う
        if(actualFontSize < 11)
        {
            int iFontSize = [self.autoSelectCell changeFontSize:self.autoSelectCell.nameLabelCell.text];
            if (iFontSize != -1)
            {
                self.autoSelectCell.nameLabelCell.lineBreakMode = NSLineBreakByWordWrapping;
                self.autoSelectCell.nameLabelCell.numberOfLines = 2;
                [self.autoSelectCell.nameLabelCell setFont:[UIFont systemFontOfSize:iFontSize]];
                
                // サイズ調整
                CGRect frame =  self.autoSelectCell.nameLabelCell.frame;
                frame.size.height = 36;
                self.autoSelectCell.nameLabelCell.frame = frame;
            }
        }
    } else {
        self.autoSelectCell.nameLabelCell.lineBreakMode = NSLineBreakByWordWrapping;
        self.autoSelectCell.nameLabelCell.numberOfLines = 2;
        
        // サイズ調整
        CGRect frame =  self.autoSelectCell.nameLabelCell.frame;
        frame.size.height = 36;
        self.autoSelectCell.nameLabelCell.frame = frame;
    }
    
    return self.autoSelectCell;
}


// 自動追加プリンター／スキャナーの名称
- (UITableViewCell *)getDeviceNameInfo:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *CellIdentifier = [NSString stringWithFormat:@"Cell%02ld%02ld", (long)indexPath.section, (long)indexPath.row];
    
    // ************************
    // 自動追加プリンター／スキャナーの名称
    // ************************
    self.deviceNameCell = (DetailTextLabelCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (self.deviceNameCell == nil)
    {
        // textLabelとdetailTextLabelを、1:1の比率で生成する(文言の長さに合わせて比率を調整すること)
        self.deviceNameCell = [[DetailTextLabelCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier textLabelRatio:1 detailTextLabelRatio:1];
        
        // タイトル(自動追加プリンター／スキャナーの名称)を設定する
        self.deviceNameCell.textLabelCell.text = S_TITLE_SETTING_DEVICENAME_STYLE;
        
        // 現在の自動検出デバイス名のスタイルを取得する
        [self getDisplayCurrentDeviceNameStyle];
        
    } else {
        // セルがすでに作成済みの場合は初期化処理を行わず、値の更新のみ行う
        [self getDisplayCurrentDeviceNameStyle];
    }
    
    return self.deviceNameCell;
}


// publicで検索する
- (UITableViewCell *)getSearchPublic:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *CellIdentifier = [NSString stringWithFormat:@"Cell%02ld%02ld", (long)indexPath.section, (long)indexPath.row];
    
    //
    //選択された PROFILE情報の取得
    //
    ProfileData *profileData = [manager loadProfileDataAtIndex:0];
    
    // セルがすでに作成済みの場合は初期化処理を行わずに抜ける
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell != nil)
    {
        return cell;
    }
    
    // publicで検索する
    if (self.snmpSearchPublic) {
        return self.snmpSearchPublic;
    }
    self.snmpSearchPublic = (SwitchDataCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (self.snmpSearchPublic == nil)
    {
        self.snmpSearchPublic = [[SwitchDataCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }else{
        return self.snmpSearchPublic;
    }
    self.snmpSearchPublic.nameLabelCell.text    = S_SETTING_APPLICATION_SNMP_SEARCH_PUBLIC;
    self.snmpSearchPublic.switchField.on      = !profileData.snmpSearchPublicMode;
    
    if(![S_LANG isEqualToString:S_LANG_EN]){
        // 自動調整サイズを取得
        CGFloat actualFontSize;
        [self.snmpSearchPublic.nameLabelCell.text
         sizeWithFont:self.snmpSearchPublic.nameLabelCell.font
         minFontSize:(self.snmpSearchPublic.nameLabelCell.minimumScaleFactor * self.snmpSearchPublic.nameLabelCell.font.pointSize)
         actualFontSize:&actualFontSize
         forWidth:self.snmpSearchPublic.nameLabelCell.bounds.size.width
         lineBreakMode:self.snmpSearchPublic.nameLabelCell.lineBreakMode];
        
        // 自動調整したフォントサイズが10以下なら、二段表示するか判定を行う
        if(actualFontSize < 11)
        {
            int iFontSize = [self.snmpSearchPublic changeFontSize:self.snmpSearchPublic.nameLabelCell.text];
            if (iFontSize != -1)
            {
                self.snmpSearchPublic.nameLabelCell.lineBreakMode = NSLineBreakByWordWrapping;
                self.snmpSearchPublic.nameLabelCell.numberOfLines = 2;
                [self.snmpSearchPublic.nameLabelCell setFont:[UIFont systemFontOfSize:iFontSize]];
                // サイズ調整
                CGRect frame =  self.snmpSearchPublic.nameLabelCell.frame;
                frame.size.height = 36;
                self.snmpSearchPublic.nameLabelCell.frame = frame;
            }
        }
    } else {
        self.snmpSearchPublic.nameLabelCell.lineBreakMode = NSLineBreakByWordWrapping;
        self.snmpSearchPublic.nameLabelCell.numberOfLines = 2;
        // サイズ調整
        CGRect frame =  self.snmpSearchPublic.nameLabelCell.frame;
        frame.size.height = 36;
        self.snmpSearchPublic.nameLabelCell.frame = frame;
    }
    
    return self.snmpSearchPublic;
}


// Community String
- (UITableViewCell *)getCommunityString:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *CellIdentifier = [NSString stringWithFormat:@"Cell%02ld%02ld", (long)indexPath.section, (long)indexPath.row];
    
    //
    //選択された PROFILE情報の取得
    //
    ProfileData *profileData = [manager loadProfileDataAtIndex:0];
    
    // セルがすでに作成済みの場合は初期化処理を行わずに抜ける
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell != nil)
    {
        return cell;
    }
    
    // Community String
    if (self.snmpCommunityString) {
        return self.snmpCommunityString;
    }
    self.snmpCommunityString = (ProfileDataCellMulti *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if(self.snmpCommunityString == nil)
    {
        self.snmpCommunityString = [[ProfileDataCellMulti alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }else{
        return self.snmpCommunityString;
    }
    
    self.snmpCommunityString.nameEditableCellMulti.textView.delegate = self;
    self.snmpCommunityString.nameLabelCell.text                  = S_SETTING_APPLICATION_SNMP_COMMUNITY_STRING;
    self.snmpCommunityString.nameLabelCell.numberOfLines             = 0;
    [self.snmpCommunityString.nameLabelCell sizeToFit];
    self.snmpCommunityString.nameEditableCellMulti.textView.text     = profileData.snmpCommunityString;
    self.snmpCommunityString.nameEditableCellMulti.textView.tag      = 0;
    //self.snmpCommunityString.nameEditableCellMulti.textView.keyboardAppearance = UIKeyboardAppearanceAlert;
    self.snmpCommunityString.nameEditableCellMulti.textView.keyboardAppearance = UIKeyboardAppearanceLight;
    self.snmpCommunityString.nameEditableCellMulti.textView.placeholder = S_SETTING_APPLICATION_SNMP_COMMUNITY_STRING_DEFAULT;
    
    // サイズ調整
    CGRect frame =  self.snmpCommunityString.nameEditableCellMulti.frame;
    frame.size.height = 210;
    self.snmpCommunityString.nameEditableCellMulti.frame = frame;
    
    frame = self.snmpCommunityString.nameEditableCellMulti.textView.frame;
    frame.size.height = 200;
    self.snmpCommunityString.nameEditableCellMulti.textView.frame = frame;
    
    return self.snmpCommunityString;
}


// 現在のリテンション設定を取得する
- (NSString*)getDisplayCurrentRetentionSetting{
    
    // managerを初期化してからプロファイルデータを取得する
    manager = [[ProfileDataManager alloc]init];
    ProfileData *profileData = [manager loadProfileDataAtIndex:0];
    
    NSString *value;
    
    // 現在のリテンション設定より文言を決める
    if (profileData.noPrint) {
        if (profileData.retentionAuth) {
            // パスワード付きリテンション設定中
            value = S_RETENTION_HOLDON;
        } else {
            // パスワードなしリテンション設定中
            value = S_RETENTION_HOLDON;
        }
    } else {
        // リテンション未設定
        value = S_RETENTION_HOLDOFF;
    }
    return value;
}


// 現在のリテンション設定を取得する
- (void)reloadRetentionSettings{
    NSIndexPath* indexPath = [NSIndexPath indexPathForRow:PRINT_SECTION_RETENTION_INFO inSection:PRINT_SECTION_APPLICATION];
    NSArray* indexPaths = [NSArray arrayWithObject:indexPath];
    [self.tableView reloadRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationNone];
}


// 自動検出デバイス名のスタイル
- (void)getDisplayCurrentDeviceNameStyle{
    
    // managerを初期化してからプロファイルデータを取得する
    manager = [[ProfileDataManager alloc]init];
    ProfileData *profileData = [manager loadProfileDataAtIndex:0];
    
    // profileData.deviceNameSetting に不正な値が入っていれば0を入れておく
    if(profileData.deviceNameStyle < 0 ||
       self.deviceNameSettings.count-1 < profileData.deviceNameStyle)
    {
        profileData.deviceNameStyle = 0;
    }
    DLog(@"%ld",(long)profileData.deviceNameStyle);
    
    self.deviceNameCell.detailTextLabelCell.text = self.deviceNameSettings[profileData.deviceNameStyle];
    self.deviceNameIndex = profileData.deviceNameStyle;
}

- (void)callBackIndex:(SettingDeviceNameInfoTableViewController *)vc {
    self.deviceNameCell.detailTextLabelCell.text = self.deviceNameSettings[vc.selectedIndex];
    self.deviceNameIndex = vc.selectedIndex;
}

@end