
#import <CFNetwork/CFNetwork.h>
#import "PictureViewController.h"
#import "Define.h"
#import "SettingSelInfoViewController.h"
#import "SettingSelDeviceViewController.h"
#import "CommonManager.h"
#import "SharpScanPrintAppDelegate.h"
//#import <QuartzCore/QuartzCore.h>
#import "RemoteScanBeforePictViewController.h"
#import "WebPagePrintViewController.h"
#import <ImageIO/ImageIO.h>
#import "SelectMailViewController.h"
#import "PrintPictViewController.h"
// 複数印刷対応
#import "SelectFileViewController.h"
#import "PrintSelectTypeViewController.h"
#import "SettingSelInfoViewController.h"

#import "ScanAfterPictViewController.h"
#import "ScanAfterPreViewController.h"
#import "SendExSitePictViewController.h"
#import "SendMailPictViewController.h"
#import "ArrangePictViewController.h"

#import "PickerModalBaseView.h"

#include <mach/host_info.h>
#include <mach/mach_init.h>
#include <mach/mach_host.h>

#import "GeneralFileUtility.h"

#define PLBL_PAGE_NUM_TAG 10
#define PAGE_DEL_BUTTON_TAG 20
@implementation PictureViewController

@synthesize PictEditInfo = m_pdicEditInfo;
@synthesize SelFilePath = m_pstrFilePath;
@synthesize IsPhotoView = m_bPhotoView;
@synthesize IsAfterView = m_bAfterView;
@synthesize IsPrintPictView = m_bPrintPictView;
@synthesize IsBeforeView = m_bBeforeView;
@synthesize IsSendExSitePictView = m_bSendExSitePictView;
@synthesize bRemoteScanSwitch;
@synthesize PrintPictViewID;
@synthesize smViewController;
@synthesize smNavigationController;
@synthesize isMoveAttachmentMail;   // 添付ファイル一覧画面からの遷移か
@synthesize previewScrollViewManager;
@synthesize m_pPreviewWebView;
@synthesize m_pPreviewScrollView;
@synthesize isSingleChar;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
        // Custom initialization
    }
    return self;
}

