
#import "ArrengeSelectFileViewController_iPad.h"
#import "CommonUtil.h"
#import "Define.h"
#import "PictureViewController_iPad.h"
#import "ArrangePictViewController_iPad.h"
#import "ScanDataCell.h"
#import "ScanDataManager.h"
// iPad用
#import "RootViewController_iPad.h"
#import "SharpScanPrintAppDelegate.h"
#import "SearchResultViewController_iPad.h"
// iPad用

@interface ArrengeSelectFileViewController_iPad ()
@property (nonatomic,assign) BOOL isFirstTap; // セルをタップ済みかどうか(連打不可対応)

// プレビュー表示しているファイル名を取得する
- (NSString *)getPreviewFileName;

// プレビュー表示しているファイルが存在するかチェックする
- (BOOL)isFileExistsPreviewFile;

// ルートビューに戻す
- (void)moveRootView;

@end

@implementation ArrengeSelectFileViewController_iPad

@synthesize baseDir;								// ファイルパス
@synthesize scanDirectory;
@synthesize bSetTitle; // iPad用
@synthesize selectIndexPath; // iPad用
@synthesize lastScrollOffSet; // iPad用
@synthesize bCanDelete; // iPad用
@synthesize sortMenuViewController;
@synthesize sortViewPopoverController;
@synthesize previewFileName = _previewFileName;
@synthesize sortTypeButton;
@synthesize previousOrientation;
@synthesize indicator;

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
    DLog(@"viewDidLoad     ArrengeSelectFileViewController_iPad");
	
    [super viewDidLoad];
    
//    self.edgesForExtendedLayout = UIRectEdgeNone;

    // UINavigationBar 44px のずれを無くす
    self.navigationController.navigationBar.translucent = NO;
    self.navigationController.navigationBar.barStyle = NAVIGATION_BARSTYLE;
    
    self.tableView.rowHeight = N_HEIGHT_SEL_FILE;
    
    // iPad用
    //self.navigationItem.title = S_TITLE_ARRANGE;
    if(bSetTitle)
    {
        self.navigationItem.title = S_TITLE_ARRANGE;
    }
    // iPad用
    
    // 編集モード中もセルの選択を有効にする
    self.tableView.allowsSelectionDuringEditing = YES;
    
    // 初期化
    mArray = [[NSMutableArray alloc]init ];
    
	//
	// UITableView の背景色を変更
	//
    //	self.tableView.backgroundColor = [UIColor blackColor];
    //	self.tableView.backgroundColor = [UIColor whiteColor];
	
	//
	// ホームディレクトリ/Documments/ 取得
	//
	NSString *tempDir	= [CommonUtil documentDir];
	self.baseDir		= [tempDir stringByAppendingString:@"/"];
    if (!self.scanDirectory) {
        self.scanDirectory = [[ScanDirectory alloc]initWithScanDirectoryPath:self.baseDir];
    }
    
    // 戻るボタンの名称変更
    UIBarButtonItem * barItemBack = [UIBarButtonItem new];
    barItemBack.title = S_BUTTON_BACK;
    self.navigationItem.backBarButtonItem = barItemBack;
   
    //  iPad用
//    if(bSetTitle)
//    {
//        // 右側ビューに表示している場合のみ編集ボタン追加
        self.navigationItem.rightBarButtonItem = self.editButtonItem;
//    }
    //  iPad用
    
    // Toolbar
    self.navigationController.toolbar.barStyle = TOOLBAR_BARSTYLE;
    // 間隔用ボタンの生成
    UIBarButtonItem *spaceBtn = [[UIBarButtonItem alloc]
                                  initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace
                                  target:nil
                                  action:nil];
    
    // 移動ボタンの生成
    moveBtn =  [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:S_ICON_FILE_MOVE] 
                                                 style:UIBarButtonItemStylePlain 
                                                target:self
                                                action:@selector(moveAction:)];
    
    // ゴミ箱ボタンの生成
    trashBtn = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:S_ICON_FILE_DELETE] 
                                                 style:UIBarButtonItemStylePlain 
                                                target:self
                                                action:@selector(delAction:)];
    
    // 名称変更ボタンの生成
    nameChangeBtn = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:S_ICON_FILE_RENAME] 
                                                      style:UIBarButtonItemStylePlain 
                                                     target:self
                                                     action:@selector(nameChangeAction:)];
    
    // フォルダ作成ボタンの生成
    folderCreationBtn = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:S_ICON_CREATE_FOLDER] 
                                                          style:UIBarButtonItemStylePlain 
                                                         target:self
                                                         action:@selector(createFolderAction:)];
    
    // 初期表示
    moveBtn.enabled = NO;
    trashBtn.enabled = NO;
    nameChangeBtn.enabled = NO;
    folderCreationBtn.enabled = YES;
    
    // ツールバーに追加
    NSArray *items = [NSArray arrayWithObjects:spaceBtn,moveBtn,spaceBtn,trashBtn,spaceBtn,nameChangeBtn,spaceBtn,folderCreationBtn,spaceBtn,nil];
    self.toolbarItems = items;
    
    [self.navigationController setToolbarHidden:YES animated:YES];
		
	//
	// ScanDataManager クラス生成
	// 
	manager		= [[ScanDataManager alloc]init];
//	manager.tView	= self.tableView;
    manager.fullPath = self.scanDirectory.scanDirectoryPath;
//    [manager reGetScanData];
    
    self.tableView.scrollEnabled = YES;
	
	//
	// statusBarStyle 設定
	//
	UIApplication* app = [UIApplication sharedApplication];
    app.statusBarStyle = UIStatusBarStyleLightContent;
    
	//
	// 再描画
	//
//	[self.tableView reloadData];
    
    // 選択情報のクリア
    if(self.scanDirectory.isRootDirectory) {
        NSUserDefaults* ud = [NSUserDefaults standardUserDefaults];
        [ud removeObjectForKey:S_KEY_SELECT_DIR];
        [ud removeObjectForKey:S_KEY_SELECT_INDEX_SECTION];
        [ud removeObjectForKey:S_KEY_SELECT_INDEX_ROW];
        [ud removeObjectForKey:S_KEY_SELECT_FPATH];
        [ud synchronize];
    }
    
    //sort用のpopoverの設定
    self.sortMenuViewController = [[SelectFileSortPopViewController_ipad alloc] initWithStyle: UITableViewStyleGrouped];
    self.sortMenuViewController.delegate = self;
    
    self.tableView.tag = 1;
    
    self.previousOrientation = [[UIDevice currentDevice] orientation];
    //回転時にrotateActionが呼ばれるようにする
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didChangedOrientation:)
                                                 name:UIDeviceOrientationDidChangeNotification object:nil];

}

//
// ビューが最後まで描画された後やアニメーションが終了した後にこの処理
//
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];

    if (!_observing) {
        // NotificationCenterを取得する
        NSNotificationCenter *center;
        center = [NSNotificationCenter defaultCenter];
        
        // Observerとして登録する
        [center addObserver:self
                   selector:@selector(keyboardDidHide:)
                       name:UIKeyboardDidHideNotification
                     object:nil];
        
        _observing = YES;
    }
    
    // タップ済みフラグを初期化する
    self.isFirstTap = NO;

    DLog(@"viewWillAppear     ArrengeSelectFileViewController_iPad");
    if(m_searchController.active)
    {
        [self willDismissSearchController:m_searchController];
    }
    
    [self SetHeaderView];
    
    // indicatorを開始する
    [self indicatorStart];
    
    // 時間がかかる処理をバックグラウンドで実行する
    [self performSelectorInBackground:@selector(lateProcessing) withObject:nil];
    
