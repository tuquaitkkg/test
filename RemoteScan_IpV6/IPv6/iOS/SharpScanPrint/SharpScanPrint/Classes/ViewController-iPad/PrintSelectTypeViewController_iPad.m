
#import "PrintSelectTypeViewController_iPad.h"
#import "SettingSelDeviceViewController_iPad.h"
#import "SettingUserInfoViewController_iPad.h"
#import "SettingApplicationViewController_iPad.h"
#import "Define.h"
// iPad用
#import "RootViewController_iPad.h"
#import "SharpScanPrintAppDelegate.h"
#import "WebPagePrintViewController_iPad.h"
// iPad用

#import "SelectFileViewController_iPad.h"
#import "SelectMailViewController_iPad.h"
#import "PrintPictViewController_iPad.h"

#import "SearchResultViewController_iPad.h"
#import "AdvancedSearchResultViewController_iPad.h"

#import "AttachmentMailViewController.h"

// 複数印刷対応_iPad
#import <AssetsLibrary/AssetsLibrary.h>
#import <ImageIO/ImageIO.h>
#import <MobileCoreServices/UTCoreTypes.h>

@interface PrintSelectTypeViewController_iPad ()

// 複数印刷対応_iPad
@property (nonatomic,strong) NSMutableArray *printFileArray;
@property (nonatomic,strong) NSMutableArray *printPictArray;

@end

@implementation PrintSelectTypeViewController_iPad
{
    /** printFileArray, printPictArrayをviewWillAppearでリセットしないフラグ iOS8対応*/
    BOOL _shouldNotResetArrays;
}

@synthesize selectIndexPath; // iPad用
@synthesize m_bVisibleMenuButton;

@synthesize subDir;
@synthesize rootDir;
@synthesize pstrSearchKeyword;                  // 検索文字
@synthesize bSubFolder;                         // 検索範囲(サブフォルダーを含む)
@synthesize bFillterFolder;                     // 検索対象(フォルダー)
@synthesize bFillterPdf;                        // 検索対象(PDF)
@synthesize bFillterTiff;                       // 検索対象(TIFF)
@synthesize bFillterImage;                      // 検索対象(JPEG,PNG)
@synthesize bFillterOffice;                     // 検索対象(OFFICE)
@synthesize bCanDelete;                         // 検索対象(削除)

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
    [super viewDidLoad];
    
    // セルのラインを表示する
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    
    // UINavigationBar 44px のずれを無くす
    self.navigationController.navigationBar.translucent = NO;
    self.navigationController.navigationBar.barStyle = NAVIGATION_BARSTYLE;
    
    // ナビゲーションバー
    // タイトル設定
    self.navigationItem.title = S_TITLE_PRINT;
    
    // 戻るボタンの名称変更
    UIBarButtonItem * barItemBack = [UIBarButtonItem new];
    barItemBack.title = S_BUTTON_BACK;
    self.navigationItem.backBarButtonItem = barItemBack;
    
    LOG(@"class :%@",[[self.navigationController.viewControllers objectAtIndex:0] class]);
    DLog(@"self:%@",self);
    
    // 複数印刷対応
    NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
    [nc addObserver:self selector:@selector(closeBtnPushed:) name:NK_CLOSE_BUTTON_PUSHED object:nil];
    [nc addObserver:self selector:@selector(enterBtnPushed:) name:NK_ENTER_BUTTON_PUSHED object:nil];
    [nc addObserver:self selector:@selector(enterBtnPushed2:) name:NK_ENTER_BUTTON_PUSHED2 object:nil];
    [nc addObserver:self selector:@selector(backBtnPushed:) name:NK_BACK_BUTTON_PUSHED object:nil];
    [nc addObserver:self selector:@selector(moveMultiPrintPictNotification:) name:NK_PICT_ENTER_BUTTON_PUSHED object:nil];
    [nc addObserver:self selector:@selector(editMultiPrintPictNotification:) name:NK_PICT_EDIT_ACTION object:nil];
    
    [nc addObserver:self selector:@selector(webPrintEnterBtnPushed1:) name:WP_ENTER_BUTTON_PUSHED1 object:nil];
    [nc addObserver:self selector:@selector(webPrintEnterBtnPushed2:) name:WP_ENTER_BUTTON_PUSHED2 object:nil];
    
    [nc addObserver:self selector:@selector(mailPrintEnterBtnPushed1:) name:MP_ENTER_BUTTON_PUSHED1 object:nil];
    [nc addObserver:self selector:@selector(mailPrintEnterBtnPushed2:) name:MP_ENTER_BUTTON_PUSHED2 object:nil];
    [nc addObserver:self selector:@selector(attachmentSelect:) name:MP_ATTACHMENT_BUTTON_PUSHED1 object:nil];
    //    [nc addObserver:self selector:@selector(mailPrintEnterBtnPushed2:) name:MP_ATTACHMENT_BUTTON_PUSHED2 object:nil];
    [nc addObserver:self selector:@selector(showAttachmentBtnPushed:) name:MP_SHOW_ATTACHMENT_BUTTON_PUSHED object:nil];
    //    }
    
    self.printFileArray = [[NSMutableArray alloc]initWithCapacity:0];
    self.printPictArray = [[NSMutableArray alloc]initWithCapacity:0];
    
    nFolderCount = 1;
}

// 複数印刷対応
- (void)closeBtnPushed:(NSNotification *)n {
    [self dismissViewControllerAnimated:YES completion:nil];
}

