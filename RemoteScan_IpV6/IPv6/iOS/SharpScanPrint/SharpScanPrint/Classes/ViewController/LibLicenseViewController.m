
#import "LibLicenseViewController.h"
#import "SharpScanPrintAppDelegate.h"
#import "RootViewController_iPad.h"
#import "VersionInfoViewController.h"
#import "Define.h"

@interface LibLicenseViewController ()

@end

@implementation LibLicenseViewController
{
    NSString* m_pstrTitle;
    NSString* m_pstrLicenseResource;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (id)initWithLicenseResource:(NSString*)pstrTitle licenseResource:(NSString*)pstrLicenseResource
{
    self = [super init];
    if (self) {
        m_pstrTitle = pstrTitle;
        m_pstrLicenseResource = pstrLicenseResource;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // UINavigationBar 44px のずれを無くす
    self.navigationController.navigationBar.translucent = NO;
    self.navigationController.navigationBar.barStyle = NAVIGATION_BARSTYLE;
    
    self.view.backgroundColor = BACKGROUND_COLOR;// TableViewに合わせた背景を設定
    if([[[UIDevice currentDevice] systemVersion] floatValue] >= 6.0 &&
       [[[UIDevice currentDevice] systemVersion] floatValue] < 7.0 &&
       UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
    {// iOS6のiPhoneだけ
        UITableView *tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
        [self.view addSubview:tableView];
        [self.view sendSubviewToBack:tableView];
    }

    // ナビゲーションバーにタイトル設定
    UILabel* lblTitle = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 400, 44)];
    lblTitle.backgroundColor = [UIColor clearColor];
    lblTitle.textColor = NAVIGATION_TITLE_COLOR;
    lblTitle.font = [UIFont boldSystemFontOfSize:20];
    lblTitle.textAlignment = NSTextAlignmentCenter;
    lblTitle.adjustsFontSizeToFitWidth = YES;
    lblTitle.text = m_pstrTitle;
    self.navigationItem.titleView = lblTitle;
    
    //self.navigationItem.title = m_pstrTitle;
    // ナビゲーションバー右側に閉じるボタンを設定
    UIBarButtonItem *btnClose = [[UIBarButtonItem alloc] initWithTitle:S_BUTTON_CLOSE style:UIBarButtonItemStylePlain target:self action:@selector(onClose)];
    self.navigationItem.rightBarButtonItem = btnClose;
    
    // ライセンスファイル読み込み
    NSString* path = [[NSBundle mainBundle] pathForResource:m_pstrLicenseResource ofType:@"txt"];
    NSError* error;
    NSString* message = [NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:&error];
    
    //ライセンスファイルをTextViewで表示
    CGRect frame = CGRectMake(3, 5, (self.view.frame.size.width - 5), (self.view.frame.size.height - self.navigationController.navigationBar.frame.size.height - 10));
    UITextView* pTextView = [[UITextView alloc] initWithFrame:frame];
    pTextView.backgroundColor = [UIColor clearColor];
    pTextView.editable = NO;
    pTextView.scrollEnabled = YES;
    pTextView.userInteractionEnabled = YES;
    pTextView.text = message;
    pTextView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    [self.view addSubview:pTextView];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

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

// 閉じるボタン押下
- (void) onClose
{
    //iPad
    if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
    {
        SharpScanPrintAppDelegate* pAppDelegate = (SharpScanPrintAppDelegate*)[[UIApplication sharedApplication] delegate];
        UINavigationController* pRootNavController = [pAppDelegate.splitViewController.viewControllers objectAtIndex:0];
        RootViewController_iPad* rootViewController_ipad = (RootViewController_iPad*)[pRootNavController.viewControllers objectAtIndex:0];
        [rootViewController_ipad OnHelpClose];
    }
    //iPhone
    else
    {
        // Modal表示のため、呼び出し元で閉じる処理を行う
        SharpScanPrintAppDelegate* appDelegate = (SharpScanPrintAppDelegate*)[[UIApplication sharedApplication] delegate];
        
        VersionInfoViewController* versionInfoViewController = (VersionInfoViewController*)appDelegate.navigationController.topViewController;
        [versionInfoViewController dissmissModalView];
    }
}

@end
