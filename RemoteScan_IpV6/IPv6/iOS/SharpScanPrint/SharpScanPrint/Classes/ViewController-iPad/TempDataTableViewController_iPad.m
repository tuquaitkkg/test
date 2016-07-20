
#import "TempDataTableViewController_iPad.h"
#import "PrintPictViewController_iPad.h"
#import "RootViewController_iPad.h"
#import "RenameScanAfterDataViewController.h"
#import <MessageUI/MessageUI.h> // メールの設定確認
// iPad用
#import "SharpScanPrintAppDelegate.h"
// iPad用
#import "PictureViewController_iPad.h"
#import "FileNameChangeViewController.h"
#import "ShowMailViewController.h"
#import "CreateFolderViewController.h"
#import "ShowMailViewController_iPad.h"
#import "SelectMailViewController.h"
#import "ArrengeSelectFileViewController_iPad.h"
#import "SelectFileViewController_iPad.h"
#import "SettingMailServerInfoViewController_iPad.h"
#import "SelectMailViewController_iPad.h"
#import "SettingSelInfoViewController_iPad.h"
#import "SettingApplicationViewController_iPad.h"
#import "SettingUserInfoViewController_iPad.h"
#import "AdvancedSearchResultViewController.h"

@implementation TempDataTableViewController_iPad

//
// アクセサメソッドの自動合成(ゲッターとセッターの役割)
//
@synthesize baseDir;							// ホームディレクトリ/Documments/
@synthesize isScan = m_bScanView;							// 画面遷移もとフラグ
@synthesize bSetTitle; // iPad用
@synthesize selectIndexPath; // iPad用
@synthesize lastScrollOffSet; // iPad用
@synthesize prevViewController;

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)dealloc
{
    // iPad用
    if (nil != tempManager)
    {
        tempManager = nil;
    }
    // iPad用
    
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
    
//    // 戻るボタンは非表示
//    [self.navigationItem setHidesBackButton:YES];
    
    self.baseDir = [CommonUtil tmpDir];
    
    // iPad用
    if(self.bSetTitle)
    {
        if(self.isScan)
        {
            self.navigationItem.title = S_TITLE_SCAN;
        }
        else
        {
            self.navigationItem.title = S_TITLE_PRINT;
        }
    }
    // iPad用
    
    //
	// ScanDataManager クラス生成
	//
    tempManager     = [[TempDataManager alloc]init];
	//tempManager		= [TempDataManager sharedTempDataManager];
    
	self.tableView.scrollEnabled = YES;
    
//    // 戻るボタンを明示的に消す
//    [self.navigationItem setHidesBackButton:YES];

    //
	// [キャンセル]ボタンの追加（Navigation Item）
	//
	self.navigationItem.leftBarButtonItem	= [[UIBarButtonItem alloc]
                                               initWithTitle:S_BUTTON_CANCEL
                                               style:UIBarButtonItemStylePlain
                                               target:self
                                               action:@selector(doCancel:)];

    // 戻るボタンを明示的に消す(leftBarButtonItemよりも後ろで実行する)
    [self.navigationItem setHidesBackButton:YES];

    if(self.isScan)
    {
        
        //
        // [保存]ボタンの追加（Navigation Item）
        //
        self.navigationItem.rightBarButtonItem	= [[UIBarButtonItem alloc]
                                                   initWithTitle:S_BUTTON_SAVEVAL
                                                   style:UIBarButtonItemStyleDone
                                                   target:self
                                                   action:@selector(dosave:)];
        
        // 共有ボタン追加
        [self initShareToolBar];
        
        //回転時にrotateActionが呼ばれるようにする
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didChangedOrientation:)
                                                     name:UIDeviceOrientationDidChangeNotification object:nil];
        
    }
    
    self.previousOrientation = [[UIDevice currentDevice] orientation];
    
    //
	// 再描画
	//
	[self.tableView reloadData];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
    // iPad用
    if (nil != baseDir)
    {
        baseDir = nil;
    }
    if (nil != tempManager)
    {
        tempManager = nil;
    }
    // iPad用
    
    // 回転の通知を削除
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIDeviceOrientationDidChangeNotification object:nil];
}

