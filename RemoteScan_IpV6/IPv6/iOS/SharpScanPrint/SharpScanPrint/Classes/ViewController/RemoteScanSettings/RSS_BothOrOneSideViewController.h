
#import <UIKit/UIKit.h>

@class RemoteScanBeforePictViewController;

@interface RSS_BothOrOneSideViewController : UIViewController
{
    RemoteScanBeforePictViewController* __unsafe_unretained parentVCDelegate;
    
    IBOutlet UITableView *bothOrOneSideTableView;
    IBOutlet UIImageView *selectSideTypeImage;
    
    NSArray* sideTypeList;
    NSInteger nSelectSideTypeIndexRow;
}

@property (nonatomic, unsafe_unretained) RemoteScanBeforePictViewController* parentVCDelegate;
@property (nonatomic) NSInteger nSelectSideTypeIndexRow;

-(id)initWithDuplexDataArray:(NSArray*)array delegate:(RemoteScanBeforePictViewController *)delegate;


@end
