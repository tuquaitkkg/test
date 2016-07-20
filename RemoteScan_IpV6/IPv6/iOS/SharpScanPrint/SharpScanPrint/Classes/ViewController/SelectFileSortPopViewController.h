
#import <UIKit/UIKit.h>

@interface SelectFileSortPopViewController : UITableViewController  {
    UIViewController* delegate;
    NSMutableArray* sortMenuList;
    NSInteger nSelectResolutionIndexRow;
    UIBarButtonItem *cancelButtonItem;
}

@property(nonatomic, strong)    UIViewController* delegate;
@property(nonatomic, strong)    NSMutableArray* sortMenuList;
@property(nonatomic)            NSInteger nSelectResolutionIndexRow;
@property(nonatomic, strong)    UIBarButtonItem *cancelButtonItem;
- (void) createMenue;
@end
