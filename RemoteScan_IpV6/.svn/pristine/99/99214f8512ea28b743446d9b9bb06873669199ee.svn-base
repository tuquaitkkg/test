
#import <CFNetwork/CFNetwork.h>
#import <UIKit/UIKit.h>
#import "PrintPictViewController_iPad.h"
#import "NSStreamAdditions.h"
#import "CommonManager.h"
#import "ProfileDataManager.h"
#import "ProfileData.h"
#import "ScanBeforePictViewController_iPad.h"
#import "FinishingViewController.h"
#import "NUpViewController.h"
#import "PrintRangeSettingViewController.h"
#import "RetentionSettingViewController.h"
#import "PrintReleaseSettingViewController.h"
#import "PrintSelectTypeViewController_iPad.h"

// iPad用
#import "SharpScanPrintAppDelegate.h"
#import "RootViewController_iPad.h"
#import "WebPagePrintViewController_iPad.h"

#import "MultiPrintPictViewController.h"

// iPad用
#import <ImageIO/ImageIO.h>
#import <AssetsLibrary/AssetsLibrary.h>
#import <Photos/PHFetchResult.h>
#import <Photos/PHAsset.h>
#import <Photos/PHImageManager.h>

// Socket通信用
#import <netinet/in.h>
#import <sys/socket.h>
#import <arpa/inet.h>
#import <netdb.h>      // IPv6対応

#define PAGE_DEL_BUTTON_TAG 20

@implementation PrintPictViewController_iPad
{
    BOOL _isNotFirstViewDidAppear; /** ２回目以降のviewDidAppearではYES　*/
    NSArray* buttonIdArray;
}

static void SocketCallBack(CFSocketRef socket, CFSocketCallBackType type, CFDataRef address, const void *data, void *info);

@synthesize delegate;
@synthesize NetworkStream = m_pNetworkStream;
@synthesize FileStream = m_pFileStream;
@synthesize BufferOffset  = m_stBufferOffset;
@synthesize BufferLimit   = m_stBufferLimit;
@synthesize IsSite        = m_isSite;
@synthesize IsSiteTemp = m_isSiteTemp;
@synthesize IsCancel = m_isCacel;
//@synthesize PjlFileName = m_stPjlFaileName;
@synthesize IsStopSend = m_isStopSend;

@synthesize m_diCtrl;

@synthesize viewPopoverController;

//コールバックが呼ばれたかどうかのフラグ
@synthesize  isCalledConnectCallback;

@synthesize selectedPrinterPrimaryKey;

// Because buffer is declared as an array, you have to use a custom getter.
// A synthesised getter doesn't compile.
- (uint8_t *)Buffer {
    return self->m_pBuffer;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    self.mailFormtArray = [[NSMutableArray alloc]init];
    if (self) {
        // 変数初期化
        [super InitObject];
        m_bSendFile = FALSE;
        
        // 印刷範囲拡張有効確認
        [self checkPdfPrintRangeExpansionMode];
        
        selectedPrinterPrimaryKey = nil;
    }
    return self;
}

- (void)dealloc {
    DLog(@"%@",m_popOver);
    // Popoverが表示されていたら閉じる
    [m_popOver dismissPopoverAnimated:NO];
    m_popOver.delegate = nil;
    m_popOver = nil;
    
    //self.m_commProcessData = nil;
    //self.isDuringCommProcess = nil;
    
    SharpScanPrintAppDelegate* appDelegate = (SharpScanPrintAppDelegate*)[[UIApplication sharedApplication] delegate];
    appDelegate.IsRun = FALSE;
    
    if (nil != m_pCmnMgr) {
        // PJL削除
        [m_pCmnMgr removeFile:self.PjlFileName];
        m_pCmnMgr = nil;
    }
    if (nil != m_pPrinterMgr) {
        m_pPrinterMgr = nil;
    }
    if (nil != m_pPrintOutMgr) {
        m_pPrintOutMgr = nil;
    }
    if (nil != m_pPJLDataMgr) {
        m_pPJLDataMgr = nil;
    }
    
    //印刷用のファイルを削除する
    if (self.PrintPictViewID == WEB_PRINT_VIEW || self.PrintPictViewID == EMAIL_PRINT_VIEW) {
        // 印刷用PDFファイルの削除
        [self deletePrintPDFFile:self.SelFilePath];
    }
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - View lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // UINavigationBar 44px のずれを無くす
    self.navigationController.navigationBar.translucent = NO;
    self.navigationController.navigationBar.barStyle = NAVIGATION_BARSTYLE;
    
    //最初にキャッシュファイルの生成を試みる
    for (ScanData* scanData in self.selectFileArray)
    {
        NSString *selFilePath = [NSString stringWithFormat:@"%@%@",scanData.fpath,scanData.fname];
        //        [self createCashForFile:selFilePath];
        [GeneralFileUtility createCacheFile:selFilePath];
    }
    
    //self.m_commProcessData = nil;
    self.isDuringCommProcess = nil;
    
    // CommonManagerクラス生成
    m_pCmnMgr = [[CommonManager alloc] init];
    
    // 写真の時は先にキャッシュをつくってしまう
    if(self.PrintPictViewID == PPV_PRINT_SELECT_PICTURE_CELL){
        [self getPictureFromPhotoLibraryForSync];
    }
    
    // PrinterDataManagerクラス初期化
    m_pPrinterMgr = [[PrinterDataManager alloc] init];
    
    // PrintServerDataManagerクラス初期化
    m_pPrintServerMgr = [[PrintServerDataManager alloc] init];
    
    // PrintOutDataManagerクラス初期化
    m_pPrintOutMgr = [[PrintOutDataManager alloc] init];
    
    // PJLDataManagerクラス初期化
    m_pPJLDataMgr = [[PJLDataManager alloc] init];
    
    //PrintOutDataManagerクラス初期化
    printOutManager = [[PrintOutDataManager alloc]init];
    //はがきサイズかつ両面の場合に戻るサイズの初期値はA4
    // iPadはPJLの値を元にする
    sizeBeforeSelect = S_PJL_PAPERSIZE_A4;
    if ([[CommonUtil GetSelectedCountry]isEqualToString:S_LOCALE_US] || [[CommonUtil GetSelectedCountry]isEqualToString:S_LOCALE_CA]) {
        // 初期値をLETTERにする
        sizeBeforeSelect = S_PJL_PAPERSIZE_LETTER;
    }
    
    
    // Webページ印刷画面から遷移してきた場合
    //    // 戻るボタンを表示する
    //    BOOL hidesBackButton = ! [super isMoveWebPagePrint];
    //	if (hidesBackButton)
    //    {
    //        hidesBackButton = ![super isMoveAttachmentMail];
    //    }
    
    if (self.PrintPictViewID == PPV_PRINT_SELECT_FILE_CELL ||
        self.PrintPictViewID == PPV_PRINT_SELECT_PICTURE_CELL ||
        self.PrintPictViewID == PPV_PRINT_MAIL_ATTACHMENT_CELL )
    {
        self.isSingleData = YES;
        [self updateMenuAndDataArray];
    }
    else
    {
        [self updateMenuAndDataArrayExceptFilePicMailAtt];
    }
    
    //縦横判定
    if (arrThumbnails.count != 0)
    {
        UIImage* image = [[UIImage alloc] initWithContentsOfFile:[arrThumbnails objectAtIndex:0]];
        self.m_isVertical = image.size.width <= image.size.height;
    }
    else
    {
        self.m_isVertical = TRUE;
    }
    // プロファイルの取得
    profileDataManager = [[ProfileDataManager alloc] init];
    ProfileData *profileData = [profileDataManager loadProfileDataAtIndex:0];
    m_isUseRawPrintMode = profileData.useRawPrintMode;
    
    // アプリケーション動作設定画面に設定中のリテンション設定で初期化する
    [self initRetention];
    
    // 仕上げの設定を初期化する
    [self initFinishing];
    
    // ソケット初期化
    m_Socket = NULL;
    
    
    // NoImageを表示するか判定
    [self showNoImageView];
    
    // メニュービュー作成
    [self updateMenuView:NO andSelRow:[self getSelPickerRowWithIndex:BUTTON_PRINTER]];
    
    // 実行スレッド
    [self performSelector:@selector(ActionThread) withObject:nil afterDelay:0.1];
    
    
}

- (void)updateMenuView:(BOOL)isRemake andSelRow:(NSInteger)selRow {
    // 最新プライマリキー取得
    NSString* pstrKey;
    // 接続先WiFiの最新プライマリキー取得
    NSString* pstrKeyForCurrentWiFi;
    // プリンタかプリントサーバーかの設定を確認する
    PrinterData* printerData = nil;
    pstrKey = [m_pPrintOutMgr GetLatestPrimaryKey];
    pstrKeyForCurrentWiFi = [m_pPrintOutMgr GetLatestPrimaryKeyForCurrentWiFi];
    // 選択中MFP取得
    [m_pPrinterMgr SetDefaultMFPIndex:pstrKey PrimaryKeyForCurrrentWifi:pstrKeyForCurrentWiFi];
    
    //NSInteger selPickerRow = [self getSelPickerRowWithIndex:BUTTON_PRINTER];
    NSInteger selPickerRow = selRow;
    printerData = (selPickerRow != m_pPrinterMgr.DefaultMFPIndex) ? [m_pPrinterMgr LoadPrinterDataAtIndexInclude2:selPickerRow] : [m_pPrinterMgr LoadPrinterDataAtIndexInclude2:m_pPrinterMgr.DefaultMFPIndex];
    
    DLog(@"%@",printerData.PrinterName);
    
    // Webページ印刷画面から遷移してきた場合
    // 戻るボタンを表示する
    BOOL hidesBackButton = ![super isMoveWebPagePrint];
    
    if (hidesBackButton) {
        hidesBackButton = ![super isMoveAttachmentMail];
    }
    
    // メインビュー初期化
    // 戻るボタンの名称変更
    UIBarButtonItem * barItemBack = [UIBarButtonItem new];
    barItemBack.title = S_BUTTON_BACK;
    self.navigationItem.backBarButtonItem = barItemBack;
    
    if (isRemake) {
        [super InitView:[CommonUtil getSSID] menuBtnNum:nPreMenuBtnMaxID hidesBackButton:hidesBackButton hidesSettingButton:NO setHiddenNoImage:YES];
    }
    else {
        [super InitView:[CommonUtil getSSID] menuBtnNum:nPreMenuBtnMaxID hidesBackButton:hidesBackButton hidesSettingButton:NO];
    }
    
    DLog(@"%ld",(long)nPreMenuBtnMaxID);
    
    m_bButtonEnable = NO;
    if (printerData != nil) {
        m_bButtonEnable = YES;
    }
    
    // メニュー作成
    NSString* pstrBtnName;
    NSString* pstrIconName = @"";
    NSString* pstrLabelName = @"";
    
    for (int i = 0; i < [buttonIdArray count]; i++) {
        enum PRINTER_SETTING_BUTTON buttonId = [[buttonIdArray objectAtIndex:i] intValue];
        switch (buttonId) {
            case BUTTON_OTHERAPP:
                pstrBtnName = S_BUTTON_OTHER_APP;
                pstrLabelName = @"";
                pstrIconName = S_ICON_SEND_SEND;
                break;
            case BUTTON_PRINTER:
                pstrBtnName = S_BUTTON_NO_PRINTER;
                if (printerData != nil) {
                    pstrBtnName = [printerData getPrinterName];
                }
                pstrLabelName = S_LABEL_PRINTER_IPAD;//プリンター
                pstrIconName = S_ICON_PRINT_PRINTER;
                
                if (isRemake != YES) {
                    NSInteger selPickerRow = [self getSelPickerRowWithIndex:BUTTON_PRINTER];
                    selPickerRow = selPickerRow ? selPickerRow : m_pPrinterMgr.DefaultMFPIndex;
                    [self setSelPickerRowWithIndex:BUTTON_PRINTER andRow:selPickerRow];
                }
                
                break;
            case BUTTON_NUM:
                
                pstrBtnName = S_BUTTON_NUMBER_OF_SETS_IPAD;//%@部
                if (self.m_pstrNumSets) {
                    pstrBtnName = [[NSString alloc]initWithFormat: pstrBtnName, self.m_pstrNumSets];
                } else {
                    pstrBtnName = [[NSString alloc]initWithFormat: pstrBtnName, @"1"];
                }
                NSInteger selPickerRow = [self getSelPickerRowWithIndex:BUTTON_NUM];
                selPickerRow = selPickerRow ? selPickerRow : 1;
                [self setSelPickerRowWithIndex:BUTTON_NUM andRow:selPickerRow];
                
                self.m_pstrNumSets = self.m_pstrNumSets ? self.m_pstrNumSets : @"1";
                
                
                pstrLabelName = S_LABEL_NUMBER_OF_SETS_IPAD;//部数
                pstrIconName = S_ICON_PRINT_NUMBER_OF_SETS;
                break;
            case BUTTON_DUPLEX:
            {
                pstrLabelName = S_LABEL_SIDE_IPAD;
                pstrIconName = S_ICON_PRINT_BOTH_ONESIDES;
                
                NSInteger selPickerRow = [self getSelPickerRowWithIndex:BUTTON_DUPLEX];
                selPickerRow = selPickerRow ? selPickerRow :E_ONE_SIDE;
                [self setSelPickerRowWithIndex:BUTTON_DUPLEX andRow:selPickerRow];
                
                switch ([self getSelPickerRowWithIndex:BUTTON_DUPLEX]) {
                    default:
                    case E_ONE_SIDE:
                        pstrBtnName = self.m_pstrSide = S_ONE_SIDE;
                        break;
                    case E_DUPLEX_SIDE_LONG:
                        pstrBtnName = self.m_pstrSide = S_DUPLEX_SIDE_LONG;
                        break;
                    case E_DUPLEX_SIDE_SHORT:
                        pstrBtnName = self.m_pstrSide = S_DUPLEX_SIDE_SHORT;
                        break;
                }
            }
                break;
            case BUTTON_COLOR:
            {
                pstrLabelName = S_LABEL_COLORMODE_IPAD;
                pstrIconName = S_ICON_COLORMODE;
                
                NSInteger selPickerRow = [self getSelPickerRowWithIndex:BUTTON_COLOR];
                selPickerRow = selPickerRow ? selPickerRow : 0;
                [self setSelPickerRowWithIndex:BUTTON_COLOR andRow:selPickerRow];
                
                if(self.PrintPictViewID == EMAIL_PRINT_VIEW){
                    
                    // グレースケールを初期値にセット
                    if (isRemake != YES) {
                        [self setSelPickerRowWithIndex:BUTTON_COLOR andRow:1];
                    }
                    
                    switch ([self getSelPickerRowWithIndex:BUTTON_COLOR]) {
                        default:
                        case 0:
                            pstrBtnName = self.m_pstrColorMode = S_PRINT_COLORMODE_COLOR;
                            break;
                        case 1:
                            pstrBtnName = self.m_pstrColorMode = S_PRINT_COLORMODE_BW;
                            break;
                    }
                } else {
                    
                    switch ([self getSelPickerRowWithIndex:BUTTON_COLOR]) {
                        default:
                        case 0:
                            pstrBtnName = self.m_pstrColorMode = S_PRINT_COLORMODE_AUTO;
                            break;
                        case 1:
                            pstrBtnName = self.m_pstrColorMode = S_PRINT_COLORMODE_COLOR;
                            break;
                        case 2:
                            pstrBtnName = self.m_pstrColorMode = S_PRINT_COLORMODE_BW;
                            break;
                    }
                }
            }
                break;
            case BUTTON_PAPERSIZE:
            {
                pstrLabelName = S_LABEL_PAPERSIZE_IPAD;//用紙サイズ
                pstrIconName = S_ICON_PAPERSIZE;
                
                NSMutableArray* paperSizeArray = [self getPaperSizeArray];
                
                NSMutableArray* pjlArray = [self getPaperSizePJLArray];
                
                if (isRemake == YES) {
                    // 再生成時
                    NSInteger selPickerRow = [self getSelPickerRowWithIndex:BUTTON_PAPERSIZE];
                    selPickerRow = selPickerRow ? selPickerRow : 0;
                    [self setSelPickerRowWithIndex:BUTTON_PAPERSIZE andRow:selPickerRow];
                    
                    pstrBtnName = self.m_pstrPaperSize ? self.m_pstrPaperSize : [paperSizeArray objectAtIndex:selPickerRow];
                    self.m_pstrPaperSize = [paperSizeArray objectAtIndex:selPickerRow];
                    self.m_pstrPaperSizePJL = [pjlArray objectAtIndex:selPickerRow];
                    
                }
                else if ([[CommonUtil GetSelectedCountry]isEqualToString:S_LOCALE_US]
                         || [[CommonUtil GetSelectedCountry]isEqualToString:S_LOCALE_CA])
                {
                    
                    pstrBtnName = self.m_pstrPaperSize ? self.m_pstrPaperSize : S_PRINT_PAPERSIZE_LETTER;
                    NSInteger selPickerRow = [self getSelPickerRowWithIndex:BUTTON_PAPERSIZE];
                    selPickerRow = selPickerRow ? selPickerRow : 7;
                    [self setSelPickerRowWithIndex:BUTTON_PAPERSIZE andRow:selPickerRow];
                    
                    self.m_pstrPaperSize = self.m_pstrPaperSize ? self.m_pstrPaperSize : S_PRINT_PAPERSIZE_LETTER;
                    self.m_pstrPaperSizePJL = self.m_pstrPaperSizePJL ? self.m_pstrPaperSizePJL : S_PJL_PAPERSIZE_LETTER;
                    
                } else {
                    
                    pstrBtnName = self.m_pstrPaperSize ? self.m_pstrPaperSize : S_PRINT_PAPERSIZE_A4;
                    NSInteger selPickerRow = [self getSelPickerRowWithIndex:BUTTON_PAPERSIZE];
                    selPickerRow = selPickerRow ? selPickerRow : 2;
                    [self setSelPickerRowWithIndex:BUTTON_PAPERSIZE andRow:selPickerRow];
                    
                    self.m_pstrPaperSize = self.m_pstrPaperSize ? self.m_pstrPaperSize : S_PRINT_PAPERSIZE_A4;
                    self.m_pstrPaperSizePJL = self.m_pstrPaperSizePJL ? self.m_pstrPaperSizePJL : S_PJL_PAPERSIZE_A4;
                    
                }
                
            }
                break;
                
            case BUTTON_PAPERTYPE:
            {
                // 用紙タイプ
                pstrLabelName = S_LABEL_PAPERTYPE_IPAD; //用紙タイプ
                pstrIconName = S_ICON_PAPERTYPE;
                
                NSMutableArray* paperTypeArray = [self getPaperTypeItems];
                
                NSMutableArray* pjlArray = [self getPaperTypePJL];
                
                if (isRemake) {
                    pstrBtnName = self.m_pstrPaperType;
                }
                else {
                    NSInteger selPickerRow = [self getSelPickerRowWithIndex:BUTTON_PAPERTYPE];
                    selPickerRow = selPickerRow ? selPickerRow : 0;
                    [self setSelPickerRowWithIndex:BUTTON_PAPERTYPE andRow:selPickerRow];
                    
                    pstrBtnName = self.m_pstrPaperType ? self.m_pstrPaperType : [[self getPaperTypeItems] objectAtIndex:selPickerRow];
                    self.m_pstrPaperType = [paperTypeArray objectAtIndex:selPickerRow];
                    self.m_pstrPaperTypePJL = [pjlArray objectAtIndex:selPickerRow];
                }
                
            }
                
                break;
            case BUTTON_FINISHING:
                pstrBtnName = [self getDisplayFinishing];
                pstrLabelName = S_BUTTON_FINISHING_IPAD;
                pstrIconName = S_ICON_STAPLE;
                break;
            case BUTTON_NUP:
                pstrBtnName = self.pstrSelectedNUp ? self.pstrSelectedNUp : S_PRINT_N_UP_ONE_UP;
                
                pstrLabelName = S_BUTTON_N_UP_IPAD;
                pstrIconName = S_ICON_NUP;
                break;
            case BUTTON_RANGE:
                pstrBtnName = self.m_pstrPrintRange ? self.m_pstrPrintRange : S_PRINT_RANGE_ALL;
                pstrLabelName = S_BUTTON_PRINT_RANGE_IPAD;        //印刷範囲
                pstrIconName = S_ICON_PRINTRANGE;
                break;
            case BUTTON_TARGET:
                // 印刷対象
                pstrBtnName = self.printAllSheetsOn ? S_PRINT_WHAT_ALL : S_PRINT_WHAT_SELECTED;
                pstrLabelName = S_BUTTON_PRINT_WHAT_IPAD;        //印刷対象
                pstrIconName = S_ICON_PRINTTARGET;
                break;
            case BUTTON_RETENTION:
                pstrBtnName = self.noPrintOn ? S_RETENTION_HOLDON : S_RETENTION_HOLDOFF;
                pstrLabelName = S_BUTTON_RETENTION_IPAD;     //リテンション
                pstrIconName = S_ICON_RETENTION;
                break;
            case BUTTON_PRINTRELEASE:
                pstrBtnName = self.printReleaseOn ? S_PRINTRELEASE_ENABLE : S_PRINTRELEASE_DISABLE;
                pstrLabelName = S_BUTTON_PRINTRELEASE_IPAD;   //プリントリリース
                pstrIconName = S_ICON_PRINTRELEASE;
                break;
            case BUTTON_PRINT:
                pstrBtnName = S_BUTTON_PRINTOUT_IPAD;
                pstrLabelName = @"";
                pstrIconName = S_ICON_PRINT_PRINTOUT;
                break;
            default:
                break;
        }
        [super CreateMenu:i+1 btnName:pstrBtnName iconName:pstrIconName lblName:pstrLabelName];
        
        if (i != 0 && i != ([buttonIdArray count] - 1)) {
            // メニューボタンをスクロールビュー内に配置し直す
            [self replaceMenuButton:i];
        }
    }
    
    // メニュースクロールビューの設定
    self.menuScrollView.delegate = self;
    DLog(@"%ld",(long)nPreMenuBtnMaxID);
    
    UIButton* lastButton = [self getUIButtonByIndex:[buttonIdArray count] - 2]; // 印刷の上のボタン
    self.menuScrollView.contentSize = (CGSize){self.menuScrollView.frame.size.width, lastButton.frame.origin.y + lastButton.frame.size.height};
    
    self.menuScrollView.bounces = NO;
    [self scrollViewDidScroll:self.menuScrollView animated:NO];
    
    // メニューのビューを指定
    m_pMenuView = self.menuScrollView;
    
    // 選択可能なプリンターが存在しない場合
    if (printerData == nil) {
        // 折り返し表示
        UIButton* button = [self getUIButtonByIndex:[self getButtonIndex:BUTTON_PRINTER]];
        button.titleLabel.lineBreakMode = NSLineBreakByWordWrapping;
        button.titleLabel.font = [UIFont systemFontOfSize:N_BUTTON_FONT_SIZE_LITTLE];
    }
    
    // 他アプリで開くの文言が長い場合は2行にする
    UIButton* otherButton = [self getUIButtonByIndex:[self getButtonIndex:BUTTON_OTHERAPP]];
    if ([otherButton.titleLabel.text length] > 15) {
        otherButton.titleLabel.lineBreakMode = NSLineBreakByWordWrapping;
        otherButton.titleLabel.numberOfLines = 2;
        otherButton.titleLabel.font = [UIFont systemFontOfSize:10];
    }
    
}

// メニューをスクロールビュー内に再配置する
- (void)replaceMenuButton:(NSInteger)buttonId {
    UIButton* btn = [self getUIButtonByIndex:buttonId];
    UILabel* lbl = [self getUILabelByIndex:buttonId];
    UIImageView* img = [self getUIImageViewByIndex:buttonId];
    
    if (btn) {
        // ボタンを再配置
        [self replaceToScrollView:btn];
        DLog(@"btn.frame:%@", NSStringFromCGRect(btn.frame));
    }
    if (lbl) {
        // ラベルを再配置
        [self replaceToScrollView:lbl];
        DLog(@"lbl.frame:%@", NSStringFromCGRect(lbl.frame));
    }
    if (img) {
        // アイコンを再配置
        [self replaceToScrollView:img];
        DLog(@"img.frame:%@", NSStringFromCGRect(img.frame));
    }
}

- (void)replaceToScrollView:(UIView*)view {
    if (view) {
        // ボタンを現在の位置から削除
        [view removeFromSuperview];
        
        // スクロールビューに配置
        CGRect viewRect = view.frame;
        viewRect.origin.x -= self.menuScrollView.frame.origin.x;
        viewRect.origin.y -= self.menuScrollView.frame.origin.y;
        [view setFrame:viewRect];
        [self.menuScrollView addSubview:view];
    }
}

// 画面表示前処理
- (void)viewWillAppear:(BOOL)animated {
    
    // Webページ印刷画面から遷移してきた場合
    // 戻るボタンを表示する
    BOOL hidesBackButton = ![super isMoveWebPagePrint];
    
    if (hidesBackButton) {
        hidesBackButton = ![super isMoveAttachmentMail];
    }
    
    // メインビュー初期化
    // 戻るボタンの名称変更
    UIBarButtonItem * barItemBack = [UIBarButtonItem new];
    barItemBack.title = S_BUTTON_BACK;
    self.navigationItem.backBarButtonItem = barItemBack;
    [super InitView:[CommonUtil getSSID] menuBtnNum:nPreMenuBtnMaxID hidesBackButton:hidesBackButton hidesSettingButton:NO setHiddenNoImage:NO];
    [super viewWillAppear:animated];
    NSString* pstrInitValue = S_BUTTON_NO_PRINTER;
    
    // スクロールボタンの表示/非表示
    [self scrollViewDidScroll:self.menuScrollView animated:NO];
    
    // プリンタ情報取得
    PrinterData* printerData = nil;
    
    //プリンタ情報更新
    // 最新プライマリキー取得
    NSString* pstrKey;
    // 接続先WiFiの最新プライマリキー取得
    NSString* pstrKeyForCurrentWiFi;
    
    //プリンタ情報更新
    m_pPrinterMgr.PrinterDataList = [m_pPrinterMgr ReadPrinterData];
    // 最新プライマリキー取得
    pstrKey = [m_pPrintOutMgr GetLatestPrimaryKey];
    pstrKeyForCurrentWiFi = [m_pPrintOutMgr GetLatestPrimaryKeyForCurrentWiFi];
    // 選択中MFP取得
    [m_pPrinterMgr SetDefaultMFPIndex:pstrKey PrimaryKeyForCurrrentWifi:pstrKeyForCurrentWiFi];
    // 選択中MFP情報取得
    
    NSInteger num = [m_pPrinterMgr GetPrinterIndexForKey:selectedPrinterPrimaryKey];
    PrinterData* printer1;
    if(num >= 0 ) {
        printer1 = [m_pPrinterMgr LoadPrinterDataAtIndexInclude2:num];
    } else {
        printer1 = nil;
    }
    if (printer1!=nil) {
        // 選ばれてたMFPがまだある場合、そのMFPを選ぶ
        printerData = printer1;
        [self setSelPickerRowWithIndex:BUTTON_PRINTER andRow:[m_pPrinterMgr GetPrinterIndexForKey:printerData.PrimaryKey]];
    } else {
        PrinterData* defaultPrinter = [m_pPrinterMgr LoadPrinterDataAtIndexInclude2:m_pPrinterMgr.DefaultMFPIndex];
        if(defaultPrinter != nil) {
            // なくなってたら、デフォルトMFPを選ぶ
            printerData = defaultPrinter;
            [self setSelPickerRowWithIndex:BUTTON_PRINTER andRow:[m_pPrinterMgr GetPrinterIndexForKey:printerData.PrimaryKey]];
        } else {
            // 一つもない場合は、「ありません」にする
            printerData = nil;
        }
    }
    m_bButtonEnable = NO;
    if (printerData != nil)
    {
        pstrInitValue = [printerData getPrinterName];
        m_bButtonEnable = YES;
        
        selectedPrinterPrimaryKey = printerData.PrimaryKey;
    } else {
        selectedPrinterPrimaryKey = nil;
    }
    
    // 前回選択されていたプリンタと今回選択されているプリンタ情報が変わっているかどうか判定
    // ---> 設定画面から戻った場合に毎回プリンター情報を取得しにいくように仕様変更(通信処理のキャンセルにて)
    // ---> 設定画面の閉じるボタン押下時の通知イベント処理にてフラグを立てるように変更
    //if (![m_strBeforeSelectedPrimaryKey isEqualToString:selectedPrinterPrimaryKey]) {
    //m_isShoudRemakeMenuButton = YES;
    //m_strBeforeSelectedPrimaryKey = selectedPrinterPrimaryKey;
    //}
    
    UIButton* printerButton = [self getUIButtonByIndex:[self getButtonIndex:BUTTON_PRINTER]];
    [printerButton setTitle:pstrInitValue forState:UIControlStateNormal];
    
    // 通信中でない場合はボタンの活性化処理
    if (!self.isDuringCommProcess
        || self.PrintPictViewID == PPV_PRINT_MAIL_ATTACHMENT_CELL) {
        
        // ボタン活性処理
        for (int i = 0; i < [buttonIdArray count]; i++) {
            UIButton* button = [self getUIButtonByIndex:i];
            [button setEnabled:YES];
        }
        
        printerButton.titleLabel.lineBreakMode = NSLineBreakByTruncatingTail;
        printerButton.titleLabel.font = [UIFont systemFontOfSize:N_BUTTON_FONT_SIZE_DEFAULT];
        printerButton.titleLabel.adjustsFontSizeToFitWidth = YES;
        if (![S_LANG isEqualToString:S_LANG_JA]) {
            // 海外版の場合
            printerButton.titleLabel.minimumScaleFactor = N_BUTTON_FONT_SIZE_DEFAULT / printerButton.titleLabel.font.pointSize;
        } else {
            // 国内版の場合、表示文字を小さくする
            printerButton.titleLabel.minimumScaleFactor = 12 / printerButton.titleLabel.font.pointSize;
        }
        
        //　両面印刷ボタンの活性/非活性
        [self setDuplexBtnEnabled];
        
        // リテンションボタン、プリントリリースボタン活性非活性
        [self setRetontionPrintReleaseBtnEnabled];
        
        // ボタンを2行表示するかチェック
        UIButton* otherButton = [self getUIButtonByIndex:[self getButtonIndex:BUTTON_OTHERAPP]];
        [m_pCmnMgr btnTwoLineChange:otherButton];
        UIButton* printButton = [self getUIButtonByIndex:[self getButtonIndex:BUTTON_PRINT]];
        [m_pCmnMgr btnTwoLineChange:printButton];
        
        if (printerData == nil || ([self.selectFileArray count] == 0 && [self.selectPictArray count] == 0 && m_pstrFilePath == nil)) {
            if (([self.selectFileArray count] == 0 && [self.selectPictArray count] == 0 && m_pstrFilePath == nil)) {
                [otherButton setEnabled:NO];
            }
            for (int i = 0; i < [buttonIdArray count]; i++) {
                enum PRINTER_SETTING_BUTTON tmpButtonId = [[buttonIdArray objectAtIndex:i] intValue];
                if (tmpButtonId != BUTTON_OTHERAPP) {
                    UIButton* button = [self getUIButtonByIndex:i];
                    [button setEnabled:NO];
                }
            }
            // 折り返し表示
            printerButton.titleLabel.lineBreakMode = NSLineBreakByWordWrapping;
            printerButton.titleLabel.font = [UIFont systemFontOfSize:N_BUTTON_FONT_SIZE_LITTLE];
        }
        
        // ボタンの活性状態を変更する(Web印刷/メール印刷用)
        [self setBtnEnable];
        
    }
    
    
    if (self.m_isShoudRemakeMenuButton) {
        
        // 設定画面を閉じた場合でプリンターがある場合
        PrinterData *printerData = [m_pPrinterMgr LoadPrinterDataAtIndexInclude2:[self getSelPickerRowWithIndex:BUTTON_PRINTER]];
        if (printerData != nil) {
            
            SharpScanPrintAppDelegate* appDelegate = (SharpScanPrintAppDelegate*)[[UIApplication sharedApplication] delegate];
            // 処理実行フラグON
            appDelegate.IsRun = TRUE;
            [self setBtnEnabledForCancelRsMng]; // ボタン非活性
            [self setDuringCommProcessValues:YES];
            // 接続中メッセージ表示
            [self popupMessageAlert:MSG_PRINTEROPTION_GET];
            
            [self callCommunicationProcessing];
        }
    }
    
    //フラグ
    self.m_isShoudRemakeMenuButton = NO;
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    // 初回
    if (self.isAddedPattern == NO) {
        
        // Web印刷とメール印刷の場合でデータがない場合は処理しない
        //if(!((self.PrintPictViewID == WEB_PRINT_VIEW || self.PrintPictViewID == EMAIL_PRINT_VIEW) && arrThumbnails == nil)) {
        
        PrinterData *printerData = [m_pPrinterMgr LoadPrinterDataAtIndexInclude2:[self getSelPickerRowWithIndex:BUTTON_PRINTER]];
        if (printerData != nil) {
            
            SharpScanPrintAppDelegate* appDelegate = (SharpScanPrintAppDelegate*)[[UIApplication sharedApplication] delegate];
            // 処理実行フラグON
            appDelegate.IsRun = TRUE;
            if (self.PrintPictViewID == WEB_PRINT_VIEW || self.PrintPictViewID == EMAIL_PRINT_VIEW) {
                [self setBtnEnabledForCancelRsMngForWebMailFirst];
            }else {
                [self setBtnEnabledForCancelRsMng]; // ボタン非活性
            }
            self.isDuringCommProcess = YES;
            // 接続中メッセージ表示
            [self popupMessageAlert:MSG_PRINTEROPTION_GET];
            
            [self callCommunicationProcessing];
        }
        //}
        
    }
    _isNotFirstViewDidAppear = YES;
    
    self.isAddedPattern = NO;
    
    
}

