
#import <CFNetwork/CFNetwork.h>
#import "PictureViewController_iPad.h"
#import "Define.h"
#import "SettingSelInfoViewController_iPad.h"
#import "SettingSelDeviceViewController_iPad.h"
#import "CommonManager.h"
#import <ImageIO/ImageIO.h>

#import "PickerViewController_iPad.h"
#import "CommonUtil.h"
#import "SharpScanPrintAppDelegate.h"
#import "RootViewController_iPad.h"
#import "WebPagePrintViewController_iPad.h"
#import "SelectMailViewController_iPad.h"
#import "PrintPictViewController_iPad.h"
#import "RemoteScanBeforePictViewController_iPad.h"

// 複数印刷対応
#import "SelectFileViewController_iPad.h"
#import "PrintSelectTypeViewController_iPad.h"
#import "SettingSelInfoViewController_iPad.h"

#include <mach/host_info.h>
#include <mach/mach_init.h>
#include <mach/mach_host.h>

#define PLBL_PAGE_NUM_TAG 10
#define PAGE_DEL_BUTTON_TAG 20

@implementation PictureViewController_iPad

@synthesize PictEditInfo = m_pdicEditInfo;
@synthesize SelFilePath = m_pstrFilePath;
@synthesize IsPhotoView = m_bPhotoView;
@synthesize IsAfterView = m_bAfterView;
@synthesize IsPrintPictView = m_bPrintPictView;
@synthesize IsSendExSitePictView = m_bSendExSitePictView;
@synthesize prevViewController;
@synthesize isMoveAttachmentMail;   // 添付ファイル一覧画面からの遷移か
@synthesize PrintPictViewID;        // 遷移元画面ID
@synthesize smViewController;
@synthesize smNavigationController;
@synthesize previewScrollViewManager;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
    }
    return self;
}

- (void)dealloc {
    if (nil != m_pPrintImageView) {
        m_pPrintImageView.image = nil;
        [self ReleaseObject:m_pPrintImageView];
    }
    [self ReleaseObject:self.m_pPreviewScrollView];
    if (nil != self.m_pPreviewWebView) {
        self.m_pPreviewWebView.delegate = nil;
        [self ReleaseObject:self.m_pPreviewWebView];
    }
    [self ReleaseObject:m_popOver];
    if (nil != m_pActivityIndicatorView) {
        m_pActivityIndicatorView = nil;
    }
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - View lifecycle
- (void)viewDidLoad {
	m_bFirstLoad = TRUE;
    [super viewDidLoad];
    
    // メニューのビューを指定
    m_pMenuView = self.view;
    
    self.view.frame = CGRectMake(0, 0, 703, 704);
}

- (void)viewWillLayoutSubviews
{
    [super viewWillLayoutSubviews];
    
    if (m_bOriginalViewer) {
        [previewScrollViewManager pageLoad:self.m_pPreviewScrollView];
    }
}

- (void)viewDidUnload {
    [super viewDidUnload];
    if (nil != m_pPrintImageView) {
        m_pPrintImageView.image = nil;
        [self ReleaseObject:m_pPrintImageView];
    }
    [self ReleaseObject:self.m_pPreviewScrollView];
    if (nil != self.m_pPreviewWebView) {
        self.m_pPreviewWebView.delegate = nil;
        [self ReleaseObject:self.m_pPreviewWebView];
    }
    [self ReleaseObject:m_popOver];
    
    if (nil != self.PictEditInfo) {
        self.PictEditInfo = nil;
    }
    if (nil != self.SelFilePath) {
        self.SelFilePath = nil;
    }
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    // 縦表示の時はメニューボタンを表示
    SharpScanPrintAppDelegate* pAppDelegate = (SharpScanPrintAppDelegate*)[[UIApplication sharedApplication] delegate];
    [pAppDelegate setPortraitMenuButton];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    //通知センターを取得
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getPickerValueAction:) name:@"Picker Value" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(closeBtnPushed:) name:ST_CLOSE_BUTTON_PUSHED object:nil];
    
    // ナビゲーションバー上ボタンのマルチタップを制御する
    for (UIView * view in self.navigationController.navigationBar.subviews) {
        if ([view isKindOfClass: [UIView class]]) {
            [view setExclusiveTouch:YES];
        }
    }
}

- (void)viewDidDisappear:(BOOL)animated {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
    [super viewDidDisappear:animated];
}

- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation {
    
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    [previewScrollViewManager adjustCurrentPage];
    return YES;
}

// 初期化関連
// 変数初期化
- (void)InitObject {
    // 変数初期化
    m_nSelPicker = PrvMenuIDNone;
    self.m_nSelPickerRow1 = 0;
    self.m_nSelPickerRow2 = 0;
    self.m_nSelPickerRow3 = 1;
    self.m_nSelPickerRow4 = 0;
    self.m_nSelPickerRow5 = 0;
    self.m_nSelPickerRow6 = 0;
    self.m_nSelPickerRow7 = 0;
    self.m_nSelPickerRow8 = 0;
    m_bPhotoView = FALSE;
    
    // スレッド
    m_bResult = TRUE;
    m_bThread = FALSE;
    m_bAbort = FALSE;
    m_pThread = nil;
}

// メインビュー初期化
- (void)InitView:(NSString*)pstrTitle menuBtnNum:(NSInteger)nMenuBtnNum hidesBackButton:(BOOL)bHidden hidesSettingButton:(BOOL)bSettingButtonHidden {
    [self InitView:pstrTitle menuBtnNum:nMenuBtnNum hidesBackButton:bHidden hidesSettingButton:bSettingButtonHidden setHiddenNoImage:NO];
    [self setNoImageHidden:YES];
}

// メインビュー初期化
- (void)InitView:(NSString*)pstrTitle menuBtnNum:(NSInteger)nMenuBtnNum hidesBackButton:(BOOL)bHidden hidesSettingButton:(BOOL)bSettingButtonHidden setHiddenNoImage:(BOOL)bSetHiddenNoImage {
    // メニュー表示するボタン数
    m_nMenuBtnNum = nMenuBtnNum;
    
    // ナビゲーションバー
    // タイトル設定
    self.navigationItem.title = pstrTitle;
    
    if(!bSettingButtonHidden) {
        // 設定ボタン追加
        UIBarButtonItem* btnSetting = [[UIBarButtonItem alloc] initWithTitle:S_BUTTON_SETTING style:UIBarButtonItemStylePlain target:self action:@selector(OnNavBarRightButton:)];
        self.navigationItem.rightBarButtonItem = btnSetting;
    }
    
    m_bButtonEnable = YES;
    
    // 戻るボタン表示切り替え
    self.navigationItem.hidesBackButton = bHidden;
    
    self.view.backgroundColor = BACKGROUND_COLOR;// TableViewに合わせた背景を設定
    if([[[UIDevice currentDevice] systemVersion] floatValue] >= 6.0 && [[[UIDevice currentDevice] systemVersion] floatValue] < 7.0 && UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) {// iOS6のiPhoneだけ
        UITableView *tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
        [self.view addSubview:tableView];
        [self.view sendSubviewToBack:tableView];
    }
    
    // NoImage文言設定
    m_pLblNoImage.text = S_LABEL_NO_IMAGE;
    if (bSetHiddenNoImage) {
        [self setNoImageHidden:m_pLblNoImage.hidden];
    }
}

