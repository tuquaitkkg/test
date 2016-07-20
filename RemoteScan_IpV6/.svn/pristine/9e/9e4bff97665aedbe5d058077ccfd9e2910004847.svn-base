
#import "RootViewController_iPad.h"
#import "Define.h"
#import "PrintPictViewController_iPad.h"
#import "PrintSelectTypeViewController_iPad.h"
#import "ScanBeforePictViewController_iPad.h"
#import "SettingSelInfoViewController_iPad.h"
#import "SelectFileViewController_iPad.h"
#import "SelectMailViewController_iPad.h"
#import "ShowMailViewController_iPad.h"
#import "ArrengeSelectFileViewController_iPad.h"
#import "TempDataTableViewController_iPad.h"
#import "PrintPictViewController_iPad.h"
#import "VersionInfoViewController_iPad.h"
#import "HelpViewController.h"
#import "ScanAfterPictViewController_iPad.h"
#import "SettingSelDeviceViewController_iPad.h"
#import "SettingShowDeviceViewController_iPad.h"
//iPad用
#import "SharpScanPrintAppDelegate.h"
//iPad用
#import "RemoteScanBeforePictViewController_iPad.h"
#import "SearchResultViewController_iPad.h"
#import "AdvancedSearchResultViewController_iPad.h"

#import "PictureViewController_iPad.h"
#import "FileNameChangeViewController.h"
#import "ShowMailViewController.h"
#import "CreateFolderViewController.h"
#import "SelectMailViewController.h"
#import "SettingMailServerInfoViewController_iPad.h"
#import "SettingMailServerInfoViewController.h"
#import "SettingApplicationViewController_iPad.h"
#import "SettingUserInfoViewController_iPad.h"
#import "SettingSelMailDisplaySettingTableViewController.h"
#import "SettingRetentionInfoTableViewController.h"
#import "SettingDeviceNameInfoTableViewController.h"

@implementation RootViewController_iPad

@synthesize isExit = m_bExitView;							// 画面遷移もとフラグ
@synthesize siteUrl;
// iPad用
@synthesize m_bIgnoreDisappear; // 戻るボタン押下時の処理実行フラグ
@synthesize selectIndexPath; // トップメニュー選択行
@synthesize barItemMenu;
//@synthesize m_popOver;
@synthesize subDir;
@synthesize rootDir;
@synthesize pstrSearchKeyword;                  // 検索文字
@synthesize bSubFolder;                         // 検索範囲(サブフォルダーを含む)
@synthesize bFillterFolder;                     // 検索対象(フォルダー)
@synthesize bFillterPdf;                        // 検索対象(PDF)
@synthesize bFillterTiff;                       // 検索対象(TIFF)
@synthesize bFillterImage;                      // 検索対象(JPEG,PNG)
@synthesize bFillterOffice;                     // 検索対象(OFFICE)
@synthesize bCanDelete;                         // 検索対象(削除)
@synthesize pstrSelectFolder;                   // E-mail印刷参照フォルダー

@synthesize m_bVisibleMenuButton;               // メニュー表示フラグ
// iPad用


#pragma mark -
#pragma mark View lifecycle


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
    self.navigationItem.title = S_TITLE_TOP;
    // ヘルプボタン
    UIBarButtonItem* barItemHelp = [[UIBarButtonItem alloc] initWithTitle:S_BUTTON_HELP style:UIBarButtonItemStylePlain target:self action:@selector(OnShowHelp)];
    self.navigationItem.leftBarButtonItem = barItemHelp;
    
    // 画面が縦向きの場合
    UIInterfaceOrientation orientation = [[UIApplication sharedApplication] statusBarOrientation];
    if(barItemMenu == nil && (orientation == UIDeviceOrientationPortrait || orientation == UIDeviceOrientationPortraitUpsideDown))
    {
        // 右側Viewに表示するメニューボタンを生成
        barItemMenu = [[UIBarButtonItem alloc] initWithTitle:S_BUTTON_MENU style:UIBarButtonItemStylePlain target:self action:@selector(OnMenuPopOverView:)];
    }
    
    // 戻るボタンの名称変更
    UIBarButtonItem * barItemBack = [UIBarButtonItem new];
    barItemBack.title = S_BUTTON_BACK;
    self.navigationItem.backBarButtonItem = barItemBack;
    
    if(self.isExit)
    {
        [self showOpenUrlFile];
    }
    else
    {
        // /Documents/Inbox/ フォルダが有れば消す
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *inboxPath = [[paths objectAtIndex:0] stringByAppendingPathComponent:@"Inbox"];
        DLog(@"%@",inboxPath);
        NSFileManager *fm = [NSFileManager defaultManager];
        NSError *error;
        if ([fm fileExistsAtPath:inboxPath]) { // 確認
            // 削除
            [fm removeItemAtPath:inboxPath error:&error];
        }
    }
    
    // 色変更
    //self.navigationController.navigationBar.tintColor = [UIColor blackColor];
    // iPad用
    // 選択行初期化
    NSUInteger defaultIndex[] = {0, 0};
    selectIndexPath = [[NSIndexPath alloc] initWithIndexes:defaultIndex length:2];
    // iPad用
}

-(void)setDefaultTopScreen
{
    // 右側View取得
    SharpScanPrintAppDelegate* pAppDelegate = (SharpScanPrintAppDelegate*)[[UIApplication sharedApplication] delegate];
    UINavigationController* pDetailNavController = [pAppDelegate.splitViewController.viewControllers objectAtIndex:1];
    
    // 右側Viewが取り込み画面でない場合
    if (![pDetailNavController.topViewController isKindOfClass:[ScanBeforePictViewController_iPad class]])
    {
        [self MoveView:[NSIndexPath indexPathForRow:0 inSection:0]];
        //右側View再取得
        //        pDetailNavController = [pAppDelegate.splitViewController.viewControllers objectAtIndex:1];
    }
    //左側Viewはメニュー表示
    [self.navigationController popToRootViewControllerAnimated:NO];
}

