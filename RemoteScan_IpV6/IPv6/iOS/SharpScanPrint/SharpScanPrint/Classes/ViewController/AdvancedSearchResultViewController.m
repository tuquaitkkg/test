
#import "AdvancedSearchResultViewController.h"
//#import "SearchResultViewController.h"
#import "CommonUtil.h"
#import "Define.h"
#import "PictureViewController.h"
#import "PrintPictViewController.h"
#import "SendMailPictViewController.h"
#import "SendExSitePictViewController.h"
#import "ArrangePictViewController.h"
#import "ScanDataCell.h"
#import "ScanDataManager.h"
#import <MessageUI/MessageUI.h> // メールの設定確認
// iPad用
#import "RootViewController_iPad.h"
#import "SharpScanPrintAppDelegate.h"
#import "AdvancedSearchViewController.h"

@interface AdvancedSearchResultViewController ()

// 複数印刷対応
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

@implementation AdvancedSearchResultViewController

@synthesize PrevViewID = m_nPrevViewID;
@synthesize bSetTitle = m_bSetTitle; // iPad用
@synthesize selectIndexPath; // iPad用
@synthesize lastScrollOffSet; // iPad用
@synthesize baseDir;								// ファイルパス
@synthesize bCanDelete; // iPad用
@synthesize pstrSearchKeyword;                  // 検索文字
@synthesize bSubFolder;                         // 検索範囲(サブフォルダーを含む)
@synthesize bFillterFolder;                     // 検索対象(フォルダー)
@synthesize bFillterPdf;                        // 検索対象(PDF)
@synthesize bFillterTiff;                       // 検索対象(TIFF)
@synthesize bFillterImage;                      // 検索対象(JPEG,PNG)
@synthesize bFillterOffice;                     // 検索対象(OFFICE)
@synthesize sessionViewController;
@synthesize scanDirectory;
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
    [super viewDidLoad];
    
    self.tableView.rowHeight = N_HEIGHT_SEL_FILE;
    
    // iPad用
    // hikubota delete left view 用
    if(!self.bSetTitle)
    {
        // タイトル非表示
        self.navigationItem.title = @"";
    }
    // iPad用
    
    // ホームディレクトリ/Documments/ 取得
	//
	NSString *tempDir	= [CommonUtil documentDir];
	self.baseDir		= [tempDir stringByAppendingString:@"/"];
    
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
//    [m_pScanMgr reGetScanData];
//    // タイトル設定
//    [self updateTitle];
    
    // TableViewのスクロール初期値設定
    self.tableView.scrollEnabled = YES;

    //
    // sort用のpopupの設定
    //
    sortViewPopUp = [[SelectFileSortPopViewController alloc] initWithStyle:UITableViewStyleGrouped];
    [sortViewPopUp setDelegate:self];
    
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
        [self initShareToolBar];
    }
    
    // 選択情報のクリア
    if(self.scanDirectory.isRootDirectory){
        NSUserDefaults* ud = [NSUserDefaults standardUserDefaults];
        [ud removeObjectForKey:S_KEY_SELECT_DIR];
        [ud removeObjectForKey:S_KEY_SELECT_INDEX_SECTION];
        [ud removeObjectForKey:S_KEY_SELECT_INDEX_ROW];
        [ud removeObjectForKey:S_KEY_SELECT_FPATH];
        [ud synchronize];
    }
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
    // iPad用
    if (nil != m_pScanMgr)
    {
        m_pScanMgr = nil;
    }
    if (nil != selectIndexPath)
    {
        selectIndexPath = nil;
    }
    // iPad用
}

//
// アプリケーションの終了直前に呼ばれるメソッド
//

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];

    // タップ済みフラグを初期化する
    self.isFirstTap = NO;
    
    [self SetHeaderView];
    
    // indicatorを開始する
    [self indicatorStart];
    
    // 時間がかかる処理をバックグラウンドで実行する
    [self performSelectorInBackground:@selector(lateProcessing) withObject:nil];
    
