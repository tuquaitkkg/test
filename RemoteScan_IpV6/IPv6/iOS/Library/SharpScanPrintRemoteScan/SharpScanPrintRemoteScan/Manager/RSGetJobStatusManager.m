
#import "RSGetJobStatusManager.h"

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

@implementation RSGetJobStatusManager

@synthesize strStatus;
@synthesize strPageCount;
@synthesize endThread;

// 情報取得開始
- (void)updateData:(NSString *)jobId

{
    NSString *requestUrl = @"mfpscan/GetJobStatus/v1?res=xml&reqType=remoteScanJob";

    // リモートスキャン設定情報取得
    requestUrl = [requestUrl stringByAppendingFormat:@"&jobId=%@", jobId];
    requestUrl = [requestUrl stringByAppendingString:@"&reqType=remoteScanJob"];

    [self getRequest:requestUrl];
}

// ジョブステータス取得のポーリングを開始する
- (void)startPollingThreadWithJobId:(NSString *)jobId timeInterval:(int)ti delegate:(id)jsDelegate
{
    jobStatusDelegate = jsDelegate;

    strPollingUrl = @"mfpscan/GetJobStatus/v1?res=xml";
    // リモートスキャン設定情報取得
    strPollingUrl = [strPollingUrl stringByAppendingFormat:@"&jobId=%@", jobId];
    strPollingUrl = [strPollingUrl stringByAppendingString:@"&reqType=remoteScanJob"];

    endThread = NO;
    timeInterval = (ti > 2 ? ti : 2); // 最低２秒
    [self performSelector:@selector(getJobStatusThreadWithPollingUrl:) withObject:strPollingUrl];
}

- (void)getJobStatusThreadWithPollingUrl:(NSString *)strUrl
{
    if (!endThread)
    {
        // ジョブステータス取得
        [self getRequest:strUrl];
        [self performSelector:@selector(getJobStatusThreadWithPollingUrl:) withObject:strUrl afterDelay:timeInterval];
    }
}

// ダウンロード成功
- (void)compleatDownloadData
{
    // フラグの初期化
    nNest = E_NEST_JOBID;
    nPage = E_PAGE_PAGECOUNNT;

    [super compleatDownloadData];
}

- (void)statusCheck
{
    if (jobStatusDelegate)
    {
        int nStatus = 0;
        if ([self string:strStatus isEqualToString:@"STARTED"])
        {
            nStatus = E_RS_JOB_STATUS_STARTED;
        }
        else if ([self string:strStatus isEqualToString:@"SCANNED"])
        {
            nStatus = E_RS_JOB_STATUS_SCANNED;
        }
        else if ([self string:strStatus isEqualToString:@"QUEUED"])
        {
            nStatus = E_RS_JOB_STATUS_QUEUED;
        }
        else if ([self string:strStatus isEqualToString:@"STOPPED"])
        {
            nStatus = E_RS_JOB_STATUS_STOPPED;
        }
        else if ([self string:strStatus isEqualToString:@"CANCELED"])
        {
            nStatus = E_RS_JOB_STATUS_CANCELED;
            endThread = YES;
        }
        else if ([self string:strStatus isEqualToString:@"FINISHED"])
        {
            nStatus = E_RS_JOB_STATUS_FINISHED;
            endThread = YES;
        }
        else if ([self string:strStatus isEqualToString:@"ERROR"])
        {
            nStatus = E_RS_JOB_STATUS_ERROR;
            endThread = YES;
        }
        else if ([self string:strStatus isEqualToString:@"ERROR_ALL_PAGE_BLANK"])
        {
            nStatus = E_RS_JOB_STATUS_ERROR_ALL_PAGE_BLANK;
            endThread = YES;
        }
        else
        {
            // その他 エラーとしておく
            nStatus = E_RS_JOB_STATUS_ERROR;
        }

        [jobStatusDelegate rsManager:self gotJobStatus:nStatus];
    }
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
        strStatus = [string copy];
        break;
    default:
        break;
    }

    switch (nPage)
    {
    case E_PAGE_REQUESTPAGECOUNT_GETVALUE:
        strPageCount = [string copy];
        break;
    default:
        break;
    }
}

// 終了タグを検出
- (void)didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName
{
}

- (void)parserDidEndDocument
{
    [self statusCheck];
}

@end
