
#import "RSSEIntegerTypeData.h"

@implementation RSSEIntegerTypeData

- (id)init
{
    self = [super init];
    if (self)
    {
        [self setValues];
    }
    return self;
}

- (void)setMinimumValue:(int)value
{
    if (minimumValue < value)
    {
        minimumValue = value;
    }
}
- (int)getMinimumValue
{
    return minimumValue;
}

- (void)setMaximumValue:(int)value
{
    if (maximumValue > value)
    {
        maximumValue = value;
    }
}
- (int)getMaximumValue
{
    return maximumValue;
}

- (void)setDefaultValue:(int)value
{
    if (minimumValue <= value && value <= maximumValue)
    {
        defaultValue = value;
    }
}
- (int)getDefaultVale
{
    return defaultValue;
}

// サブクラスで実装
- (void)setValues{};

@end
