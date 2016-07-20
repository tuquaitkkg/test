
#import "RenameScanAfterDataViewController.h"
#import "SharpScanPrintAppDelegate.h"
#import "Define.h"
#import "SaveScanAfterDataViewController.h"
#import "ScanAfterPictViewController.h"

@interface RenameScanAfterDataViewController ()

@end

@implementation RenameScanAfterDataViewController
@synthesize isMulti;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    // タイトルを上書き
    UILabel* lblTitle = (UILabel*)self.navigationItem.titleView;
    lblTitle.text = S_TITLE_RENAME_FILENAME;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#define RENAMESCANAFTERDATA_EXTENSION_LABEL_TAG 10000
- (void)viewWillAppear:(BOOL)animated
{
    
    if( self.isDirectory)
    {
        m_fileName.text = S_TITLE_FOLDER_NAME;
        // ファイル名
        m_ptxtfileName.text = self.SelFileName;
    }
    else
    {
        UILabel* lblExtension = (UILabel*)[self.view viewWithTag:RENAMESCANAFTERDATA_EXTENSION_LABEL_TAG];
        if(!lblExtension){
            // 拡張子ラベルが存在しないので初期化処理

            m_fileName.text = S_TITLE_FILE_NAME;
            
            // テキストボックスのサイズの取得
            float x = m_ptxtfileName.frame.origin.x;
            float y = m_ptxtfileName.frame.origin.y;
            float w = m_ptxtfileName.frame.size.width;
            float h = m_ptxtfileName.frame.size.height;
            
            // 横幅サイズ変更
            if(isMulti)
            {
                m_ptxtfileName.frame = CGRectMake(x, y, w-60, h);
            
                // 拡張子ラベルの設定
                CGRect frame = CGRectMake(w-40, y, 80, h);
                lblExtension = [[UILabel alloc]initWithFrame:frame];
                lblExtension.backgroundColor = [UIColor clearColor];
                lblExtension.textColor = [UIColor blackColor];
                // iPadのみ文字サイズを大きくする
                if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
                {
                    lblExtension.font = [UIFont systemFontOfSize:14];
                }else
                {
                    lblExtension.font = [UIFont systemFontOfSize:12];
                }
                lblExtension.textAlignment = NSTextAlignmentLeft;
                NSString* prefix = [CommonUtil isSerialNoLengthIsFour:[self.SelFileName stringByDeletingPathExtension]] ? @"_xxxx.%@" : @"_xxx.%@";
                lblExtension.text = [NSString stringWithFormat:prefix,[self.SelFileName pathExtension]];
                lblExtension.tag = RENAMESCANAFTERDATA_EXTENSION_LABEL_TAG;
                [self.view addSubview:lblExtension];
            }
            else
            {
                m_ptxtfileName.frame = CGRectMake(x, y, w-30, h);
                
                // 拡張子ラベルの設定
                CGRect frame = CGRectMake(w-10, y, 50, h);
                lblExtension = [[UILabel alloc]initWithFrame:frame];
                lblExtension.backgroundColor = [UIColor clearColor];
                lblExtension.textColor = [UIColor blackColor];
                // iPadのみ文字サイズを大きくする
                if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
                {
                    lblExtension.font = [UIFont systemFontOfSize:14];
                }else
                {
                    lblExtension.font = [UIFont systemFontOfSize:12];
                }
                lblExtension.textAlignment = NSTextAlignmentLeft;
                lblExtension.text = [NSString stringWithFormat:@".%@",[self.SelFileName pathExtension]];
                lblExtension.tag = RENAMESCANAFTERDATA_EXTENSION_LABEL_TAG;
                [self.view addSubview:lblExtension];

            }
            // ファイル名
            m_ptxtfileName.text = [self.SelFileName stringByDeletingPathExtension];
            
            if(isMulti)
            {
                if([CommonUtil isSerialNoLengthIsFour:[self.SelFileName stringByDeletingPathExtension]]) {
                    // 連番部分が4桁
                    m_ptxtfileName.text = [m_ptxtfileName.text substringWithRange:NSMakeRange(0,[m_ptxtfileName.text length] - 5)];
                } else {
                    // 連番部分が3桁
                    m_ptxtfileName.text = [m_ptxtfileName.text substringWithRange:NSMakeRange(0,[m_ptxtfileName.text length] - 4)];
                }
            
            }
        }
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
        UITableView *tableView = [[UITableView alloc] initWithFrame:[[UIScreen mainScreen] bounds] style:UITableViewStyleGrouped];
        [self.view addSubview:tableView];
        [self.view sendSubviewToBack:tableView];
    }
    
    // キーボード表示
    [m_ptxtfileName becomeFirstResponder];
}