-(void)showOpenUrlFile;
{
    // インジケータを止める
    SharpScanPrintAppDelegate *appDelegate = (SharpScanPrintAppDelegate *)[[UIApplication sharedApplication] delegate];
    [appDelegate stopIndicator];
    
    self.isExit = FALSE;
    TempFile *tempFile = [self getUniqueTempFile:[[self.siteUrl path] lastPathComponent]];

    CommonManager *commanager = [[CommonManager alloc]init];
    [commanager moveFile:[self.siteUrl path] :tempFile.tempFilePath];
    // キャッシュファイルの作成
    [TempFileUtility createRequiredAllImageFiles:tempFile];
    
    // 戻るボタンの名称変更
    UIBarButtonItem * barItemBack = [UIBarButtonItem new];
    barItemBack.title = S_BUTTON_BACK;
    self.navigationItem.backBarButtonItem = barItemBack;
    
    // TempDataへ画面遷移
    TempDataManager *tManager = [[TempDataManager alloc]init];
    
    // PROFILE情報の取得
    ProfileDataManager *profileDataManager = [[ProfileDataManager alloc] init];
    ProfileData *profileData = nil;
    profileData = [profileDataManager loadProfileDataAtIndex:0];
    // 他アプリから受けたファイルを残す：オン の場合
    if(profileData.saveExSiteFileMode)
    {
        // iPad用
        //SharpScanPrintAppDelegate* appDelegate = (SharpScanPrintAppDelegate*)[[UIApplication sharedApplication] delegate];
        SharpScanPrintAppDelegate* appDelegate = (SharpScanPrintAppDelegate*)[[UIApplication sharedApplication] delegate];
        // iPad用
        // 処理実行フラグON
        appDelegate.IsRun = TRUE;
        // 外部アプリから呼び出し時、選択ファイルを保存する。
        if(![self copyTempData:tManager])
        {
            // 保存に失敗した場合
            [self makeTmpExAlert:nil message:MSG_SAVE_ERR cancelBtnTitle:nil okBtnTitle:MSG_BUTTON_OK tag:0 showFlg:YES];
        }
    }
    
    // 戻るボタン押下時の処理実行フラグをON
    m_bNoPopRootView = YES;
    NSUInteger newIndex[] = {0, 0};
    selectIndexPath = [[NSIndexPath alloc] initWithIndexes:newIndex length:2];
    
    // 一時ファイルの一覧作成
    TempDataTableViewController_iPad* tempDataTableViewController = [[TempDataTableViewController_iPad alloc] init];
    tempDataTableViewController.isScan = FALSE;
    // 選択行の読み込み
    TempData *aTempData = nil;
    aTempData	= [tManager loadTempDataAtIndexPath:0];
    PrintPictViewController_iPad* pPrintPictViewController = [[PrintPictViewController_iPad alloc] init];
    // 呼び出し画面のプロパティ設定
    TempFile *localTempFile = [[TempFile alloc] initWithFileName:aTempData.fname];
    pPrintPictViewController.SelFilePath	= localTempFile.tempFilePath;
    pPrintPictViewController.IsSite         = TRUE;
    pPrintPictViewController.IsSiteTemp     = TRUE;
    // 左側Viewはファイル一覧表示
    [self.navigationController pushViewController:tempDataTableViewController animated:YES];
    
    // 右側View取得
    SharpScanPrintAppDelegate* pAppDelegate = (SharpScanPrintAppDelegate*)[[UIApplication sharedApplication] delegate];
    UINavigationController* pDetailNavController = [pAppDelegate.splitViewController.viewControllers objectAtIndex:1];
    // 右側Viewは画像プレビュー画面表示
    [pDetailNavController pushViewController:pPrintPictViewController animated:NO];
    // iPad用
}

- (TempFile*)getUniqueTempFile:(NSString*)pFileName{
    TempFile *toTempFile;
    NSString* fileNameBody = [pFileName stringByDeletingPathExtension];
    NSString* extension = [pFileName pathExtension];
    
    if(fileNameBody.length + extension.length + 1 > 200){
        // ファイル名が長いので変更
        NSFileManager* fm = [NSFileManager defaultManager];
        
        // リネームパス作成
        NSString *toFileName = [[fileNameBody substringToIndex:200 - extension.length - 1] stringByAppendingPathExtension:extension];
        toTempFile = [[TempFile alloc] initWithFileName:toFileName];
        
        if([fm isExecutableFileAtPath:toTempFile.tempFilePath]){
            // 名前の重複
            NSString *toFileNameBody = [fileNameBody substringToIndex:195 - extension.length - 1];
            for(int i = 1; i < 1000; i++){
                NSString* tempToFileName = [NSString stringWithFormat:@"%@(%zd).%@", toFileNameBody, i, extension];
                TempFile *tempToTempFile = [[TempFile alloc] initWithFileName:tempToFileName];
                if(![fm isExecutableFileAtPath:tempToTempFile.tempFilePath]){
                    // ファイル名の確定
                    toTempFile = tempToTempFile;
                    break;
                }
            }
        }
    } else{
        toTempFile = [[TempFile alloc] initWithFileName:pFileName];
    }
    
    return toTempFile;
}

- (BOOL)copyTempData:(TempDataManager*)tempDataManager{
    // ファイル名でソートする
    [tempDataManager.atempDataList sortUsingComparator:^NSComparisonResult(TempData* obj1, TempData* obj2) {
        return [obj1.fname compare:obj2.fname];
    }];
    
    NSString *scanDir = [ScanFileUtility getScanFileDirectoryPath];
    for (TempData *theTempData in tempDataManager.atempDataList){
        NSString *scanFileName = theTempData.fname;
        NSString *scanFilePath = [scanDir stringByAppendingPathComponent:scanFileName];
        ScanFile *scanFile = [[ScanFile alloc] initWithScanFilePath:scanFilePath];
        if ([scanFile existsFileInScanFile]) {
            // 連番でファイル名リネーム
            for (NSInteger iRenameIndex = 0; iRenameIndex < 10000; iRenameIndex++)
            {
                NSString *fname = [NSString stringWithFormat:@"%@(%zd).%@",
                                   [scanFileName stringByDeletingPathExtension],
                                   iRenameIndex + 1,
                                   [scanFileName pathExtension]];
                if(fname.length > 200){
                    fname = [NSString stringWithFormat:@"%@(%zd).%@",
                             [[scanFileName stringByDeletingPathExtension] substringToIndex:195 - [scanFileName pathExtension].length - 1],
                             iRenameIndex + 1,
                             [scanFileName pathExtension]];
                }
                scanFilePath =[scanDir stringByAppendingPathComponent:fname];
                scanFile = [[ScanFile alloc] initWithScanFilePath:scanFilePath];
                
                // ファイル存在確認
                if(![scanFile existsFileInScanFile])
                {
                    break;
                }
            }
        }
        if ([scanFile existsFileInScanFile]) {
            return NO;
        }
        TempFile *tempFile = [[TempFile alloc] initWithFileName:scanFileName];
        [GeneralFileUtility copy:tempFile Destination:scanFile];
    }
    
    return YES;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    /*
     設定のアクセシビリティで「ボタンの形」がオンの状態で、
     「ファイルを選択する」などで画面遷移後、この画面に戻ると
     ヘルプボタンが黒くなる。
     この問題に対応するためヘルプボタンを再設定している。
    */
    UIBarButtonItem* barItemHelp = [[UIBarButtonItem alloc] initWithTitle:S_BUTTON_HELP style:UIBarButtonItemStylePlain target:self action:@selector(OnShowHelp)];
    self.navigationItem.leftBarButtonItem = barItemHelp;
    
    // 選択状態解除
    [self.tableView deselectRowAtIndexPath:[self.tableView indexPathForSelectedRow] animated:YES];
    
    // iPad用
    // Headerの高さを指定
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0.0, 0.0, self.view.frame.size.width, 20.0)];
    self.tableView.tableHeaderView = headerView;
    // iPad用
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
    
    [self.tableView reloadData];
}
/*
 - (void)viewDidDisappear:(BOOL)animated {
 [super viewDidDisappear:animated];
 }
 */



