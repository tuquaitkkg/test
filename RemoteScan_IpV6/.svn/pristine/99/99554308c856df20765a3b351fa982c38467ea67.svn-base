
#import "AttachmentMailViewController_iPad.h"
#import "Define.h"
#import "CommonUtil.h"
#import "AttachmentDataCell.h"
#import "PrintPictViewController_iPad.h"
#import "SharpScanPrintAppDelegate.h"
#import "RootViewController_iPad.h"
#import "TempDataManager.h"

#import "MoveViewController.h"
#import "RenameScanAfterDataViewController.h"

@interface AttachmentMailViewController_iPad ()
@property (nonatomic,assign) BOOL isFirstTap; // セルをタップ済みかどうか(連打不可対応)
@end

@implementation AttachmentMailViewController_iPad

@synthesize delegate;
@synthesize attachmentDirectory;
@synthesize rootShowDir;
@synthesize zipPath;          //解凍するzipファイルのパス
@synthesize destinationPath;  //解凍したファイルを置く場所
@synthesize encryptPW;        //暗号化パスワード

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
    
    // ナビゲーションバー
    // タイトル設定
    CGRect frame = CGRectMake(0, 0, 400, 44);
    UILabel* lblTitle = [[UILabel alloc]initWithFrame:frame];
    lblTitle.backgroundColor = [UIColor clearColor];
    lblTitle.textColor = NAVIGATION_TITLE_COLOR;
    lblTitle.font = [UIFont boldSystemFontOfSize:20];
    lblTitle.textAlignment = NSTextAlignmentCenter;
    lblTitle.text = S_TITLE_ATTACH_PRINT;
    lblTitle.adjustsFontSizeToFitWidth = YES;
    self.navigationItem.titleView = lblTitle;
    
    // nilの場合は、Rootディレクトリパスを渡す
    if (self.attachmentDirectory == nil) {
        self.attachmentDirectory = [[TempAttachmentDirectory alloc]initWithDirectoryPath:[TempAttachmentFileUtility getRootDir]];
    }

    // 閉じるボタン追加
    UIBarButtonItem* btnSetting = [[UIBarButtonItem alloc] initWithTitle:S_BUTTON_CLOSE style:UIBarButtonItemStylePlain target:self action:@selector(cancelAction)];
    [self.navigationItem setRightBarButtonItem: btnSetting];
    
    // 編集モード中もセルの選択を有効にする
    self.tableView.allowsSelectionDuringEditing = YES;
    
    // 初期化
    mArray = [[NSMutableArray alloc]init ];
    mAllArray = [[NSMutableArray alloc]init ];
    
    // Toolbar
    self.navigationController.toolbar.barStyle = TOOLBAR_BARSTYLE;
    
    // 編集ボタンの生成
    editBtn = self.editButtonItem;
    [editBtn setTitle:nil];
    [editBtn setImage:[UIImage imageNamed:S_ICON_EDIT2]];

    // 保存ボタンの生成
    saveBtn = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:S_ICON_PRINT_SAVE]
                                               style:UIBarButtonItemStylePlain
                                              target:self
                                              action:@selector(saveAction:)];

    // 印刷ボタンの生成
    printBtn = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:S_ICON_PRINT_START]
                                                style:UIBarButtonItemStylePlain
                                               target:self
                                               action:@selector(printAction:)];
    

    // 初期表示
    editBtn.enabled = YES;
    saveBtn.enabled = NO;
    printBtn.enabled = NO;

    //スペーサー
    UIBarButtonItem* flexSpacer = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    
    // ツールバーに追加
    NSArray *items = [NSArray arrayWithObjects:flexSpacer,editBtn, flexSpacer, saveBtn,flexSpacer, printBtn,flexSpacer,nil];
    self.toolbarItems = items;
    
    [self.navigationController setToolbarHidden:YES animated:YES];
    
    // 色変更
    //self.navigationController.navigationBar.tintColor = [UIColor blackColor];
    
    // AttachmentDataManagerクラス生成
    m_pScanMgr = [[AttachmentDataManager alloc]init];
    //    m_pScanMgr.tView = self.tableView;
    m_pScanMgr.fullPath = self.attachmentDirectory.directoryPathInAttachmentDirectory;
    [m_pScanMgr reGetScanData];
    
    // TableViewのスクロール初期値設定
    self.tableView.scrollEnabled = YES;
    
    // 再描画
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
    // タップ済みフラグを初期化する
    self.isFirstTap = NO;
    
    [self SetHeaderView];

    // 縦表示の時はメニューボタンを表示
    [self.navigationItem setLeftBarButtonItem:nil animated:NO];
    SharpScanPrintAppDelegate* pAppDelegate = (SharpScanPrintAppDelegate*)[[UIApplication sharedApplication] delegate];
    [pAppDelegate setPortraitMenuButton];
    // iPad用
    
    if(m_pScanMgr != nil)
    {
        m_pScanMgr.fullPath = self.attachmentDirectory.directoryPathInAttachmentDirectory;
        [m_pScanMgr reGetScanData];
    }
    [self.tableView reloadData];
    
    [super viewWillAppear:animated];
    // 選択状態解除
    [self.tableView deselectRowAtIndexPath:[self.tableView indexPathForSelectedRow] animated:YES];
    
    [self.navigationController setToolbarHidden:NO animated:YES];
    isClose = NO;
    
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    [self.tableView reloadData];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void) viewWillDisappear:(BOOL)animated {
    if (!isClose) {
        [self.navigationController setToolbarHidden:YES animated:YES];
    }
    [super viewWillDisappear:animated];
}

