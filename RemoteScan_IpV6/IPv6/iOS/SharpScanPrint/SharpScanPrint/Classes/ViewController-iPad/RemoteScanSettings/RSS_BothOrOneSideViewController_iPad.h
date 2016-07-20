
#import <UIKit/UIKit.h>

@class RemoteScanBeforePictViewController_iPad;

@interface RSS_BothOrOneSideViewController_iPad : UIViewController
{
    RemoteScanBeforePictViewController_iPad* __unsafe_unretained parentVCDelegate;
    
    IBOutlet UITableView *bothOrOneSideTableView;
    IBOutlet UIImageView *selectSideTypeImage;
 
    NSArray* sideTypeList;
    NSInteger nSelectSideTypeIndexRow;
}

@property (nonatomic, unsafe_unretained) RemoteScanBeforePictViewController_iPad* parentVCDelegate;
@property (nonatomic) NSInteger nSelectSideTypeIndexRow;

-(id)initWithDuplexDataArray:(NSArray*)array delegate:(RemoteScanBeforePictViewController_iPad *)delegate;

@end