// 複数印刷対応
- (void)enterBtnPushed:(NSNotification *)n {
    
    SelectFileViewController_iPad *vc = (SelectFileViewController_iPad *)n.object;
    vc.PrevViewID = PV_PRINT_SELECT_FILE_CELL;
    DLog(@"vc.selectFilePathArray = %@",vc.selectFilePathArray);
    
    if (vc.selectFilePathArray.count > 0)
    {
        [self.printFileArray addObjectsFromArray:vc.selectFilePathArray];
    }
    DLog(@"self.printFileArray = %@, count = %lu",self.printFileArray,(unsigned long)self.printFileArray.count);
    [self dismissViewControllerAnimated:YES completion:nil];
    
    SharpScanPrintAppDelegate* pAppDelegate = (SharpScanPrintAppDelegate*)[[UIApplication sharedApplication] delegate];
    
    UINavigationController *pRootNavController = [pAppDelegate.splitViewController.viewControllers objectAtIndex:0];
    if ([pRootNavController.viewControllers.lastObject isKindOfClass:[MultiPrintTableViewController_iPad class]]) {
        MultiPrintTableViewController_iPad *tVC = (MultiPrintTableViewController_iPad *)pRootNavController.viewControllers.lastObject;
        tVC.PrintPictViewID = PPV_PRINT_SELECT_FILE_CELL;
        tVC.selectFileArray = [self.printFileArray mutableCopy];
        tVC.delegate = self;
        [tVC.tableView reloadData];
        [tVC.tableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] animated:NO scrollPosition:UITableViewRowAnimationTop];
    } else {
        MultiPrintTableViewController_iPad *tVC = [[MultiPrintTableViewController_iPad alloc]initWithStyle:UITableViewStylePlain];
        tVC.PrintPictViewID = PPV_PRINT_SELECT_FILE_CELL;
        tVC.selectFileArray = self.printFileArray;
        tVC.delegate = self;
        [pRootNavController popToRootViewControllerAnimated:NO];
        [pRootNavController pushViewController:tVC animated:NO];
    }
    
    UINavigationController *rRootNavController = [pAppDelegate.splitViewController.viewControllers objectAtIndex:1];
    if ([rRootNavController.viewControllers.lastObject isKindOfClass:[MultiPrintPictViewController_iPad class]])
    {//右側がプレビュー画面のとき
        MultiPrintPictViewController_iPad *beforeVC = (MultiPrintPictViewController_iPad *)rRootNavController.viewControllers.lastObject;
        
        DLog(@"initRetentionFlg = %d",beforeVC.initRetentionFlg);
        DLog(@"m_nSelPickerRow1 = %ld",(long)beforeVC.m_nSelPickerRow1);
        DLog(@"m_nSelPickerRow2 = %ld",(long)beforeVC.m_nSelPickerRow2);
        DLog(@"m_nSelPickerRow3 = %ld",(long)beforeVC.m_nSelPickerRow3);
        DLog(@"m_nSelPickerRow4 = %ld",(long)beforeVC.m_nSelPickerRow4);
        DLog(@"m_nSelPickerRow5 = %ld",(long)beforeVC.m_nSelPickerRow5);
        DLog(@"m_nSelPickerRow6 = %ld",(long)beforeVC.m_nSelPickerRow6);
        DLog(@"m_nSelPickerRow7 = %ld",(long)beforeVC.m_nSelPickerRow7);
        DLog(@"m_nSelPickerRow8 = %ld",(long)beforeVC.m_nSelPickerRow8);
        DLog(@"m_pstrColorMode = %@",beforeVC.m_pstrColorMode);
        DLog(@"m_pstrNumSets = %@",beforeVC.m_pstrNumSets);
        DLog(@"m_pstrPaperSize = %@",beforeVC.m_pstrPaperSize);
        DLog(@"m_pstrPaperSizePJL = %@",beforeVC.m_pstrPaperSizePJL);
        DLog(@"m_pstrPaperType = %@",beforeVC.m_pstrPaperType);
        DLog(@"m_pstrPaperTypePJL = %@",beforeVC.m_pstrPaperTypePJL);
        DLog(@"m_pstrPrintRange = %@",beforeVC.m_pstrPrintRange);
        DLog(@"m_pstrRetention = %@",beforeVC.m_pstrRetention);
        DLog(@"m_pstrSide = %@",beforeVC.m_pstrSide);
        DLog(@"nNUpRow = %ld",(long)beforeVC.nNupRow);
        DLog(@"nSeqRow = %ld",(long)beforeVC.nSeqRow);
        DLog(@"pstrSelectedNUp = %@",beforeVC.pstrSelectedNUp);
        DLog(@"pstrSelectedSeq = %@",beforeVC.pstrSelectedSeq);
        DLog(@"noPrintOn = %d",beforeVC.noPrintOn);
        DLog(@"authenticateOn = %d",beforeVC.authenticateOn);
        DLog(@"pstrPassword = %@",beforeVC.pstrPassword);
        
        MultiPrintPictViewController_iPad *pVC = [[MultiPrintPictViewController_iPad alloc]init];
        pVC.PrintPictViewID = PPV_PRINT_SELECT_FILE_CELL;
        ScanData *scanData = [self.printFileArray firstObject];
        DLog(@"fullPath = %@%@",scanData.fpath,scanData.fname);
        DLog(@"imagePath = %@",scanData.imagename);
        pVC.SelFilePath = [NSString stringWithFormat:@"%@%@",scanData.fpath,scanData.fname];
        pVC.selectFileArray = self.printFileArray;
        pVC.isAddedPattern = YES;
        pVC.delegate = self;
        // 単数扱いではなくなるため、updateMenuAndDataArrayの前で強制的にYESにする。
        pVC.wasMultiDataPattern = YES;
        
        [pVC updateMenuAndDataArray];
        
        pVC.initRetentionFlg = beforeVC.initRetentionFlg;
        pVC.m_nSelPickerRow1 = beforeVC.m_nSelPickerRow1;
        pVC.m_nSelPickerRow2 = beforeVC.m_nSelPickerRow2;
        pVC.m_nSelPickerRow3 = beforeVC.m_nSelPickerRow3;
        pVC.m_nSelPickerRow4 = beforeVC.m_nSelPickerRow4;
        pVC.m_nSelPickerRow5 = beforeVC.m_nSelPickerRow5;
        pVC.m_nSelPickerRow6 = beforeVC.m_nSelPickerRow6;
        pVC.m_nSelPickerRow7 = beforeVC.m_nSelPickerRow7;
        pVC.m_nSelPickerRow8 = beforeVC.m_nSelPickerRow8;
        pVC.m_pstrColorMode = beforeVC.m_pstrColorMode;
        pVC.m_pstrNumSets = beforeVC.m_pstrNumSets;
        pVC.m_pstrPaperSize = beforeVC.m_pstrPaperSize;
        pVC.m_pstrPaperSizePJL = beforeVC.m_pstrPaperSizePJL;
        pVC.m_pstrPaperType = beforeVC.m_pstrPaperType;
        pVC.m_pstrPaperTypePJL = beforeVC.m_pstrPaperTypePJL;
        pVC.m_pstrPrintRange = beforeVC.m_pstrPrintRange;
        pVC.m_pstrRetention = beforeVC.m_pstrRetention;
        pVC.m_pstrSide = beforeVC.m_pstrSide;
        pVC.isInvalidDuplexSize = beforeVC.isInvalidDuplexSize;
        pVC.isInvalidDuplexType = beforeVC.isInvalidDuplexType;
        pVC.isInvalidStaplePaperSize = beforeVC.isInvalidStaplePaperSize;
        pVC.isInvalidStaplePaperType = beforeVC.isInvalidStaplePaperType;
        pVC.isDuplexPrint = beforeVC.isDuplexPrint;
        pVC.selectedPrinterPrimaryKey = beforeVC.selectedPrinterPrimaryKey;
        
        if (pVC.isSingleData) {
            if (pVC.hasN_UpData) {
                pVC.nNupRow = beforeVC.nNupRow;
                pVC.nSeqRow = beforeVC.nSeqRow;
                pVC.pstrSelectedNUp = beforeVC.pstrSelectedNUp;
                pVC.pstrSelectedSeq = beforeVC.pstrSelectedSeq;
            }
            if (pVC.hasEncryptionPdfData == NO) {
                pVC.noPrintOn = beforeVC.noPrintOn;
                pVC.authenticateOn = beforeVC.authenticateOn;
                pVC.pstrPassword = beforeVC.pstrPassword;
            }
        } else {
            pVC.nNupRow = beforeVC.nNupRow;
            pVC.nSeqRow = beforeVC.nSeqRow;
            pVC.pstrSelectedNUp = beforeVC.pstrSelectedNUp;
            pVC.pstrSelectedSeq = beforeVC.pstrSelectedSeq;
            
            pVC.noPrintOn = beforeVC.noPrintOn;
            pVC.authenticateOn = beforeVC.authenticateOn;
            pVC.pstrPassword = beforeVC.pstrPassword;
        }
        pVC.printReleaseOn = beforeVC.printReleaseOn;
        pVC.canPrintRelease =beforeVC.canPrintRelease;
        pVC.nClosingRow = beforeVC.nClosingRow;
        pVC.nStapleRow = beforeVC.nStapleRow;
        pVC.nPunchRow = beforeVC.nPunchRow;
        pVC.pstrSelectedClosing = beforeVC.pstrSelectedClosing;
        pVC.pstrSelectedStaple = beforeVC.pstrSelectedStaple;
        pVC.pstrSelectedPunch = beforeVC.pstrSelectedPunch;
        pVC.staple = beforeVC.staple;
        pVC.punchData = beforeVC.punchData;
        
        
        if([[[UIDevice currentDevice]systemVersion]floatValue]>=8)_shouldNotResetArrays = YES;
        [self.navigationController popToRootViewControllerAnimated:NO];
        [self.navigationController pushViewController:pVC animated:NO];
    }
    else
    {//右側がプレビュー画面ではないとき
        MultiPrintPictViewController_iPad *pVC = [[MultiPrintPictViewController_iPad alloc]init];
        pVC.PrintPictViewID = PPV_PRINT_SELECT_FILE_CELL;
        
        pVC.delegate = self;
        
        ScanData *scanData = [self.printFileArray firstObject];
        DLog(@"fullPath = %@%@",scanData.fpath,scanData.fname);
        DLog(@"imagePath = %@",scanData.imagename);
        pVC.SelFilePath = [NSString stringWithFormat:@"%@%@",scanData.fpath,scanData.fname];
        pVC.selectFileArray = self.printFileArray;
        [pVC updateMenuAndDataArray];
        [self.navigationController popToRootViewControllerAnimated:NO];
        [self.navigationController pushViewController:pVC animated:NO];
    }
}

/**
 * 複数印刷対応 メール添付ファイル
 * 画像が選択されたとき(AttachmentMailViewController等で画像ファイルが選択されたときのnotificationHandler
 */
