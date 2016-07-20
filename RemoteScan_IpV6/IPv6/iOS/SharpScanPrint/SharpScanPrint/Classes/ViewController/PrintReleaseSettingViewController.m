#import "PrintReleaseSettingViewController.h"

@interface PrintReleaseSettingViewController ()

@end

@implementation PrintReleaseSettingViewController

@synthesize delegate;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // セルのラインを表示する
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    
    // テーブルビューをバウンドさせない
    self.tableView.bounces = NO;
    
    // ナビゲーションバー
    // タイトル設定
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad){
        //iPad
        //self.title = S_TITLE_RETENTION;
        self.contentSizeForViewInPopover = CGSizeMake(300.0, 194.0);
        self.tableView.dataSource = self;
        [self.tableView setScrollEnabled: NO];
        self.tableView.allowsSelection = NO;
    } else{
        //iPhone
        CGRect frame = CGRectMake(0, 0, 400, 44);
        UILabel* lblTitle = [[UILabel alloc]initWithFrame:frame];
        lblTitle.backgroundColor = [UIColor clearColor];
        lblTitle.textColor = NAVIGATION_TITLE_COLOR;
        lblTitle.font = [UIFont boldSystemFontOfSize:20];
        lblTitle.textAlignment = NSTextAlignmentCenter;
        lblTitle.text = S_TITLE_PRINTRELEASE;
        lblTitle.adjustsFontSizeToFitWidth = YES;
        self.navigationItem.titleView = lblTitle;
        
        // ナビゲーションバー左側にキャンセルボタンを設定
        UIBarButtonItem* btnClose = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel
                                                                                  target:self
                                                                                  action:@selector(cancelAction:)];
        self.navigationItem.leftBarButtonItem = btnClose;
        
    }
    
    // 決定ボタン追加
    UIBarButtonItem* btnSetting = [[UIBarButtonItem alloc] initWithTitle:S_BUTTON_DECIDE style:UIBarButtonItemStyleDone target:self action:@selector(decideAction:)];
    
    self.navigationItem.rightBarButtonItem = btnSetting;
}

// iPad用
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    // 縦表示の時はメニューボタンを表示
    SharpScanPrintAppDelegate* pAppDelegate = (SharpScanPrintAppDelegate*)[[UIApplication sharedApplication] delegate];
    [pAppDelegate setPortraitMenuButton];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSString *cellIdentifier = [NSString stringWithFormat:@"Cell%02ld%02ld", (long)indexPath.section, (long)indexPath.row];
    
    UITableViewCell* cell = (UITableViewCell*)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if(cell != nil) {
        return cell;
    }

    switch (indexPath.section) {
        case 0:
            switch (indexPath.row) {
                case 0:
                    cell = [self createPrintReleaseSwitchDataCell:cellIdentifier];
                    break;
                default:
                    break;
            }
            break;
        default:
            break;
    }
    
    return cell;
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

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma mark - NavigationBar Button Action

//
// キャンセルボタン処理
//
- (void)cancelAction:(id)sender
{
    if(delegate){
        if([delegate respondsToSelector:@selector(printReleaseSetting:canceled:)]){
            self.enabledPrintRelease = self.printReleaseEnableDataCell.switchField.on;
            // デリゲートメソッドの呼び出し(モーダルビューも閉じる)
            [delegate printReleaseSetting:self canceled:YES];
        }
    }
}

//
// 決定ボタン処理
//
- (IBAction)decideAction:(id)sender
{
    if(delegate){
        if([delegate respondsToSelector:@selector(printReleaseSetting:canceled:)]){
            self.enabledPrintRelease = self.printReleaseEnableDataCell.switchField.on;
            // デリゲートメソッドの呼び出し(モーダルビューも閉じる)
            [delegate printReleaseSetting:self canceled:NO];
        }
    }
    
}

#pragma mark - PrivateMethod

- (PrintReleaseSwitchDataCell*)createPrintReleaseSwitchDataCell:(NSString*)cellIdentifier
{
    PrintReleaseSwitchDataCell* dataCell = [[PrintReleaseSwitchDataCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    //dataCell.nameLabelCell.text = S_PRINTRELEASE_ENABLE;
    dataCell.nameLabelCell.text = S_TITLE_PRINTRELEASE;
    dataCell.switchField.on	= self.enabledPrintRelease;
    dataCell.switchField.tag = 0;
    [self setFontSizeOfNameLabelCell:dataCell];
    
    self.printReleaseEnableDataCell = dataCell;
    
    return dataCell;
}

- (SwitchDataCell*)setFontSizeOfNameLabelCell:(SwitchDataCell*)cell
{
    if(![S_LANG isEqualToString:S_LANG_EN]){
        // 自動調整サイズを取得
        CGFloat actualFontSize;
        [cell.nameLabelCell.text
         sizeWithFont:cell.nameLabelCell.font
         minFontSize:(cell.nameLabelCell.minimumScaleFactor * cell.nameLabelCell.font.pointSize)
         actualFontSize:&actualFontSize
         forWidth:cell.nameLabelCell.bounds.size.width
         lineBreakMode:cell.nameLabelCell.lineBreakMode];
        
        // 自動調整したフォントサイズが10以下なら、二段表示するか判定を行う
        if(actualFontSize < 11)
        {
            int iFontSize = [cell changeFontSize:cell.nameLabelCell.text];
            if (iFontSize != -1)
            {
                cell.nameLabelCell.lineBreakMode = NSLineBreakByWordWrapping;
                cell.nameLabelCell.numberOfLines = 2;
                [cell.nameLabelCell setFont:[UIFont systemFontOfSize:iFontSize]];
                // サイズ調整
                CGRect frame =  cell.nameLabelCell.frame;
                frame.size.height = 36;
                cell.nameLabelCell.frame = frame;
            }
        }
    } else {
        cell.nameLabelCell.lineBreakMode = NSLineBreakByWordWrapping;
        cell.nameLabelCell.numberOfLines = 2;
        // サイズ調整
        CGRect frame =  cell.nameLabelCell.frame;
        frame.size.height = 36;
        cell.nameLabelCell.frame = frame;
    }
    return cell;
}

@end
