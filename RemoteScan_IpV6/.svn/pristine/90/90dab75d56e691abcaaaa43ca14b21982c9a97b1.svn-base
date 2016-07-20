//
//  SnmpManager.h
//  SharpScanPrint
//
//  Created by  on 12/08/21.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Snmp_pp : NSObject {
}

- (NSMutableDictionary *)getMib:(NSString *)aVersion 
                        retries:(int)aRetries 
                        timeout:(int)aTimeout 
                      community:(NSString*)aCommunity
                       encoding:(NSStringEncoding)aEncoding;

- (NSMutableDictionary *)getBulk:(NSString *)aVersion 
                        retries:(int)aRetries 
                        timeout:(int)aTimeout 
                      community:(NSString*)aCommunity
                       encoding:(NSStringEncoding)aEncoding;

- (NSMutableDictionary *)getNext:(NSString *)aVersion
                         retries:(int)aRetries
                         timeout:(int)aTimeout
                       community:(NSString*)aCommunity
                        encoding:(NSStringEncoding)aEncoding;

- (int)initSnmp;

- (int)initSnmp:(NSString *)aIpAddress port:(u_short)aPort;

- (int)setOid:(NSMutableArray *)aOidList;

- (int)clear;
@end

@interface SnmpManager : NSObject
{
    Snmp_pp* snmpGet;
    
    NSString* aVersion;
    int aRetries;
    int aTimeout;
    NSMutableArray* aCommunity;
    NSStringEncoding aEncoding;
    BOOL isGetEncode;
    
    NSString* strCommunity;
    
    int nThreadStatus;
    int nThreadCount;
    NSMutableDictionary* aMib;
}

enum eThreadStatus{
    E_THREAD_STOP = 0,
    E_THREAD_DOING,
    E_THREAD_COMPLETED
};

@property (nonatomic, strong) NSString* aVersion;
@property (nonatomic) int aRetries;
@property (nonatomic) int aTimeout;


- (id)initWithIpAddress:aIpAddress port:(u_short)aPort;

- (NSStringEncoding)getMfpDisplayLang;

- (NSMutableDictionary *)getMibByOid:(NSMutableArray *)aOidList;

- (NSMutableDictionary *)getBulkByOid:(NSMutableArray *)aOidList;

- (NSMutableDictionary *)getNextByOid:(NSMutableArray *)aOidList;

- (void)setCommunityString:(NSMutableArray*)mCommunity;

- (void)stopGetMib;

@end
