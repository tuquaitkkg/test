
#import "RSHttpCommunicationManager.h"

@interface RSRequestUISessionIdManager : RSHttpCommunicationManager
{
    int nNest;

    // UISessionID
    NSString *strUiSessionId;
}

@property(nonatomic, readonly) NSString *sessionId;

// 情報取得開始
- (void)updateData;
@end