- (void)enterBtnPushed2:(NSNotification *)n
{
    LOG(@"self:%@",self);
    AttachmentMailViewController_iPad *vc = (AttachmentMailViewController_iPad *)n.object;
    //        vc.PrevViewID = PV_PRINT_SELECT_FILE_CELL;
    DLog(@"vc.selectFilePathArray = %@",vc.selectFilePathArray);
    
    if (vc.selectFilePathArray.count > 0)
    {
        [self.printFileArray addObjectsFromArray:vc.selectFilePathArray];
    }
    DLog(@"self.printFileArray = %@, count = %lu",self.printFileArray,(unsigned long)self.printFileArray.count);
    [self dismissViewControllerAnimated:YES completion:nil];
    
    SharpScanPrintAppDelegate* pAppDelegate = (SharpScanPrintAppDelegate*)[[UIApplication sharedApplication] delegate];
    
    UINavigationController *pRootNavController = [pAppDelegate.splitViewController.viewControllers objectAtIndex:0];
    
    if ([pRootNavController.viewControllers.lastObject isKindOfClass:[MultiPrintTableViewController_iPad class]])
    {//splitViewCの左側がMultiPrintTableViewController_iPadのとき
        MultiPrintTableViewController_iPad *tVC = (MultiPrintTableViewController_iPad *)pRootNavController.viewControllers.lastObject;
        tVC.PrintPictViewID = PPV_PRINT_MAIL_ATTACHMENT_CELL;
        
        //iOSS8では、390行のpopToRootViewControllerメソッドにより本クラスのviewWillAppearが呼ばれ、self.printFileArrayが空にされるので、mutableCopyして渡す。他バージョンでも問題ないことを確認済み。
        tVC.selectFileArray = [self.printFileArray mutableCopy];
        
        
        tVC.delegate = self;
        [tVC.tableView reloadData];//更新
        [tVC.tableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] animated:NO scrollPosition:UITableViewRowAnimationTop];
    }
    else
    {//そうでないとき
        //MultiPrintTableViewController_iPad生成
        MultiPrintTableViewController_iPad *tVC = [[MultiPrintTableViewController_iPad alloc]initWithStyle:UITableViewStylePlain];
        tVC.PrintPictViewID = PPV_PRINT_MAIL_ATTACHMENT_CELL;
        
        //iOSS8では、390行のpopToRootViewControllerメソッドにより本クラスのviewWillAppearが呼ばれ、self.printFileArrayが空にされるので、mutableCopyして渡す。他バージョンでも問題ないことを確認済み。
        tVC.selectFileArray = [self.printFileArray mutableCopy];
        
        tVC.delegate = self;
        [pRootNavController popToRootViewControllerAnimated:NO];
        [pRootNavController pushViewController:tVC animated:NO];//MultiPrintTableViewControllerをpush
    }
    
    //右側のrootVC
    UINavigationController *rRootNavController = [pAppDelegate.splitViewController.viewControllers objectAtIndex:1];
    
    if ([rRootNavController.viewControllers.lastObject isKindOfClass:[MultiPrintPictViewController_iPad class]])
    {//右側が複数画像プレビュー画面のとき
        MultiPrintPictViewController_iPad *beforeVC = (MultiPrintPictViewController_iPad *)rRootNavController.viewControllers.lastObject;
        
        DLog(@"initRetentionFlg = %d",beforeVC.initRetentionFlg);
        DLog(@"m_nSelPickerRow1 = %ld",(long)beforeVC.m_nSelPickerRow1);
        DLog(@"m_nSelPickerRow2 = %ld",(long)beforeVC.m_nSelPickerRow2);
        DLog(@"m_nSelPickerRow3 = %ld",(long)beforeVC.m_nSelPickerRow3);
        DLog(@"m_nSelPickerRow4 = %ld",(long)beforeVC.m_nSelPickerRow4);
        DLog(@"m_nSelPickerRow5 = %ld",(long)beforeVC.m_nSelPickerRow5);
        DLog(@"m_nSelPickerRow6 = %ld",(long)beforeVC.m_nSelPickerRow6);
        DLog(@"m_nSelPickerRow7 = %ld",(long)beforeVC.m_nSelPickerRow7);
        DLog(@"m_nSelPickerRow8 = %ld",(long)beforeVC.m_nSelPickerRow8);
        DLog(@"m_pstrColorMode = %@",beforeVC.m_pstrColorMode);
        DLog(@"m_pstrNumSets = %@",beforeVC.m_pstrNumSets);
        DLog(@"m_pstrPaperSize = %@",beforeVC.m_pstrPaperSize);
        DLog(@"m_pstrPaperSizePJL = %@",beforeVC.m_pstrPaperSizePJL);
        DLog(@"m_pstrPaperType = %@",beforeVC.m_pstrPaperType);
        DLog(@"m_pstrPaperTypePJL = %@",beforeVC.m_pstrPaperTypePJL);
        DLog(@"m_pstrPrintRange = %@",beforeVC.m_pstrPrintRange);
        DLog(@"m_pstrRetention = %@",beforeVC.m_pstrRetention);
        DLog(@"m_pstrSide = %@",beforeVC.m_pstrSide);
        DLog(@"nNUpRow = %ld",(long)beforeVC.nNupRow);
        DLog(@"nSeqRow = %ld",(long)beforeVC.nSeqRow);
        DLog(@"pstrSelectedNUp = %@",beforeVC.pstrSelectedNUp);
        DLog(@"pstrSelectedSeq = %@",beforeVC.pstrSelectedSeq);
        DLog(@"noPrintOn = %d",beforeVC.noPrintOn);
        DLog(@"authenticateOn = %d",beforeVC.authenticateOn);
        DLog(@"pstrPassword = %@",beforeVC.pstrPassword);
        
        MultiPrintPictViewController_iPad *pVC = [[MultiPrintPictViewController_iPad alloc]init];
        pVC.PrintPictViewID = PPV_PRINT_MAIL_ATTACHMENT_CELL;
        ScanData *scanData = [self.printFileArray firstObject];
        DLog(@"fullPath = %@%@",scanData.fpath,scanData.fname);
        DLog(@"imagePath = %@",scanData.imagename);
        pVC.SelFilePath = [NSString stringWithFormat:@"%@%@",scanData.fpath,scanData.fname];
        pVC.selectFileArray = self.printFileArray;
        pVC.isAddedPattern = YES;
        pVC.delegate = self;
        // 単数扱いではなくなるため、updateMenuAndDataArrayの前で強制的にYESにする。
        pVC.wasMultiDataPattern = YES;
        [pVC updateMenuAndDataArray];
        
        pVC.initRetentionFlg = beforeVC.initRetentionFlg;
        pVC.m_nSelPickerRow1 = beforeVC.m_nSelPickerRow1;
        pVC.m_nSelPickerRow2 = beforeVC.m_nSelPickerRow2;
        pVC.m_nSelPickerRow3 = beforeVC.m_nSelPickerRow3;
        pVC.m_nSelPickerRow4 = beforeVC.m_nSelPickerRow4;
        pVC.m_nSelPickerRow5 = beforeVC.m_nSelPickerRow5;
        pVC.m_nSelPickerRow6 = beforeVC.m_nSelPickerRow6;
        pVC.m_nSelPickerRow7 = beforeVC.m_nSelPickerRow7;
        pVC.m_nSelPickerRow8 = beforeVC.m_nSelPickerRow8;
        pVC.m_pstrColorMode = beforeVC.m_pstrColorMode;
        pVC.m_pstrNumSets = beforeVC.m_pstrNumSets;
        pVC.m_pstrPaperSize = beforeVC.m_pstrPaperSize;
        pVC.m_pstrPaperSizePJL = beforeVC.m_pstrPaperSizePJL;
        pVC.m_pstrPaperType = beforeVC.m_pstrPaperType;
        pVC.m_pstrPaperTypePJL = beforeVC.m_pstrPaperTypePJL;
        pVC.m_pstrPrintRange = beforeVC.m_pstrPrintRange;
        pVC.m_pstrRetention = beforeVC.m_pstrRetention;
        pVC.m_pstrSide = beforeVC.m_pstrSide;
        pVC.isInvalidDuplexSize = beforeVC.isInvalidDuplexSize;
        pVC.isInvalidDuplexType = beforeVC.isInvalidDuplexType;
        pVC.isInvalidStaplePaperSize = beforeVC.isInvalidStaplePaperSize;
        pVC.isInvalidStaplePaperType = beforeVC.isInvalidStaplePaperType;
        pVC.isDuplexPrint = beforeVC.isDuplexPrint;
        pVC.selectedPrinterPrimaryKey = beforeVC.selectedPrinterPrimaryKey;
        
        if (pVC.isSingleData) {
            if (pVC.hasN_UpData) {
                pVC.nNupRow = beforeVC.nNupRow;
                pVC.nSeqRow = beforeVC.nSeqRow;
                pVC.pstrSelectedNUp = beforeVC.pstrSelectedNUp;
                pVC.pstrSelectedSeq = beforeVC.pstrSelectedSeq;
            }
            if (pVC.hasEncryptionPdfData == NO) {
                pVC.noPrintOn = beforeVC.noPrintOn;
                pVC.authenticateOn = beforeVC.authenticateOn;
                pVC.pstrPassword = beforeVC.pstrPassword;
            }
        } else {
            pVC.nNupRow = beforeVC.nNupRow;
            pVC.nSeqRow = beforeVC.nSeqRow;
            pVC.pstrSelectedNUp = beforeVC.pstrSelectedNUp;
            pVC.pstrSelectedSeq = beforeVC.pstrSelectedSeq;
            
            pVC.noPrintOn = beforeVC.noPrintOn;
            pVC.authenticateOn = beforeVC.authenticateOn;
            pVC.pstrPassword = beforeVC.pstrPassword;
        }
        pVC.printReleaseOn = beforeVC.printReleaseOn;
        pVC.canPrintRelease =beforeVC.canPrintRelease;
        pVC.nClosingRow = beforeVC.nClosingRow;
        pVC.nStapleRow = beforeVC.nStapleRow;
        pVC.nPunchRow = beforeVC.nPunchRow;
        pVC.pstrSelectedClosing = beforeVC.pstrSelectedClosing;
        pVC.pstrSelectedStaple = beforeVC.pstrSelectedStaple;
        pVC.pstrSelectedPunch = beforeVC.pstrSelectedPunch;
        pVC.staple = beforeVC.staple;
        pVC.punchData = beforeVC.punchData;
        
        if([[[UIDevice currentDevice]systemVersion]floatValue]>=8)_shouldNotResetArrays = YES;
        [rRootNavController popToRootViewControllerAnimated:NO];
        [rRootNavController pushViewController:pVC animated:NO];
    }
    else
    {//右側が複数画像プレビュー画面ではないとき
        //複数画像プレビュー画面生成
        MultiPrintPictViewController_iPad *pVC = [[MultiPrintPictViewController_iPad alloc]init];
        pVC.PrintPictViewID = PPV_PRINT_MAIL_ATTACHMENT_CELL;
        pVC.delegate = self;
        ScanData *scanData = [self.printFileArray firstObject];
        DLog(@"fullPath = %@%@",scanData.fpath,scanData.fname);
        DLog(@"imagePath = %@",scanData.imagename);
        pVC.SelFilePath = [NSString stringWithFormat:@"%@%@",scanData.fpath,scanData.fname];
        pVC.selectFileArray = [self.printFileArray mutableCopy];
        [pVC updateMenuAndDataArray];//メニューとデータのアップデート
        //        [self.navigationController popToRootViewControllerAnimated:NO];
        //        [self.navigationController pushViewController:pVC animated:NO];
        [rRootNavController popToRootViewControllerAnimated:NO];//一旦ルートに戻す
        [rRootNavController pushViewController:pVC animated:NO];//pushする
    }
}

