
#import "SelectFileSortPopViewController_ipad.h"
#import "Define.h"
#import "CommonUtil.h"

#import "ArrengeSelectFileViewController_iPad.h"
#import "SearchResultViewController_iPad.h"
#import "AdvancedSearchResultViewController_iPad.h"

@implementation SelectFileSortPopViewController_ipad

@synthesize delegate;
//@synthesize sortMenu;
@synthesize sortMenuList;
@synthesize nSelectResolutionIndexRow;

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
    
    // セルのラインを表示する
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    
    self.title = S_SORT_TITLE;
    self.contentSizeForViewInPopover = CGSizeMake(300.0, 194.0);
//    self.sortMenu.view.frame=CGRectMake(0.0,0.0,210.0,169.0);
    [self createMenue];
//    self.sortMenu = [[UITableViewController alloc]initWithStyle:UITableViewStyleGrouped];
    self.tableView.dataSource = self;
    [self.tableView setScrollEnabled: NO];
//    self.sortMenu.tableView.tableHeaderView.hidden=YES;
//    self.sortMenu.tableView.tableFooterView.hidden=YES;
//
//    [self.view addSubview: self.sortMenu.view];
    self.tableView.allowsSelection = NO;
}

- (void)viewWillAppear:(BOOL)animated {
    
    // Ensure the complete list of recents is shown on first display.
    [super viewWillAppear:animated];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    return YES;
}