// メニュー作成
// iPad用
- (void)CreateMenu:(NSInteger)nMenuBtnID btnName:(NSString*)pstrBtnName iconName:(NSString*)pstrIconName lblName:(NSString*)pstrLblName {
    // メニューボタンID不正
    if (m_nMenuBtnNum < nMenuBtnID) {
        return;
    }
    
    if ((nMenuBtnID < PrvMenuIDNone) || (nMenuBtnID >= PrvMenuIDMax)) {
        return;
    }
    
    // メニューボタン作成
    switch (nMenuBtnID) {
        case PrvMenuIDFirst:
            self.m_pbtnFirst = [self CreateMenuButton:nMenuBtnID btnName:pstrBtnName iconName:pstrIconName eventFunc:@selector(OnMenuFirstButton:)];
            break;
        case PrvMenuIDSecond:
            self.m_pbtnSecond = [self CreateMenuButton:nMenuBtnID btnName:pstrBtnName iconName:nil eventFunc:@selector(OnMenuSecondButton:)];
            m_pimgSecond = [self CreateMenuIcon:nMenuBtnID iconName:pstrIconName];
            m_plblSecond = [self CreateMenuLabel:nMenuBtnID lblName:pstrLblName];
            break;
        case PrvMenuIDThird:
            self.m_pbtnThird = [self CreateMenuButton:nMenuBtnID btnName:pstrBtnName iconName:nil eventFunc:@selector(OnMenuThirdButton:)];
            m_pimgThird = [self CreateMenuIcon:nMenuBtnID iconName:pstrIconName];
            m_plblThird = [self CreateMenuLabel:nMenuBtnID lblName:pstrLblName];
            break;
        case PrvMenuIDFourth:
            self.m_pbtnFourth = [self CreateMenuButton:nMenuBtnID btnName:pstrBtnName iconName:nil eventFunc:@selector(OnMenuFourthButton:)];
            m_pimgFourth = [self CreateMenuIcon:nMenuBtnID iconName:pstrIconName];
            m_plblFourth = [self CreateMenuLabel:nMenuBtnID lblName:pstrLblName];
            break;
        case PrvMenuIDFifth:
            self.m_pbtnFifth = [self CreateMenuButton:nMenuBtnID btnName:pstrBtnName iconName:nil eventFunc:@selector(OnMenuFifthButton:)];
            m_pimgFifth = [self CreateMenuIcon:nMenuBtnID iconName:pstrIconName];
            m_plblFifth = [self CreateMenuLabel:nMenuBtnID lblName:pstrLblName];
            break;
        case PrvMenuIDSixth:
            self.m_pbtnSixth = [self CreateMenuButton:nMenuBtnID btnName:pstrBtnName iconName:nil eventFunc:@selector(OnMenuSixthButton:)];
            m_pimgSixth = [self CreateMenuIcon:nMenuBtnID iconName:pstrIconName];
            m_plblSixth = [self CreateMenuLabel:nMenuBtnID lblName:pstrLblName];
            break;
        case PrvMenuIDSeventh:
            if([self isKindOfClass:[RemoteScanBeforePictViewController_iPad class]]){
                // リモートスキャン画面時
                self.m_pbtnSeventh = [self CreateMenuButton:nMenuBtnID btnName:pstrBtnName iconName:nil eventFunc:@selector(OnMenuSeventhButton:)];
                m_pimgSeventh = [self CreateMenuIcon:nMenuBtnID iconName:pstrIconName];
                m_plblSeventh = [self CreateMenuLabel:nMenuBtnID lblName:pstrLblName];
            } else {
                if (PrvMenuIDSeventh != m_nMenuBtnNum) {
                    self.m_pbtnSeventh = [self CreateMenuButton:nMenuBtnID btnName:pstrBtnName iconName:nil eventFunc:@selector(OnMenuSeventhButton:)];
                    m_pimgSeventh = [self CreateMenuIcon:nMenuBtnID iconName:pstrIconName];
                    m_plblSeventh = [self CreateMenuLabel:nMenuBtnID lblName:pstrLblName];
                } else {
                    self.m_pbtnSeventh = [self CreateMenuButton:nMenuBtnID btnName:pstrBtnName iconName:pstrIconName eventFunc:@selector(OnMenuSeventhButton:)];
                }
            }
            break;
        case PrvMenuIDEighth:
            if (PrvMenuIDEighth != m_nMenuBtnNum) {
                self.m_pbtnEighth = [self CreateMenuButton:nMenuBtnID btnName:pstrBtnName iconName:nil eventFunc:@selector(OnMenuEighthButton:)];
                m_pimgEighth = [self CreateMenuIcon:nMenuBtnID iconName:pstrIconName];
                m_plblEighth = [self CreateMenuLabel:nMenuBtnID lblName:pstrLblName];
            } else {
                self.m_pbtnEighth = [self CreateMenuButton:nMenuBtnID btnName:pstrBtnName iconName:pstrIconName eventFunc:@selector(OnMenuEighthButton:)];
            }
            break;
        case PrvMenuIDNinth:
            if (PrvMenuIDNinth != m_nMenuBtnNum) {
                self.m_pbtnNinth = [self CreateMenuButton:nMenuBtnID btnName:pstrBtnName iconName:nil eventFunc:@selector(OnMenuNinthButton:)];
                m_pimgNinth = [self CreateMenuIcon:nMenuBtnID iconName:pstrIconName];
                m_plblNinth = [self CreateMenuLabel:nMenuBtnID lblName:pstrLblName];
            } else {
                self.m_pbtnNinth = [self CreateMenuButton:nMenuBtnID btnName:pstrBtnName iconName:pstrIconName eventFunc:@selector(OnMenuNinthButton:)];
            }
            break;
        case PrvMenuIDTenth:
            if (PrvMenuIDTenth != m_nMenuBtnNum) {
                self.m_pbtnTenth = [self CreateMenuButton:nMenuBtnID btnName:pstrBtnName iconName:nil eventFunc:@selector(OnMenuTenthButton:)];
                m_pimgTenth = [self CreateMenuIcon:nMenuBtnID iconName:pstrIconName];
                m_plblTenth = [self CreateMenuLabel:nMenuBtnID lblName:pstrLblName];
            } else {
                self.m_pbtnTenth = [self CreateMenuButton:nMenuBtnID btnName:pstrBtnName iconName:pstrIconName eventFunc:@selector(OnMenuTenthButton:)];
            }
            break;
        case PrvMenuIDEleventh:
            if (PrvMenuIDEleventh != m_nMenuBtnNum) {
                self.m_pbtnEleventh = [self CreateMenuButton:nMenuBtnID btnName:pstrBtnName iconName:nil eventFunc:@selector(OnMenuEleventhButton:)];
                m_pimgEleventh = [self CreateMenuIcon:nMenuBtnID iconName:pstrIconName];
                m_plblEleventh = [self CreateMenuLabel:nMenuBtnID lblName:pstrLblName];
            } else {
                self.m_pbtnEleventh = [self CreateMenuButton:nMenuBtnID btnName:pstrBtnName iconName:pstrIconName eventFunc:@selector(OnMenuEleventhButton:)];
            }
            break;
            
        case PrvMenuIDTwelveth:
            if (PrvMenuIDTwelveth != m_nMenuBtnNum) {
                self.m_pbtnTwelveth = [self CreateMenuButton:nMenuBtnID btnName:pstrBtnName iconName:nil eventFunc:@selector(OnMenuTwelvethButton:)];
                m_pimgTwelveth = [self CreateMenuIcon:nMenuBtnID iconName:pstrIconName];
                m_plblTwelveth = [self CreateMenuLabel:nMenuBtnID lblName:pstrLblName];
            } else {
                self.m_pbtnTwelveth = [self CreateMenuButton:nMenuBtnID btnName:pstrBtnName iconName:pstrIconName eventFunc:@selector(OnMenuTwelvethButton:)];
            }
            break;
            
        case PrvMenuIDThirteenth:
            if (PrvMenuIDThirteenth != m_nMenuBtnNum) {
                self.m_pbtnThirteenth = [self CreateMenuButton:nMenuBtnID btnName:pstrBtnName iconName:nil eventFunc:@selector(OnMenuThirteenthButton:)];
                m_pimgThirteenth = [self CreateMenuIcon:nMenuBtnID iconName:pstrIconName];
                m_plblThirteenth = [self CreateMenuLabel:nMenuBtnID lblName:pstrLblName];
            } else {
                self.m_pbtnThirteenth = [self CreateMenuButton:nMenuBtnID btnName:pstrBtnName iconName:pstrIconName eventFunc:@selector(OnMenuThirteenthButton:)];
            }
            break;
            
        case PrvMenuIDFourteenth:
            self.m_pbtnFourteenth = [self CreateMenuButton:nMenuBtnID btnName:pstrBtnName iconName:pstrIconName eventFunc:@selector(OnMenuFourteenthButton:)];
            break;
        default:
            break;
    }
}