- (void)webPrintEnterBtnPushed1:(NSNotification *)n
{
    // プレビュー画面へ遷移
    PrintPictViewController_iPad *printPictViewController = [[PrintPictViewController_iPad alloc] init];
    
    printPictViewController.SelFilePath	= S_PRINT_DATA_FILENAME_FOR_PRINT_PDF;
    printPictViewController.PrintPictViewID = WEB_PRINT_VIEW;
    
    //フラグ
    if([[[UIDevice currentDevice]systemVersion]floatValue]<8)
    {
    }
    else
    {//iOS8
        printPictViewController.shouldNotShowWebPrint = YES;
    }
    
    // ここでモーダルを閉じておく
    [self dismissViewControllerAnimated:YES completion:nil];
    
    NSIndexPath* index = [NSIndexPath indexPathForRow:0 inSection:1];
    NSLog(@"%@", printPictViewController.view);// iOS7以降で強制的にviewDidLoadを呼ぶ為
    [self ChangeView:printPictViewController didSelectRowAtIndexPath:index];
}
- (void)webPrintEnterBtnPushed2:(NSNotification *)n
{
    WebPagePrintViewController_iPad *webPagePrintViewController = (WebPagePrintViewController_iPad *)n.object;
    
    NSArray *viewControllers = self.navigationController.viewControllers;
    LOG(@"%@",viewControllers);
    
    if ([[self.navigationController.viewControllers firstObject] isKindOfClass:[RootViewController_iPad class]]) {
        // 左のviewから呼ばれてる
        return;
    }
    PrintPictViewController_iPad *printPictViewController = (PrintPictViewController_iPad*)[self.navigationController.viewControllers lastObject];
    
    printPictViewController.SelFilePath = [[CommonUtil tmpDir] stringByAppendingPathComponent: S_PRINT_DATA_FILENAME_FOR_PRINT_PDF];
    webPagePrintViewController.delegate = printPictViewController;
    
    [webPagePrintViewController.delegate webPagePrint:webPagePrintViewController upLoadWebView:printPictViewController.SelFilePath];
    
}

- (void)mailPrintEnterBtnPushed1:(NSNotification *)n
{
    // プレビュー画面へ遷移
    PrintPictViewController_iPad *printPictViewController = [[PrintPictViewController_iPad alloc] init];
    
    printPictViewController.SelFilePath	= S_PRINT_DATA_FILENAME_FOR_PRINT_PDF;
    printPictViewController.PrintPictViewID = EMAIL_PRINT_VIEW;
    printPictViewController.delegate = self;
    
    if([[[UIDevice currentDevice]systemVersion]floatValue]<8)
    {
        
    }
    else
    {//iOS8はフラグで制御
        printPictViewController.shouldNotShowSelectMail = YES;
    }
    
    // ここでモーダルを閉じておく
    [self dismissViewControllerAnimated:YES completion:nil];

    NSIndexPath *index = [NSIndexPath indexPathForRow:1 inSection:1];
    [self ChangeView:printPictViewController didSelectRowAtIndexPath:index];
}

- (void)mailPrintEnterBtnPushed2:(NSNotification *)n
{
    ShowMailViewController_iPad *showMailViewController = (ShowMailViewController_iPad *)n.object;
    
    NSArray *viewControllers = self.navigationController.viewControllers;
    LOG(@"%@",viewControllers);
    if ([[self.navigationController.viewControllers firstObject] isKindOfClass:[RootViewController_iPad class]]) {
        // 左のviewから呼ばれてる
        return;
    }
    PrintPictViewController_iPad *printPictViewController = (PrintPictViewController_iPad*)[self.navigationController.viewControllers lastObject];
    
    printPictViewController.SelFilePath = [[CommonUtil tmpDir] stringByAppendingPathComponent: S_PRINT_DATA_FILENAME_FOR_PRINT_PDF];
    showMailViewController.delegate = printPictViewController;
    
    //    [showMailViewController.delegate webPagePrint:showMailViewController upLoadWebView:printPictViewController.SelFilePath];
    [showMailViewController.delegate mailPrint:showMailViewController upLoadMailView:printPictViewController.SelFilePath];
    
}

// 添付ファイルを選択
- (void)attachmentSelect:(NSNotification *)n
{
    // プレビュー画面へ遷移
    PrintPictViewController_iPad *printPictViewController = [[PrintPictViewController_iPad alloc] init];
    
    AttachmentMailViewController_iPad *attachmentMailViewController = (AttachmentMailViewController_iPad *)n.object;
    //    printPictViewController.SelFilePath = [[CommonUtil tmpDir] stringByAppendingPathComponent: S_SAVE_MAIL_FILENAME_FOR_PRINT_PDF];
    attachmentMailViewController.delegate = printPictViewController;
    
    // デリゲートメソッドの呼び出し(モーダルビューも閉じる)
    [attachmentMailViewController.delegate mailAttachmentPrint:self upLoadMailView:attachmentMailViewController.printFilePath];
    
}

/**
 * 添付ファイル印刷ボタンが押されたときのnotificationHandher
 */
- (void)showAttachmentBtnPushed:(NSNotification *)n
{
    
    ShowMailViewController_iPad *showMailViewController = (ShowMailViewController_iPad *)n.object;
    PrintPictViewController_iPad *printPictViewController = [[PrintPictViewController_iPad alloc] init];
    printPictViewController.delegate = self;
    
    // 遷移元画面から渡されたIDをもとに遷移先のViewControllerを決定する
    AttachmentMailViewController_iPad* pViewController = nil;
    
    pViewController = [[AttachmentMailViewController_iPad alloc] init];
    pViewController.delegate = printPictViewController;
    //        [self.navigationController pushViewController:pViewController animated:YES];
    
    // 添付ファイル一覧遷移フラグをオンにする
    showMailViewController.attachMove = YES;
    
    //*** 一旦、モーダルを閉じて、別モーダルで添付ファイル一覧を表示する
    if([pViewController.delegate respondsToSelector:@selector(mailPrint:showAttachmentMailView:)]){
        // デリゲートメソッドの呼び出し(モーダルビューも閉じる)
        [pViewController.delegate mailPrint:showMailViewController showAttachmentMailView:pViewController];
    }
    
}

- (void)updatePrintFileArray:(NSMutableArray *)editedFileArray {
    DLog(@"%@",editedFileArray);
    self.printFileArray = [NSMutableArray arrayWithArray:editedFileArray];
}

- (void)updatePrintPictArray:(NSMutableArray *)editedFileArray {
    DLog(@"%@",editedFileArray);
    self.printPictArray = [NSMutableArray arrayWithArray:editedFileArray];
}

// 複数印刷対応_iPad
- (void)backBtnPushed:(NSNotification *)n {
    [self.printFileArray removeAllObjects];
    [self.printPictArray removeAllObjects];
}

