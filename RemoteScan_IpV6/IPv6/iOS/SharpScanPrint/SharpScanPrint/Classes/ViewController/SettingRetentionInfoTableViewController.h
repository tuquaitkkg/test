
#import <UIKit/UIKit.h>
#import "ProfileDataManager.h"
#import "CommonManager.h"
#import "ProfileDataCell.h"
#import "SwitchDataCell.h"

@interface SettingRetentionInfoTableViewController : UITableViewController<UITextFieldDelegate>{
    
    //
    // インスタンス変数宣言
    //
    IBOutlet    SwitchDataCell      *noPrintCell;            // 印刷せずにホールド
    IBOutlet    SwitchDataCell      *retentionAuthCell;      // 認証(リテンション)
    IBOutlet    ProfileDataCell     *retentionPasswordCell;  // パスワード(リテンション)
    
    ProfileDataManager  *manager;                        // PROFILEデータ操作Manager
    CommonManager       *commanager;                     // 共通処理Manager
    
    BOOL noPrintOn;                             // 印刷せずにホールドフラグ
    BOOL authenticateOn;                        // 認証フラグ
    NSString* pstrPassword;                     // パスワード
}

//
// プロパティの宣言
//
@property (nonatomic, strong) SwitchDataCell        *noPrintCell;            // 印刷せずにホールド
@property (nonatomic, strong) SwitchDataCell        *retentionAuthCell;      // 認証(リテンション)
@property (nonatomic, strong) ProfileDataCell       *retentionPasswordCell;  // パスワード(リテンション)
@property BOOL noPrintOn;
@property BOOL authenticateOn;
@property(nonatomic, copy) NSString* pstrPassword;

- (void)popRootView;

@end