// メニューボタン作成
- (UIButton*)CreateMenuButton:(NSInteger)nMenuBtnID btnName:(NSString*)pstrBtnName iconName:(NSString*)pstrIconName eventFunc:(SEL)selEventFunc {
    // 表示位置
    CGFloat fRectX = self.view.frame.size.width - 185.5; // 518;
    CGFloat fRectY = self.view.frame.size.height - 81; // 623.0;
    // ボタンタイプ
    UIButton* pbtnMenu = [UIButton buttonWithType:UIButtonTypeCustom];
    [pbtnMenu setExclusiveTouch: YES];
     // ラベル設定
    pbtnMenu.titleEdgeInsets= UIEdgeInsetsMake(0.0, 20.0, 0.0, 20.0);

    // 回転時の位置調整
    pbtnMenu.autoresizingMask = UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleLeftMargin;

    // ボタン文字色
    UIColor *titleColor = [UIColor whiteColor];
    NSString* strButtonImageName = S_IMAGE_BUTTON_BLUE;
    if (nMenuBtnID > PrvMenuIDFirst) {
        fRectY = ((nMenuBtnID -1) * 35.0) + ((nMenuBtnID -2) * 60.0 + 35.0);
        if ([self isKindOfClass:[PrintPictViewController_iPad class]]) {
            if(nMenuBtnID != m_nMenuBtnNum) {
                titleColor = [UIColor blackColor];
                if (nMenuBtnID == PrvMenuIDSecond) {
                    // ラベル設定
                    pbtnMenu.titleEdgeInsets= UIEdgeInsetsMake(0.0, -10.0, 0.0, 30.0);
                }
                else {
                    // ラベル設定
                    pbtnMenu.titleEdgeInsets= UIEdgeInsetsMake(0.0, 10.0, 0.0, 30.0);
                }
                
                
                if (nMenuBtnID == PrvMenuIDFirst) {
                    // 回転時の位置調整
                    pbtnMenu.autoresizingMask = UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleLeftMargin;
                    fRectY = self.view.frame.size.height - 100; // 0
                }
                
                else {
                    // 回転時の位置調整
                    pbtnMenu.autoresizingMask = UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleLeftMargin;
                    strButtonImageName = S_IMAGE_BUTTON_GRAY;
                }
            }
            else {
                // 回転時の位置調整
                pbtnMenu.autoresizingMask = UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleLeftMargin;
                fRectY = self.view.frame.size.height - 159; //545;
            }
        } else if (nMenuBtnID != PrvMenuIDSeventh ||
                   [self isKindOfClass:[RemoteScanBeforePictViewController_iPad class]]) {
            
            // iPad用
            titleColor = [UIColor blackColor];
            if (nMenuBtnID == PrvMenuIDSecond) {
                // ラベル設定
                pbtnMenu.titleEdgeInsets= UIEdgeInsetsMake(0.0, -10.0, 0.0, 30.0);
            } else {
                // ラベル設定
                pbtnMenu.titleEdgeInsets= UIEdgeInsetsMake(0.0, 10.0, 0.0, 30.0);            
            }
            // 回転時の位置調整
            pbtnMenu.autoresizingMask = UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleLeftMargin;
            strButtonImageName = S_IMAGE_BUTTON_GRAY;
        } else {
            // 回転時の位置調整
            pbtnMenu.autoresizingMask = UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleLeftMargin;
        }
        
    }
    
    if (nMenuBtnID == PrvMenuIDFirst) {
        pbtnMenu.autoresizingMask = UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleLeftMargin;
        
    }

    if ([pstrBtnName isEqualToString:S_BUTTON_OTHER_APP]) {
        // ボタン文字色
        titleColor = [UIColor blackColor];
        strButtonImageName = S_IMAGE_BUTTON_GRAY;
        
    }
    pbtnMenu.adjustsImageWhenDisabled = NO;
    [pbtnMenu setTitle:pstrBtnName forState:UIControlStateNormal];                  // ボタン表示名称
    [pbtnMenu setTitleColor:titleColor forState:UIControlStateNormal];              // ボタンのフォント
    [pbtnMenu setTitleColor:[UIColor lightTextColor] forState:UIControlStateDisabled]; // ボタンのタイトルの文字色(非活性時)
    pbtnMenu.titleLabel.font = [UIFont systemFontOfSize:N_BUTTON_FONT_SIZE_DEFAULT];
    pbtnMenu.titleLabel.minimumScaleFactor = 7 / pbtnMenu.titleLabel.font.pointSize;                                    // ボタンフォント最小サイズ
    pbtnMenu.titleLabel.adjustsFontSizeToFitWidth = YES;                            // 名称を表示できない場合は縮小
    
    if (pstrIconName != nil) {
        pbtnMenu.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;  // ボタンAlign
        // アイコン設定
        [pbtnMenu setImage:[UIImage imageNamed:pstrIconName] forState:UIControlStateNormal];
        UIEdgeInsets insets = pbtnMenu.imageEdgeInsets;
        insets.left = 8.0;
        insets.top = 2.0;
        insets.bottom = 5.0;
        pbtnMenu.imageEdgeInsets = insets;
    }
    
    pbtnMenu.frame = CGRectMake(fRectX, fRectY, 180.0, 60.0);
    // 背景画像設定
    [pbtnMenu setBackgroundImage:[UIImage imageNamed:strButtonImageName] forState:UIControlStateNormal];
//    if ((nMenuBtnID > PrvMenuIDFirst && nMenuBtnID != m_nMenuBtnNum) || (nMenuBtnID == PrvMenuIDSecond) || (nMenuBtnID > PrvMenuIDFirst && [self isKindOfClass:[RemoteScanBeforePictViewController_iPad class]])) {
    if ((nMenuBtnID > PrvMenuIDFirst && nMenuBtnID != m_nMenuBtnNum) ||
        (nMenuBtnID == PrvMenuIDSecond) ||
        (nMenuBtnID > PrvMenuIDFirst && [self isKindOfClass:[RemoteScanBeforePictViewController_iPad class]])) {
        
        // 矢印アイコン設定
        [pbtnMenu setImage:[UIImage imageNamed:S_IMAGE_PICKER] forState:UIControlStateNormal]; 
        UIEdgeInsets insets = pbtnMenu.imageEdgeInsets;
        insets.left = 150.0;
        pbtnMenu.imageEdgeInsets = insets;
    }
    
    // ボタン押下イベント登録
    [pbtnMenu addTarget:self action:selEventFunc forControlEvents:UIControlEventTouchUpInside];
    // ボタンの活性状態設定
    [pbtnMenu setEnabled:m_bButtonEnable];
    [self.view addSubview:pbtnMenu];
    return pbtnMenu;
}

// メニューアイコン作成
- (UIImageView*)CreateMenuIcon:(NSInteger)nMenuBtnID iconName:(NSString*)pstrIconName {
    CGFloat fRectX = self.view.frame.size.width - 183.5; // 520;
    CGFloat fRectY = ((nMenuBtnID -2) * 95.0 + 35.0);
    CGRect rectImage = CGRectMake(fRectX, fRectY, 32.0, 32.0);
    // アイコン設定
    UIImageView* imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:pstrIconName]];
    imageView.frame = rectImage;
    imageView.autoresizingMask = UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleLeftMargin;
    [self.view addSubview:imageView];
    
    return imageView;
}

// メニューラベル作成
- (UILabel*)CreateMenuLabel:(NSInteger)nMenuBtnID lblName:(NSString*)pstrLblName {
    CGFloat fRectX = self.view.frame.size.width - 143.5; // 560;
    CGFloat fRectY = ((nMenuBtnID -2) * 95.0 + 35.0);
    CGRect rectLabel = CGRectMake(fRectX, fRectY, 140.0, 32.0);
    // ラベル設定
    UILabel* label = [[UILabel alloc] initWithFrame:rectLabel];
    label.backgroundColor = [UIColor clearColor];
    label.text = pstrLblName;
    label.autoresizingMask = UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin;
    label.adjustsFontSizeToFitWidth = YES;
    label.minimumScaleFactor = 7 / label.font.pointSize;

    [self.view addSubview:label];
    
    return label;
}

- (void)setNoImageHidden:(BOOL)bHidden {
    m_pLblNoImage.hidden = bHidden;
    m_pImgViewNoImage.hidden = bHidden;
}

// スレッド
// 実行スレッド
- (void)ActionThread {
}

// スレッドの開始
- (void)StartThread {
    SharpScanPrintAppDelegate* appDelegate = (SharpScanPrintAppDelegate*)[[UIApplication sharedApplication] delegate];
    while (appDelegate.IsPreview) {
    }
    appDelegate.IsPreview = TRUE;

    // アクティビティインジケータを作成(WebViewのCenter位置)
	m_pActivityIndicatorView = [[UIActivityIndicatorView alloc]initWithFrame: CGRectMake(256.5, 339.5, 30.0, 30.0)]; //iPad用
	m_pActivityIndicatorView.activityIndicatorViewStyle = UIActivityIndicatorViewStyleGray;
    m_pActivityIndicatorView.autoresizingMask = UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin;
    [self.view addSubview:m_pActivityIndicatorView];
    
    // インジケータ アニメーションスタート
	[m_pActivityIndicatorView startAnimating];

    // 戻るボタン無効
    [self.navigationItem.backBarButtonItem setEnabled:false];
    
	//スレッド開始処理
	m_pThread = [[NSThread alloc] initWithTarget: self selector: @selector(ActionThread) object:nil];
	
	[[NSNotificationCenter defaultCenter] addObserver:self selector: @selector(ThreadStopNotify) name:NSThreadWillExitNotification object:m_pThread];
    
	//スレッドフラグをオンに設定
	m_bThread = TRUE;
	
	//スレッド開始
	[m_pThread start];
}

// スレッド停止
- (void)StopThread {
    if (m_bThread) {
		// 中断フラグをオンに設定
		m_bAbort = TRUE;
		while (m_bThread) {
			[NSThread sleepUntilDate: [NSDate dateWithTimeIntervalSinceNow: 0.1]];
		}
		m_bAbort = FALSE;
	}
}