- (void)viewDidUnload
{
    // 複数印刷対応_iPad
    NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
    [nc removeObserver:self];
    
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

// iPad用
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    if(selectIndexPath != nil)
    {
        // 指定の行を選択状態
        [self.tableView selectRowAtIndexPath:selectIndexPath animated:NO scrollPosition:UITableViewScrollPositionNone];
    }
    
    // 縦表示の時はメニューボタンを表示
    SharpScanPrintAppDelegate* pAppDelegate = (SharpScanPrintAppDelegate*)[[UIApplication sharedApplication] delegate];
    [pAppDelegate setPortraitMenuButton];
    
    // iPad用
    // Headerの高さを指定
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0.0, 0.0, self.view.frame.size.width, 20.0)];
    self.tableView.tableHeaderView = headerView;
    // iPad用
    
}
// iPad用
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    
    // 横向きの場合
    if(interfaceOrientation == UIInterfaceOrientationLandscapeLeft || interfaceOrientation == UIInterfaceOrientationLandscapeRight)
    {
        // 縦向き表示時のメニューPopOverが表示されていたら閉じる
        [self dismissMenuPopOver:NO];
    }
    return YES;
}
// iPad用


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return N_NUM_SECTION_PRINT_SEL;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    if (section == 0)
    {
        return N_NUM_ROW_PRINT_SEL_SEC1_IPAD;
    }
    else if(section == 1)//add shiorin
    {
        return N_NUM_ROW_PRINT_SEL_SEC2;
    }
    else
    {
        return 0;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    cell.accessoryType = TABLE_CELL_ACCESSORY;
    
    cell.textLabel.font = [UIFont systemFontOfSize:16];
    
    // アイコン名
    NSMutableString* pstrIconName = [[NSMutableString alloc] initWithCapacity:100];
    
    // 表示項目の設定
    if(indexPath.section == 0)
    {
        switch (indexPath.row)
        {
            case 0:
                cell.textLabel.text = S_PRINT_SEL_FILE;
                [pstrIconName appendString:S_ICON_PRINT_SEL_FILE];
                cell.accessoryType = UITableViewCellAccessoryNone;
                break;
                // 複数印刷対応_iPad
            case 1:
                cell.textLabel.text = S_PRINT_SEL_PICTURE;
                [pstrIconName appendString:S_ICON_PRINT_SEL_PICTURE];
                cell.accessoryType = UITableViewCellAccessoryNone;
                break;
            default:
                break;
        }
    }
    else
    {
        switch (indexPath.row)
        {
            case 0:
                // ★TODO:他言語化
                cell.textLabel.text = S_PRINT_SEL_WEBPAGE;
                [pstrIconName appendString:S_ICON_PRINT_WEBPAGE];
                cell.accessoryType = UITableViewCellAccessoryNone;
                break;
            case 1:
                cell.textLabel.text = S_PRINT_SEL_EMAIL;//S_PRINT_SEL_PICTURE;
                [pstrIconName appendString:S_ICON_PRINT_EMAIL];
                cell.accessoryType = UITableViewCellAccessoryNone;
                break;
            default:
                break;
        }
    }
    
    // アイコン設定
    UIImage* pIconImage = [UIImage imageNamed: pstrIconName];
    cell.imageView.image = pIconImage;
    
    return cell;
}

// テーブルビューの縦幅設定
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.section == 0)
    {
        return N_HEIGHT_PRINT_SEL_SEC1;
    }
    else if(indexPath.section == 1)
    {
        return N_HEIGHT_PRINT_SEL_SEC2;
    }
    else
    {
        return 0;
    }
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if([[[UIDevice currentDevice]systemVersion]floatValue]>=8)
    {//iOS8以上
        if(!_shouldNotResetArrays)
        {
            DLog(@"%s, printFileArray, printPictArrayのリセット", __func__);
            [self.printFileArray removeAllObjects];
            [self.printPictArray removeAllObjects];
        }
        else
        {
            DLog(@"%s, リセットされてない！", __func__);
            _shouldNotResetArrays = NO;
        }
    }
    else
    {//iOS7以下
        DLog(@"%s, printFileArray, printPictArrayのリセット", __func__);
        [self.printFileArray removeAllObjects];
        [self.printPictArray removeAllObjects];
    }
    
    [self MoveView:indexPath];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

// iPad用
- (void)tableView:(UITableView *)tableView accessoryButtonTappedForRowWithIndexPath:(NSIndexPath *)indexPath
{
    [self MoveView:indexPath];
}
// iPad用
// 画面遷移
- (void)MoveView:(NSIndexPath *)nIndexPath
{
    
    [self.printFileArray removeAllObjects];
    [self.printPictArray removeAllObjects];
    
    // セルの複数タップを制御する
    if ( ! [self.navigationController.visibleViewController isKindOfClass: [self class]] ) {
        DLog(@"visibleViewController is Invalid");
        return;
    }
    
    if(nIndexPath.section == 0)
    {
        switch (nIndexPath.row)
        {
            case 0:{
                SelectFileViewController_iPad * pViewController = [[SelectFileViewController_iPad alloc] init];
                pViewController.PrevViewID = PV_PRINT_SELECT_FILE_CELL;
                pViewController.bShowLeftBtn = YES;
                pViewController.bSetTitle = YES;
                
                // 複数印刷対応_iPad
                UINavigationController *nv = [[UINavigationController alloc]initWithRootViewController:pViewController];
                nv.modalPresentationStyle = UIModalPresentationPageSheet;
                nv.navigationBar.barStyle = NAVIGATION_BARSTYLE;
                [self presentViewController:nv animated:YES completion:nil];
                //[self ChangeView:pViewController didSelectRowAtIndexPath:nIndexPath];
            }break;
            case 1:{
                // 複数印刷対応_iPad
                [CommonUtil DeleteDir:[CommonUtil tmpDir]];
                if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad) {
                    ELCAlbumPickerController *albumController = [[ELCAlbumPickerController alloc] initWithNibName:@"ELCAlbumPickerController" bundle:[NSBundle mainBundle]];
                    ELCImagePickerController *elcPicker = [[ELCImagePickerController alloc] initWithRootViewController:albumController];
                    albumController.navigationController.navigationBar.barStyle = NAVIGATION_BARSTYLE;
                    elcPicker.modalPresentationStyle = UIModalPresentationPageSheet;
                    [albumController setParent:elcPicker];
                    [elcPicker setDelegate:self];
                    [elcPicker setMaximumImagesCount:-1];
                    [self presentViewController:elcPicker animated:YES completion:nil];
                }
            }break;
            default:
                break;
        }
    }
    else if(nIndexPath.section == 1)
    {
        switch (nIndexPath.row)
        {
            case 0: {
                if ([[self.navigationController.viewControllers firstObject] isKindOfClass:[RootViewController_iPad class]]) {
                    // Webページを印刷する
                    PrintPictViewController_iPad * printPictViewController = nil;
                    printPictViewController = [[PrintPictViewController_iPad alloc] init];
                    printPictViewController.SelFilePath	= S_PRINT_DATA_FILENAME_FOR_PRINT_PDF;
                    printPictViewController.PrintPictViewID = WEB_PRINT_VIEW;
                    
                    [self ChangeView:printPictViewController didSelectRowAtIndexPath:nIndexPath];
                    
                }else {
                    WebPagePrintViewController_iPad* pWebPagePrintViewController = [[WebPagePrintViewController_iPad alloc] init];
                    // モーダル表示
                    UINavigationController *navigationController = [[UINavigationController alloc]initWithRootViewController:pWebPagePrintViewController];
                    navigationController.navigationBar.barStyle = NAVIGATION_BARSTYLE;
                    [navigationController setModalPresentationStyle:UIModalPresentationPageSheet];
                    [self presentViewController:navigationController animated:YES completion:nil];
                }
            }
                break;
            case 1:{
                if ([[self.navigationController.viewControllers firstObject] isKindOfClass:[RootViewController_iPad class]]) {
                    // E-mailを印刷する
                    PrintPictViewController_iPad * printPictViewController = nil;
                    printPictViewController = [[PrintPictViewController_iPad alloc] init];
                    printPictViewController.SelFilePath	= S_PRINT_DATA_FILENAME_FOR_PRINT_PDF;
                    printPictViewController.PrintPictViewID = EMAIL_PRINT_VIEW;
                    printPictViewController.delegate = self;
                    [self ChangeView:printPictViewController didSelectRowAtIndexPath:nIndexPath];
                } else {
                    SelectMailViewController_iPad *smViewController = [[SelectMailViewController_iPad alloc] init];
                    
                    [smViewController setPrevViewID: PV_PRINT_SELECT_FILE_CELL];
                    smViewController.bRootClassShow = YES;
                    smViewController.nFolderCount = 1;
                    //                    self.smViewController.delegate = self;
                    
                    // モーダル表示
                    UINavigationController *navigationController = [[UINavigationController alloc]initWithRootViewController:smViewController];
                    navigationController.navigationBar.barStyle = NAVIGATION_BARSTYLE;
                    [navigationController setModalPresentationStyle:UIModalPresentationPageSheet];
                    [self presentViewController:navigationController animated:YES completion:nil];
                }
            }
                break;
            default:
                break;
        }
    }
    // 縦向き表示時のメニューPopOverが表示されていたら閉じる
    [self dismissMenuPopOver:YES];
}

-(void)performInvocation:(NSInvocation *)anInvocation{
    [anInvocation invokeWithTarget:self];
}

// 複数印刷対応
- (void)elcImagePickerController:(ELCImagePickerController *)picker didFinishPickingMediaWithInfo:(NSArray *)info {
    if (info.count == 0) {
        [self dismissViewControllerAnimated:YES completion:nil];
        return;
    }
    DLog(@"info = %@",info);
    
    if (isIOS8_1Later) {
        // エラーチェックなし

    } else {
        // エラーチェック
        for (NSDictionary *assetDic in info) {
            // 選択メディア
            NSString* pstrMediaType = [assetDic objectForKey:UIImagePickerControllerMediaType];
            // Imageの場合
            if (CFStringCompare((CFStringRef)pstrMediaType, kUTTypeImage, 0) == kCFCompareEqualTo)
            {
                NSString* path = [[assetDic objectForKey:UIImagePickerControllerReferenceURL] absoluteString];
                NSString* ext = [path substringFromIndex:[path rangeOfString:@"ext="].location + 4];
                
                if(![CommonUtil extensionCheck:ext])
                {
                    // Photo Albumを閉じる
                    [self dismissViewControllerAnimated:YES completion:^{
                        SharpScanPrintAppDelegate* appDelegate = (SharpScanPrintAppDelegate*)[[UIApplication sharedApplication] delegate];
                        // 処理実行フラグON
                        appDelegate.IsRun = TRUE;
                        
                        //
                        // アラート表示
                        //
                        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil
                                                                                                 message:MSG_NO_VIEW_FILE
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
                    }];
                    return;
                }
            }
            else
            {
                // ToDo:エラーメッセージ表示
            }
        }
    }
    
    [self.printPictArray addObjectsFromArray:info];
    [self dismissViewControllerAnimated:YES completion:nil];
    [self moveMultiPrintPictView];
}