- (void)dealloc
{
    [self ReleaseObject:m_ppickerMenu];
    [self ReleaseObject:m_parrPickerRow];
    

    if(m_pPrintImageView != nil)
    {
        m_pPrintImageView.image = nil;
    }
    [self ReleaseObject:m_pPrintImageView];
    
    if(m_pPreviewWebView != nil)
    {
        m_pPreviewWebView.delegate = nil;
    }
    [self ReleaseObject:m_pPreviewWebView];
    
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
	m_bFirstLoad = TRUE;
    nFolderCount = 1;
    pathDir = nil;
    
    //通知センターを取得
    NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
    [nc addObserver:self selector:@selector(closeBtnPushed:) name:ST_CLOSE_BUTTON_PUSHED object:nil];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
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

-(void)viewWillDisappear:(BOOL)animated
{
    //ピッカー閉じる
    [_pickerModalBaseView dismissAnimated:NO];
    
    [super viewWillDisappear:animated];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

// 初期化関連
// 変数初期化
- (void)InitObject
{
    // 変数初期化
    m_bShowMenu = false;
    m_nSelPicker = PrvMenuIDNone;
    self.m_nSelPickerRow1 = 0;
    self.m_nSelPickerRow2 = 0;
    self.m_nSelPickerRow3 = 1;
    self.m_nSelPickerRow4 = 0;
    self.m_nSelPickerRow5 = 0;
    self.m_nSelPickerRow6 = 0;
    self.m_nSelPickerRow7 = 0;
    self.m_nSelPickerRow8 = 0;
    self.isSingleChar = NO;
    m_bPhotoView = FALSE;
    
    // スレッド
    m_bResult = TRUE;
    m_bThread = FALSE;
    m_bAbort = FALSE;
    self.m_pThread = nil;
}

- (void)InitView:(NSString*)pstrTitle           // 画面タイトル
      menuBtnNum:(NSInteger)nMenuBtnNum         // メニュー表示するボタン数
{
    [self InitView:pstrTitle menuBtnNum:nMenuBtnNum setHiddenNoImage:NO];
    [self setNoImageHidden:YES];
}

// メインビュー初期化
- (void)InitView:(NSString*)pstrTitle           // 画面タイトル
      menuBtnNum:(NSInteger)nMenuBtnNum         // メニュー表示するボタン数
setHiddenNoImage:(BOOL)bSetHiddenNoImage        // NoImage表示フラグ
{
    // メニュー表示するボタン数
    m_nMenuBtnNum = nMenuBtnNum;
    
    // ナビゲーションバー
    // タイトル設定
    CGSize size = [pstrTitle sizeWithFont:[UIFont boldSystemFontOfSize:20]];
    CGRect frame = CGRectMake(0, 0, size.width, 44);
    UILabel* lblTitle = [[UILabel alloc]initWithFrame:frame];
    lblTitle.backgroundColor = [UIColor clearColor];
    lblTitle.textColor = NAVIGATION_TITLE_COLOR;
    lblTitle.font = [UIFont boldSystemFontOfSize:20];
    lblTitle.textAlignment = NSTextAlignmentCenter;
    lblTitle.text = pstrTitle;
    lblTitle.adjustsFontSizeToFitWidth = YES;
    self.navigationItem.titleView = lblTitle;
    
    // 色変更
    //self.navigationController.navigationBar.tintColor = [UIColor blackColor];
    // 設定ボタン追加
    UIBarButtonItem* btnSetting = [[UIBarButtonItem alloc] initWithTitle:S_BUTTON_SETTING style:UIBarButtonItemStylePlain target:self action:@selector(OnNavBarRightButton:)];
    self.navigationItem.rightBarButtonItem = btnSetting;
    
    // メニューボタンなしor１つの場合
    if (m_nMenuBtnNum == 0 || m_nMenuBtnNum == 1)
    {
        // メニュー非表示
        m_pMenuImageView.hidden = TRUE;
        // メニュー表示ボタン押下不可
        m_pbtnShowMenu.userInteractionEnabled = NO;
    }
    
    m_bButtonEnable = YES;
    
    // NoImage文言設定
    m_pLblNoImage.text = S_LABEL_NO_IMAGE;
    if (bSetHiddenNoImage) {
        [self setNoImageHidden:m_pLblNoImage.hidden];
    }
}

// メニュー作成
- (void)CreateMenu:(NSInteger)nMenuBtnID        // メニューボタンID
           btnName:(NSString*)pstrBtnName       // ボタン表示名称
         initValue:(NSString*)pstrInitValue     // ボタンに表示する初期値
          iconName:(NSString*)pstrIconName      // ボタンに表示するアイコン名称
{
    // メニューボタンID不正
    if (m_nMenuBtnNum < nMenuBtnID)
    {
        return;
    }
    
    if ((nMenuBtnID < PrvMenuIDNone) || (nMenuBtnID >= PrvMenuIDMax))
    {
        return;
    }
    
    // メニューボタン作成
    switch (nMenuBtnID)
    {
        case PrvMenuIDFirst:
            self.m_pbtnFirst = [self CreateMenuButton:nMenuBtnID
                                              btnName:pstrBtnName
                                            initValue:pstrInitValue
                                             iconName:pstrIconName
                                            eventFunc:@selector(OnMenuFirstButton:)];
            break;
        case PrvMenuIDSecond:
            self.m_pbtnSecond = [self CreateMenuButton:nMenuBtnID
                                               btnName:pstrBtnName
                                             initValue:pstrInitValue
                                              iconName:pstrIconName
                                             eventFunc:@selector(OnMenuSecondButton:)];
            break;
        case PrvMenuIDThird:
            self.m_pbtnThird = [self CreateMenuButton:nMenuBtnID
                                              btnName:pstrBtnName
                                            initValue:pstrInitValue
                                             iconName:pstrIconName
                                            eventFunc:@selector(OnMenuThirdButton:)];
            break;
        case PrvMenuIDFourth:
            self.m_pbtnFourth = [self CreateMenuButton:nMenuBtnID
                                               btnName:pstrBtnName
                                             initValue:pstrInitValue
                                              iconName:pstrIconName
                                             eventFunc:@selector(OnMenuFourthButton:)];
            break;
        case PrvMenuIDFifth:
            self.m_pbtnFifth = [self CreateMenuButton:nMenuBtnID
                                              btnName:pstrBtnName
                                            initValue:pstrInitValue
                                             iconName:pstrIconName
                                            eventFunc:@selector(OnMenuFifthButton:)];
            break;
        case PrvMenuIDSixth:
            self.m_pbtnSixth = [self CreateMenuButton:nMenuBtnID
                                              btnName:pstrBtnName
                                            initValue:pstrInitValue
                                             iconName:pstrIconName
                                            eventFunc:@selector(OnMenuSixthButton:)];
            break;
        case PrvMenuIDSeventh:
            self.m_pbtnSeventh = [self CreateMenuButton:nMenuBtnID
                                                btnName:pstrBtnName
                                              initValue:pstrInitValue
                                               iconName:pstrIconName
                                              eventFunc:@selector(OnMenuSeventhButton:)];
            break;
        case PrvMenuIDEighth:
            self.m_pbtnEighth = [self CreateMenuButton:nMenuBtnID
                                               btnName:pstrBtnName
                                             initValue:pstrInitValue
                                              iconName:pstrIconName
                                             eventFunc:@selector(OnMenuEighthButton:)];
            break;
        case PrvMenuIDNinth:
            self.m_pbtnNinth = [self CreateMenuButton:nMenuBtnID
                                              btnName:pstrBtnName
                                            initValue:pstrInitValue
                                             iconName:pstrIconName
                                            eventFunc:@selector(OnMenuNinthButton:)];
            break;
        case PrvMenuIDTenth:
            self.m_pbtnTenth = [self CreateMenuButton:nMenuBtnID
                                              btnName:pstrBtnName
                                            initValue:pstrInitValue
                                             iconName:pstrIconName
                                            eventFunc:@selector(OnMenuTenthButton:)];
            break;
        case PrvMenuIDEleventh:
            self.m_pbtnEleventh = [self CreateMenuButton:nMenuBtnID
                                              btnName:pstrBtnName
                                            initValue:pstrInitValue
                                             iconName:pstrIconName
                                            eventFunc:@selector(OnMenuEleventhButton:)];
            break;
        
        case PrvMenuIDTwelveth:
            self.m_pbtnTwelveth = [self CreateMenuButton:nMenuBtnID
                                                 btnName:pstrBtnName
                                               initValue:pstrInitValue
                                                iconName:pstrIconName
                                               eventFunc:@selector(OnMenuTwelvethButton:)];
            break;
        case PrvMenuIDThirteenth:
            self.m_pbtnThirteenth = [self CreateMenuButton:nMenuBtnID
                                                 btnName:pstrBtnName
                                               initValue:pstrInitValue
                                                iconName:pstrIconName
                                               eventFunc:@selector(OnMenuThirteenthButton:)];
            break;
            
        case PrvMenuIDFourteenth:
            self.m_pbtnFourteenth = [self CreateMenuButton:nMenuBtnID
                                                   btnName:pstrBtnName
                                                 initValue:pstrInitValue
                                                  iconName:pstrIconName
                                                 eventFunc:@selector(OnMenuFourteenthButton:)];
            break;
            
        default:
            break;
    }
}

// メニューボタン作成
- (UIButton*)CreateMenuButton:(NSInteger)nMenuBtnID     // メニューボタンID
                      btnName:(NSString*)pstrBtnName    // ボタン表示名称
                    initValue:(NSString*)pstrInitValue  // ボタンに表示する初期値
                     iconName:(NSString*)pstrIconName   // ボタンに表示するアイコン名称
                    eventFunc:(SEL)selEventFunc         // ボタン押下イベント関数名
{
    // メニューボタンIDによって、ボタン色、表示位置のy座標を変更
    CGFloat fRectY = 4.0;              // 表示位置のy座標
    // ボタン文字色
    UIColor *titleColor = [UIColor whiteColor];
    NSString* strButtonImageName = S_IMAGE_BUTTON_BLUE;
    if (nMenuBtnID > PrvMenuIDFirst)
    {
        fRectY += ((nMenuBtnID -1) * 50.0 - 2.0);
        titleColor = [UIColor blackColor];
//      if(((m_bPrintPictView || m_bBeforeView) && nMenuBtnID != PrvMenuIDSeventh))
        if((m_bPrintPictView || m_bBeforeView))
        {
            strButtonImageName = S_IMAGE_BUTTON_GRAY_PICKER;
        }
        else if([self isKindOfClass:[RemoteScanBeforePictViewController class]])
        {
            strButtonImageName = S_IMAGE_BUTTON_GRAY;            
        }
    }
    if([self isKindOfClass:[RemoteScanBeforePictViewController class]])
    {
        // スクロールビュー用にy座標を調整する
        fRectY += 2;
    }
    if([pstrBtnName isEqualToString:S_BUTTON_OTHER_APP])
    {
        titleColor = [UIColor blackColor];
        strButtonImageName = S_IMAGE_BUTTON_GRAY;    
    }

    // ボタンタイプ
    UIButton* pbtnMenu = [UIButton buttonWithType:UIButtonTypeCustom];
    [pbtnMenu setExclusiveTouch: YES];
    // ボタン表示名称
    NSString* pstrTitle = pstrBtnName;

    if (pstrInitValue != nil)
    {
        pstrTitle = [[NSString alloc]initWithFormat: pstrBtnName, pstrInitValue];
    }
    
    pbtnMenu.adjustsImageWhenDisabled = NO;
    [pbtnMenu setTitle:pstrTitle forState:UIControlStateNormal];                    // ボタン表示名称
    pbtnMenu.titleEdgeInsets= UIEdgeInsetsMake(0.0, 12.0, 0.0, 20.0);
    if (nMenuBtnID > PrvMenuIDFirst || nMenuBtnID != PrvMenuIDSeventh)
    {
        pbtnMenu.titleEdgeInsets= UIEdgeInsetsMake(0.0, 12.0, 0.0, 27.0);
	}
    [pbtnMenu setTitleColor:titleColor forState:UIControlStateNormal];    // ボタンのタイトルの文字色
    [pbtnMenu setTitleColor:[UIColor lightTextColor] forState:UIControlStateDisabled]; // ボタンのタイトルの文字色(非活性時)
    pbtnMenu.titleLabel.font = [UIFont systemFontOfSize:15];                        // ボタンフォントサイズ
    pbtnMenu.titleLabel.minimumScaleFactor = 10 / pbtnMenu.titleLabel.font.pointSize; // ボタンフォント最小サイズ
    pbtnMenu.titleLabel.adjustsFontSizeToFitWidth = YES;                            // 名称を表示できない場合は縮小
    pbtnMenu.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;  // ボタンAlign
    
//    pbtnMenu.frame = CGRectMake(4.0, fRectY, 310.0, 50.0);
    CGRect mainRec = [[UIScreen mainScreen] bounds];
    pbtnMenu.frame = CGRectMake(4.0, fRectY, mainRec.size.width - 10, 50.0);
    // 背景画像設定
    [pbtnMenu setBackgroundImage:[UIImage imageNamed:strButtonImageName] forState:UIControlStateNormal];

    // アイコン設定
    [pbtnMenu setImage:[UIImage imageNamed:pstrIconName] forState:UIControlStateNormal]; 
    UIEdgeInsets insets = pbtnMenu.imageEdgeInsets;
    insets.left = 8.0;
    insets.top = 2.0;
    insets.bottom = 5.0;
    pbtnMenu.imageEdgeInsets = insets;
    
    // ボタン押下イベント登録
    [pbtnMenu addTarget:self action:selEventFunc forControlEvents:UIControlEventTouchUpInside];
    // ボタンの活性状態設定
    [pbtnMenu setEnabled:m_bButtonEnable];
    // ビューにボタン追加
    [m_pMenuView addSubview:pbtnMenu];
    
    return pbtnMenu;
}

- (void)setNoImageHidden:(BOOL)bHidden
{
    m_pLblNoImage.hidden = bHidden;
    m_pImgViewNoImage.hidden = bHidden;
}

// スレッド
// 実行スレッド
- (void)ActionThread
{
    
}

// スレッドの開始
- (void)StartThread
{
    // アクティビティインジケータを作成(WebViewのCenter位置)
	m_pActivityIndicatorView = [[UIActivityIndicatorView alloc]initWithFrame: CGRectMake(150, 174, 30.0, 30.0)];
	m_pActivityIndicatorView.activityIndicatorViewStyle = UIActivityIndicatorViewStyleGray;
    [self.view addSubview:m_pActivityIndicatorView];
    
    // インジケータ アニメーションスタート
	[m_pActivityIndicatorView startAnimating];

	//スレッド開始処理
	self.m_pThread = [[NSThread alloc] initWithTarget: self selector: @selector(ActionThread) object:nil];
	
	[[NSNotificationCenter defaultCenter] addObserver: self
											 selector: @selector(ThreadStopNotify)
											     name: NSThreadWillExitNotification
											   object: self.m_pThread];
    
	//スレッドフラグをオンに設定
	m_bThread = TRUE;
	
	//スレッド開始
    [self.m_pThread start];
}

// スレッド停止
- (void)StopThread
{
    if (m_bThread)
	{
		// 中断フラグをオンに設定
		m_bAbort = TRUE;
		while (m_bThread)
		{
			[NSThread sleepUntilDate: [NSDate dateWithTimeIntervalSinceNow: 0.1]];
		}
		m_bAbort = FALSE;
	}
}

// スレッド終了通知
- (void)ThreadStopNotify
{
	if (nil != self.m_pThread)
	{
		self.m_pThread = nil;
	}
	
	//スレッドフラグOFF
	m_bThread = FALSE;
}

//// ファイル表示
//- (void)ShowFile:(NSString*)pstrFileResource    // 画面表示ファイル
//        fileType:(NSString*)pstrFileType        // ファイルの種類(PDF,JPEG等)
//{
//    if (pstrFileResource != nil)
//    {
//        m_pPreviewWebView.hidden = NO;
//        m_pPreviewScrollView.hidden = YES;
//
//        m_pPreviewWebView.delegate = self;
//        m_pPreviewWebView.scalesPageToFit = YES;
//        // ファイル名とファイルの種類を設定
//        NSString *pstrPath = [[NSBundle mainBundle]
//                              pathForResource:pstrFileResource
//                              ofType:pstrFileType];
//        // URL設定
//        NSURL *url = [NSURL fileURLWithPath:pstrPath];
//        
//        // リクエスト作成
//        NSURLRequest* req = [NSURLRequest requestWithURL:url];
//        // リクエスト開始
//        [m_pPreviewWebView loadRequest:req];
//    }
//    else
//    {
//        // エラー処理
//        [self ShowFileError];
//    }
//}

//キャッシュを作る（フルパス指定)
-(void)createCashForFile:(NSString*)pstrFilePath
{
    if (pstrFilePath != nil)
    {
        BOOL bCreateCache = NO;
        if([CommonUtil pngExtensionCheck:pstrFilePath])
        {
            // PNG形式のときはキャッシュの再作成を試みる
            bCreateCache = YES;
        }
        if (self.PrintPictViewID == PPV_PRINT_SELECT_FILE_CELL || self.PrintPictViewID == PPV_PRINT_MULTI_FILE_PREVIEW) {
            // キャッシュファイルがないなら作る
            bCreateCache = YES;
        }
        
        if (self.PrintPictViewID == PPV_PRINT_MAIL_ATTACHMENT_CELL)
        {
            bCreateCache = YES;
        }
        if (bCreateCache) {
            [GeneralFileUtility createCacheFile:pstrFilePath];
        }
    }
}

// ファイル表示(フルパス指定)
- (void)ShowFile:(NSString*)pstrFilePath        // 画面表示ファイルパス
{
    if (pstrFilePath != nil)
    {
        // 自前ビューアで表示するかのチェック
        m_bOriginalViewer = FALSE;
        totalPage = 0;

        BOOL bCreateCache = NO;
        
        if([CommonUtil pngExtensionCheck:pstrFilePath])
        {
            // PNG形式のときはキャッシュの再作成を試みる
            bCreateCache = YES;
        }
        if (self.PrintPictViewID == PPV_PRINT_SELECT_FILE_CELL || self.PrintPictViewID == PPV_PRINT_MULTI_FILE_PREVIEW) {
            // キャッシュファイルがないなら作る
            bCreateCache = YES;
        }
        if (self.PrintPictViewID == PPV_PRINT_MAIL_ATTACHMENT_CELL)
        {
            bCreateCache = YES;
        }
        // Officeファイルはキャッシュを作成しない
        if([CommonUtil officeExtensionCheck:pstrFilePath]) {
            bCreateCache = NO;
        }
        if (bCreateCache) {
            [GeneralFileUtility createCacheFile:pstrFilePath];
        }
        NSArray *previewFilePaths = [GeneralFileUtility getPreviewFilePaths:pstrFilePath];
        if(previewFilePaths != nil)
        {
            // スリープ可能状態に戻す
            [UIApplication sharedApplication].idleTimerDisabled = NO;
            
            // 自前ビューアでの表示
            DLog(@"%@", @"自前ビューアでの表示チェック1");
            arrThumbnails = previewFilePaths;
            
            totalPage = [arrThumbnails count];
            
            if(totalPage > 0)
            {
                m_bOriginalViewer = TRUE;
            }
        }
        
        
        if(m_bOriginalViewer || (self.PrintPictViewID == WEB_PRINT_VIEW || self.PrintPictViewID == EMAIL_PRINT_VIEW))
        {
            // 自前ビューアでの表示
            [self performSelectorOnMainThread:@selector(ShowFileInOriginalView:) withObject:pstrFilePath waitUntilDone:YES];
        }
        else
        {
            // デフォルトビューアでの表示
            m_bOriginalViewer = FALSE;
            
            if ([CommonUtil jpegExtensionCheck:pstrFilePath] ||
                [CommonUtil tiffExtensionCheck:pstrFilePath] ||
                [CommonUtil pngExtensionCheck:pstrFilePath])
            {
                [self ShowFileInScrollView:pstrFilePath];
            }
            else
            {
                [self ShowFileInWebView:pstrFilePath];
            }
        }
    }
    else
    {
        // エラー処理
        [self ShowFileError];
    }
}

// ファイル表示(フルパス指定)
// Web,Emailファイルを追加時
- (void)ShowFileUpdate:(NSString*)pstrFilePath        // 画面表示ファイルパス
{
    if (pstrFilePath != nil)
    {
        // 自前ビューアで表示するかのチェック
        m_bOriginalViewer = FALSE;
        totalPage = 0;
        
        NSArray *previewFilePaths = [GeneralFileUtility getPreviewFilePaths:pstrFilePath];
        if(previewFilePaths != nil)
        {
            // 自前ビューアでの表示
            DLog(@"%@", @"自前ビューアでの表示チェック2");

            arrThumbnails = previewFilePaths;
            
            totalPage = [arrThumbnails count];
            
            if(totalPage > 0)
            {
                m_bOriginalViewer = TRUE;
            }
        }
        
        
        // 自前ビューアでの表示
        [self performSelectorOnMainThread:@selector(ShowFileInOriginalViewUpdate) withObject:nil waitUntilDone:YES];
    }
    else
    {
        // エラー処理
        [self ShowFileError];
    }
}

// 自前ビューアでのファイル表示（フルパス指定）
- (void)ShowFileInOriginalView:pstrFilePath
{
    // WebView非表示、ScrollView表示
    m_pPreviewWebView.hidden = YES;
    m_pPreviewScrollView.hidden = NO;

    if(self.PrintPictViewID != WEB_PRINT_VIEW && self.PrintPictViewID != EMAIL_PRINT_VIEW)
    {
        // 回転ボタン追加
        CGRect rectButton = CGRectMake(m_pPreviewScrollView.frame.origin.x + m_pPreviewScrollView.frame.size.width - 55, 12, 50, 50);
        self.m_pBtnRotateImage = [[UIButton alloc]initWithFrame:rectButton];
        [self.m_pBtnRotateImage setBackgroundImage:[UIImage imageNamed:S_ICON_PREVIEWROTATE] forState:UIControlStateNormal];
        //    m_pBtnRotateImage.backgroundColor = [[UIColor darkGrayColor] colorWithAlphaComponent:0.7] ;
        self.m_pBtnRotateImage.autoresizingMask = UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin;
        [self.m_pBtnRotateImage addTarget:self action:@selector(OnClickRotateButton:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:self.m_pBtnRotateImage];
        
        if (self.PrintPictViewID == PPV_PRINT_SELECT_FILE_CELL) {
            // ページ追加ボタン追加
            CGRect pageAddButton = CGRectMake(m_pPreviewScrollView.frame.origin.x + m_pPreviewScrollView.frame.size.width - 55, 82, 50, 50);
            //UIButton *m_pBtnPageAddImage = [[UIButton alloc]initWithFrame:pageAddButton];
            self.m_pBtnPageAddImage = [[UIButton alloc]initWithFrame:pageAddButton];
            //*TODO: ページ追加ボタンのアイコン修正
            [self.m_pBtnPageAddImage setBackgroundImage:[UIImage imageNamed:S_ICON_ADDPAGE] forState:UIControlStateNormal];
            self.m_pBtnPageAddImage.autoresizingMask = UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin;
            [self.m_pBtnPageAddImage addTarget:self action:@selector(OnClickPageAddButton:) forControlEvents:UIControlEventTouchUpInside];
            [self.view addSubview:self.m_pBtnPageAddImage];
        }else if (self.PrintPictViewID == PPV_PRINT_SELECT_PICTURE_CELL) {
            // ページ追加ボタン追加
            CGRect pageAddButton = CGRectMake(m_pPreviewScrollView.frame.origin.x + m_pPreviewScrollView.frame.size.width - 55, 82, 50, 50);
            //UIButton *m_pBtnPageAddImage = [[UIButton alloc]initWithFrame:pageAddButton];
            self.m_pBtnPageAddImage = [[UIButton alloc]initWithFrame:pageAddButton];
            //*TODO: ページ追加ボタンのアイコン修正
            [self.m_pBtnPageAddImage setBackgroundImage:[UIImage imageNamed:S_ICON_ADDPAGE] forState:UIControlStateNormal];
            self.m_pBtnPageAddImage.autoresizingMask = UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin;
            [self.m_pBtnPageAddImage addTarget:self action:@selector(OnClickPageAddButton:) forControlEvents:UIControlEventTouchUpInside];
            [self.view addSubview:self.m_pBtnPageAddImage];
        }else if (self.PrintPictViewID == PPV_PRINT_MAIL_ATTACHMENT_CELL) {
            // ページ追加ボタン追加
            CGRect pageAddButton = CGRectMake(m_pPreviewScrollView.frame.origin.x + m_pPreviewScrollView.frame.size.width - 55, 82, 50, 50);
            //UIButton *m_pBtnPageAddImage = [[UIButton alloc]initWithFrame:pageAddButton];
            self.m_pBtnPageAddImage = [[UIButton alloc]initWithFrame:pageAddButton];
            //*TODO: ページ追加ボタンのアイコン修正
            [self.m_pBtnPageAddImage setBackgroundImage:[UIImage imageNamed:S_ICON_ADDPAGE] forState:UIControlStateNormal];
            self.m_pBtnPageAddImage.autoresizingMask = UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin;
            [self.m_pBtnPageAddImage addTarget:self action:@selector(OnClickPageAddButton:) forControlEvents:UIControlEventTouchUpInside];
            [self.view addSubview:self.m_pBtnPageAddImage];
        }
        
    }
    else
    {
        // ページ追加ボタン追加
        CGRect pageAddButton = CGRectMake(m_pPreviewScrollView.frame.origin.x + m_pPreviewScrollView.frame.size.width - 55, 12, 50, 50);
        //UIButton *m_pBtnPageAddImage = [[UIButton alloc]initWithFrame:pageAddButton];
        self.m_pBtnPageAddImage = [[UIButton alloc]initWithFrame:pageAddButton];
        //*TODO: ページ追加ボタンのアイコン修正
        [self.m_pBtnPageAddImage setBackgroundImage:[UIImage imageNamed:S_ICON_ADDPAGE] forState:UIControlStateNormal];
        self.m_pBtnPageAddImage.autoresizingMask = UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin;
        [self.m_pBtnPageAddImage addTarget:self action:@selector(OnClickPageAddButton:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:self.m_pBtnPageAddImage];
        // ページ削除ボタン追加
        CGRect pageDelButton = CGRectMake(m_pPreviewScrollView.frame.origin.x + m_pPreviewScrollView.frame.size.width - 55, 82, 50, 50);
        //UIButton *m_pBtnPageDelImage = [[UIButton alloc]initWithFrame:pageDelButton];
        self.m_pBtnPageDelImage = [[UIButton alloc]initWithFrame:pageDelButton];
        //*TODO: ページ削除ボタンのアイコン修正
        self.m_pBtnPageDelImage.tag = PAGE_DEL_BUTTON_TAG;
        self.m_pBtnPageDelImage.alpha = 0;
        [self.m_pBtnPageDelImage setBackgroundImage:[UIImage imageNamed:S_ICON_DELPAGE] forState:UIControlStateNormal];
        self.m_pBtnPageDelImage.autoresizingMask = UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin;
        [self.m_pBtnPageDelImage addTarget:self action:@selector(OnClickPageDelButton:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:self.m_pBtnPageDelImage];
        
    }
    [self.view bringSubviewToFront:m_pMenuView];
    [self.view bringSubviewToFront:m_pMenuButtonView];
    
    self.previewScrollViewManager = [[PreviewScrollViewManager alloc] initWithPicturePaths:arrThumbnails ScrollView:m_pPreviewScrollView];
    m_pPreviewScrollView = self.previewScrollViewManager.m_pPreviewScrollView;
    
    // 追加の前に古いラベルを削除
    UIView *labelView = [self.view viewWithTag:PLBL_PAGE_NUM_TAG];
    [labelView removeFromSuperview];
    
    self.previewScrollViewManager.m_plblPageNum.tag = PLBL_PAGE_NUM_TAG;
    [self.view addSubview:previewScrollViewManager.m_plblPageNum];
    
    m_bFinLoad = TRUE;
    
    //アニメーションストップ
    [m_pActivityIndicatorView stopAnimating];
    
    m_bResult = TRUE;
}

// 自前ビューアでのファイル表示（フルパス指定）
// Web,Email追加ファイル表示画面を更新
- (void)ShowFileInOriginalViewUpdate
{
    // WebView非表示、ScrollView表示
    m_pPreviewWebView.hidden = YES;
    m_pPreviewScrollView.hidden = YES;
    // NoImage
    [self setNoImageHidden:YES];
    
    if (!arrThumbnails || [arrThumbnails count] == 0) {
        m_pPreviewScrollView.hidden = NO;
        // NoImage表示
        [self setNoImageHidden:NO];
    }
    
    previewScrollViewManager = [[PreviewScrollViewManager alloc] initWithPicturePaths:arrThumbnails ScrollView:m_pPreviewScrollView];
    m_pPreviewScrollView = previewScrollViewManager.m_pPreviewScrollView;

    // 追加の前に古いラベルを削除
    UIView *labelView = [self.view viewWithTag:PLBL_PAGE_NUM_TAG];
    [labelView removeFromSuperview];
    
    previewScrollViewManager.m_plblPageNum.tag = PLBL_PAGE_NUM_TAG;
    [self.view addSubview:previewScrollViewManager.m_plblPageNum];
    
    m_bFinLoad = TRUE;
    m_pPreviewScrollView.scrollEnabled = YES;
    //アニメーションストップ
    [m_pActivityIndicatorView stopAnimating];
    
    m_bResult = TRUE;
}

/**
 * 回転ボタンのアクション 
 */
- (void)OnClickRotateButton:(id)sender
{
    [previewScrollViewManager rotate];
}

// *TODO:ページ追加ボタンのアクション
- (void)OnClickPageAddButton:(id)sender
{
    // 通信中は処理しない
    if (self.isDuringCommProcess) {
        return;
    }
    
    if(self.PrintPictViewID == WEB_PRINT_VIEW)
    {
        WebPagePrintViewController* pWebPagePrintViewController = [[WebPagePrintViewController alloc] init];
        pWebPagePrintViewController.delegate = self;
        
        // モーダル表示
        UINavigationController *navigationController = [[UINavigationController alloc]initWithRootViewController:pWebPagePrintViewController];
        navigationController.navigationBar.barStyle = NAVIGATION_BARSTYLE;
        [navigationController setModalPresentationStyle:UIModalPresentationPageSheet];
        [self presentViewController:navigationController animated:YES completion:nil];
        
    }else if(self.PrintPictViewID == EMAIL_PRINT_VIEW)
    {
        if (self.smNavigationController == nil) {
            self.smViewController = [[SelectMailViewController alloc] init];
            
            [self.smViewController setPrevViewID: SendMailSelectTypeView];
            self.smViewController.bRootClassShow = YES;
            self.smViewController.nFolderCount = nFolderCount;
            self.smViewController.rootDir = pathDir;
            self.smViewController.delegate = self;
            // モーダル表示
            self.smNavigationController = [[UINavigationController alloc]initWithRootViewController:self.smViewController];
            self.smNavigationController.navigationBar.barStyle = NAVIGATION_BARSTYLE;
            [self.smNavigationController setModalPresentationStyle:UIModalPresentationPageSheet];
            [self presentViewController:self.smNavigationController animated:YES completion:nil];
            
//            self.smViewController;
//            self.smNavigationController;
        }
        else
        {
            // モーダル表示
            [self presentViewController:self.smNavigationController animated:YES completion:nil];
        }
    }else if(self.PrintPictViewID == PPV_PRINT_MAIL_ATTACHMENT_CELL)
    {
        // 最後に選択したメールの添付ファイル一覧をモーダル表示
        AttachmentMailViewController* pViewController = nil;
        
        pViewController = [[AttachmentMailViewController alloc] init];
        pViewController.delegate = self;
        self.smNavigationController = [[UINavigationController alloc]initWithRootViewController:pViewController];
        self.smNavigationController.navigationBar.barStyle = NAVIGATION_BARSTYLE;
        [self.smNavigationController setModalPresentationStyle:UIModalPresentationPageSheet];
        [self presentViewController:self.smNavigationController animated:YES completion:nil];
        

    } else {
        if (self.PrintPictViewID == PPV_PRINT_SELECT_FILE_CELL) {
            // 複数印刷対応
            SelectFileViewController *pViewController = [[SelectFileViewController alloc] init];
            pViewController.PrevViewID = PV_PRINT_SELECT_FILE_CELL;
            UINavigationController *nc = [[UINavigationController alloc]initWithRootViewController:pViewController];
            nc.navigationBar.barStyle = NAVIGATION_BARSTYLE;
            [self presentViewController:nc animated:YES completion:nil];
        }
        if (self.PrintPictViewID == PPV_PRINT_SELECT_PICTURE_CELL) {
            // 複数印刷対応
            if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
                ELCAlbumPickerController *albumController = [[ELCAlbumPickerController alloc] initWithNibName:@"ELCAlbumPickerController" bundle:[NSBundle mainBundle]];
                ELCImagePickerController *elcPicker = [[ELCImagePickerController alloc] initWithRootViewController:albumController];
                  albumController.navigationController.navigationBar.barStyle = NAVIGATION_BARSTYLE;
                [albumController setParent:elcPicker];
                [elcPicker setDelegate:self];
                [elcPicker setMaximumImagesCount:-1];
                [self presentViewController:elcPicker animated:YES completion:nil];
            }
        }
    }
}

// 複数印刷対応
- (void)elcImagePickerController:(ELCImagePickerController *)picker didFinishPickingMediaWithInfo:(NSArray *)info {
    [self dismissViewControllerAnimated:YES completion:nil];
    DLog(@"info = %@",info);
    [self.multiPrintPictTempArray addObjectsFromArray:info];
    
    NSNotification *n = [NSNotification notificationWithName:NK_PICT_ENTER_BUTTON_PUSHED object:self.multiPrintPictTempArray];
    NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
    [nc postNotification:n];
}

// 複数印刷対応
- (void)elcImagePickerControllerDidCancel:(ELCImagePickerController *)picker {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)OnClickPageDelButton:(id)sender
{
    // 通信中は処理しない
    if (self.isDuringCommProcess) {
        return;
    }
    
    if ([arrThumbnails count] > 0) {
        //ファイル削除
        NSFileManager* fileManager = [NSFileManager defaultManager];
        BOOL ret = [fileManager removeItemAtPath:[arrThumbnails objectAtIndex:[previewScrollViewManager getCurrentPage]] error:NULL];
        if (ret) {
            if ([arrThumbnails count] > 1) {
                CommonManager *commanager = [[CommonManager alloc]init];
                // フォルダ内の画像をリネームする
                [commanager renamingInFilepath:[arrThumbnails objectAtIndex:0]];
            }
            if(self.PrintPictViewID == EMAIL_PRINT_VIEW && self.mailFormatArray.count > 0){
                //もとの状態には戻さない
            }
            //リストから削除
            NSMutableArray* arr = [arrThumbnails mutableCopy];
            [arr removeObject:[arr lastObject]];
            arrThumbnails = [arr copy];
            
            totalPage = [arrThumbnails count];
            
            m_bOriginalViewer = (totalPage > 0);
            
            // 自前ビューアでの表示
            [self performSelectorOnMainThread:@selector(ShowFileInOriginalViewUpdate) withObject:nil waitUntilDone:YES];
        }
        else
        {
            // 削除に失敗した場合
            [self makeTmpExAlert:nil message:MSG_DEL_ERR cancelBtnTitle:nil okBtnTitle:MSG_BUTTON_OK tag:0];
        }
        if ([arrThumbnails count] == 0) {
            UIView *delBtn = [self.view viewWithTag:PAGE_DEL_BUTTON_TAG];
            [UIView animateWithDuration:0.3
                             animations:^{
                                 delBtn.alpha = 0;
                             }];
            // ボタンの活性状態を変更する
            [self SetButtonEnabledDeleted:NO];
        }
    }
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
}

// WebVeiwへのファイル表示(フルパス指定)
- (void)ShowFileInWebView:(NSString*)pstrFilePath       // 画面表示ファイルパス
{
    BOOL isOffice = [CommonUtil officeExtensionCheck:pstrFilePath];
    
    CommonManager *commanager = [[CommonManager alloc]init];
    NSInteger iCheckPDFSize = [commanager checkPdfSize:pstrFilePath];
    
    // 読み込みできない場合
    if(!isOffice &&iCheckPDFSize == CHK_PDF_NO_VIEW_FILE)
    {
        SharpScanPrintAppDelegate* appDelegate = (SharpScanPrintAppDelegate*)[[UIApplication sharedApplication] delegate];
        // 処理実行フラグON
        appDelegate.IsRun = TRUE;
        
        // エラーメッセージ切り替え
        NSString* errMsg = MSG_NO_VIEW_FILE;   
        if(self.IsAfterView)
        {
            // 取り込み完了が画面の場合、メッセージの変更
            errMsg = MSG_NO_SCAN_FILE;
            self.IsAfterView = NO;
        }
        // エラーメッセージ表示
        [self makePictureAlert:nil message:errMsg cancelBtnTitle:MSG_BUTTON_OK okBtnTitle:nil tag:0 showFlg:YES];
        // 読み込めないファイルの場合も各ボタンを活性にする
//        // 各ボタンを非活性にする
//        [self.m_pbtnFirst setEnabled:NO];
//        [self.m_pbtnSecond setEnabled:NO];
//        [self.m_pbtnThird setEnabled:NO];
//        [self.m_pbtnFourth setEnabled:NO];
//        [self.m_pbtnFifth setEnabled:NO];
//        [self.m_pbtnSixth setEnabled:NO];
//        [self.m_pbtnSeventh setEnabled:NO];
//        [self.navigationItem.rightBarButtonItem setEnabled:NO];

        m_bFinLoad = TRUE;
        m_bResult = FALSE;
        
        m_pPreviewWebView.hidden = YES;
        m_pPreviewScrollView.hidden = NO;
        
        m_bFinLoad = TRUE;
        
        //アニメーションストップ
        [m_pActivityIndicatorView stopAnimating];

        return;
    }
    
    // 暗号化ファイルの場合
    m_bEncryptedPdf = FALSE;
    if(!isOffice &&iCheckPDFSize == CHK_PDF_ENCRYPTED_FILE)
    {
        // エラーメッセージ切り替え
        NSString* errMsg;

        // iPhoneのみ対応
        // 複数印刷設定画面(ファイル印刷またはメール添付印刷)の場合は、暗号化PDFのメッセージを表示しない
        if ([self isKindOfClass:[MultiPrintPictViewController class]] &&
            (self.PrintPictViewID == PPV_PRINT_SELECT_FILE_CELL || self.PrintPictViewID == PPV_PRINT_MAIL_ATTACHMENT_CELL)) {

            DLog(@"複数印刷設定画面のため暗号化PDFメッセージなし");
        } else {
            if(m_bSendExSitePictView)
            {
                errMsg = [NSString stringWithFormat:MSG_PDF_ENCRYPTION_ERR, MSG_SEND_APPLICATION];
            }
            else
            {
                errMsg = [NSString stringWithFormat:MSG_PDF_ENCRYPTION_ERR, MSG_OTHER_APP_CHECK];
            }
        }
        
        SharpScanPrintAppDelegate* appDelegate = (SharpScanPrintAppDelegate*)[[UIApplication sharedApplication] delegate];
        // 処理実行フラグON
        appDelegate.IsRun = TRUE;
        

        if([errMsg length] > 0 && ![errMsg isEqualToString:picture_alert.message])
        {//メッセージが存在し、異なるメッセージのアラートであれば、前のを消し、新たなアラートを表示。
            
            //もとのアラートを消す
            [picture_alert dismissViewControllerAnimated:YES completion:nil];
            
            BOOL tmpShowFlg = YES;
            // 外部連携の場合は、通信処理終了後にメッセージを表示する
            if ([self isKindOfClass:NSClassFromString(@"PrintPictViewController")]) {
                
                PrintPictViewController *ppvc = (PrintPictViewController*)self;
                // 外部連携判定
                if (ppvc.IsSite) {
                    tmpShowFlg = NO;
                }
            }

            // エラーメッセージ表示
            [self makePictureAlert:nil message:errMsg cancelBtnTitle:MSG_BUTTON_OK okBtnTitle:nil tag:0 showFlg:tmpShowFlg];
        }
        else
        {//同じメッセージであれば、何もしない
        }
        
        
        // 各ボタンの活性状態にデフォルト値を設定
        if (!self.isDuringCommProcess) {
            [self.m_pbtnFirst setEnabled:m_bButtonEnable];
            [self.m_pbtnSecond setEnabled:m_bButtonEnable];
            [self.m_pbtnThird setEnabled:m_bButtonEnable];
            //if(self.isInvalidDuplexSize == YES){
            if(self.isInvalidDuplexSize == YES || self.isInvalidDuplexType){
                [self.m_pbtnFourth setEnabled:NO];
            } else {
                [self.m_pbtnFourth setEnabled:m_bButtonEnable];
            }
            [self.m_pbtnFifth setEnabled:m_bButtonEnable];
            [self.m_pbtnSixth setEnabled:m_bButtonEnable];
            [self.m_pbtnSeventh setEnabled:m_bButtonEnable];
        }
        [self.navigationItem.rightBarButtonItem setEnabled:YES];

        m_bFinLoad = TRUE;
        m_bResult = FALSE;
        
        m_bEncryptedPdf = TRUE;
        
        m_pPreviewWebView.hidden = YES;
        m_pPreviewScrollView.hidden = NO;
        
        m_bFinLoad = TRUE;
        
        //アニメーションストップ
        [m_pActivityIndicatorView stopAnimating];
        
        // 外部連携のプレビュー画面には、ページ追加ボタン不要
        if ([self isKindOfClass:[PrintPictViewController class]] && self.PrintPictViewID == PPV_OTHER) {
            return;
        }
        // 取り込み後プレビュー画面には、ページ追加ボタン不要
        if ([self isKindOfClass:[ScanAfterPictViewController class]] || [self isKindOfClass:[ScanAfterPreViewController class]]) {
            return;
        }

        // 以下機能のプレビュー画面には、ページ追加ボタン不要
        // 「アプリケーションに送る」「メールに添付する」「ファイルを管理する」
        if (![self isKindOfClass:[SendExSitePictViewController class]] &&
            ![self isKindOfClass:[SendMailPictViewController class]] &&
            ![self isKindOfClass:[ArrangePictViewController class]]) {
            // ページ追加ボタン追加
            CGRect pageAddButton = CGRectMake(self.m_pPreviewScrollView.frame.origin.x + self.m_pPreviewScrollView.frame.size.width - 55, 14, 50, 50);
            self.m_pBtnPageAddImage = [[UIButton alloc]initWithFrame:pageAddButton];
            [self.m_pBtnPageAddImage setBackgroundImage:[UIImage imageNamed:S_ICON_ADDPAGE] forState:UIControlStateNormal];
            self.m_pBtnPageAddImage.autoresizingMask = UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleLeftMargin;
            [self.m_pBtnPageAddImage addTarget:self action:@selector(OnClickPageAddButton:) forControlEvents:UIControlEventTouchUpInside];
            [self.view addSubview:self.m_pBtnPageAddImage];
            [self.view bringSubviewToFront:m_pMenuView];
            [self.view bringSubviewToFront:m_pMenuButtonView];
        }

        return;
    }
    // 各ボタンの活性状態にデフォルト値を設定
    if (!self.isDuringCommProcess) {
        [self.m_pbtnFirst setEnabled:m_bButtonEnable];
        [self.m_pbtnSecond setEnabled:m_bButtonEnable];
        [self.m_pbtnThird setEnabled:m_bButtonEnable];
        //if(self.isInvalidDuplexSize == YES){
        if(self.isInvalidDuplexSize == YES || self.isInvalidDuplexType){
            [self.m_pbtnFourth setEnabled:NO];
        } else {
            [self.m_pbtnFourth setEnabled:m_bButtonEnable];
        }
        [self.m_pbtnFifth setEnabled:m_bButtonEnable];
        [self.m_pbtnSixth setEnabled:m_bButtonEnable];
        [self.m_pbtnSeventh setEnabled:m_bButtonEnable];
    }
    [self.navigationItem.rightBarButtonItem setEnabled:YES];

    // 1ページの平均サイズが規定値超過の場合か、ファイルサイズが空きメモリ容量より大きい場合
    if (iCheckPDFSize == CHK_PDF_OVER_1PAGE_MAXSIZE ||
                      iCheckPDFSize == CHK_PDF_OVER_ACTIVEMEMORY_MAXSIZE || isOffice)
    {
        // メッセージ切り替え
        NSString* errorMessage = MSG_IMAGE_PREVIEW_ERR;
        if(iCheckPDFSize == CHK_PDF_OVER_1PAGE_MAXSIZE)
        {
            errorMessage = [NSString stringWithFormat:MSG_IMAGE_PREVIEW_ERR_PDF, N_NUM_PDF_1PAGE_MAXSIZE];
        } else if(isOffice) {
            if([self isKindOfClass:[MultiPrintPictViewController class]]) {
                // office印刷で複数選択状態の場合、エラーメッセージは出力しない
                errorMessage = @"";
            } else {
                if(m_bSendExSitePictView)
                {
                    errorMessage = [NSString stringWithFormat:MSG_PREVIEW_INCOMPATIBLE_ERR, MSG_SEND_APPLICATION];
                }
                else
                {
                    errorMessage = [NSString stringWithFormat:MSG_PREVIEW_INCOMPATIBLE_ERR, MSG_OTHER_APP_CHECK];
                }
                
            }
        }
        
        if([errorMessage length] > 0) {
            SharpScanPrintAppDelegate* appDelegate = (SharpScanPrintAppDelegate*)[[UIApplication sharedApplication] delegate];
            // 処理実行フラグON
            appDelegate.IsRun = TRUE;
            
            BOOL tmpShowFlg = YES;
            // 外部連携の場合は、通信処理終了後にメッセージを表示する
            if ([self isKindOfClass:NSClassFromString(@"PrintPictViewController")]) {
                
                PrintPictViewController *ppvc = (PrintPictViewController*)self;
                // 外部連携判定
                if (ppvc.IsSite) {
                    tmpShowFlg = NO;
                }
            }
            
            // エラーメッセージ表示
            [self makePictureAlert:nil message:errorMessage cancelBtnTitle:MSG_BUTTON_OK okBtnTitle:nil tag:0 showFlg:tmpShowFlg];
        }
        m_bResult = FALSE;

        m_pPreviewWebView.hidden = YES;
        m_pPreviewScrollView.hidden = NO;
        
        m_bFinLoad = TRUE;
        
        //アニメーションストップ
        [m_pActivityIndicatorView stopAnimating];
    }
    else
    {
        // WebView表示、ScrollView非表示
        m_pPreviewWebView.hidden = NO;
        m_pPreviewScrollView.hidden = YES;
        
        m_pPreviewWebView.scalesPageToFit = YES;
        m_pPreviewWebView.delegate = self;
        
        // URL設定
        NSURL *url = [NSURL fileURLWithPath:pstrFilePath];
        // リクエスト作成
        NSURLRequest* req = [NSURLRequest requestWithURL:url];
        // リクエスト開始
        if([[[UIDevice currentDevice]systemVersion]floatValue] < 8){ //iOS8以外ではloadRequestを使用
            [self.m_pPreviewWebView loadRequest:req];
        } else if([[[UIDevice currentDevice]systemVersion]floatValue] >= 8){ //iOS8ではloadDataを使用
            NSData *pdfData = [[NSData alloc] initWithContentsOfURL:url];
            [self.m_pPreviewWebView loadData:pdfData MIMEType:@"application/pdf" textEncodingName:@"utf-8" baseURL:[NSURL URLWithString:@"http://"]];
            
        }
    }
    
    DLog(@"class:  %@",[self class]);
    // ArrangePictViewController no
    // PrintPictViewController no
    // SendExSitePictViewController no
    // SendMailPictViewController no
    // ScanAfterPictViewController no
    
    // PrintPictViewController yes
    // MultiPrintPictViewController yes
    
//    if (![self isKindOfClass:NSClassFromString(@"SendExSitePictViewController")]) {
    if ([self isKindOfClass:NSClassFromString(@"PrintPictViewController")] ||
        [self isKindOfClass:NSClassFromString(@"MultiPrintPictViewController")]) {
        
        PrintPictViewController *ppvc = (PrintPictViewController*)self;
        // 外部連携判定
        if (ppvc.IsSite) {
            return;
        }

        // ページ追加ボタン追加
        CGRect pageAddButton = CGRectMake(self.m_pPreviewScrollView.frame.origin.x + self.m_pPreviewScrollView.frame.size.width - 55, 14, 50, 50);
        self.m_pBtnPageAddImage = [[UIButton alloc]initWithFrame:pageAddButton];
        [self.m_pBtnPageAddImage setBackgroundImage:[UIImage imageNamed:S_ICON_ADDPAGE] forState:UIControlStateNormal];
        self.m_pBtnPageAddImage.autoresizingMask = UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleLeftMargin;
        [self.m_pBtnPageAddImage addTarget:self action:@selector(OnClickPageAddButton:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:self.m_pBtnPageAddImage];
        [self.view bringSubviewToFront:m_pMenuView];
        [self.view bringSubviewToFront:m_pMenuButtonView];
    }
}

// ScrollViewへのファイル表示(フルパス指定)
- (void)ShowFileInScrollView:(NSString*)pstrFilePath    // 画面表示ファイルパス
{
    if(![CommonUtil isExistsFreeMemoryJpegConvert:pstrFilePath])
    {
        m_bFinLoad = TRUE;
        
        //アニメーションストップ
        [m_pActivityIndicatorView stopAnimating];
        
        SharpScanPrintAppDelegate* appDelegate = (SharpScanPrintAppDelegate*)[[UIApplication sharedApplication] delegate];
        // 処理実行フラグON
        appDelegate.IsRun = TRUE;
        
        [self showMemoryErrorPNG];
        m_bResult = FALSE;
        
        return;
    }
    
    
    // 画像ファイル取得
//    UIImage* img = [[UIImage alloc] initWithContentsOfFile:pstrFilePath];
    CGDataProviderRef dataProvider = CGDataProviderCreateWithFilename([pstrFilePath UTF8String]);
    UIImage* img = [CommonUtil GetUIImageByDataProvider:dataProvider maxPixelSize:1024];
    CGDataProviderRelease(dataProvider);

    // 画像表示
    [self ShowImageInScrollView:img showMessage:TRUE];
    
    if (![self isKindOfClass:NSClassFromString(@"SendExSitePictViewController")]) {
        // ページ追加ボタン追加
        CGRect pageAddButton = CGRectMake(self.m_pPreviewScrollView.frame.origin.x + self.m_pPreviewScrollView.frame.size.width - 55, 14, 50, 50);
        self.m_pBtnPageAddImage = [[UIButton alloc]initWithFrame:pageAddButton];
        [self.m_pBtnPageAddImage setBackgroundImage:[UIImage imageNamed:S_ICON_ADDPAGE] forState:UIControlStateNormal];
        self.m_pBtnPageAddImage.autoresizingMask = UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleLeftMargin;
        [self.m_pBtnPageAddImage addTarget:self action:@selector(OnClickPageAddButton:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:self.m_pBtnPageAddImage];
        [self.view bringSubviewToFront:m_pMenuView];
        [self.view bringSubviewToFront:m_pMenuButtonView];
    }
}

- (void)ShowImageInScrollView:(UIImage*)img
                  showMessage:(BOOL)showAlert       // 画面イメージ
{
    // WebView非表示、ScrollView表示
    m_pPreviewWebView.hidden = YES;
    m_pPreviewScrollView.hidden = NO;
    m_pPrintImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 306, 350)];
    m_pPrintImageView.contentMode = UIViewContentModeScaleAspectFit;
    
    // 空きメモリ容量取得
    struct vm_statistics a_vm_info;
    mach_msg_type_number_t a_count = HOST_VM_INFO_COUNT;
    host_statistics(mach_host_self(), HOST_VM_INFO,(host_info_t)&a_vm_info, &a_count);
    
    CGFloat freeCount = ((a_vm_info.free_count * vm_page_size)/1024)/1024;
    DLog(@"%f",freeCount);
        
    // 画像ファイルが何ピクセルか取得
    CGFloat pixelsize = CGImageGetWidth(img.CGImage) * CGImageGetHeight(img.CGImage);
    DLog(@"width:%lu",CGImageGetWidth(img.CGImage));
    DLog(@"height:%lu",CGImageGetHeight(img.CGImage));
    DLog(@"size:%f",pixelsize);
    // 描画に必要なバイト数取得
    CGFloat imgByte = (((pixelsize * 32)/8)/1024)/1024;
    DLog(@"byte:%f",imgByte);
    if((freeCount * N_NUM_PDF_ACTIVEMEMORY_MAXSIZE) <= imgByte)
    {
        // エラーメッセージ表示
        if (showAlert)
        {
            SharpScanPrintAppDelegate* appDelegate = (SharpScanPrintAppDelegate*)[[UIApplication sharedApplication] delegate];
            // 処理実行フラグON
            appDelegate.IsRun = TRUE;
            
            // エラーメッセージ表示
            [self makePictureAlert:nil message:MSG_IMAGE_PREVIEW_ERR cancelBtnTitle:MSG_BUTTON_OK okBtnTitle:nil tag:0 showFlg:YES];
            m_bResult = FALSE;
        }
    }
    else
    {
        // 縦横の縮小倍率を比較して小さい方の倍率で縮小
        CGFloat magnificationW = (306 * 1.5) / img.size.width;
        CGFloat magnificationH = (350 * 1.5) / img.size.height;
        if(magnificationW < 1 || magnificationH < 1)
        {
            // 縮小倍率取得
            CGFloat magnification = magnificationW;
            if(magnificationH < magnificationW)
            {
                magnification = magnificationH;
            }
            // 縮小後領域準備
            CGRect rectImg = CGRectMake(0.0, 0.0, (img.size.width * magnification), (img.size.height * magnification));
            UIGraphicsBeginImageContext(rectImg.size);
            // 縮小後領域描画
            [img drawInRect:rectImg];
            // 縮小領域からImageを作成 (UIGraphicsGetImageFromCurrentImageContext はautorelease)
            UIImage* imgReduction = UIGraphicsGetImageFromCurrentImageContext();
            UIGraphicsEndImageContext(); // 解除
            // 画像をImageViewに設定
            m_pPrintImageView.image = imgReduction;
        }
        else
        {
            // 画像をImageViewに設定
            m_pPrintImageView.image = img;
        }
    }
    
    m_pPreviewScrollView.pagingEnabled = NO;                            // ページ単位スクロール
    m_pPreviewScrollView.contentSize = m_pPrintImageView.frame.size;    // スクロール可能サイズ
    m_pPreviewScrollView.showsHorizontalScrollIndicator = YES;          // 横スクロールバー表示
    m_pPreviewScrollView.showsVerticalScrollIndicator = YES;            // 縦スクロールバー表示
    [m_pPreviewScrollView setMinimumZoomScale:1.0];                     // 縮小率の限界値
    [m_pPreviewScrollView setMaximumZoomScale:5.0];                     // 拡大率の限界値
    //m_pPreviewScrollView.backgroundColor = [UIColor blackColor];        // 背景色
    m_pPreviewScrollView.delegate = self;                               // デリゲート
    
    [m_pPreviewScrollView addSubview:m_pPrintImageView];
        
    m_bFinLoad = TRUE;
    
    //アニメーションストップ
	[m_pActivityIndicatorView stopAnimating];
}

// ファイル表示失敗時処理
- (void)ShowFileError
{
    m_bFinLoad = TRUE;
    
    //アニメーションストップ
    [m_pActivityIndicatorView stopAnimating];
    
    m_pstrFilePath = nil;
    m_pdicEditInfo = nil;
    
    SharpScanPrintAppDelegate* appDelegate = (SharpScanPrintAppDelegate*)[[UIApplication sharedApplication] delegate];
    // 処理実行フラグON
    appDelegate.IsRun = TRUE;
    
    // エラーメッセージ表示
    [self makePictureAlert:nil message:MSG_PREVIEW_ERR cancelBtnTitle:MSG_BUTTON_OK okBtnTitle:nil tag:0 showFlg:YES];
    m_bResult = FALSE;
}

// ファイル読み込み完了
- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    m_pPreviewWebView.backgroundColor = [UIColor blackColor];
    m_bFinLoad = TRUE;
    
    //アニメーションストップ
	[m_pActivityIndicatorView stopAnimating];
}

// ファイル読み込み失敗
- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    // エラー処理
    [self ShowFileError];
}

// ScrollViewピンチイン/アウト
- (UIView*)viewForZoomingInScrollView:(UIScrollView *)scrollView
{
    return m_pPrintImageView;
}

// ボタン押下関数
// ナビゲーションバー 設定ボタン押下
- (IBAction)OnNavBarRightButton:(id)sender
{
    // 処理中あるいは処理中断フラグ=TRUEの場合は何もしない
    if (self.m_pThread || m_bAbort)
    {
        return;
    }
    
    bNavRightBtn = YES;
    
    // 戻るボタンの名称変更
    UIBarButtonItem * barItemBack = [UIBarButtonItem new];
    barItemBack.title = S_BUTTON_BACK;
    self.navigationItem.backBarButtonItem = barItemBack;
    
    // スレッドキャンセル
    if (self.queue != nil) {
        [self.queue cancelAllOperations];
        NSLog(@"キューキャンセル(設定ボタン押下時)");
    }
    if (self.isDuringCommProcess) {
        self.isDuringCommProcess = NO;
    }
    
    //設定トップ画面に遷移
    SettingSelInfoViewController *pSettingViewController = [[SettingSelInfoViewController alloc] initWithStyle:UITableViewStyleGrouped];
//    [self.navigationController pushViewController:pSettingViewController animated:YES];
    // モーダル表示
    UINavigationController *navigationController = [[UINavigationController alloc]initWithRootViewController:pSettingViewController];
    navigationController.navigationBar.barStyle = NAVIGATION_BARSTYLE;
    [navigationController setModalPresentationStyle:UIModalPresentationPageSheet];
    [self presentViewController:navigationController animated:YES completion:nil];

}

// メニュー表示ボタン押下
- (IBAction)OnShowMenuButton:(id)sender
{
    // 処理中あるいは処理中断フラグ=TRUEの場合は何もしない
    if (self.m_pThread || m_bAbort)
    {
        return;
    }
    [self AnimationShowMenu];
}

// メニューボタン１押下
- (IBAction)OnMenuFirstButton:(id)sender
{

}

// メニューボタン２押下
- (IBAction)OnMenuSecondButton:(id)sender
{

}

// メニューボタン３押下
- (IBAction)OnMenuThirdButton:(id)sender
{

}

// メニューボタン４押下
- (IBAction)OnMenuFourthButton:(id)sender
{

}

// アクションシート決定ボタン押下
- (IBAction)OnMenuDecideButton:(id)sender
{
}

// アクションシートキャンセルボタン押下
- (IBAction)OnMenuCancelButton:(id)sender
{
    // 選択行をもとに戻す
    switch (m_nSelPicker) 
    {
        case PrvMenuIDFirst:
            self.m_nSelPickerRow1 = m_nSelPickerRowBefore;
            break;
        case PrvMenuIDSecond:
            self.m_nSelPickerRow2 = m_nSelPickerRowBefore;
            break;
        case PrvMenuIDThird:
            self.m_nSelPickerRow3 = m_nSelPickerRowBefore;
            break;
        case PrvMenuIDFourth:
            self.m_nSelPickerRow4 = m_nSelPickerRowBefore;
            break;
        case PrvMenuIDFifth:
            self.m_nSelPickerRow5 = m_nSelPickerRowBefore;
            break;
        case PrvMenuIDSixth:
            self.m_nSelPickerRow6 = m_nSelPickerRowBefore;
            break;
        case PrvMenuIDSeventh:
            self.m_nSelPickerRow7 = m_nSelPickerRowBefore;
            break;
        case PrvMenuIDEighth:
            self.m_nSelPickerRow8 = m_nSelPickerRowBefore;
            break;
        case PrvMenuIDNone:
            break;
        default:
            break;
    }
    m_nSelPicker = PrvMenuIDNone;
    
    [_pickerModalBaseView dismissAnimated:YES];
}

// アニメーション関数
// メニュー表示アニメーション
-(void) AnimationShowMenu
{
    // アニメーション設定
    [UIView beginAnimations:@"menu" context:(__bridge void *)(m_pMenuView)];                   // アニメーション開始
    [UIView setAnimationDuration:0.5f];                                     // アニメーション間隔
    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];               // アニメーションタイプ
    [UIView setAnimationDelegate:self];                                     // デリゲート設定
    [UIView setAnimationDidStopSelector:@selector(EndAnimationShowMenu)]; // アニメーション完了イベント
    if (m_bShowMenu)
    {
        // メニュー表示→非表示
        int offset = 0;

        if([self isKindOfClass:[RemoteScanBeforePictViewController class]]){
            offset = -4;
        }
        else if([self class] == [PrintPictViewController class] ||
                [self class] == [MultiPrintPictViewController class])
        {
            offset = -2;
        }
        m_pMenuView.transform = CGAffineTransformMakeTranslation(0, DEFAULT_MENU_Y + offset);
        m_pMenuButtonView.transform = CGAffineTransformMakeTranslation(0, DEFAULT_MENU_Y + offset);
    }
    else
    {
        // メニュー非表示→表示
        CGFloat fRectY2 = [self AnimationShowMenuRectY];
        m_pMenuView.transform = CGAffineTransformMakeTranslation(0, fRectY2);
        m_pMenuButtonView.transform = CGAffineTransformMakeTranslation(0, fRectY2);
    }
    [self AnimationShowMenuArrow];

    [UIView commitAnimations];
}

- (void)AnimationNotShowMenu {
    // アニメーション設定
    [UIView beginAnimations:@"menu" context:(__bridge void *)(m_pMenuView)];                   // アニメーション開始
    [UIView setAnimationDuration:0.5f];                                     // アニメーション間隔
    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];               // アニメーションタイプ
    [UIView setAnimationDelegate:self];                                     // デリゲート設定
    [UIView setAnimationDidStopSelector:@selector(EndAnimationShowMenu)]; // アニメーション完了イベント
    if (!m_bShowMenu)
    {
        // メニュー表示→非表示
        int offset = 0;
        BOOL iPhoneSize4inches = [[UIScreen mainScreen] bounds].size.height >= 568;
        BOOL iPhoneSize4_7inches = [[UIScreen mainScreen] bounds].size.height >= 667;
        BOOL iPhoneSize5_5inches = [[UIScreen mainScreen] bounds].size.height >= 736;
        if([self class] == [RemoteScanBeforePictViewController class] && iPhoneSize4inches){
            offset = [self.view frame].size.height - 416;//
        }
        else if([self class] == [PrintPictViewController class]){
            if(iPhoneSize5_5inches){
                offset = -2;
            } else if(iPhoneSize4_7inches) {
                offset = -2;
            } else if(iPhoneSize4inches) {
                offset = [self.view frame].size.height - 505;
            } else {
                offset = -2;
            }
        }
        m_pMenuView.transform = CGAffineTransformMakeTranslation(0, DEFAULT_MENU_Y + offset);
        m_pMenuButtonView.transform = CGAffineTransformMakeTranslation(0, DEFAULT_MENU_Y + offset);
    }
    else
    {
        // メニュー非表示→表示
        CGFloat fRectY2 = [self AnimationShowMenuRectY];
        m_pMenuView.transform = CGAffineTransformMakeTranslation(0, fRectY2);
        m_pMenuButtonView.transform = CGAffineTransformMakeTranslation(0, fRectY2);
    }
    //[self AnimationShowMenuArrow];
    
    [UIView commitAnimations];
}

