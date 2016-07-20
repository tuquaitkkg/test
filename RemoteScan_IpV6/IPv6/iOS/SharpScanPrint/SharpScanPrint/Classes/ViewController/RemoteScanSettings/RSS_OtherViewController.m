
#import "RSS_OtherViewController.h"
#import "PickerViewController.h"
#import "RemoteScanBeforePictViewController.h"
#import "SwitchDataCell.h"

@interface RSS_OtherViewController ()

enum{
    E_TABLE_SECTION_EXPOSURE_MODE,
    E_TABLE_SECTION_EXPOSURE_LEVEL,
    E_TABLE_SECTION_BLANK,
    E_TABLE_SECTION_MULTICROP,
    
    E_TABLE_SECTION_NUM,
};

@end

@implementation RSS_OtherViewController
@synthesize parentVCDelegate;

- (id)initWithColorDepthArray:(NSArray*)cArray blankPageArray:(NSArray*)bArray delegate:(RemoteScanBeforePictViewController*)delegate
{
    self = [super initWithNibName:@"RSS_OtherViewController" bundle:nil];
    if(self){
        parentVCDelegate = delegate;

        colorDepthList = [[NSMutableArray alloc]initWithArray:cArray];
        [colorDepthList insertObject:S_RS_XML_COLORMODE_AUTO atIndex:0];
        nSelectColorDepthIndexRow = [parentVCDelegate.rssViewData.exposureMode getSelectIndex] + 1;
        nSelectColorDepthLevelIndexRow = parentVCDelegate.rssViewData.exposureLevel.selectValue;
        if(nSelectColorDepthLevelIndexRow == 0){
            // 濃度レベルが0の場合は、自動
            nSelectColorDepthIndexRow = 0;
        }

        blankPageProcessList = [[NSArray alloc]initWithArray:bArray];
        nSelectBlankPageProcessIndexRow = [parentVCDelegate.rssViewData.specialMode.blankPageSkipData getSelectIndex];

        blankPageProcessDetailList = [[NSArray alloc]initWithArray:[parentVCDelegate.rssViewData.specialMode.blankPageSkipData getDetailArray]];
        
        bMultiCrop = parentVCDelegate.rssViewData.specialMode.multiCropData.bMultiCrop;
    }
    return self;
}