// 複数印刷対応
- (void)elcImagePickerControllerDidCancel:(ELCImagePickerController *)picker {
    [self dismissViewControllerAnimated:YES completion:nil];
}

// 印刷画面に遷移
-(void)MovePrintPictView:(NSDictionary *)info
{
    SharpScanPrintAppDelegate* pAppDelegate = (SharpScanPrintAppDelegate*)[[UIApplication sharedApplication] delegate];
    
    UINavigationController *rRootNavController = [pAppDelegate.splitViewController.viewControllers objectAtIndex:1];
    if ([rRootNavController.viewControllers.lastObject isKindOfClass:[MultiPrintPictViewController_iPad class]]) {
        MultiPrintPictViewController_iPad *beforeVC = (MultiPrintPictViewController_iPad *)rRootNavController.viewControllers.lastObject;
        
        DLog(@"initRetentionFlg = %d",beforeVC.initRetentionFlg);
        DLog(@"m_nSelPickerRow1 = %ld",(long)beforeVC.m_nSelPickerRow1);
        DLog(@"m_nSelPickerRow2 = %ld",(long)beforeVC.m_nSelPickerRow2);
        DLog(@"m_nSelPickerRow3 = %ld",(long)beforeVC.m_nSelPickerRow3);
        DLog(@"m_nSelPickerRow4 = %ld",(long)beforeVC.m_nSelPickerRow4);
        DLog(@"m_nSelPickerRow5 = %ld",(long)beforeVC.m_nSelPickerRow5);
        DLog(@"m_nSelPickerRow6 = %ld",(long)beforeVC.m_nSelPickerRow6);
        DLog(@"m_nSelPickerRow7 = %ld",(long)beforeVC.m_nSelPickerRow7);
        DLog(@"m_nSelPickerRow8 = %ld",(long)beforeVC.m_nSelPickerRow8);
        DLog(@"m_pstrColorMode = %@",beforeVC.m_pstrColorMode);
        DLog(@"m_pstrNumSets = %@",beforeVC.m_pstrNumSets);
        DLog(@"m_pstrPaperSize = %@",beforeVC.m_pstrPaperSize);
        DLog(@"m_pstrPaperSizePJL = %@",beforeVC.m_pstrPaperSizePJL);
        DLog(@"m_pstrPaperType = %@",beforeVC.m_pstrPaperType);
        DLog(@"m_pstrPaperTypePJL = %@",beforeVC.m_pstrPaperTypePJL);
        DLog(@"m_pstrPrintRange = %@",beforeVC.m_pstrPrintRange);
        DLog(@"m_pstrRetention = %@",beforeVC.m_pstrRetention);
        DLog(@"m_pstrSide = %@",beforeVC.m_pstrSide);
        DLog(@"nNUpRow = %ld",(long)beforeVC.nNupRow);
        DLog(@"nSeqRow = %ld",(long)beforeVC.nSeqRow);
        DLog(@"pstrSelectedNUp = %@",beforeVC.pstrSelectedNUp);
        DLog(@"pstrSelectedSeq = %@",beforeVC.pstrSelectedSeq);
        DLog(@"noPrintOn = %d",beforeVC.noPrintOn);
        DLog(@"authenticateOn = %d",beforeVC.authenticateOn);
        DLog(@"pstrPassword = %@",beforeVC.pstrPassword);
        
        // 印刷画面に遷移
        MultiPrintPictViewController_iPad* pVC;
        pVC = [[MultiPrintPictViewController_iPad alloc] init];
        pVC.PrintPictViewID = PPV_PRINT_SELECT_PICTURE_CELL;
        if(info){
            pVC.multiPrintPictTempArray = [NSMutableArray arrayWithObject:info];
        } else {
            pVC.multiPrintPictTempArray = nil;
            return;
        }
        for (NSInteger i = 0; i < [[info allKeys] count]; i++)
        {
            DLog(@"key: %@, value:%@", [[info allKeys] objectAtIndex:i], [info objectForKey:[[info allKeys] objectAtIndex:i]]);
        }
        pVC.PictEditInfo = info;        // image情報格納
        pVC.IsPhotoView = TRUE;         // 遷移元画面設定
        pVC.selectPictArray = self.printPictArray;
        [pVC.previewScrollViewManager.m_plblPageNum setHidden:YES];
        pVC.isAddedPattern = YES;
        pVC.delegate = self;
        // 単数扱いではなくなるため、updateMenuAndDataArrayの前で強制的にYESにする。
        pVC.wasMultiDataPattern = YES;
        [pVC updateMenuAndDataArray];
        
        pVC.initRetentionFlg = beforeVC.initRetentionFlg;
        pVC.m_nSelPickerRow1 = beforeVC.m_nSelPickerRow1;
        pVC.m_nSelPickerRow2 = beforeVC.m_nSelPickerRow2;
        pVC.m_nSelPickerRow3 = beforeVC.m_nSelPickerRow3;
        pVC.m_nSelPickerRow4 = beforeVC.m_nSelPickerRow4;
        pVC.m_nSelPickerRow5 = beforeVC.m_nSelPickerRow5;
        pVC.m_nSelPickerRow6 = beforeVC.m_nSelPickerRow6;
        pVC.m_nSelPickerRow7 = beforeVC.m_nSelPickerRow7;
        pVC.m_nSelPickerRow8 = beforeVC.m_nSelPickerRow8;
        pVC.m_pstrColorMode = beforeVC.m_pstrColorMode;
        pVC.m_pstrNumSets = beforeVC.m_pstrNumSets;
        pVC.m_pstrPaperSize = beforeVC.m_pstrPaperSize;
        pVC.m_pstrPaperSizePJL = beforeVC.m_pstrPaperSizePJL;
        pVC.m_pstrPaperType = beforeVC.m_pstrPaperType;
        pVC.m_pstrPaperTypePJL = beforeVC.m_pstrPaperTypePJL;
        pVC.m_pstrPrintRange = beforeVC.m_pstrPrintRange;
        pVC.m_pstrRetention = beforeVC.m_pstrRetention;
        pVC.m_pstrSide = beforeVC.m_pstrSide;
        pVC.isInvalidDuplexSize = beforeVC.isInvalidDuplexSize;
        pVC.isInvalidDuplexType = beforeVC.isInvalidDuplexType;
        pVC.isInvalidStaplePaperSize = beforeVC.isInvalidStaplePaperSize;
        pVC.isInvalidStaplePaperType = beforeVC.isInvalidStaplePaperType;
        pVC.isDuplexPrint = beforeVC.isDuplexPrint;
        pVC.selectedPrinterPrimaryKey = beforeVC.selectedPrinterPrimaryKey;
        
        if (pVC.isSingleData) {
            if (pVC.hasN_UpData) {
                pVC.nNupRow = beforeVC.nNupRow;
                pVC.nSeqRow = beforeVC.nSeqRow;
                pVC.pstrSelectedNUp = beforeVC.pstrSelectedNUp;
                pVC.pstrSelectedSeq = beforeVC.pstrSelectedSeq;
            }
            if (pVC.hasEncryptionPdfData == NO) {
                pVC.noPrintOn = beforeVC.noPrintOn;
                pVC.authenticateOn = beforeVC.authenticateOn;
                pVC.pstrPassword = beforeVC.pstrPassword;
            }
        } else {
            pVC.nNupRow = beforeVC.nNupRow;
            pVC.nSeqRow = beforeVC.nSeqRow;
            pVC.pstrSelectedNUp = beforeVC.pstrSelectedNUp;
            pVC.pstrSelectedSeq = beforeVC.pstrSelectedSeq;
            
            pVC.noPrintOn = beforeVC.noPrintOn;
            pVC.authenticateOn = beforeVC.authenticateOn;
            pVC.pstrPassword = beforeVC.pstrPassword;
        }
        pVC.printReleaseOn = beforeVC.printReleaseOn;
        pVC.canPrintRelease =beforeVC.canPrintRelease;
        pVC.nClosingRow = beforeVC.nClosingRow;
        pVC.nStapleRow = beforeVC.nStapleRow;
        pVC.nPunchRow = beforeVC.nPunchRow;
        pVC.pstrSelectedClosing = beforeVC.pstrSelectedClosing;
        pVC.pstrSelectedStaple = beforeVC.pstrSelectedStaple;
        pVC.pstrSelectedPunch = beforeVC.pstrSelectedPunch;
        pVC.staple = beforeVC.staple;
        pVC.punchData = beforeVC.punchData;
        
        if([[[UIDevice currentDevice]systemVersion]floatValue]>=8)_shouldNotResetArrays = YES;
        [self.navigationController popToRootViewControllerAnimated:NO];
        [self.navigationController pushViewController:pVC animated:NO];
    } else {
        // 印刷画面に遷移
        MultiPrintPictViewController_iPad* pVC;
        pVC = [[MultiPrintPictViewController_iPad alloc] init];
        pVC.PrintPictViewID = PPV_PRINT_SELECT_PICTURE_CELL;
        pVC.multiPrintPictTempArray = [NSMutableArray arrayWithObject:info];
        pVC.delegate = self;
        for (NSInteger i = 0; i < [[info allKeys] count]; i++)
        {
            DLog(@"key: %@, value:%@", [[info allKeys] objectAtIndex:i], [info objectForKey:[[info allKeys] objectAtIndex:i]]);
        }
        pVC.PictEditInfo = info;        // image情報格納
        pVC.IsPhotoView = TRUE;         // 遷移元画面設定
        pVC.selectPictArray = self.printPictArray;
        [pVC.previewScrollViewManager.m_plblPageNum setHidden:YES];
        
        if (pVC.isAddedPattern == NO) {
            if ([[CommonUtil GetSelectedCountry]isEqualToString:S_LOCALE_US] || [[CommonUtil GetSelectedCountry]isEqualToString:S_LOCALE_CA]) {
                pVC.m_nSelPickerRow6 = 7;
            } else {
                pVC.m_nSelPickerRow6 = 2;
            }
        }
        [pVC updateMenuAndDataArray];
        
        [self.navigationController popToRootViewControllerAnimated:NO];
        [self.navigationController pushViewController:pVC animated:NO];
    }
    // Photo Albumを閉じる
    [self dismissViewControllerAnimated:YES completion:nil];
}

