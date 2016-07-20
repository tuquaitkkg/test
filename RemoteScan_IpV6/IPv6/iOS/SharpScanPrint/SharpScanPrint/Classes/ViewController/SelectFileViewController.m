
#import "SelectFileViewController.h"
#import "Define.h"
#import "PrintPictViewController.h"
#import "SendMailPictViewController.h"
#import "SendExSitePictViewController.h"
#import "ArrangePictViewController.h"
#import "ScanDataCell.h"
#import <MessageUI/MessageUI.h> // メールの設定確認
// iPad用
#import "RootViewController.h"
#import "SharpScanPrintAppDelegate.h"
#import <MobileCoreServices/UTCoreTypes.h>
// iPad用
#import <ImageIO/ImageIO.h>
#import <AssetsLibrary/AssetsLibrary.h>

#import "SearchResultViewController.h"

@interface SelectFileViewController()

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

@implementation SelectFileViewController

@synthesize PrevViewID = m_nPrevViewID;
@synthesize baseDir;								// ファイルパス
//@synthesize subDir;
//@synthesize rootDir;

@synthesize bSetTitle = m_bSetTitle; // iPad用
@synthesize selectIndexPath; // iPad用
@synthesize lastScrollOffSet; // iPad用
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

- (void)dealloc
{
    if(nil != m_pScanMgr)
    {
        m_pScanMgr = nil;
    }
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
    
    self.tableView.rowHeight = N_HEIGHT_SEL_FILE;
    
    // ナビゲーションバー
    // タイトル設定
    NSString* title;
    switch (self.PrevViewID)
    {
        case PV_PRINT_SELECT_FILE_CELL:
            title = S_TITLE_PRINT;
            break;
        case SendMailSelectTypeView:
            title = S_TITLE_SENDMAIL;
            [self initShareToolBar];
            break;
        case SendExSiteSelectTypeView:
            title = S_TITLE_SEND;
            [self initShareToolBar];
            break;
        case ArrangeSelectTypeView:
            title = S_TITLE_ARRANGE;
            break;
        default:
            break;
    }
    CGSize size = [title sizeWithFont:[UIFont boldSystemFontOfSize:20]];
    CGRect frame = CGRectMake(0, 0, size.width, 44);
    UILabel* lblTitle = [[UILabel alloc]initWithFrame:frame];
    lblTitle.backgroundColor = [UIColor clearColor];
    lblTitle.textColor = NAVIGATION_TITLE_COLOR;
    lblTitle.font = [UIFont boldSystemFontOfSize:20];
    lblTitle.textAlignment = NSTextAlignmentCenter;
    lblTitle.adjustsFontSizeToFitWidth = YES;
    lblTitle.text = title;
    self.navigationItem.titleView = lblTitle;
    
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
    //    [m_pScanMgr reGetScanData];
    
    // TableViewのスクロール初期値設定
    self.tableView.scrollEnabled = YES;
    
    //sort用のpopupの設定
    sortViewPopUp = [[SelectFileSortPopViewController alloc] initWithStyle:UITableViewStyleGrouped];
    [sortViewPopUp setDelegate:self];
    
    // 再描画
    //    [self.tableView reloadData];
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
    
    // タップ済みフラグを初期化する
    self.isFirstTap = NO;
    
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
    //    [super viewWillAppear:animated];
    //    // 選択状態解除
    //    [self.tableView deselectRowAtIndexPath:[self.tableView indexPathForSelectedRow] animated:YES];
    //
    //    if (self.PrevViewID == PV_PRINT_SELECT_FILE_CELL) {
    //        // 複数印刷対応
    //        // 整理する画面の場合
    //        if(self.PrevViewID != SendMailSelectTypeView &&
    //           self.PrevViewID != SendExSiteSelectTypeView &&
    //           self.PrevViewID != ArrangeSelectTypeView)
    //        {
    //            self.closeButton = [[UIBarButtonItem alloc]initWithTitle:S_BUTTON_CLOSE style:UIBarButtonItemStyleBordered target:self action:@selector(closeButtonPushed:)];
    //            [self.navigationItem setRightBarButtonItem:self.closeButton];
    //        }
    //        self.multiPrintButton = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:S_ICON_MULTIPLE] style:UIBarButtonItemStyleBordered target:self action:@selector(multiPrintButtonPushed:)];
    //        self.cancelButton = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:S_ICON_PRINT_CANCEL] style:UIBarButtonItemStyleBordered target:self action:@selector(cancelButtonPushed:)];
    //        self.enterButton = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:S_ICON_PRINT_DECIDE] style:UIBarButtonItemStyleBordered target:self action:@selector(enterButtonPushed:)];
    //        [self updateNavigationBarButton];
    //        [self.navigationController setToolbarHidden:NO];
    //        [self.navigationController.toolbar setBarStyle:TOOLBAR_BARSTYLE];
    //    }
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

// 複数印刷対応
- (void)back {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    //     [self.tableView reloadData];
    
}


/*
 - (void)viewWillDisappear:(BOOL)animated
 {
 [super viewWillDisappear:animated];
 }
 */

/*
 - (void)viewDidDisappear:(BOOL)animated
 {
 [super viewDidDisappear:animated];
 }
 */

/*
 - (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
 {
 // Return YES for supported orientations
 return (interfaceOrientation == UIInterfaceOrientationPortrait);
 }
 */

#pragma mark - Table view data source

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

// テーブルビュー セクション数設定
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    //    DLog(@"セクション数[%d]", [m_pScanMgr countOfScanData]);
    return [m_pScanMgr countOfScanData];
}

