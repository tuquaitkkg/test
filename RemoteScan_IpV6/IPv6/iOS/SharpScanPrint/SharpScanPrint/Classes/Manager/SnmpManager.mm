//
//  SnmpManager.m
//  SharpScanPrint
//
//  Created by  on 12/08/21.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "SnmpManager.hh"
#import "Define.h"

@implementation SnmpManager

@synthesize aVersion;
@synthesize aRetries;
@synthesize aTimeout;


- (id)initWithIpAddress:aIpAddress port:(u_short)aPort
{
    self = [super init];
    if ( ! self ) {
        return nil;
    }
    
    aVersion = @"v2";
    aRetries = 3;
    aTimeout = 200; // Timeout値（ 100 / sec）
    [aCommunity addObject:@"public"];
    strCommunity = @"";
    aEncoding = 0;
    isGetEncode = FALSE;
    
    nThreadCount = 0;
    
    aMib = [[NSMutableDictionary alloc]init];
    
    snmpGet = [[Snmp_pp alloc]init];
    int i =[snmpGet initSnmp:aIpAddress port:aPort];
    DLog(@"%d",i);
    return self;
}

- (NSMutableDictionary*)getMibByCommunity:(NSString*) strCommunityString
{
    return [snmpGet getMib:aVersion retries:1 timeout:aTimeout community:strCommunityString encoding:aEncoding];
}
// MIB情報の取得
- (NSMutableDictionary *)getMib
{
    nThreadStatus = E_THREAD_DOING;
    nThreadCount = 0;
    
    if([strCommunity isEqualToString:@""])
    {
        // 初回
        for (NSString* strComStr in aCommunity) {
            if([strComStr length] == 0)
            {
                continue;
            }
            nThreadCount++;
            [self performSelectorInBackground:@selector(getMib:) withObject:strComStr];
        }    
    }
    else
    {
        // 2回目以降（Community Stringが確定している状態）
        nThreadCount++;
        [self performSelectorInBackground:@selector(getMib:) withObject:strCommunity];
    }
    
    while (nThreadCount > 0) {
        [NSThread sleepForTimeInterval:0.5];
    }
        
    return aMib;
}

- (NSMutableDictionary *)getBulk
{
    nThreadStatus = E_THREAD_DOING;
    nThreadCount = 0;
    
    if([strCommunity isEqualToString:@""])
    {
        // 初回
        for (NSString* strComStr in aCommunity) {
            if([strComStr length] == 0)
            {
                continue;
            }
            nThreadCount++;
            [self performSelectorInBackground:@selector(getBulk:) withObject:strComStr];
        }    
    }
    else
    {
        // 2回目以降（Community Stringが確定している状態）
        nThreadCount++;
        [self performSelectorInBackground:@selector(getBulk:) withObject:strCommunity];
    }
    
    while (nThreadCount > 0) {
        [NSThread sleepForTimeInterval:0.5];
    }
    
    return aMib;
}

- (NSMutableDictionary *)getNext
{
    nThreadStatus = E_THREAD_DOING;
    nThreadCount = 0;
    
    if([strCommunity isEqualToString:@""])
    {
        // 初回
        for (NSString* strComStr in aCommunity) {
            if([strComStr length] == 0)
            {
                continue;
            }
            nThreadCount++;
            [self performSelectorInBackground:@selector(getNext:) withObject:strComStr];
        }
    }
    else
    {
        // 2回目以降（Community Stringが確定している状態）
        nThreadCount++;
        [self performSelectorInBackground:@selector(getNext:) withObject:strCommunity];
    }
    
    while (nThreadCount > 0) {
        [NSThread sleepForTimeInterval:0.5];
    }
    
    return aMib;
}

- (void)getMib:(NSString*) strCommunityString
{
    
    //SharpScanPrintAppDelegate* appDelegate = (SharpScanPrintAppDelegate*)[[UIApplication sharedApplication] delegate];
    
    @try {
        NSMutableDictionary* mib = nil;
        for (NSInteger i=0; i < 1; i++) {
            @autoreleasepool {
                
                mib = [snmpGet getMib:aVersion retries:aRetries timeout:aTimeout community:strCommunityString encoding:aEncoding];
                if ([mib count] > 0) {
                    break;
                }
                if (nThreadStatus == E_THREAD_COMPLETED)
                {
                    break;
                }
            }
        }
        
        if (mib != nil && [mib count] > 0) {
            aMib = mib;
            strCommunity = strCommunityString;
            nThreadStatus = E_THREAD_COMPLETED;
        }
    }
    @catch (NSException *exception) {
        // エラー時
    }
    @finally {
        nThreadCount--;
    }
    
    return;
}

- (void)getBulk:(NSString*) strCommunityString
{
    @try {
        NSMutableDictionary* mib = nil;
        for (NSInteger i=0; i < 1; i++) {
            mib = [snmpGet getBulk:aVersion retries:aRetries timeout:aTimeout community:strCommunityString encoding:aEncoding];
            if ([mib count] > 0) {
                break;
            }
            if (nThreadStatus == E_THREAD_COMPLETED)
            {
                aMib = nil;
                break;
            }
        }
        
        if (mib != nil && [mib count] > 0) {
            aMib = mib;
            strCommunity = strCommunityString;
            nThreadStatus = E_THREAD_COMPLETED;
        }
    }
    @catch (NSException *exception) {
        // エラー時
    }
    @finally {
        nThreadCount--;
    }
    
    return;
}