//
// アプリケーションの終了直前に呼ばれるメソッド
//

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
        [self setPortraitMenu:nil];
        // 戻るボタンを表示
        UIBarButtonItem * barItemBack = [UIBarButtonItem new];
        barItemBack.title = S_BUTTON_BACK;
        self.navigationItem.backBarButtonItem = barItemBack;
	}
}

// iPad用
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // 横向きの場合
    if(interfaceOrientation == UIInterfaceOrientationLandscapeLeft || interfaceOrientation == UIInterfaceOrientationLandscapeRight)
    {
        // 縦向き表示時のメニューPopOverが表示されていたら閉じる
        [self dismissMenuPopOver:NO];
        // メニューボタンは削除
        [self setPortraitMenu:nil];
    }
    
    return YES;
}

// 縦表示時のメニューボタン設定
- (void)setPortraitMenu:(UIBarButtonItem *)barButtonItem
{
    if (barButtonItem != nil) {
        barButtonItem.title = S_BUTTON_FILE_LIST;
        [self.navigationItem setLeftBarButtonItem:barButtonItem animated:YES];
    }
}
// iPad用

- (void) dismissMenuPopOver:(BOOL)bAnimated
{
    SharpScanPrintAppDelegate* pAppDelegate = (SharpScanPrintAppDelegate*)[[UIApplication sharedApplication] delegate];
    UINavigationController* pRootNavController = [pAppDelegate.splitViewController.viewControllers objectAtIndex:0];
    RootViewController_iPad* rootViewController = (RootViewController_iPad*)[pRootNavController.viewControllers objectAtIndex:0];
    
    // 縦向き表示時のメニューPopOverが表示されていたら閉じる
    [rootViewController dismissMenuPopOver:bAnimated];
}
//iPad用

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

