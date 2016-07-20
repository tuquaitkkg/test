
#import "AdvancedSearchResultViewController_iPad.h"
#import "SearchResultViewController_iPad.h"
#import "CommonUtil.h"
#import "Define.h"
#import "PictureViewController_iPad.h"
#import "PrintPictViewController_iPad.h"
#import "SendMailPictViewController_iPad.h"
#import "SendExSitePictViewController_iPad.h"
#import "ArrangePictViewController_iPad.h"
#import "ScanDataCell.h"
#import "ScanDataManager.h"
#import <MessageUI/MessageUI.h> // メールの設定確認
// iPad用
#import "RootViewController_iPad.h"
#import "SharpScanPrintAppDelegate.h"
#import "AdvancedSearchViewController.h"

@interface AdvancedSearchResultViewController_iPad ()

// 複数印刷対応_iPad
@property (nonatomic,strong) UIBarButtonItem *closeButton;
@property (nonatomic,strong) UIBarButtonItem *multiPrintButton;
@property (nonatomic,strong) UIBarButtonItem *cancelButton;
@property (nonatomic,strong) UIBarButtonItem *enterButton;
@property (nonatomic,assign) BOOL multiPrintFlag;
@property (nonatomic,assign) BOOL isFirstTap; // セルをタップ済みかどうか(連打不可対応)
- (void)closeButtonPushed:(id)sender;
- (void)multiPrintButtonPushed:(id)sender;
- (void)cancelButtonPushed:(id)sender;
- (void)enterButtonPushed:(id)sender;

@end

@implementation AdvancedSearchResultViewController_iPad

@synthesize PrevViewID = m_nPrevViewID;
@synthesize bSetTitle = m_bSetTitle; // iPad用
@synthesize selectIndexPath; // iPad用
@synthesize lastScrollOffSet; // iPad用
@synthesize baseDir;								// ファイルパス
@synthesize scanDirectory;

@synthesize bCanDelete; // iPad用
@synthesize pstrSearchKeyword;                  // 検索文字
@synthesize bSubFolder;                         // 検索範囲(サブフォルダーを含む)
@synthesize bFillterFolder;                     // 検索対象(フォルダー)
@synthesize bFillterPdf;                        // 検索対象(PDF)
@synthesize bFillterTiff;                       // 検索対象(TIFF)
@synthesize bFillterImage;                      // 検索対象(JPEG,PNG)
@synthesize bFillterOffice;                     // 検索対象(OFFICE)
@synthesize sortViewPopoverController;
@synthesize sortMenuViewController;
@synthesize sessionViewController;
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

- (void)viewDidLoad
{
    DLog(@"viewDidLoad     AdvancedSearchResultViewController_iPad");
    [super viewDidLoad];
    
    self.tableView.rowHeight = N_HEIGHT_SEL_FILE;
    
    // UINavigationBar 44px のずれを無くす
    self.navigationController.navigationBar.translucent = NO;
    self.navigationController.navigationBar.barStyle = NAVIGATION_BARSTYLE;

    if(!self.bSetTitle)
    {
        // タイトル非表示
        self.navigationItem.title = @"";
    }
    
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
    
    // ScanDataManagerクラス生成
    m_pScanMgr = [[ScanDataManager alloc]init];
    
    m_pScanMgr.fullPath = self.scanDirectory.scanDirectoryPath;
    m_pScanMgr.IsSearchView = YES;
    m_pScanMgr.IsAdvancedSearch = YES;
    m_pScanMgr.IsSubFolder = self.bSubFolder;
    m_pScanMgr.IsFillterFolder = self.bFillterFolder;
    m_pScanMgr.IsFillterPdf = self.bFillterPdf;
    m_pScanMgr.IsFillterTiff = self.bFillterTiff;
    m_pScanMgr.IsFillterImage = self.bFillterImage;
    m_pScanMgr.IsFillterOffice = self.bFillterOffice;
    m_pScanMgr.searchKeyword = self.pstrSearchKeyword;
//    self.sessionViewController.pstrSearchKeyword = self.pstrSearchKeyword;
//    [m_pScanMgr reGetScanData];
//    // タイトル設定
//    [self updateTitle];
    
    // TableViewのスクロール初期値設定
    self.tableView.scrollEnabled = YES;
    
    // 再描画
//    [self.tableView reloadData];
    
    // 整理する画面の場合
    if(self.PrevViewID == ArrangeSelectTypeView)
    {
        // 編集モード中もセルの選択を有効にする
        self.tableView.allowsSelectionDuringEditing = YES;
        
        // 初期化
        mArray = [[NSMutableArray alloc]init];
        
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
        
        // 初期表示
        moveBtn.enabled = NO;
        trashBtn.enabled = NO;
        nameChangeBtn.enabled = NO;
        
        // ツールバーに追加
        NSArray *items = [NSArray arrayWithObjects:spaceBtn,moveBtn,spaceBtn,trashBtn,spaceBtn,nameChangeBtn,spaceBtn,nil];
        self.toolbarItems = items;
        
        [self.navigationController setToolbarHidden:YES animated:YES];
        
        // 編集ボタン追加
        UIBarButtonItem *barItemEditButtonItem = self.editButtonItem;
        [self.navigationItem setRightBarButtonItem:barItemEditButtonItem];
    }    
    else if ([self isShareToolBarPrevViewID]) {
        // 複数ファイル共有
        [self initShareToolBar];
    }
    
    //sort用のpopoverの設定
    self.sortMenuViewController = [[SelectFileSortPopViewController_ipad alloc] initWithStyle: UITableViewStyleGrouped];
    self.sortMenuViewController.delegate = self;
    
    self.previousOrientation = [[UIDevice currentDevice] orientation];
    //回転時にrotateActionが呼ばれるようにする
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didChangedOrientation:)
                                                 name:UIDeviceOrientationDidChangeNotification object:nil];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
}

//
// アプリケーションの終了直前に呼ばれるメソッド
//

