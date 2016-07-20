
#import "SaveScanAfterDataViewController.h"
#import "ArrengeSelectFileViewController.h"
#import "CommonUtil.h"
#import "Define.h"
#import "PictureViewController.h"
#import "ArrangePictViewController.h"
#import "ScanDataCell.h"
#import "ScanDataManager.h"
#import "ScanAfterPictViewController.h"
// iPad用
#import "ScanAfterPictViewController_iPad.h"
#import "RootViewController_iPad.h"
// iPad用

#import "SharpScanPrintAppDelegate.h"

#import "GeneralFileUtility.h"

@implementation SaveScanAfterDataViewController

@synthesize baseDir;								// ファイルパス
@synthesize HeaderShrinkStates = m_parrHeaderShrinkState;
@synthesize subDir;
@synthesize rootDir;
@synthesize beforeDir;
@synthesize beforeMoveArray;
@synthesize beforeMoveName;
@synthesize bScanAfter;
@synthesize renamedName;

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}
//
// インスタンス化された時に最初に呼出されるメソッド
//
- (void)viewDidLoad
{
    [super viewDidLoad];
	UITapGestureRecognizer* gestureRecognizer = [[UITapGestureRecognizer alloc]initWithTarget:self action:nil];
    gestureRecognizer.delegate = self;
    [self.view addGestureRecognizer:gestureRecognizer];
    
    
    self.tableView.rowHeight = N_HEIGHT_SEL_FILE;
    
    self.navigationItem.title = S_TITLE_SAVE;
    
    // 初期化
    mArray = [[NSMutableArray alloc]init ];
	
	//
	// ホームディレクトリ/Documments/ 取得
	//
	NSString *tempDir	= [CommonUtil documentDir];
	self.baseDir		= [tempDir stringByAppendingString:@"/"];
    
    
    // 戻るボタンの名称変更
    UIBarButtonItem * barItemBack = [UIBarButtonItem new];
    barItemBack.title = S_BUTTON_BACK;
    self.navigationItem.backBarButtonItem = barItemBack;
    
//    // フォルダ作成ボタン追加
//    UIBarButtonItem * folderCreationBtn = [[[UIBarButtonItem alloc] 
//                                           initWithBarButtonSystemItem:UIBarButtonSystemItemAdd
//                                           target:self                                         
//                                           action:@selector(createFolderAction:)] autorelease];
    
    // フォルダ作成ボタンの生成
    UIBarButtonItem * folderCreationBtn = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:S_ICON_CREATE_FOLDER] 
                                                          style:UIBarButtonItemStylePlain 
                                                         target:self
                                                         action:@selector(createFolderAction:)];
    

    
    self.navigationItem.rightBarButtonItem = folderCreationBtn;
    
    // Toolbar
    self.navigationController.toolbar.barStyle = TOOLBAR_BARSTYLE;
    // 間隔用ボタンの生成
    UIBarButtonItem *spaceBtn = [[UIBarButtonItem alloc]
                                  initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace
                                  target:nil
                                  action:nil];
    
    // キャンセルボタンの生成
    cancelBtn =  [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel
                                                                target:self 
                                                                action:@selector(cancelAction:)];

    // ここに保存ボタンの生成
    saveBtn = [[UIBarButtonItem alloc] initWithTitle:S_BUTTON_SAVE_HERE 
                                                style:UIBarButtonItemStyleDone 
                                               target:self 
                                               action:@selector(saveAction:)];
    
    // ツールバーに追加
    NSArray *items = [NSArray arrayWithObjects:cancelBtn,spaceBtn,saveBtn,nil];
    self.toolbarItems = items;
    
    [self.navigationController setToolbarHidden:NO animated:YES];
	
	//
	// ScanDataManager クラス生成
	// 
	manager		= [[ScanDataManager alloc]init];
    //	manager.tView	= self.tableView;
    
    manager.fullPath = self.subDir;
    manager.IsMoveView = YES;
    [manager reGetScanData];
	
    self.tableView.scrollEnabled = YES;
	
	//
	// statusBarStyle 設定
	//
	UIApplication* app = [UIApplication sharedApplication];
	app.statusBarStyle = UIStatusBarStyleLightContent;
    
    
	//
	// 再描画
	//
	[self.tableView reloadData];
 
    //
    //  前回保存した場合、保存したパスからファイル一覧を表示
    //
    if(self.bScanAfter == YES)
    {
        self.bScanAfter = NO;
        [self DirectMoveView];
        
    }
}

