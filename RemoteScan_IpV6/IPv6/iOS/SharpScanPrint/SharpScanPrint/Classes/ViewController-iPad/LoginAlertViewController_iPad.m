
#import "LoginAlertViewController_iPad.h"
#import "Define.h"
#import "SharpScanPrintAppDelegate.h"
#import "LicenseViewController.h"

@implementation LoginAlertViewController_iPad

@synthesize IsView;
@synthesize IsShowLicense;

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
    if(m_pImageView != nil)
    {
        m_pImageView.image = nil;
        m_pImageView = nil;
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
    
    // ロゴ画像の読み込み
    UIInterfaceOrientation orientation = [[UIApplication sharedApplication] statusBarOrientation];
    if(UIDeviceOrientationIsPortrait(orientation)){
        // Portrait
//        UIImage* img = [UIImage imageNamed:@"Default-Portrait~ipad"];
        UIImage* img = [UIImage imageNamed:@"Default-Portrait"];
        m_pImageView.image = img;
        m_pImageView.frame = (CGRect){CGPointZero, img.size};
        
    }else{
        // Landscape
//        UIImage* img = [UIImage imageNamed:@"Default-Landscape~ipad"];
        UIImage* img = [UIImage imageNamed:@"Default-Landscape"];
        m_pImageView.image = img;
        m_pImageView.frame = (CGRect){CGPointZero, img.size};
        
    }
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;

    if(m_pImageView != nil)
    {
        m_pImageView.image = nil;
        m_pImageView = nil;
    }
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    m_pImageView.hidden = NO;
    
    self.navigationController.navigationBarHidden = YES;
    if(self.IsView)
    {
        // ログインフラグ(ライセンス同意フラグ)を取得
        NSUserDefaults* pud = [NSUserDefaults standardUserDefaults]; 
        BOOL isLogin = [pud boolForKey:S_LOGIN];
        
        // ログイン済み(ライセンス同意済)の場合
        if(isLogin)
        {
            [self performSelector:@selector(setMainView) withObject:nil afterDelay:0.1] ;
        }else{
            [self performSelector:@selector(createLicenseView) withObject:nil afterDelay:0.1] ;
        }
    }
}

-(void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation
{
    
}

- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration
{
    if(UIDeviceOrientationIsPortrait(toInterfaceOrientation)){
        // Portrait
        UIImage* img = [UIImage imageNamed:@"Default-Portrait.png"];
        m_pImageView.image = img;
        m_pImageView.frame = (CGRect){CGPointZero, img.size};
        
    }else{
        // Landscape
        UIImage* img = [UIImage imageNamed:@"Default-Landscape.png"];
        m_pImageView.image = img;
        m_pImageView.frame = (CGRect){CGPointZero, img.size};
        
    }
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
     return YES;
}

// ライセンス画面を開く
- (void)createLicenseView
{
    DLog(@"self width:%f height:%f", self.view.frame.size.width,self.view.frame.size.height);
    
    LicenseViewController* licenseViewController = [[LicenseViewController alloc]init];

    UINavigationController *navigationController = [[UINavigationController alloc]initWithRootViewController:licenseViewController];
    navigationController.navigationBar.translucent = NO;
    navigationController.navigationBar.barStyle = NAVIGATION_BARSTYLE;
    
    // 同意するボタン追加
    UIBarButtonItem *rb = [[UIBarButtonItem alloc] initWithTitle:S_BUTTON_AGREE style:UIBarButtonItemStyleDone target:self action:@selector(closeLicenseView)];
    [licenseViewController.navigationItem setRightBarButtonItem:rb animated:NO];
    
    // モーダルで開く
    [navigationController setModalPresentationStyle:UIModalPresentationPageSheet];
    [self presentViewController:navigationController animated:YES completion:nil];
    
}

// ライセンス画面を閉じる
- (void)closeLicenseView
{
    // モーダルを閉じる
    [self dismissViewControllerAnimated:YES completion:nil];
    
    NSUserDefaults* pud = [NSUserDefaults standardUserDefaults];
    
    [pud setBool:TRUE forKey:S_LOGIN];
    [pud synchronize];
    
    // トップ画面に遷移
    [self setMainView];
}

// トップ画面に遷移
- (void)setMainView
{
    SharpScanPrintAppDelegate* appDelegate = (SharpScanPrintAppDelegate*)[[UIApplication sharedApplication] delegate];
  
    // Version2.2への移行処理を開始する
    [appDelegate doConvertProcessing];
    
//    [appDelegate SetView];
}


@end
