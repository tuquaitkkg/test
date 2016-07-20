
#import "RSRequestUISessionIdManager.h"

enum
{
    E_NEST_REQUESTUISESSIONIDRESPONSE,
    E_NEST_UISESSIONID,
    E_NEST_REQUESTUISESSIONID_GETVALUE,
};

@implementation RSRequestUISessionIdManager
@synthesize sessionId = strUiSessionId;

// 情報取得開始
- (void)updateData
{
    // リモートスキャン設定情報取得
    [self getRequest:@"mfpcommon/RequestUISessionId/v1?res=xml&RemoteScanTimeOut=30"];
}

// ダウンロード成功
- (void)compleatDownloadData
{
    // フラグの初期化
    nNest = E_NEST_UISESSIONID;

    [super compleatDownloadData];
}

// 開始タグを検出
- (void)didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName attributes:(NSDictionary *)attributeDict
{
    // /result/RequestUISessionIdResponse/uiSessionId/まで階層を進める
    switch (nNest)
    {
    case E_NEST_UISESSIONID:
        if ([elementName isEqualToString:@"uiSessionId"])
        {
            nNest++;
        }
        break;
    default:
        nNest = 0;
        break;
    }
}

// タグ以外の文字を検出
- (void)foundCharacters:(NSString *)string
{
    switch (nNest)
    {
    case E_NEST_REQUESTUISESSIONID_GETVALUE:
        strUiSessionId = [string copy];
        nNest--;
        break;
    default:
        break;
    }
}

@end
