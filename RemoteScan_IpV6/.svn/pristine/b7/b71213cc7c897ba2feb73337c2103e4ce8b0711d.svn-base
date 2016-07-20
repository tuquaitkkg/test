
#import "SettingSelMailDisplaySettingTableViewController.h"

@interface SettingSelMailDisplaySettingTableViewController ()

@end

@implementation SettingSelMailDisplaySettingTableViewController

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

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    DLog(@"dataArray = %@",self.dataArray);
    DLog(@"selectedType = %ld",(long)self.selectedType);
    DLog(@"selectedIndex = %ld",(long)self.selectedIndex);
    
    if (self.selectedType == 90) {
        self.navigationItem.title = S_SETTING_EMAIL_GET_NUMBER;
    } else if (self.selectedType == 91) {
        self.navigationItem.title = S_SETTING_EMAIL_FILTER_SETTING;
    }
    
    if (isIOS9Later) {
        // iOS9(+ Xcode7以降)- デフォルトレイアウト設定のUITableViewの両端の余白を出さないようにする。
        self.tableView.cellLayoutMarginsFollowReadableWidth = NO;
    }
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

// iPad用
- (void)popRootView
{
    [self.navigationController popToRootViewControllerAnimated:YES];
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
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    
    cell.textLabel.text = [self.dataArray objectAtIndex:indexPath.row];
    // フォントサイズ設定
    cell.textLabel.font = [UIFont systemFontOfSize:16];

    
    if ([S_LANG isEqualToString:S_LANG_PL] || [S_LANG isEqualToString:S_LANG_EL])
    {
        if (self.selectedType == 91 && //フィルター設定で
            floor(NSFoundationVersionNumber) <= NSFoundationVersionNumber_iOS_6_1 && // iOS6以下の
            indexPath.row == 3) { // 4行目なら
            NSString *modelname = [[UIDevice currentDevice]model];
            DLog(@"%@",modelname);
            //iPhone, iPod touchの場合
            if([modelname isEqualToString:@"iPhone"] ||
               [modelname isEqualToString:@"iPod touch"] ||
               [modelname isEqualToString:@"iPhone Simulator"]){
                
                // ポーランドとギリシャの場合は改行
                cell.textLabel.numberOfLines = 2;
            }
        }
    }

    if (self.selectedIndex == indexPath.row) {
        [cell setAccessoryType:UITableViewCellAccessoryCheckmark];
    }
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([S_LANG isEqualToString:S_LANG_PL] || [S_LANG isEqualToString:S_LANG_EL])
    {
        if (self.selectedType == 91 && //フィルター設定で
            floor(NSFoundationVersionNumber) <= NSFoundationVersionNumber_iOS_6_1 && // iOS6以下の
            indexPath.row == 3) { // 4行目なら
            //iPhoneの場合
            NSString *modelname = [[UIDevice currentDevice]model];
            if([modelname isEqualToString:@"iPhone"] ||
               [modelname isEqualToString:@"iPod touch"] ||
               [modelname isEqualToString:@"iPhone Simulator"]){
                
                // ポーランドとギリシャの場合は改行
                return 66;
            }
        }
    }
    return 44;
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