- (void)viewDidLoad
{
    [super viewDidLoad];

    // セルのラインを表示する
    otherTableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    
    // スクロールの必要がないのでNO
    //otherTableView.scrollEnabled = NO;

    // テーブルのセクションIDリストを初期化
    tableSectionIDs = [[NSMutableArray alloc]init];
    for(int i = 0; i < E_TABLE_SECTION_NUM; i++){
        if([self visibleSection:i]){
            [tableSectionIDs addObject:[NSNumber numberWithInt:i]];
        }
    }

    // タイトル設定
    CGRect frame = CGRectMake(0, 0, 400, 44);
    UILabel* lblTitle = [[UILabel alloc]initWithFrame:frame];
    lblTitle.backgroundColor = [UIColor clearColor];
    lblTitle.textColor = NAVIGATION_TITLE_COLOR;
    lblTitle.font = [UIFont boldSystemFontOfSize:20];
    lblTitle.textAlignment = NSTextAlignmentCenter;
    lblTitle.text = S_TITLE_OTHER;
    lblTitle.adjustsFontSizeToFitWidth = YES;
    self.navigationItem.titleView = lblTitle;
    //self.navigationItem.title = S_TITLE_OTHER;
    //if(parentVCDelegate){
    //    [parentVCDelegate setNavigationBarTitle:S_TITLE_OTHER leftButton:nil rightButton:nil];
    //}
    
    // 保存ボタンの設定
    UIBarButtonItem* btnSave = [[UIBarButtonItem alloc] initWithTitle:S_BUTTON_SAVEVAL style:UIBarButtonItemStyleDone target:self action:@selector(dosave:)];
    
    self.navigationItem.rightBarButtonItem = btnSave;

    // 濃度レベル表示ラベル初期化
    colorDepthLevelLbl                  = [[UILabel alloc]initWithFrame:(CGRect){100, 0, otherTableView.frame.size.width, 44}];
    colorDepthLevelLbl.font             = [UIFont systemFontOfSize:14];
    colorDepthLevelLbl.textAlignment    = NSTextAlignmentCenter;
    colorDepthLevelLbl.backgroundColor  = [UIColor clearColor];
    colorDepthLevelLbl.textColor        = [UIColor blackColor];
    colorDepthLevelLbl.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin;
    colorDepthLevelLbl.text             = [NSString stringWithFormat:@"%d", nSelectColorDepthLevelIndexRow];

    // 濃度調整スライダー
    colorDepthSld                       = [[UISlider alloc]initWithFrame:(CGRect){0,0,0,0}];
    colorDepthSld.minimumValue          = 1.0;
	colorDepthSld.maximumValue          = 5.0;
	colorDepthSld.value                 = nSelectColorDepthLevelIndexRow;
    colorDepthSld.autoresizingMask      = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin;
	[colorDepthSld addTarget:self action:@selector(updateColorDepthSld:) forControlEvents:UIControlEventValueChanged];

    // 白紙飛ばし項目のフッター設定
    footerLbl                           = [[UILabel alloc]init];
    footerLbl.numberOfLines             = 0;
    footerLbl.backgroundColor           = [UIColor clearColor];
    footerLbl.textColor                 = [UIColor colorWithRed:0.29f green:0.34f blue:0.43f alpha:1.00f];
    footerLbl.shadowColor               = [UIColor whiteColor];
    footerLbl.shadowOffset              = CGSizeMake(0, 1);
    footerLbl.text                      = [blankPageProcessDetailList objectAtIndex:nSelectBlankPageProcessIndexRow];
    footerLbl.font                      = [UIFont boldSystemFontOfSize:12.0];
    // サイズと座標を調整
    footerLbl.frame = (CGRect){40, 0, 400, 40};
    [footerLbl sizeToFit];
    
    // マルチクロップのフッター設定
    multiCropFooterLbl                           = [[UILabel alloc]init];
    multiCropFooterLbl.numberOfLines             = 0;
    multiCropFooterLbl.backgroundColor           = [UIColor clearColor];
    multiCropFooterLbl.textColor                 = [UIColor colorWithRed:0.29f green:0.34f blue:0.43f alpha:1.00f];
    multiCropFooterLbl.shadowColor               = [UIColor whiteColor];
    multiCropFooterLbl.shadowOffset              = CGSizeMake(0, 1);
    [self setMultiCropFooterText];
    multiCropFooterLbl.font                      = [UIFont boldSystemFontOfSize:12.0];
    // サイズと座標を調整
    multiCropFooterLbl.frame = (CGRect){40, 0, 400, 40};
    [multiCropFooterLbl sizeToFit];

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
    otherTableView = nil;
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}


#pragma mark - UISlider Action
// スライダーの値を更新
-(void)updateColorDepthSld:(UISlider*)sld
{
    nSelectColorDepthLevelIndexRow = round(sld.value);
    colorDepthLevelLbl.text = [NSString stringWithFormat:@"%d", nSelectColorDepthLevelIndexRow];
// 保存ボタンに移動
/*    [parentVCDelegate.rssViewData.exposureLevel setSelectValue:nSelectColorDepthLevelIndexRow];
*/ 
}

#pragma mark - UITableViewDelegate
// セクション数
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [tableSectionIDs count];
}

// セルの数
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    int cellNum = 1;
    int sectionId = [[tableSectionIDs objectAtIndex:section] intValue];
    if(sectionId == E_TABLE_SECTION_EXPOSURE_LEVEL){
        cellNum = 2;
    }
    return cellNum;
}