//
// ビューが最後まで描画された後やアニメーションが終了した後にこの処理
//
- (void)viewWillAppear:(BOOL)animated
{
    [self SetHeaderView];
    
    if(manager != nil)
    {
        manager.fullPath = self.subDir;
        manager.IsMoveView = YES;
        [manager reGetScanData];
        //        manager = [[ScanDataManager alloc]init];
    }
    [self.tableView reloadData];
    
    [super viewWillAppear:animated];
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
    
    // ツール上ボタンのマルチタップを制御する
    for (UIView * view in [self.navigationController.toolbar subviews]) {
        if ([view isKindOfClass: [UIView class]]) {
            [view setExclusiveTouch:YES];
        }
    }

}

//
// アプリケーションの終了直前に呼ばれるメソッド
//

// iPad用
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
    {
        return YES;
    }
    else
    {
        // Return YES for supported orientations
        return (interfaceOrientation == UIInterfaceOrientationPortrait);
    }
}
// iPad用

-(void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)FromInterfaceOrientation
{
    if (FromInterfaceOrientation == UIInterfaceOrientationPortrait ||
        FromInterfaceOrientation == UIInterfaceOrientationPortraitUpsideDown)
	{
		// 縦向き
		
	}
	else
	{
		// 横向き
		
	}
	[self.tableView reloadData];
}

#pragma mark -
#pragma mark Table view methods


// 
// セクション数の指定
//
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [manager countOfScanData];
    
}

//
// 各セクションのセルの数を決定する
//
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [[manager loadScanDataAtSection:section] count];
    
}


//
// テーブルセルの作成
//
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    ScanDataCell *cell = (ScanDataCell*)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if ( ! cell ) {
        cell = [[ScanDataCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];        
    }
    
    if (![[self.HeaderShrinkStates objectAtIndex:[indexPath section]]boolValue])
    {
        // データ取得
        ScanData *scanData = nil;
        scanData = [manager loadScanDataAtIndexPath:indexPath];
        [cell setModel:scanData hasDisclosure:TRUE];
        
    }
    return cell;
    
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch
{
    CGPoint point = [touch locationInView:(UITableView*)self.view];
    UITableView* _tableView = (UITableView*)self.view;
    
    for (NSInteger nIndex = [self.tableView.dataSource numberOfSectionsInTableView:_tableView]-1; nIndex >= 0; nIndex --)
    {
        CGRect rectHeader = [_tableView rectForHeaderInSection:nIndex];
        if (CGRectContainsPoint(rectHeader, point))
        {
            DLog(@"%s:%d", __FUNCTION__, __LINE__);
            [self shrinkRowInSection:nIndex];
            break;
        }
    }
    return NO;
}

// テーブルビュー 縦幅設定
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    BOOL bShrinked = [[self.HeaderShrinkStates objectAtIndex:[indexPath section]]boolValue];    
    
    return bShrinked ? 0.0f : N_HEIGHT_SEL_FILE;
}
// テーブルビュー セクションのタイトル設定
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    //    if ([[manager loadScanDataAtSection:section] count] > 0)
    //    {
    //        // セクションヘッダの初期状態
    //        if (self.HeaderShrinkStates == nil)
    //        {
    //            self.HeaderShrinkStates = [NSMutableArray array];
    //        }
    //        [self.HeaderShrinkStates addObject:[NSNumber numberWithBool:NO]];
    //        
    //        // yyyy年mm月のフォーマット表示
    //        NSString *TitleChar = [[[manager loadScanDataAtSection:section] objectAtIndex:0] crdate_yymm ];
    //        
    //        // ディレクトリの場合、セクションのタイトルは"フォルダー"
    //        if([[[manager loadScanDataAtSection:section] objectAtIndex:0] isDirectory ])
    //        {
    //            return S_LABEL_FOLDER;
    //        }
    //        else
    //        {
    //            return [NSString stringWithFormat:@"%@/%@", 
    //                    [TitleChar substringWithRange:NSMakeRange(0,4)],
    //                    [TitleChar substringWithRange:NSMakeRange(4,2)]];
    //        }
    //    }
    return nil;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self MoveView:indexPath];    
}

