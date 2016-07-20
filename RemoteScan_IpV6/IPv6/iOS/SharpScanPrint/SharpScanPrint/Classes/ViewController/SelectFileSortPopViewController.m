
#import "SelectFileSortPopViewController.h"

#import "Define.h"
#import "CommonUtil.h"

@implementation SelectFileSortPopViewController

@synthesize delegate;
@synthesize sortMenuList;
@synthesize nSelectResolutionIndexRow;
@synthesize cancelButtonItem;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
//    //
//    int viewWidth     = self.view.frame.size.width;
//    int buttonWidth   = 210.0;
//    int buttonOriginX = (viewWidth - buttonWidth)/2.0;
//    int buttonEnd     = viewWidth - buttonOriginX;
//    int buttonOriginY = 6.0;
//    //
//    UIButton *sortTypeButton1 = [UIButton buttonWithType: UIButtonTypeCustom];
//    sortTypeButton1.frame = CGRectMake(buttonOriginX, buttonOriginY, 140.0, 35.0);
//    sortTypeButton1.titleLabel.textColor = [UIColor whiteColor];
//    sortTypeButton1.backgroundColor = [UIColor clearColor];
//    sortTypeButton1.tag = 100;
//    [sortTypeButton1 setTitle: @"タイムスタンプ" forState:UIControlStateNormal];
//    [sortTypeButton1 addTarget: self.delegate action:@selector(changeSortType:) forControlEvents:UIControlEventTouchUpInside];
//    //
//    UIButton *sortTypeButton1u = [UIButton buttonWithType: UIButtonTypeCustom];
//    sortTypeButton1u.frame = CGRectMake(buttonEnd - 70.0, buttonOriginY, 35.0, 35.0);
//    sortTypeButton1u.titleLabel.textColor = [UIColor whiteColor];
//    sortTypeButton1u.backgroundColor = [UIColor clearColor];
//    sortTypeButton1u.tag = 101;
//    [sortTypeButton1u setTitle: @"△" forState:UIControlStateNormal];
// 	[sortTypeButton1u addTarget: self.delegate action:@selector(changeSortType:) forControlEvents:UIControlEventTouchUpInside];
//    //
//    UIButton *sortTypeButton1d = [UIButton buttonWithType: UIButtonTypeCustom];
//    sortTypeButton1d.frame = CGRectMake(buttonEnd - 35.0, buttonOriginY, 35.0, 35.0);
//    sortTypeButton1d.titleLabel.textColor = [UIColor whiteColor];
//    sortTypeButton1d.backgroundColor = [UIColor clearColor];
//    sortTypeButton1d.tag = 102;
//    [sortTypeButton1d setTitle: @"▽" forState:UIControlStateNormal];
//	[sortTypeButton1d addTarget: self.delegate action:@selector(changeSortType:) forControlEvents:UIControlEventTouchUpInside];
//    //
//    UIButton *sortTypeButton2 = [UIButton buttonWithType: UIButtonTypeCustom];
//    sortTypeButton2.frame = CGRectMake(buttonOriginX, buttonOriginY + 35.0, 140.0, 35.0);
//    sortTypeButton2.titleLabel.textColor = [UIColor whiteColor];
//    sortTypeButton2.backgroundColor = [UIColor clearColor];
//    sortTypeButton2.tag = 200;
//    [sortTypeButton2 setTitle: @"ファイル名" forState:UIControlStateNormal];
//    [sortTypeButton2 addTarget: self.delegate action:@selector(changeSortType:) forControlEvents:UIControlEventTouchUpInside];
//    //
//    UIButton *sortTypeButton2u = [UIButton buttonWithType: UIButtonTypeCustom];
//    sortTypeButton2u.frame = CGRectMake(buttonEnd - 70.0, buttonOriginY + 35.0, 35.0, 35.0);
//    sortTypeButton2u.titleLabel.textColor = [UIColor whiteColor];
//    sortTypeButton2u.backgroundColor = [UIColor clearColor];
//    sortTypeButton2u.tag = 201;
//    [sortTypeButton2u setTitle: @"△" forState:UIControlStateNormal];
// 	[sortTypeButton2u addTarget: self.delegate action:@selector(changeSortType:) forControlEvents:UIControlEventTouchUpInside];
//    //
//    UIButton *sortTypeButton2d = [UIButton buttonWithType: UIButtonTypeCustom];
//    sortTypeButton2d.frame = CGRectMake(buttonEnd - 35.0, buttonOriginY + 35.0, 35.0, 35.0);
//    sortTypeButton2d.titleLabel.textColor = [UIColor whiteColor];
//    sortTypeButton2d.backgroundColor = [UIColor clearColor];
//    sortTypeButton2d.tag = 202;
//    [sortTypeButton2d setTitle: @"▽" forState:UIControlStateNormal];
//	[sortTypeButton2d addTarget: self.delegate action:@selector(changeSortType:) forControlEvents:UIControlEventTouchUpInside];
//    //
//    UIButton *sortTypeButton3 = [UIButton buttonWithType: UIButtonTypeCustom];
//    sortTypeButton3.frame = CGRectMake(buttonOriginX, buttonOriginY + (35.0*2), 140.0, 35.0);
//    sortTypeButton3.titleLabel.textColor = [UIColor whiteColor];
//    sortTypeButton3.backgroundColor = [UIColor clearColor];
//    sortTypeButton3.tag = 300;
//    [sortTypeButton3 setTitle: @"ファイルサイズ" forState:UIControlStateNormal];
//    [sortTypeButton3 addTarget: self.delegate action:@selector(changeSortType:) forControlEvents:UIControlEventTouchUpInside];
//    //
//    UIButton *sortTypeButton3u = [UIButton buttonWithType: UIButtonTypeCustom];
//    sortTypeButton3u.frame = CGRectMake(buttonEnd - 70.0, buttonOriginY + (35.0*2), 35.0, 35.0);
//    sortTypeButton3u.titleLabel.textColor = [UIColor whiteColor];
//    sortTypeButton3u.backgroundColor = [UIColor clearColor];
//    sortTypeButton3u.tag = 301;
//    [sortTypeButton3u setTitle: @"△" forState:UIControlStateNormal];
// 	[sortTypeButton3u addTarget: self.delegate action:@selector(changeSortType:) forControlEvents:UIControlEventTouchUpInside];
//    //
//    UIButton *sortTypeButton3d = [UIButton buttonWithType: UIButtonTypeCustom];
//    sortTypeButton3d.frame = CGRectMake(buttonEnd - 35.0, buttonOriginY + (35.0*2), 35.0, 35.0);
//    sortTypeButton3d.titleLabel.textColor = [UIColor whiteColor];
//    sortTypeButton3d.backgroundColor = [UIColor clearColor];
//    sortTypeButton3d.tag = 302;
//    [sortTypeButton3d setTitle: @"▽" forState:UIControlStateNormal];
//	[sortTypeButton3d addTarget: self.delegate action:@selector(changeSortType:) forControlEvents:UIControlEventTouchUpInside];
//    //
//    UIButton *sortTypeButton4 = [UIButton buttonWithType: UIButtonTypeCustom];
//    sortTypeButton4.frame = CGRectMake(buttonOriginX, buttonOriginY + (35.0*3), 140.0, 35.0);
//    sortTypeButton4.titleLabel.textColor = [UIColor whiteColor];
//    sortTypeButton4.backgroundColor = [UIColor clearColor];
//    sortTypeButton4.tag = 400;
//    [sortTypeButton4 setTitle: @"ファイルの種類" forState:UIControlStateNormal];
//    [sortTypeButton4 addTarget: self.delegate action:@selector(changeSortType:) forControlEvents:UIControlEventTouchUpInside];
//    //
//    UIButton *sortTypeButton4u = [UIButton buttonWithType: UIButtonTypeCustom];
//    sortTypeButton4u.frame = CGRectMake(buttonEnd - 70.0, buttonOriginY + (35.0*3), 35.0, 35.0);
//    sortTypeButton4u.titleLabel.textColor = [UIColor whiteColor];
//    sortTypeButton4u.backgroundColor = [UIColor clearColor];
//    sortTypeButton4u.tag = 401;
//    [sortTypeButton4u setTitle: @"△" forState:UIControlStateNormal];
// 	[sortTypeButton4u addTarget: self.delegate action:@selector(changeSortType:) forControlEvents:UIControlEventTouchUpInside];
//    //
//    UIButton *sortTypeButton4d = [UIButton buttonWithType: UIButtonTypeCustom];
//    sortTypeButton4d.frame = CGRectMake(buttonEnd - 35.0, buttonOriginY + (35.0*3), 35.0, 35.0);
//    sortTypeButton4d.titleLabel.textColor = [UIColor whiteColor];
//    sortTypeButton4d.backgroundColor = [UIColor clearColor];
//    sortTypeButton4d.tag = 402;
//    [sortTypeButton4d setTitle: @"▽" forState:UIControlStateNormal];
//	[sortTypeButton4d addTarget: self.delegate action:@selector(changeSortType:) forControlEvents:UIControlEventTouchUpInside];
//    
//    //	// Add a label to the popover's view controller.
//    //	UILabel *popoverLabel = [[UILabel alloc] initWithFrame:CGRectMake(0., 0., 180, 180.)];
//    //	popoverLabel.text = @"POP!";
//    //	popoverLabel.font = [UIFont boldSystemFontOfSize:20.];
//    //	popoverLabel.textAlignment = NSTextAlignmentCenter;
//    //	popoverLabel.textColor = [UIColor yellowColor];
//    //	popoverLabel.backgroundColor = [UIColor darkGrayColor];
//	
//	[self.view addSubview:sortTypeButton1];
//	[self.view addSubview:sortTypeButton1u];
//	[self.view addSubview:sortTypeButton1d];
//	[self.view addSubview:sortTypeButton2];
//	[self.view addSubview:sortTypeButton2u];
//	[self.view addSubview:sortTypeButton2d];
//	[self.view addSubview:sortTypeButton3];
//	[self.view addSubview:sortTypeButton3u];
//	[self.view addSubview:sortTypeButton3d];
//	[self.view addSubview:sortTypeButton4];
//	[self.view addSubview:sortTypeButton4u];
//	[self.view addSubview:sortTypeButton4d];
    //    [self.view addSubview:popoverLabel];
	
    [self createMenue];
