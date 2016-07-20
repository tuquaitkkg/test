
#import "TempDataTableViewController.h"
#import "PrintPictViewController.h"
#import "RootViewController.h"
#import "SharpScanPrintAppDelegate.h"
#import "RenameScanAfterDataViewController.h"
#import <MessageUI/MessageUI.h> // メールの設定確認

@implementation TempDataTableViewController

//
// アクセサメソッドの自動合成(ゲッターとセッターの役割)
//
@synthesize baseDir;							// ホームディレクトリ/Documments/
@synthesize isScan = m_bScanView;							// 画面遷移もとフラグ

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
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
    
    self.baseDir = [CommonUtil tmpDir];
    
    
    if(self.isScan)
    {
        self.navigationItem.title = S_TITLE_SCAN;
    }
    else
    {
        self.navigationItem.title = S_TITLE_PRINT;
    }
    //
	// ScanDataManager クラス生成
	//
    tempManager     = [[TempDataManager alloc]init];
	//tempManager		= [TempDataManager sharedTempDataManager];
    
	self.tableView.scrollEnabled = YES;
    
    //
	// [キャンセル]ボタンの追加（Navigation Item）
	//
	self.navigationItem.leftBarButtonItem	= [[UIBarButtonItem alloc]
                                               initWithTitle:S_BUTTON_CANCEL
                                               style:UIBarButtonItemStylePlain
                                               target:self
                                               action:@selector(doCancel:)];
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
        
    }
    
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
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    // ToolBar再表示(モーダル表示でViewWillDisappearが呼ばれ非表示になることがある為。)
    [self.navigationController setToolbarHidden:NO animated:YES];
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
    
    // 別Viewに遷移するときにToolBarを非表示(ただしmodalでViewを表示する場合にも通ってしまうことがある。→viewWillAppearで再表示)
    [self.navigationController setToolbarHidden:YES animated:NO];

}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
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
        
        UIAlertController *tempAlert = [UIAlertController alertControllerWithTitle:nil
                                                                           message:MSG_DEL_CONFIRM
                                                                    preferredStyle:UIAlertControllerStyleAlert];
        
        // Cancel用のアクションを生成
        UIAlertAction *cancelAction =
        [UIAlertAction actionWithTitle:MSG_BUTTON_CANCEL
                                 style:UIAlertActionStyleCancel
                               handler:^(UIAlertAction * action) {
                                   
                                   // ボタンタップ時の処理
                                   [self alertButtonPushed:tempAlert tagIndex:2 buttonIndex:0];
                               }];
        
        // OK用のアクションを生成
        UIAlertAction *okAction =
        [UIAlertAction actionWithTitle:MSG_BUTTON_OK
                                 style:UIAlertActionStyleDefault
                               handler:^(UIAlertAction * action) {
                                   
                                   // ボタンタップ時の処理
                                   [self alertButtonPushed:tempAlert tagIndex:2 buttonIndex:1];
                               }];
        
        // コントローラにアクションを追加
        [tempAlert addAction:cancelAction];
        [tempAlert addAction:okAction];
        // アラート表示処理
        [self presentViewController:tempAlert animated:YES completion:nil];
    }
    else
    {
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
                SharpScanPrintAppDelegate* appDelegate = (SharpScanPrintAppDelegate*)[[UIApplication sharedApplication] delegate];
                // 処理実行フラグON
                appDelegate.IsRun = TRUE;
                
                //
                // 削除に失敗した場合
                //
                UIAlertController *tempAlert = [UIAlertController alertControllerWithTitle:nil
                                                                                   message:MSG_SETTING_DEL_ERR
                                                                            preferredStyle:UIAlertControllerStyleAlert];
                
                // OK用のアクションを生成
                UIAlertAction *okAction =
                [UIAlertAction actionWithTitle:MSG_BUTTON_OK
                                         style:UIAlertActionStyleDefault
                                       handler:^(UIAlertAction * action) {
                                           
                                           // ボタンタップ時の処理
                                           [self alertButtonPushed:tempAlert tagIndex:0 buttonIndex:0];
                                       }];
                
                // コントローラにアクションを追加
                [tempAlert addAction:okAction];
                // アラート表示処理
                [self presentViewController:tempAlert animated:YES completion:nil];
                return;
                
            }
            
            [self.navigationController popToRootViewControllerAnimated:YES];
        }
        
    }
    
}

// モーダル表示した画面を閉じ、TOPに戻る
- (void)OnClose
{
    [self dismissViewControllerAnimated:YES completion:nil];
    [self.navigationController popToRootViewControllerAnimated:YES];
}

// モーダル表示した画面を閉じる
- (void)OnCancel
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - Table view delegate



- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self MoveView:indexPath];
}
-(void)tableView:(UITableView *)tableView accessoryButtonTappedForRowWithIndexPath:(NSIndexPath *)indexPath
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
        ScanAfterPreViewController *scanAfterPreViewController = [[ScanAfterPreViewController alloc] initWithNibName:@"ScanAfterPreViewController" bundle:nil];
        
        //
        // 呼び出し画面のプロパティ設定
        //
        TempFile *localTempFile = [[TempFile alloc]initWithFileName:aTempData.fname];
        scanAfterPreViewController.tempFile = localTempFile;
        scanAfterPreViewController.SelFilePath = localTempFile.tempFilePath;
        
        //
        // DetailViewコントローラを navigationコントローラのスタックに追加
        // 画面上部に親画面へ戻るボタンを表示してくれる
        //
        [self.navigationController pushViewController:scanAfterPreViewController animated:YES];
        
        //
        // scanAfterPreViewControllerのインスタンス解放
        //
    }
    else
    {
        //
        // PrintPictViewControllerのインスタンス作成
        //
        PrintPictViewController *printPictViewController = [[PrintPictViewController alloc] initWithNibName:@"PrintPictViewController" bundle:nil];
        
        //
        // 呼び出し画面のプロパティ設定
        //
        TempFile *localTempFile = [[TempFile alloc]initWithFileName:aTempData.fname];
        printPictViewController.SelFilePath = localTempFile.tempFilePath;
        
        //
        // DetailViewコントローラを navigationコントローラのスタックに追加
        // 画面上部に親画面へ戻るボタンを表示してくれる
        //
        [self.navigationController pushViewController:printPictViewController animated:YES];
        
        //
        // printPictViewControllerのインスタンス解放
        //
        
    }
}

//ダイアログのボタン押下時
-(void)alertButtonPushed:(UIAlertController *)alertController tagIndex:(NSInteger)tagIndex buttonIndex:(NSInteger)buttonIndex{
    SharpScanPrintAppDelegate* appDelegate = (SharpScanPrintAppDelegate*)[[UIApplication sharedApplication] delegate];
    // 処理実行フラグOFF
    appDelegate.IsRun = FALSE;
    
    if(tagIndex == 1)
    {
        [self.navigationController popToRootViewControllerAnimated:YES];
    } else if(tagIndex == 2)
    {
        if(buttonIndex != 0)
        {
            
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
                    SharpScanPrintAppDelegate* appDelegate = (SharpScanPrintAppDelegate*)[[UIApplication sharedApplication] delegate];
                    // 処理実行フラグON
                    appDelegate.IsRun = TRUE;
                    
                    //
                    // 削除に失敗した場合
                    //
                    UIAlertController *tempAlert = [UIAlertController alertControllerWithTitle:nil
                                                                                       message:MSG_SETTING_DEL_ERR
                                                                                preferredStyle:UIAlertControllerStyleAlert];
                    
                    // OK用のアクションを生成
                    UIAlertAction *okAction =
                    [UIAlertAction actionWithTitle:MSG_BUTTON_OK
                                             style:UIAlertActionStyleDefault
                                           handler:^(UIAlertAction * action) {
                                               
                                               // ボタンタップ時の処理
                                               [self alertButtonPushed:tempAlert tagIndex:0 buttonIndex:0];
                                           }];
                    
                    // コントローラにアクションを追加
                    [tempAlert addAction:okAction];
                    // アラート表示処理
                    [self presentViewController:tempAlert animated:YES completion:nil];
                    return;
                    
                }
            }
            
            
            
            if (self.isScan)
            {
                @autoreleasepool
                {
                    //画面遷移
                    ScanBeforePictViewController* scanpViewController;
                    scanpViewController = [[ScanBeforePictViewController alloc] init];
                    DLog(@"%@",scanpViewController);
                    
                    //
                    // 呼び出し画面のプロパティ設定
                    //
                    [self.navigationController popViewControllerAnimated:YES];
                }
            }
            else
            {
                [self.navigationController popToRootViewControllerAnimated:YES];
            }
        }
    }
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
    
    UIActivityViewController *activityViewController = [[UIActivityViewController alloc] initWithActivityItems:filePathArray applicationActivities:nil];
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
                    [self setAlert:MSG_MAIL_START_ERR];
                }
            }
        }
    };
    
    [self presentViewController:activityViewController animated:YES completion:nil];
    
}

// アラート表示
-(void) setAlert:(NSString *) aDescription {
    SharpScanPrintAppDelegate* appDelegate = (SharpScanPrintAppDelegate*)[[UIApplication sharedApplication] delegate];
    // 処理実行フラグON
    appDelegate.IsRun = TRUE;
    
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil
                                                                             message:aDescription
                                                                      preferredStyle:UIAlertControllerStyleAlert];
    
    // OK用のアクションを生成
    UIAlertAction * okAction =
    [UIAlertAction actionWithTitle:MSG_BUTTON_OK
                             style:UIAlertActionStyleDefault
                           handler:^(UIAlertAction * action) {
                               
                               // ボタンタップ時の処理
                               [self alertButtonPushed:alertController tagIndex:0 buttonIndex:0];
                           }];
    
    // コントローラにアクションを追加
    [alertController addAction:okAction];
    // アラート表示処理
    [self presentViewController:alertController animated:YES completion:nil];
}

@end
