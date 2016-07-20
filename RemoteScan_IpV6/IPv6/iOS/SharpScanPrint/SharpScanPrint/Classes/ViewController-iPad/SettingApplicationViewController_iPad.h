
#import <UIKit/UIKit.h>
#import "ProfileDataManager.h"
#import "CommonManager.h"
#import "ProfileDataCell.h"
#import "ProfileDataCellMulti.h"
#import "SwitchDataCell.h"
#import "DetailTextLabelCell.h"
#import "SettingDeviceNameInfoTableViewController.h"

// iPad用
@protocol UpdateSettingApplicationViewController
- (void)popRootView;
- (void)setPortraitMenu:(UIBarButtonItem *)barButtonItem;
@end
// iPad用

@interface SettingApplicationViewController_iPad : UITableViewController <UITextFieldDelegate,UITextViewDelegate, UINavigationControllerDelegate, SettingDeviceNameInfoTableViewControllerDelegate>{
    // iPad用
    
    //
    // インスタンス変数宣言
    //
    IBOutlet	SwitchDataCell		*delmodeCell;        // プロファイル消さないモード
    IBOutlet	SwitchDataCell		*modifymodeCell;     // プロファイル強制上書き
    IBOutlet    SwitchDataCell		*saveExSiteFileCell; // 他アプリから受けたファイルを残す
    IBOutlet    SwitchDataCell		*autoSelectCell;     // このプリンター/スキャナーを選択
    IBOutlet    SwitchDataCell		*highQualityCell;    // 高品質で印刷する
    IBOutlet    SwitchDataCell      *updateSelectCell;   // 選択プリンター/スキャナーの更新
    IBOutlet    SwitchDataCell      *useRawPrintCell;    // 印刷にRawプリントを使用する
    IBOutlet    SwitchDataCell      *savePrintSettingCell;    // 印刷設定を記憶する
    IBOutlet    SwitchDataCell      *snmpSearchPublic;   // publicで検索する
    IBOutlet    ProfileDataCellMulti     *snmpCommunityString; // Community String
    IBOutlet    DetailTextLabelCell		*retentionCell;        // リテンション
    IBOutlet    DetailTextLabelCell		*deviceNameCell;       // プリンター/スキャナーの名称
    IBOutlet    ProfileDataCell		*jobTimeOutCell;     // ジョブ送信のタイムアウト(秒)
    
    NSString *defaultJobTimeOut;    // ジョブ送信のタイムアウト(秒)の初期値

    ProfileDataManager	*manager;                        // PROFILEデータ操作Manager
    CommonManager		*commanager;                     // 共通処理Manager
    
    NSInteger m_nDeviceNameStyle;
}

//
// プロパティの宣言
//
@property (nonatomic, strong) SwitchDataCell		*delmodeCell;        // プロファイル消さない
@property (nonatomic, strong) SwitchDataCell		*modifymodeCell;	 // プロファイル上書き
@property (nonatomic, strong) SwitchDataCell		*saveExSiteFileCell; // 他アプリから受けたファイルを残す
@property (nonatomic, strong) SwitchDataCell		*autoSelectCell;	 // このプリンター/スキャナーを選択
@property (nonatomic, strong) SwitchDataCell		*highQualityCell;	 // 高品質で印刷する
@property (nonatomic, strong) SwitchDataCell		*updateSelectCell;	 // 選択プリンター/スキャナーの更新
@property (nonatomic, strong) SwitchDataCell		*useRawPrintCell;	 // 印刷にRawプリントを使用する
@property (nonatomic, strong) SwitchDataCell		*savePrintSettingCell;	 // 印刷設定を記憶する
@property (nonatomic, strong) SwitchDataCell        *snmpSearchPublic;   // publicで検索する
@property (nonatomic, strong) ProfileDataCellMulti       *snmpCommunityString; // Community String
@property (nonatomic, strong) DetailTextLabelCell	*retentionCell;        // リテンション
@property (nonatomic, strong) DetailTextLabelCell	*deviceNameCell;       // プリンター/スキャナーの名称
@property (nonatomic, strong) ProfileDataCell		*jobTimeOutCell;       // ジョブ送信のタイムアウト(秒)

@property (nonatomic, assign) NSInteger deviceNameIndex;

//
// メソッドの宣言
//
- (BOOL)profileChk:	     (ProfileData *)pData;		// 入力チェック
- (IBAction)dosave:(id)sender;                      //保存ボタン処理

// アラート表示
- (void)profileAlert:(NSString *)errTitle errMessage:(NSString *)errMessage;

- (void)setPortraitMenu:(UIBarButtonItem *)barButtonItem;

- (void)popRootView;

@end
