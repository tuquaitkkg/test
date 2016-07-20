
#import "MoveViewController.h"
#import "ArrengeSelectFileViewController.h"
#import "CommonUtil.h"
#import "Define.h"
#import "PictureViewController.h"
#import "ArrangePictViewController.h"
#import "ScanDataCell.h"
#import "FileNameChangeViewController.h"
#import "ScanDataManager.h"
// iPad用
#import "ArrengeSelectFileViewController_iPad.h"
#import "RootViewController_iPad.h"
// iPad用
#import "SharpScanPrintAppDelegate.h"

@implementation MoveViewController

@synthesize delegate;
@synthesize baseDir;								// ファイルパス
@synthesize HeaderShrinkStates = m_parrHeaderShrinkState;
@synthesize beforeMoveArray;
@synthesize beforeMoveName;
@synthesize isAttachment;
@synthesize scanDirectory;

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
        isAttachment = NO;
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
    
    if (isAttachment) {
        self.navigationItem.title = S_TITLE_SAVE;
    }else {
        self.navigationItem.title = S_TITLE_MOVE;
    }
    // 初期化
    mArray = [[NSMutableArray alloc]init ];
	
	//
	// ホームディレクトリ/Documments/ 取得
	//
	NSString *tempDir	= [CommonUtil documentDir];
	self.baseDir		= [tempDir stringByAppendingString:@"/"];
    if(!self.scanDirectory.isInit){
        self.scanDirectory = [[ScanDirectory alloc]initWithScanDirectoryPath:self.baseDir];
    }
    
    // 戻るボタンの名称変更
    UIBarButtonItem * barItemBack = [UIBarButtonItem new];
    barItemBack.title = S_BUTTON_BACK;
    self.navigationItem.backBarButtonItem = barItemBack;



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
    if (isAttachment) {
        // ここに保存ボタンの生成
        moveBtn = [[UIBarButtonItem alloc] initWithTitle:S_BUTTON_SAVE_HERE
                                                   style:UIBarButtonItemStyleDone
                                                  target:self
                                                  action:@selector(saveAction:)];
        // フォルダ作成ボタンの生成
        UIBarButtonItem * folderCreationBtn = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:S_ICON_CREATE_FOLDER]
                                                                               style:UIBarButtonItemStylePlain
                                                                              target:self
                                                                              action:@selector(createFolderAction:)];
        self.navigationItem.rightBarButtonItem = folderCreationBtn;
    }else {
        // ここに移動ボタンの生成
        moveBtn = [[UIBarButtonItem alloc] initWithTitle:S_BUTTON_MOVE
                                                   style:UIBarButtonItemStyleDone
                                                  target:self
                                                  action:@selector(moveAction:)];
    }
    
    // ツールバーに追加
    NSArray *items = [NSArray arrayWithObjects:cancelBtn,spaceBtn,moveBtn,nil];
    self.toolbarItems = items;
    
    [self.navigationController setToolbarHidden:NO animated:YES];
	
	//
	// ScanDataManager クラス生成
	// 
	manager		= [[ScanDataManager alloc]init];
    //	manager.tView	= self.tableView;
    
    manager.fullPath = self.scanDirectory.scanDirectoryPath;
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
}