//    if(m_pScanMgr != nil)
//    {
//        m_pScanMgr.fullPath = self.scanDirectory.scanDirectoryPath;
//        m_pScanMgr.IsSearchView = YES;
//        m_pScanMgr.IsAdvancedSearch = YES;
//        m_pScanMgr.IsSubFolder = self.bSubFolder;
//        m_pScanMgr.IsFillterFolder = self.bFillterFolder;
//        m_pScanMgr.IsFillterPdf = self.bFillterPdf;
//        m_pScanMgr.IsFillterTiff = self.bFillterTiff;
//        m_pScanMgr.IsFillterImage = self.bFillterImage;
//        m_pScanMgr.IsFillterOffice = self.bFillterOffice;
//        m_pScanMgr.searchKeyword = self.pstrSearchKeyword;
//        [m_pScanMgr reGetScanData];
//    }
//    [self.tableView reloadData];
//    
//    [super viewWillAppear:animated];
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
//        
//        //^^
//        NSString* fullPath = [[NSUserDefaults standardUserDefaults] stringForKey: S_KEY_SELECT_FPATH];
//        selectIndexPath = [m_pScanMgr indexOfScanDataWithFilePath: fullPath];
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
//            
//        }
//    }
//    
//    // 複数印刷対応
//    // 整理する画面の場合
//    if(self.PrevViewID != SendMailSelectTypeView &&
//       self.PrevViewID != SendExSiteSelectTypeView &&
//       self.PrevViewID != ArrangeSelectTypeView)
//    {
//        self.closeButton = [[UIBarButtonItem alloc]initWithTitle:S_BUTTON_CLOSE style:UIBarButtonItemStyleBordered target:self action:@selector(closeButtonPushed:)];
//        [self.navigationItem setRightBarButtonItem:self.closeButton];
//    }
//    self.multiPrintButton = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:S_ICON_MULTIPLE] style:UIBarButtonItemStyleBordered target:self action:@selector(multiPrintButtonPushed:)];
//    self.cancelButton = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:S_ICON_PRINT_CANCEL] style:UIBarButtonItemStyleBordered target:self action:@selector(cancelButtonPushed:)];
//    self.enterButton = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:S_ICON_PRINT_DECIDE] style:UIBarButtonItemStyleBordered target:self action:@selector(enterButtonPushed:)];
//    [self updateNavigationBarButton];
//    if(self.PrevViewID == PV_PRINT_SELECT_FILE_CELL) {
//        [self.navigationController setToolbarHidden:NO];
//    }
//    [self.navigationController.toolbar setBarStyle:TOOLBAR_BARSTYLE];
}