- (void)viewWillAppear:(BOOL)animated
{
    DLog(@"viewWillAppear     AdvancedSearchResultViewController_iPad");
    
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

    if(m_searchController.active)
    {
        [self willDismissSearchController:m_searchController];
    }
    
    [self SetHeaderView];
    
    // indicatorを開始する
    [self indicatorStart];
    
    // 時間がかかる処理をバックグラウンドで実行する
    [self performSelectorInBackground:@selector(lateProcessing) withObject:nil];
    
//    m_pScanMgr.fullPath = self.scanDirectory.scanDirectoryPath;
//    m_pScanMgr.IsSearchView = YES;
//    m_pScanMgr.IsAdvancedSearch = YES;
//    m_pScanMgr.IsSubFolder = self.bSubFolder;
//    m_pScanMgr.IsFillterFolder = self.bFillterFolder;
//    m_pScanMgr.IsFillterPdf = self.bFillterPdf;
//    m_pScanMgr.IsFillterTiff = self.bFillterTiff;
//    m_pScanMgr.IsFillterImage = self.bFillterImage;
//    m_pScanMgr.IsFillterOffice = self.bFillterOffice;
//    m_pScanMgr.searchKeyword = self.pstrSearchKeyword;
//    [m_pScanMgr reGetScanData];
//    
//    [self.tableView reloadData];
//    
//    [super viewWillAppear:animated];
//    //^^
//    NSString* fullPath = [[NSUserDefaults standardUserDefaults] stringForKey: S_KEY_SELECT_FPATH];
//    selectIndexPath = [m_pScanMgr indexOfScanDataWithFilePath: fullPath];
//    
//    // 選択状態解除
//    [self.tableView deselectRowAtIndexPath:[self.tableView indexPathForSelectedRow] animated:YES];
//    SharpScanPrintAppDelegate* pAppDelegate = (SharpScanPrintAppDelegate*)[[UIApplication sharedApplication] delegate];
//    UINavigationController* pRootNavController = [pAppDelegate.splitViewController.viewControllers objectAtIndex:0];
//    //左側のViewに設定されているクラスの名前を取得
//    NSString* leftViewClassName = [pRootNavController.topViewController description];
//    NSString* selectDir = [[NSUserDefaults standardUserDefaults] objectForKey:S_KEY_SELECT_DIR];
////    if (selectIndexPath != nil && ((self.rootDir == nil && selectDir == nil) || [self.rootDir isEqualToString:selectDir]))
//    if (selectIndexPath != nil && ((self.scanDirectory.isRootDirectory && selectDir == nil) || [self.scanDirectory.relativeDirectoryPathInScanFile isEqualToString:selectDir]))
//    {
// 
//        
//        // 左側のViewにこのクラスが表示されている場合
//        if([leftViewClassName isEqual:[self description]])
//        {
//            // 指定の行を選択状態
//            [self.tableView selectRowAtIndexPath:selectIndexPath animated:NO scrollPosition:UITableViewScrollPositionNone];
//            // 指定の位置までスクロール
//            if(selectIndexPath.section)
//            {
//                [self.tableView scrollToRowAtIndexPath:selectIndexPath atScrollPosition:UITableViewScrollPositionTop animated:NO];
//            }
//            else
//            {   
//                //0件の場合
//                [self.tableView setContentOffset:lastScrollOffSet];
//            }
//        }
//    }
//    // 左側のViewにこのクラスが表示されている場合
//    if([leftViewClassName isEqual:[self description]])
//    {
//        if(searchController.active){
//            m_pbtnAdvancedSearch.hidden = YES;
//            searchController.searchBar.frame = (CGRect){0, 1.0, self.view.frame.size.width, SEARCHBAR_HEIGHT + 3.0};
//            if(!sortTypeButton.hidden){
//                sortTypeButton.hidden = YES;
//            }
//        }else{
//            sortTypeButton.hidden = NO;
//            searchController.searchBar.frame = (CGRect){SORTBUTTON_WIDTH, 1.0, self.view.frame.size.width - SORTBUTTON_WIDTH, SEARCHBAR_HEIGHT + 3.0};
//        }
//    }
//    
//    if (self.PrevViewID == PV_PRINT_SELECT_FILE_CELL) {
//        // 複数印刷対応_iPad
//        self.closeButton = [[UIBarButtonItem alloc]initWithTitle:S_BUTTON_CLOSE style:UIBarButtonItemStyleBordered target:self action:@selector(closeButtonPushed:)];
//        [self.navigationItem setRightBarButtonItem:self.closeButton];
//        self.multiPrintButton = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:S_ICON_MULTIPLE] style:UIBarButtonItemStyleBordered target:self action:@selector(multiPrintButtonPushed:)];
//        self.cancelButton = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:S_ICON_PRINT_CANCEL] style:UIBarButtonItemStyleBordered target:self action:@selector(cancelButtonPushed:)];
//        self.enterButton = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:S_ICON_PRINT_DECIDE] style:UIBarButtonItemStyleBordered target:self action:@selector(enterButtonPushed:)];
//        [self updateNavigationBarButton];
//    }
}

// 複数印刷対応_iPad
- (void)updateNavigationBarButton {
    if (self.PrevViewID == PV_PRINT_SELECT_FILE_CELL) {
        //スペーサー
        UIBarButtonItem* flexSpacer = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
        
        if (self.multiPrintFlag) {
            self.tableView.editing = YES;
            NSArray *toolBarItems = @[flexSpacer,self.cancelButton,flexSpacer,self.enterButton,flexSpacer];
            self.toolbarItems = toolBarItems;
        } else {
            self.tableView.editing = NO;
            NSArray *toolBarItems = @[flexSpacer,self.multiPrintButton,flexSpacer];
            self.toolbarItems = toolBarItems;
        }
    }
}

// 複数印刷対応_iPad
- (void)back {
    [self.navigationController popViewControllerAnimated:YES];
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

    //iPad用
    //[self.tableView reloadData];
    // popOverが開かれていたら閉じる
    if(m_popOver != nil)
    {
        [m_popOver dismissPopoverAnimated:NO];
        m_popOver = nil;
    }
    //iPad用
}

// iPad用
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // 横向きの場合
    if(interfaceOrientation == UIInterfaceOrientationLandscapeLeft || interfaceOrientation == UIInterfaceOrientationLandscapeRight)
    {
        // 縦向き表示時のメニューPopOverが表示されていたら閉じる
        [self dismissMenuPopOver:NO];
    }
    
    return YES;
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
        
        if (activityViewController) {   // 表示されてなくても通るが動作には影響しない
            [activityViewController dismissViewControllerAnimated:YES completion:nil];  // 複数ファイル共有閉じる
        }
        
        [self dismissMenuPopOver:NO];
        // キーボードを消す
        if(m_searchController.active){
            [self.view endEditing:YES];
            // 並び替えのポップオーバーを表示中に回転すると、検索Viewの長さがおかしくなる問題に対応
            m_searchController.searchBar.frame = (CGRect){0.0, 1.0, self.view.frame.size.width, SEARCHBAR_HEIGHT + 3.0};
        } else {
            // 並び替えのポップオーバーを表示中に回転すると、検索Viewの長さがおかしくなる問題に対応
            m_searchController.searchBar.frame = (CGRect){SORTBUTTON_WIDTH, 1.0, self.view.frame.size.width - (SORTBUTTON_WIDTH + ADVANCEDSEARCHBUTTON_WIDTH), SEARCHBAR_HEIGHT + 3.0};
            m_pbtnAdvancedSearch.frame = CGRectMake(self.view.frame.size.width - ADVANCEDSEARCHBUTTON_WIDTH, 0.0, ADVANCEDSEARCHBUTTON_WIDTH, SEARCHBAR_HEIGHT);
        }
        if(self.sortViewPopoverController)
        {
            [self.sortViewPopoverController dismissPopoverAnimated:YES];
        }
    }
    self.previousOrientation = orientation;
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

