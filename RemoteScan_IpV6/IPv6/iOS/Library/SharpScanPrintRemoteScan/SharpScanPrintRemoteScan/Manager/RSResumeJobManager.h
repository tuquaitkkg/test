
#import "RSHttpCommunicationManager.h"

enum
{
    E_NEST_REQUESTJOBIDRESPONSE,
    E_NEST_JOBID,
    E_NEST_REQUESTJOBID_GETVALUE,
};

@interface RSResumeJobManager : RSHttpCommunicationManager
{
    int nNest;

    // JobID
    NSString *strJobId;
}

// 情報取得開始
- (void)updateData:(NSString *)jobId
      originalSize:(NSString *)originalSize
          sendSize:(NSString *)sendSize
        resolution:(NSString *)resolution
      exposureMode:(NSString *)exposureMode
     exposureLevel:(NSInteger *)exposureLevel;

@end
