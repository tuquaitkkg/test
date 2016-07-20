
#import "SelectFileViewController_iPad.h"
#import "Define.h"
#import "PrintPictViewController_iPad.h"
#import "SendMailPictViewController_iPad.h"
#import "SendExSitePictViewController_iPad.h"
#import "ArrangePictViewController_iPad.h"
#import "ScanDataCell.h"
// iPad用
#import "RootViewController_iPad.h"
#import "SharpScanPrintAppDelegate.h"
#import <MobileCoreServices/UTCoreTypes.h>
// iPad用
#import <ImageIO/ImageIO.h>
#import <AssetsLibrary/AssetsLibrary.h>

#import "SearchResultViewController_iPad.h"
#import "PrintSelectTypeViewController_iPad.h"

@interface SelectFileViewController_iPad ()

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

@implementation SelectFileViewController_iPad

@synthesize PrevViewID = m_nPrevViewID;
@synthesize bSetTitle = m_bSetTitle; // iPad用
@synthesize selectIndexPath; // iPad用
@synthesize lastScrollOffSet; // iPad用
@synthesize baseDir;								// ファイルパス
@synthesize sortMenuViewController;
@synthesize sortViewPopoverController;
@synthesize bShowLeftBtn;
@synthesize sortTypeButton;
@synthesize previousOrientation;
@synthesize scanDirectory;
@synthesize indicator;

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
    DLog(@"viewDidLoad     SelectFileViewController_iPad");
    [super viewDidLoad];
    
    // UINavigationBar 44px のずれを無くす
    self.navigationController.navigationBar.translucent = NO;
    self.navigationController.navigationBar.barStyle = NAVIGATION_BARSTYLE;
    
    self.tableView.rowHeight = N_HEIGHT_SEL_FILE;
    
    // ナビゲーションバー
    // タイトル設定
    switch (self.PrevViewID)
    {
        case PV_PRINT_SELECT_FILE_CELL: {
			self.navigationItem.title = S_TITLE_PRINT;
//            // iPad用
//            // 写真アルバムボタンを追加
//            UIBarButtonItem *barItemPhoto = [[UIBarButtonItem alloc] initWithTitle:S_BUTTON_PHOTO style:UIBarButtonItemStyleBordered target:self action:@selector(OnPhotoPopOverView:withEvent:)];
//            [self.navigationItem setRightBarButtonItem:barItemPhoto];
//            // iPad用
            break;
        }
        case SendMailSelectTypeView:
			self.navigationItem.title = S_TITLE_SENDMAIL;
            [self initShareToolBar];
			break;
		case SendExSiteSelectTypeView:
			self.navigationItem.title = S_TITLE_SEND;
            [self initShareToolBar];
			break;
        case ArrangeSelectTypeView:
            self.navigationItem.title = S_TITLE_ARRANGE;
            break;
	    default:
            break;
    }
    
    // 戻るボタンの名称変更
    UIBarButtonItem * barItemBack = [UIBarButtonItem new];
    barItemBack.title = S_BUTTON_BACK;
    self.navigationItem.backBarButtonItem = barItemBack;

    if(!self.bSetTitle)
    {
        // タイトル非表示
        //self.navigationItem.title = @"";
    }
    
    // ホームディレクトリ/Documments/ 取得
	//
	NSString *tempDir	= [CommonUtil documentDir];
	self.baseDir		= [tempDir stringByAppendingString:@"/"];
    if (!self.scanDirectory) {
        self.scanDirectory = [[ScanDirectory alloc]initWithScanDirectoryPath:self.baseDir];
    }
    
    // ScanDataManagerクラス生成
    m_pScanMgr = [[ScanDataManager alloc]init];
    m_pScanMgr.fullPath = self.scanDirectory.scanDirectoryPath;
//    [m_pScanMgr reGetScanData];
    
    // TableViewのスクロール初期値設定
    self.tableView.scrollEnabled = YES;
    
    // 再描画
//    [self.tableView reloadData];
    
    // 選択情報のクリア
    if(!self.scanDirectory.isRootDirectory){
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
    
    self.previousOrientation = [[UIDevice currentDevice] orientation];
    //回転時にrotateActionが呼ばれるようにする
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didChangedOrientation:)
                                                 name:UIDeviceOrientationDidChangeNotification object:nil];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
    // iPad用
}