- (void)viewWillAppear:(BOOL)animated
{
    [self.tableView reloadData];
    
    [super viewWillAppear:animated];
    
    // ToolBar再表示(左ペインに表示時に端末を縦向きにしたときにviewWillDisappearで一旦非表示になる為)
    [self.navigationController setToolbarHidden:NO animated:NO];
    
    // 選択状態解除
    [self.tableView deselectRowAtIndexPath:[self.tableView indexPathForSelectedRow] animated:YES];
    
    if (selectIndexPath != nil)
    {
        // 指定の行を選択状態
        [self.tableView selectRowAtIndexPath:selectIndexPath animated:NO scrollPosition:UITableViewScrollPositionNone];
        // 指定の位置までスクロール
        [self.tableView scrollToRowAtIndexPath:selectIndexPath atScrollPosition:UITableViewScrollPositionTop animated:NO];
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

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    // 別Viewに遷移するときにToolBarを非表示(ただし左ペインに表示時に端末を縦にしたときにも非表示となってしまう。→viewWillAppearで再表示)
    [self.navigationController setToolbarHidden:YES animated:NO];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    // iPad用
    //return (interfaceOrientation == UIInterfaceOrientationPortrait);
    // 横向きの場合
    if(interfaceOrientation == UIInterfaceOrientationLandscapeLeft || interfaceOrientation == UIInterfaceOrientationLandscapeRight)
    {
        // 縦向き表示時のメニューPopOverが表示されていたら閉じる
        [self dismissMenuPopOver:NO];
        
    }
    return YES;
    // iPad用
}

- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration
{
    // モーダルが開いていたらアニメーションなしで閉じる
    [self dismissViewControllerAnimated:NO completion:nil];
}

- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation
{
	// [キャンセル]ボタンの追加（Navigation Item）
	self.navigationItem.leftBarButtonItem	= [[UIBarButtonItem alloc]
                                               initWithTitle:S_BUTTON_CANCEL
                                               style:UIBarButtonItemStylePlain
                                               target:self
                                               action:@selector(doCancel:)];
    
    // 戻るボタンを明示的に消す(leftBarButtonItemよりも後ろで実行する)
    [self.navigationItem setHidesBackButton:YES];
}

- (void)didChangedOrientation:(NSNotification *)notification
{
    UIDeviceOrientation orientation = [(UIDevice*)[notification object] orientation];
    
    if(orientation != self.previousOrientation
    &&(self.previousOrientation != UIDeviceOrientationUnknown
        || self.previousOrientation != UIDeviceOrientationFaceUp
        || self.previousOrientation != UIDeviceOrientationFaceDown)){
           
        if (activityViewController) {   // 表示されてなくても通るが動作には影響しない
            [activityViewController dismissViewControllerAnimated:YES completion:nil];
        }
    }
    
    self.previousOrientation = orientation;
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [tempManager countOfTempData];
}
//
// 各行の高さを指定
//
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return N_HEIGHT_SEL_FILE;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"TempDataCell";
    
	//
	// 指定されたセルを返却
	//
    TempDataCell *cell = (TempDataCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil)
	{
        cell = [[TempDataCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
	//
	// データを取得
	//
	TempData *aTempData = nil;
    aTempData	= [tempManager loadTempDataAtIndexPath:indexPath];
    
	//
	// セルの設定(各セルにアクセサリーを設定)
	//
    [cell setModel:aTempData hasDisclosure:TRUE];
    
    return cell;
}

//
// 保存ボタン処理
//
-(IBAction)dosave:(id)sender
{
    // 縦向き表示時のメニューPopOverが表示されていたら閉じる
    [self dismissMenuPopOver:YES];
    
    // ファイル名でソート
    NSMutableArray* tempDataList = [NSMutableArray arrayWithArray:tempManager.atempDataList];
    [tempDataList sortUsingComparator:^NSComparisonResult(TempData* obj1, TempData* obj2) {
        return [obj1.fname compare:obj2.fname];
    }];
    
    // 先頭ファイル情報取得
    TempData* aTempData	= [tempDataList objectAtIndex:0];
    if(aTempData){
        // 画面遷移
        RenameScanAfterDataViewController* controller;
        controller = [[RenameScanAfterDataViewController alloc] initWithNibName:@"FileNameChangeViewController" bundle:nil];
        controller.delegate = self;
        // 送り元
        controller.isMulti = YES;
        
        controller.SelFileName = [aTempData.fname lastPathComponent];
        controller.isDirectory = NO;
        TempFile *localTempFile = [[TempFile alloc]initWithFileName:aTempData.fname];
        controller.tempFile =localTempFile;
        
        // モーダル表示
        UINavigationController *navigationController = [[UINavigationController alloc]initWithRootViewController:controller];
        navigationController.navigationBar.barStyle = NAVIGATION_BARSTYLE;
        [navigationController setModalPresentationStyle:UIModalPresentationPageSheet];
        [self presentViewController:navigationController animated:YES completion:nil];
        
    }
}

//
// キャンセルボタン処理
//
-(IBAction)doCancel:(id)sender
{
    if(self.isScan)
    {
        // 取り込み後画面の場合はダイアログ表示
        SharpScanPrintAppDelegate* appDelegate = (SharpScanPrintAppDelegate*)[[UIApplication sharedApplication] delegate];
        // 処理実行フラグON
        appDelegate.IsRun = TRUE;
        
        [self makeTmpExAlert:nil message:MSG_DEL_CONFIRM cancelBtnTitle:MSG_BUTTON_CANCEL okBtnTitle:MSG_BUTTON_OK tag:2 showFlg:YES];
    }
    else
    {
        // iPad用
        //SharpScanPrintAppDelegate* appDelegate = (SharpScanPrintAppDelegate*)[[UIApplication sharedApplication] delegate];
        SharpScanPrintAppDelegate* appDelegate = (SharpScanPrintAppDelegate*)[[UIApplication sharedApplication] delegate];
        // iPad用
        // 処理実行フラグON
        appDelegate.IsRun = TRUE;
        
        //削除処理
        @autoreleasepool
        {
            NSFileManager	*fileManager	= [NSFileManager defaultManager];
            BOOL			ret;
            
            ret		= [fileManager removeItemAtPath:[CommonUtil tmpDir] error:NULL];	// ディレクトリ削除
            if (ret == NO)
            {
                //
                // 削除に失敗した場合
                //
                [self makeTmpExAlert:nil message:MSG_SETTING_DEL_ERR cancelBtnTitle:nil okBtnTitle:MSG_BUTTON_OK tag:0 showFlg:YES];
                return;
                
            }
        }
        
        // iPad用
        //[self.navigationController popToRootViewControllerAnimated:YES];
        SharpScanPrintAppDelegate* pAppDelegate = (SharpScanPrintAppDelegate*)[[UIApplication sharedApplication] delegate];
        
        // 左側のViewを取得
        UINavigationController* pRootNavController = [pAppDelegate.splitViewController.viewControllers objectAtIndex:0];
        RootViewController_iPad* rootViewController = (RootViewController_iPad*)[pRootNavController.viewControllers objectAtIndex:0];
        // 左側のViewを遷移前の状態に戻す
        [rootViewController popRootView];
        
        // 右側のViewを取得
        UINavigationController* pDetailNavController = [pAppDelegate.splitViewController.viewControllers objectAtIndex:1];
        UIViewController* rightViewController = (UIViewController*)[pDetailNavController.viewControllers objectAtIndex:0];
        // 右側のViewを初期起動時の状態に戻す
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
        }else if ([rightViewController isKindOfClass:[SelectMailViewController class]]) {
            [(SelectMailViewController*)rightViewController popRootView];
        }else if ([rightViewController isKindOfClass:[ArrengeSelectFileViewController_iPad class]]) {
            [(ArrengeSelectFileViewController_iPad*)rightViewController popRootView];
        }else if ([rightViewController isKindOfClass:[SelectFileViewController_iPad class]]) {
            [(SelectFileViewController_iPad*)rightViewController popRootView];
        }else if ([rightViewController isKindOfClass:[SettingMailServerInfoViewController_iPad class]]) {
            [(SettingMailServerInfoViewController_iPad*)rightViewController popRootView];
        }else if ([rightViewController isKindOfClass:[SelectMailViewController_iPad class]]) {
            [(SelectMailViewController_iPad*)rightViewController popRootView];
        }else if ([rightViewController isKindOfClass:[SettingSelInfoViewController_iPad class]]) {
            [(SettingSelInfoViewController_iPad*)rightViewController popRootView];
        }else if ([rightViewController isKindOfClass:[SettingApplicationViewController_iPad class]]) {
            [(SettingApplicationViewController_iPad*)rightViewController popRootView];
        }else if ([rightViewController isKindOfClass:[TempDataTableViewController_iPad class]]) {
            [(TempDataTableViewController_iPad*)rightViewController popRootView];
        }else if ([rightViewController isKindOfClass:[SettingUserInfoViewController_iPad class]]) {
            [(SettingUserInfoViewController_iPad*)rightViewController popRootView];
        }else if ([rightViewController isKindOfClass:[AdvancedSearchResultViewController class]]) {
            [(AdvancedSearchResultViewController*)rightViewController popRootView];
        }
        //        [rightViewController popRootView];
        // iPad用
        
    }
    
    
    
}

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
// 画面遷移
- (void)MoveView:(NSIndexPath *)nIndexPath
{
    // 戻るボタンの名称変更
    UIBarButtonItem * barItemBack = [UIBarButtonItem new];
    barItemBack.title = S_BUTTON_BACK;
    self.navigationItem.backBarButtonItem = barItemBack;
    
    TempData *aTempData = nil;
    aTempData	= [tempManager loadTempDataAtIndexPath:nIndexPath];
    
    if(self.isScan)
    {
        //
        // 選択行の読み込み
        //
	    
        //
        // ScanAfterPreViewControllerのインスタンス作成
        //
        ScanAfterPreViewController_iPad *scanAfterPreViewController = [[ScanAfterPreViewController_iPad alloc] initWithNibName:@"ScanAfterPreViewController_iPad" bundle:nil];
        
        //
        // 呼び出し画面のプロパティ設定
        //
        TempFile *localTempFile = [[TempFile alloc]initWithFileName:aTempData.fname];
        scanAfterPreViewController.tempFile = localTempFile;
        scanAfterPreViewController.SelFilePath = localTempFile.tempFilePath;
        
        // iPad用
        ////
        //// DetailViewコントローラを navigationコントローラのスタックに追加
        //// 画面上部に親画面へ戻るボタンを表示してくれる
        ////
        //[self.navigationController pushViewController:scanAfterPreViewController animated:YES];
        [self ChangeDetailView:scanAfterPreViewController didSelectRowAtIndexPath:nIndexPath];
        // iPad用
        
        //
        // scanAfterPreViewControllerのインスタンス解放
        //
    }
    else
    {
        //
        // ScanAfterPreViewControllerのインスタンス作成
        //
        PrintPictViewController_iPad *printPictViewController = [[PrintPictViewController_iPad alloc] initWithNibName:@"PrintPictViewController_iPad" bundle:nil];
        
        //
        // 呼び出し画面のプロパティ設定
        //
        TempFile *localTempFile = [[TempFile alloc]initWithFileName:aTempData.fname];
        printPictViewController.SelFilePath = localTempFile.tempFilePath;
        
        // iPad用
        ////
        //// DetailViewコントローラを navigationコントローラのスタックに追加
        //// 画面上部に親画面へ戻るボタンを表示してくれる
        ////
        //[self.navigationController pushViewController:printPictViewController animated:YES];
        [self ChangeDetailView:printPictViewController didSelectRowAtIndexPath:nIndexPath];
        // iPad用
        
        //
        // printPictViewControllerのインスタンス解放
        //
        
    }
    // 縦向き表示時のメニューPopOverが表示されていたら閉じる
    [self dismissMenuPopOver:YES];
}

// アラートボタン押下処理
-(void)alertButtonPushed:(UIAlertController *)alertController tagIndex:(NSInteger)tagIndex buttonIndex:(NSInteger)buttonIndex
{
    [self alertButtonClicked:alertController tagIndex:tagIndex buttonIndex:buttonIndex];
    [self alertButtonDismiss:alertController tagIndex:tagIndex buttonIndex:buttonIndex];
}

-(void)alertButtonClicked:(UIAlertController *)alertController tagIndex:(NSInteger)tagIndex buttonIndex:(NSInteger)buttonIndex
{
    // iPad用
    SharpScanPrintAppDelegate* appDelegate = (SharpScanPrintAppDelegate*)[[UIApplication sharedApplication] delegate];
    // 処理実行フラグOFF
    appDelegate.IsRun = FALSE;
    
    if(tagIndex == 1)
    {
        [self.navigationController popToRootViewControllerAnimated:YES];
        
        // iPad用
        SharpScanPrintAppDelegate* pAppDelegate = (SharpScanPrintAppDelegate*)[[UIApplication sharedApplication] delegate];
        
        // 左側のViewを取得
        UINavigationController* pRootNavController = [pAppDelegate.splitViewController.viewControllers objectAtIndex:0];
        RootViewController_iPad* rootViewController = (RootViewController_iPad*)[pRootNavController.viewControllers objectAtIndex:0];
        // 左側のViewを遷移前の状態に戻す
        [rootViewController popRootView];
        // iPad用
    } else if (tagIndex == 2)
    {
        if(buttonIndex != 0)
        {
            
            // iPad用
            SharpScanPrintAppDelegate* appDelegate = (SharpScanPrintAppDelegate*)[[UIApplication sharedApplication] delegate];
            // 処理実行フラグON
            appDelegate.IsRun = TRUE;
            
            //削除処理
            @autoreleasepool
            {
                NSFileManager	*fileManager	= [NSFileManager defaultManager];
                BOOL			ret;
                
                ret		= [fileManager removeItemAtPath:[CommonUtil tmpDir] error:NULL];	// ディレクトリ削除
                if (ret == NO)
                {
                    //
                    // 削除に失敗した場合
                    //
                    [self makeTmpExAlert:nil message:MSG_SETTING_DEL_ERR cancelBtnTitle:nil okBtnTitle:MSG_BUTTON_OK tag:0 showFlg:YES];
                    return;
                    
                }
            }
            
            
            
            if (self.isScan)
            {
                //
                // 呼び出し画面のプロパティ設定
                //
                [(ScanBeforePictViewController_iPad *)(self.prevViewController) setPrevScanner];
                [self.navigationController popViewControllerAnimated:YES];
                
            }
            else
            {
                // iPad用
                //[self.navigationController popToRootViewControllerAnimated:YES];
                SharpScanPrintAppDelegate* pAppDelegate = (SharpScanPrintAppDelegate*)[[UIApplication sharedApplication] delegate];
                
                // 左側のViewを取得
                UINavigationController* pRootNavController = [pAppDelegate.splitViewController.viewControllers objectAtIndex:0];
                RootViewController_iPad* rootViewController = (RootViewController_iPad*)[pRootNavController.viewControllers objectAtIndex:0];
                // 左側のViewを遷移前の状態に戻す
                [rootViewController popRootView];
                
                // 右側のViewを取得
                UINavigationController* pDetailNavController = [pAppDelegate.splitViewController.viewControllers objectAtIndex:1];
                UIViewController* rightViewController = (UIViewController*)[pDetailNavController.viewControllers objectAtIndex:0];
                // 右側のViewを初期起動時の状態に戻す
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
                }else if ([rightViewController isKindOfClass:[SelectMailViewController class]]) {
                    [(SelectMailViewController*)rightViewController popRootView];
                }else if ([rightViewController isKindOfClass:[ArrengeSelectFileViewController_iPad class]]) {
                    [(ArrengeSelectFileViewController_iPad*)rightViewController popRootView];
                }else if ([rightViewController isKindOfClass:[SelectFileViewController_iPad class]]) {
                    [(SelectFileViewController_iPad*)rightViewController popRootView];
                }else if ([rightViewController isKindOfClass:[SettingMailServerInfoViewController_iPad class]]) {
                    [(SettingMailServerInfoViewController_iPad*)rightViewController popRootView];
                }else if ([rightViewController isKindOfClass:[SelectMailViewController_iPad class]]) {
                    [(SelectMailViewController_iPad*)rightViewController popRootView];
                }else if ([rightViewController isKindOfClass:[SettingSelInfoViewController_iPad class]]) {
                    [(SettingSelInfoViewController_iPad*)rightViewController popRootView];
                }else if ([rightViewController isKindOfClass:[SettingApplicationViewController_iPad class]]) {
                    [(SettingApplicationViewController_iPad*)rightViewController popRootView];
                }else if ([rightViewController isKindOfClass:[TempDataTableViewController_iPad class]]) {
                    [(TempDataTableViewController_iPad*)rightViewController popRootView];
                }else if ([rightViewController isKindOfClass:[SettingUserInfoViewController_iPad class]]) {
                    [(SettingUserInfoViewController_iPad*)rightViewController popRootView];
                }else if ([rightViewController isKindOfClass:[AdvancedSearchResultViewController class]]) {
                    [(AdvancedSearchResultViewController*)rightViewController popRootView];
                }
                // iPad用
            }
        }
    }
}

-(void)alertButtonDismiss:(UIAlertController *)alertController tagIndex:(NSInteger)tagIndex buttonIndex:(NSInteger)buttonIndex
{
}

// iPad用
// 詳細画面切換え
-(void)ChangeDetailView:(UIViewController*)pViewController didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    SharpScanPrintAppDelegate* pAppDelegate = (SharpScanPrintAppDelegate*)[[UIApplication sharedApplication] delegate];
    
    if (pAppDelegate.IsPreview)
    {
        // 指定の行を選択状態
        [self.tableView selectRowAtIndexPath:selectIndexPath animated:NO scrollPosition:UITableViewScrollPositionNone];
        
        return;
    }
    
    // 選択行保持
    NSUInteger newIndex[] = {indexPath.section, indexPath.row};
    selectIndexPath = [[NSIndexPath alloc] initWithIndexes:newIndex length:2];
    
    UINavigationController* pRootNavController = [pAppDelegate.splitViewController.viewControllers objectAtIndex:0];
    // 左側のViewに設定されているクラスの名前を取得
    NSString* leftViewClassName = [pRootNavController.topViewController description];
    // 左側のViewにトップメニューが表示されている場合
    if(![leftViewClassName isEqual:[self description]])
    {
        // 左側のViewを更新してファイル一覧を表示
        RootViewController_iPad* pRootViewController = (RootViewController_iPad*)pRootNavController.topViewController;
        [pRootViewController updateView:ScanTempDataView didSelectRowAtIndexPath:indexPath scrollOffset:[self.tableView contentOffset]];
        selectIndexPath = nil;
        // 右側のViewを更新して画像プレビューを表示
        [self.navigationController pushViewController:pViewController animated:YES];
    }
    else
    {
        // 詳細画面のナビゲーション初期化
        UINavigationController* pDetailNavController = nil;
        
        ScanBeforePictViewController_iPad* pScanViewController = [[ScanBeforePictViewController_iPad alloc] init];
        // 新規詳細画面追加
        pDetailNavController = [[UINavigationController alloc]initWithRootViewController: pScanViewController];
        pDetailNavController.navigationBar.barStyle = NAVIGATION_BARSTYLE;
        pDetailNavController.delegate = pScanViewController;
        
        NSArray *viewControllers = [[NSArray alloc] initWithObjects:self.navigationController, pDetailNavController, nil];
        pAppDelegate.splitViewController.viewControllers = viewControllers;
        
        [pScanViewController updateView:pViewController animated:NO];
    }
}