#pragma mark -
#pragma mark Table view data source

// Customize the number of sections in the table view.
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return N_NUM_SECTION_TOP;
}


// Customize the number of rows in the table view.
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
	NSInteger nRet = 0;
	if(section == 0)
	{
		nRet = N_NUM_ROW_TOP_SEC1;
	}
	else if(section == 1)
	{
		nRet = N_NUM_ROW_TOP_SEC2;
	}
	return nRet;
}


// Customize the appearance of table view cells.
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
        switch (indexPath.row)
        {
            case 0:
                cell.textLabel.text = S_TOP_SCAN;
                [pstrIconName appendString:S_ICON_TOP_SCAN];
                break;
            case 1:
                cell.textLabel.text = S_TOP_PRINT;
                [pstrIconName appendString:S_ICON_TOP_PRINT];
                break;
            case 2:
                cell.textLabel.text = S_TOP_SENDMAIL;
                [pstrIconName appendString:S_ICON_TOP_SENDMAIL];
                break;
            case 3:
                cell.textLabel.text = S_TOP_SEND_OUTSIDE;
                [pstrIconName appendString:S_ICON_TOP_SEND_EX_SITE];
                break;
            case 4:
                cell.textLabel.text = S_TOP_ARRANGE;
                [pstrIconName appendString:S_ICON_TOP_ARRANGE];
                break;
            default:
                break;
        }
    }
    else
    {
        switch (indexPath.row)
        {
            case 0:
                cell.textLabel.text = S_TOP_SUB_SETTING;
                [pstrIconName appendString:S_ICON_TOP_SETTINGS];
                break;
            case 1:
                cell.textLabel.text = S_TOP_SUB_VERSION;
                [pstrIconName appendString:S_ICON_TOP_VERSION];
                break;
            default:
                break;
        }
    }
    
    // フォントサイズ設定
    cell.textLabel.font = [UIFont systemFontOfSize:16];

    // アイコン設定
    [pstrIconName appendString:S_EXTENSION_PNG];
    UIImage* pIconImage = [UIImage imageNamed: pstrIconName];
    cell.imageView.image = pIconImage;
    
    // iPad用
    //現在の選択行を選択状態にする
    if(selectIndexPath != nil &&
       selectIndexPath.section == indexPath.section &&
       selectIndexPath.row == indexPath.row &&
       selectIndexPath != [self.tableView indexPathForSelectedRow])
    {
        // 選択
        [self.tableView selectRowAtIndexPath:selectIndexPath animated:NO scrollPosition:UITableViewScrollPositionNone];
    }
    // iPad用
    cell.textLabel.adjustsFontSizeToFitWidth = YES;
    
    return cell;
}

// テーブルビューの縦幅設定
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.section == 0)
    {
        return N_HEIGHT_TOP_SEC1;
    }
    else
    {
        return N_HEIGHT_TOP_SEC2;
    }
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
 // Delete the row from the data source.
 [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
 }
 else if (editingStyle == UITableViewCellEditingStyleInsert) {
 // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view.
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


#pragma mark -
#pragma mark Table view delegate

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
#pragma mark -
#pragma mark Memory management

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Relinquish ownership any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    
    // Relinquish ownership of anything that can be recreated in viewDidLoad or on demand.
    // For example: self.myOutlet = nil;
    // iPad用
    if (nil != selectIndexPath)
    {
        selectIndexPath = nil;
    }
    // iPad用
}



// 画面遷移
- (void)MoveView:(NSIndexPath *)nIndexPath
{
    // iPad用
    // 選択行保持
    NSUInteger newIndex[] = {nIndexPath.section, nIndexPath.row};
    selectIndexPath = [[NSIndexPath alloc] initWithIndexes:newIndex length:2];
    // iPad用
    
    // iPad用
    // 取り込み後の画面でメニューが押された場合に、削除しますか？のダイアログを表示する
    if([[[self.splitViewController.viewControllers objectAtIndex:1] topViewController] isKindOfClass:[ScanAfterPictViewController_iPad class]] || [[[self.splitViewController.viewControllers objectAtIndex:1] topViewController] isKindOfClass:[TempDataTableViewController_iPad class]])
    {
        // ダイアログ表示
        SharpScanPrintAppDelegate* appDelegate = (SharpScanPrintAppDelegate*)[[UIApplication sharedApplication] delegate];
        // 処理実行フラグON
        appDelegate.IsRun = TRUE;
        
        [self makeTmpExAlert:nil message:MSG_DEL_CONFIRM cancelBtnTitle:MSG_BUTTON_CANCEL okBtnTitle:MSG_BUTTON_OK tag:2 showFlg:YES];
        
        //選択状態を「取り込む」のままにする
        NSUInteger scanViewIndex[] = {0, 0};
        NSIndexPath* scanView = [[NSIndexPath alloc] initWithIndexes:scanViewIndex length:2];
        [self.tableView selectRowAtIndexPath:scanView animated:NO scrollPosition:UITableViewScrollPositionNone];
        return;
    }
    
    PrintSelectTypeViewController_iPad* pPrintViewController;
	SelectFileViewController_iPad* pSelectFileViewController;
    ScanBeforePictViewController_iPad* pScanViewController;
    RemoteScanBeforePictViewController_iPad* pRemoteScanViewController;
    SettingSelInfoViewController_iPad* pSettingViewController;
    ArrengeSelectFileViewController_iPad* pArrengeSelectFileViewController;
    VersionInfoViewController_iPad* pVersionInfoViewController;
    if(nIndexPath.section == 0){
        switch (nIndexPath.row)
        {
            case 0:
                if([CommonUtil isCapableRemoteScan]) {
                    pRemoteScanViewController = [[RemoteScanBeforePictViewController_iPad alloc] init];
                    // iPad用
                    //[self.navigationController pushViewController:pScanViewController animated:YES];
                    [self ChangeDetailView:pRemoteScanViewController];
                    // iPad用
                }else{
                    pScanViewController = [[ScanBeforePictViewController_iPad alloc] init];
                    // iPad用
                    //[self.navigationController pushViewController:pScanViewController animated:YES];
                    [self ChangeDetailView:pScanViewController];
                    // iPad用
                }
                break;
            case 1:
                pPrintViewController = [[PrintSelectTypeViewController_iPad alloc] initWithStyle:UITableViewStyleGrouped];
                // iPad用
                //[self.navigationController pushViewController:pPrintViewController animated:YES];
                [self ChangeDetailView:pPrintViewController];
                // iPad用
                break;
            case 2:
                pSelectFileViewController = [[SelectFileViewController_iPad alloc] init];
                pSelectFileViewController.PrevViewID = SendMailSelectTypeView;
                pSelectFileViewController.bSetTitle = YES;
                // iPad用
                //[self.navigationController pushViewController:pSelectFileViewController animated:YES];
                [self ChangeDetailView:pSelectFileViewController];
                // iPad用
                break;
            case 3:
                pSelectFileViewController = [[SelectFileViewController_iPad alloc] init];
                pSelectFileViewController.PrevViewID = SendExSiteSelectTypeView;
                pSelectFileViewController.bSetTitle = YES;
                // iPad用
                //[self.navigationController pushViewController:pSelectFileViewController animated:YES];
                [self ChangeDetailView:pSelectFileViewController];
                // iPad用
                break;
            case 4:
                pArrengeSelectFileViewController = [[ArrengeSelectFileViewController_iPad alloc] init];
                //pSelectFileViewController.PrevViewID = ArrangeSelectTypeView;
                // iPad用
                //[self.navigationController pushViewController:pArrengeSelectFileViewController animated:YES];
                pArrengeSelectFileViewController.bSetTitle = YES;
                pArrengeSelectFileViewController.bCanDelete = YES;
                [self ChangeDetailView:pArrengeSelectFileViewController];
                // iPad用
                
                break;
            default:
                break;
        }
    }
    else
    {
        switch (nIndexPath.row)
        {
            case 0:
                pSettingViewController = [[SettingSelInfoViewController_iPad alloc] initWithStyle:UITableViewStyleGrouped];
                // iPad用
                pSettingViewController.m_bVisibleMenuButton = true;
                //[self.navigationController pushViewController:pSettingViewController animated:YES];
                [self ChangeDetailView:pSettingViewController];
                // iPad用
                break;
            case 1:
                pVersionInfoViewController = [[VersionInfoViewController_iPad alloc] init];
                // iPad用
                //[self.navigationController pushViewController:pVersionInfoViewController animated:YES];
                [self ChangeDetailView:pVersionInfoViewController];
                // iPad用
                break;
            default:
                break;
        }
    }
    [self dismissMenuPopOver:YES];
}