//    if(manager != nil)
//    {
//        manager.fullPath = self.scanDirectory.scanDirectoryPath;
//        [manager reGetScanData];
//    }
//    [self.tableView reloadData];
//
//    //[super viewWillAppear:animated];
//	[self.tableView deselectRowAtIndexPath:[self.tableView indexPathForSelectedRow] animated:YES];
//    SharpScanPrintAppDelegate* pAppDelegate = (SharpScanPrintAppDelegate*)[[UIApplication sharedApplication] delegate];
//    UINavigationController* pRootNavController = [pAppDelegate.splitViewController.viewControllers objectAtIndex:0];
//    //左側のViewに設定されているクラスの名前を取得
//    NSString* leftViewClassName = [pRootNavController.topViewController description];
//    NSString* selectDir = [[NSUserDefaults standardUserDefaults] objectForKey:S_KEY_SELECT_DIR];
//    if (selectIndexPath != nil && ((self.scanDirectory.isRootDirectory && selectDir == nil) || [self.scanDirectory.relativeDirectoryPathInScanFile  isEqualToString:selectDir]))
//    {
//        //^^
//        NSString* fullPath = [[NSUserDefaults standardUserDefaults] stringForKey: S_KEY_SELECT_FPATH];
//        selectIndexPath = [manager indexOfScanDataWithFilePath: fullPath];
//        
//        // 左側のViewにこのクラスが表示されている場合
//        if([leftViewClassName isEqual:[self description]])
//        {
//            // 指定の行を選択状態
//            [self.tableView selectRowAtIndexPath:selectIndexPath animated:NO scrollPosition:UITableViewScrollPositionNone];
//            // 指定の位置までスクロール
//            if(selectIndexPath.section)
//            {
//                if([[[UIDevice currentDevice] systemVersion] floatValue] < 7.0)
//                {   // iOS7より前の場合
//                    [self.tableView scrollToRowAtIndexPath:selectIndexPath atScrollPosition:UITableViewScrollPositionTop animated:NO];
//                }
//            }
//            else
//            {   
//                //0件の場合
//                [self.tableView setContentOffset:lastScrollOffSet];
//            }
//        }
//    }
//    // iPad用
//    // 縦表示の時はメニューボタンを表示
//    [pAppDelegate setPortraitMenuButton];
//    // iPad用
//    
//    // tap時のイベント
//    UITapGestureRecognizer *tapRecognizer = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(ClickEventOnBlackAlpha:)];
//    [tapRecognizer setNumberOfTapsRequired:1];
//    [tapRecognizer setDelegate:self];
//    blackAlphaView.userInteractionEnabled = YES;
//    [blackAlphaView addGestureRecognizer:tapRecognizer];
//    if([leftViewClassName isEqual:[self description]])
//    {
//        if(searchController.active){
//            searchController.searchBar.frame = (CGRect){0, 1.0, self.view.frame.size.width, SEARCHBAR_HEIGHT + 3.0};
//            if(!sortTypeButton.hidden){
//                sortTypeButton.hidden = YES;
//            }
//        }else{
//            sortTypeButton.hidden = NO;
//            searchController.searchBar.frame = (CGRect){SORTBUTTON_WIDTH, 1.0, self.view.frame.size.width - SORTBUTTON_WIDTH, SEARCHBAR_HEIGHT + 3.0};
//        }
//    }
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

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    // オブザーバー登録を終了する
    if (_observing) {
        // NotificationCenterを取得する
        NSNotificationCenter *center;
        center = [NSNotificationCenter defaultCenter];
        
        // Observerを削除する
        [center removeObserver:self
                          name:UIKeyboardDidHideNotification
                        object:nil];
        
        _observing = NO;
    }
}

-(void)viewWillLayoutSubviews
{
    // didRotateFromInterfaceOrientation:が呼ばれないのでここでサーチバーの調整をする
    if (m_searchController.isActive) {
        m_searchController.searchBar.frame = (CGRect){0.0, 1.0, self.view.frame.size.width, SEARCHBAR_HEIGHT + 3.0};
    } else {
        m_searchController.searchBar.frame = (CGRect){SORTBUTTON_WIDTH, 1.0, self.view.frame.size.width - SORTBUTTON_WIDTH, SEARCHBAR_HEIGHT + 3.0};
    }
}

//
// アプリケーションの終了直前に呼ばれるメソッド
//

// iPad用
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // 横向きの場合
    if(interfaceOrientation == UIInterfaceOrientationLandscapeLeft || interfaceOrientation == UIInterfaceOrientationLandscapeRight)
    {
        // 縦向き表示時のメニューPopOverが表示されていたら閉じる
        [self dismissMenuPopOver:NO];
    }    
//    [self SetHeaderView]; //ヘッダの作り直し
	return YES;
}

-(void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)FromInterfaceOrientation
{
    // モーダルが開いていたらアニメーションなしで閉じる
    [fileNameChangeViewController hideErrorMessage];
//    [self dismissViewControllerAnimated:NO completion:nil];
    
    if (FromInterfaceOrientation == UIInterfaceOrientationPortrait ||
        FromInterfaceOrientation == UIInterfaceOrientationPortraitUpsideDown)
	{
		// 縦向き
	}
	else
	{
		// 横向きから縦向きに変更
        if(!self.scanDirectory.isRootDirectory)
        {
            // フォルダ階層遷移した為、メニューボタンは削除
            [self setPortraitMenu:nil];
            // 戻るボタンを表示
            UIBarButtonItem * barItemBack = [UIBarButtonItem new];
            barItemBack.title = S_BUTTON_BACK;
            self.navigationItem.backBarButtonItem = barItemBack;
        }
	}
    if (self.sortViewPopoverController !=nil)
    {
        [self.sortViewPopoverController dismissPopoverAnimated:YES];
    }
    if(m_searchController.active)
    {
        [self.view endEditing:YES];
        // 検索バーを隠す
        [m_searchController setActive:NO];
    }
    
    m_searchController.searchBar.frame = (CGRect){SORTBUTTON_WIDTH, 1.0, self.view.frame.size.width - SORTBUTTON_WIDTH, SEARCHBAR_HEIGHT + 2.0};

    [self SetHeaderView];
}

/**
 @brief iOS8以降の回転時のレイアウト変更を行う
 @detail 現在はUISearchController用の回転時の処理のみ
 */
- (void)viewWillTransitionToSize:(CGSize)size withTransitionCoordinator:(id<UIViewControllerTransitionCoordinator>)coordinator
{
    [coordinator animateAlongsideTransition:^(id<UIViewControllerTransitionCoordinatorContext> context) {
        
        if (size.width <= size.height) {
            // 縦レイアウトの位置修正
        }
        else {
            // 横レイアウトの位置修正
        }
        
        if (bEndActiveAtKBNotification) {
            // キーボードが閉じた通知にて非アクティブにされた場合は一旦アクティブにする
            // 回転時のsetActive:NOはこのタイミングで行わないとうまく動作しない為。一旦アクティブ化せず２重にNOしてもうまく動作しない。
            [m_searchController setActive:YES];
            bEndActiveAtKBNotification = NO;
        }
        if (m_searchController.active) {
            [m_searchController setActive:NO];
        }
        
    } completion:nil];
}

- (void)didChangedOrientation:(NSNotification *)notification
{
    float osVersion = [[[UIDevice currentDevice] systemVersion] floatValue];
    if(osVersion < 8.0){
        return;
    }
    UIDeviceOrientation orientation = [(UIDevice*)[notification object] orientation];
    switch (orientation) {
            
        case UIDeviceOrientationPortrait:
            // iPhoneを縦にして、ホームボタンが下にある状態
            break;
            
        case UIDeviceOrientationPortraitUpsideDown:
            // iPhoneを縦にして、ホームボタンが上にある状態
            break;
            
        case UIDeviceOrientationLandscapeLeft:
            // iPhoneを横にして、ホームボタンが左にある状態
            break;
            
        case UIDeviceOrientationLandscapeRight:
            // iPhoneを横にして、ホームボタンが右にある状態
            break;
        case UIDeviceOrientationUnknown:
            // 向きが分からない状態
            return;
            
        case UIDeviceOrientationFaceUp:
            // iPhoneの液晶面を大空に向けた状態
            return;
            
        case UIDeviceOrientationFaceDown:
            // iPhoneの液晶面を大地に向けた状態
            return;
        default:
            break;
    }
    if(orientation != self.previousOrientation &&(self.previousOrientation != UIDeviceOrientationUnknown || self.previousOrientation != UIDeviceOrientationFaceUp || self.previousOrientation != UIDeviceOrientationFaceDown)){
        [self dismissMenuPopOver:NO];
        // キーボードを消す
        if(m_searchController.active){
            [self.view endEditing:YES];
        }
        if(self.sortViewPopoverController)
        {
            [self.sortViewPopoverController dismissPopoverAnimated:YES];
        }
    }
    self.previousOrientation = orientation;
}


// iPad用

#pragma mark -
#pragma mark Table view methods


