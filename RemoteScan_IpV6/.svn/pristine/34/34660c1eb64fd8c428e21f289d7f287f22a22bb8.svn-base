
#import <UIKit/UIKit.h>
#import "PrinterData.h"
#import "PrinterDetailDataCell.h"
#import "SwitchDataCell.h"
#import "ButtonDataCell.h"
#import "RSmfpifManager.h"
#import "RSmfpifServiceManager.h"
#import "ExAlertController.h"

// iPad用
@protocol UpdateSettingShowDeviceViewController
- (void)popRootView;
- (void)setPortraitMenu:(UIBarButtonItem *)barButtonItem;
@end
// iPad用

@interface SettingShowDeviceViewController_iPad : UITableViewController <UITextFieldDelegate,RSHttpCommunicationManagerDelegate, NSURLConnectionDelegate>
{
    PrinterData* m_pPrinterInfo;            // プリンタ情報
    PrinterDetailDataCell* m_pName;         // 名称セル
    PrinterDetailDataCell* m_pDeviceName;   // 製品名セル
    PrinterDetailDataCell* m_pIpAddressCell;     // IPアドレスセル
    PrinterDetailDataCell* m_pPortNoCell;   // プリンタ名セル
    PrinterDetailDataCell* m_pPlaceCell;    // 設置場所セル
    SwitchDataCell* m_pDefaultMFPCell;      // このプリンター/スキャナーを選択
    SwitchDataCell* m_pExclusionListCell;   // 除外リストに追加

    SwitchDataCell* m_pConfigScannerSetting;// 端末側からスキャナーの設定を行う
    PrinterDetailDataCell* m_pDispName;     // 表示名
    SwitchDataCell* m_pAutoVerifyCode;      // 確認コードは自動で作成
    PrinterDetailDataCell* m_pVerifyCode;   // 確認コード
    ButtonDataCell* m_pRemoteScanSettingReset;  // リセット
    
    BOOL m_bAutoScan;                       // 自動追加フラグ
    BOOL m_bAddNew;                         // 新規追加フラグ
    NSString* pstrInitIPAddress;            // 変更前IPアドレス
    
    ExAlertController *ex_alert;            // メッセージ表示
    
    BOOL isEnd;                             // MFP情報取得中断フラグ
    BOOL isComplete;                        // MFP情報取得完了フラグ
    RSmfpifManager* mfpManager;
    RSmfpifServiceManager* mfpServiceManager;
    BOOL isCapableRemoteScan;               // リモートスキャン対応可否フラグ
    
    BOOL autoVerifyOn;                      // 確認コードは自動作成フラグ

    BOOL isRSSettingClear;                  // リモートスキャン設定のクリアフラグ
    
    // IPv6対応
    NSString *pstrPrimaryKey;               // 手動追加時のプライマリーキー登録値格納用
    NSString *pstrInitPrimaryKey;           // 手動追加プリンター編集時の変更前プライマリーキー
}

@property (nonatomic, strong) PrinterData* PrinterInfo;
@property (nonatomic, strong) PrinterDetailDataCell* NameCell;
@property (nonatomic, strong) PrinterDetailDataCell* DeviceNameCell;
@property (nonatomic, strong) PrinterDetailDataCell* IpAddressCell;
@property (nonatomic, strong) PrinterDetailDataCell* PortNoCell;
@property (nonatomic, strong) PrinterDetailDataCell* PlaceCell;
@property (nonatomic, strong) SwitchDataCell* DefaultMFPCell;
@property (nonatomic, strong) SwitchDataCell* ExclusionListCell;
@property (nonatomic, strong) SwitchDataCell* ConfigScannerSetting;
@property (nonatomic, strong) PrinterDetailDataCell* DispName;
@property (nonatomic, strong) SwitchDataCell* AutoVerifyCode;
@property (nonatomic, strong) PrinterDetailDataCell* VerifyCode;
@property (nonatomic, strong) ButtonDataCell* RemoteScanSettingReset;
@property (nonatomic)BOOL     AutoScan;

// 入力チェック
- (NSInteger)CheckError;
- (void)savePrinterData;

- (void)startGetMfpIf;

- (void)popRootView;

@end
