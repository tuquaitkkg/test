
#import "RSExecuteJobManager.h"

enum
{
    E_NEST_REQUESTJOBIDRESPONSE,
    E_NEST_JOBID,
    E_NEST_REQUESTJOBID_GETVALUE,
};

@implementation RSExecuteJobManager
@synthesize jobId = strJobId;

// 情報取得開始
- (void)updateData:(NSDictionary *)dic
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyyMMddHHmmss"];
    // 24時間表示に変換
    [dateFormatter setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"en_US"]];

    NSString *formattedDateString = [dateFormatter stringFromDate:[NSDate date]];
    NSString *scanFileName = [NSString stringWithFormat:@"Scanfile_%@", formattedDateString];
    NSString *requestUrl = [NSString stringWithFormat:@"mfpscan/ExecuteJob/v1?res=xml&reqType=remoteScanJob&TransferProtocol=ftp&FileName=%@&FtpUrlType=ftp", scanFileName];

    for (NSString *key in [dic allKeys])
    {
        requestUrl = [requestUrl stringByAppendingFormat:@"&%@=%@", key, [RSCommonUtil urlEncode:[dic objectForKey:key]]];
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
        strJobId = [string copy];
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
