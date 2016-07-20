
#import "SettingSelInfoViewController.h"
#import "SharpScanPrintAppDelegate.h"
#import "SettingSelDeviceViewController.h"
#import "SettingUserInfoViewController.h"
#import "SettingApplicationViewController.h"
#import "SettingMailServerInfoViewController.h"
#import "Define.h"

@implementation SettingSelInfoViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self)
    {
        // Custom initialization
    }
    return self;
}


- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];

    // セルのラインを表示する
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;

    // ナビゲーションバー
    // タイトル設定
    self.navigationItem.title = S_TITLE_SETTING;
    
    // 戻るボタンの名称変更
    UIBarButtonItem * barItemBack = [UIBarButtonItem new];
    barItemBack.title = S_BUTTON_BACK;
    self.navigationItem.backBarButtonItem = barItemBack;
    
    // 色変更
    //self.navigationController.navigationBar.tintColor = [UIColor blackColor];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

// iPad用
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    // 縦表示の時はメニューボタンを表示
    SharpScanPrintAppDelegate* pAppDelegate = (SharpScanPrintAppDelegate*)[[UIApplication sharedApplication] delegate];
    [pAppDelegate setPortraitMenuButton];
    
    if (![pAppDelegate.navigationController.viewControllers containsObject:self])
    {
        // モーダルで開いている場合は右に閉じるボタンを追加
        UIBarButtonItem *closeButton = [[UIBarButtonItem alloc] initWithTitle:S_BUTTON_CLOSE
                                                                        style:UIBarButtonItemStylePlain
                                                                       target:self
                                                                       action:@selector(closeAction)];
        self.navigationItem.rightBarButtonItem = closeButton;
        
    }
}

/*
 - (void)viewWillAppear:(BOOL)animated
 {
 [super viewWillAppear:animated];
 }
 */

/*
 - (void)viewDidAppear:(BOOL)animated
 {
 [super viewDidAppear:animated];
 }
 */

/*
 - (void)viewWillDisappear:(BOOL)animated
 {
 [super viewWillDisappear:animated];
 }
 */

/*
 - (void)viewDidDisappear:(BOOL)animated
 {
 [super viewDidDisappear:animated];
 }
 */

