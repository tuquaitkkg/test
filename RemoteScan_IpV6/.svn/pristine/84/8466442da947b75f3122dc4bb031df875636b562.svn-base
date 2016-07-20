
#import "RSS_ResolutionViewController.h"
#import "RemoteScanBeforePictViewController.h"

@interface RSS_ResolutionViewController ()

@end

@implementation RSS_ResolutionViewController
@synthesize parentVCDelegate;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
    }
    return self;
}

- (id)initWithResolutionArray:(NSArray*)array delegate:(RemoteScanBeforePictViewController*)delegate
{
    self = [super initWithNibName:@"RSS_ResolutionViewController" bundle:nil];
    if (self) {
        parentVCDelegate = delegate;
        resolutionList = [[NSArray alloc]initWithArray:array];
        
        NSString *value = [parentVCDelegate.rssViewData.resolution getSelectValueName];
        if ([resolutionList containsObject:value]) {
            nSelectResolutionIndexRow = [resolutionList indexOfObject:value];
        } else {
            nSelectResolutionIndexRow = 0;
        }
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    // セルのラインを表示する
    resolutionTableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    
    // スクロールの必要がないのでNO
    //resolutionTableView.scrollEnabled = NO;

    // タイトル設定
    CGRect frame = CGRectMake(0, 0, 400, 44);
    UILabel* lblTitle = [[UILabel alloc]initWithFrame:frame];
    lblTitle.backgroundColor = [UIColor clearColor];
    lblTitle.textColor = NAVIGATION_TITLE_COLOR;
    lblTitle.font = [UIFont boldSystemFontOfSize:20];
    lblTitle.textAlignment = NSTextAlignmentCenter;
    lblTitle.text = S_TITLE_RESOLUTION;
    lblTitle.adjustsFontSizeToFitWidth = YES;
    self.navigationItem.titleView = lblTitle;
    //self.navigationItem.title = S_TITLE_RESOLUTION;
    
    // 保存ボタンの設定
    UIBarButtonItem* btnSave = [[UIBarButtonItem alloc] initWithTitle:S_BUTTON_SAVEVAL style:UIBarButtonItemStyleDone target:self action:@selector(dosave:)];
    
    self.navigationItem.rightBarButtonItem = btnSave;
    
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
    resolutionList = nil;
    resolutionTableView = nil;
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}


#pragma mark - UITableViewDelegate
// セクション数
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

// セルの数
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [resolutionList count];
}

// テーブルセルの作成
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{

    static NSString *CellIdentifier = @"Cell";

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
        titleLbl.tag = 3;
        
        [cell.contentView addSubview:titleLbl];
        
    }else{
        titleLbl = (UILabel*)[cell.contentView viewWithTag:3];
    }

    // セルタイトル
    titleLbl.text = [resolutionList objectAtIndex:indexPath.row];

    // 選択状態
    cell.accessoryType = (indexPath.row == nSelectResolutionIndexRow ? UITableViewCellAccessoryCheckmark:UITableViewCellAccessoryNone);
    return cell;

}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // ハイライトOFF
    [tableView deselectRowAtIndexPath:indexPath animated:YES];

    // 選択番号の更新
    nSelectResolutionIndexRow = indexPath.row;

    // チェックの設定
    for(int i = 0; i < [resolutionList count]; i++){
        UITableViewCell * cell = [tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:i inSection:indexPath.section]];
        int accessory = UITableViewCellAccessoryNone;
        if(i == indexPath.row){
            accessory = UITableViewCellAccessoryCheckmark;
        }

        [cell setAccessoryType:accessory];
    }
    
// 保存ボタンに処理を移動  
//    // 高圧縮/高圧縮高精細のPDF/PDFAではない場合
//    if(!([parentVCDelegate.rssViewData.formatData getSelectCompactPdfTypeIndex] != 0
//       &&([[parentVCDelegate.rssViewData.formatData getSelectFileFormatValue] rangeOfString:@"pdf"].location != NSNotFound)))
//    {
//        // 設定の更新
//        [parentVCDelegate.rssViewData.resolution setSelectValue:indexPath.row];
//        [parentVCDelegate updateSetting];
//    }
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

#pragma mark -OnButtonClick
//
// 保存ボタン処理
//
-(IBAction)dosave:(id)sender
{
    if (nSelectResolutionIndexRow >= resolutionList.count) {
        return;
    }
    
    NSString *resolutionValue = resolutionList[nSelectResolutionIndexRow];
    [parentVCDelegate.rssViewData.resolution setSelectResolutionValue:resolutionValue];
    [parentVCDelegate updateSetting];
    
    // 前画面に戻る
    [self.navigationController popViewControllerAnimated:YES];
}

@end
