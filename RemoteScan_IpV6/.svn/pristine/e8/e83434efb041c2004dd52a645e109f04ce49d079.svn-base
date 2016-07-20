
#import "Snmp_pp.hh"


@implementation Snmp_pp

- (int)initSnmp:(NSString *)aIpAddress port:(u_short)aPort
{
    //---------[ make a GenAddress and Oid object to retrieve ]---------------
    // SNMP通信先のIPアドレスを設定
    address = UdpAddress((char *)[aIpAddress UTF8String]);
    
    // アドレスに不備がないかチェック
    if ( !address.valid()) {           // check validity of address
        return -1;
    }
    
    address.set_port(aPort);

    //----------[ create a SNMP++ session ]-----------------------------------
    int status;
    // bind to any port and use IPv6 if needed
    Snmp snmp = Snmp(status, 0, (address.get_ip_version() == Address::version_ipv6)); 
    
    if ( status != SNMP_CLASS_SUCCESS) {
        return -2;
    }
    
    return 0;
}


- (NSMutableDictionary *)getMib:(NSString *)aVersion 
                        retries:(int)aRetries
                        timeout:(int)aTimeout 
                        community:(NSString*)aCommunity
                        encoding:(NSStringEncoding)aEncoding{    
    
    // 変数宣言
    NSMutableDictionary *dicMib = [NSMutableDictionary dictionary];
    
    //---------[ determine options to use ]-----------------------------------
    snmp_version version=version2c;                         // SNMPのバージョンを設定
    if ([aVersion isEqualToString: @"v1"])
    {
        version=version1;              
    }    
    int retries = aRetries;                                // リトライ回数を設定
    int timeout = aTimeout;                                // タイムアウト時間設定
    OctetStr community((char *)[aCommunity UTF8String]);   // コミュニティ名称設定
    
    //----------[ create a SNMP++ session ]-----------------------------------
    int status;
    CTarget ctarget(address);             // make a target using the address
    ctarget.set_version(version);         // set the SNMP version SNMPV1 or V2
    ctarget.set_retry(retries);           // set the number of auto retries
    ctarget.set_timeout(timeout);         // set timeout
    ctarget.set_readcommunity(community); // set the read community name
    
    //-------[ issue the request, blocked mode ]-----------------------------
    SnmpTarget *target;
    target = &ctarget;
    
    // ソケット通信開始
    Snmp::socket_startup();

    Snmp snmp = Snmp(status, 0, (address.get_ip_version() == Address::version_ipv6));
    status = snmp.get( pdu, *target);
    
    // ソケット通信終了
    Snmp::socket_cleanup();
    
    if (status == SNMP_CLASS_SUCCESS)
    {
        for (int index = 0; index < pdu.get_vb_count(); index++) 
		{
            Vb vb;
            pdu.get_vb( vb,index);
            
            NSString *pstrOid;
            NSString *pstrMib;
            
            // OID
            const char *OID;
            OID = vb.get_printable_oid();
            pstrOid = [NSString stringWithCString:OID encoding:NSUTF8StringEncoding];
            
            char ptr[1024];
            if(vb.get_value(ptr)==SNMP_CLASS_SUCCESS)
            {
                pstrMib = [NSString stringWithCString:ptr encoding:aEncoding];
            }
            else
            {
                pstrMib = [NSString stringWithCString:vb.get_printable_value() encoding:NSUTF8StringEncoding];
            }
            
            [dicMib setObject:pstrMib forKey:pstrOid];
        }
    }
    else
    {
        return dicMib;
    }
    
    
    return dicMib;
}