-(void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)FromInterfaceOrientation
{
    if (FromInterfaceOrientation == UIInterfaceOrientationPortrait ||
        FromInterfaceOrientation == UIInterfaceOrientationPortraitUpsideDown)
	{
		// 縦向き
	}
	else
	{
		// 横向きから縦向きに変更
//        if(self.subDir != nil)
//        {
            // フォルダ階層遷移した為、メニューボタンは削除
            [self setPortraitMenu:nil];
            // 戻るボタンを表示
            UIBarButtonItem * barItemBack = [UIBarButtonItem new];
            barItemBack.title = S_BUTTON_BACK;
            self.navigationItem.backBarButtonItem = barItemBack;
//        }
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
    [self SetHeaderView];

}

-(void)viewWillLayoutSubviews
{
    // didRotateFromInterfaceOrientation:が呼ばれないのでここでサーチバーの調整をする
    if (m_searchController.isActive) {
        m_searchController.searchBar.frame = (CGRect){0.0, 1.0, self.view.frame.size.width, SEARCHBAR_HEIGHT + 3.0};
    } else {
        m_searchController.searchBar.frame = (CGRect){SORTBUTTON_WIDTH, 1.0, self.view.frame.size.width - (SORTBUTTON_WIDTH + ADVANCEDSEARCHBUTTON_WIDTH), SEARCHBAR_HEIGHT + 3.0};
        m_pbtnAdvancedSearch.frame = CGRectMake(self.view.frame.size.width - ADVANCEDSEARCHBUTTON_WIDTH, 0.0, ADVANCEDSEARCHBUTTON_WIDTH, SEARCHBAR_HEIGHT);
    }
}

-(void)viewWillDisappear:(BOOL)animated
{
    
    if ([self.delegate respondsToSelector:@selector(willDisAppearAdvancedSearchResultViewController:)]) {
        [self.delegate willDisAppearAdvancedSearchResultViewController:self];
    }
    
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


#pragma mark - Table view data source

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {

    // ファイル印刷の場合
    if (self.PrevViewID == PPV_PRINT_SELECT_FILE_CELL || [self isShareToolBarPrevViewID]) {
        ScanData *scanData = nil;
        scanData = [m_pScanMgr loadScanDataAtIndexPath:indexPath];
        
        if ([scanData isDirectory]) {
            ScanDataCell *cell = (ScanDataCell *)[tableView cellForRowAtIndexPath:indexPath];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            if (self.tableView.editing) {
                cell.accessoryType = UITableViewCellAccessoryNone;
            } else {
                cell.accessoryType = TABLE_CELL_ACCESSORY;
            }
            return NO;
        }
        return YES;
    } else {
        return YES;
    }
}

// テーブルビュー セクション数設定
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return [m_pScanMgr countOfScanData];
}

// テーブルビュー セクション内の行数設定
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{    
    // Return the number of rows in the section.
    return [[m_pScanMgr loadScanDataAtSection:section] count];
}

// テーブルビュー セクションのタイトル設定
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    if ([[m_pScanMgr loadScanDataAtSection:section] count] > 0)
    {
        // yyyy年mm月のフォーマット表示
        NSString *TitleChar = [[[m_pScanMgr loadScanDataAtSection:section] objectAtIndex:0] crdate_yymm ];
        
        // ディレクトリの場合、セクションのタイトルは"フォルダー"
        if([[[m_pScanMgr loadScanDataAtSection:section] objectAtIndex:0] isDirectory ])
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
                    return [[[m_pScanMgr loadScanDataAtSection:section] objectAtIndex:0] fileType];
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
//    if ([[m_pScanMgr loadScanDataAtSection:section] count] > 0)
//    {
//        // yyyy年mm月のフォーマット表示
//        NSString *TitleChar = [[[m_pScanMgr loadScanDataAtSection:section] objectAtIndex:0] crdate_yymm ];
//        
//        // ディレクトリの場合、セクションのタイトルは"フォルダー"
//        if([[[m_pScanMgr loadScanDataAtSection:section] objectAtIndex:0] isDirectory ])
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
//
// テーブルビュー セル作成
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *CellIdentifier = [NSString stringWithFormat:@"Cell%@", (indexPath.section?@"T":@"F")];
    
    //
    ScanDataCell *cell = (ScanDataCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if(cell == nil)
    {
        cell = [[ScanDataCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    // 複数印刷対応_iPad
    if (self.PrevViewID == PV_PRINT_SELECT_FILE_CELL) {
        [cell.selectImgView removeFromSuperview];
    }
    
    // データ取得
    ScanData *scanData = nil;
    scanData = [m_pScanMgr loadScanDataAtIndexPath:indexPath];
//    [cell setModel:scanData hasDisclosure:TRUE];
//    
//    // フォルダ以外はアクセサリなし
//    if ([[m_pScanMgr loadScanDataAtIndexPath:indexPath]isDirectory] == NO) {
//        cell.accessoryType = UITableViewCellAccessoryNone;
//    }
    if(self.presentingViewController != nil){
        // モーダルのとき
        // フォルダ以外はアクセサリなし
        if ([[m_pScanMgr loadScanDataAtIndexPath:indexPath]isDirectory] == NO) {
            [cell setModel:scanData hasDisclosure:NO];
        }else{
            [cell setModel:scanData hasDisclosure:YES];
        }
    }
    else{
        [cell setModel:scanData hasDisclosure:YES];
    }
    
    if(self.PrevViewID == ArrangeSelectTypeView)
    {
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
    }
    [cell.selectImgView removeFromSuperview];
    
    SharpScanPrintAppDelegate* pAppDelegate = (SharpScanPrintAppDelegate*)[[UIApplication sharedApplication] delegate];
    UINavigationController* pRootNavController = [pAppDelegate.splitViewController.viewControllers objectAtIndex:0];
    //左側のViewに設定されているクラスの名前を取得
    NSString* leftViewClassName = [pRootNavController.topViewController description];
    // 左側のViewにこのクラスが表示されている場合
    if([leftViewClassName isEqual:[self description]]){
        [cell setModel:scanData hasDisclosure:YES];
    }else if(self.presentingViewController != nil){
        //モーダルの場合
        if ([[m_pScanMgr loadScanDataAtIndexPath:indexPath]isDirectory] == NO) {
            // フォルダ以外はアクセサリなし
            [cell setModel:scanData hasDisclosure:NO];
        }else{
            [cell setModel:scanData hasDisclosure:YES];
        }
    }
    else{
        [cell setModel:scanData hasDisclosure:YES];
        //通常のビューの場合
    }
    
    // 共有ボタンツールバーの画面の場合
    if ([self isShareToolBarPrevViewID]) {
        // 編集モード中のフォルダーセルはアクセサリはなし
        if (self.isEditing && [[m_pScanMgr loadScanDataAtIndexPath:indexPath]isDirectory]) {
            cell.accessoryType = UITableViewCellAccessoryNone;
        }
    }
    
    return cell;
}

// テーブルビュー 縦幅設定
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return N_HEIGHT_SEL_FILE;
}

// iPad用
- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.fromSelectFileVC) {
        return 3;
    }

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
            BOOL ret = NO;
            ScanData *scanData = [m_pScanMgr loadScanDataAtIndexPath:indexPath];
            NSString *path = [scanData.fpath stringByAppendingPathComponent:scanData.fname];
            
            if(scanData.isDirectory){
                ScanDirectory *selectedScanDirectory = [[ScanDirectory alloc]initWithScanDirectoryPath:path];
                ret = [ScanDirectoryUtility deleteDirectory:selectedScanDirectory];
            }else{
                ScanFile *selectedScanFile = [[ScanFile alloc]initWithScanFilePath:path];
                ret = [ScanFileUtility deleteFile:selectedScanFile];
            }

            if (ret == YES)
            {
                //
                // Delete the row from the data source
                //
                [m_pScanMgr removeAtIndex:indexPath];
                [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationLeft];
            }
            
        }
    }
}

#pragma mark - Table view delegate

// 複数印刷対応_iPad
-(NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.PrevViewID == PV_PRINT_SELECT_FILE_CELL || [self isShareToolBarPrevViewID]) {
        DLog(@"indexPath = %@ and isDirectory = %d",indexPath,[[m_pScanMgr loadScanDataAtIndexPath:indexPath]isDirectory]);
        if (self.tableView.editing && [[m_pScanMgr loadScanDataAtIndexPath:indexPath] isDirectory]) {
            return nil;
        } else {
            return indexPath;
        }
    } else {
        return indexPath;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // 複数印刷対応_iPad
    if (self.tableView.editing && self.fromSelectFileVC && ![self isShareToolBarPrevViewID]) {
        return;
    }

    // セルの複数タップを制御する
    if ( ! [self.navigationController.visibleViewController isKindOfClass: [self class]] ) {
        DLog(@"visibleViewController is Invalid");
        return;
    }

    if(self.tableView.editing == NO)
    {
        // ファイル印刷の場合
        if (self.PrevViewID == PPV_PRINT_SELECT_FILE_CELL) {
            // セルをタップ済みかどうか(連打不可対応)
            if (self.isFirstTap) {
                return;
            } else {
                self.isFirstTap = YES;
            }
        }
        
        [self MoveView:indexPath];
    }
    else
    {
        // チェックボックス切り替え
        [self changeCheckbox:indexPath];
    }
}

- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath {
    // 複数印刷対応_iPad
    if (self.tableView.editing && self.fromSelectFileVC && ![self isShareToolBarPrevViewID]) {
        return;
    }
    
    // セルの複数タップを制御する
    if ( ! [self.navigationController.visibleViewController isKindOfClass: [self class]] ) {
        DLog(@"visibleViewController is Invalid");
        return;
    }
    
    if(self.tableView.editing == NO)
    {
        [self MoveView:indexPath];
    }
    else
    {
        // チェックボックス切り替え
        [self changeCheckbox:indexPath];
    }
}