// スレッド終了通知
- (void)ThreadStopNotify {
	if (nil != m_pThread) {
		m_pThread = nil;
	}
    
	//スレッドフラグOFF
	m_bThread = FALSE;
    
    SharpScanPrintAppDelegate* appDelegate = (SharpScanPrintAppDelegate*)[[UIApplication sharedApplication] delegate];
    appDelegate.IsPreview = FALSE;
}

//// ファイル表示
//- (void)ShowFile:(NSString*)pstrFileResource fileType:(NSString*)pstrFileType {
//    if (pstrFileResource != nil) {
//        self.m_pPreviewWebView.hidden = NO;
//        self.m_pPreviewScrollView.hidden = YES;
//
//        self.m_pPreviewWebView.delegate = self;
//        self.m_pPreviewWebView.scalesPageToFit = YES;
//        self.m_pPreviewWebView.contentMode = UIViewContentModeScaleAspectFit;
//        // ファイル名とファイルの種類を設定
//        NSString *pstrPath = [[NSBundle mainBundle]pathForResource:pstrFileResource ofType:pstrFileType];
//        // URL設定
//        NSURL *url = [NSURL fileURLWithPath:pstrPath];
//        
//        // リクエスト作成
//        NSURLRequest* req = [NSURLRequest requestWithURL:url];
//        // リクエスト開始
//        [self.m_pPreviewWebView loadRequest:req];
//    } else {
//        // エラー処理
//        [self ShowFileError];
//    }
//}

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
        if (self.PrintPictViewID == PPV_PRINT_MAIL_ATTACHMENT_CELL){
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
//        // エラー処理
//        [self ShowFileError];
    }
}

/*
// ファイル表示(フルパス指定)
- (void)ShowFile:(NSString*)pstrFilePath {
    if (pstrFilePath != nil) {
        // 自前ビューアで表示するかのチェック
        m_bOriginalViewer = FALSE;
        totalPage = 0;
        
        CommonManager *commanager = [[CommonManager alloc]init];
        if ([CommonUtil pngExtensionCheck:pstrFilePath] && ![commanager existsCacheDirByScanFilePath:pstrFilePath]) {
            // PNG形式のときはキャッシュの再作成を試みる
            [commanager createCacheFile:[pstrFilePath stringByDeletingLastPathComponent] filename:[pstrFilePath lastPathComponent]];
        }
        
        if ([commanager existsCacheDirByScanFilePath:pstrFilePath]) {
            // スリープ可能状態に戻す
            [UIApplication sharedApplication].idleTimerDisabled = NO;

            // 自前ビューアでの表示
            DLog(@"%@", @"自前ビューアでの表示チェック");
            
            cacheDirPath = [CommonUtil GetCacheDirByScanFilePath:pstrFilePath];
            
            NSFileManager *localFileManager	= [NSFileManager defaultManager];
            arrThumbnails = [localFileManager contentsOfDirectoryAtPath:cacheDirPath error:NULL];
            arrThumbnails = [arrThumbnails filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"pathExtension IN %@ or pathExtension IN %@ or pathExtension IN %@ or pathExtension IN %@", @"jpeg", @"JPG", @"jpg", @"JPEG"]];
            
            NSMutableArray* arr = [NSMutableArray arrayWithArray:arrThumbnails];
            for (int i = 0; i < [arr count]; i++) {
                [arr replaceObjectAtIndex:i withObject:[cacheDirPath stringByAppendingPathComponent:[arr objectAtIndex:i]]];
            }
            arrThumbnails = arr;
            totalPage = [arrThumbnails count];
            
            if (totalPage > 0) {
                m_bOriginalViewer = TRUE;
            }
        }else if (self.PrintPictViewID == PPV_PRINT_MAIL_ATTACHMENT_CELL){
            if (![commanager existsCacheDirByScanFilePath:pstrFilePath]) {
                [commanager createCacheFile:[pstrFilePath stringByDeletingLastPathComponent] filename:[pstrFilePath lastPathComponent]];
            }
            
            // スリープ可能状態に戻す
            [UIApplication sharedApplication].idleTimerDisabled = NO;
            
            // 自前ビューアでの表示
            DLog(@"%@", @"自前ビューアでの表示チェック1");
            
            cacheDirPath = [CommonUtil GetCacheDirByScanFilePath:pstrFilePath];
            
            NSFileManager *localFileManager	= [NSFileManager defaultManager];
            arrThumbnails = [localFileManager contentsOfDirectoryAtPath:cacheDirPath error:NULL];
            arrThumbnails = [arrThumbnails filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"pathExtension IN %@ or pathExtension IN %@ or pathExtension IN %@ or pathExtension IN %@", @"jpeg", @"JPG", @"jpg", @"JPEG"]];
            NSMutableArray* arr = [NSMutableArray arrayWithArray:arrThumbnails];
            for(int i = 0; i < [arr count]; i++)
            {
                [arr replaceObjectAtIndex:i withObject:[cacheDirPath stringByAppendingPathComponent:[arr objectAtIndex:i]]];
            }
            arrThumbnails = arr;
            
            totalPage = [arrThumbnails count];
            
            if(totalPage > 0)
            {
                m_bOriginalViewer = TRUE;
            }
        }
        
        // 自前ビューア表示判定（Web,Emailは無条件で自前ビューア）
        if (m_bOriginalViewer || (self.PrintPictViewID == WEB_PRINT_VIEW || self.PrintPictViewID == EMAIL_PRINT_VIEW)) {
            // 自前ビューアでの表示
            [self performSelectorOnMainThread:@selector(ShowFileInOriginalView:) withObject:pstrFilePath waitUntilDone:YES];
        } else {
            // デフォルトビューアでの表示
            m_bOriginalViewer = FALSE;
            
            if ([CommonUtil jpegExtensionCheck:pstrFilePath] || [CommonUtil tiffExtensionCheck:pstrFilePath] || [CommonUtil pngExtensionCheck:pstrFilePath]) {
                [self ShowFileInScrollView:pstrFilePath];
            } else {
                [self ShowFileInWebView:pstrFilePath];
            }
        }
    } else {
        // エラー処理
        [self ShowFileError];
    }
}
*/

// ファイル表示(フルパス指定)
// Web,Emailファイルを追加時
- (void)ShowFileUpdate:(NSString*)pstrFilePath {
    if (pstrFilePath != nil) {
        // 自前ビューアで表示するかのチェック
        m_bOriginalViewer = FALSE;
        totalPage = 0;
        
        NSArray *previewFilePaths = [GeneralFileUtility getPreviewFilePaths:pstrFilePath];
        if(previewFilePaths != nil){
            // 自前ビューアでの表示
            DLog(@"%@", @"自前ビューアでの表示チェック");
            
            arrThumbnails = previewFilePaths;

            
            totalPage = [arrThumbnails count];
            
            if(totalPage > 0) {
                m_bOriginalViewer = TRUE;
            }
        }
        // 自前ビューアでの表示
        [self performSelectorOnMainThread:@selector(ShowFileInOriginalViewUpdate) withObject:nil waitUntilDone:YES];
    } else {
        // エラー処理
        [self ShowFileError];
    }
}

