#import "RSSVMultiCropData.h"

@implementation RSSVMultiCropData

- (id)initWithDictionary:(NSDictionary *)dictionary defaultValue:(NSString *)defaultValue {
    self = [super init];
    if (self)
    {
        self.isMultiCropValid = NO;
        self.bMultiCrop = NO;
        
        if (dictionary != nil) {
            for (id key in [dictionary keyEnumerator]) {
                if ([key isEqualToString:@"multi_crop"]) {
                    self.isMultiCropValid = YES;
                }
            }
        }
        
        if ([defaultValue isEqualToString:@"multi_crop"] && self.isMultiCropValid) {
            self.bMultiCrop = YES;
        }
        
    }
    return self;
    
}

@end