// ピッカー非表示アニメーション完了
- (void)EndAnimationShowMenu
{
    
}

// メニュー矢印アニメーション開始
- (void)AnimationShowMenuArrow
{
    // アニメーション設定
    [UIView beginAnimations:@"menu" context:(__bridge void *)(m_pMenuView)];                      // アニメーション開始
    [UIView setAnimationDuration:0.25f];                                       // アニメーション間隔
    [UIView setAnimationCurve:UIViewAnimationCurveLinear];                     // アニメーションタイプ
    [UIView setAnimationDelegate:self];                                        // デリゲート設定
    [UIView setAnimationDidStopSelector:@selector(EndAnimationShowMenuArrow)]; // アニメーション完了イベント
    
    // 矢印の変更がある場合表示中の矢印を消す
//    BOOL prev_arrow_up = [m_pMenuArrowImageView.image isEqual:[UIImage imageNamed:@"ArrowDown.png"]];
//    if(prev_arrow_up == m_bShowMenu){
//        CGRect frame = m_pMenuArrowImageView.frame;
//        frame.size.height = 1;
//        [m_pMenuArrowImageView setFrame:frame];
//    }
    [UIView commitAnimations];
}

// メニュー矢印アニメーション完了
- (void)EndAnimationShowMenuArrow
{
    // 矢印イメージを変更
    NSString* strArrowImageName = @"ArrowDown.png";
    if (m_bShowMenu)
    {
        strArrowImageName = @"ArrowUp.png";
    }
    m_pMenuArrowImageView.image = nil;
    m_pMenuArrowImageView.image = [UIImage imageNamed:strArrowImageName];
    
    // アニメーション設定
    [UIView beginAnimations:@"menu" context:(__bridge void *)(m_pMenuView)];                      // アニメーション開始
    [UIView setAnimationDuration:0.25f];                                       // アニメーション間隔
    [UIView setAnimationCurve:UIViewAnimationCurveLinear];                     // アニメーションタイプ
    [UIView setAnimationDelegate:self];                                        // デリゲート設定
    
    // 矢印表示
    CGRect frame = m_pMenuArrowImageView.frame;
    frame.size.height = 48;
    [m_pMenuArrowImageView setFrame:frame];
    
    //フラグ
    m_bShowMenu = !m_bShowMenu;
    
    [UIView commitAnimations];
}

