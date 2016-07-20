
#import "SettingMailServerInfoViewController_iPad.h"
#import "SettingUserInfoViewController_iPad.h"
#import "Define.h"
#import "CommonUtil.h"
#import "SharpScanPrintAppDelegate.h"
#import "RootViewController_iPad.h"
#import "SettingSelInfoViewController_iPad.h"
#import "PJLDataManager.h"

@interface SettingMailServerInfoViewController_iPad ()
@property (nonatomic,strong) NSArray *getNumbers;
@property (nonatomic,strong) NSArray *filterSettings;
@end

@implementation SettingMailServerInfoViewController_iPad
@synthesize		accountNameCell;      // ログイン名
@synthesize		accountPasswordCell;  // パスワード
@synthesize		hostNameCell;       // ホスト名(または,ipアドレス)
@synthesize     imapPortNoCell;           // ポート番号
@synthesize     SSLCell;            //　SSL
@synthesize     serverConnectTestCell;
@synthesize     getNumberCell;      // 取得件数
@synthesize     filterCell;  // デフォルトのフィルタ設定

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
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

- (void)viewDidLoad
{
    [super viewDidLoad];
//    self.getNumbers = @[@"10",@"30",@"50",@"100"];
    NSString *obj0 = MAIL_SETTING_DISPLAY_TEN;
    NSString *obj1 = MAIL_SETTING_DISPLAY_THIRTY;
    NSString *obj2 = MAIL_SETTING_DISPLAY_FIFTY;
    NSString *obj3 = MAIL_SETTING_DISPLAY_HUNDRED;
    self.getNumbers = @[obj0,obj1,obj2,obj3];
    NSString *obj4 = S_TITLE_SETTING_MAILSERVER_FILTER_0;
    NSString *obj5 = S_TITLE_SETTING_MAILSERVER_FILTER_1;
    NSString *obj6 = S_TITLE_SETTING_MAILSERVER_FILTER_2;
    NSString *obj7 = S_TITLE_SETTING_MAILSERVER_FILTER_3;
    self.filterSettings = @[obj4,obj5,obj6,obj7];

    // セルのラインを表示する
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    
    //
	// ProfileDataManager クラスのインスタンス取得
	//
	manager = [[MailServerDataManager alloc]init];
    
	//
	// CommonManager クラスのインスタンス取得
	//
	commanager = [[CommonManager alloc]init];
    
    // タイトル設定
    CGRect frame = CGRectMake(0, 0, 400, 44);
    UILabel* lblTitle = [[UILabel alloc]initWithFrame:frame];
    lblTitle.backgroundColor = [UIColor clearColor];
    lblTitle.textColor = NAVIGATION_TITLE_COLOR;
    lblTitle.font = [UIFont boldSystemFontOfSize:20];
    lblTitle.textAlignment = NSTextAlignmentCenter;
    lblTitle.text = S_TITLE_SETTING_MAILSERVER;
    lblTitle.adjustsFontSizeToFitWidth = YES;
    self.navigationItem.titleView = lblTitle;
    
    // iPad用
    self.navigationItem.backBarButtonItem.title = S_BUTTON_BACK;
    
//    self.navigationItem.hidesBackButton = YES; //戻るボタン非表示
    SharpScanPrintAppDelegate* pAppDelegate = (SharpScanPrintAppDelegate*)[[UIApplication sharedApplication] delegate];
    UINavigationController* pRootNavController = [pAppDelegate.splitViewController.viewControllers objectAtIndex:0];
    if ([pRootNavController.topViewController isKindOfClass:[SettingSelInfoViewController_iPad class]])
    {
        self.navigationItem.hidesBackButton = YES; //戻るボタン非表示
    }
    {//モーダル表示されたときは戻るボタンを表示する
//        if([self.navigationController.viewControllers[0] isKindOfClass:[SettingSelInfoViewController_iPad class]])//***間違ってる
        if([pAppDelegate.splitViewController.viewControllers objectAtIndex:1] != self.navigationController)
        {
            SettingSelInfoViewController_iPad* settingSelInfoVC = (SettingSelInfoViewController_iPad*)self.navigationController.viewControllers[0];
            if(settingSelInfoVC.modalPresented)
            {
                self.navigationItem.hidesBackButton = NO; //戻るボタン表示
            }
        }
    }
    // iPad用
    
    UIBarButtonItem* btnSave = [[UIBarButtonItem alloc] initWithTitle:S_BUTTON_SAVEVAL style:UIBarButtonItemStyleDone target:self action:@selector(dosave:)];
    
    self.navigationItem.rightBarButtonItem	= btnSave;
    
    // SSLオン/オフ時のポート番号デフォルト値
    defaultPortNoSslOn = @"993";
    defaultPortNoSslOff = @"143";
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
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

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    //#warning Potentially incomplete method implementation.
    // Return the number of sections.
    return N_NUM_SECTION_N_NUM_ROW_MAILSERVERINFO;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    //#warning Incomplete method implementation.
    // Return the number of rows in the section.
	NSInteger nRet = 0;
	if(section == 0)
	{
		nRet = N_NUM_ROW_MAILSERVERINFO_SEC1;
	}
	else if(section == 1)
	{
		nRet = N_NUM_ROW_MAILSERVERINFO_SEC2;
	}
    else if(section == 2)
    {
        nRet = N_NUM_ROW_MAILSERVERINFO_SEC3;
    }
    else if(section == 3)
    {
        nRet = N_NUM_ROW_MAILSERVERINFO_SEC4;
    }

	return nRet;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    {
        //
        // 自動解放プールの作成
        //
        @autoreleasepool
        {
            @try {
                NSString *CellIdentifier = [NSString stringWithFormat:@"Cell%02ld%02ld", (long)indexPath.section, (long)indexPath.row];
                
                //
                //選択された PROFILE情報の取得
                //
                MailServerData *mailServerData = [manager loadMailServerDataAtIndex:0];
                
                // Cellがすでに作成済みの場合は初期化処理を行わずに抜ける
                ProfileDataCell *cell = (ProfileDataCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
                if (cell != nil)
                {
                    return cell;
                }
                
                //
                // 指定されたセルを返却
                //
                if (indexPath.section == 0)
                {
                    if(indexPath.row == 0)
                    {
                        return [self createAccountNameCell:tableView CellIdentifier:CellIdentifier MailServerData:mailServerData];
                    }
                    else
                    {
                        return [self createAccountPasswordCell:tableView CellIdentifier:CellIdentifier MailServerData:mailServerData];
                    }
                }
                else if(indexPath.section == 1)
                {
                    if (indexPath.row == 0)
                    {
                        return [self createServerHostNameCell:tableView CellIdentifier:CellIdentifier MailServerData:mailServerData];
                    }
                    else if (indexPath.row == 1)
                    {
                        return [self createServerPortNoCell:tableView CellIdentifier:CellIdentifier MailServerData:mailServerData];
                    }
                    else
                    {
                        return [self createServerSslCell:tableView CellIdentifier:CellIdentifier MailServerData:mailServerData];
                    }
                }
                else if(indexPath.section == 2)
                {
                    return [self createServerConnectTestCell:tableView CellIdentifier:CellIdentifier MailServerData:mailServerData];
                }
                else if (indexPath.section == 3)
                {
                    if (indexPath.row == 0)
                    {
                        return [self createDisplayNumberCell:tableView CellIdentifier:CellIdentifier MailServerData:mailServerData];
                    }
                    else if (indexPath.row == 1)
                    {
                        return [self createDisplayFilterCell:tableView CellIdentifier:CellIdentifier MailServerData:mailServerData];
                    }
                }
            }
            @finally
            {
            }
        }
        return nil; //ビルド警告回避用
    }
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
 [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
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
    switch (indexPath.section) {
        case 2:
            switch (indexPath.row) {
                case 0:
                    DLog(@"ボタン押下");
                    [self checkServerConnection];
                    break;
                default:
                    break;
            }
            break;
            
        default:
            break;
    }
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark - セル作成処理
- (UITableViewCell*)createAccountNameCell:(UITableView*) tableView
                           CellIdentifier:(NSString*)CellIdentifier
                           MailServerData:(MailServerData*)mailServerData
{
    // ********************
    // メールアカウント名
    // ********************
    self.accountNameCell = (ProfileDataCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (self.accountNameCell == nil)
    {
        self.accountNameCell = [[ProfileDataCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    NSString *decryptLoginName = mailServerData.accountName;
    if([decryptLoginName length] > 0)
    {
        decryptLoginName = [CommonUtil decryptString:[CommonUtil base64Decoding:mailServerData.accountName] withKey:S_KEY_PJL];
    }
    self.accountNameCell.nameEditableCell.textField.delegate = self;
    self.accountNameCell.nameLabelCell.text				= S_SETTING_MAILSERVER_ACCOUNT_NAME;
    self.accountNameCell.nameEditableCell.textField.text	= decryptLoginName;
    self.accountNameCell.nameEditableCell.textField.tag	= 3;
    //self.accountNameCell.nameEditableCell.textField.keyboardAppearance = UIKeyboardAppearanceAlert;
    self.accountNameCell.nameEditableCell.textField.keyboardAppearance = UIKeyboardAppearanceLight;
    
    if(![S_LANG isEqualToString:S_LANG_EN]){
        // 自動調整サイズを取得
        CGFloat actualFontSize;
        [self.accountNameCell.nameLabelCell.text
         sizeWithFont:self.accountNameCell.nameLabelCell.font
         minFontSize:(self.accountNameCell.nameLabelCell.minimumScaleFactor * self.accountNameCell.nameLabelCell.font.pointSize)
         actualFontSize:&actualFontSize
         forWidth:self.accountNameCell.nameLabelCell.bounds.size.width
         lineBreakMode:self.accountNameCell.nameLabelCell.lineBreakMode];
        
        // 自動調整したフォントサイズが10以下なら、二段表示するか判定を行う
        if(actualFontSize < 11)
        {
            int iFontSize = [self.accountNameCell changeFontSize:self.accountNameCell.nameLabelCell.text];
            if (iFontSize != -1)
            {
                self.accountNameCell.nameLabelCell.lineBreakMode = NSLineBreakByWordWrapping;
                self.accountNameCell.nameLabelCell.numberOfLines = 2;
                [self.accountNameCell.nameLabelCell setFont:[UIFont systemFontOfSize:iFontSize]];
                // サイズ調整
                CGRect frame =  self.accountNameCell.nameLabelCell.frame;
                frame.size.height = 36;
                self.accountNameCell.nameLabelCell.frame = frame;
            }
            
        }
    } else {
        self.accountNameCell.nameLabelCell.lineBreakMode = NSLineBreakByWordWrapping;
        self.accountNameCell.nameLabelCell.numberOfLines = 2;
        // サイズ調整
        CGRect frame =  self.accountNameCell.nameLabelCell.frame;
        frame.size.height = 36;
        self.accountNameCell.nameLabelCell.frame = frame;
    }
    
    return self.accountNameCell;
}

- (UITableViewCell*)createAccountPasswordCell:(UITableView*) tableView
                               CellIdentifier:(NSString*)CellIdentifier
                               MailServerData:(MailServerData*)mailServerData
{
    // ********************
    // メールアカウントパスワード
    // ********************
    self.accountPasswordCell = (ProfileDataCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (self.accountPasswordCell == nil)
    {
        self.accountPasswordCell = [[ProfileDataCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    NSString *decryptLoginPassword = mailServerData.accountPassword;
    if([decryptLoginPassword length] > 0)
    {
        decryptLoginPassword = [CommonUtil decryptString:[CommonUtil base64Decoding:mailServerData.accountPassword] withKey:S_KEY_PJL];
    }
    self.accountPasswordCell.nameEditableCell.textField.delegate = self;
    self.accountPasswordCell.nameLabelCell.text				= S_SETTING_MAILSERVER_PASSWORD;
    self.accountPasswordCell.nameEditableCell.textField.text	= decryptLoginPassword;
    self.accountPasswordCell.nameEditableCell.textField.secureTextEntry = YES;
    self.accountPasswordCell.nameEditableCell.textField.tag	= 4;
    //self.accountPasswordCell.nameEditableCell.textField.keyboardAppearance = UIKeyboardAppearanceAlert;
    self.accountPasswordCell.nameEditableCell.textField.keyboardAppearance = UIKeyboardAppearanceLight;
    
    if(![S_LANG isEqualToString:S_LANG_EN]){
        // 自動調整サイズを取得
        CGFloat actualFontSize;
        [self.accountPasswordCell.nameLabelCell.text
         sizeWithFont:self.accountPasswordCell.nameLabelCell.font
         minFontSize:(self.accountPasswordCell.nameLabelCell.minimumScaleFactor * self.accountPasswordCell.nameLabelCell.font.pointSize)
         actualFontSize:&actualFontSize
         forWidth:self.accountPasswordCell.nameLabelCell.bounds.size.width
         lineBreakMode:self.accountPasswordCell.nameLabelCell.lineBreakMode];
        
        // 自動調整したフォントサイズが10以下なら、二段表示するか判定を行う
        if(actualFontSize < 11)
        {
            int iFontSize = [self.accountPasswordCell changeFontSize:self.accountPasswordCell.nameLabelCell.text];
            if (iFontSize != -1)
            {
                self.accountPasswordCell.nameLabelCell.lineBreakMode = NSLineBreakByWordWrapping;
                self.accountPasswordCell.nameLabelCell.numberOfLines = 2;
                [self.accountPasswordCell.nameLabelCell setFont:[UIFont systemFontOfSize:iFontSize]];
                // サイズ調整
                CGRect frame =  self.accountPasswordCell.nameLabelCell.frame;
                frame.size.height = 36;
                self.accountPasswordCell.nameLabelCell.frame = frame;
            }
            
        }
    } else {
        self.accountPasswordCell.nameLabelCell.lineBreakMode = NSLineBreakByWordWrapping;
        self.accountPasswordCell.nameLabelCell.numberOfLines = 2;
        // サイズ調整
        CGRect frame =  self.accountPasswordCell.nameLabelCell.frame;
        frame.size.height = 36;
        self.accountPasswordCell.nameLabelCell.frame = frame;
    }
    
    return self.accountPasswordCell;
}

- (UITableViewCell*)createServerHostNameCell:(UITableView*) tableView
                              CellIdentifier:(NSString*)CellIdentifier
                              MailServerData:(MailServerData*)mailServerData
{
    // ********************
    //  メールサーバー名
    // ********************
    self.hostNameCell = (ProfileDataCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (self.hostNameCell == nil)
    {
        self.hostNameCell = [[ProfileDataCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    self.hostNameCell.nameEditableCell.textField.delegate = self;
    self.hostNameCell.nameLabelCell.text				= S_SETTING_MAILSERVER_HOST_NAME;
    self.hostNameCell.nameEditableCell.textField.text	= mailServerData.hostname;
    self.hostNameCell.nameEditableCell.textField.tag	= 0;
    //self.hostNameCell.nameEditableCell.textField.keyboardAppearance = UIKeyboardAppearanceAlert;
    self.hostNameCell.nameEditableCell.textField.keyboardAppearance = UIKeyboardAppearanceLight;
    
    if(![S_LANG isEqualToString:S_LANG_EN]){
        // 自動調整サイズを取得
        CGFloat actualFontSize;
        [self.hostNameCell.nameLabelCell.text
         sizeWithFont:self.hostNameCell.nameLabelCell.font
         minFontSize:(self.hostNameCell.nameLabelCell.minimumScaleFactor * self.hostNameCell.nameLabelCell.font.pointSize)
         actualFontSize:&actualFontSize
         forWidth:self.hostNameCell.nameLabelCell.bounds.size.width
         lineBreakMode:self.hostNameCell.nameLabelCell.lineBreakMode];
        
        // 自動調整したフォントサイズが10以下なら、二段表示するか判定を行う
        if(actualFontSize < 11)
        {
            int iFontSize = [self.hostNameCell changeFontSize:self.hostNameCell.nameLabelCell.text];
            if (iFontSize != -1)
            {
                self.hostNameCell.nameLabelCell.lineBreakMode = NSLineBreakByWordWrapping;
                self.hostNameCell.nameLabelCell.numberOfLines = 2;
                [self.hostNameCell.nameLabelCell setFont:[UIFont systemFontOfSize:iFontSize]];
                // サイズ調整
                CGRect frame =  self.hostNameCell.nameLabelCell.frame;
                frame.size.height = 36;
                self.hostNameCell.nameLabelCell.frame = frame;
            }
            
        }
    } else {
        self.hostNameCell.nameLabelCell.lineBreakMode = NSLineBreakByWordWrapping;
        self.hostNameCell.nameLabelCell.numberOfLines = 2;
        // サイズ調整
        CGRect frame =  self.hostNameCell.nameLabelCell.frame;
        frame.size.height = 36;
        self.hostNameCell.nameLabelCell.frame = frame;
    }
    
    return self.hostNameCell;
}

- (UITableViewCell*)createServerPortNoCell:(UITableView*) tableView
                            CellIdentifier:(NSString*)CellIdentifier
                            MailServerData:(MailServerData*)mailServerData
{
    // ********************
    // imap ポート番号
    // ********************
    self.imapPortNoCell = (ProfileDataCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (self.imapPortNoCell == nil)
    {
        self.imapPortNoCell = [[ProfileDataCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    self.imapPortNoCell.nameEditableCell.textField.delegate = self;
    self.imapPortNoCell.nameLabelCell.text				= S_SETTING_MAILSERVER_PORT_NUMBER;
    if ([mailServerData.imapPortNo length] > 0) {
        self.imapPortNoCell.nameEditableCell.textField.text	= mailServerData.imapPortNo;
    }else{
        if (mailServerData.bSSL == YES) {
            self.imapPortNoCell.nameEditableCell.textField.text	= defaultPortNoSslOn;
        }else{
            self.imapPortNoCell.nameEditableCell.textField.text	= defaultPortNoSslOff;
        }
    }
    self.imapPortNoCell.nameEditableCell.textField.tag	= 1;
    //self.imapPortNoCell.nameEditableCell.textField.keyboardAppearance = UIKeyboardAppearanceAlert;
    self.imapPortNoCell.nameEditableCell.textField.keyboardAppearance = UIKeyboardAppearanceLight;
    self.imapPortNoCell.nameEditableCell.textField.keyboardType = UIKeyboardTypeNumbersAndPunctuation;
    
    if(![S_LANG isEqualToString:S_LANG_EN]){
        // 自動調整サイズを取得
        CGFloat actualFontSize;
        [self.imapPortNoCell.nameLabelCell.text
         sizeWithFont:self.imapPortNoCell.nameLabelCell.font
         minFontSize:(self.imapPortNoCell.nameLabelCell.minimumScaleFactor * self.imapPortNoCell.nameLabelCell.font.pointSize)
         actualFontSize:&actualFontSize
         forWidth:self.imapPortNoCell.nameLabelCell.bounds.size.width
         lineBreakMode:self.imapPortNoCell.nameLabelCell.lineBreakMode];
        
        // 自動調整したフォントサイズが10以下なら、二段表示するか判定を行う
        if(actualFontSize < 11)
        {
            int iFontSize = [self.imapPortNoCell changeFontSize:self.imapPortNoCell.nameLabelCell.text];
            if (iFontSize != -1)
            {
                self.imapPortNoCell.nameLabelCell.lineBreakMode = NSLineBreakByWordWrapping;
                self.imapPortNoCell.nameLabelCell.numberOfLines = 2;
                [self.imapPortNoCell.nameLabelCell setFont:[UIFont systemFontOfSize:iFontSize]];
                // サイズ調整
                CGRect frame =  self.imapPortNoCell.nameLabelCell.frame;
                frame.size.height = 36;
                self.imapPortNoCell.nameLabelCell.frame = frame;
            }
            
        }
    } else {
        self.imapPortNoCell.nameLabelCell.lineBreakMode = NSLineBreakByWordWrapping;
        self.imapPortNoCell.nameLabelCell.numberOfLines = 2;
        // サイズ調整
        CGRect frame =  self.imapPortNoCell.nameLabelCell.frame;
        frame.size.height = 36;
        self.imapPortNoCell.nameLabelCell.frame = frame;
    }
    
    return self.imapPortNoCell;
}

- (UITableViewCell*)createServerSslCell:(UITableView*) tableView
                         CellIdentifier:(NSString*)CellIdentifier
                         MailServerData:(MailServerData*)mailServerData
{
    // ********************
    //　SSL状態
    // ********************
    self.SSLCell = (SwitchDataCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (self.SSLCell == nil)
    {
        self.SSLCell = [[SwitchDataCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    self.SSLCell.nameLabelCell.text		= S_SETTING_MAILSERVER_SSL;
    self.SSLCell.switchField.on			= mailServerData.bSSL;
    self.SSLCell.switchField.tag		= 2;
    [self.SSLCell.switchField addTarget:self action:@selector(changeSwitchValue:) forControlEvents:UIControlEventValueChanged];
    
    if(![S_LANG isEqualToString:S_LANG_EN]){
        // 自動調整サイズを取得
        CGFloat actualFontSize;
        [self.SSLCell.nameLabelCell.text
         sizeWithFont:self.SSLCell.nameLabelCell.font
         minFontSize:(self.SSLCell.nameLabelCell.minimumScaleFactor * self.SSLCell.nameLabelCell.font.pointSize)
         actualFontSize:&actualFontSize
         forWidth:self.SSLCell.nameLabelCell.bounds.size.width
         lineBreakMode:self.SSLCell.nameLabelCell.lineBreakMode];
        
        // 自動調整したフォントサイズが10以下なら、二段表示するか判定を行う
        if(actualFontSize < 11)
        {
            int iFontSize = [self.SSLCell changeFontSize:self.SSLCell.nameLabelCell.text];
            if (iFontSize != -1)
            {
                self.SSLCell.nameLabelCell.lineBreakMode = NSLineBreakByWordWrapping;
                self.SSLCell.nameLabelCell.numberOfLines = 2;
                [self.SSLCell.nameLabelCell setFont:[UIFont systemFontOfSize:iFontSize]];
                // サイズ調整
                CGRect frame =  self.SSLCell.nameLabelCell.frame;
                frame.size.height = 36;
                self.SSLCell.nameLabelCell.frame = frame;
            }
        }
    } else {
        self.SSLCell.nameLabelCell.lineBreakMode = NSLineBreakByWordWrapping;
        self.SSLCell.nameLabelCell.numberOfLines = 2;
        // サイズ調整
        CGRect frame =  self.SSLCell.nameLabelCell.frame;
        frame.size.height = 36;
        self.SSLCell.nameLabelCell.frame = frame;
    }
    return self.SSLCell;
}

- (UITableViewCell*)createServerConnectTestCell:(UITableView*) tableView
                                 CellIdentifier:(NSString*)CellIdentifier
                                 MailServerData:(MailServerData*)mailServerData
{
    // セルの作成
    self.serverConnectTestCell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    [self.serverConnectTestCell.textLabel setFont:[UIFont systemFontOfSize:14]];
    [self.serverConnectTestCell.textLabel setAdjustsFontSizeToFitWidth:TRUE];
    self.serverConnectTestCell.textLabel.textAlignment = NSTextAlignmentCenter;
    self.serverConnectTestCell.textLabel.text = S_SETTING_MAILSERVER_CONNECT_TEST;
    self.serverConnectTestCell.textLabel.textColor = self.navigationController.navigationBar.tintColor;
    
    self.serverConnectTestCell.textLabel.lineBreakMode = NSLineBreakByWordWrapping;
    self.serverConnectTestCell.textLabel.numberOfLines = 2;
    // サイズ調整
    CGRect frame =  self.serverConnectTestCell.textLabel.frame;
    frame.size.height = 36;
    self.serverConnectTestCell.textLabel.frame = frame;
    
    return self.serverConnectTestCell;
}

- (UITableViewCell*)createDisplayNumberCell:(UITableView*) tableView
                             CellIdentifier:(NSString*)CellIdentifier
                             MailServerData:(MailServerData*)mailServerData
{
    self.getNumberCell = (ProfileDataCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (self.getNumberCell == nil) {
        self.getNumberCell = [[ProfileDataCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    self.getNumberCell.nameLabelCell.text = S_SETTING_MAILSERVER_GET_NUMBER;
    self.getNumberCell.accessoryType = TABLE_CELL_ACCESSORY;
    self.getNumberCell.nameEditableCell.textField.text = mailServerData.getNumber;
    self.getNumberCell.nameEditableCell.textField.tag = 90;
    self.getNumberCell.nameEditableCell.textField.delegate = self;
    self.getNumIndex = mailServerData.getNumber.integerValue;
    return self.getNumberCell;
}

- (UITableViewCell*)createDisplayFilterCell:(UITableView*) tableView
                             CellIdentifier:(NSString*)CellIdentifier
                             MailServerData:(MailServerData*)mailServerData
{
    self.filterCell = (ProfileDataCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (self.filterCell == nil) {
        self.filterCell = [[ProfileDataCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    self.filterCell.nameLabelCell.text = S_SETTING_MAILSERVER_FILTER_SETTING;
    DLog(@"%@",self.filterSettings);
    DLog(@"%@",mailServerData.filterSetting);
    
    //mailServerData.filterSetting に不正な値が入っていれば0を入れておく
    if(mailServerData.filterSetting.intValue < 0
       ||
       self.filterSettings.count-1 < mailServerData.filterSetting.intValue)
    {
        mailServerData.filterSetting = @0;
        DLog(@"%@",mailServerData.filterSetting);
    }
    self.filterCell.accessoryType = TABLE_CELL_ACCESSORY;
    //self.filterCell.nameEditableCell.textField.text = self.filterSettings[0];
    self.filterCell.nameEditableCell.textField.text = self.filterSettings[mailServerData.filterSetting.intValue];
    self.filterCell.nameEditableCell.textField.tag = 91;
    self.filterCell.nameEditableCell.textField.delegate = self;
    self.filterIndex = mailServerData.filterSetting.integerValue;
    
    return self.filterCell;
}

//
//
// 入力チェック
//
- (BOOL)mailServerChk:(MailServerData *)pData
           allowBlank:(BOOL)allowBlank
{
    if(allowBlank){
        if((pData.accountName == nil || [pData.accountName isEqualToString:@""]) &&
           (pData.accountPassword == nil || [pData.accountPassword isEqualToString:@""]) &&
           (pData.hostname == nil || [pData.hostname isEqualToString:@""]) &&
           (pData.imapPortNo == nil || [pData.imapPortNo isEqualToString:@""]))
        {
            // 入力項目がすべて未入力ならエラーとしない
            return YES;
        }
    }
    
	//
	// 自動解放プールの作成
	//
    @autoreleasepool
    {
        @try {
            NSString	*strerrMessage;
            BOOL		rtn;
            int         len;
            
            // アカウント名
            // (半角255文字、全角127文字以内)
            len = [CommonUtil strLength:[pData.accountName stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]]];
            if (255 < len)
            {
                strerrMessage = [NSString stringWithFormat:MSG_LENGTH_ERR, SUBMSG_ACCOUNTNAME_ERR, SUBMSG_LOGINNAME_FORMAT];
                [self profileAlert:nil errMessage:strerrMessage];
                return NO;
            }
            
            // 絵文字入力チェック
            if ( [CommonUtil IsUsedEmoji: pData.accountName] ) {
                strerrMessage = [[NSString alloc] initWithFormat: MSG_FORMAT_ERR, SUBMSG_ACCOUNTNAME_ERR, SUBMSG_EMOJI];
                [self profileAlert: nil errMessage: strerrMessage];
                return NO;
            }
            
            // パスワード
            // (半角文字)
            NSUInteger len2;
            len2 = [[pData.accountPassword stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] length];
            if(len == 0 && len2 > 0)
            {
                strerrMessage = [NSString stringWithFormat:MSG_REQUIRED_ERR, SUBMSG_ACCOUNTNAME_ERR];
                [self profileAlert:nil errMessage:strerrMessage];
                return NO;
            }
            
            if (32 < len2)
            {
                strerrMessage = [NSString stringWithFormat:MSG_LENGTH_ERR, S_RETENTION_PASSWORD, SUBMSG_PDFPASSWORD_MAXLENGTH];
                [self profileAlert:nil errMessage:strerrMessage];
                return NO;
            }
            
            if ([CommonUtil isZen:pData.accountPassword])
            {
                strerrMessage = [NSString stringWithFormat:MSG_FORMAT_ERR, SUBMSG_LOGINPASSWORD_ERR, SUBMSG_LOGINPASSWORD_FORMAT];
                [self profileAlert:nil errMessage:strerrMessage];
                return NO;
            }
            
            // ホスト名
            len = [CommonUtil strLength:[pData.hostname stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]]];
            if (len <= 0)
            {
                strerrMessage = [NSString stringWithFormat:MSG_REQUIRED_ERR, [NSString stringWithFormat: SUBMSG_HOSTNAME_ERR]];
                [self profileAlert:nil errMessage:strerrMessage];
                return NO;
                
            }
            else
            {
#ifdef IPV6_VALID
                if (len > 255)
                {
                    strerrMessage	= [[NSString alloc]initWithFormat:MSG_LENGTH_ERR,SUBMSG_HOSTNAME_ERR,SUBMSG_HOSTNAME_LEN_ERR];
                    [self profileAlert:nil errMessage:strerrMessage];
                    return NO;
                }
                
                // 半角英数記号チェック
                if (![CommonUtil isAplhaNumericSymbol:pData.hostname]) {
                    strerrMessage = [NSString stringWithFormat:MSG_CHAR_TYPE_ERR, SUBMSG_HOSTNAME_ERR, SUBMSG_HOSTNAME_LEN_ERR];
                    [self profileAlert: nil errMessage: strerrMessage];
                    return NO;
                }
#else
                if (len > 36)
                {
                    strerrMessage	= [[NSString alloc]initWithFormat:MSG_LENGTH_ERR,SUBMSG_HOSTNAME_ERR,SUBMSG_NAME_FORMAT];
                    [self profileAlert:nil errMessage:strerrMessage];
                    return NO;
                }
                // 絵文字入力チェック
                if ( [CommonUtil IsUsedEmoji: pData.hostname] ) {
                    strerrMessage = [[NSString alloc] initWithFormat: MSG_FORMAT_ERR, SUBMSG_HOSTNAME_ERR, SUBMSG_EMOJI];
                    [self profileAlert: nil errMessage: strerrMessage];
                    return NO;
                }
#endif
                rtn = [CommonUtil charCheck:pData.accountName];
            }
            
            // port番号
            // (整数);
            NSInteger nRet = ERR_SUCCESS;
            nRet = [CommonUtil IsPortNo:pData.imapPortNo];
            if(nRet != ERR_SUCCESS)
            {
                switch (nRet)
                {
                    case ERR_NO_INPUT:	// 未入力
                        strerrMessage = [NSString stringWithFormat:MSG_REQUIRED_ERR, SUBMSG_PORT_ERR];
                        break;
                    case ERR_INVALID_CHAR_TYPE:	// 文字種不正
                        strerrMessage = [NSString stringWithFormat:MSG_CHAR_TYPE_ERR, SUBMSG_PORT_ERR, SUBMSG_ONLY_HALFCHAR_NUMBER];
                        break;
                    case ERR_OVER_NUM_RANGE:	// 数値範囲外
                        strerrMessage = [NSString stringWithFormat:MSG_NUM_RANGE_ERR, SUBMSG_PORT_ERR, SUBMSG_PORTNO_RANGE];
                        break;
                    default:
                        break;
                }
                [self profileAlert:nil errMessage:strerrMessage];
                return NO;
            }
            
            
            return YES;
        }
        @finally
        {
        }
    }
    return YES;
}


//
// アラート表示
//
-(void)mailServerAlert:(NSString *)errTitle errMessage:(NSString *)errMessage
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
	[super viewDidLoad];
    
}

-(MailServerData*)setMailServerDataFromInput:(MailServerData*)mailServerData
{
    mailServerData.hostname	= self.hostNameCell.nameEditableCell.textField.text;
    mailServerData.imapPortNo = self.imapPortNoCell.nameEditableCell.textField.text;
    mailServerData.accountName = self.accountNameCell.nameEditableCell.textField.text;
    mailServerData.accountPassword = self.accountPasswordCell.nameEditableCell.textField.text;
    mailServerData.getNumber = self.getNumberCell.nameEditableCell.textField.text;
    mailServerData.filterSetting = @([self.filterSettings indexOfObject:self.filterCell.nameEditableCell.textField.text]);
    DLog(@"%@",mailServerData.filterSetting);
    
    return mailServerData;
}


//
// 保存ボタン処理
//
-(IBAction)dosave:(id)sender
{
    //
    //PROFILE情報を設定ファイルから取得
    //
    MailServerData *mailServerData = [manager loadMailServerDataAtIndex:0];
    
    [self setMailServerDataFromInput:mailServerData];
	
    //
	// 自動解放プールの作成
	//
    @autoreleasepool
    {
        @try {
            //
            // 入力チェック
            //
            if ([self mailServerChk: mailServerData allowBlank:YES] != YES)
            {
                // エラー時
                return;
            }
            
            
            //
            // ログイン名、パスワードの暗号化
            //
            
            if([mailServerData.accountName length] > 0)
            {
                mailServerData.accountName = [CommonUtil base64encodeString:[CommonUtil encryptString:self.accountNameCell.nameEditableCell.textField.text withKey:S_KEY_PJL]];
            }
            if([mailServerData.accountPassword length] > 0)
            {
                mailServerData.accountPassword = [CommonUtil base64encodeString:[CommonUtil encryptString:self.accountPasswordCell.nameEditableCell.textField.text withKey:S_KEY_PJL]];
            }
            //
            // クラス値の変更
            //
            [manager replaceMailServerDataAtIndex:0 newObject:mailServerData];
            
            //
            // 保存
            //
            if(![manager saveMailServerData])
            {
                [self mailServerAlert: @"" errMessage: MSG_REG_USER_PROFILE_ERR];  //////^^
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

// 各セルの高さを設定
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return N_HEIGHT_SEL_DEFAULT;
}

//
// 各セクションのタイトルを決定する
//
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    NSString *title = @"";
    switch (section) {
        case 0:
            title = S_TITLE_SETTING_MAILSERVER_ACCOUNT;
            break;
        case 1:
            title = S_TITLE_SETTING_MAILSERVER_SETTING;
            break;
        case 3:
            title = S_TITLE_SETTING_MAILSERVER_DISPLAY;
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

// 各セクションのフッターをカスタマイズする場合
- (UIView *) tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView* returnView = nil;
    
    if(section == 1){
        // ビューを作成
        returnView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, tableView.bounds.size.width, 40)];
        
        // タイトルラベル作成
        UILabel* titleLbl = [[UILabel alloc]initWithFrame:CGRectMake(60, 0, tableView.bounds.size.width - 20, 20)];
        [titleLbl setNumberOfLines:1];
        [titleLbl setBackgroundColor:[UIColor clearColor]];
        [titleLbl setTextColor:[UIColor colorWithRed:0.29f green:0.34f blue:0.43f alpha:1.00f]];
        [titleLbl setShadowColor:[UIColor whiteColor]];
        [titleLbl setShadowOffset:CGSizeMake(0, 1)];
        [titleLbl setText:S_TITLE_SETTING_EMAIL_SERVER_IMAP];
        
        // フォントサイズを調整
        [titleLbl setFont:[UIFont boldSystemFontOfSize:12.0]];
        
        [returnView addSubview:titleLbl];
    }
    
    return returnView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    if (section == 1) {
        return 24.0f;
    }
    return 12.0f;
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

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    if (textField.tag == 90) {
        DLog(@"90");
        SettingSelMailDisplaySettingTableViewController *vc = [[SettingSelMailDisplaySettingTableViewController alloc]initWithStyle:UITableViewStyleGrouped];
        vc.selectedType = 90;
        vc.selectedIndex = [self.getNumbers indexOfObject:textField.text];
        vc.dataArray = self.getNumbers;
        vc.delegate = self;
        [self.navigationController pushViewController:vc animated:YES];
        return NO;
    } else if (textField.tag == 91) {
        DLog(@"91");
        SettingSelMailDisplaySettingTableViewController *vc = [[SettingSelMailDisplaySettingTableViewController alloc]initWithStyle:UITableViewStyleGrouped];
        vc.selectedType = 91;
        vc.selectedIndex = [self.filterSettings indexOfObject:textField.text];
        vc.dataArray = self.filterSettings;
        vc.delegate = self;
        [self.navigationController pushViewController:vc animated:YES];
        return NO;
    } else {
        return YES;
    }
}

- (void)callBackIndex:(SettingSelMailDisplaySettingTableViewController *)vc {
    if (vc.selectedType == 90) {
        self.getNumberCell.nameEditableCell.textField.text = self.getNumbers[vc.selectedIndex];
        self.getNumIndex = vc.selectedIndex;
    } else if (vc.selectedType == 91) {
        self.filterCell.nameEditableCell.textField.text = self.filterSettings[vc.selectedIndex];
        self.filterIndex = vc.selectedIndex;
    }
}

// 処理実行フラグをOFFにする
- (void)appDelegateIsRunOff {
    // ボタンタップ時の処理
    SharpScanPrintAppDelegate* appDelegate = (SharpScanPrintAppDelegate*)[[UIApplication sharedApplication] delegate];
    // 処理実行フラグOFF
    appDelegate.IsRun = FALSE;
}

//
-(IBAction)changeSwitchValue:(UISwitch*)sender
{
    switch (sender.tag) {
            // 確認コードの自動生成のスイッチ変更時の処理
        case 2:
        {
            MailServerData *mailServerData = [manager loadMailServerDataAtIndex:0];
            mailServerData.bSSL = sender.on;
            
            if (mailServerData.bSSL == YES) {
                self.imapPortNoCell.nameEditableCell.textField.text	= defaultPortNoSslOn;
            }else{
                self.imapPortNoCell.nameEditableCell.textField.text	= defaultPortNoSslOff;
            }
            break;
        }
        default:
            return;
            break;
    }
}
//

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
	[super viewDidLoad];
    
}

#pragma mark - メールサーバー接続テスト

-(void) checkServerConnection
{
    MailServerData* mailServerData = [manager loadMailServerDataAtIndex:0];
    
    [self setMailServerDataFromInput:mailServerData];
    
    // エラー時はエラーメッセージも出す
    BOOL isValidInput = [self mailServerChk:mailServerData allowBlank:NO];
    if(!isValidInput) {
        return;
    }
    
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil
                                                                             message:MSG_WAIT
                                                                      preferredStyle:UIAlertControllerStyleAlert];
    [self presentViewController:alertController animated:YES completion:nil];
    
    // 通信処理があるので別スレッド化
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{

        // 1秒待つ
        [NSThread sleepForTimeInterval:1];
        
        // 接続確認
        BOOL result = [self connectServer:mailServerData];

        dispatch_sync(dispatch_get_main_queue(), ^{
            // アラートを閉じる
            [alertController dismissViewControllerAnimated:YES completion:^{
                if(result) {
                    [self profileAlert:nil errMessage:MSG_SERVER_CONNECT_SUCCESS];
                } else {
                    [self profileAlert:nil errMessage:MSG_SERVER_CONNECT_FAILED];
                }
            }];
        });
    });
}

-(BOOL) connectServer:(MailServerData*)mailServerData
{
    CTCoreAccount* anAccount = [[CTCoreAccount alloc] init];
    NSDictionary *dicIPAddr = [CommonUtil getIPAddrDicForComm:mailServerData.hostname port:mailServerData.imapPortNo];
    NSString *strIPaddr = [dicIPAddr objectForKey:S_TARGET_IPADDRESS_DIC_KEY];
#ifdef IPV6_VALID
    if ([CommonUtil isValidIPv6StringFormat:strIPaddr]) {
        // IPv6アドレスの場合は非省略形式にする
        strIPaddr = [CommonUtil convertOmitIPv6ToFullIPv6:strIPaddr];
    }
#endif
    if ([strIPaddr length] < 1) {
        return NO;
    }
    BOOL result = [anAccount connectToServer: strIPaddr
                                        port: [mailServerData.imapPortNo intValue]
                              connectionType: (mailServerData.bSSL)?CONNECTION_TYPE_TLS:CONNECTION_TYPE_PLAIN
                                    authType: IMAP_AUTH_TYPE_PLAIN
                                       login: mailServerData.accountName
                                    password: mailServerData.accountPassword];
    if(result) {
        [anAccount disconnect];
    }
    return result;
}

@end