// 
// セクション数の指定
//
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    DLog(@"numberOfSectionsInTableView tag:%ld",(long)tableView.tag);
    if (tableView.tag != 1) {
        return 0;
    }
    return [manager countOfScanData];

}

//
// 各セクションのセルの数を決定する
//
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    DLog(@"numberOfRowsInSection tag:%ld",(long)tableView.tag);
    if (tableView.tag != 1) {
        return 0;
    }
    return [[manager loadScanDataAtSection:section] count];
    
}

//
// テーブルセルの作成
//
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    DLog(@"cellForRowAtIndexPath tag:%ld",(long)tableView.tag);
    if (tableView.tag != 1) {
        return 0;
    }
    
    NSString *CellIdentifier = [NSString stringWithFormat:@"Cell%@", (indexPath.section?@"T":@"F")];
    
    ScanDataCell *cell = (ScanDataCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if(cell == nil)
    {
        cell = [[ScanDataCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];

    }
    /*
     cell.accessoryType = UITableViewCellAccessoryDetailDisclosureButton;
     cell.textLabel.font = [UIFont systemFontOfSize:16];
     */
    
    // データ取得
    ScanData *scanData = nil;
    scanData = [manager loadScanDataAtIndexPath:indexPath];
   
    // チェックボックス切り替え
    BOOL checkd = [mArray containsObject:indexPath];
    if (checkd)
    {
        cell.selectImgView.tag = 1;
    }
    else
    {
        cell.selectImgView.tag = 0;
    }
    [cell setModel:scanData hasDisclosure:TRUE];
    [cell.selectImgView removeFromSuperview];
    /*
    // ファイル名
    cell.textLabel.text = scanData.fname;
    // サムネイル
    NSString* pstrImagePath	= [[CommonUtil pngDir:manager.baseDir] stringByAppendingPathComponent:scanData.imagename];
    cell.imageView.image = [UIImage imageWithContentsOfFile: pstrImagePath];
    */
    
    DLog(@"cellForRowAtIndexPath end");
    return cell;

}


// テーブルビュー 縦幅設定
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return N_HEIGHT_SEL_FILE;
}
// テーブルビュー セクションのタイトル設定
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    if ([[manager loadScanDataAtSection:section] count] > 0)
    {
        // yyyy年mm月のフォーマット表示
        NSString *TitleChar = [[[manager loadScanDataAtSection:section] objectAtIndex:0] crdate_yymm ];
        
        // ディレクトリの場合、セクションのタイトルは"フォルダー"
        if([[[manager loadScanDataAtSection:section] objectAtIndex:0] isDirectory ])
        {
            return S_LABEL_FOLDER;
        }
        else
        {
            switch ([CommonUtil scanDataSortType]) {
                case SCANDATA_FILEDATE:
                    return [NSString stringWithFormat:@"%@/%@",
                            [TitleChar substringWithRange:NSMakeRange(0,4)],
                            [TitleChar substringWithRange:NSMakeRange(4,2)]];
                    break;
                case SCANDATA_FILENAME:
                    //                    return [[[[manager loadScanDataAtSection:section] objectAtIndex:0] fname] substringToIndex:1];
                    return S_LABEL_FILE;
                    break;
                case SCANDATA_FILESIZE:
                    //                    return [[[[manager loadScanDataAtSection:section] objectAtIndex:0] fname] substringToIndex:1];
                    return S_LABEL_FILE;
                    break;
                case SCANDATA_FILETYPE:
                    //                    return [[[[manager loadScanDataAtSection:section] objectAtIndex:0] fname] pathExtension];
                    return [[[manager loadScanDataAtSection:section] objectAtIndex:0] fileType];
                default:
                    return nil;
                    break;
            }
        }
    }
    return nil;
}

// ヘッダー表示前にフォントを設定
- (void)tableView:(UITableView *)tableView willDisplayHeaderView:(UIView *)view forSection:(NSInteger)section
{
    UITableViewHeaderFooterView *heView = (UITableViewHeaderFooterView *)view;
    heView.textLabel.font = [UIFont systemFontOfSize:N_TABLE_FONT_SIZE_HEADER];
}

//// テーブルビュー セクションのタイトル設定
//- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
//{
//    if ([[manager loadScanDataAtSection:section] count] > 0)
//    {
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
//    return nil;
//}

// iPad用
- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(self.tableView.editing)
    {
        return 3;
    }
    if(bCanDelete)
    {
        return UITableViewCellEditingStyleDelete;
    }
    else
    {
        return UITableViewCellEditingStyleNone;
    }
}
// iPad用

//
// テーブル編集モード中に削除クリック処理
//
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
	DLog(@"indexPath %ld-%ld",(long)indexPath.section ,(long)indexPath.row);
	//
	// 削除ボタン押下
	//
    if (editingStyle == UITableViewCellEditingStyleDelete)
	{
		//
		// ファイル削除
		//
		@autoreleasepool
        {
            // おそらくこのコードは通らないが置き換える
            BOOL bRet = NO;
            ScanData *scanData = [manager loadScanDataAtIndexPath:indexPath];
            NSString *path = [self.scanDirectory.scanDirectoryPath stringByAppendingPathComponent:[scanData fname]];
            
            if(scanData.isDirectory){
                ScanDirectory *selectedScanDirectory = [[ScanDirectory alloc]initWithScanDirectoryPath:path];
                bRet = [ScanDirectoryUtility deleteDirectory:selectedScanDirectory];
            }else{
                ScanFile *selectedScanFile = [[ScanFile alloc]initWithScanFilePath:path];
                bRet = [ScanFileUtility deleteFile:selectedScanFile];
            }
            
            if (bRet == YES)
            {
//                // テーブルの更新
//                [tableView reloadData];
                
                //
                // Delete the row from the data source
                //
                [manager removeAtIndex:indexPath];
                [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationLeft];
            }
            
		}
        
    }
    else if (editingStyle == UITableViewCellEditingStyleInsert)
	{
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}



- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // セルの複数タップを制御する
    if ( ! [self.navigationController.visibleViewController isKindOfClass: [self class]] ) {
        DLog(@"visibleViewController is Invalid");
        return;
    }

    if(self.tableView.editing == NO)
    {
        // セルをタップ済みかどうか(連打不可対応)
        if (self.isFirstTap) {
            return;
        } else {
            self.isFirstTap = YES;
        }

        [self MoveView:indexPath];
    }
    else
    {
        // ハイライトOFF       
        //[tableView deselectRowAtIndexPath:indexPath animated:YES];
        
        // チェックボックス切り替え
        /*
        ScanDataCell *cell = (ScanDataCell*)[tableView cellForRowAtIndexPath:indexPath];
        if(cell.selectImgView.tag)
        {
            cell.selectImgView.tag = 0;
        }
        else
        {
            cell.selectImgView.tag = 1;
        }
        [cell setImageModel];
        */
        /*
        // 選択セルのチェック
        if ([mArray containsObject:indexPath] )
        {
            // 既に存在する場合は取り除く
            [mArray removeObject:indexPath];
        }
        else
        {
            [mArray addObject:indexPath];
        }
        DLog(@"%@",mArray);
        
        // 行の選択数によりボタン表示状態を変更
        switch ([mArray count]) {
            case 0:
                moveBtn.enabled = NO;
                trashBtn.enabled = NO;
                nameChangeBtn.enabled = NO;
                folderCreationBtn.enabled = YES;
                break;
            case 1:
                moveBtn.enabled = YES;
                trashBtn.enabled = YES;
                nameChangeBtn.enabled = YES;
                folderCreationBtn.enabled = YES;
                break;
            default:
                moveBtn.enabled = YES;
                trashBtn.enabled = YES;
                nameChangeBtn.enabled = NO;
                folderCreationBtn.enabled = YES;
                break;
        }
         */
        switch (tableView.indexPathsForSelectedRows.count) {
            case 0:
                moveBtn.enabled = NO;
                trashBtn.enabled = NO;
                nameChangeBtn.enabled = NO;
                folderCreationBtn.enabled = YES;
                break;
            case 1:
                moveBtn.enabled = YES;
                trashBtn.enabled = YES;
                nameChangeBtn.enabled = YES;
                folderCreationBtn.enabled = YES;
                break;
            default:
                moveBtn.enabled = YES;
                trashBtn.enabled = YES;
                nameChangeBtn.enabled = NO;
                folderCreationBtn.enabled = YES;
                break;
        }
    }
}

- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.tableView.editing == NO) {
        
    } else {
        switch (tableView.indexPathsForSelectedRows.count) {
            case 0:
                moveBtn.enabled = NO;
                trashBtn.enabled = NO;
                nameChangeBtn.enabled = NO;
                folderCreationBtn.enabled = YES;
                break;
            case 1:
                moveBtn.enabled = YES;
                trashBtn.enabled = YES;
                nameChangeBtn.enabled = YES;
                folderCreationBtn.enabled = YES;
                break;
            default:
                moveBtn.enabled = YES;
                trashBtn.enabled = YES;
                nameChangeBtn.enabled = NO;
                folderCreationBtn.enabled = YES;
                break;
        }
    }
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

// 画面遷移
- (void)MoveView:(NSIndexPath *)nIndexPath
{
    // ディレクトリの場合は階層遷移
    if([[manager loadScanDataAtIndexPath:nIndexPath] isDirectory ])
    {
        // iPad用
        SharpScanPrintAppDelegate* pAppDelegate = (SharpScanPrintAppDelegate*)[[UIApplication sharedApplication] delegate];
        
        if (pAppDelegate.IsPreview)
        {
            //^^
            NSString* fullPath = [[NSUserDefaults standardUserDefaults] stringForKey: S_KEY_SELECT_FPATH];
            selectIndexPath = [manager indexOfScanDataWithFilePath: fullPath];
            // 指定の行を選択状態
            [self.tableView selectRowAtIndexPath:selectIndexPath animated:NO scrollPosition:UITableViewScrollPositionNone];
            
            return;
        }
        ArrengeSelectFileViewController_iPad* arrengeView;
        arrengeView = [[ArrengeSelectFileViewController_iPad alloc] init];
        
        // 選択ファイルパス格納
        ScanData *scanData = nil;
        scanData = [manager loadScanDataAtIndexPath:nIndexPath];
        NSString * fullPath = [self.scanDirectory.scanDirectoryPath stringByAppendingPathComponent: scanData.fname];
        
        manager.fullPath = fullPath;

        ScanDirectory *selectedScanDirectory = [[ScanDirectory alloc]initWithScanDirectoryPath:fullPath];
        arrengeView.scanDirectory = selectedScanDirectory;
        
        arrengeView.selectIndexPath = nil;
        NSString* selectDir = [[NSUserDefaults standardUserDefaults] objectForKey:S_KEY_SELECT_DIR];
        if ([arrengeView.scanDirectory.relativeDirectoryPathInScanFile isEqualToString:selectDir]){
            NSString* fullPath = [[NSUserDefaults standardUserDefaults] stringForKey: S_KEY_SELECT_FPATH];
            arrengeView.selectIndexPath = [manager indexOfScanDataWithFilePath: fullPath];
        }
        arrengeView.bCanDelete = YES;
        
        UINavigationController* pRootNavController = [pAppDelegate.splitViewController.viewControllers objectAtIndex:0];
        //左側のViewに設定されているクラスの名前を取得
        NSString* leftViewClassName = [pRootNavController.topViewController description];
        
        // 左側のViewに自身が表示されていない場合
        if(![leftViewClassName isEqual:[self description]])
        {
            arrengeView.bSetTitle = YES;
        }
        
        [self.navigationController pushViewController:arrengeView animated:YES];
        
    }
    else
    {
        // iPad用
        SharpScanPrintAppDelegate* pAppDelegate = (SharpScanPrintAppDelegate*)[[UIApplication sharedApplication] delegate];

        if (pAppDelegate.IsPreview)
        {
            //^^
            NSString* fullPath = [[NSUserDefaults standardUserDefaults] stringForKey: S_KEY_SELECT_FPATH];
            selectIndexPath = [manager indexOfScanDataWithFilePath: fullPath];
            // 指定の行を選択状態
            [self.tableView selectRowAtIndexPath:selectIndexPath animated:NO scrollPosition:UITableViewScrollPositionNone];
        
            return;

        }

        // 選択行保持
        NSUInteger newIndex[] = {nIndexPath.section, nIndexPath.row};
        selectIndexPath = [[NSIndexPath alloc] initWithIndexes:newIndex length:2];

        // 選択ファイルの情報を保存
        NSUserDefaults* ud = [NSUserDefaults standardUserDefaults];
        [ud setObject:self.scanDirectory.relativeDirectoryPathInScanFile forKey:S_KEY_SELECT_DIR];
        [ud setObject:[NSNumber numberWithInteger:selectIndexPath.section] forKey:S_KEY_SELECT_INDEX_SECTION];
        [ud setObject:[NSNumber numberWithInteger:selectIndexPath.row] forKey:S_KEY_SELECT_INDEX_ROW];
        [ud setObject:[manager filePathAtIndexPath: selectIndexPath] forKey:S_KEY_SELECT_FPATH];
        [ud synchronize];
        // iPad用

        // 遷移元画面から渡されたIDをもとに遷移先のViewControllerを決定する
        PictureViewController_iPad* pViewController;
        pViewController =[[ArrangePictViewController_iPad alloc] init];

        // 選択ファイルパス格納
        ScanData *scanData = nil;
        scanData = [manager loadScanDataAtIndexPath:nIndexPath];
        NSString * fullPath = [self.scanDirectory.scanDirectoryPath stringByAppendingPathComponent: scanData.fname];
        
        ScanFile *selectedScanFile = [[ScanFile alloc] initWithScanFilePath:fullPath];
        pViewController.SelFilePath = selectedScanFile.scanFilePath;
        // iPad用
    
        UINavigationController* pRootNavController = [pAppDelegate.splitViewController.viewControllers objectAtIndex:0];
        //左側のViewに設定されているクラスの名前を取得
        NSString* leftViewClassName = [pRootNavController.topViewController description];
    
        // 左側のViewにトップメニューが表示されている場合
        if(![leftViewClassName isEqual:[self description]])
        {
            // 左側のViewを更新してファイル一覧を表示
            RootViewController_iPad* pRootViewController = (RootViewController_iPad*)pRootNavController.topViewController;
            pRootViewController.subDir = self.scanDirectory.scanDirectoryPath;
            pRootViewController.rootDir = self.scanDirectory.relativeDirectoryPathInScanFile;
            [pRootViewController updateView:ArrangeSelectTypeView didSelectRowAtIndexPath:nIndexPath scrollOffset:[self.tableView contentOffset]];
            selectIndexPath = nil;
            // 右側のViewを更新して画像プレビューを表示
            [self.navigationController pushViewController:pViewController animated:YES];
        }
        else
        {
            // フラグを初期化する(iPad対応)
            self.isFirstTap = NO;
            
            UINavigationController* pDetailNavController = [pAppDelegate.splitViewController.viewControllers objectAtIndex:1];
            
            // 右側の画面に詳細画面を既に表示している場合
            if ( [[[pDetailNavController viewControllers] lastObject] isKindOfClass: [PictureViewController_iPad class]] ) {
                // 画面を取り除く
                [pDetailNavController popViewControllerAnimated:NO];
            }

            // 詳細画面に表示
            [pDetailNavController pushViewController:pViewController animated:NO];

        }

        // 縦向き表示時のメニューPopOverが表示されていたら閉じる
        [self dismissMenuPopOver:YES];
        // iPad用
    }
}

//
// メモリ警告時
//
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];    
}

// iPad用
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
    [self.navigationItem setLeftBarButtonItem:nil animated:YES];
    if (barButtonItem != nil && bSetTitle && self.scanDirectory.isRootDirectory)
    {
        [self.navigationItem setLeftBarButtonItem:barButtonItem animated:YES];
    }
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