- (void)getNext:(NSString*) strCommunityString
{
    @try {
        NSMutableDictionary* mib = nil;
        
        for (NSInteger i=0; i < 1 ; i++)
        {
            @autoreleasepool {
                // getNext時のタイムアウトは固定で5秒
                mib = [snmpGet getNext:aVersion
                               retries:aRetries
                               timeout:aTimeout
                             community:strCommunityString
                              encoding:aEncoding];
                
                if ([mib count] > 0) {
                    break;
                }
                if (nThreadStatus == E_THREAD_COMPLETED)
                {
                    break;
                }
            }
        }
        
        if (mib != nil && [mib count] > 0) {
            aMib = mib;
            strCommunity = strCommunityString;
            nThreadStatus = E_THREAD_COMPLETED;
        }
    }
    @catch (NSException *exception) {
        // エラー時
    }
    @finally {
        nThreadCount--;
    }
    
    return;
}

// 取得するOIDを設定
- (int)setOid:(NSMutableArray *)aOidList
{
    return [snmpGet setOid:aOidList];
}

// PDUのClear
- (int)clear
{
    return [snmpGet clear];
}

// MFPから取得した表示言語の値から、対応する対応するNSStringEncodingを返却する（取得できない場合はNSISOLatin1StringEncodingを返却）
-(NSStringEncoding)getStringEncodingById:(NSString*) langId
{
    if([langId isEqualToString:S_SNMP_OID_LANG_JA])
    {
        return NSShiftJISStringEncoding;
    }
    if([langId isEqualToString:S_SNMP_OID_LANG_CH])
    {
        return CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingGB_18030_2000);
    }
    if([langId isEqualToString:S_SNMP_OID_LANG_CH_TW])
    {
        return CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingBig5);
    }
    if([langId isEqualToString:S_SNMP_OID_LANG_2001])
    {
        return NSWindowsCP1252StringEncoding;
    }
    if([langId isEqualToString:S_SNMP_OID_LANG_2002])
    {
        return NSWindowsCP1250StringEncoding;
    }
    if([langId isEqualToString:S_SNMP_OID_LANG_2003])
    {
        return NSWindowsCP1254StringEncoding;
    }
    if([langId isEqualToString:S_SNMP_OID_LANG_2251])
    {
        return NSWindowsCP1251StringEncoding;
    }
    if([langId isEqualToString:S_SNMP_OID_LANG_2253])
    {
        return NSWindowsCP1253StringEncoding;
    }
    if([langId isEqualToString:S_SNMP_OID_LANG_2255])
    {
        return CFStringConvertEncodingToWindowsCodepage(kCFStringEncodingISOLatinHebrew);
    }
    if([langId isEqualToString:S_SNMP_OID_LANG_2257])
    {
        return CFStringConvertEncodingToWindowsCodepage(kCFStringEncodingISOLatin4);
    }

    // その他はLatin1
    return NSISOLatin1StringEncoding;
}

// MFPの現在の表示言語を取得し、対応するNSStringEncodingを返却する（取得できない場合は0を返却）
- (NSStringEncoding)getMfpDisplayLang
{
    NSMutableArray* arrOid = [NSMutableArray array];    // OID
    NSMutableDictionary* dicMibList;                    // 取得結果
    
    [arrOid addObject:S_SNMP_OID_LANG_INDEX];
    
    [self clear];
    [self setOid:arrOid];
    
    dicMibList = [self getMib];
    if(dicMibList == nil || [dicMibList count] == 0)
    {
        return 0;
    }
    NSString* index = @"";
    for (NSString* key in [dicMibList keyEnumerator]) {
        if([key isEqualToString:S_SNMP_OID_LANG_INDEX])
        {
            index = [dicMibList objectForKey:key];
            break;
        }
    }
    
    // 取得に失敗したらNSUTF8StringEncodingを返却
    if([index isEqualToString:@""])
    {
        return NSUTF8StringEncoding;
    }
    
    NSString* indexLang = [S_SNMP_OID_LANG_ stringByAppendingString:index];
    
    [arrOid removeAllObjects];
    [arrOid addObject:indexLang];
    
    [self clear];
    [self setOid:arrOid];
    
    dicMibList = [self getMib];
    
    if(dicMibList == nil || [dicMibList count] == 0)
    {
        return 0;
    }
    
    NSString* langId = @"";
    for (NSString* key in [dicMibList keyEnumerator]) {
        if([key isEqualToString:indexLang])
        {
            langId = [dicMibList objectForKey:key];
            break;
        }
    }
    
    // 取得に失敗したら0を返却
    if([langId isEqualToString:@""])
    {
        return 0;
    }
    
    return [self getStringEncodingById: langId];
}

// 任意のOIDの情報を取得する
- (NSMutableDictionary *)getMibByOid:(NSMutableArray *)aOidList
{
    if(isGetEncode == FALSE)
    {
        aEncoding = [self getMfpDisplayLang];
        isGetEncode = TRUE;
    }
    
    // エンコードが取得できない = 全てのCommunity Stringが合致しない
    if(aEncoding == 0)
    {
        return [[NSMutableDictionary alloc]init];
    }
    
    [self clear];
    [self setOid:aOidList];
    
    return [self getMib];
}

- (NSMutableDictionary *)getBulkByOid:(NSMutableArray *)aOidList
{
    [self clear];
    [self setOid:aOidList];
    
    return [self getBulk];
}

- (NSMutableDictionary *)getNextByOid:(NSMutableArray *)aOidList
{
    [self clear];
    [self setOid:aOidList];
    
    return [self getNext];
}


- (void)setCommunityString:(NSMutableArray*)mCommunity
{
    aCommunity = nil;
    aCommunity = [[NSMutableArray alloc] initWithArray: mCommunity];
    strCommunity = @"";
}

- (void)stopGetMib
{
    nThreadStatus = E_THREAD_COMPLETED;
}
@end
