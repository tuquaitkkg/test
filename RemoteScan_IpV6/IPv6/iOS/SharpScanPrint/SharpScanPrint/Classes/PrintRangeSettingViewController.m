
#import "PrintRangeSettingViewController.h"
#import "Define.h"
#import "CommonUtil.h"
#import "SharpScanPrintAppDelegate.h"
#import "PJLDataManager.h"

@interface PrintRangeSettingViewController ()

@end

@implementation PrintRangeSettingViewController

//
// アクセサメソッドの自動合成(ゲッターとセッターの役割)
//
@synthesize delegate;
@synthesize pageDirectCell;
@synthesize m_parrPickerRow;
@synthesize m_PrintRangeStyle;
@synthesize m_PageMax;
@synthesize m_PageFrom;
@synthesize m_PageTo;
@synthesize m_PageDirect;
@synthesize noRangeDesignation;

enum{
    PRINT_RANGE_STYLE_ALL,
    PRINT_RANGE_STYLE_RANGE,
    PRINT_RANGE_STYLE_DIRECT,
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

    // テーブルビューをバウンドさせない
    self.tableView.bounces = NO;
    
    // タイトル設定
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad){
        //iPad
        //self.title = S_TITLE_PRINT_RANGE;
        self.contentSizeForViewInPopover = CGSizeMake(320.0, 380.0);
        self.tableView.dataSource = self;
        //[self.tableView setScrollEnabled: NO];
        //self.tableView.allowsSelection = NO;
    } else{
        //iPhone
        CGRect frame = CGRectMake(0, 0, 400, 44);
        UILabel* lblTitle = [[UILabel alloc]initWithFrame:frame];
        lblTitle.backgroundColor = [UIColor clearColor];
        lblTitle.textColor = NAVIGATION_TITLE_COLOR;
        lblTitle.font = [UIFont boldSystemFontOfSize:20];
        lblTitle.textAlignment = NSTextAlignmentCenter;
        lblTitle.text = S_TITLE_PRINT_RANGE;
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
    switch (m_PrintRangeStyle)
    {
        //全てのページ
        case PRINT_RANGE_STYLE_ALL:
            m_PageFrom = 1;
            m_PageTo = m_PageMax;
            m_PageDirect = @"";
            // ピッカー作成
            [self showPicker];
            //ピッカーを非表示にする
            pickerView1.hidden = YES;
            pickerView2.hidden = YES;
            lblSeparate.hidden = YES;
            break;
            
        //範囲指定
        case PRINT_RANGE_STYLE_RANGE:
            m_PageDirect = @"";
            // ピッカー作成
            [self showPicker];
            //ピッカーを表示する
            [self showViewAnimation];
            break;
            
        //直接指定
        case PRINT_RANGE_STYLE_DIRECT:
            m_PageFrom = 1;
            m_PageTo = m_PageMax;
            // ピッカー作成
            [self showPicker];
            //ピッカーを非表示にする
            pickerView1.hidden = YES;
            pickerView2.hidden = YES;
            lblSeparate.hidden = YES;
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

- (void)viewDidUnload
{
    [super viewDidUnload];
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
		nRet = 3;
	}
	else if(sectionId == 1)
	{
        if(m_PrintRangeStyle == PRINT_RANGE_STYLE_DIRECT){
            nRet = 1;
        }else{
            nRet = 0;
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
            NSString *CellIdentifier = [NSString stringWithFormat:@"Cell%02d%02ld", sectionId, (long)indexPath.row];
            
            //
            // 指定されたセルを返却
            //
            if (sectionId == 0)
            {
                // -------------
                // 印刷範囲
                // -------------
                UITableViewCell* nomalCell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
                UILabel* titleLbl = nil;
                if(nomalCell == nil){
                    nomalCell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
                    
                    // タイトルラベルの作成
                    CGRect titleLblFrame = nomalCell.contentView.frame;
                    if([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0 ||
                       UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
                    {
                        // iOS7以降 もしくはiPad
                        titleLblFrame.origin.x += 20;
                        titleLblFrame.size.width -= 20;
                    }else{
                        // iOS6以前
                        titleLblFrame.origin.x += 10;
                        titleLblFrame.size.width -= 10;
                    }
                    
                    titleLbl = [[UILabel alloc]initWithFrame:titleLblFrame];
                    titleLbl.font = [UIFont systemFontOfSize:[UIFont systemFontSize]];
                    titleLbl.backgroundColor = [UIColor clearColor];
                    titleLbl.tag = 3;
                    
                    [nomalCell.contentView addSubview:titleLbl];
                    
                    // 現在の設定を読み込む
                    //                m_PrintRangeStyle = profileData.userAuthStyle;
                    //m_PrintRangeStyle = 0;
                    
                }else{
                    titleLbl = (UILabel*)[nomalCell.contentView viewWithTag:3];
                }
                
                // タイトルの設定
                if(titleLbl){
                    if(indexPath.row == 0){
                        titleLbl.text = S_PRINT_RANGE_ALL;
                    }else if (indexPath.row == 1){
                        titleLbl.text = S_PRINT_RANGE_RANGE;
                    }else{
                        titleLbl.text = S_PRINT_RANGE_DIRECT;
                    }
                }
                
                // 選択状態の設定
                if(indexPath.row == m_PrintRangeStyle){
                    [nomalCell setAccessoryType:UITableViewCellAccessoryCheckmark];
                }else{
                    [nomalCell setAccessoryType:UITableViewCellAccessoryNone];
                }
                
                return nomalCell;
            }
            else if (sectionId == 1)
            {
                if(indexPath.row == 0)
                {
                    // ********************
                    // 直接指定
                    // ********************
                    self.pageDirectCell = (PrintRangeCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
                    if (self.pageDirectCell == nil)
                    {
                        self.pageDirectCell = [[PrintRangeCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
                    }
                    self.pageDirectCell.nameEditableCell.textField.delegate = self;
                    self.pageDirectCell.nameEditableCell.textField.text	= m_PageDirect;
                    self.pageDirectCell.nameEditableCell.textField.secureTextEntry = NO;
                    self.pageDirectCell.nameEditableCell.textField.tag	= 1;
                    //self.pageDirectCell.nameEditableCell.textField.keyboardAppearance = UIKeyboardAppearanceAlert;
                    self.pageDirectCell.nameEditableCell.textField.keyboardAppearance = UIKeyboardAppearanceLight;
                    return self.pageDirectCell;
                }
            }
        }
        @finally
        {
        }
    }
	return nil; //ビルド警告回避用
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    // 「範囲指定」項目を非表示にする場合
    if (noRangeDesignation) {
        if (indexPath.section == 0) {
            if (indexPath.row == 1) {
                cell.hidden = YES;//非表示
            }
        }
    }
}

// 各セルの高さを設定
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    // 「範囲指定」項目を非表示にする場合、高さも０にしておく
    if (noRangeDesignation) {
        if (indexPath.section == 0) {
            if (indexPath.row == 1) {
                return 0;
            }
        }
    }
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

#pragma mark - Table view delegate
//
// 印刷範囲切り替え
//
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    int sectionId = [[tableSectionIDs objectAtIndex:indexPath.section] intValue];
    if(sectionId == 0){
        bool isShowPicker = true;
        //範囲指定を連続選択した場合
        if (m_PrintRangeStyle == indexPath.row == PRINT_RANGE_STYLE_RANGE) {
            isShowPicker = false;
        }
        
        // ハイライトの解除
        [tableView deselectRowAtIndexPath:[tableView indexPathForSelectedRow] animated:YES];
        
        // 選択番号の更新
        m_PrintRangeStyle = indexPath.row;
        
        // チェックの設定
        for(int i = 0; i < 3; i++){
            UITableViewCell* cell = [tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:i inSection:indexPath.section]];
            int accessory = UITableViewCellAccessoryNone;
            if(i == indexPath.row){
                accessory = UITableViewCellAccessoryCheckmark;
            }
            
            [cell setAccessoryType:accessory];
        }
        
        // セクションの削除と挿入
        [self sectionDeleteAndInsert];

        //範囲指定の場合
        if(m_PrintRangeStyle == PRINT_RANGE_STYLE_RANGE){
            if (isShowPicker) {
                // 表示アニメーション
                [self showViewAnimation];
            }
        } else{
            if (!pickerView1.hidden){
                // 非表示アニメーション
                [self hideViewAnimation];
            }
        }
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
        // 直接指定
        if(m_PrintRangeStyle == PRINT_RANGE_STYLE_DIRECT){
            res = YES;
        }
        else{
            // 「直接指定」以外の時は非表示
            res = NO;
        }
    }
    
    return res;
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
            title = @"";
            break;
        case 1:
            title = @"";
            break;
        default:
            break;
    }
    return title;
}


//
// 入力チェック
//
- (BOOL)CheckText
{
    if(m_PrintRangeStyle == PRINT_RANGE_STYLE_DIRECT){
        NSString* pstrPageDirectCell = self.pageDirectCell.nameEditableCell.textField.text;
        
        // 空白チェック
        if (pstrPageDirectCell == nil || [pstrPageDirectCell isEqualToString:@""] || pstrPageDirectCell.length == 0)
        {
            pstrErrMessage = [NSString stringWithFormat:MSG_REQUIRED_ERR, S_PRINT_RANGE_DIRECT];
            return NO;
        }
        
        // 印刷数字チェック
        if(![CommonUtil isMatchPrintNumber:pstrPageDirectCell])
        {
            pstrErrMessage = [NSString stringWithFormat:MSG_CHAR_TYPE_ERR, S_PRINT_RANGE_DIRECT, SUBMSG_PRINTNUMBER];
            return NO;
        }
        
        // 印刷数字チェック(数字数字)
        if([CommonUtil isMatchPrintNumber_NumberNumber:pstrPageDirectCell])
        {
            pstrErrMessage = [NSString stringWithFormat:MSG_FORMAT_ERR, S_PRINT_RANGE_DIRECT, SUBMSG_PRINTNUMBER_FORMAT];
            return NO;
        }
        
        // 印刷数字チェック(ハイフン数字ハイフン)
        if([CommonUtil isMatchPrintNumber_HyphenNumberHyphen:pstrPageDirectCell])
        {
            pstrErrMessage = [NSString stringWithFormat:MSG_FORMAT_ERR, S_PRINT_RANGE_DIRECT, SUBMSG_PRINTNUMBER_FORMAT];
            return NO;
        }
        
        // 印刷数字チェック(ハイフンハイフン)
        if([CommonUtil isMatchPrintNumber_HyphenHyphen:pstrPageDirectCell])
        {
            pstrErrMessage = [NSString stringWithFormat:MSG_FORMAT_ERR, S_PRINT_RANGE_DIRECT, SUBMSG_PRINTNUMBER_FORMAT];
            return NO;
        }
        
        // 印刷数字チェック(区切り文字のみ)
        if([CommonUtil isMatchPrintNumber_OnlySeparater:pstrPageDirectCell])
        {
            pstrErrMessage = [NSString stringWithFormat:MSG_FORMAT_ERR, S_PRINT_RANGE_DIRECT, SUBMSG_PRINTNUMBER_FORMAT];
            return NO;
        }
        
        // カンマで区切った文字ごとにチェックし、ハイフンのみ又はハイフン前後の数字の大小チェックを行う。
        NSArray* lRanges = [pstrPageDirectCell componentsSeparatedByString:@","];
        //NSString lRanges[] = pstrPageDirectCell.split(",", -1);
        for(int i = 0; i < lRanges.count; i++){
            NSArray* lRangeParts = [lRanges[i] componentsSeparatedByString:@"-"];
            //String[] lRangeParts = lRanges[i].split("-", -1);
            if(lRangeParts.count == 2){
                 NSUInteger len1 = [[lRangeParts[0] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] length];
                 NSUInteger len2 = [[lRangeParts[1] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] length];
                 if(len1 == 0 && len2 == 0){
                     pstrErrMessage = [NSString stringWithFormat:MSG_FORMAT_ERR, S_PRINT_RANGE_DIRECT, SUBMSG_PRINTNUMBER_FORMAT];
                     return NO;
                 }
 
                int value1 = [lRangeParts[0] intValue];
                int value2 = [lRangeParts[1] intValue];
                if(len1 > 0 && len2 > 0 && value1 > value2){
                    pstrErrMessage = [NSString stringWithFormat:MSG_FORMAT_ERR, S_PRINT_RANGE_DIRECT, SUBMSG_PRINTNUMBER_FORMAT];
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
        if([delegate respondsToSelector:@selector(printRangeSetting:didCreatedSuccess:)]){
            // デリゲートメソッドの呼び出し(モーダルビューも閉じる)
            [delegate printRangeSetting:self didCreatedSuccess:NO];
        }
    }
}

//
// 決定ボタン処理
//
-(IBAction)dosave:(id)sender
{
    // 入力チェック
    BOOL isNoError = [self CheckText];

    if (isNoError)
    {
        if(delegate){
            if([delegate respondsToSelector:@selector(printRangeSetting:didCreatedSuccess:)]){
                m_PageDirect = self.pageDirectCell.nameEditableCell.textField.text;
               // デリゲートメソッドの呼び出し(モーダルビューも閉じる)
                [delegate printRangeSetting:self didCreatedSuccess:YES];
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

- (void)showPicker {
	// ピッカーの作成
	//pickerView1 = [[UIPickerView alloc] initWithFrame:CGRectMake(0, [[UIScreen mainScreen] bounds].size.height - 280, [[UIScreen mainScreen] bounds].size.width / 2, 0)];
    pickerView1 = [[UIPickerView alloc] init];
	pickerView1.delegate = self;
	pickerView1.dataSource = self;
    CGRect mainRec = [[UIScreen mainScreen] bounds];
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        //iPad
        if([[[UIDevice currentDevice] systemVersion] floatValue] >= 9.0f){
            [pickerView1 setFrame:CGRectMake(0, self.contentSizeForViewInPopover.height - pickerView1.bounds.size.height, self.contentSizeForViewInPopover.width / 2, pickerView1.bounds.size.height)];
        }else{
            //iOS8 以下(厳密にはiOS5~8)
            [pickerView1 setFrame:CGRectMake(0, self.contentSizeForViewInPopover.height - pickerView1.bounds.size.height, self.contentSizeForViewInPopover.width / 2, 0)];
        }

        DLog(@"self.contentSizeForViewInPopover.height=%f", self.contentSizeForViewInPopover.height);
        DLog(@"pickerView1.bounds.size.height=%f", pickerView1.bounds.size.height);
        DLog(@"self.contentSizeForViewInPopover.width=%f", self.contentSizeForViewInPopover.width);
        DLog(@"pickerView1.bounds.size.width=%f", pickerView1.bounds.size.width);
        
    }else{
        //iPhone
        if([[[UIDevice currentDevice] systemVersion] floatValue] >= 9.0f){
            [pickerView1 setFrame:CGRectMake(0, mainRec.size.height - 280, mainRec.size.width / 2, 216)];
        }else{
            //iOS8 以下(厳密にはiOS5~8)
            [pickerView1 setFrame:CGRectMake(0, mainRec.size.height - 280, mainRec.size.width / 2, 0)];
        }
    }
	[pickerView1 setShowsSelectionIndicator:TRUE];
    if (m_PageFrom > 0) {
        [pickerView1 selectRow:m_PageFrom-1 inComponent:0 animated:NO];
    }
    //pickerView2 = [[UIPickerView alloc] initWithFrame:CGRectMake(160, [[UIScreen mainScreen] bounds].size.height - 280, [[UIScreen mainScreen] bounds].size.width / 2, 0)];
    pickerView2 = [[UIPickerView alloc] init];
	pickerView2.delegate = self;
    pickerView2.dataSource = self;
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        //iPad
        if([[[UIDevice currentDevice] systemVersion] floatValue] >= 9.0f){
            [pickerView2 setFrame:CGRectMake(self.contentSizeForViewInPopover.width / 2, self.contentSizeForViewInPopover.height - pickerView2.bounds.size.height, self.contentSizeForViewInPopover.width / 2, pickerView1.bounds.size.height)];
        }else{
            //iOS8 以下(厳密にはiOS5~8)
            [pickerView2 setFrame:CGRectMake(self.contentSizeForViewInPopover.width / 2, self.contentSizeForViewInPopover.height - pickerView2.bounds.size.height, self.contentSizeForViewInPopover.width / 2, 0)];
        }

        DLog(@"self.contentSizeForViewInPopover.width=%f", self.contentSizeForViewInPopover.width);
        DLog(@"self.contentSizeForViewInPopover.height=%f", self.contentSizeForViewInPopover.height);
        DLog(@"pickerView2.bounds.size.height=%f", pickerView2.bounds.size.height);
        DLog(@"pickerView2.bounds.size.width=%f", pickerView2.bounds.size.width);
        
    }else{
        //iPhone
        if([[[UIDevice currentDevice] systemVersion] floatValue] >= 9.0f) {
            [pickerView2 setFrame:CGRectMake(mainRec.size.width / 2, mainRec.size.height - 280, mainRec.size.width / 2, 216)];
        }else{
            //iOS8 以下(厳密にはiOS5~8)
            [pickerView2 setFrame:CGRectMake(mainRec.size.width / 2, mainRec.size.height - 280, mainRec.size.width / 2, 0)];
        }
    }
	[pickerView2 setShowsSelectionIndicator:TRUE];
    if (m_PageTo > 0) {
        [pickerView2 selectRow:m_PageTo-1 inComponent:0 animated:NO];
    }
    
    //ラベル
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        //iPad
        lblSeparate = [[UILabel alloc]initWithFrame:CGRectMake(self.contentSizeForViewInPopover.width / 2 - 10, self.contentSizeForViewInPopover.height - pickerView1.bounds.size.height, 20, pickerView1.bounds.size.height)];
        
        DLog(@"self.contentSizeForViewInPopover.width=%f", self.contentSizeForViewInPopover.width);
        DLog(@"self.contentSizeForViewInPopover.height=%f", self.contentSizeForViewInPopover.height);
        DLog(@"pickerView1.bounds.size.height=%f", pickerView1.bounds.size.height);
        DLog(@"pickerView1.bounds.size.width=%f", pickerView1.bounds.size.width);
        
    }else{
        //iPhone
        if([[[UIDevice currentDevice] systemVersion] floatValue] >= 9.0f) {
            lblSeparate = [[UILabel alloc]initWithFrame:CGRectMake((mainRec.size.width/2)-10, mainRec.size.height - 280, 20, 216)];
        }else{
            //iOS8 以下(厳密にはiOS5~8)
            lblSeparate = [[UILabel alloc]initWithFrame:CGRectMake((mainRec.size.width/2)-10, mainRec.size.height - 280, 20, 215)]; // 元々が215で指定していた為
        }
        
    }
    lblSeparate.backgroundColor = [UIColor clearColor];
    lblSeparate.textColor = [UIColor whiteColor];
    if([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0)
    {   // iOS7以上なら
        lblSeparate.textColor = [UIColor blackColor];
    }
    lblSeparate.font = [UIFont boldSystemFontOfSize:20];
    lblSeparate.textAlignment = NSTextAlignmentCenter;
    lblSeparate.text = @"〜";
    lblSeparate.adjustsFontSizeToFitWidth = YES;
	
	// ピッカーとラベルの表示
	[self.view addSubview:pickerView1];
	[self.view addSubview:pickerView2];
	[self.view addSubview:lblSeparate];

}

// 表示アニメーション
- (void)showViewAnimation {
    //ピッカーを非表示にする
    pickerView1.hidden = NO;
    pickerView2.hidden = NO;
    lblSeparate.hidden = NO;
    
    pickerView1.alpha = 0.0f;
    pickerView2.alpha = 0.0f;
    lblSeparate.alpha = 0.0f;
    
    [UIView animateWithDuration:0.25f delay:0.0f options:UIViewAnimationOptionCurveLinear animations:^{
        
        pickerView1.alpha = 1.0f;
        pickerView2.alpha = 1.0f;
        lblSeparate.alpha = 1.0f;
        
    } completion:^(BOOL finished) {
        
        if (finished) {
        }
        
        
    }];
    
}

// メニュービュー非表示アニメーション
- (void)hideViewAnimation {
    
    pickerView1.alpha = 1.0f;
    pickerView2.alpha = 1.0f;
    lblSeparate.alpha = 1.0f;
    
    [UIView animateWithDuration:0.25f delay:0.0f options:UIViewAnimationOptionCurveLinear animations:^{
        
        pickerView1.alpha = 0.0f;
        pickerView2.alpha = 0.0f;
        lblSeparate.alpha = 0.0f;
        
    } completion:^(BOOL finished) {
        
        if (finished) {
            //ピッカーを非表示にする
            pickerView1.hidden = YES;
            pickerView2.hidden = YES;
            lblSeparate.hidden = YES;
        }
        
    }];
    
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)picker {
	
	// ピッカーの列数
	return 1;
}

- (NSInteger)pickerView:(UIPickerView *)picker numberOfRowsInComponent:(NSInteger)component {
	
	// ピッカーの行数
	return m_PageMax;
}

//
//ピッカーに表示する値を返す
//
//- (NSString *)pickerView:(UIPickerView *)picker titleForRow:(NSInteger)row forComponent:(NSInteger)component {
//	
//	if (component == 0) {
////        NSMutableArray* parrPickerRow = [[NSMutableArray alloc] initWithCapacity:m_PageMax];
////
////        for (NSInteger nIndex = 1; nIndex <= m_PageMax; nIndex++)
////        {
////            [parrPickerRow addObject:[NSString stringWithFormat:@"%d", nIndex]];
////        }
////        
////		return [parrPickerRow objectAtIndex:row];
//        return [NSString stringWithFormat:@"%d", row+1];
//	}
//	else {
//		
//		return @"";
//	}
//}

//
//ピッカーに表示する値を返す
//
- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view {
    UILabel* label = [[UILabel alloc] init];
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        //iPad
        [label setFrame:CGRectMake(0, self.contentSizeForViewInPopover.height - pickerView1.bounds.size.height, 40, pickerView1.bounds.size.height)];
    }else{
        //iPhone
        [label setFrame:CGRectMake(0, [[UIScreen mainScreen] bounds].size.height - 280, 40, 215)];
    }
    [label setText:[NSString stringWithFormat:@"%zd", row+1]];
    [label setTextAlignment:NSTextAlignmentRight];
    [label setFont:[UIFont boldSystemFontOfSize:20]];
    [label setBackgroundColor:[UIColor clearColor]];
    return label;
}

//
//ピッカーの選択行が決まったとき
//
- (void)pickerView:(UIPickerView *)pickerView
      didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    NSInteger picker1 = [pickerView1 selectedRowInComponent:0];
    NSInteger picker2 = [pickerView2 selectedRowInComponent:0];
    //ピッカー値の大小チェック
    if (picker1 > picker2) {
        if (pickerView == pickerView1) {
            [pickerView1 selectRow:picker2 inComponent:0 animated:YES];
            picker1 = picker2;
        }else if(pickerView == pickerView2){
            [pickerView2 selectRow:picker1 inComponent:0 animated:YES];
            picker2 = picker1;
        }
    }
    
    // 左ピッカーの選択された行数を取得
    m_PageFrom = picker1+1;
    // 右ピッカーの選択された行数を取得
    m_PageTo = picker2+1;
}

-(CGFloat)pickerView:
(UIPickerView*)pickerView
   widthForComponent:(NSInteger)component
{
    return 50;
}
@end