- (void) changeCheckbox:(NSIndexPath *)indexPath {
    // チェックボックス切り替え
    ScanDataCell *cell = (ScanDataCell*)[self.tableView cellForRowAtIndexPath:indexPath];
    if(cell.selectImgView.tag)
    {
        cell.selectImgView.tag = 0;
    }
    else
    {
        cell.selectImgView.tag = 1;
    }
    
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
    
    // 行の選択数によりボタン表示状態を変更
    switch ([mArray count]) {
        case 0:
            if (moveBtn) {
            moveBtn.enabled = NO;
            }
            if (trashBtn) {
            trashBtn.enabled = NO;
            }
            if (nameChangeBtn) {
            nameChangeBtn.enabled = NO;
            }
            if (shareBtn) {
                shareBtn.enabled = NO;
            }
            break;
        case 1:
            if (moveBtn) {
            moveBtn.enabled = YES;
            }
            if (trashBtn) {
            trashBtn.enabled = YES;
            }
            if (nameChangeBtn) {
            nameChangeBtn.enabled = YES;
            }
            if (shareBtn) {
                shareBtn.enabled = YES;
            }
            break;
        default:
            if (moveBtn) {
            moveBtn.enabled = YES;
            }
            if (trashBtn) {
            trashBtn.enabled = YES;
            }
            if (nameChangeBtn) {
            nameChangeBtn.enabled = NO;
            }
            if (shareBtn) {
                shareBtn.enabled = YES;
            }
            break;
    }
}

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
    if([[m_pScanMgr loadScanDataAtIndexPath:nIndexPath] isDirectory ])
    {
        SharpScanPrintAppDelegate* pAppDelegate = (SharpScanPrintAppDelegate*)[[UIApplication sharedApplication] delegate];
        
        if(self.PrevViewID == ArrangeSelectTypeView)
        {
            ArrengeSelectFileViewController_iPad* selectView;
            selectView = [[ArrengeSelectFileViewController_iPad alloc] init]; 
  
            // 選択ファイルパス格納
            ScanData *scanData = nil;
            scanData = [m_pScanMgr loadScanDataAtIndexPath:nIndexPath];
            NSString *directoryPath = [NSString stringWithFormat:@"%@/%@" , scanData.fpath, scanData.fname];
            ScanDirectory *localScanDirectory = [[ScanDirectory alloc] initWithScanDirectoryPath:directoryPath];
            selectView.scanDirectory = localScanDirectory;
            m_pScanMgr.fullPath = selectView.scanDirectory.scanDirectoryPath;
            
            selectView.selectIndexPath = nil;
            NSString* selectDir = [[NSUserDefaults standardUserDefaults] objectForKey:S_KEY_SELECT_DIR];
            if ([selectView.scanDirectory.relativeDirectoryPathInScanFile isEqualToString:selectDir]){
                NSString* fullPath = [[NSUserDefaults standardUserDefaults] stringForKey: S_KEY_SELECT_FPATH];
                selectView.selectIndexPath = [m_pScanMgr indexOfScanDataWithFilePath: fullPath];
            }
            UINavigationController* pRootNavController = [pAppDelegate.splitViewController.viewControllers objectAtIndex:0];
            //左側のViewに設定されているクラスの名前を取得
            NSString* leftViewClassName = [pRootNavController.topViewController description];        
            // 左側のViewに自身が表示されていない場合
            if(![leftViewClassName isEqual:[self description]])
            {
                selectView.bSetTitle = YES;
            }
            
            [self.navigationController pushViewController:selectView animated:YES];

        } else if (self.PrevViewID == PV_PRINT_SELECT_FILE_CELL) {
            SelectFileViewController_iPad* selectView = [[SelectFileViewController_iPad alloc] init];
            
            // 選択ファイルパス格納
            ScanData *scanData = nil;
            scanData = [m_pScanMgr loadScanDataAtIndexPath:nIndexPath];
            NSString *directoryPath = [scanData.fpath stringByAppendingPathComponent:scanData.fname];
            ScanDirectory *localScanDirectory = [[ScanDirectory alloc] initWithScanDirectoryPath:directoryPath];
            selectView.scanDirectory = localScanDirectory;
            m_pScanMgr.fullPath = selectView.scanDirectory.scanDirectoryPath;
            
            selectView.PrevViewID = self.PrevViewID;
            
            // 複数印刷対応
            selectView.pushFlag = YES;
            
            [self.navigationController pushViewController:selectView animated:YES];
        } else {
            SelectFileViewController_iPad* selectView = [[SelectFileViewController_iPad alloc] init];
            // 選択ファイルパス格納
            ScanData *scanData = nil;
            scanData = [m_pScanMgr loadScanDataAtIndexPath:nIndexPath];
            NSString *directoryPath = [NSString stringWithFormat:@"%@/%@" , scanData.fpath, scanData.fname];
            ScanDirectory *localScanDirectory = [[ScanDirectory alloc] initWithScanDirectoryPath:directoryPath];
            selectView.scanDirectory = localScanDirectory;
            m_pScanMgr.fullPath = selectView.scanDirectory.scanDirectoryPath;
            
            selectView.PrevViewID = self.PrevViewID;
            selectView.selectIndexPath = nil;
            NSString* selectDir = [[NSUserDefaults standardUserDefaults] objectForKey:S_KEY_SELECT_DIR];
            if ([selectView.scanDirectory.relativeDirectoryPathInScanFile isEqualToString:selectDir]){
                NSString* fullPath = [[NSUserDefaults standardUserDefaults] stringForKey: S_KEY_SELECT_FPATH];
                selectView.selectIndexPath = [m_pScanMgr indexOfScanDataWithFilePath: fullPath];
            }
            
            UINavigationController* pRootNavController = [pAppDelegate.splitViewController.viewControllers objectAtIndex:0];
            //左側のViewに設定されているクラスの名前を取得
            NSString* leftViewClassName = [pRootNavController.topViewController description];        
            // 左側のViewに自身が表示されていない場合
            if(![leftViewClassName isEqual:[self description]])
            {
                selectView.bSetTitle = YES;
            }
            
            [self.navigationController pushViewController:selectView animated:YES];
            
        }
        
    }
    else
    {
        // 複数印刷対応_iPad
        if (self.PrevViewID == PV_PRINT_SELECT_FILE_CELL) {
            // 選択ファイルパス格納
            if (self.selectFilePathArray == nil) {
                self.selectFilePathArray = [[NSMutableArray alloc]initWithCapacity:0];
            }
            ScanData *scanData = [m_pScanMgr loadScanDataAtIndexPath:nIndexPath];
            scanData.fpath = [scanData.fpath stringByAppendingString:@"/"];
            [self.selectFilePathArray addObject:scanData];
            /*
             if(self.subDir == nil)
             {
             [self.selectFilePathArray addObject:[NSString stringWithFormat:@"%@/%@",m_pScanMgr.baseDir,scanData.fname]];
             }
             else
             {
             [self.selectFilePathArray addObject:[NSString stringWithFormat:@"%@/%@",self.subDir,scanData.fname]];
             }
             */
            DLog(@"%@",self.selectFilePathArray);
            [self performSelector:@selector(enterButtonPushed:) withObject:nil];
            return;
        }
        
        // 遷移元画面から渡されたIDをもとに遷移先のViewControllerを決定する
        PictureViewController_iPad* pViewController;
//        pViewController = [[PrintPictViewController_iPad alloc] init];
        
        switch (self.PrevViewID)
        {
            case PV_PRINT_SELECT_FILE_CELL:
                pViewController = [[PrintPictViewController_iPad alloc] init];
                pViewController.PrintPictViewID = PPV_PRINT_SELECT_FILE_CELL;
                break;
            case SendMailSelectTypeView:
                pViewController = [[SendMailPictViewController_iPad alloc] init];
                pViewController.PrintPictViewID = PPV_OTHER;
                break;
            case SendExSiteSelectTypeView:
                pViewController = [[SendExSitePictViewController_iPad alloc] init];
                pViewController.PrintPictViewID = PPV_OTHER;
                break;
            case ArrangeSelectTypeView:
                pViewController =[[ArrangePictViewController_iPad alloc] init];
                pViewController.PrintPictViewID = PPV_OTHER;
                break;
            default:
                pViewController = [[PrintPictViewController_iPad alloc] init];
                pViewController.PrintPictViewID = PPV_OTHER;
                break;
        }
        // 選択ファイルパス格納
        ScanData *scanData = nil;
        scanData = [m_pScanMgr loadScanDataAtIndexPath:nIndexPath];
//        if(self.subDir == nil)
//        {
//            pViewController.SelFilePath	= [NSString stringWithFormat:@"%@/%@" , m_pScanMgr.baseDir, scanData.fname];
//        }
//        else
//        {     
//            pViewController.SelFilePath	= [NSString stringWithFormat:@"%@/%@" , self.subDir, scanData.fname];
//        }
        pViewController.SelFilePath	= [NSString stringWithFormat:@"%@/%@" , scanData.fpath, scanData.fname];
        // iPad用
        //[self.navigationController pushViewController:pViewController animated:YES];
        [self ChangeDetailView:pViewController didSelectRowAtIndexPath:nIndexPath];
        // iPad用
        
        // 縦向き表示時のメニューPopOverが表示されていたら閉じる
        [self dismissMenuPopOver:YES];
    }
    
}