// iPad用
- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    // 縦から横に回転された場合にこの処理が呼び出された場合は処理を行わない
    if(m_bRotation)
    {
        [viewController viewWillAppear:animated];
        
        if (([viewController isEqual:self] && !m_bNoPopRootView))
        {
            SharpScanPrintAppDelegate* pAppDelegate = (SharpScanPrintAppDelegate*)[[UIApplication sharedApplication] delegate];
            
            while (pAppDelegate.IsPreview)
            {
            }
            
            // 右側のViewを取得
            UINavigationController* pDetailNavController = [pAppDelegate.splitViewController.viewControllers objectAtIndex:1];
            // 右側Viewに戻り先画面がある場合
            if([pDetailNavController.viewControllers count] > 1)
            {
                UIViewController* rightViewController = (UIViewController*)pDetailNavController.topViewController;
                if([rightViewController isKindOfClass:[PictureViewController_iPad class]] ||
                   [rightViewController isKindOfClass:[SettingSelDeviceViewController_iPad class]] ||
                   [rightViewController isKindOfClass:[SettingShowDeviceViewController_iPad class]] ||
                   [rightViewController isKindOfClass:[SettingSelMailDisplaySettingTableViewController class]] ||
                   [rightViewController isKindOfClass:[SettingRetentionInfoTableViewController class]] ||
                   [rightViewController isKindOfClass:[SettingDeviceNameInfoTableViewController class]] ||
                   [rightViewController isKindOfClass:[ShowMailViewController_iPad class]]){
                    // プレビュー画面および、設定画面の場合、ファイルリストまで戻す
                    UIViewController* lastFileView = nil;
                    for(UIViewController* vc in [pDetailNavController.viewControllers reverseObjectEnumerator]){
                        if([vc isKindOfClass:[SelectFileViewController_iPad class]] ||
                           [vc isKindOfClass:[ArrengeSelectFileViewController_iPad class]] ||
                           [vc isKindOfClass:[SearchResultViewController_iPad class]] ||
                           [vc isKindOfClass:[AdvancedSearchResultViewController_iPad class]]){
                            // ファイルリスト発見
                            lastFileView = vc;
                            break;
                        }
                    }
                    
                    if(lastFileView != nil){
                        [pDetailNavController popToViewController:lastFileView animated:YES];
                    }else{
                        // 右側のViewを遷移前の状態に戻す
                        if ([rightViewController isKindOfClass:[PictureViewController_iPad class]]) {
                            if ([(PictureViewController_iPad*)rightViewController PrintPictViewID] != WEB_PRINT_VIEW &&
                                [(PictureViewController_iPad*)rightViewController PrintPictViewID] != EMAIL_PRINT_VIEW) {
                                [(PictureViewController_iPad*)rightViewController popRootView];
                            }
                        }else if ([rightViewController isKindOfClass:[FileNameChangeViewController class]]) {
                            [(FileNameChangeViewController*)rightViewController popRootView];
                        }else if ([rightViewController isKindOfClass:[ShowMailViewController class]]) {
                            [(ShowMailViewController*)rightViewController popRootView];
                        }else if ([rightViewController isKindOfClass:[CreateFolderViewController class]]) {
                            [(CreateFolderViewController*)rightViewController popRootView];
                        }else if ([rightViewController isKindOfClass:[ShowMailViewController_iPad class]]) {
                            [(ShowMailViewController_iPad*)rightViewController popRootView];
                        }else if ([rightViewController isKindOfClass:[RootViewController_iPad class]]) {
                            [(RootViewController_iPad*)rightViewController popRootView];
                        }else if ([rightViewController isKindOfClass:[SettingSelInfoViewController_iPad class]]) {
                            [(SettingSelInfoViewController_iPad*)rightViewController popRootView];
                        }else if ([rightViewController isKindOfClass:[SelectMailViewController class]]) {
                            [(SelectMailViewController*)rightViewController popRootView];
                        }else if ([rightViewController isKindOfClass:[ArrengeSelectFileViewController_iPad class]]) {
                            [(ArrengeSelectFileViewController_iPad*)rightViewController popRootView];
                        }else if ([rightViewController isKindOfClass:[SelectFileViewController_iPad class]]) {
                            [(SelectFileViewController_iPad*)rightViewController popRootView];
                        }else if ([rightViewController isKindOfClass:[SettingShowDeviceViewController_iPad class]]) {
                            [(SettingShowDeviceViewController_iPad*)rightViewController popRootView];
                        }else if ([rightViewController isKindOfClass:[SettingMailServerInfoViewController_iPad class]]) {
                            [(SettingMailServerInfoViewController_iPad*)rightViewController popRootView];
                        }else if ([rightViewController isKindOfClass:[SettingMailServerInfoViewController class]]) {
                            [(SettingMailServerInfoViewController*)rightViewController popRootView];
                        }else if ([rightViewController isKindOfClass:[SearchResultViewController_iPad class]]) {
                            [(SearchResultViewController_iPad*)rightViewController popRootView];
                        }else if ([rightViewController isKindOfClass:[AdvancedSearchResultViewController_iPad class]]) {
                            [(AdvancedSearchResultViewController_iPad*)rightViewController popRootView];
                        }else if ([rightViewController isKindOfClass:[SettingSelDeviceViewController_iPad class]]) {
                            [(SettingSelDeviceViewController_iPad*)rightViewController popRootView];
                        }else if ([rightViewController isKindOfClass:[PrintSelectTypeViewController_iPad class]]) {
                            [(PrintSelectTypeViewController_iPad*)rightViewController popRootView];
                        }else if ([rightViewController isKindOfClass:[SettingSelMailDisplaySettingTableViewController class]]) {
                            [(SettingSelMailDisplaySettingTableViewController*)rightViewController popRootView];
                        }else if ([rightViewController isKindOfClass:[SettingRetentionInfoTableViewController class]]) {
                            [(SettingRetentionInfoTableViewController*)rightViewController popRootView];
                        }else if ([rightViewController isKindOfClass:[SettingDeviceNameInfoTableViewController class]]) {
                            [(SettingDeviceNameInfoTableViewController*)rightViewController popRootView];
                        }else {
                            DLog(@"対象無し");
                        }
                        //                        [rightViewController popRootView];
                    }
                }else{
                    // 右側のViewを遷移前の状態に戻す
                    if ([rightViewController isKindOfClass:[PictureViewController_iPad class]]) {
                        [(PictureViewController_iPad*)rightViewController popRootView];
                    }else if ([rightViewController isKindOfClass:[FileNameChangeViewController class]]) {
                        [(FileNameChangeViewController*)rightViewController popRootView];
                    }else if ([rightViewController isKindOfClass:[ShowMailViewController class]]) {
                        [(ShowMailViewController*)rightViewController popRootView];
                    }else if ([rightViewController isKindOfClass:[CreateFolderViewController class]]) {
                        [(CreateFolderViewController*)rightViewController popRootView];
                    }else if ([rightViewController isKindOfClass:[ShowMailViewController_iPad class]]) {
                        [(ShowMailViewController_iPad*)rightViewController popRootView];
                    }else if ([rightViewController isKindOfClass:[RootViewController_iPad class]]) {
                        [(RootViewController_iPad*)rightViewController popRootView];
                    }else if ([rightViewController isKindOfClass:[SettingSelInfoViewController_iPad class]]) {
                        [(SettingSelInfoViewController_iPad*)rightViewController popRootView];
                    }else if ([rightViewController isKindOfClass:[SelectMailViewController class]]) {
                        [(SelectMailViewController*)rightViewController popRootView];
                    }else if ([rightViewController isKindOfClass:[ArrengeSelectFileViewController_iPad class]]) {
                        [(ArrengeSelectFileViewController_iPad*)rightViewController popRootView];
                    }else if ([rightViewController isKindOfClass:[SelectFileViewController_iPad class]]) {
                        [(SelectFileViewController_iPad*)rightViewController popRootView];
                    }else if ([rightViewController isKindOfClass:[SettingShowDeviceViewController_iPad class]]) {
                        [(SettingShowDeviceViewController_iPad*)rightViewController popRootView];
                    }else if ([rightViewController isKindOfClass:[SettingUserInfoViewController_iPad class]]) {
                        [(SettingMailServerInfoViewController_iPad*)rightViewController popRootView];
                    }else if ([rightViewController isKindOfClass:[SettingApplicationViewController_iPad class]]) {
                        [(SettingMailServerInfoViewController_iPad*)rightViewController popRootView];  
                    }else if ([rightViewController isKindOfClass:[SettingMailServerInfoViewController_iPad class]]) {
                        [(SettingMailServerInfoViewController_iPad*)rightViewController popRootView];
                    }else if ([rightViewController isKindOfClass:[SettingMailServerInfoViewController class]]) {
                        [(SettingMailServerInfoViewController*)rightViewController popRootView];
                    }else if ([rightViewController isKindOfClass:[SearchResultViewController_iPad class]]) {
                        //                        [(SearchResultViewController_iPad*)rightViewController popRootView];
                    }else if ([rightViewController isKindOfClass:[AdvancedSearchResultViewController_iPad class]]) {
                        //                        [(AdvancedSearchResultViewController_iPad*)rightViewController popRootView];
                    }else if ([rightViewController isKindOfClass:[SettingSelDeviceViewController_iPad class]]) {
                        [(SettingSelDeviceViewController_iPad*)rightViewController popRootView];
                    }else if ([rightViewController isKindOfClass:[PrintSelectTypeViewController_iPad class]]) {
                        [(PrintSelectTypeViewController_iPad*)rightViewController popRootView];
                    }else {
                        DLog(@"対象無し");
                    }
                    //                    [rightViewController popRootView];
                }
            }
            //現在の選択行を選択状態にする
            if(selectIndexPath != nil)
            {
                // 選択
                [self.tableView selectRowAtIndexPath:selectIndexPath animated:NO scrollPosition:UITableViewScrollPositionNone];
            }
        }
        else if ([viewController isKindOfClass:[PrintSelectTypeViewController_iPad class]] && !m_bNoPopRootView)
        {
            
            SharpScanPrintAppDelegate* pAppDelegate = (SharpScanPrintAppDelegate*)[[UIApplication sharedApplication] delegate];
            
            // 右側のViewを取得
            UINavigationController* pDetailNavController = [pAppDelegate.splitViewController.viewControllers objectAtIndex:1];
            
            // 右側Viewに戻り先画面がある場合
            if([pDetailNavController.viewControllers count] > 1)
            {
                UIViewController* rightViewController = (UIViewController*)pDetailNavController.topViewController;
                if([rightViewController isKindOfClass:[PictureViewController_iPad class]])
                {
                    // プレビュー画面および、設定画面の場合、ファイルリストまで戻す
                    UIViewController* lastFileView = nil;
                    for(UIViewController* vc in [pDetailNavController.viewControllers reverseObjectEnumerator])
                    {
                        if([vc isKindOfClass:[SelectFileViewController_iPad class]] ||
                           [vc isKindOfClass:[SearchResultViewController_iPad class]] ||
                           [vc isKindOfClass:[AdvancedSearchResultViewController_iPad class]])
                        {
                            // ファイルリスト発見
                            lastFileView = vc;
                            break;
                        }
                    }
                    
                    if(lastFileView != nil)
                    {
                        [pDetailNavController popToViewController:lastFileView animated:YES];
                    }
                }
            }
        }
    }
    else
    {
        m_bRotation = YES;
    }
}


