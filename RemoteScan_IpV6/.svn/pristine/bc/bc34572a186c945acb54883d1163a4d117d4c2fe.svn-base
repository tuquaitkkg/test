
#import "RSSetDeviceContextManager.h"

@implementation RSSetDeviceContextManager

// 情報取得開始
- (void)updateData:(BOOL)enableRemoteScan remoteScanHost:(NSString *)host remoteScanCode:(NSString *)code remoteScanTimeOut:(NSInteger)timeout vkey:(NSString *)vkey
{
    NSString *requestUrl = @"mfpcommon/SetDeviceContext/v1?res=xml";
    // リモートスキャン設定情報取得
    if (enableRemoteScan)
    {
        // スクリーンロック開始
        requestUrl = [requestUrl stringByAppendingString:@"&enableRemoteScanJob=true"];
        if (host != nil && ![host isEqualToString:@""])
        {
            requestUrl = [requestUrl stringByAppendingFormat:@"&%@=%@", @"remoteScanHost", [RSCommonUtil urlEncode:host]];
        }
        if (code != nil && ![code isEqualToString:@""])
        {
            requestUrl = [requestUrl stringByAppendingFormat:@"&%@=%@", @"remoteScanCode", [RSCommonUtil urlEncode:code]];
        }
        if (vkey != nil && ![vkey isEqualToString:@""])
        {
            requestUrl = [requestUrl stringByAppendingFormat:@"&%@=%@", @"vkey", [RSCommonUtil urlEncode:vkey]];
        }
        requestUrl = [requestUrl stringByAppendingFormat:@"&%@=%ld", @"remoteScanTimeOut", (long)timeout];
    }
    else
    {
        // スクリーンロック停止
        requestUrl = [requestUrl stringByAppendingString:@"&enableRemoteScanJob=false"];
        if (vkey != nil && ![vkey isEqualToString:@""])
        {
            requestUrl = [requestUrl stringByAppendingFormat:@"&%@=%@", @"vkey", [RSCommonUtil urlEncode:vkey]];
        }
    }

    [self getRequest:requestUrl];
}

// ダウンロード成功
- (void)compleatDownloadData
{
    [super compleatDownloadData];
}

// 開始タグを検出
- (void)didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName attributes:(NSDictionary *)attributeDict
{
}

// タグ以外の文字を検出
- (void)foundCharacters:(NSString *)string
{
}

// 終了タグを検出
- (void)didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName
{
}

@end