// 複数印刷画面に遷移
- (void)moveMultiPrintPictView {
    MultiPrintTableViewController_iPad *tVC = [[MultiPrintTableViewController_iPad alloc]initWithStyle:UITableViewStylePlain];
    tVC.PrintPictViewID = PPV_PRINT_SELECT_PICTURE_CELL;
    tVC.selectPictArray = self.printPictArray;
    tVC.delegate = self;
    SharpScanPrintAppDelegate* pAppDelegate = (SharpScanPrintAppDelegate*)[[UIApplication sharedApplication] delegate];
    UINavigationController* pRootNavController = [pAppDelegate.splitViewController.viewControllers objectAtIndex:0];
    [pRootNavController pushViewController:tVC animated:NO];
    
    [self MovePrintPictView:self.printPictArray.firstObject];
}

- (void)moveMultiPrintPictNotification:(NSNotification *)n {
    
    NSMutableArray *ary = (NSMutableArray *)n.object;
    DLog(@"ary = %lu",(unsigned long)ary.count);
    
    [self.printPictArray addObjectsFromArray:ary];
    [self MovePrintPictView:self.printPictArray.firstObject];
    
    //    MultiPrintTableViewController_iPad *tVC = [[MultiPrintTableViewController_iPad alloc]initWithStyle:UITableViewStylePlain];
    //    tVC.PrintPictViewID = PPV_PRINT_SELECT_PICTURE_CELL;
    //    tVC.selectPictArray = self.printPictArray;
    //    tVC.delegate = self;
    //
    //    SharpScanPrintAppDelegate* pAppDelegate = (SharpScanPrintAppDelegate*)[[UIApplication sharedApplication] delegate];
    //    UINavigationController* pRootNavController = [pAppDelegate.splitViewController.viewControllers objectAtIndex:0];
    //    [pRootNavController popToRootViewControllerAnimated:NO];
    //    [pRootNavController pushViewController:tVC animated:NO];
    
    SharpScanPrintAppDelegate* pAppDelegate = (SharpScanPrintAppDelegate*)[[UIApplication sharedApplication] delegate];
    UINavigationController* pRootNavController = [pAppDelegate.splitViewController.viewControllers objectAtIndex:0];
    MultiPrintTableViewController_iPad *tVC = (MultiPrintTableViewController_iPad *)[pRootNavController.viewControllers lastObject];
    tVC.PrintPictViewID = PPV_PRINT_SELECT_PICTURE_CELL;
    tVC.selectPictArray = self.printPictArray;
    tVC.delegate = self;
    [tVC.tableView reloadData];
    
}

- (void)editMultiPrintPictNotification:(NSNotification *)n {
    NSMutableArray *ary = (NSMutableArray *)n.object;
    if (ary.count > 0) {
        [self.printPictArray removeAllObjects];
        [self.printPictArray addObjectsFromArray:ary];
    }
}

// 処理実行フラグをOFFにする
- (void)appDelegateIsRunOff {
    // ボタンタップ時の処理
    SharpScanPrintAppDelegate* appDelegate = (SharpScanPrintAppDelegate*)[[UIApplication sharedApplication] delegate];
    // 処理実行フラグOFF
    appDelegate.IsRun = FALSE;
}

- (void)updateView:(UIViewController*) pViewController
{
    [self.navigationController pushViewController:pViewController animated:YES];
}

