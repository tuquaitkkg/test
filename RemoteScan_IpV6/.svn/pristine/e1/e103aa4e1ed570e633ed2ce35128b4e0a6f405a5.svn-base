
#import "RSS_ManuscriptViewController.h"
#import "RemoteScanBeforePictViewController.h"

// セクションデータ
enum {
    kSectionGenkouSize = 0,     // 原稿サイズ
    kSectionKenchiSize,     // 検知サイズ
    kSectionSaveSize,       // 保存サイズ
    kSectionCustomSize,     // カスタムサイズ
    kSectionCellSize,       // セルサイズ

    kSectionMaxCount,       // セクションデータ最大件数
};

@interface RSS_ManuscriptViewController ()

@end

@implementation RSS_ManuscriptViewController
@synthesize parentVCDelegate, strOriginalSize;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (id)initWithManuscriptTypeArray:(NSArray*)mArray saveSizeArray:(NSArray*)sArray delegate:(RemoteScanBeforePictViewController *)delegate
{
    self = [super initWithNibName:@"RSS_ManuscriptViewController" bundle:nil];
    if (self) {
        parentVCDelegate = delegate;

        // 原稿サイズの初期化
        manuscriptSizeList = [[NSArray alloc]initWithArray:mArray];
        m_nSelectedManuscriptSizeIndexRow = [parentVCDelegate.rssViewData.originalSize getSelectIndex];

        // 保存サイズの初期化
        saveSizeList = [[NSArray alloc]initWithArray:sArray];
        m_nSelectedSaveSizeIndexRow = [parentVCDelegate.rssViewData.sendSize getSelectIndex];

        // 画像セットの方向の初期化
        manuscriptSetList = [[NSArray alloc]initWithArray:[parentVCDelegate.rssViewData.rotation getSelectableArray]];
        m_nSelectedManuscriptSetIndexRow = [parentVCDelegate.rssViewData.rotation getSelectIndex];

    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    // セルのラインを表示する
    manuscriptTableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    
    // スクロールが必要
    manuscriptTableView.scrollEnabled = YES;


    // アイコン画像設定
//    UIImage* pIconImage = (m_nSelectedManuscriptSetIndexRow ? [UIImage imageNamed: @"RemoteScanOrientationH"]:[UIImage imageNamed: @"RemoteScanOrientationV"]);
//    manuscriptSetImageView.image = pIconImage;

    // タイトル設定
    CGRect frame = CGRectMake(0, 0, 400, 44);
    UILabel* lblTitle = [[UILabel alloc]initWithFrame:frame];
    lblTitle.backgroundColor = [UIColor clearColor];
    lblTitle.textColor = NAVIGATION_TITLE_COLOR;
    lblTitle.font = [UIFont boldSystemFontOfSize:20];
    lblTitle.textAlignment = NSTextAlignmentCenter;
    lblTitle.text = S_TITLE_MANUSCRIPT;
    lblTitle.adjustsFontSizeToFitWidth = YES;
    self.navigationItem.titleView = lblTitle;
    //self.navigationItem.title = S_TITLE_MANUSCRIPT;
    //    if(parentVCDelegate){
    //        [parentVCDelegate setNavigationBarTitle:S_TITLE_MANUSCRIPT leftButton:nil rightButton:nil];
    //    }

    // 戻るボタン(次のビュー用)
    UIBarButtonItem * barItemBack = [UIBarButtonItem new];
    barItemBack.title = S_BUTTON_BACK;
    self.navigationItem.backBarButtonItem = barItemBack;
    
    // 保存ボタンの設定
    UIBarButtonItem* btnSave = [[UIBarButtonItem alloc] initWithTitle:S_BUTTON_SAVEVAL style:UIBarButtonItemStyleDone target:self action:@selector(dosave:)];
    
    self.navigationItem.rightBarButtonItem = btnSave;
    
    // コントロールの設定
    [self setScOrientation];

    // セクションデータ
    m_sections = [[NSMutableArray alloc] initWithObjects:
                  [NSNumber numberWithInteger: kSectionGenkouSize],
                  [NSNumber numberWithInteger: kSectionKenchiSize],
                  [NSNumber numberWithInteger: kSectionSaveSize],
                  [NSNumber numberWithInteger: kSectionCustomSize],
                  [NSNumber numberWithInteger: kSectionCellSize],
                  nil];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];

    manuscriptSizeList = nil;
//
//    RemoteScanSettingViewData * rssViewData = [[[RemoteScanSettingViewData alloc] initWithRSSettableElementsData:
//                                                [parentVCDelegate.rsManager rsSettableElementsData]]
//                                               autorelease];
//
//    // ファイルに保存されているデータから原稿サイズのみ取得し直す
    parentVCDelegate.rssViewData.originalSize = [parentVCDelegate.rssViewData reloadOriginalSize:[parentVCDelegate.rsManager rsSettableElementsData] ManuscriptSizeIndexRow:m_nSelectedManuscriptSizeIndexRow];

    manuscriptSizeList = [[NSArray alloc] initWithArray:[parentVCDelegate.rssViewData.originalSize getSelectableArray]];
    m_nSelectedManuscriptSizeIndexRow = [parentVCDelegate.rssViewData.originalSize getSelectIndex];
    
    // カスタムサイズ(名刺含む)が選択されている場合
    NSUInteger originalSizeCount = [[parentVCDelegate.rssViewData.originalSize getSelectableArray] count];
    originalSizeCount -= [[parentVCDelegate.rssViewData.customSizeListData getPaperSizeArray] count];
    originalSizeCount -= [[parentVCDelegate.rssViewData.extraSizeListData getPaperSizeArray] count];
    
    //現在の検知サイズの表示/非表示設定
    if (m_nSelectedManuscriptSizeIndexRow > 0)
    {//原稿サイズ自動以外
        // 原稿サイズ検知セクション存在チェック
        if ([m_sections containsObject:[NSNumber numberWithInteger: kSectionKenchiSize]] == YES)
        {// 現在の検知サイズセクションあり
            // 現在の検知サイズセクションを削除する
            [m_sections removeObject: [NSNumber numberWithInteger: kSectionKenchiSize]];
            
            // テーブルビューから削除する
            [manuscriptTableView deleteSections: [NSIndexSet indexSetWithIndex: kSectionKenchiSize]
                               withRowAnimation: UITableViewRowAnimationAutomatic];
        }
    }
    else
    {//原稿サイズ自動のとき
        // 原稿サイズ検知セクション存在チェック
        if ([m_sections containsObject:[NSNumber numberWithInteger: kSectionKenchiSize]] == NO)
        {// 現在の検知サイズセクションが無いとき
            if([manuscriptSizeList containsObject:strOriginalSize] || [strOriginalSize isEqualToString:S_RS_UNKNOWN])
            {
                // 現在の検知サイズセクションを追加する
                [m_sections insertObject: [NSNumber numberWithInteger: kSectionKenchiSize]
                                 atIndex: kSectionKenchiSize];
                
                // テーブルビューに追加する
                [manuscriptTableView insertSections: [NSIndexSet indexSetWithIndex: kSectionKenchiSize]
                                   withRowAnimation: UITableViewRowAnimationAutomatic];
            }
            
        }
        else
        {// 現在の検知サイズセクションがあるとき
            if(![manuscriptSizeList containsObject:strOriginalSize] && ![strOriginalSize isEqualToString:S_RS_UNKNOWN])
            {
                // 現在の検知サイズセクションを削除する
                [m_sections removeObject: [NSNumber numberWithInteger: kSectionKenchiSize]];
                
                // テーブルビューから削除する
                [manuscriptTableView deleteSections: [NSIndexSet indexSetWithIndex: kSectionKenchiSize]
                                   withRowAnimation: UITableViewRowAnimationAutomatic];
            }
            
        }
    }
    
    //保存サイズの表示/非表示設定
    if (m_nSelectedManuscriptSizeIndexRow > originalSizeCount - 1) {
        //保存サイズに自動を設定
        m_nSelectedSaveSizeIndexRow = 0;
//        [parentVCDelegate.rssViewData.sendSize setSelectValue:0];
        //保存サイズを選択不可に設定
        
        // セクション存在チェック
        if ([m_sections containsObject:[NSNumber numberWithInteger: kSectionSaveSize]] == YES) {
            // 保存サイズセクションを削除する
            [m_sections removeObject: [NSNumber numberWithInteger: kSectionSaveSize]];
            
            // テーブルビューから削除する
            [manuscriptTableView deleteSections: [NSIndexSet indexSetWithIndex: kSectionSaveSize]
                               withRowAnimation: UITableViewRowAnimationAutomatic];
        }
        
    }else if([[parentVCDelegate.rssViewData.originalSize getSelectValue] isEqualToString:@"long"]
                        || [[parentVCDelegate.rssViewData.originalSize getSelectValue] isEqualToString:@"japanese_postcard_a6"])
    {
        //保存サイズに自動を設定
        m_nSelectedSaveSizeIndexRow = 0;
//        [parentVCDelegate.rssViewData.sendSize setSelectValue:0];
        //保存サイズを選択不可に設定
        
        // セクション存在チェック
        if ([m_sections containsObject:[NSNumber numberWithInteger: kSectionSaveSize]] == YES) {
            // 保存サイズセクションを削除する
            [m_sections removeObject: [NSNumber numberWithInteger: kSectionSaveSize]];
            
            // テーブルビューから削除する
            [manuscriptTableView deleteSections: [NSIndexSet indexSetWithIndex: kSectionSaveSize]
                               withRowAnimation: UITableViewRowAnimationAutomatic];
        }
    } else {
        // セクション存在チェック
        if ([m_sections containsObject:[NSNumber numberWithInteger: kSectionSaveSize]] == NO) {
            // 保存サイズセクションを追加する
            [m_sections insertObject: [NSNumber numberWithInteger: kSectionSaveSize]
                             atIndex: kSectionSaveSize];
            
            // テーブルビューに追加する
            [manuscriptTableView insertSections: [NSIndexSet indexSetWithIndex: kSectionSaveSize]
                               withRowAnimation: UITableViewRowAnimationAutomatic];
        }
    }

    // テーブルビューへ反映
    [manuscriptTableView reloadData];
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
    childVC = nil;
    self.parentVCDelegate = nil;

    manuscriptTableView = nil;

    m_sections = nil;
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}