// トップ画面更新
- (void)updateView:(NSInteger)preViewID didSelectRowAtIndexPath:(NSIndexPath *)indexPath scrollOffset:(CGPoint)offset
{
    PrintSelectTypeViewController_iPad* pPrintSelectTypeViewController;
    SelectFileViewController_iPad* pSelectFileViewController;
    SelectMailViewController_iPad* pSelectMailViewController;
    ArrengeSelectFileViewController_iPad* pArrengeSelectFileViewController;
    SettingSelInfoViewController_iPad* pSettingViewController;
    TempDataTableViewController_iPad* tempDataTableViewController;
    SearchResultViewController_iPad* pSearchResultViewController;
    AdvancedSearchResultViewController_iPad* pAdvancedSearchResultViewController;
    
    ScanDirectory *selectedScanDirectory;
    
    switch (preViewID) {
        case PV_PRINT_SELECT_FILE_CELL:
            pPrintSelectTypeViewController = [[PrintSelectTypeViewController_iPad alloc] initWithStyle:UITableViewStyleGrouped];
            
            //iOS8ではアニメーションなしで
            BOOL animated = ([[[UIDevice currentDevice]systemVersion]floatValue]<8)? YES : NO ;
            [self.navigationController pushViewController:pPrintSelectTypeViewController animated:animated];
            
            break;
        case SendMailSelectTypeView:
        case SendExSiteSelectTypeView:
            pSelectFileViewController = [[SelectFileViewController_iPad alloc] init];
            pSelectFileViewController.PrevViewID = preViewID;
            pSelectFileViewController.bSetTitle = NO;
            pSelectFileViewController.selectIndexPath = indexPath;
            pSelectFileViewController.lastScrollOffSet = offset;
            selectedScanDirectory = [[ScanDirectory alloc]initWithScanDirectoryPath:self.subDir];
            pSelectFileViewController.scanDirectory = selectedScanDirectory;

            // 画面遷移
            [self.navigationController pushViewController:pSelectFileViewController animated:YES];
            break;
        case ArrangeSelectTypeView:
            pArrengeSelectFileViewController = [[ArrengeSelectFileViewController_iPad alloc] init];
            pArrengeSelectFileViewController.bSetTitle = NO;
            pArrengeSelectFileViewController.selectIndexPath = indexPath;
            pArrengeSelectFileViewController.lastScrollOffSet = offset;
            pArrengeSelectFileViewController.bCanDelete = NO;
            selectedScanDirectory = [[ScanDirectory alloc]initWithScanDirectoryPath:self.subDir];
            pArrengeSelectFileViewController.scanDirectory = selectedScanDirectory;
            pArrengeSelectFileViewController.bCanDelete = YES;
            // 画面遷移
            [self.navigationController pushViewController:pArrengeSelectFileViewController animated:YES];
            break;
        case SettingMenu:
            pSettingViewController = [[SettingSelInfoViewController_iPad alloc] initWithStyle:UITableViewStyleGrouped];
            pSettingViewController.selectIndexPath = indexPath;
            pSettingViewController.m_bVisibleMenuButton = false;//m_bVisibleMenuButton

            [self.navigationController pushViewController:pSettingViewController animated:YES];
            break;
        case ScanTempDataView:
            tempDataTableViewController = [[TempDataTableViewController_iPad alloc] init];
            tempDataTableViewController.bSetTitle = FALSE;
            tempDataTableViewController.isScan = TRUE;
            tempDataTableViewController.selectIndexPath = indexPath;
            tempDataTableViewController.lastScrollOffSet = offset;
            // 画面遷移
            [self.navigationController pushViewController:tempDataTableViewController animated:YES];
            break;
        case SearchResultTypeView:
            pSearchResultViewController = [[SearchResultViewController_iPad alloc] init];
            pSearchResultViewController.PrevViewID = ArrangeSelectTypeView;
            pSearchResultViewController.bSetTitle = NO;
            pSearchResultViewController.selectIndexPath = indexPath;
            pSearchResultViewController.lastScrollOffSet = offset;
            //            pSearchResultViewController.bCanDelete = NO;
            selectedScanDirectory = [[ScanDirectory alloc]initWithScanDirectoryPath:self.subDir];
            pSearchResultViewController.scanDirectory = selectedScanDirectory;
            pSearchResultViewController.pstrSearchKeyword = self.pstrSearchKeyword;
            // 画面遷移
            [self.navigationController pushViewController:pSearchResultViewController animated:YES];
            break;
        case AdvancedSearchResultTypeView:
            pAdvancedSearchResultViewController = [[AdvancedSearchResultViewController_iPad alloc] init];
            pAdvancedSearchResultViewController.PrevViewID = ArrangeSelectTypeView;
            pAdvancedSearchResultViewController.bSetTitle = NO;
            pAdvancedSearchResultViewController.selectIndexPath = indexPath;
            pAdvancedSearchResultViewController.lastScrollOffSet = offset;
            selectedScanDirectory = [[ScanDirectory alloc]initWithScanDirectoryPath:self.subDir];
            pAdvancedSearchResultViewController.scanDirectory = selectedScanDirectory;
            pAdvancedSearchResultViewController.pstrSearchKeyword = self.pstrSearchKeyword;
            // 画面遷移
            [self.navigationController pushViewController:pAdvancedSearchResultViewController animated:YES];
            break;
        case SelectMailView:
            pSelectMailViewController = [[SelectMailViewController_iPad alloc] init];
            pSelectMailViewController.PrevViewID = preViewID;
            pSelectMailViewController.bSetTitle = NO;
            pSelectMailViewController.selectIndexPath = indexPath;
            pSelectMailViewController.lastScrollOffSet = offset;
            pSelectMailViewController.m_pstrSelectFolder = self.pstrSelectFolder;
            // 画面遷移
            [self.navigationController pushViewController:pSelectMailViewController animated:YES];
            break;
        default:
            break;
    }
}

