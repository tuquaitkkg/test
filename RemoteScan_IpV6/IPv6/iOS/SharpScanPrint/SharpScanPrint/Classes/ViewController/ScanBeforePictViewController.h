
#import <UIKit/UIKit.h>
#import <Foundation/NSObject.h>

#import "TempDataManager.h"
#import "FtpServerManager.h"
#import "HttpManeger.h"
#import "HttpLegacyManeger.h"
#import "CommonManager.h"
#import "ScanBeforePictViewController.h"
#import "PictureViewController.h"
#import "ProfileDataManager.h"
#import "PrinterDataManager.h"
#import "PrintOutDataManager.h"
#import "TempFile.h"
#import "TempFileUtility.h"
#import "ExAlertController.h"

#define DELEY_TIME_1	1							// プロファイルの削除の delay 1秒
#define DELEY_TIME_2	2							// プロファイルの削除の delay 2秒
#define DELEY_TIME_5	5							// プロファイルの削除の delay 5秒


@interface ScanBeforePictViewController : PictureViewController
{
    CommonManager			*commanager;				// 共通処理Manager
    FtpServerManager		*ftpmanager;				// FTP 操作Manager
    HttpManeger				*httpMgr;					// HTTP操作Manager
    HttpLegacyManeger       *httpLegacyMgr;             // HTTP操作Manager(レガシー)
    ExAlertController		*ex_alert;					// メッセージ表示
    NSString				*baseDir;					// ホームディレクトリ/Documments/
    NSString				*ScanFileName;				// スキャンファイル名称
    NSString				*iPaddr;					// IPアドレス
    NSString				*mfp_iPaddr;				// mfp IPアドレス
    ProfileDataManager      *profileDataManager;
    NSInteger				selectInd;					// 選択位置
    PrinterDataManager*     m_pPrinterMgr;              // PrinterDataManagerクラス
    PrintOutDataManager*    m_pPrintOutMgr;             // PrintOutDataManagerクラス
    NSString                *selectMfpIpAddress;        // 選択中MFPのIPアドレス
    NSString                *selectMfpRSPortNo;         // 選択中MFPのリモートスキャンで使用するポート番号
    
    BOOL                    m_IsDelProfile;
    BOOL                    m_IsModProfile;
    BOOL                    m_IsRecComp;
    BOOL                    m_isScanStop;
    
    NSString                *m_ScanUser;
    NSString                *m_ScanPass;
    
    UILabel                 *lblProfilaName;
    UILabel                 *lblSearch;
    
    NSInteger               scanerPickerRow;            //
    UIView                  *remoteSwitchBaseView;      // リモートスキャン切替スイッチを配置するビュー
    UILabel                 *remoteSwitchLbl;           //リモートスキャン切替スイッチのラベル
    UISwitch                *remoteSwt;                 //リモートスキャン切替スイッチ
//    BOOL                    bRemoteSwitchTap;
    
    NSString* selectedPrinterPrimaryKey;
}
@property (nonatomic, copy)		NSString			*baseDir;		// ホームディレクトリ/Documments/
@property (nonatomic, copy)		NSString			*ScanFileName;	// スキャンファイル名称
@property (nonatomic, copy)		NSString			*iPaddr;		// IPアドレス
@property (nonatomic, copy)		NSString			*mfp_iPaddr;	// mfp IPアドレス
@property (nonatomic)			NSInteger			selectInd;		// 選択位置
@property (nonatomic)           BOOL                isDelProfile;   // プロファイル削除フラグ
@property (nonatomic)           BOOL                isModProfile;   // プロファイル更新フラグ
@property (nonatomic)           BOOL                isRecComp;      // 完了フラグ
@property (nonatomic,copy)      NSString            *ScanUser;
@property (nonatomic,copy)      NSString            *ScanPass;
@property (nonatomic)           NSInteger                 scanerPickerRow;
//@property (nonatomic)           BOOL                bRemoteSwitchTap;      // リモート切り替えスイッチ押下フラグ
@property (nonatomic)           BOOL                isRemoteScan;      // 完了フラグ

@property (nonatomic,strong) NSString* selectedPrinterPrimaryKey;

- (void)addPost:(int) userAuthentication;							// HTTP POST 送信(登録)
- (void)modPost;													// HTTP POST 送信(更新)
- (void)delPost:(uint)delayTime;									// HTTP POST 送信(削除)

- (BOOL)startFTP;													// FTP 開始

#pragma mark Notifi Result
- (void)FtpReceiveResponceNotification :(NSNotification *)aNotification;

- (void)HttpAddResponceNotification    :(NSNotification *)aNotification;	// 通知：プロファイル登録
- (void)HttpModResponceNotification    :(NSNotification *)aNotification;	// 通知：プロファイル更新
- (void)HttpDelResponceNotification    :(NSNotification *)aNotification;	// 通知：プロファイル削除
- (void)HttpInternalErrorNotification  :(NSNotification *)aNotification;	// 通知：ネットワークエラー
// アラートボタン押下処理
-(void)alertButtonPushed:(UIAlertController *)alertController tagIndex:(NSInteger)tagIndex buttonIndex:(NSInteger)buttonIndex;

- (void)CreateCompleteAlert;

// tag固定
- (void) createProgressionAlertWithMessage:(NSString *)titles message:(NSString *)messages withCancel:(BOOL)cancel;
// tag指定
- (void) createProgressionAlertWithMessage:(NSString *)titles message:(NSString *)messages withCancel:(BOOL)cancel tag:(NSInteger)tag;

- (IBAction)tapRemoteSwt:(UISwitch*)sender;
// リモートスキャンに切り替える
-(void)nomalScanToRemoteScan;
// Picker選択値設定
-(void)setPickerValue;

@end
