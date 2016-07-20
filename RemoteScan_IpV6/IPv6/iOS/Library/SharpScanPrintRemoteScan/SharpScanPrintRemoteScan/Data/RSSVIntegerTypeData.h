
#import <Foundation/Foundation.h>

@interface RSSVIntegerTypeData : NSObject
{
    int minimumValue;
    int maximumValue;
    int selectValue;
}

@property(assign) int minimumValue;
@property(assign) int maximumValue;
@property(assign) int selectValue;

- (id)initWithValue:(int)defaultValue minimumValue:(int)minValue maximumValue:(int)maxValue;

@end
