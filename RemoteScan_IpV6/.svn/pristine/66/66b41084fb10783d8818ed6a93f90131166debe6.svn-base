
#import <UIKit/UIKit.h>

@protocol SettingSelMailDisplayTableViewControllerDelegate;

@interface SettingSelMailDisplaySettingTableViewController : UITableViewController

@property (nonatomic, strong) NSArray *dataArray;
@property (nonatomic, assign) NSInteger selectedType;
@property (nonatomic, assign) NSInteger selectedIndex;
@property (nonatomic, assign) id <SettingSelMailDisplayTableViewControllerDelegate> delegate;

- (void)popRootView;

@end

@protocol SettingSelMailDisplayTableViewControllerDelegate <NSObject>

- (void)callBackIndex:(SettingSelMailDisplaySettingTableViewController *)vc;

@end
