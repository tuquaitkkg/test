
#import <Foundation/Foundation.h>


@interface PrinterData : NSObject
{
    NSString* m_pstrPrimaryKey;     // プリンタ情報のプライマリキー
    NSString* m_pstrHostName;       // ホスト名
    NSString* m_pstrPrinterName;    // プリンタ名称
    NSString* m_pstrProductName;    // 製品名
    NSString* m_pstIpAddress;       // プリンタIPアドレス
    NSString* m_pstrPortNo;         // サービスに割当てられたポートNo
    NSString* m_pstrFtpPortNo;      // FTPポートNo(現在は固定で21)
    NSString* m_pstrRawPortNo;      // RawポートNo(現在は固定で9100)
    NSString* m_pstrPlace;          // 設置場所
    NSString* m_pstrServiceName;    // サービス名
    BOOL m_bDefaultMFP;             // 選択中MFP
    BOOL m_bExclusionList;          // 除外リストに追加
    BOOL m_bIsExistsPCL;            // PCLオプション（未使用）
    BOOL m_bIsExistsPS;             // PSオプション（未使用）
    BOOL m_bIsCapableRemoteScan;    // リモートスキャン対応MFPフラグ
    BOOL m_bIsCapableNetScan;       // ネットキャン対応MFPフラグ
    BOOL m_bIsCapablePrintRelease;  // プリントリリース対応フラグ
    BOOL m_bEnabledDataReceive;  // プリントリリース親機対応フラグ
    BOOL m_bIsCapableNovaLight;    // Nova-Lフラグ
    NSString* m_pstrRSPortNo;       // リモートスキャンのポートNo
    
    NSMutableDictionary *m_addDic;
    NSMutableDictionary *m_updateDic;
    NSMutableDictionary *m_deleteDic;
}

@property (nonatomic, copy) NSString* PrimaryKey;
@property (nonatomic, copy) NSString* HostName;
@property (nonatomic, copy) NSString* PrinterName;
@property (nonatomic, copy) NSString* ProductName;
@property (nonatomic, copy) NSString* IpAddress;
@property (nonatomic, copy) NSString* PortNo;
@property (nonatomic, copy) NSString* FtpPortNo;
@property (nonatomic, copy) NSString* RawPortNo;
@property (nonatomic, copy) NSString* Place;
@property (nonatomic, copy) NSString* ServiceName;
@property (nonatomic) BOOL DefaultMFP;
@property (nonatomic) BOOL ExclusionList;
@property (nonatomic) BOOL IsExistsPCL;
@property (nonatomic) BOOL IsExistsPS;
@property (nonatomic) BOOL IsCapableRemoteScan;
@property (nonatomic) BOOL IsCapableNovaLight;
@property (nonatomic) BOOL isCapableNetScan;
@property (nonatomic) BOOL isCapablePrintRelease;
@property (nonatomic) BOOL enabledDataReceive;
@property (nonatomic, copy) NSString* RSPortNo;

@property (nonatomic, copy) NSMutableDictionary *addDic;
@property (nonatomic, copy) NSMutableDictionary *updateDic;
@property (nonatomic, copy) NSMutableDictionary *deleteDic;

// 名称の取得
- (NSString*)getPrinterName;

- (BOOL)getAddStatus;

// IPアドレスの取得
- (NSString*)getIPAddress;

@end