-(BOOL)visibleSection:(int)sectionId
{
    BOOL res = YES;
    
    switch (sectionId) {
        case E_TABLE_SECTION_EXPOSURE_LEVEL:
            if(nSelectColorDepthIndexRow == 0){
                // 濃度設定が自動の場合
                res = NO;
            }
            break;
        case E_TABLE_SECTION_BLANK:
            if (bMultiCrop) {
                res = NO;
            }
            break;
        case E_TABLE_SECTION_MULTICROP:
            if (![parentVCDelegate.rssViewData.specialMode isMultiCropValid]) {
                // MFP未対応の場合
                res = NO;
                break;
            }
            if ([[blankPageProcessList objectAtIndex:nSelectBlankPageProcessIndexRow] isEqualToString:S_RS_XML_SPECIAL_MODE_BLANK_PAGE_SKIP]
                || [[blankPageProcessList objectAtIndex:nSelectBlankPageProcessIndexRow] isEqualToString:S_RS_XML_SPECIAL_MODE_BLANK_AND_BACK_SHADOW_SKIP]) {
                // 「白紙を飛ばす」or「白紙と裏写り原稿を飛ばす」の場合
                res = NO;
            }
            break;
        default:
            break;
    }
    
    return res;
}

// テーブルセルの作成
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    int sectionId = [[tableSectionIDs objectAtIndex:indexPath.section] intValue];
    NSString *CellIdentifier = [NSString stringWithFormat:@"Cell%d%ld", sectionId, (long)indexPath.row];

    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    UILabel* titleLbl = nil;

    if(cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.tag = sectionId;
        cell.exclusiveTouch = YES; // 同時押し禁止
        
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
        titleLbl.tag = E_TABLE_SECTION_NUM;      // (注意：元々3であったが今回セクションが増えるので影響する可能性も。) →　E_TABLE_SECTION_NUMに変更
        
        [cell.contentView addSubview:titleLbl];

        if(sectionId == E_TABLE_SECTION_EXPOSURE_LEVEL){
            // 濃度レベル設定
            if(indexPath.row == 0){
                // レベル表示
                titleLbl.text = S_TITLE_OTHER_EXPOSURE_LEVEL;
                CGRect frame = CGRectZero;
                frame.origin.x = 100;
                frame.size.width = cell.contentView.frame.size.width - 200;
                frame.size.height = cell.contentView.frame.size.height;
                colorDepthLevelLbl.frame = frame;
                [cell.contentView addSubview:colorDepthLevelLbl];

            }else{
                CGRect frame = CGRectZero;
                // うすい
                frame = (CGRect){0, 0, 100, cell.contentView.frame.size.height};
                UILabel* lightLbl = [[UILabel alloc]initWithFrame:frame];
                lightLbl.font             = [UIFont systemFontOfSize:14];
                lightLbl.textAlignment    = NSTextAlignmentCenter;
                lightLbl.backgroundColor  = [UIColor clearColor];
                lightLbl.textColor        = [UIColor blackColor];
                lightLbl.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleRightMargin;
                lightLbl.text             = S_OTHER_LIGHT;
                [cell.contentView addSubview:lightLbl];

                // こい
                frame.origin.x = cell.contentView.frame.size.width - 100;
                UILabel* deepLbl = [[UILabel alloc]initWithFrame:frame];
                deepLbl.font             = [UIFont systemFontOfSize:14];
                deepLbl.textAlignment    = NSTextAlignmentCenter;
                deepLbl.backgroundColor  = [UIColor clearColor];
                deepLbl.textColor        = [UIColor blackColor];
                deepLbl.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleLeftMargin;
                deepLbl.text             = S_OTHER_DEEP;
                [cell.contentView addSubview:deepLbl];

                // スライダー
                frame.origin.x = lightLbl.frame.size.width;
                frame.size.width = cell.contentView.frame.size.width - (lightLbl.frame.size.width + deepLbl.frame.size.width);
                colorDepthSld.frame = frame;
                [cell.contentView addSubview:colorDepthSld];
            }
        }
        else if (sectionId == E_TABLE_SECTION_MULTICROP) {
            // マルチクロップ
            SwitchDataCell* swSwitchDataCell = [[SwitchDataCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
            swSwitchDataCell.nameLabelCell.text = S_RS_XML_SPECIAL_MODE_MULTI_CROP;
            swSwitchDataCell.switchField.on = bMultiCrop;
            swSwitchDataCell.tag = E_TABLE_SECTION_MULTICROP;
            swSwitchDataCell.switchField.tag = E_TABLE_SECTION_MULTICROP;
            [swSwitchDataCell.switchField addTarget:self action:@selector(changeSwitchValue:) forControlEvents:UIControlEventValueChanged];
            cell = swSwitchDataCell;
        }

    }
    else{
        titleLbl = (UILabel*)[cell.contentView viewWithTag:E_TABLE_SECTION_NUM];    // (注意：元々3であったが今回セクションが増えるので影響する可能性も。) →　E_TABLE_SECTION_NUMに変更
    }

    // セルタイトル
    cell.accessoryView = nil;
    switch (sectionId) {
        case E_TABLE_SECTION_EXPOSURE_MODE:
            titleLbl.text = [colorDepthList objectAtIndex:nSelectColorDepthIndexRow];
            cell.accessoryView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:S_IMAGE_PICKER]];
            break;
        case E_TABLE_SECTION_BLANK:
            titleLbl.text = [blankPageProcessList objectAtIndex:nSelectBlankPageProcessIndexRow];
            cell.accessoryView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:S_IMAGE_PICKER]];
            break;

        case E_TABLE_SECTION_EXPOSURE_LEVEL:
        case E_TABLE_SECTION_MULTICROP:
        default:
            break;
    }

    return cell;
}

