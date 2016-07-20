
#import "SharpScanPrintAppDelegate.h"
#import "RootViewController.h"
#import "RootViewController_iPad.h"
#import "TempDataTableViewController.h"
#import "TempDataTableViewController_iPad.h"
#import "SettingSelDeviceViewController.h"
#import "SettingSelDeviceViewController_iPad.h"
#import "PrintPictViewController.h"
#import "PrintPictViewController_iPad.h"
#import "MultiPrintPictViewController.h"
#import "MultiPrintPictViewController_iPad.h"
#import "RemoteScanBeforePictViewController_iPad.h"
#import "CommonUtil.h"
#import "LicenseViewController.h"

#import "RemoteScanBeforePictViewController.h"

#import "FileNameChangeViewController.h"
#import "ShowMailViewController.h"
#import "PictureViewController_iPad.h"
#import "CreateFolderViewController.h"
#import "RSS_CustomSizeSettingViewController_iPad.h"
#import "ShowMailViewController_iPad.h"
#import "VersionInfoViewController_iPad.h"
#import "SettingApplicationViewController_iPad.h"
#import "SettingSelInfoViewController_iPad.h"
#import "SelectMailViewController_iPad.h"
#import "RSS_CustomSizeListViewController.h"
#import "AdvancedSearchResultViewController.h"
#import "ArrengeSelectFileViewController_iPad.h"
#import "SelectFileViewController_iPad.h"
#import "RSS_CustomSizeListViewController_iPad.h"
#import "TempDataTableViewController_iPad.h"
#import "SettingUserInfoViewController_iPad.h"
#import "PrintSelectTypeViewController_iPad.h"
#import "SettingMailServerInfoViewController_iPad.h"
#import "ScanAfterPictViewController.h"
#import "ScanAfterPictViewController_iPad.h"
#import "ScanFileUtility.h"
//// エラーログ出力用
//void uncaughtExceptionHandler(NSException *exception) {
//    DLog(@"CRASH: %@", exception);
//    DLog(@"Stack Trace: %@", [exception callStackSymbols]);
//    // Internal error reporting
//}

@implementation SharpScanPrintAppDelegate

@synthesize window;
@synthesize navigationController;
@synthesize splitViewController; // ipad用
@synthesize IsExSite = m_isExSite;
@synthesize Url = m_purl;
@synthesize masterPopoverController;
@synthesize IsStart;
@synthesize convertAlert;

-(BOOL)IsRun
{
	return m_bIsRun;
}

-(void)setIsRun:(BOOL)bIsRun
{
	m_bIsRun = bIsRun;
}

// iPad用
-(BOOL)IsPreview
{
	return m_bIsPreview;
}

-(void)setIsPreview:(BOOL)bIsPreview
{
	m_bIsPreview = bIsPreview;
}
// iPad用

#pragma mark -
#pragma mark Application lifecycle

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {

//    // エラーログ出力用
//    NSSetUncaughtExceptionHandler(&uncaughtExceptionHandler);

//    // 確認のため
//    for (int i = 0; i < 100; i++) {
//        [NSThread sleepForTimeInterval:1.0];
//        DLog(@"起動中ーーーーーーーーーーーーー%d",i);
//        
//    }
    
    // 外部アプリから呼び出されたかチェック
    BOOL isloginAlertView = TRUE;
    if(launchOptions != nil &&
       [launchOptions valueForKey:UIApplicationLaunchOptionsURLKey] != nil)
    {
        // 外部から呼び出された場合はopenURLで処理を行う
        self.IsStart = TRUE;
    }
    else
    {
        if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
        {
            // ipad用
            // 画面遷移
            [self SetLoginAlertView:isloginAlertView];
        }
        else
        {
            // iPhone用
            // ログインフラグ(ライセンス同意フラグ)を取得
            NSUserDefaults* pud = [NSUserDefaults standardUserDefaults]; 
            BOOL isLogin = [pud boolForKey:S_LOGIN];
            
            self.IsExSite = FALSE;
            
            if(!isLogin)
            {
                
                UIViewController *vc = [[UIViewController alloc]init];
                vc.view.backgroundColor = [UIColor blackColor];
                
                window.rootViewController = vc;
                [window makeKeyAndVisible];

                // ライセンス画面表示
                [self createLicenseView];
                
                m_bIsShowAlert = false;
            }
            else
            {
                // 移行処理の前にwindowにrootViewControllerをセットしておく
                RootViewController* rootViewController = [[RootViewController alloc]initWithStyle:UITableViewStyleGrouped] ;

                navigationController = [[UINavigationController alloc]
                                        initWithRootViewController:rootViewController];
                navigationController.navigationBar.barStyle = NAVIGATION_BARSTYLE;

                window.rootViewController = navigationController;
                [window makeKeyAndVisible];

                // Version2.2への移行処理を開始する
                [self doConvertProcessing];

            }
        }
    }
    
//    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0) {
//        // アプリケーション全体のtintColorを設定する
//        self.window.tintColor = [UIColor colorWithRed:0 green:0.5 blue:1 alpha:1];
//    }
    
    return YES;
}