#pragma mark - Setter / Getter
-(NSString*)strOriginalSize
{
    return strOriginalSize;
}

/*
 * 約２秒ごとに呼ばれる。
 */
-(void)setStrOriginalSize:(NSString*)str
{
    if([strOriginalSize isEqualToString:str])return;
    
    strOriginalSize = str;
    
    if (m_nSelectedManuscriptSizeIndexRow == 0)
    {//原稿サイズが自動の場合
        
        if([manuscriptSizeList containsObject:strOriginalSize] || [strOriginalSize isEqualToString:S_RS_UNKNOWN])
        {//サイズリストに現在の通知サイズが存在する、または　現在の通知サイズがunknownであるとき
            if(![m_sections containsObject:[NSNumber numberWithInteger:kSectionKenchiSize]])
            {
                // 現在の検知サイズセクションを追加する
                [m_sections insertObject: [NSNumber numberWithInteger: kSectionKenchiSize]
                                 atIndex: kSectionKenchiSize];
                [manuscriptTableView insertSections:[NSIndexSet indexSetWithIndex:kSectionKenchiSize]
                                   withRowAnimation:UITableViewRowAnimationFade];
            }
        }
        else
        {//そうでないとき
            if([m_sections containsObject:[NSNumber numberWithInteger:kSectionKenchiSize]])
            {
                // 現在の検知サイズセクションを削除する
                [m_sections removeObject:[NSNumber numberWithInteger:kSectionKenchiSize]];
                [manuscriptTableView deleteSections:[NSIndexSet indexSetWithIndex:kSectionKenchiSize]
                                   withRowAnimation:UITableViewRowAnimationFade];
            }
        }
        
        if ([m_sections containsObject:[NSNumber numberWithInteger: kSectionKenchiSize]] == YES)
        {//原稿検知サイズセクションが表示中のときは、単に更新する。
            [manuscriptTableView reloadData];
        }
    }
}

