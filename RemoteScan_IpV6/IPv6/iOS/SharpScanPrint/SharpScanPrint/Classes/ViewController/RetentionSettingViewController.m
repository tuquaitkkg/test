
#import "RetentionSettingViewController.h"
#import "Define.h"
#import "SharpScanPrintAppDelegate.h"

@interface RetentionSettingViewController ()

@end

@implementation RetentionSettingViewController

@synthesize delegate;
@synthesize noPrintCell;                         // 印刷せずにホールド
@synthesize authenticateCell;                    // 認証
@synthesize passwordCell;                        // パスワード
@synthesize noPrintOn;
@synthesize authenticateOn;
@synthesize pstrPassword;

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // セルのラインを表示する
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    
    // テーブルビューをバウンドさせない
    self.tableView.bounces = NO;
    
    // ナビゲーションバー
    // タイトル設定
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad){
        //iPad
        //self.title = S_TITLE_RETENTION;
        self.contentSizeForViewInPopover = CGSizeMake(300.0, 194.0);
        self.tableView.dataSource = self;
        [self.tableView setScrollEnabled: NO];
        self.tableView.allowsSelection = NO;
    } else{
        //iPhone
        CGRect frame = CGRectMake(0, 0, 400, 44);
        UILabel* lblTitle = [[UILabel alloc]initWithFrame:frame];
        lblTitle.backgroundColor = [UIColor clearColor];
        lblTitle.textColor = NAVIGATION_TITLE_COLOR;
        lblTitle.font = [UIFont boldSystemFontOfSize:20];
        lblTitle.textAlignment = NSTextAlignmentCenter;
        lblTitle.text = S_TITLE_RETENTION;
        lblTitle.adjustsFontSizeToFitWidth = YES;
        self.navigationItem.titleView = lblTitle;
        
        // ナビゲーションバー左側にキャンセルボタンを設定
        UIBarButtonItem* btnClose = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel
                                                                                  target:self
                                                                                  action:@selector(cancelAction:)];
        self.navigationItem.leftBarButtonItem = btnClose;
        
    }
    
    // 決定ボタン追加
    UIBarButtonItem* btnSetting = [[UIBarButtonItem alloc] initWithTitle:S_BUTTON_DECIDE style:UIBarButtonItemStyleDone target:self action:@selector(dosave:)];
    
    self.navigationItem.rightBarButtonItem = btnSetting;
    
    //初期値設定
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
    
    // テーブルのセクションIDリストを初期化
    tableSectionIDs = [[NSMutableArray alloc]init];
    for(int i = 0; i < 2; i++){
        if([self visibleSection:i]){
            [tableSectionIDs addObject:[NSNumber numberWithInt:i]];
        }
    }
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
}

#pragma mark - Table view data source
// セクション数
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return [tableSectionIDs count];
}

// セルの数
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
	NSInteger nRet = 0;
    int sectionId = [[tableSectionIDs objectAtIndex:section] intValue];
    if(sectionId == 0)
    {
        nRet = 1;
    }else if(sectionId == 1)
    {
        if(!noPrintOn)
        {
            nRet = 0;
        }else{
            if(authenticateOn)
            {
                nRet = 2;
            }else{
                nRet = 1;
            }
        }
    }
    return nRet;
}

