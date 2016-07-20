
#import "SettingUserInfoViewController_iPad.h"
#import "Define.h"
#import "CommonUtil.h"
#import "SharpScanPrintAppDelegate.h"
#import "RootViewController_iPad.h"
#import "SettingSelInfoViewController_iPad.h"
#import "PJLDataManager.h"

@implementation SettingUserInfoViewController_iPad

//
// アクセサメソッドの自動合成(ゲッターとセッターの役割)
//
@synthesize		nameCell;           // 表示名
@synthesize		sercCell;           // 検索文字列
@synthesize		ipaddCell;          // ipアドレス
@synthesize     loginNameCell;      // ログイン名
@synthesize     loginPasswordCell;  // パスワード
@synthesize     userNoCell;         // ユーザー番号
@synthesize     userNameCell;       // ユーザー名
@synthesize     jobNameCell;        // ジョブ名
@synthesize     useLoginNameForUserName;

enum{
    USER_AUTH_STYLE_LOGIN,
    USER_AUTH_STYLE_USERNO,
};

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
    
    self.navigationItem.title = S_TITLE_SETTING_USER;
    
    // iPad用
    //// 戻るボタンの名称変更
    //UIBarButtonItem * barItemBack = [UIBarButtonItem new];
    //barItemBack.title = S_BUTTON_BACK;
    //self.navigationItem.backBarButtonItem = barItemBack;
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
    /*
     UISegmentedControl *btn = [[[UISegmentedControl alloc]initWithItems:[NSArray arrayWithObjects:S_BUTTON_SAVEVAL, nil]] autorelease];
     btn.momentary = YES;
     btn.segmentedControlStyle = UISegmentedControlStyleBar;
     btn.frame = CGRectMake(0.0f, 0.0f, 50.0f, 30.0f);
     btn.tintColor = [UIColor blueColor];
     [btn addTarget:self action:@selector(dosave:) forControlEvents:UIControlEventValueChanged];
     UIBarButtonItem* btnSave = [[[UIBarButtonItem alloc] initWithCustomView:btn] autorelease];
     */
    UIBarButtonItem* btnSave = [[UIBarButtonItem alloc] initWithTitle:S_BUTTON_SAVEVAL style:UIBarButtonItemStyleDone target:self action:@selector(dosave:)];
    
    self.navigationItem.rightBarButtonItem	= btnSave;
    
    ProfileData *profileData = [manager loadProfileDataAtIndex:0];
    m_nUserAuthStyle = profileData.userAuthStyle;
    
    // テーブルのセクションIDリストを初期化
    tableSectionIDs = [[NSMutableArray alloc]init];
    for(int i = 0; i < 5; i++){
        if([self visibleSection:i]){
            [tableSectionIDs addObject:[NSNumber numberWithInt:i]];
        }
    }
    
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
    return [tableSectionIDs count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
	NSInteger nRet = 0;
    int sectionId = [[tableSectionIDs objectAtIndex:section] intValue];
	if(sectionId == 0)
	{
		nRet = N_NUM_ROW_USERINFO_SEC1;
	}
	else if(sectionId == 1)
	{
		nRet = N_NUM_ROW_USERINFO_SEC2;
	}
    else if(sectionId == 2)
    {
        if(m_nUserAuthStyle == USER_AUTH_STYLE_LOGIN){
            nRet = N_NUM_ROW_USERINFO_SEC3;
        }else{
            nRet = N_NUM_ROW_USERINFO_SEC3 -2;
        }
    }
    else if(sectionId == 3)
    {
        if(m_nUserAuthStyle == USER_AUTH_STYLE_LOGIN){
            nRet = N_NUM_ROW_USERINFO_SEC4 -1;
        }else{
            nRet = N_NUM_ROW_USERINFO_SEC4;
        }
    }
    else if(sectionId == 4)
    {
        nRet = N_NUM_ROW_USERINFO_SEC5;
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
            int sectionId = [[tableSectionIDs objectAtIndex:indexPath.section] intValue];
            NSString *CellIdentifier = [NSString stringWithFormat:@"Cell%02d%02ld", sectionId, (long)indexPath.row];
            
            //
            //選択された PROFILE情報の取得
            //
            ProfileData *profileData = [manager loadProfileDataAtIndex:0];
            
            // Cellがすでに作成済みの場合は初期化処理を行わずに抜ける
            ProfileDataCell *cell = (ProfileDataCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
            if (cell != nil)
            {
                return cell;
            }
            
            //
            // 指定されたセルを返却
            //
            if (sectionId == 0)
            {
                if (indexPath.row == 0)
                {
                    // ********************
                    // 表示名
                    // ********************
                    self.nameCell = (ProfileDataCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
                    if (self.nameCell == nil)
                    {
                        self.nameCell = [[ProfileDataCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
                    }
                    self.nameCell.nameEditableCell.textField.delegate = self;
                    self.nameCell.nameLabelCell.text				= S_SETTING_USERINFO_NAME;
                    self.nameCell.nameEditableCell.textField.text	= profileData.profileName;
                    self.nameCell.nameEditableCell.textField.tag	= 0;
                    //self.nameCell.nameEditableCell.textField.keyboardAppearance = UIKeyboardAppearanceAlert;
                    self.nameCell.nameEditableCell.textField.keyboardAppearance = UIKeyboardAppearanceLight;
                    
                    if(![S_LANG isEqualToString:S_LANG_EN]){
                        // 自動調整サイズを取得
                        CGFloat actualFontSize;
                        [self.nameCell.nameLabelCell.text
                         sizeWithFont:self.nameCell.nameLabelCell.font
                         minFontSize:(self.nameCell.nameLabelCell.minimumScaleFactor * self.nameCell.nameLabelCell.font.pointSize)
                         actualFontSize:&actualFontSize
                         forWidth:self.nameCell.nameLabelCell.bounds.size.width
                         lineBreakMode:self.nameCell.nameLabelCell.lineBreakMode];
                        
                        // 自動調整したフォントサイズが10以下なら、二段表示するか判定を行う
                        if(actualFontSize < 11)
                        {
                            int iFontSize = [self.nameCell changeFontSize:self.nameCell.nameLabelCell.text];
                            if (iFontSize != -1)
                            {
                                self.nameCell.nameLabelCell.lineBreakMode = NSLineBreakByWordWrapping;
                                self.nameCell.nameLabelCell.numberOfLines = 2;
                                [self.nameCell.nameLabelCell setFont:[UIFont systemFontOfSize:iFontSize]];
                                // サイズ調整
                                CGRect frame =  self.nameCell.nameLabelCell.frame;
                                frame.size.height = 36;
                                self.nameCell.nameLabelCell.frame = frame;
                            }
                            
                        }
                    } else {
                        self.nameCell.nameLabelCell.lineBreakMode = NSLineBreakByWordWrapping;
                        self.nameCell.nameLabelCell.numberOfLines = 2;
                        // サイズ調整
                        CGRect frame =  self.nameCell.nameLabelCell.frame;
                        frame.size.height = 36;
                        self.nameCell.nameLabelCell.frame = frame;
                    }
                    
                    return self.nameCell;
                    
                }
                else if (indexPath.row == 1)
                {
                    // ********************
                    // 検索文字
                    // ********************
                    self.sercCell = (ProfileDataCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
                    if (self.sercCell == nil)
                    {
                        self.sercCell = [[ProfileDataCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
                    }
                    self.sercCell.nameEditableCell.textField.delegate = self;
                    self.sercCell.nameLabelCell.text				= S_SETTING_USERINFO_SEARCH;
                    self.sercCell.nameEditableCell.textField.text	= profileData.serchString;
                    self.sercCell.nameEditableCell.textField.tag	= 1;
                    //self.sercCell.nameEditableCell.textField.keyboardAppearance = UIKeyboardAppearanceAlert;
                    self.sercCell.nameEditableCell.textField.keyboardAppearance = UIKeyboardAppearanceLight;
                    
                    if(![S_LANG isEqualToString:S_LANG_EN]){
                        // 自動調整サイズを取得
                        CGFloat actualFontSize;
                        [self.sercCell.nameLabelCell.text
                         sizeWithFont:self.sercCell.nameLabelCell.font
                         minFontSize:(self.sercCell.nameLabelCell.minimumScaleFactor * self.sercCell.nameLabelCell.font.pointSize)
                         actualFontSize:&actualFontSize
                         forWidth:self.sercCell.nameLabelCell.bounds.size.width
                         lineBreakMode:self.sercCell.nameLabelCell.lineBreakMode];
                        
                        // 自動調整したフォントサイズが10以下なら、二段表示するか判定を行う
                        if(actualFontSize < 11)
                        {
                            int iFontSize = [self.sercCell changeFontSize:self.sercCell.nameLabelCell.text];
                            if (iFontSize != -1)
                            {
                                self.sercCell.nameLabelCell.lineBreakMode = NSLineBreakByWordWrapping;
                                self.sercCell.nameLabelCell.numberOfLines = 2;
                                [self.sercCell.nameLabelCell setFont:[UIFont systemFontOfSize:iFontSize]];
                                // サイズ調整
                                CGRect frame =  self.sercCell.nameLabelCell.frame;
                                frame.size.height = 36;
                                self.sercCell.nameLabelCell.frame = frame;
                            }
                            
                        }
                    } else {
                        self.sercCell.nameLabelCell.lineBreakMode = NSLineBreakByWordWrapping;
                        self.sercCell.nameLabelCell.numberOfLines = 2;
                        // サイズ調整
                        CGRect frame =  self.sercCell.nameLabelCell.frame;
                        frame.size.height = 36;
                        self.sercCell.nameLabelCell.frame = frame;
                    }
                    
                    return self.sercCell;
                }
                else
                {
                    // ********************
                    // IPアドレス
                    // ********************
                    self.ipaddCell = (ProfileDataCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
                    if (self.ipaddCell == nil)
                    {
                        self.ipaddCell = [[ProfileDataCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
                    }
                    self.ipaddCell.nameEditableCell.textField.delegate = self;
                    //[self.ipaddCell.nameEditableCell.textField setPlaceholder:@"   .   .   ."];
                    self.ipaddCell.nameEditableCell.textField.enabled = false;
                    self.ipaddCell.nameLabelCell.text				= S_SETTING_USERINFO_IP_ADDRESS;
                    self.ipaddCell.nameEditableCell.textField.tag	= 2;
                    
                    if(![S_LANG isEqualToString:S_LANG_EN]){
                        // 自動調整サイズを取得
                        CGFloat actualFontSize;
                        [self.ipaddCell.nameLabelCell.text
                         sizeWithFont:self.ipaddCell.nameLabelCell.font
                         minFontSize:(self.ipaddCell.nameLabelCell.minimumScaleFactor * self.ipaddCell.nameLabelCell.font.pointSize)
                         actualFontSize:&actualFontSize
                         forWidth:self.ipaddCell.nameLabelCell.bounds.size.width
                         lineBreakMode:self.ipaddCell.nameLabelCell.lineBreakMode];
                        
                        // 自動調整したフォントサイズが10以下なら、二段表示するか判定を行う
                        if(actualFontSize < 11)
                        {
                            int iFontSize = [self.ipaddCell changeFontSize:self.ipaddCell.nameLabelCell.text];
                            if (iFontSize != -1)
                            {
                                self.ipaddCell.nameLabelCell.lineBreakMode = NSLineBreakByWordWrapping;
                                self.ipaddCell.nameLabelCell.numberOfLines = 2;
                                [self.ipaddCell.nameLabelCell setFont:[UIFont systemFontOfSize:iFontSize]];
                                // サイズ調整
                                CGRect frame =  self.ipaddCell.nameLabelCell.frame;
                                frame.size.height = 36;
                                self.ipaddCell.nameLabelCell.frame = frame;
                            }
                            
                        }
                    } else {
                        self.ipaddCell.nameLabelCell.lineBreakMode = NSLineBreakByWordWrapping;
                        self.ipaddCell.nameLabelCell.numberOfLines = 2;
                        // サイズ調整
                        CGRect frame =  self.ipaddCell.nameLabelCell.frame;
                        frame.size.height = 36;
                        self.ipaddCell.nameLabelCell.frame = frame;
                    }
                    
                    NSString *iPaddr	=[CommonUtil getIPAdder];
                    NSUInteger len	= [[iPaddr stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] length];
                    if (len <= 0)
                    {
                        self.ipaddCell.nameEditableCell.textField.text	= nil;
                    }
                    else
                    {
                        self.ipaddCell.nameEditableCell.textField.text	= iPaddr;
                    }
                    
                    return self.ipaddCell;
                    
                }
            }
            else if (sectionId == 1)
            {
                // -------------
                // ユーザー認証
                // -------------
                UITableViewCell* nomalCell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
                UILabel* titleLbl = nil;
                if(nomalCell == nil){
                    nomalCell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
                    
                    float iOSVersion = [[[UIDevice currentDevice] systemVersion] floatValue];
                    
                    // タイトルラベルの作成
                    CGRect titleLblFrame = nomalCell.contentView.frame;
                    
                    if(iOSVersion >= 7.0 || UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
                    {
                        // iOS7以降 もしくはiPad
                        titleLblFrame.origin.x += 20;
                        titleLblFrame.size.width += 40;
                    }else{
                        // iOS6以前
                        titleLblFrame.origin.x += 10;
                        titleLblFrame.size.width -= 10;
                    }
                    
                    titleLbl = [[UILabel alloc]initWithFrame:titleLblFrame];
                    titleLbl.font = [UIFont systemFontOfSize:[UIFont systemFontSize]];
                    titleLbl.backgroundColor = [UIColor clearColor];
                    titleLbl.autoresizingMask = UIViewAutoresizingFlexibleWidth;
                    titleLbl.tag = 3;
                    
                    [nomalCell.contentView addSubview:titleLbl];
                    
                    // 現在の設定を読み込む
                    m_nUserAuthStyle = profileData.userAuthStyle;
                    
                }else{
                    titleLbl = (UILabel*)[nomalCell.contentView viewWithTag:3];
                }
                
                // タイトルの設定
                if(titleLbl){
                    if(indexPath.row == 0){
                        titleLbl.text = S_SETTING_USERINFO_STYLE_LOFIN;
                    }else{
                        titleLbl.text = S_SETTING_USERINFO_STYLE_USER;
                    }
                }
                
                // 選択状態の設定
                if(indexPath.row == m_nUserAuthStyle){
                    [nomalCell setAccessoryType:UITableViewCellAccessoryCheckmark];
                }else{
                    [nomalCell setAccessoryType:UITableViewCellAccessoryNone];
                }
                
                return nomalCell;
            }
            else if (sectionId == 2)
            {
                if(indexPath.row == 0)
                {
                    // ********************
                    // ログイン名
                    // ********************
                    self.loginNameCell = (ProfileDataCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
                    if (self.loginNameCell == nil)
                    {
                        self.loginNameCell = [[ProfileDataCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
                    }
                    NSString *decryptLoginName = profileData.loginName;
                    if([decryptLoginName length] > 0)
                    {
                        decryptLoginName = [CommonUtil decryptString:[CommonUtil base64Decoding:profileData.loginName] withKey:S_KEY_PJL];
                    }
                    self.loginNameCell.nameEditableCell.textField.delegate = self;
                    self.loginNameCell.nameLabelCell.text				= S_SETTING_USERINFO_LOGINNAME;
                    self.loginNameCell.nameEditableCell.textField.text	= decryptLoginName;
                    self.loginNameCell.nameEditableCell.textField.tag	= 3;
                    //self.loginNameCell.nameEditableCell.textField.keyboardAppearance = UIKeyboardAppearanceAlert;
                    self.loginNameCell.nameEditableCell.textField.keyboardAppearance = UIKeyboardAppearanceLight;
                    
                    if(![S_LANG isEqualToString:S_LANG_EN]){
                        // 自動調整サイズを取得
                        CGFloat actualFontSize;
                        [self.loginNameCell.nameLabelCell.text
                         sizeWithFont:self.loginNameCell.nameLabelCell.font
                         minFontSize:(self.loginNameCell.nameLabelCell.minimumScaleFactor * self.loginNameCell.nameLabelCell.font.pointSize)
                         actualFontSize:&actualFontSize
                         forWidth:self.loginNameCell.nameLabelCell.bounds.size.width
                         lineBreakMode:self.loginNameCell.nameLabelCell.lineBreakMode];
                        
                        // 自動調整したフォントサイズが10以下なら、二段表示するか判定を行う
                        if(actualFontSize < 11)
                        {
                            int iFontSize = [self.loginNameCell changeFontSize:self.loginNameCell.nameLabelCell.text];
                            if (iFontSize != -1)
                            {
                                self.loginNameCell.nameLabelCell.lineBreakMode = NSLineBreakByWordWrapping;
                                self.loginNameCell.nameLabelCell.numberOfLines = 2;
                                [self.loginNameCell.nameLabelCell setFont:[UIFont systemFontOfSize:iFontSize]];
                                // サイズ調整
                                CGRect frame =  self.loginNameCell.nameLabelCell.frame;
                                frame.size.height = 36;
                                self.loginNameCell.nameLabelCell.frame = frame;
                            }
                            
                        }
                    } else {
                        self.loginNameCell.nameLabelCell.lineBreakMode = NSLineBreakByWordWrapping;
                        self.loginNameCell.nameLabelCell.numberOfLines = 2;
                        // サイズ調整
                        CGRect frame =  self.loginNameCell.nameLabelCell.frame;
                        frame.size.height = 36;
                        self.loginNameCell.nameLabelCell.frame = frame;
                    }
                    
                    return self.loginNameCell;
                }
                else
                {
                    // ********************
                    // パスワード
                    // ********************
                    self.loginPasswordCell = (ProfileDataCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
                    if (self.loginPasswordCell == nil)
                    {
                        self.loginPasswordCell = [[ProfileDataCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
                    }
                    NSString *decryptLoginPassword = profileData.loginPassword;
                    if([decryptLoginPassword length] > 0)
                    {
                        decryptLoginPassword = [CommonUtil decryptString:[CommonUtil base64Decoding:profileData.loginPassword] withKey:S_KEY_PJL];
                    }
                    self.loginPasswordCell.nameEditableCell.textField.delegate = self;
                    self.loginPasswordCell.nameLabelCell.text				= S_SETTING_USERINFO_LOGINPASSWORD;
                    self.loginPasswordCell.nameEditableCell.textField.text	= decryptLoginPassword;
                    self.loginPasswordCell.nameEditableCell.textField.secureTextEntry = YES;
                    self.loginPasswordCell.nameEditableCell.textField.tag	= 4;
                    //self.loginPasswordCell.nameEditableCell.textField.keyboardAppearance = UIKeyboardAppearanceAlert;
                    self.loginPasswordCell.nameEditableCell.textField.keyboardAppearance = UIKeyboardAppearanceLight;
                    
                    if(![S_LANG isEqualToString:S_LANG_EN]){
                        // 自動調整サイズを取得
                        CGFloat actualFontSize;
                        [self.loginPasswordCell.nameLabelCell.text
                         sizeWithFont:self.loginPasswordCell.nameLabelCell.font
                         minFontSize:(self.loginPasswordCell.nameLabelCell.minimumScaleFactor * self.loginPasswordCell.nameLabelCell.font.pointSize)
                         actualFontSize:&actualFontSize
                         forWidth:self.loginPasswordCell.nameLabelCell.bounds.size.width
                         lineBreakMode:self.loginPasswordCell.nameLabelCell.lineBreakMode];
                        
                        // 自動調整したフォントサイズが10以下なら、二段表示するか判定を行う
                        if(actualFontSize < 11)
                        {
                            int iFontSize = [self.loginPasswordCell changeFontSize:self.loginPasswordCell.nameLabelCell.text];
                            if (iFontSize != -1)
                            {
                                self.loginPasswordCell.nameLabelCell.lineBreakMode = NSLineBreakByWordWrapping;
                                self.loginPasswordCell.nameLabelCell.numberOfLines = 2;
                                [self.loginPasswordCell.nameLabelCell setFont:[UIFont systemFontOfSize:iFontSize]];
                                // サイズ調整
                                CGRect frame =  self.loginPasswordCell.nameLabelCell.frame;
                                frame.size.height = 36;
                                self.loginPasswordCell.nameLabelCell.frame = frame;
                            }
                            
                        }
                    } else {
                        self.loginPasswordCell.nameLabelCell.lineBreakMode = NSLineBreakByWordWrapping;
                        self.loginPasswordCell.nameLabelCell.numberOfLines = 2;
                        // サイズ調整
                        CGRect frame =  self.loginPasswordCell.nameLabelCell.frame;
                        frame.size.height = 36;
                        self.loginPasswordCell.nameLabelCell.frame = frame;
                    }
                    
                    return self.loginPasswordCell;
                }
            }
            else if (sectionId == 3)
            {
                if(indexPath.row == 0)
                {
                    // ********************
                    // ユーザー番号
                    // ********************
                    self.userNoCell = (ProfileDataCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
                    if (self.userNoCell == nil)
                    {
                        self.userNoCell = [[ProfileDataCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
                    }
                    self.userNoCell.nameEditableCell.textField.delegate = self;
                    self.userNoCell.nameLabelCell.text				= S_SETTING_USERINFO_USERNO;
                    self.userNoCell.nameEditableCell.textField.text	= profileData.userNo;
                    self.userNoCell.nameEditableCell.textField.secureTextEntry = YES;
                    self.userNoCell.nameEditableCell.textField.tag	= 6;
                    //self.userNoCell.nameEditableCell.textField.keyboardAppearance = UIKeyboardAppearanceAlert;
                    self.userNoCell.nameEditableCell.textField.keyboardAppearance = UIKeyboardAppearanceLight;
                    
                    if(![S_LANG isEqualToString:S_LANG_EN]){
                        // 自動調整サイズを取得
                        CGFloat actualFontSize;
                        [self.userNoCell.nameLabelCell.text
                         sizeWithFont:self.userNoCell.nameLabelCell.font
                         minFontSize:(self.userNoCell.nameLabelCell.minimumScaleFactor * self.userNoCell.nameLabelCell.font.pointSize)
                         actualFontSize:&actualFontSize
                         forWidth:self.userNoCell.nameLabelCell.bounds.size.width
                         lineBreakMode:self.userNoCell.nameLabelCell.lineBreakMode];
                        
                        // 自動調整したフォントサイズが10以下なら、二段表示するか判定を行う
                        if(actualFontSize < 11)
                        {
                            int iFontSize = [self.userNoCell changeFontSize:self.userNoCell.nameLabelCell.text];
                            if (iFontSize != -1)
                            {
                                self.userNoCell.nameLabelCell.lineBreakMode = NSLineBreakByWordWrapping;
                                self.userNoCell.nameLabelCell.numberOfLines = 2;
                                [self.userNoCell.nameLabelCell setFont:[UIFont systemFontOfSize:iFontSize]];
                                // サイズ調整
                                CGRect frame =  self.userNoCell.nameLabelCell.frame;
                                frame.size.height = 36;
                                self.userNoCell.nameLabelCell.frame = frame;
                            }
                            
                        }
                    } else {
                        self.userNoCell.nameLabelCell.lineBreakMode = NSLineBreakByWordWrapping;
                        self.userNoCell.nameLabelCell.numberOfLines = 2;
                        // サイズ調整
                        CGRect frame =  self.userNoCell.nameLabelCell.frame;
                        frame.size.height = 36;
                        self.userNoCell.nameLabelCell.frame = frame;
                    }
                    
                    return self.userNoCell;
                }
            }
            else
            {
                if(indexPath.row == 0)
                {
                    // ********************
                    // ユーザー名にログイン名を使用する
                    // ********************
                    
                    self.useLoginNameForUserName = (SwitchDataCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
                    if (self.useLoginNameForUserName == nil)
                    {
                        self.useLoginNameForUserName = [[SwitchDataCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
                    }
                    
                    self.useLoginNameForUserName.nameLabelCell.text		= S_SETTING_USERINFO_USE_LOGINNAME_FOR_USERNAME;
                    self.useLoginNameForUserName.switchField.on			= profileData.bUseLoginNameForUserName;
                    self.useLoginNameForUserName.switchField.tag		= 2;
                    [self.useLoginNameForUserName.switchField addTarget:self action:@selector(changeSwitchValue:) forControlEvents:UIControlEventValueChanged];
                    
                    if(![S_LANG isEqualToString:S_LANG_EN]){
                        // 自動調整サイズを取得
                        CGFloat actualFontSize;
                        [self.useLoginNameForUserName.nameLabelCell.text
                         sizeWithFont:self.useLoginNameForUserName.nameLabelCell.font
                         minFontSize:(self.useLoginNameForUserName.nameLabelCell.minimumScaleFactor * self.useLoginNameForUserName.nameLabelCell.font.pointSize)
                         actualFontSize:&actualFontSize
                         forWidth:self.useLoginNameForUserName.nameLabelCell.bounds.size.width
                         lineBreakMode:self.useLoginNameForUserName.nameLabelCell.lineBreakMode];
                        
                        // 自動調整したフォントサイズが10以下なら、二段表示するか判定を行う
                        if(actualFontSize < 11)
                        {
                            int iFontSize = [self.useLoginNameForUserName changeFontSize:self.useLoginNameForUserName.nameLabelCell.text];
                            if (iFontSize != -1)
                            {
                                self.useLoginNameForUserName.nameLabelCell.lineBreakMode = NSLineBreakByWordWrapping;
                                self.useLoginNameForUserName.nameLabelCell.numberOfLines = 2;
                                [self.useLoginNameForUserName.nameLabelCell setFont:[UIFont systemFontOfSize:iFontSize]];
                                // サイズ調整
                                CGRect frame =  self.useLoginNameForUserName.nameLabelCell.frame;
                                frame.size.height = 36;
                                self.useLoginNameForUserName.nameLabelCell.frame = frame;
                            }
                        }
                    } else {
                        self.useLoginNameForUserName.nameLabelCell.lineBreakMode = NSLineBreakByWordWrapping;
                        self.useLoginNameForUserName.nameLabelCell.numberOfLines = 2;
                        // サイズ調整
                        CGRect frame =  self.useLoginNameForUserName.nameLabelCell.frame;
                        frame.size.height = 36;
                        self.useLoginNameForUserName.nameLabelCell.frame = frame;
                    }
                    
                    return self.useLoginNameForUserName;
                    
                } else if(indexPath.row == 1) {
                    // ********************
                    // ユーザー名
                    // ********************
                    self.userNameCell = (ProfileDataCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
                    if (self.userNameCell == nil)
                    {
                        self.userNameCell = [[ProfileDataCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
                    }
                    self.userNameCell.nameEditableCell.textField.delegate = self;
                    self.userNameCell.nameLabelCell.text				= S_SETTING_USERINFO_USERNAME;
                    self.userNameCell.nameEditableCell.textField.text	= profileData.userName;
                    self.userNameCell.nameEditableCell.textField.tag	= 7;
                    //self.userNameCell.nameEditableCell.textField.keyboardAppearance = UIKeyboardAppearanceAlert;
                    self.userNameCell.nameEditableCell.textField.keyboardAppearance = UIKeyboardAppearanceLight;
                    
                    if(![S_LANG isEqualToString:S_LANG_EN]){
                        // 自動調整サイズを取得
                        CGFloat actualFontSize;
                        [self.userNameCell.nameLabelCell.text
                         sizeWithFont:self.userNameCell.nameLabelCell.font
                         minFontSize:(self.userNameCell.nameLabelCell.minimumScaleFactor * self.userNameCell.nameLabelCell.font.pointSize)
                         actualFontSize:&actualFontSize
                         forWidth:self.userNameCell.nameLabelCell.bounds.size.width
                         lineBreakMode:self.userNameCell.nameLabelCell.lineBreakMode];
                        
                        // 自動調整したフォントサイズが10以下なら、二段表示するか判定を行う
                        if(actualFontSize < 11)
                        {
                            int iFontSize = [self.userNameCell changeFontSize:self.userNameCell.nameLabelCell.text];
                            if (iFontSize != -1)
                            {
                                self.userNameCell.nameLabelCell.lineBreakMode = NSLineBreakByWordWrapping;
                                self.userNameCell.nameLabelCell.numberOfLines = 2;
                                [self.userNameCell.nameLabelCell setFont:[UIFont systemFontOfSize:iFontSize]];
                                // サイズ調整
                                CGRect frame =  self.userNameCell.nameLabelCell.frame;
                                frame.size.height = 36;
                                self.userNameCell.nameLabelCell.frame = frame;
                            }
                            
                        }
                    } else {
                        self.userNameCell.nameLabelCell.lineBreakMode = NSLineBreakByWordWrapping;
                        self.userNameCell.nameLabelCell.numberOfLines = 2;
                        // サイズ調整
                        CGRect frame =  self.userNameCell.nameLabelCell.frame;
                        frame.size.height = 36;
                        self.userNameCell.nameLabelCell.frame = frame;
                    }
                    
                    [self setUseLoginNameForUserNameSetting:self.useLoginNameForUserName.switchField.on];
                    
                    return self.userNameCell;
                }
                else
                {
                    // ********************
                    // ジョブ名
                    // ********************
                    self.jobNameCell = (ProfileDataCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
                    if (self.jobNameCell == nil)
                    {
                        self.jobNameCell = [[ProfileDataCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
                    }
                    self.jobNameCell.nameEditableCell.textField.delegate = self;
                    self.jobNameCell.nameLabelCell.text				= S_SETTING_USERINFO_JOBNAME;
                    self.jobNameCell.nameEditableCell.textField.text	= profileData.jobName;
                    self.jobNameCell.nameEditableCell.textField.tag	= 8;
                    //self.jobNameCell.nameEditableCell.textField.keyboardAppearance = UIKeyboardAppearanceAlert;
                    self.jobNameCell.nameEditableCell.textField.keyboardAppearance = UIKeyboardAppearanceLight;
                    
                    if(![S_LANG isEqualToString:S_LANG_EN]){
                        // 自動調整サイズを取得
                        CGFloat actualFontSize;
                        [self.jobNameCell.nameLabelCell.text
                         sizeWithFont:self.jobNameCell.nameLabelCell.font
                         minFontSize:(self.jobNameCell.nameLabelCell.minimumScaleFactor * self.jobNameCell.nameLabelCell.font.pointSize)
                         actualFontSize:&actualFontSize
                         forWidth:self.jobNameCell.nameLabelCell.bounds.size.width
                         lineBreakMode:self.jobNameCell.nameLabelCell.lineBreakMode];
                        
                        // 自動調整したフォントサイズが10以下なら、二段表示するか判定を行う
                        if(actualFontSize < 11)
                        {
                            int iFontSize = [self.jobNameCell changeFontSize:self.jobNameCell.nameLabelCell.text];
                            if (iFontSize != -1)
                            {
                                self.jobNameCell.nameLabelCell.lineBreakMode = NSLineBreakByWordWrapping;
                                self.jobNameCell.nameLabelCell.numberOfLines = 2;
                                [self.jobNameCell.nameLabelCell setFont:[UIFont systemFontOfSize:iFontSize]];
                                // サイズ調整
                                CGRect frame =  self.jobNameCell.nameLabelCell.frame;
                                frame.size.height = 36;
                                self.jobNameCell.nameLabelCell.frame = frame;
                            }
                            
                        }
                    } else {
                        self.jobNameCell.nameLabelCell.lineBreakMode = NSLineBreakByWordWrapping;
                        self.jobNameCell.nameLabelCell.numberOfLines = 2;
                        // サイズ調整
                        CGRect frame =  self.jobNameCell.nameLabelCell.frame;
                        frame.size.height = 36;
                        self.jobNameCell.nameLabelCell.frame = frame;
                    }
                    
                    return self.jobNameCell;
                }
            }
        }
        @finally
        {
        }
    }
	return nil; //ビルド警告回避用
}

#pragma mark - Table view delegate
//
// ユーザー認証切り替え
//
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    int sectionId = [[tableSectionIDs objectAtIndex:indexPath.section] intValue];
    if(sectionId == 1){
        // ハイライトの解除
        [tableView deselectRowAtIndexPath:[tableView indexPathForSelectedRow] animated:YES];
        
        // 選択番号の更新
        m_nUserAuthStyle = indexPath.row;
        
        // チェックの設定
        for(int i = 0; i < N_NUM_ROW_USERINFO_SEC2; i++){
            UITableViewCell* cell = [tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:i inSection:indexPath.section]];
            int accessory = UITableViewCellAccessoryNone;
            if(i == indexPath.row){
                accessory = UITableViewCellAccessoryCheckmark;
            }
            
            [cell setAccessoryType:accessory];
        }
        
        // セクションの削除と挿入
        [self sectionDeleteAndInsert];
    }
}

#pragma mark - Table Section Delete And Insert
// セクションの削除と挿入
-(void)sectionDeleteAndInsert
{
    // セクションの削除
    NSMutableIndexSet* modIndexes = [NSMutableIndexSet indexSet];
    for(int secid = 0; secid < 5; secid++){
        int check = [self checkSectionDeleteOrInsert:secid];
        if(check == -1){
            // 削除リストに追加
            NSUInteger sec = [tableSectionIDs indexOfObject:[NSNumber numberWithInt:secid]];
            [modIndexes addIndex:sec];
        }
    }
    if(modIndexes.count){
        // 削除実行
        [tableSectionIDs removeObjectsAtIndexes:modIndexes];
        [self.tableView deleteSections:modIndexes withRowAnimation:UITableViewRowAnimationFade];
        
        // 削除を実行した場合は、アニメーション後に挿入のチェックのためにもう一度呼び出す
        [self performSelector:@selector(sectionDeleteAndInsert) withObject:nil afterDelay:0.0];
    }else{
        
        // セクションの挿入
        int sectionCount = 0;
        [modIndexes removeAllIndexes];
        for(int secid = 0; secid < 5; secid++){
            int check = [self checkSectionDeleteOrInsert:secid];
            if(check == 1){
                // 挿入リストに追加
                [modIndexes addIndex:sectionCount];
                sectionCount++;
            }else if(check != -1){
                NSUInteger indexNum = [tableSectionIDs indexOfObject:[NSNumber numberWithInt:secid]];
                if(indexNum != NSNotFound){
                    // 表示中ならばカウント
                    sectionCount++;
                }
            }
        }
        if(modIndexes.count){
            // テーブルのセクションIDリストを取得
            [tableSectionIDs removeAllObjects];
            for(int i = 0; i < 5; i++){
                if([self visibleSection:i]){
                    [tableSectionIDs addObject:[NSNumber numberWithInt:i]];
                }
            }
            
            // 挿入実行
            [self.tableView insertSections:modIndexes withRowAnimation:UITableViewRowAnimationFade];
            
            // 挿入アニメーション後にテーブルを更新
            [self.tableView performSelector:@selector(reloadData) withObject:nil afterDelay:0.5];
        }else{
            // テーブルを更新
            [self.tableView reloadData];
        }
    }
}

// セクションの挿入or削除判定
-(int)checkSectionDeleteOrInsert:(int)sectionId
{
    int res = 0;
    NSUInteger indexNum = [tableSectionIDs indexOfObject:[NSNumber numberWithInt:sectionId]];
    if(indexNum != NSNotFound){
        // 表示中
        if(![self visibleSection:sectionId]){
            // 削除する
            res = -1;
        }
    }else{
        // 非表示中
        if([self visibleSection:sectionId]){
            // 挿入する
            res = 1;
        }
    }
    return res;
}

-(BOOL)visibleSection:(int)sectionId
{
    BOOL res = YES;
    //　保存ボタンに処理を移動 iPhone用
    
    if(sectionId == 0){
    }
    else if(sectionId == 1){
    }
    else if(sectionId == 2){
        // ログイン名・パスワード
        if(m_nUserAuthStyle == USER_AUTH_STYLE_LOGIN){
            res = YES;
        }
        else{
            // 「認証にユーザー番号を使用する」の時は非表示
            res = NO;
        }
    }
    else if(sectionId == 3){
        // ユーザー番号
        if(m_nUserAuthStyle == USER_AUTH_STYLE_LOGIN){
            // 「認証にログイン名を使用する」の時は非表示
            res = NO;
        }
        else{
            res = YES;
        }
    }
    else if(sectionId == 4){
    }
    
    return res;
}

// 各セルの高さを設定
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return N_HEIGHT_SEL_DEFAULT;
}

//
// 各セクションのタイトルを決定する
//
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    int sectionId = [[tableSectionIDs objectAtIndex:section] intValue];
    NSString *title = @"";
    switch (sectionId) {
        case 0:
            title = S_TITLE_SETTING_USER_INFO;
            break;
        case 1:
            title = S_TITLE_SETTING_USER_AUTH;
            break;
        case 2:
            break;
        case 3:
            break;
        case 4:
            title = S_TITLE_SETTING_USER_JOB;
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
            BOOL		rtn;
            NSUInteger  len;
            // 表示名
            len = [CommonUtil strLength:[pData.profileName stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]]];
            if (len <= 0)
            {
                strerrMessage = [NSString stringWithFormat:MSG_REQUIRED_ERR, [NSString stringWithFormat:SUBMSG_ERR, SUBMSG_NAME_ERR, SUBMSG_SEARCH_ERR]];
                [self profileAlert:nil errMessage:strerrMessage];
                return NO;
                
            }
            else
            {
                if (len > 36)
                {
                    strerrMessage	= [[NSString alloc]initWithFormat:MSG_LENGTH_ERR,SUBMSG_NAME_ERR,SUBMSG_NAME_FORMAT];
                    [self profileAlert:nil errMessage:strerrMessage];
                    return NO;
                }
                
                // 絵文字入力チェック
                if ( [CommonUtil IsUsedEmoji: pData.profileName] ) {
                    strerrMessage = [[NSString alloc] initWithFormat: MSG_CHAR_TYPE_ERR, SUBMSG_NAME_ERR, SUBMSG_EMOJI];
                    [self profileAlert: nil errMessage: strerrMessage];
                    return NO;
                }
                
                rtn = [CommonUtil charCheck:pData.serchString];
            }
            
            // 検索文字列
            //（全角/半角10文字以内）
            // TODO 文字種判断
            
            len = [[pData.serchString stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] length];
            if (len <= 0)
            {
                strerrMessage = [NSString stringWithFormat:MSG_REQUIRED_ERR, [NSString stringWithFormat:SUBMSG_ERR, SUBMSG_NAME_ERR, SUBMSG_SEARCH_ERR]];
                [self profileAlert:nil errMessage:strerrMessage];
                return NO;
                
            }
            else
            {
                if (len > 10)
                {
                    strerrMessage	= [NSString stringWithFormat:MSG_LENGTH_ERR,SUBMSG_SEARCH_ERR,SUBMSG_SEARCH_FORMAT];
                    [self profileAlert:nil errMessage:strerrMessage];
                    return NO;
                }
                
                // 絵文字入力チェック
                if ( [CommonUtil IsUsedEmoji: pData.serchString] ) {
                    strerrMessage = [[NSString alloc] initWithFormat: MSG_CHAR_TYPE_ERR, SUBMSG_SEARCH_ERR, SUBMSG_EMOJI];
                    [self profileAlert: nil errMessage: strerrMessage];
                    return NO;
                }
                
                rtn = [CommonUtil charCheck:pData.serchString];
            }
            
            // ログイン名
            // (半角255文字、全角127文字以内)
            len = [CommonUtil strLength:[pData.loginName stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]]];
            if (255 < len)
            {
                strerrMessage = [NSString stringWithFormat:MSG_LENGTH_ERR, SUBMSG_LOGINNAME_ERR, SUBMSG_LOGINNAME_FORMAT];
                [self profileAlert:nil errMessage:strerrMessage];
                return NO;
            }
            
            // 絵文字入力チェック
            if ( [CommonUtil IsUsedEmoji: pData.loginName] ) {
                strerrMessage = [[NSString alloc] initWithFormat: MSG_CHAR_TYPE_ERR, SUBMSG_LOGINNAME_ERR, SUBMSG_EMOJI];
                [self profileAlert: nil errMessage: strerrMessage];
                return NO;
            }
            
            // パスワード
            // (半角32文字)
            NSUInteger len2;
            len2 = [[pData.loginPassword stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] length];
            if(len == 0 && len2 > 0)
            {
                strerrMessage = [NSString stringWithFormat:MSG_REQUIRED_ERR, SUBMSG_LOGINNAME_ERR];
                [self profileAlert:nil errMessage:strerrMessage];
                return NO;
            }
            
            if ([CommonUtil isZen:pData.loginPassword])
            {
                strerrMessage = [NSString stringWithFormat:MSG_FORMAT_ERR, SUBMSG_LOGINPASSWORD_ERR, SUBMSG_LOGINPASSWORD_FORMAT];
                [self profileAlert:nil errMessage:strerrMessage];
                return NO;
            }
            
            if (32 < len2)
            {
                strerrMessage = [NSString stringWithFormat:MSG_LENGTH_ERR, SUBMSG_LOGINPASSWORD_ERR, SUBMSG_LOGINPASSWORD_FORMAT];
                [self profileAlert:nil errMessage:strerrMessage];
                return NO;
            }
            
            // ユーザー番号
            // (半角数値5〜8桁)
            len = [CommonUtil strLength:[pData.userNo stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]]];
            // 半角数字チェック
            if (0 < len)
            {
                char* chars = (char*)[pData.userNo UTF8String];
                for(int i = 0; i < pData.userNo.length; i++){
                    if(chars[i] >= '0' && chars[i] <= '9'){
                        continue;
                    }else if(chars[i] == '\0'){
                        // 終端文字
                        break;
                    }else{
                        strerrMessage = [NSString stringWithFormat:MSG_CHAR_TYPE_ERR, SUBMSG_USERNO_ERR, SUBMSG_ONLY_HALFCHAR_NUMBER];
                        [self profileAlert:nil errMessage:strerrMessage];
                        return NO;
                    }
                }
            }
            //長さチェック（最大）
            if (8 < len)
            {
                strerrMessage = [NSString stringWithFormat:MSG_FORMAT_ERR, SUBMSG_USERNO_ERR, SUBMSG_USERNO_FORMAT];
                [self profileAlert:nil errMessage:strerrMessage];
                return NO;
            }
            //長さチェック（最小）
            if (0 < len && len < 5)
            {
                strerrMessage = [NSString stringWithFormat:MSG_FORMAT_ERR, SUBMSG_USERNO_ERR, SUBMSG_USERNO_FORMAT];
                [self profileAlert:nil errMessage:strerrMessage];
                return NO;
            }
            
            // 絵文字入力チェック
            if ( [CommonUtil IsUsedEmoji: pData.userNo] ) {
                strerrMessage = [[NSString alloc] initWithFormat: MSG_FORMAT_ERR, SUBMSG_USERNO_ERR, SUBMSG_EMOJI];
                [self profileAlert: nil errMessage: strerrMessage];
                return NO;
            }
            
            // ユーザー名
            // (半角32文字、全角16文字以内)
            len = [CommonUtil strLength:[pData.userName stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]]];
            if (32 < len)
            {
                strerrMessage = [NSString stringWithFormat:MSG_LENGTH_ERR, SUBMSG_USERNAME_ERR, SUBMSG_USERNAME_FORMAT];
                [self profileAlert:nil errMessage:strerrMessage];
                return NO;
            }
            
            // 絵文字入力チェック
            if ( [CommonUtil IsUsedEmoji: pData.userName] ) {
                strerrMessage = [[NSString alloc] initWithFormat: MSG_FORMAT_ERR, SUBMSG_USERNAME_ERR, SUBMSG_EMOJI];
                [self profileAlert: nil errMessage: strerrMessage];
                return NO;
            }
            
            // ジョブ名
            // (半角30文字、全角15文字以内)
            len = [CommonUtil strLength:[pData.jobName stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]]];
            if (80 < len)
            {
                strerrMessage = [NSString stringWithFormat:MSG_LENGTH_ERR, SUBMSG_JOBNAME_ERR, SUBMSG_JOBNAME_FORMAT];
                [self profileAlert:nil errMessage:strerrMessage];
                return NO;
            }
            
            // 絵文字入力チェック
            if ( [CommonUtil IsUsedEmoji: pData.jobName] ) {
                strerrMessage = [[NSString alloc] initWithFormat: MSG_FORMAT_ERR, SUBMSG_JOBNAME_ERR, SUBMSG_EMOJI];
                [self profileAlert: nil errMessage: strerrMessage];
                return NO;
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
    
	profileData.profileName	= self.nameCell.nameEditableCell.textField.text;
	profileData.serchString	= self.sercCell.nameEditableCell.textField.text;
    profileData.userAuthStyle = m_nUserAuthStyle;
    if(profileData.userAuthStyle == USER_AUTH_STYLE_LOGIN)
    {
        profileData.loginName = self.loginNameCell.nameEditableCell.textField.text;
        profileData.loginPassword = self.loginPasswordCell.nameEditableCell.textField.text;
        profileData.userNo = @"";
    }
    else
    {
        profileData.loginName = @"";
        profileData.loginPassword = @"";
        profileData.userNo = self.userNoCell.nameEditableCell.textField.text;
        //認証にユーザー番号を使用する選択時でユーザー番号が未入力の場合
        if (profileData.userNo.length == 0) {
            profileData.userAuthStyle = USER_AUTH_STYLE_LOGIN;
        }
    }
    
    // ユーザー名にログイン名を使用する
    profileData.bUseLoginNameForUserName = self.useLoginNameForUserName.switchField.on;
    
    profileData.userName = self.userNameCell.nameEditableCell.textField.text;
    profileData.jobName = self.jobNameCell.nameEditableCell.textField.text;
    
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
            
            //
            // ログイン名、パスワードの暗号化
            //
            if([profileData.loginName length] > 0)
            {
                profileData.loginName = [CommonUtil base64encodeString:[CommonUtil encryptString:self.loginNameCell.nameEditableCell.textField.text withKey:S_KEY_PJL]];
            }
            if([profileData.loginPassword length] > 0)
            {
                profileData.loginPassword = [CommonUtil base64encodeString:[CommonUtil encryptString:self.loginPasswordCell.nameEditableCell.textField.text withKey:S_KEY_PJL]];
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

#pragma mark - UISwitch Action
-(IBAction)changeSwitchValue:(UISwitch*)sender
{
    switch (sender.tag) {
        case 2:
        {
            // 「ユーザー名にログイン名を使用する」スイッチ
            [self setUseLoginNameForUserNameSetting:sender.on];
        }
            break;
            
        default:
            break;
    }
}

#pragma mark -
- (void) setUseLoginNameForUserNameSetting : (BOOL) useLoginNameForUserNameSetting
{
    if(useLoginNameForUserNameSetting) {
        // ユーザー名を非活性にし、入力値を破棄する
        self.userNameCell.nameEditableCell.textField.text = @"";
        self.userNameCell.nameEditableCell.textField.enabled = NO;
    } else {
        // ユーザー名を活性にする
        self.userNameCell.nameEditableCell.textField.enabled = YES;
    }
}
@end