#pragma mark - UITableViewDelegate
// セクション数
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [m_sections count];
}

// セルの数
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSInteger sectionNum = [[m_sections objectAtIndex: section] intValue];
    if( sectionNum == kSectionCellSize )
    {
        return 0;
    }
    return 1;
}

// テーブルセルの作成
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{

//    static NSString *CellIdentifier = @"Cell";
    NSString *CellIdentifier = [NSString stringWithFormat:@"Cell%02ld%02ld", (long)indexPath.section, (long)indexPath.row];
    
    // セル作成
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    UILabel* titleLbl = nil;
    
    if(cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        cell.tag = indexPath.section;

        // タイトルラベルの作成
        CGRect titleLblFrame = cell.contentView.frame;
        
        if([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0)
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
        titleLbl.font = [UIFont systemFontOfSize:14];
        titleLbl.backgroundColor = [UIColor clearColor];
        titleLbl.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        titleLbl.adjustsFontSizeToFitWidth = YES;
        titleLbl.minimumScaleFactor = 6 / titleLbl.font.pointSize;
        titleLbl.tag = 3;

        [cell.contentView addSubview:titleLbl];

    }else{
        titleLbl = (UILabel*)[cell.contentView viewWithTag:3];
    }
    cell.exclusiveTouch = YES; // 同時押し禁止

    // セルタイトル
    cell.accessoryView = nil;
    switch ( [[m_sections objectAtIndex: indexPath.section] intValue] ) {
        default:
        case kSectionGenkouSize:
            // 原稿サイズ
            titleLbl.text = [manuscriptSizeList objectAtIndex:m_nSelectedManuscriptSizeIndexRow];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.accessoryView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:S_IMAGE_PICKER]];

            break;
        case kSectionKenchiSize:
            // 現在の検知サイズ
            titleLbl.text = strOriginalSize;
            cell.textLabel.lineBreakMode = NSLineBreakByWordWrapping;
            cell.textLabel.numberOfLines = 2;
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.accessoryType = UITableViewCellAccessoryNone;
            break;
        case kSectionSaveSize:
            // 保存サイズ
            titleLbl.text = [saveSizeList objectAtIndex:m_nSelectedSaveSizeIndexRow];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.accessoryView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:S_IMAGE_PICKER]];
            break;
        case kSectionCustomSize:
            // カスタムサイズの登録
            titleLbl.text = S_MANUSCRIPT_CUSTOMSIZE_REGISTER;
            cell.textLabel.lineBreakMode = NSLineBreakByWordWrapping;
            cell.textLabel.numberOfLines = 2;
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            break;
        case kSectionCellSize:
            // セルタイトル
