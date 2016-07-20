
#import "FileNameChangeViewController.h"
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

#import "ScanFile.h"
#import "ScanFileUtility.h"
#import "ScanDirectory.h"
#import "ScanDirectoryUtility.h"

@implementation FileNameChangeViewController

@synthesize delegate;
@synthesize SelFilePath = m_pstrFilePath;
@synthesize SelFileName = m_pstrFileName;
@synthesize isDirectory;

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
    lblTitle.adjustsFontSizeToFitWidth = YES;
    if( self.isDirectory)
    {
        lblTitle.text = S_TITLE_CHANGE_FOLDERNAME;
    }
    else
    {
        lblTitle.text = S_TITLE_CHANGE_FILENAME;        
    }
    self.navigationItem.titleView = lblTitle;
   
    // デリゲート設定
    m_ptxtfileName.delegate = self;
    
    // キーボード変更
    //m_ptxtfileName.keyboardAppearance = UIKeyboardAppearanceAlert;
    m_ptxtfileName.keyboardAppearance = UIKeyboardAppearanceLight;
    
    // 入力キーボード設定
    m_ptxtfileName.keyboardType = UIKeyboardTypeDefault;

    // ナビゲーションバー左側にキャンセルボタンを設定
    UIBarButtonItem* btnClose = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel
                                                                              target:self 
                                                                              action:@selector(cancelAction)];
    self.navigationItem.leftBarButtonItem = btnClose; 
    
    
    // 保存ボタン追加
    UIBarButtonItem* btnSave = [[UIBarButtonItem alloc] initWithTitle:S_BUTTON_SAVEVAL style:UIBarButtonItemStyleDone target:self action:@selector(OnNavBarRightButton:)];
    
    self.navigationItem.rightBarButtonItem = btnSave;
    

}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
 
    if( self.isDirectory)
    {
        m_fileName.text = S_TITLE_FOLDER_NAME;
        // ファイル名
        m_ptxtfileName.text = self.SelFileName;
    }
    else
    {
        m_fileName.text = S_TITLE_FILE_NAME;
        
        
        // テキストボックスのサイズの取得
        float x = m_ptxtfileName.frame.origin.x;
        float y = m_ptxtfileName.frame.origin.y;
        float w = m_ptxtfileName.frame.size.width;
        float h = m_ptxtfileName.frame.size.height;

        // 横幅サイズ変更
        m_ptxtfileName.frame = CGRectMake(x, y, w-30, h);
        
        // 拡張子ラベルの設定
        CGRect frame = CGRectMake(w-10, y, 50, h);
        UILabel* lblExtension = [[UILabel alloc]initWithFrame:frame];
        lblExtension.backgroundColor = [UIColor clearColor];
        lblExtension.textColor = [UIColor blackColor];
        // iPadのみ文字サイズを大きくする
        if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
        {
            lblExtension.font = [UIFont systemFontOfSize:14];
        }
        else
        {
            lblExtension.font = [UIFont systemFontOfSize:12];
        }
        lblExtension.textAlignment = NSTextAlignmentLeft;
        lblExtension.text = [NSString stringWithFormat:@".%@",[self.SelFileName pathExtension]];
        [self.view addSubview:lblExtension];
        
        // ファイル名
        m_ptxtfileName.text = [self.SelFileName stringByDeletingPathExtension];
    }
    
    // iPadのみテキストフィールドの文字サイズを大きくする
    if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
    {
        m_ptxtfileName.font = [UIFont systemFontOfSize:16];
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
    
    // キーボード表示
    [m_ptxtfileName becomeFirstResponder];
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

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
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
//    // iPad用
//    if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
//    {
        if(delegate){
            if([delegate respondsToSelector:@selector(nameChange:didNameChangeSuccess:)]){
                // デリゲートメソッドの呼び出し(モーダルビューも閉じる)
                [delegate nameChange:self didNameChangeSuccess:NO];
            }
        }
//        SharpScanPrintAppDelegate* pAppDelegate = (SharpScanPrintAppDelegate*)[[UIApplication sharedApplication] delegate];
//        UINavigationController* pRootNavController = [pAppDelegate.splitViewController.viewControllers objectAtIndex:0];
//        RootViewController_iPad* rootViewController_ipad = (RootViewController_iPad*)[pRootNavController.viewControllers objectAtIndex:0];
//        [rootViewController_ipad OnHelpClose];
//    }
//    else
//    {
//        // iPad用
//        // Modal表示のため、呼び出し元で閉じる処理を行う
//        SharpScanPrintAppDelegate* appDelegate = (SharpScanPrintAppDelegate*)[[UIApplication sharedApplication] delegate];
//        ArrengeSelectFileViewController* pArrengeSelectFileViewController = (ArrengeSelectFileViewController*)appDelegate.navigationController.topViewController;
//        
//        [pArrengeSelectFileViewController OnClose];
//    }
    
}