// 画面非表示前処理
- (void)viewWillDisappear:(BOOL)animated {
    
    //デフォルト処理
    [super viewWillDisappear:animated];
    
    // プリンター情報取得通信処理キャンセル
    [self stopCommProcess];
    
    //スレッド終了
    [self StopThread];
}

-(void)viewDidDisappear:(BOOL)animated
{
    m_diCtrl.delegate = nil;
    [m_diCtrl dismissMenuAnimated:NO];
    
    [super viewDidDisappear:animated];
    
}

- (void)viewDidUnload {
    [super viewDidUnload];
    if (nil != m_pCmnMgr) {
        // PJL削除
        [m_pCmnMgr removeFile:self.PjlFileName];
        m_pCmnMgr = nil;
    }
    if (nil != m_pPrinterMgr) {
        m_pPrinterMgr = nil;
    }
    if (nil != m_pPrintOutMgr) {
        m_pPrintOutMgr = nil;
    }
    if (nil != m_pPJLDataMgr) {
        m_pPJLDataMgr = nil;
    }
    if (nil != m_pLblNoImage) {
        m_pLblNoImage = nil;
    }
    if (nil != m_pImgViewNoImage) {
        m_pImgViewNoImage = nil;
    }
    self.menuScrollView = nil;
    menuUpBtn = nil;
    menuDownBtn = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Popoverが表示されていたら閉じる
    [m_popOver dismissPopoverAnimated:NO];
    return YES;
}

- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)FromInterfaceOrientation {
    [super didRotateFromInterfaceOrientation:FromInterfaceOrientation];
    // Popオーバーが開いていたらアニメーションなしで閉じる
    [m_popOver dismissPopoverAnimated:NO];
    [self.viewPopoverController dismissPopoverAnimated:NO];
    // スクロールボタンの判定
    [self scrollViewDidScroll:self.menuScrollView animated:NO];
}

// スレッド
// 実行スレッド
- (void)ActionThread {
    if (!m_bAbort) {
        // TempフォルダにPhotoLibraryで選択したファイルを保存
        if (self.IsPhotoView) {
            [self getPictureFromPhotoLibrary];
        } else {
            DLog(@"selFilePath:%@",self.SelFilePath);
            self.IsPrintPictView = YES;
            //ファイル表示
            [super ShowFile:self.SelFilePath];
        }
        if ((self.PrintPictViewID != WEB_PRINT_VIEW && self.PrintPictViewID != EMAIL_PRINT_VIEW)) {
            if (!self.isDuringCommProcess) {
                // 他アプリで確認ボタンは活性状態にする。
                UIButton* button = [self getUIButtonByIndex:[self getButtonIndex:BUTTON_OTHERAPP]];
                [button setEnabled:YES];
            }
        }
    }
    m_bFinLoad = FALSE;
    PrinterData* printerData = nil;
    printerData = [m_pPrinterMgr LoadPrinterDataAtIndexInclude2:[self getSelPickerRowWithIndex:BUTTON_PRINTER]];
    
    if(self.PrintPictViewID == WEB_PRINT_VIEW || self.PrintPictViewID == EMAIL_PRINT_VIEW)
    {
        SharpScanPrintAppDelegate *pAppDelegate = (SharpScanPrintAppDelegate *)[[UIApplication sharedApplication]delegate];
        // 左側のViewを取得
        UINavigationController *pRootNavController = [pAppDelegate.splitViewController.viewControllers objectAtIndex:0];
        
        if ([[pRootNavController.viewControllers lastObject] isKindOfClass:[PrintSelectTypeViewController_iPad class]]) {
            [self performSelector:@selector(OnClickPageAddButton:) withObject:nil afterDelay:0.1];
        }
    } else {
        if (printerData == nil) {
            if (m_bResult) {
                [self CreateNoPrinterAlert];
            }
        }
    }
}

// ALAssetsLibraryからの画像取得を同期化し、getmibをしないようにしました。
- (void)getPictureFromPhotoLibraryForSync
{
    if (isIOS8_1Later) {
        [self getPictureForSyncByPhotos];
        return;
    }
    
    dispatch_semaphore_t sema = dispatch_semaphore_create(0);
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    
    NSURL *referenceURL = [self.PictEditInfo objectForKey:UIImagePickerControllerReferenceURL];
    ALAssetsLibrary *library = [[ALAssetsLibrary alloc]init];
    DLog(@"referenceURL %@",referenceURL);
    __block BOOL foundTheAsset = NO;
    dispatch_async(queue, ^{
        [library assetForURL:referenceURL resultBlock:^(ALAsset *asset) {
            if (asset) {
                foundTheAsset = YES;
                [self createPictureFromAsset:asset :NO];
                
                dispatch_semaphore_signal(sema);
            } else {
                [library enumerateGroupsWithTypes:ALAssetsGroupPhotoStream
                                       usingBlock:^(ALAssetsGroup *group, BOOL *stop)
                 {
                     //ALAssetsLibraryのすべてのアルバムが列挙される
                     if (group) { // まずはフォトストリームを探す
                         DLog(@"group: %@",[group description]);
                         //アルバム(group)からALAssetの取得
                         [group enumerateAssetsUsingBlock:^(ALAsset *result, NSUInteger index, BOOL *stop) {
                             if (result) {
                                 NSDictionary *dic = [result valueForProperty:ALAssetPropertyURLs];
                                 NSString *url = [[dic valueForKey:[[dic allKeys] objectAtIndex:0]] absoluteString];
                                 LOG(@"url    : %@",url);
                                 LOG(@"refURL : %@",referenceURL);
                                 if ([[referenceURL absoluteString] isEqualToString:url]) {
                                     [self createPictureFromAsset:result :NO];
                                     foundTheAsset = YES;
                                     *stop = YES;
                                     
                                     dispatch_semaphore_signal(sema);
                                 }
                             }
                         }];
                         if (foundTheAsset) {
                             *stop = YES;
                         }
                     } else { // フォトストリームにもない場合はフォトストリーム以外のアルバムも探す
                         if (!foundTheAsset) {
                             [library enumerateGroupsWithTypes:ALAssetsGroupAll
                                                    usingBlock:^(ALAssetsGroup *group, BOOL *stop)
                              {
                                  //ALAssetsLibraryのすべてのアルバムが列挙される
                                  DLog(@"group: %@",[group description]);
                                  if (group) {
                                      if ([[group valueForProperty:@"ALAssetsGroupPropertyType"] integerValue] != ALAssetsGroupPhotoStream) {
                                          
                                          //アルバム(group)からALAssetの取得
                                          [group enumerateAssetsUsingBlock:^(ALAsset *result, NSUInteger index, BOOL *stop) {
                                              if (result) {
                                                  NSDictionary *dic = [result valueForProperty:ALAssetPropertyURLs];
                                                  NSString *url = [[dic valueForKey:[[dic allKeys] objectAtIndex:0]] absoluteString];
                                                  LOG(@"url    : %@",url);
                                                  LOG(@"refURL : %@",referenceURL);
                                                  if ([[referenceURL absoluteString] isEqualToString:url]) {
                                                      [self createPictureFromAsset:result :NO];
                                                      foundTheAsset = YES;
                                                      *stop = YES;
                                                      
                                                      dispatch_semaphore_signal(sema);
                                                  }
                                              }
                                          }];
                                      }
                                  }
                              } failureBlock:nil];
                         }
                     }
                 } failureBlock:nil];
            }
        } failureBlock:^(NSError *error) {
            [super ShowFile:self.SelFilePath];
            DLog(@"failureBlock %@",error);
            dispatch_semaphore_signal(sema);
        }];
    });
    
    dispatch_semaphore_wait(sema, DISPATCH_TIME_FOREVER);
}

//PhotoLibraryアクセス用の実行スレッド
- (void)getPictureFromPhotoLibrary {

    if (isIOS8_1Later) {
        [self getPictureByPhotos];
        return;
    }
    
    NSURL *referenceURL = [self.PictEditInfo objectForKey:UIImagePickerControllerReferenceURL];
    ALAssetsLibrary *library = [[ALAssetsLibrary alloc]init];
    DLog(@"referenceURL %@",referenceURL);
    __block BOOL foundTheAsset = NO;
    [library assetForURL:referenceURL resultBlock:^(ALAsset *asset) {
        if (asset) {
            foundTheAsset = YES;
            [self createPictureFromAsset:asset];
            if(m_isDoSnmp) {
                // 機器検索
                [self performSelectorInBackground:@selector(getMib) withObject:nil];
            }
        } else {
            [library enumerateGroupsWithTypes:ALAssetsGroupPhotoStream
                                   usingBlock:^(ALAssetsGroup *group, BOOL *stop)
             {
                 //ALAssetsLibraryのすべてのアルバムが列挙される
                 if (group) { // まずはフォトストリームを探す
                     DLog(@"group: %@",[group description]);
                     //アルバム(group)からALAssetの取得
                     [group enumerateAssetsUsingBlock:^(ALAsset *result, NSUInteger index, BOOL *stop) {
                         if (result) {
                             NSDictionary *dic = [result valueForProperty:ALAssetPropertyURLs];
                             NSString *url = [[dic valueForKey:[[dic allKeys] objectAtIndex:0]] absoluteString];
                             LOG(@"url    : %@",url);
                             LOG(@"refURL : %@",referenceURL);
                             if ([[referenceURL absoluteString] isEqualToString:url]) {
                                 [self createPictureFromAsset:result];
                                 foundTheAsset = YES;
                                 *stop = YES;
                                 if(m_isDoSnmp) {
                                     // 機器検索
                                     [self performSelectorInBackground:@selector(getMib) withObject:nil];
                                 }
                             }
                         }
                     }];
                     if (foundTheAsset) {
                         *stop = YES;
                     }
                 } else { // フォトストリームにもない場合はフォトストリーム以外のアルバムも探す
                     if (!foundTheAsset) {
                         [library enumerateGroupsWithTypes:ALAssetsGroupAll
                                                usingBlock:^(ALAssetsGroup *group, BOOL *stop)
                          {
                              //ALAssetsLibraryのすべてのアルバムが列挙される
                              DLog(@"group: %@",[group description]);
                              if (group) {
                                  if ([[group valueForProperty:@"ALAssetsGroupPropertyType"] integerValue] != ALAssetsGroupPhotoStream) {
                                      
                                      //アルバム(group)からALAssetの取得
                                      [group enumerateAssetsUsingBlock:^(ALAsset *result, NSUInteger index, BOOL *stop) {
                                          if (result) {
                                              NSDictionary *dic = [result valueForProperty:ALAssetPropertyURLs];
                                              NSString *url = [[dic valueForKey:[[dic allKeys] objectAtIndex:0]] absoluteString];
                                              LOG(@"url    : %@",url);
                                              LOG(@"refURL : %@",referenceURL);
                                              if ([[referenceURL absoluteString] isEqualToString:url]) {
                                                  [self createPictureFromAsset:result];
                                                  foundTheAsset = YES;
                                                  *stop = YES;
                                                  if(m_isDoSnmp) {
                                                      // 機器検索
                                                      [self performSelectorInBackground:@selector(getMib) withObject:nil];
                                                  }
                                              }
                                          }
                                      }];
                                  }
                              }
                          } failureBlock:nil];
                     }
                 }
             } failureBlock:nil];
        }
    } failureBlock:^(NSError *error) {
        [super ShowFile:self.SelFilePath];
        DLog(@"failureBlock %@",error);
    }];
}

- (void)createPictureFromAsset :(ALAsset*)asset {
    [self createPictureFromAsset:asset :YES];
}
- (void)createPictureFromAsset :(ALAsset*)asset
                               :(BOOL) show {
    ALAssetRepresentation *representation = [asset defaultRepresentation];
    NSUInteger size = [representation size];
    uint8_t *buff = (uint8_t *)malloc(sizeof(uint8_t)*size);
    if (buff != nil) {
        NSError *error = nil;
        NSUInteger bytesRead = [representation getBytes:buff fromOffset:0 length:size error:&error];
        if (bytesRead && !error) {
            
            NSData *data = [NSData dataWithBytesNoCopy:buff length:bytesRead freeWhenDone:YES];
            
            NSString *filename = [[asset defaultRepresentation]filename];
            
            TempFile *localTempFile = [[TempFile alloc] initWithFileName:filename];
            [TempFileUtility deleteFile:localTempFile];
            [data writeToFile:localTempFile.tempFilePath atomically:YES];
            self.SelFilePath = localTempFile.tempFilePath;
            DLog(@"%@",self.SelFilePath);
            [TempFileUtility createRequiredAllImageFiles:localTempFile];
            
            if(show) {
                [super ShowFile:self.SelFilePath];
            }
            
        } else {
            free(buff);
        }
        if (error) {
            DLog(@"error %@",error);
        }
    }
}

- (void)createCache:(id)sender {
    @autoreleasepool {
        m_bCreateCache = FALSE;
        [GeneralFileUtility createCacheFile:self.SelFilePath];
        [super ShowFile:self.SelFilePath];
    }
}

- (void)getPictureForSyncByPhotos
{
    // PHAssetを取得する
    PHAsset *phAsset = [self.PictEditInfo objectForKey:@"PHAsset"];
    
    // TempFileを作成する
    [self createPictureFromAssetByPhotos:phAsset show:NO];
}

- (void)getPictureByPhotos
{
    // PHAssetを取得する
    PHAsset *phAsset = [self.PictEditInfo objectForKey:@"PHAsset"];
    
    // TempFileを作成する
    [self createPictureFromAssetByPhotos:phAsset];
    
    // プリンター通信を行う
    if(m_isDoSnmp) {
        [self performSelectorInBackground:@selector(getMib) withObject:nil];
    }
}

- (void)createPictureFromAssetByPhotos :(PHAsset*)asset
{
    [self createPictureFromAssetByPhotos:asset show:YES];
}

- (void)createPictureFromAssetByPhotos :(PHAsset*)asset
                                       show:(BOOL) show {
    
    // ファイル名
    __block NSString *filename;
    // ファイルサイズ
    __block NSUInteger size;
    // 画像データ抽出用
    __block NSData *data;
    
    PHImageRequestOptions *options = [[PHImageRequestOptions alloc] init];
    options.synchronous = YES;
    
    //ファイル名とファイルサイズを取得する
    [[PHImageManager defaultManager] requestImageDataForAsset:asset options:options resultHandler:^(NSData *imageData, NSString *dataUTI, UIImageOrientation orientation, NSDictionary *info) {
        
        //ファイル名
        filename = [[info objectForKey:@"PHImageFileURLKey"] lastPathComponent];
        //ファイルサイズ
        size = imageData.length;
        // 画像データ抽出
        data = imageData;
    }];
    
    uint8_t *buff = (uint8_t *)malloc(sizeof(uint8_t)*size);
    if(buff != nil)
    {
        NSUInteger bytesRead = size;
        if(bytesRead)
        {
            TempFile *localTempFile = [[TempFile alloc] initWithFileName:filename];
            [TempFileUtility deleteFile:localTempFile];
            [data writeToFile:localTempFile.tempFilePath atomically:YES];
            self.SelFilePath = localTempFile.tempFilePath;
            DLog(@"%@",self.SelFilePath);
            [TempFileUtility createRequiredAllImageFiles:localTempFile];
            
            if(show) {
                [super ShowFile:self.SelFilePath];
            }
        }
        else
        {
            free(buff);
        }
    }
}

#pragma mark - Button Action
// ボタン押下関数
// メニューボタン１(他アプリに送る)押下
- (IBAction)OnMenuFirstButton:(id)sender {
    
    [self OnMenuButtonActionByIndex:sender index:0];
}

// メニューボタン２押下
- (IBAction)OnMenuSecondButton:(id)sender {
    
    [self OnMenuButtonActionByIndex:sender index:1];
}

// メニューボタン３押下
- (IBAction)OnMenuThirdButton:(id)sender {
    
    [self OnMenuButtonActionByIndex:sender index:2];
}

// メニューボタン４押下
- (IBAction)OnMenuFourthButton:(id)sender {
    
    [self OnMenuButtonActionByIndex:sender index:3];
}

// メニューボタン5押下
- (IBAction)OnMenuFifthButton:(id)sender {
    
    [self OnMenuButtonActionByIndex:sender index:4];
}

// メニューボタン6押下
- (IBAction)OnMenuSixthButton:(id)sender {
    
    [self OnMenuButtonActionByIndex:sender index:5];
}

// ボタン押下関数
// メニューボタン7押下
- (IBAction)OnMenuSeventhButton:(id)sender {
    [self OnMenuButtonActionByIndex:sender index:6];
}

// メニューボタン8押下
- (IBAction)OnMenuEighthButton:(id)sender {
    [self OnMenuButtonActionByIndex:sender index:7];
}

// メニューボタン9押下
- (IBAction)OnMenuNinthButton:(id)sender {
    [self OnMenuButtonActionByIndex:sender index:8];
}

// メニューボタン10押下
- (IBAction)OnMenuTenthButton:(id)sender {
    [self OnMenuButtonActionByIndex:sender index:9];
}

// メニューボタン11押下
- (IBAction)OnMenuEleventhButton:(id)sender {
    [self OnMenuButtonActionByIndex:sender index:10];
}

// メニューボタン12押下
- (IBAction)OnMenuTwelvethButton:(id)sender {
    [self OnMenuButtonActionByIndex:sender index:11];
}

// メニューボタン13押下
- (IBAction)OnMenuThirteenthButton:(id)sender {
    [self OnMenuButtonActionByIndex:sender index:12];
}


// 印刷するボタン押下時のアクション
- (void)PrintBtnAction
{
    
//    //フラグリセット
//    self.canPrintPDF = NO;
//    _printCancelled = NO;
    
    // 処理中、処理中断フラグ=TRUE、あるいはファイル送信中の場合は何もしない
    if (m_pThread || m_bAbort || m_bSendFile) {
        return;
    }
    
    SharpScanPrintAppDelegate *appDelegate = (SharpScanPrintAppDelegate *)[[UIApplication sharedApplication] delegate];
    appDelegate.IsRun = TRUE;
    
    m_isPrintStop = FALSE;
    m_isCacel = FALSE;
    m_isStopSend = FALSE;
    m_isStop = FALSE;
    
    // IP アドレスチェック
    NSString *strIpaddr	= [CommonUtil getIPAdder];
    NSUInteger len = [[strIpaddr stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] length];
    if (len <= 0) {
        m_isPrintStop = TRUE;
        [self CreateAllert:nil message:MSG_NETWORK_ERR btnTitle:MSG_BUTTON_OK];
        return;
    }
    
    // プリンタ情報が取得できなければ何もしない
    PrinterData* printerData = nil;
    printerData = [m_pPrinterMgr LoadPrinterDataAtIndexInclude2:[self getSelPickerRowWithIndex:BUTTON_PRINTER]];
    
    if (printerData == nil) {
        m_isPrintStop = TRUE;
        [self CreateAllert:nil message:MSG_PRINT_REQ_ERR btnTitle:MSG_BUTTON_OK];
        return;
    }
    
    if (nil == self.m_pstrNumSets) {
        self.m_pstrNumSets = @"1";
    }
    if (nil == self.m_pstrSide) {
        self.m_pstrSide = S_ONE_SIDE;
        [self setSelPickerRowWithIndex:BUTTON_DUPLEX andRow:E_ONE_SIDE];
    }
    [self CreateAllert:nil message:MSG_PRINT_CONFIRM btnTitle:MSG_BUTTON_CANCEL withTag:ALERT_TAG_PRINT_CONFIRM];//確認アラート
}

// 他アプリで確認ボタン押下時のアクション
- (void)otherAppBtnAction {
    
    DLog(@"送るボタン押下");
    //表示中の画像は前画面で選択したファイル。
    NSString *urlString = self.SelFilePath;
    
    m_diCtrl = [UIDocumentInteractionController interactionControllerWithURL:[NSURL fileURLWithPath:urlString]];
    m_diCtrl.delegate = self;
    
    //UIButton *btn = (UIButton *)sender;
    NSInteger btnIndex = [self getButtonIndex:BUTTON_OTHERAPP];
    UIButton *btn = [self getUIButtonByIndex:btnIndex];
    
    BOOL isShow = [m_diCtrl presentOpenInMenuFromRect:btn.frame inView:self.view animated:YES];
    if (!isShow) {
        //ひとつも対応するアプリがない場合
        DLog(@"isShow:False");
        SharpScanPrintAppDelegate *appDelegate = (SharpScanPrintAppDelegate *)[[UIApplication sharedApplication] delegate];
        // 処理実行フラグON
        appDelegate.IsRun = TRUE;
        // エラーメッセージ表示
        [self CreateAllert:nil message:MSG_NO_SEND_APP btnTitle:MSG_BUTTON_OK];
    }
    
}


// プリンター選択ボタン押下時のアクション
- (void)printerBtnAction {
    
    // プリンタ数が０の場合は何もしない
    if ([m_pPrinterMgr CountOfPrinterData] == 0 && [m_pPrintServerMgr CountOfPrinterData] == 0) {
        return;
    }
    
    // プリンタ一覧
    PrinterData* printerData = nil;
    NSMutableArray* parrPickerRow = [[NSMutableArray alloc] initWithCapacity:[m_pPrinterMgr CountOfPrinterDataInclude]];
    
    for (NSInteger nIndex = 0; nIndex < [m_pPrinterMgr CountOfPrinterDataInclude]; nIndex++) {
        printerData = [m_pPrinterMgr LoadPrinterDataAtIndexInclude2:nIndex];
        [parrPickerRow addObject:[printerData getPrinterName]];
    }
    
    // プリントサーバー一覧
    NSMutableArray* parrPickerRow2 = [[NSMutableArray alloc] initWithCapacity:[m_pPrintServerMgr CountOfPrinterDataInclude]];
    
    for (NSInteger nIndex = 0; nIndex < [m_pPrintServerMgr CountOfPrinterDataInclude]; nIndex++)
    {
        printerData = [m_pPrintServerMgr LoadPrinterDataAtIndexInclude2:nIndex];
        [parrPickerRow2 addObject:[printerData getPrinterName]];
    }
    
    [self callShowPickerView:BUTTON_PRINTER andPickerItems:parrPickerRow andPickerItems2:parrPickerRow2];
    
    
}

// 部数ボタン押下時のアクション
- (void)numBtnAction {
    
    NSInteger nMaxCount = 9;
    NSMutableArray *parrPickerRow = [[NSMutableArray alloc] initWithCapacity:nMaxCount];
    for (NSInteger nIndex = 0; nIndex <= nMaxCount; nIndex++) {
        [parrPickerRow addObject:[[NSString alloc]initWithFormat:@"%ld", (long)nIndex]];
    }
    
    // ピッカー表示
    [self callShowPickerView:BUTTON_NUM andPickerItems:parrPickerRow];
    
}

// 両面/片面ボタン押下時のアクション
- (void)duplexBtnAction {
    
    // 片面/両面設定
    NSMutableArray *parrPickerRow = [[NSMutableArray alloc]initWithCapacity:3];
    [parrPickerRow addObject:S_ONE_SIDE];
    [parrPickerRow addObject:S_DUPLEX_SIDE_LONG];
    [parrPickerRow addObject:S_DUPLEX_SIDE_SHORT];
    
    // ピッカー表示
    [self callShowPickerView:BUTTON_DUPLEX andPickerItems:parrPickerRow];
    
}

// カラーモードボタン押下時のアクション
- (void)colorModeBtnAction {
    
    NSMutableArray* parrPickerRow;
    if(self.PrintPictViewID == EMAIL_PRINT_VIEW){
        // メール本文印刷時は、自動を表示しない
        parrPickerRow = [[NSMutableArray alloc] initWithCapacity:2];
        [parrPickerRow addObject:S_PRINT_COLORMODE_COLOR];
        [parrPickerRow addObject:S_PRINT_COLORMODE_BW];
    } else {
        parrPickerRow = [[NSMutableArray alloc] initWithCapacity:3];
        [parrPickerRow addObject:S_PRINT_COLORMODE_AUTO];
        [parrPickerRow addObject:S_PRINT_COLORMODE_COLOR];
        [parrPickerRow addObject:S_PRINT_COLORMODE_BW];
    }
    
    // ピッカー表示
    [self callShowPickerView:BUTTON_COLOR andPickerItems:parrPickerRow];
    
}

// 用紙サイズボタン押下時のアクション
- (void)paperSizeBtnAction {
    
    NSMutableArray *parrPickerRow = [self getPaperSizeArray];
    
    m_pArrPapersize = [self getPaperSizePJLArray];
    
    // ピッカー表示
    [self callShowPickerView:BUTTON_PAPERSIZE andPickerItems:parrPickerRow];
    
}

// 用紙タイプボタン押下時のアクション
- (void)PaperTypeBtnAction {
    
    // ピッカーに表示する項目を格納
    NSMutableArray* parrPickerRow = [self getPaperTypeItems];
    
    // ピッカー表示
    [self callShowPickerView:BUTTON_PAPERTYPE andPickerItems:parrPickerRow];
    
}

// 仕上げボタン押下時のアクション
- (void)finishingBtnAction {
    
    // 画面遷移
    FinishingViewController* pFinishingViewController;
    pFinishingViewController = [[FinishingViewController alloc] initWithStyle:UITableViewStyleGrouped];
    pFinishingViewController.delegate = self;
    
    // とじ位置
    NSMutableArray *parrClosingPickerRow = [[NSMutableArray alloc] init];
    switch ([self getSelPickerRowWithIndex:BUTTON_DUPLEX]) {
        default:
        case E_ONE_SIDE:
            [parrClosingPickerRow addObject:S_PRINT_BINDINGEDGE_LEFT];
            [parrClosingPickerRow addObject:S_PRINT_BINDINGEDGE_RIGHT];
            [parrClosingPickerRow addObject:S_PRINT_BINDINGEDGE_TOP];
            break;
        case E_DUPLEX_SIDE_LONG:
            [parrClosingPickerRow addObject:S_PRINT_BINDINGEDGE_LEFT];
            [parrClosingPickerRow addObject:S_PRINT_BINDINGEDGE_RIGHT];
            break;
        case E_DUPLEX_SIDE_SHORT:
            [parrClosingPickerRow addObject:S_PRINT_BINDINGEDGE_TOP];
            break;
    }
    pFinishingViewController.m_parrClosingPickerRow = parrClosingPickerRow;
    
    // ステープル
    NSMutableArray *parrStaplePickerRow = [PrintPictManager getSelectableStaple:self.staple andPaperSize:self.m_pstrPaperSize];
    pFinishingViewController.m_parrStaplePickerRow = parrStaplePickerRow;
    
    // パンチ
    NSMutableArray *parrPunchPickerRow = [PrintPictManager getSelectablePunch:self.punchData andPaperSize:self.m_pstrPaperSize];
    pFinishingViewController.m_parrPunchPickerRow = parrPunchPickerRow;
    
    // 選択中の行番号を設定
    pFinishingViewController.nClosingRow = self.nClosingRow;
    pFinishingViewController.nStapleRow = self.nStapleRow;
    pFinishingViewController.nPunchRow = self.nPunchRow;
    
    // ステープルの有効/無効判定(排他制御)
    if (self.isInvalidStaplePaperSize || self.isInvalidStaplePaperType) {
        pFinishingViewController.canStaple = NO;
    }
    else {
        pFinishingViewController.canStaple = YES;
    }
    
    // パンチの有効/無効判定(排他制御)
    if (self.isInvalidPunchPaperSize || self.isInvalidPunchPaperType) {
        pFinishingViewController.canPunch = NO;
    }
    else {
        pFinishingViewController.canPunch = YES;
    }
    
    // ステープル欄を表示有無
    if ([self visibleStaple]) {
        pFinishingViewController.noVisibleStaple = NO;
    } else {
        pFinishingViewController.noVisibleStaple = YES;
    }
    
    // パンチ欄を表示有無
    if ([self visiblePunch]) {
        pFinishingViewController.noVisiblePunch = NO;
    } else {
        pFinishingViewController.noVisiblePunch = YES;
    }
    
    // 押下されたボタンの位置取得
    UIButton* button = [self getUIButtonByIndex:[self getButtonIndex:BUTTON_FINISHING]];
    CGRect popoverRect = [self.view convertRect:[button frame]fromView:self.view];
    // Popオーバー表示
    UINavigationController *navigationController = [[UINavigationController alloc]initWithRootViewController:pFinishingViewController];
    UIPopoverController *popover = [[UIPopoverController alloc]initWithContentViewController: navigationController];
    self.viewPopoverController = popover;
    self.viewPopoverController.popoverContentSize = CGSizeMake(320, 500);
    [viewPopoverController presentPopoverFromRect:popoverRect inView:m_pMenuView permittedArrowDirections:UIPopoverArrowDirectionRight animated:YES];
}