- (void)applicationWillResignActive:(UIApplication *)application {
    /*
     Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
     Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
     */
    
    
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    /*
     Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
     If your application supports background execution, called instead of applicationWillTerminate: when the user quits.
     */
    
    // メニューが表示されていれば隠す
    [self dismissPopoverAnimated:NO];
    
    if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
    {
        // iPad用
        if([[self.splitViewController.viewControllers objectAtIndex:1] isKindOfClass:[UINavigationController class]])
        {
            UINavigationController* pDetailNavController = [self.splitViewController.viewControllers objectAtIndex:1];
            [pDetailNavController.topViewController.view endEditing:YES];
            
            UINavigationController* pRootNavController = [self.splitViewController.viewControllers objectAtIndex:0];
            if([pRootNavController.topViewController isKindOfClass:[RootViewController_iPad class]])
            {
//                RootViewController_iPad* rootViewController = (RootViewController_iPad*)pRootNavController.topViewController;
//                // iPadの場合だけヘルプ画面を閉じる処理が入っている
//                [rootViewController OnHelpClose];
            }
        }
    }
    else
    {
        // キーボードを非表示にする。
        [self.navigationController.topViewController.view endEditing:YES];
    }
    
    if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
    {
        // iPad用
        if([self.splitViewController.viewControllers count] > 1)
        {
            UIViewController * viewController = [self.splitViewController.viewControllers objectAtIndex:1];
            
            if ([viewController isKindOfClass: [UINavigationController class]]) {
                UINavigationController* pDetailNavController = (UINavigationController *)viewController;
                UIViewController* pVisibleViewController = pDetailNavController.topViewController;
                if([pVisibleViewController isKindOfClass:[RemoteScanBeforePictViewController_iPad class]])
                {
                    RemoteScanBeforePictViewController_iPad* remoteScan = (RemoteScanBeforePictViewController_iPad*)pVisibleViewController;
                    
                    // セッションID解放
                    [remoteScan DidBackgroundEnter];
                    
                } else if ([pVisibleViewController isKindOfClass:[SettingSelDeviceViewController_iPad class]]) {
                    // 自動検索中なら中止する
                    SettingSelDeviceViewController_iPad *selDeviceView = (SettingSelDeviceViewController_iPad*)pVisibleViewController;
                    [selDeviceView StopSearchForSeviceOfTypeCloseAlert:YES];
                    self.IsRun = NO;
                }
            }
        }
        
    }
    else
    {
        UIViewController* visibleViewController = self.navigationController.visibleViewController;
        
        if([visibleViewController isKindOfClass:[RemoteScanBeforePictViewController class]])
        {
            RemoteScanBeforePictViewController* remoteScan = (RemoteScanBeforePictViewController*)visibleViewController;
            
            // セッションID解放
            [remoteScan DidBackgroundEnter];
            
        } else if ([visibleViewController isKindOfClass:[SettingSelDeviceViewController class]]) {
            // 自動検索中なら中止する
            SettingSelDeviceViewController *selDeviceView = (SettingSelDeviceViewController*)visibleViewController;
            [selDeviceView StopSearchForSeviceOfTypeCloseAlert:YES];
            self.IsRun = NO;
        }
    }
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    /*
     Called as part of  transition from the background to the inactive state: here you can undo many of the changes made on entering the background.
     */
    
    if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
    {
        // iPad用
        if([self.splitViewController.viewControllers count] > 1)
        {
            UIViewController * viewController = [self.splitViewController.viewControllers objectAtIndex:1];
            
            if ([viewController isKindOfClass: [UINavigationController class]]) {
                UINavigationController* pDetailNavController = (UINavigationController *)viewController;
                UIViewController* pVisibleViewController = pDetailNavController.topViewController;
                if([pVisibleViewController isKindOfClass:[RemoteScanBeforePictViewController_iPad class]])
                {
                    RemoteScanBeforePictViewController_iPad* remoteScan = (RemoteScanBeforePictViewController_iPad*)pVisibleViewController;
                    
                    // 画面起動時は通信を再開する
                    [remoteScan WillForegroundEnter];
                    
                }
            }
        }
    }
    else
    {
        UIViewController* visibleViewController = self.navigationController.visibleViewController;
        
        if([visibleViewController isKindOfClass:[RemoteScanBeforePictViewController class]])
        {
            RemoteScanBeforePictViewController* remoteScan = (RemoteScanBeforePictViewController*)visibleViewController;
            
            // 画面起動時は通信を再開する
            [remoteScan WillForegroundEnter];
            
        }
    }

}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    /*
     Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
     */

    // ログインフラグ(ライセンス同意フラグ)を取得
    NSUserDefaults* pud = [NSUserDefaults standardUserDefaults]; 
    BOOL isLogin = [pud boolForKey:S_LOGIN];
    if(!isLogin)
    {
        // ライセンスアラートを再作成する
        if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
        {
            // iPad用
            if(loginAlertViewController.IsShowLicense)
            {
                [loginAlertViewController createLicenseView];
            }
            loginAlertViewController.IsShowLicense = TRUE;
        }
        else
        {
            // iPhone用
            if(m_bIsShowAlert)
            {
                // ライセンス画面表示
                [self createLicenseView];
            }
            m_bIsShowAlert = true;
        }
    }
}


- (void)applicationWillTerminate:(UIApplication *)application {
    /*
     Called when the application is about to terminate.
     See also applicationDidEnterBackground:.
     */
    // tempフォルダにファイルがあれば削除
    NSFileManager	*fileManager	= [NSFileManager defaultManager];
    [fileManager removeItemAtPath:[CommonUtil tmpDir] error:NULL];	// ディレクトリ削除  
}


#pragma mark -
#pragma mark Memory management

- (void)applicationDidReceiveMemoryWarning:(UIApplication *)application {
    /*
     Free up as much memory as possible by purging cached data objects that can be recreated (or reloaded from disk) later.
     */
}