- (void)tableView:(UITableView *)tableView accessoryButtonTappedForRowWithIndexPath:(NSIndexPath *)indexPath
{
    [self MoveView:indexPath];
}

- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event
{
    DLog(@"cancel");
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    DLog(@"began");
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    DLog(@"moved");
}

// セクションの折りたたみ、展開
- (void)shrinkRowInSection:(NSInteger)section
{
    DLog(@"%s:%d section=%ld", __FUNCTION__, __LINE__, (long)section);
    UITableView* _tableView = (UITableView*)self.view;
    NSMutableArray* arr = [NSMutableArray array];
    
    // セクションの状態を取得
    BOOL bShrinked = [[self.HeaderShrinkStates objectAtIndex:section]boolValue];    
    [self.HeaderShrinkStates replaceObjectAtIndex:section withObject:[NSNumber numberWithBool: bShrinked ? NO :YES]];
    
    // セクション数分ループ
    for (NSInteger nIndex = 0; nIndex < [self tableView:_tableView numberOfRowsInSection:section]; nIndex++)
    {
        NSIndexPath* indexPath = [NSIndexPath indexPathForRow:nIndex inSection:section];
        [arr addObject:indexPath];
    }
    
    [_tableView beginUpdates];
    [_tableView reloadRowsAtIndexPaths:arr withRowAnimation:NO];
    [_tableView endUpdates];
}

// 画面遷移
- (void)MoveView:(NSIndexPath *)nIndexPath
{
    // セルの複数タップを制御する
    if ( ! [self.navigationController.visibleViewController isKindOfClass: [self class]] ) {
        DLog(@"visibleViewController is Invalid");
        return;
    }

    // ディレクトリの場合は階層遷移
    if([[manager loadScanDataAtIndexPath:nIndexPath] isDirectory ])
    {
        SaveScanAfterDataViewController* pMoveView = [[SaveScanAfterDataViewController alloc] init];
        pMoveView.renamedName = renamedName;
        
        // 選択ファイルパス格納
        ScanData *scanData = nil;
        pMoveView.tempFile = self.tempFile;
        scanData = [manager loadScanDataAtIndexPath:nIndexPath];
        if(self.subDir == nil)
        {
            pMoveView.subDir = [NSString stringWithFormat:@"%@/%@" , manager.baseDir, scanData.fname]; 
//            pMoveView.rootDir = [NSString stringWithFormat:@"/%@" , [scanData.fname substringFromIndex:4]];
            pMoveView.rootDir = [NSString stringWithFormat:@"/%@" , scanData.fname];
        }
        else
        {
            pMoveView.subDir = [NSString stringWithFormat:@"%@/%@" , self.subDir, scanData.fname];     
//            pMoveView.rootDir = [NSString stringWithFormat:@"%@/%@" , self.rootDir, [scanData.fname substringFromIndex:4]];
            pMoveView.rootDir = [NSString stringWithFormat:@"%@/%@" , self.rootDir, scanData.fname]; 
        }
        
        manager.fullPath = pMoveView.subDir;
        [self.navigationController pushViewController:pMoveView animated:YES];
    }
}

