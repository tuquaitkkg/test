
#import "RSSVBoolTypeData.h"

@implementation RSSVBoolTypeData

@synthesize canEnable;
@synthesize isEnable;

- (id)init
{
    self = [super init];
    if (self)
    {
        canEnable = YES;
        isEnable = YES;
    }
    return self;
}

@end
