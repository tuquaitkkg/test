
#import "RSS_ColorModeViewController_iPad.h"
#import "RemoteScanBeforePictViewController_iPad.h"

@interface RSS_ColorModeViewController_iPad ()

@end

@implementation RSS_ColorModeViewController_iPad
@synthesize parentVCDelegate;
@synthesize nSelectedIndexRow;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(id)initWithColorModeArray:(NSArray*)array delegate:(RemoteScanBeforePictViewController_iPad *)delegate
{
    self = [super initWithNibName:@"RSS_ColorModeViewController_iPad" bundle:nil];
    if(self){
        self.parentVCDelegate = delegate;

        colorModeArray = [[NSArray alloc]initWithArray:array];

        // 選択セルの検索
        self.nSelectedIndexRow = [parentVCDelegate.rssViewData.colorMode getSelectIndex];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    // セルのラインを表示する
    colorModeTableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    
    // テーブルの背景色を設定
    UIView* bgView = [[UIView alloc]initWithFrame:colorModeTableView.frame];
    [colorModeTableView setBackgroundView:bgView];
    // スクロールの必要がないのでNO
    //colorModeTableView.scrollEnabled = NO;

    // ナビゲーションバーの設定
    if(parentVCDelegate){
        [parentVCDelegate setNavigationBarTitle:S_TITLE_COLORMODE leftButton:nil rightButton:nil];
    }

}

// iPad用
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    // 原稿サイズが長尺の場合は白黒2値のみ選択可能とする
    if([parentVCDelegate.rssViewData.originalSize isLong])
    {
        colorModeArray = nil;
        colorModeArray = [[NSArray alloc]initWithObjects:[parentVCDelegate.rssViewData.colorMode getSpecifiedValueName:@"monochrome"], nil];   
        // 選択セルの検索
        self.nSelectedIndexRow = 0;
        [colorModeTableView reloadData];
    }    // 元の配列と数があわなければもとに戻る
    else if([colorModeArray count] != [[parentVCDelegate.rssViewData.colorMode getSelectableArray] count])
    {
        colorModeArray = nil;
        colorModeArray = [[NSArray alloc]initWithArray:[parentVCDelegate.rssViewData.colorMode getSelectableArray]];            
        // 選択セルの検索
        self.nSelectedIndexRow = [parentVCDelegate.rssViewData.colorMode getSelectIndex];
        [colorModeTableView reloadData];
    }

}

- (void)viewDidUnload
{
    colorModeTableView = nil;
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
    return [colorModeArray count];
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

    DLog(@"%ld, %@", (long)indexPath.row, [colorModeArray objectAtIndex:indexPath.row]);
    // セルタイトル
    cell.textLabel.text = [colorModeArray objectAtIndex:indexPath.row];
    // 選択状態
    cell.accessoryType = (indexPath.row == nSelectedIndexRow ? UITableViewCellAccessoryCheckmark:UITableViewCellAccessoryNone);
    return cell;

}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // ハイライトOFF
    [tableView deselectRowAtIndexPath:indexPath animated:YES];

    // 選択番号の更新
    self.nSelectedIndexRow = indexPath.row;

    // チェックの設定
    for(int i = 0; i < [colorModeArray count]; i++){
        UITableViewCell * cell = [tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:i inSection:indexPath.section]];
        int accessory = UITableViewCellAccessoryNone;
        if(i == indexPath.row){
            accessory = UITableViewCellAccessoryCheckmark;
        }

        [cell setAccessoryType:accessory];
    }
    

    // 原稿サイズが長尺以外の場合のみ更新する
    if(![parentVCDelegate.rssViewData.originalSize isLong])
    {  
        // 設定の更新
        [parentVCDelegate.rssViewData.colorMode setSelectValue:indexPath.row];
        [parentVCDelegate updateSetting];
    }
}

@end