// 移動画面に遷移する
- (void)moveAction:(id)sender
{
    mArray = [NSMutableArray arrayWithArray:self.tableView.indexPathsForSelectedRows];
    if(mArray == nil)
    {
        return;
    }
    // 画面遷移
    MoveViewController* pMoveViewController;
    pMoveViewController = [[MoveViewController alloc] init];
    pMoveViewController.delegate = self;
    NSMutableArray *abc = [[NSMutableArray alloc] init ];
    NSMutableArray *name = [[NSMutableArray alloc] init ];
    
    NSInteger row = 0;    
    for (row = 0; row < [mArray count] ; row++)
    {
        // 選択ファイルの情報を取得
        NSString *path = @"";
        ScanData *scanData = nil;
        scanData = [manager loadScanDataAtIndexPath:[mArray objectAtIndex:row]];
        
        path = [self.scanDirectory.scanDirectoryPath stringByAppendingPathComponent:scanData.fname];
        
        // 選択しているファイル/フォルダ名を格納する
        [abc addObject:path];
        [name addObject:scanData.fname];
    }
    // 移動画面に渡す
    pMoveViewController.beforeMoveArray = abc;
    pMoveViewController.beforeMoveName = name;
    // 初回移動先は必ず/Documents/ScanFileであるため、scanDirectoryは渡さない
//    pMoveViewController.scanDirectory = self.scanDirectory;

    // 編集モードOFF
    [self setEditing:NO animated:NO];
    
    //    [self.navigationController pushViewController:pMoveViewController animated:YES];
    // モーダル表示
    UINavigationController *navigationController = [[UINavigationController alloc]initWithRootViewController:pMoveViewController];
    navigationController.navigationBar.barStyle = NAVIGATION_BARSTYLE;
    [navigationController setModalPresentationStyle:UIModalPresentationPageSheet];
    [self presentViewController:navigationController animated:YES completion:nil];


}

// 削除確認ダイアログを表示する
- (void)delAction:(id)sender
{
    mArray = [NSMutableArray arrayWithArray:self.tableView.indexPathsForSelectedRows];

    [self makeTmpExAlert:nil message:MSG_DEL_FILE_FOLDER_CONFIRM cancelBtnTitle:S_BUTTON_CANCEL okBtnTitle:MSG_BUTTON_OK tag:1 showFlg:YES];
    
}

// 名称変更画面に遷移する
- (void)nameChangeAction:(id)sender
{
    mArray = [NSMutableArray arrayWithArray:self.tableView.indexPathsForSelectedRows];

    // 選択ファイルの情報を取得
    ScanData *scanData = nil;
    scanData = [manager loadScanDataAtIndexPath:[mArray objectAtIndex:0]];
    
    // 編集モードOFF
    [self setEditing:NO animated:NO];
    
    // 画面遷移
    FileNameChangeViewController* pFileNameChangeViewController;
    pFileNameChangeViewController = [[FileNameChangeViewController alloc] init];
    fileNameChangeViewController = pFileNameChangeViewController;
    pFileNameChangeViewController.delegate = self;
    // 選択ファイルパス格納
    pFileNameChangeViewController.SelFilePath = [NSString stringWithFormat:@"%@/" , self.scanDirectory.scanDirectoryPath];
    
    // 選択ファイル名格納
    if(scanData.isDirectory)
    {
//        pFileNameChangeViewController.SelFileName = [scanData.fname substringFromIndex:4];
        // "DIR-"はないのでそのまま表示する
        pFileNameChangeViewController.SelFileName = scanData.fname;
        pFileNameChangeViewController.isDirectory = YES;
    }
    else
    {
        pFileNameChangeViewController.SelFileName = scanData.fname;
        pFileNameChangeViewController.isDirectory = NO;
    }
    
//    [self.navigationController pushViewController:pFileNameChangeViewController animated:YES];
    
    // プレビュー表示しているファイル名を保持する（ファイル名変更によるファイル存在チェックのため）
    self.previewFileName = [self getPreviewFileName];

    // モーダル表示
    UINavigationController *navigationController = [[UINavigationController alloc]initWithRootViewController:pFileNameChangeViewController];
    navigationController.navigationBar.barStyle = NAVIGATION_BARSTYLE;
    [navigationController setModalPresentationStyle:UIModalPresentationPageSheet];
    [self presentViewController:navigationController animated:YES completion:nil];


}

// フォルダ作成画面に遷移する
- (void)createFolderAction:(id)sender
{    
    // 編集モードOFF
    [self setEditing:NO animated:NO];
    
    // 画面遷移
    CreateFolderViewController* pCreateFolderViewController;
    pCreateFolderViewController = [[CreateFolderViewController alloc] init];
    pCreateFolderViewController.delegate = self;
    // 選択ファイルパス格納
    pCreateFolderViewController.scanDirectory = [[ScanDirectory alloc]initWithScanDirectoryPath:self.scanDirectory.scanDirectoryPath];
    
//    [self.navigationController pushViewController:pCreateFolderViewController animated:YES];

    // モーダル表示
    UINavigationController *navigationController = [[UINavigationController alloc]initWithRootViewController:pCreateFolderViewController];
    navigationController.navigationBar.barStyle = NAVIGATION_BARSTYLE;
    [navigationController setModalPresentationStyle:UIModalPresentationPageSheet];
    [self presentViewController:navigationController animated:YES completion:nil];
    

}

// アラートボタン押下処理
-(void)alertButtonPushed:(UIAlertController *)alertController tagIndex:(NSInteger)tagIndex buttonIndex:(NSInteger)buttonIndex
{
    [self alertButtonClicked:alertController tagIndex:tagIndex buttonIndex:buttonIndex];
    [self alertButtonDismiss:alertController tagIndex:tagIndex buttonIndex:buttonIndex];
}

-(void)alertButtonClicked:(UIAlertController *)alertController tagIndex:(NSInteger)tagIndex buttonIndex:(NSInteger)buttonIndex
{
    if(tagIndex == 1)
    {
        if(buttonIndex == 1)
        {
            NSInteger row = 0;
            
            //
            // ファイル削除
            //
            @autoreleasepool
            {
                NSString		*path;
                
                for (row = 0; row < [mArray count] ; row++)
                {
                    ScanData *scanData = nil;
                    scanData = [manager loadScanDataAtIndexPath:[mArray objectAtIndex:row]];
                    path = [self.scanDirectory.scanDirectoryPath stringByAppendingPathComponent:scanData.fname];
                    if(scanData.isDirectory){
                        ScanDirectory *selectedScanDirectory = [[ScanDirectory alloc]initWithScanDirectoryPath:path];
                        [ScanDirectoryUtility deleteDirectory:selectedScanDirectory];
                    }else{
                        ScanFile *selectedScanFile = [[ScanFile alloc]initWithScanFilePath:path];
                        [ScanFileUtility deleteFile:selectedScanFile];
                    }
                    DLog(@"削除しました");
                }
            }
            
            [self makeTmpExAlert:nil message:MSG_DEL_COMPLETE cancelBtnTitle:nil okBtnTitle:MSG_BUTTON_OK tag:2 showFlg:YES];
        }
    }
    
    if(tagIndex == 2)
    {
        [self setEditing:NO animated:NO];
        [manager reGetScanData];
        [self.tableView reloadData];
    }
    
}

-(void)alertButtonDismiss:(UIAlertController *)alertController tagIndex:(NSInteger)tagIndex buttonIndex:(NSInteger)buttonIndex
{
    if (tagIndex == 2)
    {
        // プレビュー表示しているファイルが存在するかチェックする
        BOOL isFileExists = [self isFileExistsPreviewFile];
        
        // ファイルが存在する場合
        if ( isFileExists )
        {
            // 左側の画面はそのまま
            return;
        }
        
        // ルートビューに戻す
        [self moveRootView];
    }
}

