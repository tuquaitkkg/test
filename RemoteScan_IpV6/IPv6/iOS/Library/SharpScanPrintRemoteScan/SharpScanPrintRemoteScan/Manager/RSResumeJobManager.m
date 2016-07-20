
#import "RSResumeJobManager.h"

@implementation RSResumeJobManager

// 情報取得開始
- (void)updateData:(NSString *)jobId
      originalSize:(NSString *)originalSize
          sendSize:(NSString *)sendSize
        resolution:(NSString *)resolution
      exposureMode:(NSString *)exposureMode
     exposureLevel:(NSInteger *)exposureLevel
{
    NSString *requestUrl = @"mfpscan/ResumeJob/v1?res=xml&reqType=remoteScanJob";

    // リモートスキャン設定情報取得
    requestUrl = [requestUrl stringByAppendingFormat:@"&jobId=%@", jobId];

    if (originalSize != nil && ![originalSize isEqualToString:@""])
    {
        requestUrl = [requestUrl stringByAppendingFormat:@"&OriginalSize=%@", originalSize];
    }
    if (sendSize != nil && ![sendSize isEqualToString:@""])
    {
        requestUrl = [requestUrl stringByAppendingFormat:@"&SendSize=%@", sendSize];
    }
    if (resolution != nil && ![resolution isEqualToString:@""])
    {
        requestUrl = [requestUrl stringByAppendingFormat:@"&Resolution=%@", resolution];
    }
    if (exposureMode != nil && ![exposureMode isEqualToString:@""])
    {
        requestUrl = [requestUrl stringByAppendingFormat:@"&ExposureMode=%@", exposureMode];
    }
    if (exposureLevel != nil)
    {
        requestUrl = [requestUrl stringByAppendingFormat:@"&ExposureLevel=%ld", (long)*exposureLevel];
    }

    [self getRequest:requestUrl];
}

// ダウンロード成功
- (void)compleatDownloadData
{
    // フラグの初期化
    nNest = E_NEST_JOBID;

    [super compleatDownloadData];
}

// 開始タグを検出
- (void)didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName attributes:(NSDictionary *)attributeDict
{
    // /result/ExecuteJobResponse/jobId/まで階層を進める
    switch (nNest)
    {
    case E_NEST_JOBID:
        if ([elementName isEqualToString:@"jobId"])
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
    case E_NEST_REQUESTJOBID_GETVALUE:
        strJobId = string;
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
