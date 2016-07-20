
#import "SpecialModeHelpViewController.h"
#import "HelpViewController.h"
#import "Define.h"
#import "SharpScanPrintAppDelegate.h"
#import "RootViewController.h"
#import "RootViewController_iPad.h"
#import "VersionInfoViewController.h"
#import "VersionInfoViewController_iPad.h"

@implementation SpecialModeHelpViewController

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
    if(m_webView != nil)
    {
        m_webView.delegate = nil;
        m_webView = nil;
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
    
    self.view.backgroundColor = BACKGROUND_COLOR;// TableViewに合わせた背景を設定
    if([[[UIDevice currentDevice] systemVersion] floatValue] >= 6.0 &&
       [[[UIDevice currentDevice] systemVersion] floatValue] < 7.0 &&
       UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
    {// iOS6のiPhoneだけ
        UITableView *tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
        [self.view addSubview:tableView];
        [self.view sendSubviewToBack:tableView];
    }
    
    // 特別モード
    // ナビゲーションバーにタイトル設定
    self.navigationItem.title = S_BUTTON_HELP;
    // ナビゲーションバー右側に閉じるボタンを設定
    UIBarButtonItem *btnClose = [[UIBarButtonItem alloc] initWithTitle:S_BUTTON_CLOSE style:UIBarButtonItemStylePlain target:self action:@selector(onClose)];
    self.navigationItem.rightBarButtonItem = btnClose;
    
    // help.htmlをWebViewに表示
    m_webView = [[UIWebView alloc]init];
    m_webView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    m_webView.frame = CGRectMake(3, 3, (self.view.frame.size.width - 5), (self.view.frame.size.height - 10));
    m_webView.scalesPageToFit = YES;
    [self.view addSubview:m_webView];
    NSString* path = [[NSBundle mainBundle] pathForResource:S_HELP_SPECIAL_MODE ofType:@"html"];
    [m_webView loadRequest:[NSURLRequest requestWithURL:[NSURL fileURLWithPath:path]]];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
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
    if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
    {
        SharpScanPrintAppDelegate* pAppDelegate = (SharpScanPrintAppDelegate*)[[UIApplication sharedApplication] delegate];
        UINavigationController* pRootNavController = [pAppDelegate.splitViewController.viewControllers objectAtIndex:0];
        RootViewController_iPad* rootViewController_ipad = (RootViewController_iPad*)[pRootNavController.viewControllers objectAtIndex:0];
        [rootViewController_ipad OnHelpClose];
    }
    else
    {
        // Modal表示のため、呼び出し元で閉じる処理を行う
        SharpScanPrintAppDelegate* appDelegate = (SharpScanPrintAppDelegate*)[[UIApplication sharedApplication] delegate];
        
        VersionInfoViewController* versionInfoViewController = (VersionInfoViewController*)appDelegate.navigationController.topViewController;
        [versionInfoViewController dissmissModalView];
    }
}

@end