- (void) changeSortType: (UIButton*) button
{
    //    [self.delegate setSortType:(enum ScanDataSortType)button.tag];
    switch (button.tag) {
        case 100:
            [CommonUtil setScanDataSortType:SCANDATA_FILEDATE];
            break;
        case 101:
            [CommonUtil setScanDataSortType:SCANDATA_FILEDATE];
            [CommonUtil ScanDataSortDirectionType:SCANDATA_ASC];
            break;
        case 102:
            [CommonUtil setScanDataSortType:SCANDATA_FILEDATE];
            [CommonUtil ScanDataSortDirectionType:SCANDATA_DES];
            break;
        case 200:
            [CommonUtil setScanDataSortType:SCANDATA_FILENAME];
            break;
        case 201:
            [CommonUtil setScanDataSortType:SCANDATA_FILENAME];
            [CommonUtil ScanDataSortDirectionType:SCANDATA_ASC];
            break;
        case 202:
            [CommonUtil setScanDataSortType:SCANDATA_FILENAME];
            [CommonUtil ScanDataSortDirectionType:SCANDATA_DES];
            break;
        case 300:
            [CommonUtil setScanDataSortType:SCANDATA_FILESIZE];
            break;
        case 301:
            [CommonUtil setScanDataSortType:SCANDATA_FILESIZE];
            [CommonUtil ScanDataSortDirectionType:SCANDATA_ASC];
            break;
        case 302:
            [CommonUtil setScanDataSortType:SCANDATA_FILESIZE];
            [CommonUtil ScanDataSortDirectionType:SCANDATA_DES];
            break;
        case 400:
            [CommonUtil setScanDataSortType:SCANDATA_FILETYPE];
            break;
        case 401:
            [CommonUtil setScanDataSortType:SCANDATA_FILETYPE];
            [CommonUtil ScanDataSortDirectionType:SCANDATA_ASC];
            break;
        case 402:
            [CommonUtil setScanDataSortType:SCANDATA_FILETYPE];
            [CommonUtil ScanDataSortDirectionType:SCANDATA_DES];
            break;
        default:
            break;
    }
    [self.delegate viewWillAppear:YES];

    UIImage *buttonImage;
    switch ([CommonUtil scanDataSortType]) {
        case SCANDATA_FILEDATE:
            if([CommonUtil scanDataSortDirectionType] == SCANDATA_ASC)
            {
                buttonImage = [UIImage imageNamed:S_ICON_SORTTIMEASC];
            }
            else
            {
                buttonImage = [UIImage imageNamed:S_ICON_SORTTIMEDES];
            }
            break;
        case SCANDATA_FILENAME:
            if([CommonUtil scanDataSortDirectionType] == SCANDATA_ASC)
            {
                buttonImage = [UIImage imageNamed:S_ICON_SORTFILEASC];
            }
            else
            {
                buttonImage = [UIImage imageNamed:S_ICON_SORTFILEDES];
            }
            break;
        case SCANDATA_FILESIZE:
            if([CommonUtil scanDataSortDirectionType] == SCANDATA_ASC)
            {
                buttonImage = [UIImage imageNamed:S_ICON_SORTSIZEASC];
            }
            else
            {
                buttonImage = [UIImage imageNamed:S_ICON_SORTSIZEDES];
            }
            break;
        case SCANDATA_FILETYPE:
            if([CommonUtil scanDataSortDirectionType] == SCANDATA_ASC)
            {
                buttonImage = [UIImage imageNamed:S_ICON_SORTTYPEASC];
            }
            else
            {
                buttonImage = [UIImage imageNamed:S_ICON_SORTTYPEDES];
            }
        default:
            break;
    }

    
    if ([self.delegate isKindOfClass:[ArrengeSelectFileViewController_iPad class]]) {
        [[(ArrengeSelectFileViewController_iPad*)self.delegate sortViewPopoverController] dismissPopoverAnimated:YES];
        ArrengeSelectFileViewController_iPad *controller = (ArrengeSelectFileViewController_iPad*)self.delegate;
        [controller.sortTypeButton setBackgroundImage:buttonImage forState:UIControlStateNormal];
    }else if ([self.delegate isKindOfClass:[SelectFileViewController_iPad class]]) {
        [[(SelectFileViewController_iPad*)self.delegate sortViewPopoverController] dismissPopoverAnimated:YES];
        SelectFileViewController_iPad *controller = (SelectFileViewController_iPad*)self.delegate;
        [controller.sortTypeButton setBackgroundImage:buttonImage forState:UIControlStateNormal];
    }else if ([self.delegate isKindOfClass:[SearchResultViewController_iPad class]]) {
        [[(SearchResultViewController_iPad*)self.delegate sortViewPopoverController] dismissPopoverAnimated:YES];
        SearchResultViewController_iPad *controller = (SearchResultViewController_iPad*)self.delegate;
        [controller.sortTypeButton setBackgroundImage:buttonImage forState:UIControlStateNormal];
    }else if ([self.delegate isKindOfClass:[AdvancedSearchResultViewController_iPad class]]) {
        [[(AdvancedSearchResultViewController_iPad*)self.delegate sortViewPopoverController] dismissPopoverAnimated:YES];
        AdvancedSearchResultViewController_iPad *controller = (AdvancedSearchResultViewController_iPad*)self.delegate;
        [controller.sortTypeButton setBackgroundImage:buttonImage forState:UIControlStateNormal];
    }
//    [[self.delegate sortViewPopoverController] dismissPopoverAnimated:YES];
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
        
        self.sortMenuList =[NSMutableArray arrayWithObjects: S_SORT_BUTTON_DATE,
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
//    [cell.   allowsSelection: NO];
    
    // セルタイトル
//    cell.textLabel.text = [NSString stringWithFormat:@"%@%@",[sortMenuList objectAtIndex:indexPath.row],@"△▽"];//[parentVCDelegate replaceRSStr:[resolutionList objectAtIndex:indexPath.row]];
    cell.textLabel.text = [sortMenuList objectAtIndex:indexPath.row];
    NSInteger indexNumber = indexPath.row;
//    //
//    UIButton *sortTypeButton1 = [UIButton buttonWithType: UIButtonTypeCustom];
//    sortTypeButton1.frame = CGRectMake(0.0, 0.0, 130.0, 35.0);
//    sortTypeButton1.titleLabel.font = [UIFont systemFontOfSize:14];
//    sortTypeButton1.titleLabel.textColor = [UIColor blackColor];
//    sortTypeButton1.titleLabel.text = [self.sortMenuList objectAtIndex:indexNumber];
//    sortTypeButton1.backgroundColor = [UIColor clearColor];
//    sortTypeButton1.tag = (indexNumber + 1)*100;
//    [sortTypeButton1 setTitle: [sortMenuList objectAtIndex:indexPath.row] forState:UIControlStateNormal];
//    [sortTypeButton1 addTarget: self action:@selector(changeSortType:) forControlEvents:UIControlEventTouchUpInside];
    //    //
    UIButton *sortTypeButton1u = [UIButton buttonWithType: UIButtonTypeRoundedRect];
    [sortTypeButton1u setExclusiveTouch: YES];
    sortTypeButton1u.frame = CGRectMake(190.0,5.0, 40.0, 35.0);
    sortTypeButton1u.titleLabel.font = [UIFont systemFontOfSize:18];
    sortTypeButton1u.titleLabel.textColor = [UIColor blackColor];
    sortTypeButton1u.backgroundColor = [UIColor clearColor];
    [sortTypeButton1u setTitle: @"▽" forState:UIControlStateNormal];
    sortTypeButton1u.tag = (indexNumber + 1)*100 + 1;
//    [sortTypeButton1u setTitle: @"△" forState:UIControlStateNormal];
    [sortTypeButton1u addTarget: self action:@selector(changeSortType:) forControlEvents:UIControlEventTouchUpInside];
    //    //
    UIButton *sortTypeButton1d = [UIButton buttonWithType: UIButtonTypeRoundedRect];
    [sortTypeButton1d setExclusiveTouch: YES];
    sortTypeButton1d.frame = CGRectMake(230.0, 5.0, 40.0, 35.0);
    sortTypeButton1d.titleLabel.font = [UIFont systemFontOfSize:18];
    sortTypeButton1d.titleLabel.textColor = [UIColor blackColor];
    sortTypeButton1d.backgroundColor = [UIColor clearColor];
    [sortTypeButton1d setTitle: @"△" forState:UIControlStateNormal];
    sortTypeButton1d.tag = (indexNumber+ 1)*100 + 2;
//    [sortTypeButton1d setTitle: @"▽" forState:UIControlStateNormal];
    [sortTypeButton1d addTarget: self action:@selector(changeSortType:) forControlEvents:UIControlEventTouchUpInside];
    
    cell.backgroundColor = [UIColor whiteColor];
//    [cell.contentView addSubview:sortTypeButton1];
    [cell.contentView addSubview:sortTypeButton1d];
    [cell.contentView addSubview:sortTypeButton1u];
    
    // 選択状態
//    cell.accessoryType = (indexPath.row == nSelectResolutionIndexRow ? UITableViewCellAccessoryCheckmark:UITableViewCellAccessoryNone);
    return cell;
    
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
    nSelectResolutionIndexRow = indexPath.row;
    
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

//- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
//{
//    return @"　　　並べ替え";
//}
//
@end




