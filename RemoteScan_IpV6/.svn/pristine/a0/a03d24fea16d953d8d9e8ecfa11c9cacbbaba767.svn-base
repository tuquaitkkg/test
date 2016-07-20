
#import <UIKit/UIKit.h>
#import "ScanBeforePictViewController.h"
#import "RSS_ColorModeViewController.h"
#import "RSS_ManuscriptViewController.h"
#import "RSS_CustomSizeListViewController.h"
#import "RSS_CustomSizeSettingViewController.h"
#import "RSS_BothOrOneSideViewController.h"
#import "RSS_FormatViewController.h"
#import "RSS_ResolutionViewController.h"
#import "RSS_OtherViewController.h"
#import "RSGetJobSettableElementsManager.h"
#import "RSRequestUISessionIdManager.h"
#import "RSSetDeviceContextManager.h"
#import "RSGetDeviceStatusManager.h"
#import "RSExecuteJobManager.h"
#import "RSGetJobStatusManager.h"
#import "RSReleaseUISessionIdManager.h"
#import "RSCancelJobManager.h"
#import "RSResumeJobManager.h"
#import "TempFile.h"
#import "TempFileUtility.h"
#import "RemoteScanSettingViewData.h"

#import "FtpServerManager.h"

#import "RSmfpifManager.h"
#import "RSmfpifServiceManager.h"
#import "ExAlertController.h"

#define MAXPROFILENAMELENGTH 32   // for shorten strProfileName

enum{
    ALERT_TAG_REMOTE_CHECK = 94,
    ALERT_TAG_REMOTE_Result = 95,
    ALERT_TAG_SCANBEFORE = 99,
    ALERT_TAG_SCANPROGRESS = 10,
    ALERT_TAG_FAILED_REQUESTUISESSIONID = 98,
    ALERT_TAG_FAILED_GETJOBSETTABLEELEMENTS = 97,
    ALERT_TAG_JAMMING = 96,
    
    ALERT_TAG_WIFI_NO_CONNECTION = 200,
    ALERT_TAG_SCAN_FAILED,
    ALERT_TAG_NOT_SUPPORTED,
    ALERT_TAG_NOT_SUPPORTED_AND_STOP,
    ALERT_TAG_RESOURCE_NOT_FOUND,
    ALERT_TAG_ORIGINAL_NOT_DETECTED,
    ALERT_TAG_ORIGINAL_NOT_DETECTED_EXECUTE,
    ALERT_TAG_WAIT,
    ALERT_TAG_RSSETDEVICECONTEXTMANAGER_ERROR,
    ALERT_TAG_NETWORKERROR_AND_EXIT,
    ALERT_TAG_SETDEVICECONTEXT_WAIT,
    ALERT_TAG_EXECUTEJOB_ACCESSDENIED,
    ALERT_TAG_GETDEVICESTATUS_FAILED,
};

enum{
    RSSTATUS,
    RSSTATUS_INIT,
    RSSTATUS_GETJOBSETTABLEELEMENTS,
    RSSTATUS_GETDEVICESTATUS,
    RSSTATUS_REQUESTUISESSIONID,
    RSSTATUS_SETDEVICECONTEXT_START,
    RSSTATUS_SETDEVICECONTEXT_END,
    RSSTATUS_SETDEVICECONTEXT_RETRY,
    RSSTATUS_SETDEVICECONTEXT_WAIT,
    RSSTATUS_EXECUTEJOB,
    RSSTATUS_EXECUTEJOB_COMPLETE,
    RSSTATUS_EXECUTEJOB_CANCELED,
    RSSTATUS_EXECUTEJOB_CANCELING,
    RSSTATUS_EXECUTEJOB_JAMMING,
    RSSTATUS_EXECUTEJOB_JAMMED,
    RSSTATUS_GETJOBSTATUS,
    RSSTATUS_CANCELJOB,
    RSSTATUS_RESUMEJOB,
    RSSTATUS_RELEASEUISESSIONID,
};

@interface RemoteScanBeforePictViewController : ScanBeforePictViewController<RSManagerDelegate, RSGetJobStatusManagerDelegate,UIScrollViewDelegate>
{
    RSS_ColorModeViewController* m_pColorModeVC;
    RSS_ManuscriptViewController* m_pManuscriptVC;
    RSS_CustomSizeListViewController* m_pCustomSizeListVC;
    RSS_BothOrOneSideViewController* m_pBothOrOneSideVC;
    RSS_FormatViewController* m_pFormatVC;
    RSS_ResolutionViewController* m_pResolutionVC;
    RSS_OtherViewController* m_pOtherVC;
    
    RemoteScanSettingViewData* rssViewData;

    RSGetJobSettableElementsManager* rsManager;
    RSGetDeviceStatusManager* pollingRsManager;
    RSReleaseUISessionIdManager* releaseUISessionIdManager;
    RSRequestUISessionIdManager* requestUISessionIdManager;
    RSSetDeviceContextManager* setDeviceContextManager;
    RSExecuteJobManager* executeJobManager;
    RSGetJobStatusManager* getJobStatusManager;
    RSCancelJobManager* cancelJobManager;
    RSResumeJobManager* resumeJobManager;

