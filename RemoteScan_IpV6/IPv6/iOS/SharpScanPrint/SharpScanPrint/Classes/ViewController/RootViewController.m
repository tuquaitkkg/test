
#import "RootViewController.h"
#import "Define.h"
#import "PrintPictViewController.h"
#import "PrintSelectTypeViewController.h"
#import "ScanBeforePictViewController.h"
#import "SettingSelInfoViewController.h"
#import "SelectFileViewController.h"
#import "ArrengeSelectFileViewController.h"
#import "TempDataTableViewController.h"
#import "PrintPictViewController.h"
#import "VersionInfoViewController.h"
#import "SharpScanPrintAppDelegate.h"
#import "HelpViewController.h"
#import "RemoteScanBeforePictViewController.h"
#import "TempFile.h"
#import "TempFileUtility.h"
#import "ScanFile.h"
#import "ScanFileUtility.h"
#import "GeneralFileUtility.h"

@implementation RootViewController

@synthesize isExit = m_bExitView;							// 画面遷移もとフラグ
@synthesize siteUrl;

#pragma mark -
#pragma mark View lifecycle


- (void)viewDidLoad 
{
    // セルのラインを表示する
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;

    // UINavigationBar 44px のずれを無くす
    self.navigationController.navigationBar.translucent = NO;
    self.navigationController.navigationBar.barStyle = NAVIGATION_BARSTYLE;
    
    [super viewDidLoad];
    
    // ナビゲーションバー
    // タイトル設定
    self.navigationItem.title = S_TITLE_TOP;
    // ヘルプボタン
    UIBarButtonItem* barItemHelp = [[UIBarButtonItem alloc] initWithTitle:S_BUTTON_HELP style:UIBarButtonItemStylePlain target:self action:@selector(OnShowHelp)];
    self.navigationItem.leftBarButtonItem = barItemHelp;
    
    // 戻るボタンの名称変更
    UIBarButtonItem * barItemBack = [UIBarButtonItem new];
    barItemBack.title = S_BUTTON_BACK;
    self.navigationItem.backBarButtonItem = barItemBack;
    
    if(self.isExit)
    {
        self.isExit = FALSE;
        TempFile *tempFile = [self getUniqueTempFile:[[self.siteUrl path] lastPathComponent]];
        
        CommonManager *commanager = [[CommonManager alloc]init];
        [commanager moveFile:[self.siteUrl path] :tempFile.tempFilePath];

        // キャッシュファイルの作成
        [TempFileUtility createRequiredAllImageFiles:tempFile];
     
        // インジケータを止める
        SharpScanPrintAppDelegate *appDelegate = (SharpScanPrintAppDelegate *)[[UIApplication sharedApplication] delegate];
        [appDelegate stopIndicator];

        // TempDataへ画面遷移
        TempDataManager *tManager = [[TempDataManager alloc]init];
        
        // PROFILE情報の取得
        ProfileDataManager *profileDataManager = [[ProfileDataManager alloc] init];
        ProfileData *profileData = nil;
        profileData = [profileDataManager loadProfileDataAtIndex:0];
        // 他アプリから受けたファイルを残す：オン の場合
        if(profileData.saveExSiteFileMode)
        {
            SharpScanPrintAppDelegate* appDelegate = (SharpScanPrintAppDelegate*)[[UIApplication sharedApplication] delegate];
            // 処理実行フラグON
            appDelegate.IsRun = TRUE;
            // 外部アプリから呼び出し時、選択ファイルを保存する。
            if(![self copyTempData:tManager])
            {
                // 保存に失敗した場合
                // 外部連携ファイル保存失敗時に作成するアラート
                [self createAlertForExternalLoad:tManager];
            }
        }
        //TempDataManager *tManager = [TempDataManager sharedTempDataManager];
        if([tManager countOfTempData] != 1)
        {
            // 一覧遷移
            // ナビゲーションバー ボタン押下可能
            //self.navigationController.navigationBar.userInteractionEnabled = YES;
            TempDataTableViewController* tempDataTableViewController = [[TempDataTableViewController alloc]initWithStyle:UITableViewStyleGrouped] ;
            tempDataTableViewController.isScan = FALSE;
            
            [self.navigationController pushViewController:tempDataTableViewController animated:YES];
            
            
        }else
        {
            // ナビゲーションバー ボタン押下可能
            //self.navigationController.navigationBar.userInteractionEnabled = YES;
            
            //
            // 選択行の読み込み
            //
            TempData *aTempData = nil;
            aTempData	= [tManager loadTempDataAtIndexPath:0];
            
            PrintPictViewController* pPrintPictViewController = [[PrintPictViewController alloc] init];
            TempFile *localTempFile = [[TempFile alloc] initWithFileName:aTempData.fname];
            //
            // 呼び出し画面のプロパティ設定
            //
            pPrintPictViewController.SelFilePath	= localTempFile.tempFilePath;
            pPrintPictViewController.IsSite         = TRUE;
            pPrintPictViewController.IsSiteTemp     = TRUE;
            [self.navigationController pushViewController:pPrintPictViewController animated:YES];

        }
        /////////////////////////////////////////////////////////////////////////////// ここまで
        
    }
    else
    {
        // /Documents/Inbox/ フォルダが有れば消す
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *inboxPath = [[paths objectAtIndex:0] stringByAppendingPathComponent:@"Inbox"];
        NSFileManager *fm = [NSFileManager defaultManager];
        NSError *error;
        if ([fm fileExistsAtPath:inboxPath]) { // 確認
            // 削除
            [fm removeItemAtPath:inboxPath error:&error];
        }
    }
    // 色変更
    //self.navigationController.navigationBar.tintColor = [UIColor blackColor];
}