// メニュー非表示から表示へアニメーションする時のY座標
- (CGFloat)AnimationShowMenuRectY
{
    // メニュー非表示→表示
    CGFloat fRectY1 = [self.m_pbtnFirst frame].origin.y + DEFAULT_MENU_Y;  // 最初のボタンのy座標
    CGFloat fRectY2 = 0.0;                                  // 最後のボタンのy座標
    
    BOOL iPhoneSize4inches = [[UIScreen mainScreen] bounds].size.height >= 568;
    BOOL iPhoneSize4_7inches = [[UIScreen mainScreen] bounds].size.height >= 667;
    BOOL iPhoneSize5_5inches = [[UIScreen mainScreen] bounds].size.height >= 736;

    switch (m_nMenuBtnNum)
    {
        case PrvMenuIDSecond:
            fRectY2 = [self.m_pbtnSecond frame].origin.y;
            if(m_bBeforeView && bRemoteScanSwitch)
            {
                fRectY2 += 50;
            }
            else
            {
                if (bRemoteScanSwitch) {
                    if(iPhoneSize5_5inches){
                        fRectY2 = [self.m_pbtnEighth frame].origin.y - 42;
                    } else if(iPhoneSize4_7inches) {
                        fRectY2 = [self.m_pbtnEighth frame].origin.y - 42;
                    } else if(iPhoneSize4inches) {
                        fRectY2 = [self.m_pbtnEighth frame].origin.y - 42;
                    } else {
                        fRectY2 = [self.m_pbtnSeventh frame].origin.y - 25;
                    }
                }
            }
            break;
        case PrvMenuIDThird:
            fRectY2 = [self.m_pbtnThird frame].origin.y;
            break;
        case PrvMenuIDFourth:
            fRectY2 = [self.m_pbtnFourth frame].origin.y;
            break;
        case PrvMenuIDFifth:
            fRectY2 = [self.m_pbtnFifth frame].origin.y;
            break;
        case PrvMenuIDSixth:
            fRectY2 = [self.m_pbtnSixth frame].origin.y;
            break;
        case PrvMenuIDSeventh:
            if(iPhoneSize5_5inches){
                fRectY2 = [self.m_pbtnSeventh frame].origin.y + 10;
            } else if(iPhoneSize4_7inches) {
                fRectY2 = [self.m_pbtnSeventh frame].origin.y + 10;
            } else if(iPhoneSize4inches) {
                fRectY2 = [self.m_pbtnSeventh frame].origin.y + 10;
            } else {
                fRectY2 = [self.m_pbtnSeventh frame].origin.y;
            }
            break;
        case PrvMenuIDEighth:
            if(iPhoneSize5_5inches) {
                if(bRemoteScanSwitch)
                {
                    fRectY2 = [self.m_pbtnEighth frame].origin.y + 50;
                }
                else
                {
                    fRectY2 = [self.m_pbtnEighth frame].origin.y;
                }
                break;
            } else if(iPhoneSize4_7inches) {
                if(bRemoteScanSwitch)
                {
                    fRectY2 = [self.m_pbtnEighth frame].origin.y + 50;
                }
                else
                {
                    fRectY2 = [self.m_pbtnEighth frame].origin.y + 10;
                }
                break;
            } else if(iPhoneSize4inches) {
                if(bRemoteScanSwitch)
                {
                    fRectY2 = [self.m_pbtnEighth frame].origin.y + 50;
                    break;
                }
            } else {
                if(bRemoteScanSwitch)
                {
                    fRectY2 = [self.m_pbtnSeventh frame].origin.y - 25;
                    break;
                }
            }
        case PrvMenuIDNinth:
            if(iPhoneSize5_5inches) {
                fRectY2 = [self.m_pbtnNinth frame].origin.y;
                break;
            } else if(iPhoneSize4_7inches) {
                fRectY2 = [self.m_pbtnNinth frame].origin.y + 10;
                break;
            } else if(iPhoneSize4inches) {
                
            } else {
                
            }
        case PrvMenuIDTenth:
            if(iPhoneSize5_5inches) {
                fRectY2 = [self.m_pbtnTenth frame].origin.y;
            } else if(iPhoneSize4_7inches) {
                fRectY2 = [self.m_pbtnEighth frame].origin.y + 100;
            } else if(iPhoneSize4inches) {
                fRectY2 = [self.m_pbtnEighth frame].origin.y + 25;
                CGRect frame = CGRectMake(0,self.view.frame.origin.y,self.view.frame.size.width,504);
                self.view.frame = frame;
            } else {
                fRectY2 = [self.m_pbtnSeventh frame].origin.y - 19;
                CGRect frame = CGRectMake(0,self.view.frame.origin.y,self.view.frame.size.width,416);
                self.view.frame = frame;
            }
            break;
            
        
        case PrvMenuIDEleventh:
            if(iPhoneSize5_5inches) {
                fRectY2 = [self.m_pbtnEleventh frame].origin.y;
            } else if(iPhoneSize4_7inches) {
                fRectY2 = [self.m_pbtnEighth frame].origin.y + 100;
            } else if(iPhoneSize4inches) {
                fRectY2 = [self.m_pbtnEighth frame].origin.y + 25;
                CGRect frame = CGRectMake(0,self.view.frame.origin.y,self.view.frame.size.width,504);
                self.view.frame = frame;
            } else {
                fRectY2 = [self.m_pbtnSeventh frame].origin.y - 19;
                CGRect frame = CGRectMake(0,self.view.frame.origin.y,self.view.frame.size.width,416);
                self.view.frame = frame;
            }
            break;
            
        case PrvMenuIDTwelveth:
            if(iPhoneSize5_5inches) {
                fRectY2 = [self.m_pbtnTwelveth frame].origin.y;
            } else if(iPhoneSize4_7inches) {
                fRectY2 = [self.m_pbtnEighth frame].origin.y + 100;
            } else if(iPhoneSize4inches) {
                fRectY2 = [self.m_pbtnEighth frame].origin.y + 25;
                CGRect frame = CGRectMake(0,self.view.frame.origin.y,self.view.frame.size.width,504);
                self.view.frame = frame;
            } else {
                fRectY2 = [self.m_pbtnSeventh frame].origin.y - 19;
                CGRect frame = CGRectMake(0,self.view.frame.origin.y,self.view.frame.size.width,416);
                self.view.frame = frame;
            }
            break;
        
            
        case PrvMenuIDThirteenth:
            if(iPhoneSize5_5inches) {
                fRectY2 = [self.m_pbtnThirteenth frame].origin.y;
            } else if(iPhoneSize4_7inches) {
                fRectY2 = [self.m_pbtnEighth frame].origin.y + 100;
            } else if(iPhoneSize4inches) {
                fRectY2 = [self.m_pbtnEighth frame].origin.y + 25;
                CGRect frame = CGRectMake(0,self.view.frame.origin.y,self.view.frame.size.width,504);
                self.view.frame = frame;
            } else {
                fRectY2 = [self.m_pbtnSeventh frame].origin.y - 19;
                CGRect frame = CGRectMake(0,self.view.frame.origin.y,self.view.frame.size.width,416);
                self.view.frame = frame;
            }
            break;
            
        case PrvMenuIDFourteenth:
            if(iPhoneSize5_5inches) {
                fRectY2 = [self.m_pbtnFourteenth frame].origin.y;
            } else if(iPhoneSize4_7inches) {
                fRectY2 = [self.m_pbtnEighth frame].origin.y + 100;
            } else if(iPhoneSize4inches) {
                fRectY2 = [self.m_pbtnEighth frame].origin.y + 25;
                CGRect frame = CGRectMake(0,self.view.frame.origin.y,self.view.frame.size.width,504);
                self.view.frame = frame;
            } else {
                fRectY2 = [self.m_pbtnSeventh frame].origin.y - 19;
                CGRect frame = CGRectMake(0,self.view.frame.origin.y,self.view.frame.size.width,416);
                self.view.frame = frame;
            }
            break;
            
        default:
            break;
    }
    return fRectY1 - fRectY2;
}

