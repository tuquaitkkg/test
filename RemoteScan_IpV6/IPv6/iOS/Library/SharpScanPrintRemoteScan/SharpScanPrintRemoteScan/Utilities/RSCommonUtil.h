
#import <Foundation/Foundation.h>
#import <CFNetwork/CFNetwork.h>
#import "RSNetworkInformation.h"

@interface RSCommonUtil : NSObject
{
}

//設定ファイル格納ディレクトリを取得する
+ (NSString *)settingFileDir;

// IPアドレス取得する
+ (NSString *)getIPAdder;

// 文字列をUTF-8でURLEncodeする
+ (NSString *)urlEncode:(NSString *)str;

// IPv6グローバルアドレスであるかの判定
+ (BOOL)isIPv6GlobalAddress:(NSString*)string;

@end
