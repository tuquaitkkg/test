
#import "SettingDeviceNameInfoTableViewController.h"
#define CELL_TITLE_LABEL_TAG 1000
#define RegularCell_HEIGHT 44

@interface SettingDeviceNameInfoTableViewController ()

@end

@implementation SettingDeviceNameInfoTableViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    DLog(@"dataArray = %@",self.dataArray);
//    DLog(@"selectedType = %ld",(long)self.selectedType);
    DLog(@"selectedIndex = %ld",(long)self.selectedIndex);
    
    self.navigationItem.title = S_TITLE_SETTING_DEVICENAME_STYLE;
    
    if (isIOS9Later) {
        // iOS9(+ Xcode7以降)- デフォルトレイアウト設定のUITableViewの両端の余白を出さないようにする。
        self.tableView.cellLayoutMarginsFollowReadableWidth = NO;
    }
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
    [super viewDidUnload];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

// iPad用
- (void)popRootView
{
    [self.navigationController popToRootViewControllerAnimated:YES];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    
    cell.textLabel.text = [self.dataArray objectAtIndex:indexPath.row];
    // フォントサイズ設定
    cell.textLabel.font = [UIFont systemFontOfSize:[UIFont systemFontSize]];
    cell.textLabel.adjustsFontSizeToFitWidth = YES;
    cell.textLabel.numberOfLines = 2;
    
    if (self.selectedIndex == indexPath.row) {
        [cell setAccessoryType:UITableViewCellAccessoryCheckmark];
    }
    return cell;
}

// ヘッダー表示前にフォントを設定
- (void)tableView:(UITableView *)tableView willDisplayHeaderView:(UIView *)view forSection:(NSInteger)section
{
    UITableViewHeaderFooterView *heView = (UITableViewHeaderFooterView *)view;
    heView.textLabel.font = [UIFont systemFontOfSize:N_TABLE_FONT_SIZE_HEADER];
}

//
// 各セクションのタイトルを決定する
//
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    NSString *title = @"";
    switch (section) {
        case 0:
            title = S_TITLE_SETTING_DEVICENAME_STYLE;
            break;
        default:
            break;
    }
    return title;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    // チェックの設定
    for(int i = 0; i < [self.dataArray count]; i++){
        UITableViewCell * cell = [tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:i inSection:indexPath.section]];
        int accessory = UITableViewCellAccessoryNone;
        if(i == indexPath.row){
            accessory = UITableViewCellAccessoryCheckmark;
        }
        [cell setAccessoryType:accessory];
    }
    
    self.selectedIndex = indexPath.row;
    if ([self.delegate respondsToSelector:@selector(callBackIndex:)]) {
        [self.delegate callBackIndex:self];
    }
    [self.navigationController popViewControllerAnimated:YES];
}

@end