//// 前回保存した階層まで画面遷移する
- (void)DirectMoveView
{
    
    savePath = [NSUserDefaults standardUserDefaults];
    NSString *path = [savePath stringForKey:S_KEY_SAVE_PATH];
    

    if(path != nil && ![path isEqualToString:@""])
    {

        NSFileManager *fManager = [NSFileManager defaultManager];
        // パスにファイルが存在し、保存階層と同じでない場合
        if([fManager fileExistsAtPath:path] && ![self.subDir isEqualToString:path])
        {
//            //パスが存在している場合は保存

            NSString *Dir = @"";
            if (self.subDir == nil)
            {
                Dir = manager.baseDir;
            }
            else
            {
                Dir = self.subDir;
            }
            
            NSString *pstrSubDir = [path substringFromIndex:[Dir length]+1];
            NSArray *array = [pstrSubDir componentsSeparatedByString:@"/"];
            NSString *pstrSubDirName = [array objectAtIndex:0];
            
            if (pstrSubDirName != nil && ![pstrSubDirName isEqualToString:@""])
            {
                SaveScanAfterDataViewController* pMoveView = [[SaveScanAfterDataViewController alloc] init];

                // 選択ファイルパス格納
                if(self.subDir == nil)
                {
                    pMoveView.subDir = [NSString stringWithFormat:@"%@/%@" , manager.baseDir, pstrSubDirName]; 
//                    pMoveView.rootDir = [NSString stringWithFormat:@"/%@" , [pstrSubDirName substringFromIndex:4]];
                    // "DIR-"はないのでそのまま表示する
                    pMoveView.rootDir = [NSString stringWithFormat:@"/%@" , pstrSubDirName];

                }
                else
                {
                    pMoveView.subDir = [NSString stringWithFormat:@"%@/%@" , self.subDir, pstrSubDirName];     
//                    pMoveView.rootDir = [NSString stringWithFormat:@"%@/%@" , self.rootDir, [pstrSubDirName substringFromIndex:4]];
                    // "DIR-"はないのでそのまま表示する
                    pMoveView.rootDir = [NSString stringWithFormat:@"%@/%@" , self.rootDir, pstrSubDirName];
                }
                
                if (![pMoveView.subDir isEqualToString:path])
                {
                    // 前回保存パスと同じになるまでは画面遷移フラグはYES
                    pMoveView.bScanAfter = YES;                        
                }
                manager.fullPath = pMoveView.subDir;
                pMoveView.tempFile = self.tempFile;
                pMoveView.renamedName = renamedName;
                [self.navigationController pushViewController:pMoveView animated:NO];
            }
        }
    }
}

//
// メモリ警告時
//
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];    
}

// キャンセルし画面を閉じる
- (void)cancelAction:(id)sender
{
    // iPad用
    if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
    {
        SharpScanPrintAppDelegate* pAppDelegate = (SharpScanPrintAppDelegate*)[[UIApplication sharedApplication] delegate];
        UINavigationController* pRootNavController = [pAppDelegate.splitViewController.viewControllers objectAtIndex:0];
        RootViewController_iPad* rootViewController_ipad = (RootViewController_iPad*)[pRootNavController.viewControllers objectAtIndex:0];
        [rootViewController_ipad OnHelpClose];
    }
    else
    {
    // iPad用
        // Modal表示のため、呼び出し元で閉じる処理を行う
        SharpScanPrintAppDelegate* appDelegate = (SharpScanPrintAppDelegate*)[[UIApplication sharedApplication] delegate];
        ScanAfterPictViewController* pScanAfterPictViewController = (ScanAfterPictViewController*)appDelegate.navigationController.topViewController;
    
        [pScanAfterPictViewController OnCancel];
    }
}

// フォルダ作成画面に遷移する
- (void)createFolderAction:(id)sender
{    
    // 編集モードOFF
    [self setEditing:NO animated:NO];
    
    // 画面遷移
    CreateFolderViewController* pCreateFolderViewController;
    pCreateFolderViewController = [[CreateFolderViewController alloc] init];
    ScanDirectory *localScanDirectory;
    // 選択ファイルパス格納
    if(self.subDir == nil)
    {
        localScanDirectory = [[ScanDirectory alloc]initWithScanDirectoryPath:manager.baseDir];
    }
    else
    {     
        localScanDirectory = [[ScanDirectory alloc]initWithScanDirectoryPath:self.subDir];
    }
    
    pCreateFolderViewController.scanDirectory	= localScanDirectory;
//    // 保存画面遷移フラグをたてる
//    pCreateFolderViewController.bSaveView = YES;
//    [self.navigationController pushViewController:pCreateFolderViewController animated:YES];
    
    // モーダル表示
    pCreateFolderViewController.delegate = self;
    UINavigationController *navigationController = [[UINavigationController alloc]initWithRootViewController:pCreateFolderViewController];
    navigationController.navigationBar.barStyle = NAVIGATION_BARSTYLE;
    [navigationController setModalPresentationStyle:UIModalPresentationPageSheet];
    [self presentViewController:navigationController animated:YES completion:nil];
    

}

