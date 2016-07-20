
#import <UIKit/UIKit.h>
#import "ScanBeforePictViewController.h"
#import "TwainSocketController.h"
#import "TRSS_ColorModeViewController.h"
#import "TRSS_ManuscriptViewController.h"
#import "TRSS_CustomSizeListViewController.h"
#import "TRSS_BothOrOneSideViewController.h"
#import "TRSS_ResolutionViewController.h"
#import "TRSS_OtherViewController.h"

#import "TwainRemoteScanSettingViewData.h"

#import "RSGetJobSettableElementsManager.h"
#import "RSGetJobStatusManager.h"
#import "RSRequestUISessionIdManager.h"
#import "RSGetDeviceStatusManager.h"
#import "RemoteScanSettingViewData.h"

enum{
    TW_ALERT_TAG_REMOTE_CHECK = 94,
    TW_ALERT_TAG_REMOTE_Result = 95,
    TW_ALERT_TAG_SCANBEFORE = 99,
    TW_ALERT_TAG_SCANPROGRESS = 10,
    TW_ALERT_TAG_FAILED_REQUESTUISESSIONID = 98,
    TW_ALERT_TAG_FAILED_GETJOBSETTABLEELEMENTS = 97,
    TW_ALERT_TAG_JAMMING = 96,
    
    TW_ALERT_TAG_WIFI_NO_CONNECTION = 200,
    TW_ALERT_TAG_SCAN_FAILED,
    TW_ALERT_TAG_NOT_SUPPORTED,
    TW_ALERT_TAG_NOT_SUPPORTED_AND_STOP,
    TW_ALERT_TAG_RESOURCE_NOT_FOUND,
    TW_ALERT_TAG_ORIGINAL_NOT_DETECTED,
    TW_ALERT_TAG_ORIGINAL_NOT_DETECTED_EXECUTE,
    TW_ALERT_TAG_WAIT,
    TW_ALERT_TAG_RSSETDEVICECONTEXTMANAGER_ERROR,
    TW_ALERT_TAG_NETWORKERROR_AND_EXIT,
    TW_ALERT_TAG_SETDEVICECONTEXT_WAIT,
    TW_ALERT_TAG_EXECUTEJOB_ACCESSDENIED,
    TW_ALERT_TAG_GETDEVICESTATUS_FAILED,
};


//enum{
//    TRSSTATUS,
//    TRSSTATUS_INIT,
//    TRSSTATUS_GETJOBSETTABLEELEMENTS,
//    TRSSTATUS_GETDEVICESTATUS,
//    TRSSTATUS_REQUESTUISESSIONID,
//    TRSSTATUS_SETDEVICECONTEXT_START,
//    TRSSTATUS_SETDEVICECONTEXT_END,
//    TRSSTATUS_SETDEVICECONTEXT_RETRY,
//    TRSSTATUS_SETDEVICECONTEXT_WAIT,
//    TRSSTATUS_EXECUTEJOB,
//    TRSSTATUS_EXECUTEJOB_COMPLETE,
//    TRSSTATUS_EXECUTEJOB_CANCELED,
//    TRSSTATUS_EXECUTEJOB_CANCELING,
//    TRSSTATUS_EXECUTEJOB_JAMMING,
//    TRSSTATUS_EXECUTEJOB_JAMMED,
//    TRSSTATUS_GETJOBSTATUS,
//    TRSSTATUS_CANCELJOB,
//    TRSSTATUS_RESUMEJOB,
//    TRSSTATUS_RELEASEUISESSIONID,
//};

@interface TwainRemoteScanBeforePictViewController : ScanBeforePictViewController < TwainSocketControllerDelegate, RSManagerDelegate, UIAlertViewDelegate, UIScrollViewDelegate>
{
    TRSS_ColorModeViewController        *m_pColorModeVC;
    TRSS_ManuscriptViewController       *m_pManuscriptVC;
    TRSS_CustomSizeListViewController   *m_pCustomSizeListVC;
    TRSS_BothOrOneSideViewController    *m_pBothOrOneSideVC;
//    TRSS_FormatViewController           *m_pFormatVC;
    TRSS_ResolutionViewController       *m_pResolutionVC;
    TRSS_OtherViewController            *m_pOtherVC;

    TwainRemoteScanSettingViewData* rssViewData;
    RSGetJobSettableElementsManager* rsManager;
    RSGetJobStatusManager* getJobStatusManager;
    RSRequestUISessionIdManager* requestUISessionIdManager;
    RSGetDeviceStatusManager* pollingRsManager;

    IBOutlet UIView *settingView;
    IBOutlet UIScrollView *menuScrollView;
    IBOutlet UIButton *menuUpBtn;
    IBOutlet UIButton *menuDownBtn;
    UIViewController* selectedVC;

    NSString* strVKey;

    BOOL bRemoteScanRunning;
    BOOL bRemoteScanCanceled;

    BOOL bDoReleaseUiSessionId;
    // 初回エラーフラグ
    BOOL bFirstErr_Network;
    BOOL bScreenLock;

    int nStatus;

    NSURL* connectUrl;

    NSString* sessionId;
    NSString* strOriginalSize;

    NSString* strProfileName;
    NSString* strVerifyCode;

    
    UIBackgroundTaskIdentifier bgTask; // バックグラウンド実行タスク

    PrinterData* m_pPrinterInfo;            // プリンタ情報

}
// Twain印刷用引数
//ScanPosition
@property (nonatomic,assign) ScanPosition scanPosition;
//Direction
@property (nonatomic,assign) Direction direction;
//コンピュータ名
@property (nonatomic,strong) NSString *computerName;
//解像度
@property (nonatomic,assign) int resolution;
//ColorMode カラーモード
@property (nonatomic,assign) ColorMode colorMode;
//threshold しきい値
@property (nonatomic,assign) int threshold;
// 濃度レベル
@property (nonatomic,assign) int colorDepth;
//PaperSize　原稿サイズ
@property (nonatomic,assign) PaperSize paperSize;
////ModeSense用フラグ
//@property (nonatomic,assign) BOOL forModeSense;
//タイムアウト時間
@property (nonatomic,assign) NSInteger timeoutSec;


@property (nonatomic, strong) TwainRemoteScanSettingViewData* rssViewData;
@property (nonatomic, readonly) RSGetJobSettableElementsManager* rsManager;

@property (nonatomic,strong) TwainSocketController *tsc;
//@property (nonatomic,strong) TwainSocketManager *tSocketManager;

//@property (nonatomic, strong) RSSVListTypeData* colorMode;

// 設定情報の更新
-(void)updateSetting;
// カスタムサイズリスト
- (void)OnCustomSizeList;

- (void)getThreshold;

@end
