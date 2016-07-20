
#ifdef _NSSTRING_SIZEWITHFONT_H_
#import "NSString+SizeWithFont.h"
#endif

@implementation NSString (SizeWithFont)

#if defined(_NSSTRING_SIZEWITHFONT_H_) && __IPHONE_OS_VERSION_MIN_REQUIRED >= __IPHONE_7_0

- (CGSize)sizeWithFont:(UIFont *)font
{
    return [self sizeWithAttributes:@{NSFontAttributeName:font}];
}

- (CGSize)sizeWithFont:(UIFont *)font constrainedToSize:(CGSize)size
{
    return [self boundingRectWithSize:size
                               options:NSStringDrawingUsesLineFragmentOrigin
                            attributes:@{NSFontAttributeName:font}
                               context:nil].size;
}

- (CGSize)sizeWithFont:(UIFont *)font constrainedToSize:(CGSize)size lineBreakMode:(NSLineBreakMode)lineBreakMode
{
    NSMutableParagraphStyle *style = [NSMutableParagraphStyle new];
    style.lineBreakMode = lineBreakMode;
    style.alignment = NSTextAlignmentLeft;
    
    return [self boundingRectWithSize:size
                              options:NSStringDrawingUsesLineFragmentOrigin
                           attributes:@{NSFontAttributeName:font, NSParagraphStyleAttributeName:style}
                              context:nil].size;
}

- (CGSize)sizeWithFont:(UIFont *)font minFontSize:(CGFloat)minFontSize actualFontSize:(CGFloat *)actualFontSize forWidth:(CGFloat)width lineBreakMode:(NSLineBreakMode)lineBreakMode
{
    NSMutableParagraphStyle *style = [NSMutableParagraphStyle new];
    style.lineBreakMode = lineBreakMode;
    style.alignment = NSTextAlignmentLeft;
    
    CGSize actualSize = [self sizeWithAttributes:@{NSFontAttributeName:font, NSParagraphStyleAttributeName:style}];
    
    // オリジナルの振る舞いとして、現在のフォントサイズより大きくはならない
    CGFloat rate = 1.0;
    if (actualSize.width > 0.0) {
        CGFloat r = width / actualSize.width;
        if (r < 1.0) rate = r;
    }
    
    // オリジナルの振る舞いとして、0.5ポイント刻み
    CGFloat _actualFontSize = floorf((font.pointSize * rate) * 2.0) / 2.0;
    
    *actualFontSize = MAX(minFontSize, _actualFontSize);
    
    return actualSize;
}

#endif

@end