// トップ画面更新(検索用)
- (void)updateView:(NSInteger)preViewID searchPreViewID:(NSInteger)searchViewID didSelectRowAtIndexPath:(NSIndexPath *)indexPath scrollOffset:(CGPoint)offset
{
    SearchResultViewController_iPad* pSearchResultViewController;
    AdvancedSearchResultViewController_iPad* pAdvancedSearchResultViewController;
    
    ScanDirectory *selectedScanDirectory;
    
    switch (searchViewID) {
        case SearchResultTypeView:
            pSearchResultViewController = [[SearchResultViewController_iPad alloc] init];
            pSearchResultViewController.PrevViewID = preViewID;
            pSearchResultViewController.bSetTitle = NO;
            pSearchResultViewController.selectIndexPath = indexPath;
            pSearchResultViewController.lastScrollOffSet = offset;
            //            pSearchResultViewController.bCanDelete = NO;
            selectedScanDirectory = [[ScanDirectory alloc]initWithScanDirectoryPath:self.subDir];
            pSearchResultViewController.scanDirectory = selectedScanDirectory;
            pSearchResultViewController.pstrSearchKeyword = self.pstrSearchKeyword;
            pSearchResultViewController.bCanDelete = self.bCanDelete;
            
            // 画面遷移
            [self.navigationController pushViewController:pSearchResultViewController animated:YES];
            break;
        case AdvancedSearchResultTypeView:
            pAdvancedSearchResultViewController = [[AdvancedSearchResultViewController_iPad alloc] init];
            pAdvancedSearchResultViewController.PrevViewID = preViewID;
            pAdvancedSearchResultViewController.bSetTitle = NO;
            pAdvancedSearchResultViewController.selectIndexPath = indexPath;
            pAdvancedSearchResultViewController.lastScrollOffSet = offset;
            selectedScanDirectory = [[ScanDirectory alloc]initWithScanDirectoryPath:self.subDir];
            pAdvancedSearchResultViewController.scanDirectory = selectedScanDirectory;
            pAdvancedSearchResultViewController.pstrSearchKeyword = self.pstrSearchKeyword;
            pAdvancedSearchResultViewController.bSubFolder = self.bSubFolder;
            pAdvancedSearchResultViewController.bFillterFolder = self.bFillterFolder;
            pAdvancedSearchResultViewController.bFillterPdf = self.bFillterPdf;
            pAdvancedSearchResultViewController.bFillterTiff = self.bFillterTiff;
            pAdvancedSearchResultViewController.bFillterImage = self.bFillterImage;
            pAdvancedSearchResultViewController.bFillterOffice = self.bFillterOffice;
            pAdvancedSearchResultViewController.bCanDelete = self.bCanDelete;
            // 画面遷移
            [self.navigationController pushViewController:pAdvancedSearchResultViewController animated:YES];
            break;
        default:
            break;
    }
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // 横向きの場合
    if(interfaceOrientation == UIInterfaceOrientationLandscapeLeft || interfaceOrientation == UIInterfaceOrientationLandscapeRight)
    {
        // 縦向き表示時のメニューPopOverが表示されていたら閉じる
        [self dismissMenuPopOver:NO];
    }
    
    return YES;
}