//            cell.textLabel.text = [manuscriptSetList objectAtIndex:indexPath.row];
            // 選択状態
//            cell.accessoryType = (indexPath.row == m_nSelectedManuscriptSetIndexRow ? UITableViewCellAccessoryCheckmark:UITableViewCellAccessoryNone);
//
//            // アイコン
//            CGRect rectImage = CGRectMake(RSS_MANUSCRIPT_IMAGE_X, RSS_MANUSCRIPT_IMAGE_Y, RSS_MANUSCRIPT_IMAGE_W, RSS_MANUSCRIPT_IMAGE_H);
//            manuscriptSetImageView = [[UIImageView alloc] initWithFrame:rectImage];
//            
//            UIImage* pIconImage = (indexPath.row ? [UIImage imageNamed: S_IMAGE_RSS_MANUSCRIPT_ORIENTATION_H]:[UIImage imageNamed: S_IMAGE_RSS_MANUSCRIPT_ORIENTATION_V]);
//            manuscriptSetImageView.image = pIconImage;

//            [cell addSubview:manuscriptSetImageView];
            break;
    }


    return cell;

}

// テーブルセルのタッチ判定
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // ハイライトOFF
    [tableView deselectRowAtIndexPath:indexPath animated:YES];

    // セルの取得
    //UITableViewCell * cell = [tableView cellForRowAtIndexPath:indexPath];
    m_nSelPicker = [[m_sections objectAtIndex: indexPath.section] intValue];

    switch (m_nSelPicker) {
        default:
        case kSectionGenkouSize:
            // 原稿サイズ
            [self showFormatSettingPickerViewFromCell];
            break;
        case kSectionKenchiSize:
            // 現在の検知サイズ
            break;
        case kSectionSaveSize:
            // 保存サイズ
        {
            // 原稿サイズの選択値がカスタムサイズの場合は選択不可
            NSUInteger originalSizeCount = [[parentVCDelegate.rssViewData.originalSize getSelectableArray] count];
            originalSizeCount -= [[parentVCDelegate.rssViewData.customSizeListData getPaperSizeArray] count];
            originalSizeCount -= [[parentVCDelegate.rssViewData.extraSizeListData getPaperSizeArray] count];
            
            if (m_nSelectedManuscriptSizeIndexRow <= originalSizeCount - 1) {
                [self showFormatSettingPickerViewFromCell];
            }
        }
            break;
        case kSectionCustomSize:
        {
            // カスタムサイズの登録
            [parentVCDelegate OnCustomSizeList];
            break;
        }
        case kSectionCellSize:
//            // 画像セットの方向
//            // ハイライトOFF
//            [tableView deselectRowAtIndexPath:indexPath animated:YES];
//
//            // 選択番号の更新
//            m_nSelectedManuscriptSetIndexRow = indexPath.row;
//            // チェックの設定
//            for(int i = 0; i < [manuscriptSetList count]; i++){
//                UITableViewCell * cell = [tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:i inSection:indexPath.section]];
//                int accessory = UITableViewCellAccessoryNone;
//                if(i == indexPath.row){
//                    accessory = UITableViewCellAccessoryCheckmark;
//                }
//
//                [cell setAccessoryType:accessory];
//            }

            // 設定を保存
//            [parentVCDelegate.rssViewData.rotation setSelectValue:indexPath.row];

            // 画像更新
//            UIImage* pIconImage = (m_nSelectedManuscriptSetIndexRow ? [UIImage imageNamed: @"RemoteScanOrientationH"]:[UIImage imageNamed: @"RemoteScanOrientationV"]);
//            manuscriptSetImageView.image = pIconImage;

            break;
    }
}