- (void)popRootView
{
    [self.navigationController popToRootViewControllerAnimated:YES];
}

// 縦表示時のメニューボタン設定
- (void)setPortraitMenu:(UIBarButtonItem *)barButtonItem
{
    // キャンセルボタンが表示されているため処理は行わない
    
    //	// [キャンセル]ボタンの追加（Navigation Item）
    //	self.navigationItem.leftBarButtonItem	= [[[UIBarButtonItem alloc]
    //												initWithTitle:S_BUTTON_CANCEL
    //												style:UIBarButtonItemStylePlain
    //												target:self
    //												action:@selector(doCancel:)] autorelease];
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

#pragma mark FileNameChangeViewControllerDelegate
-(void)nameChange:(UIViewController*)viewController didNameChangeSuccess:(BOOL)bSuccess
{
    FileNameChangeViewController* nameChangeView = (FileNameChangeViewController*)viewController;
    
    // モーダルを閉じる
    [nameChangeView dismissViewControllerAnimated:YES completion:nil];
    
    // デリゲートをクリア
    nameChangeView.delegate = nil;
}

#pragma mark - ShareMultiFileToOtherApp

/**
 @brief 編集ボタン/共有ボタンToolBar生成
 */
- (void)initShareToolBar {
    
    // Toolbar
    self.navigationController.toolbar.barStyle = TOOLBAR_BARSTYLE;
    
    // スペーサを生成
    UIBarButtonItem *spacer = [[UIBarButtonItem alloc]
                               initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace
                               target:nil action:nil];
    
    // 共有ボタンの生成
    shareBtn =  [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAction
                                                              target:self
                                                              action:@selector(shareAction:)];
    
    shareBtn.enabled = YES;
    
    self.toolbarItems = @[spacer, shareBtn, spacer];
    
    [self.navigationController setToolbarHidden:NO];
    
}

// 共有ボタン押下時
- (void)shareAction:(id)sender {
    
    NSMutableArray *filePathArray = [[NSMutableArray alloc] init];
    
    for (NSInteger index = 0; index < tempManager.atempDataList.count; index++) {
        
        // 選択ファイルの情報を取得
        
        //NSString *filePath = @"";
        TempData* aTempData	= [tempManager.atempDataList objectAtIndex:index];
        TempFile *localTempFile = [[TempFile alloc]initWithFileName:aTempData.fname];
        NSURL *url = [NSURL fileURLWithPath:localTempFile.tempFilePath];
        
        [filePathArray addObject:url];
    }
    
    __block TempDataTableViewController_iPad *block_self = self;
    activityViewController = [[UIActivityViewController alloc] initWithActivityItems:filePathArray applicationActivities:nil];
    activityViewController.completionWithItemsHandler = ^(NSString *activityType, BOOL completed, NSArray *returnedItems, NSError *activityError)
    {
        /*
         // メールアプリ選択時のメール未設定アラート
         */
        NSLog(@"%@", activityType);
        if (activityError) {
            NSLog(@"activityError：%@", activityError);
        }
        else if (!completed) {
            NSLog(@"Activity is not Completed.");
            
            if (activityType == UIActivityTypeMail) {
                Class mail = (NSClassFromString(@"MFMailComposeViewController"));
                // メールの設定がされているかどうかチェック
                if (![mail canSendMail]) {
                    NSLog(@"Mail Activity Error：Mail Account is not Set.");
                    [block_self setAlert:MSG_MAIL_START_ERR];
                }
            }
        }
    };
    
    // iPadの場合は以下１文が必要（popoverの表示位置指定）
    activityViewController.popoverPresentationController.barButtonItem = shareBtn;
    
    [self presentViewController:activityViewController animated:YES completion:nil];
    
}

// アラート表示
-(void) setAlert:(NSString *) aDescription {
    SharpScanPrintAppDelegate* appDelegate = (SharpScanPrintAppDelegate*)[[UIApplication sharedApplication] delegate];
    // 処理実行フラグON
    appDelegate.IsRun = TRUE;
    
    [self makeTmpExAlert:nil message:aDescription cancelBtnTitle:nil okBtnTitle:MSG_BUTTON_OK tag:0 showFlg:YES];
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
