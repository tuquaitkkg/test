
#import <UIKit/UIKit.h>

@class RemoteScanBeforePictViewController_iPad;

@interface RSS_ResolutionViewController_iPad : UIViewController
{
    RemoteScanBeforePictViewController_iPad* __unsafe_unretained parentVCDelegate;

    IBOutlet UITableView *resolutionTableView;
    
    NSArray* resolutionList;
    NSUInteger nSelectResolutionIndexRow;
}

- (id)initWithResolutionArray:(NSArray*)array delegate:(RemoteScanBeforePictViewController_iPad*)delegate;

@property (nonatomic, unsafe_unretained) RemoteScanBeforePictViewController_iPad* parentVCDelegate;

@end