// 各セルの高さを設定
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return N_HEIGHT_SEL_DEFAULT;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // セルの取得
    UITableViewCell * cell = [tableView cellForRowAtIndexPath:indexPath];
    if(cell.tag != E_TABLE_SECTION_EXPOSURE_LEVEL && cell.tag != E_TABLE_SECTION_MULTICROP){
        // ピッカーを表示(濃度調整とマルチクロップのセクション以外)
        m_nSelPicker = cell.tag;
        [self showFormatSettingPickerViewFromCell:cell];
    }
}

// 各セクションのタイトルを決定する
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    NSString *title = @"";
    int sectionId = [[tableSectionIDs objectAtIndex:section] intValue];
    switch (sectionId) {
        case E_TABLE_SECTION_EXPOSURE_MODE:
            title = S_TITLE_OTHER_EXPOSURE_MODE;
            break;
        case E_TABLE_SECTION_EXPOSURE_LEVEL:
            break;
        case E_TABLE_SECTION_BLANK:
            title = S_TITLE_OTHER_BLANK;
            break;
        case E_TABLE_SECTION_MULTICROP: // SWなのでタイトルなし(他の設定画面に合わせる)
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

    int sectionId = [[tableSectionIDs objectAtIndex:section] intValue];
    if(sectionId == E_TABLE_SECTION_BLANK){
        // ビューを作成
        returnView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, tableView.bounds.size.width, 40)];
        [returnView setAutoresizingMask:UIViewAutoresizingFlexibleWidth];

        // 文言更新
        [footerLbl setText:[blankPageProcessDetailList objectAtIndex:nSelectBlankPageProcessIndexRow]];
        [footerLbl setFrame:(CGRect){20, 0, tableView.bounds.size.width -20, 40}];
        [footerLbl setLineBreakMode:NSLineBreakByWordWrapping];
        [footerLbl sizeToFit];

        [returnView setFrame:(CGRect){returnView.frame.origin, returnView.frame.size.width , footerLbl.frame.size.height}];
        [returnView addSubview:footerLbl];
    }
    // マルチクロップ文言 フッター表示
    else if (sectionId == E_TABLE_SECTION_MULTICROP) {
        // ビューを作成
        returnView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, tableView.bounds.size.width, 40)];
        [returnView setAutoresizingMask:UIViewAutoresizingFlexibleWidth];
        
        // 文言更新
        [self setMultiCropFooterText];
        [multiCropFooterLbl setFrame:(CGRect){20, 0, tableView.bounds.size.width -20, 40}];
        [multiCropFooterLbl setLineBreakMode:NSLineBreakByWordWrapping];
        [multiCropFooterLbl sizeToFit];
        
        [returnView setFrame:(CGRect){returnView.frame.origin, returnView.frame.size.width , multiCropFooterLbl.frame.size.height}];
        [returnView addSubview:multiCropFooterLbl];
    }

    return returnView;
}