// ファイルを保存する
- (void)saveAction:(id)sender
{
    //リリースプール生成
    @autoreleasepool
    {
        
        self.navigationController.toolbar.userInteractionEnabled = NO;  // Toolbarタッチ操作無効(連打対応)
        
        SharpScanPrintAppDelegate* appDelegate = (SharpScanPrintAppDelegate*)[[UIApplication sharedApplication] delegate];
        DLog(@"%d",appDelegate.IsRun);
        //        // 処理実行フラグON
        //        appDelegate.IsRun = TRUE;
        
        // 保存処理
        TempDataManager *tempManager = [[TempDataManager alloc]init];
        
        if([self copyTempData:tempManager]){
            //
            // 完了した場合
            //
            savePath = [NSUserDefaults standardUserDefaults];
            [savePath setObject:self.subDir forKey:S_KEY_SAVE_PATH];
            
            // アラートを出さずにTOP画面に遷移させるようにする
            [self alertButtonPushed:nil tagIndex:1 buttonIndex:0];
        }
        else
        {
            //
            // 保存に失敗した場合
            //
            UIAlertController *tempAlert = [UIAlertController alertControllerWithTitle:nil
                                                                               message:MSG_SAVE_ERR
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
            
            self.navigationController.toolbar.userInteractionEnabled = YES; // Toolbarタッチ操作戻す(エラー時)

            return;
            
        }
    }
}

// 処理実行フラグをOFFにする
- (void)appDelegateIsRunOff {
    // ボタンタップ時の処理
    SharpScanPrintAppDelegate* appDelegate = (SharpScanPrintAppDelegate*)[[UIApplication sharedApplication] delegate];
    // 処理実行フラグOFF
    appDelegate.IsRun = FALSE;
}

//ダイアログのボタン押下時
-(void)alertButtonPushed:(UIAlertController *)alertController tagIndex:(NSInteger)tagIndex buttonIndex:(NSInteger)buttonIndex{

    if(tagIndex == 1)
    {
        // iPad用
        if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
        {
            // Modal表示のため、呼び出し元で閉じる処理を行う
            SharpScanPrintAppDelegate* pAppDelegate = (SharpScanPrintAppDelegate*)[[UIApplication sharedApplication] delegate];
            UINavigationController* pRootNavController = [pAppDelegate.splitViewController.viewControllers objectAtIndex:0];
            RootViewController_iPad* rootViewController_ipad = (RootViewController_iPad*)[pRootNavController.viewControllers objectAtIndex:0];
            [rootViewController_ipad OnSaveClose];
            
        }
        else
        {
        // iPhone用
            // Modal表示のため、呼び出し元で閉じる処理を行う
            SharpScanPrintAppDelegate* appDelegate = (SharpScanPrintAppDelegate*)[[UIApplication sharedApplication] delegate];
            ScanAfterPictViewController* pScanAfterPictViewController = (ScanAfterPictViewController*)appDelegate.navigationController.topViewController;
            
            [pScanAfterPictViewController OnClose];
        }
        
        self.navigationController.toolbar.userInteractionEnabled = YES; // Toolbarタッチ操作戻す(正常時)
    }
    
    // 処理実行フラグをOFFにする
    [self appDelegateIsRunOff];
}

// モーダル表示した画面を閉じる
- (void)OnClose
{
    [self dismissViewControllerAnimated:YES completion:nil];
    [self viewWillAppear:YES];
}

// ヘッダー表示
- (void)SetHeaderView
{
    
    UILabel *label = [[UILabel alloc] init];
    label.frame = CGRectMake(10.0, 0.0, self.view.frame.size.width-20.0, 24.0);
    label.backgroundColor = [UIColor grayColor];
    label.textColor = [UIColor whiteColor];
    label.font = [UIFont fontWithName:@"AppleGothic" size:16];
    label.textAlignment = NSTextAlignmentLeft;
    label.adjustsFontSizeToFitWidth = NO;
    label.lineBreakMode = NSLineBreakByTruncatingMiddle;
    
    NSString *pstrText = self.rootDir;
    if(pstrText == nil || [pstrText isEqualToString:@""])
    {
        label.text = @"/";
    }
    else
    {
        label.text = pstrText;
    }
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0.0, 0.0, self.view.frame.size.width, 25.0)];   
    headerView.backgroundColor = [UIColor grayColor];
    [headerView addSubview:label];
    //TableViewにヘッダー設定
    self.tableView.tableHeaderView = headerView;
    
}

