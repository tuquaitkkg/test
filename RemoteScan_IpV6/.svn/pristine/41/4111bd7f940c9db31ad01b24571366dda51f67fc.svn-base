
#import "SettingSelInfoViewController_iPad.h"
#import "SettingSelDeviceViewController_iPad.h"
#import "SettingUserInfoViewController_iPad.h"
#import "SettingApplicationViewController_iPad.h"
#import "SettingMailServerInfoViewController_iPad.h"
#import "Define.h"
// iPad用
#import "RootViewController_iPad.h"
#import "SharpScanPrintAppDelegate.h"

//#define S_SETTING_MAILSERVER @"メールサーバー情報を設定"

// iPad用

@implementation SettingSelInfoViewController_iPad

@synthesize selectIndexPath; // iPad用
@synthesize m_bVisibleMenuButton;

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
    
    // UINavigationBar 44px のずれを無くす
    self.navigationController.navigationBar.translucent = NO;
    self.navigationController.navigationBar.barStyle = NAVIGATION_BARSTYLE;
    
    // ナビゲーションバー
    // タイトル設定
    self.navigationItem.title = S_TITLE_SETTING;
    
    // 戻るボタンの名称変更
    UIBarButtonItem * barItemBack = [UIBarButtonItem new];
    barItemBack.title = S_BUTTON_BACK;
    self.navigationItem.backBarButtonItem = barItemBack;
    
    // 色変更
    //self.navigationController.navigationBar.tintColor = [UIColor blackColor];
    
	[self.tableView reloadData];
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
    [self.tableView reloadData];
    
    [super viewWillAppear:animated];
    
    if(selectIndexPath != nil)
    {
        // 指定の行を選択状態
        [self.tableView selectRowAtIndexPath:selectIndexPath animated:NO scrollPosition:UITableViewScrollPositionNone];
    }
    
    // 縦表示の時はメニューボタンを表示
    SharpScanPrintAppDelegate* pAppDelegate = (SharpScanPrintAppDelegate*)[[UIApplication sharedApplication] delegate];
    UINavigationController* pRootNavController = [pAppDelegate.splitViewController.viewControllers objectAtIndex:0];
    UINavigationController* dRootNavController = [pAppDelegate.splitViewController.viewControllers objectAtIndex:1];
    RootViewController_iPad* rootViewController = (RootViewController_iPad*)[pRootNavController.viewControllers objectAtIndex:0];
    if(m_bVisibleMenuButton)
    {
        // 左上メニューボタンのタイトル変更
        if(rootViewController.barItemMenu != nil)
        {
            rootViewController.barItemMenu.title = S_BUTTON_MENU;
            [self.navigationItem setLeftBarButtonItem:nil animated:NO];
        }
        
        [self.navigationItem setLeftBarButtonItem:rootViewController.barItemMenu animated:NO];
    }
    else
    {
        // Headerの高さを指定
        UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0.0, 0.0, self.view.frame.size.width, 20.0)];
        self.tableView.tableHeaderView = headerView;
        
        [self.navigationItem setLeftBarButtonItem:nil animated:NO];
    }
    
    if (![pRootNavController.viewControllers containsObject:self] && ![dRootNavController.viewControllers containsObject:self] )
    {
        // モーダルで開いている場合は右に閉じるボタンを追加
        UIBarButtonItem *closeButton = [[UIBarButtonItem alloc] initWithTitle:S_BUTTON_CLOSE
                                                                        style:UIBarButtonItemStylePlain
                                                                       target:self
                                                                       action:@selector(closeAction)];
        self.navigationItem.rightBarButtonItem = closeButton;

    }

}
// iPad用


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


