
#import <UIKit/UIKit.h>
#import "RSS_CustomSizeListViewController.h"
#import "PickerViewController.h"

@class RemoteScanBeforePictViewController;

@interface RSS_OtherViewController : PickerViewController // UIViewController <UIPopoverControllerDelegate>
{
    RemoteScanBeforePictViewController* __unsafe_unretained parentVCDelegate;
    
    IBOutlet UITableView *otherTableView;
    
    NSMutableArray* tableSectionIDs;
    
    NSMutableArray* colorDepthList;
    NSArray* blankPageProcessList;
    NSArray* blankPageProcessDetailList;
    
    NSInteger nSelectColorDepthIndexRow;
    int nSelectColorDepthLevelIndexRow;
    NSInteger nSelectBlankPageProcessIndexRow;
    
    UILabel* colorDepthLevelLbl;
    UISlider* colorDepthSld;
    UILabel* footerLbl;
    UILabel *multiCropFooterLbl;

   // UIPopoverController* m_popOver;
    NSInteger m_nSelPicker;
    
    BOOL bMultiCrop;
}

@property (nonatomic, unsafe_unretained) RemoteScanBeforePictViewController* parentVCDelegate;

- (id)initWithColorDepthArray:(NSArray*)cArray blankPageArray:(NSArray*)bArray delegate:(RemoteScanBeforePictViewController*)delegate;

@end
