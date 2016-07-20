#import <UIKit/UIKit.h>
#import "SharpScanPrintAppDelegate.h"
#import "PrintReleaseSwitchDataCell.h"

@protocol PrintReleaseSettingViewControllerDelegate

-(void) printReleaseSetting:(UIViewController*)viewController canceled:(BOOL)canceled;
    
@end

@interface PrintReleaseSettingViewController : UITableViewController
{
    NSObject <PrintReleaseSettingViewControllerDelegate> *__unsafe_unretained delegate;
    
    
    //BOOL printReleaseOn;                             // プリントリリース　する/しない
}

@property(nonatomic, unsafe_unretained) id delegate;
@property(nonatomic, strong) PrintReleaseSwitchDataCell* printReleaseEnableDataCell;
@property BOOL enabledPrintRelease;

@property BOOL printReleaseOn;  // プリントリリース　する/しない

@end