// トップ画面更新(検索用)
- (void)updateView:(NSInteger)preViewID searchPreViewID:(NSInteger)searchViewID didSelectRowAtIndexPath:(NSIndexPath *)indexPath scrollOffset:(CGPoint)offset
{
    SearchResultViewController_iPad* pSearchResultViewController;
    AdvancedSearchResultViewController_iPad* pAdvancedSearchResultViewController;
    switch (searchViewID) {
        case SearchResultTypeView:
            pSearchResultViewController = [[SearchResultViewController_iPad alloc] init];
            pSearchResultViewController.PrevViewID = preViewID;
            pSearchResultViewController.bSetTitle = NO;
            pSearchResultViewController.selectIndexPath = indexPath;
            pSearchResultViewController.lastScrollOffSet = offset;
            //            pSearchResultViewController.bCanDelete = NO;
            //            pSearchResultViewController.subDir = self.subDir;
            //            pSearchResultViewController.rootDir = self.rootDir;
            pSearchResultViewController.pstrSearchKeyword = self.pstrSearchKeyword;
            // 画面遷移
            [self.navigationController pushViewController:pSearchResultViewController animated:YES];
            break;
        case AdvancedSearchResultTypeView:
            pAdvancedSearchResultViewController = [[AdvancedSearchResultViewController_iPad alloc] init];
            pAdvancedSearchResultViewController.PrevViewID = preViewID;
            pAdvancedSearchResultViewController.bSetTitle = NO;
            pAdvancedSearchResultViewController.selectIndexPath = indexPath;
            pAdvancedSearchResultViewController.lastScrollOffSet = offset;
            //            //詳細検索結果画面への遷移時にルートディレクトリを渡す
            //            pAdvancedSearchResultViewController.scanDirectory = [[ScanDirectory alloc]initWithScanDirectoryPath:[ScanFileUtility getRootDir]];
            
            pAdvancedSearchResultViewController.pstrSearchKeyword = self.pstrSearchKeyword;
            pAdvancedSearchResultViewController.bSubFolder = self.bSubFolder;
            pAdvancedSearchResultViewController.bFillterFolder = self.bFillterFolder;
            pAdvancedSearchResultViewController.bFillterPdf = self.bFillterPdf;
            pAdvancedSearchResultViewController.bFillterTiff = self.bFillterTiff;
            pAdvancedSearchResultViewController.bFillterImage = self.bFillterImage;
            pAdvancedSearchResultViewController.bFillterOffice = self.bFillterOffice;
            // 画面遷移
            [self.navigationController pushViewController:pAdvancedSearchResultViewController animated:YES];
            break;
        default:
            break;
    }
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

// iPad用
-(void)ChangeView:(UIViewController *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //    self.selectIndexPath = indexPath;
    SharpScanPrintAppDelegate* pAppDelegate = (SharpScanPrintAppDelegate*)[[UIApplication sharedApplication] delegate];
    UINavigationController* pRootNavController = [pAppDelegate.splitViewController.viewControllers objectAtIndex:0];
    //左側のViewに設定されているクラスの名前を取得
    NSString* leftViewClassName = [pRootNavController.topViewController description];
    // 左側のViewにトップメニューが表示されている場合
    if(![leftViewClassName isEqual:[self description]])
    {
        // 右側のViewを更新して画像プレビューを表示
        [self.navigationController pushViewController:tableView animated:NO];//アニメーションなし
    }
    else
    {
        // 左のナビゲーションにPrintSelectTypeViewController_iPadがある場合
        
        SharpScanPrintAppDelegate* pAppDelegate = (SharpScanPrintAppDelegate*)[[UIApplication sharedApplication] delegate];
        UINavigationController* lRootNavController = [pAppDelegate.splitViewController.viewControllers objectAtIndex:1];
        [lRootNavController popToRootViewControllerAnimated:NO];
        
        NSArray *viewControllers = [[NSArray alloc] initWithObjects:self.navigationController, lRootNavController, nil];
        pAppDelegate.splitViewController.viewControllers = viewControllers;
        
        [(PrintSelectTypeViewController_iPad*)[[lRootNavController viewControllers] objectAtIndex:0] updateView:tableView];
        
    }
}

- (void)ChangeLeftView
{
    NSIndexPath* indexPath = [NSIndexPath indexPathForRow:0 inSection:1];
    
    SharpScanPrintAppDelegate* pAppDelegate = (SharpScanPrintAppDelegate*)[[UIApplication sharedApplication] delegate];
    UINavigationController* pRootNavController = [pAppDelegate.splitViewController.viewControllers objectAtIndex:0];
    
    // 左側のViewを更新してファイル一覧を表示
    RootViewController_iPad* pRootViewController = (RootViewController_iPad*)pRootNavController.topViewController;
    [pRootViewController updateView:PV_PRINT_SELECT_FILE_CELL didSelectRowAtIndexPath:indexPath scrollOffset:[self.tableView contentOffset]];
    selectIndexPath = nil;
}
// トップ画面更新
- (void)updateView:(NSInteger)preViewID didSelectRowAtIndexPath:(NSIndexPath *)indexPath scrollOffset:(CGPoint)offset subDir:(NSString*)pSubDir rootDir:(NSString*)pRootDir
{
    
    switch (preViewID) {
        case PV_PRINT_SELECT_FILE_CELL:{
            SelectFileViewController_iPad* pSelectFileViewController = [[SelectFileViewController_iPad alloc] init];
            pSelectFileViewController.PrevViewID = preViewID;
            pSelectFileViewController.bSetTitle = NO;
            pSelectFileViewController.selectIndexPath = indexPath;
            pSelectFileViewController.lastScrollOffSet = offset;
            //            pSelectFileViewController.subDir = pSubDir;
            //            pSelectFileViewController.rootDir = pRootDir;
            // 画面遷移
            [self.navigationController pushViewController:pSelectFileViewController animated:YES];
        }break;
        default:
            break;
    }
    
}


#pragma mark - 外部呼び出し

/**
 * メール選択画面を閉じ、添付ファイル画面を開く
 * @param viewController 次に開くべき添付画面
 * @param closeView 閉じるべき画面
 */
-(void) closeSelectMailViewShowAttachmentMailView:(UIViewController*)viewController closeView:(UIViewController*)closeView
{
    
    SelectMailViewController_iPad* con = (SelectMailViewController_iPad*)closeView;
    
    SharpScanPrintAppDelegate* pAppDelegate = (SharpScanPrintAppDelegate*)[[UIApplication sharedApplication] delegate];
    
    // 右側のViewを取得
    UINavigationController* pDetailNavController = [pAppDelegate.splitViewController.viewControllers objectAtIndex:1];
    if ([[pDetailNavController topViewController] isKindOfClass:self.class])
    {
        AttachmentMailViewController_iPad *pViewController = [[AttachmentMailViewController_iPad alloc] init];
        
        //メール添付ファイル表示画面への遷移時にメール添付のルートディレクトリを渡します
        pViewController.attachmentDirectory = [[TempAttachmentDirectory alloc]initWithDirectoryPath:[TempAttachmentFileUtility getRootDir]];
        
        UINavigationController *navigationController = [[UINavigationController alloc]initWithRootViewController:pViewController];
        navigationController.navigationBar.barStyle = NAVIGATION_BARSTYLE;
        [navigationController setModalPresentationStyle:UIModalPresentationPageSheet];
        
        if([con respondsToSelector:@selector(dismissViewControllerAnimated:completion:)])
        {//iOS5以上
            //モーダル閉じる
            [con dismissViewControllerAnimated:YES completion:^{
                
                //閉じた後
                //次の画面をモーダル表示
                [self presentViewController:navigationController animated:YES completion:^{
                    
                }];
            }];
        }
        else
        {//iOS4
            // モーダルを閉じる
            [con dismissViewControllerAnimated:YES completion:nil];
            
            // 閉じるのを待って次のモーダルを表示
            double delayInSeconds = 1.5;
            dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
            dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
                [self presentViewController:navigationController animated:YES completion:nil];
            });
        }
        
    } else {
        PrintPictViewController_iPad* ppViewController = (PrintPictViewController_iPad*)viewController;
        if(floor(NSFoundationVersionNumber) < NSFoundationVersionNumber_iOS_5_0)
        {
            // モーダルを閉じる
            [con dismissViewControllerAnimated:YES completion:nil];
            
            // 閉じるのを待って次のモーダルを表示
            [self performSelector:@selector(showAttachmentMailView:) withObject:ppViewController afterDelay:0.5];
        } else {
            // iOS5以上なら
            [con dismissViewControllerAnimated:YES completion:^{
                AttachmentMailViewController_iPad *pViewController = [[AttachmentMailViewController_iPad alloc] init];
                pViewController.delegate = ppViewController;
                
                //メール添付ファイル表示画面への遷移時にメール添付のルートディレクトリを渡します
                pViewController.attachmentDirectory = [[TempAttachmentDirectory alloc]initWithDirectoryPath:[TempAttachmentFileUtility getRootDir]];
                
                // モーダル表示
                UINavigationController *navigationController = [[UINavigationController alloc]initWithRootViewController:pViewController];
                navigationController.navigationBar.barStyle = NAVIGATION_BARSTYLE;
                [navigationController setModalPresentationStyle:UIModalPresentationPageSheet];
                
                [self presentViewController:navigationController animated:YES completion:^{
                    
                }];
            }];
        }
    }
}

/**
 @brief 通信中フラグの設定値を変える
 @details PrintPictViewからプリンター情報取得関連処理で呼ばれる(外部呼び出しメソッド:デリゲートメソッド)
 */
- (void)setDuringCommProcessValue:(BOOL)bValue {
    // 左側のViewを取得
    SharpScanPrintAppDelegate* pAppDelegate = (SharpScanPrintAppDelegate*)[[UIApplication sharedApplication] delegate];
    UINavigationController *pRootNavController = [pAppDelegate.splitViewController.viewControllers objectAtIndex:0];
    
    if ([pRootNavController.viewControllers.lastObject isKindOfClass:[MultiPrintTableViewController_iPad class]])
    {//splitViewCの左側がMultiPrintTableViewController_iPadのとき
        MultiPrintTableViewController_iPad *tVC = (MultiPrintTableViewController_iPad *)pRootNavController.viewControllers.lastObject;
        tVC.isDuringCommProcess = bValue;
        
        /*
         if (bValue) {
         // 編集ボタンを無効化
         tVC.editButtonItem.enabled = NO;
         }
         else {
         tVC.editButtonItem.enabled = YES;
         }
         */
    }
}

- (void)showAttachmentMailView:(UIViewController*)viewController
{
    AttachmentMailViewController_iPad *pViewController = [[AttachmentMailViewController_iPad alloc] init];
    //    pViewController.delegate = viewController;
    // モーダル表示
    UINavigationController *navigationController = [[UINavigationController alloc]initWithRootViewController:pViewController];
    navigationController.navigationBar.barStyle = NAVIGATION_BARSTYLE;
    [navigationController setModalPresentationStyle:UIModalPresentationPageSheet];
    [self presentViewController:navigationController animated:YES completion:nil];
    //    [self presentViewController:navigationController animated:YES completion:^{
    //
    //    }];
    
}


//-(void) closeSelectMailViewShowAttachmentMailView:(UIViewController*)viewController closeView:(UIViewController*)closeView
//{
//    PrintPictViewController_iPad* ppViewController = (PrintPictViewController_iPad*)viewController;
//    [self.navigationController popViewControllerAnimated:NO];
//
//    SelectMailViewController_iPad* con = (SelectMailViewController_iPad*)closeView;
//
//    if([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0)
//    {   // iOS7以上なら
//        [con dismissViewControllerAnimated:YES completion:^{
//            [self performSelector:@selector(showAttachmentMailView:) withObject:ppViewController afterDelay:0.0];
//        }];
//
//    }else {
//        // モーダルを閉じる
//        [con dismissViewControllerAnimated:YES completion:nil];
//
//        // 閉じるのを待って次のモーダルを表示
//        [self performSelector:@selector(showAttachmentMailView:) withObject:ppViewController afterDelay:0.5];
//    }
//
//}
//
//- (void)showAttachmentMailView:(UIViewController*)viewController
//{
//    AttachmentMailViewController* pViewController = nil;
//    pViewController = [[AttachmentMailViewController alloc] init];
//    pViewController.delegate = viewController;
//    // モーダル表示
//    UINavigationController *navigationController = [[UINavigationController alloc]initWithRootViewController:pViewController];
//    navigationController.navigationBar.barStyle = NAVIGATION_BARSTYLE;
//    [navigationController setModalPresentationStyle:UIModalPresentationPageSheet];
//    
//    [UIView animateWithDuration:0.3 animations:^{
//        [self presentViewController:navigationController animated:YES completion:nil];
//    } completion:^(BOOL finished) {
//        [self.navigationController pushViewController:viewController animated:NO];
//    }];
//    
//}

@end
