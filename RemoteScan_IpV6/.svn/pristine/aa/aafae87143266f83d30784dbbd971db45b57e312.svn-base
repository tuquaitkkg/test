
#import <UIKit/UIKit.h>
#import <MailCore/MailCore.h>
#import "ProfileDataManager.h"
#import "CommonManager.h"
#import "MailServerData.h"
#import "ProfileDataCell.h"
#import "SwitchDataCell.h"
#import "MailServerDataManager.h"
#import "SettingSelMailDisplaySettingTableViewController.h"

@interface SettingMailServerInfoViewController : UITableViewController<UITextFieldDelegate,UITextViewDelegate, UINavigationControllerDelegate, SettingSelMailDisplayTableViewControllerDelegate>
{
	// インスタンス変数宣言
	//
	IBOutlet	ProfileDataCell		*accountNameCell;       // ログイン名
	IBOutlet	ProfileDataCell		*accountPasswordCell;   // パスワード
	IBOutlet	ProfileDataCell		*hostNameCell;          // ホスト名(または,ipアドレス)
    IBOutlet    ProfileDataCell		*imapPortNoCell;        // ポート番号
    IBOutlet    SwitchDataCell		*SSLCell;               //　SSL
    IBOutlet    UITableViewCell     *serverConnectTestCell;  // メールサーバ接続テスト
    IBOutlet    ProfileDataCell		*getNumberCell;        // 取得件数
    IBOutlet    ProfileDataCell		*filterCell;        // フィルタ設定
    
    MailServerDataManager   *manager;                        // PROFILEデータ操作Manager
    CommonManager           *commanager;                     // 共通処理Manager
    
    NSString* defaultPortNoSslOn;                           // SSLオンのポート番号初期値
    NSString* defaultPortNoSslOff;                          // SSLオフのポート番号初期値
}

@property (nonatomic, strong) ProfileDataCell		*accountNameCell;      // ログイン名
@property (nonatomic, strong) ProfileDataCell		*accountPasswordCell;  // パスワード
@property (nonatomic, strong) ProfileDataCell		*hostNameCell;          // ホスト名(または,ipアドレス)
@property (nonatomic, strong) ProfileDataCell		*imapPortNoCell;        // ポート番号
@property (nonatomic, strong) SwitchDataCell		*SSLCell;               //　SSL
@property (nonatomic, strong) UITableViewCell		*serverConnectTestCell; // メールサーバ接続テスト
@property (nonatomic, strong) ProfileDataCell		*getNumberCell;        // 取得件数
@property (nonatomic, strong) ProfileDataCell		*filterCell;        // デフォルトのフィルタ設定

@property (nonatomic, assign) NSInteger getNumIndex;
@property (nonatomic, assign) NSInteger filterIndex;

//
// メソッドの宣言
//
- (IBAction)dosave:(id)sender;                          //保存ボタン処理
//
//// アラート表示
- (void)mailServerAlert:(NSString *)errTitle errMessage:(NSString *)errMessage;

- (void)popRootView;

@end
