
#import <UIKit/UIKit.h>
// iPad用
@protocol UpdateSettingSelInfoViewController
- (void)updateView:(UIViewController*) pViewController;
- (void)popRootView;
- (void)setPortraitMenu:(UIBarButtonItem *)barButtonItem;
@end
// iPad用
// iPad用
//@interface SettingSelInfoViewController : UITableViewController
@interface SettingSelInfoViewController_iPad : UITableViewController <UINavigationControllerDelegate, UpdateSettingSelInfoViewController>
// iPad用
{
}

@property(nonatomic, strong) NSIndexPath* selectIndexPath; // iPad用 選択行
@property(nonatomic) BOOL m_bVisibleMenuButton; // 縦表示時のメニューボタン表示フラグ
@property BOOL modalPresented;//!< モーダル表示されたかどうかを示すフラグ。　モーダル表示ならYES

// 画面遷移
- (void)MoveView:(NSIndexPath *)nIndexPath;

- (void)ChangeView:(UITableViewController *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath; // iPad用
- (void) dismissMenuPopOver:(BOOL)bAnimated;

@end