#pragma mark - CreateFolderViewControllerDelegate
-(void) createFolder:(UIViewController*)viewController didCreatedSuccess:(BOOL)bSuccess;
{
    
    CreateFolderViewController* con = (CreateFolderViewController*)viewController;

    // フォルダ作成
    if(bSuccess){
        // リスト更新
        [self viewWillAppear:NO];
    }

    // モーダルを閉じる
    [con dismissViewControllerAnimated:YES completion:nil];

    // デリゲートをクリア
    con.delegate = nil;
}

// TempFileから保存する
- (BOOL)copyTempData:(TempDataManager*)tempManager
{

    BOOL isSaveSucceeded = NO;
    BOOL isError = NO;

    if(self.subDir){
        tempManager.fullPath = manager.fullPath;
    } else {
        tempManager.fullPath = [ScanFileUtility getScanFileDirectoryPath];
    }
    tempManager.saveFileName = renamedName;
    
    // 適切なファイルパス配列を取得する
    NSMutableArray *targetFilePathArray = [self getTargetFilePathArray:tempManager isError:&isError];
    DLog(@"isError = %@",(isError ? @"YES":@"NO"));

    // ファイルパス配列を取得できた場合
    if (!isError) {
        // 保存処理開始
        for (int i = 0; i < tempManager.atempDataList.count; i++){
            TempData *tempData = [tempManager.atempDataList objectAtIndex:i];
            DLog(@"tempData.fname = %@",tempData.fname);
            TempFile *localTempFile = [[TempFile alloc]initWithFileName:tempData.fname];
            NSString *targetFilePath = [targetFilePathArray objectAtIndex:i];
            DLog(@"targetFilePath = %@",targetFilePath);
            
            //scanFileを作り、その場所にデータを保存
            ScanFile *scanFile = [[ScanFile alloc]initWithScanFilePath:targetFilePath];
            isSaveSucceeded = [GeneralFileUtility move:localTempFile Destination:scanFile];
            if(!isSaveSucceeded){
                break;
            }
        }
    }
    return isSaveSucceeded;
}