// 自前ビューアでのファイル表示（フルパス指定）
- (void)ShowFileInOriginalView:pstrFilePath {
    // WebView非表示、ScrollView表示
    self.m_pPreviewWebView.hidden = YES;
    self.m_pPreviewScrollView.hidden = NO;
    
    // ページ追加ボタン切り替え処理
    if (self.PrintPictViewID != WEB_PRINT_VIEW && self.PrintPictViewID != EMAIL_PRINT_VIEW) {
        [self.m_pBtnRotateImage removeFromSuperview];
        [self.m_pBtnPageAddImage removeFromSuperview];
        self.m_pBtnRotateImage = nil;
        self.m_pBtnPageAddImage = nil;
        
        // 回転ボタン追加
        CGRect rectButton = CGRectMake(self.m_pPreviewScrollView.frame.origin.x + self.m_pPreviewScrollView.frame.size.width - 75, 50, 50, 50);
        self.m_pBtnRotateImage = [[UIButton alloc]initWithFrame:rectButton];
        [self.m_pBtnRotateImage setBackgroundImage:[UIImage imageNamed:S_ICON_PREVIEWROTATE] forState:UIControlStateNormal];
        self.m_pBtnRotateImage.autoresizingMask = UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleLeftMargin;
        [self.m_pBtnRotateImage addTarget:self action:@selector(OnClickRotateButton:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:self.m_pBtnRotateImage];
        
        if(self.PrintPictViewID != PPV_OTHER)
        {
            // ページ追加ボタン追加
            CGRect pageAddButton = CGRectMake(self.m_pPreviewScrollView.frame.origin.x + self.m_pPreviewScrollView.frame.size.width - 75, 120, 50, 50);
            self.m_pBtnPageAddImage = [[UIButton alloc]initWithFrame:pageAddButton];
            //*TODO: ページ追加ボタンのアイコン修正
            [self.m_pBtnPageAddImage setBackgroundImage:[UIImage imageNamed:S_ICON_ADDPAGE] forState:UIControlStateNormal];
            self.m_pBtnPageAddImage.autoresizingMask = UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleLeftMargin;
            [self.m_pBtnPageAddImage addTarget:self action:@selector(OnClickPageAddButton:) forControlEvents:UIControlEventTouchUpInside];
            [self.view addSubview:self.m_pBtnPageAddImage];
        }

        
        
    } else {
        // ページ追加ボタン追加
        CGRect pageAddButton = CGRectMake(self.m_pPreviewScrollView.frame.origin.x + self.m_pPreviewScrollView.frame.size.width - 75, 50, 50, 50);
        UIButton *m_pBtnPageAddImage = [[UIButton alloc]initWithFrame:pageAddButton];
        //*TODO: ページ追加ボタンのアイコン修正
        [m_pBtnPageAddImage setBackgroundImage:[UIImage imageNamed:S_ICON_ADDPAGE] forState:UIControlStateNormal];
        m_pBtnPageAddImage.autoresizingMask = UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin;
        [m_pBtnPageAddImage addTarget:self action:@selector(OnClickPageAddButton:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:m_pBtnPageAddImage];
        
        // ページ削除ボタン追加
        CGRect pageDelButton = CGRectMake(self.m_pPreviewScrollView.frame.origin.x + self.m_pPreviewScrollView.frame.size.width - 75, 120, 50, 50);
        UIButton *m_pBtnPageDelImage = [[UIButton alloc]initWithFrame:pageDelButton];
        //*TODO: ページ削除ボタンのアイコン修正
        m_pBtnPageDelImage.tag = PAGE_DEL_BUTTON_TAG;
        m_pBtnPageDelImage.alpha = 1;
        [m_pBtnPageDelImage setBackgroundImage:[UIImage imageNamed:S_ICON_DELPAGE] forState:UIControlStateNormal];
        m_pBtnPageDelImage.autoresizingMask = UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin;
        [m_pBtnPageDelImage addTarget:self action:@selector(OnClickPageDelButton:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:m_pBtnPageDelImage];
    }
    
    previewScrollViewManager = [[PreviewScrollViewManager alloc] initWithPicturePaths:arrThumbnails ScrollView:self.m_pPreviewScrollView];
    self.m_pPreviewScrollView = previewScrollViewManager.m_pPreviewScrollView;
    
    // 追加の前に古いラベルを削除
    UIView *labelView = [self.view viewWithTag:PLBL_PAGE_NUM_TAG];
    [labelView removeFromSuperview];
    
    previewScrollViewManager.m_plblPageNum.tag = PLBL_PAGE_NUM_TAG;
    
    [previewScrollViewManager.m_plblPageNum setFrame:CGRectMake(15, 50, 80, 40)];   // iPad版は位置をずらす
    //[previewScrollViewManager.m_plblPageNum setFrame:CGRectMake(15, 50, 80, 40)];   // iPad版は位置をずらす
    [self.view addSubview:previewScrollViewManager.m_plblPageNum];
    
    m_bFinLoad = TRUE;
    
    //アニメーションストップ
    [m_pActivityIndicatorView stopAnimating];
    
    m_bResult = TRUE;
}

// 自前ビューアでのファイル表示（フルパス指定）
// Web,Email追加ファイル表示画面を更新
- (void)ShowFileInOriginalViewUpdate {
    // WebView非表示、ScrollView表示
    self.m_pPreviewWebView.hidden = YES;
    self.m_pPreviewScrollView.hidden = YES;
    self.m_pPreviewScrollView.scrollEnabled = YES;
    // NoImage
    [self setNoImageHidden:YES];
    
    if (!arrThumbnails || [arrThumbnails count] == 0) {
        self.m_pPreviewScrollView.hidden = NO;
        // NoImage表示
        [self setNoImageHidden:NO];
    }
    
    previewScrollViewManager = [[PreviewScrollViewManager alloc] initWithPicturePaths:arrThumbnails ScrollView:self.m_pPreviewScrollView];
    self.m_pPreviewScrollView = previewScrollViewManager.m_pPreviewScrollView;
    
    // 追加の前に古いラベルを削除
    UIView *labelView = [self.view viewWithTag:PLBL_PAGE_NUM_TAG];
    [labelView removeFromSuperview];
    
    previewScrollViewManager.m_plblPageNum.tag = PLBL_PAGE_NUM_TAG;
    [self.view addSubview:previewScrollViewManager.m_plblPageNum];
    
    m_bFinLoad = TRUE;
    
    //アニメーションストップ
    [m_pActivityIndicatorView stopAnimating];
    
    m_bResult = TRUE;
}

- (void)OnClickRotateButton:(id)sender {
    [previewScrollViewManager rotate];
}

// 複数印刷対応_iPad
- (void)elcImagePickerController:(ELCImagePickerController *)picker didFinishPickingMediaWithInfo:(NSArray *)info {
    [self dismissViewControllerAnimated:YES completion:nil];
    DLog(@"info = %@",info);
    [self.multiPrintPictTempArray removeAllObjects];
    if(info){
        [self.multiPrintPictTempArray addObjectsFromArray:info];
    }
    NSNotification *n = [NSNotification notificationWithName:NK_PICT_ENTER_BUTTON_PUSHED object:self.multiPrintPictTempArray];
    NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
    [nc postNotification:n];
}

// 複数印刷対応_iPad
- (void)elcImagePickerControllerDidCancel:(ELCImagePickerController *)picker {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)OnClickPageAddButton:(id)sender {
    
    // 通信中は処理しない
    if (self.isDuringCommProcess) {
        return;
    }

    if (self.PrintPictViewID == WEB_PRINT_VIEW) {
        WebPagePrintViewController_iPad* pWebPagePrintViewController = [[WebPagePrintViewController_iPad alloc] init];
        pWebPagePrintViewController.delegate = self;
        
        // モーダル表示
        UINavigationController *navigationController = [[UINavigationController alloc]initWithRootViewController:pWebPagePrintViewController];
        navigationController.navigationBar.barStyle = NAVIGATION_BARSTYLE;
        [navigationController setModalPresentationStyle:UIModalPresentationPageSheet];
        [self presentViewController:navigationController animated:YES completion:nil];

    } else if (self.PrintPictViewID == EMAIL_PRINT_VIEW) {
        if (self.smNavigationController == nil) {
            self.smViewController = [[SelectMailViewController_iPad alloc] init];
            
            [self.smViewController setPrevViewID: PV_PRINT_SELECT_FILE_CELL];
            self.smViewController.bRootClassShow = YES;
            self.smViewController.nFolderCount = 1;
            self.smViewController.delegate = self;
            
            // モーダル表示
            self.smNavigationController = [[UINavigationController alloc]initWithRootViewController:self.smViewController];
            self.smNavigationController.navigationBar.barStyle = NAVIGATION_BARSTYLE;
            [self.smNavigationController setModalPresentationStyle:UIModalPresentationPageSheet];
            [self presentViewController:self.smNavigationController animated:YES completion:nil];
        } else {
            // モーダル表示
            [self presentViewController:self.smNavigationController animated:YES completion:nil];
        }
    } else if (self.PrintPictViewID == PPV_PRINT_SELECT_FILE_CELL) {
        // 複数印刷対応_iPad
        SelectFileViewController_iPad *pViewController = [[SelectFileViewController_iPad alloc] init];
        pViewController.PrevViewID = PV_PRINT_SELECT_FILE_CELL;
        UINavigationController *nc = [[UINavigationController alloc]initWithRootViewController:pViewController];
        nc.modalPresentationStyle = UIModalPresentationPageSheet;
        [self presentViewController:nc animated:YES completion:nil];
    }else if (self.PrintPictViewID == PPV_PRINT_SELECT_PICTURE_CELL) {
        // 複数印刷対応_iPad
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
    }else if (self.PrintPictViewID == PPV_PRINT_MAIL_ATTACHMENT_CELL) {
        // 最後に選択したメールの添付ファイル一覧をモーダル表示
        AttachmentMailViewController_iPad* pViewController = nil;
        
        pViewController = [[AttachmentMailViewController_iPad alloc] init];
        pViewController.delegate = self;
        self.smNavigationController = [[UINavigationController alloc]initWithRootViewController:pViewController];
        self.smNavigationController.navigationBar.barStyle = NAVIGATION_BARSTYLE;
        [self.smNavigationController setModalPresentationStyle:UIModalPresentationPageSheet];
        [self presentViewController:self.smNavigationController animated:YES completion:nil];
        
    }
}

- (void)OnClickPageDelButton:(id)sender {
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
            if(self.PrintPictViewID == EMAIL_PRINT_VIEW && self.mailFormtArray > 0){
                //もとの状態には戻さない [self.mailFormtArray removeObject:[self.mailFormtArray lastObject]];
            }
            //リストから削除
            NSMutableArray* arr = [arrThumbnails mutableCopy];
            [arr removeObject:[arr lastObject]];
            arrThumbnails = [arr copy];
            
            totalPage = [arrThumbnails count];
            
            m_bOriginalViewer = (totalPage > 0);
            
            // 自前ビューアでの表示
            [self performSelectorOnMainThread:@selector(ShowFileInOriginalViewUpdate) withObject:nil waitUntilDone:YES];
        } else {
            // 削除に失敗した場合
            [self makeTmpExAlert:nil message:MSG_DEL_ERR cancelBtnTitle:nil okBtnTitle:MSG_BUTTON_OK tag:0];
        }
        if ([arrThumbnails count] == 0) {
            UIView *delBtn = [self.view viewWithTag:PAGE_DEL_BUTTON_TAG];
            [UIView animateWithDuration:0.3 animations:^{
                delBtn.alpha = 0;
            }];
            // ボタンの活性状態を変更する
            [self SetButtonEnabled:NO];
        }
    }
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
}

// WebVeiwへのファイル表示(フルパス指定)
- (void)ShowFileInWebView:(NSString*)pstrFilePath {
    BOOL isOffice = [CommonUtil officeExtensionCheck:pstrFilePath];
    
    CommonManager *commanager = [[CommonManager alloc]init];
    NSInteger iCheckPDFSize = [commanager checkPdfSize:pstrFilePath ];

    // 読み込みできない場合
    if (!isOffice && iCheckPDFSize == CHK_PDF_NO_VIEW_FILE) {
        SharpScanPrintAppDelegate* appDelegate = (SharpScanPrintAppDelegate*)[[UIApplication sharedApplication] delegate];
        // 処理実行フラグON
        appDelegate.IsRun = TRUE;
        
        // エラーメッセージ切り替え
        NSString* errMsg = MSG_NO_VIEW_FILE;
        if (self.IsAfterView) {
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
        
        self.m_pPreviewWebView.hidden = YES;
        self.m_pPreviewScrollView.hidden = NO;
        
        m_bFinLoad = TRUE;
        
        //アニメーションストップ
        [m_pActivityIndicatorView stopAnimating];
        return;
    }
  
    // 暗号化ファイルの場合
    m_bEncryptedPdf = FALSE;
    if (!isOffice && iCheckPDFSize == CHK_PDF_ENCRYPTED_FILE) {
        // エラーメッセージ切り替え
        NSString* errMsg;
        
        if (m_bSendExSitePictView) {
            errMsg = [NSString stringWithFormat:MSG_PDF_ENCRYPTION_ERR, MSG_SEND_APPLICATION_IPAD];
        } else {
            errMsg = [NSString stringWithFormat:MSG_PDF_ENCRYPTION_ERR, MSG_OTHER_APP_CHECK];
        }
        SharpScanPrintAppDelegate* appDelegate = (SharpScanPrintAppDelegate*)[[UIApplication sharedApplication] delegate];
        
        // 処理実行フラグON
        appDelegate.IsRun = TRUE;
        
        BOOL tmpShowFlg = YES;
        // 外部連携の場合は、通信処理終了後にメッセージを表示する
        if ([self isKindOfClass:NSClassFromString(@"PrintPictViewController_iPad")]) {
            
            PrintPictViewController_iPad *ppvc = (PrintPictViewController_iPad*)self;
            // 外部連携判定
            if (ppvc.IsSite) {
                tmpShowFlg = NO;
            }
        }
        
        // エラーメッセージ表示
        [self makePictureAlert:nil message:errMsg cancelBtnTitle:MSG_BUTTON_OK okBtnTitle:nil tag:0 showFlg:tmpShowFlg];
        
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
        
        self.m_pPreviewWebView.hidden = YES;
        self.m_pPreviewScrollView.hidden = NO;
        
        m_bFinLoad = TRUE;
        
        //アニメーションストップ
        [m_pActivityIndicatorView stopAnimating];
        
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
    if (iCheckPDFSize == CHK_PDF_OVER_1PAGE_MAXSIZE || iCheckPDFSize == CHK_PDF_OVER_ACTIVEMEMORY_MAXSIZE || isOffice) {
        // メッセージ切り替え
        NSString* errorMessage = MSG_IMAGE_PREVIEW_ERR;
        if (iCheckPDFSize == CHK_PDF_OVER_1PAGE_MAXSIZE) {
            errorMessage = [NSString stringWithFormat:MSG_IMAGE_PREVIEW_ERR_PDF, N_NUM_PDF_1PAGE_MAXSIZE];
        } else if(isOffice) {
            if(m_bSendExSitePictView) {
                errorMessage = [NSString stringWithFormat:MSG_PREVIEW_INCOMPATIBLE_ERR, MSG_SEND_APPLICATION_IPAD];
            } else {
                errorMessage = [NSString stringWithFormat:MSG_PREVIEW_INCOMPATIBLE_ERR, MSG_OTHER_APP_CHECK];
            }
        }
        
        SharpScanPrintAppDelegate* appDelegate = (SharpScanPrintAppDelegate*)[[UIApplication sharedApplication] delegate];
        
        // 処理実行フラグON
        appDelegate.IsRun = TRUE;
        
        BOOL tmpShowFlg = YES;
        // 外部連携の場合は、通信処理終了後にメッセージを表示する
        if ([self isKindOfClass:NSClassFromString(@"PrintPictViewController_iPad")]) {
            
            PrintPictViewController_iPad *ppvc = (PrintPictViewController_iPad*)self;
            // 外部連携判定
            if (ppvc.IsSite) {
                tmpShowFlg = NO;
            }
        }
        // エラーメッセージ表示
        [self makePictureAlert:nil message:errorMessage cancelBtnTitle:MSG_BUTTON_OK okBtnTitle:nil tag:0 showFlg:tmpShowFlg];
        m_bResult = FALSE;
                
        self.m_pPreviewWebView.hidden = YES;
        self.m_pPreviewScrollView.hidden = NO;
        
        m_bFinLoad = TRUE;
        
        //アニメーションストップ
        [m_pActivityIndicatorView stopAnimating];
    } else {
        // WebView表示、ScrollView非表示
        self.m_pPreviewWebView.hidden = NO;
        self.m_pPreviewScrollView.hidden = YES;
        
        self.m_pPreviewWebView.scalesPageToFit = YES;
        self.m_pPreviewWebView.delegate = self;
        self.m_pPreviewWebView.contentMode = UIViewContentModeScaleAspectFit;
        
        // URL設定
        NSURL *url = [NSURL fileURLWithPath:pstrFilePath];
        // リクエスト作成
        NSURLRequest* req = [NSURLRequest requestWithURL:url];
        
        if([[[UIDevice currentDevice]systemVersion]floatValue] < 8){ //iOS8以外ではloadRequestを使用
            [self.m_pPreviewWebView loadRequest:req];
        } else if([[[UIDevice currentDevice]systemVersion]floatValue] >= 8){ //iOS8ではloadDataを使用
            NSData *pdfData = [[NSData alloc] initWithContentsOfURL:url];
            [self.m_pPreviewWebView loadData:pdfData MIMEType:@"application/pdf" textEncodingName:@"utf-8" baseURL:[NSURL URLWithString:@"http://"]];
            
        }
    }
}

// ScrollViewへのファイル表示(フルパス指定)
- (void)ShowFileInScrollView:(NSString*)pstrFilePath {
    if (![CommonUtil isExistsFreeMemoryJpegConvert:pstrFilePath]) {
        m_bFinLoad = TRUE;
        
        //アニメーションストップ
        [m_pActivityIndicatorView stopAnimating];
        
        SharpScanPrintAppDelegate* appDelegate = (SharpScanPrintAppDelegate*)[[UIApplication sharedApplication] delegate];
        // 処理実行フラグON
        appDelegate.IsRun = TRUE;
        
        // エラーメッセージ表示
        [self showMemoryErrorPNG];
        m_bResult = FALSE;
        
        return;
    }

    // 画像ファイル取得
    CGDataProviderRef dataProvider = CGDataProviderCreateWithFilename([pstrFilePath UTF8String]);
    UIImage* img = [CommonUtil GetUIImageByDataProvider:dataProvider maxPixelSize:1024];
    CGDataProviderRelease(dataProvider);
    
    // 画像表示
    [self ShowImageInScrollView:img showMessage:TRUE];
}

- (void)ShowImageInScrollView:(UIImage*)img showMessage:(BOOL)showAlert {
    // WebView非表示、ScrollView表示
    self.m_pPreviewWebView.hidden = YES;
    self.m_pPreviewScrollView.hidden = NO;
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
    if ((freeCount * N_NUM_PDF_ACTIVEMEMORY_MAXSIZE) <= imgByte) {
        // エラーメッセージ表示
        if (showAlert) {
            SharpScanPrintAppDelegate* appDelegate = (SharpScanPrintAppDelegate*)[[UIApplication sharedApplication] delegate];
            
            // 処理実行フラグON
            appDelegate.IsRun = TRUE;
            
            // エラーメッセージ表示
            [self makePictureAlert:nil message:MSG_IMAGE_PREVIEW_ERR cancelBtnTitle:MSG_BUTTON_OK okBtnTitle:nil tag:0 showFlg:YES];
            m_bResult = FALSE;
        }
    } else {
        // 縦横の縮小倍率を比較して小さい方の倍率で縮小
        CGFloat magnificationW = (505 * 1.5) / img.size.width;
        CGFloat magnificationH = (647 * 1.5) / img.size.height;
        if (magnificationW < 1 || magnificationH < 1) {
            // 縮小倍率取得
            CGFloat magnification = magnificationW;
            if (magnificationH < magnificationW) {
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
        } else {
            // 画像をImageViewに設定
            m_pPrintImageView.image = img;
        }
    }

    self.m_pPreviewScrollView.pagingEnabled = NO;                            // ページ単位スクロール
    self.m_pPreviewScrollView.contentSize = m_pPrintImageView.frame.size;    // スクロール可能サイズ
    self.m_pPreviewScrollView.showsHorizontalScrollIndicator = YES;          // 横スクロールバー表示
    self.m_pPreviewScrollView.showsVerticalScrollIndicator = YES;            // 縦スクロールバー表示
    [self.m_pPreviewScrollView setMinimumZoomScale:1.0];                     // 縮小率の限界値
    [self.m_pPreviewScrollView setMaximumZoomScale:5.0];                     // 拡大率の限界値
    self.m_pPreviewScrollView.delegate = self;                               // デリゲート
    [self.m_pPreviewScrollView addSubview:m_pPrintImageView];
    m_bFinLoad = TRUE;
    
    //アニメーションストップ
	[m_pActivityIndicatorView stopAnimating];
}

// ファイル表示失敗時処理
- (void)ShowFileError {
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
- (void)webViewDidFinishLoad:(UIWebView *)webView {
    self.m_pPreviewWebView.backgroundColor = [UIColor blackColor];
    m_bFinLoad = TRUE;
    
    //アニメーションストップ
	[m_pActivityIndicatorView stopAnimating];
}

// ファイル読み込み失敗
- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error {
    // エラー処理
    [self ShowFileError];
}

// ScrollViewピンチイン/アウト
- (UIView*)viewForZoomingInScrollView:(UIScrollView *)scrollView {
    return m_pPrintImageView;
}

// ボタン押下関数
// ナビゲーションバー 設定ボタン押下
- (IBAction)OnNavBarRightButton:(id)sender {
    // 処理中あるいは処理中断フラグ=TRUEの場合は何もしない
    if (m_pThread || m_bAbort) {
        return;
    }
    bNavRightBtn = YES;
    
//    // 戻るボタンの名称変更
//    UIBarButtonItem * barItemBack = [UIBarButtonItem new];
//    barItemBack.title = S_BUTTON_BACK;
//    self.navigationItem.backBarButtonItem = barItemBack;
    
    // スレッドキャンセル
    if (self.queue != nil) {
        [self.queue cancelAllOperations];
        NSLog(@"キューキャンセル(設定ボタン押下時)");
    }
    if (self.isDuringCommProcess) {
        self.isDuringCommProcess = NO;
    }
    
    SettingSelInfoViewController_iPad *pSettingViewController = [[SettingSelInfoViewController_iPad alloc] initWithStyle:UITableViewStyleGrouped];
    pSettingViewController.modalPresented = YES;//モーダル表示フラグ
    // iPad用
    pSettingViewController.m_bVisibleMenuButton = NO;
//    [self.navigationController pushViewController:pSettingViewController animated:YES];
    // モーダル表示
    UINavigationController *navigationController = [[UINavigationController alloc]initWithRootViewController:pSettingViewController];
    navigationController.navigationBar.barStyle = NAVIGATION_BARSTYLE;
    [navigationController setModalPresentationStyle:UIModalPresentationPageSheet];
    [self presentViewController:navigationController animated:YES completion:nil];

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

    // iPad用
    //// ピッカービューをビューから削除
    //[m_ppickerMenu removeFromSuperview];
    // iPad用

    // メニューボタンID不正
    if (m_nMenuBtnNum < nMenuBtnID) {
        return;
    }

    if ((nMenuBtnID < PrvMenuIDNone) || (nMenuBtnID >= PrvMenuIDMax)) {
        return;
    }
    
    // 選択中ピッカーIDを設定
    //m_nSelPicker = nMenuBtnID;
    m_nSelPicker = nPickerID;
    NSInteger nSelRow = 0;
    
    // 選択中ボタン取得
    UIButton* selButton = nil;
    
    // 選択中の項目取得
    switch (nMenuBtnID) {
        case PrvMenuIDFirst:
            selButton = self.m_pbtnFirst;
            break;
        case PrvMenuIDSecond:
            selButton = self.m_pbtnSecond;
            break;
        case PrvMenuIDThird:
            selButton = self.m_pbtnThird;
            break;
        case PrvMenuIDFourth:
            selButton = self.m_pbtnFourth;
            break;
        case PrvMenuIDFifth:
            selButton = self.m_pbtnFifth;
            break;
        case PrvMenuIDSixth:
            selButton = self.m_pbtnSixth;
            break;
        case PrvMenuIDSeventh:
            selButton = self.m_pbtnSeventh;
            break;
        case PrvMenuIDEighth:
            selButton = self.m_pbtnEighth;
            break;
        case PrvMenuIDNinth:
            selButton = self.m_pbtnNinth;
            break;
        case PrvMenuIDTenth:
            selButton = self.m_pbtnTenth;
            break;
        case PrvMenuIDEleventh:
            selButton = self.m_pbtnEleventh;
            break;
        case PrvMenuIDTwelveth:
            selButton = self.m_pbtnTwelveth;
            break;
        case PrvMenuIDThirteenth:
            selButton = self.m_pbtnThirteenth;
            break;
        case PrvMenuIDFourteenth:
            selButton = self.m_pbtnFourteenth;
            break;
        default:
            break;
    }
    
    // add
    switch (nPickerID) {
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

    // Picker表示用View設定
    PickerViewController_iPad *pickerViewController;
    pickerViewController = [[PickerViewController_iPad alloc] init];

    if (isPrint) {
        LOG(@"self.PrintPictViewID:%d",self.PrintPictViewID);
        // 切り替えセグメントを追加する
        [pickerViewController addSegmentedControl];
        
        // プリンターかプリントサーバーのどちらかのみが登録されている場合は切り替えれなくする
        if ([parrPickerMenu count] == 0) {
            [pickerViewController.segmentedControl setEnabled:NO forSegmentAtIndex:0];
        }else if ([parrPickerMenu2 count] == 0){
            [pickerViewController.segmentedControl setEnabled:NO forSegmentAtIndex:1];
        }
    }

    // popOverサイズを設定
    if (nMenuBtnID == PrvMenuIDSecond) {
        pickerViewController.contentSizeForViewInPopover=CGSizeMake(500,216);
    } else if (nMenuBtnID == PrvMenuIDThird) {
        pickerViewController.contentSizeForViewInPopover=CGSizeMake(200,216);
        pickerViewController.m_bSingleChar = YES;
    } else {
        pickerViewController.contentSizeForViewInPopover=CGSizeMake(300,216);
    }
    pickerViewController.m_parrPickerRow = parrPickerMenu;
    pickerViewController.m_parrPickerRow2 = parrPickerMenu2;
    pickerViewController.m_nSelRow = nSelRow;
    pickerViewController.m_bSets = (nMenuBtnID == PrvMenuIDThird);
    pickerViewController.m_bScanPrint = (nMenuBtnID == PrvMenuIDSecond);
        UINavigationController *pickerNavController = [[UINavigationController alloc] initWithRootViewController:pickerViewController];
    [pickerNavController setNavigationBarHidden:NO];
    
    // popOver release
    if (m_popOver != nil) {
        m_popOver = nil;
    }
    // popOver生成
    if(m_popOver == nil) {
        m_popOver = [[UIPopoverController alloc] initWithContentViewController:pickerNavController];
        m_popOver.delegate = self;
        // popOverサイズを設定
        if (nMenuBtnID == PrvMenuIDSecond) {
            m_popOver.popoverContentSize = CGSizeMake(500,250);
        } else if (nMenuBtnID == PrvMenuIDThird) {
            m_popOver.popoverContentSize = CGSizeMake(200,250);
        } else {
            m_popOver.popoverContentSize = CGSizeMake(320,250);
        }
    }
    // 押下されたボタンの位置取得
    CGRect popoverRect = [self.view convertRect:[selButton frame] fromView:self.view];
    // popOver表示
    if (!m_pMenuView) {
        m_pMenuView = self.view;
    }
    if (!m_popOver.popoverVisible) {
        // ピッカーを左側に出す
        [m_popOver presentPopoverFromRect:popoverRect inView:m_pMenuView permittedArrowDirections:UIPopoverArrowDirectionRight animated:YES];
    }
}

// Picker選択値取得
- (void)getPickerValueAction:(NSNotification*)notification {
    NSInteger row = [[[notification userInfo] objectForKey:@"ROW"] intValue];
    m_pstrPickerValue = (NSString*)[[notification userInfo] objectForKey:@"VALUE"];
    switch (m_nSelPicker) {
        case PrvMenuIDFirst:
            self.m_nSelPickerRow1 = row;
            break;
        case PrvMenuIDSecond:
            self.m_nSelPickerRow2 = row;
            break;
        case PrvMenuIDThird:
            self.m_nSelPickerRow3 = row;
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
    // popOverを閉じる
    [m_popOver dismissPopoverAnimated:YES];
    //Picker選択値設定
    [self setPickerValue];
}

// Picker選択値設定 継承先のクラスでそれぞれ実装
- (void)setPickerValue {
}

// その他サブ関数
// ボタン押下Enabled設定
- (void)SetButtonEnabled:(BOOL)bEnable {
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
- (void)ReleaseObject:(id)object {
    if (object != nil) {
        object = nil;
    }
}

// メッセージボックス表示
- (void)CreateAllert:(NSString*)pstrTitle message:(NSString*)pstrMsg btnTitle:(NSString*)pstrBtnTitle{
    [self dismissAlertPicture];
    SharpScanPrintAppDelegate* appDelegate = (SharpScanPrintAppDelegate*)[[UIApplication sharedApplication] delegate];
    // 処理実行フラグON
    appDelegate.IsRun = TRUE;
    
    [self makePictureAlert:nil message:pstrMsg cancelBtnTitle:pstrBtnTitle okBtnTitle:nil tag:0 showFlg:YES];
}


// メッセージボックス表示
- (void)CreateAllert:(NSString *)pstrTitle message:(NSString *)pstrMsg btnTitle:(NSString *)pstrBtnTitle withTag:(NSInteger)nTag {
    [self dismissAlertPicture];
    SharpScanPrintAppDelegate* appDelegate = (SharpScanPrintAppDelegate*)[[UIApplication sharedApplication] delegate];
    // 処理実行フラグON
    appDelegate.IsRun = TRUE;
    
    [self makePictureAlert:nil message:pstrMsg cancelBtnTitle:pstrBtnTitle okBtnTitle:MSG_BUTTON_OK tag:nTag showFlg:YES];
}

- (void)CreateAlert:(NSString*)pstrTitle message:(NSString*)pstrMsg cancelTitle:(NSString*)cancelTitle okTitle:(NSString*)okTitle withTag:(NSInteger)nTag {
    [self dismissAlertPicture];
    SharpScanPrintAppDelegate* appDelegate = (SharpScanPrintAppDelegate*)[[UIApplication sharedApplication] delegate];
    // 処理実行フラグON
    appDelegate.IsRun = TRUE;
    
    [self makePictureAlert:pstrTitle message:pstrMsg cancelBtnTitle:cancelTitle okBtnTitle:okTitle tag:nTag showFlg:YES];
}

// 処理中アラート表示
- (void)CreateProgressAlert:(NSString *)pstrTitle message:(NSString *)pstrMessage withCancel:(BOOL)bCancel {
	@autoreleasepool {
        [self dismissAlertPicture];
        SharpScanPrintAppDelegate *appDelegate = (SharpScanPrintAppDelegate*)[[UIApplication sharedApplication]delegate];
        
        // 処理実行フラグON
        appDelegate.IsRun = TRUE;
        
        if (bCancel) {
            [self makePictureAlert:nil message:pstrMessage cancelBtnTitle:MSG_BUTTON_CANCEL okBtnTitle:nil tag:1 showFlg:YES];
        } else {
            [self makePictureAlert:nil message:pstrMessage cancelBtnTitle:nil okBtnTitle:nil tag:1 showFlg:YES];
        }
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
    [self dismissAlertPicture];
    SharpScanPrintAppDelegate* appDelegate = (SharpScanPrintAppDelegate*)[[UIApplication sharedApplication] delegate];
    // 処理実行フラグON
    appDelegate.IsRun = TRUE;
    
    [self makePictureAlert:nil message:pstrMsg cancelBtnTitle:pstrCanceBtnTitle okBtnTitle:pstrBtnTitle tag:nTag showFlg:YES];
}

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
    if (!m_bResult) {
        SharpScanPrintAppDelegate * appDelegate = (SharpScanPrintAppDelegate*)[[UIApplication sharedApplication] delegate];
        // 処理実行フラグOFF
        appDelegate.IsRun = FALSE;
    }
    m_bResult = TRUE;
}

- (void)updateView:(UIViewController*) pViewController {
    [self.navigationController pushViewController:pViewController animated:YES];
}

- (void)updateView:(UIViewController*) pViewController animated:(BOOL)animated {
    [self.navigationController pushViewController:pViewController animated:animated];
}

- (void)popRootView {
    if (self.PrintPictViewID == PPV_PRINT_MAIL_ATTACHMENT_CELL) {
        //メール添付ファイル印刷でできたフォルダを削除する
        [TempAttachmentFileUtility deleteMailTmpDir];
    }
    [self.navigationController popToRootViewControllerAnimated:YES];
}

// 縦表示時のメニューボタン設定
- (void)setPortraitMenu:(UIBarButtonItem *)barButtonItem {
    [self.navigationItem setLeftBarButtonItem:nil animated:NO];
    
    if (barButtonItem != nil) {
        if ( [self isMoveWebPagePrint] || [self isMoveAttachmentMail]) {
            // Webページ印刷から遷移している場合は設定しない、代わりに戻るボタンを表示する
            return;
        }
        if (self.PrintPictViewID == WEB_PRINT_VIEW || self.PrintPictViewID == EMAIL_PRINT_VIEW) {
            barButtonItem.title = S_BUTTON_MENU;
        } else {
            barButtonItem.title = S_BUTTON_FILE_LIST;
        }
        [self.navigationItem setLeftBarButtonItem:barButtonItem animated:YES];
    }
}

- (void)showMemoryErrorPNG {
    // エラーメッセージ表示
    [self makePictureAlert:nil message:MSG_IMAGE_PREVIEW_ERR cancelBtnTitle:MSG_BUTTON_OK okBtnTitle:nil tag:ALERT_TAG_PREVIEW_MEMORY_ERROR_IPAD showFlg:YES];
}

// Webページ印刷を行う画面から遷移したかをチェックする
- (BOOL)isMoveWebPagePrint {
    for (UIViewController *viewController in self.navigationController.viewControllers) {
        // Webページ印刷を行う画面から遷移してきた場合
        if ([viewController isKindOfClass:[WebPagePrintViewController_iPad class]]) {
            return YES;
        }
    }
    return NO;
}

- (BOOL)showOriginalViewerCheck:(NSString*)selFilePath {
    if ((self.PrintPictViewID == WEB_PRINT_VIEW || self.PrintPictViewID == EMAIL_PRINT_VIEW)) {
        return YES;
    }
    
    NSArray *previewFilePaths = [GeneralFileUtility getPreviewFilePaths:selFilePath];
    if(previewFilePaths != nil)
    {
        // 自前ビューアでの表示
        DLog(@"%@", @"自前ビューアでの表示チェック");

        arrThumbnails = previewFilePaths;
        totalPage = [arrThumbnails count];

        if (totalPage > 0) {
            return YES;
        }
    }
    return NO;
}
/**
 * 既に出ているアラートを消す
 */
-(void)dismissAlertPicture
{
    if(picture_alert){
        DLog(@"dismissAlertPicture : message = %@", picture_alert.message);
        
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

// 複数印刷対応
- (void)closeBtnPushed:(NSNotification *)n {
    
    if([self isKindOfClass:[PrintPictViewController_iPad class]] || [self isKindOfClass:[MultiPrintPictViewController_iPad class]]) {
        self.m_isShoudRemakeMenuButton = YES;         // 再生成処理必要フラグ
    }

    [self dismissViewControllerAnimated:YES completion:nil];
    
    // プリンター情報を更新
    [self viewWillAppear:YES];
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