// ステープル機能有無取得
-(BOOL)visibleStaple
{
    BOOL bRet = YES;
    
    switch (self.staple) {
        case STAPLE_ERR:
            bRet = NO;
            break;
        case STAPLE_NONE:
            bRet = NO;
            break;
        case STAPLE_ONE:
            break;
        case STAPLE_TWO:
            break;
        case STAPLE_NONE_STAPLELESS:
            break;
        case STAPLE_ONE_STAPLELESS:
            break;
        case STAPLE_TWO_STAPLELESS:
            break;
    }
    
    return bRet;
}

// パンチ機能有無取得
-(BOOL)visiblePunch
{
    BOOL bRet = YES;
    
    // ステープル未対応
    if (self.punchData == nil || self.punchData.canPunch == NO) {
        bRet = NO;
    }
    
    return bRet;
}

// N-Upボタンを押下時のアクション
- (void)NUpBtnAction {
    // 画面遷移
    NUpViewController *pNUpViewController;
    pNUpViewController = [[NUpViewController alloc]initWithStyle:UITableViewStyleGrouped];
    pNUpViewController.delegate = self;
    
    // N-Up
    NSMutableArray *parrPickerRow = [[NSMutableArray alloc]initWithCapacity:3];
    [parrPickerRow addObject:S_PRINT_N_UP_ONE_UP];
    [parrPickerRow addObject:S_PRINT_N_UP_TWO_UP];
    [parrPickerRow addObject:S_PRINT_N_UP_FOUR_UP];
    pNUpViewController.m_parrPickerRow = parrPickerRow;
    
    // 2-Upの順序
    if ([self.selectFileArray count] == 1) {
        ScanData *scanData = [self.selectFileArray firstObject];
        NSString *localScanFilePath = [scanData.fpath stringByAppendingPathComponent:scanData.fname];
        arrThumbnails = [GeneralFileUtility getPreviewFilePaths:localScanFilePath];
        
        //縦横判定
        if (arrThumbnails.count != 0) {
            UIImage* image = [[UIImage alloc] initWithContentsOfFile:[arrThumbnails objectAtIndex:0]];
            self.m_isVertical = image.size.width <= image.size.height;
            if (!self.m_isVertical && self.nNupRow == 1) {
                self.nSeqRow = 0;
            }
        } else {
            self.m_isVertical = TRUE;
        }
    }
    
    if (self.m_isVertical || !self.isSingleData) {
        // 1ファイル印刷で、縦向き原稿の場合、または複数ファイル印刷に一度でもなった後
        NSMutableArray *parrTwoUpPickerRow = [[NSMutableArray alloc]initWithCapacity:2];
        [parrTwoUpPickerRow addObject:S_PRINT_TWO_UP_LEFT_TO_RIGHT];
        [parrTwoUpPickerRow addObject:S_PRINT_TWO_UP_RIGHT_TO_LEFT];
        pNUpViewController.m_parrTwoUpPickerRow = parrTwoUpPickerRow;
    } else {
        NSMutableArray* parrTwoUpPickerRow = [[NSMutableArray alloc]initWithCapacity:1];
        [parrTwoUpPickerRow addObject:S_PRINT_TWO_UP_TOP_TO_BOTTOM];
        pNUpViewController.m_parrTwoUpPickerRow = parrTwoUpPickerRow;
    }
    
    // 4-Upの順序
    NSMutableArray *parrFourUpPickerRow = [[NSMutableArray alloc]initWithCapacity:4];
    [parrFourUpPickerRow addObject:S_PRINT_FOUR_UP_UPPERLEFT_TO_RIGHT];
    [parrFourUpPickerRow addObject:S_PRINT_FOUR_UP_UPPERLEFT_TO_BOTTOM];
    [parrFourUpPickerRow addObject:S_PRINT_FOUR_UP_UPPERRIGHT_TO_LEFT];
    [parrFourUpPickerRow addObject:S_PRINT_FOUR_UP_UPPERRIGHT_TO_BOTTOM];
    pNUpViewController.m_parrFourUpPickerRow = parrFourUpPickerRow;
    
    // 選択中の行番号を設定
    pNUpViewController.nNupRow = self.nNupRow;
    pNUpViewController.nSeqRow = self.nSeqRow;
    
    // 押下されたボタンの位置取得
    UIButton* button = [self getUIButtonByIndex:[self getButtonIndex:BUTTON_NUP]];
    CGRect popoverRect = [self.view convertRect:[button frame]fromView:self.view];
    
    // Popオーバー表示
    UINavigationController *navigationController = [[UINavigationController alloc]initWithRootViewController:pNUpViewController];
    
    UIPopoverController *popover = [[UIPopoverController alloc]initWithContentViewController: navigationController];
    self.viewPopoverController = popover;
    self.viewPopoverController.popoverContentSize = CGSizeMake(320, 410);
    [viewPopoverController presentPopoverFromRect:popoverRect inView:m_pMenuView permittedArrowDirections:UIPopoverArrowDirectionRight animated:YES];
}

// 印刷範囲ボタン押下時のアクション
- (void)PrintRangeBtnAction:(UIButton*)senderBtn {
    // 画面遷移
    PrintRangeSettingViewController *pPrintRangeSettingViewController;
    pPrintRangeSettingViewController = [[PrintRangeSettingViewController alloc]initWithStyle:UITableViewStyleGrouped];
    pPrintRangeSettingViewController.delegate = self;
    m_PageMax = totalPage;
    
    //設定値格納
    pPrintRangeSettingViewController.m_PrintRangeStyle = m_PrintRangeStyle;
    pPrintRangeSettingViewController.m_PageMax = m_PageMax;
    pPrintRangeSettingViewController.m_PageFrom = m_PageFrom;
    pPrintRangeSettingViewController.m_PageTo = m_PageTo;
    pPrintRangeSettingViewController.m_PageDirect = m_PageDirect;
    
    //暗号化PDFまたは一般PDFの場合で、印刷範囲拡張有効時は、「範囲指定」項目を非表示とする
    if (self.isSingleData && (self.hasEncryptionPdfData || self.hasGeneralPdfData) && isPrintRangeExpansionMode) {
        pPrintRangeSettingViewController.noRangeDesignation = YES;
    } else {
        pPrintRangeSettingViewController.noRangeDesignation = NO;
    }
    
    CGRect popoverRect = [self.view convertRect:senderBtn.frame fromView:senderBtn.superview];
    
    // Popオーバー表示
    UINavigationController *navigationController = [[UINavigationController alloc]initWithRootViewController:pPrintRangeSettingViewController];
    UIPopoverController *popover = [[UIPopoverController alloc]initWithContentViewController:navigationController];
    self.viewPopoverController = popover;
    self.viewPopoverController.popoverContentSize = CGSizeMake(320, 410);
    [viewPopoverController presentPopoverFromRect:popoverRect
                                           inView:self.view
                         permittedArrowDirections:UIPopoverArrowDirectionRight
                                         animated:YES];
}

// 印刷対象ボタン押下時のアクション
- (void)printTargetBtnAction {
    
    // ピッカーに表示する項目を格納
    NSMutableArray* parrPickerRow = [self getPrintTargetPickerItems];
    
    // ピッカー表示
    [self callShowPickerView:BUTTON_TARGET andPickerItems:parrPickerRow];
    
}

// リテンションボタン押下時のアクション
- (void)RetentionBtnAction:(UIButton*)senderBtn; {
    // 画面遷移
    RetentionSettingViewController* pRetentionSettingViewController;
    pRetentionSettingViewController = [[RetentionSettingViewController alloc]initWithStyle:UITableViewStyleGrouped];
    pRetentionSettingViewController.delegate = self;
    
    //設定値格納
    pRetentionSettingViewController.noPrintOn = self.noPrintOn;
    pRetentionSettingViewController.authenticateOn = self.authenticateOn;
    pRetentionSettingViewController.pstrPassword = self.pstrPassword;
    
    CGRect popoverRect = [self.view convertRect:senderBtn.frame fromView:senderBtn.superview];
    
    // Popオーバー表示
    UINavigationController *navigationController = [[UINavigationController alloc]initWithRootViewController:pRetentionSettingViewController];
    
    UIPopoverController *popover = [[UIPopoverController alloc]initWithContentViewController:navigationController];
    self.viewPopoverController = popover;
    self.viewPopoverController.popoverContentSize = CGSizeMake(320, 230);
    [viewPopoverController presentPopoverFromRect:popoverRect
                                           inView:self.view
                         permittedArrowDirections:UIPopoverArrowDirectionRight
                                         animated:YES];
}

// プリントリリースボタン押下時のアクション
- (void)printReleaseBtnAction:(UIButton*)senderBtn; {
    // 画面遷移
    PrintReleaseSettingViewController* pPrintReleaseSettingViewController;
    pPrintReleaseSettingViewController = [[PrintReleaseSettingViewController alloc]initWithStyle:UITableViewStyleGrouped];
    pPrintReleaseSettingViewController.delegate = self;
    
    //設定値格納
    //pPrintReleaseSettingViewController.printReleaseOn = self.printReleaseOn;
    pPrintReleaseSettingViewController.enabledPrintRelease = self.printReleaseOn;
    
    CGRect popoverRect = [self.view convertRect:senderBtn.frame fromView:senderBtn.superview];
    
    // Popオーバー表示
    UINavigationController *navigationController = [[UINavigationController alloc]initWithRootViewController:pPrintReleaseSettingViewController];
    
    UIPopoverController *popover = [[UIPopoverController alloc]initWithContentViewController:navigationController];
    self.viewPopoverController = popover;
    self.viewPopoverController.popoverContentSize = CGSizeMake(320, 230);
    [viewPopoverController presentPopoverFromRect:popoverRect
                                           inView:self.view
                         permittedArrowDirections:UIPopoverArrowDirectionRight
                                         animated:YES];
    
}

// 印刷範囲設定のキャンセルまたは決定ボタン押下
#pragma mark - ViewControllerDelegate
#pragma mark - RetentionSettingViewControllerDelegate
- (void)printRangeSetting:(UIViewController*)viewController didCreatedSuccess:(BOOL)bSuccess {
    PrintRangeSettingViewController* con = (PrintRangeSettingViewController*)viewController;
    
    // フォルダ作成
    if (bSuccess) {
        //決定ボタン押下
        m_PrintRangeStyle = con.m_PrintRangeStyle;
        m_PageMax = con.m_PageMax;
        m_PageFrom = con.m_PageFrom;
        m_PageTo = con.m_PageTo;
        m_PageDirect = [con.m_PageDirect copy];
        //ボタン名称セット
        NSString* pstrTitle;
        if (m_PrintRangeStyle == 0) {
            //全てのページの場合
            self.m_pstrPrintRange = S_PRINT_RANGE_ALL;
        } else if (m_PrintRangeStyle == 1) {
            //範囲指定の場合
            self.m_pstrPrintRange = [[NSString alloc]initWithFormat: @"%zd-%zd", m_PageFrom, m_PageTo];
        } else if (m_PrintRangeStyle == 2) {
            //直接指定の場合
            self.m_pstrPrintRange = m_PageDirect;
        }
        pstrTitle = self.m_pstrPrintRange;
        
        UIButton* button = [self getUIButtonByIndex:[self getButtonIndex:BUTTON_RANGE]];
        [button setTitle:pstrTitle forState:UIControlStateNormal];
        m_nSelPicker = PrvMenuIDNone;
    }
    
    // Popオーバーを閉じる
    [self.viewPopoverController dismissPopoverAnimated:YES];
    
    // デリゲートをクリア
    con.delegate = nil;
}

// リテンション設定のキャンセルまたは決定ボタン押下
#pragma mark - ViewControllerDelegate
#pragma mark - RetentionSettingViewControllerDelegate
- (void)retentionSetting:(UIViewController*)viewController didCreatedSuccess:(BOOL)bSuccess {
    RetentionSettingViewController *con = (RetentionSettingViewController *)viewController;
    
    // フォルダ作成
    if (bSuccess) {
        //決定ボタン押下
        self.noPrintOn = con.noPrintOn;
        self.authenticateOn = con.authenticateOn;
        self.pstrPassword = [con.pstrPassword copy];
        //ボタン名称セット
        NSString *pstrTitle;
        if (self.noPrintOn == YES) {
            //印刷せずにホールド「オン」の場合
            self.m_pstrRetention = S_RETENTION_HOLDON;
            
            // プリントリリースの値をOFFにする
            self.printReleaseOn = NO;
            
        } else {
            //印刷せずにホールド「オフ」の場合
            self.m_pstrRetention = S_RETENTION_HOLDOFF;
        }
        
        pstrTitle = self.m_pstrRetention;
        UIButton* button = [self getUIButtonByIndex:[self getButtonIndex:BUTTON_RETENTION]];
        [button setTitle:pstrTitle forState:UIControlStateNormal];
        
        // プリントリリースボタンのEnabled処理
        [self setPrintReleaseButtonEnabled];
        
        m_nSelPicker = PrvMenuIDNone;
    }
    
    // Popオーバーを閉じる
    [self.viewPopoverController dismissPopoverAnimated:YES];
    
    // デリゲートをクリア
    con.delegate = nil;
}


// プリントリリース設定のキャンセルまたは決定ボタン押下
#pragma mark - ViewControllerDelegate
#pragma mark - RetentionSettingViewControllerDelegate
- (void)printReleaseSetting:(UIViewController*)viewController canceled:(BOOL)canceled {
    
    PrintReleaseSettingViewController *con = (PrintReleaseSettingViewController *)viewController;
    
    // フォルダ作成
    if (!canceled) {
        //決定ボタン押下
        self.printReleaseOn = con.enabledPrintRelease;
        //ボタン名称セット
        NSString *pstrTitle;
        NSString* strPrintReleaseState;
        if(self.printReleaseOn == YES){
            //「する」の場合
            strPrintReleaseState = S_PRINTRELEASE_ENABLE;
            
            // リテンションの設定値をOFFにする
            self.noPrintOn = NO;
            
        } else {
            //「しない」の場合
            strPrintReleaseState = S_PRINTRELEASE_DISABLE;
        }
        
        //pstrTitle = self.m_pstrRetention;
        pstrTitle = strPrintReleaseState;
        
        UIButton* button = [self getUIButtonByIndex:[self getButtonIndex:BUTTON_PRINTRELEASE]];
        [button setTitle:pstrTitle forState:UIControlStateNormal];
        
        // リテンションボタンのEnabled処理
        [self setRetentionButtonEnabled];
        
        m_nSelPicker = PrvMenuIDNone;
    }
    
    // Popオーバーを閉じる
    [self.viewPopoverController dismissPopoverAnimated:YES];
    
    // デリゲートをクリア
    con.delegate = nil;
}

// 仕上げ設定のキャンセルまたは決定ボタン押下
#pragma mark - FinishingViewControllerDelegate
-(void) finishingSetting:(UIViewController*)viewController didSelectedSuccess:(BOOL)bSuccess;
{
    FinishingViewController* con = (FinishingViewController*)viewController;
    
    // 決定ボタン押下
    if(bSuccess){
        //　表示ボタンの値を更新
        self.nClosingRow = con.nClosingRow;
        self.nStapleRow = con.nStapleRow;
        self.nPunchRow = con.nPunchRow;
        self.pstrSelectedClosing = [[con.m_parrClosingPickerRow objectAtIndex:con.nClosingRow] copy];
        self.pstrSelectedStaple = [[con.m_parrStaplePickerRow objectAtIndex:con.nStapleRow] copy];
        self.pstrSelectedPunch = [[con.m_parrPunchPickerRow objectAtIndex:con.nPunchRow] copy];
        
        UIButton* button = [self getUIButtonByIndex:[self getButtonIndex:BUTTON_FINISHING]];
        [button setTitle:[self getDisplayFinishing] forState:UIControlStateNormal];
    }
    
    // Popオーバーを閉じる
    [self.viewPopoverController dismissPopoverAnimated:YES];
    
    // デリゲートをクリア
    con.delegate = nil;
}
// N-Up設定のキャンセルまたは決定ボタン押下
#pragma mark - NUpViewControllerDelegate
- (void)nUpSetting:(UIViewController *)viewController didSelectedSuccess:(BOOL)bSuccess {
    NUpViewController *con = (NUpViewController *)viewController;
    
    // 決定ボタン押下
    if (bSuccess) {
        //　表示ボタンの値を更新
        self.nNupRow = con.nNupRow;
        self.nSeqRow = con.nSeqRow;
        self.pstrSelectedNUp = [[con.m_parrPickerRow objectAtIndex:con.nNupRow] copy];
        UIButton* button = [self getUIButtonByIndex:[self getButtonIndex:BUTTON_NUP]];
        [button setTitle:self.pstrSelectedNUp forState:UIControlStateNormal];
    }
    
    // Popオーバーを閉じる
    [self.viewPopoverController dismissPopoverAnimated:YES];
    
    // デリゲートをクリア
    con.delegate = nil;
}

// アクションシート決定ボタン押下時の処理
- (void)setPickerValue {
    
    // ボタン名称セット等の処理
    NSInteger btnIndex = [self getButtonIndexFromPicSelRow:m_nSelPicker];
    [self menuDecideButtonActionByIndex:btnIndex];
    
}

/**
 @brief アクションシート決定ボタンが押されたときの処理呼び出し
 現在はアクションシートは固定メニューボタンでのみ使用されているのでN-UP等はこのメソッドは使用しない
 */
- (void)menuDecideButtonActionByIndex:(NSInteger)index {
    
    enum PRINTER_SETTING_BUTTON buttonId = [[buttonIdArray objectAtIndex:index] intValue];
    
    switch (buttonId) {
        case BUTTON_PRINT:
            break;
        case BUTTON_PRINTER:
            [self menuDecideButtonActionPrinter];
            break;
        case BUTTON_NUM:
            [self menuDecideButtonActionNum];
            break;
        case BUTTON_DUPLEX:
            [self menuDecideButtonActionDuplex];
            break;
        case BUTTON_COLOR:
            [self menuDecideButtonActionColorMode];
            break;
        case BUTTON_PAPERSIZE:
            [self menuDecideButtonActionPaperSize];
            break;
        case BUTTON_PAPERTYPE:
            [self menuDecideButtonActionPaperType];
            break;
        case BUTTON_TARGET:
            [self menuDecideButtonActionPrintTarget];
            break;
        default:
            break;
    }
}

/**
 @brief アクションシート決定ボタン処理(プリンター)
 */
- (void)menuDecideButtonActionPrinter {
    
    // プリンタ選択ボタン
    UIButton* button = [self getUIButtonByIndex:[self getButtonIndex:BUTTON_PRINTER]];
    [button setTitle:m_pstrPickerValue forState:UIControlStateNormal];
    
    m_nSelPicker = PrvMenuIDNone;
    
    // プライマリキーの情報を選択されているPickerのプリンタの情報で更新
    NSInteger selPickerRow = [self getSelPickerRowWithIndex:BUTTON_PRINTER];
    selectedPrinterPrimaryKey =
    [m_pPrinterMgr LoadPrinterDataAtIndexInclude2:selPickerRow].PrimaryKey;
    
    
    // プリンタの選択が変わっているかどうか判定
    //if (![m_strBeforeSelectedPrimaryKey isEqualToString:selectedPrinterPrimaryKey]) {
    
    //m_strBeforeSelectedPrimaryKey = selectedPrinterPrimaryKey;
    
    PrinterData *printerData = [m_pPrinterMgr LoadPrinterDataAtIndexInclude2:[self getSelPickerRowWithIndex:BUTTON_PRINTER]];
    if (printerData != nil) {
        
        SharpScanPrintAppDelegate* appDelegate = (SharpScanPrintAppDelegate*)[[UIApplication sharedApplication] delegate];
        // 処理実行フラグON
        appDelegate.IsRun = TRUE;
        [self setBtnEnabledForCancelRsMng]; // ボタン非活性
        [self setDuringCommProcessValues:YES];
        // 接続中メッセージ表示
        [self popupMessageAlert:MSG_PRINTEROPTION_GET];
        
        // プリンター変更時の処理
        [self callPrinterChange];
    }
    //}
}

/**
 @brief アクションシート決定ボタン処理(部数)
 */
- (void)menuDecideButtonActionNum {
    
    NSString *pstrTitle;
    
    // 部数選択ボタン
    self.m_pstrNumSets = m_pstrPickerValue;
    pstrTitle = [[NSString alloc]initWithFormat:S_BUTTON_NUMBER_OF_SETS_IPAD,m_pstrPickerValue];
    UIButton* button = [self getUIButtonByIndex:[self getButtonIndex:BUTTON_NUM]];
    [button setTitle:pstrTitle forState:UIControlStateNormal];
    m_nSelPicker = PrvMenuIDNone;
    
}
/**
 @brief アクションシート決定ボタン処理(両面/片面)
 */
- (void)menuDecideButtonActionDuplex {
    
    self.m_pstrSide = m_pstrPickerValue;
    // 片面/両面選択ボタン
    UIButton* button = [self getUIButtonByIndex:[self getButtonIndex:BUTTON_DUPLEX]];
    [button setTitle:m_pstrPickerValue forState:UIControlStateNormal];
    m_nSelPicker = PrvMenuIDNone;
    
    if([self.m_pstrSide isEqualToString:S_DUPLEX_SIDE_LONG] || [self.m_pstrSide isEqualToString:S_DUPLEX_SIDE_SHORT]){
        self.isDuplexPrint = YES;
    }else{
        self.isDuplexPrint = NO;
    }
    
    // 印刷面(片面/両面)更新時に仕上げ設定情報を更新する
    [self updateFinishingInfoFromPrintSide];
}
/**
 @brief アクションシート決定ボタン処理(カラーモード)
 */
- (void)menuDecideButtonActionColorMode {
    
    // カラーモード選択ボタン
    self.m_pstrColorMode = m_pstrPickerValue;
    m_nSelPicker = PrvMenuIDNone;
    UIButton* button = [self getUIButtonByIndex:[self getButtonIndex:BUTTON_COLOR]];
    [button setTitle:m_pstrPickerValue forState:UIControlStateNormal];
    
}
/**
 @brief アクションシート決定ボタン処理(用紙サイズ)
 */
- (void)menuDecideButtonActionPaperSize {

    NSMutableArray *arrPaperSize = [self getPaperSizeArray];
    NSMutableArray *arrPaperSizePjl = [self getPaperSizePJLArray];
    
    // ピッカーで選択された用紙サイズ
    NSString *strSelectedPaperSize = [arrPaperSize objectAtIndex:[self getSelPickerRowWithIndex:BUTTON_PAPERSIZE]];
    
    // 組み合わせチェック
    if ([self canSelectPaperSizePickerValue:strSelectedPaperSize]) {
        
        // ステープルの選択値を更新(用紙サイズによってステープルのリストが変わる可能性がある)
        [self updateStapleSelectIndex:strSelectedPaperSize];
        
        // パンチの選択値を更新(用紙サイズの変更によってリストが変わる場合がある)
        [self updatePunchSelectIndex:strSelectedPaperSize];

        // ボタンの活性/非活性処理
        [self checkPaperSizeAndDuplex:strSelectedPaperSize];
        [self checkPaperSizeAndStaple:strSelectedPaperSize];
        [self checkPaperSizeAndPunch:strSelectedPaperSize];
        
        // 値格納
        self.m_pstrPaperSize = [arrPaperSize objectAtIndex:[self getSelPickerRowWithIndex:BUTTON_PAPERSIZE]];
        self.m_pstrPaperSizePJL = [arrPaperSizePjl objectAtIndex:[self getSelPickerRowWithIndex:BUTTON_PAPERSIZE]];
        
        // ボタン名称設定
        [self setMenuButtonTitleWithBtnID:BUTTON_PAPERSIZE andItemValue:self.m_pstrPaperSize];
        
        // 用紙タイプ選択処理
        [self setPaperTypeSelection];
    }
    else {
        
        // エラーメッセージ表示
        [self makeTmpExAlert:nil message:MSG_REMOTESCAN_NOTUSE cancelBtnTitle:nil okBtnTitle:MSG_BUTTON_OK tag:0];
        
        // ピッカーの選択行を戻す
        for (NSInteger iCnt = 0; iCnt < arrPaperSize.count; iCnt++) {
            if ([[arrPaperSize objectAtIndex:iCnt] isEqualToString:self.m_pstrPaperSize]) {
                [self setSelPickerRowWithIndex:BUTTON_PAPERSIZE andRow:iCnt];
            }
        }
    }
    
    DLog(@"%@", self.m_pstrPaperSizePJL);
    
    m_nSelPicker = PrvMenuIDNone;
    
}

/**
 @brief アクションシート決定ボタン処理(用紙タイプ)
 */
- (void)menuDecideButtonActionPaperType {
    
    // 両面印刷設定との組み合わせチェック
    NSMutableArray *arrPaperType = [self getPaperTypeItems];
    NSString *strSelectedPaperType = [arrPaperType objectAtIndex:[self getSelPickerRowWithIndex:BUTTON_PAPERTYPE]];
    
    if ([self canSelectPaperTypePickerValue:strSelectedPaperType]) {
        
        // ボタンの活性/非活性処理
        [self checkPaperTypeAndDuplex:strSelectedPaperType];
        [self checkPaperTypeAndStaple:strSelectedPaperType];
        [self checkPaperTypeAndPunch:strSelectedPaperType];
        
        // 値格納
        NSInteger selPickerRow = [self getSelPickerRowWithIndex:BUTTON_PAPERTYPE];
        self.m_pstrPaperType = [arrPaperType objectAtIndex:selPickerRow];
        self.m_pstrPaperTypePJL = [[self getPaperTypePJL] objectAtIndex:selPickerRow];
        
        // ボタン名称設定
        [self setMenuButtonTitleWithBtnID:BUTTON_PAPERTYPE andItemValue:self.m_pstrPaperType];
    }
    else {
        
        // エラーメッセージ表示
        [self makeTmpExAlert:nil message:MSG_REMOTESCAN_NOTUSE cancelBtnTitle:nil okBtnTitle:MSG_BUTTON_OK tag:0];
        
        // ピッカーの選択行を戻す
        for (NSInteger iCnt = 0; iCnt < arrPaperType.count; iCnt++) {
            if ([[arrPaperType objectAtIndex:iCnt] isEqualToString:self.m_pstrPaperType]) {
                [self setSelPickerRowWithIndex:BUTTON_PAPERTYPE andRow:iCnt];
            }
        }
    }
    
    m_nSelPicker = PrvMenuIDNone;
    
}

/**
 @brief 印刷対象アクションシートの決定ボタンが押されたときの処理
 */
- (void)menuDecideButtonActionPrintTarget {
    
    NSInteger picSelRowIndex = [self getSelPickerRowWithIndex:BUTTON_TARGET];
    switch (picSelRowIndex) {
        case 0:
            self.printAllSheetsOn = NO;
            break;
        case 1:
            self.printAllSheetsOn = YES;
            break;
        default:
            break;
    }
    NSMutableArray *itemArray = [self getPrintTargetPickerItems];
    if (itemArray.count > picSelRowIndex) {
        NSString *strTarget = [itemArray objectAtIndex:picSelRowIndex];
        // ボタン名称設定
        [self setMenuButtonTitleWithBtnID:BUTTON_TARGET andItemValue:strTarget];
    }
    
    m_nSelPicker = PrvMenuIDNone;
    
}

// ファイル送信分岐
- (NSInteger)StartSendFile:strFilePath {
    NSInteger nRet = SUCCESS;
    
    // プリンタかプリントサーバーかの設定を確認する
    if (m_isUseRawPrintMode) {
        // Rawプリント
        nRet = [self StartSendFileForRawPrint:strFilePath];
    } else {
        // FTPで送信
        nRet = [self StartSendFileForFTP:strFilePath];
    }
    return nRet;
}

// FTP Serverへのファイル送信
- (NSInteger)StartSendFileForFTP:strFilePath {
    // 戻り値
    NSInteger nRet = SUCCESS;
    // NetworkStream戻り値
    BOOL bRet = TRUE;
    // 送信先URL
    NSURL *url;
    // 書き込み用ストリーム
    CFWriteStreamRef ftpWriteStream;
    
    m_bRet = FALSE;
    
    // ストリーム初期化
    self.NetworkStream = nil;
    self.FileStream = nil;
    self.BufferOffset = 0;
    self.BufferLimit = 0;
    
    // ファイルパスが存在しない
    if (strFilePath == nil || ![[NSFileManager defaultManager]fileExistsAtPath:strFilePath]) {
        nRet = ERR_INVALID_FILEPATH;
    }
    
    // プリンタ情報取得
    PrinterData* printerData = nil;
    printerData = [m_pPrinterMgr LoadPrinterDataAtIndex2:[self getSelPickerRowWithIndex:BUTTON_PRINTER]];
    
    // メール本文印刷の場合のみ、カラーモードの値を1足す（自動がないので）
    NSInteger colormode = [self getSelPickerRowWithIndex:BUTTON_COLOR];
    if(self.PrintPictViewID == EMAIL_PRINT_VIEW)
    {
        colormode = colormode + 1;
    }
    
    // 印刷範囲情報を作成する
    PrintRangeSettingViewController *printRangeInfo = [self makePrintRangeInfo];
    
    // ファイルパス、ip,部数、両面設定を引数に
    NSString* pjlFilePath = [m_pPJLDataMgr CreatePJLData:[self getSelPickerRowWithIndex:BUTTON_NUM]
                                                    Side:[self getSelPickerRowWithIndex:BUTTON_DUPLEX]
                                               ColorMode:colormode
                                               PaperSize:self.m_pstrPaperSizePJL
                                               PaperType:self.m_pstrPaperTypePJL
                                             Orientation:[self getSelPickerRowWithIndex:BUTTON_PAPERSIZE] //self.m_nSelPickerRow6
                                          PrintRangeInfo:printRangeInfo
                                             PrintTarget:[self getPrintTargetValue]
                                           RetentionHold:self.noPrintOn
                                           RetentionAuth:self.authenticateOn
                                       RetentionPassword:self.pstrPassword
                                               Finishing:self.staple
                                              ClosingRow:self.nClosingRow
                                                  Staple:[PrintPictManager getStaplePJLString:self.pstrSelectedStaple]
                                                CanPunch:self.punchData
                                                   Punch:[PrintPictManager getPunchPJLString:self.pstrSelectedPunch]
                                                  NupRow:self.nNupRow
                                                  SeqRow:self.nSeqRow
                                              IsVertical:self.m_isVertical
                                                FilePath:strFilePath
                                                 JobName:self.SelFilePath
                                            PrintRelease:[self getPrintReleaseValue]];
    // Pjl ファイル名を取得
    self.PjlFileName = [pjlFilePath lastPathComponent];
    
    // FTP接続先
    NSDictionary *dicIPAddr = [CommonUtil getIPAddrDicForComm:[printerData IpAddress] port:[printerData FtpPortNo]];
    NSString* pstrFtp = [[NSString alloc]initWithFormat: @"ftp://%@:%@", [CommonUtil optIPAddrForComm:[dicIPAddr objectForKey:S_TARGET_IPADDRESS_DIC_KEY]],[printerData FtpPortNo]];
    
    url = [NSURL URLWithString:pstrFtp];
    
    if (url == nil) {
        nRet = ERR_INVALID_HOSTNAME;
    }
    
    if (nRet == SUCCESS) {
        // 送信するファイル名のみ取得してURLに追加
        url = CFBridgingRelease(CFURLCreateCopyAppendingPathComponent(NULL, (CFURLRef) url, (CFStringRef) [pjlFilePath lastPathComponent], false));
        // URL生成失敗
        if (url == nil) {
            nRet = ERR_INVALID_URL;
        }
    }
    if (nRet == SUCCESS) {
        // 送信ファイルのストリームをオープン
        self.FileStream = [NSInputStream inputStreamWithFileAtPath:pjlFilePath];
        assert(self.FileStream != nil);
        
        //        [self.FileStream open];
        [self.FileStream performSelectorInBackground:@selector(open) withObject:nil];
        
        // 送信先のURL作成
        ftpWriteStream = CFWriteStreamCreateWithFTPURL(NULL, (__bridge CFURLRef) url);
        
        // URL生成失敗
        if (ftpWriteStream == nil) {
            nRet = ERR_INVALID_URL;
        }
    }
    
    if (nRet == SUCCESS) {
        self.NetworkStream = (__bridge NSOutputStream*) ftpWriteStream;
        if (ftpWriteStream != nil) {
            CFRelease(ftpWriteStream);
        }
        
        // ユーザ名はanonymous、パスワードは「なし」固定
        bRet = [self.NetworkStream setProperty:S_PRINT_LOGIN_ID forKey:(id)kCFStreamPropertyFTPUserName];
        if (bRet) {
            bRet = [self.NetworkStream setProperty:S_PRINT_LOGIN_PASSWORD forKey:(id)kCFStreamPropertyFTPPassword];
        }
        // FTPサーバとのコネクションを再利用するかのフラグ。Falseにすることで転送後にコネクションをクローズする
        if (bRet) {
            bRet = [self.NetworkStream setProperty:(id)kCFBooleanFalse forKey:(id)kCFStreamPropertyFTPAttemptPersistentConnection];
        }
        if (bRet) {
            self.NetworkStream.delegate = self;
            [self.NetworkStream scheduleInRunLoop:[NSRunLoop currentRunLoop]forMode:NSDefaultRunLoopMode];
            //            [self.NetworkStream open];
            [self.NetworkStream performSelectorInBackground:@selector(open) withObject:nil];
            DLog(@"転送開始");
        } else {
            // 送信パラメータ設定失敗
            nRet = ERR_FAILED_SET_SENDPRM;
        }
    }
    return nRet;
}

