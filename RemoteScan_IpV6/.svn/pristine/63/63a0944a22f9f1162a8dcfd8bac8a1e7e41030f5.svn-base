
#import <UIKit/UIKit.h>

@class RemoteScanBeforePictViewController_iPad;

@interface RSS_OtherViewController_iPad : UIViewController<UIPopoverControllerDelegate>
{
    RemoteScanBeforePictViewController_iPad* __unsafe_unretained parentVCDelegate;
    
    IBOutlet UITableView *otherTableView;
    
    NSMutableArray* tableSectionIDs;

    NSMutableArray* colorDepthList;
    NSArray* blankPageProcessList;
    NSArray* blankPageProcessDetailList;
    
    NSUInteger nSelectColorDepthIndexRow;
    int nSelectColorDepthLevelIndexRow;
    NSUInteger nSelectBlankPageProcessIndexRow;

    UILabel* colorDepthLevelLbl;
    UISlider* colorDepthSld;
    UILabel* footerLbl;
    UILabel *multiCropFooterLbl;

    UIPopoverController* m_popOver;
    NSInteger m_nSelPicker;
    
    BOOL bMultiCrop;
}

@property (nonatomic, unsafe_unretained) RemoteScanBeforePictViewController_iPad* parentVCDelegate;

- (id)initWithColorDepthArray:(NSArray*)cArray blankPageArray:(NSArray*)bArray delegate:(RemoteScanBeforePictViewController_iPad*)delegate;

// ポップオーバーを閉じる
-(void)popoverClose;

@end
