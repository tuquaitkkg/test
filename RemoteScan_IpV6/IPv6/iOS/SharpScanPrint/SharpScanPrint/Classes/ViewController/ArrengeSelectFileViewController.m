
#import "ArrengeSelectFileViewController.h"
#import "CommonUtil.h"
#import "Define.h"
#import "PictureViewController.h"
#import "ArrangePictViewController.h"
#import "ScanDataCell.h"
#import "FileNameChangeViewController.h"
#import "ScanDataManager.h"
#import "MoveViewController.h"

// iPad用
#import "RootViewController.h"
#import "SharpScanPrintAppDelegate.h"
#import "SearchResultViewController.h"
// iPad用

@interface ArrengeSelectFileViewController()
@property (nonatomic,assign) BOOL isFirstTap; // セルをタップ済みかどうか(連打不可対応)
@end

@implementation ArrengeSelectFileViewController

@synthesize PrevViewID = m_nPrevViewID;
@synthesize baseDir;								// ファイルパス
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
//
// インスタンス化された時に最初に呼出されるメソッド
//
- (void)viewDidLoad
{
	
    [super viewDidLoad];

    self.tableView.rowHeight = N_HEIGHT_SEL_FILE;
    
    self.navigationItem.title = S_TITLE_ARRANGE;
    
    // 編集モード中もセルの選択を有効にする
    self.tableView.allowsSelectionDuringEditing = YES;
    
    // 初期化
    mArray = [[NSMutableArray alloc]init ];
    
    //
    // ホームディレクトリ/Documments/ 取得
    //
    NSString *tempDir	= [CommonUtil documentDir];
    self.baseDir		= [tempDir stringByAppendingString:@"/"];
    
    if( !self.scanDirectory ){
        self.scanDirectory = [[ScanDirectory alloc]initWithScanDirectoryPath:self.baseDir];
    }
    
    // 戻るボタンの名称変更
    UIBarButtonItem * barItemBack = [UIBarButtonItem new];
    barItemBack.title = S_BUTTON_BACK;
    self.navigationItem.backBarButtonItem = barItemBack;

    // 編集ボタン追加
    self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
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
    NSArray *items = [NSArray arrayWithObjects:moveBtn,spaceBtn,trashBtn,spaceBtn,nameChangeBtn,spaceBtn,folderCreationBtn,nil];
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
    // sort用のpopupの設定
    //
    sortViewPopUp = [[SelectFileSortPopViewController alloc] initWithStyle:UITableViewStyleGrouped];
    [sortViewPopUp setDelegate:self];
    
    //
    // 再描画
    //
//	[self.tableView reloadData];
}