// 複数印刷対応
- (void)updateNavigationBarButton {
    if (self.PrevViewID == PV_PRINT_SELECT_FILE_CELL) {
        //スペーサー
        UIBarButtonItem* flexSpacer = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
        
        if (self.pushFlag) {
            if (self.multiPrintFlag) {
                self.tableView.editing = YES;
                NSArray *toolBarItems = @[flexSpacer,self.cancelButton,flexSpacer,self.enterButton,flexSpacer];
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

-(void)viewWillDisappear:(BOOL)animated
{
    [self.delegate willDisAppearAdvancedSearchResultViewController:self];
    
    [super viewWillDisappear:animated];
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
    
    // 複数印刷対応
    if (self.PrevViewID == PV_PRINT_SELECT_FILE_CELL) {
        [cell.selectImgView removeFromSuperview];
    }
    
    // データ取得
    ScanData *scanData = nil;
    scanData = [m_pScanMgr loadScanDataAtIndexPath:indexPath];
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
            BOOL bRet = NO;
            ScanData *scanData = [m_pScanMgr loadScanDataAtIndexPath:indexPath];
            NSString *path = [scanData.fpath stringByAppendingPathComponent:scanData.fname];
            
            if(scanData.isDirectory){
                ScanDirectory *selectedScanDirectory = [[ScanDirectory alloc]initWithScanDirectoryPath:path];
                bRet = [ScanDirectoryUtility deleteDirectory:selectedScanDirectory];
            }else{
                ScanFile *selectedScanFile = [[ScanFile alloc]initWithScanFilePath:path];
                bRet = [ScanFileUtility deleteFile:selectedScanFile];
            }
            
            if (bRet == YES)
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

// 複数印刷対応
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
    // 複数印刷対応
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
    // 複数印刷対応
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
            ArrengeSelectFileViewController* selectView;
            selectView = [[ArrengeSelectFileViewController alloc] init];
            selectView.PrevViewID = self.PrevViewID;
            
            // 選択ファイルパス格納
            ScanData *scanData = nil;
            scanData = [m_pScanMgr loadScanDataAtIndexPath:nIndexPath];
            //            if(self.subDir == nil)
            //            {
            //                selectView.subDir = [NSString stringWithFormat:@"%@/%@" , m_pScanMgr.baseDir, scanData.fname];
            
            //                selectView.rootDir = [NSString stringWithFormat:@"/%@" , [scanData.fname substringFromIndex:4]];
            
            //            }
            //            else
            //            {
            //                selectView.subDir = [NSString stringWithFormat:@"%@/%@" , self.subDir, scanData.fname];
            //                selectView.rootDir = [NSString stringWithFormat:@"%@/%@" , self.rootDir, [scanData.fname substringFromIndex:4]];
            //            }
//            selectView.rootDir = [[CommonUtil rootDirPath:scanData.fpath] stringByAppendingPathComponent:[scanData.fname substringFromIndex:4]];
//            
//            selectView.subDir	= [NSString stringWithFormat:@"%@/%@" , scanData.fpath, scanData.fname];
            NSString *directoryPath = [NSString stringWithFormat:@"%@/%@" , scanData.fpath, scanData.fname];
            ScanDirectory *localScanDirectory = [[ScanDirectory alloc] initWithScanDirectoryPath:directoryPath];
            selectView.scanDirectory = localScanDirectory;
            m_pScanMgr.fullPath = selectView.scanDirectory.scanDirectoryPath;
//            selectView.selectIndexPath = nil;
            NSString* selectDir = [[NSUserDefaults standardUserDefaults] objectForKey:S_KEY_SELECT_DIR];
            if ([selectView.scanDirectory.relativeDirectoryPathInScanFile isEqualToString:selectDir]){
//                NSNumber* sec = [[NSUserDefaults standardUserDefaults] objectForKey:S_KEY_SELECT_INDEX_SECTION];
//                NSNumber* row = [[NSUserDefaults standardUserDefaults] objectForKey:S_KEY_SELECT_INDEX_ROW];
//                selectView.selectIndexPath = [NSIndexPath indexPathForRow:row.intValue inSection:sec.intValue];
                //^^
                NSString* fullPath = [[NSUserDefaults standardUserDefaults] stringForKey: S_KEY_SELECT_FPATH];
                selectIndexPath = [m_pScanMgr indexOfScanDataWithFilePath: fullPath];
            }
            
            UINavigationController* pRootNavController = [pAppDelegate.splitViewController.viewControllers objectAtIndex:0];
            //左側のViewに設定されているクラスの名前を取得
            NSString* leftViewClassName = [pRootNavController.topViewController description];
            // 左側のViewに自身が表示されていない場合
            if(![leftViewClassName isEqual:[self description]])
            {
//                selectView.bSetTitle = YES;
            }
            
            [self.navigationController pushViewController:selectView animated:YES];
            
        } else if (self.PrevViewID == PV_PRINT_SELECT_FILE_CELL) {
            SelectFileViewController* selectView = [[SelectFileViewController alloc] init];
            
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
            SelectFileViewController* selectView = [[SelectFileViewController alloc] init];
            // 選択ファイルパス格納
            ScanData *scanData = nil;
            scanData = [m_pScanMgr loadScanDataAtIndexPath:nIndexPath];
            //            if(self.subDir == nil)
            //            {
            //                selectView.subDir = [NSString stringWithFormat:@"%@/%@" , m_pScanMgr.baseDir, scanData.fname];
            //                selectView.rootDir = [NSString stringWithFormat:@"/%@" , [scanData.fname substringFromIndex:4]];
            
            //            }
            //            else
            //            {
            //                selectView.subDir = [NSString stringWithFormat:@"%@/%@" , self.subDir, scanData.fname];
            //                selectView.rootDir = [NSString stringWithFormat:@"%@/%@" , self.rootDir, [scanData.fname substringFromIndex:4]];
            //            }
//            selectView.rootDir = [[CommonUtil rootDirPath:scanData.fpath] stringByAppendingPathComponent:[scanData.fname substringFromIndex:4]];
            
//            selectView.subDir	= [NSString stringWithFormat:@"%@/%@" , scanData.fpath, scanData.fname];
            NSString *directoryPath = [NSString stringWithFormat:@"%@/%@" , scanData.fpath, scanData.fname];
            ScanDirectory *localScanDirectory = [[ScanDirectory alloc] initWithScanDirectoryPath:directoryPath];
            selectView.scanDirectory = localScanDirectory;
            m_pScanMgr.fullPath = selectView.scanDirectory.scanDirectoryPath;
            selectView.PrevViewID = self.PrevViewID;
            selectView.selectIndexPath = nil;
            NSString* selectDir = [[NSUserDefaults standardUserDefaults] objectForKey:S_KEY_SELECT_DIR];
            if ([selectView.scanDirectory.relativeDirectoryPathInScanFile isEqualToString:selectDir]){
//                NSNumber* sec = [[NSUserDefaults standardUserDefaults] objectForKey:S_KEY_SELECT_INDEX_SECTION];
//                NSNumber* row = [[NSUserDefaults standardUserDefaults] objectForKey:S_KEY_SELECT_INDEX_ROW];
//                selectView.selectIndexPath = [NSIndexPath indexPathForRow:row.intValue inSection:sec.intValue];
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
        // 複数印刷対応
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
        PictureViewController* pViewController;
//        pViewController = [[PrintPictViewController alloc] init];
        
        switch (self.PrevViewID)
        {
            case PV_PRINT_SELECT_FILE_CELL:
                pViewController = [[PrintPictViewController alloc] init];
                pViewController.PrintPictViewID = PPV_PRINT_SELECT_FILE_CELL;
                break;
            case SendMailSelectTypeView:
                pViewController = [[SendMailPictViewController alloc] init];
                pViewController.PrintPictViewID = PPV_OTHER;
                break;
            case SendExSiteSelectTypeView:
                pViewController = [[SendExSitePictViewController alloc] init];
                pViewController.PrintPictViewID = PPV_OTHER;
                break;
            case ArrangeSelectTypeView:
                pViewController =[[ArrangePictViewController alloc] init];
                pViewController.PrintPictViewID = PPV_OTHER;
                break;
            default:
                pViewController = [[PrintPictViewController alloc] init];
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
    // 複数印刷対応
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
        //^^
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
        // 左側のViewを更新してファイル一覧を表示
        RootViewController_iPad* pRootViewController = (RootViewController_iPad*)pRootNavController.topViewController;
        pRootViewController.subDir = self.scanDirectory.scanDirectoryPath;
        pRootViewController.rootDir = self.scanDirectory.relativeDirectoryPathInScanFile;
        pRootViewController.pstrSearchKeyword = self.pstrSearchKeyword;
        pRootViewController.bSubFolder = self.bSubFolder;
        pRootViewController.bFillterFolder = self.bFillterFolder;
        pRootViewController.bFillterPdf = self.bFillterPdf;
        pRootViewController.bFillterTiff = self.bFillterTiff;
        pRootViewController.bFillterImage = self.bFillterImage;
        pRootViewController.bFillterOffice = self.bFillterOffice;
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
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil
                                                                             message:MSG_DEL_FILE_FOLDER_CONFIRM
                                                                      preferredStyle:UIAlertControllerStyleAlert];
    // Cancel用のアクションを生成
    UIAlertAction * cancelAction =
    [UIAlertAction actionWithTitle:S_BUTTON_CANCEL
                             style:UIAlertActionStyleCancel
                           handler:^(UIAlertAction * action) {
                               
                               // ボタンタップ時の処理
                               DLog(@"Cancelボタン押下");
                               [self appDelegateIsRunOff];
                           }];
    
    // OK用のアクションを生成
    UIAlertAction * okAction =
    [UIAlertAction actionWithTitle:MSG_BUTTON_OK
                             style:UIAlertActionStyleDefault
                           handler:^(UIAlertAction * action) {
                               
                               // ボタンタップ時の処理
                               [self okButtonPushed];
                               [self appDelegateIsRunOff];
                           }];
    
    // コントローラにアクションを追加
    [alertController addAction:cancelAction];
    [alertController addAction:okAction];
    // アラート表示処理
    [self presentViewController:alertController animated:YES completion:nil];
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
    pFileNameChangeViewController.SelFilePath = [NSString stringWithFormat:@"%@/" , scanData.fpath];
    
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

// 処理実行フラグをOFFにする
- (void)appDelegateIsRunOff {
    // ボタンタップ時の処理
    SharpScanPrintAppDelegate* appDelegate = (SharpScanPrintAppDelegate*)[[UIApplication sharedApplication] delegate];
    // 処理実行フラグOFF
    appDelegate.IsRun = FALSE;
}

// OKボタンタップ時の処理(削除用)
- (void)okButtonPushed {
    DLog(@"OKボタン押下");
    NSInteger row = 0;
    
    //
    // ファイル削除
    //
    @autoreleasepool
    {
        NSString *path;
        
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
    
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil
                                                                             message:MSG_DEL_COMPLETE
                                                                      preferredStyle:UIAlertControllerStyleAlert];
    // OK用のアクションを生成
    UIAlertAction * okAction =
    [UIAlertAction actionWithTitle:MSG_BUTTON_OK
                             style:UIAlertActionStyleDefault
                           handler:^(UIAlertAction * action) {
                               
                               // ボタンタップ時の処理
                               DLog(@"OKボタン押下");
                               [self appDelegateIsRunOff];
                           }];
    
    // コントローラにアクションを追加
    [alertController addAction:okAction];
    // アラート表示処理
    [self presentViewController:alertController animated:YES completion:nil];
    
    [self setEditing:NO animated:NO];
    [m_pScanMgr reGetScanData];
    // タイトルを更新
    [self updateTitle];
    [self.tableView reloadData];
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
        
        [self.navigationItem setHidesBackButton:NO animated:YES];
        // 整理する画面の場合、メールに添付する、アプリケーションに送るの場合
        if(self.PrevViewID == ArrangeSelectTypeView || [self isShareToolBarPrevViewID]) {
            [self.navigationController setToolbarHidden:YES animated:NO];
        }
    }
}

// ヘッダー表示
- (void)SetHeaderView
{
    if (!self.tableView.tableHeaderView) {
        
        UILabel *label = [[UILabel alloc] init];
        label.frame = CGRectMake(10.0, 44.0, self.view.frame.size.width-20.0, 24.0);
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
        UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0.0, 0.0, self.view.frame.size.width, 69.0)];
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
            m_searchController.searchBar.frame = CGRectMake(SORTBUTTON_WIDTH, 0.0, self.view.frame.size.width - (SORTBUTTON_WIDTH + ADVANCEDSEARCHBUTTON_WIDTH), SEARCHBAR_HEIGHT);
            
            // searchBarの設定
            m_searchController.searchBar.delegate = self;
            m_searchController.searchBar.showsCancelButton = NO;
            m_searchController.searchBar.placeholder = S_SEARCH_PLACEHOLDER;
            m_searchController.searchBar.text = pstrSearchKeyword;
            m_searchController.searchBar.keyboardType = UIKeyboardTypeDefault;
            m_searchController.searchBar.keyboardAppearance = UIKeyboardAppearanceLight;
            m_searchController.searchBar.barStyle = TOOLBAR_BARSTYLE;
            m_searchController.searchBar.searchBarStyle = UISearchBarStyleMinimal;
            for (UIView *subView in [m_searchController.searchBar subviews]) {
                for (UIView *secondLevelSubview in subView.subviews){
                    if([secondLevelSubview isKindOfClass:[UITextField class]]) {
                        UITextField *textField = (UITextField *)secondLevelSubview;
                        [textField setFont:[UIFont systemFontOfSize:10]];
                        [textField setAdjustsFontSizeToFitWidth:6];
                    }
                }
            }
            m_searchController.searchBar.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleRightMargin;
        }
        else
        {
            m_searchController.searchBar.frame = CGRectMake(SORTBUTTON_WIDTH, 0.0, self.view.frame.size.width - (SORTBUTTON_WIDTH + ADVANCEDSEARCHBUTTON_WIDTH), SEARCHBAR_HEIGHT - 1);
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
                for (UIView *subView in [m_searchController.searchBar subviews]) {
                    for (UIView *secondLevelSubview in subView.subviews){
                        if([secondLevelSubview isKindOfClass:[UITextField class]]) {
                            UITextField *textField = (UITextField *)secondLevelSubview;
                            [textField setFont:[UIFont systemFontOfSize:10]];
                            [textField setAdjustsFontSizeToFitWidth:6];
                        }
                    }
                }
            } else {
                UITextField *textField = [[m_searchController.searchBar subviews] objectAtIndex:1];
                [textField setFont:[UIFont fontWithName:@"Helvetica" size:10]];
            }
            m_searchController.searchBar.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleRightMargin;
            // 検索バーが上に移動するコントローラーを使う
            m_searchController.delegate = self;
        }
        
        // Todo 並べ替え & 検索バーをテーブルのヘッダー部に表示する
        UINavigationBar *sortAndSearchView = [[UINavigationBar alloc] initWithFrame:CGRectMake(0.0, 0.0, self.view.frame.size.width, SEARCHBAR_HEIGHT)];
        sortAndSearchView.barStyle = NAVIGATION_BARSTYLE;
        sortAndSearchView.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        
        // Todo 並び替えボタン表示 start
        //並べ替え用ボタンを生成（現在の検索キーを表示)
        sortTypeButton = [UIButton buttonWithType: UIButtonTypeCustom];
        [sortTypeButton setExclusiveTouch: YES];
        sortTypeButton.frame = CGRectMake(0, 0, SORTBUTTON_WIDTH, SEARCHBAR_HEIGHT);
        sortTypeButton.titleLabel.font = [UIFont fontWithName:@"AppleGothic" size:24];
        sortTypeButton.titleLabel.textAlignment = NSTextAlignmentRight;
        sortTypeButton.titleLabel.baselineAdjustment = UIBaselineAdjustmentAlignBaselines;
        sortTypeButton.titleLabel.adjustsFontSizeToFitWidth = NO;
        
        [self setSortTypeButtonImage];
        
        sortTypeButton.titleLabel.textColor = [UIColor whiteColor];
        sortTypeButton.backgroundColor = [UIColor clearColor];
        
        [sortTypeButton addTarget:self action:@selector(showSortPopupView:) forControlEvents:UIControlEventTouchUpInside]; // for modal(popup)
        
        //    UIButton* m_pbtnSort = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        //    m_pbtnSort.frame = CGRectMake(0.0, 5.0, SORTBUTTON_WIDTH, 34.0);
        //    m_pbtnSort.titleLabel.text = @"並び";
        // Todo 並び替えボタン表示 end
        
        // Todo 詳細検索ボタン表示 start
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
        
        // 並べ替え & 検索バーをテーブルのヘッダー部に表示する
        [sortAndSearchView addSubview:sortTypeButton];
        //[sortAndSearchView addSubview:m_pbtnSort];
        [sortAndSearchView addSubview:m_pbtnAdvancedSearch];
        [headerView addSubview:sortAndSearchView];
        // Todo 詳細検索ボタン表示 end
        
        [headerView addSubview:m_searchController.searchBar];
        
        
        //TableViewにヘッダー設定
        self.tableView.tableHeaderView = headerView;
        
    } else {
        // 検索バーを表示する
        if (floor(NSFoundationVersionNumber) > NSFoundationVersionNumber_iOS_6_1) {
            [self.tableView insertSubview:m_searchController.searchBar aboveSubview:self.tableView];
        }
        
        // 戻るボタンの遷移時用の対応
        [self setSortTypeButtonImage];
    }
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
    
    [m_searchController setActive:NO];
    
    sortTypeButton.hidden = NO;
    m_pbtnAdvancedSearch.hidden = NO;
    
    [self SetHeaderView];   // searchBarをテーブルヘッダーに戻す
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
    
    self.navigationController.navigationBar.translucent = YES;  // 検索モード時にサーチバーの位置がずれる対応(検索モード中のみYESとする)
    
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
    
    // サーチバーの横幅調整(widthやorigin.xの設定はここでは正しく設定できないが、origin.yの調整はここで行わないとアニメーションが不自然になる。)
    searchController.searchBar.frame = CGRectMake(SORTBUTTON_WIDTH, 0.0, self.view.frame.size.width - (SORTBUTTON_WIDTH + ADVANCEDSEARCHBUTTON_WIDTH), SEARCHBAR_HEIGHT);   // didDismissと同じ設定。
    
    sortTypeButton.hidden = NO;
    m_pbtnAdvancedSearch.hidden = NO;
    
    [self.tableView insertSubview:m_searchController.searchBar aboveSubview:self.tableView];
    
    self.navigationController.navigationBar.translucent = NO;
    
    [UIView commitAnimations];
    
}
// 検索モードが解除された後に呼ばれる
- (void)didDismissSearchController:(UISearchController *)searchController {
    
    // サーチバーの横幅調整(origin.xやwidthの調整はここで行う。)
    searchController.searchBar.frame = CGRectMake(SORTBUTTON_WIDTH, 0.0, self.view.frame.size.width - (SORTBUTTON_WIDTH + ADVANCEDSEARCHBUTTON_WIDTH), SEARCHBAR_HEIGHT);   // willDismissと同じ設定。
    searchController.searchBar.text = self.pstrSearchKeyword;
    
}

#pragma mark - RightBarButtonClicked
// 詳細検索画面（モーダル）で検索押下時
-(void)advancedSearchRightBarButtonClicked
{
    // モーダルを閉じる
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
        self.sessionViewController.pstrSearchKeyword = self.pstrSearchKeyword;
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
    
    lblTitle.adjustsFontSizeToFitWidth = YES;
    
    // タイトルを更新
    //    self.navigationItem.title = [NSString stringWithFormat:S_TITLE_SEARCHRESULT, [m_pScanMgr countOfSearchScanData]];
}

#pragma mark - sort messages
- (void) showSortPopupView:(UIButton *)button
{
    // 編集モードOFF
    [self setEditing:NO animated:NO];
    
    UIBarButtonItem * barItemBack = [UIBarButtonItem new];
    barItemBack.title = S_BUTTON_CANCEL;
    [barItemBack setTarget:self];
    [barItemBack setAction: @selector(closeSortPopupView)];
    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController: sortViewPopUp];
    navigationController.navigationBar.barStyle = NAVIGATION_BARSTYLE;
    navigationController.navigationBar.topItem.title = S_SORT_TITLE;
	UIBarButtonItem *addButton = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"AddTitle", @"")
																   style:UIBarButtonItemStylePlain
																  target:self
																  action:@selector(closeSortPopupView)];
    addButton.enabled = YES;
	navigationController.navigationItem.rightBarButtonItem = addButton;

    [self presentViewController:navigationController animated:YES completion:nil];
}

