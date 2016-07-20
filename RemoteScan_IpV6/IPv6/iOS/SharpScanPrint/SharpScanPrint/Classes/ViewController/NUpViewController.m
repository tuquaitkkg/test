
#import "NUpViewController.h"
#import "Define.h"
#import "CommonUtil.h"
#import "SharpScanPrintAppDelegate.h"

@interface NUpViewController ()

@end

@implementation NUpViewController

// アクセサメソッドの自動合成(ゲッターとセッターの役割)
//
@synthesize     delegate;
@synthesize     m_parrPickerRow;
@synthesize     m_parrTwoUpPickerRow;
@synthesize     m_parrFourUpPickerRow;
@synthesize     nNupRow;
@synthesize     nSeqRow;

enum{
    PRINT_ONE_UP,
    PRINT_TWO_UP,
    PRINT_FOUR_UP,
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
    
    // デバイスに合わせた設定
    if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
    {
        // popPverのサイズ設定
        self.contentSizeForViewInPopover = CGSizeMake(320.0, 380.0);

    }else{
        // タイトル設定
        CGRect frame = CGRectMake(0, 0, 400, 44);
        UILabel* lblTitle = [[UILabel alloc]initWithFrame:frame];
        lblTitle.backgroundColor = [UIColor clearColor];
        lblTitle.textColor = NAVIGATION_TITLE_COLOR;
        lblTitle.font = [UIFont boldSystemFontOfSize:20];
        lblTitle.textAlignment = NSTextAlignmentCenter;
        lblTitle.text = S_TITLE_N_UP;
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
    
    // ピッカー作成
    [self createPicker];
    
    // 現在の選択値を設定(初期化)
    nNUpStyle = nNupRow;
    
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
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
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
		nRet = 1;
	}
	else if(sectionId == 1)
	{
        if(nNUpStyle != PRINT_ONE_UP){
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
                plblNUpCellTitle = nil;
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
                    
                    nomalCell.accessoryView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:S_IMAGE_PICKER]];
                    plblNUpCellTitle = [[UILabel alloc]initWithFrame:titleLblFrame];
                    plblNUpCellTitle.font = [UIFont systemFontOfSize:[UIFont systemFontSize]];
                    plblNUpCellTitle.backgroundColor = [UIColor clearColor];
                    plblNUpCellTitle.tag = 3;
                    
                    [nomalCell.contentView addSubview:plblNUpCellTitle];
                    
                    // 現在の設定を読み込む
                    nNUpStyle = nNupRow;
                    
                }else{
                    plblNUpCellTitle = (UILabel*)[nomalCell.contentView viewWithTag:3];
                }
                
                // タイトルの設定
                if(plblNUpCellTitle){
                    plblNUpCellTitle.text = [self GetPickerTitle:pickerView1 didSelectRow:nNupRow];
                }
                
                return nomalCell;
            }
            else if (sectionId == 1)
            {
                if(indexPath.row == 0)
                {
                    // -------------
                    // 印刷範囲
                    // -------------
                    UITableViewCell* nomalCell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
                    plblSeqCellTitle = nil;
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
                        
                        nomalCell.accessoryView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:S_IMAGE_PICKER]];
                        plblSeqCellTitle = [[UILabel alloc]initWithFrame:titleLblFrame];
                        plblSeqCellTitle.font = [UIFont systemFontOfSize:[UIFont systemFontSize]];
                        plblSeqCellTitle.backgroundColor = [UIColor clearColor];
                        plblSeqCellTitle.tag = 3;
                        
                        [nomalCell.contentView addSubview:plblSeqCellTitle];
                    }else{
                        plblSeqCellTitle = (UILabel*)[nomalCell.contentView viewWithTag:3];
                    }
                    
                    // タイトルの設定
                    if(plblSeqCellTitle){
                        plblSeqCellTitle.text = [self GetPickerTitle:pickerView2 didSelectRow:nSeqRow];
                    }
                    
                    return nomalCell;
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
    if (section == 0)
    {
    return TABLE_HEADER_HEIGHT_1;
    }
    return TABLE_HEADER_HEIGHT_2;
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
    // ハイライトの解除
    [tableView deselectRowAtIndexPath:[tableView indexPathForSelectedRow] animated:NO];
    
    int sectionId = [[tableSectionIDs objectAtIndex:indexPath.section] intValue];
    if(sectionId == 0)
    {
        // ピッカー表示
        [self changeShowPicker:YES];
        
    }else
    {
        // ピッカー表示
        [self changeShowPicker:NO];
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
        // 1-Up以外
        if(nNUpStyle != PRINT_ONE_UP){
            res = YES;
        }
        else{
            // 「1-Up」の時は非表示
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
            title = S_N_UP_ORDER;
            break;
        default:
            break;
    }
    return title;
}