-(CGFloat) tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    int sectionId = [[tableSectionIDs objectAtIndex:section] intValue];
//    CGFloat h = 0.0;
    CGFloat h = TABLE_HEADER_HEIGHT_1;
    if(sectionId == E_TABLE_SECTION_BLANK){
        h = footerLbl.frame.size.height;
    }
    return h;
}

// ヘッダーの高さを設定
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    int sectionId = [[tableSectionIDs objectAtIndex:section] intValue];
    if(sectionId == E_TABLE_SECTION_EXPOSURE_LEVEL){
        return TABLE_HEADER_HEIGHT_1;
    }
    return TABLE_HEADER_HEIGHT_2;
}

#pragma mark - PickerView Manage
-(void)showFormatSettingPickerViewFromCell:(UITableViewCell*)cell
{
    NSMutableArray* setArray = [NSMutableArray array];
    NSInteger nSelRow = 0;
    switch (cell.tag) {
        case E_TABLE_SECTION_EXPOSURE_MODE:
            // 濃度種類
            [setArray addObjectsFromArray:colorDepthList];
            nSelRow = nSelectColorDepthIndexRow;
            break;
        case E_TABLE_SECTION_BLANK:
            // 白紙飛ばし
            [setArray addObjectsFromArray:blankPageProcessList];
            nSelRow = nSelectBlankPageProcessIndexRow;
            break;

        case E_TABLE_SECTION_EXPOSURE_LEVEL:
            // 濃度調整
            // ピッカーを表示しない
        // 呼び出しで場合分けしているので不要だが、濃度調整が同じパターンで記述されているので合わせている。
        case E_TABLE_SECTION_MULTICROP:
            // マルチクロップ
            // ピッカーを表示しない
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

- (IBAction)OnMenuDecideButton:(id)sender
{

    // Todo getPickerValueActionで行っていた処理をここで行う
     NSInteger row = m_nSelRow;

    // アクションシート非表示
    [super OnMenuDecideButton:sender];

    // 値の格納
    switch (m_nSelPicker) {
        case E_TABLE_SECTION_EXPOSURE_MODE:
            // 濃度種類
            nSelectColorDepthIndexRow = row;
            if(row == 0){
                // 自動を選択
                if(nSelectColorDepthLevelIndexRow != 0){
                    nSelectColorDepthLevelIndexRow = 0;
//　保存ボタンに移動
/*                    // 自動時は濃度レベルは0にする
                    [parentVCDelegate.rssViewData.exposureLevel setSelectValue:nSelectColorDepthLevelIndexRow];
*/
                }

            }else{
//　保存ボタンに移動
/*                // 保存時は自動を追加した文を減算する
                [parentVCDelegate.rssViewData.exposureMode setSelectValue:row - 1];
*/
                if(nSelectColorDepthLevelIndexRow == 0){
                    // 自動以外が選択された時に、濃度レベルが０ならば３にする
                    nSelectColorDepthLevelIndexRow = 3;
                    [colorDepthSld setValue:nSelectColorDepthLevelIndexRow];
                    [self updateColorDepthSld:colorDepthSld];
                }
            }

            break;
        case E_TABLE_SECTION_BLANK:
            // 白紙飛ばし
            nSelectBlankPageProcessIndexRow = row;
            footerLbl.text = [blankPageProcessDetailList objectAtIndex:nSelectBlankPageProcessIndexRow];
//　保存ボタンに移動
/*            [parentVCDelegate.rssViewData.specialMode setSelectValue:row];
*/            break;

        case E_TABLE_SECTION_EXPOSURE_LEVEL:
            // 濃度調整
            // ピッカーを表示しない
        // 厳密には不要だが濃度調整と合わせる
        case E_TABLE_SECTION_MULTICROP:
            // マルチクロップ
            // ピッカーを表示しない
        default:
            // 例外処理
            return;
            break;
    }

    // セクションの削除と挿入
    [self sectionDeleteAndInsert];

    // 通知の監視を終了
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"Picker Value" object:nil];

}

- (void)OnMenuCancelButton:(id)sender
{
    [super OnMenuCancelButton:sender];
}

#pragma mark - Table Section Delete And Insert
// セクションの削除と挿入
-(void)sectionDeleteAndInsert
{
    // セクションの削除
    NSMutableIndexSet* modIndexes = [NSMutableIndexSet indexSet];
    for(int secid = 0; secid < E_TABLE_SECTION_NUM; secid++){
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
        [otherTableView deleteSections:modIndexes withRowAnimation:UITableViewRowAnimationAutomatic];

        // 削除を実行した場合は、アニメーション後に挿入のチェックのためにもう一度呼び出す
        [self performSelector:@selector(sectionDeleteAndInsert) withObject:nil afterDelay:0.5];
    }else{

        // セクションの挿入
        int sectionCount = 0;
        [modIndexes removeAllIndexes];
        for(int secid = 0; secid < E_TABLE_SECTION_NUM; secid++){
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
            for(int i = 0; i < E_TABLE_SECTION_NUM; i++){
                if([self visibleSection:i]){
                    [tableSectionIDs addObject:[NSNumber numberWithInt:i]];
                }
            }

            // 挿入実行
            [otherTableView insertSections:modIndexes withRowAnimation:UITableViewRowAnimationAutomatic];

            // 挿入アニメーション後にテーブルを更新
            [otherTableView performSelector:@selector(reloadData) withObject:nil afterDelay:0.5];
        }else{
            // テーブルを更新
            [otherTableView reloadData];
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

#pragma mark -OnButtonClick
//
// 保存ボタン処理
//
-(IBAction)dosave:(id)sender
{
    // 保存時は自動を追加した分を減算する
    if(nSelectColorDepthIndexRow)
    {
        [parentVCDelegate.rssViewData.exposureMode setSelectValue:nSelectColorDepthIndexRow - 1];
    }
    else
    {
        // 自動が選ばれている場合は減算しない(exposureLevelが0かどうかで判断する)
        [parentVCDelegate.rssViewData.exposureMode setSelectValue:nSelectColorDepthIndexRow];        
    }
    // スライダーの値を更新
    [parentVCDelegate.rssViewData.exposureLevel setSelectValue:nSelectColorDepthLevelIndexRow];

    // 白紙飛ばしの値を更新
    [parentVCDelegate.rssViewData.specialMode.blankPageSkipData setSelectValue:nSelectBlankPageProcessIndexRow];
    
    // マルチクロップの値が変わったかどうか判定
    if (bMultiCrop != parentVCDelegate.rssViewData.specialMode.multiCropData.bMultiCrop) {
        // マルチクロップの値を更新
        parentVCDelegate.rssViewData.specialMode.multiCropData.bMultiCrop = bMultiCrop;
        
        if (bMultiCrop) {
            // マルチクロップ選択による制限処理(値の強制変更)
            [parentVCDelegate.rssViewData updateRssViewDataForMultiCropOn:parentVCDelegate.rsManager.rsSettableElementsData.fileFormatData];
            
        }
        else {
            // マルチクロップ解除による処理
            [parentVCDelegate.rssViewData updateRssViewDataForMultiCropOff];
        }
        
        // メニューボタンのEnabled設定
        [self updateRssViewMenuButtonEnabled];
    }
    
    // ボタン表示名の更新
    [parentVCDelegate updateSetting];
    
    // 前画面に戻る
    [self.navigationController popViewControllerAnimated:YES];
    
}

// マルチクロップ設定変更に伴うメニューボタンの活性/非活性処理
- (void)updateRssViewMenuButtonEnabled {
    
    [parentVCDelegate.m_pbtnFourth setEnabled:!bMultiCrop];
    [parentVCDelegate.m_pbtnFifth setEnabled:!bMultiCrop];
    
}

#pragma mark -SwitchValueChanged

-(IBAction)changeSwitchValue:(UISwitch*)sender
{
    switch (sender.tag) {
        case E_TABLE_SECTION_MULTICROP:
            if (bMultiCrop != sender.on) {
                bMultiCrop = sender.on;
                [self sectionDeleteAndInsert];
            }
            return;
            
        default:
            return;
    }

}

- (void)setMultiCropFooterText {
    if (bMultiCrop) {
        multiCropFooterLbl.text = S_RS_MULTICROP_DETAIL_OPEN_PLATEN;
    }
    else {
        multiCropFooterLbl.text = @"";
    }

}

@end
