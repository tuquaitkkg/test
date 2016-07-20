
#import <UIKit/UIKit.h>

@protocol OptionValueChangedDelegate;

@interface OptionChangeTableViewController : UITableViewController

@property (nonatomic,assign) id <OptionValueChangedDelegate> delegate;
@property (nonatomic,assign) NSInteger type;
@property (nonatomic,assign) NSInteger selectedIndex;
@property (nonatomic,strong) NSArray *dataArray;

- (id)initWithType:(NSInteger)type withIndex:(NSInteger)index;
- (void)cancel;
- (void)change;
@end

@protocol OptionValueChangedDelegate
- (void)cancelBtnPushed;
- (void)mailNumChanged:(NSInteger)value;
- (void)filterChanged:(NSInteger)value;
@end