
#import "RSS_ResolutionViewController_iPad.h"
#import "RemoteScanBeforePictViewController_iPad.h"

@interface RSS_ResolutionViewController_iPad ()

@end

@implementation RSS_ResolutionViewController_iPad
@synthesize parentVCDelegate;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
    }
    return self;
}

- (id)initWithResolutionArray:(NSArray*)array delegate:(RemoteScanBeforePictViewController_iPad*)delegate
{
    self = [super initWithNibName:@"RSS_ResolutionViewController_iPad" bundle:nil];
    if (self) {
        parentVCDelegate = delegate;

        resolutionList = [[NSArray alloc]initWithArray:array];
        nSelectResolutionIndexRow = [parentVCDelegate.rssViewData.resolution getSelectIndex];

    }
    return self;
}

// iPad用
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    // PDFの高圧縮／高圧縮高精細が指定されている場合は選択されている解像度(300x300bpi:FormatViewController_ipadで指定)のみ選択可能とする
    RemoteScanSettingViewData *rssViewData = parentVCDelegate.rssViewData;
    NSArray *resolutionValues = [rssViewData.resolution getSelectableResolutionValues:rssViewData.formatData
                                                                            colorMode:rssViewData.colorMode
                                                                         originalSize:rssViewData.originalSize
                                                                            multiCrop:[rssViewData.specialMode isMultiCropOn]];
    resolutionList = [[NSArray alloc] initWithArray:resolutionValues];
    
    NSString *value = [parentVCDelegate.rssViewData.resolution getSelectValueName];
    if ([resolutionList containsObject:value])
    {
        nSelectResolutionIndexRow = [resolutionList indexOfObject:value];
    }
    else
    {
        nSelectResolutionIndexRow = 0;
    }
    
    [resolutionTableView reloadData];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // セルのラインを表示する
    resolutionTableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;

    // テーブルの背景色を設定
    UIView* bgView = [[UIView alloc]initWithFrame:resolutionTableView.frame];
    [resolutionTableView setBackgroundView:bgView];
    // スクロールの必要がないのでNO
    //resolutionTableView.scrollEnabled = NO;

    // ナビゲーションバーの設定
    if(parentVCDelegate){
        [parentVCDelegate setNavigationBarTitle:S_TITLE_RESOLUTION leftButton:nil rightButton:nil];
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

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
	return YES;
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

    if(cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        cell.textLabel.font = [UIFont systemFontOfSize:14];
    }

    // セルタイトル
    cell.textLabel.text = [resolutionList objectAtIndex:indexPath.row];//[parentVCDelegate replaceRSStr:[resolutionList objectAtIndex:indexPath.row]];
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
    
    // 設定の更新
    NSString *resolutionValue = resolutionList[nSelectResolutionIndexRow];
    [parentVCDelegate.rssViewData.resolution setSelectResolutionValue:resolutionValue];
    [parentVCDelegate updateSetting];
}

@end