// テーブルビュー セル作成
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *CellIdentifier = [NSString stringWithFormat:@"Cell%@", (indexPath.section?@"T":@"F")];
    
    AttachmentDataCell *cell = (AttachmentDataCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if(cell == nil)
    {
        cell = [[AttachmentDataCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        
    }
    
    /*
     cell.accessoryType = UITableViewCellAccessoryDetailDisclosureButton;
     cell.textLabel.font = [UIFont systemFontOfSize:16];
     */
    
    // データ取得
    AttachmentData *scanData = nil;
    scanData = [m_pScanMgr loadScanDataAtIndexPath:indexPath];
    
    
    // サムネイル
    TempAttachmentFile * localTempAttachmentFile = [[TempAttachmentFile alloc]initWithFilePath:[self.attachmentDirectory.directoryPathInAttachmentDirectory stringByAppendingPathComponent:scanData.fname]];
    
    // ファイルの場合はキャッシュファイルも作成する
    if (scanData.isDirectory) {
        [TempAttachmentFileUtility createThumbnailFile:localTempAttachmentFile];
    } else {
        [TempAttachmentFileUtility createRequiredAllImageFiles:localTempAttachmentFile];
    }

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
    //全リストを取得
    if (![mAllArray containsObject:indexPath])
    {
        [mAllArray addObject:indexPath];
        cell.shouldIndentWhileEditing = NO;
    }
    [cell.selectImgView removeFromSuperview];
    
    return cell;
}

// 削除のマイナスアイコンを表示させない
- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.tableView.editing)
    {
        return 3;
    }
    else
    {
        return UITableViewCellEditingStyleDelete;
    }
    //    return UITableViewCellEditingStyleNone;
}

// フォルダーはインデント（右にスライド）させない
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    AttachmentData *scanData = nil;
    scanData = [m_pScanMgr loadScanDataAtIndexPath:indexPath];
    AttachmentDataCell *cell = (AttachmentDataCell*)[tableView cellForRowAtIndexPath:indexPath];
    
    if([scanData isDirectory])
    {
        // ハイライトなし
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        if (self.tableView.editing) {
            cell.accessoryType = UITableViewCellAccessoryNone;
        } else {
            cell.accessoryType = TABLE_CELL_ACCESSORY;
        }
        return NO; //編集不可能なセルの場合
    }
    else
    {
        return YES;//編集可能なセルの場合
    }
    
}

// テーブルビュー 縦幅設定
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return N_HEIGHT_SEL_FILE;
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
//        // ハイライトOFF
//        [tableView deselectRowAtIndexPath:indexPath animated:YES];
        
        // 選択ファイルパス格納
        AttachmentData *scanData = nil;
        scanData = [m_pScanMgr loadScanDataAtIndexPath:indexPath];
        
        // ディレクトリ、ZIPは選択不可
        if(![scanData isDirectory])
        {
            // チェックボックス切り替え
            [self changeCheckbox:indexPath];
        }
        
    }
}
- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    // 選択ファイルパス格納
    AttachmentData *scanData = nil;
    scanData = [m_pScanMgr loadScanDataAtIndexPath:indexPath];
    
    // ディレクトリ、ZIPは選択不可
    if(![scanData isDirectory])
    {
        // チェックボックス切り替え
        [self changeCheckbox:indexPath];
    }
}

- (void) changeCheckbox:(NSIndexPath *)indexPath {
    // チェックボックス切り替え
    AttachmentDataCell *cell = (AttachmentDataCell*)[self.tableView cellForRowAtIndexPath:indexPath];
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
            editBtn.enabled = YES;
            saveBtn.enabled = NO;
            printBtn.enabled = NO;
            break;
        case 1:
            editBtn.enabled = YES;
            saveBtn.enabled = YES;
            printBtn.enabled = YES;
            break;
        default:
            editBtn.enabled = YES;
            saveBtn.enabled = YES;
            printBtn.enabled = YES;
            break;
    }
}