// iPad用
- (IBAction)OnShowAdvancedSearchResultView:(UIBarButtonItem*)sender withEvent:(UIEvent*)event
{
    // 編集モードOFF
    [self setEditing:NO animated:NO];

    // モーダル表示
    
    // 画面遷移
    AdvancedSearchViewController* pAdvancedSearchViewController;
    pAdvancedSearchViewController = [[AdvancedSearchViewController alloc] init];
    pAdvancedSearchViewController.bSubFolder = self.bSubFolder;
    pAdvancedSearchViewController.bFillterFolder = self.bFillterFolder;
    pAdvancedSearchViewController.bFillterPdf = self.bFillterPdf;
    pAdvancedSearchViewController.bFillterTiff = self.bFillterTiff;
    pAdvancedSearchViewController.bFillterImage = self.bFillterImage;
    pAdvancedSearchViewController.bFillterOffice = self.bFillterOffice;
    pAdvancedSearchViewController.sessionViewController = self.sessionViewController;
    // 複数印刷対応_iPad
    pAdvancedSearchViewController.fromSelectFileVC = self.fromSelectFileVC;
    
    // モーダル表示
    UINavigationController *navigationController = [[UINavigationController alloc]initWithRootViewController:pAdvancedSearchViewController];
    navigationController.navigationBar.barStyle = NAVIGATION_BARSTYLE;
    [navigationController setModalPresentationStyle:UIModalPresentationPageSheet];
    [self presentViewController:navigationController animated:YES completion:nil];
    
    
}

// 詳細画面切換え
-(void)ChangeDetailView:(UIViewController*)pViewController didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    SharpScanPrintAppDelegate* pAppDelegate = (SharpScanPrintAppDelegate*)[[UIApplication sharedApplication] delegate];
    
    if (pAppDelegate.IsPreview)
    {
        // 指定の行を選択状態
        //^^
        NSString* fullPath = [[NSUserDefaults standardUserDefaults] stringForKey: S_KEY_SELECT_FPATH];
        selectIndexPath = [m_pScanMgr indexOfScanDataWithFilePath: fullPath];
        [self.tableView selectRowAtIndexPath:selectIndexPath animated:NO scrollPosition:UITableViewScrollPositionNone];
        
        return;
    }
    
    // 選択行保持
    NSUInteger newIndex[] = {indexPath.section, indexPath.row};
    selectIndexPath = [[NSIndexPath alloc] initWithIndexes:newIndex length:2];
    // 選択ファイルの情報を保存
    
//    if(!self.rootDir)
//    {
//        self.rootDir = @"/";
//    }
//        
    NSUserDefaults* ud = [NSUserDefaults standardUserDefaults];
    [ud setObject:self.scanDirectory.relativeDirectoryPathInScanFile forKey:S_KEY_SELECT_DIR];
    [ud setObject:[NSNumber numberWithInteger:selectIndexPath.section] forKey:S_KEY_SELECT_INDEX_SECTION];
    [ud setObject:[NSNumber numberWithInteger:selectIndexPath.row] forKey:S_KEY_SELECT_INDEX_ROW];
    [ud setObject:[m_pScanMgr filePathAtIndexPath: selectIndexPath] forKey:S_KEY_SELECT_FPATH];
    [ud synchronize];
    
    UINavigationController* pRootNavController = [pAppDelegate.splitViewController.viewControllers objectAtIndex:0];
    // 左側のViewに設定されているクラスの名前を取得
    NSString* leftViewClassName = [pRootNavController.topViewController description];
    // 左側のViewにトップメニューが表示されている場合
    if(![leftViewClassName isEqual:[self description]])
    {
        // 左側のViewを更新してファイル一覧を表示
        RootViewController_iPad* pRootViewController = (RootViewController_iPad*)pRootNavController.topViewController;
        pRootViewController.subDir = self.scanDirectory.scanDirectoryPath;
        pRootViewController.rootDir = self.scanDirectory.relativeDirectoryPathInScanFile;

        pRootViewController.pstrSearchKeyword = self.pstrSearchKeyword;
//        self.sessionViewController.pstrSearchKeyword = self.pstrSearchKeyword;
        pRootViewController.bSubFolder = self.bSubFolder;
        pRootViewController.bFillterFolder = self.bFillterFolder;
        pRootViewController.bFillterPdf = self.bFillterPdf;
        pRootViewController.bFillterTiff = self.bFillterTiff;
        pRootViewController.bFillterImage = self.bFillterImage;
        pRootViewController.bFillterOffice = self.bFillterOffice;
        pRootViewController.bCanDelete = self.bCanDelete;
        
//        [pRootViewController updateView:self.PrevViewID didSelectRowAtIndexPath:indexPath scrollOffset:[self.tableView contentOffset]];
        [pRootViewController updateView:self.PrevViewID searchPreViewID:AdvancedSearchResultTypeView didSelectRowAtIndexPath:indexPath scrollOffset:[self.tableView contentOffset]];
        selectIndexPath = nil;
        // 右側のViewを更新して画像プレビューを表示
        [self.navigationController pushViewController:pViewController animated:YES];
    }
    else
    {
        // 詳細画面に表示
        UINavigationController* pDetailNavController = [pAppDelegate.splitViewController.viewControllers objectAtIndex:1];
        [pDetailNavController pushViewController:pViewController animated:NO];
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

#pragma mark - ToolBarAction

// 移動画面に遷移する
- (void)moveAction:(id)sender
{
    
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
        scanData = [m_pScanMgr loadScanDataAtIndexPath:[mArray objectAtIndex:row]];
        
        //        if(self.subDir == nil)
        //        {
        //            // ホームディレクトリの場合
        //            //            path = [NSString stringWithFormat:@"%@/%@" , m_pScanMgr.baseDir,scanData.fname];
        //        }
        //        else
        //        {
        //            // 階層遷移している場合
        //            //            path = [NSString stringWithFormat:@"%@/%@" , self.subDir,scanData.fname];
        //        }
        
        path = [NSString stringWithFormat:@"%@/%@" , scanData.fpath, scanData.fname];
        
        //        DLog(@"%@",path);
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
    [self makeTmpExAlert:nil message:MSG_DEL_FILE_FOLDER_CONFIRM cancelBtnTitle:S_BUTTON_CANCEL okBtnTitle:MSG_BUTTON_OK tag:1 showFlg:YES];
}

// 名称変更画面に遷移する
- (void)nameChangeAction:(id)sender
{
    // 選択ファイルの情報を取得
    ScanData *scanData = nil;
    scanData = [m_pScanMgr loadScanDataAtIndexPath:[mArray objectAtIndex:0]];
    
    // 編集モードOFF
    [self setEditing:NO animated:NO];
    
    // 画面遷移
    FileNameChangeViewController* pFileNameChangeViewController;
    pFileNameChangeViewController = [[FileNameChangeViewController alloc] init];
    pFileNameChangeViewController.delegate = self;
    // 選択ファイルパス格納
//    if(self.subDir == nil)
//    {
//        pFileNameChangeViewController.SelFilePath	= [NSString stringWithFormat:@"%@/" , m_pScanMgr.baseDir];
//    }
//    else
//    {     
//        pFileNameChangeViewController.SelFilePath	= [NSString stringWithFormat:@"%@/" , self.subDir];
//    }
    pFileNameChangeViewController.SelFilePath	= [NSString stringWithFormat:@"%@/" , scanData.fpath];
    
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
    
    // モーダル表示
    UINavigationController *navigationController = [[UINavigationController alloc]initWithRootViewController:pFileNameChangeViewController];
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
                    scanData = [m_pScanMgr loadScanDataAtIndexPath:[mArray objectAtIndex:row]];
                    
                    path = [NSString stringWithFormat:@"%@/%@", scanData.fpath, scanData.fname];
                    
                    if (!scanData.isDirectory) {
                        ScanFile *deleteFile = [[ScanFile alloc] initWithScanFilePath:path];
                        [ScanFileUtility deleteFile:deleteFile];
                    } else {
                        ScanDirectory *deleteDirectory = [[ScanDirectory alloc] initWithScanDirectoryPath:path];
                        [ScanDirectoryUtility deleteDirectory:deleteDirectory];
                    }
                    
                }
            }
            
            [self makeTmpExAlert:nil message:MSG_DEL_COMPLETE cancelBtnTitle:nil okBtnTitle:MSG_BUTTON_OK tag:2 showFlg:YES];
        }
    }
    
    if(tagIndex == 2)
    {
        [self setEditing:NO animated:NO];
        [m_pScanMgr reGetScanData];
        // タイトルを更新
        [self updateTitle];
        [self.tableView reloadData];
    }
    
}

