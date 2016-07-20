
#import <UIKit/UIKit.h>
#import "RSS_CustomSizeSettingViewController.h"
#import "Define.h"

@class RemoteScanBeforePictViewController;

@interface RSS_CustomSizeListViewController : UITableViewController //UIViewController
{
    RemoteScanBeforePictViewController* __unsafe_unretained parentVCDelegate;
    
    NSMutableArray* sizeList;
    
    RSS_CustomSizeSettingViewController* m_pCustomSizeSettingVC;
}

@property (nonatomic, unsafe_unretained) RemoteScanBeforePictViewController* parentVCDelegate;
@property (nonatomic, copy)		NSString		*baseDir;	// ホームディレクトリ/Documments/

- (void)setPortraitMenu:(UIBarButtonItem *)barButtonItem;
- (id)initWithStyle:(UITableViewStyle)style delegate:(RemoteScanBeforePictViewController *)delegate;

@end