-(BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation
{
    /*
    // topViewControllerがSettingSelInfoViewControllerか値チェック
    if([self.navigationController.topViewController class] == [SettingSelDeviceViewController class])
    {
        SettingSelDeviceViewController* settingSelDeviceViewController =(SettingSelDeviceViewController*)self.navigationController.topViewController;
        if(settingSelDeviceViewController.TimeoutSearchForSearvice != nil)
        {
            // サービス検索タイマー停止
            [settingSelDeviceViewController StopSearchForSeviceOfTypeCloseAlert:YES];
        }
    }
    */
    BOOL bSuccess = TRUE;
    NSString* pstrErrMessage = @"";
    
    // ライセンスに同意済みかどうか
    if(![self isLicenseAgreement:url]) {
        // ライセンス同意前なら終了する
        return YES;
    }
    
    // Version2.2 への移行確認
    if (![ScanFileUtility isConvertVersion2_2]) {
        
        // 移行処理を開始する
        
        // 移行開始のアラート出力
        self.convertAlert = [self convertOpeningAlert];
        // Version2.2への移行本処理
        [self performSelectorInBackground:@selector(convertVersion2_2) withObject:nil];

        return YES;
    }
    
    // 取り込み後画面表示中は、外部連携を受け付けない
    BOOL isScanAfter = NO;
    if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        if([[self.splitViewController.viewControllers objectAtIndex:1] isKindOfClass:[UINavigationController class]]) {
            UINavigationController* pDetailNavController = [self.splitViewController.viewControllers objectAtIndex:1];
            if([pDetailNavController.topViewController isKindOfClass:[ScanAfterPreViewController_iPad class]] ||
               [pDetailNavController.topViewController isKindOfClass:[ScanAfterPictViewController_iPad class]] ||
               [pDetailNavController.topViewController isKindOfClass:[TempDataTableViewController_iPad class]]) { // TempDataTableViewController_iPadが右側ビューに表示されるのは取り込みの時だけ。外部連家時は左側
                isScanAfter = YES;
            }
        }
    } else {
        if([self.navigationController.topViewController isKindOfClass:[ScanAfterPreViewController class]] ||
           [self.navigationController.topViewController isKindOfClass:[ScanAfterPictViewController class]] ||
           [self.navigationController.topViewController isKindOfClass:[TempDataTableViewController class]]){
        isScanAfter = YES;
        }
    }
    if(isScanAfter) {
        pstrErrMessage = [NSString stringWithFormat:MSG_RECIEVE_ERR_PROCESSING, MSG_RECIEVE_ERR_SCAN];
        bSuccess = NO;
    }else if(self.IsRun)
    {
        // 中断不可の処理起動中エラー
        // 起動失敗
        bSuccess = FALSE;
        // 取り込み失敗
        NSString* sProcess = MSG_RECIEVE_ERR_BUSY;
        NSString* sTopViewDescription = @"";
        UIViewController* topViewController;
        if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
        {
            // ipad用
            // 表示画面を取得
            UINavigationController* pDetailViewController = [self.splitViewController.viewControllers objectAtIndex:1];
            sTopViewDescription = [[pDetailViewController.topViewController class] description];
            topViewController = pDetailViewController.topViewController;
        }
        else
        {
            // iphone用
            // 表示画面を取得
            sTopViewDescription = [[self.navigationController.topViewController class] description];
            topViewController = self.navigationController.topViewController;
        }
        
        DLog(@"topViewController:%@",[topViewController description]);
        DLog(@"presentedViewController:%@",[[topViewController presentedViewController] description]);
        if ([topViewController presentedViewController] == nil) {
            // 表示画面が画像プレビュー(取込み前)画面
            if([sTopViewDescription hasPrefix:[ScanBeforePictViewController description]] ||
               [sTopViewDescription hasPrefix:[RemoteScanBeforePictViewController description]] ||
               [sTopViewDescription hasPrefix:[ScanBeforePictViewController_iPad description]] ||
               [sTopViewDescription hasPrefix:[RemoteScanBeforePictViewController_iPad description]])
            {
                sProcess = MSG_RECIEVE_ERR_SCAN;
            }
            // 表示画面が画像プレビュー(印刷)画面
            else if([sTopViewDescription hasPrefix:[PrintPictViewController description]] ||
                    [sTopViewDescription hasPrefix:[MultiPrintPictViewController description]] ||
                    [sTopViewDescription hasPrefix:[PrintPictViewController_iPad description]] ||
                    [sTopViewDescription hasPrefix:[MultiPrintPictViewController_iPad description]])
            {
                sProcess = MSG_RECIEVE_ERR_PRINT;
            }
        }
        pstrErrMessage = [NSString stringWithFormat:MSG_RECIEVE_ERR_PROCESSING, sProcess];
    }
    else if(![[url scheme]isEqualToString:@"file"])
    {
        // ファイル以外エラー
        // 起動失敗
        bSuccess = FALSE;
        // 取り込み失敗
        pstrErrMessage = MSG_RECIEVE_ERR;
    }
    else
    {
        // Override point for customization after application launch
        // ディレクトリ削除
        NSFileManager *fileManager	= [NSFileManager defaultManager];
        if(![fileManager removeItemAtPath:[CommonUtil tmpDir] error:NULL])
        {
            // ディレクトリ削除エラー
            // 起動失敗
            bSuccess = FALSE;
            // ディレクトリ削除エラー
            pstrErrMessage = [NSString stringWithFormat:MSG_RECIEVE_ERR_PROCESSING, MSG_RECIEVE_ERR_SAVE];
        }
        else
        {
            
            self.IsExSite = TRUE;
            self.Url = url;
            
            if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
            {
                // ipad用
                // 画面遷移
                if (self.IsStart) {
                    //外部アプリからの連携でアプリが起動した場合
                    [self SetLoginAlertView:TRUE];
                    loginAlertViewController.IsShowLicense = FALSE;
                    
                    [self createAndShowIndicator];
                }
                else
                {
                    // iPad用
                    if([[self.splitViewController.viewControllers objectAtIndex:1] isKindOfClass:[UINavigationController class]])
                    {
                        UINavigationController* pRootNavController = [self.splitViewController.viewControllers objectAtIndex:0];
                        if([pRootNavController.topViewController isKindOfClass:[RootViewController_iPad class]])
                        {
                            RootViewController_iPad* rootViewController = (RootViewController_iPad*)pRootNavController.topViewController;
                            // iPadの場合だけヘルプ画面を閉じる処理が入っている
                            [rootViewController OnHelpClose];
                        }
                    }

                    //アプリ起動中に外部アプリから連携された場合
                    UINavigationController* pRootNav = (UINavigationController*)[self.splitViewController.viewControllers objectAtIndex:0];
                    RootViewController_iPad* pRootView = (RootViewController_iPad*)[pRootNav.viewControllers objectAtIndex:0];
                    //アプリ起動時の画面に戻す
                    [pRootView setDefaultTopScreen];
                    
                    pRootView.siteUrl = url;
                    //外部アプリから連携された場合の表示に更新
                    [pRootView performSelectorOnMainThread:@selector(showOpenUrlFile) withObject:nil waitUntilDone:YES];
                }
                self.IsStart = false;
            }
            else
            {
                // iphone用
                // ログインフラグ(ライセンス同意フラグ)を取得
                NSUserDefaults* pud = [NSUserDefaults standardUserDefaults]; 
                BOOL isLogin = [pud boolForKey:S_LOGIN];                
                if(!isLogin)
                {
                    
                    UIViewController *vc = [[UIViewController alloc]init];
                    vc.view.backgroundColor = [UIColor blackColor];
                    window.rootViewController = vc;
                    [window makeKeyAndVisible];
                    
                    // ライセンス画面表示
                    [self createLicenseView];
//                    m_bIsShowAlert = false;
                    m_bIsShowAlert = true;
                }
                else
                {
                    RootViewController* rootViewController = [[RootViewController alloc]initWithStyle:UITableViewStyleGrouped] ;
                    rootViewController.isExit = TRUE;
                    rootViewController.siteUrl = url;
                    navigationController = [[UINavigationController alloc]
                                            initWithRootViewController:rootViewController];
                    navigationController.navigationBar.barStyle = NAVIGATION_BARSTYLE;
                    window.rootViewController = navigationController;
                    [window makeKeyAndVisible];
                    
                    [self createAndShowIndicator];
                }
            }
        }
    }
    
    // 起動確認
    if (!bSuccess)
    {
        [self makeTmpExAlert:nil message:pstrErrMessage cancelBtnTitle:MSG_BUTTON_OK okBtnTitle:nil tag:0 showFlg:YES];
    }
    
    return bSuccess;

}