// 編集モードか否かを判別する
- (void)setEditing:(BOOL)editing animated:(BOOL)animated
{
    DLog(@"4-----setEditing ArrengeSelectFileViewController_iPad");
    [super setEditing:editing animated:animated];
    [self.tableView setEditing:editing animated:YES];

    // 編集モード時のみ、ツールバーを表示する
    if(editing)
    {
        [self.navigationController setToolbarHidden:NO animated:YES];
    }else
    {
        NSInteger row = 0;
        for (row = 0; row < [mArray count] ; row++)
        {
            // チェックボックス切り替え
            ScanDataCell *cell = (ScanDataCell*)[self.tableView cellForRowAtIndexPath:[mArray objectAtIndex:row]];
            
            cell.selectImgView.tag = 0;            
            [cell setImageModel];
        }
        
        [mArray removeAllObjects];
        
        // ボタンの設定を戻す
        moveBtn.enabled = NO;
        trashBtn.enabled = NO;
        nameChangeBtn.enabled = NO;
        folderCreationBtn.enabled = YES;
        
        [self.navigationController setToolbarHidden:YES animated:NO];
    
        //^^
        NSString* fullPath = [[NSUserDefaults standardUserDefaults] stringForKey: S_KEY_SELECT_FPATH];
        selectIndexPath = [manager indexOfScanDataWithFilePath: fullPath];
        // 指定の行を選択状態
        [self.tableView selectRowAtIndexPath:selectIndexPath animated:NO scrollPosition:UITableViewScrollPositionNone];
    }
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
    if (!self.tableView.tableHeaderView) {

        // Todo 並べ替え & 検索バーをテーブルのヘッダー部に表示する
        UIToolbar *sortAndSearchViewLeft = [[UIToolbar alloc] initWithFrame:CGRectMake(0.0, 0.0, self.view.frame.size.width, SEARCHBAR_HEIGHT + 4.0)];
        sortAndSearchViewLeft.barStyle = TOOLBAR_BARSTYLE;
        sortAndSearchViewLeft.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        UILabel *label = [[UILabel alloc] init];
        label.frame = CGRectMake(10.0, 48.0, self.view.frame.size.width - 10.0, 24.0);
        label.backgroundColor = [UIColor grayColor];
        label.textColor = [UIColor whiteColor];
        label.font = [UIFont fontWithName:@"AppleGothic" size:16];
        label.textAlignment = NSTextAlignmentLeft;
        label.adjustsFontSizeToFitWidth = NO;
        label.lineBreakMode = NSLineBreakByTruncatingMiddle;
        label.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleRightMargin;
        
        NSString *pstrText = self.scanDirectory.relativeDirectoryPathInScanFile;
        
        if(pstrText == nil || [pstrText isEqualToString:@""])
        {
            label.text = @"/";
        }
        else
        {
            label.text = pstrText;
        }
        UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0.0, 0.0, self.view.frame.size.width, 72.0)];
        //        UIView *searchView = [[UIView alloc] initWithFrame:CGRectMake(0.0, 0.0, self.view.frame.size.width, 44.0)];
        //    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0.0, 0.0, self.view.frame.size.width, 150.0)];
        headerView.backgroundColor = [UIColor grayColor];
        [headerView addSubview:label];
        // 検索バーをテーブルのヘッダー部に表示する
        //    if(!m_pSearchBar)
        if(!m_searchController)
        {
            // 検索コントローラー作成
            m_searchController = [[UISearchController alloc] initWithSearchResultsController:nil];
            m_searchController.delegate = self;
            m_searchController.dimsBackgroundDuringPresentation = YES; // 編集モード時に薄黒いビューを表示するかどうか
            m_searchController.searchBar.delegate = self;
            m_searchController.searchBar.frame = CGRectMake(SORTBUTTON_WIDTH, 1.0, self.view.frame.size.width - SORTBUTTON_WIDTH, SEARCHBAR_HEIGHT + 3.0);
            
            self.definesPresentationContext = YES;
            
            // searchBarの設定
            m_searchController.searchBar.showsCancelButton = NO;
            m_searchController.searchBar.placeholder = S_SEARCH_PLACEHOLDER;
            m_searchController.searchBar.keyboardType = UIKeyboardTypeDefault;
            if (isIOS7_1Later) {
                m_searchController.searchBar.keyboardAppearance = UIKeyboardAppearanceLight;
            }
            m_searchController.searchBar.barStyle = TOOLBAR_BARSTYLE;
            if([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0)
            {   // iOS7以上なら
                m_searchController.searchBar.searchBarStyle = UISearchBarStyleMinimal;
            }
            
        }
        else
        {
            m_searchController.searchBar.frame = CGRectMake(SORTBUTTON_WIDTH, 1.0, self.view.frame.size.width - SORTBUTTON_WIDTH, SEARCHBAR_HEIGHT + 3.0);
            m_searchController.searchBar.delegate = self;
            m_searchController.searchBar.showsCancelButton = NO;
            m_searchController.searchBar.placeholder = S_SEARCH_PLACEHOLDER;
            m_searchController.searchBar.keyboardType = UIKeyboardTypeDefault;
            if (isIOS7_1Later) {
                m_searchController.searchBar.keyboardAppearance = UIKeyboardAppearanceLight;
            }
            m_searchController.searchBar.barStyle = TOOLBAR_BARSTYLE;
            if([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0)
            {   // iOS7以上なら
                m_searchController.searchBar.searchBarStyle = UISearchBarStyleMinimal;
            }
            m_searchController.searchBar.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleRightMargin;
            
            m_searchController.delegate = self;
        }
        
        //並べ替え用ボタンを生成（現在の検索キーを表示)
        sortTypeButton = [UIButton buttonWithType: UIButtonTypeCustom];
        [sortTypeButton setExclusiveTouch: YES];
        sortTypeButton.frame = CGRectMake(0, 0, SORTBUTTON_WIDTH, SEARCHBAR_HEIGHT);
        sortTypeButton.titleLabel.font = [UIFont fontWithName:@"AppleGothic" size:16];
        sortTypeButton.titleLabel.textAlignment = NSTextAlignmentRight;
        sortTypeButton.titleLabel.baselineAdjustment = UIBaselineAdjustmentAlignBaselines;
        sortTypeButton.titleLabel.adjustsFontSizeToFitWidth = NO;
        
        [self setSortTypeButtonImage];
        
        sortTypeButton.titleLabel.textColor = [UIColor whiteColor];
        sortTypeButton.backgroundColor = [UIColor clearColor];
        
        [sortTypeButton addTarget:self action:@selector(showSortPopoverview:) forControlEvents:UIControlEventTouchUpInside];
        
        // 検索バーをテーブルのヘッダー部に表示する
        //    searchBar.keyboardType = UIKeyboardTypeDefault;
        //    searchBar.barStyle = UIBarStyleBlack;
        [sortAndSearchViewLeft addSubview:sortTypeButton];
        [headerView addSubview: sortAndSearchViewLeft];
        // Todo 並び替えボタン表示 end
        
        [headerView addSubview:m_searchController.searchBar];
        //    [searchView addSubview: searchController.searchBar];
        //    [headerView addSubview: searchView];
        //TableViewにヘッダー設定
        self.tableView.tableHeaderView = headerView;
        
    }else {
        
        // 戻るボタンで戻ってきた時用の対応
        [self setSortTypeButtonImage];
    }
}

- (void) showSortPopoverview: (UIButton*) button
{
    // 編集モードOFF
    [self setEditing:NO animated:NO];
    
    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController: self.sortMenuViewController];
    
    UIPopoverController *popover = [[UIPopoverController alloc] initWithContentViewController: navigationController];
    self.sortViewPopoverController = popover;
    
    // Ensure the popover is not dismissed if the user taps in the search bar.
    //    popover.passthroughViews = [NSArray arrayWithObject:button];
    
    // Display the search results controller popover.
    [sortViewPopoverController presentPopoverFromRect:[button bounds]
                                               inView: button
                             permittedArrowDirections: UIPopoverArrowDirectionUp animated:YES];
    
}

// プレビュー表示しているファイル名を取得する
- (NSString *)getPreviewFileName
{
    SharpScanPrintAppDelegate* pAppDelegate = (SharpScanPrintAppDelegate*)[[UIApplication sharedApplication] delegate];
    
    if (pAppDelegate.splitViewController.viewControllers.count <= 1)
    {
        // ありえないはず
        return NO;
    }
    
    UINavigationController* pDetailNavController = [pAppDelegate.splitViewController.viewControllers objectAtIndex:1];
    if ( ! [pDetailNavController.visibleViewController isKindOfClass: [ArrangePictViewController_iPad class]] )
    {
        // ありえないはず
        return NO;
    }
    
    ArrangePictViewController_iPad * arrangePictViewController = nil;
    arrangePictViewController = (ArrangePictViewController_iPad* )pDetailNavController.visibleViewController;
    
    return arrangePictViewController.SelFilePath;
}

// プレビュー表示しているファイルが存在するかチェックする
- (BOOL)isFileExistsPreviewFile
{
    // プレビュー表示しているファイル名を取得する
    NSString * previewFileName = [self getPreviewFileName];
    
    NSFileManager * fileManager = [NSFileManager defaultManager];
    
    // ファイル存在チェック
    BOOL isFileExists = [fileManager fileExistsAtPath: previewFileName];

    return isFileExists;
}