-(void)alertButtonDismiss:(UIAlertController *)alertController tagIndex:(NSInteger)tagIndex buttonIndex:(NSInteger)buttonIndex
{
    // iPad用
    SharpScanPrintAppDelegate* appDelegate = (SharpScanPrintAppDelegate*)[[UIApplication sharedApplication] delegate];
    // iPad用
    // 処理実行フラグOFF
    appDelegate.IsRun = FALSE;
    
    if (tagIndex == 2)
    {
        [self moveRootViewForArrangePreview];
    }
}

// 編集モードか否かを判別する
- (void)setEditing:(BOOL)editing animated:(BOOL)animated
{
    [super setEditing:editing animated:animated];
    [self.tableView setEditing:editing animated:YES];
    
    // 編集モード時のみ、ツールバーを表示する
    if(editing)
    {
        [self.navigationItem setHidesBackButton:YES animated:YES];
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
        if (moveBtn) {
        moveBtn.enabled = NO;
        }
        if (trashBtn) {
        trashBtn.enabled = NO;
        }
        if (nameChangeBtn) {
        nameChangeBtn.enabled = NO;
        }
        if (shareBtn) {
            shareBtn.enabled = NO;
        }
        
        //^^
        NSString* fullPath = [[NSUserDefaults standardUserDefaults] stringForKey: S_KEY_SELECT_FPATH];
        selectIndexPath = [m_pScanMgr indexOfScanDataWithFilePath: fullPath];
        // 指定の行を選択状態
        [self.tableView selectRowAtIndexPath:selectIndexPath animated:NO scrollPosition:UITableViewScrollPositionNone];
        
        [self.navigationItem setHidesBackButton:NO animated:YES];        
        // 整理する画面、メールに添付する、アプリケーションに送るの場合
        if(self.PrevViewID == ArrangeSelectTypeView || [self isShareToolBarPrevViewID]) {
            [self.navigationController setToolbarHidden:YES animated:NO];
        }
    }
}

// ヘッダー表示
- (void)SetHeaderView
{
    if (!self.tableView.tableHeaderView) {
        
        //　現在のフォルダの階層を表示する
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
        
        // ヘッダービューを生成する
        UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0.0, 0.0, self.view.frame.size.width, 72.0)];
        headerView.backgroundColor = [UIColor grayColor];
        [headerView addSubview:label];
        
        // Todo 並べ替え & 検索バーを生成
        UIToolbar *sortAndSearchView = [[UIToolbar alloc] initWithFrame:CGRectMake(0.0, 0.0, self.view.frame.size.width, SEARCHBAR_HEIGHT + 4.0)];
        sortAndSearchView.barStyle = TOOLBAR_BARSTYLE;
        sortAndSearchView.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        
        // 検索バーを生成
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
            m_searchController.searchBar.text = pstrSearchKeyword;
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
        }
        else
        {
            m_searchController.searchBar.frame = CGRectMake(SORTBUTTON_WIDTH, 1.0, self.view.frame.size.width - (SORTBUTTON_WIDTH + ADVANCEDSEARCHBUTTON_WIDTH), SEARCHBAR_HEIGHT + 3.0);
            m_searchController.searchBar.delegate = self;
            m_searchController.searchBar.showsCancelButton = NO;
            m_searchController.searchBar.placeholder = S_SEARCH_PLACEHOLDER;
            m_searchController.searchBar.text = pstrSearchKeyword;
            m_searchController.searchBar.keyboardType = UIKeyboardTypeDefault;
            if (isIOS7_1Later) {
                m_searchController.searchBar.keyboardAppearance = UIKeyboardAppearanceLight;
            }
            m_searchController.searchBar.barStyle = TOOLBAR_BARSTYLE;
            if([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0)
            {   // iOS7以上なら
                m_searchController.searchBar.searchBarStyle = UISearchBarStyleMinimal;
            }
            m_searchController.searchBar.backgroundColor = [UIColor clearColor];
            m_searchController.searchBar.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleRightMargin;
            
            m_searchController.delegate = self;
            
        }
        //　並べ替え用ボタンを生成（現在の検索キーを表示)
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
        
        
        //  詳細検索ボタン生成
        m_pbtnAdvancedSearch = [UIButton buttonWithType:UIButtonTypeCustom];
        [m_pbtnAdvancedSearch setExclusiveTouch: YES];
        m_pbtnAdvancedSearch.frame = CGRectMake(self.view.frame.size.width - ADVANCEDSEARCHBUTTON_WIDTH, 0.0, ADVANCEDSEARCHBUTTON_WIDTH, SEARCHBAR_HEIGHT);
        m_pbtnAdvancedSearch.titleLabel.font = [UIFont fontWithName:@"AppleGothic" size:12];
        m_pbtnAdvancedSearch.titleLabel.textAlignment = NSTextAlignmentRight;
        m_pbtnAdvancedSearch.titleLabel.baselineAdjustment = UIBaselineAdjustmentAlignBaselines;
        m_pbtnAdvancedSearch.titleLabel.adjustsFontSizeToFitWidth = NO;
        //★TODO:アイコン出来上がり次第変更
        [m_pbtnAdvancedSearch setBackgroundImage:[UIImage imageNamed:S_ICON_SEARCHFINE] forState:UIControlStateNormal];
        m_pbtnAdvancedSearch.titleLabel.textColor = [UIColor whiteColor];
        m_pbtnAdvancedSearch.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin;
        
        [m_pbtnAdvancedSearch addTarget:self action:@selector(OnShowAdvancedSearchResultView:withEvent:) forControlEvents:UIControlEventTouchUpInside];
        
        // ボタンテーブルをヘッダー部に追加
        [sortAndSearchView addSubview:sortTypeButton];
        [sortAndSearchView addSubview:m_pbtnAdvancedSearch];
        
        // 並べ替え & 検索バーをテーブルのヘッダー部に表示する
        [headerView addSubview:sortAndSearchView];
        
        // Todo 詳細検索ボタン表示 end
        [headerView addSubview:m_searchController.searchBar];
        
        //TableViewにヘッダー設定
        self.tableView.tableHeaderView = headerView;
        
    } else {
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
}