- (void)cancelAction:(id)sender
{
    if(delegate){
        if([delegate respondsToSelector:@selector(nUpSetting:didSelectedSuccess:)]){
            // デリゲートメソッドの呼び出し(モーダルビューも閉じる)
            [delegate nUpSetting:self didSelectedSuccess:NO];
        }
    }
}

//
// 決定ボタン処理
//
-(IBAction)dosave:(id)sender
{
    if(delegate){
        if([delegate respondsToSelector:@selector(nUpSetting:didSelectedSuccess:)]){
            // デリゲートメソッドの呼び出し(モーダルビューも閉じる)
            [delegate nUpSetting:self didSelectedSuccess:YES];
        }
    }
}

// ピッカーを作成する
- (void)createPicker {
    CGRect mainRec = [[UIScreen mainScreen] bounds];

	// ピッカーの作成
    pickerView1 = [[UIPickerView alloc] init];
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        //iPad
        if([[[UIDevice currentDevice] systemVersion] floatValue] >= 9.0f){
            [pickerView1 setFrame:CGRectMake(0, self.contentSizeForViewInPopover.height - pickerView1.bounds.size.height, self.contentSizeForViewInPopover.width, pickerView1.bounds.size.height)];
        }else{
            //iOS8 以下(厳密にはiOS5~8)
            [pickerView1 setFrame:CGRectMake(0, self.contentSizeForViewInPopover.height - pickerView1.bounds.size.height, self.contentSizeForViewInPopover.width, 0)];
        }

    }else{
        //iPhone
        if([[[UIDevice currentDevice] systemVersion] floatValue] >= 9.0f){
            [pickerView1 setFrame:CGRectMake(0, mainRec.size.height - 280, mainRec.size.width, 216)];
        }else{
            //iOS8 以下(厳密にはiOS5~8)
            [pickerView1 setFrame:CGRectMake(0, mainRec.size.height - 280, mainRec.size.width, 0)];
        }
    }
	pickerView1.delegate = self;
	pickerView1.showsSelectionIndicator = YES;
    pickerView2 = [[UIPickerView alloc] init];
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        //iPad
        if([[[UIDevice currentDevice] systemVersion] floatValue] >= 9.0f) {
            [pickerView2 setFrame:CGRectMake(0, self.contentSizeForViewInPopover.height - pickerView2.bounds.size.height, self.contentSizeForViewInPopover.width, pickerView1.bounds.size.height)];
        }
        else {
            //iOS8 以下(厳密にはiOS5~8)
            [pickerView2 setFrame:CGRectMake(0, self.contentSizeForViewInPopover.height - pickerView2.bounds.size.height, self.contentSizeForViewInPopover.width, 0)];
        }
        
    }else{
        //iPhone
        if([[[UIDevice currentDevice] systemVersion] floatValue] >= 9.0f){
            [pickerView2 setFrame:CGRectMake(0, mainRec.size.height - 280, mainRec.size.width, 216)];
        }
        else {
            //iOS8 以下(厳密にはiOS5~8)
            [pickerView2 setFrame:CGRectMake(0, mainRec.size.height - 280, mainRec.size.width, 0)];
        }
    }
	pickerView2.delegate = self;
	pickerView2.showsSelectionIndicator = YES;
    
	// ピッカーの表示
	[self.view addSubview:pickerView1];
	[self.view addSubview:pickerView2];
    
    [pickerView1 selectRow:nNupRow inComponent:0 animated:NO];
    [pickerView2 selectRow:nSeqRow inComponent:0 animated:NO];
    
    pickerView2.hidden = YES;

}