// ナビゲーションバー 保存ボタン押下
- (IBAction)OnNavBarRightButton:(id)sender
{
    if ([m_ptxtfileName isEditing]) {
        [m_ptxtfileName resignFirstResponder];
    }
    
	// 入力チェック
    NSInteger iErrCode = [self CheckNewFileName];
    
    if (iErrCode == FILE_ERR_SUCCESS)
    {
        // 前画面に戻る
//        [self.navigationController popViewControllerAnimated:YES];
                
        // iPad用
//        if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
//        {
            if(delegate){
                if([delegate respondsToSelector:@selector(nameChange:didNameChangeSuccess:)]){
                    // デリゲートメソッドの呼び出し(モーダルビューも閉じる)
                    [delegate nameChange:self didNameChangeSuccess:YES];
                }
            }
//            SharpScanPrintAppDelegate* pAppDelegate = (SharpScanPrintAppDelegate*)[[UIApplication sharedApplication] delegate];

//            // 右側のViewを取得
//            UINavigationController* pDetailNavController = [pAppDelegate.splitViewController.viewControllers objectAtIndex:1];
//            
//            // 右側Viewに戻り先画面がある場合
//            if([pDetailNavController.viewControllers count] > 1)
//            {    
//                // 移動元画面を指定する
//                ArrengeSelectFileViewController_iPad* arrangeViewController_ipad = (ArrengeSelectFileViewController_iPad*)
//                [pDetailNavController.viewControllers objectAtIndex:[pDetailNavController.viewControllers count]-1];
//                [arrangeViewController_ipad OnClose];
//            }
//            else
//            {
//                ArrengeSelectFileViewController_iPad* arrangeViewController_ipad = (ArrengeSelectFileViewController_iPad*)
//                [pDetailNavController.viewControllers objectAtIndex:0];
//                [arrangeViewController_ipad OnClose];
//            }
      
//        }
//        else
//        {
//        // iPad用
//            // Modal表示のため、呼び出し元で閉じる処理を行う
//            SharpScanPrintAppDelegate* appDelegate = (SharpScanPrintAppDelegate*)[[UIApplication sharedApplication] delegate];
//            ArrengeSelectFileViewController* pArrengeSelectFileViewController = (ArrengeSelectFileViewController*)appDelegate.navigationController.topViewController;
//            
//            [pArrengeSelectFileViewController OnClose];
//        }
    }
    else
    {
        NSString *pstrErrMessage = @"";
        
        switch (iErrCode)
        {
                // ファイル名未入力
            case FILE_ERR_NO_INPUT:
                if(self.isDirectory)
                {
                    pstrErrMessage = [NSString stringWithFormat:MSG_REQUIRED_ERR, SUBMSG_FOLDERNAME_ERR];
                }
                else
                {
                    pstrErrMessage = [NSString stringWithFormat:MSG_REQUIRED_ERR, SUBMSG_FILENAME_ERR];
                }
                break;
                
                // 文字数チェック
            case FILE_ERR_OVER_NUM_RANGE:
                if(self.isDirectory)
                {
                    pstrErrMessage = [NSString stringWithFormat:MSG_LENGTH_ERR, SUBMSG_FOLDERNAME_ERR, SUBMSG_FILENAME_FORMAT];                    
                }
                else
                {
                    pstrErrMessage = [NSString stringWithFormat:MSG_LENGTH_ERR, SUBMSG_FILENAME_ERR, SUBMSG_FILENAME_FORMAT];                    
                }
                break;
                
                // 文字種（絵文字）チェック
            case FILE_ERR_INVALID_CHAR_TYPE:
                if(self.isDirectory)
                {
                    pstrErrMessage = [NSString stringWithFormat:MSG_FILENAME_FORMAT, SUBMSG_FOLDERNAME_ERR];
                }
                else
                {
                    pstrErrMessage = [NSString stringWithFormat:MSG_FILENAME_FORMAT, SUBMSG_FILENAME_ERR];
                }
                break;
                
                // 予約語チェック
            case FILE_ERR_RESERVED_WORD:
                if(self.isDirectory)
                {
                    pstrErrMessage = [NSString stringWithFormat:MSG_ENTERED_FOLDERNAME_ERR, SUBMSG_FOLDERNAME_ERR];
                }
                break;

                // 同じファイル名が存在
            case FILE_ERR_EXISTS_SAME:
                if(self.isDirectory)
                {
                    pstrErrMessage = [NSString stringWithFormat:MSG_SAME_NAME_ERR, SUBMSG_FOLDERNAME_ERR];
                }
                else
                {
                    pstrErrMessage = [NSString stringWithFormat:MSG_SAME_NAME_ERR, SUBMSG_FILENAME_ERR];                    
                }
                break;
                
                // 失敗
            case FILE_ERR_FAILED:
                if(self.isDirectory)
                {
                    pstrErrMessage = [NSString stringWithFormat:MSG_CHANGE_FAILED, SUBMSG_FOLDERNAME_ERR];
                }
                else
                {
                    pstrErrMessage = [NSString stringWithFormat:MSG_CHANGE_FAILED, SUBMSG_FILENAME_ERR];
                }
                break;
                
            default:
                break;
        }
        
        SharpScanPrintAppDelegate* appDelegate = (SharpScanPrintAppDelegate*)[[UIApplication sharedApplication] delegate];
        // 処理実行フラグON
        appDelegate.IsRun = TRUE;
        
        errorMessageView = [self makeUIAlertController:nil message:pstrErrMessage cancelBtnTitle:MSG_BUTTON_OK okBtnTitle:nil showFlg:YES];
        
        return;
    }

}