#pragma mark - MoveViewControllerDelegate
-(void) move:(UIViewController*)viewController didMovedSuccess:(BOOL)bSuccess;
{
    
    MoveViewController* moveView = (MoveViewController*)viewController;
    
    // フォルダ作成
    if(bSuccess){
        // リスト更新
        //        [self viewWillAppear:NO];
        
        if(m_pScanMgr != nil)
        {
            m_pScanMgr.fullPath = self.scanDirectory.scanDirectoryPath;
            m_pScanMgr.IsSearchView = YES;
            m_pScanMgr.searchKeyword = self.pstrSearchKeyword;
//            self.sessionViewController.pstrSearchKeyword = self.pstrSearchKeyword;
            [m_pScanMgr reGetScanData];
            // タイトルを更新
            [self updateTitle];
        }
        [self.tableView reloadData];
    }
    
    // モーダルを閉じる
    [moveView dismissViewControllerAnimated:YES completion:nil];
    
    // デリゲートをクリア
    moveView.delegate = nil;
    
    [self moveRootViewForArrangePreview];
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
    
    [self moveRootViewForArrangePreview];
}

#pragma mark - UISearchBarDelegate
// キーボードのSearchボタンタップ時に呼ばれる
-(void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    DLog(@"search");
    // iPad用
    // キーボードを非表示
    [searchBar resignFirstResponder];
    
    // テーブルのリロード
    self.pstrSearchKeyword = searchBar.text;
    self.sessionViewController.pstrSearchKeyword = searchBar.text;
    if(m_pScanMgr != nil)
    {
        m_pScanMgr.fullPath = self.scanDirectory.scanDirectoryPath;
        m_pScanMgr.IsSearchView = YES;
        m_pScanMgr.IsAdvancedSearch = YES;
        m_pScanMgr.searchKeyword = self.pstrSearchKeyword;
        [m_pScanMgr reGetScanData];
        // タイトルを更新
        [self updateTitle];
    }
    [self.tableView reloadData];
    
    [self SetHeaderView];
}

// 検索バーのキャンセルボタンを押下時に呼ばれる
-(void)searchBarCancelButtonClicked:(UISearchBar *)searchBar
{
    sortTypeButton.hidden = NO;
    m_pbtnAdvancedSearch.hidden = NO;

    [self SetHeaderView];
}


#pragma mark - UISearchControllerDelegate

// 検索モードになる前に呼ばれる
- (void)presentSearchController:(UISearchController *)searchController {
    
    // 編集モードOFF
    [self setEditing:NO animated:NO];
    
    // ファイル印刷で、編集モード中に検索バーのテキストフィールドをタップした場合、UIを通常モードに戻す
    if (self.PrevViewID == PPV_PRINT_SELECT_FILE_CELL && self.multiPrintFlag == YES) {
        self.multiPrintFlag = NO;
        [self updateNavigationBarButton];
    }
    
    sortTypeButton.hidden = YES;
    m_pbtnAdvancedSearch.hidden = YES;
    
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
    searchController.searchBar.frame = CGRectMake(SORTBUTTON_WIDTH, 0.0, self.view.frame.size.width - (SORTBUTTON_WIDTH + ADVANCEDSEARCHBUTTON_WIDTH), SEARCHBAR_HEIGHT);
    
    sortTypeButton.hidden = NO;
    m_pbtnAdvancedSearch.hidden = NO;
    
    [self.tableView insertSubview:m_searchController.searchBar aboveSubview:self.tableView];
    
    [UIView commitAnimations];
    
}
// 検索モードが解除された後に呼ばれる
- (void)didDismissSearchController:(UISearchController *)searchController {
    searchController.searchBar.text = pstrSearchKeyword;
}

// iPadでキーボードを閉じるボタン押下時の処理
- (void)keyboardDidHide:(NSNotification*)notification
{
    /*
    if (m_searchController.active) {
        // 検索バーを隠す
        [m_searchController setActive:NO];
    }
    */
    bEndActiveAtKBNotification = NO;
    if (m_searchController.active) {
        [m_searchController setActive:NO];
        bEndActiveAtKBNotification = YES;   // この通知処理にて検索モードを終了したフラグを設定 回転時の処理に使用する。
    }

}

#pragma mark - RightBarButtonClicked
// 詳細検索画面（モーダル）で検索押下時
-(void)advancedSearchRightBarButtonClicked
{
    
    // モーダルを閉じる
//    self.sessionViewController.pstrSearchKeyword = self.pstrSearchKeyword;
    [self dismissViewControllerAnimated:YES completion:nil];
    // テーブルのリロード
    if(m_pScanMgr != nil)
    {
        m_pScanMgr.fullPath = self.scanDirectory.scanDirectoryPath;
        m_pScanMgr.IsSearchView = YES;
        m_pScanMgr.IsAdvancedSearch = YES;
        m_pScanMgr.IsSubFolder = self.bSubFolder;
        m_pScanMgr.IsFillterFolder = self.bFillterFolder;
        m_pScanMgr.IsFillterPdf = self.bFillterPdf;
        m_pScanMgr.IsFillterTiff = self.bFillterTiff;
        m_pScanMgr.IsFillterImage = self.bFillterImage;
        m_pScanMgr.IsFillterOffice = self.bFillterOffice;
        m_pScanMgr.searchKeyword = self.pstrSearchKeyword;
        [m_pScanMgr reGetScanData];
        // タイトルを更新
        [self updateTitle];
    }
    [self.tableView reloadData];
}

#pragma mark - updateTitle
-(void)updateTitle
{
    // タイトル設定
    CGRect frame = CGRectMake(0, 0, 500, 44);
    UILabel* lblTitle = [[UILabel alloc]initWithFrame:frame];
    lblTitle.backgroundColor = [UIColor clearColor];
    lblTitle.textColor = NAVIGATION_TITLE_COLOR;
    lblTitle.font = [UIFont boldSystemFontOfSize:18];
    if ([S_LANG isEqualToString:S_LANG_JA])
    {
        // 国内版の場合、表示文字を小さくする
        lblTitle.adjustsFontSizeToFitWidth = YES;
        lblTitle.minimumScaleFactor = 7 / lblTitle.font.pointSize;
    }
    lblTitle.textAlignment = NSTextAlignmentCenter;
    lblTitle.text = [NSString stringWithFormat:S_TITLE_SEARCHRESULT, [m_pScanMgr countOfSearchScanData]];
    lblTitle.lineBreakMode = NSLineBreakByTruncatingTail;
    self.navigationItem.titleView = lblTitle;
    // タイトルを更新
//    self.navigationItem.title = [NSString stringWithFormat:S_TITLE_SEARCHRESULT, [m_pScanMgr countOfSearchScanData]];
}

// 複数印刷対応_iPad
- (void)closeButtonPushed:(id)sender {
    NSNotification *n = [NSNotification notificationWithName:NK_CLOSE_BUTTON_PUSHED object:self];
    NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
    [nc postNotification:n];
}
// 複数印刷対応_iPad
- (void)multiPrintButtonPushed:(id)sender {
    self.multiPrintFlag = YES;
    [self updateNavigationBarButton];
}
// 複数印刷対応_iPad
- (void)cancelButtonPushed:(id)sender {
    self.multiPrintFlag = NO;
    [self updateNavigationBarButton];
}
// 複数印刷対応_iPad
- (void)enterButtonPushed:(id)sender {
    if (self.multiPrintFlag) {
        if (self.selectFilePathArray == nil) {
            self.selectFilePathArray = [NSMutableArray arrayWithCapacity:0];
        }
        for (NSIndexPath *indexPath in self.tableView.indexPathsForSelectedRows) {
            ScanData *scanData = [m_pScanMgr loadScanDataAtIndexPath:indexPath];
            scanData.fpath = [scanData.fpath stringByAppendingString:@"/"];
            [self.selectFilePathArray addObject:scanData];
            /*
             if(self.subDir == nil)
             {
             [self.selectFilePathArray addObject:[NSString stringWithFormat:@"%@/%@",m_pScanMgr.baseDir,scanData.fname]];
             }
             else
             {
             [self.selectFilePathArray addObject:[NSString stringWithFormat:@"%@/%@",self.subDir,scanData.fname]];
             }
             */
        }
        DLog(@"%@",self.selectFilePathArray);
    }
    if (self.selectFilePathArray.count == 0) {
        [self performSelector:@selector(cancelButtonPushed:) withObject:nil];
        return;
    }
    
    NSNotification *n = [NSNotification notificationWithName:NK_ENTER_BUTTON_PUSHED object:self];
    NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
    [nc postNotification:n];
}

