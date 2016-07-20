
#import "FinishingViewController.h"
#import "Define.h"
#import "CommonUtil.h"
#import "SharpScanPrintAppDelegate.h"

@interface FinishingViewController ()

@end

@implementation FinishingViewController

// アクセサメソッドの自動合成(ゲッターとセッターの役割)
//
@synthesize     delegate;
@synthesize     m_parrClosingPickerRow;
@synthesize     m_parrStaplePickerRow;
@synthesize     m_parrPunchPickerRow;
@synthesize     nClosingRow;
@synthesize     nStapleRow;
@synthesize     nPunchRow;
@synthesize     noVisibleStaple;
@synthesize     noVisiblePunch;

enum{
    CLOSING_LEFT,
    CLOSING_RIGHT,
    CLOSING_TOP
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
        // popOverのサイズ設定
        self.contentSizeForViewInPopover = CGSizeMake(320.0, 460.0);
        
    }else{
        // タイトル設定
        CGRect frame = CGRectMake(0, 0, 400, 44);
        UILabel* lblTitle = [[UILabel alloc]initWithFrame:frame];
        lblTitle.backgroundColor = [UIColor clearColor];
        lblTitle.textColor = NAVIGATION_TITLE_COLOR;
        lblTitle.font = [UIFont boldSystemFontOfSize:20];
        lblTitle.textAlignment = NSTextAlignmentCenter;
        lblTitle.text = S_TITLE_FINISHING;
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
    
    int itemCount = 3;

    // テーブルのセクションIDリストを初期化
    tableSectionIDs = [[NSMutableArray alloc]init];
    for(int i = 0; i < itemCount; i++){
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
        nRet = 1;
    }
    else if(sectionId == 2)
    {
        nRet = 1;
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

            // とじ位置
            if (sectionId == 0){
                return [self getBindingSection:tableView cellForRowAtIndexPath:indexPath];
                
            // ステープル
            } else if(sectionId == 1) {
                return [self getStapleSection:tableView cellForRowAtIndexPath:indexPath];
                
            // パンチ
            } else if(sectionId == 2) {
                return [self getPunchSection:tableView cellForRowAtIndexPath:indexPath];
                
            }

        }
        @finally
        {
        }
    }
    return nil; //ビルド警告回避用
}

// とじ位置
- (UITableViewCell *)getBindingSection:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    // とじ位置の設定
    if(indexPath.row == 0) {
        return [self getBindingSetting:tableView cellForRowAtIndexPath:indexPath];
        
    } else {
        return nil; //ビルド警告回避用
    }
}

// ステープル
- (UITableViewCell *)getStapleSection:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    // ステープルの設定
    if(indexPath.row == 0) {
        return [self getStapleSetting:tableView cellForRowAtIndexPath:indexPath];
        
    } else {
        return nil; //ビルド警告回避用
    }
}

// パンチ
- (UITableViewCell *)getPunchSection:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    // パンチの設定
    if(indexPath.row == 0) {
        return [self getPunchSetting:tableView cellForRowAtIndexPath:indexPath];
        
    } else {
        return nil; //ビルド警告回避用
    }
}

// とじ位置の設定
- (UITableViewCell *)getBindingSetting:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *CellIdentifier = [NSString stringWithFormat:@"Cell%02ld%02ld", (long)indexPath.section, (long)indexPath.row];
    
    // -------------
    // とじ位置
    // -------------
    UITableViewCell* nomalCell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    plblClosingCellTitle = nil;
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
        plblClosingCellTitle = [[UILabel alloc]initWithFrame:titleLblFrame];
        plblClosingCellTitle.font = [UIFont systemFontOfSize:[UIFont systemFontSize]];
        plblClosingCellTitle.backgroundColor = [UIColor clearColor];
        plblClosingCellTitle.tag = 3;
        
        [nomalCell.contentView addSubview:plblClosingCellTitle];
        
    }else{
        plblClosingCellTitle = (UILabel*)[nomalCell.contentView viewWithTag:3];
    }
    
    // タイトルの設定
    if(plblClosingCellTitle){
        plblClosingCellTitle.text = [self GetPickerTitle:pickerView1 didSelectRow:nClosingRow];
    }
    
    return nomalCell;
}

// ステープルの設定
- (UITableViewCell *)getStapleSetting:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *CellIdentifier = [NSString stringWithFormat:@"Cell%02ld%02ld", (long)indexPath.section, (long)indexPath.row];
    
    // -------------
    // ステープル
    // -------------
    UITableViewCell* nomalCell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    plblStapleCellTitle = nil;
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
        
        plblStapleCellTitle = [[UILabel alloc]initWithFrame:titleLblFrame];
        plblStapleCellTitle.font = [UIFont systemFontOfSize:[UIFont systemFontSize]];
        plblStapleCellTitle.backgroundColor = [UIColor clearColor];
        plblStapleCellTitle.tag = 3;
        
        if (self.canStaple) {
            nomalCell.accessoryView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:S_IMAGE_PICKER]];
            nomalCell.selectionStyle = UITableViewCellSelectionStyleDefault;
        }
        else {
            nomalCell.selectionStyle = UITableViewCellSelectionStyleNone;
            plblStapleCellTitle.textColor = UNABLE_TEXT_COLOR;
        }

        [nomalCell.contentView addSubview:plblStapleCellTitle];
    }else{
        plblStapleCellTitle = (UILabel*)[nomalCell.contentView viewWithTag:3];
    }
    
    // タイトルの設定
    if(plblStapleCellTitle){
        plblStapleCellTitle.text = [self GetPickerTitle:pickerView2 didSelectRow:nStapleRow];
    }
    
    return nomalCell;
}