// ライセンスに同意済みかどうか
- (BOOL)isLicenseAgreement:(NSURL *)url {
    
    self.IsExSite = TRUE;
    self.Url = url;
    
    // ログインフラグ(ライセンス同意フラグ)を取得
    NSUserDefaults* pud = [NSUserDefaults standardUserDefaults];
    BOOL isLogin = [pud boolForKey:S_LOGIN];

    if(!isLogin)
    {
        if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad){
            // iPad用
            [self SetLoginAlertView:YES];
            
            if(loginAlertViewController.IsShowLicense)
            {
                [loginAlertViewController createLicenseView];
            }
            loginAlertViewController.IsShowLicense = TRUE;
                        
        } else {
            // iphone用
            UIViewController *vc = [[UIViewController alloc]init];
            vc.view.backgroundColor = [UIColor blackColor];
            window.rootViewController = vc;
            [window makeKeyAndVisible];
            
            // ライセンス画面表示
            [self createLicenseView];
            m_bIsShowAlert = true;
        }
    }

    return isLogin;
}


- (void)dealloc {
    if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
    {
        // ipad用
    }
    else
    {
        // iphone用
    }
}

// ライセンス画面を開く
- (void)createLicenseView
{
    
    LicenseViewController* licenseViewController = [[LicenseViewController alloc]init];
    
    UINavigationController *mNavigationController = [[UINavigationController alloc]initWithRootViewController:licenseViewController];
    // UINavigationBar 44px のずれを無くす
    mNavigationController.navigationBar.translucent = NO;
    mNavigationController.navigationBar.barStyle = NAVIGATION_BARSTYLE;
    
    // 同意するボタン追加
    UIBarButtonItem *rb = [[UIBarButtonItem alloc] initWithTitle:S_BUTTON_AGREE style:UIBarButtonItemStyleDone target:self action:@selector(closeLicenseView)];
    [licenseViewController.navigationItem setRightBarButtonItem:rb animated:NO];
    
    // モーダルで開く
    [mNavigationController setModalPresentationStyle:UIModalPresentationPageSheet];
    [window.rootViewController presentViewController:mNavigationController animated:YES completion:nil];
    

}

// ライセンス画面を閉じる
- (void)closeLicenseView
{
    // モーダルを閉じる
    [window.rootViewController dismissViewControllerAnimated:YES completion:nil];
    
    // ログインフラグ(ライセンス同意フラグ)保存
    NSUserDefaults* pud = [NSUserDefaults standardUserDefaults];

    [pud setBool:TRUE forKey:S_LOGIN];
    [pud synchronize];

    // Version2.2への移行処理を開始する
    [self doConvertProcessing];
}


// 移行処理がある場合は移行を、ない場合は現行画面に遷移させる
- (void)doConvertProcessing {

    // Version2.2 への移行確認
    if (![ScanFileUtility isConvertVersion2_2]) {

        // 移行処理を開始する

        // 移行開始のアラート出力
        self.convertAlert = [self convertOpeningAlert];
        // Version2.2への移行本処理
        [self performSelectorInBackground:@selector(convertVersion2_2) withObject:nil];
        
    } else {
        // 移行済みの場合は、現行の画面遷移へ
        [self doConvertFinish];
    }

}

// 移行開始のアラート出力
-(ExAlertController*)convertOpeningAlert
{
    ExAlertController* tmpAlert = [self makeTmpExAlert:nil message:[NSString stringWithFormat:@"%@",MSG_UPGRADING_INTERNALDATA] cancelBtnTitle:nil okBtnTitle:nil tag:0 showFlg:YES];
    return tmpAlert;
}

// Version2.2への移行本処理
- (void)convertVersion2_2{
    // Version2.2への移行
    [ScanFileUtility convertToVersion2_2];
    
    // 処理を一定時間止める（試験用）
    [NSThread sleepForTimeInterval:2.0];
    
    // 移行終了
    if(self.convertAlert){
        // 移行開始アラートを消す
        NSOperationQueue *queue1 = [NSOperationQueue mainQueue];
        [queue1 addOperationWithBlock:^(){
            [self.convertAlert dismissViewControllerAnimated:YES completion:nil];
        }];
    }
    
    // 移行結果確認
    NSFileManager *fileManager = [NSFileManager defaultManager];
    // 移行前ドキュメント保存パス
    NSString *beforeSavePath = [[ScanFileUtility getScanFileDirectoryPath] stringByAppendingPathComponent:@"ScanFile"];
    // 移行結果メッセージ
    NSString *resultMessage;
    
    if ([fileManager fileExistsAtPath:beforeSavePath]) {
        // 移行失敗データあり
        resultMessage = [NSString stringWithFormat:@"%@",MSG_UPGRADE_INTERNALDATA_ERR];
    } else {
        // 移行成功
        resultMessage = [NSString stringWithFormat:@"%@",MSG_UPGRADE_INTERNALDATA_COMPLETE];
    }
    
    // 移行結果アラート出力
    NSOperationQueue *queue2 = [NSOperationQueue mainQueue];
    [queue2 addOperationWithBlock:^(){
        [self convertResultAlert:resultMessage];
    }];
    
}

