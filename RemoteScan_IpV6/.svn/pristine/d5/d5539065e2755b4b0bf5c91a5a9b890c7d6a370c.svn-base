
#import "RSHttpCommunicationManager.h"
#import "RSDefine.h"

@class RSGetJobStatusManager;

@protocol RSGetJobStatusManagerDelegate
@optional
- (void)rsManager:(RSGetJobStatusManager *)manager gotJobStatus:(int)status;
@end

@interface RSGetJobStatusManager : RSHttpCommunicationManager <NSXMLParserDelegate>
{
    NSObject<RSGetJobStatusManagerDelegate> *jobStatusDelegate;

    int nNest;
    int nPage;

    NSString *strStatus;    // status
    NSString *strPageCount; // skippedPageCount

    BOOL endThread;
    int timeInterval;
    NSString *strPollingUrl;
}
@property(nonatomic, readonly) NSString *strStatus;
@property(nonatomic, readonly) NSString *strPageCount;
@property(assign) BOOL endThread;

- (void)startPollingThreadWithJobId:(NSString *)jobId timeInterval:(int)ti delegate:(id)jsDelegate;

@end