- (void)tableView:(UITableView *)tableView accessoryButtonTappedForRowWithIndexPath:(NSIndexPath *)indexPath
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
    
    // 選択ファイルパス格納
    AttachmentData *scanData = nil;
    scanData = [m_pScanMgr loadScanDataAtIndexPath:nIndexPath];
    
    // ディレクトリの場合は階層遷移
    if([scanData isDirectory ])
    {
        TempAttachmentDirectory *localTempDirectory;
        AttachmentMailViewController_iPad* selectView = [[AttachmentMailViewController_iPad alloc] init];
        //ZIPファイルの場合
        if ([scanData.fname hasSuffix:@".zip"]) {
            //パスの適正化
            self.zipPath = [NSString stringWithFormat:@"%@/%@" , self.attachmentDirectory.directoryPathInAttachmentDirectory, scanData.fname];

            // ZipArchiveFileという固定名をやめる
//            self.destinationPath = self.attachmentDirectory.zipDestinationPath;
            
            NSString *zipDirectoryName = [NSString stringWithFormat:@"DIRZIP-%@" , [[scanData.fname substringFromIndex:4] stringByDeletingPathExtension]];
            self.destinationPath = [self.attachmentDirectory.directoryPathInAttachmentDirectory stringByAppendingPathComponent:zipDirectoryName];

            localTempDirectory = [[TempAttachmentDirectory alloc]initWithDirectoryPath:self.destinationPath];

            //zipファイルの展開
            bool isNormalZip = [SSZipArchive unzipFileAtPath:self.zipPath toDestination:self.destinationPath];
            if (isNormalZip)
            {
                if(!self.rootShowDir){
                    self.rootShowDir = @"";
                }
                selectView.rootShowDir = [NSString stringWithFormat:@"%@/%@" , self.rootShowDir, [scanData.fname substringFromIndex:4]];
                
                selectView.attachmentDirectory = localTempDirectory;
                m_pScanMgr.fullPath = localTempDirectory.directoryPathInAttachmentDirectory;
                
                selectView.delegate = self.delegate;
                [self.navigationController pushViewController:selectView animated:YES];
            }
            else    //暗号化ZIPの場合
            {
                // 選択状態解除
                [self.tableView deselectRowAtIndexPath:[self.tableView indexPathForSelectedRow] animated:YES];
                //暗号化パスワード入力ダイアログ表示
                [self alertEncrypt];
            }
            
        }
        else
        {//普通のフォルダの場合
            selectView.attachmentDirectory = localTempDirectory;
            m_pScanMgr.fullPath = selectView.attachmentDirectory.directoryPathInAttachmentDirectory;
            NSString * fullPath = [self.attachmentDirectory.directoryPathInAttachmentDirectory stringByAppendingPathComponent: scanData.fname];
            localTempDirectory = [[TempAttachmentDirectory alloc]initWithDirectoryPath:fullPath];
            selectView.attachmentDirectory = localTempDirectory;
            selectView.rootShowDir = [NSString stringWithFormat:@"%@/%@" , self.rootShowDir, [scanData.fname substringFromIndex:4]];
            
            selectView.delegate = self.delegate;
            [self.navigationController pushViewController:selectView animated:YES];
        }
    }
    else
    {
        selectIndexPath = nIndexPath;

        [mArray addObject:selectIndexPath];//***

        if ([delegate getArrThumbnailsCount] > 0) {
            SharpScanPrintAppDelegate* appDelegate = (SharpScanPrintAppDelegate*)[[UIApplication sharedApplication] delegate];
            // 処理実行フラグON
            appDelegate.IsRun = TRUE;

            // メール本文を選択している場合
            // （添付ファイル押下のタイミングで発動）
            [self createAlertMailPrintToAttachementOnAttachmentFile];
            
            
        }else {
            // メール本文を選択していない場合
  
//            // 印刷画面へ遷移
//            [self movePrintPictView];
            [self moveMultiPrintPictView];
        }
    }
}

// メール本文印刷から添付ファイル印刷へ切り替える時のアラート作成(添付ファイル押下のタイミングで発動)
- (void)createAlertMailPrintToAttachementOnAttachmentFile {
    
    [self makeTmpExAlert:MSG_PRINT_MAILATTACHMENT_CONFIRM message:nil cancelBtnTitle:S_BUTTON_CANCEL okBtnTitle:MSG_BUTTON_YES tag:2 showFlg:YES isEncrypt:NO];
}

// 印刷画面へ遷移
- (void)movePrintPictView: (NSString*)printFilePath {
    isClose = YES;
    if(delegate){
        if([delegate respondsToSelector:@selector(mailAttachmentPrint:upLoadMailView:)])
        {
            // デリゲートメソッドの呼び出し(モーダルビューも閉じる)
            [delegate mailAttachmentPrint:self upLoadMailView:printFilePath];
        }
    }else {
        // 印刷画面へ遷移
        [self movePrintPictView];// こっちにくるはず
    }
}

