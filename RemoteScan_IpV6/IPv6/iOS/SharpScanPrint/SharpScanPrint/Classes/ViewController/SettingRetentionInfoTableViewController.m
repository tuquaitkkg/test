
#import "SettingRetentionInfoTableViewController.h"
#import "Define.h"
#import "CommonUtil.h"
#import "SharpScanPrintAppDelegate.h"

#define RegularCell_HEIGHT 44

@interface SettingRetentionInfoTableViewController ()

@end

@implementation SettingRetentionInfoTableViewController
//
// アクセサメソッドの自動合成(ゲッターとセッターの役割)
//
@synthesize     noPrintCell;            // 印刷せずにホールド
@synthesize     retentionAuthCell;      // 認証(リテンション)
@synthesize     retentionPasswordCell;  // パスワード(リテンション)
@synthesize     noPrintOn;              // 印刷せずにホールド
@synthesize     authenticateOn;         // 認証
@synthesize     pstrPassword;           // パスワード

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // セルのラインを表示する
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    
    if (isIOS9Later) {
        // iOS9(+ Xcode7以降)- デフォルトレイアウト設定のUITableViewの両端の余白を出さないようにする。
        self.tableView.cellLayoutMarginsFollowReadableWidth = NO;
    }
    
    //
    // ProfileDataManager クラスのインスタンス取得
    //
    manager = [[ProfileDataManager alloc]init];
    
    //
    // CommonManager クラスのインスタンス取得
    //
    commanager = [[CommonManager alloc]init];
    
    
    // ナビゲーションバー
    // タイトル設定
    self.navigationItem.title = S_TITLE_RETENTION;
    
    // 戻るボタンの名称変更
    UIBarButtonItem * barItemBack = [UIBarButtonItem new];
    barItemBack.title = S_BUTTON_BACK;
    self.navigationItem.backBarButtonItem = barItemBack;
    
    UIBarButtonItem* btnSave = [[UIBarButtonItem alloc] initWithTitle:S_BUTTON_SAVEVAL style:UIBarButtonItemStyleDone target:self action:@selector(dosave:)];
    
    // 保存ボタン
    self.navigationItem.rightBarButtonItem  = btnSave;
    
    //初期値設定
    ProfileData *profileData = [manager loadProfileDataAtIndex:0];
    noPrintOn = profileData.noPrint;
    authenticateOn = profileData.retentionAuth;
    pstrPassword = profileData.retentionPassword;
    
    switch ((Boolean)noPrintOn) {
        case YES:
            switch ((Boolean)authenticateOn) {
                case YES:
                    break;
                    
                case NO:
                    pstrPassword = @"";
                    break;
                    
                default:
                    break;
            }
            break;
            
        case NO:
            authenticateOn = NO;
            pstrPassword = @"";
            break;
            
        default:
            break;
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

- (void)viewDidUnload
{
    [super viewDidUnload];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

// iPad用
- (void)popRootView
{
    [self.navigationController popToRootViewControllerAnimated:YES];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSInteger nRet = 0;
    // リテンション設定
    if(!noPrintOn)
    {
        nRet = N_NUM_ROW_RETENTION_INFO_SECTION - 2;
    }else{
        if(authenticateOn)
        {
            nRet = N_NUM_ROW_RETENTION_INFO_SECTION;
        }else{
            nRet = N_NUM_ROW_RETENTION_INFO_SECTION - 1;
        }
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
            // リテンション設定
            if (indexPath.section == 0){
                return [self getRetentionSection:tableView cellForRowAtIndexPath:indexPath];
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
    return RegularCell_HEIGHT;
}

// リテンション設定
- (UITableViewCell *)getRetentionSection:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    // 印刷せずにホールド
    if(indexPath.row == RETENTION_INFO_SECTION_NO_PRINT_HOLD) {
        return [self getRetentionNoPrintHold:tableView cellForRowAtIndexPath:indexPath];

    // パスワードを指定
    } else if(indexPath.row == RETENTION_INFO_SECTION_AUTH_ON) {
        return [self getRetentionAuthOn:tableView cellForRowAtIndexPath:indexPath];

    // パスワード
    } else if(indexPath.row == RETENTION_INFO_SECTION_PASSWORD) {
        return [self getRetentionPassword:tableView cellForRowAtIndexPath:indexPath];

    } else {
        return nil; //ビルド警告回避用
    }
}

// 印刷せずにホールド
- (UITableViewCell *)getRetentionNoPrintHold:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
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
    // 印刷せずにホールド
    // ********************
    self.noPrintCell = (SwitchDataCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (self.noPrintCell == nil)
    {
        self.noPrintCell = [[SwitchDataCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    self.noPrintCell.nameLabelCell.text		= S_RETENTION_NOPRINT;
    self.noPrintCell.switchField.on			= profileData.noPrint;
    self.noPrintCell.switchField.tag		= 0;
    [self.noPrintCell.switchField addTarget:self action:@selector(changeRetentionSwitchValue:) forControlEvents:UIControlEventValueChanged];

    if(![S_LANG isEqualToString:S_LANG_EN]){
        // 自動調整サイズを取得
        CGFloat actualFontSize;
        [self.noPrintCell.nameLabelCell.text
         sizeWithFont:self.noPrintCell.nameLabelCell.font
         minFontSize:(self.noPrintCell.nameLabelCell.minimumScaleFactor * self.noPrintCell.nameLabelCell.font.pointSize)
         actualFontSize:&actualFontSize
         forWidth:self.noPrintCell.nameLabelCell.bounds.size.width
         lineBreakMode:self.noPrintCell.nameLabelCell.lineBreakMode];

        // 自動調整したフォントサイズが10以下なら、二段表示するか判定を行う
        if(actualFontSize < 11)
        {
            int iFontSize = [self.noPrintCell changeFontSize:self.noPrintCell.nameLabelCell.text];
            if (iFontSize != -1)
            {
                self.noPrintCell.nameLabelCell.lineBreakMode = NSLineBreakByWordWrapping;
                self.noPrintCell.nameLabelCell.numberOfLines = 2;
                [self.noPrintCell.nameLabelCell setFont:[UIFont systemFontOfSize:iFontSize]];

                // サイズ調整
                CGRect frame =  self.noPrintCell.nameLabelCell.frame;
                frame.size.height = 36;
                self.noPrintCell.nameLabelCell.frame = frame;
            }
        }
    } else {
        self.noPrintCell.nameLabelCell.lineBreakMode = NSLineBreakByWordWrapping;
        self.noPrintCell.nameLabelCell.numberOfLines = 2;

        // サイズ調整
        CGRect frame =  self.noPrintCell.nameLabelCell.frame;
        frame.size.height = 36;
        self.noPrintCell.nameLabelCell.frame = frame;
    }

    return self.noPrintCell;
}


// パスワードを指定
- (UITableViewCell *)getRetentionAuthOn:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
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
    // パスワードを指定
    // ********************
    self.retentionAuthCell = (SwitchDataCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (self.retentionAuthCell == nil)
    {
        self.retentionAuthCell = [[SwitchDataCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    self.retentionAuthCell.nameLabelCell.text		= S_RETENTION_AUTHENTICATE;
    self.retentionAuthCell.switchField.on			= profileData.retentionAuth;
    self.retentionAuthCell.switchField.tag		    = 1;
    [self.retentionAuthCell.switchField addTarget:self action:@selector(changeRetentionSwitchValue:) forControlEvents:UIControlEventValueChanged];

    if(![S_LANG isEqualToString:S_LANG_EN]){
        // 自動調整サイズを取得
        CGFloat actualFontSize;
        [self.retentionAuthCell.nameLabelCell.text
         sizeWithFont:self.retentionAuthCell.nameLabelCell.font
         minFontSize:(self.retentionAuthCell.nameLabelCell.minimumScaleFactor * self.retentionAuthCell.nameLabelCell.font.pointSize)
         actualFontSize:&actualFontSize
         forWidth:self.retentionAuthCell.nameLabelCell.bounds.size.width
         lineBreakMode:self.retentionAuthCell.nameLabelCell.lineBreakMode];

        // 自動調整したフォントサイズが10以下なら、二段表示するか判定を行う
        if(actualFontSize < 11)
        {
            int iFontSize = [self.retentionAuthCell changeFontSize:self.retentionAuthCell.nameLabelCell.text];
            if (iFontSize != -1)
            {
                self.retentionAuthCell.nameLabelCell.lineBreakMode = NSLineBreakByWordWrapping;
                self.retentionAuthCell.nameLabelCell.numberOfLines = 2;
                [self.retentionAuthCell.nameLabelCell setFont:[UIFont systemFontOfSize:iFontSize]];

                // サイズ調整
                CGRect frame =  self.retentionAuthCell.nameLabelCell.frame;
                frame.size.height = 36;
                self.retentionAuthCell.nameLabelCell.frame = frame;
            }
        }
    } else {
        self.retentionAuthCell.nameLabelCell.lineBreakMode = NSLineBreakByWordWrapping;
        self.retentionAuthCell.nameLabelCell.numberOfLines = 2;

        // サイズ調整
        CGRect frame =  self.retentionAuthCell.nameLabelCell.frame;
        frame.size.height = 36;
        self.retentionAuthCell.nameLabelCell.frame = frame;
    }

    return self.retentionAuthCell;
}


// パスワード
- (UITableViewCell *)getRetentionPassword:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
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
    // パスワード
    // ********************
    self.retentionPasswordCell = (ProfileDataCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (self.retentionPasswordCell == nil)
    {
        self.retentionPasswordCell = [[ProfileDataCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    self.retentionPasswordCell.nameEditableCell.textField.delegate = self;
    self.retentionPasswordCell.nameLabelCell.text				= S_RETENTION_PASSWORD;
    self.retentionPasswordCell.nameEditableCell.textField.text	= profileData.retentionPassword;
    self.retentionPasswordCell.nameEditableCell.textField.secureTextEntry = YES;
    self.retentionPasswordCell.nameEditableCell.textField.tag	= 2;
    //self.retentionPasswordCell.nameEditableCell.textField.keyboardAppearance = UIKeyboardAppearanceAlert;
    self.retentionPasswordCell.nameEditableCell.textField.keyboardAppearance = UIKeyboardAppearanceLight;

    if(![S_LANG isEqualToString:S_LANG_EN]){
        // 自動調整サイズを取得
        CGFloat actualFontSize;
        [self.retentionPasswordCell.nameLabelCell.text
         sizeWithFont:self.retentionPasswordCell.nameLabelCell.font
         minFontSize:(self.retentionPasswordCell.nameLabelCell.minimumScaleFactor * self.retentionPasswordCell.nameLabelCell.font.pointSize)
         actualFontSize:&actualFontSize
         forWidth:self.retentionPasswordCell.nameLabelCell.bounds.size.width
         lineBreakMode:self.retentionPasswordCell.nameLabelCell.lineBreakMode];

        // 自動調整したフォントサイズが10以下なら、二段表示するか判定を行う
        if(actualFontSize < 11)
        {
            int iFontSize = [self.retentionPasswordCell changeFontSize:self.retentionPasswordCell.nameLabelCell.text];
            if (iFontSize != -1)
            {
                self.retentionPasswordCell.nameLabelCell.lineBreakMode = NSLineBreakByWordWrapping;
                self.retentionPasswordCell.nameLabelCell.numberOfLines = 2;
                [self.retentionPasswordCell.nameLabelCell setFont:[UIFont systemFontOfSize:iFontSize]];
                // サイズ調整
                CGRect frame =  self.retentionPasswordCell.nameLabelCell.frame;
                frame.size.height = 36;
                self.retentionPasswordCell.nameLabelCell.frame = frame;
            }

        }
    } else {
        self.retentionPasswordCell.nameLabelCell.lineBreakMode = NSLineBreakByWordWrapping;
        self.retentionPasswordCell.nameLabelCell.numberOfLines = 2;
        // サイズ調整
        CGRect frame =  self.retentionPasswordCell.nameLabelCell.frame;
        frame.size.height = 36;
        self.retentionPasswordCell.nameLabelCell.frame = frame;
    }

    return self.retentionPasswordCell;
}


// ヘッダー表示前にフォントを設定
- (void)tableView:(UITableView *)tableView willDisplayHeaderView:(UIView *)view forSection:(NSInteger)section
{
    UITableViewHeaderFooterView *heView = (UITableViewHeaderFooterView *)view;
    heView.textLabel.font = [UIFont systemFontOfSize:N_TABLE_FONT_SIZE_HEADER];
}

//
// 各セクションのタイトルを決定する
//
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    NSString *title = @"";
    switch (section) {
        case 0:
            title = S_TITLE_RETENTION;
            break;
        default:
            break;
    }
    return title;
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
            
            // パスワード(リテンション)
            if(pData.noPrint == YES && pData.retentionAuth == YES){
                
                // 空白チェック
                if (pData.retentionPassword == nil || [pData.retentionPassword isEqualToString:@""] || pData.retentionPassword.length == 0)
                {
                    strerrMessage = [NSString stringWithFormat:MSG_REQUIRED_ERR, S_RETENTION_PASSWORD];
                    [self profileAlert:nil errMessage:strerrMessage];
                    return NO;
                }
                
                // 文字数チェック
                if (8 < pData.retentionPassword.length || 5 > pData.retentionPassword.length)
                {
                    strerrMessage = [NSString stringWithFormat:MSG_FORMAT_ERR, S_RETENTION_PASSWORD, SUBMSG_RETENTION_FORMAT];
                    [self profileAlert:nil errMessage:strerrMessage];
                    return NO;
                }
                
                // 半角数字チェック
                if (0 < pData.retentionPassword.length)
                {
                    char* chars = (char*)[pData.retentionPassword UTF8String];
                    for(int i = 0; i < pData.retentionPassword.length; i++){
                        if(chars[i] >= '0' && chars[i] <= '9'){
                            continue;
                        }else if(chars[i] == '\0'){
                            // 終端文字
                            break;
                        }else{
                            strerrMessage = [NSString stringWithFormat:MSG_CHAR_TYPE_ERR, S_RETENTION_PASSWORD, SUBMSG_ONLY_HALFCHAR_NUMBER];
                            [self profileAlert:nil errMessage:strerrMessage];
                            return NO;
                        }
                    }
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
    SharpScanPrintAppDelegate* appDelegate = (SharpScanPrintAppDelegate*)[[UIApplication sharedApplication] delegate];
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

// 処理実行フラグをOFFにする
- (void)appDelegateIsRunOff {
    // ボタンタップ時の処理
    SharpScanPrintAppDelegate* appDelegate = (SharpScanPrintAppDelegate*)[[UIApplication sharedApplication] delegate];
    // 処理実行フラグOFF
    appDelegate.IsRun = FALSE;
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
    
    // 印刷せずにホールド
    if (self.noPrintCell) {
        BOOL isNoPrint = FALSE;
        if(self.noPrintCell.switchField.on == YES)
        {
            isNoPrint = TRUE;
        }
        profileData.noPrint = isNoPrint;
        
        // 印刷せずにホールドがONの場合
        if (isNoPrint) {
            
            // パスワードを指定
            if (self.retentionAuthCell) {
                BOOL isRetentionAuth = FALSE;
                if(self.retentionAuthCell.switchField.on == YES)
                {
                    isRetentionAuth = TRUE;
                }
                profileData.retentionAuth = isRetentionAuth;
                
                // パスワードを指定するがONの場合
                if (isRetentionAuth) {
                    // パスワード
                    if (self.retentionPasswordCell.nameEditableCell.textField) {
                        profileData.retentionPassword = self.retentionPasswordCell.nameEditableCell.textField.text;
                    }
                } else {
                    // パスワードを初期化する
                    profileData.retentionPassword = @"";
                }
                
            } else {
                // パスワードを初期化する
                profileData.retentionPassword = @"";
            }
            
        } else {
            // パスワードを指定するをNOにする
            profileData.retentionAuth = NO;
            // パスワードを初期化する
            profileData.retentionPassword = @"";
        }
    }
    
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
            
            // 前画面に戻る
            [self.navigationController popViewControllerAnimated:YES];
            
        }
        @finally
        {
        }
    }
    
}

// リテンション関連
-(IBAction)changeRetentionSwitchValue:(UISwitch*)sender
{
    switch (sender.tag) {
        // 印刷せずにホールドのスイッチ変更時の処理
        case 0:
        {
            noPrintOn = sender.on;
            
            NSIndexPath* indexPath = [NSIndexPath indexPathForRow:RETENTION_INFO_SECTION_AUTH_ON inSection:0];
            NSArray* indexPaths = [NSArray arrayWithObject:indexPath];
            NSInteger nRowxCount = [self.tableView numberOfRowsInSection:0];
            if(noPrintOn){
                // 行追加処理開始
                [self.tableView beginUpdates];
                // パスワードを指定する選択欄の追加
                [self.tableView insertRowsAtIndexPaths: indexPaths withRowAnimation:UITableViewRowAnimationAutomatic];
                
                if (authenticateOn) {
                    NSIndexPath* indexPath = [NSIndexPath indexPathForRow:RETENTION_INFO_SECTION_PASSWORD inSection:0];
                    NSArray* indexPaths = [NSArray arrayWithObject:indexPath];
                    // パスワード入力欄の追加
                    [self.tableView insertRowsAtIndexPaths: indexPaths withRowAnimation:UITableViewRowAnimationAutomatic];
                }
                // 行追加処理終了
                [self.tableView endUpdates];
            }else{
                // 行削除処理開始
                [self.tableView beginUpdates];
                if (nRowxCount == 3) {
                    NSIndexPath* indexPath = [NSIndexPath indexPathForRow:RETENTION_INFO_SECTION_PASSWORD inSection:0];
                    NSArray* indexPaths = [NSArray arrayWithObject:indexPath];
                    // パスワード入力欄の削除
                    [self.tableView deleteRowsAtIndexPaths: indexPaths withRowAnimation:UITableViewRowAnimationAutomatic];
                }
                // パスワードを指定する選択欄の削除
                [self.tableView deleteRowsAtIndexPaths: indexPaths withRowAnimation:UITableViewRowAnimationAutomatic];
                // 行削除処理終了
                [self.tableView endUpdates];
            }
            // テーブルを更新
            [self.tableView performSelector:@selector(reloadData) withObject:nil afterDelay:0.5];
            
            break;
        }
        // 認証のスイッチ変更時の処理
        case 1:
        {
            authenticateOn = sender.on;
            NSIndexPath* indexPath = [NSIndexPath indexPathForRow: RETENTION_INFO_SECTION_PASSWORD inSection:0];
            NSArray* indexPaths = [NSArray arrayWithObject:indexPath];
            NSInteger nRowxCount = [self.tableView numberOfRowsInSection:0];
            if(authenticateOn){
                if (nRowxCount == 2) {
                    // パスワード入力欄の追加
                    [self.tableView insertRowsAtIndexPaths: indexPaths withRowAnimation:UITableViewRowAnimationAutomatic];
                }
            }else{
                if (nRowxCount == 3) {
                    // パスワード入力欄の削除
                    [self.tableView deleteRowsAtIndexPaths: indexPaths withRowAnimation:UITableViewRowAnimationAutomatic];
                }
            }
            // テーブルを更新
            [self.tableView performSelector:@selector(reloadData) withObject:nil afterDelay:0.5];
            
            break;
        }
            
        default:
            return;
            break;
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

@end