//    [self.view setBackgroundColor: [UIColor clearColor]];
    UIBarButtonItem *aButtonItem = [[UIBarButtonItem alloc] initWithTitle:S_BUTTON_CANCEL style:UIBarButtonItemStylePlain target:self.delegate action:@selector(closeSortPopupView)];
    self.cancelButtonItem = aButtonItem;
    self.navigationItem.rightBarButtonItem = cancelButtonItem;
    self.tableView.allowsSelection = NO;
//    [self setDataSource: self];
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

#pragma mark -
#pragma mark Memory management

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}


- (void)viewDidUnload {
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}



#pragma mark - srot menu creation
- (void) createMenue
{
    if(self.sortMenuList == nil)
    {
        
        self.sortMenuList =[NSMutableArray arrayWithObjects:
                            S_SORT_BUTTON_DATE,
                            S_SORT_BUTTON_NAME,
                            S_SORT_BUTTON_SIZE,
                            S_SORT_BUTTON_TYPE,
                            nil];
    }
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
    return [sortMenuList count];
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
    //    cell.textLabel.text = [NSString stringWithFormat:@"%@%@",[sortMenuList objectAtIndex:indexPath.row],@"△▽"];//[parentVCDelegate replaceRSStr:[resolutionList objectAtIndex:indexPath.row]];
    cell.textLabel.text = [sortMenuList objectAtIndex:indexPath.row];
    NSInteger indexNumber = indexPath.row;
//    int indexNumber = 0;
    //
//    UIButton *sortTypeButton1 = [UIButton buttonWithType: UIButtonTypeRoundedRect];
//    sortTypeButton1.frame = CGRectMake(0.0, 0.0, 190.0, 35.0);
//    sortTypeButton1.titleLabel.font = [UIFont systemFontOfSize:14];
//    sortTypeButton1.titleLabel.textColor = [UIColor blackColor];
//    sortTypeButton1.backgroundColor = [UIColor clearColor];
//    sortTypeButton1.tag = (indexNumber + 1)*100;
//    //    [sortTypeButton1 setTitle: [sortMenuList objectAtIndex:indexPath.row] forState:UIControlStateNormal];
//    [sortTypeButton1 addTarget: self.delegate action:@selector(changeSortType:) forControlEvents:UIControlEventTouchUpInside];
    //    //
    UIButton *sortTypeButton1u = [UIButton buttonWithType: UIButtonTypeRoundedRect];
    [sortTypeButton1u setExclusiveTouch: YES];
    sortTypeButton1u.frame = CGRectMake(190.0, 4.5, 50.0, 35.0);
    sortTypeButton1u.titleLabel.font = [UIFont systemFontOfSize:14];
    sortTypeButton1u.titleLabel.textColor = [UIColor blackColor];
//    sortTypeButton1u.backgroundColor = [UIColor clearColor];
    sortTypeButton1u.tag = (indexNumber + 1)*100 + 1;
    [sortTypeButton1u setTitle: @"▽" forState:UIControlStateNormal];
    [sortTypeButton1u addTarget: self.delegate action:@selector(changeSortType:) forControlEvents:UIControlEventTouchUpInside];
    //    //
    UIButton *sortTypeButton1d = [UIButton buttonWithType: UIButtonTypeRoundedRect];
    [sortTypeButton1d setExclusiveTouch: YES];
    sortTypeButton1d.frame = CGRectMake(240.0, 4.5, 50.0, 35.0);
    sortTypeButton1d.titleLabel.font = [UIFont systemFontOfSize:14];
    sortTypeButton1d.titleLabel.textColor = [UIColor blackColor];
//    sortTypeButton1d.backgroundColor = [UIColor clearColor];
    sortTypeButton1d.tag = (indexNumber+ 1)*100 + 2;
    [sortTypeButton1d setTitle: @"△" forState:UIControlStateNormal];
    [sortTypeButton1d addTarget: self.delegate action:@selector(changeSortType:) forControlEvents:UIControlEventTouchUpInside];
    
    
    
//    UIButton *sortTypeButton1u = [UIButton buttonWithType: UIButtonTypeRoundedRect];
//    sortTypeButton1u.frame = CGRectMake(190.0,5.0, 40.0, 35.0);
//    sortTypeButton1u.titleLabel.font = [UIFont systemFontOfSize:18];
//    sortTypeButton1u.titleLabel.textColor = [UIColor blackColor];
//    sortTypeButton1u.backgroundColor = [UIColor clearColor];
//    [sortTypeButton1u setTitle: @"△" forState:UIControlStateNormal];
//    sortTypeButton1u.tag = (indexNumber + 1)*100 + 1;
//    //    [sortTypeButton1u setTitle: @"△" forState:UIControlStateNormal];
//    [sortTypeButton1u addTarget: self action:@selector(changeSortType:) forControlEvents:UIControlEventTouchUpInside];

    
    cell.backgroundColor = [UIColor whiteColor];
//    [cell.contentView addSubview:sortTypeButton1];
    [cell.contentView addSubview:sortTypeButton1d];
    [cell.contentView addSubview:sortTypeButton1u];
    
    // 選択状態
    //    cell.accessoryType = (indexPath.row == nSelectResolutionIndexRow ? UITableViewCellAccessoryCheckmark:UITableViewCellAccessoryNone);
    return cell;
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // セルの複数タップを制御する
    if ( ! [self.navigationController.visibleViewController isKindOfClass: [self class]] ) {
        DLog(@"visibleViewController is Invalid");
        return;
    }

    // ハイライトOFF
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    // 選択番号の更新
//    nSelectResolutionIndexRow = indexPath.row;
    
    // チェックの設定
    //    for(int i = 0; i < [sortMenuList count]; i++){
    //        UITableViewCell * cell = [tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:i inSection:indexPath.section]];
    //        int accessory = UITableViewCellAccessoryNone;
    //        if(i == indexPath.row){
    //            accessory = UITableViewCellAccessoryCheckmark;
    //        }
    //
    //        [cell setAccessoryType:accessory];
    //    }
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

//- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
//{
//    return @"　　　並べ替え";
//}
//

@end
