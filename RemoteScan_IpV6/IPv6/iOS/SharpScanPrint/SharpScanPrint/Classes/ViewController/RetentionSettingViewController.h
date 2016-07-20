
#import <UIKit/UIKit.h>
#import "RetentionCell.h"
#import "RetentionSwitchDataCell.h"

@protocol RetentionSettingViewControllerDelegate
-(void) retentionSetting:(UIViewController*)viewController didCreatedSuccess:(BOOL)bSuccess;
@end

@interface RetentionSettingViewController : UITableViewController<UITextFieldDelegate,UITextViewDelegate, UINavigationControllerDelegate>
{
    NSObject <RetentionSettingViewControllerDelegate> *__unsafe_unretained delegate;

	// インスタンス変数宣言
    IBOutlet    RetentionSwitchDataCell		*noPrintCell;       // 印刷せずにホールド
    IBOutlet    RetentionSwitchDataCell		*authenticateCell;  // 認証
	IBOutlet	RetentionCell		*passwordCell;      // パスワード
    
    BOOL noPrintOn;                             // 印刷せずにホールドフラグ
    BOOL authenticateOn;                        // 認証フラグ
    NSString* pstrPassword;                     // パスワード
    NSMutableArray* tableSectionIDs;
    NSString *pstrErrMessage;
}

@property(nonatomic, unsafe_unretained) id delegate;
@property(nonatomic, strong) RetentionSwitchDataCell *noPrintCell;
@property(nonatomic, strong) RetentionSwitchDataCell *authenticateCell;
@property(nonatomic, strong) RetentionCell *passwordCell;
@property BOOL noPrintOn;
@property BOOL authenticateOn;
@property(nonatomic, copy) NSString* pstrPassword;

@end