- (void) movePrintPictView
{
    //    [mArray addObject:selectIndexPath];
    
    DLog(@"%@",mArray);
    
    if (self.selectFilePathArray == nil) {
        self.selectFilePathArray = [NSMutableArray arrayWithCapacity:0];
    }
    for (NSIndexPath *indexPath in mArray) {
        // データ取得
        AttachmentData *scanData = [m_pScanMgr loadScanDataAtIndexPath:indexPath];
        
        [self.selectFilePathArray addObject:scanData];
        
        DLog(@"scanData = %@",[scanData description]);
    }
    DLog(@"%@",self.selectFilePathArray);
    if (self.selectFilePathArray.count == 0) {
        [self performSelector:@selector(cancelAction) withObject:nil];
        return;
    }
    NSNotification *n = [NSNotification notificationWithName:NK_ENTER_BUTTON_PUSHED2 object:self];
    NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
    [nc postNotification:n];
    
}

//暗号化パスワード入力ダイアログを表示する
- (void)alertEncrypt
{
    SharpScanPrintAppDelegate* appDelegate = (SharpScanPrintAppDelegate*)[[UIApplication sharedApplication] delegate];
    // 処理実行フラグON
    appDelegate.IsRun = TRUE;
    
    [self makeTmpExAlert:S_ENCRYPTZIP_PASSWORD message:nil cancelBtnTitle:S_BUTTON_CANCEL okBtnTitle:MSG_BUTTON_OK tag:1 showFlg:YES isEncrypt:YES];
}

// 暗号化ZIPファイル解凍処理
- (void)unzipEncryptZip:(UIAlertController*)alertController {
    
    // パスワード取得
    self.encryptPW = alertController.textFields.firstObject.text;
    
    //暗号化パスワード入力ありの場合
    if ([self.encryptPW length] > 0 && self.encryptPW != nil)
    {
        //zipファイル解凍
        bool isEncryptZip = [SSZipArchive unzipFileAtPath:self.zipPath toDestination:self.destinationPath overwrite:YES password:self.encryptPW error:nil];
        if (isEncryptZip)
        {
            AttachmentMailViewController_iPad* selectView = [[AttachmentMailViewController_iPad alloc] init];
            TempAttachmentDirectory * localTempDirectory = [[TempAttachmentDirectory alloc]initWithDirectoryPath:self.destinationPath];
            
            if(!self.rootShowDir){
                self.rootShowDir = @"";
            }
            selectView.rootShowDir = [NSString stringWithFormat:@"%@/%@",self.rootShowDir , [[self.zipPath lastPathComponent] substringFromIndex:4]];
            selectView.attachmentDirectory = localTempDirectory;
            m_pScanMgr.fullPath = self.destinationPath;
            
            selectView.delegate = self.delegate;
            [self.navigationController pushViewController:selectView animated:YES];
        } else{
            SharpScanPrintAppDelegate* appDelegate = (SharpScanPrintAppDelegate*)[[UIApplication sharedApplication] delegate];
            // 処理実行フラグON
            appDelegate.IsRun = TRUE;
            
            // 解凍失敗時の処理
            // パスワード不正ダイアログ表示
            [self unzipFailure];
            
            return;
        }
    }
    else
    {
        SharpScanPrintAppDelegate* appDelegate = (SharpScanPrintAppDelegate*)[[UIApplication sharedApplication] delegate];
        // 処理実行フラグON
        appDelegate.IsRun = TRUE;
        
        //パスワード未入力ダイアログ表示
        [self unzipPasswordEmpty];
        
        return;
    }
}

// 暗号化ZIPファイルパスワード未入力時の処理
- (void)unzipPasswordEmpty {
    
    [self makeTmpExAlert:nil message:[NSString stringWithFormat:MSG_REQUIRED_ERR, S_ENCRYPTZIP_PASSWORD] cancelBtnTitle:nil okBtnTitle:MSG_BUTTON_OK tag:5 showFlg:YES isEncrypt:NO];
}