- (void)moveRootViewForArrangePreview {
    // 整理する画面の場合
    if(self.PrevViewID == ArrangeSelectTypeView)
    {
        NSFileManager * fileManager = [NSFileManager defaultManager];
        
        // プレビュー表示しているファイルが存在するかチェックする
        BOOL isFileExists = [fileManager fileExistsAtPath: self.arrangePreviewFileName];
        
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
    m_pScanMgr.fullPath = self.scanDirectory.scanDirectoryPath;
    m_pScanMgr.IsSearchView = YES;
    m_pScanMgr.IsAdvancedSearch = YES;
    m_pScanMgr.IsSubFolder = self.bSubFolder;
    m_pScanMgr.IsFillterFolder = self.bFillterFolder;
    m_pScanMgr.IsFillterPdf = self.bFillterPdf;
    m_pScanMgr.IsFillterTiff = self.bFillterTiff;
    m_pScanMgr.IsFillterImage = self.bFillterImage;
    m_pScanMgr.IsFillterOffice = self.bFillterOffice;
    m_pScanMgr.searchKeyword = self.pstrSearchKeyword;
    [m_pScanMgr reGetScanData];
    // タイトル設定
    [self updateTitle];

    //^^
    NSString* fullPath = [[NSUserDefaults standardUserDefaults] stringForKey: S_KEY_SELECT_FPATH];
    selectIndexPath = [m_pScanMgr indexOfScanDataWithFilePath: fullPath];
    
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
    if (selectIndexPath != nil && ((self.scanDirectory.isRootDirectory && selectDir == nil) || [self.scanDirectory.relativeDirectoryPathInScanFile isEqualToString:selectDir]))
    {
        
        
        // 左側のViewにこのクラスが表示されている場合
        if([leftViewClassName isEqual:[self description]])
        {
            if (!self.tableView.editing) {  // 編集モードではない場合
                // 指定の行を選択状態
                [self.tableView selectRowAtIndexPath:selectIndexPath animated:NO scrollPosition:UITableViewScrollPositionNone];
                // 指定の位置までスクロール
                if(selectIndexPath.section)
                {
                    [self.tableView scrollToRowAtIndexPath:selectIndexPath atScrollPosition:UITableViewScrollPositionTop animated:NO];
                }
                else
                {
                    //0件の場合
                    [self.tableView setContentOffset:lastScrollOffSet];
                }
            }
            
        }
    }
    // 左側のViewにこのクラスが表示されている場合
    if([leftViewClassName isEqual:[self description]])
    {
        if(m_searchController.active){
            m_pbtnAdvancedSearch.hidden = YES;
            m_searchController.searchBar.frame = (CGRect){0, 1.0, self.view.frame.size.width, SEARCHBAR_HEIGHT + 3.0};
            if(!sortTypeButton.hidden){
                sortTypeButton.hidden = YES;
            }
        }else{
            sortTypeButton.hidden = NO;
            m_pbtnAdvancedSearch.hidden = NO;
            m_searchController.searchBar.frame = (CGRect){SORTBUTTON_WIDTH, 1.0, self.view.frame.size.width - SORTBUTTON_WIDTH, SEARCHBAR_HEIGHT + 3.0};
        }
    }
    
    if (self.PrevViewID == PV_PRINT_SELECT_FILE_CELL) {
        // 複数印刷対応_iPad
        self.closeButton = [[UIBarButtonItem alloc]initWithTitle:S_BUTTON_CLOSE style:UIBarButtonItemStylePlain target:self action:@selector(closeButtonPushed:)];
        [self.navigationItem setRightBarButtonItem:self.closeButton];
        self.multiPrintButton = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:S_ICON_MULTIPLE] style:UIBarButtonItemStylePlain target:self action:@selector(multiPrintButtonPushed:)];
        self.cancelButton = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:S_ICON_PRINT_CANCEL] style:UIBarButtonItemStylePlain target:self action:@selector(cancelButtonPushed:)];
        self.enterButton = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:S_ICON_PRINT_DECIDE] style:UIBarButtonItemStylePlain target:self action:@selector(enterButtonPushed:)];
        [self updateNavigationBarButton];
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


#pragma mark - ShareMultiFileToOtherApp

/**
 @brief 編集ボタン/共有ボタンToolBar生成
 */
- (void)initShareToolBar {
    
    // 編集モード中もセルの選択を有効にする
    self.tableView.allowsSelectionDuringEditing = YES;
    
    // 選択インデックス初期化
    mArray = [[NSMutableArray alloc] init];
    
    // 編集ボタン追加
    self.navigationItem.rightBarButtonItem = self.editButtonItem;
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
    
    shareBtn.enabled = NO;
    
    self.toolbarItems = @[spacer, shareBtn, spacer];
    
    [self.navigationController setToolbarHidden:YES animated:YES];
}

// 共有ボタンのToolBarを表示する画面かどうかの判定
- (BOOL)isShareToolBarPrevViewID {
    if (self.PrevViewID == SendMailSelectTypeView || self.PrevViewID == SendExSiteSelectTypeView)  {
        return YES;
    }
    return NO;
}


// 共有ボタン押下時
- (void)shareAction:(id)sender {
    
    NSMutableArray *filePathArray = [[NSMutableArray alloc] init];
    
    for (NSInteger row = 0; row < mArray.count; row++) {
        
        // 選択ファイルの情報を取得
        NSString *filePath = @"";
        ScanData *scanData = nil;
        scanData = [m_pScanMgr loadScanDataAtIndexPath:[mArray objectAtIndex:row]];
        filePath = [self.scanDirectory.scanDirectoryPath stringByAppendingPathComponent:scanData.fname];
        NSURL *url = [NSURL fileURLWithPath:filePath];
        
        [filePathArray addObject:url];
    }
    
    __block AdvancedSearchResultViewController_iPad *block_self = self;
    activityViewController = [[UIActivityViewController alloc] initWithActivityItems:filePathArray applicationActivities:nil];
    activityViewController.completionWithItemsHandler = ^(NSString *activityType, BOOL completed, NSArray *returnedItems, NSError *activityError)
    {
        /*
         // ActivityViewControllerが閉じられたときの処理
         // なにかしらアプリを選択した後に(キャンセルや正常終了で)閉じられたときは編集モードを解除する。
         */
        NSLog(@"%@", activityType);
        if (activityError) {
            NSLog(@"activityError：%@", activityError);
        }
        else if (!completed) {
            NSLog(@"Activity is not Completed.");
            
            if (activityType == UIActivityTypeMail) {
                // メールが選択された場合
                Class mail = (NSClassFromString(@"MFMailComposeViewController"));
                // メールの設定がされているかどうかチェック
                if (![mail canSendMail]) {
                    NSLog(@"Mail Activity Error：Mail Account is not Set.");
                    [block_self setAlert:MSG_MAIL_START_ERR];
                }
                else {
                    // 編集モードを解除する
                    [block_self setEditing:NO animated:YES];
                }
            }
            else if (activityType != nil) {
                // なにかしらアプリが選択された後で終了した場合(選択アプリ先でキャンセルなど)
                // 編集モードを解除する
                [block_self setEditing:NO animated:YES];
            }
            else {
                // アプリを選択せずにキャンセルした場合はなにもしない
            }
        }
        else if (completed) {
            // 正常終了時
            // 編集モードを解除する
            [block_self setEditing:NO animated:YES];
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
