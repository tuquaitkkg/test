
#import "VersionInfoViewController.h"
#import "Define.h"
#import "SpecialModeHelpViewController.h"
#import "LibLicenseViewController.h"

@implementation VersionInfoViewController

AlertMessageCheck* check;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        
    }
    return self;
}

- (void)dealloc
{
    [self ReleaseObject:m_tradeMark];
    [self ReleaseObject:m_applicationName];
    [self ReleaseObject:m_applicationName2];
    [self ReleaseObject:m_vesionNumber];
    [self ReleaseObject:m_copyright];
    
    if(nil != m_imageView)
    {
        m_imageView.image = nil;
        [self ReleaseObject:m_imageView];
    }
}

// 変数解放
- (void)ReleaseObject:(id)object
{
    if (object != nil)
    {
        object = nil;
    }
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
    // Do any additional setup after loading the view from its nib.
    // ナビゲーションバー
    // タイトル設定
    self.navigationItem.title = S_TITLE_VERSION_INFO;
    
    // 戻るボタンの名称変更
    UIBarButtonItem * barItemBack = [UIBarButtonItem new];
    barItemBack.title = S_BUTTON_BACK;
    self.navigationItem.backBarButtonItem = barItemBack;
    
    // 色変更
    //self.navigationController.navigationBar.tintColor = [UIColor blackColor];
    
    // アプリケーション情報の設定
    [self AddAndKeepTextDown:S_TRADEMARK :m_tradeMark];
    m_applicationName.text = S_APPLICATIONNAME;
    m_applicationName2.text = S_APPLICATIONNAME2;
#ifdef IPV6_VALID
    NSString *strVersion = [NSString stringWithFormat:S_VERSION,[[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleVersion"],MAINTENANCE_NUMBER];
    m_vesionNumber.text = [strVersion stringByAppendingString:@" IPv6"];
#else
    m_vesionNumber.text = [NSString stringWithFormat:S_VERSION,[[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleVersion"],MAINTENANCE_NUMBER];
#endif
    m_copyright.text = S_COPYRIGHT;
    m_libraryLicense.text = S_LIBRARY_LICENSE;
    [m_librarySnmpPlus setTitle:S_LIBRARY_SNMPPLUS forState:UIControlStateNormal];
    
//    UITableView *tv = [[UITableView alloc] initWithFrame:self.view.frame style:UITableViewStyleGrouped];
//    UIView *backgroundView = tv.backgroundView;
//    [self.view addSubview:tv.backgroundView];
//    CGRect backgroundFrame = CGRectMake(0,0,self.view.frame.size.width,self.view.frame.size.height);
//    [backgroundView setFrame:backgroundFrame];
//    [self.view sendSubviewToBack:backgroundView];
    
    self.view.backgroundColor = BACKGROUND_COLOR;// TableViewに合わせた背景を設定
    if([[[UIDevice currentDevice] systemVersion] floatValue] >= 6.0 &&
       [[[UIDevice currentDevice] systemVersion] floatValue] < 7.0 &&
       UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
    {// iOS6のiPhoneだけ
        UITableView *tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
        [self.view addSubview:tableView];
        [self.view sendSubviewToBack:tableView];
    }
    
    //国内版の場合、特別モード実行可能
    if ([S_LANG isEqualToString:S_LANG_JA])
    {
        CGRect rect1 = [[UIScreen mainScreen] bounds];
        DLog(@"rect1.size.width : %f , rect1.size.height : %f", rect1.size.width, rect1.size.height);
        
        // 特別モードボタン生成
        [m_btnSpecialMode setExclusiveTouch: YES];
        // 背景画像設定
        [m_btnSpecialMode setBackgroundImage:[UIImage imageNamed:S_IMAGE_BUTTON_GRAY] forState:UIControlStateNormal];
        m_btnSpecialMode.titleEdgeInsets = UIEdgeInsetsMake(0.0,0.0,0.0,0.0);
        [m_btnSpecialMode setTitle:S_BUTTON_SPECIALMODE forState:UIControlStateNormal];                     // ボタンのラベル
        [m_btnSpecialMode setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];        // ボタンのフォント
        m_btnSpecialMode.titleLabel.font = [UIFont systemFontOfSize:12];                            // ボタンのフォントサイズ
        m_btnSpecialMode.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;    // ボタンAlign
        
        // イベント
        [m_btnSpecialMode addTarget:self action:@selector(OnClickSpecialModeButton:) forControlEvents:UIControlEventTouchUpInside] ;
        
        NSUserDefaults* specialMode = [NSUserDefaults standardUserDefaults]; 
        
        if([specialMode boolForKey:S_SPECIALMODE_FLAG])
        {
            m_btnSpecialMode.hidden = NO;
        }
        else
        {
            m_btnSpecialMode.hidden = YES;        
        }
        
        m_imageView.userInteractionEnabled = YES;
        
        [self createGestureRecognizer];
    }
    
    //PDF印刷範囲拡張モード表示ボタン生成
    [self makePdfPrintRangeExpansionButton];

    
    // AlertDialog確認用
    if(NO)
    {
        check = [[AlertMessageCheck alloc] init];
        [check showAlertView:YES];
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
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)AddAndKeepTextDown:(NSString *)newString 
                          :(UILabel *)txtLabel
{   
    // 文字列代入後のラベルサイズを取得
    CGSize size;
    if (floor(NSFoundationVersionNumber) <= NSFoundationVersionNumber_iOS_6_1) {
        // Load resources for iOS 6.1 or earlier
        
        size = [newString sizeWithFont:txtLabel.font
                     constrainedToSize:CGSizeMake(txtLabel.bounds.size.width, 2000)
                         lineBreakMode:NSLineBreakByCharWrapping];
        DLog(@"1:%f:%f",size.width, size.height);
    } else {
        // Load resources for iOS 7 or later
        
        NSDictionary *attributeDic = @{NSFontAttributeName:txtLabel.font};
        size = [newString boundingRectWithSize:CGSizeMake(txtLabel.bounds.size.width, 2000)
                                       options:NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading
                                    attributes:attributeDic
                                       context:nil].size;
        // 小数点以下を切り上げないとうまくいかない
        size.width = ceilf(size.width);
        size.height = ceilf(size.height);
        DLog(@"2:%f:%f",size.width, size.height);
    }

    txtLabel.translatesAutoresizingMaskIntoConstraints = YES;   // AutoLayoutでsetFrameを行う。
    txtLabel.frame = CGRectMake(txtLabel.frame.origin.x,
                                txtLabel.frame.origin.y + (txtLabel.bounds.size.height - size.height),
                                txtLabel.bounds.size.width,
                                size.height);
    txtLabel.text = newString;
}


- (void)createGestureRecognizer
{
    UILongPressGestureRecognizer *longPressGesture = [[UILongPressGestureRecognizer alloc]
                                                      initWithTarget:self                                                                                            
                                                      action:@selector(handleLongPressGesture:)];
    // 10秒長押し
    longPressGesture.minimumPressDuration = 10;
    longPressGesture.delegate = self;
    [m_imageView addGestureRecognizer:longPressGesture];
    
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch
{
    return YES;
}

- (void)handleLongPressGesture:(UILongPressGestureRecognizer*) sender
{
    switch (sender.state) {
        case UIGestureRecognizerStateBegan: {
            //長押しを検知した場合の処理
            DLog(@"long press"); 
            
            NSUserDefaults* specialMode = [NSUserDefaults standardUserDefaults]; 
            if([specialMode boolForKey:S_SPECIALMODE_FLAG])
            {
                // 特別モードフラグ保存
                [specialMode setBool:NO forKey:S_SPECIALMODE_FLAG];
                [specialMode synchronize];
                
                m_btnSpecialMode.hidden = YES;
            }
            else
            {
                // 特別モードフラグ保存
                [specialMode setBool:YES forKey:S_SPECIALMODE_FLAG];
                [specialMode synchronize];
                
                m_btnSpecialMode.hidden = NO;
            }
            
            break;
            
        }
        default:
            break;
    }
}

- (IBAction)OnClickSpecialModeButton:(id)sender
{
    //特別モードヘルプ画面表示
    SpecialModeHelpViewController* specialModeHelpViewController = [[SpecialModeHelpViewController alloc]init];
    
    UINavigationController *navigationController = [[UINavigationController alloc]
                                                    initWithRootViewController:specialModeHelpViewController];
    navigationController.navigationBar.barStyle = NAVIGATION_BARSTYLE;
    [navigationController setModalPresentationStyle:UIModalPresentationPageSheet];
    [self presentViewController:navigationController animated:YES completion:nil];
}


- (void)createGestureRecognizerForPdfPrintRangeExpansion
{
    UILongPressGestureRecognizer *longPressGesture = [[UILongPressGestureRecognizer alloc]
                                                      initWithTarget:self
                                                      action:@selector(handleLongPressGestureForPdfPrintRangeExpansion:)];
    // 5秒長押し
    longPressGesture.minimumPressDuration = 5;
    longPressGesture.delegate = self;
    [m_applicationName addGestureRecognizer:longPressGesture];
    
}

- (void)handleLongPressGestureForPdfPrintRangeExpansion:(UILongPressGestureRecognizer*) sender
{
    switch (sender.state) {
        case UIGestureRecognizerStateBegan: {
            //長押しを検知した場合の処理
            DLog(@"long press");
            
            NSUserDefaults* pdfPrintRangeExpansionMode = [NSUserDefaults standardUserDefaults];
            if([pdfPrintRangeExpansionMode boolForKey:S_PDF_PRINT_RANGE_EXPANSION_FLAG])
            {
                // PDF印刷範囲拡張モードフラグ保存
                [pdfPrintRangeExpansionMode setBool:NO forKey:S_PDF_PRINT_RANGE_EXPANSION_FLAG];
                [pdfPrintRangeExpansionMode synchronize];
                
                m_btnPdfPrintRangeExpansionMode.hidden = YES;
            }
            else
            {
                // PDF印刷範囲拡張モードフラグ保存
                [pdfPrintRangeExpansionMode setBool:YES forKey:S_PDF_PRINT_RANGE_EXPANSION_FLAG];
                [pdfPrintRangeExpansionMode synchronize];
                
                m_btnPdfPrintRangeExpansionMode.hidden = NO;
            }
            
            break;
            
        }
        default:
            break;
    }
}

- (IBAction)OnClickPdfPrintRangeExpansionButton:(id)sender
{
    //特にイベントなし
    DLog(@"OnClickPdfPrintRangeExpansionButton");
}

//PDF印刷範囲拡張モード表示ボタン生成
- (void)makePdfPrintRangeExpansionButton{
    
    CGRect rect1 = [[UIScreen mainScreen] bounds];
    DLog(@"rect1.size.width : %f , rect1.size.height : %f", rect1.size.width, rect1.size.height);
    
    
    // PDF印刷範囲拡張モードボタン生成
    [m_btnPdfPrintRangeExpansionMode setExclusiveTouch: YES];
    CGFloat startY = [S_LANG isEqualToString:S_LANG_JA] ? m_btnPdfPrintRangeExpansionMode.frame.origin.y : (m_btnPdfPrintRangeExpansionMode.frame.origin.y - 35);    //国内版と海外版で座標を変える
    CGFloat buttonW = [S_LANG isEqualToString:S_LANG_JA] ? m_btnPdfPrintRangeExpansionMode.frame.size.width : (m_btnPdfPrintRangeExpansionMode.frame.size.width + 190);    //国内版と海外版で座標を変える
    if([[[UIDevice currentDevice] systemVersion] floatValue] < 7.0) {
        startY -= 44;
    }
    
    m_btnPdfPrintRangeExpansionMode.translatesAutoresizingMaskIntoConstraints = YES;    // AutoLayoutでsetFrameを行う。
    m_btnPdfPrintRangeExpansionMode.frame = [self createSpecialButtonCGRectFromY:startY SizeWidth:buttonW SizeHeight:32.0];
    
    // 背景画像設定
    [m_btnPdfPrintRangeExpansionMode setBackgroundImage:[UIImage imageNamed:S_IMAGE_BUTTON_GRAY] forState:UIControlStateNormal];
    m_btnPdfPrintRangeExpansionMode.titleEdgeInsets = UIEdgeInsetsMake(0.0,0.0,0.0,0.0);
    [m_btnPdfPrintRangeExpansionMode setTitle:S_BUTTON_PRINT_RANGE_EXPANSION forState:UIControlStateNormal];                     // ボタンのラベル
    [m_btnPdfPrintRangeExpansionMode setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];        // ボタンのフォント
    m_btnPdfPrintRangeExpansionMode.titleLabel.font = [UIFont systemFontOfSize:12];                            // ボタンのフォントサイズ
    m_btnPdfPrintRangeExpansionMode.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;    // ボタンAlign
    m_btnPdfPrintRangeExpansionMode.titleLabel.adjustsFontSizeToFitWidth = YES;
    m_btnPdfPrintRangeExpansionMode.titleEdgeInsets = UIEdgeInsetsMake(m_btnPdfPrintRangeExpansionMode.titleEdgeInsets.top,
                                                                       10,
                                                                       m_btnPdfPrintRangeExpansionMode.titleEdgeInsets.bottom,
                                                                       10);
    // 長い文言の場合に、ボタンからラベルがはみ出てしまったため、ボタン内のマージンを無理やり左右10ずつあけるようにしました。
    
    
    // イベント
    [m_btnPdfPrintRangeExpansionMode addTarget:self action:@selector(OnClickPdfPrintRangeExpansionButton:) forControlEvents:UIControlEventTouchUpInside] ;
    
    NSUserDefaults* pdfPrintRangeExpansionMode = [NSUserDefaults standardUserDefaults];
    
    if([pdfPrintRangeExpansionMode boolForKey:S_PDF_PRINT_RANGE_EXPANSION_FLAG])
    {
        m_btnPdfPrintRangeExpansionMode.hidden = NO;
    }
    else
    {
        m_btnPdfPrintRangeExpansionMode.hidden = YES;
    }
    
    m_applicationName.userInteractionEnabled = YES;
    
    [self createGestureRecognizerForPdfPrintRangeExpansion];
}


// モーダル表示したヘルプ画面を閉じる
- (void)dissmissModalView
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

//ライセンス条項表示 (SNMP++)
- (IBAction)onLicenseSNMPplus:(id)sender
{
    LibLicenseViewController* libLicenseViewController = [[LibLicenseViewController alloc] initWithLicenseResource:((UIButton*)sender).currentTitle licenseResource:S_LIBRARY_LICENSE_SNMPPLUS];

    UINavigationController *navigationController = [[UINavigationController alloc]
                                                     initWithRootViewController:libLicenseViewController];
    navigationController.navigationBar.barStyle = NAVIGATION_BARSTYLE;
    [navigationController setModalPresentationStyle:UIModalPresentationPageSheet];
    [self presentViewController:navigationController animated:YES completion:nil];
}

//ライセンス条項表示 (MailCore)
- (IBAction)onLicenseMailCore:(id)sender
{
    LibLicenseViewController* libLicenseViewController = [[LibLicenseViewController alloc] initWithLicenseResource:((UIButton*)sender).currentTitle licenseResource:S_LIBRARY_LICENSE_MAILCORE];
    
    UINavigationController *navigationController = [[UINavigationController alloc]
                                                     initWithRootViewController:libLicenseViewController];
    navigationController.navigationBar.barStyle = NAVIGATION_BARSTYLE;
    [navigationController setModalPresentationStyle:UIModalPresentationPageSheet];
    [self presentViewController:navigationController animated:YES completion:nil];
}

//ライセンス条項表示 (LibEtPan)
- (IBAction)onLicenseLibEtPan:(id)sender
{
    LibLicenseViewController* libLicenseViewController = [[LibLicenseViewController alloc] initWithLicenseResource:((UIButton*)sender).currentTitle licenseResource:S_LIBRARY_LICENSE_LIBETPAN];
    
    UINavigationController *navigationController = [[UINavigationController alloc]
                                                     initWithRootViewController:libLicenseViewController];
    navigationController.navigationBar.barStyle = NAVIGATION_BARSTYLE;
    [navigationController setModalPresentationStyle:UIModalPresentationPageSheet];
    [self presentViewController:navigationController animated:YES completion:nil];
}

//ライセンス条項表示 (iOS Ports SDK)
- (IBAction)onLicenseiOSPorts:(id)sender
{
    LibLicenseViewController* libLicenseViewController = [[LibLicenseViewController alloc] initWithLicenseResource:((UIButton*)sender).currentTitle licenseResource:S_LIBRARY_LICENSE_IOSPORTS];
    
    UINavigationController *navigationController = [[UINavigationController alloc]
                                                     initWithRootViewController:libLicenseViewController];
    navigationController.navigationBar.barStyle = NAVIGATION_BARSTYLE;
    [navigationController setModalPresentationStyle:UIModalPresentationPageSheet];
    [self presentViewController:navigationController animated:YES completion:nil];
}

//ライセンス条項表示 (Cyrus SASL)
- (IBAction)onLicenseCyrusSASL:(id)sender
{
    LibLicenseViewController* libLicenseViewController = [[LibLicenseViewController alloc] initWithLicenseResource:((UIButton*)sender).currentTitle licenseResource:S_LIBRARY_LICENSE_CYRUSSASL];
    
    UINavigationController *navigationController = [[UINavigationController alloc]
                                                     initWithRootViewController:libLicenseViewController];
    navigationController.navigationBar.barStyle = NAVIGATION_BARSTYLE;
    [navigationController setModalPresentationStyle:UIModalPresentationPageSheet];
    [self presentViewController:navigationController animated:YES completion:nil];
}

//ライセンス条項表示 (OpenSSL)
- (IBAction)onLicenseOpenSSL:(id)sender
{
    LibLicenseViewController* libLicenseViewController = [[LibLicenseViewController alloc] initWithLicenseResource:((UIButton*)sender).currentTitle licenseResource:S_LIBRARY_LICENSE_OPENSSL];
    
    UINavigationController *navigationController = [[UINavigationController alloc]
                                                     initWithRootViewController:libLicenseViewController];
    navigationController.navigationBar.barStyle = NAVIGATION_BARSTYLE;
    [navigationController setModalPresentationStyle:UIModalPresentationPageSheet];
    [self presentViewController:navigationController animated:YES completion:nil];
}

//ライセンス条項表示 (ELCImagePickerController)
- (IBAction)onLicenseELCImage:(id)sender
{
    LibLicenseViewController* libLicenseViewController = [[LibLicenseViewController alloc] initWithLicenseResource:((UIButton*)sender).currentTitle licenseResource:S_LIBRARY_LICENSE_ELCIMAGE];
    
    UINavigationController *navigationController = [[UINavigationController alloc]
                                                    initWithRootViewController:libLicenseViewController];
    navigationController.navigationBar.barStyle = NAVIGATION_BARSTYLE;
    [navigationController setModalPresentationStyle:UIModalPresentationPageSheet];
    [self presentViewController:navigationController animated:YES completion:nil];
}

//ライセンス条項表示 (MiniZip)
- (IBAction)onLicenseMiniZip:(id)sender
{
    LibLicenseViewController* libLicenseViewController = [[LibLicenseViewController alloc] initWithLicenseResource:((UIButton*)sender).currentTitle licenseResource:S_LIBRARY_LICENSE_MINIZIP];
    
    UINavigationController *navigationController = [[UINavigationController alloc]
                                                    initWithRootViewController:libLicenseViewController];
    navigationController.navigationBar.barStyle = NAVIGATION_BARSTYLE;
    [navigationController setModalPresentationStyle:UIModalPresentationPageSheet];
    [self presentViewController:navigationController animated:YES completion:nil];
}

#pragma mark - Private Method
// 特別モード機能有効時のボタンを作成します。
- (CGRect) createSpecialButtonCGRectFromY :(CGFloat) originY SizeWidth:(CGFloat) sizeWidth SizeHeight:(CGFloat) sizeHeight
{
    CGFloat originX = (self.view.frame.size.width / 2) - (sizeWidth / 2);
    return CGRectMake(originX, originY, sizeWidth, sizeHeight);
}

@end
