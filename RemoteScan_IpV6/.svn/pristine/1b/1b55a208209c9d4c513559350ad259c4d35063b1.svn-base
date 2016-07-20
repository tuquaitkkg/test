
#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

#ifndef _NSSTRING_SIZEWITHFONT_H_
#define _NSSTRING_SIZEWITHFONT_H_
#endif

@interface NSString (SizeWithFont)

#if __IPHONE_OS_VERSION_MIN_REQUIRED >= __IPHONE_7_0 // NS_AVAILABLE_IOS(7_0)

- (CGSize)sizeWithFont:(UIFont *)font;

- (CGSize)sizeWithFont:(UIFont *)font constrainedToSize:(CGSize)size;

- (CGSize)sizeWithFont:(UIFont *)font constrainedToSize:(CGSize)size lineBreakMode:(NSLineBreakMode)lineBreakMode;

- (CGSize)sizeWithFont:(UIFont *)font minFontSize:(CGFloat)minFontSize actualFontSize:(CGFloat *)actualFontSize forWidth:(CGFloat)width lineBreakMode:(NSLineBreakMode)lineBreakMode;

#endif

@end