- (NSInteger)StartSendFileForRawPrint:strFilePath {
    // 戻り値
    NSInteger nRet = SUCCESS;
    m_bRet = FALSE;
    
    // ファイルパスが存在しない
    if (strFilePath == nil || ![[NSFileManager defaultManager]fileExistsAtPath:strFilePath]) {
    }
    
    // プリンタ情報取得
    // プリンタかプリントサーバーかの設定を確認する
    PrinterData* printerData = nil;
    printerData = [m_pPrinterMgr LoadPrinterDataAtIndex2:[self getSelPickerRowWithIndex:BUTTON_PRINTER]];
    
    // メール本文印刷の場合のみ、カラーモードの値を1足す（自動がないので）
    NSInteger colormode = [self getSelPickerRowWithIndex:BUTTON_COLOR];
    if(self.PrintPictViewID == EMAIL_PRINT_VIEW)
    {
        colormode = colormode + 1;
    }
    
    // 印刷範囲情報を作成する
    PrintRangeSettingViewController *printRangeInfo = [self makePrintRangeInfo];
    
    // ファイルパス、ip,部数、両面設定を引数に
    NSString* pjlFilePath = [m_pPJLDataMgr CreatePJLData:[self getSelPickerRowWithIndex:BUTTON_NUM]
                                                    Side:[self getSelPickerRowWithIndex:BUTTON_DUPLEX]
                                               ColorMode:colormode
                                               PaperSize:self.m_pstrPaperSizePJL
                                               PaperType:self.m_pstrPaperTypePJL
                                             Orientation:[self getSelPickerRowWithIndex:BUTTON_PAPERSIZE] //self.m_nSelPickerRow6
                                          PrintRangeInfo:printRangeInfo
                                             PrintTarget:[self getPrintTargetValue]
                                           RetentionHold:self.noPrintOn
                                           RetentionAuth:self.authenticateOn
                                       RetentionPassword:self.pstrPassword
                                               Finishing:self.staple
                                              ClosingRow:self.nClosingRow
                                                  Staple:[PrintPictManager getStaplePJLString:self.pstrSelectedStaple]
                                                CanPunch:self.punchData
                                                   Punch:[PrintPictManager getPunchPJLString:self.pstrSelectedPunch]
                                                  NupRow:self.nNupRow
                                                  SeqRow:self.nSeqRow
                                              IsVertical:self.m_isVertical
                                                FilePath:strFilePath
                                                 JobName:self.SelFilePath
                                            PrintRelease:[self getPrintReleaseValue]];
    // Pjl ファイル名を取得
    self.PjlFileName = [pjlFilePath lastPathComponent];
    
    NSData* sendData = [NSData dataWithContentsOfFile:pjlFilePath];
    NSDictionary *dicIPAddr = [CommonUtil getIPAddrDicForComm:[printerData IpAddress] port:[printerData RawPortNo]];
    nRet = [self socketConnectWithIPAddr:[dicIPAddr objectForKey:S_TARGET_IPADDRESS_DIC_KEY] port:[[printerData RawPortNo]intValue]data:sendData];  // ここではIPv6アドレスでも括弧をつけない。
    
    return nRet;
}

// 送信中止
- (void)StopSendWithStatus:(NSString *)pstrStatus {
    // タイマー停止
    if (nil != tm) {
        [tm invalidate];
        tm = nil;
    }
    
    if (!m_isStop) {
        m_isStop = TRUE;
        
        // プリンタかプリントサーバーかの設定を確認する
        if(m_isUseRawPrintMode){
            // RawPrintモード
            [self CreateDialogForStopSendWithStatus:pstrStatus];
        } else {
            // 転送中です
            [picture_alert dismissViewControllerAnimated:YES completion:^{
                [self alertButtonDismiss:picture_alert tagIndex:picture_alert.tag buttonIndex:0];
                // FTPモード
                [self performSelector:@selector(CreateDialogForStopSendWithStatus:) withObject:pstrStatus afterDelay:0.01];
            }];
        }
    }
}

//- (void)dismissMyAlert:(NSNumber*)isAnimatedNum {
//    BOOL animated = YES;
//    if (isAnimatedNum) {
//        animated = [isAnimatedNum boolValue];
//    }
//    [m_palert dismissWithClickedButtonIndex:0 animated:animated];
//}

- (void)CreateDialogForStopSendWithStatus:(NSString *)pstrStatus {
    // プリンタかプリントサーバーかの設定を確認する
    if(m_isUseRawPrintMode){
        // RawPrintモード(切断中アラートを表示しない)
        // スレッドで呼び出されるので、メインスレッドでアラートを消す
//        [self performSelectorOnMainThread:@selector(dismissMyAlert:) withObject:[NSNumber numberWithBool:YES] waitUntilDone:YES];
        DLog(@"転送終了");
    } else if (self.NetworkStream != nil) {
        // FTPモード
//        [self CreateProgressAlert:nil message:MSG_PRINT_DISCONNECT withCancel:NO];
        [self networkStreamClose];
//        [m_palert dismissWithClickedButtonIndex:0 animated:NO];
        DLog(@"転送終了");
    }
    [self fileStreamClose];
    
    if (pstrStatus != nil) {
        m_isStopSend = TRUE;
        
        // 印刷終了後はスリープ可能状態に戻す
        [UIApplication sharedApplication].idleTimerDisabled = NO;
        // 印刷終了後はバックグラウンド処理を終了する
        [self EndBackgroundTask];
        
        //既に出ているアラートを消す
        if(picture_alert){
            if([NSThread isMainThread]){
                [picture_alert dismissViewControllerAnimated:YES completion:^{
                }];
                picture_alert = nil;
                [self changeDialogForStopSendWithStatus:pstrStatus];
            }else{
                // メインスレッドでアラートを閉じる処理をするが、同期的に処理を行いたいため、
                // semaphoreで同期化しています。
                dispatch_semaphore_t semaphore = dispatch_semaphore_create(0);
                dispatch_async(dispatch_get_main_queue(), ^{
                    [picture_alert dismissViewControllerAnimated:YES completion:^{
                        [self changeDialogForStopSendWithStatus:pstrStatus];
                    }];
                    dispatch_semaphore_signal(semaphore);
                });
                dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
            }
        }
    }
    m_isCacel = TRUE;
    m_bSendFile = FALSE;
    [m_pCmnMgr removeFile:self.PjlFileName];
}

- (void)changeDialogForStopSendWithStatus:(NSString *)pstrStatus
{
    if([self isMoveAttachmentMail])
    {
        if(pstrStatus == MSG_PRINT_COMPLETE)
        {
            // 添付ファイル印刷
            [self makePictureAlert:nil message:[NSString stringWithFormat:@"%@\r\n%@",pstrStatus, MSG_PRINT_COMPLETE_ATTACHMENT_MAIL] cancelBtnTitle:MSG_BUTTON_NO okBtnTitle:MSG_BUTTON_YES tag:4 showFlg:YES];
        } else {
            [self makePictureAlert:nil message:pstrStatus cancelBtnTitle:MSG_BUTTON_NO okBtnTitle:MSG_BUTTON_YES tag:0 showFlg:YES];
        }
    }
    else
    {
        if(pstrStatus == MSG_PRINT_COMPLETE)
        {
            if(m_bEncryptedPdf){
                // 暗号化PDFの転送完了時はメッセージを切り替える
                [self makePictureAlert:nil message:MSG_PRINT_COMPLETE_PDF_ENCRYPTION cancelBtnTitle:MSG_BUTTON_OK okBtnTitle:nil tag:3 showFlg:YES];
            } else {
                [self makePictureAlert:nil message:pstrStatus cancelBtnTitle:MSG_BUTTON_OK okBtnTitle:nil tag:3 showFlg:YES];
            }
        } else {
            [self makePictureAlert:nil message:pstrStatus cancelBtnTitle:MSG_BUTTON_OK okBtnTitle:nil tag:0 showFlg:YES];
        }
    }
    // 転送が完了しました
}

- (void)networkStreamClose {
    if (self.NetworkStream != nil) {
        [self.NetworkStream close];
        [self.NetworkStream removeFromRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
        self.NetworkStream.delegate = nil;
        self.NetworkStream = nil;
    }
}

- (void)fileStreamClose {
    if (self.FileStream != nil) {
        [self.FileStream close];
        self.FileStream = nil;
    }
}

// FTP送信Callback関数
- (void)stream:(NSStream *)aStream handleEvent:(NSStreamEvent)eventCode {
    // タイマー停止
    if (nil != tm) {
        [tm invalidate];
        tm = nil;
    }
#pragma unused(aStream)
    [NSThread sleepUntilDate:[NSDate dateWithTimeIntervalSinceNow:0.1]];
    assert(aStream == self.NetworkStream);
    CommonManager *commanager = [[CommonManager alloc]init];
    [commanager myrunLoop:0.5];
    switch (eventCode) {
        case NSStreamEventOpenCompleted:
            // タイマー開始
            tm = [NSTimer scheduledTimerWithTimeInterval:[self getJobTimeOut] target:self selector:@selector(timerHandler:) userInfo:nil repeats:NO];
            if (!m_isCacel) {
                // ランループの実行
                // 接続中です
                [picture_alert dismissViewControllerAnimated:YES completion:^{
                    [self alertButtonDismiss:picture_alert tagIndex:picture_alert.tag buttonIndex:0];
                    // 転送中です
                    [self makePictureAlert:nil message:MSG_PRINT_FORWARD cancelBtnTitle:nil okBtnTitle:nil tag:1 showFlg:YES];
                }];
            }
            break;
        case NSStreamEventHasBytesAvailable:
            // FTP送信では発生しない
            assert(NO);
            break;
        case NSStreamEventHasSpaceAvailable:
            // タイマー開始
            tm =[NSTimer scheduledTimerWithTimeInterval:[self getJobTimeOut] target:self selector:@selector(timerHandler:) userInfo:nil repeats:NO];
            // If we don't have any data buffered, go read the next chunk of data.
            if (self.BufferOffset == self.BufferLimit) {
                NSInteger bytesRead;
                bytesRead = [self.FileStream read:self.Buffer maxLength:kSendBufferSize];
                
                if (bytesRead == -1) {
                    [self StopSendWithStatus:MSG_PRINT_ERR];
                } else if (bytesRead == 0) {
                    self.BufferOffset = 0;
                    [self.NetworkStream write:&self.Buffer[self.BufferOffset] maxLength:0];
                    break;
                } else {
                    self.BufferOffset = 0;
                    self.BufferLimit  = bytesRead;
                }
            }
            
            // If we're not out of data completely, send the next chunk.
            if (self.BufferOffset != self.BufferLimit) {
                NSInteger bytesWritten;
                bytesWritten = [self.NetworkStream write:&self.Buffer[self.BufferOffset] maxLength:self.BufferLimit - self.BufferOffset];
                assert(bytesWritten != 0);
                if (bytesWritten == -1) {
                    [self StopSendWithStatus:MSG_PRINT_ERR];
                } else {
                    self.BufferOffset += bytesWritten;
                }
            }
            break;
        case NSStreamEventErrorOccurred:
            [self StopSendWithStatus:MSG_PRINT_ERR];
            break;
        case NSStreamEventEndEncountered:
            [self StopSendWithStatus:MSG_PRINT_COMPLETE];
            m_bRet = TRUE;
            break;
        default:
            assert(NO);
            break;
    }
}

//ダイアログのボタン押下時
-(void)alertButtonPushed:(UIAlertController *)alertController tagIndex:(NSInteger)tagIndex buttonIndex:(NSInteger)buttonIndex
{
    [self alertButtonClicked:alertController tagIndex:tagIndex buttonIndex:buttonIndex];
    [self alertButtonDismiss:alertController tagIndex:tagIndex buttonIndex:buttonIndex];
}

// アラートボタン押下処理
-(void)alertButtonClicked:(UIAlertController *)alertController tagIndex:(NSInteger)tagIndex buttonIndex:(NSInteger)buttonIndex
{
    switch (buttonIndex) {
        case 0:
            self.isContinuePrint = NO;
            
            if (tagIndex == 1) {
                // キャンセル操作
                _printCancelled = YES;//キャンセルフラグ
                m_isPrintStop = TRUE;
                
                DLog(@"印刷中断");
                if (m_isUseRawPrintMode) {
                    DLog(@"RAW印刷");
                } else if (self.NetworkStream != nil) {
                    DLog(@"FTP印刷");
                    [self networkStreamClose];
                }
                [self fileStreamClose];
                m_bSendFile = FALSE;
                
                
                if (!m_isStop) {
                    m_isStop = YES;
                    m_isCacel = TRUE;
                    [m_pCmnMgr removeFile:self.PjlFileName];
                    
                    // 印刷中断アラート
                    [self makePictureAlert:nil message:MSG_PRINT_CANCEL cancelBtnTitle:MSG_BUTTON_OK okBtnTitle:nil tag:0 showFlg:YES];
                }
            }
            
            if (m_bRet) {
                m_isPrintStop = TRUE;
            } else {
                if (m_isStopSend) {
                    m_isPrintStop = TRUE;
                    m_isStopSend = FALSE;
                }
                if (ALERT_TAG_PRINT_CONFIRM == tagIndex) {
                    m_isPrintStop = TRUE;
                }
//                if (m_bSendFile) {
//                    // キャンセル操作
//                    m_isCacel = TRUE;
//                    [self StopSendWithStatus:MSG_PRINT_CANCEL];
//                    [m_pCmnMgr removeFile:self.PjlFileName];
//                }
            }
            if (m_isDoSnmp) {
                //SNMP取得時のキャンセル
                m_isDoSnmp = NO;
                [snmpManager stopGetMib];
                snmpManager = NULL;
            }
            break;
        default:
            break;
    }
}

// アラートボタンによる処理(アラートが閉じた後に呼ばれるメソッド)
-(void)alertButtonDismiss:(UIAlertController *)alertController tagIndex:(NSInteger)tagIndex buttonIndex:(NSInteger)buttonIndex
{
    if (tagIndex == ALERT_TAG_PREVIEW_MEMORY_ERROR_IPAD) {
        return;
    }
    
    // PROFILE情報の取得
    profileDataManager = [[ProfileDataManager alloc]init];
    ProfileData *profileData = nil;
    profileData = [profileDataManager loadProfileDataAtIndex:0];
    
    switch (tagIndex) {
        case 1:
            break;
        case 2:
            break;
        case 3:
        {
            // 内部メモリへの保存
            // プライマリキー
            if(profileData.autoSelectMode)
            {
                PrinterData* printerData = nil;
                printerData = [m_pPrinterMgr LoadPrinterDataAtIndexInclude2:[self getSelPickerRowWithIndex:BUTTON_PRINTER]];
                [m_pPrintOutMgr SetLatestPrimaryKey:[printerData PrimaryKey]];
            }
            
        }
            [self performSelector:@selector(moveView) withObject:nil afterDelay:0.1];
            break;
        case 4: {
            switch (buttonIndex) {
                case 0: {
                    // TOPメニューに戻る
                    [self.navigationController popToRootViewControllerAnimated:YES];
                    SharpScanPrintAppDelegate* pAppDelegate = (SharpScanPrintAppDelegate *)[[UIApplication sharedApplication]delegate];
                    
                    // 左側のViewを取得
                    UINavigationController* pRootNavController = [pAppDelegate.splitViewController.viewControllers objectAtIndex:0];
                    RootViewController_iPad* rootViewController = (RootViewController_iPad *)[pRootNavController.viewControllers objectAtIndex:0];
                    // 左側のViewを遷移前の状態に戻す
                    [rootViewController popRootView];
                    break;
                }
                case 1: {
                    // 前画面に戻る
                    [self.navigationController popViewControllerAnimated:YES];
                    break;
                }
                default: {
                    break;
                }
            }
        }
            break;
        case 5:
        {
            switch (buttonIndex)
            {
                case 0:
                    // いいえの場合、ダイアログを閉じて印刷をキャンセル
                    // 印刷中断アラート
                    [self makePictureAlert:nil message:MSG_PRINT_CANCEL cancelBtnTitle:MSG_BUTTON_OK okBtnTitle:nil tag:0 showFlg:YES];
                    return;
                    break;
                case 1:
                    // はいの場合、TIFFを生成して印刷
                    self.nNupRow = 0;
                    [self performSelectorOnMainThread:@selector(getMibEnd) withObject:nil waitUntilDone:YES];
                    break;
                default:
                    break;
            }
        }
            break;
            
        case ALERT_TAG_PRINT_CONFIRM:
        {
            
            if (buttonIndex == 1) {
                m_bRet = FALSE;
                
                _printCancelled = NO;
                dispatch_async(dispatch_get_main_queue(), ^{
                    //別スレッドで処理開始
                    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                        self.canPrint = NO;
                        self.canPrintPDF = NO;
                        self.canPrintOffice = NO;
                        if(![self checkPclPsOfficeOption])return;
                        // 単品印刷時で、PCLなしのエラー
                        if(!self.canPrint)
                        {
                            // PCLオプションなし
                            if(!_printCancelled)
                            {
                                [self CreateAllert:nil message:MSG_NO_PRINTOPTION_PCL btnTitle:MSG_BUTTON_OK];
                            }
                            return;
                        }
                        
                        if(self.PrintPictViewID == WEB_PRINT_VIEW ||
                           self.PrintPictViewID == EMAIL_PRINT_VIEW){
                            [self updateMenuAndDataArrayExceptFilePicMailAtt];//データ配列更新
                        }
                        
                        [self updatePrintData];//データ更新
                        
                        if(!_printCancelled){
                            [self doSnmp];
                        }
                    });
                });
                return;
            }
        }
            break;
            
        case ALERT_TAG_COMMPROCESS: //プリンター/スキャナー情報の取得中です。
            break;
            
        default:
            break;
    }
    
    if (m_isPrintStop || !m_bResult) {
        SharpScanPrintAppDelegate* appDelegate = (SharpScanPrintAppDelegate*)[[UIApplication sharedApplication] delegate];
        // 処理実行フラグOFF
        appDelegate.IsRun = FALSE;
        m_isPrintStop = FALSE;
        m_bResult = TRUE;
    }
}

#pragma mark -

- (void)moveView {
    // TOPメニューに戻る
    [self.navigationController popToRootViewControllerAnimated:YES];
    SharpScanPrintAppDelegate *pAppDelegate = (SharpScanPrintAppDelegate *)[[UIApplication sharedApplication]delegate];
    
    // 左側のViewを取得
    UINavigationController *pRootNavController = [pAppDelegate.splitViewController.viewControllers objectAtIndex:0];
    RootViewController_iPad *rootViewController = (RootViewController_iPad*)[pRootNavController.viewControllers objectAtIndex:0];
    
    // 左側のViewを遷移前の状態に戻す
    [rootViewController popRootView];
    
    // 外部連携判定
    if (self.IsSite) {
        // 右側のViewを取得
        UINavigationController *pDetailNavController = [pAppDelegate.splitViewController.viewControllers objectAtIndex:1];
        UIViewController *dVC = [pDetailNavController.viewControllers objectAtIndex:0];
        if ([dVC isKindOfClass:[ScanBeforePictViewController_iPad class]]) {
            ScanBeforePictViewController_iPad* detailViewController = (ScanBeforePictViewController_iPad*)dVC;
            // メニューを表示しない
            detailViewController.isShowMenu = FALSE;
        }
    }
}

// 印刷処理
- (void)doPrint {
    NSInteger nRet = SUCCESS;
    
    m_bSendFile = TRUE;
    m_isStop = FALSE;
    self.m_isPrint = TRUE;
    
    NSString *pstrMergeFilePath = [self MergeJpegToOutputfile];
    if (!self.m_isPrint) {
        m_isPrintStop = TRUE;
        // 送信ファイル不正
        [self CreateAllert:nil message:MSG_PRINT_FILE_ERR btnTitle:MSG_BUTTON_OK];
        m_bSendFile = FALSE;
        return;
    }
    
    if (![pstrMergeFilePath isEqualToString:@""] && pstrMergeFilePath != nil) {
        nRet = [self StartSendFile:pstrMergeFilePath];
    } else {
        nRet = [self StartSendFile:[self getPrintFilePath:self.SelFilePath]];
    }
    
    if (nRet == SUCCESS) {
        // 印刷実行中はスリープしない
        [UIApplication sharedApplication].idleTimerDisabled = YES;
        // 印刷中はバックグラウンドになっても処理を継続
        bgTask = [[UIApplication sharedApplication]beginBackgroundTaskWithExpirationHandler:^{
            [[UIApplication sharedApplication] endBackgroundTask:bgTask];
            bgTask = UIBackgroundTaskInvalid;
        }];
        
        if(m_isUseRawPrintMode){
            // Rawプリント(接続中アラートを表示しない)
            // 複数ファイルの時だけ（１/３）をつける
            NSString *msg = MSG_PRINT_FORWARD;
            if (!self.isSingleData) {
                if (self.PrintPictViewID == PPV_PRINT_SELECT_FILE_CELL || self.PrintPictViewID == PPV_PRINT_MAIL_ATTACHMENT_CELL) {
                    msg = [NSString stringWithFormat:@"%@ (%zd/%zd)",MSG_PRINT_FORWARD,self.currentNum+1, _filesToBePrintedArray.count];
                } else if (self.PrintPictViewID == PPV_PRINT_SELECT_PICTURE_CELL) {
                    msg = [NSString stringWithFormat:@"%@ (%zd/%zd)",MSG_PRINT_FORWARD,self.currentNum+1, self.selectPictArray.count];
                }
//                [m_palert setMessage:msg];
            }
            [self CreateProgressAlert:nil
                              message:msg
                           withCancel:NO];
        } else {
            // FTPで送信
            [self CreateProgressAlert:nil message:MSG_PRINT_CONNECT withCancel:YES];
        }
    }
    else if (nRet == ERR_INVALID_HOSTNAME) {
        m_isPrintStop = TRUE;
        // 送信ファイル不正
        [self CreateAllert:nil message:MSG_PRINT_ERR btnTitle:MSG_BUTTON_OK];
        m_bSendFile = FALSE;
    }
    else {
        m_isPrintStop = TRUE;
        // 送信ファイル不正
        [self CreateAllert:nil message:MSG_PRINT_FILE_ERR btnTitle:MSG_BUTTON_OK];
        m_bSendFile = FALSE;
    }
    
}

// iPad用
- (void)CreateNoPrinterAlert {
    SharpScanPrintAppDelegate* appDelegate = (SharpScanPrintAppDelegate*)[[UIApplication sharedApplication] delegate];
    // 処理実行フラグOFF
    appDelegate.IsRun = TRUE;
    m_isPrintStop = TRUE;
    
    // アラート表示
    [self makeTmpExAlert:nil message:MSG_NO_PRINTER cancelBtnTitle:MSG_BUTTON_OK okBtnTitle:nil tag:2];
}

- (void)timerHandler:(NSTimer*)timer {
    [self StopSendWithStatus:MSG_PRINT_ERR];
}

- (void)EndBackgroundTask {
    [[UIApplication sharedApplication]endBackgroundTask:bgTask];
    bgTask = UIBackgroundTaskInvalid;
}

// socket通信関数
// TCP接続処理
- (NSInteger)socketConnectWithIPAddr:(NSString*)ipaddr port:(int)port data:(NSData*)data {
    DLog(@"転送開始");
    DLog(@"ipaddr:%@, port:%d", ipaddr, port);
    CFSocketContext ctx;
    ctx.version = 0;
    ctx.info = (__bridge void *)self;
    ctx.retain = NULL;
    ctx.release = NULL;
    ctx.copyDescription = NULL;
    
    NSString *strPort = [NSString stringWithFormat:@"%d", port];
    struct addrinfo hints;
    struct addrinfo *ai0 = NULL;    // addrinfoリストの先頭の要素
    struct addrinfo *ai;            // 処理中のaddrinfoリストの要素
    
    memset(&hints, 0, sizeof(hints));
    hints.ai_addrlen = sizeof(hints);
#ifdef IPV6_VALID
    if ([CommonUtil isValidIPv4StringFormat:ipaddr]) {
        hints.ai_family = AF_INET;
    }
    else if ([CommonUtil isValidIPv6StringFormat:ipaddr]) {
        hints.ai_family = AF_INET6;
    }
    else {
        hints.ai_family = AF_UNSPEC;
    }
#else
    hints.ai_family = AF_INET;
#endif

    hints.ai_socktype = SOCK_STREAM;
    hints.ai_protocol = IPPROTO_TCP;
    hints.ai_flags = AI_PASSIVE;
    
    int err = getaddrinfo([ipaddr UTF8String], [strPort UTF8String], &hints, &ai0);
    if (err != 0) {
        DLog(@"[SocketCallBack] getaddrinfoError");
        [self StopSendWithStatus:@"getaddrinfoError"];
        return ERR_INVALID_URL;
    }
    
    BOOL isIpv6 = NO;
    NSData *address = nil;
    // 得られたアドレス情報のループ
    for (ai = ai0; ai != NULL; ai = ai->ai_next) {
        
        if (ai != NULL) {
            
            if(!address && (ai->ai_family == AF_INET))
            {
                address = [NSData dataWithBytes:ai->ai_addr length:ai->ai_addrlen];
            }
            else if (!address && (ai->ai_family == AF_INET6))
            {
                address = [NSData dataWithBytes:ai->ai_addr length:ai->ai_addrlen];
                isIpv6 = YES;
            }

        }
    }
    freeaddrinfo(ai0);
    
    if (!address) {
        DLog(@"[SocketCallBack] getaddrinfoError-NotFoundIPAddress");
        [self StopSendWithStatus:@"getaddrinfoError-NotFoundIPAddress"];
        return ERR_INVALID_URL;
    }
    
    // ソケットの作成
    SInt32 addrFamily = PF_INET;
    if (isIpv6) {
        addrFamily = PF_INET6;
    }
    m_Socket = CFSocketCreate(kCFAllocatorDefault, addrFamily, SOCK_STREAM, IPPROTO_TCP, kCFSocketConnectCallBack | kCFSocketDataCallBack, SocketCallBack, &ctx);
    if (m_Socket == NULL) {
        DLog(@"[SocketCallBack] ERR:CreateError");
        [self StopSendWithStatus:MSG_PRINT_ERR];
        return ERR_INVALID_URL;
    }
    
    CFRunLoopSourceRef sourceRef = CFSocketCreateRunLoopSource(kCFAllocatorDefault, m_Socket, 0);
    CFRunLoopAddSource(CFRunLoopGetCurrent(), sourceRef, kCFRunLoopCommonModes);
    CFRelease(sourceRef);
    
    CFSocketNativeHandle socket = CFSocketGetNative(m_Socket);
    int set = 1;
    setsockopt(socket, SOL_SOCKET, SO_NOSIGPIPE, (void *)&set, sizeof(int));
    
    // TCP接続・送信
    NSDictionary* dic = [NSDictionary dictionaryWithObjectsAndKeys:data, @"data", address, @"address", nil];
    [NSThread detachNewThreadSelector:@selector(socketConnectThred:) toTarget:self withObject:dic];
    
    return SUCCESS;
}

// TCP接続・ファイル送信スレッド
-(void)socketConnectThred:(NSDictionary*)dic
{
    @autoreleasepool
    {
        self.isCalledConnectCallback = NO;
        // 転送中です
        [picture_alert dismissViewControllerAnimated:YES completion:^{
            [self alertButtonDismiss:picture_alert tagIndex:picture_alert.tag buttonIndex:0];
        }];
        
        //  スレッド処理
        NSData* data = [dic objectForKey:@"data"];
        NSData* address = [dic objectForKey:@"address"];
        
        CFSocketError SockError = CFSocketConnectToAddress(m_Socket, (__bridge CFDataRef)address, FOWARD_TIMEOUT);
        if (SockError == kCFSocketError) {
            [self socketDisconnectKCFSocketError];
            return;
        }
        
        while (!isCalledConnectCallback)
        {
            [[NSRunLoop currentRunLoop]runUntilDate:[NSDate dateWithTimeIntervalSinceNow:1.0f]];
            
        }
        
        if (SockError == kCFSocketSuccess) {
            // 送信
            NSInteger packetLength = 1024 * 1;
            NSRange dataRange;
            NSInteger dataSize = data.length;
            NSInteger dataSplitCount = dataSize/packetLength;
            
            dataRange.length = packetLength;
            dataRange.location = 0;
            NSMutableArray *dataArray = [NSMutableArray array];
            for(NSInteger cnt = 0;cnt<dataSplitCount;cnt++)
            {
                [dataArray addObject:[data subdataWithRange:dataRange]];
                dataRange.location += packetLength;
            }
            // 最後のデータは、レングスを調整してから処理を行う
            if (dataSize%packetLength != 0) {
                dataRange.length = dataSize%packetLength;
                [dataArray addObject:[data subdataWithRange:dataRange]];
            }
            
            // ジョブ送信のタイムアウト(秒)を取得する
            int jobTimeOut = [self getJobTimeOut];
            for(int i  =0 ; i <[dataArray count]; i ++){
                
                NSDate * sendStartDate = [NSDate date];
                
                NSData *packetData = [dataArray objectAtIndex:i];
                CFDataRef refData = CFDataCreate(kCFAllocatorDefault, [packetData bytes], [packetData length]);
                SockError = CFSocketSendData(m_Socket, NULL, refData, jobTimeOut);
                CFRelease(refData);
                
                NSTimeInterval sendDataTime = [[NSDate date] timeIntervalSinceDate: sendStartDate];
                
                // [送信中に複合機のLANが抜かれた場合を想定した処理]
                // 送信時間がタイムアウト時間を超えている場合
                if (sendDataTime >= jobTimeOut) {
                    /*
                     CFSocketSendData の結果としてLANが抜かれたタイミングによっては
                     kCFSocketSuccess を返してくる場合があるため
                     （エラーが返ってこない）
                     タイムアウトとみなす
                     */
                    SockError = kCFSocketTimeout;
                    DLog(@"タイムアウトとみなす");
                }
                
                
                if(SockError != kCFSocketSuccess){
                    //                NSString* errStr = [NSString stringWithFormat:@"%@(%d)", (SockError == kCFSocketError ? @"kCFSocketError" : @"kCFSocketTimeout"), (int)SockError];
                    //                DLog(@"ERR:Socket Send Error:%@", errStr);
                    
                    if(SockError == kCFSocketError){
                        // 送信失敗
                    }else{
                        // タイムアウト
                    }
                    
                    [self StopSendWithStatus:MSG_PRINT_ERR];
                    [self socketDisconnect:m_Socket];
                    break;
                }
            }
            
            // ファイルサイズが小さいと転送中アラート表示中に固まる場合があるので、スリープを１秒入れておく
            [NSThread sleepForTimeInterval:1.0];
            
            if(SockError == kCFSocketSuccess){
                // 送信成功
                m_bRet = TRUE;
                [self StopSendWithStatus:MSG_PRINT_COMPLETE];
                [self socketDisconnect:m_Socket];
            }
        }else{
            //Error
            DLog(@"ERR:Socket Connect Error:%d", (int)SockError);
            [self StopSendWithStatus:MSG_PRINT_ERR];
            [self socketDisconnect:m_Socket];
        }
        
        DLog(@"socketConnectThred finish");
        
    }
}


