
#import <UIKit/UIKit.h>
#import "LoginAlertViewController_iPad.h"
#import "ExAlertController.h"

@interface SharpScanPrintAppDelegate : NSObject <UIApplicationDelegate, UISplitViewControllerDelegate> {
    
    UIWindow *window;
    UINavigationController *navigationController;
    UISplitViewController *splitViewController; // iPad用
    BOOL m_bIsRun;
    //IBOutlet UITextField *m_ptxtPass;
    BOOL m_isExSite;
    NSURL *m_purl;
    // iPad用
    LoginAlertViewController_iPad* loginAlertViewController;
    BOOL m_bIsPreview;
    BOOL m_bIsShowAlert;
    // iPad用
    UIPopoverController* masterPopoverController;
}

@property (nonatomic, strong) IBOutlet UIWindow *window;
@property (nonatomic, strong) IBOutlet UINavigationController *navigationController;
@property (nonatomic, strong) IBOutlet UISplitViewController *splitViewController;  // iPad用
@property (nonatomic) BOOL IsStart;
@property (nonatomic) BOOL IsRun;
@property (nonatomic) BOOL IsExSite;
@property (nonatomic, copy) NSURL *Url;
@property (nonatomic) BOOL IsPreview;  // iPad用
@property (strong, nonatomic) UIPopoverController *masterPopoverController;
@property (nonatomic, strong)   ExAlertController* convertAlert;	// データ移行用

// iPad用
- (void)SetView;
- (void)SetLoginAlertView:(BOOL)isloginAlertViewShow;
// iPad用
-(void)createAndShowIndicator;
-(void)stopIndicator;

- (void)setPortraitMenuButton;
-(void)dismissPopoverAnimated:(BOOL)animated;
-(void)showPopoverAnimated:(BOOL)animated;

- (void)doConvertProcessing;

@end