// 暗号化ZIPファイル解凍失敗時の処理
- (void)unzipFailure {
    //パスワード不正ダイアログ表示
    [self makeTmpExAlert:nil message:MSG_ENCRYPTZIP_ERROR cancelBtnTitle:nil okBtnTitle:MSG_BUTTON_OK tag:6 showFlg:YES isEncrypt:NO];
}

//ダイアログのボタン押下時
-(void)alertButtonPushed:(UIAlertController *)alertController tagIndex:(NSInteger)tagIndex buttonIndex:(NSInteger)buttonIndex
{
    [self alertButtonClicked:alertController tagIndex:tagIndex buttonIndex:buttonIndex];
    [self alertButtonDismiss:alertController tagIndex:tagIndex buttonIndex:buttonIndex];
}

-(void)alertButtonDismiss:(UIAlertController *)alertController tagIndex:(NSInteger)tagIndex buttonIndex:(NSInteger)buttonIndex{
    // ボタンタップ時の処理
    SharpScanPrintAppDelegate* appDelegate = (SharpScanPrintAppDelegate*)[[UIApplication sharedApplication] delegate];
    // 処理実行フラグoff
    appDelegate.IsRun = FALSE;

    if (tagIndex == 1) {
        if (buttonIndex == 0) {
            // パスワード入力ダイアログのキャンセルボタン押下時
            self.isFirstTap = NO;
            
        } else if (buttonIndex == 1) {
            // 暗号化ZIPファイル解凍処理
            [self unzipEncryptZip:alertController];
        }
        
    } else if (tagIndex == 2) {
        if (buttonIndex == 0) {
            // メール本文を選択している場合で添付ファイル選択をしたときの確認でキャンセルボタン押下時
            self.isFirstTap = NO;
            // 選択ファイルを削除し、ハイライトを消しておく。
            [mArray removeAllObjects];
            [self.tableView deselectRowAtIndexPath:[self.tableView indexPathForSelectedRow] animated:NO];
            
        } else if (buttonIndex == 1) {
            // 印刷画面へ遷移
            [self movePrintPictView];
        }
        
    } else if (tagIndex == 3) {
        if (buttonIndex == 0) {
            // NOP
            
        } else if (buttonIndex == 1) {
            // 印刷画面へ遷移
            [self moveMultiPrintPictView];
        }
        
    } else if (tagIndex == 5 && buttonIndex == 0) {
        // 暗号化ZIPパスワード入力アラートでキャンセルボタン押下
        self.isFirstTap = NO;
        
    } else if (tagIndex == 6 && buttonIndex == 0) {
        // 暗号化ZIPパスワード不正時
        // パスワードを初期化
        self.encryptPW = @"";
        self.isFirstTap = NO;
        // 選択ファイルを削除し、ハイライトを消しておく。
        [mArray removeAllObjects];
        [self.tableView deselectRowAtIndexPath:[self.tableView indexPathForSelectedRow] animated:NO];
    }
    
    // 編集モード時の処理(PrintPictViewController等を修正時のTODO)
    if(tagIndex == 4)
    {
        [self setEditing:NO animated:YES];
    }
}

-(void)alertButtonClicked:(UIAlertController *)alertController tagIndex:(NSInteger)tagIndex buttonIndex:(NSInteger)buttonIndex
{
    SharpScanPrintAppDelegate* appDelegate = (SharpScanPrintAppDelegate*)[[UIApplication sharedApplication] delegate];
    // 処理実行フラグoff
    appDelegate.IsRun = FALSE;

}

// 印刷ボタン押下
- (void)printAction:(id)sender
{
    if ([delegate getArrThumbnailsCount] > 0) {
        SharpScanPrintAppDelegate* appDelegate = (SharpScanPrintAppDelegate*)[[UIApplication sharedApplication] delegate];
        // 処理実行フラグON
        appDelegate.IsRun = TRUE;

        // メール本文を選択している場合
        // （編集モードでファイル選択後に印刷ボタンを押下したタイミングで発動）
        [self createAlertMailPrintToAttachementOnPrintButton];
        
    }else {
        // メール本文を選択していない場合
        
        // 印刷画面へ遷移
        [self moveMultiPrintPictView];
    }
}