// 移行結果のアラート出力
-(void)convertResultAlert:(NSString*) resultMessage
{
    [self makeTmpExAlert:nil message:resultMessage cancelBtnTitle:MSG_BUTTON_OK okBtnTitle:nil tag:50 showFlg:YES];
}

// アラートボタン押下処理
-(void)alertButtonPushed:(UIAlertController *)alertController tagIndex:(NSInteger)tagIndex buttonIndex:(NSInteger)buttonIndex
{
    [self alertButtonClicked:alertController tagIndex:tagIndex buttonIndex:buttonIndex];
}

-(void)alertButtonClicked:(UIAlertController *)alertController tagIndex:(NSInteger)tagIndex buttonIndex:(NSInteger)buttonIndex
{
    switch (tagIndex)
    {
        case 50:
        {
            // (移行完了後)現行処理を実施する
            [self doConvertFinish];
        }
        default:
            break;
    }
}

// (移行完了後)現行処理を実施する
- (void)doConvertFinish
{
    // iPadの場合
    if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad){
        [self SetView];
        
    // iPhoneの場合
    } else {
        // Topメニュー画面表示
        RootViewController* rootViewController = [[RootViewController alloc]initWithStyle:UITableViewStyleGrouped];
        
        // 外部から呼び出し時はフラグとURLを保持
        if(m_isExSite)
        {
            rootViewController.isExit = TRUE;
            rootViewController.siteUrl = m_purl;
        }
        
        navigationController = [[UINavigationController alloc]
                                initWithRootViewController:rootViewController];
        navigationController.navigationBar.barStyle = NAVIGATION_BARSTYLE;
        window.rootViewController = navigationController;
        [window makeKeyAndVisible];
    }
}

//// ライセンス画面を閉じる
//- (void)closeLicenseView
//{
//    // モーダルを閉じる
//    [window.rootViewController dismissViewControllerAnimated:YES completion:nil];
//    
//    // ログインフラグ(ライセンス同意フラグ)保存
//    NSUserDefaults* pud = [NSUserDefaults standardUserDefaults];
//    
//    [pud setBool:TRUE forKey:S_LOGIN];
//    [pud synchronize];
//    
//    // Topメニュー画面表示
//    RootViewController* rootViewController = [[RootViewController alloc]initWithStyle:UITableViewStyleGrouped];
//    // 外部から呼び出し時はフラグとURLを保持
//    if(m_isExSite)
//    {
//        rootViewController.isExit = TRUE;
//        rootViewController.siteUrl = m_purl;
//    }
//    navigationController = [[UINavigationController alloc]
//                            initWithRootViewController:rootViewController];
//    navigationController.navigationBar.barStyle = NAVIGATION_BARSTYLE;
//    window.rootViewController = navigationController;
//    [window makeKeyAndVisible];
//}

// ipad用
- (void)SetLoginAlertView:(BOOL)isloginAlertViewShow
{
    // 画面をwindowから削除
    for(UIView* view in window.subviews)
    {
        [view removeFromSuperview];
    }
    // TOPメニュー画面表示時に画面の向きを取得するため、一つ画面を挟む
    if(loginAlertViewController == nil)
    {
        loginAlertViewController = [[LoginAlertViewController_iPad alloc] init];
    }
    
    loginAlertViewController.IsShowLicense = NO;
    loginAlertViewController.IsView = isloginAlertViewShow;
    UINavigationController * rootNavigationController = [[UINavigationController alloc]initWithRootViewController:loginAlertViewController];
    rootNavigationController.delegate = loginAlertViewController;
    rootNavigationController.navigationBar.barStyle = NAVIGATION_BARSTYLE;
    window.rootViewController = rootNavigationController;
    [window makeKeyAndVisible];

    // ログインフラグ(ライセンス同意フラグ)を取得
    NSUserDefaults* pud = [NSUserDefaults standardUserDefaults];
    BOOL isLogin = [pud boolForKey:S_LOGIN];
    m_bIsShowAlert = !isLogin;
}

// 起動時の表示画面設定
- (void)SetView
{
    
    RootViewController_iPad *rootViewController = [[RootViewController_iPad alloc]initWithStyle:UITableViewStyleGrouped];
    ScanBeforePictViewController_iPad *detailViewController = nil;

    if([CommonUtil isCapableRemoteScan]){
    // リモートスキャン
        detailViewController = [[RemoteScanBeforePictViewController_iPad alloc] init];
    }else{
        detailViewController = [[ScanBeforePictViewController_iPad alloc] init];
    }
    // UIAlertController置き換え時に、iPad縦向きでの初回起動時はマスタービュー（左側ビュー）を表示しないようにする
    detailViewController.isShowMenu = false;
    // 外部アプリから呼び出し時
    if(m_isExSite)
    {
        rootViewController.isExit = TRUE;
        rootViewController.siteUrl = m_purl;
        detailViewController.isShowAlert = NO;
    }
    UINavigationController *navRootController = [[UINavigationController alloc]initWithRootViewController:rootViewController];
    navRootController.delegate = rootViewController;
    navRootController.navigationBar.barStyle = NAVIGATION_BARSTYLE;
    
    UINavigationController *navDetailController = [[UINavigationController alloc]initWithRootViewController:detailViewController];
    navDetailController.delegate = detailViewController;
    navDetailController.navigationBar.barStyle = NAVIGATION_BARSTYLE;
    
    NSArray *viewControllers = [[NSArray alloc] initWithObjects:navRootController, navDetailController, nil];
    splitViewController.viewControllers = viewControllers;
//    splitViewController.delegate = rootViewController;
    splitViewController.delegate = (id)self;
    
    // iOSのバージョンを取得
//    float version = [[[UIDevice currentDevice]systemVersion]floatValue];
//    if(version >= 5.1f) {
    if (floor(NSFoundationVersionNumber) >= NSFoundationVersionNumber_iOS_5_1) {
        // iOS5.1以降で発生するsplitViewのスワイプ表示を行わない
        splitViewController.presentsWithGesture = NO;
    }

//    UIInterfaceOrientation orientation = [[UIApplication sharedApplication] statusBarOrientation];
//    if(rootViewController.barItemMenu == nil && (orientation != UIDeviceOrientationPortrait && orientation != UIDeviceOrientationPortraitUpsideDown))
//        {
//            [navigationController.navigationItem setLeftBarButtonItem:nil animated:NO];
//        }
//        else
//        {
//            [navigationController.navigationItem setLeftBarButtonItem:nil animated:NO];
//            // 左上メニューボタンのタイトル変更
//            if(rootViewController.barItemMenu != nil)
//            {
//                rootViewController.barItemMenu.title = S_BUTTON_MENU;
//                [navigationController.navigationItem setLeftBarButtonItem:rootViewController.barItemMenu animated:NO];
//            }
//        }
//
    
    window.rootViewController = splitViewController;
    [window makeKeyAndVisible];
    
    [splitViewController reloadInputViews];

    if (m_bIsShowAlert) {
        window.backgroundColor = [UIColor blackColor];
        window.rootViewController.view.alpha = 0.01;
        [self performSelector:@selector(show) withObject:nil afterDelay:1.5];
    }
    
}
// ipad用
- (void)show
{
    [UIView animateWithDuration:0.1 animations:^{
        window.rootViewController.view.alpha = 1.0;
    }];
    m_bIsShowAlert = false;
}