/*
 - (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
 {
 // Return YES for supported orientations
 return (interfaceOrientation == UIInterfaceOrientationPortrait);
 }
 */

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return N_NUM_SECTION_SETTING;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0)
    {
        /* 除外MFPリストは国内版のみ対応 */
        // 20121113 国内版でも除外リストは削除
        if (0)
        {
            // Return the number of rows in the section.
            return N_NUM_ROW_SETTING_SEL_SEC1;
        }
        else
        {
//            return N_NUM_ROW_SETTING_SEL_SEC1 -1;
            return N_NUM_ROW_SETTING_SEL_SEC1 -2; // TODO: プリントサーバー機能を一旦外す
        }
    }           
    else
    {
        return 0;        
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    
    if (cell == nil) 
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    cell.accessoryType = TABLE_CELL_ACCESSORY;
        
    // アイコン名
    NSMutableString* pstrIconName = [[NSMutableString alloc] initWithCapacity:100];
    
    // 表示項目の設定
    if(indexPath.section == 0)
    {
        // TODO: プリントサーバー機能を一旦外す
//        switch (indexPath.row)
//        {
//            case 0:
//                cell.textLabel.text = S_SETTING_DEVICE;
//                cell.textLabel.font = [UIFont systemFontOfSize:12];
//                cell.textLabel.lineBreakMode = NSLineBreakByWordWrapping;
//                cell.textLabel.numberOfLines = 2;
//                [pstrIconName appendString:S_ICON_SETTING_DEVICE];
//                break;
//            case 1:
////                cell.textLabel.text = S_SETTING_SERVER; //*** ローカライズが必要
//                cell.textLabel.text = @"プリントサーバーを設定";
//                cell.textLabel.font = [UIFont systemFontOfSize:12];
//                cell.textLabel.lineBreakMode = NSLineBreakByWordWrapping;
//                cell.textLabel.numberOfLines = 2;
//                [pstrIconName appendString:S_ICON_SETTING_SERVER];
//                break;
//            case 2:
//                /* 除外MFPリストは国内版のみ対応 */
//                // 20121113 国内版でも除外リストは削除
//                if (0)
//                {
//                    cell.textLabel.text = S_SETTING_EXCLUDE_MFP;
//                    cell.textLabel.font = [UIFont systemFontOfSize:12];
//                    cell.textLabel.lineBreakMode = NSLineBreakByWordWrapping;
//                    cell.textLabel.numberOfLines = 2;
//                    [pstrIconName appendString:S_ICON_SETTING_EXCLUDE_MFP];
//                }
//                else
//                {
//                    cell.textLabel.text = S_SETTING_USERINFO;
//                    cell.textLabel.font = [UIFont systemFontOfSize:12];
//                    cell.textLabel.lineBreakMode = NSLineBreakByWordWrapping;
//                    cell.textLabel.numberOfLines = 2;
//                    [pstrIconName appendString:S_ICON_SETTING_USERINFO];
//                }
//                break;
//            case 3:
//                /* 除外MFPリストは国内版のみ対応 */
//                // 20121113 国内版でも除外リストは削除
//                if (0)
//                {
//                    cell.textLabel.text = S_SETTING_USERINFO;
//                    cell.textLabel.font = [UIFont systemFontOfSize:12];
//                    cell.textLabel.lineBreakMode = NSLineBreakByWordWrapping;
//                    cell.textLabel.numberOfLines = 2;
//                    [pstrIconName appendString:S_ICON_SETTING_USERINFO];
//                }
//                else
//                {
//                    cell.textLabel.text = S_SETTING_APPLICATION;
//                    cell.textLabel.font = [UIFont systemFontOfSize:12];
//                    cell.textLabel.lineBreakMode = NSLineBreakByWordWrapping;
//                    cell.textLabel.numberOfLines = 2;
//                    [pstrIconName appendString:S_ICON_SETTING_APPLICATION];
//                }
//                break;
//            case 4:
//                /* 除外MFPリストは国内版のみ対応 */
//                // 20121113 国内版でも除外リストは削除
//                if (0)
//                {
//                    cell.textLabel.text = S_SETTING_APPLICATION;
//                    cell.textLabel.font = [UIFont systemFontOfSize:12];
//                    cell.textLabel.lineBreakMode = NSLineBreakByWordWrapping;
//                    cell.textLabel.numberOfLines = 2;
//                    [pstrIconName appendString:S_ICON_SETTING_APPLICATION];
//                }
//                else
//                {
//                    cell.textLabel.text = S_SETTING_MAIL_SERVERINFO;
//                    cell.textLabel.font = [UIFont systemFontOfSize:12];
//                    cell.textLabel.lineBreakMode = NSLineBreakByWordWrapping;
//                    cell.textLabel.numberOfLines = 2;
//                    [pstrIconName appendString:S_ICON_SETTING_MAIL_SERVERINFO];
//                    
//                }
//                break;
//            case 5:
//                cell.textLabel.text = S_SETTING_MAIL_SERVERINFO;
//                cell.textLabel.font = [UIFont systemFontOfSize:12];
//                cell.textLabel.lineBreakMode = NSLineBreakByWordWrapping;
//                cell.textLabel.numberOfLines = 2;
//                [pstrIconName appendString:S_ICON_SETTING_MAIL_SERVERINFO];
//                break;
//            default:
//                break;
//        }
        switch (indexPath.row)
        {
            case 0:
                cell.textLabel.text = S_SETTING_DEVICE;
                cell.textLabel.font = [UIFont systemFontOfSize:12];
                cell.textLabel.lineBreakMode = NSLineBreakByWordWrapping;
                cell.textLabel.numberOfLines = 2;
                [pstrIconName appendString:S_ICON_SETTING_DEVICE];
                break;
            case 1:
                /* 除外MFPリストは国内版のみ対応 */
                // 20121113 国内版でも除外リストは削除
                if (0)
                {
                    cell.textLabel.text = S_SETTING_EXCLUDE_MFP;
                    cell.textLabel.font = [UIFont systemFontOfSize:12];
                    cell.textLabel.lineBreakMode = NSLineBreakByWordWrapping;
                    cell.textLabel.numberOfLines = 2;
                    [pstrIconName appendString:S_ICON_SETTING_EXCLUDE_MFP];
                }
                else
                {
                    cell.textLabel.text = S_SETTING_USERINFO;
                    cell.textLabel.font = [UIFont systemFontOfSize:12];
                    cell.textLabel.lineBreakMode = NSLineBreakByWordWrapping;
                    cell.textLabel.numberOfLines = 2;
                    [pstrIconName appendString:S_ICON_SETTING_USERINFO];
                }
                break;
            case 2:
                /* 除外MFPリストは国内版のみ対応 */
                // 20121113 国内版でも除外リストは削除
                if (0)
                {
                    cell.textLabel.text = S_SETTING_USERINFO;
                    cell.textLabel.font = [UIFont systemFontOfSize:12];
                    cell.textLabel.lineBreakMode = NSLineBreakByWordWrapping;
                    cell.textLabel.numberOfLines = 2;
                    [pstrIconName appendString:S_ICON_SETTING_USERINFO];
                }
                else
                {
                    cell.textLabel.text = S_SETTING_APPLICATION;
                    cell.textLabel.font = [UIFont systemFontOfSize:12];
                    cell.textLabel.lineBreakMode = NSLineBreakByWordWrapping;
                    cell.textLabel.numberOfLines = 2;
                    [pstrIconName appendString:S_ICON_SETTING_APPLICATION];
                }
                break;
            case 3:
                /* 除外MFPリストは国内版のみ対応 */
                // 20121113 国内版でも除外リストは削除
                if (0)
                {
                    cell.textLabel.text = S_SETTING_APPLICATION;
                    cell.textLabel.font = [UIFont systemFontOfSize:12];
                    cell.textLabel.lineBreakMode = NSLineBreakByWordWrapping;
                    cell.textLabel.numberOfLines = 2;
                    [pstrIconName appendString:S_ICON_SETTING_APPLICATION];
                }
                else
                {
                    cell.textLabel.text = S_SETTING_MAIL_SERVERINFO;
                    cell.textLabel.font = [UIFont systemFontOfSize:12];
                    cell.textLabel.lineBreakMode = NSLineBreakByWordWrapping;
                    cell.textLabel.numberOfLines = 2;
                    [pstrIconName appendString:S_ICON_SETTING_MAIL_SERVERINFO];
                    
                }
                break;
            case 4:
                cell.textLabel.text = S_SETTING_MAIL_SERVERINFO;
                cell.textLabel.font = [UIFont systemFontOfSize:12];
                cell.textLabel.lineBreakMode = NSLineBreakByWordWrapping;
                cell.textLabel.numberOfLines = 2;
                [pstrIconName appendString:S_ICON_SETTING_MAIL_SERVERINFO];
                break;
            default:
                break;
        }
    }
    
    // アイコン設定
    UIImage* pIconImage = [UIImage imageNamed: pstrIconName];
    cell.imageView.image = pIconImage;
    
    return cell;
}