// 画面表示時メニュー表示アニメーション1
- (void)AnimationShowStartMenu
{
//    // ボタン押下不可
//    [self SetButtonEnabled:NO];
    
    // アニメーション開始まで0.5秒待つ
    [NSThread sleepUntilDate: [NSDate dateWithTimeIntervalSinceNow: 0.5]];
    
    // アニメーション設定
    [UIView beginAnimations:@"startMenu" context:(__bridge void *)(m_pMenuView)];  // アニメーション開始
    [UIView setAnimationDuration:0.5f];                         // アニメーション間隔
    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];   // アニメーションタイプ
    [UIView setAnimationDelegate:self];                         // デリゲート設定
    [UIView setAnimationDidStopSelector:@selector(EndAnimationShowStartMenu)];  // アニメーション完了イベント
    
    CGFloat fRectY2 = [self AnimationShowMenuRectY];
    // メニュー表示
    m_pMenuView.transform = CGAffineTransformMakeTranslation(0, fRectY2 - 7);
    m_pMenuButtonView.transform = CGAffineTransformMakeTranslation(0, fRectY2 - 7);
    
    [UIView commitAnimations];
}

// 画面表示時メニュー表示アニメーション1完了
- (void)EndAnimationShowStartMenu
{
    // アニメーション設定
    [UIView beginAnimations:@"startMenu2" context:(__bridge void *)(m_pMenuView)]; // アニメーション開始
    [UIView setAnimationDuration:0.5f];                         // アニメーション間隔
    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];   // アニメーションタイプ
    [UIView setAnimationDelegate:self];                         // デリゲート設定
    [UIView setAnimationDidStopSelector:@selector(EndAnimationShowStartMenu2)]; // アニメーション完了イベント
    
    CGFloat fRectY2 = [self AnimationShowMenuRectY];
    m_pMenuView.transform = CGAffineTransformMakeTranslation(0, fRectY2);
    m_pMenuButtonView.transform = CGAffineTransformMakeTranslation(0, fRectY2);
    
    // 矢印表示切り替え
    [self AnimationShowMenuArrow];

    [UIView commitAnimations];    
}