// ルートビューに戻す
- (void)moveRootView
{
    SharpScanPrintAppDelegate* pAppDelegate = (SharpScanPrintAppDelegate*)[[UIApplication sharedApplication] delegate];

    if (pAppDelegate.splitViewController.viewControllers.count == 0) {
        // ありえないはず
        return;
    }
    
    // 左側のViewを取得
    UINavigationController* pRootNavController = [pAppDelegate.splitViewController.viewControllers objectAtIndex:0];
    NSArray * rootViewControllers = pRootNavController.viewControllers;
    
    if (rootViewControllers.count == 0)
    {
        // ありえないはず
        return;
    }
    
    if ( ! [[rootViewControllers objectAtIndex: 0] isKindOfClass: [RootViewController_iPad class]] )
    {
        // ありえないはず
        return;
    }

    RootViewController_iPad* rootViewController = (RootViewController_iPad*)[rootViewControllers objectAtIndex:0];
    
    // 左側のViewを遷移前の状態に戻す
    [rootViewController popRootView];    

    //// 縦向き表示時のメニューPopOverが表示されていたら閉じる
    //[self dismissMenuPopOver:NO];
}

#pragma mark - ViewControllerDelegate
#pragma mark   CreateFolderViewControllerDelegate
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

#pragma mark MoveViewControllerDelegate
-(void) move:(UIViewController*)viewController didMovedSuccess:(BOOL)bSuccess;
{
    
    MoveViewController* moveView = (MoveViewController*)viewController;
    
    // フォルダ作成
    if(bSuccess){
        // リスト更新
        [self viewWillAppear:NO];
    }
    
    // モーダルを閉じる
    [moveView dismissViewControllerAnimated:YES completion:nil];
    
    // デリゲートをクリア
    moveView.delegate = nil;
    
    // プレビュー表示しているファイルが存在するかチェックする
    BOOL isFileExists = [self isFileExistsPreviewFile];
    
    // ファイルが存在する場合
    if ( isFileExists )
    {
        // 左側の画面はそのまま
        return;
    }
    
    // ルートビューに戻す
    [self moveRootView];

}

#pragma mark FileNameChangeViewControllerDelegate
-(void)nameChange:(UIViewController*)viewController didNameChangeSuccess:(BOOL)bSuccess
{
    FileNameChangeViewController* nameChangeView = (FileNameChangeViewController*)viewController;
  
    // フォルダ作成
    if(bSuccess){
        // リスト更新
        [self viewWillAppear:NO];
    }
    
    // モーダルを閉じる
    [nameChangeView dismissViewControllerAnimated:YES completion:nil];
    
    // デリゲートをクリア
    nameChangeView.delegate = nil;
    
    NSFileManager * fileManager = [NSFileManager defaultManager];
    
    // プレビュー表示しているファイルが存在するかチェックする
    BOOL isFileExists = [fileManager fileExistsAtPath: self.previewFileName];
    
    // ファイルが存在する場合
    if ( isFileExists )
    {
        // 左側の画面はそのまま
        return;
    }
    
    // ルートビューに戻す
    [self moveRootView];
}

#pragma mark - UISearchBarDelegate
// キーボードのSearchボタンタップ時に呼ばれる
-(void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    DLog(@"searchBarSearchButtonClicked ArrengeSelectFileViewController_iPad");
    // iPad用
    SharpScanPrintAppDelegate* pAppDelegate = (SharpScanPrintAppDelegate*)[[UIApplication sharedApplication] delegate];
    
    SearchResultViewController_iPad* pSearchResultViewController_iPad;
    
    pSearchResultViewController_iPad = [[SearchResultViewController_iPad alloc]init];
    pSearchResultViewController_iPad.pstrSearchKeyword = searchBar.text;
    pSearchResultViewController_iPad.PrevViewID = ArrangeSelectTypeView;
    pSearchResultViewController_iPad.bCanDelete = YES;
    pSearchResultViewController_iPad.arrangePreviewFileName = self.previewFileName;
    ScanDirectory *localScanDirectory = [[ScanDirectory alloc]initWithScanDirectoryPath:self.scanDirectory.scanDirectoryPath];
    pSearchResultViewController_iPad.scanDirectory = localScanDirectory;
    
    UINavigationController* pRootNavController = [pAppDelegate.splitViewController.viewControllers objectAtIndex:0];
    //左側のViewに設定されているクラスの名前を取得
    NSString* leftViewClassName = [pRootNavController.topViewController description];
    
    // 左側のViewに自身が表示されていない場合
    if(![leftViewClassName isEqual:[self description]])
    {
        pSearchResultViewController_iPad.bSetTitle = YES;
    }
    
    [self.navigationController pushViewController:pSearchResultViewController_iPad animated:YES];

    // 検索バーを下げる
    [m_searchController setActive:NO];
    
    [self SetHeaderView];
}

// 検索バーのキャンセルボタンを押下時に呼ばれる
-(void)searchBarCancelButtonClicked:(UISearchBar *)searchBar
{    
    DLog(@"searchBarCancelButtonClicked ArrengeSelectFileViewController_iPad");
    searchBar.frame = (CGRect){SORTBUTTON_WIDTH, 1.0, self.view.frame.size.width - SORTBUTTON_WIDTH, SEARCHBAR_HEIGHT + 3.0};
    sortTypeButton.hidden = NO;

    [self SetHeaderView];
    
}

#pragma mark - UISearchControllerDelegate

// 検索モードになる前に呼ばれる
- (void)presentSearchController:(UISearchController *)searchController {
    
    // 編集モードOFF
    [self setEditing:NO animated:NO];
    
    sortTypeButton.hidden = YES;
    
    // 検索バーのframe調整
    searchController.searchBar.frame = (CGRect){0.0, 0.0, self.view.frame.size.width, searchController.searchBar.frame.size.height};
}

// 検索モードになる直前に呼ばれる
- (void)willPresentSearchController:(UISearchController *)searchController {
    // do something before the search controller is presented
}

// 検索モードになった後に呼ばれる
- (void)didPresentSearchController:(UISearchController *)searchController {
    // do something after the search controller is presented
}

// 検索モードが解除されるときに呼ばれる
- (void)willDismissSearchController:(UISearchController *)searchController {
    
    // サーチバーの横幅調整
    searchController.searchBar.frame = CGRectMake(SORTBUTTON_WIDTH, 0.0, self.view.frame.size.width - SORTBUTTON_WIDTH, SEARCHBAR_HEIGHT);
    
    sortTypeButton.hidden = NO;
    
    [self.tableView insertSubview:m_searchController.searchBar aboveSubview:self.tableView];
    
    [UIView commitAnimations];
    
}
// 検索モードが解除された後に呼ばれる
- (void)didDismissSearchController:(UISearchController *)searchController {
    
}

// iPadでキーボードを閉じるボタン押下時の処理
- (void)keyboardDidHide:(NSNotification*)notification
{
    bEndActiveAtKBNotification = NO;
    if (m_searchController.active) {
        [m_searchController setActive:NO];
        bEndActiveAtKBNotification = YES;   // この通知処理にて検索モードを終了したフラグを設定 回転時の処理に使用する。
    }

}

