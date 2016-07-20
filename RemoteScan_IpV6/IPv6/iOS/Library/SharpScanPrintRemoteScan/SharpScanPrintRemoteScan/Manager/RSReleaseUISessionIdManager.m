
#import "RSReleaseUISessionIdManager.h"

enum
{
    E_NEST_REQUESTJOBIDRESPONSE,
    E_NEST_JOBID,
    E_NEST_REQUESTJOBID_GETVALUE,
};

enum
{
    E_PAGE_REQUESTPAGECOUNTRESPONSE,
    E_PAGE_PAGECOUNNT,
    E_PAGE_REQUESTPAGECOUNT_GETVALUE,
};

@implementation RSReleaseUISessionIdManager

@synthesize strStatus;
@synthesize strPageCount;

// 情報取得開始
- (void)updateData:(NSString *)uiSessionId

{
    NSString *requestUrl = @"mfpcommon/ReleaseUISessionId/v1?res=xml";

    // リモートスキャン設定情報取得
    requestUrl = [requestUrl stringByAppendingFormat:@"&uiSessionId=%@", uiSessionId];

    [self getRequest:requestUrl];
}
// ダウンロード成功
- (void)compleatDownloadData
{
    // フラグの初期化
    nNest = E_NEST_JOBID;
    nPage = E_PAGE_PAGECOUNNT;

    [super compleatDownloadData];
}

// 開始タグを検出
- (void)didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName attributes:(NSDictionary *)attributeDict
{
    // /result/GetJobStatusResponse/まで階層を進める
    switch (nNest)
    {
    case E_NEST_JOBID:
        if ([elementName isEqualToString:@"status"])
        {
            nNest++;
        }
        break;
    default:
        nNest = 0;
        break;
    }
    switch (nPage)
    {
    case E_PAGE_PAGECOUNNT:
        if ([elementName isEqualToString:@"skippedPageCount"])
        {
            nPage++;
        }
        break;
    default:
        nPage = 0;
        break;
    }
}

// タグ以外の文字を検出
- (void)foundCharacters:(NSString *)string
{
    switch (nNest)
    {
    case E_NEST_REQUESTJOBID_GETVALUE:
        strStatus = string;
        break;
    default:
        break;
    }

    switch (nPage)
    {
    case E_PAGE_REQUESTPAGECOUNT_GETVALUE:
        strPageCount = string;
        break;
    default:
        break;
    }
}

// 終了タグを検出
- (void)didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName
{
}

@end
