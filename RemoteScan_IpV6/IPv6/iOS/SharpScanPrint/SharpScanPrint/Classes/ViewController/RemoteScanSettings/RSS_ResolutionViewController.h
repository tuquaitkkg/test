
#import <UIKit/UIKit.h>

@class RemoteScanBeforePictViewController;

@interface RSS_ResolutionViewController : UIViewController
{
    RemoteScanBeforePictViewController* __unsafe_unretained parentVCDelegate;
    
    IBOutlet UITableView *resolutionTableView;
    
    NSArray* resolutionList;
    NSUInteger nSelectResolutionIndexRow;
}

- (id)initWithResolutionArray:(NSArray*)array delegate:(RemoteScanBeforePictViewController*)delegate;

@property (nonatomic, unsafe_unretained) RemoteScanBeforePictViewController* parentVCDelegate;


@end