// 画面表示時メニュー表示アニメーション2完了
- (void)EndAnimationShowStartMenu2
{
    // ボタン押下可
    [self SetButtonEnabled:YES];
}


//iOS8ではアクションシートにUIPickerViewを組み込めない問題への対策
- (PickerModalBaseView*)viewForModalPickerWithIsPrint:(BOOL)isPrint
{
    PickerModalBaseView* pmbv = [[PickerModalBaseView alloc] init];
    pmbv.frame = self.navigationController.view.bounds;
    
    CGFloat navBarHeight = 44;
//    CGFloat pickerHeight = 216;
    CGFloat barOriginY   = 0;
    
//    CGRect barRect = CGRectMake(0, barOriginY, 320, navBarHeight);
    CGRect mainRec = [[UIScreen mainScreen] bounds];
    CGRect barRect = CGRectMake(0, barOriginY, mainRec.size.width, navBarHeight);
    UINavigationBar *naviBar = [[UINavigationBar alloc] initWithFrame:barRect];
    naviBar.barStyle = TOOLBAR_BARSTYLE;
    UINavigationItem *naviItem = [[UINavigationItem alloc] initWithTitle:@""];
    
    // 決定ボタン
    UIBarButtonItem *pDecideBtn = [[UIBarButtonItem alloc] initWithTitle:S_BUTTON_DECIDE
                                                                   style:UIBarButtonItemStylePlain
                                                                  target:self
                                                                  action:@selector(OnMenuDecideButton:)];
    
    // キャンセルボタン
    UIBarButtonItem *pCancelBtn = [[UIBarButtonItem alloc] initWithTitle:S_BUTTON_CANCEL
                                                                   style:UIBarButtonItemStylePlain
                                                                  target:self
                                                                  action:@selector(OnMenuCancelButton:)];
    
    naviItem.rightBarButtonItem = pDecideBtn;
    naviItem.leftBarButtonItem = pCancelBtn;
    
    if (isPrint) {
        // 切り替えセグメントを追加する
        // UISegmentedControl を真ん中に追加
        UIImage *image1 = [UIImage imageNamed:S_ICON_PRINTER];
        UIImage *image2 = [UIImage imageNamed:S_ICON_PRINTSERVER];
        NSArray *items = [NSArray arrayWithObjects:image1, image2, nil];
        segmentedControl = [[UISegmentedControl alloc] initWithItems:items];
        segmentedControl.momentary = NO;
        segmentedControl.contentMode = UIViewContentModeScaleAspectFit;
        segmentedControl.frame = CGRectMake(segmentedControl.frame.origin.x, segmentedControl.frame.origin.y, segmentedControl.frame.size.width + 16.0f * [items count], segmentedControl.frame.size.height);
        [segmentedControl addTarget:self action:@selector(segmentedControlAction:) forControlEvents:UIControlEventValueChanged];
        
        // プリンタかプリントサーバーかの設定を確認する
        PrintOutDataManager* printOutManager = [[PrintOutDataManager alloc]init];
        NSInteger select = [printOutManager GetLatestPrintType];
        
        [segmentedControl setSelectedSegmentIndex:select];
        //        naviItem.titleView = segmentedControl; // TODO: プリントサーバー機能を一旦外す
        
    }
    
    [naviBar pushNavigationItem:naviItem animated:NO];
    
    [pmbv addView:naviBar];
    
    return pmbv;
}