// テーブルセルの作成
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //
    // 自動解放プールの作成
    //
    @autoreleasepool
    {
        @try {
            int sectionId = [[tableSectionIDs objectAtIndex:indexPath.section] intValue];
            NSString *CellIdentifier = [NSString stringWithFormat:@"Cell%02ld%02ld", (long)indexPath.section, (long)indexPath.row];
            
            //
            // 指定されたセルを返却
            //
            if (sectionId == 0)
            {
                if(indexPath.row == 0)
                {
                    // ********************
                    //　印刷せずにホールド
                    // ********************
                    self.noPrintCell = (RetentionSwitchDataCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
                    if (self.noPrintCell == nil)
                    {
                        self.noPrintCell = [[RetentionSwitchDataCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
                    }
                    self.noPrintCell.nameLabelCell.text		= S_RETENTION_NOPRINT;
                    self.noPrintCell.switchField.on			= noPrintOn;
                    self.noPrintCell.switchField.tag		= 0;
                    [self.noPrintCell.switchField addTarget:self action:@selector(changeSwitchValue:) forControlEvents:UIControlEventValueChanged];
                    
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
            }
            else if(sectionId == 1)
            {
                if(indexPath.row == 0)
                {
                    // ********************
                    //　認証
                    // ********************
                    self.authenticateCell = (RetentionSwitchDataCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
                    if (self.authenticateCell == nil)
                    {
                        self.authenticateCell = [[RetentionSwitchDataCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
                    }
                    self.authenticateCell.nameLabelCell.text		= S_RETENTION_AUTHENTICATE;
                    self.authenticateCell.switchField.on			= authenticateOn;
                    self.authenticateCell.switchField.tag		= 1;
                    [self.authenticateCell.switchField addTarget:self action:@selector(changeSwitchValue:) forControlEvents:UIControlEventValueChanged];
                    
                    if(![S_LANG isEqualToString:S_LANG_EN]){
                        // 自動調整サイズを取得
                        CGFloat actualFontSize;
                        [self.authenticateCell.nameLabelCell.text
                         sizeWithFont:self.authenticateCell.nameLabelCell.font
                         minFontSize:(self.authenticateCell.nameLabelCell.minimumScaleFactor * self.authenticateCell.nameLabelCell.font.pointSize)
                         actualFontSize:&actualFontSize
                         forWidth:self.authenticateCell.nameLabelCell.bounds.size.width
                         lineBreakMode:self.authenticateCell.nameLabelCell.lineBreakMode];
                        
                        // 自動調整したフォントサイズが10以下なら、二段表示するか判定を行う
                        if(actualFontSize < 11)
                        {
                            int iFontSize = [self.authenticateCell changeFontSize:self.authenticateCell.nameLabelCell.text];
                            if (iFontSize != -1)
                            {
                                self.authenticateCell.nameLabelCell.lineBreakMode = NSLineBreakByWordWrapping;
                                self.authenticateCell.nameLabelCell.numberOfLines = 2;
                                [self.authenticateCell.nameLabelCell setFont:[UIFont systemFontOfSize:iFontSize]];
                                // サイズ調整
                                CGRect frame =  self.authenticateCell.nameLabelCell.frame;
                                frame.size.height = 36;
                                self.authenticateCell.nameLabelCell.frame = frame;
                            }
                        }
                    } else {
                        self.authenticateCell.nameLabelCell.lineBreakMode = NSLineBreakByWordWrapping;
                        self.authenticateCell.nameLabelCell.numberOfLines = 2;
                        // サイズ調整
                        CGRect frame =  self.authenticateCell.nameLabelCell.frame;
                        frame.size.height = 36;
                        self.authenticateCell.nameLabelCell.frame = frame;
                    }
                    return self.authenticateCell;
                }
                else
                {
                    if(self.authenticateCell.switchField.on)
                    {
                        // ********************
                        // パスワード
                        // ********************
                        self.passwordCell = (RetentionCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
                        if (self.passwordCell == nil)
                        {
                            self.passwordCell = [[RetentionCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
                        }
                        
                        //                    if([decryptLoginPassword length] > 0)
                        //                    {
                        //                        decryptLoginPassword = [CommonUtil decryptString:[CommonUtil base64Decoding:pstrPassword] withKey:S_KEY_PJL];
                        //                    }
                        self.passwordCell.nameEditableCell.textField.delegate = self;
                        self.passwordCell.nameLabelCell.text				= S_RETENTION_PASSWORD;
                        self.passwordCell.nameEditableCell.textField.text	= pstrPassword;
                        self.passwordCell.nameEditableCell.textField.secureTextEntry = YES;
                        self.passwordCell.nameEditableCell.textField.tag	= 2;
                        //self.passwordCell.nameEditableCell.textField.keyboardAppearance = UIKeyboardAppearanceAlert;
                        self.passwordCell.nameEditableCell.textField.keyboardAppearance = UIKeyboardAppearanceLight;
                        
                        if(![S_LANG isEqualToString:S_LANG_EN]){
                            // 自動調整サイズを取得
                            CGFloat actualFontSize;
                            [self.passwordCell.nameLabelCell.text
                             sizeWithFont:self.passwordCell.nameLabelCell.font
                             minFontSize:(self.passwordCell.nameLabelCell.minimumScaleFactor * self.passwordCell.nameLabelCell.font.pointSize)
                             actualFontSize:&actualFontSize
                             forWidth:self.passwordCell.nameLabelCell.bounds.size.width
                             lineBreakMode:self.passwordCell.nameLabelCell.lineBreakMode];
                            
                            // 自動調整したフォントサイズが10以下なら、二段表示するか判定を行う
                            if(actualFontSize < 11)
                            {
                                int iFontSize = [self.passwordCell changeFontSize:self.passwordCell.nameLabelCell.text];
                                if (iFontSize != -1)
                                {
                                    self.passwordCell.nameLabelCell.lineBreakMode = NSLineBreakByWordWrapping;
                                    self.passwordCell.nameLabelCell.numberOfLines = 2;
                                    [self.passwordCell.nameLabelCell setFont:[UIFont systemFontOfSize:iFontSize]];
                                    // サイズ調整
                                    CGRect frame =  self.passwordCell.nameLabelCell.frame;
                                    frame.size.height = 36;
                                    self.passwordCell.nameLabelCell.frame = frame;
                                }
                                
                            }
                        } else {
                            self.passwordCell.nameLabelCell.lineBreakMode = NSLineBreakByWordWrapping;
                            self.passwordCell.nameLabelCell.numberOfLines = 2;
                            // サイズ調整
                            CGRect frame =  self.passwordCell.nameLabelCell.frame;
                            frame.size.height = 36;
                            self.passwordCell.nameLabelCell.frame = frame;
                        }
                        
                        return self.passwordCell;
                    }
                }
            }
        }
        @finally
        {
        }
    }
    return nil; //ビルド警告回避用
}

// 各セルの高さを設定
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return N_HEIGHT_SEL_DEFAULT;
}

// ヘッダーの高さを設定
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return TABLE_HEADER_HEIGHT_1;
}

// フッターの高さを設定
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return TABLE_FOOTER_HEIGHT_1;
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
    // Navigation logic may go here. Create and push another view controller.
    /*
     <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:@"<#Nib name#>" bundle:nil];
     // ...
     // Pass the selected object to the new view controller.
     [self.navigationController pushViewController:detailViewController animated:YES];
     [detailViewController release];
     */
}

//
// 入力チェック
//
- (BOOL)CheckText
{
    if(noPrintOn == YES && authenticateOn == YES){
        NSString* pstrPasswordCell = self.passwordCell.nameEditableCell.textField.text;
        
        // 空白チェック
        if (pstrPasswordCell == nil || [pstrPasswordCell isEqualToString:@""] || pstrPasswordCell.length == 0)
        {
            pstrErrMessage = [NSString stringWithFormat:MSG_REQUIRED_ERR, S_RETENTION_PASSWORD];
            return NO;
        }
        
        // 文字数チェック
        //int len = [[pstrPasswordCell stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] length];
        if (8 < pstrPasswordCell.length || 5 > pstrPasswordCell.length)
        {
            pstrErrMessage = [NSString stringWithFormat:MSG_FORMAT_ERR, S_RETENTION_PASSWORD, SUBMSG_RETENTION_FORMAT];
            return NO;
        }
        
        // 半角数字チェック
        if (0 < pstrPasswordCell.length)
        {
            char* chars = (char*)[pstrPasswordCell UTF8String];
            for(int i = 0; i < pstrPasswordCell.length; i++){
                if(chars[i] >= '0' && chars[i] <= '9'){
                    continue;
                }else if(chars[i] == '\0'){
                    // 終端文字
                    break;
                }else{
                    pstrErrMessage = [NSString stringWithFormat:MSG_CHAR_TYPE_ERR, S_RETENTION_PASSWORD, SUBMSG_ONLY_HALFCHAR_NUMBER];
                    return NO;
                }
            }
        }
    }
    return YES;
}

//
// キャンセルボタン処理
//
- (void)cancelAction:(id)sender
{
    if(delegate){
        if([delegate respondsToSelector:@selector(retentionSetting:didCreatedSuccess:)]){
            // デリゲートメソッドの呼び出し(モーダルビューも閉じる)
            [delegate retentionSetting:self didCreatedSuccess:NO];
        }
    }
}

//
// 決定ボタン処理
//
- (IBAction)dosave:(id)sender
{
    // 入力チェック
    BOOL isNoError = [self CheckText];
    
    if (isNoError)
    {
        if(delegate){
            if([delegate respondsToSelector:@selector(retentionSetting:didCreatedSuccess:)]){
                pstrPassword = self.passwordCell.nameEditableCell.textField.text;
                // デリゲートメソッドの呼び出し(モーダルビューも閉じる)
                [delegate retentionSetting:self didCreatedSuccess:YES];
            }
        }
    }
    else
    {
        SharpScanPrintAppDelegate* appDelegate = (SharpScanPrintAppDelegate*)[[UIApplication sharedApplication] delegate];
        // 処理実行フラグON
        appDelegate.IsRun = TRUE;
        
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil
                                                                                 message:pstrErrMessage
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
        
        return;
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
            // 印刷せずにホールドのスイッチ変更時の処理
        case 0:
        {
            noPrintOn = sender.on;
            
            // セクションの削除と挿入
            [self sectionDeleteAndInsert];
            
            break;
        }
            // 認証のスイッチ変更時の処理
        case 1:
        {
            authenticateOn = sender.on;
            NSIndexPath* indexPath = [NSIndexPath indexPathForRow: 1 inSection:1];
            NSArray* indexPaths = [NSArray arrayWithObject:indexPath];
            NSInteger nRowxCount = [self.tableView numberOfRowsInSection:1];
            if(authenticateOn){
                if (nRowxCount == 1) {
                    // パスワード入力欄の追加
                    [self.tableView insertRowsAtIndexPaths: indexPaths withRowAnimation:UITableViewRowAnimationAutomatic];
                }
            }else{
                if (nRowxCount == 2) {
                    // パスワード入力欄の削除
                    [self.tableView deleteRowsAtIndexPaths: indexPaths withRowAnimation:UITableViewRowAnimationAutomatic];
                }
            }
            break;
        }
            
        default:
            return;
            break;
    }
    
}
#pragma mark - Table Section Delete And Insert
// セクションの削除と挿入
-(void)sectionDeleteAndInsert
{
    // セクションの削除
    NSMutableIndexSet* modIndexes = [NSMutableIndexSet indexSet];
    for(int secid = 0; secid < 2; secid++){
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
        for(int secid = 0; secid < 2; secid++){
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
            for(int i = 0; i < 2; i++){
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
        // 認証・パスワード
        if(noPrintOn){
            res = YES;
        }
        else{
            // 「印刷せずにホールド」オフの時は非表示
            res = NO;
        }
    }
    
    return res;
}

@end