// 各セクションのタイトルを決定する
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    NSString *title = @"";
    switch ( [[m_sections objectAtIndex: section] intValue] ) {
        case kSectionGenkouSize:
            title = S_TITLE_MANUSCRIPT_SIZE;
            break;
        case kSectionKenchiSize:
            title = S_TITLE_MANUSCRIPT_CURRENT_SIZE;
            break;
        case kSectionSaveSize:
            title = S_TITLE_MANUSCRIPT_SAVE_SIZE;
            break;
        case kSectionCustomSize:
            title = @"";
            break;
        case kSectionCellSize:
            title = S_TITLE_MANUSCRIPT_SET;
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

    NSInteger sectionNum = [[m_sections objectAtIndex: section] intValue];

    if(sectionNum == kSectionSaveSize){
        // 保存サイズ
        // ビューを作成
        returnView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, tableView.bounds.size.width, 40)];

        // タイトルラベル作成
        UILabel* titleLbl = [[UILabel alloc]initWithFrame:CGRectMake(20, 0, tableView.bounds.size.width - 20, 32)];
        [titleLbl setNumberOfLines:0];
        [titleLbl setBackgroundColor:[UIColor clearColor]];
        [titleLbl setTextColor:[UIColor colorWithRed:0.29f green:0.34f blue:0.43f alpha:1.00f]];
        [titleLbl setShadowColor:[UIColor whiteColor]];
        [titleLbl setShadowOffset:CGSizeMake(0, 1)];
        [titleLbl setText:S_FOOTER_MANUSCRIPT_SAVE_SIZE];

        // フォントサイズを調整
        [titleLbl setFont:[UIFont boldSystemFontOfSize:12.0]];
        
        if([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0)
        {   // iOS7以上
            [titleLbl setFont:[UIFont systemFontOfSize:12.0]];
            [titleLbl setTextColor:[UIColor grayColor]];
        }
        [titleLbl sizeToFit];

        [returnView addSubview:titleLbl];
    }else if(sectionNum == kSectionCellSize){
        // 画像セットの方向
    }

    return returnView;
}

// 各セクションタイトルの高さを設定
-(CGFloat) tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if ([[m_sections objectAtIndex: section] intValue] == kSectionCustomSize) {
        return TABLE_HEADER_HEIGHT_1;
    }
    return TABLE_HEADER_HEIGHT_2;
//    CGFloat h = 46.0;
//
//    NSInteger sectionNum = [[m_sections objectAtIndex: section] intValue];
//
//    if(sectionNum == kSectionCustomSize){
//        // タイトルラベル作成
//        UILabel* titleLbl = [[[UILabel alloc]initWithFrame:CGRectMake(20, 0, tableView.bounds.size.width - 20, 32)]autorelease];
//        [titleLbl setNumberOfLines:0];
//        [titleLbl setShadowColor:[UIColor whiteColor]];
//        [titleLbl setShadowOffset:CGSizeMake(0, 1)];
//        [titleLbl setText:S_FOOTER_MANUSCRIPT_SAVE_SIZE];
//
//        // フォントサイズを調整
//        [titleLbl setFont:[UIFont boldSystemFontOfSize:12.0]];
//        [titleLbl sizeToFit];
//
//        h += titleLbl.frame.size.height - 32;
//        h -= 32;
//    }
//
//    return h;
}

// 各セクションフッターの高さを設定
-(CGFloat) tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    CGFloat footerHeight = TABLE_FOOTER_HEIGHT_1;

    NSInteger sectionNum = [[m_sections objectAtIndex: section] intValue];

    if(sectionNum == kSectionSaveSize){
        footerHeight = TABLE_FOOTER_HEIGHT_2;
    }
    return footerHeight;
}

