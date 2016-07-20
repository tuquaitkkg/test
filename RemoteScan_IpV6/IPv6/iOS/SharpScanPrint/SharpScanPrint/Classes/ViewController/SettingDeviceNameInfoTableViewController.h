
#import <UIKit/UIKit.h>
#import "Define.h"
#import "ProfileDataManager.h"
#import "CommonManager.h"

@protocol SettingDeviceNameInfoTableViewControllerDelegate;

@interface SettingDeviceNameInfoTableViewController : UITableViewController

@property (nonatomic, strong) NSArray *dataArray;
//@property (nonatomic, assign) NSInteger selectedType;
@property (nonatomic, assign) NSInteger selectedIndex;
@property (nonatomic, assign) id <SettingDeviceNameInfoTableViewControllerDelegate> delegate;

- (void)popRootView;

@end

@protocol SettingDeviceNameInfoTableViewControllerDelegate <NSObject>

- (void)callBackIndex:(SettingDeviceNameInfoTableViewController *)vc;

@end