//- (BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar{ // return NO to not become first responder
//    DLog(@"1-----searchBarShouldBeginEditing");
//    DLog(@"a searchBar %@",searchBar);
//    return YES;
//}
//- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar{ // called when text starts editing
//    DLog(@"2-----searchBarTextDidBeginEditing");
//    DLog(@"b searchBar %@",searchBar);
//}
//- (BOOL)searchBarShouldEndEditing:(UISearchBar *)searchBar{ // return NO to not resign first responder
//    DLog(@"searchBarShouldEndEditing");
//    DLog(@"c searchBar %@",searchBar);
//    return YES;
//}
//- (void)searchBarTextDidEndEditing:(UISearchBar *)searchBar{ // called when text ends editing
//    DLog(@"searchBarTextDidEndEditing");
//    DLog(@"d searchBar %@",searchBar);
//}
//
//// called when the table is created destroyed, shown or hidden. configure as necessary.
//- (void)searchDisplayController:(UISearchDisplayController *)controller didLoadSearchResultsTableView:(UITableView *)tableView{
//    DLog(@"5-----didLoadSearchResultsTableView");
//
//}
//- (void)searchDisplayController:(UISearchDisplayController *)controller willUnloadSearchResultsTableView:(UITableView *)tableView{
//    
//}
//
//// called when table is shown/hidden
//- (void)searchDisplayController:(UISearchDisplayController *)controller willShowSearchResultsTableView:(UITableView *)tableView{
//    DLog(@"willShowSearchResultsTableView");
//    DLog(@"c searchBar %@",controller.searchBar);
// 
//}
////- (void)searchDisplayController:(UISearchDisplayController *)controller didShowSearchResultsTableView:(UITableView *)tableView{
////    
////}
//- (void)searchDisplayController:(UISearchDisplayController *)controller willHideSearchResultsTableView:(UITableView *)tableView{
//    DLog(@"willHideSearchResultsTableView");
//    DLog(@"c searchBar %@",controller.searchBar);
//   
//}
//- (void)searchDisplayController:(UISearchDisplayController *)controller didHideSearchResultsTableView:(UITableView *)tableView{
//    DLog(@"searchDisplayController");
//    DLog(@"c searchBar %@",controller.searchBar);
//
//}
//
//// return YES to reload table. called when search string/option changes. convenience methods on top UISearchBar delegate methods
////- (BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchString:(NSString *)searchString{
////    return YES;
////
////}
//- (BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchScope:(NSInteger)searchOption{
//    DLog(@"shouldReloadTableForSearchScope");
//    DLog(@"c searchBar %@",controller.searchBar);
//    return YES;
// 
//}


// indicatorを生成する
- (void)indicatorInit{
    
    // indicator初期化
    UIActivityIndicatorView *ai = [[UIActivityIndicatorView alloc] init];
    ai.frame = CGRectMake(0, 0, 50, 50);
    ai.center = self.view.center;
    // indicatorのスタイルを設定
    ai.activityIndicatorViewStyle = UIActivityIndicatorViewStyleWhiteLarge;
    // indicatorの色を設定
    ai.color = [UIColor grayColor];
    
    // inidicatorスタート
    [ai startAnimating];
    
    // indicatorを追加
    [self.view addSubview:ai];
    
    self.indicator = ai;
}

// indicatorを開始する
- (void)indicatorStart{
    if (![self.indicator isAnimating]) {
        // スタート
        [self indicatorInit];
    }
}

// indicatorを終了する
- (void)indicatorFinish{
    if ([self.indicator isAnimating]) {
        // indicatorの解放
        [self.indicator stopAnimating];
        [self.indicator removeFromSuperview];
    }
}

// 時間がかかる処理をバックグラウンドで実行するためのメソッド
- (void)lateProcessing{
    // メインスレッドで結果を反映
    [self performSelectorOnMainThread:@selector(executeLateProcessing) withObject:nil waitUntilDone:YES];
}

// 実行メソッド
- (void)executeLateProcessing{
    if(manager != nil)
    {
        manager.fullPath = self.scanDirectory.scanDirectoryPath;
        [manager reGetScanData];
    }
    // リロードと選択行解除(編集モードの時はしない)
    if (!self.tableView.editing) {
        [self.tableView reloadData];
        [self.tableView deselectRowAtIndexPath:[self.tableView indexPathForSelectedRow] animated:YES];
    }
    
    SharpScanPrintAppDelegate* pAppDelegate = (SharpScanPrintAppDelegate*)[[UIApplication sharedApplication] delegate];
    UINavigationController* pRootNavController = [pAppDelegate.splitViewController.viewControllers objectAtIndex:0];
    //左側のViewに設定されているクラスの名前を取得
    NSString* leftViewClassName = [pRootNavController.topViewController description];
    NSString* selectDir = [[NSUserDefaults standardUserDefaults] objectForKey:S_KEY_SELECT_DIR];
    if (selectIndexPath != nil && ((self.scanDirectory.isRootDirectory && selectDir == nil) || [self.scanDirectory.relativeDirectoryPathInScanFile  isEqualToString:selectDir]))
    {
        //^^
        NSString* fullPath = [[NSUserDefaults standardUserDefaults] stringForKey: S_KEY_SELECT_FPATH];
        selectIndexPath = [manager indexOfScanDataWithFilePath: fullPath];
        
        // 左側のViewにこのクラスが表示されている場合
        if([leftViewClassName isEqual:[self description]])
        {
            if (!self.tableView.editing) {  // 編集モードではない場合
                // 指定の行を選択状態
                [self.tableView selectRowAtIndexPath:selectIndexPath animated:NO scrollPosition:UITableViewScrollPositionNone];
                // 指定の位置までスクロール
                if(selectIndexPath.section)
                {
                    if([[[UIDevice currentDevice] systemVersion] floatValue] < 7.0)
                    {   // iOS7より前の場合
                        [self.tableView scrollToRowAtIndexPath:selectIndexPath atScrollPosition:UITableViewScrollPositionTop animated:NO];
                    }
                }
                else
                {
                    //0件の場合
                    [self.tableView setContentOffset:lastScrollOffSet];
                }
            }
            
        }
    }
    // iPad用
    // 縦表示の時はメニューボタンを表示
    [pAppDelegate setPortraitMenuButton];
    // iPad用
    
    // tap時のイベント
    UITapGestureRecognizer *tapRecognizer = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(ClickEventOnBlackAlpha:)];
    [tapRecognizer setNumberOfTapsRequired:1];
    [tapRecognizer setDelegate:self];
    
    if([leftViewClassName isEqual:[self description]])
    {
        if(m_searchController.active){
            m_searchController.searchBar.frame = (CGRect){0, 1.0, self.view.frame.size.width, SEARCHBAR_HEIGHT + 3.0};
            if(!sortTypeButton.hidden){
                sortTypeButton.hidden = YES;
            }
        }else{
            sortTypeButton.hidden = NO;
            m_searchController.searchBar.frame = (CGRect){SORTBUTTON_WIDTH, 1.0, self.view.frame.size.width - SORTBUTTON_WIDTH, SEARCHBAR_HEIGHT + 3.0};
        }
    }
    
    // 実データ(ファイル、ディレクトリ)が存在せず、CacheDirectoryのみ残っている場合に削除する
    ScanDirectory *pScanDirectory = self.scanDirectory;
    [ScanDirectoryUtility removeCacheDirectoriesNotExistScanData:pScanDirectory];
    
    // indicator終了させる
    [self indicatorFinish];
}


// ソートタイプボタンの画像を設定する
- (void)setSortTypeButtonImage {
    
    switch ([CommonUtil scanDataSortType]) {
        case SCANDATA_FILEDATE:
            if([CommonUtil scanDataSortDirectionType] == SCANDATA_ASC)
            {
                [sortTypeButton setBackgroundImage:[UIImage imageNamed:S_ICON_SORTTIMEASC] forState:UIControlStateNormal];
            }
            else
            {
                [sortTypeButton setBackgroundImage:[UIImage imageNamed:S_ICON_SORTTIMEDES] forState:UIControlStateNormal];
            }
            break;
        case SCANDATA_FILENAME:
            if([CommonUtil scanDataSortDirectionType] == SCANDATA_ASC)
            {
                [sortTypeButton setBackgroundImage:[UIImage imageNamed:S_ICON_SORTFILEASC] forState:UIControlStateNormal];
            }
            else
            {
                [sortTypeButton setBackgroundImage:[UIImage imageNamed:S_ICON_SORTFILEDES] forState:UIControlStateNormal];
            }
            break;
        case SCANDATA_FILESIZE:
            if([CommonUtil scanDataSortDirectionType] == SCANDATA_ASC)
            {
                [sortTypeButton setBackgroundImage:[UIImage imageNamed:S_ICON_SORTSIZEASC] forState:UIControlStateNormal];
            }
            else
            {
                [sortTypeButton setBackgroundImage:[UIImage imageNamed:S_ICON_SORTSIZEDES] forState:UIControlStateNormal];
            }
            break;
        case SCANDATA_FILETYPE:
            if([CommonUtil scanDataSortDirectionType] == SCANDATA_ASC)
            {
                [sortTypeButton setBackgroundImage:[UIImage imageNamed:S_ICON_SORTTYPEASC] forState:UIControlStateNormal];
            }
            else
            {
                [sortTypeButton setBackgroundImage:[UIImage imageNamed:S_ICON_SORTTYPEDES] forState:UIControlStateNormal];
            }
        default:
            break;
    }
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