//
// ビューが最後まで描画された後やアニメーションが終了した後にこの処理
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
    
    NSString *CellIdentifier = [NSString stringWithFormat:@"Cell%@", (indexPath.section?@"T":@"F")];
    
    ScanDataCell *cell = (ScanDataCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if(cell == nil)
    {
        cell = [[ScanDataCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        
    }
    
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

    return cell;
}

// 削除のマイナスアイコンを表示させない
- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.tableView.editing) {
        return 3;
    }
    else
    {
        return UITableViewCellEditingStyleDelete;
    }
//    return UITableViewCellEditingStyleNone;
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
        
        // 選択セル情報を格納
        [mArray addObject:indexPath];
        DLog(@"mArray: %@", mArray);
        
        switch (tableView.indexPathsForSelectedRows.count) {
            case 0://選択なし　　フォルダの新規作成のみ可
                moveBtn.enabled = NO;
                trashBtn.enabled = NO;
                nameChangeBtn.enabled = NO;
                folderCreationBtn.enabled = YES;
                break;
            case 1://１つ選択　すべて可
                moveBtn.enabled = YES;
                trashBtn.enabled = YES;
                nameChangeBtn.enabled = YES;
                folderCreationBtn.enabled = YES;
                break;
            default://２つ以上選択　名前の変更以外は可
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
        
        //選択から外す
        [mArray removeObject:indexPath];
        DLog(@"mArray: %@", mArray);
        
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

- (void)tableView:(UITableView *)tableView accessoryButtonTappedForRowWithIndexPath:(NSIndexPath *)indexPath
{
    // セルの複数タップを制御する
    if ( ! [self.navigationController.visibleViewController isKindOfClass: [self class]] ) {
        DLog(@"visibleViewController is Invalid");
        return;
    }

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

// 画面遷移
- (void)MoveView:(NSIndexPath *)nIndexPath
{
    ScanData *scanData = nil;
    scanData = [manager loadScanDataAtIndexPath:nIndexPath];
    NSString * fullPath = [self.scanDirectory.scanDirectoryPath stringByAppendingPathComponent: scanData.fname];
    
    manager.fullPath = fullPath;
    // ディレクトリの場合は階層遷移
    if([[manager loadScanDataAtIndexPath:nIndexPath] isDirectory ])
    {
        
        ArrengeSelectFileViewController* arrengeView;
        arrengeView = [[ArrengeSelectFileViewController alloc] init];
        ScanDirectory *selectedScanDirectory = [[ScanDirectory alloc]initWithScanDirectoryPath:fullPath];
        arrengeView.scanDirectory = selectedScanDirectory;
        // 選択ファイルパス格納
        [self.navigationController pushViewController:arrengeView animated:YES];
    }
    else
    {
        // 遷移元画面から渡されたIDをもとに遷移先のViewControllerを決定する
        PictureViewController* pViewController;
        pViewController =[[ArrangePictViewController alloc] init];
        pViewController.PrintPictViewID = self.PrevViewID;


        pViewController.SelFilePath = fullPath;
        [self.navigationController pushViewController:pViewController animated:YES];
    }
}
//
// メモリ警告時
//
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

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
    scanData = [manager loadScanDataAtIndexPath:[mArray objectAtIndex:0]];
    
    // 編集モードOFF
    [self setEditing:NO animated:NO];

    // 画面遷移
    FileNameChangeViewController* pFileNameChangeViewController;
    pFileNameChangeViewController = [[FileNameChangeViewController alloc] init];
    pFileNameChangeViewController.delegate = self;
    
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
    // モーダル表示
    pCreateFolderViewController.scanDirectory = [[ScanDirectory alloc]initWithScanDirectoryPath:self.scanDirectory.scanDirectoryPath];

    UINavigationController *navigationController = [[UINavigationController alloc]initWithRootViewController:pCreateFolderViewController];
    navigationController.navigationBar.barStyle = NAVIGATION_BARSTYLE;
    [navigationController setModalPresentationStyle:UIModalPresentationPageSheet];
    [self presentViewController:navigationController animated:YES completion:nil];
}

//ダイアログのボタン押下時
-(void)alertButtonPushed:(UIAlertController *)alertController tagIndex:(NSInteger)tagIndex buttonIndex:(NSInteger)buttonIndex{
    [self alertButtonClicked:alertController tagIndex:tagIndex buttonIndex:buttonIndex];
    [self alertButtonDismiss:alertController tagIndex:tagIndex buttonIndex:buttonIndex];
}

-(void)alertButtonClicked:(UIAlertController *)alertController tagIndex:(NSInteger)tagIndex buttonIndex:(NSInteger)buttonIndex
{
    if(tagIndex == 1)
    {
        // 削除の場合
        if(buttonIndex == 1)
        {
            NSInteger row = 0;
            //           DLog(@"mArray = %@",mArray);
            
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
}

// モーダル表示した画面を閉じる
- (void)OnClose
{
    [self dismissViewControllerAnimated:YES completion:nil];
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
//        DLog(@"mArray = %@",mArray);
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
        
        [self.navigationItem setHidesBackButton:NO animated:YES];
        [self.navigationController setToolbarHidden:YES animated:NO];
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
            // 検索バーが上に移動するコントローラーを使う
            m_searchController = [[UISearchController alloc] initWithSearchResultsController:nil];
            m_searchController.delegate = self;
            m_searchController.dimsBackgroundDuringPresentation = YES; // 編集モード時に薄黒いビューを表示するかどうか
            m_searchController.searchBar.delegate = self;
            m_searchController.searchBar.frame = CGRectMake(SORTBUTTON_WIDTH, 0.0, self.view.frame.size.width - SORTBUTTON_WIDTH, SEARCHBAR_HEIGHT);
            
            // searchBarの設定
            m_searchController.searchBar.delegate = self;
            m_searchController.searchBar.showsCancelButton = NO;
            m_searchController.searchBar.placeholder =S_SEARCH_PLACEHOLDER;
            m_searchController.searchBar.keyboardType = UIKeyboardTypeDefault;
            m_searchController.searchBar.keyboardAppearance = UIKeyboardAppearanceLight;
            
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
            m_searchController.searchBar.frame = CGRectMake(SORTBUTTON_WIDTH, 0.0, self.view.frame.size.width - SORTBUTTON_WIDTH, SEARCHBAR_HEIGHT - 1);
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
            
            // 検索バーが上に移動するコントローラーを使う
            m_searchController.delegate = self;

        }
        
        // Todo 並べ替え & 検索バーをテーブルのヘッダー部に表示する
        UINavigationBar *sortAndSearchView = [[UINavigationBar alloc] initWithFrame:CGRectMake(0.0, 0.0, self.view.frame.size.width, SEARCHBAR_HEIGHT)];
        sortAndSearchView.barStyle = TOOLBAR_BARSTYLE;
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
        //    blackAlphaView.hidden = YES;
        
    } else {
        // テーブルヘッダーにsearchControllerを入れ直す
        [self.tableView insertSubview:m_searchController.searchBar aboveSubview:self.tableView];
        
        // 戻るボタンで画面遷移してきたとき用の対応
        [self setSortTypeButtonImage];
    }
}

#pragma mark - ViewControllerDelegate
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
    // iPhone用
    SharpScanPrintAppDelegate* pAppDelegate = (SharpScanPrintAppDelegate*)[[UIApplication sharedApplication] delegate];
    
    SearchResultViewController* pSearchResultViewController;
    
    pSearchResultViewController = [[SearchResultViewController alloc]init];
    pSearchResultViewController.pstrSearchKeyword = searchBar.text;
    pSearchResultViewController.PrevViewID = ArrangeSelectTypeView;
    pSearchResultViewController.bCanDelete = YES;
    ScanDirectory *localScanDirectory = [[ScanDirectory alloc]initWithScanDirectoryPath:self.scanDirectory.scanDirectoryPath];
    pSearchResultViewController.scanDirectory = localScanDirectory;

    UINavigationController* pRootNavController = pAppDelegate.navigationController;
    //左側のViewに設定されているクラスの名前を取得
    NSString* leftViewClassName = [pRootNavController.topViewController description];
    
    // 左側のViewに自身が表示されていない場合
    if(![leftViewClassName isEqual:[self description]])
    {
        pSearchResultViewController.bSetTitle = YES;
    }
    
    [self.navigationController pushViewController:pSearchResultViewController animated:YES];
    
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
    
    // この処理の後にviewWillAppearが呼ばれ、その中でこのメソッドが呼ばれることになるので処理していません。
    // 動作がおかしくなるようでしたらコメント外してください。
    //[self setSortTypeButtonImage];
    

//    [self viewWillAppear:YES];
    [self dismissViewControllerAnimated:YES completion:nil];
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
    if(manager != nil)
    {
        manager.fullPath = self.scanDirectory.scanDirectoryPath;
        [manager reGetScanData];
    }
    [self.tableView reloadData];
    
    [self.tableView deselectRowAtIndexPath:[self.tableView indexPathForSelectedRow] animated:YES];

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
        // アラート表示処理
        [self presentViewController:tmpAlert animated:YES completion:nil];
    }
    return tmpAlert;
}

@end