// パンチの設定
- (UITableViewCell *)getPunchSetting:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *CellIdentifier = [NSString stringWithFormat:@"Cell%02ld%02ld", (long)indexPath.section, (long)indexPath.row];
    
    // -------------
    // パンチ
    // -------------
    UITableViewCell* nomalCell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    plblPunchCellTitle = nil;
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
        
        plblPunchCellTitle = [[UILabel alloc]initWithFrame:titleLblFrame];
        plblPunchCellTitle.font = [UIFont systemFontOfSize:[UIFont systemFontSize]];
        plblPunchCellTitle.backgroundColor = [UIColor clearColor];
        plblPunchCellTitle.tag = 3;
        
        if (self.canPunch) {
            nomalCell.accessoryView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:S_IMAGE_PICKER]];
            nomalCell.selectionStyle = UITableViewCellSelectionStyleDefault;
        }
        else {
            nomalCell.selectionStyle = UITableViewCellSelectionStyleNone;
            plblPunchCellTitle.textColor = UNABLE_TEXT_COLOR;
        }
        
        [nomalCell.contentView addSubview:plblPunchCellTitle];
    }else{
        plblPunchCellTitle = (UILabel*)[nomalCell.contentView viewWithTag:3];
    }
    
    // タイトルの設定
    if(plblPunchCellTitle){
        plblPunchCellTitle.text = [self GetPickerTitle:pickerView3 didSelectRow:nPunchRow];
    }
    
    return nomalCell;
}

// 各セルの高さを設定
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return N_HEIGHT_SEL_DEFAULT;
}

// ヘッダーの高さを設定
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return TABLE_HEADER_HEIGHT_2;
}

// フッターの高さを設定
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return TABLE_FOOTER_HEIGHT_1;
}

#pragma mark - Table view delegate
//
// ピッカー表示内容切り替え
//
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // ハイライトの解除
    [tableView deselectRowAtIndexPath:[tableView indexPathForSelectedRow] animated:NO];
    
    // ピッカー表示
    [self changeShowPickerIndex:indexPath];
    
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
    
    if(sectionId == 0){
    }
    else if(sectionId == 1){
        // ステープル機能なしの場合は非表示
        if(noVisibleStaple){
            res = NO;
        }
    }
    else if(sectionId == 2){
        // パンチ機能なしの場合は非表示
        if(noVisiblePunch){
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
            title = S_FINISHING_BINDINGEDGE;
            break;
        case 1:
            title = S_FINISHING_STAPLE;
            break;
        case 2:
            title = S_FINISHING_PUNCH;
            break;
        default:
            break;
    }
    return title;
}

- (void)cancelAction:(id)sender
{
    if(delegate){
        if([delegate respondsToSelector:@selector(finishingSetting:didSelectedSuccess:)]){
            // デリゲートメソッドの呼び出し(モーダルビューも閉じる)
            [delegate finishingSetting:self didSelectedSuccess:NO];
        }
    }
}

//
// 決定ボタン処理
//
-(IBAction)dosave:(id)sender
{
    if(delegate){
        if([delegate respondsToSelector:@selector(finishingSetting:didSelectedSuccess:)]){
            // デリゲートメソッドの呼び出し(モーダルビューも閉じる)
            [delegate finishingSetting:self didSelectedSuccess:YES];
        }
    }
}

// ピッカーを作成する
- (void)createPicker {
    // 対象ピッカー作成
    [self makePicker:1];
    [self makePicker:2];
    [self makePicker:3];
    
    // ピッカーの表示
    [self.view addSubview:pickerView1];
    [self.view addSubview:pickerView2];
    [self.view addSubview:pickerView3];
    
    [pickerView1 selectRow:nClosingRow inComponent:0 animated:NO];
    [pickerView2 selectRow:nStapleRow inComponent:0 animated:NO];
    [pickerView3 selectRow:nPunchRow inComponent:0 animated:NO];
    
    pickerView2.hidden = YES;
    pickerView3.hidden = YES;
}

