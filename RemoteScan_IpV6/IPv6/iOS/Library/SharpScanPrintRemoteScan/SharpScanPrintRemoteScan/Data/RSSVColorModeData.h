
#import "RSSVListTypeData.h"
#import "RSSVOriginalSizeData.h"

@interface RSSVColorModeData : RSSVListTypeData
- (BOOL)isMonochrome:(RSSVOriginalSizeData *)originalSize;
- (NSString *)getSelectColorModeKey:(RSSVOriginalSizeData *)originalSize;

@end