// ピッカービュー関連
// ピッカー表示
- (void)ShowPickerView:(NSInteger)nMenuBtnID            // メニューボタンID
            pickerMenu:(NSMutableArray*)parrPickerMenu  // メニュー用ピッカー表示項目
{
    [self ShowPickerView:nMenuBtnID pickerID:nMenuBtnID pickerMenu:parrPickerMenu];
}

- (void)ShowPickerView:(NSInteger)nMenuBtnID            // メニューボタンID
              pickerID:(NSInteger)nPickerID             // ピッカーID
            pickerMenu:(NSMutableArray*)parrPickerMenu  // メニュー用ピッカー表示項目
{
    //[self ShowPickerView:nMenuBtnID pickerMenu:parrPickerMenu pickerMenu2:nil isPrint:NO];
    [self ShowPickerView:nMenuBtnID pickerID:nPickerID pickerMenu:parrPickerMenu pickerMenu2:nil isPrint:NO];
}

- (void)ShowPickerView:(NSInteger)nMenuBtnID            // メニューボタンID
              pickerID:(NSInteger)nPickerID             // ピッカーID
            pickerMenu:(NSMutableArray*)parrPickerMenu  // メニュー用ピッカー表示項目
           pickerMenu2:(NSMutableArray*)parrPickerMenu2  // メニュー用ピッカー表示項目
               isPrint:(BOOL)isPrint                    // 印刷モード
{
    // ピッカービューをビューから削除
    [m_ppickerMenu removeFromSuperview];

    // メニューボタンID不正
    if (m_nMenuBtnNum < nMenuBtnID)
    {
        return;
    }

    if ((nMenuBtnID < PrvMenuIDNone) || (nMenuBtnID >= PrvMenuIDMax))
    {
        return;
    }
    
    // 選択中ピッカーIDを設定
    //m_nSelPicker = nMenuBtnID;
    m_nSelPicker = nPickerID;
    NSInteger nSelRow = 0;
    
    // 選択中の項目取得
    //switch (nMenuBtnID)
    switch (nPickerID)
    {
        case PrvMenuIDFirst:
            nSelRow = self.m_nSelPickerRow1;
            break;
        case PrvMenuIDSecond:
            nSelRow = self.m_nSelPickerRow2;
            break;
        case PrvMenuIDThird:
            nSelRow = self.m_nSelPickerRow3;
            break;
        case PrvMenuIDFourth:
            nSelRow = self.m_nSelPickerRow4;
            break;
        case PrvMenuIDFifth:
            nSelRow = self.m_nSelPickerRow5;
            break;
        case PrvMenuIDSixth:
            nSelRow = self.m_nSelPickerRow6;
            break;
        case PrvMenuIDSeventh:
            nSelRow = self.m_nSelPickerRow7;
            break;
        case PrvMenuIDEighth:
            nSelRow = self.m_nSelPickerRow8;
            break;
        default:
            break;
    }
    m_parrPickerRow = [parrPickerMenu copy];
    m_parrPickerRow2 = [parrPickerMenu2 copy];
    
    // 現在の選択行を保持
    m_nSelPickerRowBefore = nSelRow;
    
    
    // プリンターかプリントサーバーのどちらかのみが登録されている場合は切り替えれなくする
    if ([parrPickerMenu count] == 0) {
        [segmentedControl setEnabled:NO forSegmentAtIndex:0];
    }else if ([parrPickerMenu2 count] == 0){
        [segmentedControl setEnabled:NO forSegmentAtIndex:1];
    }

    // ピッカー作成
    m_ppickerMenu = [self CreatePickerView];

    // 現在の選択項目を初期表示とする
    if(PrvMenuIDThird != nMenuBtnID)
    {
        self.isSingleChar = NO;
        [m_ppickerMenu selectRow:nSelRow inComponent:0 animated:NO];
    }
    else
    {
        self.isSingleChar = YES;
        NSInteger nSelRowTen = (nSelRow / 10);
        // 10の位
        [m_ppickerMenu selectRow:nSelRowTen inComponent:0 animated:NO];
        // 1の位 ※0の場合は1を設定
        NSInteger nSelRowOne = (nSelRow == 0) ? 1 : (nSelRow - nSelRowTen * 10);
        [m_ppickerMenu selectRow:nSelRowOne inComponent:1 animated:NO];
    }
    
    //ピッカー背景色
    if([[[UIDevice currentDevice]systemVersion]floatValue]<8)
    {
    }
    else
    {
        m_ppickerMenu.backgroundColor = [UIColor whiteColor];
    }

    //actionSheet代替pickerModalBaseView生成
    _pickerModalBaseView= [self viewForModalPickerWithIsPrint:isPrint];
    
    //pickerをセット
    [_pickerModalBaseView addView:m_ppickerMenu];
    
    //表示
    [_pickerModalBaseView showInView:self.navigationController.view animated:YES];
    

}

// ピッカー作成
- (UIPickerView*)CreatePickerView
{
    CGFloat pickerHeight = 216;

	UIPickerView *pPicker;
	
	pPicker = [[UIPickerView alloc] init];
	
	pPicker.delegate = self;
	pPicker.dataSource = self;
	
    CGRect mainRec = [[UIScreen mainScreen] bounds];
    // ピッカー位置設定
    if(m_nSelPicker == PrvMenuIDThird)
    {//第３ボタン（部数選択）だけ特別
//        [pPicker setFrame:CGRectMake(0, 0, 320, pickerHeight)];
        [pPicker setFrame:CGRectMake(0, 0, mainRec.size.width, pickerHeight)];
    }
    
//    [pPicker setCenter:CGPointMake(160, 152)];
    // 選択時のインジケータを表示
	[pPicker setShowsSelectionIndicator:TRUE];
	
	return pPicker;
}

// 列数返却
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView*)pickerView
{
    NSInteger numPicker = 1;
    // 部数の場合は２列
    if(m_nSelPicker == PrvMenuIDThird)
    {
        numPicker = 2;
    }
    return numPicker;
}

// 行数返却
- (NSInteger)pickerView:(UIPickerView*)pickerView numberOfRowsInComponent:(NSInteger)component
{
//    return [m_parrPickerRow count];
    if (segmentedControl && segmentedControl.selectedSegmentIndex == 1) {
        return [m_parrPickerRow2 count];
    } else {
        return [m_parrPickerRow count];
    }
}

// ピッカーに表示する文字列を返却
- (NSString*)pickerView:(UIPickerView*)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
//    return [m_parrPickerRow objectAtIndex:row];
    if (segmentedControl && segmentedControl.selectedSegmentIndex == 1) {
        return [m_parrPickerRow2 objectAtIndex:row];
    } else {
        return [m_parrPickerRow objectAtIndex:row];
    }
}

//
//ピッカーに表示する文字列を返却
//
- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view {
    UILabel* label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, [pickerView rowSizeForComponent:component].width-8, [pickerView rowSizeForComponent:component].height)];
    if (segmentedControl && segmentedControl.selectedSegmentIndex == 1) {
        [label setText:[m_parrPickerRow2 objectAtIndex:row]];
    } else {
        [label setText:[m_parrPickerRow objectAtIndex:row]];
    }
    [label setFont:[UIFont boldSystemFontOfSize:15]];
    [label setBackgroundColor:[UIColor clearColor]];
    if(self.isSingleChar){
        label.textAlignment = NSTextAlignmentCenter;
    }
    return label;
}
//列の幅を指定します
-(CGFloat)pickerView:
(UIPickerView*)pickerView
   widthForComponent:(NSInteger)component
{
    if(self.isSingleChar){
        return 50;
    }
    else {
        return pickerView.frame.size.width /[self numberOfComponentsInPickerView:pickerView];
    }
}

// ピッカーの値選択時の動作
- (void)pickerView:(UIPickerView*)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    switch (m_nSelPicker) 
    {
        case PrvMenuIDFirst:
            self.m_nSelPickerRow1 = row;
            break;
        case PrvMenuIDSecond:
            self.m_nSelPickerRow2 = row;
            break;
        case PrvMenuIDThird:
            if(0 == component)
            {
                // 10の位を更新
                self.m_nSelPickerRow3 = (row * 10) + (self.m_nSelPickerRow3 - ((self.m_nSelPickerRow3 / 10) * 10));
            }
            else
            {
                // 1の位を更新
                self.m_nSelPickerRow3 = ((self.m_nSelPickerRow3 / 10) * 10) + row;
            }
            if(0 == self.m_nSelPickerRow3)
            {
                self.m_nSelPickerRow3 = 1;
            }
            break;
        case PrvMenuIDFourth:
            self.m_nSelPickerRow4 = row;
            break;
        case PrvMenuIDFifth:
            self.m_nSelPickerRow5 = row;
            break;
        case PrvMenuIDSixth:
            self.m_nSelPickerRow6 = row;
            break;
        case PrvMenuIDSeventh:
            self.m_nSelPickerRow7 = row;
            break;
        case PrvMenuIDEighth:
            self.m_nSelPickerRow8 = row;
            break;
        case PrvMenuIDNone:
            break;
        default:
            break;
    }
}

// ピッカービューのアイテムを切り替える
- (void)segmentedControlAction:(UISegmentedControl *)sc {
    [m_ppickerMenu reloadAllComponents];
    
    // 最新プライマリキーを取得して選択中MFPを設定
    PrintOutDataManager* printOutManager = [[PrintOutDataManager alloc]init];
    NSInteger nSaveIdx = -1;
    
    // デフォルト指定のプリンターもしくはプリントダーバーを選択する
    if (sc.selectedSegmentIndex == 0) {
        // PrinterDataManagerクラス初期化
        PrinterDataManager *m_pPrinterMgr = [[PrinterDataManager alloc] init];
        nSaveIdx = [m_pPrinterMgr GetPrinterIndexForKey:[printOutManager GetLatestPrimaryKey]];
        [m_ppickerMenu selectRow:nSaveIdx inComponent:0 animated:NO];
        m_nSelPickerRowBefore = nSaveIdx;
    }else {
        // PrintServerDataManagerクラス初期化
        PrintServerDataManager *m_pPrintServerMgr = [[PrintServerDataManager alloc] init];
        nSaveIdx = [m_pPrintServerMgr GetPrinterIndexForKey:[printOutManager GetLatestPrimaryKey2]];
        [m_ppickerMenu selectRow:nSaveIdx inComponent:0 animated:NO];
        m_nSelPickerRowBefore = nSaveIdx;
    }
}

// その他サブ関数
// ボタン押下Enabled設定
- (void)SetButtonEnabled:(BOOL)bEnable
{
    // ナビゲーションバー
    //self.navigationController.navigationBar.userInteractionEnabled = bEnable;
    // メニュー表示ボタン
//    m_pbtnShowMenu.userInteractionEnabled = bEnable;
    // 各メニューボタン
    self.m_pbtnFirst.userInteractionEnabled = bEnable;
    self.m_pbtnSecond.userInteractionEnabled = bEnable;
    self.m_pbtnThird.userInteractionEnabled = bEnable;
    self.m_pbtnFourth.userInteractionEnabled = bEnable;
    self.m_pbtnFifth.userInteractionEnabled = bEnable;
    self.m_pbtnSixth.userInteractionEnabled = bEnable;
    self.m_pbtnSeventh.userInteractionEnabled = bEnable;
    self.m_pbtnEighth.userInteractionEnabled = bEnable;
    self.m_pbtnNinth.userInteractionEnabled = bEnable;
    self.m_pbtnTenth.userInteractionEnabled = bEnable;
    self.m_pbtnEleventh.userInteractionEnabled = bEnable;
    self.m_pbtnTwelveth.userInteractionEnabled = bEnable;
    self.m_pbtnThirteenth.userInteractionEnabled = bEnable;
    self.m_pbtnFourteenth.userInteractionEnabled = bEnable;
}

