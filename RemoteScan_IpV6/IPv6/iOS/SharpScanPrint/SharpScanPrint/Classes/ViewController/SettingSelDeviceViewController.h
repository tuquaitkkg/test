
#import <UIKit/UIKit.h>
#import <Foundation/NSNetServices.h>
#import "PrinterDataManager.h"
#import "PrintServerDataManager.h"
#import "ProfileDataManager.h"
#import "SnmpManager.hh"
#import "RSmfpifManager.h"
#import "RSmfpifServiceManager.h"
#import "ExAlertController.h"

@interface SettingSelDeviceViewController : UITableViewController<NSNetServiceBrowserDelegate,
                                                                  NSNetServiceDelegate,                                                                  RSHttpCommunicationManagerDelegate>
{
    PrinterDataManager* m_pPrinterMgr;          // PrinterDataManagerクラス
    PrintServerDataManager* m_pPrintServerMgr;  // PrintServerDataManagerクラス
    NSMutableArray* m_parrServices;             // サービス情報格納
	NSNetServiceBrowser* m_pnetServiceBrowser;  // サービス検索
	NSNetService* m_pnetServiceCurrentResolve;  // ホスト名解決
    NSInteger m_nResolvedCnt;                   // ホスト名解決済みプリンタ数
    ExAlertController *ex_alert;                // メッセージ表示
    BOOL isEnd;                                 // 処理終了フラグ
    
    NSMutableDictionary* m_pDicPlace;           // SNMPで取得する設置場所情報
    NSMutableDictionary* m_pDicFtpPort;           // SNMPで取得するFTP通信ポート番号情報
    NSMutableArray* snmpManagerArray;
    NSInteger m_nMibCount;
    
    RSmfpifManager* mfpManager;
    RSmfpifServiceManager* mfpServiceManager;
//    RSmfpifServicePrintReleaseManager* mfpifServicePrintReleaseManager;
    BOOL isParseEnd;
}

@property (nonatomic, strong, readwrite) NSMutableArray* Services;
@property (nonatomic, strong, readwrite) NSNetServiceBrowser* NetServiceBrowser;
@property (nonatomic, strong, readwrite) NSNetService* CurrentResolve;
@property (nonatomic, strong) NSTimer* TimeoutSearchForSearvice; // サービス検索タイムアウト用タイマー

// 画面遷移
- (void)MoveView:(NSIndexPath *)nIndexPath;

//// フッター表示
//- (void)SetFooterView;
//ヘッダー表示
- (void)SetHeaderView;

// 処理中アラート表示
- (void)CreateProgressAlert:(NSString *)pstrTitle 
                    message:(NSString *)pstrMessage 
                 withCancel:(BOOL)bCancel;

// Bonjour関連
// サービス検索
- (BOOL)SearchForServicesOfType:(NSString *)pstrType inDomain:(NSString *)pstrDomain;

// サービス検索完了
- (void)EndSearchNetService;

// サービス検索中断
- (void)StopSearchForSeviceOfTypeCloseAlert:(BOOL)isclosealert;
- (void)StopSearchForSeviceOfType:(NSTimer*)timer;

// タイマー停止
- (void)StopTimer;

// ホスト名解決中断
- (void)StopCurrentResolve;

// ホスト名解決
- (void)ResolveAddress:(NSInteger)nIndex;

// ホスト名解決完了
- (void)EndResolveAddress;

// SNMP開始
- (void)StartSnmp;

// IPアドレス取得
- (NSString*)GetIpAddress:(NSNetService*)sender;

// バックグラウンドに入ったかチェック
- (BOOL) isDidEnterBackground;

@end