// ソケット切断
- (void)socketDisconnect:(CFSocketRef)socket {
    if (socket != NULL) {
        CFSocketInvalidate(socket);
        CFRelease(socket);
        socket = NULL;
    }
}

// TCP通信コールバック
static void SocketCallBack(CFSocketRef socket, CFSocketCallBackType type, CFDataRef address, const void *data, void *info) {
    PrintPictViewController_iPad *selfClass = (__bridge PrintPictViewController_iPad *)(info);
    if (CFSocketIsValid(socket) == FALSE) {
        // ソケットが利用できない
        DLog(@"[SocketCallBack] Socket Disonnect 1");
        [selfClass socketDisconnect:socket];
        [selfClass StopSendWithStatus:MSG_PRINT_ERR];
    } else {
        if (type == kCFSocketConnectCallBack) {
            // 接続完了
            DLog(@"[SocketCallBack] Socket Connect!!");
        } else if (type == kCFSocketDataCallBack) {
            // データ取得
            NSData* RcvData = (__bridge NSData*)data;
            if ([RcvData length] == 0){
                // サーバーから切断
                DLog(@"[SocketCallBack] Socket Disonnect 2");
            } else {
            }
        } else {
            // その他のタイプ
            DLog(@"[SocketCallBack] type:%d", (int)type);
        }
    }
    if (type == kCFSocketConnectCallBack) {
        selfClass.isCalledConnectCallback = YES;
    }
}

/**
 @brief TCP通信:ソケット接続エラー時用の処理(IPv6対応特殊な場合)
 @details ソケット接続解除とメッセージ表示を行う。
 例えばIPv4のみ環境でIPv6形式のアドレスを指定してソケット作成を行うとコールバックされず、
 　　　　　キャンセルなどの処理が行われない処理フローとなっているので、そのような場合のエラー処理。
 */
- (void)socketDisconnectKCFSocketError {
    NSLog(@"[SocketError] Socket Disonnect");
    [self socketDisconnect:m_Socket];
    [self StopSendWithStatus:MSG_PRINT_ERR];
}

// SNMPによるMIB取得処理
- (void)doSnmp {
    if(_printCancelled)return;

    m_isDoSnmp = YES;
//    m_bSendFile = TRUE;
    m_isStop = FALSE;
    
    SharpScanPrintAppDelegate *appDelegate = (SharpScanPrintAppDelegate *)[[UIApplication sharedApplication]delegate];
    // 処理実行フラグON
    appDelegate.IsRun = TRUE;
    
    // 機器検索
    [self performSelectorInBackground:@selector(getMib) withObject:nil];
}

// Mib情報の取得 Officeチェックもここ
- (void)getMib
{
    if(self.canPrintPDF && self.canPrintOffice)
    {//既にPDFとOffice印刷が可能であることが判明しているとき
        m_isDoSnmp = NO;
        // 印刷開始
        [self performSelectorOnMainThread:@selector(getMibEnd) withObject:nil waitUntilDone:YES];
        return;
    }
    
    //以下、mibチェックして印刷
    ProfileDataManager* pManager = [[ProfileDataManager alloc]init];
    ProfileData* pData = [pManager loadProfileDataAtIndex:0];
    
    // Community String の設定
    NSMutableArray* communityString = [[NSMutableArray alloc]init];
    if(!pData.snmpSearchPublicMode)
    {
        [communityString addObject:S_SNMP_COMMUNITY_STRING_DEFAULT];
    }
    NSArray *strStrings = [pData.snmpCommunityString componentsSeparatedByString:@"\n"];
    for (NSString* strTmp in strStrings) {
        [communityString addObject:strTmp];
    }
    
    PrinterData* printerData = nil;
    printerData = [m_pPrinterMgr LoadPrinterDataAtIndexInclude2:[self getSelPickerRowWithIndex:BUTTON_PRINTER]];
    
    NSDictionary *dicIPAddr = [CommonUtil getIPAddrDicForComm:[printerData getIPAddress]
                                                         port:[NSString stringWithFormat:@"%@", [NSNumber numberWithInteger:N_SNMP_PORT]]];
    snmpManager = [[SnmpManager alloc]initWithIpAddress:[CommonUtil optIPAddrForComm:[dicIPAddr objectForKey:S_TARGET_IPADDRESS_DIC_KEY]] port:N_SNMP_PORT];
    [snmpManager setCommunityString:communityString];
    
    
    //==========================================================
    //PCL,PS判定開始
    if(!m_isDoSnmp)
    {
        return;
    }
    //-------------------------
    //以下のフラグについて判定を行う
    BOOL isExistsPCL = NO;
    BOOL isExistsPS  = NO;
    //-------------------------
    
    //判定実行
    BOOL result = NO;
    if([printerData getAddStatus]) {
        // 手動追加MFPの場合は、SNMP通信せず、PCLオプション、PSオプション、Office対応はすべて有効として処理を続ける
        result = YES;
        isExistsPCL = YES;
        isExistsPS = YES;
    } else {
        result = [CommonUtil checkPrinterSpecWithSnmpManager:snmpManager PCL:&isExistsPCL PS:&isExistsPS];
    }
    
    if(!m_isDoSnmp)
    {
        return;
    }
    m_isDoSnmp = NO;
    //PCL,PS判定終了
    //==========================================================
    
    
    if(result)
    {//情報取得成功
        m_isAvailablePrintPDF = YES;
        if(isExistsPCL) {
            self.canPrintOffice = [self isCapableOfficePrint:printerData];
        }
        if(!isExistsPCL)
        {
            // PCLオプションなし
            [self CreateAllert:nil message:MSG_NO_PRINTOPTION_PCL btnTitle:MSG_BUTTON_OK];
        }
        else if(!isExistsPS && m_pstrFilePath != nil && [CommonUtil pdfExtensionCheck:m_pstrFilePath])
        {
            // PSオプションなし
            if(self.PrintPictViewID == WEB_PRINT_VIEW || self.PrintPictViewID == EMAIL_PRINT_VIEW)
            {
                m_isAvailablePrintPDF = NO;
                if(self.nNupRow > 0)
                {
                    // PDF印刷が不可能かつN-Upが指定されている(Web印刷・Email印刷の場合)
                    [picture_alert dismissViewControllerAnimated:YES completion:^{
                        [self makePictureAlert:nil message:MSG_PRINT_CONFIRM_NUP_DISABLE cancelBtnTitle:MSG_BUTTON_NO okBtnTitle:MSG_BUTTON_YES tag:5 showFlg:YES];
                    }];
                }
                else
                {
                    // PDF印刷が不可能な場合TIFF形式で印刷する
                    // 印刷開始
                    [self performSelectorOnMainThread:@selector(getMibEnd) withObject:nil waitUntilDone:YES];
                }
            }
            else
            {
                [self CreateAllert:nil message:MSG_NO_PRINTOPTION_PS btnTitle:MSG_BUTTON_OK];
            }
        }
        else if(!self.canPrintOffice && m_pstrFilePath != nil && [CommonUtil officeExtensionCheck:m_pstrFilePath]) {
            // Office 印刷不可
            dispatch_async(dispatch_get_main_queue(), ^{
                [self CreateAllert:nil message:MSG_NO_PRINTOPTION_OFFICE btnTitle:MSG_BUTTON_OK];
            });
        }
        else
        {
            // PDF印刷が可能な場合PDF形式で印刷する
            // 印刷開始
            [self performSelectorOnMainThread:@selector(getMibEnd) withObject:nil waitUntilDone:YES];
        }
    }
    else
    {//情報取得失敗
        [picture_alert dismissViewControllerAnimated:YES completion:^{
            [self alertButtonDismiss:picture_alert tagIndex:picture_alert.tag buttonIndex:0];
            [self CreateAllert:nil message:MSG_NETWORK_ERR btnTitle:MSG_BUTTON_OK];
        }];
    }
}

// Mib取得完了後処理
- (void)getMibEnd {
    //    [self doPrint];
    //    [self CheckBeforePrinting];
    //印刷前チェックしてから印刷(doPrint)へ
    if(!_printCancelled){
        [self CheckBeforePrinting];
    }
    return;
}

- (void)documentInteractionController:(UIDocumentInteractionController *)controller willBeginSendingToApplication:(NSString *)application {
    DLog(@"!!!!! Sending to: %@", application);
}

- (void)documentInteractionController:(UIDocumentInteractionController *)controller didEndSendingToApplication:(NSString *)application {
    //DLog(@"!!!!! Sent to: %@", application);
    [m_diCtrl dismissMenuAnimated:YES];
    
    //    [self performSelector:@selector(popRootView) withObject:nil afterDelay:0.1];
}

// 印刷データのパスを取得
// 元がPNG形式の場合は抽出したJPEGを、それ以外はスキャンデータを返却
- (NSString*) getPrintFilePath:(NSString*)SelFilePath
{
    NSString* printFilePath = [GeneralFileUtility getPrintFilePath:SelFilePath];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if(printFilePath != nil && ![@"" isEqualToString:printFilePath] && [fileManager fileExistsAtPath:printFilePath]){
        return printFilePath;
    } else {
        return SelFilePath;
    }
}

- (void)showMemoryErrorPNG {
    // エラーメッセージ表示
    [self makePictureAlert:nil message:MSG_PRINT_MEMORY_ERROR_PNG cancelBtnTitle:MSG_BUTTON_OK okBtnTitle:nil tag:ALERT_TAG_PREVIEW_MEMORY_ERROR_IPAD showFlg:YES];
}

#pragma mark - ViewControllerDelegate
#pragma mark   WebPagePrintViewControllerDelegate
- (void)webPagePrint:(UIViewController*)viewController didWebPagePrintSuccess:(BOOL)bSuccess {
    WebPagePrintViewController_iPad* con = (WebPagePrintViewController_iPad*)viewController;
    
    // モーダルを閉じる
    [con dismissViewControllerAnimated:YES completion:nil];
    
    // デリゲートをクリア
    con.delegate = nil;
    PrinterData* printerData = nil;
    printerData = [m_pPrinterMgr LoadPrinterDataAtIndexInclude2:[self getSelPickerRowWithIndex:BUTTON_PRINTER]];
    
    if (printerData == nil) {
        if (m_bResult) {
            [self CreateNoPrinterAlert];
        }
    }
}

-(void) webPagePrint:(UIViewController*)viewController upLoadWebView:(NSString*)strFilePath;
{
    WebPagePrintViewController_iPad* con = (WebPagePrintViewController_iPad*)viewController;
    if(strFilePath != nil)
    {
        self.SelFilePath = strFilePath;
        
        [TempFileUtility createCacheFileForWeb];
        [super ShowFileUpdate:strFilePath];
        
        if (!self.isDuringCommProcess) {
            // ボタンの活性状態を変更する
            [self setBtnEnable];
            
        }
        
        // NoImageは隠す
        m_pLblNoImage.hidden = YES;
        m_pImgViewNoImage.hidden = YES;
        
    }
    // モーダルを閉じる
    [con dismissViewControllerAnimated:YES completion:nil];
    
    // デリゲートをクリア
    con.delegate = nil;
    
    if ([arrThumbnails count] > 0) {
        UIView *delBtn = [self.view viewWithTag:PAGE_DEL_BUTTON_TAG];
        [UIView animateWithDuration:0.3 animations:^{
            delBtn.alpha = 1;
        }];
    }
    PrinterData* printerData = nil;
    printerData = [m_pPrinterMgr LoadPrinterDataAtIndexInclude2:[self getSelPickerRowWithIndex:BUTTON_PRINTER]];
    if (printerData == nil)
    {
        if (m_bResult)
        {
            [self CreateNoPrinterAlert];
        }
    }
}

- (void)selectMail:(UIViewController*)viewController didSelectMailSuccess:(BOOL)bSuccess {
    SelectMailViewController_iPad* con = (SelectMailViewController_iPad*)viewController;
    // モーダルを閉じる
    [con dismissViewControllerAnimated:YES completion:nil];
    
    self.smNavigationController = nil;
    PrinterData* printerData = nil;
    printerData = [m_pPrinterMgr LoadPrinterDataAtIndexInclude2:[self getSelPickerRowWithIndex:BUTTON_PRINTER]];
    if (printerData == nil) {
        if (m_bResult) {
            [self CreateNoPrinterAlert];
        }
    }
}

- (void)mailPrint:(UIViewController*)viewController upLoadMailView:(NSString*)strFilePath {
    ShowMailViewController_iPad* con = (ShowMailViewController_iPad*)viewController;
    for(int i = 0 ; i < con.mailFormatArrayOfPages.count ; i ++){
        [self.mailFormtArray addObject: [con.mailFormatArrayOfPages objectAtIndex:i]];
    }
    
    if (strFilePath != nil) {
        self.SelFilePath = strFilePath;
        
        [TempFileUtility createCacheFileForWeb];
        [super ShowFileUpdate:strFilePath];
        
        if (!self.isDuringCommProcess) {
            // ボタンの活性状態を変更する
            [self setBtnEnable];
        }
        
        // NoImageは隠す
        m_pLblNoImage.hidden = YES;
        m_pImgViewNoImage.hidden = YES;
        
        // モーダルを閉じる
        [con dismissViewControllerAnimated:YES completion:nil];
        
        // ナビゲーションコントローラーを一つ前の画面に戻す遷移
        [self.smNavigationController popViewControllerAnimated:NO];
    } else {
        // モーダルを閉じる
        [con dismissViewControllerAnimated:YES completion:nil];
        // ナビゲーションコントローラーを一つ前の画面に戻す遷移
        [self.smNavigationController popViewControllerAnimated:NO];
    }
    
    if ([arrThumbnails count] > 0) {
        UIView *delBtn = [self.view viewWithTag:PAGE_DEL_BUTTON_TAG];
        [UIView animateWithDuration:0.3 animations:^{
            delBtn.alpha = 1;
        }];
    }
    
    PrinterData *printerData = nil;
    printerData = [m_pPrinterMgr LoadPrinterDataAtIndexInclude2:[self getSelPickerRowWithIndex:BUTTON_PRINTER]];
    if (printerData == nil) {
        if (m_bResult) {
            [self CreateNoPrinterAlert];
        }
    }
}

// メール選択用のモーダルを閉じて、選択したメールの添付ファイル一覧を別のモーダルで開く
-(void) mailPrint:(UIViewController*)viewController showAttachmentMailView:(UIViewController*)attachmentViewController;
{
    // PrintSelectTypeViewControllerでモーダルを開いている場合のキャンセルはナビゲーションを戻す
    if (arrThumbnails == nil) {
        if(delegate){
            if([delegate respondsToSelector:@selector(closeSelectMailViewShowAttachmentMailView:closeView:)]){
                // デリゲートメソッドの呼び出し(モーダルビューも閉じる)
                [delegate closeSelectMailViewShowAttachmentMailView:self closeView:viewController];
            }
        }
        
    }else {
        
        SelectMailViewController* con = (SelectMailViewController*)viewController;
        
        if(floor(NSFoundationVersionNumber) < NSFoundationVersionNumber_iOS_5_0)
        {
            // モーダルを閉じる
            [con dismissViewControllerAnimated:YES completion:nil];
            
            // 閉じるのを待って次のモーダルを表示
            [self performSelector:@selector(showAttachmentMailView:) withObject:attachmentViewController afterDelay:0.5];
        } else {
            // iOS5以上なら
            // モーダルを閉じる
            [con dismissViewControllerAnimated:YES completion:^{
                AttachmentMailViewController_iPad *pViewController = (AttachmentMailViewController_iPad *)attachmentViewController;
                // モーダル表示
                UINavigationController *navigationController = [[UINavigationController alloc]initWithRootViewController:pViewController];
                navigationController.navigationBar.barStyle = NAVIGATION_BARSTYLE;
                [navigationController setModalPresentationStyle:UIModalPresentationPageSheet];
                
                // モーダル内のビューをひとつ戻す
                [con.navigationController popViewControllerAnimated:NO];
                
                [self presentViewController:navigationController animated:YES completion:^{
                    //                    [self.navigationController pushViewController:viewController animated:NO];
                }];
            }];
        }
    }
}

-(void) showAttachmentMailView:(UIViewController*)attachmentViewController
{
    // 遷移元画面から渡されたIDをもとに遷移先のViewControllerを決定する
    UINavigationController *navigationController = [[UINavigationController alloc]initWithRootViewController:attachmentViewController];
    navigationController.navigationBar.barStyle = NAVIGATION_BARSTYLE;
    [navigationController setModalPresentationStyle:UIModalPresentationPageSheet];
    [self presentViewController:navigationController animated:YES completion:nil];
    
}

- (void)mailAttachmentPrint:(UITableViewController*)viewController upLoadMailView:(NSString*)strFilePath {
    
    if (self.PrintPictViewID == EMAIL_PRINT_VIEW) {
        // メール本文印刷経由で添付ファイル一覧画面に遷移して「閉じる」を押下した場合は、TempAttachementFileを削除しておく
        [TempAttachmentFileUtility deleteMailTmpDir];
    }
    
    AttachmentMailViewController_iPad *con = (AttachmentMailViewController_iPad *)viewController;
    
    if (strFilePath != nil) {
        // 遷移元画面から渡されたIDをもとに遷移先のViewControllerを決定する
        PictureViewController_iPad* pViewController = nil;
        pViewController = [[PrintPictViewController_iPad alloc] init];
        pViewController.SelFilePath	= strFilePath;
        pViewController.isMoveAttachmentMail = YES;
        [self.navigationController pushViewController:pViewController animated:YES];
    } else {
        PrinterData* printerData = nil;
        printerData = [m_pPrinterMgr LoadPrinterDataAtIndexInclude2:[self getSelPickerRowWithIndex:BUTTON_PRINTER]];
        if (printerData == nil) {
            if (m_bResult) {
                [self CreateNoPrinterAlert];
            }
        }
    }
    // モーダルを閉じる
    [con dismissViewControllerAnimated:YES completion:nil];
}

// 印刷用PDFファイルの削除
- (void)deletePrintPDFFile:(NSString*)deleteFilePath {
    // PDFファイルを削除
    TempFile *tempFile = [[TempFile alloc]initWithFileName:[deleteFilePath lastPathComponent]];
    [TempFileUtility deleteFile:tempFile];
}

- (void)showNoImageView {
    // Webページ印刷とE-Mail印刷以外の場合は表示しない
    if (self.PrintPictViewID == EMAIL_PRINT_VIEW || self.PrintPictViewID == WEB_PRINT_VIEW) {
        [self setNoImageHidden:NO];
        
        // NoImage文言設定
        m_pLblNoImage.text = S_LABEL_NO_IMAGE;
        //        if (self.PrintPictViewID == WEB_PRINT_VIEW) {
        //            // Webのキャッシュを削除しておく
        //            [self deletePrintPDFFile:[[CommonUtil tmpDir] stringByAppendingPathComponent: S_SAVE_WEB_FILENAME_FOR_PRINT_PDF]];
        //        } else {
        //            // メールのキャッシュを削除しておく
        //            [self deletePrintPDFFile:[[CommonUtil tmpDir] stringByAppendingPathComponent: S_SAVE_MAIL_FILENAME_FOR_PRINT_PDF]];
        //        }
        // キャッシュを削除しておく
        [self deletePrintPDFFile:self.SelFilePath];
    }
}

- (void)setBtnEnable {
    NSUInteger index = [self.mailFormtArray indexOfObject:@"html"];
    if ((self.PrintPictViewID == WEB_PRINT_VIEW || self.PrintPictViewID == EMAIL_PRINT_VIEW)) {
        // プリンタ情報取得
        PrinterData* printerData = nil;
        printerData = [m_pPrinterMgr LoadPrinterDataAtIndexInclude2:m_pPrinterMgr.DefaultMFPIndex];
        
        if (totalPage > 0 && printerData != nil) {
            for (int i = 0; i < [buttonIdArray count]; i++) {
                UIButton* button = [self getUIButtonByIndex:i];
                [button setEnabled:YES];
            }
            
            // メール本文印刷の時のみ特別制御
            if(self.PrintPictViewID == EMAIL_PRINT_VIEW && index == NSNotFound){
                UIButton* button = [self getUIButtonByIndex:[self getButtonIndex:BUTTON_COLOR]];
                [button setEnabled:NO];
            }
            
            // 両面印刷ボタン非活性判定
            [self setDuplexBtnEnabled];
            
            // リテンションボタン、プリントリリースボタン非活性判定
            [self setRetontionPrintReleaseBtnEnabled];
            
            
        } else {
            for (int i = 0; i < [buttonIdArray count]; i++) {
                UIButton* button = [self getUIButtonByIndex:i];
                [button setEnabled:NO];
            }
        }
    }
}

#pragma mark - Menu ScrollView Manage
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    [super scrollViewDidScroll:self.m_pPreviewScrollView];
    [self scrollViewDidScroll:self.menuScrollView animated:YES];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView animated:(BOOL)animated {
    UIButton* btn = nil;
    BOOL btnOn = 0;
    
    // 上ボタン表示判定
    if (self.menuScrollView.contentOffset.y > 0) {
        if (menuUpBtn.alpha == 0.0) {
            // 表示する
            btnOn = YES;
            btn = menuUpBtn;
        }
    } else {
        if (menuUpBtn.alpha == 1.0) {
            // 非表示にする
            btnOn = NO;
            btn = menuUpBtn;
        }
    }
    if (btn) {
        // 表示を切り替える
        [self showButton:btn on:btnOn animated:animated];
        btn = nil;
    }
    
    // 下ボタン表示判定
    if (self.menuScrollView.contentOffset.y + self.menuScrollView.frame.size.height < self.menuScrollView.contentSize.height) {
        if (menuDownBtn.alpha == 0.0) {
            // 表示する
            btnOn = YES;
            btn = menuDownBtn;
        }
    } else {
        if (menuDownBtn.alpha == 1.0) {
            // 非表示にする
            btnOn = NO;
            btn = menuDownBtn;
        }
    }
    if (btn) {
        // 表示を切り替える
        [self showButton:btn on:btnOn animated:animated];
        btn = nil;
    }
}

- (void)showButton:(UIButton*)btn on:(BOOL)on animated:(BOOL)animated {
    if (animated) {
        // アニメーション
        [UIView animateWithDuration:0.3 animations:^{
            btn.alpha = (on ? 1.0 : 0.0);
        }];
    } else {
        btn.alpha = (on ? 1.0 : 0.0);
    }
}

#pragma mark - UIButton Action
- (IBAction)tapMenuUpBtn:(UIButton *)sender {
    // 最上部までスクロール
    [UIView animateWithDuration:0.3 animations:^{
        self.menuScrollView.contentOffset = CGPointZero;
    }];
}

- (IBAction)tapMenuDownBtn:(UIButton *)sender {
    // 最下部までスクロール
    [UIView animateWithDuration:0.3 animations:^{
        self.menuScrollView.contentOffset = CGPointMake(0, self.menuScrollView.contentSize.height - self.menuScrollView.frame.size.height);
    }];
}

// N-Up、印刷範囲設定に対応する為にJpegから出力ファイルを作成するライブラリを使用する
- (NSString *)MergeJpegToOutputfile {
    if (m_PrintRangeStyle == 0 && self.nNupRow == 0  && !(self.PrintPictViewID == WEB_PRINT_VIEW || self.PrintPictViewID == EMAIL_PRINT_VIEW)) {
        // 1-Upかつ全てのページの場合は処理をしない
        return @"";
    }
    
    if(self.isSingleData && (self.hasEncryptionPdfData || self.hasGeneralPdfData) && isPrintRangeExpansionMode)
    {
        // 初回単数ファイルで暗号化PDFまたは一般PDFの場合で、印刷範囲拡張有効時は、ここでは処理をしない
        return @"";
    }
    
    NSMutableArray* inputFiles = [[NSMutableArray alloc]init];
    NSMutableArray* fileIndexs = [[NSMutableArray alloc]init];
    
    
    
    for (int i = 0; i < [arrThumbnails count]; i++) {
        BOOL bPrint = NO;
        
        NSInteger addCnt = 0;
        
        // 印刷範囲設定
        switch (m_PrintRangeStyle) {
            case 0:
                // 全てのページ
                bPrint = YES;
                addCnt++;
                break;
            case 1:
                // 範囲指定
                if(m_PageFrom <= (i + 1) && (i + 1) <= m_PageTo) {
                    bPrint = YES;
                    addCnt++;
                }
                break;
            case 2: {
                NSArray *parrRangeDirect = [m_PageDirect componentsSeparatedByString:@","];
                
                for (int j = 0 ; j < [parrRangeDirect count]; j++) {
                    NSArray* parrRangeParts = [[parrRangeDirect objectAtIndex:j] componentsSeparatedByString:@"-"];
                    if ([parrRangeParts count] == 1) {
                        if([[parrRangeParts objectAtIndex:0] integerValue] == (i + 1)) {
                            bPrint = YES;
                            addCnt++;
                        }
                    } else {
                        NSUInteger nPrintRangeFrom = 1;
                        NSUInteger nPrintRangeTo = m_PageMax;
                        if ([[parrRangeParts objectAtIndex:0] length] > 0 && [parrRangeParts[0] intValue] > 0) {
                            nPrintRangeFrom = [[parrRangeParts objectAtIndex:0] integerValue];
                        }
                        if ([[parrRangeParts objectAtIndex:1] length] > 0 && [parrRangeParts[1] intValue] > 0) {
                            nPrintRangeTo = [[parrRangeParts objectAtIndex:1] integerValue];
                        }
                        if (nPrintRangeFrom <= (i + 1) && (i + 1) <= nPrintRangeTo) {
                            bPrint = YES;
                            addCnt++;
                        }
                    }
                }
            }
                break;
            default:
                break;
        }
        
        if (bPrint) {
            
            for (NSInteger iCnt = 0; iCnt < addCnt; iCnt++) {
                // 印刷対象のファイルパスを配列に格納する
                [inputFiles addObject:[arrThumbnails objectAtIndex:i]];
                // ファイルインデックスを格納する
                [fileIndexs addObject:[NSString stringWithFormat:@"%d", i]];
            }
            
        }
    }
    
    if ([inputFiles count] == 0) {
        self.m_isPrint = FALSE;
        return @"";
    }
    
    // TempPrintFileフォルダーにファイルがあれば削除
    [NupTempFileUtility initializeNupTmpDir];
    
    // 初期化
    int nSetNup = 1;
    int nSetNupOrder = 0;
    
    // 画面入力値の反映
    switch (self.nNupRow) {
        case 0:
            nSetNup = 1;
            break;
        case 1:
            nSetNup = 2;
            switch (self.nSeqRow) {
                case 0:
                    nSetNupOrder = NUP_ORDER_LEFT_TO_RIGHT;
                    break;
                case 1:
                    nSetNupOrder = NUP_ORDER_RIGHT_TO_LEFT;
                    break;
                default:
                    break;
            }
            break;
        case 2:
            nSetNup = 4;
            switch (self.nSeqRow) {
                case 0:
                    nSetNupOrder = NUP_ORDER_UPPERLEFT_TO_RIGHT;
                    break;
                case 1:
                    nSetNupOrder = NUP_ORDER_UPPERLEFT_TO_BOTTOM;
                    break;
                case 2:
                    nSetNupOrder = NUP_ORDER_UPPERRIGHT_TO_LEFT;
                    break;
                case 3:
                    nSetNupOrder = NUP_ORDER_UPPERRIGHT_TO_BOTTOM;
                    break;
                default:
                    break;
            }
            break;
        default:
            break;
    }
    
    int nRet = 0;
    NupTempFile* nupTempFile;
    
    // マージ処理
    if (self.PrintPictViewID != WEB_PRINT_VIEW && self.PrintPictViewID != EMAIL_PRINT_VIEW)
    {//web　または email以外
        BOOL isError = NO;
        NSInteger selPickerRow = [self getSelPickerRowWithIndex:BUTTON_PAPERSIZE];
        nupTempFile = [NupTempFileUtility createPrintFileFromScanFile:self.SelFilePath FileIndexs:fileIndexs Nup:nSetNup NupOrder:nSetNupOrder PaperSize:(int)selPickerRow IsError:&isError];
        
        if(isError == YES){
            nRet = -1;
        }
    } else {
        if (!m_isAvailablePrintPDF) {
            // PSオプション無し(PDF印刷不可)の場合、TIFFを生成して印刷を行う
            nupTempFile = [NupTempFileUtility createPrintFileTiff:inputFiles];
            if(nupTempFile == nil){
                nRet = -1;
            }
        } else {
            NSInteger selPickerRow = [self getSelPickerRowWithIndex:BUTTON_PAPERSIZE];
            nupTempFile = [NupTempFileUtility createPrintFilePdf:inputFiles Nup:nSetNup NupOrder:nSetNupOrder PaperSize:(int)selPickerRow];
            
            if(nupTempFile == nil){
                nRet = -1;
            }
        }
    }
    
    //エラーチェック
    if(nRet < 0) {
        DLog(@"mergeできませんでした");
        self.m_isPrint = FALSE;
        return @"";
    }
    if (nupTempFile != nil) {
        return nupTempFile.printFilePath;
    } else {
        return @"";
    }
}

