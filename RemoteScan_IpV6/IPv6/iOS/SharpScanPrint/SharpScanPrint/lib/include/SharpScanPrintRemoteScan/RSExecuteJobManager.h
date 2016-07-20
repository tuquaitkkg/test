
#import "RSHttpCommunicationManager.h"
#import "RSCommonUtil.h"

@interface RSExecuteJobManager : RSHttpCommunicationManager
{
    int nNest;

    // JobID
    NSString *strJobId;
}
- (void)updateData:(NSDictionary *)dic;

@property(nonatomic, readonly) NSString *jobId;

@end
