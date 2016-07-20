
#import "RSSVColorModeData.h"

@implementation RSSVColorModeData

// 白黒2値の場合YESを返す
- (BOOL)isMonochrome:(RSSVOriginalSizeData *)originalSize
{
    // 長尺の場合は白黒2値で固定
    if ([originalSize isLong]) {
        return YES;
    }
    
    if ([select isEqualToString:@"monochrome"]) {
        return YES;
    }
    
    return NO;
}

// 選択中のカラーモードを返す
- (NSString *)getSelectColorModeKey:(RSSVOriginalSizeData *)originalSize
{
    // 長尺の場合は白黒2値で固定
    if ([originalSize isLong]) {
        return @"monochrome";
    }
    
    return select;
}

@end