- (void)updateMenuAndDataArray
{
    self.hasEncryptionPdfData = NO;
    self.hasN_UpData = NO;
    self.isAllEncryptionPDF = YES;
    self.isAllN_UpData = YES;
    if (self.selectFileArray.count > 1 ||
        self.selectPictArray.count > 1 ||
        self.multiPrintPictTempArray.count > 1) {
        self.isSingleData = NO;
    }
    
    // 複数データパターンになった場合は、isSingleDataをNOに変更する
    if (self.wasMultiDataPattern) {
        self.isSingleData = NO;
    }
    
    self.hasOriginalTiffData = NO;
    self.encryptionPdfDataArray = [NSMutableArray arrayWithCapacity:0];
    self.N_UpDataArray = [NSMutableArray arrayWithCapacity:0];
    self.pdfDataArray = [NSMutableArray arrayWithCapacity:0];
    self.officeDataArray = [NSMutableArray arrayWithCapacity:0];
    CommonManager *commanager = [[CommonManager alloc]init];
    
    if (self.PrintPictViewID == PPV_PRINT_SELECT_FILE_CELL ||
        self.PrintPictViewID == PPV_PRINT_MAIL_ATTACHMENT_CELL )
    {
        
        for (ScanData *scanData in self.selectFileArray) {
            //            UIImage *img = nil;
            NSString *selFilePath = [NSString stringWithFormat:@"%@%@",scanData.fpath,scanData.fname];
            DLog(@"%@",selFilePath);
            
            BOOL useOriginalViewer = [self showOriginalViewerCheck:selFilePath];
            
            BOOL isPDF = [CommonUtil pdfExtensionCheck:selFilePath];
            if (isPDF) {
                // PDFデータ
                [self.pdfDataArray addObject:scanData];
                //                NSInteger iCheckPDFSize = [commanager checkPdfSize:selFilePath firstPage:&img];
                NSInteger iCheckPDFSize = [commanager checkPdfSize:selFilePath];
                if (iCheckPDFSize == CHK_PDF_ENCRYPTED_FILE) {
                    // 暗号化されたPDFデータ
                    self.hasEncryptionPdfData = YES;
                    self.isAllN_UpData = NO;
                    [self.encryptionPdfDataArray addObject:scanData];
                } else {
                    self.isAllEncryptionPDF = NO;
                    if (useOriginalViewer) {
                        // Jpeg抜き出し出来るPDFデータ(N-Up可)
                        self.hasN_UpData = YES;
                        [self.N_UpDataArray addObject:scanData];
                    } else {
                        // Jpeg抜き出し出来ないPDFデータ(N-Up不可)
                        self.isAllN_UpData = NO;
                        self.hasGeneralPdfData = YES;
                    }
                }
            } else {
                // PDF以外
                self.isAllEncryptionPDF = NO;
                self.isAllN_UpData = NO;
                
                if (useOriginalViewer) {
                    BOOL isTiff = [CommonUtil tiffExtensionCheck:selFilePath];
                    if (isTiff) {
                        // 印刷範囲指定が可能なTiffデータ
                        self.hasOriginalTiffData = YES;
                    }
                }
            }
            
            BOOL isOffice = [CommonUtil officeExtensionCheck:selFilePath];
            if(isOffice) {
                self.hasOfficeData = YES;
                [self.officeDataArray addObject:scanData];
            }
        }
        if ([self.selectFileArray count] > 1) {
            //self.hasEncryptionPdfData = NO;
            // 複数ファイル時はN-Up可
            self.hasN_UpData = YES;
            // 印刷範囲指定不可
            self.hasOriginalTiffData = NO;
        }
    } else if (self.PrintPictViewID == PPV_PRINT_SELECT_PICTURE_CELL){
        self.isAllEncryptionPDF = NO;
        self.isAllN_UpData = NO;
        self.hasEncryptionPdfData = NO;
        self.hasN_UpData = NO;
        
        BOOL useOriginalViewer = [self showOriginalViewerCheck:self.SelFilePath];
        if (useOriginalViewer) {
            BOOL isTiff = [CommonUtil tiffExtensionCheck:self.SelFilePath];
            if (isTiff) {
                // 印刷範囲指定が可能なTiffデータ
                self.hasOriginalTiffData = YES;
            }
        }
        
    }
    
    // 印刷対象表示判定
    if (self.isSingleData) {
        if (self.selectFileArray.count == 1) {
            ScanData *scanData = [self.selectFileArray objectAtIndex:0];
            NSString *selFilePath = [NSString stringWithFormat:@"%@%@",scanData.fpath,scanData.fname];
            if ([CommonUtil excelExtensionCheck:selFilePath]) {
                self.showPrintTarget = YES;
                DLog(@"印刷対象表示フラグ：YES");
            }
        }
    }
    
    if (buttonIdArray.count > 0) {
        // Picker値退避
        [self saveAllPickerSelRowValue];
        // メニューボタン配列作成
        buttonIdArray = [self createButtonIdArray];
        // Picker値再設定
        [self inputAllPickerSelRowValue];
    }
    else {
        buttonIdArray = [self createButtonIdArray];
    }
    [self calcPreMenuBtnMaxID];
}

/**
 @brief 設定値、データ配列設定(ファイル印刷、写真印刷、添付ファイル印刷のファイル選択画面以外からの遷移時)
 */
- (void)updateMenuAndDataArrayExceptFilePicMailAtt {
    
    self.hasEncryptionPdfData = NO;
    self.hasN_UpData = NO;
    self.isAllEncryptionPDF = YES;
    self.isAllN_UpData = YES;
    self.isSingleData = YES;
    self.hasOriginalTiffData = NO;
    self.isDuplexPrint = NO;
    // メインビューに表示するボタンの数を決める
    bShowOriginalView = [self showOriginalViewerCheck:self.SelFilePath];
    
    if (bShowOriginalView)
    {
        if ([CommonUtil pngExtensionCheck:self.SelFilePath] ||
            [CommonUtil jpegExtensionCheck:self.SelFilePath]) {
        } else if (![CommonUtil tiffExtensionCheck:self.SelFilePath]){
            // Jpeg抽出した画像の場合
            // N-Up可能
            self.hasN_UpData = YES;
        } else {
            // 拡張子tiffの場合
            // 印刷範囲指定が可能なTiffデータ
            self.hasOriginalTiffData = YES;
        }
    }
    else
    {
        if (![self.SelFilePath isEqualToString:@""] && self.SelFilePath != nil)
        {
            CommonManager *commanager = [[CommonManager alloc]init];
            NSInteger iCheckPDFSize = [commanager checkPdfSize:self.SelFilePath];
            
            if (iCheckPDFSize == CHK_PDF_ENCRYPTED_FILE)
            {
                m_bEncryptedPdf = TRUE;
            }
        }
        
        if ([CommonUtil officeExtensionCheck:self.SelFilePath]) {
            // Officeファイル
            self.hasOfficeData = YES;
        } else if (!m_bEncryptedPdf)
        {
            self.hasGeneralPdfData = YES;
            self.isAllN_UpData = NO;
        }
        else
        {
            // 暗号化PDFの場合
            self.hasEncryptionPdfData = YES;
            self.isAllN_UpData = NO;
        }
    }
    
    // 印刷対象表示判定
    if ([CommonUtil excelExtensionCheck:self.SelFilePath]) {
        self.showPrintTarget = YES;
        DLog(@"印刷対象表示フラグ：YES");
    }
    
    if (buttonIdArray.count > 0) {
        // Picker値退避
        [self saveAllPickerSelRowValue];
        // メニューボタン配列作成
        buttonIdArray = [self createButtonIdArray];
        // Picker値再設定
        [self inputAllPickerSelRowValue];
    }
    else {
        buttonIdArray = [self createButtonIdArray];
    }
    [self calcPreMenuBtnMaxID];
    
}

- (void)calcPreMenuBtnMaxID {
    nPreMenuBtnMaxID = [buttonIdArray count];
    return;
}

/**
 * プリンタの能力情報（PCLオプション・PS拡張キット・Office対応有無を取得する
 * このメソッドを呼び出し後、canPrintPDFプロパティを読め。
 * @return プリンタの通信に成功すればYES
 */
- (BOOL)checkPclPsOfficeOption
{
    DLog(@"start");
    
    PrinterData* printerData = [m_pPrinterMgr LoadPrinterDataAtIndexInclude2:[self getSelPickerRowWithIndex:BUTTON_PRINTER]];
    
    if([printerData getAddStatus] == YES) {
        // 手動追加MFPの場合はすべて印刷可能扱いとする。
        self.canPrint = YES;
        self.canPrintPDF = YES;
        self.canPrintOffice = YES;
        return YES;
    }
    
    // プリンター/スキャナー情報取得中アラート
    [self CreateProgressAlert:nil message:MSG_PRINTEROPTION_GET withCancel:YES];
    
    m_isDoSnmp = YES;
    
    ProfileDataManager* pManager = [[ProfileDataManager alloc]init];
    ProfileData* pData = [pManager loadProfileDataAtIndex:0];
    
    // Community String の設定
    NSMutableArray* communityString = [[NSMutableArray alloc]init];
    if (!pData.snmpSearchPublicMode) {
        [communityString addObject:S_SNMP_COMMUNITY_STRING_DEFAULT];
    }
    NSArray *strStrings = [pData.snmpCommunityString componentsSeparatedByString:@"\n"];
    for (NSString* strTmp in strStrings) {
        [communityString addObject:strTmp];
    }
    
    NSDictionary *dicIPAddr = [CommonUtil getIPAddrDicForComm:[printerData getIPAddress]
                                                         port:[NSString stringWithFormat:@"%@", [NSNumber numberWithInteger:N_SNMP_PORT]]];
    snmpManager = [[SnmpManager alloc]initWithIpAddress:[CommonUtil optIPAddrForComm:[dicIPAddr objectForKey:S_TARGET_IPADDRESS_DIC_KEY]] port:N_SNMP_PORT];
    [snmpManager setCommunityString:communityString];
    
    if(!m_isDoSnmp)
    {
        return NO;
    }
    
    //==========================================================
    //PCL,PS判定開始
    //-------------------------
    //以下のフラグについて判定を行う
    BOOL isExistsPCL = NO;
    BOOL isExistsPS  = NO;
    //-------------------------
    
    //判定実行
    BOOL result = [CommonUtil checkPrinterSpecWithSnmpManager:snmpManager PCL:&isExistsPCL PS:&isExistsPS];
    //PCL,PS判定終了
    //==========================================================

    if(!m_isDoSnmp)
    {
        return NO;
    }
    
    if(result)
    {//情報取得成功
        if (!isExistsPCL) {
            // PCLオプションなし
            self.canPrint = NO;
            self.canPrintPDF = NO;
            m_isAvailablePrintPDF = NO;
        } else if (!isExistsPS) {
            // PSオプションなし
            self.canPrint = YES;
            self.canPrintPDF = NO;
            m_isAvailablePrintPDF = NO;
        } else {
            self.canPrint = YES;
            self.canPrintPDF = YES;
            m_isAvailablePrintPDF = YES;
        }
        
        // Office対応有無取得
        if (isExistsPCL) {
            self.canPrintOffice = [self isCapableOfficePrint:printerData];
        }
        
        m_isDoSnmp = NO;
        
        return YES;
    }
    else
    {//情報取得失敗
        
        if(m_isDoSnmp)
        {
            //既に出ているアラート消す//別スレッドで呼び出されているので、メインスレッドで
            dispatch_async(dispatch_get_main_queue(), ^{
                //既に出ているアラートを消す
                [picture_alert dismissViewControllerAnimated:YES completion:^{
                    [self alertButtonDismiss:picture_alert tagIndex:picture_alert.tag buttonIndex:0];
                    //ネットワークエラー　アラート出す
                    [self CreateAllert:nil message:MSG_NETWORK_ERR btnTitle:MSG_BUTTON_OK];
                }];
                picture_alert = nil;
                
            });
        }
        
        m_isDoSnmp = NO;
        
        return NO;
    }
    
    DLog(@"stop");
}

- (void)checkMenuOptionStatus
{
    
    self.isN_UpSet = (self.nNupRow != 0);
    self.isPrintRangeSet = !([self.m_pstrPrintRange isEqualToString:S_PRINT_RANGE_ALL] || self.m_pstrPrintRange == nil);
    self.isRetentionSet = (self.noPrintOn == YES);
    
    if (self.isN_UpSet && self.isRetentionSet) {
        if (self.isAllN_UpData) {
            self.isContinuePrint = YES;
        } else {
            self.isContinuePrint = NO;
        }
    } else if (self.isN_UpSet) {
        if (self.isAllN_UpData) {
            self.isContinuePrint = YES;
        } else {
            self.isContinuePrint = NO;
        }
    } else if (self.isRetentionSet) {
        if (self.hasEncryptionPdfData) {
            self.isContinuePrint = NO;
        } else {
            self.isContinuePrint = YES;
        }
    } else {
        self.isContinuePrint = YES;
    }
    
    if (self.canPrintPDF == NO) {
        if (self.pdfDataArray.count > 0) {
            self.isContinuePrint = NO;
        }
    }
    
    if (self.canPrintOffice == NO) {
        if (self.officeDataArray.count > 0) {
            self.isContinuePrint = NO;
        }
    }
}

- (void)updatePrintData
{
    NSMutableArray *testArray = [NSMutableArray arrayWithArray:self.selectFileArray];
    if (self.canPrintPDF == NO) {
        [testArray removeObjectsInArray:self.pdfDataArray];
        [self.N_UpDataArray removeAllObjects];
    }
    
    if (self.canPrintOffice == NO) {
        [testArray removeObjectsInArray:self.officeDataArray];
    }
    
    if (self.isN_UpSet) {
        if (self.PrintPictViewID == PPV_PRINT_SELECT_FILE_CELL || self.PrintPictViewID == PPV_PRINT_MAIL_ATTACHMENT_CELL) {
            testArray = self.N_UpDataArray;
        }
    }
    if (self.isRetentionSet) {
        if (self.PrintPictViewID == PPV_PRINT_SELECT_FILE_CELL || self.PrintPictViewID == PPV_PRINT_MAIL_ATTACHMENT_CELL) {
            //self.hasEncryptionPdfData = NO;
            [testArray removeObjectsInArray:self.encryptionPdfDataArray];
        }
    }
    self.isOptionError = NO;

    if( self.PrintPictViewID == PPV_PRINT_SELECT_PICTURE_CELL) {
        _filesToBePrintedArray = self.selectPictArray;
        return;
    }
    
    DLog(@"testCount = %lu",(unsigned long)testArray.count);
    DLog(@"count = %lu",(unsigned long)self.selectFileArray.count);
    
    
    if (testArray.count != self.selectFileArray.count) {
        self.isOptionError = YES;
    }
    _filesToBePrintedArray = testArray;
}

- (NSInteger *) getArrThumbnailsCount
{
    if (self.PrintPictViewID == EMAIL_PRINT_VIEW) {
        return [arrThumbnails count];
        
    }
    return 0;
}

// 印刷前のチェック
- (void)CheckBeforePrinting
{
    // オプション確認
    [self checkMenuOptionStatus];
    
    if (self.isContinuePrint == NO) {
        NSMutableString *confirmMsg = [NSMutableString string];
        [confirmMsg appendFormat:@"%@\n\n",MSG_NOTPRINT_CONFIRM];
        if (self.canPrint && self.canPrintPDF == NO && self.pdfDataArray.count > 0) {
            [confirmMsg appendFormat:@"%@\n",MSG_NOTPRINT_PS];
        }
        if (self.isN_UpSet && self.isAllN_UpData == NO) {
            [confirmMsg appendFormat:@"%@\n",MSG_NOTPRINT_NUP];
        }
        if (self.isRetentionSet && self.hasEncryptionPdfData) {
            [confirmMsg appendFormat:@"%@\n",MSG_NOTPRINT_RETENTION];
        }
        if (self.canPrint && self.canPrintOffice == NO && self.officeDataArray.count > 0) {
            [confirmMsg appendFormat:@"%@\n",MSG_NOTPRINT_OFFICE];
        }
        [confirmMsg appendFormat:@"\n%@",MSG_NOTPRINT_CONFIRM];
        
        [self CreateAlert:nil message:confirmMsg cancelTitle:MSG_BUTTON_CANCEL okTitle:MSG_BUTTON_OK withTag:ALERT_TAG_PRINT_CONFIRM_OPTION_ERROR_RECONFIRM];
    } else {
        [self doPrint];
    }
    
}

//キャッシュを作る（フルパス指定)
-(void)createCashForFile:(NSString*)pstrFilePath
{
    if (pstrFilePath != nil)
    {
        CommonManager *commanager = [[CommonManager alloc]init];
        if([CommonUtil pngExtensionCheck:pstrFilePath] && ![commanager existsCacheDirByScanFilePath:pstrFilePath])
        {
            // PNG形式のときはキャッシュの再作成を試みる
            TempFile *localTempFile = [[TempFile alloc]initWithFileName:pstrFilePath];
            [TempFileUtility createCacheFile:localTempFile];
        }
        if (self.PrintPictViewID == PPV_PRINT_SELECT_FILE_CELL || self.PrintPictViewID == PPV_PRINT_MULTI_FILE_PREVIEW) {
            // キャッシュファイルがないなら作る
            if (![commanager existsCacheDirByScanFilePath:pstrFilePath]) {
                ScanFile *localScanFile = [[ScanFile alloc]initWithScanFilePath:pstrFilePath];
                [ScanFileUtility createCacheFile:localScanFile];
            }
        }
        
        if([commanager existsCacheDirByScanFilePath:pstrFilePath]){
        }else if (self.PrintPictViewID == PPV_PRINT_MAIL_ATTACHMENT_CELL)
        {
            if (![commanager existsCacheDirByScanFilePath:pstrFilePath]) {
                TempAttachmentFile *localTempAttachmentFile = [[TempAttachmentFile alloc]initWithFilePath:pstrFilePath];
                [TempAttachmentFileUtility createCacheFile:localTempAttachmentFile];
            }
        }
    }
}

// アプリケーション動作設定画面に設定中のリテンション設定で初期化する
- (void)initRetention {
    if (!self.initRetentionFlg) {
        if (self.isSingleData && self.hasEncryptionPdfData) {
            // 初回暗号化PDFファイルが１枚の場合のみ、リテンションを初期化しない
            DLog(@"isSingleData:%d",self.isSingleData);
            DLog(@"hasEncryptionPdfData:%d",self.hasEncryptionPdfData);
        } else {
            // プロファイルの取得
            profileDataManager = [[ProfileDataManager alloc] init];
            ProfileData *profileData = nil;
            profileData = [profileDataManager loadProfileDataAtIndex:0];
            // リテンションを初期化する
            self.noPrintOn = profileData.noPrint;
            self.authenticateOn = profileData.retentionAuth;
            self.pstrPassword = profileData.retentionPassword;
            self.initRetentionFlg = YES;
        }
    }
}


// 仕上げの設定を初期化する(viewDidLoadでのみ使用すること)
- (void)initFinishing {
    if (!self.pstrSelectedClosing) {
        self.nClosingRow = 0;
        self.nStapleRow = STAPLE_NONE;
        self.nPunchRow = 0;
        self.pstrSelectedClosing = S_PRINT_BINDINGEDGE_LEFT;
        self.pstrSelectedStaple = S_PRINT_STAPLE_NONE;
        self.pstrSelectedPunch = S_PRINT_PUNCH_NONE;
    }
}

// 印刷範囲拡張有効かどうかを確認する
- (void)checkPdfPrintRangeExpansionMode {
    
    isPrintRangeExpansionMode = NO;
    
    //印刷範囲拡張モード実行可能
    NSUserDefaults* pdfPrintRangeExpansionMode = [NSUserDefaults standardUserDefaults];
    if([pdfPrintRangeExpansionMode boolForKey:S_PDF_PRINT_RANGE_EXPANSION_FLAG])
    {
        isPrintRangeExpansionMode = YES;
    }
}

// 印刷範囲情報を作成する
- (PrintRangeSettingViewController*)makePrintRangeInfo {
    
    PrintRangeSettingViewController *printRangeInfo = [[PrintRangeSettingViewController alloc] initWithStyle:UITableViewStyleGrouped];
    
    //設定値格納
    printRangeInfo.m_PrintRangeStyle = m_PrintRangeStyle;
    printRangeInfo.m_PageMax = m_PageMax;
    printRangeInfo.m_PageFrom = m_PageFrom;
    printRangeInfo.m_PageTo = m_PageTo;
    printRangeInfo.m_PageDirect = m_PageDirect;
    
    //暗号化PDFまたは一般PDFの場合は、「範囲指定」項目を非表示とする
    if (self.isSingleData && (self.hasEncryptionPdfData || self.hasGeneralPdfData) && isPrintRangeExpansionMode) {
        printRangeInfo.noRangeDesignation = YES;
    } else {
        printRangeInfo.noRangeDesignation = NO;
    }
    
    return printRangeInfo;
}

// Office対応有無を取得
- (BOOL)isCapableOfficePrint :(PrinterData*) printerData
{
    NSDictionary *dicIPAddr = [CommonUtil getIPAddrDicForComm:[printerData IpAddress]
                                                         port:[NSString stringWithFormat:@"%@", [NSNumber numberWithInteger:80]]];
    NSURL* url = [NSURL URLWithString: [NSString stringWithFormat:@"http://%@:%d/", [CommonUtil optIPAddrForComm:[dicIPAddr objectForKey:S_TARGET_IPADDRESS_DIC_KEY]], 80]];
    
    RSmfpifManager* mfpManager = [[RSmfpifManager alloc] initWithURL:url];
    mfpManager = [mfpManager updateDataForSync];
    
    return mfpManager.isCapableOfficePrint;
}

#pragma mark - Setting Value For PJL
- (NSInteger)getPrintReleaseValue
{
    if(!self.canPrintRelease) {
        return PRINT_RELEASE_NOT_SUPPORTED;
    }
    if(self.printReleaseOn) {
        return PRINT_RELEASE_ENABLED;
    } else {
        return PRINT_RELEASE_DISABLED;
    }
}

// 印刷対象
- (NSInteger)getPrintTargetValue {
    if (!self.showPrintTarget) {
        return PRINT_TARGET_NOT_AVAILABLE;
    }
    if (self.printAllSheetsOn) {
        return PRINT_TARGET_ALL_SHEETS_ON;
    }
    else {
        return PRINT_TARGET_ALL_SHEETS_OFF;
    }
}


#pragma mark - ボタン表示・非表示判定処理

-(NSArray*)createButtonIdArray
{
    NSMutableArray* tmpButtonIdArray = [[NSMutableArray alloc] init];
    
    // 他アプリで確認
    [tmpButtonIdArray addObject:[NSNumber numberWithInt:BUTTON_OTHERAPP]];
    // XXX
    [tmpButtonIdArray addObject:[NSNumber numberWithInt:BUTTON_PRINTER]];
    // 部数
    [tmpButtonIdArray addObject:[NSNumber numberWithInt:BUTTON_NUM]];
    // 両面/片面
    [tmpButtonIdArray addObject:[NSNumber numberWithInt:BUTTON_DUPLEX]];
    // カラーモード
    [tmpButtonIdArray addObject:[NSNumber numberWithInt:BUTTON_COLOR]];
    // 用紙サイズ
    [tmpButtonIdArray addObject:[NSNumber numberWithInt:BUTTON_PAPERSIZE]];
    // 用紙タイプ
    [tmpButtonIdArray addObject:[NSNumber numberWithInt:BUTTON_PAPERTYPE]];
    // 仕上げ
    if([self visibleFinishingButton]) {
        [tmpButtonIdArray addObject:[NSNumber numberWithInt:BUTTON_FINISHING]];
    }
    // N-Up
    if([self visibleNupButton]) {
        [tmpButtonIdArray addObject:[NSNumber numberWithInt:BUTTON_NUP]];
    }
    // 範囲選択
    if([self visibleRangeButton]) {
        [tmpButtonIdArray addObject:[NSNumber numberWithInt:BUTTON_RANGE]];
    }
    // 印刷対象
    if ([self visibleTargetButton]) {
        [tmpButtonIdArray addObject:[NSNumber numberWithInt:BUTTON_TARGET]];
    }
    // リテンション
    if([self visibleRetentionButton]) {
        [tmpButtonIdArray addObject:[NSNumber numberWithInt:BUTTON_RETENTION]];
    }
    // プリントリリース
    if([self visiblePrintReleaseButton]) {
        [tmpButtonIdArray addObject:[NSNumber numberWithInt:BUTTON_PRINTRELEASE]];
    }
    // XXXで印刷する
    [tmpButtonIdArray addObject:[NSNumber numberWithInt:BUTTON_PRINT]];
    
    return tmpButtonIdArray;
}

-(BOOL)visibleFinishingButton
{
    // ステープルまたはパンチが可能な場合に仕上げボタンを表示する
    if ([self visibleStaple] || [self visiblePunch]) {
        return YES;
    }
    return NO;
}
-(BOOL)visibleNupButton
{
    if (self.isSingleData) {
        if (self.hasN_UpData) {
            return YES;
        }
    } else {
        return YES;
    }
    return NO;
}
-(BOOL)visibleRangeButton
{
    if (self.isSingleData) {
        if (self.hasN_UpData || self.hasOriginalTiffData) {
            return YES;
        } else if ((self.hasEncryptionPdfData || self.hasGeneralPdfData) && isPrintRangeExpansionMode) {
            return YES;
        }
    }
    return NO;
}
// 印刷対象
- (BOOL)visibleTargetButton {
    
    if (self.showPrintTarget) {
        return YES;
    }
    return NO;
}

-(BOOL)visibleRetentionButton
{
    if (self.isSingleData && self.hasEncryptionPdfData) {
        return NO;
    }
    return YES;
    
}
-(BOOL)visiblePrintReleaseButton
{
    return self.canPrintRelease;
}

#pragma mark - ボタン位置と機能を関連付けする処理

-(NSInteger)getButtonIndex:(enum PRINTER_SETTING_BUTTON) buttonId
{
    for (int i = 0; i < [buttonIdArray count]; i++) {
        enum PRINTER_SETTING_BUTTON tmpButtonId = [[buttonIdArray objectAtIndex:i] intValue];
        if(buttonId == tmpButtonId) {
            return i;
        }
    }
    return -1;
}

-(UIButton*)getUIButtonByIndex:(NSInteger) index
{
    switch (index) {
        case 0:
            return self.m_pbtnFirst;
        case 1:
            return self.m_pbtnSecond;
        case 2:
            return self.m_pbtnThird;
        case 3:
            return self.m_pbtnFourth;
        case 4:
            return self.m_pbtnFifth;
        case 5:
            return self.m_pbtnSixth;
        case 6:
            return self.m_pbtnSeventh;
        case 7:
            return self.m_pbtnEighth;
        case 8:
            return self.m_pbtnNinth;
        case 9:
            return self.m_pbtnTenth;
        case 10:
            return self.m_pbtnEleventh;
        case 11:
            return self.m_pbtnTwelveth;
        case 12:
            return self.m_pbtnThirteenth;
        case 13:
            return self.m_pbtnFourteenth;
        default:
            return nil;
    }
}

-(UILabel*)getUILabelByIndex:(NSInteger) index
{
    switch (index) {
        case 0:
            // 「他アプリで確認」は「nil」を返す
            return nil;
        case 1:
            return m_plblSecond;
        case 2:
            return m_plblThird;
        case 3:
            return m_plblFourth;
        case 4:
            return m_plblFifth;
        case 5:
            return m_plblSixth;
        case 6:
            return m_plblSeventh;
        case 7:
            return m_plblEighth;
        case 8:
            return m_plblNinth;
        case 9:
            return m_plblTenth;
        case 10:
            return m_plblEleventh;
        case 11:
            return m_plblTwelveth;
        case 12:
            return m_plblThirteenth;
        case 13:
            // 「印刷する」は「nil」を返す
            return nil;
        default:
            return nil;
    }
}


-(UIImageView*)getUIImageViewByIndex:(NSInteger) index
{
    switch (index) {
        case 0:
            // 「他アプリで確認」は「nil」を返す
            return nil;
        case 1:
            return m_pimgSecond;
        case 2:
            return m_pimgThird;
        case 3:
            return m_pimgFourth;
        case 4:
            return m_pimgFifth;
        case 5:
            return m_pimgSixth;
        case 6:
            return m_pimgSeventh;
        case 7:
            return m_pimgEighth;
        case 8:
            return m_pimgNinth;
        case 9:
            return m_pimgTenth;
        case 10:
            return m_pimgEleventh;
        case 11:
            return m_pimgTwelveth;
        case 12:
            return m_pimgThirteenth;
        case 13:
            // 「印刷する」は「nil」を返す
            return nil;
        default:
            return nil;
    }
}



-(void)OnMenuButtonActionByIndex:(UIButton*)senderBtn index:(NSInteger) index
{
    // 処理中あるいは処理中断フラグ=TRUEの場合は何もしない
    if (m_pThread || m_bAbort)
    {
        return;
    }
    
    DLog(@"button%zd押下", index+1);
    
    enum PRINTER_SETTING_BUTTON buttonId = [[buttonIdArray objectAtIndex:index] intValue];
    switch (buttonId) {
        case BUTTON_OTHERAPP:
            [self otherAppBtnAction];
            break;
        case BUTTON_PRINTER:
            [self printerBtnAction];
            break;
        case BUTTON_NUM:
            [self numBtnAction];
            break;
        case BUTTON_DUPLEX:
            [self duplexBtnAction];
            break;
        case BUTTON_COLOR:
            [self colorModeBtnAction];
            break;
        case BUTTON_PAPERSIZE:
            [self paperSizeBtnAction];
            break;
        case BUTTON_PAPERTYPE:
            [self PaperTypeBtnAction];
            break;
        case BUTTON_FINISHING:
            [self finishingBtnAction];
            break;
        case BUTTON_NUP:
            [self NUpBtnAction];
            break;
        case BUTTON_RANGE:
            [self PrintRangeBtnAction:senderBtn];
            break;
        case BUTTON_TARGET:
            [self printTargetBtnAction];
            break;
        case BUTTON_RETENTION:
            [self RetentionBtnAction:senderBtn];
            break;
        case BUTTON_PRINTRELEASE:
            [self printReleaseBtnAction:senderBtn];
            break;
        case BUTTON_PRINT:
            [self PrintBtnAction];
            break;
        default:
            break;
    }
}


#pragma mark - PrintRelease関連対応
// メニューボタン再生成
- (void)remakeMenuButton:(NSInteger)selRow {
    
    // メニューの初期化
    [self removeMenuButton];
    // メニューボタン配列作成
    if (buttonIdArray.count > 0) {
        // Picker値退避
        [self saveAllPickerSelRowValue];
        // メニューボタン配列作成
        buttonIdArray = [self createButtonIdArray];
        // Picker値再設定
        [self inputAllPickerSelRowValue];
    }
    else {
        buttonIdArray = [self createButtonIdArray];
    }
    [self calcPreMenuBtnMaxID];
    
    // メニューボタン作成
    [self updateMenuView:YES andSelRow:selRow];
    
}

// メニュー初期化
- (void)removeMenuButton {
    
    for (int i = 0; i < [buttonIdArray count]; i++) {
        UIButton* button = [self getUIButtonByIndex:i];
        if (button != nil) {
            [button removeFromSuperview];
            button = nil;
        }
        
        UILabel *label = [self getUILabelByIndex:i];
        if (label != nil) {
            [label removeFromSuperview];
            label = nil;
        }
        
        UIImageView *imgView = [self getUIImageViewByIndex:i];
        if (imgView != nil) {
            [imgView removeFromSuperview];
            imgView = nil;
        }
        
    }
}

// ステープル可否およびパンチ可否状態の取得
- (FinishingData*)setStaplePunchState:(NSInteger)selRow {
    
    // 選択中のMFP
    PrinterData* printerData = [m_pPrinterMgr LoadPrinterDataAtIndexInclude2:selRow];
    
    snmpManager = [CommonUtil createSnmpManager:printerData];
    
    if (printerData == nil) {
        return nil;
    } else {
        // ステープルおよびパンチの状態を取得
        return [CommonUtil checkPrinterSpecStaplePunchWithSnmpManager:snmpManager];
    }
    
}

