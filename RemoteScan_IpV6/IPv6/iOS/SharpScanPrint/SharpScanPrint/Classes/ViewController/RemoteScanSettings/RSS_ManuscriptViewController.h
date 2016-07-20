
#import <UIKit/UIKit.h>
#import "RSS_CustomSizeListViewController.h"
#import "PickerViewController.h"
@class RemoteScanBeforePictViewController;

@interface RSS_ManuscriptViewController : PickerViewController//UIViewController <UIPopoverControllerDelegate>
{
    RemoteScanBeforePictViewController* __unsafe_unretained parentVCDelegate;
    
    IBOutlet UITableView *manuscriptTableView;
    IBOutlet UISegmentedControl *scOrientation;
    
    NSUInteger m_nSelectedManuscriptSizeIndexRow;
    NSArray* manuscriptSizeList;
    NSUInteger m_nSelectedSaveSizeIndexRow;
    NSArray* saveSizeList;
    NSUInteger m_nSelectedManuscriptSetIndexRow;
    NSArray* manuscriptSetList;
    
    UIPopoverController* m_popOver;
    int m_nSelPicker;
    
    RSS_CustomSizeListViewController* childVC;
    
    NSString* strOriginalSize;
    
    UIImageView* manuscriptSetImageView;
    
    NSMutableArray * m_sections;                            // セクションデータ保持
}

@property (nonatomic, unsafe_unretained) RemoteScanBeforePictViewController* parentVCDelegate;
@property (nonatomic, strong) NSString* strOriginalSize;


- (id)initWithManuscriptTypeArray:(NSArray*)mArray saveSizeArray:(NSArray*)sArray delegate:(RemoteScanBeforePictViewController *)delegate;
-(void)setScOrientation;
@end