// 保存中のファイルと重複しないファイル名(ファイルパス)を取得する
- (NSMutableArray*) getTargetFilePathArray:(TempDataManager*)tempManager isError:(BOOL*)isError
{
    NSMutableArray *targetFilePathArray = [[NSMutableArray alloc]init];
    NSString *scanDir = tempManager.fullPath;

    // ファイル名でソートする
    [tempManager.atempDataList sortUsingComparator:^NSComparisonResult(TempData* obj1, TempData* obj2) {
        return [obj1.fname compare:obj2.fname];
    }];
    
    int nSequence = 0;
    if (tempManager.atempDataList.count <= 0) {
        // データがない場合はエラーとする。
        *isError = YES;
        return targetFilePathArray;
    }
    TempData* aData = [tempManager.atempDataList objectAtIndex:0];
    
    BOOL isSerialNoLengthIsFour = [CommonUtil isSerialNoLengthIsFour:[aData.fname stringByDeletingPathExtension]];
    
    // ファイル名変更の有無をチェック
    if(tempManager.saveFileName){
        NSString* checkFname = [[tempManager.saveFileName stringByDeletingPathExtension] stringByAppendingPathExtension:[aData.fname pathExtension]];
        if([checkFname isEqualToString:aData.fname]){
            // 変更なし
            nSequence = 0;
            tempManager.saveFileName = nil;
        }
        else
        {
            // 連番判定
            NSArray* splits = [[aData.fname stringByDeletingPathExtension] componentsSeparatedByString:@"_"];
            // 最初のファイル名の最後が"_数字"になっているか
            if(tempManager.atempDataList.count > 1 &&
               splits.count > 1 &&
               [[splits lastObject] intValue] > 0){
                // "_001"か
                if([[splits lastObject] isEqualToString:@"001"] || [[splits lastObject] isEqualToString:@"0001"])
                {
                    // 連番ファイル名と判定
                    nSequence = 1;
                }
            }
        }
    }
    
    BOOL ret = YES;

    // ディレクトリ用の列挙子を取得する
    for (TempData *theTempData in tempManager.atempDataList)
    {
        NSString *fname = theTempData.fname;

        if(tempManager.saveFileName){
            fname = [[tempManager.saveFileName stringByDeletingPathExtension] stringByAppendingPathExtension:[theTempData.fname pathExtension]];
            
        }else{
            if(nSequence){
                // 連番部分を削除
                NSString* ext = [fname pathExtension];
                NSMutableArray* splitFname = [NSMutableArray arrayWithArray:[[fname stringByDeletingPathExtension] componentsSeparatedByString:@"_"]];
                [splitFname removeLastObject];
                fname = [splitFname objectAtIndex:0];
                [splitFname removeObjectAtIndex:0];
                for(NSString* p in splitFname){
                    fname = [NSString stringWithFormat:@"%@_%@", fname , p];
                }
                fname = [fname stringByAppendingPathExtension:ext];
            }
        }
        
        // 連番を付与
        if (nSequence) {
            NSString* format = @"%@_%03d.%@";
            if(isSerialNoLengthIsFour) {
                format = @"%@_%04d.%@";
            }
            fname = [NSString stringWithFormat:format,
                     [fname stringByDeletingPathExtension],
                     nSequence,
                     [fname pathExtension]];
            nSequence++;
        }
        
        // 初期設定
        NSString *targetFilePath =[scanDir stringByAppendingPathComponent:fname];
        [targetFilePathArray addObject:targetFilePath];
        ScanFile *scanFile = [[ScanFile alloc] initWithScanFilePath:targetFilePath];
        
        NSString *orgFname = fname;

        // ファイル存在確認
        if ([scanFile existsFileInScanFile])
        {
            ret = NO;
            
            // 連番でファイル名リネーム
            for (NSInteger iRenameIndex = 0; iRenameIndex < 10000; iRenameIndex++)
            {
                fname = [NSString stringWithFormat:@"%@(%zd).%@",
                         [orgFname stringByDeletingPathExtension],
                         iRenameIndex + 1,
                         [orgFname pathExtension]];
                if(fname.length > 200){
                    fname = [NSString stringWithFormat:@"%@(%zd).%@",
                             [[orgFname stringByDeletingPathExtension] substringToIndex:195 - [orgFname pathExtension].length - 1],
                             iRenameIndex + 1,
                             [orgFname pathExtension]];
                }
                
                // ファイル名を変更
                targetFilePath =[scanDir stringByAppendingPathComponent:fname];
                scanFile = [[ScanFile alloc] initWithScanFilePath:targetFilePath];

                // ファイル存在確認
                if (![scanFile existsFileInScanFile])
                {
                    // 初期設定したファイル名を変更する
                    [targetFilePathArray replaceObjectAtIndex:targetFilePathArray.count-1 withObject:targetFilePath];
                    ret = YES;
                    break;
                }
            }
            
            if (!ret)
            {
                // 適切なファイルなし
                *isError = YES;
                break;
            }
        }
    }
    return targetFilePathArray;
}

@end