// プリントリリースボタン表示非表示処理
- (BOOL)checkCanPrintRelease:(NSInteger)selRow{
    
    // プリンタ情報格納変数宣言
    NSInteger selPickerRow = selRow;
    
    PrinterData* printerData = (selPickerRow != m_pPrinterMgr.DefaultMFPIndex) ? [m_pPrinterMgr LoadPrinterDataAtIndexInclude2:selPickerRow] : [m_pPrinterMgr LoadPrinterDataAtIndexInclude2:m_pPrinterMgr.DefaultMFPIndex];
    
    // プリンタ情報のプリントリリース対応フラグチェック
    if (printerData.isCapablePrintRelease == YES) {
        // プリントリリースボタンの表示フラグの判定及び設定(通信して最新の情報取得等)
        return [self setCanPrintReleaseState:selRow];
    }
    else {
        return NO;
    }
}


// プリントリリースできるかどうかのフラグ設定処理
- (BOOL)setCanPrintReleaseState:(NSInteger)selRow {
    
    SharpScanPrintAppDelegate* appDelegate = (SharpScanPrintAppDelegate*)[[UIApplication sharedApplication] delegate];
    // 処理実行フラグON
    appDelegate.IsRun = TRUE;
    
    if ([self checkDisplayPrintReleaseButton:selRow] == 1) {
        return YES;
    }
    else {
        return NO;
    }
    
    // 処理実行フラグOFF
    appDelegate.IsRun = FALSE;
}

/**
 @brief プリントリリースのボタンを表示するかどうかの判定(通信して最新の情報を取得)
 @details 0:非表示、1:表示、-1:エラー
 */
-(NSInteger)checkDisplayPrintReleaseButton:(NSInteger)selRow
{
    
    // プリンタ情報格納変数宣言
    PrinterData* newData = [m_pPrinterMgr LoadPrinterDataAtIndex2:selRow];
    
    // プリントリリース対応判定
    NSDictionary *dicIPAddr = [CommonUtil getIPAddrDicForComm:newData.IpAddress
                                                         port:[NSString stringWithFormat:@"%@", [NSNumber numberWithInteger:80]]];
    NSURL* url = [NSURL URLWithString:[NSString stringWithFormat:@"http://%@:%d/", [CommonUtil optIPAddrForComm:[dicIPAddr objectForKey:S_TARGET_IPADDRESS_DIC_KEY]], 80]];
    RSmfpifManager* mfpManager = [[RSmfpifManager alloc] initWithURL:url];
    
    mfpManager.parserDelegate = self;
    BOOL isSucceeded = [mfpManager updateData];
    isParseEnd = FALSE;
    NSDate *startDate = [NSDate date];
    // Xmlパースが終了するまで待つ
    while (!isParseEnd)
    {
        [[NSRunLoop currentRunLoop]runUntilDate:[NSDate dateWithTimeIntervalSinceNow:0.1f]];
        
        // もし、10秒 以上経過していたら終了する
        // または検索をキャンセルした場合終了する
        if ([[NSDate date] timeIntervalSinceDate:startDate] > 10)
        {
            isParseEnd = YES;
            DLog(@"Parse Time out 10sec");
        }
        
        // 処理中フラグ判定
        if([self isDidEnterBackground])
        {
            return -1;
        }
        
    }
    
    //リクエスト時にエラー
    if(!isSucceeded){
        return -1;
    }
    //ネットワークエラー
    if([mfpManager.errCode isEqualToString:@"NETWORK_ERROR"]){
        DLog(@"ネットワークエラー errorCode:%@",mfpManager.errCode);
        return -1;
    }
    
    //通信エラー（statusCodeが200番台以外）
    if(mfpManager.statusCodeNumber/100 != 2){
        DLog(@"通信 statusCode:%ld",(long)mfpManager.statusCodeNumber);
        [mfpManager disconnect];
        return -1;
    }
    
    //xmlパース失敗
    if([mfpManager.errCode isEqualToString:@"XML_PARSE_ERROR"]){
        DLog(@"パースエラー errorCode:%@",mfpManager.errCode);
        [mfpManager disconnect];
        return -1;
    }
    
    [newData setIsCapablePrintRelease:[mfpManager isCapablePrintRelease]];
    
    if(newData.isCapablePrintRelease){
        
        url = [NSURL URLWithString: [NSString stringWithFormat:@"http://%@:%d/", [CommonUtil optIPAddrForComm:[dicIPAddr objectForKey:S_TARGET_IPADDRESS_DIC_KEY]], 80]];
        RSmfpifServiceManager* mfpifServiceManager;
        mfpifServiceManager = [[RSmfpifServiceManager alloc] initWithURL:url];
        
        mfpifServiceManager.parserDelegate = self;
        mfpifServiceManager.setPrintReleaseDataReceiveGetFlag = YES;
        [mfpifServiceManager updateData:mfpManager.serviceUrl];
        
        isParseEnd = FALSE;
        startDate = [NSDate date];
        // Xmlパースが終了するまで待つ
        while (!isParseEnd)
        {
            [[NSRunLoop currentRunLoop]runUntilDate:[NSDate dateWithTimeIntervalSinceNow:0.1f]];
            
            // もし、10秒 以上経過していたら終了する
            // または検索をキャンセルした場合終了する
            if ([[NSDate date] timeIntervalSinceDate:startDate] > 10)
            {
                isParseEnd = YES;
                DLog(@"Parse Time out 10sec");
            }
            
            if([self isDidEnterBackground])
            {
                return -1;
            }
        }
        newData.enabledDataReceive = mfpifServiceManager.enabledDataReceive;
        
        if (newData.enabledDataReceive == YES) {
            return 1;
        }
    }
    
    return 0;
}


- (BOOL) isDidEnterBackground
{
    DLog(@"%s", __PRETTY_FUNCTION__);
    SharpScanPrintAppDelegate* appDelegate = (SharpScanPrintAppDelegate*)[[UIApplication sharedApplication] delegate];
    // 処理実行フラグ
    return (!appDelegate.IsRun);
}

// メッセージアラート表示
-(void)popupMessageAlert:(NSString*)message
{
    m_pAlertCommProcess = [ExAlertController alertControllerWithTitle:nil
                                                              message:message
                                                       preferredStyle:UIAlertControllerStyleAlert];
    m_pAlertCommProcess.tag = ALERT_TAG_COMMPROCESS;
    // Cancel用のアクションを生成
    UIAlertAction *cancelAction =
    [UIAlertAction actionWithTitle:MSG_BUTTON_CANCEL
                             style:UIAlertActionStyleCancel
                           handler:^(UIAlertAction * action) {
                               
                               // ボタンタップ時の処理
                               [self alertButtonPushed:m_pAlertCommProcess tagIndex:m_pAlertCommProcess.tag buttonIndex:0];
                           }];
    // コントローラにアクションを追加
    [m_pAlertCommProcess addAction:cancelAction];
    
    // アラート表示処理
    [self presentViewController:m_pAlertCommProcess animated:YES completion:nil];
    
}


// ボタン再生成時のボタンのEnabled設定
- (void)setButtonEnabledWhenRemakeButton {
    
    // ボタンを活性化する。
    for (int i = 0; i < [buttonIdArray count]; i++) {
        UIButton* button = [self getUIButtonByIndex:i];
        [button setEnabled:YES];
    }
    if(self.PrintPictViewID == EMAIL_PRINT_VIEW){
        //NSUInteger index = [self.mailFormatArray indexOfObject:@"html"];
        //UIButton* colorButton = [self getUIButtonByIndex:[self getButtonIndex:BUTTON_COLOR]];
        //[colorButton setEnabled:(index != NSNotFound)];
    }
    
    // 両面印刷ボタンの活性/非活性
    [self setDuplexBtnEnabled];
    // リテンションボタンの活性非活性処理
    [self setRetentionButtonEnabled];
    // プリントリリースボタン活性非活性処理
    [self setPrintReleaseButtonEnabled];
    
    // プリンターが登録されていないか、複数ファイル印刷でファイルが一つも選択されていない場合はボタンを非活性にする ---> iPadの場合は単数でも
    //if(selectedPrinterPrimaryKey == nil || (!self.isSingleData && [self.selectFileArray count] == 0 && [self.selectPictArray count] == 0))
    if(selectedPrinterPrimaryKey == nil || ([self.selectFileArray count] == 0 && [self.selectPictArray count] == 0))
    {
        if (self.PrintPictViewID != PPV_OTHER) {
            
            for (int i = 0; i < [buttonIdArray count]; i++) {
                UIButton* button = [self getUIButtonByIndex:i];
                [button setEnabled:NO];
            }
            
            // 他アプリで確認は単数のファイル系印刷の時で表示できるときは必ず押せる。 ---> iPad版は複数印刷でもボタンが表示されているのでファイルが選択されている場合のみ活性
            if (self.selectFileArray.count > 0 || self.selectPictArray.count > 0) {
                UIButton* otherButton = [self getUIButtonByIndex:[self getButtonIndex:BUTTON_OTHERAPP]];
                if (otherButton == nil) {
                    [otherButton setEnabled:YES];
                }
            }
            
        }
        
    }
    
}

/**
 @brief リテンションボタン活性非活性処理
 @details ボタン再生成時に使用
 */
- (void)setRetentionButtonEnabled {
    
    // リテンションが「ホールドする」の場合、プリントリリースを「しない」に設定
    if (self.noPrintOn) {
        self.printReleaseOn = NO;
    }
    
    if (self.canPrintRelease) {
        
        if (self.printReleaseOn == YES) {
            // 「する」に設定されている場合
            UIButton* retentionButton = [self getUIButtonByIndex:[self getButtonIndex:BUTTON_RETENTION]];
            if (retentionButton != nil) {
                [retentionButton setEnabled:NO];
            }
        }
        else {
            // 「しない」に設定されている場合
            UIButton* retentionButton = [self getUIButtonByIndex:[self getButtonIndex:BUTTON_RETENTION]];
            if (retentionButton != nil) {
                [retentionButton setEnabled:YES];
            }
        }
    }
    
}

/**
 @brief プリントリリースボタン活性非活性処理
 @details ボタン再生成時に使用
 */
- (void) setPrintReleaseButtonEnabled {
    
    if (self.canPrintRelease) {
        
        // プリントリリースボタンを非活性
        if (self.noPrintOn) {
            UIButton* printReleaseButton = [self getUIButtonByIndex:[self getButtonIndex:BUTTON_PRINTRELEASE]];
            if (printReleaseButton != nil) {
                [printReleaseButton setEnabled:NO];
            }
            
        }
        else {
            // 活性
            UIButton* printReleaseButton = [self getUIButtonByIndex:[self getButtonIndex:BUTTON_PRINTRELEASE]];
            if (printReleaseButton != nil) {
                [printReleaseButton setEnabled:YES];
            }
            
        }
    }
    
}

/**
 @brief リテンションボタンとプリントリリースボタンの活性非活性を設定する
 @details フラグの変更はしない
 */
- (void)setRetontionPrintReleaseBtnEnabled {
    
    // リテンションボタンの非活性
    // プリントリリースボタンが表示されているか判定
    if (self.canPrintRelease) {
        // 「する」に設定されているか判定
        if (self.printReleaseOn == YES) {
            UIButton* retentionButton = [self getUIButtonByIndex:[self getButtonIndex:BUTTON_RETENTION]];
            if (retentionButton != nil) {
                [retentionButton setEnabled:NO];
            }
            
        }
    }
    
    // プリントリリースボタンの非活性
    if (self.noPrintOn) {
        UIButton* printReleaseButton = [self getUIButtonByIndex:[self getButtonIndex:BUTTON_PRINTRELEASE]];
        if (printReleaseButton != nil) {
            [printReleaseButton setEnabled:NO];
        }
        
    }
}

#pragma mark - RSHttpCommunicationManager delegate

-(void)rsManagerDidFinishParsing:(RSHttpCommunicationManager*)manager
{
    // 終了
    isParseEnd = YES;
}

-(void)rsManagerDidFailWithError:(RSHttpCommunicationManager*)manager
{
    // 終了
    isParseEnd = YES;
    DLog(@"Parse Failed.");
}


#pragma mark - PaperSizeItem
/**
 @brief 用紙サイズPickerViewに表示する項目を返す
 */
- (NSMutableArray*)getPaperSizeArray {
    
    NSMutableArray *paperSizeArray = [[NSMutableArray alloc] init];
    // A2
    [paperSizeArray addObject:S_PRINT_PAPERSIZE_A3WIDE];
    [paperSizeArray addObject:S_PRINT_PAPERSIZE_A3];
    [paperSizeArray addObject:S_PRINT_PAPERSIZE_A4];
    [paperSizeArray addObject:S_PRINT_PAPERSIZE_A5];
    [paperSizeArray addObject:S_PRINT_PAPERSIZE_B4];
    [paperSizeArray addObject:S_PRINT_PAPERSIZE_B5];
    // 12x18
    [paperSizeArray addObject:S_PRINT_PAPERSIZE_LEDGER];
    [paperSizeArray addObject:S_PRINT_PAPERSIZE_LETTER];
    // 8.5 x 13.4
    [paperSizeArray addObject:S_PRINT_PAPERSIZE_LEGAL];
    [paperSizeArray addObject:S_PRINT_PAPERSIZE_EXECUTIVE];
    [paperSizeArray addObject:S_PRINT_PAPERSIZE_INVOICE];
    [paperSizeArray addObject:S_PRINT_PAPERSIZE_FOOLSCAP];
    [paperSizeArray addObject:S_PRINT_PAPERSIZE_CHINESE8K];
    [paperSizeArray addObject:S_PRINT_PAPERSIZE_CHINESE16K];
    // 216 x 343
    [paperSizeArray addObject:S_PRINT_PAPERSIZE_DL];
    [paperSizeArray addObject:S_PRINT_PAPERSIZE_C5];
    [paperSizeArray addObject:S_PRINT_PAPERSIZE_COM10];
    [paperSizeArray addObject:S_PRINT_PAPERSIZE_MONARCH];
    [paperSizeArray addObject:S_PRINT_PAPERSIZE_JPOST];
    [paperSizeArray addObject:S_PRINT_PAPERSIZE_KAKUGATA2];
    [paperSizeArray addObject:S_PRINT_PAPERSIZE_CHOKEI3];
    [paperSizeArray addObject:S_PRINT_PAPERSIZE_YOKEI2];
    [paperSizeArray addObject:S_PRINT_PAPERSIZE_YOKEI4];
    
    return paperSizeArray;
}

/**
 @brief 用紙サイズ用PJL配列を返す
 */
- (NSMutableArray*)getPaperSizePJLArray {
    
    NSMutableArray* pjlArray = [[NSMutableArray alloc]init];
    // A2
    [pjlArray addObject:S_PJL_PAPERSIZE_A3WIDE];
    [pjlArray addObject:S_PJL_PAPERSIZE_A3];
    [pjlArray addObject:S_PJL_PAPERSIZE_A4];
    [pjlArray addObject:S_PJL_PAPERSIZE_A5];
    [pjlArray addObject:S_PJL_PAPERSIZE_B4];
    [pjlArray addObject:S_PJL_PAPERSIZE_JISB5];
    // 12x18
    [pjlArray addObject:S_PJL_PAPERSIZE_LEDGER];
    [pjlArray addObject:S_PJL_PAPERSIZE_LETTER];
    // 8.5 x 13.4
    [pjlArray addObject:S_PJL_PAPERSIZE_LEGAL];
    [pjlArray addObject:S_PJL_PAPERSIZE_EXECUTIVE];
    [pjlArray addObject:S_PJL_PAPERSIZE_INVOICE];
    [pjlArray addObject:S_PJL_PAPERSIZE_FOOLSCAP];
    [pjlArray addObject:S_PJL_PAPERSIZE_CHINESE8K];
    [pjlArray addObject:S_PJL_PAPERSIZE_CHINESE16K];
    // 216 x 343
    [pjlArray addObject:S_PJL_PAPERSIZE_DL];
    [pjlArray addObject:S_PJL_PAPERSIZE_C5];
    [pjlArray addObject:S_PJL_PAPERSIZE_COM10];
    [pjlArray addObject:S_PJL_PAPERSIZE_MONARCH];
    [pjlArray addObject:S_PJL_PAPERSIZE_JPOST];
    [pjlArray addObject:S_PJL_PAPERSIZE_KAKUGATA2];
    [pjlArray addObject:S_PJL_PAPERSIZE_CHOKEI3];
    [pjlArray addObject:S_PJL_PAPERSIZE_YOKEI2];
    [pjlArray addObject:S_PJL_PAPERSIZE_YOKEI4];
    
    return pjlArray;
}

#pragma mark - PaperType

/**
 @brief 用紙タイプPickerViewに表示する項目を返す
 */
- (NSMutableArray*)getPaperTypeItems {
    
    NSMutableArray* paperTypeArray = [self getPaperTypeFixedItems];
    
    // はがきを追加するかどうか判定
    if ([self isPaperSizeHagakiSelected]) {
        [paperTypeArray addObject:S_PRINT_PAPERTYPE_POSTCARD];
    }
    // 封筒を追加するかどうか判定
    else if ([self isPaperSizeEnvelopeSelected]) {
        [paperTypeArray addObject:S_PRINT_PAPERTYPE_ENVELOPE];
    }
    
    return paperTypeArray;
    
}

/**
 @brief 用紙タイプPickerViewに表示する固定部分の項目を返す
 */
- (NSMutableArray*)getPaperTypeFixedItems {
    
    NSMutableArray* paperTypeArray = [NSMutableArray array];
    
    [paperTypeArray addObject:S_PRINT_PAPERTYPE_AUTOSELECT];
    [paperTypeArray addObject:S_PRINT_PAPERTYPE_PLAIN];
    [paperTypeArray addObject:S_PRINT_PAPERTYPE_LETTERHEAD];
    [paperTypeArray addObject:S_PRINT_PAPERTYPE_PREPRINTED];
    [paperTypeArray addObject:S_PRINT_PAPERTYPE_PREPUNCHED];
    [paperTypeArray addObject:S_PRINT_PAPERTYPE_RECYCLED];
    [paperTypeArray addObject:S_PRINT_PAPERTYPE_COLOR];
    [paperTypeArray addObject:S_PRINT_PAPERTYPE_LABELS];
    [paperTypeArray addObject:S_PRINT_PAPERTYPE_HEAVYPAPER];
    [paperTypeArray addObject:S_PRINT_PAPERTYPE_TRANSPARENCY];
    
    return paperTypeArray;
}

/**
 @brief 用紙タイプ用PJL配列を返す
 */
- (NSMutableArray*)getPaperTypePJL {
    
    NSMutableArray* pjlArray = [self getPaperTypeFixedItemsPJL];
    
    // はがきを追加するかどうか判定
    if ([self isPaperSizeHagakiSelected]) {
        [pjlArray addObject:S_PJL_PAPERTYPE_POSTCARD];
    }
    // 封筒を追加するかどうか判定
    else if ([self isPaperSizeEnvelopeSelected]) {
        [pjlArray addObject:S_PJL_PAPERTYPE_ENVELOPE];
    }
    
    return pjlArray;
}

/**
 @brief 用紙タイプの固定表示項目のPJLを返す
 */
- (NSMutableArray*)getPaperTypeFixedItemsPJL {
    
    NSMutableArray* pjlArray = [[NSMutableArray alloc]init];
    
    [pjlArray addObject:S_PJL_PAPERTYPE_AUTOSELECT];
    [pjlArray addObject:S_PJL_PAPERTYPE_PLAIN];
    [pjlArray addObject:S_PJL_PAPERTYPE_LETTERHEAD];
    [pjlArray addObject:S_PJL_PAPERTYPE_PREPRINTED];
    [pjlArray addObject:S_PJL_PAPERTYPE_PREPUNCHED];
    [pjlArray addObject:S_PJL_PAPERTYPE_RECYCLED];
    [pjlArray addObject:S_PJL_PAPERTYPE_COLOR];
    [pjlArray addObject:S_PJL_PAPERTYPE_LABELS];
    [pjlArray addObject:S_PJL_PAPERTYPE_HEAVYPAPER];
    [pjlArray addObject:S_PJL_PAPERTYPE_TRANSPARENCY];
    
    return pjlArray;
}

/**
 @brief 用紙タイプのピッカーで「はがき」と「封筒」に当たる行番号を返す
 */
- (NSInteger)getPickerRowNoPostCardEnvelope {
    return [self getPaperTypeFixedItems].count - 1 + 1;
}

/**
 @brief 選択されている用紙サイズがはがきか判定する
 */
- (BOOL)isPaperSizeHagakiSelected {
    
    if ([self.m_pstrPaperSize isEqualToString:S_PRINT_PAPERSIZE_JPOST]) {
        
        return YES;
    }
    
    return NO;
}

/**
 @brief 選択されている用紙サイズが封筒か判定する
 */
- (BOOL)isPaperSizeEnvelopeSelected {
    
    if ([self.m_pstrPaperSize isEqualToString:S_PRINT_PAPERSIZE_DL]
        || [self.m_pstrPaperSize isEqualToString:S_PRINT_PAPERSIZE_C5]
        || [self.m_pstrPaperSize isEqualToString:S_PRINT_PAPERSIZE_COM10]
        || [self.m_pstrPaperSize isEqualToString:S_PRINT_PAPERSIZE_MONARCH]
        || [self.m_pstrPaperSize isEqualToString:S_PRINT_PAPERSIZE_KAKUGATA2]
        || [self.m_pstrPaperSize isEqualToString:S_PRINT_PAPERSIZE_CHOKEI3]
        || [self.m_pstrPaperSize isEqualToString:S_PRINT_PAPERSIZE_YOKEI2]
        || [self.m_pstrPaperSize isEqualToString:S_PRINT_PAPERSIZE_YOKEI4]
        
        ) {
        
        return YES;
    }
    
    return NO;
}

/**
 @brief 選択されている用紙タイプがはがきか封筒であるか判定する
 */
- (BOOL)isPaperTypeSelectedHagakiOrEnvelope {
    
    if ([self.m_pstrPaperType isEqualToString:S_PRINT_PAPERTYPE_POSTCARD]
        || [self.m_pstrPaperType isEqualToString:S_PRINT_PAPERTYPE_ENVELOPE])
    {
        return YES;
    }
    return NO;
}

/**
 @brief 用紙サイズが選択された場合の用紙タイプの選択処理
 */
- (void)setPaperTypeSelection {
    
    // 用紙サイズがはがきの場合
    if ([self isPaperSizeHagakiSelected]) {
        // 用紙タイプの選択をはがきにする
        self.m_pstrPaperType = S_PRINT_PAPERTYPE_POSTCARD;
        self.m_pstrPaperTypePJL = S_PJL_PAPERTYPE_POSTCARD;
        [self setSelPickerRowWithIndex:BUTTON_PAPERTYPE andRow:[self getPickerRowNoPostCardEnvelope]];
        [self setMenuButtonTitleWithBtnID:BUTTON_PAPERTYPE andItemValue:self.m_pstrPaperType];
        self.isInvalidDuplexType = YES;
        self.isInvalidStaplePaperType = YES;
        self.isInvalidPunchPaperType = YES;
    }
    // 用紙サイズが封筒の場合
    else if ([self isPaperSizeEnvelopeSelected]) {
        // 用紙タイプの選択を封筒にする
        self.m_pstrPaperType = S_PRINT_PAPERTYPE_ENVELOPE;
        self.m_pstrPaperTypePJL = S_PJL_PAPERTYPE_ENVELOPE;
        [self setSelPickerRowWithIndex:BUTTON_PAPERTYPE andRow:[self getPickerRowNoPostCardEnvelope]];
        [self setMenuButtonTitleWithBtnID:BUTTON_PAPERTYPE andItemValue:self.m_pstrPaperType];
        self.isInvalidDuplexType = YES;
        self.isInvalidStaplePaperType = YES;
        self.isInvalidPunchPaperType = YES;
    }
    // 用紙サイズがはがきと封筒以外で用紙タイプがはがきか封筒の場合
    else if ([self isPaperTypeSelectedHagakiOrEnvelope]) {
        // 用紙タイプの選択を自動給紙にする
        self.m_pstrPaperType = S_PRINT_PAPERTYPE_AUTOSELECT;
        self.m_pstrPaperTypePJL = S_PJL_PAPERTYPE_AUTOSELECT;
        [self setSelPickerRowWithIndex:BUTTON_PAPERTYPE andRow:0];
        [self setMenuButtonTitleWithBtnID:BUTTON_PAPERTYPE andItemValue:self.m_pstrPaperType];
        self.isInvalidDuplexType = NO;
        self.isInvalidStaplePaperType = NO;
        self.isInvalidPunchPaperType = NO;
        
        if (!self.isInvalidDuplexSize) {
            // 両面印刷ボタンを活性化
            UIButton *btnDuplex = [self getUIButtonByIndex:[self getButtonIndex:BUTTON_DUPLEX]];
            [btnDuplex setEnabled:YES];
        }
        
    }
}

#pragma mark - PrintTarget
/**
 @brief 印刷対象PickerViewに表示する固定部分の項目を返す
 */
- (NSMutableArray*)getPrintTargetPickerItems {
    
    NSMutableArray* printTargetArray = [NSMutableArray array];
    
    [printTargetArray addObject:S_PRINT_WHAT_SELECTED];
    [printTargetArray addObject:S_PRINT_WHAT_ALL];
    
    return printTargetArray;
}

#pragma mark - Common
/**
 @brief メニューボタンのタイトルを設定
 @param btnId:メニューボタンのID strItemName:選択されている項目名
 */
- (void)setMenuButtonTitleWithBtnID:(enum PRINTER_SETTING_BUTTON)btnId andItemValue:(NSString*)strValue {
    
    UIButton* button = [self getUIButtonByIndex:[self getButtonIndex:btnId]];
    [button setTitle:strValue forState:UIControlStateNormal];
}

/**
 @brief PictureViewのピッカー作成処理(プリンターボタン以外の場合)
 @details pickerItem2の引数にnilを設定してcallShowPickerViewメソッドを呼ぶ
 @param btnId:ボタンID andPickerItems1:ピッカーに表示する項目1
 */
- (void)callShowPickerView:(enum PRINTER_SETTING_BUTTON)btnId
            andPickerItems:(NSMutableArray*)arrPickerItems
{
    [self callShowPickerView:btnId andPickerItems:arrPickerItems andPickerItems2:nil];
    
}
/**
 @brief PictureViewのピッカー作成処理
 @param btnId:ボタンID andPickerItems1:ピッカーに表示する項目1 andPickerItems2:ピッカーに表示する項目2
 */
- (void)callShowPickerView:(enum PRINTER_SETTING_BUTTON)btnId
            andPickerItems:(NSMutableArray*)arrPickerItems
           andPickerItems2:(NSMutableArray*)arrPickerItems2
{
    
    NSInteger menuID = [self getButtonIndex:btnId] + 1;
    NSInteger pickerIndex = [self getPicturePickerSelRowIndex:btnId];
    if (pickerIndex != -1) {
        
        BOOL isPrint = NO;
        if (btnId == BUTTON_PRINTER) {
            isPrint = YES;
        }
        
        [super ShowPickerView:menuID
                     pickerID:pickerIndex
                   pickerMenu:arrPickerItems
                  pickerMenu2:arrPickerItems2
                      isPrint:isPrint];
        
    }
    else {
        DLog(@"NotUsingPictureView:getPicturePickerSelRowIndex");
    }
}

#pragma mark - PictureView PickerRow

/**
 @brief Picker選択行を取得する
 @details ボタンIDにより該当するPickerの選択行を返す
 PictureViewを使用しているもののみ対応
 @param btnId:ボタンID
 */
- (NSInteger)getSelPickerRowWithIndex:(enum PRINTER_SETTING_BUTTON)btnId {
    
    // 何番目のPickerを使用しているか判定する
    NSInteger picSelRowIndex = [self getPicturePickerSelRowIndex:btnId];
    
    switch (picSelRowIndex) {
        case 1:
            return self.m_nSelPickerRow1;
            break;
        case 2:
            return self.m_nSelPickerRow2;
            break;
        case 3:
            return self.m_nSelPickerRow3;
            break;
        case 4:
            return self.m_nSelPickerRow4;
            break;
        case 5:
            return self.m_nSelPickerRow5;
            break;
        case 6:
            return self.m_nSelPickerRow6;
            break;
        case 7:
            return self.m_nSelPickerRow7;
            break;
        case 8:
            return self.m_nSelPickerRow8;
        default:
            DLog(@"UnexceptedParam:setSelPickerRowWithIndex ButtonID:%zd",btnId);
            break;
    }
    
    return nil;
}

/**
 @brief PictureViewの選択行の値を更新する
 @details PictureViewの選択行の値を更新する
 PictureViewを使用しているもののみ対応
 @param btnId:更新するPickerRowの判定用 row:更新値
 */
- (void)setSelPickerRowWithIndex:(enum PRINTER_SETTING_BUTTON)btnId andRow:(NSInteger)row {
    
    // 何番目のPickerを使用しているか判定する
    NSInteger picSelRowIndex = [self getPicturePickerSelRowIndex:btnId];
    
    switch (picSelRowIndex) {
        case 1:
            self.m_nSelPickerRow1 = row;
            break;
        case 2:
            self.m_nSelPickerRow2 = row;
            break;
        case 3:
            self.m_nSelPickerRow3 = row;
            break;
        case 4:
            self.m_nSelPickerRow4 = row;
            break;
        case 5:
            self.m_nSelPickerRow5 = row;
            break;
        case 6:
            self.m_nSelPickerRow6 = row;
            break;
        case 7:
            self.m_nSelPickerRow7 = row;
            break;
        case 8:
            self.m_nSelPickerRow8 = row;
        default:
            DLog(@"UnexceptedParam:setSelPickerRowWithIndex ButtonID:%zd",btnId);
            break;
    }
}

/**
 @brief ボタンIDからPictureViewの何番目の選択行変数を使用しているかの番号を返す
 */
- (NSInteger)getPicturePickerSelRowIndex:(enum PRINTER_SETTING_BUTTON)buttonId {
    
    //NSInteger pictMenuCnt = 0;
    NSInteger pictMenuCnt = 1;  // 1から開始しないと他のクラスの設定を変えないといけなくなる(row3:部数、row6:用紙サイズとして処理しているクラスがある為)
    
    for (int i = 0; i < [buttonIdArray count]; i++) {
        enum PRINTER_SETTING_BUTTON tmpButtonId = [[buttonIdArray objectAtIndex:i] intValue];
        
        if ([self isUsePictureView:tmpButtonId]) {
            pictMenuCnt++;
        }
        
        if(buttonId == tmpButtonId) {
            return pictMenuCnt;
        }
    }
    return -1;
}

/**
 @brief PictureViewを使用するボタンかどうかの判定
 @details switchのcaseは使用しないボタン
 */
- (BOOL)isUsePictureView:(enum PRINTER_SETTING_BUTTON)btnId {
    
    BOOL resFlg = YES;
    
    switch (btnId) {
        case BUTTON_PRINT:
            resFlg = NO;
            break;
        case BUTTON_NUP:
            resFlg = NO;
            break;
        case BUTTON_FINISHING:
            resFlg = NO;
            break;
        case BUTTON_RANGE:
            resFlg = NO;
            break;
        case BUTTON_RETENTION:
            resFlg = NO;
            break;
        case BUTTON_PRINTRELEASE:
            resFlg = NO;
            break;
        case BUTTON_OTHERAPP:
            resFlg = NO;
            break;
        default:
            break;
    }
    
    return resFlg;
    
}