// テーブルビューの縦幅設定
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
//    NSInteger sectionNum = [[m_sections objectAtIndex: indexPath.section] intValue];
//    if(sectionNum == kSectionCellSize)
//    {
//        return N_HEIGHT_RSS_MANUSCRIPT_SEC_ORIENTATION;
//    }
//    else
//    {
        return N_HEIGHT_RSS_MANUSCRIPT_SEC_OTHER;
//    }
}

#pragma mark - PickerView Manage
-(void)showFormatSettingPickerViewFromCell
{
    //    // Picker表示用View設定
    //    PickerViewController *pickerViewController;
    //    pickerViewController = [[PickerViewController alloc] init];

    NSMutableArray* setArray = [NSMutableArray array];
    NSUInteger nSelRow = 0;
    switch (m_nSelPicker) {
        case kSectionGenkouSize:
            // 原稿サイズ
            [setArray addObjectsFromArray:manuscriptSizeList];
            nSelRow = m_nSelectedManuscriptSizeIndexRow;
            break;
        case kSectionKenchiSize:
            // 現在の検知サイズ
            break;
        case kSectionSaveSize:
            // 保存サイズ
            [setArray addObjectsFromArray:saveSizeList];
            nSelRow = m_nSelectedSaveSizeIndexRow;
            break;

        default:
            // 例外処理
            return;
            break;
    }

    m_parrPickerRow = [setArray copy];
    m_nSelRow = nSelRow;
    m_bSets = NO;
    m_bScanPrint = NO;

    // ピッカー表示
    [super showPickerView];
}