// 外部連携時の処理中インジケータを表示する
#define APP_OPENURL_INDICATOR_TAG 10000
-(void)createAndShowIndicator
{
//    DLog(@"%s", __func__);
//    UIActivityIndicatorView* indicator = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
//    indicator.tag = APP_OPENURL_INDICATOR_TAG;
//    [indicator setCenter:CGPointMake(window.frame.size.width/2, window.frame.size.height/2)];
//    [indicator startAnimating];
//    [window addSubview:indicator];
}

-(void)stopIndicator
{
//    DLog(@"%s", __func__);
//    UIActivityIndicatorView* indicator = (UIActivityIndicatorView*)[window viewWithTag:APP_OPENURL_INDICATOR_TAG];
//    if(indicator){
//        [indicator removeFromSuperview];
////        [indicator stopAnimating];
//    }
}

#pragma mark - Split view
// 横から縦になった時
- (void)splitViewController:(UISplitViewController *)splitController
     willHideViewController:(UIViewController *)viewController
          withBarButtonItem:(UIBarButtonItem *)barButtonItem
       forPopoverController:(UIPopoverController *)popoverController
{
   // 左上メニューボタンのタイトル変更
//    UINavigationController* pDetailNavController = self.splitViewController.viewControllers[1];
//    UIViewController* navController = (UIViewController*)[pDetailNavController topViewController];
    UINavigationController* pDetailNav = (UINavigationController*)[self.splitViewController.viewControllers objectAtIndex:1];
    UIViewController* detailViewController = (UIViewController*)[pDetailNav topViewController]; //RemoteScanBeforePictViewController_iPad,
    UINavigationController* pRootNavController = [self.splitViewController.viewControllers objectAtIndex:0];
    RootViewController_iPad* rootViewController = (RootViewController_iPad*)[pRootNavController.viewControllers objectAtIndex:0];

    if(rootViewController.barItemMenu == nil)
    {
        // 右側Viewに表示するメニューボタン(左上)を生成
        rootViewController.barItemMenu = [[UIBarButtonItem alloc] initWithTitle:S_BUTTON_MENU style:UIBarButtonItemStylePlain target:rootViewController action:@selector(OnMenuPopOverView:)];
        
        // ナビゲーションバー上ボタンのマルチタップを制御する
        for (UIView * view in detailViewController.navigationController.navigationBar.subviews) {
            if ([view isKindOfClass: [UIView class]]) {
                [view setExclusiveTouch:YES];
            }
        }
    }
    //画面別にメニューボタンの文言更新
    if (detailViewController.navigationItem.hidesBackButton ||
        [pDetailNav.viewControllers count] == 1) {
        DLog(@"willHideViewController %@",[detailViewController class]);
        // 右側のViewを初期起動時の状態に戻す
        if ([detailViewController isKindOfClass:[FileNameChangeViewController class]]) {
            [(FileNameChangeViewController*)detailViewController setPortraitMenu:rootViewController.barItemMenu];
        }else if ([detailViewController isKindOfClass:[ShowMailViewController class]]) {
            [(ShowMailViewController*)detailViewController setPortraitMenu:rootViewController.barItemMenu];
        }else if ([detailViewController isKindOfClass:[PictureViewController_iPad class]]) {
            [(PictureViewController_iPad*)detailViewController setPortraitMenu:rootViewController.barItemMenu];
        }else if ([detailViewController isKindOfClass:[CreateFolderViewController class]]) {
            [(CreateFolderViewController*)detailViewController setPortraitMenu:rootViewController.barItemMenu];
        }else if ([detailViewController isKindOfClass:[RSS_CustomSizeSettingViewController_iPad class]]) {
            [(RSS_CustomSizeSettingViewController_iPad*)detailViewController setPortraitMenu:rootViewController.barItemMenu];
        }else if ([detailViewController isKindOfClass:[ShowMailViewController_iPad class]]) {
            [(ShowMailViewController_iPad*)detailViewController setPortraitMenu:rootViewController.barItemMenu];
        }else if ([detailViewController isKindOfClass:[VersionInfoViewController_iPad class]]) {
            [(VersionInfoViewController_iPad*)detailViewController setPortraitMenu:rootViewController.barItemMenu];
        }else if ([detailViewController isKindOfClass:[SettingApplicationViewController_iPad class]]) {
            [(SettingApplicationViewController_iPad*)detailViewController setPortraitMenu:rootViewController.barItemMenu];
        }else if ([detailViewController isKindOfClass:[SettingSelInfoViewController_iPad class]]) {
            [(SettingSelInfoViewController_iPad*)detailViewController setPortraitMenu:rootViewController.barItemMenu];
        }else if ([detailViewController isKindOfClass:[SelectMailViewController_iPad class]]) {
            [(SelectMailViewController_iPad*)detailViewController setPortraitMenu:rootViewController.barItemMenu];
        }else if ([detailViewController isKindOfClass:[RSS_CustomSizeListViewController class]]) {
            [(RSS_CustomSizeListViewController*)detailViewController setPortraitMenu:rootViewController.barItemMenu];
        }else if ([detailViewController isKindOfClass:[AdvancedSearchResultViewController class]]) {
            [(AdvancedSearchResultViewController*)detailViewController setPortraitMenu:rootViewController.barItemMenu];
        }else if ([detailViewController isKindOfClass:[ArrengeSelectFileViewController_iPad class]]) {
            [(ArrengeSelectFileViewController_iPad*)detailViewController setPortraitMenu:rootViewController.barItemMenu];
        }else if ([detailViewController isKindOfClass:[SelectFileViewController_iPad class]]) {
            [(SelectFileViewController_iPad*)detailViewController setPortraitMenu:rootViewController.barItemMenu];
        }else if ([detailViewController isKindOfClass:[RSS_CustomSizeListViewController_iPad class]]) {
            [(RSS_CustomSizeListViewController_iPad*)detailViewController setPortraitMenu:rootViewController.barItemMenu];
        }else if ([detailViewController isKindOfClass:[TempDataTableViewController_iPad class]]) {
            [(TempDataTableViewController_iPad*)detailViewController setPortraitMenu:rootViewController.barItemMenu];
        }else if ([detailViewController isKindOfClass:[SettingUserInfoViewController_iPad class]]) {
            [(SettingUserInfoViewController_iPad*)detailViewController setPortraitMenu:rootViewController.barItemMenu];
        }else if ([detailViewController isKindOfClass:[PrintSelectTypeViewController_iPad class]]) {
            [(PrintSelectTypeViewController_iPad*)detailViewController setPortraitMenu:rootViewController.barItemMenu];
        }else if ([detailViewController isKindOfClass:[SettingSelDeviceViewController_iPad class]]) {
            [(SettingSelDeviceViewController_iPad*)detailViewController setPortraitMenu:rootViewController.barItemMenu];
        }else if ([detailViewController isKindOfClass:[SettingMailServerInfoViewController_iPad class]]) {
            [(SettingMailServerInfoViewController_iPad*)detailViewController setPortraitMenu:rootViewController.barItemMenu];
        }
//        [detailViewController setPortraitMenu:rootViewController.barItemMenu];
    }
    
    self.masterPopoverController = popoverController;
}