/**
 @brief PictureViewのピッカーインデックス情報からボタンインデックスを取得する
 @param pickerIndex:現在使用中のピッカー番号(m_nSelPickerを想定)
 */
- (NSInteger)getButtonIndexFromPicSelRow:(NSInteger)pickerNo {
    
    NSInteger pictMenuCnt = 1;  // (row3:部数、row6:用紙サイズとして処理しているクラスに合わせる為、1から開始。)
    
    for (int i = 0; i < [buttonIdArray count]; i++) {
        enum PRINTER_SETTING_BUTTON tmpButtonId = [[buttonIdArray objectAtIndex:i] intValue];
        
        if ([self isUsePictureView:tmpButtonId]) {
            pictMenuCnt++;
        }
        
        if (pictMenuCnt == pickerNo) {
            return i;
        }
    }
    return -1;
    
}

/**
 @brief Pickerの選択行情報を一旦退避して保持する(PictureViewのPickerのみ)
 */
- (void)saveAllPickerSelRowValue {
    
    // ボタンIDのループ
    for (int i = 0; i < [buttonIdArray count]; i++) {
        enum PRINTER_SETTING_BUTTON btnId = [[buttonIdArray objectAtIndex:i] intValue];
        
        //[self savePickerSelValueWithBtnID:btnId];
        
        switch (btnId) {
            case BUTTON_PRINTER:
                m_nSelPickerRowPrinter = [self getSelPickerRowWithIndex:btnId];
                break;
            case BUTTON_NUM:
                m_nSelPickerRowNum = [self getSelPickerRowWithIndex:btnId];
                break;
            case BUTTON_DUPLEX:
                m_nSelPickerRowDuplex = [self getSelPickerRowWithIndex:btnId];
                break;
            case BUTTON_COLOR:
                m_nSelPickerRowColor = [self getSelPickerRowWithIndex:btnId];
                break;
            case BUTTON_PAPERSIZE:
                m_nSelPickerRowPaperSize = [self getSelPickerRowWithIndex:btnId];
                break;
            case BUTTON_PAPERTYPE:
                m_nSelPickerRowPaperType = [self getSelPickerRowWithIndex:btnId];
                break;
            case BUTTON_TARGET:
                m_nSelPickerRowPrintTarget = [self getSelPickerRowWithIndex:btnId];
            default:
                break;
        }
        
    }
    
}

/**
 @brief 退避したPickerの選択行情報を再度PictureViewのプロパティに設定する(PictureViewのPickerのみ)
 */
- (void)inputAllPickerSelRowValue {
    
    // ボタンIDのループ
    for (int i = 0; i < [buttonIdArray count]; i++) {
        enum PRINTER_SETTING_BUTTON btnId = [[buttonIdArray objectAtIndex:i] intValue];
        
        //[self inputPickerSelValueWithBtnID:btnId];
        
        switch (btnId) {
            case BUTTON_PRINTER:
                [self setSelPickerRowWithIndex:btnId andRow:m_nSelPickerRowPrinter];
                break;
            case BUTTON_NUM:
                [self setSelPickerRowWithIndex:btnId andRow:m_nSelPickerRowNum];
                break;
            case BUTTON_DUPLEX:
                [self setSelPickerRowWithIndex:btnId andRow:m_nSelPickerRowDuplex];
                break;
            case BUTTON_COLOR:
                [self setSelPickerRowWithIndex:btnId andRow:m_nSelPickerRowColor];
                break;
            case BUTTON_PAPERSIZE:
                [self setSelPickerRowWithIndex:btnId andRow:m_nSelPickerRowPaperSize];
                break;
            case BUTTON_PAPERTYPE:
                [self setSelPickerRowWithIndex:btnId andRow:m_nSelPickerRowPaperType];
                break;
            case BUTTON_TARGET:
                [self setSelPickerRowWithIndex:btnId andRow:m_nSelPickerRowPrintTarget];
                break;
                
            default:
                break;
        }
        
    }
}

// ジョブ送信のタイムアウト(秒)を取得する
- (int)getJobTimeOut {
    // プロファイルの取得
    profileDataManager = [[ProfileDataManager alloc] init];
    ProfileData *profileData = nil;
    profileData = [profileDataManager loadProfileDataAtIndex:0];
    
    // ジョブ送信のタイムアウト(秒)の取得
    int jobTimeOut;
    if (profileData.jobTimeOut) {
        jobTimeOut = [profileData.jobTimeOut intValue];
    } else {
        jobTimeOut = [N_NUM_DEFAULT_JOB_TIME_OUT intValue];
    }
    DLog(@"ジョブ送信のタイムアウト(秒)：%d", jobTimeOut);
    
    return jobTimeOut;
}

// 仕上げ設定の画面表示文言を取得する
- (NSString*)getDisplayFinishing {
    
    // 初期値を「なし」を設定
    NSString *value = S_PRINT_FINISHING_DISABLED;
    
    BOOL isStaple = NO;
    BOOL isPunch = NO;
    
    // ステープル
    if ([self.pstrSelectedStaple isEqualToString:S_PRINT_STAPLE_1STAPLE]
        || [self.pstrSelectedStaple isEqualToString:S_PRINT_STAPLE_2STAPLES]
        || [self.pstrSelectedStaple isEqualToString:S_PRINT_STAPLE_STAPLELESS]) {
        
        isStaple = YES;
    }
    
    // パンチ
    if ([self.pstrSelectedPunch isEqualToString:S_PRINT_PUNCH_2HOLES]
        || [self.pstrSelectedPunch isEqualToString:S_PRINT_PUNCH_3HOLES]
        || [self.pstrSelectedPunch isEqualToString:S_PRINT_PUNCH_4HOLES]
        || [self.pstrSelectedPunch isEqualToString:S_PRINT_PUNCH_4HOLESWIDE]) {
        
        isPunch = YES;
    }
    
    if (isStaple && isPunch) {
        // ステープル, パンチ
        value = [NSString stringWithFormat:@"%@, %@",S_PRINT_STAPLE_ENABLED,S_PRINT_PUNCH_ENABLED];
    } else if (isStaple) {
        // ステープル
        value = S_PRINT_STAPLE_ENABLED;
    } else if (isPunch) {
        // パンチ
        value = S_PRINT_PUNCH_ENABLED;
    }
    
    return value;
}

// 印刷面(片面/両面)変更時に仕上げ設定情報を更新する
- (void)updateFinishingInfoFromPrintSide {
    
    // 「片面印刷」に変更した場合
    if ([self.m_pstrSide isEqualToString:S_ONE_SIDE]) {
        
        // 「仕上げ」のとじ位置が「左とじ」の場合
        if ([self.pstrSelectedClosing isEqualToString:S_PRINT_BINDINGEDGE_LEFT]) {
            self.nClosingRow = 0;
            
            // 「仕上げ」のとじ位置が「右とじ」の場合
        } else if ([self.pstrSelectedClosing isEqualToString:S_PRINT_BINDINGEDGE_RIGHT]) {
            self.nClosingRow = 1;
            
            // 「仕上げ」のとじ位置が「上とじ」の場合
        } else if ([self.pstrSelectedClosing isEqualToString:S_PRINT_BINDINGEDGE_TOP]) {
            self.nClosingRow = 2;
            
        } else {
            // 「左とじ」の値を設定しておく
            self.nClosingRow = 0;
            self.pstrSelectedClosing = S_PRINT_BINDINGEDGE_LEFT;
        }
        
        // 「両面印刷よことじ」に変更した場合
    } else if ([self.m_pstrSide isEqualToString:S_DUPLEX_SIDE_LONG]) {
        
        // 「仕上げ」のとじ位置が「左とじ」の場合
        if ([self.pstrSelectedClosing isEqualToString:S_PRINT_BINDINGEDGE_LEFT]) {
            self.nClosingRow = 0;
            
            // 「仕上げ」のとじ位置が「右とじ」の場合
        } else if ([self.pstrSelectedClosing isEqualToString:S_PRINT_BINDINGEDGE_RIGHT]) {
            self.nClosingRow = 1;
            
            // 「仕上げ」のとじ位置が「上とじ」の場合、「左とじ」に変更する
        } else if ([self.pstrSelectedClosing isEqualToString:S_PRINT_BINDINGEDGE_TOP]) {
            self.nClosingRow = 0;
            self.pstrSelectedClosing = S_PRINT_BINDINGEDGE_LEFT;
            
        } else {
            // 「左とじ」の値を設定しておく
            self.nClosingRow = 0;
            self.pstrSelectedClosing = S_PRINT_BINDINGEDGE_LEFT;
        }
        
        // 「両面印刷たてとじ」に変更した場合
    } else if ([self.m_pstrSide isEqualToString:S_DUPLEX_SIDE_SHORT]) {
        
        // 「仕上げ」のとじ位置が「左とじ」の場合、「上とじ」に変更する
        if ([self.pstrSelectedClosing isEqualToString:S_PRINT_BINDINGEDGE_LEFT]) {
            self.nClosingRow = 0;
            self.pstrSelectedClosing = S_PRINT_BINDINGEDGE_TOP;
            
            // 「仕上げ」のとじ位置が「右とじ」の場合、「上とじ」に変更する
        } else if ([self.pstrSelectedClosing isEqualToString:S_PRINT_BINDINGEDGE_RIGHT]) {
            self.nClosingRow = 0;
            self.pstrSelectedClosing = S_PRINT_BINDINGEDGE_TOP;
            
            // 「仕上げ」のとじ位置が「上とじ」の場合
        } else if ([self.pstrSelectedClosing isEqualToString:S_PRINT_BINDINGEDGE_TOP]) {
            self.nClosingRow = 0;
            
        } else {
            // 「上とじ」の値を設定しておく
            self.nClosingRow = 0;
            self.pstrSelectedClosing = S_PRINT_BINDINGEDGE_TOP;
        }
    }
}


// プリンター変更時に仕上げ設定情報を更新する
- (void)updateFinishingInfoFromPrinter {
    
    // ステープル情報再設定
    NSArray *selectableList = [PrintPictManager getSelectableStaple:self.staple andPaperSize:self.m_pstrPaperSize];
    
    // 現在選択中の値が選択可能か判定する
    NSInteger selectIndex = [selectableList indexOfObject:self.pstrSelectedStaple];
    if (selectIndex != NSNotFound) {
        // 選択可能だった場合
        self.nStapleRow = selectIndex;  // リストが変わっている場合があり得るので選択インデックス更新
    }
    else {
        // 選択不可だった場合
        // 選択中のステープル設定を「なし」(0)にする。
        self.nStapleRow = 0;
        self.pstrSelectedStaple = S_PRINT_STAPLE_NONE;
    }
    
    // パンチ情報再設定
    NSArray *selectablePunchList = [PrintPictManager getSelectablePunch:self.punchData andPaperSize:self.m_pstrPaperSize];
    
    // 現在選択中の値が選択可能か判定する
    NSInteger selectPunchIndex = [selectablePunchList indexOfObject:self.pstrSelectedPunch];
    if (selectPunchIndex != NSNotFound) {
        // 選択可能だった場合
        self.nPunchRow = selectPunchIndex;  // リストが変わっている場合があり得るので選択インデックス更新
    }
    else {
        // 選択不可だった場合
        // 選択中のパンチ設定を「なし」(0)にする。
        self.nPunchRow = 0;
        self.pstrSelectedPunch = S_PRINT_PUNCH_NONE;
    }
    
    
    if (self.staple == STAPLE_NONE && (self.punchData == nil || self.punchData.canPunch == NO)) {
        // ステープル未対応かつパンチ未対応のプリンターに変更した場合はとじ位置を「左とじ」にする
        self.nClosingRow = 0;
        self.pstrSelectedClosing = S_PRINT_BINDINGEDGE_LEFT;
    }
    
    NSLog(@"プリンター変更後のステープル設定： %@", self.pstrSelectedStaple);
    NSLog(@"プリンター変更後のパンチ設定： %@", self.pstrSelectedPunch);
    
    // 印刷面(片面/両面)を考慮した仕上げ設定情報に更新する
    [self updateFinishingInfoFromPrintSide];
}

/**
 @brief ステープルのリスト更新の際に選択インデックスを再設定 20160212
 @detail 用紙サイズの選択が変わった後にステープルの選択肢が変わる可能性がある為インデックスを更新する。
 */
- (void)updateStapleSelectIndex:(NSString*)strPaperSize {
    
    // 用紙サイズ変更後のリストを取得
    NSArray *selectableList = [PrintPictManager getSelectableStaple:self.staple andPaperSize:strPaperSize];
    
    // 現在選択中のステープル値が選択可能か判定する
    NSInteger selectIndex = [selectableList indexOfObject:self.pstrSelectedStaple];
    if (selectIndex != NSNotFound) {
        // 選択可能だった場合
        self.nStapleRow = selectIndex;  // リストが変わっている場合があり得るので選択インデックス更新
    }
    else {
        // 選択不可だった場合
        // 選択中のステープル設定を「なし」(0)にする。
        self.nStapleRow = 0;
        self.pstrSelectedStaple = S_PRINT_STAPLE_NONE;
    }

}

/**
 @brief パンチのリスト更新の際に選択インデックスを再設定
 @detail 用紙サイズの選択が変わった後にパンチの選択肢が変わる可能性がある為インデックスを更新する。
 */
- (void)updatePunchSelectIndex:(NSString*)strPaperSize {
    
    // 用紙サイズ変更後のリストを取得
    NSArray *selectableList = [PrintPictManager getSelectablePunch:self.punchData andPaperSize:strPaperSize];
    
    // 現在選択中のパンチ値が選択可能か判定する
    NSInteger selectIndex = [selectableList indexOfObject:self.pstrSelectedPunch];
    if (selectIndex != NSNotFound) {
        // 選択可能だった場合
        self.nPunchRow = selectIndex;  // リストが変わっている場合があり得るので選択インデックス更新
    }
    else {
        // 選択不可だった場合
        // 選択中のパンチ設定を「なし」(0)にする。
        self.nPunchRow = 0;
        self.pstrSelectedPunch = S_PRINT_PUNCH_NONE;
    }
    
}

// プリンター変更時の処理
- (void)printerChange:(NSBlockOperation*)operation andSelRow:(NSInteger)selRow {
    
    if (operation.isCancelled) {
        NSLog(@"通信処理キャンセルされた。(ステープル情報取得前)");
        return;
    }
    // データ変数
    PrintPictCommProcessData *data = [[PrintPictCommProcessData alloc] init];
    
    // プリンター変更時に仕上げ設定情報を更新する
    FinishingData *finishingData = [self setStaplePunchState:selRow];
    
    if (finishingData == nil) {
        data.staple = STAPLE_NONE;
    } else {
        data.staple = finishingData.staple;
    }
    data.punchData = finishingData.punchData;

    if (operation.isCancelled) {
        NSLog(@"通信処理キャンセルされた。(プリントリリース情報取得前)");
        return;
    }
    
    // プリントリリースの値取得
    data.canPrintRelease = [self checkCanPrintRelease:selRow];
    
    NSLog(@"通信完了");
    
    if (operation.isCancelled) {
        NSLog(@"通信処理キャンセルされた。(メニューボタン再生成前)");
        return;
    }
    
//    STAPLE beforeStaple = self.staple;
    
    // 取得したステープル/プリントリリースの値を保存
    [self setCommProcessResultData:data];
    
//    [self updateFinishingInfoFromPrinter:beforeStaple];
    [self updateFinishingInfoFromPrinter];
    [self checkPaperSizeAndStaple:self.m_pstrPaperSize];
    [self checkPaperSizeAndPunch:self.m_pstrPaperSize];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        // メニューボタンの再生成
        [self remakeMenuButton:selRow];
        
        // メニューボタンのEnabled設定
        [self setButtonEnabledWhenRemakeButton];
        
        // メニューボタンのEnabled設定(Web印刷)
        [self setBtnEnable];
        
        NSLog(@"通信処理後のメニューの活性");
        
        // メッセージ非表示
        if (m_pAlertCommProcess != nil) {
            [m_pAlertCommProcess dismissViewControllerAnimated:YES completion:^{
                [self alertButtonDismiss:m_pAlertCommProcess tagIndex:m_pAlertCommProcess.tag buttonIndex:0];
            }];
            NSLog(@"アラート閉じた。");
        }
        
    });
    
    // 通信中フラグOFF
    [self setDuringCommProcessValues:NO];
    
    // 処理実行フラグOFF
    SharpScanPrintAppDelegate* appDelegate = (SharpScanPrintAppDelegate*)[[UIApplication sharedApplication] delegate];
    appDelegate.IsRun = FALSE;
    
}

// 仕上げとプリントリリースについて通信処理を行う
- (void)communicationProcessing:(NSBlockOperation*)operation andSelRow:(NSInteger)selRow {
    
    if (operation.isCancelled) {
        NSLog(@"通信処理キャンセルされた。(ステープル情報取得前)");
        return;
    }
    
    // データ変数
    PrintPictCommProcessData *data = [[PrintPictCommProcessData alloc] init];
    
    // プリンター変更時に仕上げ設定情報を更新する
    FinishingData *finishingData = [self setStaplePunchState:selRow];
    
    if (finishingData == nil) {
        data.staple = STAPLE_NONE;
    } else {
        data.staple = finishingData.staple;
    }
    data.punchData = finishingData.punchData;

    if (operation.isCancelled) {
        NSLog(@"通信処理キャンセルされた。(プリントリリース情報取得前)");
        return;
    }
    
    // プリントリリース対応判定とボタン表示非表示処理
    data.canPrintRelease = [self checkCanPrintRelease:selRow];
    
    NSLog(@"通信完了");
    
    if (operation.isCancelled) {
        NSLog(@"通信処理キャンセルされた。(メニューボタン再生成前)");
        return;
    }
    
    // 取得したステープル/プリントリリースの値を保存
    [self setCommProcessResultData:data];
    
    [self updateFinishingInfoFromPrinter];
    [self checkPaperSizeAndStaple:self.m_pstrPaperSize];
    [self checkPaperSizeAndPunch:self.m_pstrPaperSize];

    dispatch_async(dispatch_get_main_queue(), ^{
        // メニューボタンの再生成
        [self remakeMenuButton:selRow];
        
        // メニューボタンのEnabled設定
        [self setButtonEnabledWhenRemakeButton];
        
        // メニューボタンのEnabled設定(Web印刷)
        [self setBtnEnable];
        
        NSLog(@"通信処理後のメニューの活性");
        
        // メッセージ非表示
        if (m_pAlertCommProcess != nil) {
            [m_pAlertCommProcess dismissViewControllerAnimated:YES completion:^{
                [self alertButtonDismiss:m_pAlertCommProcess tagIndex:m_pAlertCommProcess.tag buttonIndex:0];
                
                // 別のアラートが存在する場合にはここで表示処理を行う
                [super showAlertOnMainThread];
            }];
            NSLog(@"アラート閉じた。");
        }
        
    });
    
    // 通信処理中フラグOFF
    [self setDuringCommProcessValues:NO];
    
    SharpScanPrintAppDelegate* appDelegate = (SharpScanPrintAppDelegate*)[[UIApplication sharedApplication] delegate];
    // 処理実行フラグOFF
    appDelegate.IsRun = FALSE;
    
}

#pragma mark - 用紙サイズ用紙タイプ排他制御

/**
 @brief 用紙サイズと両面印刷とステープルの排他制御処理
 @details 排他チェックと排他に関連する処理を行う。戻り値はピッカーで選択された用紙タイプが選択できる状態かを返す
 */
- (BOOL)canSelectPaperSizePickerValue:(NSString*)strSelectedPaperSize {
    
    // ピッカーの値を選択出来るか判定
    if (self.isDuplexPrint) {
        if ([PrintPictManager checkCanDuplexPaperSize:strSelectedPaperSize] == NO) {
            // 用紙サイズが両面印刷不可
            return NO;
        }
    }
    
    // 針なしステープルが選択されているか判定
    BOOL isStapleless = [PrintPictManager isStaplelessStapleSelected:self.staple andSelectedIndex:self.nStapleRow andPaperSize:self.m_pstrPaperSize];
    if ([self visibleStaple] && self.nStapleRow > 0) {
        if (![PrintPictManager checkCanStaplePaperSize:isStapleless andPaperSize:strSelectedPaperSize]) {
            // 用紙サイズがステープル不可
            return NO;
        }
    }
    
    // パンチ排他チェック
    if ([self visiblePunch] && self.nPunchRow > 0) {
        if (![PrintPictManager checkCanPunchPaperSize:strSelectedPaperSize]) {
            // 用紙サイズがパンチ不可の場合
            return NO;
        }
    }
    
    return YES;
    
}

/**
 @brief 用紙サイズと両面印刷の排他チェック
 */
- (void)checkPaperSizeAndDuplex:(NSString*)strSelectedPaperSize {
    
    if ([PrintPictManager checkCanDuplexPaperSize:strSelectedPaperSize] == NO) {
        // 用紙サイズが両面印刷不可の場合
        if (self.isDuplexPrint != YES) {
            // 両面印刷ボタン非活性
            self.isInvalidDuplexSize = YES;
            UIButton* button = [self getUIButtonByIndex:[self getButtonIndex:BUTTON_DUPLEX]];
            [button setEnabled:NO];
        }
    }
    else {
        // 用紙サイズが両面印刷可の場合
        self.isInvalidDuplexSize = NO;
        
        // 用紙タイプ判定
        if ([PrintPictManager checkCanDuplexPaperType:self.m_pstrPaperType] == YES) {
            
            // 両面印刷ボタン活性
            UIButton* btnDuplex = [self getUIButtonByIndex:[self getButtonIndex:BUTTON_DUPLEX]];
            [btnDuplex setEnabled:YES];
        }
    }
    
}

/**
 @brief 用紙サイズとステープルの排他チェック
 */
- (void)checkPaperSizeAndStaple:(NSString*)strSelectedPaperSize {
    
    // 用紙サイズがステープル不可の場合
    if (![PrintPictManager checkFinishingSettingViewStapleEnable:self.staple andPaperSize:strSelectedPaperSize]) {
        // ステープルの項目を選択不可状態にする
        self.isInvalidStaplePaperSize = YES;
        
    }
    else {
        // ステープルの不可フラグの設定を変える
        self.isInvalidStaplePaperSize = NO;
    }
}

/**
 @brief 用紙サイズとパンチの排他処理(ボタンの活性/非活性関連)
 */
- (void)checkPaperSizeAndPunch:(NSString*)strSelectedPaperSize {
    
    // 用紙サイズがパンチ不可の場合
    if (![PrintPictManager checkFinishingSettingViewPunchEnable:self.punchData andPaperSize:strSelectedPaperSize]) {
        // パンチの項目を選択不可状態にする
        self.isInvalidPunchPaperSize = YES;
    }
    else {
        // パンチの不可フラグの設定を変える
        self.isInvalidPunchPaperSize = NO;
    }
    
}

/**
 @brief 用紙タイプと両面印刷とステープルの排他制御処理
 @details 排他チェックと排他に関連する処理を行う。戻り値はピッカーで選択された用紙タイプが選択できる状態かを返す
 */
- (BOOL)canSelectPaperTypePickerValue:(NSString*)strSelectedPaperType {
    
    if (self.isDuplexPrint) {
        if ([PrintPictManager checkCanDuplexPaperType:strSelectedPaperType] == NO) {
            // 両面印刷が出来ない用紙タイプの場合
            return NO;
        }
    }
    
    if ([self visibleStaple] && self.nStapleRow > 0) {
        if (![PrintPictManager checkCanStaplePaperType:strSelectedPaperType]) {
            // ステープルが出来ない用紙タイプの場合
            
            return NO;
        }
    }
    
    // パンチ排他チェック
    if ([self visiblePunch] && self.nPunchRow > 0) {
        if (![PrintPictManager checkCanPunchPaperType:strSelectedPaperType]) {
            // パンチ出来ない用紙タイプの場合
            
            return NO;
        }
    }

    return YES;
    
}

/**
 @brief 用紙タイプと両面印刷の排他処理(ボタンの活性/非活性関連)
 */
- (void)checkPaperTypeAndDuplex:(NSString*)strSelectedPaperType {
    
    if ([PrintPictManager checkCanDuplexPaperType:strSelectedPaperType] == NO) {
        // 両面印刷が出来ない用紙タイプの場合
        if (self.isDuplexPrint != YES) {
            
            // 両面印刷ボタンを非活性化
            self.isInvalidDuplexType = YES;
            UIButton *btnDuplex = [self getUIButtonByIndex:[self getButtonIndex:BUTTON_DUPLEX]];
            [btnDuplex setEnabled:NO];
            
        }
    }
    else {
        self.isInvalidDuplexType = NO;
        // 用紙サイズ判定
        if (!self.isInvalidDuplexSize) {
            // 両面印刷ボタンを活性化
            UIButton *btnDuplex = [self getUIButtonByIndex:[self getButtonIndex:BUTTON_DUPLEX]];
            [btnDuplex setEnabled:YES];
        }
    }
}

/**
 @brief 用紙タイプとステープルの排他処理(ボタンの活性/非活性関連)
 */
- (void)checkPaperTypeAndStaple:(NSString*)strSelectedPaperType {
    
    // 用紙タイプがステープル不可の場合
    if (![PrintPictManager checkCanStaplePaperType:strSelectedPaperType]) {
        // ステープルの項目を選択不可状態にする
        self.isInvalidStaplePaperType = YES;
    }
    else {
        // ステープルの不可フラグの設定を変える
        self.isInvalidStaplePaperType = NO;
    }
    
}

/**
 @brief 用紙タイプとパンチの排他処理(ボタンの活性/非活性関連)
 */
- (void)checkPaperTypeAndPunch:(NSString*)strSelectedPaperType {
    
    // 用紙タイプがパンチ不可の場合
    if (![PrintPictManager checkCanPunchPaperType:strSelectedPaperType]) {
        // パンチの項目を選択不可状態にする
        self.isInvalidPunchPaperType = YES;
    }
    else {
        // パンチの不可フラグの設定を変える
        self.isInvalidPunchPaperType = NO;
    }
    
}

/**
 @brief 両面印刷ボタンの非活性
 (使用されるすべての箇所の直前で全ボタンを活性化している流れなので非活性のみ処理)
 */
- (void)setDuplexBtnEnabled {
    
    if (self.isInvalidDuplexSize || self.isInvalidDuplexType) {
        
        // 用紙サイズまたは用紙タイプが両面印刷が出来ないものの場合
        UIButton* duplexBtn = [self getUIButtonByIndex:[self getButtonIndex:BUTTON_DUPLEX]];
        if (duplexBtn != nil) {
            [duplexBtn setEnabled:NO];  // 非活性
        }
    }
    
}

#pragma mark - 通信中のキャンセル対応
/**
 @brief 通信中のメニューボタンの非活性
 */
- (void)setBtnEnabledForCancelRsMng {
    
    // ボタン配列ループ
    for (NSInteger iCnt = 0; iCnt < buttonIdArray.count; iCnt++) {
        enum PRINTER_SETTING_BUTTON btnId = [[buttonIdArray objectAtIndex:iCnt] intValue];
        UIButton *btn = [self getUIButtonByIndex:iCnt];
        [btn setEnabled:[self getEnableValueForCancelRsMng:btnId]];
    }
    
}

- (void)setBtnEnabledForCancelRsMngForWebMailFirst {
    
    // ボタン配列ループ
    for (NSInteger iCnt = 0; iCnt < buttonIdArray.count; iCnt++) {
        enum PRINTER_SETTING_BUTTON btnId = [[buttonIdArray objectAtIndex:iCnt] intValue];
        UIButton *btn = [self getUIButtonByIndex:iCnt];
        if (btnId == BUTTON_PRINTER) {
            [btn setEnabled:YES];
        }else {
            [btn setEnabled:NO];
        }
    }
}


/**
 @brief 通信処理中のそれぞれのメニューボタンの活性状態を返す
 */
- (BOOL)getEnableValueForCancelRsMng:(enum PRINTER_SETTING_BUTTON)btnId {
    
    BOOL resFlg = NO;
    
    switch (btnId) {
        case BUTTON_PRINTER:
            if ([PrintPictManager checkPrintDataSelected:self.PrintPictViewID
                                            andFileCount:self.selectFileArray.count
                                            andPictCount:self.selectPictArray.count
                                            andTotalPage:totalPage
                                             andFilePath:self.SelFilePath
                                         andIsSingleData:self.isSingleData]) {
                resFlg = YES;
            }
            break;
        default:
            break;
    }
    
    return resFlg;
    
}

#pragma mark -キャンセル可能なバックグラウンド処理

-(void)callPrinterChange {
    
    if (self.queue == nil){
        self.queue = [[NSOperationQueue alloc] init];
    }
    
    [self.queue cancelAllOperations];
    NSLog(@"キューキャンセル(新規キュー追加時)");
    
    NSBlockOperation *operation = [[NSBlockOperation alloc] init];
    __weak NSBlockOperation *weakOperation = operation; // 循環参照を避ける
    
    NSInteger selPrinterPicRow = [self getSelPickerRowWithIndex:BUTTON_PRINTER];
    
    [operation addExecutionBlock:^{
        
        [self printerChange:weakOperation andSelRow:selPrinterPicRow];
        
    }];
    
    [self.queue addOperation:operation];
    
}


-(void)callCommunicationProcessing {
    
    if (self.queue == nil){
        self.queue = [[NSOperationQueue alloc] init];
    }
    
    [self.queue cancelAllOperations];
    NSLog(@"キューキャンセル(新規キュー追加時)");
    
    NSBlockOperation *operation = [[NSBlockOperation alloc] init];
    __weak NSBlockOperation *weakOperation = operation; // 循環参照を避ける
    
    NSInteger selPrinterPicRow = [self getSelPickerRowWithIndex:BUTTON_PRINTER];
    
    [operation addExecutionBlock:^{
        
        // バックグラウンド処理
        [self communicationProcessing:weakOperation andSelRow:selPrinterPicRow];
        
    }];
    
    [self.queue addOperation:operation];
    
}

#pragma mark -make comm process data

// 通信で取得したデータをプロパティーへ反映
- (void)setCommProcessResultData:(PrintPictCommProcessData*)data {
    
    // ステープル
    self.staple = data.staple;
    
    // パンチ
    self.punchData = data.punchData;

    // プリントリリース
    self.canPrintRelease = data.canPrintRelease;
    
}

/**
 @brief プリンター情報取得中フラグの値を設定
 */
- (void)setDuringCommProcessValues:(BOOL)bValue {
    
    self.isDuringCommProcess = bValue;
    
    // 左側のtableViewに値を設定
    if (delegate) {
        if([delegate respondsToSelector:@selector(setDuringCommProcessValue:)]){
            // デリゲートメソッドの呼び出し
            [delegate setDuringCommProcessValue:bValue];
        }
    }
}

/**
 @brief プリンター情報取得の通信処理キャンセル
 @details 他画面へ遷移するときに使用(このviewが破棄されるとき--->viewWillDisappear)
 */
- (void)stopCommProcess {
    
    // キューキャンセル
    if (self.queue != nil) {
        [self.queue cancelAllOperations];
        NSLog(@"キューキャンセル(viewが閉じるとき)");
    }
    
    // 通信中フラグ初期化
    if (self.isDuringCommProcess) {
        self.isDuringCommProcess = nil;
    }
    
}

@end
