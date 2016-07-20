
#import "ScanBeforePictViewController_iPad.h"
#import "RSS_ColorModeViewController_iPad.h"
#import "RSS_ManuscriptViewController_iPad.h"
#import "RSS_CustomSizeListViewController_iPad.h"
#import "RSS_CustomSizeSettingViewController_iPad.h"
#import "RSS_BothOrOneSideViewController_iPad.h"
#import "RSS_FormatViewController_iPad.h"
#import "RSS_ResolutionViewController_iPad.h"
#import "RSS_OtherViewController_iPad.h"
#import "RSGetJobSettableElementsManager.h"
#import "RSRequestUISessionIdManager.h"
#import "RSGetJobSettableElementsManager.h"
#import "RSSetDeviceContextManager.h"
#import "RSGetDeviceStatusManager.h"
#import "RSExecuteJobManager.h"
#import "RSGetJobStatusManager.h"
#import "RSReleaseUISessionIdManager.h"
#import "RSCancelJobManager.h"
#import "RSResumeJobManager.h"
#import "CommonUtil.h"
#import "TempFile.h"
#import "TempFileUtility.h"
#import "RemoteScanSettingViewData.h"

#import "FtpServerManager.h"

#import "RSmfpifManager.h"
#import "RSmfpifServiceManager.h"

#define MAXPROFILENAMELENGTH 32   // for shorten strProfileName

enum{
    ALERT_TAG_REMOTE_CHECK_IPAD = 94,
    ALERT_TAG_REMOTE_Result_IPAD = 95,
    ALERT_TAG_SCANBEFORE_IPAD= 99,
    ALERT_TAG_SCANPROGRESS_IPAD = 10,
    ALERT_TAG_FAILED_REQUESTUISESSIONID_IPAD = 98,
    ALERT_TAG_FAILED_GETJOBSETTABLEELEMENTS_IPAD = 97,
    ALERT_TAG_JAMMING_IPAD = 96,

    ALERT_TAG_WIFI_NO_CONNECTION_IPAD = 200,
    ALERT_TAG_SCAN_FAILED_IPAD,
    ALERT_TAG_NOT_SUPPORTED_IPAD,
    ALERT_TAG_NOT_SUPPORTED_AND_STOP_IPAD,
    ALERT_TAG_RESOURCE_NOT_FOUND_IPAD,
    ALERT_TAG_ORIGINAL_NOT_DETECTED_IPAD,
    ALERT_TAG_ORIGINAL_NOT_DETECTED_EXECUTE_IPAD,
    ALERT_TAG_WAIT_IPAD,
    ALERT_TAG_RSSETDEVICECONTEXTMANAGER_ERROR_IPAD,
    ALERT_TAG_NETWORKERROR_AND_EXIT_IPAD,
    ALERT_TAG_SETDEVICECONTEXT_WAIT_IPAD,
    ALERT_TAG_EXECUTEJOB_ACCESSDENIED_IPAD,
    ALERT_TAG_GETDEVICESTATUS_FAILED_IPAD,
};

enum{
    RSSTATUS_IPAD,
    RSSTATUS_INIT_IPAD,
    RSSTATUS_GETJOBSETTABLEELEMENTS_IPAD,
    RSSTATUS_GETDEVICESTATUS_IPAD,
    RSSTATUS_REQUESTUISESSIONID_IPAD,
    RSSTATUS_SETDEVICECONTEXT_START_IPAD,
    RSSTATUS_SETDEVICECONTEXT_END_IPAD,
    RSSTATUS_SETDEVICECONTEXT_RETRY_IPAD,
    RSSTATUS_SETDEVICECONTEXT_WAIT_IPAD,
    RSSTATUS_EXECUTEJOB_IPAD,
    RSSTATUS_EXECUTEJOB_COMPLETE_IPAD,
    RSSTATUS_EXECUTEJOB_CANCELED_IPAD,
    RSSTATUS_EXECUTEJOB_CANCELING_IPAD,
    RSSTATUS_EXECUTEJOB_JAMMING_IPAD,
    RSSTATUS_EXECUTEJOB_JAMMED_IPAD,
    RSSTATUS_GETJOBSTATUS_IPAD,
    RSSTATUS_CANCELJOB_IPAD,
    RSSTATUS_RESUMEJOB_IPAD,
    RSSTATUS_RELEASEUISESSIONID_IPAD,
};


@interface RemoteScanBeforePictViewController_iPad : ScanBeforePictViewController_iPad <RSManagerDelegate, RSGetJobStatusManagerDelegate, UIScrollViewDelegate>
{
    RSS_ColorModeViewController_iPad* m_pColorModeVC;
    RSS_ManuscriptViewController_iPad* m_pManuscriptVC;
    RSS_CustomSizeListViewController_iPad* m_pCustomSizeListVC;
    RSS_BothOrOneSideViewController_iPad* m_pBothOrOneSideVC;
    RSS_FormatViewController_iPad* m_pFormatVC;
    RSS_ResolutionViewController_iPad* m_pResolutionVC;
    RSS_OtherViewController_iPad* m_pOtherVC;

    IBOutlet UIView *settingView;
    IBOutlet UIView *whiteView;
    IBOutlet UIScrollView *menuScrollView;
    IBOutlet UIButton *menuUpBtn;
    IBOutlet UIButton *menuDownBtn;
    UIViewController* selectedVC;
    
    RSGetJobSettableElementsManager* rsManager;
    RSGetDeviceStatusManager* pollingRsManager;
    RSReleaseUISessionIdManager* releaseUISessionIdManager;
    RSRequestUISessionIdManager* requestUISessionIdManager;
    RSSetDeviceContextManager* setDeviceContextManager;
    RSExecuteJobManager* executeJobManager;
    RSGetJobStatusManager* getJobStatusManager;
    RSCancelJobManager* cancelJobManager;
    RSResumeJobManager* resumeJobManager;
    
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
    
    int nStatus;
    int nSetDeviceRetryCount;

    NSString* strOriginalSize;
    NSTimer* originalSizePollingTimer;
    NSTimer* cancelJobWaitTimer;
    
    RemoteScanSettingViewData* rssViewData;
    
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

@property (unsafe_unretained, nonatomic, readonly) RSGetJobSettableElementsManager* rsManager;

@property (nonatomic, strong) RemoteScanSettingViewData* rssViewData;

@property (nonatomic)			int createCacheCount; // キャッシュ作成完了確認用（0なら完了）

#pragma mark - Manuscript Setting Manage
- (void) setBarBtnWithTitle:(NSString*)title target:(id)target action:(SEL)action isLeft:(BOOL)isLeft;
- (void) setNavigationBarTitle:(NSString*)title leftButton:(UIBarButtonItem*)leftBtn rightButton:(UIBarButtonItem*)rightBtn;

// 設定情報の更新
-(void)updateSetting;
-(void)updateBtnThirdSetting;
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
//-(void)setChangeSelectMfp:(BOOL) value;

#pragma mark - UIButton Action
- (IBAction)tapMenuUpBtn:(UIButton *)sender;
- (IBAction)tapMenuDownBtn:(UIButton *)sender;

#pragma mark Notifi Result
- (void)FtpReceiveResponceNotification :(NSNotification *)aNotification;

// ポップオーバーを閉じる
-(void)popoverClose;

// バックグラウンドになった時に実行
- (void)DidBackgroundEnter;
// バックグラウンドから復帰した時に実行
- (void)WillForegroundEnter;
// バックグラウンド処理が終わった時に呼び出す
-(void)EndBackgroundTask;

@end