    IBOutlet UIView *settingView;
    IBOutlet UIScrollView *menuScrollView;
    IBOutlet UIButton *menuUpBtn;
    IBOutlet UIButton *menuDownBtn;
    UIViewController* selectedVC;
    
    NSString* strVKey;
    
    BOOL bRemoteScanRunning;
    BOOL bShowingManuscriptDialog;
    BOOL bRemoteScanCanceled;
    BOOL bSetPaper;
    NSURL* connectUrl;
    NSString* sessionId;
    BOOL bScreenLock;
    NSString* jobId;
    BOOL bIsJamHassei;
    BOOL bIsJamKaisho;
//    BOOL bChangeSelectMfp;
//    BOOL bDoReset;
    BOOL bDoReleaseUiSessionId;
    
    int nStatus;
    int nSetDeviceRetryCount;
    
    NSString* strOriginalSize;
    NSTimer* originalSizePollingTimer;
    NSTimer* cancelJobWaitTimer;
        
    NSString* strProfileName;
    NSString* strVerifyCode;
    
    UIImageView* fukidashiView;

    // 初回エラーフラグ
    BOOL bFirstErr_Network;
    
//    BOOL bDoGetJobSettableElements;
//    BOOL bDoRetryExecuteJob;      // ExecuteJobで一回目Vkeyエラーの場合のみ、RequestUISessionIDを繰り返す機能の制御を行う為のフラグ
    BOOL bFeederSize;
    BOOL bPlatenSize;
    
    UIBackgroundTaskIdentifier bgTask; // バックグラウンド実行タスク
    
    NSString* pstrDetectableMinWidth;  // GetDeviceStatusで取得したminWidth
    NSString* pstrDetectableMinHeight; // GetDeviceStatusで取得したminHeight
    
    PrinterData* m_pPrinterInfo;            // プリンタ情報
    RSmfpifManager* mfpManager;
    RSmfpifServiceManager* mfpServiceManager;

}

@property (nonatomic, readonly) RSGetJobSettableElementsManager* rsManager;

@property (nonatomic, strong) RemoteScanSettingViewData* rssViewData;

@property (nonatomic)			int createCacheCount; // キャッシュ作成完了確認用（0なら完了）

// 設定情報の更新
//-(void)updateSetting;

#pragma mark - Manuscript Setting Manage
//- (void) setBarBtnWithTitle:(NSString*)title target:(id)target action:(SEL)action isLeft:(BOOL)isLeft;
//- (void) setNavigationBarTitle:(NSString*)title leftButton:(UIBarButtonItem*)leftBtn rightButton:(UIBarButtonItem*)rightBtn;

//- (void)createConnectUrl_ph;
//- (void)rsGetJobSettableElements;
//- (void)didFinishRSGetJobSettableElementsManagerParsing;

#pragma mark - Manuscript Setting Manage
- (void) setBarBtnWithTitle:(NSString*)title target:(id)target action:(SEL)action isLeft:(BOOL)isLeft;
- (void) setNavigationBarTitle:(NSString*)title leftButton:(UIBarButtonItem*)leftBtn rightButton:(UIBarButtonItem*)rightBtn;

// 設定情報の更新
-(void)updateSetting;
// カスタムサイズリスト
- (void)OnCustomSizeList;
//// 多言語対応文言の取得
//-(NSString*)replaceRSStr:(NSString*)str;

-(void)createConnectUrl;

-(void)rsRequestUISessionId;
-(void)rsReleaseUISessionId;
-(void)rsGetDeviceStatus;
-(void)rsGetJobSettableElements;
-(void)rsExecuteJob;
-(void)clearSettingView;
-(void)rsGetJobStatus;
-(void)rsFinish;
-(void)rsSetDeviceContextEnd;
-(void)rsSetDeviceContextStart;
-(void)didFinishRSGetJobSettableElementsManagerParsing;
-(void)rsSetDeviceContext:(BOOL)bScreenLockStart;
-(void)rsGetDeviceStatusPolling;
-(NSString*)vkey;
-(void)rsCancelJob;
-(void)rsResumeJob;
-(void)setAllButtonEnable:(BOOL) enable;
-(void)setFirstButtonEnable;
-(BOOL)isShowRemoteScanView;

// メニューをスクロールビュー内に再配置する
-(void)replaceMenuButton:(NSInteger)menuId;
// Picker選択値設定
-(void)setPickerValue;

#pragma mark Notifi Result
- (void)FtpReceiveResponceNotification :(NSNotification *)aNotification;

-(void)reloadRemoteScanView;
// バックグラウンドになった時に実行
- (void)DidBackgroundEnter;
// バックグラウンドから復帰した時に実行
- (void)WillForegroundEnter;
// バックグラウンド処理が終わった時に呼び出す
-(void)EndBackgroundTask;
@end