// 回転が開始する前に行う処理
- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration
{
    // モーダルが開いていたらアニメーションなしで閉じる
    //[self dismissViewControllerAnimated:NO completion:nil];
    
    // 横向きの場合
    if(toInterfaceOrientation == UIInterfaceOrientationLandscapeLeft || toInterfaceOrientation == UIInterfaceOrientationLandscapeRight)
    {
        m_bRotation = NO;
    }
    else {
        m_bRotation = YES;
    }
    return;
}

// 詳細画面切換え
-(void)ChangeDetailView:(UIViewController*)pViewController
{
    // 詳細画面のナビゲーション初期化
    SharpScanPrintAppDelegate* pAppDelegate = (SharpScanPrintAppDelegate*)[[UIApplication sharedApplication] delegate];
    UINavigationController* pDetailNavController = nil;
    
    // 新規詳細画面追加
    pDetailNavController = [[UINavigationController alloc]initWithRootViewController: pViewController];
    pDetailNavController.navigationBar.barStyle = NAVIGATION_BARSTYLE;
    pDetailNavController.delegate = (id)pViewController;
    
    NSArray *viewControllers = [[NSArray alloc] initWithObjects:self.navigationController, pDetailNavController, nil];
    pAppDelegate.splitViewController.viewControllers = viewControllers;
}
- (void)popRootView
{
    [self.navigationController popToRootViewControllerAnimated:YES];
    m_bNoPopRootView = NO;
}
// iPad用

// 縦表示時のメニューボタン押下処理
- (IBAction)OnMenuPopOverView:(UIBarButtonItem*)sender
{
    [self ShowMenuPopOverView];
}

-(void)ShowMenuPopOverView
{
    SharpScanPrintAppDelegate* pAppDelegate = (SharpScanPrintAppDelegate*)[[UIApplication sharedApplication] delegate];
    [pAppDelegate showPopoverAnimated:YES];
    
}
// 縦向き表示時のメニューPopOverが表示されていたら閉じる
- (void) dismissMenuPopOver:(BOOL)banimated
{
    SharpScanPrintAppDelegate* pAppDelegate = (SharpScanPrintAppDelegate*)[[UIApplication sharedApplication] delegate];
    [pAppDelegate dismissPopoverAnimated:banimated];
}

// モーダル表示した画面を閉じる
- (void)OnHelpClose
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

// ヘルプ画面をモーダル表示
- (IBAction)OnShowHelp
{
    SharpScanPrintAppDelegate* appDelegate = (SharpScanPrintAppDelegate*)[[UIApplication sharedApplication] delegate];
    // 処理実行フラグON
    appDelegate.IsRun = YES;
    [self makeTmpExAlert:nil message:MSG_OPENMANUAL_WITHEXTERNALAPP cancelBtnTitle:MSG_BUTTON_CANCEL okBtnTitle:MSG_BUTTON_OK tag:10 showFlg:YES];
}

- (void)showHelpView{

    // サファリを起動してヘルプPDFファイルを表示する
    NSString *path = [S_HELPPDF_URL_IPAD stringByAppendingString:S_HELPPDF_NAME_IPAD];
    NSURL *url = [NSURL URLWithString:path];
    [[UIApplication sharedApplication] openURL:url];
}

// モーダル表示した保存画面を閉じる
- (void)OnSaveClose
{
    [self dismissViewControllerAnimated:YES completion:nil];
    [self.navigationController popToRootViewControllerAnimated:YES];
    
    // iPad用
    SharpScanPrintAppDelegate* pAppDelegate = (SharpScanPrintAppDelegate*)[[UIApplication sharedApplication] delegate];
    // 右側のViewを取得
    UINavigationController* pDetailNavController = [pAppDelegate.splitViewController.viewControllers objectAtIndex:1];
    // 右側Viewに戻り先画面がある場合
    if([pDetailNavController.viewControllers count] > 1)
    {
        UIViewController* rightViewController = (UIViewController*)pDetailNavController.topViewController;
        [rightViewController.navigationController popToRootViewControllerAnimated:YES];
        m_bNoPopRootView = NO;
    }
    // iPad用
}