// メール本文印刷から添付ファイル印刷へ切り替える時のアラート作成(編集モードでファイル選択後に印刷ボタンを押下したタイミングで発動)
- (void)createAlertMailPrintToAttachementOnPrintButton {
    
    [self makeTmpExAlert:MSG_PRINT_MAILATTACHMENT_CONFIRM message:nil cancelBtnTitle:S_BUTTON_CANCEL okBtnTitle:MSG_BUTTON_YES tag:3 showFlg:YES isEncrypt:NO];
}

// 保存ボタン押下
- (void)saveAction:(id)sender
{
    if(mArray == nil)
    {
        return;
    }
    
    //リリースプール生成
    @autoreleasepool
    {
        // 画面遷移
        MoveViewController* pMoveViewController = [[MoveViewController alloc] init];
        pMoveViewController.delegate = self;
        pMoveViewController.isAttachment = YES;
        NSMutableArray *abc = [[NSMutableArray alloc] init ];
        NSMutableArray *name = [[NSMutableArray alloc] init ];
        NSInteger row = 0;
        for (row = 0; row < [mArray count] ; row++)
        {
            // 選択ファイルの情報を取得
            NSString *path = @"";
            AttachmentData *attData = nil;
            attData = [m_pScanMgr loadScanDataAtIndexPath:[mArray objectAtIndex:row]];
            
            path = [NSString stringWithFormat:@"%@/%@" , self.attachmentDirectory.directoryPathInCacheDirectory
                    ,attData.fname];
            
            //        DLog(@"%@",path);
            // 選択しているファイル/フォルダ名を格納する
            [abc addObject:path];
            [name addObject:attData.fname];
        }
        // 移動画面に渡す
        pMoveViewController.beforeMoveArray = abc;
        pMoveViewController.beforeMoveName = name;
        ScanDirectory *localScanDirectory;
        localScanDirectory = [[ScanDirectory alloc]initWithScanDirectoryPath:[ScanFileUtility getRootDir]];
        pMoveViewController.scanDirectory = localScanDirectory;

        // 編集モードOFF
        [self setEditing:NO animated:NO];
        
        //    [self.navigationController pushViewController:pMoveViewController animated:YES];
        // モーダル表示
        UINavigationController *navigationController = [[UINavigationController alloc]initWithRootViewController:pMoveViewController];
        navigationController.navigationBar.barStyle = NAVIGATION_BARSTYLE;
        [navigationController setModalPresentationStyle:UIModalPresentationPageSheet];
        [self presentViewController:navigationController animated:YES completion:nil];
    }
}

- (void)moveMultiPrintPictView
{
    DLog(@"%@",mArray);
    
    if (self.selectFilePathArray == nil) {
        self.selectFilePathArray = [NSMutableArray arrayWithCapacity:0];
    }
    for (NSIndexPath *indexPath in mArray) {
        // データ取得
        AttachmentData *scanData = [m_pScanMgr loadScanDataAtIndexPath:indexPath];
        
        [self.selectFilePathArray addObject:scanData];
        
        DLog(@"scanData = %@",[scanData description]);
    }
    DLog(@"%@",self.selectFilePathArray);
    
    if (self.selectFilePathArray.count == 0) {
//        [self performSelector:@selector(cancelButtonPushed:) withObject:nil];
        [self performSelector:@selector(cancelAction) withObject:nil];
        return;
    }
    
    // 添付ファイルのキャッシュをつくる
    for (AttachmentData *canData in self.selectFilePathArray) {
        CommonManager* coManager = [[CommonManager alloc]init];
        [coManager createCacheFile:canData.fpath filename:canData.fname];
    }
    
    NSNotification *n = [NSNotification notificationWithName:NK_ENTER_BUTTON_PUSHED2 object:self];
    NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
    [nc postNotification:n];
    
}