// 決定ボタン押下時の処理
- (IBAction)OnMenuDecideButton:(id)sender
{

    // iPhone用 getPickerValueActionで行っていた処理をここで行う
    // 値の格納
    switch (m_nSelPicker) {
        case kSectionGenkouSize:
            // 原稿サイズ
            m_nSelectedManuscriptSizeIndexRow = m_nSelRow;
//            [parentVCDelegate.rssViewData.originalSize setSelectValue:m_nSelRow];
            // カスタムサイズ(名刺含む)が選択されている場合
            NSUInteger originalSizeCount = [[parentVCDelegate.rssViewData.originalSize getSelectableArray] count];
            originalSizeCount -= [[parentVCDelegate.rssViewData.customSizeListData getPaperSizeArray] count];
            originalSizeCount -= [[parentVCDelegate.rssViewData.extraSizeListData getPaperSizeArray] count];
            
            //現在の検知サイズの表示/非表示設定
            if (m_nSelectedManuscriptSizeIndexRow > 0)
            {///自動以外
                // セクション存在チェック
                if ([m_sections containsObject:[NSNumber numberWithInteger: kSectionKenchiSize]] == YES) {
                    // 現在の検知サイズセクションを削除する
                    [m_sections removeObject: [NSNumber numberWithInteger: kSectionKenchiSize]];
                    
                    // テーブルビューから削除する
                    [manuscriptTableView deleteSections: [NSIndexSet indexSetWithIndex: kSectionKenchiSize]
                                       withRowAnimation: UITableViewRowAnimationFade];
                }
            }
            else
            {//自動
                // セクション存在チェック
                if ([m_sections containsObject:[NSNumber numberWithInteger: kSectionKenchiSize]] == NO)
                {// 現在の検知サイズセクションが無いとき
                    
                    if([manuscriptSizeList containsObject:strOriginalSize] || [strOriginalSize isEqualToString:S_RS_UNKNOWN])
                    {//サイズリストに現在の通知サイズが存在する、または　現在の通知サイズがunknownであるとき
                        // 現在の検知サイズセクションを追加する
                        [m_sections insertObject: [NSNumber numberWithInteger: kSectionKenchiSize]
                                         atIndex: kSectionKenchiSize];
                        
                        // テーブルビューに追加する
                        [manuscriptTableView insertSections: [NSIndexSet indexSetWithIndex: kSectionKenchiSize]
                                           withRowAnimation: UITableViewRowAnimationFade];
                    }
                }
                else
                {//現在の検知サイズセクションがあるとき
                    if(![manuscriptSizeList containsObject:strOriginalSize] && ![strOriginalSize isEqualToString:S_RS_UNKNOWN])
                    {//サイズリストに現在の通知サイズが存在しない、かつ現在の通知サイズがunknownではないとき
                        // 現在の検知サイズセクションを削除する
                        [m_sections removeObject: [NSNumber numberWithInteger: kSectionKenchiSize]];
                        
                        // テーブルビューから削除する
                        [manuscriptTableView deleteSections: [NSIndexSet indexSetWithIndex: kSectionKenchiSize]
                                           withRowAnimation: UITableViewRowAnimationFade];
                    }
                }
            }
            
            //保存サイズの表示/非表示設定
            if (m_nSelectedManuscriptSizeIndexRow > originalSizeCount - 1) {
                //保存サイズに自動を設定
                m_nSelectedSaveSizeIndexRow = 0;
//                [parentVCDelegate.rssViewData.sendSize setSelectValue:0];
                
                
                //保存サイズを選択不可に設定

                // セクション存在チェック
                if ([m_sections containsObject:[NSNumber numberWithInteger: kSectionSaveSize]] == YES) {
                    // 保存サイズセクションを削除する
                    [m_sections removeObject: [NSNumber numberWithInteger: kSectionSaveSize]];

                    // テーブルビューから削除する
                    [manuscriptTableView deleteSections: [NSIndexSet indexSetWithIndex: kSectionSaveSize]
                                       withRowAnimation: UITableViewRowAnimationFade];
                }
// 保存ボタンに処理を移動した為、修正
//            }else if([[parentVCDelegate.rssViewData.originalSize getSelectValue] isEqualToString:@"long"]
//                     || [[parentVCDelegate.rssViewData.originalSize getSelectValue] isEqualToString:@"japanese_postcard_a6"])
            }else if([[parentVCDelegate.rssViewData.originalSize getSelectValue:(int)m_nSelectedManuscriptSizeIndexRow] isEqualToString:@"long"]
                     || [[parentVCDelegate.rssViewData.originalSize getSelectValue:(int)m_nSelectedManuscriptSizeIndexRow] isEqualToString:@"japanese_postcard_a6"])
            {
                //保存サイズに自動を設定
                m_nSelectedSaveSizeIndexRow = 0;
//                [parentVCDelegate.rssViewData.sendSize setSelectValue:0];
                
                
                //保存サイズを選択不可に設定
                
                // セクション存在チェック
                if ([m_sections containsObject:[NSNumber numberWithInteger: kSectionSaveSize]] == YES) {
                    // 保存サイズセクションを削除する
                    [m_sections removeObject: [NSNumber numberWithInteger: kSectionSaveSize]];
                    
                    // テーブルビューから削除する
                    [manuscriptTableView deleteSections: [NSIndexSet indexSetWithIndex: kSectionSaveSize]
                                       withRowAnimation: UITableViewRowAnimationFade];
                }
            }
            else {
                // セクション存在チェック
                if ([m_sections containsObject:[NSNumber numberWithInteger: kSectionSaveSize]] == NO) {
                    // 現在の検知サイズセクション存在チェック
                    if ([m_sections containsObject:[NSNumber numberWithInteger: kSectionKenchiSize]] == NO) {
                        // 保存サイズセクションを追加する
                        [m_sections insertObject: [NSNumber numberWithInteger: kSectionSaveSize]
                                         atIndex: kSectionKenchiSize];
                    }else{
                        // 保存サイズセクションを追加する
                        [m_sections insertObject: [NSNumber numberWithInteger: kSectionSaveSize]
                                         atIndex: kSectionSaveSize];
                    }

                    // テーブルビューに追加する
                    [manuscriptTableView insertSections: [NSIndexSet indexSetWithIndex: kSectionSaveSize]
                                       withRowAnimation: UITableViewRowAnimationFade];
                }
            }
//            //ボタンラベルを更新する
//            [parentVCDelegate updateSetting];
            
            if ([self isLongSelected]) {
                // 長尺が選択された場合、画像の向きを固定にする
                m_nSelectedManuscriptSetIndexRow = 0;
                [scOrientation setSelectedSegmentIndex:0];
                [scOrientation setEnabled:NO];
            }
            else {
                [scOrientation setEnabled:YES];
            }

            break;
        case kSectionKenchiSize:
            // 現在の検知サイズ
            break;
        case kSectionSaveSize:
            // 保存サイズ
            m_nSelectedSaveSizeIndexRow = m_nSelRow;
//            [parentVCDelegate.rssViewData.sendSize setSelectValue:m_nSelRow];
            // ボタンラベルを更新する
//            [parentVCDelegate updateSetting];
            break;

        default:
            // 例外処理
            break;
    }

    // テーブルを更新
//    [manuscriptTableView reloadData];
    // ピッカーの閉じるアニメーションと被るため、
    // テーブルのセクション挿入/削除アニメーションを見えるように若干遅らす
    [manuscriptTableView performSelector:@selector(reloadData) withObject:nil afterDelay:0.2];

    //親クラスのメソッド呼び出す（ダイアログを消す）
    [super OnMenuDecideButton:sender];
}

