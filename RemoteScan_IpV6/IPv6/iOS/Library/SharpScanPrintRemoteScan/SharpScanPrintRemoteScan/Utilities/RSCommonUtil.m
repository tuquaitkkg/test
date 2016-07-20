
#import <SystemConfiguration/CaptiveNetwork.h>
#import <ImageIO/ImageIO.h>
#import "RSCommonUtil.h"
#import "RSNetworkInformation.h"

@implementation RSCommonUtil

//設定ファイル格納ディレクトリを取得する
+ (NSString *)settingFileDir
{
    // Libraryの取得
    NSArray *libraryPaths = NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES);
    NSString *libraryPath = [libraryPaths lastObject];
    // Library/PrivateDocuments の取得
    NSString *privateDocumentsPath = [libraryPath stringByAppendingPathComponent:@"PrivateDocuments"];
    
    return privateDocumentsPath;
}

//
// IPアドレスの取得
//

+ (NSString *)getIPAdder
{

    RSNetworkInformation *niManager = [[RSNetworkInformation alloc] init];
    NSString *ip = niManager.primaryIPv4Address;
    
    if (ip != nil) {
        return ip;
    }
    
    ip = niManager.primaryIPv6Address;
    return ip;
    
    /*
     NSArray		*adders	= [[NSHost currentHost] addresses];
     NSString	*iPaddr	= [adders objectAtIndex:1];
     
     NSRange searchResult = [iPaddr rangeOfString:@"::"];
     if (searchResult.location == NSNotFound)
     {
     // 見つからない（接続時）
     return iPaddr;
     }
     else
     {
     // 見つかった（接続時）
     return nil;
     }
     */
}

// 文字列をUTF-8でURLEncodeする
+ (NSString *)urlEncode:(NSString *)str
{
    NSString *retStr = ((NSString *)CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(NULL,
                                                                                              (CFStringRef)str,
                                                                                              NULL,
                                                                                              (CFStringRef) @"!*'();:@&=+$,/?%#[]",
                                                                                              kCFStringEncodingUTF8)));
    return retStr;
}

/**
 @brief IPv6グローバルアドレスであるかの判定
 */
+ (BOOL)isIPv6GlobalAddress:(NSString*)string {
    
    NSString *chkStr = [string substringToIndex:1];
    
    if ([chkStr compare:@"2"] == NSOrderedSame ||
        [chkStr compare:@"3"] == NSOrderedSame ||
        [chkStr compare:@"4"] == NSOrderedSame ||
        [chkStr compare:@"5"] == NSOrderedSame ||
        [chkStr compare:@"6"] == NSOrderedSame ||
        [chkStr compare:@"7"] == NSOrderedSame ||
        [chkStr compare:@"8"] == NSOrderedSame ||
        [chkStr compare:@"9"] == NSOrderedSame ||
        [chkStr compare:@"a"] == NSOrderedSame ||
        [chkStr compare:@"b"] == NSOrderedSame ||
        [chkStr compare:@"c"] == NSOrderedSame ||
        [chkStr compare:@"d"] == NSOrderedSame )
    {
        return YES;
    }
    else if ([chkStr compare:@"e"] == NSOrderedSame)
    {
        chkStr = [string substringToIndex:4];
        if ([chkStr compare:@"e000"] == NSOrderedSame) {
            return YES;
        }
    }
    
    return NO;
    
}


@end
