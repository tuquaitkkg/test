
#import "RSHttpCommunicationManager.h"

@interface RSReleaseUISessionIdManager : RSHttpCommunicationManager
{
    int nNest;
    int nPage;

    NSString *__unsafe_unretained strStatus;    // status
    NSString *__unsafe_unretained strPageCount; // skippedPageCount
}
@property(unsafe_unretained, nonatomic, readonly) NSString *strStatus;
@property(unsafe_unretained, nonatomic, readonly) NSString *strPageCount;

- (void)updateData:(NSString *)uiSessionId;

@end
