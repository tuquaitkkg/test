
#import "RSHttpCommunicationManager.h"

@interface RSCancelJobManager : RSHttpCommunicationManager

// 情報取得開始
- (void)updateData:(NSString *)jobId;

@end