- (NSMutableDictionary *)getBulk:(NSString *)aVersion 
                         retries:(int)aRetries 
                         timeout:(int)aTimeout 
                       community:(NSString*)aCommunity
                        encoding:(NSStringEncoding)aEncoding
{
    
    // 変数宣言
    NSMutableDictionary *dicMib = [NSMutableDictionary dictionary];
    
    //---------[ determine options to use ]-----------------------------------
    snmp_version version=version2c;                         // SNMPのバージョンを設定
    if ([aVersion isEqualToString: @"v1"])
    {
        version=version1;              
    }    
    int retries = aRetries;                                // リトライ回数を設定
    int timeout = aTimeout;                                // タイムアウト時間設定
    OctetStr community((char *)[aCommunity UTF8String]);   // コミュニティ名称設定
    
    //----------[ create a SNMP++ session ]-----------------------------------
    int status;
    CTarget ctarget(address);             // make a target using the address
    ctarget.set_version(version);         // set the SNMP version SNMPV1 or V2
    ctarget.set_retry(retries);           // set the number of auto retries
    ctarget.set_timeout(timeout);         // set timeout
    ctarget.set_readcommunity(community); // set the read community name
    
    //-------[ issue the request, blocked mode ]-----------------------------
    SnmpTarget *target;
    target = &ctarget;
    
    // ソケット通信開始
    Snmp::socket_startup();
    
    Snmp snmp = Snmp(status, 0, (address.get_ip_version() == Address::version_ipv6));
    status = snmp.get_bulk( pdu, *target, 0, 30);
    
    // ソケット通信終了
    Snmp::socket_cleanup();
    
    if (status == SNMP_CLASS_SUCCESS)
    {
        for (int index = 0; index < pdu.get_vb_count(); index++) 
		{
            Vb vb;
            pdu.get_vb( vb,index);
            
            NSString *pstrOid;
            NSString *pstrMib;
            
            // OID
            const char *OID;
            OID = vb.get_printable_oid();
            pstrOid = [NSString stringWithCString:OID encoding:NSUTF8StringEncoding];
            
            char ptr[1024];
            if(vb.get_value(ptr)==SNMP_CLASS_SUCCESS)
            {
                pstrMib = [NSString stringWithCString:ptr encoding:aEncoding];
            }
            else
            {
                pstrMib = [NSString stringWithCString:vb.get_printable_value() encoding:NSUTF8StringEncoding];
            }
            
            [dicMib setObject:pstrMib forKey:pstrOid];
        }
    }
    else
    {
        return dicMib;
    }
    
    return dicMib;
}

- (NSMutableDictionary *)getNext:(NSString *)aVersion
                         retries:(int)aRetries
                         timeout:(int)aTimeout
                       community:(NSString*)aCommunity
                        encoding:(NSStringEncoding)aEncoding
{
    
    // 変数宣言
    NSMutableDictionary *dicMib = [NSMutableDictionary dictionary];
    
    //---------[ determine options to use ]-----------------------------------
    snmp_version version=version2c;                         // SNMPのバージョンを設定
    if ([aVersion isEqualToString: @"v1"])
    {
        version=version1;
    }
    int retries = aRetries;                                // リトライ回数を設定
    int timeout = aTimeout;                                // タイムアウト時間設定
    OctetStr community((char *)[aCommunity UTF8String]);   // コミュニティ名称設定
    
    //----------[ create a SNMP++ session ]-----------------------------------
    int status;
    CTarget ctarget(address);             // make a target using the address
    ctarget.set_version(version);         // set the SNMP version SNMPV1 or V2
    ctarget.set_retry(retries);           // set the number of auto retries
    ctarget.set_timeout(timeout);         // set timeout
    ctarget.set_readcommunity(community); // set the read community name
    
    //-------[ issue the request, blocked mode ]-----------------------------
    SnmpTarget *target;
    target = &ctarget;
    
    // ソケット通信開始
    Snmp::socket_startup();
    
    Snmp snmp = Snmp(status, 0, (address.get_ip_version() == Address::version_ipv6));
    status = snmp.get_next( pdu, *target);
    
    // ソケット通信終了
    Snmp::socket_cleanup();
    
    if (status == SNMP_CLASS_SUCCESS)
    {
        for (int index = 0; index < pdu.get_vb_count(); index++)
		{
            Vb vb;
            pdu.get_vb( vb,index);
            
            NSString *pstrOid;
            NSString *pstrMib;
            
            // OID
            const char *OID;
            OID = vb.get_printable_oid();
            pstrOid = [NSString stringWithCString:OID encoding:NSUTF8StringEncoding];
            
            char ptr[1024];
            if(vb.get_value(ptr)==SNMP_CLASS_SUCCESS)
            {
                pstrMib = [NSString stringWithCString:ptr encoding:aEncoding];
            }
            else
            {
                pstrMib = [NSString stringWithCString:vb.get_printable_value() encoding:NSUTF8StringEncoding];
            }
            
            [dicMib setObject:pstrMib forKey:pstrOid];
        }
    }
    else
    {
        return dicMib;
    }
    
    
    return dicMib;
}


- (int)setOid:(NSMutableArray *)aOidList
{
    for(NSString *pstrSetOid in aOidList)
    {
        pdu += Vb(Oid((char *)[pstrSetOid UTF8String]));
    }
    return 0;
}

- (int)clear
{
    pdu.clear();
    return 0;
}


@end
