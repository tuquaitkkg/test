
#import "RSS_BothOrOneSideViewController_iPad.h"
#import "RemoteScanBeforePictViewController_iPad.h"

@interface RSS_BothOrOneSideViewController_iPad ()

@end

@implementation RSS_BothOrOneSideViewController_iPad
@synthesize parentVCDelegate;
@synthesize nSelectSideTypeIndexRow;


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
    }
    return self;
}

-(id)initWithDuplexDataArray:(NSArray*)array delegate:(RemoteScanBeforePictViewController_iPad *)delegate
{
    self = [super initWithNibName:@"RSS_BothOrOneSideViewController_iPad" bundle:nil];
    if(self){
        self.parentVCDelegate = delegate;

        sideTypeList = [[NSArray alloc]initWithArray:array];
        self.nSelectSideTypeIndexRow = [parentVCDelegate.rssViewData.duplexData getSelectIndex];

    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // セルのラインを表示する
    bothOrOneSideTableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;

    // テーブルの背景色を設定
    UIView* bgView = [[UIView alloc]initWithFrame:bothOrOneSideTableView.frame];
    [bothOrOneSideTableView setBackgroundView:bgView];
    // スクロールの必要がないのでNO
    bothOrOneSideTableView.scrollEnabled = YES;

    // ナビゲーションバーの設定
    if(parentVCDelegate){
        [parentVCDelegate setNavigationBarTitle:S_TITLE_BOTH leftButton:nil rightButton:nil];
    }

    // 画像の初期化
    selectSideTypeImage.contentMode = UIViewContentModeScaleAspectFit;
    NSString* imgName = [parentVCDelegate.rssViewData.duplexData getSelectValueImageName];
    selectSideTypeImage.image = [UIImage imageNamed:imgName];
}

- (void)viewDidUnload
{
    sideTypeList = nil;

    bothOrOneSideTableView = nil;
    selectSideTypeImage = nil;
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
    return [sideTypeList count];
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
    cell.textLabel.text = [sideTypeList objectAtIndex:indexPath.row];
    // 選択状態
    cell.accessoryType = (indexPath.row == nSelectSideTypeIndexRow ? UITableViewCellAccessoryCheckmark:UITableViewCellAccessoryNone);

    return cell;
}

// セルを選択したときの処理
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // ハイライトOFF
    [tableView deselectRowAtIndexPath:indexPath animated:YES];

    // 選択番号の更新
    self.nSelectSideTypeIndexRow = indexPath.row;
    [parentVCDelegate.rssViewData.duplexData setSelectValue:indexPath.row];
    // チェックの設定
    for(int i = 0; i < [sideTypeList count]; i++){
        UITableViewCell * cell = [tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:i inSection:indexPath.section]];
        int accessory = UITableViewCellAccessoryNone;
        if(i == indexPath.row){
            accessory = UITableViewCellAccessoryCheckmark;
        }

        [cell setAccessoryType:accessory];
    }

    // 設定の更新
    [parentVCDelegate updateSetting];

    // 画像更新
    NSString* imgName = [parentVCDelegate.rssViewData.duplexData getSelectValueImageName];
    selectSideTypeImage.image = [UIImage imageNamed:imgName];
}


@end