- (void)SetButtonEnabledDeleted:(BOOL)bEnable
{
    // 各メニューボタン
    self.m_pbtnFirst.enabled = bEnable;
    self.m_pbtnSecond.enabled = bEnable;
    self.m_pbtnThird.enabled = bEnable;
    self.m_pbtnFourth.enabled = bEnable;
    self.m_pbtnFifth.enabled = bEnable;
    self.m_pbtnSixth.enabled = bEnable;
    self.m_pbtnSeventh.enabled = bEnable;
    self.m_pbtnEighth.enabled = bEnable;
    self.m_pbtnNinth.enabled = bEnable;
    self.m_pbtnTenth.enabled = bEnable;
    self.m_pbtnEleventh.enabled = bEnable;
    self.m_pbtnTwelveth.enabled = bEnable;
    self.m_pbtnThirteenth.enabled = bEnable;
    self.m_pbtnFourteenth.enabled = bEnable;
}

// 変数解放
- (void)ReleaseObject:(id)object
{
    if (object != nil)
    {
        object = nil;
    }
}

#pragma mark - alertCreate

/**
 * メッセージボックス表示（ボタン１つ、タグなし）
 */
- (void)CreateAllert:(NSString*)pstrTitle
             message:(NSString*)pstrMsg
            btnTitle:(NSString*)pstrBtnTitle
{
    //既に出ているアラートを消す
    [self dismissAlertView];
    
    SharpScanPrintAppDelegate* appDelegate = (SharpScanPrintAppDelegate*)[[UIApplication sharedApplication] delegate];
    // 処理実行フラグON
    appDelegate.IsRun = TRUE;
    
    [self makePictureAlert:nil message:pstrMsg cancelBtnTitle:pstrBtnTitle okBtnTitle:nil tag:0 showFlg:NO];

    [self showAlertOnMainThread];
}

/**
 * メッセージボックス表示（ボタン１つ、タグあり）
 */
- (void)CreateAllert:(NSString*)pstrTitle
             message:(NSString*)pstrMsg
            btnTitle:(NSString*)pstrBtnTitle
             withTag:(NSInteger)nTag
{
    //既に出ているアラートを消す
    [self dismissAlertView];
    
    SharpScanPrintAppDelegate* appDelegate = (SharpScanPrintAppDelegate*)[[UIApplication sharedApplication] delegate];
    // 処理実行フラグON
    appDelegate.IsRun = TRUE;
    
    [self makePictureAlert:nil message:pstrMsg cancelBtnTitle:pstrBtnTitle okBtnTitle:MSG_BUTTON_OK tag:nTag showFlg:NO];

    [self showAlertOnMainThread];
}

- (void)CreateAlert:(NSString*)pstrTitle
            message:(NSString*)pstrMsg cancelTitle:(NSString*)cancelTitle
            okTitle:(NSString*)okTitle withTag:(NSInteger)nTag
{
    //既に出ているアラートを消す
    [self dismissAlertView];
    
    SharpScanPrintAppDelegate* appDelegate = (SharpScanPrintAppDelegate*)[[UIApplication sharedApplication] delegate];
    // 処理実行フラグON
    appDelegate.IsRun = TRUE;
    
    [self makePictureAlert:pstrTitle message:pstrMsg cancelBtnTitle:cancelTitle okBtnTitle:okTitle tag:nTag showFlg:NO];
    [self showAlertOnMainThread];
}

/**
 * 処理中アラート表示（tagは固定、キャンセルボタンの有無選択可能）
 * @param pstrTitle タイトル
 * @param pstrMessage メッセージ
 * @param bCancel キャンセルボタンを付けるならYES
 */
- (void)CreateProgressAlert:(NSString *)pstrTitle
                    message:(NSString *)pstrMessage
                 withCancel:(BOOL)bCancel
{
    //既に出ているアラートを消す
    [self dismissAlertView];

    
	@autoreleasepool
    {
        
        SharpScanPrintAppDelegate* appDelegate = (SharpScanPrintAppDelegate*)[[UIApplication sharedApplication] delegate];
        // 処理実行フラグON
        appDelegate.IsRun = TRUE;
        
        if (bCancel)
        {//キャンセルボタンあり
            [self makePictureAlert:nil message:pstrMessage cancelBtnTitle:MSG_BUTTON_CANCEL okBtnTitle:nil tag:ALERT_TAG_PROGRESS_ALERT showFlg:NO];
        }
        else
        {//キャンセルボタンなし
            [self makePictureAlert:nil message:pstrMessage cancelBtnTitle:nil okBtnTitle:nil tag:1 showFlg:NO];
        }

        [self showAlertOnMainThread];
        
	}
}

/**
 * メッセージボックス表示（ボタン2つ、タグなし）
 */
- (void)CreateAllert:(NSString*)pstrTitle
             message:(NSString*)pstrMsg
            btnTitle:(NSString*)pstrBtnTitle
      cancelBtnTitle:(NSString*)pstrCanceBtnTitle
             withTag:(NSInteger)nTag
{
    //既に出ているアラートを消す
    [self dismissAlertView];
    
    SharpScanPrintAppDelegate* appDelegate = (SharpScanPrintAppDelegate*)[[UIApplication sharedApplication] delegate];
    // 処理実行フラグON
    appDelegate.IsRun = TRUE;
    
    [self makePictureAlert:nil message:pstrMsg cancelBtnTitle:pstrCanceBtnTitle okBtnTitle:pstrBtnTitle tag:nTag showFlg:NO];
    [self showAlertOnMainThread];
}

//-(void)dismissAlertView{
//    //既に出ているアラートを消す
//    if(m_palert)
//    {
//        DLog(@"dismissAlert : message = %@", m_palert.message);
//        
//        @synchronized (m_palert) {
//            if([NSThread isMainThread]){
//                [m_palert dismissWithClickedButtonIndex:0 animated:NO];
//                m_palert = nil;
//            }else{
//                // メインスレッドでアラートを閉じる処理をするが、同期的に処理を行いたいため、
//                // semaphoreで同期化しています。
//                dispatch_semaphore_t semaphore = dispatch_semaphore_create(0);
//                dispatch_async(dispatch_get_main_queue(), ^{
//                    [m_palert dismissWithClickedButtonIndex:0 animated:NO];
//                    m_palert = nil;
//                    dispatch_semaphore_signal(semaphore);
//                });
//                dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
//            }
//        }
//    }
//}
-(void)dismissAlertView{
    //既に出ているアラートを消す
    if(picture_alert)
    {
        DLog(@"dismissAlert : message = %@", picture_alert.message);
        
        @synchronized (picture_alert) {
            if([NSThread isMainThread]){
                [picture_alert dismissViewControllerAnimated:YES completion:^{
                    [self alertButtonDismiss:picture_alert tagIndex:picture_alert.tag buttonIndex:0];
                }];
                picture_alert = nil;
            }else{
                // メインスレッドでアラートを閉じる処理をするが、同期的に処理を行いたいため、
                // semaphoreで同期化しています。
                dispatch_semaphore_t semaphore = dispatch_semaphore_create(0);
                dispatch_async(dispatch_get_main_queue(), ^{
                    [picture_alert dismissViewControllerAnimated:YES completion:^{
                        [self alertButtonDismiss:picture_alert tagIndex:picture_alert.tag buttonIndex:0];
                    }];
                    picture_alert = nil;
                    dispatch_semaphore_signal(semaphore);
                });
                dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
            }
        }
    }
}

//-(void)showAlertOnMainThread
//{
//    if(m_palert){
//        
//        //[m_palert performSelectorOnMainThread:@selector(show) withObject:nil waitUntilDone:YES];
//        
//        if([NSThread isMainThread]){
//            [m_palert show];
//        }else{
//            dispatch_async(dispatch_get_main_queue(), ^{
//                [m_palert show];
//            });
//        }
//    }
//    else
//    {
//        DLog(@"表示したいアラートのインスタンスがありません");
//    }
//
//}
-(void)showAlertOnMainThread
{
    if(picture_alert){
        
        if([NSThread isMainThread]){
            // アラート表示処理
            [self presentViewController:picture_alert animated:YES completion:nil];
        }else{
            dispatch_async(dispatch_get_main_queue(), ^{
                // アラート表示処理
                [self presentViewController:picture_alert animated:YES completion:nil];
            });
        }
    }
    else
    {
        DLog(@"表示したいアラートのインスタンスがありません");
    }

}

-(void)alertButtonPushed:(UIAlertController *)alertController tagIndex:(NSInteger)tagIndex buttonIndex:(NSInteger)buttonIndex
{
    [self alertButtonClicked:alertController tagIndex:tagIndex buttonIndex:buttonIndex];
    [self alertButtonDismiss:alertController tagIndex:tagIndex buttonIndex:buttonIndex];
}

-(void)alertButtonClicked:(UIAlertController *)alertController tagIndex:(NSInteger)tagIndex buttonIndex:(NSInteger)buttonIndex
{
}

-(void)alertButtonDismiss:(UIAlertController *)alertController tagIndex:(NSInteger)tagIndex buttonIndex:(NSInteger)buttonIndex
{
    if (!m_bResult)
    {
        SharpScanPrintAppDelegate* appDelegate = (SharpScanPrintAppDelegate*)[[UIApplication sharedApplication] delegate];
        // 処理実行フラグOFF
        appDelegate.IsRun = FALSE;
    }
    m_bResult = TRUE;
}

#pragma mark -

-(void)showMemoryErrorPNG
{
    // エラーメッセージ表示
    [self makePictureAlert:nil message:MSG_IMAGE_PREVIEW_ERR cancelBtnTitle:MSG_BUTTON_OK okBtnTitle:nil tag:ALERT_TAG_PREVIEW_MEMORY_ERROR showFlg:YES];
}

- (BOOL)showOriginalViewerCheck:(NSString*)selFilePath
{
    if((self.PrintPictViewID == WEB_PRINT_VIEW || self.PrintPictViewID == EMAIL_PRINT_VIEW))
    {
        return YES;
    }
    
    NSArray *previewFilePaths = [GeneralFileUtility getPreviewFilePaths:selFilePath];
    if(previewFilePaths != nil)
    {
        // 自前ビューアでの表示
        DLog(@"%@", @"自前ビューアでの表示チェック3");

        arrThumbnails = previewFilePaths;
        totalPage = [arrThumbnails count];
        
        if(totalPage > 0)
        {
            return YES;
        }
    }
    
    return NO;
}

- (void)cancelAction {
    if(self.PrintPictViewID == PPV_PRINT_MAIL_ATTACHMENT_CELL){
        [TempAttachmentFileUtility deleteMailTmpDir];
    }
    [self.navigationController popViewControllerAnimated:NO];
}

// 複数印刷対応
- (void)closeBtnPushed:(NSNotification *)n {
    
    if([self isKindOfClass:[PrintPictViewController class]] || [self isKindOfClass:[MultiPrintPictViewController class]]) {
        self.m_isShoudRemakeMenuButton = YES;         // 再生成処理必要フラグ
    }
    
    [self dismissViewControllerAnimated:YES completion:nil];
}


// アラート表示
- (void)makePictureAlert:(NSString*)pstrTitle
                 message:(NSString*)pstrMsg
          cancelBtnTitle:(NSString*)cancelBtnTitle
              okBtnTitle:(NSString*)okBtnTitle
                     tag:(NSInteger)tag
                 showFlg:(BOOL)showFlg
{
    picture_alert = [ExAlertController alertControllerWithTitle:pstrTitle
                                                   message:pstrMsg
                                            preferredStyle:UIAlertControllerStyleAlert];
    picture_alert.tag = tag;
    
    // Cancel用のアクションを生成
    if (cancelBtnTitle != nil) {
        UIAlertAction *cancelAction =
        [UIAlertAction actionWithTitle:cancelBtnTitle
                                 style:UIAlertActionStyleCancel
                               handler:^(UIAlertAction * action) {
                                   
                                   // ボタンタップ時の処理
                                   [self alertButtonPushed:picture_alert tagIndex:tag buttonIndex:0];
                               }];
        // コントローラにアクションを追加
        [picture_alert addAction:cancelAction];
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
                                   [self alertButtonPushed:picture_alert tagIndex:tag buttonIndex:okIndex];
                               }];
        // コントローラにアクションを追加
        [picture_alert addAction:okAction];
    }
    
    if (showFlg) {
        // アラート表示処理
        [self presentViewController:picture_alert animated:YES completion:nil];
    }
}

// アラート表示
- (void) makeTmpExAlert:(NSString*)pstrTitle
                message:(NSString*)pstrMsg
         cancelBtnTitle:(NSString*)cancelBtnTitle
             okBtnTitle:(NSString*)okBtnTitle
                    tag:(NSInteger)tag
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
    
    // アラート表示処理
    [self presentViewController:tmpAlert animated:YES completion:nil];
}

@end