// 外部連携ファイル保存失敗時に作成するアラート
- (void)createAlertForExternalLoad:(TempDataManager*)tManager {
    // 保存に失敗した場合
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil
                                                                             message:MSG_SAVE_ERR
                                                                      preferredStyle:UIAlertControllerStyleAlert];
    // OK用のアクションを生成
    UIAlertAction *okAction =
    [UIAlertAction actionWithTitle:MSG_BUTTON_OK
                             style:UIAlertActionStyleDefault
                           handler:^(UIAlertAction * action) {
                               
                               // ボタンタップ時の処理
                               [self okButtonPushed:tManager];
                           }];
    
    // コントローラにアクションを追加
    [alertController addAction:okAction];
    // アラート表示処理
    [self presentViewController:alertController animated:YES completion:nil];
}

// OKボタンタップ時の処理(外部連携ファイル保存失敗時の処理)
- (void)okButtonPushed:(TempDataManager*)tManager {
    // 処理実行フラグをOFFにする
    [self appDelegateIsRunOff];
    
    // 保存失敗時の画面遷移処理
    if([tManager countOfTempData] != 1)
    {
        // 一覧遷移
        // ナビゲーションバー ボタン押下可能
        TempDataTableViewController* tempDataTableViewController = [[TempDataTableViewController alloc]initWithStyle:UITableViewStyleGrouped] ;
        tempDataTableViewController.isScan = FALSE;
        
        [self.navigationController pushViewController:tempDataTableViewController animated:YES];
        
        
    }else
    {
        //
        // 選択行の読み込み
        //
        TempData *aTempData = nil;
        aTempData	= [tManager loadTempDataAtIndexPath:0];
        
        PrintPictViewController* pPrintPictViewController = [[PrintPictViewController alloc] init];
        TempFile *localTempFile = [[TempFile alloc] initWithFileName:aTempData.fname];
        //
        // 呼び出し画面のプロパティ設定
        //
        pPrintPictViewController.SelFilePath	= localTempFile.tempFilePath;
        pPrintPictViewController.IsSite         = TRUE;
        pPrintPictViewController.IsSiteTemp     = TRUE;
        [self.navigationController pushViewController:pPrintPictViewController animated:YES];
        
    }
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
    // 選択状態解除
    [self.tableView deselectRowAtIndexPath:[self.tableView indexPathForSelectedRow] animated:YES];

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
- (void)viewWillDisappear:(BOOL)animated {
	[super viewWillDisappear:animated];
}
*/
/*
- (void)viewDidDisappear:(BOOL)animated {
	[super viewDidDisappear:animated];
}
*/

/*
 // Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
	// Return YES for supported orientations.
	return (interfaceOrientation == UIInterfaceOrientationPortrait);
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
    [self MoveView:indexPath];
}

- (void)tableView:(UITableView *)tableView accessoryButtonTappedForRowWithIndexPath:(NSIndexPath *)indexPath
{
    [self MoveView:indexPath];
}

#pragma mark -
#pragma mark Memory management

- (void)didReceiveMemoryWarning 
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Relinquish ownership any cached data, images, etc that aren't in use.
}

// 画面遷移
- (void)MoveView:(NSIndexPath *)nIndexPath
{
    // セルの複数タップを制御する
    if ( ! [self.navigationController.visibleViewController isKindOfClass: [self class]] ) {
        DLog(@"visibleViewController is Invalid");
        return;
    }

    PrintSelectTypeViewController* pPrintViewController;
	SelectFileViewController* pSelectFileViewController;
    ScanBeforePictViewController* pScanViewController;
    RemoteScanBeforePictViewController *pRemoteScanViewController; 
    SettingSelInfoViewController* pSettingViewController;
    ArrengeSelectFileViewController* pArrengeSelectFileViewController;
    VersionInfoViewController* pVersionInfoViewController;
    
    if(nIndexPath.section == 0){
        switch (nIndexPath.row)
        {
            case 0:
                // RemoteScanフラグで切り替え

                if([CommonUtil isCapableRemoteScan]) {
                    pRemoteScanViewController = [[RemoteScanBeforePictViewController alloc] init];
                    [self.navigationController pushViewController:pRemoteScanViewController animated:YES];
                }else {
                    pScanViewController = [[ScanBeforePictViewController alloc] init];
                    [self.navigationController pushViewController:pScanViewController animated:YES];
                }
                break;
            case 1:
                pPrintViewController = [[PrintSelectTypeViewController alloc] initWithStyle:UITableViewStyleGrouped];
                [self.navigationController pushViewController:pPrintViewController animated:YES];
                break;
            case 2:
                pSelectFileViewController = [[SelectFileViewController alloc] init];
                pSelectFileViewController.PrevViewID = SendMailSelectTypeView;
                [self.navigationController pushViewController:pSelectFileViewController animated:YES];
                break;
            case 3:
                pSelectFileViewController = [[SelectFileViewController alloc] init];
                pSelectFileViewController.PrevViewID = SendExSiteSelectTypeView;
                [self.navigationController pushViewController:pSelectFileViewController animated:YES];
                break;
            case 4:
                pArrengeSelectFileViewController = [[ArrengeSelectFileViewController alloc] init];
                //pSelectFileViewController.PrevViewID = ArrangeSelectTypeView;
                [self.navigationController pushViewController:pArrengeSelectFileViewController animated:YES];

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
                pSettingViewController = [[SettingSelInfoViewController alloc] initWithStyle:UITableViewStyleGrouped];
                [self.navigationController pushViewController:pSettingViewController animated:YES];
                break;
            case 1:
                pVersionInfoViewController = [[VersionInfoViewController alloc] init];
                [self.navigationController pushViewController:pVersionInfoViewController animated:YES];
                break;
            default:
                break;
        }
    }
}

// ヘルプ画面を表示
- (IBAction)OnShowHelp
{
    SharpScanPrintAppDelegate* appDelegate = (SharpScanPrintAppDelegate*)[[UIApplication sharedApplication] delegate];
    appDelegate.IsRun = YES;
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil
                                                                             message:MSG_OPENMANUAL_WITHEXTERNALAPP
                                                                      preferredStyle:UIAlertControllerStyleAlert];
    // Cancel用のアクションを生成
    UIAlertAction *cancelAction =
    [UIAlertAction actionWithTitle:MSG_BUTTON_CANCEL
                             style:UIAlertActionStyleCancel
                           handler:^(UIAlertAction * action) {
                               
                               // ボタンタップ時の処理
                               [self appDelegateIsRunOff];
                           }];
    
    // OK用のアクションを生成
    UIAlertAction *okAction =
    [UIAlertAction actionWithTitle:MSG_BUTTON_OK
                             style:UIAlertActionStyleDefault
                           handler:^(UIAlertAction * action) {
                               
                               // ボタンタップ時の処理
                               [self appDelegateIsRunOff];
                               [self showHelpView];
                           }];
    
    // コントローラにアクションを追加
    [alertController addAction:cancelAction];
    [alertController addAction:okAction];
    // アラート表示処理
    [self presentViewController:alertController animated:YES completion:nil];
}

// 処理実行フラグをOFFにする
- (void)appDelegateIsRunOff {
    // ボタンタップ時の処理
    SharpScanPrintAppDelegate* appDelegate = (SharpScanPrintAppDelegate*)[[UIApplication sharedApplication] delegate];
    // 処理実行フラグOFF
    appDelegate.IsRun = FALSE;
}

- (void)showHelpView{
    
    // サファリを起動してヘルプPDFファイルを表示する
    NSString *path = [S_HELPPDF_URL stringByAppendingString:S_HELPPDF_NAME];
    NSURL *url = [NSURL URLWithString:path];
    [[UIApplication sharedApplication] openURL:url];

}
// モーダル表示したヘルプ画面を閉じる
- (void)OnHelpClose
{
    [self dismissViewControllerAnimated:YES completion:nil];
}


@end

