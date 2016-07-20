
#import "LicenseViewController.h"
#import "Define.h"

@interface LicenseViewController ()

@end

@implementation LicenseViewController

@synthesize textView;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {

    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    self.view.backgroundColor = [UIColor blackColor];

    [self createLicense];
}

- (void)createLicense
{
    // ライセンスファイル読み込み
    NSString* path = [[NSBundle mainBundle] pathForResource:S_LICENSE ofType:@"txt"];
    NSError* error;
    NSString* message = [NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:&error];

    CGRect tvRec = CGRectMake(20, 0, self.view.frame.size.width-40, self.view.frame.size.height);
    // ライセンス文言設定
    textView = [[UITextView alloc] initWithFrame:tvRec];
    textView.backgroundColor = [UIColor clearColor];
    textView.editable = NO;
    textView.scrollEnabled = YES;
    textView.userInteractionEnabled = YES;
    textView.text = message;
    textView.textColor = [UIColor whiteColor];
    textView.indicatorStyle = UIScrollViewIndicatorStyleWhite;
    [self.view addSubview:textView];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];

}

/**
 @brief iOS8以降の回転時のレイアウト変更を行う
 */
- (void)viewWillTransitionToSize:(CGSize)size withTransitionCoordinator:(id<UIViewControllerTransitionCoordinator>)coordinator
{
    if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        DLog(@"self width:%f height:%f", self.view.frame.size.width,self.view.frame.size.height);
        [coordinator animateAlongsideTransition:^(id<UIViewControllerTransitionCoordinatorContext> context) {
            
            CGRect tvRec = CGRectMake(20, 0, self.view.frame.size.width-40, self.view.frame.size.height);
            textView.frame =tvRec;
            
        } completion:nil];
        
    }
    
    [super viewWillTransitionToSize:size withTransitionCoordinator:coordinator];
}

@end