- (void)OnMenuCancelButton:(id)sender
{
    [super OnMenuCancelButton:sender];
}

#pragma mark - set UISegmentedControl
-(void)setScOrientation
{
    UIImage *img_ORIENTATION_H_before = [UIImage imageNamed:S_IMAGE_RSS_MANUSCRIPT_ORIENTATION_H];
    UIImage *img_ORIENTATION_V_before = [UIImage imageNamed:S_IMAGE_RSS_MANUSCRIPT_ORIENTATION_V];
    if([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0)
    {   // iOS7以上なら
        img_ORIENTATION_H_before = [UIImage imageNamed:S_IMAGE_RSS_MANUSCRIPT_ORIENTATION_H2];
        img_ORIENTATION_V_before = [UIImage imageNamed:S_IMAGE_RSS_MANUSCRIPT_ORIENTATION_V2];
    }

    
    UIImage *img_ORIENTATION_H_after;
    UIImage *img_ORIENTATION_V_after;
    
    float widthPer = 0.7;
    float heightPer = 0.7;
    
    // 画像サイズを縮小する
    CGSize sz = CGSizeMake(img_ORIENTATION_H_before.size.width * widthPer, img_ORIENTATION_H_before.size.height * heightPer);
    UIGraphicsBeginImageContext(sz);
    [img_ORIENTATION_H_before drawInRect:CGRectMake(0, 0, sz.width, sz.height)];
    img_ORIENTATION_H_after = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    UIGraphicsBeginImageContext(sz);
    [img_ORIENTATION_V_before drawInRect:CGRectMake(0, 0, sz.width, sz.height)];
    img_ORIENTATION_V_after = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    // 縮小した画像をセットする
    [scOrientation setImage:img_ORIENTATION_V_after forSegmentAtIndex:0];
    [scOrientation setImage:img_ORIENTATION_H_after forSegmentAtIndex:1];
    
    scOrientation.frame = CGRectMake(10, 0, 300, 80);
    
    [scOrientation setSelectedSegmentIndex:m_nSelectedManuscriptSetIndexRow];
    
    // 長尺が選択されている場合は非活性
    if ([self isLongSelected]) {
        [scOrientation setEnabled:NO];
    }
    
}
#pragma mark - UIObject Action
// カラーモード切替
- (IBAction)tapScOrientation:(UISegmentedControl *)sender
{
    m_nSelectedManuscriptSetIndexRow = sender.selectedSegmentIndex;
}
#pragma mark -OnButtonClick
//
// 保存ボタン処理
//
-(IBAction)dosave:(id)sender
{
    if (![parentVCDelegate.rssViewData.originalSize isLong] && [self isLongSelected]) {
        
        // 長尺選択による制限処理
        [parentVCDelegate.rssViewData updateRssViewDataForLongSizeSelect:parentVCDelegate.rsManager.rsSettableElementsData.fileFormatData];
    }
    else if ([parentVCDelegate.rssViewData.originalSize isLong] && ![self isLongSelected]){
        // 長尺選択解除による処理(ファイル形式)
        [parentVCDelegate.rssViewData updateRssViewDataForLongSizeDeselect];
    }
    
    // 設定を保存
    [parentVCDelegate.rssViewData.originalSize setSelectValue:m_nSelectedManuscriptSizeIndexRow];
    
    [parentVCDelegate.rssViewData.sendSize setSelectValue:m_nSelectedSaveSizeIndexRow];
    
    [parentVCDelegate.rssViewData.rotation setSelectValue:m_nSelectedManuscriptSetIndexRow];
    
    //ボタンラベルを更新する
    [parentVCDelegate updateSetting];
    // 前画面に戻る
    [self.navigationController popViewControllerAnimated:YES];    
    
}

// 長尺が選択されているかどうか
- (BOOL)isLongSelected {
    if ([[manuscriptSizeList objectAtIndex:m_nSelectedManuscriptSizeIndexRow] isEqualToString:S_RS_XML_ORIGINAL_SIZE_LONG]) {
        return YES;
    }
    return NO;
}

@end
