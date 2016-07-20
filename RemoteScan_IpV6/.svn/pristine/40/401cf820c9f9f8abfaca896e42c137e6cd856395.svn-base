
#import "RSHttpCommunicationManager.h"
#import "RSCommonUtil.h"

@interface RSGetDeviceStatusManager : RSHttpCommunicationManager
{
    int nNest;
    int nSysName;

    NSString *feederSize;
    NSString *platenSize;
    NSString *currentMode;
    NSString *detectableMinWidth;
    NSString *detectableMinHeight;

    NSString *tmpSize;
    NSString *tmpSource;
}

@property(nonatomic, readonly) NSString *feederSize;
@property(nonatomic, readonly) NSString *platenSize;

@property(nonatomic, readonly) NSString *currentMode;

@property(nonatomic, readonly) NSString *detectableMinWidth;
@property(nonatomic, readonly) NSString *detectableMinHeight;

// 情報取得開始
- (void)updateData;

@end