// 複数印刷対応
- (void)enterButtonPushed:(id)sender {
    
    if ([delegate getArrThumbnailsCount] > 0) {
        SharpScanPrintAppDelegate* appDelegate = (SharpScanPrintAppDelegate*)[[UIApplication sharedApplication] delegate];
        // 処理実行フラグON
        appDelegate.IsRun = TRUE;

        // メール本文を選択している場合
        // （編集モードでファイル選択後に印刷ボタンを押下したタイミングで発動）
        [self createAlertMailPrintToAttachementOnPrintButton];
    }else {
        // メール本文を選択していない場合
        // 印刷画面へ遷移
        [self moveMultiPrintPictView];
    }
}


// 編集モードか否かを判別する
- (void)setEditing:(BOOL)editing animated:(BOOL)animated
{
    [super setEditing:editing animated:animated];
    [self.tableView setEditing:editing animated:YES];
    
    // 編集モード時のみ、保存ボタンを表示する
    if(editing)
    {
//        [self.navigationItem setHidesBackButton:YES animated:YES];
        [self.navigationController setToolbarHidden:NO animated:YES];
    }else
    {
        NSInteger row = 0;
        //        DLog(@"mArray = %@",mArray);
        for (row = 0; row < [mArray count] ; row++)
        {
            // チェックボックス切り替え
            AttachmentDataCell *cell = (AttachmentDataCell*)[self.tableView cellForRowAtIndexPath:[mArray objectAtIndex:row]];
            
            cell.selectImgView.tag = 0;
            [cell setImageModel];
        }
        
        [mArray removeAllObjects];
        
        for (row = 0; row < [mAllArray count] ; row++)
        {
            AttachmentDataCell *cell = (AttachmentDataCell*)[self.tableView cellForRowAtIndexPath:[mAllArray objectAtIndex:row]];
            // ハイライトあり
            cell.selectionStyle = UITableViewCellSelectionStyleBlue;
        }
        
        // ボタンの設定を戻す
        editBtn.enabled = YES;
        saveBtn.enabled = NO;
        printBtn.enabled = NO;
        
//        [self.navigationItem setHidesBackButton:NO animated:YES];
    }
    [editBtn setTitle:nil];
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
    
    NSString *pstrText = self.rootShowDir;
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

// キャンセルし画面を閉じる
- (void)cancelAction
{
    isClose = YES;
    if(delegate){
        if([delegate respondsToSelector:@selector(mailAttachmentPrint:upLoadMailView:)]){
            // デリゲートメソッドの呼び出し(モーダルビューも閉じる)
            [delegate mailAttachmentPrint:self upLoadMailView:nil];
        }
    }else {
        // 添付ファイル一覧画面を初回表示した場合の「閉じる」押下は、TempAttachementFileを削除しておく
        [TempAttachmentFileUtility deleteMailTmpDir];
        NSNotification *n = [NSNotification notificationWithName:NK_CLOSE_BUTTON_PUSHED object:self];
        NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
        [nc postNotification:n];
    }
}

-(void) move:(UIViewController*)viewController didMovedSuccess:(BOOL)bSuccess {
    MoveViewController* moveView = (MoveViewController*)viewController;
    
    // モーダルを閉じる
    [moveView dismissViewControllerAnimated:YES completion:nil];
    
    // デリゲートをクリア
    moveView.delegate = nil;
}

// アラート表示
- (void) makeTmpExAlert:(NSString*)pstrTitle
                message:(NSString*)pstrMsg
         cancelBtnTitle:(NSString*)cancelBtnTitle
             okBtnTitle:(NSString*)okBtnTitle
                    tag:(NSInteger)tag
                showFlg:(BOOL)showFlg
              isEncrypt:(BOOL)isEncrypt
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
    
    // パスワード
    if (isEncrypt) {
        [tmpAlert addTextFieldWithConfigurationHandler:^(UITextField *inputTextField) {
            inputTextField.placeholder = S_ENCRYPTZIP_PASSWORD;
            inputTextField.secureTextEntry = YES;
        }];
    }
    
    if (showFlg) {
        // アラート表示処理
        [self presentViewController:tmpAlert animated:YES completion:nil];
    }
}

@end