// iPad用
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    
    // 横向きの場合
    if(interfaceOrientation == UIInterfaceOrientationLandscapeLeft || interfaceOrientation == UIInterfaceOrientationLandscapeRight)
    {
        // 縦向き表示時のメニューPopOverが表示されていたら閉じる
        [self dismissMenuPopOver:NO];
    }
    return YES;
}
// iPad用


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
//                [pstrIconName appendString:S_ICON_SETTING_DEVICE];
//                break;
//            case 1:
////                cell.textLabel.text = S_SETTING_SERVER; //*** ローカライズが必要
//                cell.textLabel.text = @"プリントサーバーを設定";
//                cell.textLabel.font = [UIFont systemFontOfSize:12];
//                [pstrIconName appendString:S_ICON_SETTING_SERVER];
//                break;
//            case 2:
//                /* 除外MFPリストは国内版のみ対応 */
//                // 20121113 国内版でも除外リストは削除
//                if (0)
//                {
//                    cell.textLabel.text = S_SETTING_EXCLUDE_MFP;
//                    cell.textLabel.font = [UIFont systemFontOfSize:12];
//                    [pstrIconName appendString:S_ICON_SETTING_EXCLUDE_MFP];
//                }
//                else
//                {
//                    cell.textLabel.text = S_SETTING_USERINFO;
//                    cell.textLabel.font = [UIFont systemFontOfSize:12];
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
//                    [pstrIconName appendString:S_ICON_SETTING_USERINFO];
//                }
//                else
//                {
//                    cell.textLabel.text = S_SETTING_APPLICATION;
//                    cell.textLabel.font = [UIFont systemFontOfSize:12];
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
//                    [pstrIconName appendString:S_ICON_SETTING_APPLICATION];
//                }
//                else
//                {
//                    cell.textLabel.text = S_SETTING_MAIL_SERVERINFO; //@"メールサーバー情報を設定";
//                    cell.textLabel.font = [UIFont systemFontOfSize:12];
//                    [pstrIconName appendString:S_ICON_SETTING_MAIL_SERVERINFO];
//                }
//                break;
//            case 5:
//                cell.textLabel.text = S_SETTING_MAIL_SERVERINFO; //@"メールサーバー情報を設定";
//                cell.textLabel.font = [UIFont systemFontOfSize:12];
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
                [pstrIconName appendString:S_ICON_SETTING_DEVICE];
                break;
            case 1:
                /* 除外MFPリストは国内版のみ対応 */
                // 20121113 国内版でも除外リストは削除
                if (0)
                {
                    cell.textLabel.text = S_SETTING_EXCLUDE_MFP;
                    cell.textLabel.font = [UIFont systemFontOfSize:12];
                    [pstrIconName appendString:S_ICON_SETTING_EXCLUDE_MFP];
                }
                else
                {
                    cell.textLabel.text = S_SETTING_USERINFO;
                    cell.textLabel.font = [UIFont systemFontOfSize:12];
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
                    [pstrIconName appendString:S_ICON_SETTING_USERINFO];
                }
                else
                {
                    cell.textLabel.text = S_SETTING_APPLICATION;
                    cell.textLabel.font = [UIFont systemFontOfSize:12];
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
                    [pstrIconName appendString:S_ICON_SETTING_APPLICATION];
                }
                else
                {
                    cell.textLabel.text = S_SETTING_MAIL_SERVERINFO; //@"メールサーバー情報を設定";
                    cell.textLabel.font = [UIFont systemFontOfSize:12];
                    [pstrIconName appendString:S_ICON_SETTING_MAIL_SERVERINFO];
                }
                break;
            case 4:
                cell.textLabel.text = S_SETTING_MAIL_SERVERINFO; //@"メールサーバー情報を設定";
                cell.textLabel.font = [UIFont systemFontOfSize:12];
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
        return N_HEIGHT_SETTING_SEL_SEC1 +1;
    }
    else
    {
        return 0;
    }
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
    // セルの複数タップを制御する
    if ( ! [self.navigationController.visibleViewController isKindOfClass: [self class]] ) {
        DLog(@"visibleViewController is Invalid");
        return;
    }
    
    [self MoveView:indexPath];
}

