
#import "PrinterData.h"
#import "CommonUtil.h"
#import "Define.h"


@implementation PrinterData

@synthesize PrimaryKey = m_pstrPrimaryKey;      // プリンタ情報のプライマリキー
@synthesize HostName = m_pstrHostName;          // ホスト名
@synthesize PrinterName = m_pstrPrinterName;    // プリンタ名称
@synthesize ProductName = m_pstrProductName;    // 製品名
@synthesize IpAddress = m_pstIpAddress;         // プリンタIPアドレス
@synthesize PortNo = m_pstrPortNo;              // サービスに割当てられたポートNo
@synthesize FtpPortNo = m_pstrFtpPortNo;        // FTPポートNo(現在は固定で21)
@synthesize RawPortNo = m_pstrRawPortNo;        // RawポートNo(現在は固定で9100)
@synthesize Place = m_pstrPlace;                // 設置場所
@synthesize ServiceName = m_pstrServiceName;    // サービス名
@synthesize DefaultMFP = m_bDefaultMFP;         // デフォルトMFPフラグ
@synthesize ExclusionList = m_bExclusionList;   // 除外リストに追加フラグ
@synthesize IsExistsPCL  = m_bIsExistsPCL;      // PCLオプションフラグ（未使用）
@synthesize IsExistsPS = m_bIsExistsPS;         // PSオプションフラグ（未使用）
@synthesize IsCapableRemoteScan = m_bIsCapableRemoteScan;   // リモートスキャン対応MFPフラグ
@synthesize IsCapableNovaLight = m_bIsCapableNovaLight;   // NovaLight対応MFPフラグ
@synthesize RSPortNo = m_pstrRSPortNo;                      // リモートスキャンのポートNo
@synthesize isCapableNetScan = m_bIsCapableNetScan;         // ネットスキャン対応MFPフラグ
@synthesize isCapablePrintRelease = m_bIsCapablePrintRelease;
@synthesize enabledDataReceive = m_bEnabledDataReceive;


@synthesize addDic = m_addDic;
@synthesize updateDic = m_updateDic;
@synthesize deleteDic = m_deleteDic;

- (id)init
{
    if ((self = [super init]) == nil)
	{
        return nil;
    }
    
    m_bIsExistsPCL = YES;   // デフォルトでYES
    m_bIsExistsPS = YES;    // デフォルトでYES
    m_bIsCapableRemoteScan = NO;    // デフォルトでNO
    m_bIsCapableNetScan = NO;    // デフォルトでNO
    m_bIsCapableNovaLight = NO;    // デフォルトでNO
    m_bIsCapablePrintRelease = NO;    // デフォルトでNO
    m_bEnabledDataReceive = NO;    // デフォルトでNO

    return self;
}

// エンコーダーにデータを保存する処理
- (void)encodeWithCoder:(NSCoder*)coder
{
    // 文字列をキーで保存する
    [coder encodeObject:m_pstrPrimaryKey    forKey:@"stringPrimaryKey"];
    [coder encodeObject:m_pstrHostName      forKey:@"stringHostName"];
    [coder encodeObject:m_pstrPrinterName   forKey:@"stringPrinterName"];
    [coder encodeObject:m_pstrProductName   forKey:@"stringProductName"];
    [coder encodeObject:m_pstIpAddress      forKey:@"stringIpAddress"];
    [coder encodeObject:m_pstrPortNo        forKey:@"stringPortNo"];
    [coder encodeObject:m_pstrFtpPortNo     forKey:@"stringFtpPortNo"];
    [coder encodeObject:m_pstrRawPortNo     forKey:@"stringRawPortNo"];
    [coder encodeObject:m_pstrPlace         forKey:@"stringPlace"];
    [coder encodeObject:m_pstrServiceName   forKey:@"stringServiceName"];

    [coder encodeObject:[NSString stringWithFormat:@"%d", m_bIsExistsPCL]      forKey:@"stringIsExistsPCL"];
    [coder encodeObject:[NSString stringWithFormat:@"%d", m_bIsExistsPS]      forKey:@"stringIsExistsPS"];
    if(m_bExclusionList)
    {
        [coder encodeObject:@"1"         forKey:@"stringExclusionList"];
    }
    else
    {
        [coder encodeObject:@"0"         forKey:@"stringExclusionList"];        
    }
    [coder encodeObject:[NSString stringWithFormat:@"%d", m_bIsCapableRemoteScan] forKey:@"stringIsCapableRemoteScan"];
    [coder encodeObject:[NSString stringWithFormat:@"%d", m_bIsCapableNetScan] forKey:@"stringIsCapableNetScan"];
    [coder encodeObject:[NSString stringWithFormat:@"%d", m_bIsCapableNovaLight] forKey:@"stringIsCapableNovaLight"];
    
    [coder encodeObject:m_pstrRSPortNo   forKey:@"stringRSPortNo"];
    
    [coder encodeObject:m_addDic forKey:@"dictionaryAdd"];
    [coder encodeObject:m_updateDic forKey:@"dictionaryUpdate"];
    [coder encodeObject:m_deleteDic forKey:@"dictionaryDelete"];
    
    [coder encodeObject:[NSString stringWithFormat:@"%d", m_bIsCapablePrintRelease] forKey:@"stringIsCapablePrintRelease"];
    [coder encodeObject:[NSString stringWithFormat:@"%d", m_bEnabledDataReceive] forKey:@"stringEnabledDataReceive"];
}