//
// ビューが最後まで描画された後やアニメーションが終了した後にこの処理
//
- (void)viewWillAppear:(BOOL)animated
{
    [self SetHeaderView];
    
    if(manager != nil)
    {
        manager.fullPath = self.scanDirectory.scanDirectoryPath;
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

/*
 - (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
 {
 return YES;
 }
 */
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
        MoveViewController* pMoveView = [[MoveViewController alloc] init];
        
        // 選択ファイルパス格納
        ScanData *scanData = nil;
        scanData = [manager loadScanDataAtIndexPath:nIndexPath];
        
        NSString * fullPath = [self.scanDirectory.scanDirectoryPath stringByAppendingPathComponent: scanData.fname];
        ScanDirectory *selectedScanDirectory = [[ScanDirectory alloc]initWithScanDirectoryPath:fullPath];

        pMoveView.scanDirectory = selectedScanDirectory;
        manager.fullPath = pMoveView.scanDirectory.scanDirectoryPath;
        pMoveView.beforeMoveArray = self.beforeMoveArray;
        pMoveView.beforeMoveName = self.beforeMoveName;
        pMoveView.delegate = self.delegate;
        pMoveView.isAttachment = self.isAttachment;
        [self.navigationController pushViewController:pMoveView animated:YES];
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

// キャンセルし画面を閉じる
- (void)cancelAction:(id)sender
{
    // iPad用
//    if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
//    {
        if(delegate){
            if([delegate respondsToSelector:@selector(move:didMovedSuccess:)]){
                // デリゲートメソッドの呼び出し(モーダルビューも閉じる)
                [delegate move:self didMovedSuccess:NO];
            }
        }
//        SharpScanPrintAppDelegate* pAppDelegate = (SharpScanPrintAppDelegate*)[[UIApplication sharedApplication] delegate];
//        UINavigationController* pRootNavController = [pAppDelegate.splitViewController.viewControllers objectAtIndex:0];
//        RootViewController_iPad* rootViewController_ipad = (RootViewController_iPad*)[pRootNavController.viewControllers objectAtIndex:0];
//        [rootViewController_ipad OnHelpClose];
//    }
//    else
//    {
//    // iPad用
//        // Modal表示のため、呼び出し元で閉じる処理を行う
//        SharpScanPrintAppDelegate* appDelegate = (SharpScanPrintAppDelegate*)[[UIApplication sharedApplication] delegate];
//        ArrengeSelectFileViewController* pArrengeSelectFileViewController = (ArrengeSelectFileViewController*)appDelegate.navigationController.topViewController;
//    
//        [pArrengeSelectFileViewController OnClose];
//    }
    
}

// 移動したファイルを保存する
- (void)moveAction:(id)sender
{
    // 入力チェック
    iErrCode = [self CheckMoveFile];
    

    if(iErrCode == FILE_ERR_NO_CHANGE)
    {
        // キャンセルされた場合、何もしない
    }
    else
    {
        NSString *pstrErrMessage = @"";
        
        switch (iErrCode)
        {
                // 成功
            case FILE_ERR_SUCCESS:
                pstrErrMessage = MSG_MOVE_SUCCESS;
                break;
                
                // 予約語チェック
            case FILE_ERR_RESERVED_WORD:
                pstrErrMessage = MSG_MOVEFOLDER_FOLDERNAME_ERR;
                break;
                
                // 同一階層チェック
            case FILE_ERR_MOVE_SAMEDIR:
                pstrErrMessage = MSG_MOVE_SAMEDIR;
                break;
                
                // 親子階層チェック
            case FILE_ERR_MOVE_PARENTCHILD:
                pstrErrMessage = MSG_MOVE_PARENTCHILD;
                break;
                
                // 移動先に指定されたファイル名と同じ名前のフォルダーが既に存在
            case FILE_ERR_MOVE_FILEDIRECTORYSAME:
                pstrErrMessage = MSG_MOVE_FILEDIRECTORYSAME;
                break;
                
                // 移動先に指定されたフィルダー名と同じ名前のファイルが既に存在
            case FILE_ERR_MOVE_DIRECTORYFILESAME:
                pstrErrMessage = MSG_MOVE_DIRECTORYFILESAME;
                break;
                
                // 一部のファイル/フォルダーの移動に失敗
            case FILE_ERR_MOVE_FAILED:
                pstrErrMessage = MSG_MOVE_SOMEFILES_AND_DIRECTORIES;
                break;
                
                // 失敗
            case FILE_ERR_FAILED:
                pstrErrMessage = MSG_MOVE_FAILED;
                break;
                
            default:
                break;
        }
        
        SharpScanPrintAppDelegate* appDelegate = (SharpScanPrintAppDelegate*)[[UIApplication sharedApplication] delegate];
        // 処理実行フラグON
        appDelegate.IsRun = TRUE;
        
        [self makeTmpExAlert:nil message:pstrErrMessage cancelBtnTitle:MSG_BUTTON_OK okBtnTitle:nil tag:2 showFlg:YES];
        
    }
    
}

// 移動したファイルを保存する
- (void)saveAction:(id)sender
{
    // 入力チェック
    iErrCode = [self CheckMoveFile];
    
    
    if(iErrCode == FILE_ERR_NO_CHANGE)
    {
        // キャンセルされた場合、何もしない
    }
    else
    {
        NSString *pstrErrMessage = @"";
        
        switch (iErrCode)
        {
                // 成功
            case FILE_ERR_SUCCESS:
                pstrErrMessage = MSG_SAVE;//*** 差し替えが必要？
                break;
                
                // 予約語チェック
            case FILE_ERR_RESERVED_WORD:
                pstrErrMessage = MSG_MOVEFOLDER_FOLDERNAME_ERR;
                break;
                
                // 同一階層チェック
            case FILE_ERR_MOVE_SAMEDIR:
                pstrErrMessage = MSG_MOVE_SAMEDIR;
                break;
                
                // 親子階層チェック
            case FILE_ERR_MOVE_PARENTCHILD:
                pstrErrMessage = MSG_MOVE_PARENTCHILD;
                break;
                
                // 移動先に指定されたファイル名と同じ名前のフォルダーが既に存在
            case FILE_ERR_MOVE_FILEDIRECTORYSAME:
                pstrErrMessage = MSG_MOVE_FILEDIRECTORYSAME;
                break;
                
                // 移動先に指定されたフィルダー名と同じ名前のファイルが既に存在
            case FILE_ERR_MOVE_DIRECTORYFILESAME:
                pstrErrMessage = MSG_MOVE_DIRECTORYFILESAME;
                break;
                
                // 一部のファイル/フォルダーの移動に失敗
            case FILE_ERR_MOVE_FAILED:
                pstrErrMessage = MSG_MOVE_SOMEFILES_AND_DIRECTORIES;
                break;
                
                // 失敗
            case FILE_ERR_FAILED:
                pstrErrMessage = MSG_MOVE_FAILED;//*** 差し替えが必要？
                break;
                
            default:
                break;
        }
        
        SharpScanPrintAppDelegate* appDelegate = (SharpScanPrintAppDelegate*)[[UIApplication sharedApplication] delegate];
        // 処理実行フラグON
        appDelegate.IsRun = TRUE;
        
        [self makeTmpExAlert:nil message:pstrErrMessage cancelBtnTitle:MSG_BUTTON_OK okBtnTitle:nil tag:2 showFlg:YES];
        
    }
    
}

// 移動ファイルをチェック
- (NSInteger)CheckMoveFile
{

    // 実行前チェック
    if (self.beforeMoveArray == nil || self.beforeMoveName == nil)
    {
        // エラー
        return FILE_ERR_FAILED;
    }
    
    // 移動元ファイル（およびフォルダー）に同じ名前のものがないかどうかをチェックする
    NSOrderedSet *orderdSet = [NSOrderedSet orderedSetWithArray:self.beforeMoveName];
    if (self.beforeMoveName.count != orderdSet.count) {
        return FILE_ERR_FAILED;
    }
    
    NSString *dir;
    dir = self.scanDirectory.scanDirectoryPath;
    //
    // 同一階層チェック
    //
//    if ([self.beforeDir isEqualToString:dir])
//    {
//        return FILE_ERR_MOVE_SAMEDIR;
//    }
    
    //
    // 親子階層チェック
    //
    NSInteger cnt = 0;    
    NSString *pstrBefore;
    NSString *pstrBeforeName;
    NSString *pstrAfter;
    for (cnt = 0; cnt < [self.beforeMoveArray count] ; cnt++)
    {
        pstrBefore = [NSString stringWithFormat:@"%@/" ,[self.beforeMoveArray objectAtIndex:cnt]];
        pstrBeforeName = [self.beforeMoveName objectAtIndex:cnt];
        
        pstrAfter = [NSString stringWithFormat:@"%@/%@" , dir,pstrBeforeName];
        
        DLog(@"pstrBefore = %@",pstrBefore);
        DLog(@"pstrAfter = %@",pstrAfter);
        
        // 予約語チェック
        if ([CommonUtil IsReserved:pstrAfter]) {
            return FILE_ERR_RESERVED_WORD;
        }
        
        //
        // 同一階層チェック(複数選択時)
        //
        if ([pstrAfter isEqualToString:[self.beforeMoveArray objectAtIndex:cnt]])
        {
            return FILE_ERR_MOVE_SAMEDIR;
        }
        
        // 親ディレクトリから子ディレクトリに移動する場合はエラーとする
        if([pstrAfter hasPrefix:pstrBefore])
        {
            return FILE_ERR_MOVE_PARENTCHILD;
        }

    }
 
    NSInteger ret = EXISTS_OVERWRITEFILE_OK;
    // ファイル上書きチェック
    ret = [self CheckOverwriteFile :self.beforeMoveArray baseDirPath:self.scanDirectory.scanDirectoryPath];
    if (ret == EXISTS_OVERWRITEFILE_OVERWRITE)
    {
        [self makeTmpExAlert:nil message:MSG_MOVE_PATHEXISTS cancelBtnTitle:S_BUTTON_CANCEL okBtnTitle:MSG_BUTTON_OK tag:1 showFlg:YES];
        
        alertFinished = NO;
        cancelClick = NO;
        while (alertFinished == NO)
        {
            [[NSRunLoop currentRunLoop]runUntilDate:[NSDate dateWithTimeIntervalSinceNow:0.5f]];
        }
        
        // キャンセルされた場合は何もしない
        if(cancelClick)
        {
            return FILE_ERR_NO_CHANGE;
        }
    }
    else if(ret == EXISTS_OVERWRITEFILE_FILEDIRECTORYSAME)
    {
        // 移動先に指定されたファイル名と同じ名前のフォルダーが既に存在
        return FILE_ERR_MOVE_FILEDIRECTORYSAME;
    }
    else if(ret == EXISTS_OVERWRITEFILE_DIRECTORYFILESAME)
    {
        // 移動先に指定されたフィルダー名と同じ名前のファイルが既に存在
        return FILE_ERR_MOVE_DIRECTORYFILESAME;
    }
    
    // 移動処理 
    for (cnt = 0; cnt < [self.beforeMoveArray count] ; cnt++)
    {
        BOOL bRet = NO;
        NSString *filepath = [self.beforeMoveArray objectAtIndex:cnt];
        NSString *fileName = [self.beforeMoveName objectAtIndex:cnt];

        if([GeneralFileUtility isDirectory:filepath]){
            ScanDirectory *scanDirectoryManipulated = [[ScanDirectory alloc ]initWithScanDirectoryPath:filepath];
            ScanDirectory *scanDirectoryDestination = [[ScanDirectory alloc]initWithScanDirectoryPath:[self.scanDirectory.scanDirectoryPath stringByAppendingPathComponent:fileName]];
            bRet = [ScanDirectoryUtility move:scanDirectoryManipulated Destination:scanDirectoryDestination];
        }else{
            ScanFile *scanFileDestination = [[ScanFile alloc]initWithScanFilePath:[self.scanDirectory.scanDirectoryPath stringByAppendingPathComponent:fileName]];
            if (self.isAttachment) {
                TempAttachmentFile *tempAttachmentFileManipulated = [[TempAttachmentFile alloc] initWithFilePath:filepath];
                bRet = [GeneralFileUtility copy:tempAttachmentFileManipulated ToScanFile:scanFileDestination];
            } else {
                ScanFile *scanFileManipulated = [[ScanFile alloc]initWithScanFilePath:filepath];
                bRet = [ScanFileUtility move:scanFileManipulated Destination:scanFileDestination];
            }
        }
        if (!bRet) {
            ret = FILE_ERR_MOVE_FAILED;
            break;
        }
        ret = FILE_ERR_SUCCESS;
    }
    
    if (ret == FILE_ERR_SUCCESS)
    {
        return FILE_ERR_SUCCESS;
    }
    else if(ret == FILE_ERR_MOVE_FAILED)
    {
        return FILE_ERR_MOVE_FAILED;
    }
    
    return FILE_ERR_FAILED;

}

// ファイル上書きチェック
- (NSInteger)CheckOverwriteFile:(NSMutableArray*)Array baseDirPath:(NSString*)baseDirPath
{
    NSInteger ret = 0;
    NSInteger cnt = 0;    
    NSString *pstrBefore;
    NSString *pstrBeforeName;
    NSString *pstrAfter;
    CommonManager* pCommonManager = [[CommonManager alloc] init];  

    // 移動先重複チェック
    for (cnt = 0; cnt < [Array count] ; cnt++)
    {
        pstrBefore = [Array objectAtIndex:cnt];
        pstrBeforeName = [pstrBefore lastPathComponent];
        pstrAfter = [NSString stringWithFormat:@"%@/%@" ,baseDirPath,pstrBeforeName];
        
        // ディレクトリかファイルの判別
        //
        if([CommonUtil directoryCheck2:pstrBefore name:pstrBeforeName])
        {
            //同じ名前のフォルダー/ファイルがある場合
            if([pCommonManager existsFile:pstrBeforeName :baseDirPath])
            {
                
                NSInteger i = [CommonUtil getSameNameData:baseDirPath beforePath:pstrAfter];
                //ファイル
                if(i == 1)
                {
                    //同じ名前のファイルが存在
                    ret = EXISTS_OVERWRITEFILE_DIRECTORYFILESAME;
                    break;
                }
                //フォルダー
                else if(i == 2)
                {
                    NSMutableArray *localSrcPath = nil;
                    localSrcPath = [CommonUtil getlocalPathData:pstrBefore];
                    
                    NSInteger localRet;
                    localRet = [self CheckOverwriteFile:localSrcPath baseDirPath:pstrAfter];
                    if( ret < localRet)
                    {
                        ret = localRet;
                    }
                    if(ret == EXISTS_OVERWRITEFILE_FILEDIRECTORYSAME || ret ==  EXISTS_OVERWRITEFILE_DIRECTORYFILESAME)
                    {
                        break;
                    }
                }

            }
            
            //ない場合は何もしない
        }
        else
        {
            //同じ名前のフォルダー/ファイルが存在するか確認
            if([pCommonManager existsFile:pstrBeforeName :baseDirPath])
            {

                NSInteger i = [CommonUtil getSameNameData:baseDirPath beforePath:pstrAfter];
                if(i == 1)
                {
                    //上書きしてもよいか確認ダイアログを出す
                    if(ret < EXISTS_OVERWRITEFILE_OVERWRITE)
                    {
                        ret = EXISTS_OVERWRITEFILE_OVERWRITE;
                    }
                }
                //同じ名前のフォルダーが存在する場合
                else if(i == 2)
                {
                    //同じ名前のフォルダーが存在
                    ret = EXISTS_OVERWRITEFILE_FILEDIRECTORYSAME;
                    break;
                }
                
            }
            //ない場合は何もしない
        }
    }
    return ret;
}

// ファイル移動処理
-(NSInteger)fileMove:(NSString*)beforeMovePath baseDirPath:(NSString*)baseDirPath
{
    NSInteger error = 0;
    NSString *pstrBefore;
    NSString *pstrBeforeName;
    NSString *pstrAfter;
    CommonManager* pCommonManager = [[CommonManager alloc] init];
    if (beforeMovePath == nil)
    {
        // エラー
        return FILE_ERR_FAILED;
    }
    // 移動前、移動後のフルパスを取得する
    pstrBefore = beforeMovePath;
    pstrBeforeName = [pstrBefore lastPathComponent];
    pstrAfter = [NSString stringWithFormat:@"%@/%@" ,baseDirPath,pstrBeforeName];

    @autoreleasepool
    {
        @try
        {
            // ディレクトリかファイルの判別
            //
            if([CommonUtil directoryCheck2:pstrBefore name:pstrBeforeName])
            {
                //同じ名前のフォルダー/ファイルがない場合
                if(![pCommonManager existsFile:pstrBeforeName :baseDirPath])
                {
                    //フォルダ作成
                    [pCommonManager makeDir:pstrBeforeName saveDir:baseDirPath];
                }
                //サブディレクトリを確認
                NSMutableArray *localSrcPath = [[NSMutableArray alloc] init ];
                NSMutableArray *localChildPath = [[NSMutableArray alloc] init ];
                
                localSrcPath = [CommonUtil getlocalPathData:pstrBefore];
                DLog(@"Path = %@",localSrcPath);
                
                NSInteger row;
                for(row = 0; row < [localSrcPath count] ; row++)
                {
                    [localChildPath addObject:[localSrcPath objectAtIndex:row]];
                    [self fileMove:[localChildPath objectAtIndex:row] baseDirPath:pstrAfter];
                }
                if(![pstrBefore isEqualToString:pstrAfter])
                {
                    //移動が完了したフォルダを削除する
                    [pCommonManager removeFile:pstrBefore];
                }
            }
            else
            {
                //同じ名前のフォルダー/ファイルが存在するか確認
                if([pCommonManager existsFile:pstrBeforeName :baseDirPath])
                {
                    if(![pstrBefore isEqualToString:pstrAfter])
                    {
                        //移動前に削除(ファイルの上書き対応)
                        [pCommonManager removeFile:pstrAfter];
                    }
                }
                if (isAttachment) {
                    //対象のファイルをコピーする
                    [pCommonManager copyFile:pstrBefore :pstrAfter];
                    
                }else {
                    //対象のファイルを移動する
                    [pCommonManager moveFile:pstrBefore :pstrAfter];
                }
            }
            
            if(error < FILE_ERR_SUCCESS)
            {
                error = FILE_ERR_SUCCESS;
            }
        }
        @catch (NSException *exception)
        {
            // 一部のファイル/フォルダーが移動できませんでした。
            error = FILE_ERR_MOVE_FAILED;
        }
        @finally
        {
        }
    }
    
    return error;
}

//// サムネイル画像移動処理
//-(NSInteger)thumbnailMove:(NSString*)beforeMovePath baseDirPath:(NSString*)baseDirPath
//{
//    NSString *pngDir = [CommonUtil pngDir:baseDirPath];
//    BOOL isDir;
//    NSFileManager *lFileManager	= [NSFileManager defaultManager];
//        
//    NSString *thumbnailPath = beforeMovePath;
//    if (([lFileManager fileExistsAtPath:thumbnailPath isDirectory:&isDir] && isDir)) 
//    {
//        return 1;
//    }
//    else
//    {
//        [self fileMove:[CommonUtil thumbnailPath:thumbnailPath]baseDirPath:pngDir];
//        return 0;
//    }
//
//}

// PDFキャッシュフォルダ移動処理
-(NSInteger)cacheDirlMove:(NSString*)beforeMovePath baseDirPath:(NSString*)baseDirPath
{
    NSString *cacheDir = baseDirPath;
    BOOL isDir;
    NSFileManager *lFileManager	= [NSFileManager defaultManager];
    
    NSString *cacheDirPath = beforeMovePath;
    if (([lFileManager fileExistsAtPath:cacheDirPath isDirectory:&isDir] && isDir)) 
    {
        return 1;
    }
    else
    {
        [self fileMove:[CommonUtil GetCacheDirByScanFilePath:cacheDirPath] baseDirPath:cacheDir];
        return 0;
    }
    
}

//ダイアログのボタン押下時
-(void)alertButtonPushed:(UIAlertController *)alertController tagIndex:(NSInteger)tagIndex buttonIndex:(NSInteger)buttonIndex{
    [self alertButtonClicked:alertController tagIndex:tagIndex buttonIndex:buttonIndex];
}

-(void)alertButtonClicked:(UIAlertController *)alertController tagIndex:(NSInteger)tagIndex buttonIndex:(NSInteger)buttonIndex
{
    SharpScanPrintAppDelegate* appDelegate = (SharpScanPrintAppDelegate*)[[UIApplication sharedApplication] delegate];
    // 処理実行フラグOFF
    appDelegate.IsRun = FALSE;

    if(tagIndex == 1)
    {
        if (buttonIndex == 0)
        {
            cancelClick = YES;
        }
        alertFinished = YES;
    }
    if(tagIndex == 2)
    {
        if (iErrCode == FILE_ERR_SUCCESS || iErrCode == FILE_ERR_MOVE_FAILED)
        {
            // 成功時、一部のファイル/フォルダーは移動できている場合、処理は完了
            if(delegate){
                if([delegate respondsToSelector:@selector(move:didMovedSuccess:)]){
                    // デリゲートメソッドの呼び出し(モーダルビューも閉じる)
                    [delegate move:self didMovedSuccess:YES];
                }
            }
        }
    }
}

// ヘッダー表示
- (void)SetHeaderView
{
    
    UILabel *label = [[UILabel alloc] init];
//    label.frame = CGRectMake(10.0, 0.0, 300.0, 24.0);
    label.frame = CGRectMake(10.0, 0.0, self.view.frame.size.width-20.0, 24.0);
    label.backgroundColor = [UIColor grayColor];
    label.textColor = [UIColor whiteColor];
    label.font = [UIFont fontWithName:@"AppleGothic" size:16];
    label.textAlignment = NSTextAlignmentLeft;
    label.adjustsFontSizeToFitWidth = NO;
    label.lineBreakMode = NSLineBreakByTruncatingMiddle;
    
    NSString *pstrText = self.scanDirectory.relativeDirectoryPathInScanFile;
    if(pstrText == nil || [pstrText isEqualToString:@""])
    {
        label.text = @"/";
    }
    else
    {
        label.text = pstrText;
    }
//    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0.0, 0.0, 400.0, 25.0)];
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0.0, 0.0, self.view.frame.size.width, 25.0)];   
    headerView.backgroundColor = [UIColor grayColor];
    [headerView addSubview:label];
    //TableViewにヘッダー設定
    self.tableView.tableHeaderView = headerView;
    
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
    pCreateFolderViewController.scanDirectory	= self.scanDirectory;
    //    [self.navigationController pushViewController:pCreateFolderViewController animated:YES];
    
    // モーダル表示
    UINavigationController *navigationController = [[UINavigationController alloc]initWithRootViewController:pCreateFolderViewController];
    navigationController.navigationBar.barStyle = NAVIGATION_BARSTYLE;
    [navigationController setModalPresentationStyle:UIModalPresentationPageSheet];
    [self presentViewController:navigationController animated:YES completion:nil];
    
    
}

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