- (void)viewWillAppear:(BOOL)animated
{
    DLog(@"viewWillAppear     SelectFileViewController_iPad");

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
    
//    if(m_pScanMgr != nil)
//    {
//        if(!self.scanDirectory){
//            self.scanDirectory = [[ScanDirectory alloc]initWithScanDirectoryPath:self.baseDir];
//        }
//        m_pScanMgr.fullPath = self.scanDirectory.scanDirectoryPath;
//        [m_pScanMgr reGetScanData];
//    }
//    [self.tableView reloadData];
//    
//    //[super viewWillAppear:animated];
//    // 選択状態解除
//    [self.tableView deselectRowAtIndexPath:[self.tableView indexPathForSelectedRow] animated:YES];
//    
//    NSString* selectDir = [[NSUserDefaults standardUserDefaults] objectForKey:S_KEY_SELECT_DIR];
//    if (selectIndexPath != nil && ((self.scanDirectory.isRootDirectory && selectDir == nil) || [self.scanDirectory.relativeDirectoryPathInScanFile isEqualToString:selectDir]))
//    {
//        SharpScanPrintAppDelegate* pAppDelegate = (SharpScanPrintAppDelegate*)[[UIApplication sharedApplication] delegate];
//        UINavigationController* pRootNavController = [pAppDelegate.splitViewController.viewControllers objectAtIndex:0];
//        //左側のViewに設定されているクラスの名前を取得
//        NSString* leftViewClassName = [pRootNavController.topViewController description];
//        NSString* fullPath = [[NSUserDefaults standardUserDefaults] stringForKey: S_KEY_SELECT_FPATH];
//        selectIndexPath = [m_pScanMgr indexOfScanDataWithFilePath: fullPath];
//        
//        if (selectIndexPath != nil) {
//            // 左側のViewにこのクラスが表示されている場合
//            if(searchController.active){
//                searchController.searchBar.frame = (CGRect){0, 1.0, self.view.frame.size.width, SEARCHBAR_HEIGHT + 3.0};
//                if(!sortTypeButton.hidden){
//                    sortTypeButton.hidden = YES;
//                }
//            }else{
//                sortTypeButton.hidden = NO;
//                searchController.searchBar.frame = (CGRect){SORTBUTTON_WIDTH, 1.0, self.view.frame.size.width - SORTBUTTON_WIDTH, SEARCHBAR_HEIGHT + 3.0};
//            }
//            if([leftViewClassName isEqual:[self description]])
//            {
//                // 指定の行を選択状態
//                [self.tableView selectRowAtIndexPath:selectIndexPath animated:NO scrollPosition:UITableViewScrollPositionNone];
//                // 指定の位置までスクロール
//                if(selectIndexPath.section)
//                {
//                    if([[[UIDevice currentDevice] systemVersion] floatValue] < 7.0)
//                    {   // iOS7より前の場合
//                        [self.tableView scrollToRowAtIndexPath:selectIndexPath atScrollPosition:UITableViewScrollPositionTop animated:NO];
//                    }
//                }
//                else
//                {   
//                    //0件の場合
//                    [self.tableView setContentOffset:lastScrollOffSet];
//                }
//
//            }
//        }
//    }
//    // 縦表示の時はメニューボタンを表示
//    SharpScanPrintAppDelegate* pAppDelegate = (SharpScanPrintAppDelegate*)[[UIApplication sharedApplication] delegate];
//    [pAppDelegate setPortraitMenuButton];
//    
//    if (self.PrevViewID == PV_PRINT_SELECT_FILE_CELL) {
//        // 複数印刷対応_iPad
//        self.closeButton = [[UIBarButtonItem alloc]initWithTitle:S_BUTTON_CLOSE style:UIBarButtonItemStyleBordered target:self action:@selector(closeButtonPushed:)];
//        [self.navigationItem setRightBarButtonItem:self.closeButton];
//        self.multiPrintButton = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:S_ICON_MULTIPLE] style:UIBarButtonItemStyleBordered target:self action:@selector(multiPrintButtonPushed:)];
//        self.cancelButton = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:S_ICON_PRINT_CANCEL] style:UIBarButtonItemStyleBordered target:self action:@selector(cancelButtonPushed:)];
//        self.enterButton = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:S_ICON_PRINT_DECIDE] style:UIBarButtonItemStyleBordered target:self action:@selector(enterButtonPushed:)];
//        [self updateNavigationBarButton];
//        [self.navigationController setToolbarHidden:NO];
//        [self.navigationController.toolbar setBarStyle:TOOLBAR_BARSTYLE];
//    }
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

// 複数印刷対応_iPad
- (void)updateNavigationBarButton {
    if (self.PrevViewID == PV_PRINT_SELECT_FILE_CELL) {
        //スペーサー
        UIBarButtonItem* flexSpacer = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
        
        if (self.pushFlag) {
            if (self.multiPrintFlag) {
                self.tableView.editing = YES;
                NSArray *toolBarItems = @[flexSpacer, self.cancelButton,flexSpacer,self.enterButton,flexSpacer];
                self.toolbarItems = toolBarItems;
            } else {
                self.tableView.editing = NO;
                NSArray *toolBarItems = @[flexSpacer,self.multiPrintButton,flexSpacer];
                self.toolbarItems = toolBarItems;
            }
        } else {
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
     
     // popOverが開かれていたら閉じる
     if(m_popOver != nil)
     {
         [m_popOver dismissPopoverAnimated:NO];
         m_popOver = nil;
     }
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // 横向きの場合
    if(interfaceOrientation == UIInterfaceOrientationLandscapeLeft || interfaceOrientation == UIInterfaceOrientationLandscapeRight)
    {
        // 縦向き表示時のメニューPopOverが表示されていたら閉じる
        [self dismissMenuPopOver:NO];
    }
    
    // 写真アルバムが表示されていたら閉じる
    if(m_popOver)
    {
        [m_popOver dismissPopoverAnimated:NO];
    }
    return YES;
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
    if (m_popOver !=nil)
    {
        [m_popOver dismissPopoverAnimated:YES];
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
            m_searchController.searchBar.frame = (CGRect){SORTBUTTON_WIDTH, 1.0, self.view.frame.size.width - SORTBUTTON_WIDTH, SEARCHBAR_HEIGHT + 3.0};
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
 @detail 現在はUISearchController用の回転時の処理のみ(UISearchController置き換え対応時に追加)
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

-(void)viewWillLayoutSubviews
{
    // didRotateFromInterfaceOrientation:が呼ばれないのでここでサーチバーの調整をする
    if (m_searchController.isActive) {
        m_searchController.searchBar.frame = (CGRect){0.0, 1.0, self.view.frame.size.width, SEARCHBAR_HEIGHT + 3.0};
        
    } else {
        m_searchController.searchBar.frame = (CGRect){SORTBUTTON_WIDTH, 1.0, self.view.frame.size.width - SORTBUTTON_WIDTH, SEARCHBAR_HEIGHT + 3.0};
    }
}
#pragma mark - Table view data source

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
    scanData = [m_pScanMgr loadScanDataAtIndexPath: indexPath];
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
    [cell.selectImgView removeFromSuperview];
    
    // 編集モード中のフォルダーセルはアクセサリはなし
    if (self.isEditing && [[m_pScanMgr loadScanDataAtIndexPath:indexPath]isDirectory]) {
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
    
    return cell;
}

// テーブルビュー 縦幅設定
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return N_HEIGHT_SEL_FILE;
}

#pragma mark - Table view delegate

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
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
}

// 複数印刷対応_iPad
- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.tableView.editing) {
        return 3;
    } else {
        return UITableViewCellEditingStyleNone;
    }
}

// 複数印刷対応_iPad
-(NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (( self.PrevViewID == PV_PRINT_SELECT_FILE_CELL || [self isShareToolBarPrevViewID])
        && self.tableView.editing && [[m_pScanMgr loadScanDataAtIndexPath:indexPath] isDirectory]) {
        return nil;
    } else {
        return indexPath;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // セルの複数タップを制御する
    if ( ! [self.navigationController.visibleViewController isKindOfClass: [self class]] ) {
        DLog(@"visibleViewController is Invalid");
        return;
    }

    // 複数印刷対応
    if (self.tableView.editing == NO) {
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
    else {
        if ([self isShareToolBarPrevViewID]) {
            // 選択セル情報を格納
            [mArray addObject:indexPath];
            DLog(@"mArray: %@", mArray);
            
            switch (tableView.indexPathsForSelectedRows.count) {
                case 0:     //選択なし
                    shareBtn.enabled = NO;
                    break;
                default:    //1つ以上選択
                    shareBtn.enabled = YES;
                    break;
            }
        }
        
    }
}

- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.tableView.editing == NO) {
        
    } else {
        if ([self isShareToolBarPrevViewID]) {
            //選択から外す
            [mArray removeObject:indexPath];
            DLog(@"mArray: %@", mArray);
            
            switch (tableView.indexPathsForSelectedRows.count) {
                case 0:     //選択なし
                    shareBtn.enabled = NO;
                    break;
                default:    //1つ以上選択
                    shareBtn.enabled = YES;
                    break;
            }
        }
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
        
        SelectFileViewController_iPad* selectView = [[SelectFileViewController_iPad alloc] init];
        
        // 選択ファイルパス格納
        ScanData *scanData = nil;
        scanData = [m_pScanMgr loadScanDataAtIndexPath:nIndexPath];
        
        NSString *fullPath = [self.scanDirectory.scanDirectoryPath stringByAppendingPathComponent: scanData.fname];
        ScanDirectory *selectedScanDirectory = [[ScanDirectory alloc]initWithScanDirectoryPath:fullPath];
        
        selectView.scanDirectory = selectedScanDirectory;
        m_pScanMgr.fullPath = selectedScanDirectory.scanDirectoryPath;
        
        
        selectView.PrevViewID = self.PrevViewID;
        selectView.fromSelectFileVC = YES;
        
        selectView.selectIndexPath = nil;
        NSString* selectDir = [[NSUserDefaults standardUserDefaults] objectForKey:S_KEY_SELECT_DIR];
        DLog(@"select dir %@", selectDir);
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
    else
    {
        if (self.PrevViewID == PV_PRINT_SELECT_FILE_CELL) {
            // 複数印刷対応
            if (self.selectFilePathArray == nil) {
                self.selectFilePathArray = [[NSMutableArray alloc]initWithCapacity:0];
            }
            ScanData *scanData = [m_pScanMgr loadScanDataAtIndexPath:nIndexPath];
            [self.selectFilePathArray addObject:scanData];
            
            DLog(@"%@",self.selectFilePathArray);
            [self performSelector:@selector(enterButtonPushed:) withObject:nil];
            return;
        }

        // 遷移元画面から渡されたIDをもとに遷移先のViewControllerを決定する
        PictureViewController_iPad* pViewController = nil;
    
        switch (self.PrevViewID)
        {
            case PV_PRINT_SELECT_FILE_CELL:
                pViewController = [[PrintPictViewController_iPad alloc]init];
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
                pViewController = [[ArrangePictViewController_iPad alloc] init];
                pViewController.PrintPictViewID = PPV_OTHER;
                break;
            default:
                pViewController = [[PrintPictViewController_iPad alloc] init];
                pViewController.PrintPictViewID = PPV_OTHER;
                break;
        }
        
        if ( ! pViewController ) {
            pViewController = [[PrintPictViewController_iPad alloc] init];
        }
        
        // 選択ファイルパス格納
        ScanData *scanData = nil;
        scanData = [m_pScanMgr loadScanDataAtIndexPath:nIndexPath];
        NSString * filePath = [self.scanDirectory.scanDirectoryPath stringByAppendingPathComponent:scanData.fname];
        pViewController.SelFilePath = filePath;
    
        // iPad用
        //^^
        NSString* fullPath = [[NSUserDefaults standardUserDefaults] stringForKey: S_KEY_SELECT_FPATH];
        selectIndexPath = [m_pScanMgr indexOfScanDataWithFilePath: fullPath];
        [self ChangeDetailView:pViewController didSelectRowAtIndexPath:nIndexPath];
        // iPad用
        
        // 縦向き表示時のメニューPopOverが表示されていたら閉じる
        [self dismissMenuPopOver:YES];
    }

}

// おそらく使われていない
// UIImagePickerController のデリゲート
-(void) imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
}


// 印刷画面に遷移
-(void)MovePrintPictView:(NSDictionary *)info
{
    // 印刷画面に遷移
    PictureViewController_iPad* pViewController;
    pViewController = [[PrintPictViewController_iPad alloc] init];
    pViewController.PictEditInfo = info;        // image情報格納
    pViewController.IsPhotoView = TRUE;         // 遷移元画面設定
    
    //画面遷移
    [self ChangeDetailView:pViewController didSelectRowAtIndexPath:nil];
    
    // Photo Albumを閉じる
    [m_popOver dismissPopoverAnimated:YES]; 
}

// 詳細画面切換え
-(void)ChangeDetailView:(UIViewController*)pViewController didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    SharpScanPrintAppDelegate* pAppDelegate = (SharpScanPrintAppDelegate*)[[UIApplication sharedApplication] delegate];

    if (pAppDelegate.IsPreview)
    {
        NSString* fullPath = [[NSUserDefaults standardUserDefaults] stringForKey: S_KEY_SELECT_FPATH];
        selectIndexPath = [m_pScanMgr indexOfScanDataWithFilePath: fullPath];
        // 指定の行を選択状態
        [self.tableView selectRowAtIndexPath:selectIndexPath animated:NO scrollPosition:UITableViewScrollPositionNone];

        return;
    }
    
    // 選択行保持
    NSUInteger newIndex[] = {indexPath.section, indexPath.row};
    selectIndexPath = [[NSIndexPath alloc] initWithIndexes:newIndex length:2];
    
    
    // 選択ファイルの情報を保存
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
        
        //^^
        NSString* fullPath = [[NSUserDefaults standardUserDefaults] stringForKey: S_KEY_SELECT_FPATH];
        selectIndexPath = [m_pScanMgr indexOfScanDataWithFilePath: fullPath];
       // 左側のViewを更新してファイル一覧を表示
        // 左側の画面がTOPメニュー画面を表示している場合
        if ( [[[pRootNavController viewControllers] lastObject] isKindOfClass: [RootViewController_iPad class]] ) {
            RootViewController_iPad* pRootViewController = (RootViewController_iPad*)pRootNavController.topViewController;
            pRootViewController.subDir = self.scanDirectory.scanDirectoryPath;
            pRootViewController.rootDir = self.scanDirectory.relativeDirectoryPathInScanFile;
            [pRootViewController updateView:self.PrevViewID didSelectRowAtIndexPath:indexPath scrollOffset:[self.tableView contentOffset]];
            selectIndexPath = nil;
        }
        else
        {
            PrintSelectTypeViewController_iPad* pPrintSelectTypeViewController = (PrintSelectTypeViewController_iPad*)pRootNavController.topViewController;
            [pPrintSelectTypeViewController updateView:self.PrevViewID didSelectRowAtIndexPath:indexPath scrollOffset:[self.tableView contentOffset] subDir:self.scanDirectory.scanDirectoryPath rootDir:self.scanDirectory.relativeDirectoryPathInScanFile];
        }
        
        // 右側のViewを更新して画像プレビューを表示
        [self.navigationController pushViewController:pViewController animated:YES];
    }
    else
    {
        UINavigationController* pDetailNavController = [pAppDelegate.splitViewController.viewControllers objectAtIndex:1];

        // 右側の画面に詳細画面を既に表示している場合
        if ( [[[pDetailNavController viewControllers] lastObject] isKindOfClass: [PrintPictViewController_iPad class]] ) {
            // 画面を取り除く
            [pDetailNavController popViewControllerAnimated:NO];
        }
        
        // 詳細画面に表示
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
    [self.navigationItem setLeftBarButtonItem:nil animated:YES];
    if (barButtonItem != nil && m_bSetTitle && self.scanDirectory.isRootDirectory)
    {
        [self.navigationItem setLeftBarButtonItem:barButtonItem animated:YES];
    }
    if(bShowLeftBtn)
    {
        barButtonItem.title = S_BUTTON_MENU;
        [self.navigationItem setLeftBarButtonItem:barButtonItem animated:NO];
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
        headerView.backgroundColor = [UIColor grayColor];
        [headerView addSubview:label];
        // 検索バーをテーブルのヘッダー部に表示する
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
            m_searchController.searchBar.translucent = YES;
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
        [sortAndSearchViewLeft addSubview:sortTypeButton];
        [headerView addSubview: sortAndSearchViewLeft];
        // Todo 並び替えボタン表示 end
        
        [headerView addSubview: m_searchController.searchBar];
        //TableViewにヘッダー設定
        self.tableView.tableHeaderView = headerView;
        
    } else {
        
        // 戻るボタンで戻ってきたとき用の対応
        [self setSortTypeButtonImage];
    }
}

