
#import "RSSEBooleanTypeData.h"

@implementation RSSEBooleanTypeData

- (void)setFullValues
{
    fullKeys = [[NSArray alloc] initWithObjects:@"true", @"false", nil];
    fullValues = [[NSArray alloc] initWithObjects:S_RS_XML_TRUE, S_RS_XML_FALSE, nil];
    defaultKey = @"false";
}

// Booleanのデータとして有効な場合YESを返す
- (BOOL)isValidBoolean
{
    NSArray *booleanKeys = [self getCapableOptionsKeys];
    if (![booleanKeys containsObject:@"true"]) {
        return NO;
    }
    
    if (![booleanKeys containsObject:@"false"]) {
        return NO;
    }
    
    return YES;
}

@end