// ファイル名をチェック
- (NSInteger)CheckNewFileName
{
    if (self.SelFileName == nil)
    {
        // エラー
        return FILE_ERR_FAILED;
    }
    
    NSString* pstrFilePath = self.SelFilePath;
    NSString* pstrFileName = self.SelFileName;
//    NSString* pstrFolderName = [NSString stringWithFormat:@"DIR-%@",pstrFileName];
    // フォルダ名にDIR-はなくなっている
    NSString* pstrFolderName = pstrFileName;
    NSString* pstrNewFileName = m_ptxtfileName.text;
    if( !isDirectory)
    {
        pstrNewFileName = [NSString stringWithFormat:@"%@.%@",m_ptxtfileName.text,[pstrFileName pathExtension]];
    }
//    NSString* pstrNewFolderName = [NSString stringWithFormat:@"DIR-%@",pstrNewFileName];
    // フォルダ名にDIR-はなくなっている
    NSString* pstrNewFolderName = pstrNewFileName;


    // 空白チェック
    if (m_ptxtfileName.text == nil || [m_ptxtfileName.text isEqualToString:@""] || m_ptxtfileName.text.length == 0)
    {
        return FILE_ERR_NO_INPUT;
    }
    
    // ファイル名変更チェック
    if ([pstrFileName isEqualToString:pstrNewFileName])
    {
        // ファイル名が同じ場合は何もしない
        return FILE_ERR_SUCCESS;
    }
    
    // 文字数チェック
    if ([CommonUtil IsFileName:pstrNewFileName] != ERR_SUCCESS)
    {
        return FILE_ERR_OVER_NUM_RANGE;
    }
    
    // 使用不可文字チェック
    if ([CommonUtil fileNameCheck:pstrNewFileName])
    {
        return FILE_ERR_INVALID_CHAR_TYPE;
    }
    
    // 絵文字チェック
    if ( [CommonUtil IsUsedEmoji: pstrNewFileName] ) {
        return FILE_ERR_INVALID_CHAR_TYPE;
    }
    
    // 予約語チェック
    NSString *targetPath = [self.SelFilePath stringByAppendingPathComponent:pstrNewFolderName];
    if ([CommonUtil IsReserved:targetPath]) {
        return FILE_ERR_RESERVED_WORD;
    }
    
    // 同じ名称ファイルの存在チェック
    ScanDataManager* pScanDataManager = [[ScanDataManager alloc] init];
    pScanDataManager.fullPath = pstrFilePath;
    [pScanDataManager reGetScanData];
    if(self.isDirectory)
    {
        if([pScanDataManager checkFolderData:pstrNewFolderName] == NO)
        {
            return FILE_ERR_EXISTS_SAME;
        }
    }
    else
    {
        if([pScanDataManager checkFolderData:pstrNewFileName] == NO)
        {
            return FILE_ERR_EXISTS_SAME;
        }
    }    
    
    // ファイル名の変更処理
    NSString* pstrCurrentFilePath;      //変更前ファイル名(フルパス)
    BOOL bRet = NO;
    
    if(self.isDirectory)
    {
        // フォルダ
        pstrCurrentFilePath = [pstrFilePath stringByAppendingPathComponent:pstrFolderName];
        ScanDirectory *srcScanDirectory = [[ScanDirectory alloc] initWithScanDirectoryPath:pstrCurrentFilePath];
        bRet = [ScanDirectoryUtility rename:srcScanDirectory DirectoryName:pstrNewFolderName];
    }
    else
    {
        // ファイル
        pstrCurrentFilePath = [pstrFilePath stringByAppendingPathComponent:pstrFileName];
        ScanFile *srcScanFile = [[ScanFile alloc] initWithScanFilePath:pstrCurrentFilePath];
        bRet = [ScanFileUtility rename:srcScanFile FileName:pstrNewFileName];
    }
    
    if (bRet) {
        return FILE_ERR_SUCCESS;
    }
    
    return FILE_ERR_FAILED;
}