// アラートボタン押下処理
-(void)alertButtonPushed:(UIAlertController *)alertController tagIndex:(NSInteger)tagIndex buttonIndex:(NSInteger)buttonIndex
{
    [self alertButtonClicked:alertController tagIndex:tagIndex buttonIndex:buttonIndex];
    [self alertButtonDismiss:alertController tagIndex:tagIndex buttonIndex:buttonIndex];
}

-(void)alertButtonClicked:(UIAlertController *)alertController tagIndex:(NSInteger)tagIndex buttonIndex:(NSInteger)buttonIndex
{
    SharpScanPrintAppDelegate* appDelegate = (SharpScanPrintAppDelegate*)[[UIApplication sharedApplication] delegate];
    appDelegate.IsRun = NO;
    // 処理実行フラグOFF
    if(tagIndex == 10){
        switch (buttonIndex) {
            case 0:
                [alertController dismissViewControllerAnimated:YES completion:nil];
                break;
            case 1:
                [self showHelpView];
                break;
            default:
                break;
        }
    }
    else if(tagIndex == 2)
    {
        if(buttonIndex != 0){
            
            //選択状態を変更する
            NSUInteger newIndex[] = {selectIndexPath.section, selectIndexPath.row};
            NSIndexPath* newView = [[NSIndexPath alloc] initWithIndexes:newIndex length:2];
            [self.tableView selectRowAtIndexPath:newView animated:NO scrollPosition:UITableViewScrollPositionNone];
            
            PrintSelectTypeViewController_iPad* pPrintViewController;
            SelectFileViewController_iPad* pSelectFileViewController;
            ScanBeforePictViewController_iPad* pScanViewController;
            RemoteScanBeforePictViewController_iPad* pRemoteScanViewController;
            SettingSelInfoViewController_iPad* pSettingViewController;
            ArrengeSelectFileViewController_iPad* pArrengeSelectFileViewController;
            VersionInfoViewController_iPad* pVersionInfoViewController;
            if(selectIndexPath.section == 0){
                switch (selectIndexPath.row)
                {
                    case 0:
                        if([CommonUtil isCapableRemoteScan]){
                            pRemoteScanViewController = [[RemoteScanBeforePictViewController_iPad alloc] init];
                            // iPad用
                            [self ChangeDetailView:pRemoteScanViewController];
                            // iPad用
                        }else{
                            pScanViewController = [[ScanBeforePictViewController_iPad alloc] init];
                            // iPad用
                            [self ChangeDetailView:pScanViewController];
                            // iPad用
                        }
                        break;
                    case 1:
                        // iPad用
                        pPrintViewController = [[PrintSelectTypeViewController_iPad alloc] initWithStyle:UITableViewStyleGrouped];
                        [self ChangeDetailView:pPrintViewController];
                        // iPad用
                        break;
                    case 2:
                        pSelectFileViewController = [[SelectFileViewController_iPad alloc] init];
                        pSelectFileViewController.PrevViewID = SendMailSelectTypeView;
                        pSelectFileViewController.bSetTitle = YES;
                        // iPad用
                        [self ChangeDetailView:pSelectFileViewController];
                        // iPad用
                        break;
                    case 3:
                        pSelectFileViewController = [[SelectFileViewController_iPad alloc] init];
                        pSelectFileViewController.PrevViewID = SendExSiteSelectTypeView;
                        pSelectFileViewController.bSetTitle = YES;
                        // iPad用
                        [self ChangeDetailView:pSelectFileViewController];
                        // iPad用
                        break;
                    case 4:
                        pArrengeSelectFileViewController = [[ArrengeSelectFileViewController_iPad alloc] init];
                        // iPad用
                        pArrengeSelectFileViewController.bSetTitle = YES;
                        pArrengeSelectFileViewController.bCanDelete = YES;
                        [self ChangeDetailView:pArrengeSelectFileViewController];
                        // iPad用
                        
                        break;
                    default:
                        break;
                }
            }
            else
            {
                switch (selectIndexPath.row)
                {
                    case 0:
                        pSettingViewController = [[SettingSelInfoViewController_iPad alloc] initWithStyle:UITableViewStyleGrouped];
                        // iPad用
                        pSettingViewController.m_bVisibleMenuButton = true;
                        [self ChangeDetailView:pSettingViewController];
                        // iPad用
                        break;
                    case 1:
                        pVersionInfoViewController = [[VersionInfoViewController_iPad alloc] init];
                        // iPad用
                        [self ChangeDetailView:pVersionInfoViewController];
                        // iPad用
                        break;
                    default:
                        break;
                }
            }
            [self dismissMenuPopOver:YES];
        }
    }
}

-(void)alertButtonDismiss:(UIAlertController *)alertController tagIndex:(NSInteger)tagIndex buttonIndex:(NSInteger)buttonIndex
{
    // iPad用
    SharpScanPrintAppDelegate* appDelegate = (SharpScanPrintAppDelegate*)[[UIApplication sharedApplication] delegate];
    // 処理実行フラグOFF
    appDelegate.IsRun = FALSE;
}

// アラート表示
- (void) makeTmpExAlert:(NSString*)pstrTitle
                message:(NSString*)pstrMsg
         cancelBtnTitle:(NSString*)cancelBtnTitle
             okBtnTitle:(NSString*)okBtnTitle
                    tag:(NSInteger)tag
                showFlg:(BOOL)showFlg
{
    ExAlertController *tmpAlert = [ExAlertController alertControllerWithTitle:pstrTitle
                                                                      message:pstrMsg
                                                               preferredStyle:UIAlertControllerStyleAlert];
    tmpAlert.tag = tag;
    
    // Cancel用のアクションを生成
    if (cancelBtnTitle != nil) {
        UIAlertAction *cancelAction =
        [UIAlertAction actionWithTitle:cancelBtnTitle
                                 style:UIAlertActionStyleCancel
                               handler:^(UIAlertAction * action) {
                                   
                                   // ボタンタップ時の処理
                                   [self alertButtonPushed:tmpAlert tagIndex:tag buttonIndex:0];
                               }];
        // コントローラにアクションを追加
        [tmpAlert addAction:cancelAction];
    }
    
    // OK用のアクションを生成
    if (okBtnTitle != nil) {
        // OK用ボタンIndex
        NSInteger okIndex = (cancelBtnTitle == nil) ? 0 : 1;
        
        UIAlertAction *okAction =
        [UIAlertAction actionWithTitle:okBtnTitle
                                 style:UIAlertActionStyleDefault
                               handler:^(UIAlertAction * action) {
                                   
                                   // ボタンタップ時の処理
                                   [self alertButtonPushed:tmpAlert tagIndex:tag buttonIndex:okIndex];
                               }];
        // コントローラにアクションを追加
        [tmpAlert addAction:okAction];
    }
    
    if (showFlg) {
        // アラート表示処理
        [self presentViewController:tmpAlert animated:YES completion:nil];
    }
}

@end
