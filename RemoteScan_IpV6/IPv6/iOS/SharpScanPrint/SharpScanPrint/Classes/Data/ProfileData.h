#import <Foundation/Foundation.h>


@interface ProfileData : NSObject
{
	//
	// インスタンス変数宣言
	//
	NSString	*profileName;						// 表示名
    NSString	*serchString;						// 検索文字列
	BOOL        m_delMode;                          // 消さない
	BOOL        m_modifyMode;                       // 強制上書き
	BOOL        m_saveExSiteFileMode;               // 他アプリから受けたファイルを残す
	BOOL        m_autoSelectMode;                   // このプリンター/スキャナーを選択
	BOOL        m_highQualityMode;                   // 高品質で印刷する
    BOOL        m_useRawPrintMode;                  // 印刷にRawプリントを使用する
    int         m_deviceNameStyle;                  // 自動検出デバイス名のスタイル
    NSString    *loginName;                         // ログイン名
    NSString    *loginPassword;                     // パスワード
    BOOL        m_snmpSearchPublicMode;             // publicで検索する
    NSString    *snmpCommunityString;               // Community String
    
    BOOL        m_configScannerSetting;             // 端末側でスキャナーを設定する（リモートスキャンのON/OFF）
    
    BOOL        autoCreateVerifyCode;              // 確認コード自動生成フラグ
    NSString    *verifyCode;                        // 確認コード
    
    NSString    *rsCustomSize0;                   // リモートスキャン カスタムサイズ設定 0
    NSString    *rsCustomSize1;                   // リモートスキャン カスタムサイズ設定 1
    NSString    *rsCustomSize2;                   // リモートスキャン カスタムサイズ設定 2
    NSString    *rsCustomSize3;                   // リモートスキャン カスタムサイズ設定 3
    NSString    *rsCustomSize4;                   // リモートスキャン カスタムサイズ設定 4
    
    NSString	*jobTimeOut;						// ジョブ送信のタイムアウト(秒)
}

//
// プロパティの宣言
//
@property (nonatomic, copy) NSString *profileName;	// 表示名
@property (nonatomic, copy) NSString *serchString;	// 検索文字列
@property (nonatomic) BOOL delMode;                 // 消さない
@property (nonatomic) BOOL modifyMode;              // 強制上書き    
@property (nonatomic) BOOL saveExSiteFileMode;		// 他アプリから受けたファイルを残す
@property (nonatomic) BOOL autoSelectMode;          // このプリンター/スキャナーを選択
@property (nonatomic) BOOL highQualityMode;         // 高品質で印刷する
@property (nonatomic) BOOL useRawPrintMode;         // 印刷にRawプリントを使用する
@property (nonatomic) NSInteger deviceNameStyle;    // 自動検出デバイス名のスタイル
@property (nonatomic) NSInteger userAuthStyle;      // ユーザー認証のスタイル
@property (nonatomic, copy) NSString *loginName;	// ログイン名
@property (nonatomic, copy) NSString *loginPassword;	// パスワード
@property (nonatomic, copy) NSString *userNo;	    // ユーザー番号
@property (nonatomic, copy) NSString *userName;	    // ユーザー名
@property (nonatomic, copy) NSString *jobName;	    // ジョブ名
@property (nonatomic)       BOOL      bUseLoginNameForUserName;
@property (nonatomic) BOOL snmpSearchPublicMode;    // publicで検索する
@property (nonatomic, copy) NSString *snmpCommunityString; // Community String

@property (nonatomic) BOOL configScannerSetting;    // 端末側でスキャナーを設定する（リモートスキャンのON/OFF）
@property (nonatomic) BOOL autoCreateVerifyCode;    // 確認コード自動生成フラグ
@property (nonatomic, copy) NSString *verifyCode;                   // 確認コード

@property (nonatomic, copy) NSString *rsCustomSize0;                   // リモートスキャン カスタムサイズ設定 0
@property (nonatomic, copy) NSString *rsCustomSize1;                   // リモートスキャン カスタムサイズ設定 1
@property (nonatomic, copy) NSString *rsCustomSize2;                   // リモートスキャン カスタムサイズ設定 2
@property (nonatomic, copy) NSString *rsCustomSize3;                   // リモートスキャン カスタムサイズ設定 3
@property (nonatomic, copy) NSString *rsCustomSize4;                   // リモートスキャン カスタムサイズ設定 4

@property (nonatomic, copy) NSString *jobTimeOut;                       // ジョブ送信のタイムアウト(秒)

@property (nonatomic) BOOL noPrint;                        // 印刷せずにホールド
@property (nonatomic) BOOL retentionAuth;                  // 認証(リテンション)
@property (nonatomic, copy) NSString *retentionPassword;   // パスワード

@end
