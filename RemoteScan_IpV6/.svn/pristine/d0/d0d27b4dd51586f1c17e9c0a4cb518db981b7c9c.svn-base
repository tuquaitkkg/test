
#import "CreateFolderViewController.h"
#import "SharpScanPrintAppDelegate.h"
#import "Define.h"
#import "CommonUtil.h"
#import "CommonManager.h"
#import "ScanDataManager.h"
// iPad用
#import "ArrengeSelectFileViewController_iPad.h"
#import "RootViewController_iPad.h"
// iPad用
#import "ArrengeSelectFileViewController.h"
#import "SaveScanAfterDataViewController.h"

@implementation CreateFolderViewController

@synthesize delegate;
@synthesize bSaveView;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
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

    // UINavigationBar 44px のずれを無くす
    self.navigationController.navigationBar.translucent = NO;
    self.navigationController.navigationBar.barStyle = NAVIGATION_BARSTYLE;
    
    // ナビゲーションバー
    // タイトル設定
    CGRect frame = CGRectMake(0, 0, 400, 44);
    UILabel* lblTitle = [[UILabel alloc]initWithFrame:frame];
    lblTitle.backgroundColor = [UIColor clearColor];
    lblTitle.textColor = NAVIGATION_TITLE_COLOR;
    lblTitle.font = [UIFont boldSystemFontOfSize:14];
    lblTitle.textAlignment = NSTextAlignmentCenter;
    lblTitle.text = S_TITLE_CREATE_FOLDER;
    self.navigationItem.titleView = lblTitle;
    lblTitle.adjustsFontSizeToFitWidth = YES;
    m_folderName.text = S_TITLE_CREATE_FOLDER_NAME;
    
    if(bSaveView)
    {
        // 戻るボタンの名称変更
        UIBarButtonItem * barItemBack = [UIBarButtonItem new];
        barItemBack.title = S_BUTTON_BACK;
        self.navigationItem.backBarButtonItem = barItemBack;
    }
    else
    {
        // ナビゲーションバー左側にキャンセルボタンを設定
        UIBarButtonItem* btnClose = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel
                                                                                  target:self 
                                                                                  action:@selector(cancelAction)];
        self.navigationItem.leftBarButtonItem = btnClose; 
        
    }
    
    // 保存ボタン追加
    UIBarButtonItem* btnSave = [[UIBarButtonItem alloc] initWithTitle:S_BUTTON_SAVEVAL style:UIBarButtonItemStyleDone target:self action:@selector(OnNavBarRightButton:)];
    
    self.navigationItem.rightBarButtonItem = btnSave;
    
    // デリゲート設定
    m_ptxtfolderName.delegate = self;
    
    // キーボード変更
    //m_ptxtfolderName.keyboardAppearance = UIKeyboardAppearanceAlert;
    m_ptxtfolderName.keyboardAppearance = UIKeyboardAppearanceLight;
    
    // 入力キーボード設定
    m_ptxtfolderName.keyboardType = UIKeyboardTypeDefault;
    
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
    
    // iPadのみテキストフィールドの文字サイズを大きくする
    if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
    {
        m_ptxtfolderName.font = [UIFont systemFontOfSize:16];
    }

    self.view.backgroundColor = BACKGROUND_COLOR;// TableViewに合わせた背景を設定
    if([[[UIDevice currentDevice] systemVersion] floatValue] >= 6.0 &&
       [[[UIDevice currentDevice] systemVersion] floatValue] < 7.0 &&
       UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
    {// iOS6のiPhoneだけ
        UITableView *tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
        [self.view addSubview:tableView];
        [self.view sendSubviewToBack:tableView];
    }

    // iPad用
 
    // キーボード表示
    [m_ptxtfolderName becomeFirstResponder];
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

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // iPad用
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

// キャンセルし画面を閉じる
- (void)cancelAction
{
    if(delegate){
        if([delegate respondsToSelector:@selector(createFolder:didCreatedSuccess:)]){
            // デリゲートメソッドの呼び出し(モーダルビューも閉じる)
            [delegate createFolder:self didCreatedSuccess:NO];
        }
    }
}

// ナビゲーションバー 保存ボタン押下
- (IBAction)OnNavBarRightButton:(id)sender
{
    // 入力チェック
    NSInteger iErrCode = [self CheckNewFolderName];
    
    if (iErrCode == FILE_ERR_SUCCESS)
    {
        if(bSaveView)
        {
            // 前画面に戻る
            [self.navigationController popViewControllerAnimated:YES];
        }
        else
        {
            if(delegate){
                if([delegate respondsToSelector:@selector(createFolder:didCreatedSuccess:)]){
                    // デリゲートメソッドの呼び出し(モーダルビューも閉じる)
                    [delegate createFolder:self didCreatedSuccess:YES];
                }
            }
        }
    }
    else
    {
        NSString *pstrErrMessage = @"";
        
        switch (iErrCode)
        {
                // ファイル名未入力
            case FILE_ERR_NO_INPUT:
                pstrErrMessage = [NSString stringWithFormat:MSG_REQUIRED_ERR, SUBMSG_FOLDERNAME_ERR];
                break;
                
                // 文字数チェック
            case FILE_ERR_OVER_NUM_RANGE:
                pstrErrMessage = [NSString stringWithFormat:MSG_LENGTH_ERR, SUBMSG_FOLDERNAME_ERR, SUBMSG_FILENAME_FORMAT];                    
                break;
                
                // 文字種（絵文字）チェック
            case FILE_ERR_INVALID_CHAR_TYPE:
                pstrErrMessage = [NSString stringWithFormat:MSG_FILENAME_FORMAT, SUBMSG_FOLDERNAME_ERR];
                break;
                
                // 予約語チェック
            case FILE_ERR_RESERVED_WORD:
                pstrErrMessage = MSG_ENTERED_FOLDERNAME_ERR;
                break;
                
                // 同じファイル名が存在
            case FILE_ERR_EXISTS_SAME:
                pstrErrMessage = [NSString stringWithFormat:MSG_SAME_NAME_ERR, SUBMSG_FOLDERNAME_ERR];
                break;
                
                // 失敗
            case FILE_ERR_FAILED:
                pstrErrMessage = MSG_CREATE_DIR_FAILED;
                break;
                
            default:
                break;
        }
        
        SharpScanPrintAppDelegate* appDelegate = (SharpScanPrintAppDelegate*)[[UIApplication sharedApplication] delegate];
        // 処理実行フラグON
        appDelegate.IsRun = TRUE;
        
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil
                                                                                 message:pstrErrMessage
                                                                          preferredStyle:UIAlertControllerStyleAlert];
        
        // Cancel用のアクションを生成
        UIAlertAction *cancelAction =
        [UIAlertAction actionWithTitle:MSG_BUTTON_OK
                                 style:UIAlertActionStyleCancel
                               handler:^(UIAlertAction * action) {
                                   
                                   // ボタンタップ時の処理
                                   [self appDelegateIsRunOff];
                               }];
        
        // コントローラにアクションを追加
        [alertController addAction:cancelAction];
        // アラート表示処理
        [self presentViewController:alertController animated:YES completion:nil];
        return;
    }
    
}