// キーボードReturnキー押下イベント
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [m_ptxtfileName resignFirstResponder];
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

// アラート表示
- (UIAlertController*) makeUIAlertController:(NSString*)pstrTitle
                       message:(NSString*)pstrMsg
                cancelBtnTitle:(NSString*)cancelBtnTitle
                    okBtnTitle:(NSString*)okBtnTitle
                       showFlg:(BOOL)showFlg
{
    UIAlertController *tmpAlert = [UIAlertController alertControllerWithTitle:pstrTitle
                                                                      message:pstrMsg
                                                               preferredStyle:UIAlertControllerStyleAlert];
    // Cancel用のアクションを生成
    if (cancelBtnTitle != nil) {
        UIAlertAction *cancelAction =
        [UIAlertAction actionWithTitle:cancelBtnTitle
                                 style:UIAlertActionStyleCancel
                               handler:^(UIAlertAction * action) {
                                   
                                   // ボタンタップ時の処理
                                   [self alertButtonPushed:tmpAlert buttonIndex:0];
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
                                   [self alertButtonPushed:tmpAlert buttonIndex:okIndex];
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

// アラートボタン押下処理
-(void)alertButtonPushed:(UIAlertController *)alertController buttonIndex:(NSInteger)buttonIndex
{
    SharpScanPrintAppDelegate* appDelegate = (SharpScanPrintAppDelegate*)[[UIApplication sharedApplication] delegate];
    // 処理実行フラグOFF
    appDelegate.IsRun = FALSE;
}

- (void)hideErrorMessage
{
    if (errorMessageView) {
        [errorMessageView dismissViewControllerAnimated:YES completion:nil];
    }
}
@end