// テーブルビュー セクション内の行数設定
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    //    DLog(@"section[%d] セルの数[%d]", section, [[m_pScanMgr loadScanDataAtSection:section] count]);
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

/*
 // Override to support conditional editing of the table view.
 - (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
 {
 // Return NO if you do not want the specified item to be editable.
 return YES;
 }
 */

/*
 // Override to support editing the table view.
 - (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
 {
 if (editingStyle == UITableViewCellEditingStyleDelete) {
 // Delete the row from the data source
 [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
 }
 else if (editingStyle == UITableViewCellEditingStyleInsert) {
 // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
 }
 }
 */

/*
 // Override to support rearranging the table view.
 - (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
 {
 }
 */

/*
 // Override to support conditional rearranging of the table view.
 - (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
 {
 // Return NO if you do not want the item to be re-orderable.
 return YES;
 }
 */

#pragma mark - Table view delegate

// 複数印刷対応
- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.tableView.editing) {
        return 3;
    } else {
        return UITableViewCellEditingStyleNone;
    }
}

// 複数印刷対応
-(NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (( self.PrevViewID == PV_PRINT_SELECT_FILE_CELL || [self isShareToolBarPrevViewID] )
        && self.tableView.editing && [[m_pScanMgr loadScanDataAtIndexPath:indexPath] isDirectory]) {
        return nil;
    }
    else {
        return indexPath;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
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
            NSLog(@"mArray: %@", mArray);
            
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
            NSLog(@"mArray: %@", mArray);
            
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

/* gestureRecognizeで実装しているためコメントアウト
 // UIViewタッチ完了イベント
 - (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
 {
 UITouch* touch = [[touches allObjects] objectAtIndex:0];
 CGPoint point = [touch locationInView:(UITableView*)self.view];
 UITableView* _tableView = (UITableView*)self.view;
 //    SelectFileViewController* controller = self.tableView.delegate;
 
 for (NSInteger nIndex = [self.tableView.dataSource numberOfSectionsInTableView:_tableView]-1; nIndex >= 0; nIndex --)
 {
 CGRect rectHeader = [_tableView rectForSection:nIndex];
 if (CGRectContainsPoint(rectHeader, point))
 {
 DLog(@"%s:%d", __FUNCTION__, __LINE__);
 [self shrinkRowInSection:nIndex];
 break;
 }
 }
 }
 */

// 画面遷移
- (void)MoveView:(NSIndexPath *)nIndexPath
{
    // セルの複数タップを制御する
    if ( ! [self.navigationController.visibleViewController isKindOfClass: [self class]] ) {
        DLog(@"visibleViewController is Invalid");
        return;
    }
    
    if([[m_pScanMgr loadScanDataAtIndexPath:nIndexPath] isDirectory ])
    {
        SelectFileViewController * selectView = [[SelectFileViewController alloc] init];
        ScanDirectory * selectedScanDirectory;
        // 選択ファイルパス格納
        ScanData * scanData = nil;
        scanData = [m_pScanMgr loadScanDataAtIndexPath:nIndexPath];
        NSString * fullPath;
        
        fullPath = [self.scanDirectory.scanDirectoryPath stringByAppendingPathComponent: scanData.fname];
        selectedScanDirectory = [[ScanDirectory alloc]initWithScanDirectoryPath:fullPath];
        
        selectView.scanDirectory = selectedScanDirectory;
        m_pScanMgr.fullPath = selectedScanDirectory.scanDirectoryPath;
        selectView.PrevViewID = self.PrevViewID;
        selectView.fromSelectFileVC = YES;
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
            //[self.selectFilePathArray addObject:[NSString stringWithFormat:@"%@/%@",self.subDir,scanData.fname]];
            
            DLog(@"%@",self.selectFilePathArray);
            [self performSelector:@selector(enterButtonPushed:) withObject:nil];
            return;
        }
        
        // 遷移元画面から渡されたIDをもとに遷移先のViewControllerを決定する
        PictureViewController* pViewController = nil;
        
        switch (self.PrevViewID)
        {
            case PV_PRINT_SELECT_FILE_CELL:
                pViewController = [[PrintPictViewController alloc]init];
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
        
        if ( ! pViewController ) {
            pViewController = [[PrintPictViewController alloc] init];
        }
        
        // 選択ファイルパス格納
        ScanData *scanData = nil;
        scanData = [m_pScanMgr loadScanDataAtIndexPath:nIndexPath];
        NSString * filePath = [self.scanDirectory.scanDirectoryPath stringByAppendingPathComponent:scanData.fname];
        pViewController.SelFilePath = filePath;
        [self.navigationController pushViewController:pViewController animated:YES];
    }
}

// ヘッダー表示
//- (void)SetHeaderView
//{
//
//    UILabel *label = [[UILabel alloc] init];
//    label.frame = CGRectMake(10.0, 0.0, self.view.frame.size.width-20.0, 24.0);
//    label.backgroundColor = [UIColor grayColor];
//    label.textColor = [UIColor whiteColor];
//    label.font = [UIFont fontWithName:@"AppleGothic" size:16];
//    label.textAlignment = NSTextAlignmentLeft;
//    label.adjustsFontSizeToFitWidth = NO;
//    label.lineBreakMode = NSLineBreakByTruncatingMiddle;
//
//    NSString *pstrText = self.rootDir;
//    if([pstrText isEqualToString:nil] || pstrText == nil)
//    {
//        label.text = @"/";
//    }
//    else
//    {
//        label.text = pstrText;
//    }
//    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0.0, 0.0, self.view.frame.size.width, 25.0)];
//    headerView.backgroundColor = [UIColor grayColor];
//    [headerView addSubview:label];
//    //TableViewにヘッダー設定
//    self.tableView.tableHeaderView = headerView;
//
//}
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
        if (!m_searchController)
        {
            // 検索コントローラー作成
            m_searchController = [[UISearchController alloc] initWithSearchResultsController:nil];
            m_searchController.delegate = self;
            m_searchController.dimsBackgroundDuringPresentation = YES; // default is YES　編集モード時に薄黒いビューを表示するかどうか
            m_searchController.searchBar.delegate = self; // so we can monitor text changes + others
            m_searchController.searchBar.frame = CGRectMake(SORTBUTTON_WIDTH, 0.0, self.view.frame.size.width - SORTBUTTON_WIDTH, SEARCHBAR_HEIGHT);
            
            // searchBarの設定
            m_searchController.searchBar.showsCancelButton = NO;
            m_searchController.searchBar.placeholder = S_SEARCH_PLACEHOLDER;
            m_searchController.searchBar.keyboardType = UIKeyboardTypeDefault;
            m_searchController.searchBar.keyboardAppearance = UIKeyboardAppearanceLight;
            m_searchController.searchBar.barStyle = TOOLBAR_BARSTYLE;
            m_searchController.searchBar.searchBarStyle = UISearchBarStyleMinimal;
            for (UIView *subView in [m_searchController.searchBar subviews]) {
                for (UIView *secondLevelSubview in subView.subviews) {
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
            m_searchController.searchBar.frame = CGRectMake(SORTBUTTON_WIDTH, 0.0, self.view.frame.size.width - SORTBUTTON_WIDTH, SEARCHBAR_HEIGHT-1);
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
            }else
            {
                UITextField *textField = [[m_searchController.searchBar subviews] objectAtIndex:1];
                [textField setFont:[UIFont fontWithName:@"Helvetica" size:10]];
            }
            m_searchController.searchBar.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleRightMargin;
            
            m_searchController.delegate = self;
        }
        
        // Todo 並べ替え & 検索バーをテーブルのヘッダー部に表示する
        UINavigationBar *sortAndSearchView = [[UINavigationBar alloc] initWithFrame:CGRectMake(0.0, 0.0, self.view.frame.size.width, SEARCHBAR_HEIGHT)];
        sortAndSearchView.barStyle = NAVIGATION_BARSTYLE;
        sortAndSearchView.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        
        //    // Todo 並び替えボタン表示 start
        //    UIButton* m_pbtnSort = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        //    m_pbtnSort.frame = CGRectMake(0.0, 5.0, SORTBUTTON_WIDTH, 34.0);
        //    m_pbtnSort.titleLabel.text = @"並び";
        
        //並べ替え用ボタンを生成（現在の検索キーを表示)
        sortTypeButton = [UIButton buttonWithType: UIButtonTypeCustom];
        [sortTypeButton setExclusiveTouch: YES];
        sortTypeButton.frame = CGRectMake(0, 0, SORTBUTTON_WIDTH, SEARCHBAR_HEIGHT);
        sortTypeButton.titleLabel.font = [UIFont fontWithName:@"AppleGothic" size:24];
        sortTypeButton.titleLabel.textAlignment = NSTextAlignmentRight;
        sortTypeButton.titleLabel.baselineAdjustment = UIBaselineAdjustmentAlignBaselines;
        sortTypeButton.titleLabel.adjustsFontSizeToFitWidth = NO;
        
        // 並び替えボタン画像設定
        [self setSortTypeButtonImage];
        
        sortTypeButton.titleLabel.textColor = [UIColor whiteColor];
        sortTypeButton.backgroundColor = [UIColor clearColor];
        
        [sortTypeButton addTarget:self action:@selector(showSortPopupView:) forControlEvents:UIControlEventTouchUpInside]; // for modal(popup)
        
        /////
        //    [sortAndSearchView addSubview:m_pbtnSort];
        [sortAndSearchView addSubview:sortTypeButton];
        [headerView addSubview:sortAndSearchView];
        // Todo 並び替えボタン表示 end
        
        [headerView addSubview:m_searchController.searchBar];
        
        //TableViewにヘッダー設定
        self.tableView.tableHeaderView = headerView;
        
    } else {
        // 検索バーを表示する
        // テーブルヘッダーにsearchControllerを入れ直す
        [self.tableView insertSubview:m_searchController.searchBar aboveSubview:self.tableView];
        
        // 戻るボタンでの遷移時用の対応
        [self setSortTypeButtonImage];
    }
}

#pragma mark - UISearchBarDelegate
// キーボードのSearchボタンタップ時に呼ばれる
-(void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    DLog(@"search");
    // iPhone用
    SharpScanPrintAppDelegate* pAppDelegate = (SharpScanPrintAppDelegate*)[[UIApplication sharedApplication] delegate];
    
    SearchResultViewController* pSearchResultViewController;
    
    pSearchResultViewController = [[SearchResultViewController alloc]init];
    pSearchResultViewController.pstrSearchKeyword = searchBar.text;
    pSearchResultViewController.PrevViewID = self.PrevViewID;
    // 次画面へ渡す
    pSearchResultViewController.scanDirectory = self.scanDirectory;
    
    // 複数印刷対応
    pSearchResultViewController.fromSelectFileVC = YES;
    
    //    UINavigationController* pRootNavController = [pAppDelegate.splitViewController.viewControllers objectAtIndex:0];
    UINavigationController* pRootNavController = pAppDelegate.navigationController;
    //左側のViewに設定されているクラスの名前を取得
    NSString* leftViewClassName = [pRootNavController.topViewController description];
    
    // 左側のViewに自身が表示されていない場合
    if(![leftViewClassName isEqual:[self description]])
    {
        pSearchResultViewController.bSetTitle = YES;
    }
    
    [self.navigationController pushViewController:pSearchResultViewController animated:YES];
    
    // 検索バーを下げる
    [m_searchController setActive:NO];
    
    [self SetHeaderView];   // searchBarをテーブルヘッダーに戻す
    
}

// 検索バーのキャンセルボタンを押下時に呼ばれる
-(void)searchBarCancelButtonClicked:(UISearchBar *)searchBar
{
    // 検索バーを下げる
    sortTypeButton.hidden = NO;
    
    [self SetHeaderView];   // searchBarをテーブルヘッダーに戻す
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
    searchController.searchBar.frame = CGRectMake(SORTBUTTON_WIDTH, 0.0, self.view.frame.size.width - SORTBUTTON_WIDTH, SEARCHBAR_HEIGHT);   // didDismissと同じ設定。
    
    sortTypeButton.hidden = NO;
    
    [self.tableView insertSubview:m_searchController.searchBar aboveSubview:self.tableView];
    
    self.navigationController.navigationBar.translucent = NO;
    
    [UIView commitAnimations];
    
}
// 検索モードが解除された後に呼ばれる
- (void)didDismissSearchController:(UISearchController *)searchController {
    
    // サーチバーの横幅調整(origin.xやwidthの調整はここで行う。)
    searchController.searchBar.frame = CGRectMake(SORTBUTTON_WIDTH, 0.0, self.view.frame.size.width - SORTBUTTON_WIDTH, SEARCHBAR_HEIGHT);  // willDismissと同じ設定。
}

// ナビゲーションバー関連
#pragma mark - sort messages
- (void) showSortPopupView:(UIButton *)button
{
    // 編集モードOFF
    [self setEditing:NO animated:NO];
    
    UIBarButtonItem * barItemBack = [UIBarButtonItem new];
    barItemBack.title = S_BUTTON_CANCEL;
    [barItemBack setTarget: self];
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
    
    // この処理の後にviewWillAppearが呼ばれ、その中でこのメソッドが呼ばれることになるので処理していません。
    // 動作がおかしくなるようでしたらコメント外してください。
    //[self setSortTypeButtonImage];
    
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
    
    [self.tableView reloadData];
    
    // 選択状態解除
    [self.tableView deselectRowAtIndexPath:[self.tableView indexPathForSelectedRow] animated:YES];
    
    if (self.PrevViewID == PV_PRINT_SELECT_FILE_CELL) {
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
        
        // 共有ボタンのToolBarの場合は編集モードOFFと同時にToolBarを非表示にする。
        if ([self isShareToolBarPrevViewID]) {
            [self.navigationController setToolbarHidden:YES animated:NO];
        }
        
    }
}

@end
