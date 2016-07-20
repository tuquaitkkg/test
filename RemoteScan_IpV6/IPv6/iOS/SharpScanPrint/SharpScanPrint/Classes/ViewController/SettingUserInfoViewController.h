
#import <UIKit/UIKit.h>
#import "ProfileDataManager.h"
#import "CommonManager.h"
#import "ProfileDataCell.h"
#import "SwitchDataCell.h"

@interface SettingUserInfoViewController : UITableViewController <UITextFieldDelegate>{
    
    //
	// インスタンス変数宣言
	//
	IBOutlet	ProfileDataCell		*nameCell;           // 表示名
	IBOutlet	ProfileDataCell		*sercCell;           // 検索文字列
	IBOutlet	ProfileDataCell		*ipaddCell;          // ipアドレス
    IBOutlet    ProfileDataCell     *loginNameCell;      // ログイン名
    IBOutlet    ProfileDataCell     *loginPasswordCell;  // パスワード
    
    ProfileDataManager	*manager;                        // PROFILEデータ操作Manager
    CommonManager		*commanager;                     // 共通処理Manager
    
    NSInteger m_nUserAuthStyle;
    NSMutableArray* tableSectionIDs;
    
}

//
// プロパティの宣言
//
@property (nonatomic, strong) ProfileDataCell		*nameCell;           // 表示名
@property (nonatomic, strong) ProfileDataCell		*sercCell;           // 検索文字列
@property (nonatomic, strong) ProfileDataCell		*ipaddCell;          // ipアドレス
@property (nonatomic, strong) ProfileDataCell		*loginNameCell;      // ログイン名
@property (nonatomic, strong) ProfileDataCell		*loginPasswordCell;  // パスワード
@property (nonatomic, strong) ProfileDataCell		*userNoCell;         // ユーザー番号
@property (nonatomic, strong) ProfileDataCell		*userNameCell;       // ユーザー名
@property (nonatomic, strong) ProfileDataCell		*jobNameCell;        // ジョブ名
@property (nonatomic, strong) SwitchDataCell        *useLoginNameForUserName;

//
// メソッドの宣言
//
- (BOOL)profileChk:	     (ProfileData *)pData;		// 入力チェック
- (IBAction)dosave:(id)sender;                      //保存ボタン処理

// アラート表示
- (void)profileAlert:(NSString *)errTitle errMessage:(NSString *)errMessage;
@end