// iPad用
- (void)tableView:(UITableView *)tableView accessoryButtonTappedForRowWithIndexPath:(NSIndexPath *)indexPath
{
    // セルの複数タップを制御する
    if ( ! [self.navigationController.visibleViewController isKindOfClass: [self class]] ) {
        DLog(@"visibleViewController is Invalid");
        return;
    }
    
	@autoreleasepool
    {
        // アクセサリボタンの選択状態を解除するため、選択行を再読み込み
        [tableView reloadRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationNone];
        // 選択行を選択状態にする
        [tableView selectRowAtIndexPath:indexPath animated:NO scrollPosition:UITableViewScrollPositionNone];
        // 行選択イベント
        [self MoveView:indexPath];
        // 処理終了後にautoreleasePoolを解放
    }
}
// iPad用
// 画面遷移
- (void)MoveView:(NSIndexPath *)nIndexPath
{
    // 選択行保持
    NSUInteger newIndex[] = {nIndexPath.section, nIndexPath.row};
    selectIndexPath = [[NSIndexPath alloc] initWithIndexes:newIndex length:2];
    
    if(nIndexPath.section == 0)
    {
        SettingSelDeviceViewController_iPad* pDevViewController;
//        SettingSelServerViewController_iPad* pSerViewController; // TODO: プリントサーバー機能を一旦外す
        SettingUserInfoViewController_iPad* pUserViewController;
        SettingApplicationViewController_iPad* pAppliViewController;
        SettingMailServerInfoViewController_iPad* pMServerViewController;
        
        // TODO: プリントサーバー機能を一旦外す
//        switch (nIndexPath.row)
//        {
//            case 0:
//            {
//                // プリンター/スキャナー設定画面に遷移
//                pDevViewController = [[SettingSelDeviceViewController_iPad alloc] initWithStyle:UITableViewStyleGrouped];
//                // iPad用
//                if (self.m_bVisibleMenuButton) {
//                    pDevViewController.HidesBackButton = YES;
//                }else {
//                    pDevViewController.HidesBackButton = NO;
//                }
//                [self ChangeView:pDevViewController didSelectRowAtIndexPath:nIndexPath];
//                // iPad用
//                break;
//            }
//            case 1:
//                // プリントサーバー設定画面に遷移
//                pSerViewController = [[SettingSelServerViewController_iPad alloc] initWithStyle:UITableViewStyleGrouped];
//                // iPad用
//                if (self.m_bVisibleMenuButton) {
//                    pDevViewController.HidesBackButton = YES;
//                }else {
//                    pDevViewController.HidesBackButton = NO;
//                }
//                [self ChangeView:pSerViewController didSelectRowAtIndexPath:nIndexPath];
//                // iPad用
//                break;
//            case 2:
//            {
//                /* 除外MFPリストは国内版のみ対応 */
//                // 20121113 国内版でも除外リストは削除
//                if (0)
//                {
//                    // 除外プリンター/スキャナーを設定画面に遷移
//                    pExcludeMfpViewController = [[SettingExcludeMfpSelectViewController_iPad alloc] initWithStyle:UITableViewStyleGrouped];
//                    [self ChangeView:pExcludeMfpViewController didSelectRowAtIndexPath:nIndexPath];
//                }
//                else
//                {
//                    // ユーザ情報設定画面に遷移
//                    pUserViewController = [[SettingUserInfoViewController_iPad alloc] initWithStyle:UITableViewStyleGrouped];
//                    [self ChangeView:pUserViewController didSelectRowAtIndexPath:nIndexPath];
//                }
//                break;
//            }
//            case 3:
//                /* 除外MFPリストは国内版のみ対応 */
//                // 20121113 国内版でも除外リストは削除
//                if (0)
//                {
//                    // ユーザ情報設定画面に遷移
//                    pUserViewController = [[SettingUserInfoViewController_iPad alloc] initWithStyle:UITableViewStyleGrouped];
//                    [self ChangeView:pUserViewController didSelectRowAtIndexPath:nIndexPath];
//                }
//                else
//                {
//                    // アプリケーションの動作を設定画面に遷移
//                    pAppliViewController = [[SettingApplicationViewController_iPad alloc]initWithStyle:UITableViewStyleGrouped];
//                    [self ChangeView:pAppliViewController didSelectRowAtIndexPath:nIndexPath];
//                }
//                break;
//            case 4:
//                /* 除外MFPリストは国内版のみ対応 */
//                // 20121113 国内版でも除外リストは削除
//                if (0)
//                {
//                    // アプリケーションの動作を設定画面に遷移
//                    pAppliViewController = [[SettingApplicationViewController_iPad alloc]initWithStyle:UITableViewStyleGrouped];
//                    [self ChangeView:pAppliViewController didSelectRowAtIndexPath:nIndexPath];
//                    
//                }
//                else
//                {
//                    // メールサーバー情報設定画面に遷移
//                    pMServerViewController = [[SettingMailServerInfoViewController_iPad alloc]initWithStyle:UITableViewStyleGrouped];
//                    [self ChangeView:pMServerViewController didSelectRowAtIndexPath:nIndexPath];
//                    
//                }
//                break;
//            case 5:
//                // メールサーバー情報設定画面に遷移
//                pMServerViewController = [[SettingMailServerInfoViewController_iPad alloc]initWithStyle:UITableViewStyleGrouped];
//                [self ChangeView:pMServerViewController didSelectRowAtIndexPath:nIndexPath];
//                break;
//            default:
//                break;
//        }
        switch (nIndexPath.row)
        {
            case 0:
            {
                // プリンター/スキャナー設定画面に遷移
                pDevViewController = [[SettingSelDeviceViewController_iPad alloc] initWithStyle:UITableViewStyleGrouped];
                // iPad用
                if (self.m_bVisibleMenuButton) {
                    pDevViewController.HidesBackButton = YES;
                }else {
                    pDevViewController.HidesBackButton = NO;
                }
                [self ChangeView:pDevViewController didSelectRowAtIndexPath:nIndexPath];
                // iPad用
                break;
            }
            case 1:
            {
                // ユーザ情報設定画面に遷移
                pUserViewController = [[SettingUserInfoViewController_iPad alloc] initWithStyle:UITableViewStyleGrouped];
                [self ChangeView:pUserViewController didSelectRowAtIndexPath:nIndexPath];
                break;
            }
            case 2:
                // アプリケーションの動作を設定画面に遷移
                pAppliViewController = [[SettingApplicationViewController_iPad alloc]initWithStyle:UITableViewStyleGrouped];
                [self ChangeView:pAppliViewController didSelectRowAtIndexPath:nIndexPath];
                break;
            case 3:
                // メールサーバー情報設定画面に遷移
                pMServerViewController = [[SettingMailServerInfoViewController_iPad alloc]initWithStyle:UITableViewStyleGrouped];
                [self ChangeView:pMServerViewController didSelectRowAtIndexPath:nIndexPath];
                break;
            default:
                break;
        }
    }
    // 縦向き表示時のメニューPopOverが表示されていたら閉じる
    [self dismissMenuPopOver:YES];
}

