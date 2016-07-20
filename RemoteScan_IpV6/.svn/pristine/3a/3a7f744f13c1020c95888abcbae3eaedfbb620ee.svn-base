
#import "OptionChangeTableViewController.h"

@interface OptionChangeTableViewController ()
@end

@implementation OptionChangeTableViewController

- (id)initWithType:(NSInteger)type withIndex:(NSInteger)index {
    self = [self initWithStyle:UITableViewStyleGrouped];
    if (self) {
        self.type = type;
        self.selectedIndex = index;
    }
    return self;
}

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.navigationController.navigationBar.barStyle = NAVIGATION_BARSTYLE;
    UIBarButtonItem *cancelBtn = [[UIBarButtonItem alloc]initWithTitle:S_BUTTON_CANCEL style:UIBarButtonItemStylePlain target:self action:@selector(cancel)];
    UIBarButtonItem *changeBtn = [[UIBarButtonItem alloc]initWithTitle:S_BUTTON_DECIDE style:UIBarButtonItemStylePlain target:self action:@selector(change)];
    self.navigationItem.leftBarButtonItem = cancelBtn;
    self.navigationItem.rightBarButtonItem = changeBtn;
    
    NSString* title = nil;//ナビゲーションバーのタイトル文言
    
    if (self.type == MAIL_OPTION_TYPE_1) {
        // 取得件数
        self.dataArray = @[@"10",@"30",@"50",@"100"];
        self.selectedIndex = [self.dataArray indexOfObject:[NSString stringWithFormat:@"%ld",(long)self.selectedIndex]];
        title = S_SETTING_MAILSERVER_GET_NUMBER;
    } else if (self.type == MAIL_OPTION_TYPE_2) {
        // フィルタリング設定
        NSString *obj0 = S_TITLE_SETTING_MAILSERVER_FILTER_0;
        NSString *obj1 = S_TITLE_SETTING_MAILSERVER_FILTER_1;
        NSString *obj2 = S_TITLE_SETTING_MAILSERVER_FILTER_2;
        NSString *obj3 = S_TITLE_SETTING_MAILSERVER_FILTER_3;
        self.dataArray = @[obj0,obj1,obj2,obj3];
        title = S_SETTING_MAILSERVER_FILTER_SETTING;
    }
    
    //タイトル
    float titleViewWidth = self.view.frame.size.width - self.navigationItem.leftBarButtonItem.customView.frame.size.width - self.navigationItem.rightBarButtonItem.customView.frame.size.width;
    CGRect rect = (CGRect){{0, 0},{titleViewWidth,44}};
    UILabel* titleLabel= [[UILabel alloc] initWithFrame:rect];
    titleLabel.text = title;
    titleLabel.backgroundColor = [UIColor clearColor];
    titleLabel.textColor = NAVIGATION_TITLE_COLOR;
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.font = [UIFont boldSystemFontOfSize:18];
    titleLabel.adjustsFontSizeToFitWidth = YES;
    self.navigationItem.titleView = titleLabel;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)cancel {
    if (self.delegate != nil) {
        [self.delegate cancelBtnPushed];
    }
}

- (void)change {
    if (self.delegate != nil) {
        if (self.type == MAIL_OPTION_TYPE_1) {
            NSString *num = [self.dataArray objectAtIndex:self.selectedIndex];
            [self.delegate mailNumChanged:num.integerValue];
        } else if (self.type == MAIL_OPTION_TYPE_2) {
            [self.delegate filterChanged:self.selectedIndex];
        }
    }
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
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
    // フォントサイズ設定
    cell.textLabel.font = [UIFont systemFontOfSize:16];
    [cell.textLabel setText:[self.dataArray objectAtIndex:indexPath.row]];
    DLog(@"height:%f",cell.frame.size.height);
    if ([S_LANG isEqualToString:S_LANG_PL] || [S_LANG isEqualToString:S_LANG_EL])
    {
        if (self.type == MAIL_OPTION_TYPE_2 && //フィルター設定で
            floor(NSFoundationVersionNumber) <= NSFoundationVersionNumber_iOS_6_1 && // iOS6以下の
            indexPath.row == 3) { // 4行目なら
            // ポーランドとギリシャの場合は改行
            cell.textLabel.numberOfLines = 2;
        }
    }
    if (self.selectedIndex == indexPath.row) {
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    }
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([S_LANG isEqualToString:S_LANG_PL] || [S_LANG isEqualToString:S_LANG_EL])
    {
        if (self.type == MAIL_OPTION_TYPE_2 && //フィルター設定で
            floor(NSFoundationVersionNumber) <= NSFoundationVersionNumber_iOS_6_1 && // iOS6以下の
            indexPath.row == 3) { // 4行目なら
            // ポーランドとギリシャの場合は改行
            return 66;
        }
    }
    return 44;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    for (NSInteger i = 0; i < self.dataArray.count; i++) {
        UITableViewCell *cell = [tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:i inSection:0]];
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
    
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    cell.accessoryType = UITableViewCellAccessoryCheckmark;
    
    self.selectedIndex = indexPath.row;
}

@end