// ピッカーを作成する
- (void)makePicker:(int)pickerId {
    CGRect mainRec = [[UIScreen mainScreen] bounds];
    
    // ピッカーの作成
    UIPickerView *pickerView = [[UIPickerView alloc] init];
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        //iPad
        if([[[UIDevice currentDevice] systemVersion] floatValue] >= 9.0f) {
            [pickerView setFrame:CGRectMake(0, self.contentSizeForViewInPopover.height - pickerView.bounds.size.height, self.contentSizeForViewInPopover.width, pickerView.bounds.size.height)];
        }else {
            //iOS8 以下(厳密にはiOS5~8)
            [pickerView setFrame:CGRectMake(0, self.contentSizeForViewInPopover.height - pickerView.bounds.size.height, self.contentSizeForViewInPopover.width, 0)];
        }
        
    }else{
        //iPhone
        if([[[UIDevice currentDevice] systemVersion] floatValue] >= 9.0f) {
            [pickerView setFrame:CGRectMake(0, mainRec.size.height - 280, mainRec.size.width, 216)];
        }
        else {//iOS8 以下(厳密にはiOS5~8)
            [pickerView setFrame:CGRectMake(0, mainRec.size.height - 280, mainRec.size.width, 0)];
        }
        
        //iPhone 3.5インチの場合
        if (mainRec.size.height <= 480) {
            // パンチ欄とピッカーが重なって表示されるので、ピッカーの縦幅を少し小さくする
            CGFloat scale = 0.82;
            // ピッカーの高さを縮小
            CGAffineTransform s0 = CGAffineTransformMakeScale(1.0, scale);
            // ピッカーの高さ位置を調整
            CGAffineTransform t0 = CGAffineTransformMakeTranslation(0, pickerView.bounds.size.height * (1 - scale) / 2);
            // ピッカーを所定の位置に変換
            pickerView.transform = CGAffineTransformConcat(s0, t0);
        }
    }
    pickerView.delegate = self;
    pickerView.showsSelectionIndicator = YES;
    
    if (pickerId == 1) {
        pickerView1 = pickerView;
    } else if (pickerId == 2) {
        pickerView2 = pickerView;
    } else {
        pickerView3 = pickerView;
    }
}

// 表示するピッカーを切り替える
- (void)changeShowPickerIndex:(NSIndexPath *)indexPath
{
    int sectionId = [[tableSectionIDs objectAtIndex:indexPath.section] intValue];

    if(sectionId == 0)
    {
        pickerView1.hidden = NO;
        pickerView2.hidden = YES;
        pickerView3.hidden = YES;
    }else if(sectionId == 1)
    {
        pickerView1.hidden = YES;
        pickerView2.hidden = NO;
        pickerView3.hidden = YES;
    }else
    {
        pickerView1.hidden = YES;
        pickerView2.hidden = YES;
        pickerView3.hidden = NO;
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
        // とじ位置ピッカーの行数
        return [m_parrClosingPickerRow count];
    }else if(picker == pickerView2){
        // ステープルピッカーの行数
        return [m_parrStaplePickerRow count];
    }else{
        // パンチピッカーの行数
        return [m_parrPunchPickerRow count];
    }
}

// ピッカーに表示するタイトルを指定する
- (NSString *)pickerView:(UIPickerView *)picker titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    
    return [self GetPickerTitle:picker didSelectRow:row];
}

// ピッカーの値選択時の動作
- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    // とじ位置設定ピッカーの場合
    if(pickerView == pickerView1)
    {
        nClosingRow = row;
        plblClosingCellTitle.text = [self GetPickerTitle:pickerView1 didSelectRow:nClosingRow];

    // ステープル設定ピッカーの場合
    }else if(pickerView == pickerView2){
        nStapleRow = row;
        plblStapleCellTitle.text = [self GetPickerTitle:pickerView2 didSelectRow:nStapleRow];
        
    }else{
        nPunchRow = row;
        plblPunchCellTitle.text = [self GetPickerTitle:pickerView3 didSelectRow:nPunchRow];
    }
}

// 指定したピッカーに表示するタイトルを取得する
- (NSString*)GetPickerTitle:(UIPickerView *)pickerView
               didSelectRow:(NSInteger)row
{
    if(pickerView == pickerView1)
    {
        // とじ位置設定ピッカーに表示するタイトル
        return [m_parrClosingPickerRow objectAtIndex:row];
    }
    else if(pickerView == pickerView2)
    {
        // ステープル設定ピッカーに表示するタイトル
        return [m_parrStaplePickerRow objectAtIndex:row];

    }
    else if(pickerView == pickerView3)
    {
        // パンチ設定ピッカーに表示するタイトル
        return [m_parrPunchPickerRow objectAtIndex:row];
        
    }
    else{
        return @"";
    }
}

// セル選択不可設定
-(NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    int sectionId = [[tableSectionIDs objectAtIndex:indexPath.section] intValue];

    if (!self.canStaple) {
        // ステープル非活性
        if (sectionId == 1) {
            return nil;
        }
    }
    if (!self.canPunch) {
        // パンチ非活性
        if (sectionId == 2) {
            return nil;
        }
    }
    return indexPath;
}


@end
