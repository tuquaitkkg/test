
#import <UIKit/UIKit.h>
#import "RSS_CustomSizeSettingViewController_iPad.h"
#import "Define.h"

@class RemoteScanBeforePictViewController_iPad;

@interface RSS_CustomSizeListViewController_iPad : UITableViewController //UIViewController
{
    RemoteScanBeforePictViewController_iPad* __unsafe_unretained parentVCDelegate;

//    IBOutlet UITableView *customSizeListTableView;
    NSMutableArray* sizeList;

    RSS_CustomSizeSettingViewController_iPad* m_pCustomSizeSettingVC;
}

@property (nonatomic, unsafe_unretained) RemoteScanBeforePictViewController_iPad* parentVCDelegate;
@property (nonatomic, copy)		NSString		*baseDir;	// ホームディレクトリ/Documments/

- (void)setPortraitMenu:(UIBarButtonItem *)barButtonItem;
- (id)initWithStyle:(UITableViewStyle)style delegate:(RemoteScanBeforePictViewController_iPad *)delegate;

@end
