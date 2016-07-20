
#import "RSSVListTypeData.h"
#import "RSSVFormatData.h"
#import "RSSVColorModeData.h"

@interface RSSVResolutionData : RSSVListTypeData
- (NSArray *)getSelectableResolutionValues:(RSSVFormatData *)formatData
                                 colorMode:(RSSVColorModeData *)colorMode
                              originalSize:(RSSVOriginalSizeData *)originalSize
                                 multiCrop:(BOOL)bMultiCrop;
- (NSArray *)selectResolutionValues:(NSArray *)selectKeys;
- (NSString *)getSelectResolutionKey:(RSSVFormatData *)formatData
                           colorMode:(RSSVColorModeData *)colorMode
                        originalSize:(RSSVOriginalSizeData *)originalSize;
- (void)setSelectResolutionValue:(NSString *)resolutionValue;

@end
