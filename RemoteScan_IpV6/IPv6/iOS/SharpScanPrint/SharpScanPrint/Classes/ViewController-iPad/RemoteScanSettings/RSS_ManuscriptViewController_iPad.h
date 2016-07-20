
#import <UIKit/UIKit.h>
#import "RSS_CustomSizeListViewController_iPad.h"

@class RemoteScanBeforePictViewController_iPad;

@interface RSS_ManuscriptViewController_iPad : UIViewController <UIPopoverControllerDelegate>
{
    RemoteScanBeforePictViewController_iPad* __unsafe_unretained parentVCDelegate;

    IBOutlet UITableView *manuscriptTableView;
    IBOutlet UISegmentedControl *scOrientation;
    
    NSUInteger m_nSelectedManuscriptSizeIndexRow;
    NSArray* manuscriptSizeList;          /** 原稿サイズのリスト*/
    NSUInteger m_nSelectedSaveSizeIndexRow;
    NSArray* saveSizeList;               /** 保存サイズのリスト　*/
    NSUInteger m_nSelectedManuscriptSetIndexRow;
    NSArray* manuscriptSetList;
    
    UIPopoverController* m_popOver;
    int m_nSelPicker;
    
    RSS_CustomSizeListViewController_iPad* childVC;
    
    NSString* strOriginalSize;
    
    UIImageView* manuscriptSetImageView;
    
    NSMutableArray * m_sections;                            // セクションデータ保持
}

@property (nonatomic, unsafe_unretained) RemoteScanBeforePictViewController_iPad* parentVCDelegate;
@property (nonatomic, strong) NSString* strOriginalSize;


- (id)initWithManuscriptTypeArray:(NSArray*)mArray saveSizeArray:(NSArray*)sArray delegate:(RemoteScanBeforePictViewController_iPad *)delegate;

// ポップオーバーを閉じる
-(void)popoverClose;

@end