// ナビゲーションバー 保存ボタン押下
- (IBAction)OnNavBarRightButton:(id)sender
{
	// 入力チェック（リネームはしない）
    NSInteger iErrCode = [self CheckNewFileName];
    
    if (iErrCode == FILE_ERR_SUCCESS)
    {
        // 画面遷移
        SaveScanAfterDataViewController* pSaveScanAfterDataViewController;
        pSaveScanAfterDataViewController = [[SaveScanAfterDataViewController alloc] init];
        pSaveScanAfterDataViewController.bScanAfter = YES;
        pSaveScanAfterDataViewController.tempFile = self.tempFile;
        pSaveScanAfterDataViewController.renamedName = [NSString stringWithFormat:@"%@.%@", m_ptxtfileName.text, [self.SelFileName pathExtension]];
        NSUserDefaults * savePath = [NSUserDefaults standardUserDefaults];
        NSString *path = [savePath stringForKey:S_KEY_SAVE_PATH];
        BOOL anime = NO;
        
        // 前回保存した階層がルートではなくサブフォルダ以降の場合
        if ( path && ! [path isEqualToString: @""] ) {
            anime = NO;
        }
        // 前回保存した階層がルートの場合
        else {
            anime = YES;
        }
        
        [self.navigationController pushViewController:pSaveScanAfterDataViewController animated:anime];
        

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
                
                // 文字種チェック
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

                // 失敗
            case FILE_ERR_FAILED:
                if(self.isDirectory)
                {
                    pstrErrMessage = [NSString stringWithFormat:MSG_CHANGE_FAILED, SUBMSG_FOLDERNAME_ERR];
                }
                else
                {
                    pstrErrMessage = [NSString stringWithFormat:MSG_CHANGE_FAILED, SUBMSG_FILENAME_ERR];                }
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


// ファイル名をチェック
- (NSInteger)CheckNewFileName
{
    if (self.SelFileName == nil)
    {
        // エラー
        return FILE_ERR_FAILED;
    }
    
    NSString* pstrNewFileName = [NSString stringWithFormat:@"%@.%@",m_ptxtfileName.text,[self.SelFileName pathExtension]];

    // 空白チェック
    if (m_ptxtfileName.text == nil || [m_ptxtfileName.text isEqualToString:@""] || m_ptxtfileName.text.length == 0)
    {
        return FILE_ERR_NO_INPUT;
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
    NSString *targetPath = [self.SelFilePath stringByAppendingPathComponent:pstrNewFileName];
    if ([CommonUtil IsReserved:targetPath]) {
        return FILE_ERR_RESERVED_WORD;
    }
    
    return FILE_ERR_SUCCESS;
}

// キャンセルし画面を閉じる
- (void)cancelAction
{
    // iPad用
    if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
    {
        [super cancelAction];
    }
    else
    {
        // Modal表示のため、呼び出し元で閉じる処理を行う
        SharpScanPrintAppDelegate* appDelegate = (SharpScanPrintAppDelegate*)[[UIApplication sharedApplication] delegate];
        ScanAfterPictViewController* pArrengeSelectFileViewController = (ScanAfterPictViewController*)appDelegate.navigationController.topViewController;
        
        [pArrengeSelectFileViewController OnCancel];
    }
    
}

// 処理実行フラグをOFFにする
- (void)appDelegateIsRunOff {
    // ボタンタップ時の処理
    SharpScanPrintAppDelegate* appDelegate = (SharpScanPrintAppDelegate*)[[UIApplication sharedApplication] delegate];
    // 処理実行フラグOFF
    appDelegate.IsRun = FALSE;
}

@end