// iPad用
-(void)ChangeView:(UITableViewController *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    SharpScanPrintAppDelegate* pAppDelegate = (SharpScanPrintAppDelegate*)[[UIApplication sharedApplication] delegate];
    UINavigationController* pRootNavController = [pAppDelegate.splitViewController.viewControllers objectAtIndex:0];
    //左側のViewに設定されているクラスの名前を取得
    NSString* leftViewClassName = [pRootNavController.topViewController description];
    // 左側のViewにトップメニューが表示されている場合
    if(![leftViewClassName isEqual:[self description]])
    {
        if(!self.modalPresented)
        {//モーダル表示されたのでなければ、
            // 左側のViewを更新してファイル一覧を表示
            RootViewController_iPad* pRootViewController = (RootViewController_iPad*)pRootNavController.topViewController;
            if ([pRootNavController.topViewController isKindOfClass:[RootViewController_iPad class]]) {
                pRootViewController.m_bVisibleMenuButton = self.m_bVisibleMenuButton;
                [pRootViewController updateView:SettingMenu didSelectRowAtIndexPath:indexPath scrollOffset:[self.tableView contentOffset]];
            }
        }
        selectIndexPath = nil;
        // 右側のViewを更新して画像プレビューを表示
        [self.navigationController pushViewController:tableView animated:YES];
    }
    else
    {
        // 詳細画面のナビゲーション
        UINavigationController* pDetailNavController = nil;
        
        // 新規詳細画面追加
        SettingSelInfoViewController_iPad* pSettingViewController = [[SettingSelInfoViewController_iPad alloc] initWithStyle:UITableViewStyleGrouped];
        pSettingViewController.selectIndexPath = nil;
        
        pDetailNavController = [[UINavigationController alloc]initWithRootViewController: pSettingViewController];
        pDetailNavController.navigationBar.barStyle = NAVIGATION_BARSTYLE;
        pDetailNavController.delegate = pSettingViewController;
        
        NSArray *viewControllers = [[NSArray alloc] initWithObjects:self.navigationController, pDetailNavController, nil];
        pAppDelegate.splitViewController.viewControllers = viewControllers;
        
        [pSettingViewController updateView:tableView];
    }
}

- (void)updateView:(UIViewController*) pViewController
{
    [self.navigationController pushViewController:pViewController animated:YES];
}

- (void)popRootView
{
    [self.navigationController popToRootViewControllerAnimated:YES];
}

// 縦表示時のメニューボタン設定
- (void)setPortraitMenu:(UIBarButtonItem *)barButtonItem
{
    [self.navigationItem setLeftBarButtonItem:barButtonItem animated:YES];
}

- (void) dismissMenuPopOver:(BOOL)bAnimated
{
    SharpScanPrintAppDelegate* pAppDelegate = (SharpScanPrintAppDelegate*)[[UIApplication sharedApplication] delegate];
    UINavigationController* pRootNavController = [pAppDelegate.splitViewController.viewControllers objectAtIndex:0];
    RootViewController_iPad* rootViewController = (RootViewController_iPad*)[pRootNavController.viewControllers objectAtIndex:0];
    
    // 縦向き表示時のメニューPopOverが表示されていたら閉じる
    [rootViewController dismissMenuPopOver:bAnimated];
}
//iPad用

// キャンセルし画面を閉じる
- (void)closeAction
{
    NSNotification *n = [NSNotification notificationWithName:ST_CLOSE_BUTTON_PUSHED object:self];
    NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
    [nc postNotification:n];
}


@end