// 表示するピッカーを切り替える
- (void)changeShowPicker:(BOOL)bNUpPicker
{
    if(bNUpPicker)
    {
        pickerView1.hidden = NO;
        pickerView2.hidden = YES;
    }else
    {
        pickerView1.hidden = YES;
        pickerView2.hidden = NO;
        
        [pickerView2 reloadAllComponents];
        
        [pickerView2 selectRow:nSeqRow inComponent:0 animated:NO];
    }
}

// ピッカーの列数を指定する
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)picker {
	
	// ピッカーの列数
	return 1;
}

// ピッカーの行数を指定する
- (NSInteger)pickerView:(UIPickerView *)picker numberOfRowsInComponent:(NSInteger)component {
	
    if(picker == pickerView1){
        // ピッカーの行数
        return [m_parrPickerRow count];
    }else{
        NSInteger nPickerRow = 0;
        switch (nNUpStyle) {
            case PRINT_TWO_UP:
                nPickerRow = [m_parrTwoUpPickerRow count];
                break;
            case PRINT_FOUR_UP:
                nPickerRow = [m_parrFourUpPickerRow count];
                break;
            default:
                break;
        }
        // 順序のピッカーに表示する行数
        return nPickerRow;
    }
}

// ピッカーに表示するタイトルを指定する
- (NSString *)pickerView:(UIPickerView *)picker titleForRow:(NSInteger)row forComponent:(NSInteger)component {

    return [self GetPickerTitle:picker didSelectRow:row];
}

// ピッカーの値選択時の動作
- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    // N-Up設定ピッカーの場合
    if(pickerView == pickerView1)
    {
        if(nNUpStyle != row){
            if([m_parrPickerRow count] > row){
                plblNUpCellTitle.text = [m_parrPickerRow objectAtIndex:row];
            }
            nNUpStyle = nNupRow = row;
            nSeqRow = 0;
            plblSeqCellTitle.text = [self GetPickerTitle:pickerView2 didSelectRow:0];
            [pickerView2 selectRow:0 inComponent:0 animated:NO];
            // セクションの削除と挿入
            [self sectionDeleteAndInsert];
        }
    }else{
        nSeqRow = row;
        plblSeqCellTitle.text = [self GetPickerTitle:pickerView2 didSelectRow:nSeqRow];
    }
}

// 指定したピッカーに表示するタイトルを取得する
- (NSString*)GetPickerTitle:(UIPickerView *)pickerView
               didSelectRow:(NSInteger)row
{
    if(pickerView == pickerView1)
    {
        // N-Up設定ピッカーに表示するタイトル
        return [m_parrPickerRow objectAtIndex:row];
    }
    else if(pickerView == pickerView2)
    {
        NSString* pstrPickerTitle = @"";
        switch (nNUpStyle) {
            case PRINT_TWO_UP:
                if([m_parrTwoUpPickerRow count] > row)
                {
                    pstrPickerTitle = [m_parrTwoUpPickerRow objectAtIndex:row];
                }
                else
                {
                    pstrPickerTitle = [m_parrTwoUpPickerRow objectAtIndex:0];
                    [pickerView2 selectRow:0 inComponent:0 animated:NO];
                }
                break;
            case PRINT_FOUR_UP:
                if([m_parrFourUpPickerRow count] > row)
                {
                    pstrPickerTitle = [m_parrFourUpPickerRow objectAtIndex:row];
                }
                else
                {
                    pstrPickerTitle = [m_parrFourUpPickerRow objectAtIndex:0];
                    [pickerView2 selectRow:0 inComponent:0 animated:NO];
                }
                break;
            default:
                break;
        }
        // 順序のピッカーに表示するタイトル
        return pstrPickerTitle;
    }
    else{
        return @"";
    }
}

@end