- (void) closeSortPopupView
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

// change sort key
- (void) changeSortType: (UIButton*) button
{
    //    [self.delegate setSortType:(enum ScanDataSortType)button.tag];
    switch (button.tag) {
        case 100:
            [CommonUtil setScanDataSortType:SCANDATA_FILEDATE];
            break;
        case 101:
            [CommonUtil setScanDataSortType:SCANDATA_FILEDATE];
            [CommonUtil ScanDataSortDirectionType:SCANDATA_ASC];
            break;
        case 102:
            [CommonUtil setScanDataSortType:SCANDATA_FILEDATE];
            [CommonUtil ScanDataSortDirectionType:SCANDATA_DES];
            break;
        case 200:
            [CommonUtil setScanDataSortType:SCANDATA_FILENAME];
            break;
        case 201:
            [CommonUtil setScanDataSortType:SCANDATA_FILENAME];
            [CommonUtil ScanDataSortDirectionType:SCANDATA_ASC];
            break;
        case 202:
            [CommonUtil setScanDataSortType:SCANDATA_FILENAME];
            [CommonUtil ScanDataSortDirectionType:SCANDATA_DES];
            break;
        case 300:
            [CommonUtil setScanDataSortType:SCANDATA_FILESIZE];
            break;
        case 301:
            [CommonUtil setScanDataSortType:SCANDATA_FILESIZE];
            [CommonUtil ScanDataSortDirectionType:SCANDATA_ASC];
            break;
        case 302:
            [CommonUtil setScanDataSortType:SCANDATA_FILESIZE];
            [CommonUtil ScanDataSortDirectionType:SCANDATA_DES];
            break;
        case 400:
            [CommonUtil setScanDataSortType:SCANDATA_FILETYPE];
            break;
        case 401:
            [CommonUtil setScanDataSortType:SCANDATA_FILETYPE];
            [CommonUtil ScanDataSortDirectionType:SCANDATA_ASC];
            break;
        case 402:
            [CommonUtil setScanDataSortType:SCANDATA_FILETYPE];
            [CommonUtil ScanDataSortDirectionType:SCANDATA_DES];
            break;
        default:
            break;
    }
    
//    [self viewWillAppear:YES];
    [self dismissViewControllerAnimated:YES completion:nil];
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
    }
    [self.tableView reloadData];
    
    // 選択状態解除
    [self.tableView deselectRowAtIndexPath:[self.tableView indexPathForSelectedRow] animated:YES];
    
    NSString* selectDir = [[NSUserDefaults standardUserDefaults] objectForKey:S_KEY_SELECT_DIR];
    if (selectIndexPath != nil && ((self.scanDirectory.isRootDirectory && selectDir == nil) || [self.scanDirectory.relativeDirectoryPathInScanFile isEqualToString:selectDir]))
    {
        SharpScanPrintAppDelegate* pAppDelegate = (SharpScanPrintAppDelegate*)[[UIApplication sharedApplication] delegate];
        UINavigationController* pRootNavController = [pAppDelegate.splitViewController.viewControllers objectAtIndex:0];
        //左側のViewに設定されているクラスの名前を取得
        NSString* leftViewClassName = [pRootNavController.topViewController description];
        
        //^^
        NSString* fullPath = [[NSUserDefaults standardUserDefaults] stringForKey: S_KEY_SELECT_FPATH];
        selectIndexPath = [m_pScanMgr indexOfScanDataWithFilePath: fullPath];
        
        // 左側のViewにこのクラスが表示されている場合
        if([leftViewClassName isEqual:[self description]])
        {
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
    
    // 複数印刷対応
    // 整理する画面の場合
    if(self.PrevViewID != SendMailSelectTypeView &&
       self.PrevViewID != SendExSiteSelectTypeView &&
       self.PrevViewID != ArrangeSelectTypeView)
    {
        self.closeButton = [[UIBarButtonItem alloc]initWithTitle:S_BUTTON_CLOSE style:UIBarButtonItemStylePlain target:self action:@selector(closeButtonPushed:)];
        [self.navigationItem setRightBarButtonItem:self.closeButton];
    }
    self.multiPrintButton = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:S_ICON_MULTIPLE] style:UIBarButtonItemStylePlain target:self action:@selector(multiPrintButtonPushed:)];
    self.cancelButton = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:S_ICON_PRINT_CANCEL] style:UIBarButtonItemStylePlain target:self action:@selector(cancelButtonPushed:)];
    self.enterButton = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:S_ICON_PRINT_DECIDE] style:UIBarButtonItemStylePlain target:self action:@selector(enterButtonPushed:)];
    [self updateNavigationBarButton];
    if(self.PrevViewID == PV_PRINT_SELECT_FILE_CELL) {
        [self.navigationController setToolbarHidden:NO];
    }
    [self.navigationController.toolbar setBarStyle:TOOLBAR_BARSTYLE];
    
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
    
    UIActivityViewController *activityViewController = [[UIActivityViewController alloc] initWithActivityItems:filePathArray applicationActivities:nil];
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
                    [self setAlert:MSG_MAIL_START_ERR];
                }
                else {
                    // 編集モードを解除する
                    [self setEditing:NO animated:YES];
                }
            }
            else if (activityType != nil) {
                // なにかしらアプリが選択された後で終了した場合(選択アプリ先でキャンセルなど)
                // 編集モードを解除する
                [self setEditing:NO animated:YES];
            }
            else {
                // アプリを選択せずにキャンセルした場合はなにもしない
            }
        }
        else if (completed) {
            // 正常終了時
            // 編集モードを解除する
            [self setEditing:NO animated:YES];
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
                               [self appDelegateIsRunOff];
                           }];
    
    // コントローラにアクションを追加
    [alertController addAction:okAction];
    // アラート表示処理
    [self presentViewController:alertController animated:YES completion:nil];
}

@end

