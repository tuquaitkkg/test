
#import <UIKit/UIKit.h>

@class RemoteScanBeforePictViewController;

@interface RSS_ColorModeViewController : UIViewController
{
    RemoteScanBeforePictViewController* __unsafe_unretained parentVCDelegate;
    
    IBOutlet UITableView *colorModeTableView;
    NSArray* colorModeArray;
    NSInteger nSelectedIndexRow;
}


@property (nonatomic, unsafe_unretained) RemoteScanBeforePictViewController* parentVCDelegate;
@property (nonatomic) NSInteger nSelectedIndexRow;


-(id)initWithColorModeArray:(NSArray*)array delegate:(RemoteScanBeforePictViewController*)delegate;


@end
