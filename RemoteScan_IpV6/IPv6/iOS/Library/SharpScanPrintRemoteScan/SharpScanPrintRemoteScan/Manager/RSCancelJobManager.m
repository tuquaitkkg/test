
#import "RSCancelJobManager.h"

@implementation RSCancelJobManager

- (void)updateData:(NSString *)jobId
{
    NSString *requestUrl = @"mfpscan/CancelJob/v1?res=xml&reqType=remoteScanJob";

    // リモートスキャン設定情報取得
    requestUrl = [requestUrl stringByAppendingFormat:@"&jobId=%@", jobId];

    [self getRequest:requestUrl];
}

// ダウンロード成功
- (void)compleatDownloadData
{
    // 仮実装（何か処理がいるかも）

    [super compleatDownloadData];
}
@end
