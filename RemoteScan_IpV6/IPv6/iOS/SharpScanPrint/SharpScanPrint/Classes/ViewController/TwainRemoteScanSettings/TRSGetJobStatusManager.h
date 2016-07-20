
#import "TRSHttpCommunicationManager.h"
#import "RSDefine.h"

@class TRSGetJobStatusManager;

@protocol TRSGetJobStatusManagerDelegate
@optional
-(void)rsManager:(TRSGetJobStatusManager*)manager gotJobStatus:(int)status;
@end

@interface TRSGetJobStatusManager : TRSHttpCommunicationManager <NSXMLParserDelegate>
{
    NSObject<TRSGetJobStatusManagerDelegate>* jobStatusDelegate;
    
    int nNest;
    int nPage;

    NSString* strStatus;    // status
    NSString* strPageCount; // skippedPageCount
    
    BOOL endThread;
    int timeInterval;
    NSString* strPollingUrl;
    
}
@property (nonatomic, readonly) NSString* strStatus;
@property (nonatomic, readonly) NSString* strPageCount;
@property (assign) BOOL endThread;

-(void)startPollingThreadWithJobId:(NSString*)jobId timeInterval:(int)ti delegate:(id)jsDelegate;

@end