// 縦から横になった時(iOS8以降は非推奨のデリゲートメソッド)
- (void)splitViewController:(UISplitViewController *)splitController
     willShowViewController:(UIViewController *)viewController
  invalidatingBarButtonItem:(UIBarButtonItem *)barButtonItem
{
    // iOS8.0未満の場合
    if(!isIOS8Later){
        [self dismissPopoverAnimated:NO];

        UIViewController* navController = (UIViewController*)[[self.splitViewController.viewControllers objectAtIndex:1] topViewController];
        [navController.navigationItem setLeftBarButtonItem:nil animated:YES];

        SharpScanPrintAppDelegate* pAppDelegate = (SharpScanPrintAppDelegate*)[[UIApplication sharedApplication] delegate];
        UINavigationController* pRootNavController = [pAppDelegate.splitViewController.viewControllers objectAtIndex:0];
        RootViewController_iPad* rootViewController = (RootViewController_iPad*)[pRootNavController.viewControllers objectAtIndex:0];
        rootViewController.barItemMenu = nil;

        self.masterPopoverController = nil;
    }
}

// 縦から横になった時(iOS8以降のデリゲートメソッド)
- (void)splitViewController:(nonnull UISplitViewController *)svc
    willChangeToDisplayMode:(UISplitViewControllerDisplayMode)displayMode
{
    if (displayMode == UISplitViewControllerDisplayModeAutomatic) {
        DLog(@"displayMode:%@",@"UISplitViewControllerDisplayModeAutomatic");
        
    // primary画面を隠し、secondary画面だけを表示する。(iPad縦向き)
    } else if (displayMode == UISplitViewControllerDisplayModePrimaryHidden) {
        DLog(@"displayMode:%@",@"UISplitViewControllerDisplayModePrimaryHidden");
        
    // primary画面とsecondary画面の両方を隠すことなく表示する(iPad横向き)
    } else if (displayMode == UISplitViewControllerDisplayModeAllVisible) {
        DLog(@"displayMode:%@",@"UISplitViewControllerDisplayModeAllVisible");
        
        // iOS8.0以降の場合
        if(isIOS8Later){
            [self dismissPopoverAnimated:NO];
            
            UIViewController* navController = (UIViewController*)[[self.splitViewController.viewControllers objectAtIndex:1] topViewController];
            [navController.navigationItem setLeftBarButtonItem:nil animated:YES];
            
            SharpScanPrintAppDelegate* pAppDelegate = (SharpScanPrintAppDelegate*)[[UIApplication sharedApplication] delegate];
            UINavigationController* pRootNavController = [pAppDelegate.splitViewController.viewControllers objectAtIndex:0];
            RootViewController_iPad* rootViewController = (RootViewController_iPad*)[pRootNavController.viewControllers objectAtIndex:0];
            rootViewController.barItemMenu = nil;
            
            self.masterPopoverController = nil;
        }
    
    // seconary画面に覆いかぶさる形でprimary画面が表示される
    } else if (displayMode == UISplitViewControllerDisplayModePrimaryOverlay) {
        DLog(@"displayMode:%@",@"UISplitViewControllerDisplayModePrimaryOverlay");
    }
}