// アーカイブから読み込む
- (id)initWithCoder:(NSCoder*)coder
{
    self = [super init];
	
    if (self)
	{
        m_pstrPrimaryKey    = [coder decodeObjectForKey:@"stringPrimaryKey"];
        m_pstrHostName      = [coder decodeObjectForKey:@"stringHostName"];
        m_pstrPrinterName   = [coder decodeObjectForKey:@"stringPrinterName"];
        m_pstrProductName   = [coder decodeObjectForKey:@"stringProductName"];
        m_pstIpAddress      = [coder decodeObjectForKey:@"stringIpAddress"];
        m_pstrPortNo        = [coder decodeObjectForKey:@"stringPortNo"];
        m_pstrFtpPortNo     = [coder decodeObjectForKey:@"stringFtpPortNo"];
        m_pstrRawPortNo     = [coder decodeObjectForKey:@"stringRawPortNo"];
        m_pstrPlace         = [coder decodeObjectForKey:@"stringPlace"];
        m_pstrServiceName   = [coder decodeObjectForKey:@"stringServiceName"];
        
        if([coder decodeObjectForKey:@"stringIsExistsPCL"])
        {
            m_bIsExistsPCL      = [[coder decodeObjectForKey:@"stringIsExistsPCL"] boolValue];
        }
        else
        {
            m_bIsExistsPCL = YES;            
        }
        if([coder decodeObjectForKey:@"stringIsExistsPS"])
        {
            m_bIsExistsPS      = [[coder decodeObjectForKey:@"stringIsExistsPS"] boolValue];
        }
        else
        {
            m_bIsExistsPS = YES;            
        }
        
        if ([[coder decodeObjectForKey:@"stringExclusionList"] isEqualToString:@"1"])
        {
            m_bExclusionList = TRUE;
        }
        else
        {
            m_bExclusionList = FALSE;
        }
        
        // ネットスキャン機能
        if ([coder decodeObjectForKey:@"stringIsCapableNetScan"])
        {
            m_bIsCapableNetScan = [[coder decodeObjectForKey:@"stringIsCapableNetScan"] boolValue];
        }
        else
        {
            m_bIsCapableNetScan = NO;
        }
        // リモートスキャン機能
        if ([coder decodeObjectForKey:@"stringIsCapableRemoteScan"])
        {
            m_bIsCapableRemoteScan = [[coder decodeObjectForKey:@"stringIsCapableRemoteScan"] boolValue];
        }
        else
        {
            m_bIsCapableRemoteScan = NO;
        }
        
        // NovaLight機能
        if ([coder decodeObjectForKey:@"stringIsCapableNovaLight"])
        {
            m_bIsCapableNovaLight = [[coder decodeObjectForKey:@"stringIsCapableNovaLight"] boolValue];
        }
        else
        {
            m_bIsCapableNovaLight = NO;
        }
               
        m_pstrRSPortNo = [coder decodeObjectForKey:@"stringRSPortNo"];
        
        // レガシーMFP
        m_addDic    = [coder decodeObjectForKey:@"dictionaryAdd"];
        m_updateDic = [coder decodeObjectForKey:@"dictionaryUpdate"];
        m_deleteDic = [coder decodeObjectForKey:@"dictionaryDelete"];
        
        if ([coder decodeObjectForKey:@"stringIsCapablePrintRelease"])
        {
            m_bIsCapablePrintRelease = [[coder decodeObjectForKey:@"stringIsCapablePrintRelease"] boolValue];
        }
        else
        {
            m_bIsCapablePrintRelease = NO;
        }
        if ([coder decodeObjectForKey:@"stringEnabledDataReceive"])
        {
            m_bEnabledDataReceive = [[coder decodeObjectForKey:@"stringEnabledDataReceive"] boolValue];
        }
        else
        {
            m_bEnabledDataReceive = NO;
        }
    }
    return self;
}

// ログ出力
- (NSString*)description
{
    return [NSString stringWithFormat:
            @"PrimaryKey[%@] HostName[%@] PrinterName[%@] ProductName[%@] IpAddress[%@] PortNo[%@] FtpPortNo[%@] RawPortNo[%@] Place[%@] ServiceName[%@] ExclusionList[%d] addDic[%@] updateDic[%@] deleteDic[%@]"
            , m_pstrPrimaryKey
            , m_pstrHostName
            , m_pstrPrinterName
            , m_pstrProductName
            , m_pstIpAddress
			, m_pstrPortNo
			, m_pstrFtpPortNo
            , m_pstrRawPortNo
            , m_pstrPlace
            , m_pstrServiceName
            , m_bExclusionList
            , self.addDic
            , self.updateDic
            , self.deleteDic];
}


// 名称の取得
- (NSString*)getPrinterName
{
    
    if([m_pstrPrinterName hasPrefix:@"SHARP "])
    {
        // "SHARP "で始まる場合は省いて返す
        return [m_pstrPrinterName substringFromIndex:6];
    }
    else
    {
        return m_pstrPrinterName;
    }
    
}

// 手動登録、自動登録されたMFPの区別
- (BOOL)getAddStatus
{
    if ([CommonUtil isAutoScanPrinter:m_pstrHostName]) {
        // 自動登録
        return NO;
    }
    else
    {
        // 手動登録
        return YES;
    }
}


// IPアドレスの取得
- (NSString*)getIPAddress
{
    return m_pstIpAddress;
}

@end