// 処理実行フラグをOFFにする
- (void)appDelegateIsRunOff {
    // ボタンタップ時の処理
    SharpScanPrintAppDelegate* appDelegate = (SharpScanPrintAppDelegate*)[[UIApplication sharedApplication] delegate];
    // 処理実行フラグOFF
    appDelegate.IsRun = FALSE;
}

// フォルダー名をチェック
- (NSInteger)CheckNewFolderName
{
    if (!self.scanDirectory)
    {
        // エラー
        return FILE_ERR_FAILED;
    }
    
    NSString* pstrNewFolderName = m_ptxtfolderName.text;
//    NSString* pstrNewCreateFolderName = [NSString stringWithFormat:@"DIR-%@",pstrNewFolderName];
    // フォルダ名にDIR-はなくなっている
    NSString* pstrNewCreateFolderName = pstrNewFolderName;
    
    // 空白チェック
    if (pstrNewFolderName == nil || [pstrNewFolderName isEqualToString:@""] || pstrNewFolderName.length == 0)
    {
        return FILE_ERR_NO_INPUT;
    }
    
    // 文字数チェック
    if ([CommonUtil IsFileName:pstrNewFolderName] != ERR_SUCCESS)
    {
        return FILE_ERR_OVER_NUM_RANGE;
    }
    
    // 使用不可文字チェック
    if ([CommonUtil fileNameCheck:pstrNewFolderName])
    {
        return FILE_ERR_INVALID_CHAR_TYPE;
    }
    
    // 絵文字チェック
    if ( [CommonUtil IsUsedEmoji: pstrNewFolderName] ) {
        return FILE_ERR_INVALID_CHAR_TYPE;
    }
    
    // 予約語チェック
    NSString *targetPath = [self.scanDirectory.scanDirectoryPath stringByAppendingPathComponent:pstrNewFolderName];
    if ([CommonUtil IsReserved:targetPath]) {
        return FILE_ERR_RESERVED_WORD;
    }
    
    // 同じ名称ファイルの存在チェック     
    ScanDataManager* pScanDataManager = [[ScanDataManager alloc] init];
    pScanDataManager.fullPath = self.scanDirectory.scanDirectoryPath;
    [pScanDataManager reGetScanData];
    if(![pScanDataManager checkFolderData:pstrNewCreateFolderName])
    {
        return FILE_ERR_EXISTS_SAME;
    }
        
    // ディレクトリの作成
    NSString * pstrNewCreateFolderPath = [self.scanDirectory.scanDirectoryPath stringByAppendingPathComponent:pstrNewCreateFolderName];
    ScanDirectory *scanDirectory = [[ScanDirectory alloc]initWithScanDirectoryPath:pstrNewCreateFolderPath];
    if([ScanDirectoryUtility createDirectory:scanDirectory]){
        return FILE_ERR_SUCCESS;
    }
    return FILE_ERR_FAILED;
}

// キーボードReturnキー押下イベント
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [m_ptxtfolderName resignFirstResponder];
    return YES;
}

//iPad用
// 縦表示時のメニューボタン設定
- (void)setPortraitMenu:(UIBarButtonItem *)barButtonItem
{
    // 戻るボタンがあるためメニューを表示しない
}

- (void)popRootView
{
    [self.navigationController popToRootViewControllerAnimated:YES];
}
//iPad用

@end