- (void)setPortraitMenuButton
{
    UINavigationController* pRootNavController = [self.splitViewController.viewControllers objectAtIndex:0];
    RootViewController_iPad* rootViewController = (RootViewController_iPad*)[pRootNavController.viewControllers objectAtIndex:0];
    UINavigationController* pDetailNav = (UINavigationController*)[self.splitViewController.viewControllers objectAtIndex:1];
    UIViewController* detailViewController = (UIViewController*)[pDetailNav topViewController];
    
//    DLog(@"setPortraitMenuButton %@",[detailViewController class]);
    rootViewController.barItemMenu.title = S_BUTTON_MENU;
    // 右側のViewを初期起動時の状態に戻す
    if ([detailViewController isKindOfClass:[FileNameChangeViewController class]]) {
        [(FileNameChangeViewController*)detailViewController setPortraitMenu:rootViewController.barItemMenu];
    }else if ([detailViewController isKindOfClass:[ShowMailViewController class]]) {
        [(ShowMailViewController*)detailViewController setPortraitMenu:rootViewController.barItemMenu];
    }else if ([detailViewController isKindOfClass:[PictureViewController_iPad class]]) {
        [(PictureViewController_iPad*)detailViewController setPortraitMenu:rootViewController.barItemMenu];
    }else if ([detailViewController isKindOfClass:[CreateFolderViewController class]]) {
        [(CreateFolderViewController*)detailViewController setPortraitMenu:rootViewController.barItemMenu];
    }else if ([detailViewController isKindOfClass:[RSS_CustomSizeSettingViewController_iPad class]]) {
        [(RSS_CustomSizeSettingViewController_iPad*)detailViewController setPortraitMenu:rootViewController.barItemMenu];
    }else if ([detailViewController isKindOfClass:[ShowMailViewController_iPad class]]) {
        [(ShowMailViewController_iPad*)detailViewController setPortraitMenu:rootViewController.barItemMenu];
    }else if ([detailViewController isKindOfClass:[VersionInfoViewController_iPad class]]) {
        [(VersionInfoViewController_iPad*)detailViewController setPortraitMenu:rootViewController.barItemMenu];
    }else if ([detailViewController isKindOfClass:[SettingApplicationViewController_iPad class]]) {
        [(SettingApplicationViewController_iPad*)detailViewController setPortraitMenu:rootViewController.barItemMenu];
    }else if ([detailViewController isKindOfClass:[SettingSelInfoViewController_iPad class]]) {
        [(SettingSelInfoViewController_iPad*)detailViewController setPortraitMenu:rootViewController.barItemMenu];
    }else if ([detailViewController isKindOfClass:[SelectMailViewController_iPad class]]) {
        [(SelectMailViewController_iPad*)detailViewController setPortraitMenu:rootViewController.barItemMenu];
    }else if ([detailViewController isKindOfClass:[RSS_CustomSizeListViewController class]]) {
        [(RSS_CustomSizeListViewController*)detailViewController setPortraitMenu:rootViewController.barItemMenu];
    }else if ([detailViewController isKindOfClass:[AdvancedSearchResultViewController class]]) {
        [(AdvancedSearchResultViewController*)detailViewController setPortraitMenu:rootViewController.barItemMenu];
    }else if ([detailViewController isKindOfClass:[ArrengeSelectFileViewController_iPad class]]) {
        [(ArrengeSelectFileViewController_iPad*)detailViewController setPortraitMenu:rootViewController.barItemMenu];
    }else if ([detailViewController isKindOfClass:[SelectFileViewController_iPad class]]) {
        [(SelectFileViewController_iPad*)detailViewController setPortraitMenu:rootViewController.barItemMenu];
    }else if ([detailViewController isKindOfClass:[RSS_CustomSizeListViewController_iPad class]]) {
        [(RSS_CustomSizeListViewController_iPad*)detailViewController setPortraitMenu:rootViewController.barItemMenu];
    }else if ([detailViewController isKindOfClass:[TempDataTableViewController_iPad class]]) {
        [(TempDataTableViewController_iPad*)detailViewController setPortraitMenu:rootViewController.barItemMenu];
    }else if ([detailViewController isKindOfClass:[SettingUserInfoViewController_iPad class]]) {
        [(SettingUserInfoViewController_iPad*)detailViewController setPortraitMenu:rootViewController.barItemMenu];
    }else if ([detailViewController isKindOfClass:[PrintSelectTypeViewController_iPad class]]) {
        [(PrintSelectTypeViewController_iPad*)detailViewController setPortraitMenu:rootViewController.barItemMenu];
    }else if ([detailViewController isKindOfClass:[SettingSelDeviceViewController_iPad class]]) {
        [(SettingSelDeviceViewController_iPad*)detailViewController setPortraitMenu:rootViewController.barItemMenu];
    }else if ([detailViewController isKindOfClass:[SettingMailServerInfoViewController_iPad class]]) {
        [(SettingMailServerInfoViewController_iPad*)detailViewController setPortraitMenu:rootViewController.barItemMenu];
    }else {
        DLog(@"対象無し %@",detailViewController);
    }
//    [detailViewController setPortraitMenu:rootViewController.barItemMenu];
}

// メニューを非表示
-(void)dismissPopoverAnimated:(BOOL)animated
{
    if(masterPopoverController && masterPopoverController.isPopoverVisible){
        [masterPopoverController dismissPopoverAnimated:animated];
    }
}
-(void)showPopoverAnimated
{
    [self showPopoverAnimated:YES];
}
// メニューを表示
-(void)showPopoverAnimated:(BOOL)animated
{
    if(window.rootViewController.view.alpha != 1.0) {
        [self performSelector:@selector(showPopoverAnimated) withObject:nil afterDelay:1.0];
        return;
    }
    if(masterPopoverController && !masterPopoverController.isPopoverVisible){
//        UINavigationController* navi = [splitViewController.viewControllers objectAtIndex:1];
//        [masterPopoverController presentPopoverFromRect:(CGRect){0,0,1,1} inView:navi.topViewController.view permittedArrowDirections:UIPopoverArrowDirectionUp animated:animated];
        // メニューボタンを起点に表示する
        UINavigationController* pRootNavController = [self.splitViewController.viewControllers objectAtIndex:0];
        RootViewController_iPad* rootViewController = (RootViewController_iPad*)[pRootNavController.viewControllers objectAtIndex:0];
        [masterPopoverController presentPopoverFromBarButtonItem:rootViewController.barItemMenu permittedArrowDirections:UIPopoverArrowDirectionUp animated:animated];
    }
}

// アラート表示
- (ExAlertController*) makeTmpExAlert:(NSString*)pstrTitle
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
        // 親ViewControllerを検索
        UIViewController *baseVC = [UIApplication sharedApplication].keyWindow.rootViewController;
        while (baseVC.presentedViewController != nil && !baseVC.presentedViewController.isBeingDismissed) {
            baseVC = baseVC.presentedViewController;
        }
        // アラート表示処理
        [baseVC presentViewController:tmpAlert animated:YES completion:nil];
    }
    return tmpAlert;
}

@end

