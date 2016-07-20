
#import "PrintOutDataManager.h"
#import "Define.h"
#import "CommonUtil.h"

@implementation PrintOutDataManager

- (id)init
{
    m_pUserDefault = [NSUserDefaults standardUserDefaults];
    return self;
}


// 最新印刷情報 プライマリキー取得 (プリンター)
- (NSString*)GetLatestPrimaryKey
{
    NSString* pstrValue = [m_pUserDefault stringForKey:S_KEY_LATEST_PRIMARY_KEY];
    if (pstrValue == nil)
    {
        return @"";
    }

    return pstrValue;
}

// 最新印刷情報 プライマリキー取得 (プリントサーバー)
- (NSString*)GetLatestPrimaryKey2
{
    NSString* pstrValue = [m_pUserDefault stringForKey:S_KEY_LATEST_PRIMARY_KEY2];
    if (pstrValue == nil)
    {
        return @"";
    }

    return pstrValue;
}

// 接続先WiFiでの最新印刷情報 プライマリキー取得 (プリンター)
- (NSString*)GetLatestPrimaryKeyForCurrentWiFi
{
    LOG(@"------GetLatestPrimaryKeyForCurrentWiFi");
    NSString* primaryKey = S_KEY_LATEST_PRIMARY_KEY;
    NSString* pstrValue = nil;
    
    // 現在の接続先WiFi取得
    NSString* strWiFiSSID = [CommonUtil GetCurrentWifiSSID];
    // 接続先がWiFiの場合
    if(strWiFiSSID != nil)
    {
        primaryKey = [NSString stringWithFormat:@"%@_%@",S_KEY_LATEST_PRIMARY_KEY,strWiFiSSID];
        // 現在の接続先WiFiでの最新印刷情報取得
        pstrValue = [m_pUserDefault stringForKey:primaryKey];
    }
    
    if (pstrValue == nil)
    {
        return @"";
    }
    return pstrValue;
}

// 接続先WiFiでの最新印刷情報 プライマリキー取得 (プリントサーバー)
- (NSString*)GetLatestPrimaryKeyForCurrentWiFi2
{
    NSString* primaryKey = S_KEY_LATEST_PRIMARY_KEY2;
    NSString* pstrValue = nil;
    
    // 現在の接続先WiFi取得
    NSString* strWiFiSSID = [CommonUtil GetCurrentWifiSSID];
    // 接続先がWiFiの場合
    if(strWiFiSSID != nil)
    {
        primaryKey = [NSString stringWithFormat:@"%@_%@",S_KEY_LATEST_PRIMARY_KEY2,strWiFiSSID];
        // 現在の接続先WiFiでの最新印刷情報取得
        pstrValue = [m_pUserDefault stringForKey:primaryKey];
    }
    
    if (pstrValue == nil)
    {
        return @"";
    }
    return pstrValue;
}

// 最新印刷情報 プリントタイプ　1:プリンター/スキャナー 2:プリントサーバー
- (NSInteger)GetLatestPrintType
{
    return [m_pUserDefault integerForKey:S_KEY_LATEST_PRINT_TYPE];
}

/*
// 最新印刷情報 部数index取得
- (NSInteger)GetLatestIdxNumOfSets
{
    return [m_pUserDefault integerForKey:S_KEY_LATEST_IDX_NUM_OF_SETS];
}

// 最新印刷情報 部数取得
- (NSString*)GetLatestNumOfSets
{
    NSString* pstrValue = [m_pUserDefault stringForKey:S_KEY_LATEST_NUM_OF_SETS];
    if (pstrValue == nil)
    {
        return @"1";
    }
    return pstrValue;
}

// 最新印刷情報 両面/片面index取得
- (NSInteger)GetLatestIdxSide
{
    return [m_pUserDefault integerForKey:S_KEY_LATEST_IDX_SIDE];
}

// 最新印刷情報 両面/片面取得
- (NSString*)GetLatestSide
{
    NSString* pstrValue = [m_pUserDefault stringForKey:S_KEY_LATEST_SIDE];
    if (pstrValue == nil)
    {
        return S_ONE_SIDE;
    }
    return pstrValue;
}
*/
// 最新印刷情報 プライマリキー登録
- (BOOL)SetLatestPrimaryKey:(NSString*)pstrVaule
{
    BOOL bRet = FALSE;
    if (pstrVaule != nil)
    {
        NSString *key = S_KEY_LATEST_PRIMARY_KEY;

        [m_pUserDefault setObject:pstrVaule forKey:key];
        // 現在の接続先WiFi取得
        NSString* strWiFiSSID = [CommonUtil GetCurrentWifiSSID];
        if(strWiFiSSID != nil)
        {
            NSString* primaryKey = [NSString stringWithFormat:@"%@_%@",key,strWiFiSSID];
            
            // 現在の接続先WiFiでの最新印刷情報を登録
            [m_pUserDefault setObject:pstrVaule forKey:primaryKey];
        }

        bRet = TRUE;
    }
    return bRet;
}

// 最新印刷情報 プライマリキー登録
- (BOOL)SetLatestPrimaryKey2:(NSString*)pstrVaule
{
    BOOL bRet = FALSE;
    if (pstrVaule != nil)
    {
        NSString *key = S_KEY_LATEST_PRIMARY_KEY2;

        [m_pUserDefault setObject:pstrVaule forKey:key];
        // 現在の接続先WiFi取得
        NSString* strWiFiSSID = [CommonUtil GetCurrentWifiSSID];
        if(strWiFiSSID != nil)
        {
            NSString* primaryKey = [NSString stringWithFormat:@"%@_%@",key,strWiFiSSID];
            
            // 現在の接続先WiFiでの最新印刷情報を登録
            [m_pUserDefault setObject:pstrVaule forKey:primaryKey];
        }
        
        bRet = TRUE;
    }
    return bRet;
}

// 最新印刷情報 プリントタイプ　1:プリンター/スキャナー 2:プリントサーバー
- (BOOL)SetLatestPrintType:(NSInteger)nValue
{
    [m_pUserDefault setInteger:nValue forKey:S_KEY_LATEST_PRINT_TYPE];
    
    return TRUE;
}

/*
// 最新印刷情報 部数index登録
- (BOOL)SetLatestIdxNumOfSets:(NSInteger)nValue
{
    [m_pUserDefault setInteger:nValue forKey:S_KEY_LATEST_IDX_NUM_OF_SETS];

    return TRUE;
}

// 最新印刷情報 部数登録
- (BOOL)SetLatestNumOfSets:(NSString*)pstrVaule
{
    BOOL bRet = FALSE;
    if (pstrVaule != nil)
    {
        [m_pUserDefault setObject:pstrVaule forKey:S_KEY_LATEST_NUM_OF_SETS];
        bRet = TRUE;
    }
    return bRet;
}

// 最新印刷情報 部数index登録
- (BOOL)SetLatestIdxSide:(NSInteger)nValue
{
    [m_pUserDefault setInteger:nValue forKey:S_KEY_LATEST_IDX_SIDE];
    
    return TRUE;
}

// 最新印刷情報 両面/片面登録
- (BOOL)SetLatestSide:(NSString*)pstrVaule
{
    BOOL bRet = FALSE;
    if (pstrVaule != nil)
    {
        [m_pUserDefault setObject:pstrVaule forKey:S_KEY_LATEST_SIDE];
        bRet = TRUE;
    }
    return bRet;
}
*/
@end
