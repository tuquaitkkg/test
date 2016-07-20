
#import <Foundation/Foundation.h>
#import "snmp_pp.h"

@interface Snmp_pp : NSObject
{
    UdpAddress address;
    Pdu pdu;
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

- (int)initSnmp:(NSString *)aIpAddress port:(u_short)aPort;

- (int)setOid:(NSMutableArray *)aOidList;

- (int)clear;

@end