// テーブルビューの縦幅設定
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.section == 0)
    {
        return N_HEIGHT_SETTING_SEL_SEC1;
    }
    else
    {
        return 0;
    }
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
 - (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
 {
 // Return NO if you do not want the specified item to be editable.
 return YES;
 }
 */

/*
 // Override to support editing the table view.
 - (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
 {
 if (editingStyle == UITableViewCellEditingStyleDelete) {
 // Delete the row from the data source
 [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
 }   
 else if (editingStyle == UITableViewCellEditingStyleInsert) {
 // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
 }   
 }
 */

/*
 // Override to support rearranging the table view.
 - (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
 {
 }
 */

/*
 // Override to support conditional rearranging of the table view.
 - (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
 {
 // Return NO if you do not want the item to be re-orderable.
 return YES;
 }
 */

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self MoveView:indexPath];
}

- (void)tableView:(UITableView *)tableView accessoryButtonTappedForRowWithIndexPath:(NSIndexPath *)indexPath
{
    [self MoveView:indexPath];
}

// 画面遷移
- (void)MoveView:(NSIndexPath *)nIndexPath
{    
    // セルの複数タップを制御する
    if ( ! [self.navigationController.visibleViewController isKindOfClass: [self class]] ) {
        DLog(@"visibleViewController is Invalid");
        return;
    }

    if(nIndexPath.section == 0)
    {
        SettingSelDeviceViewController * pDevViewController;
//        SettingSelServerViewController * pSerViewController; // TODO: プリントサーバー機能を一旦外す
        SettingUserInfoViewController * pUserViewController;
        SettingApplicationViewController * pAppliViewController;
        SettingMailServerInfoViewController * pMailServerViewController;
        
        // TODO: プリントサーバー機能を一旦外す
//        switch (nIndexPath.row)
//        {
//            case 0:
//                // プリンター/スキャナー設定画面に遷移
//                pDevViewController = [[SettingSelDeviceViewController alloc] initWithStyle:UITableViewStyleGrouped];
//                [self.navigationController pushViewController:pDevViewController animated:YES];
//                break;
//            case 1:
//                // プリンター/スキャナー設定画面に遷移
//                pSerViewController = [[SettingSelServerViewController alloc] initWithStyle:UITableViewStyleGrouped];
//                [self.navigationController pushViewController:pSerViewController animated:YES];
//                break;
//            case 2:
//                /* 除外MFPリストは国内版のみ対応 */
//                // 20121113 国内版でも除外リストは削除
//                if (0)
//                {
//                    // 除外プリンター/スキャナーを設定画面に遷移
//                    pExcludeMfpViewController = [[SettingExcludeMfpSelectViewController alloc] initWithStyle:UITableViewStyleGrouped];
//                    [self.navigationController pushViewController:pExcludeMfpViewController animated:YES];
//                }
//                else
//                {
//                    // ユーザ情報設定画面に遷移
//                    pUserViewController = [[SettingUserInfoViewController alloc] initWithStyle:UITableViewStyleGrouped];
//                    [self.navigationController pushViewController:pUserViewController animated:YES];
//                }
//                break;
//            case 3:
//                /* 除外MFPリストは国内版のみ対応 */
//                // 20121113 国内版でも除外リストは削除
//                if (0)
//                {
//                    // ユーザ情報設定画面に遷移
//                    pUserViewController = [[SettingUserInfoViewController alloc] initWithStyle:UITableViewStyleGrouped];
//                    [self.navigationController pushViewController:pUserViewController animated:YES];
//                }
//                else
//                {
//                    // アプリケーション設定画面に遷移
//                    pAppliViewController = [[SettingApplicationViewController alloc] initWithStyle:UITableViewStyleGrouped];
//                    [self.navigationController pushViewController:pAppliViewController animated:YES];
//                }
//                break;
//            case 4:
//                /* 除外MFPリストは国内版のみ対応 */
//                // 20121113 国内版でも除外リストは削除
//                if (0)
//                {
//                    // アプリケーション設定画面に遷移
//                    pAppliViewController = [[SettingApplicationViewController alloc] initWithStyle:UITableViewStyleGrouped];
//                    [self.navigationController pushViewController:pAppliViewController animated:YES];
//                }
//                else
//                {
//                    // メールサーバー情報設定画面に遷移
//                    pMailServerViewController = [[SettingMailServerInfoViewController alloc] initWithStyle:UITableViewStyleGrouped];
//                    [self.navigationController pushViewController:pMailServerViewController animated:YES];
//                }
//                break;
//            case 5:
//                // メールサーバー情報設定画面に遷移
//                pMailServerViewController = [[SettingMailServerInfoViewController alloc] initWithStyle:UITableViewStyleGrouped];
//                [self.navigationController pushViewController:pMailServerViewController animated:YES];
//                break;
//            default:
//                break;
//        }
        switch (nIndexPath.row)
        {
            case 0:
                // プリンター/スキャナー設定画面に遷移
                pDevViewController = [[SettingSelDeviceViewController alloc] initWithStyle:UITableViewStyleGrouped];
                [self.navigationController pushViewController:pDevViewController animated:YES];
                break;
            case 1:
                // ユーザ情報設定画面に遷移
                pUserViewController = [[SettingUserInfoViewController alloc] initWithStyle:UITableViewStyleGrouped];
                [self.navigationController pushViewController:pUserViewController animated:YES];
                break;
            case 2:
                // アプリケーション設定画面に遷移
                pAppliViewController = [[SettingApplicationViewController alloc] initWithStyle:UITableViewStyleGrouped];
                [self.navigationController pushViewController:pAppliViewController animated:YES];
                break;
            case 3:
                // メールサーバー情報設定画面に遷移
                pMailServerViewController = [[SettingMailServerInfoViewController alloc] initWithStyle:UITableViewStyleGrouped];
                [self.navigationController pushViewController:pMailServerViewController animated:YES];
                break;
            default:
                break;
        }
    }
}

// キャンセルし画面を閉じる
- (void)closeAction
{
    NSNotification *n = [NSNotification notificationWithName:ST_CLOSE_BUTTON_PUSHED object:self];
    NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
    [nc postNotification:n];
}

@end