- (void) showSortPopoverview: (UIButton*) button
{
    
    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController: self.sortMenuViewController];
    
    UIPopoverController *popover = [[UIPopoverController alloc] initWithContentViewController: navigationController];
    self.sortViewPopoverController = popover;
    
    // Display the search results controller popover.
    [sortViewPopoverController presentPopoverFromRect:[button bounds]
                                               inView: button
                             permittedArrowDirections: UIPopoverArrowDirectionUp animated:YES];
}

#pragma mark - UISearchBarDelegate

//キーボードのSearchボタンタップ時に呼ばれる
-(void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    DLog(@"search");
    // iPad用
    SharpScanPrintAppDelegate* pAppDelegate = (SharpScanPrintAppDelegate*)[[UIApplication sharedApplication] delegate];
    
    SearchResultViewController_iPad* pSearchResultViewController_iPad;
    
    pSearchResultViewController_iPad = [[SearchResultViewController_iPad alloc]init];
    pSearchResultViewController_iPad.pstrSearchKeyword = searchBar.text;
    pSearchResultViewController_iPad.PrevViewID = self.PrevViewID;
    // 次画面へ渡す
    pSearchResultViewController_iPad.scanDirectory = self.scanDirectory;
    pSearchResultViewController_iPad.bCanDelete = NO;
    // 複数印刷対応_iPad
    pSearchResultViewController_iPad.fromSelectFileVC = YES;

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

// 複数印刷対応
- (void)closeButtonPushed:(id)sender {
    NSNotification *n = [NSNotification notificationWithName:NK_CLOSE_BUTTON_PUSHED object:self];
    NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
    [nc postNotification:n];
}

// 複数印刷対応
- (void)multiPrintButtonPushed:(id)sender {
    self.multiPrintFlag = YES;
    [self updateNavigationBarButton];
}

// 複数印刷対応
- (void)cancelButtonPushed:(id)sender {
    self.multiPrintFlag = NO;
    [self updateNavigationBarButton];
}

// 複数印刷対応
- (void)enterButtonPushed:(id)sender {
    if (self.multiPrintFlag) {
        if (self.selectFilePathArray == nil) {
            self.selectFilePathArray = [NSMutableArray arrayWithCapacity:0];
        }
        for (NSIndexPath *indexPath in self.tableView.indexPathsForSelectedRows) {
            ScanData *scanData = [m_pScanMgr loadScanDataAtIndexPath:indexPath];
            [self.selectFilePathArray addObject:scanData];
            DLog(@"scanData = %@",scanData);
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
    if(m_pScanMgr != nil)
    {
        if(!self.scanDirectory){
            self.scanDirectory = [[ScanDirectory alloc]initWithScanDirectoryPath:self.baseDir];
        }
        m_pScanMgr.fullPath = self.scanDirectory.scanDirectoryPath;
        [m_pScanMgr reGetScanData];
    }
    
    //[self setSortTypeButtonImage];
    
    // リロードと選択行解除(編集モードの時はしない)
    if (!self.tableView.editing) {
    [self.tableView reloadData];
    [self.tableView deselectRowAtIndexPath:[self.tableView indexPathForSelectedRow] animated:YES];
    }
    
    NSString* selectDir = [[NSUserDefaults standardUserDefaults] objectForKey:S_KEY_SELECT_DIR];
    if (selectIndexPath != nil && ((self.scanDirectory.isRootDirectory && selectDir == nil) || [self.scanDirectory.relativeDirectoryPathInScanFile isEqualToString:selectDir]))
    {
        SharpScanPrintAppDelegate* pAppDelegate = (SharpScanPrintAppDelegate*)[[UIApplication sharedApplication] delegate];
        UINavigationController* pRootNavController = [pAppDelegate.splitViewController.viewControllers objectAtIndex:0];
        //左側のViewに設定されているクラスの名前を取得
        NSString* leftViewClassName = [pRootNavController.topViewController description];
        NSString* fullPath = [[NSUserDefaults standardUserDefaults] stringForKey: S_KEY_SELECT_FPATH];
        selectIndexPath = [m_pScanMgr indexOfScanDataWithFilePath: fullPath];
        
        if (selectIndexPath != nil) {
            // 左側のViewにこのクラスが表示されている場合
            if(m_searchController.active){
                m_searchController.searchBar.frame = (CGRect){0, 1.0, self.view.frame.size.width, SEARCHBAR_HEIGHT + 3.0};
                if(!sortTypeButton.hidden){
                    sortTypeButton.hidden = YES;
                }
            }else{
                sortTypeButton.hidden = NO;
                m_searchController.searchBar.frame = (CGRect){SORTBUTTON_WIDTH, 1.0, self.view.frame.size.width - SORTBUTTON_WIDTH, SEARCHBAR_HEIGHT + 3.0};
            }
            if([leftViewClassName isEqual:[self description]])
            {
                // 指定の行を選択状態
                if (!self.tableView.editing) {
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
    }
    // 縦表示の時はメニューボタンを表示
    SharpScanPrintAppDelegate* pAppDelegate = (SharpScanPrintAppDelegate*)[[UIApplication sharedApplication] delegate];
    [pAppDelegate setPortraitMenuButton];
    
    if (self.PrevViewID == PV_PRINT_SELECT_FILE_CELL) {
        // 複数印刷対応_iPad
        self.closeButton = [[UIBarButtonItem alloc]initWithTitle:S_BUTTON_CLOSE style:UIBarButtonItemStylePlain target:self action:@selector(closeButtonPushed:)];
        [self.navigationItem setRightBarButtonItem:self.closeButton];
        self.multiPrintButton = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:S_ICON_MULTIPLE] style:UIBarButtonItemStylePlain target:self action:@selector(multiPrintButtonPushed:)];
        self.cancelButton = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:S_ICON_PRINT_CANCEL] style:UIBarButtonItemStylePlain target:self action:@selector(cancelButtonPushed:)];
        self.enterButton = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:S_ICON_PRINT_DECIDE] style:UIBarButtonItemStylePlain target:self action:@selector(enterButtonPushed:)];
        [self updateNavigationBarButton];
        [self.navigationController setToolbarHidden:NO];
        [self.navigationController.toolbar setBarStyle:TOOLBAR_BARSTYLE];
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
    
    __block SelectFileViewController_iPad *block_self = self;
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
    
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil
                                                                             message:aDescription
                                                                      preferredStyle:UIAlertControllerStyleAlert];
    
    // OK用のアクションを生成
    UIAlertAction * okAction =
    [UIAlertAction actionWithTitle:MSG_BUTTON_OK
                             style:UIAlertActionStyleDefault
                           handler:^(UIAlertAction * action) {
                               
                               // ボタンタップ時の処理
                               [self appDelegateIsRunOff];
                           }];
    
    // コントローラにアクションを追加
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

// 編集モード変更
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
        
        for (NSInteger row = 0; row < [mArray count] ; row++)
        {
            // チェックボックス切り替え
            ScanDataCell *cell = (ScanDataCell*)[self.tableView cellForRowAtIndexPath:[mArray objectAtIndex:row]];
            
            cell.selectImgView.tag = 0;
            [cell setImageModel];
        }
        
        [mArray removeAllObjects];
        
        // ボタンの設定を戻す
        shareBtn.enabled = NO;
        
        [self.navigationItem setHidesBackButton:NO animated:YES];
        
        // 通常モードでの選択位置に選択状態を設定
        NSString* fullPath = [[NSUserDefaults standardUserDefaults] stringForKey: S_KEY_SELECT_FPATH];
        selectIndexPath = [m_pScanMgr indexOfScanDataWithFilePath: fullPath];
        // 指定の行を選択状態
        [self.tableView selectRowAtIndexPath:selectIndexPath animated:NO scrollPosition:UITableViewScrollPositionNone];
        
        // 共有ボタンのToolBarの場合は編集モードOFFと同時にToolBarを非表示にする。
        if (self.PrevViewID == SendMailSelectTypeView || self.PrevViewID == SendExSiteSelectTypeView) {
            [self.navigationController setToolbarHidden:YES animated:NO];
        }
        
    }
}


@end
