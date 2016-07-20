
#import <UIKit/UIKit.h>

@interface SelectFileSortPopViewController_ipad : UITableViewController{
    UIViewController* delegate;
//    UITableViewController* sortMenu;
    NSMutableArray* sortMenuList;
    NSInteger nSelectResolutionIndexRow;
}

@property(nonatomic, strong)    UIViewController* delegate;
//@property(nonatomic, retain)    UITableViewController* sortMenu;
@property(nonatomic, strong)    NSMutableArray* sortMenuList;
@property(nonatomic)            NSInteger nSelectResolutionIndexRow;

- (void) changeSortType: (UIButton*) button;
- (void) createMenue;
@end
