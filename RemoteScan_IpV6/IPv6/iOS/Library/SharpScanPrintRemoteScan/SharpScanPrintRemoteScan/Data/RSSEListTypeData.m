
#import "RSSEListTypeData.h"

@implementation RSSEListTypeData

- (id)init
{
    self = [super init];
    if (self)
    {
        [self setFullValues];
        capableKeys = [[NSMutableArray alloc] init];
    }
    return self;
}

- (void)addCapableKey:(NSString *)key
{
    [capableKeys addObject:key];
}

- (void)setDefaultKey:(NSString *)key
{
    mfpDefaultKey = [key copy];
}

- (NSDictionary *)getCapableOptions
{
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];

    for (int i = 0; i < [fullKeys count]; i++)
    {
        if ([capableKeys containsObject:[fullKeys objectAtIndex:i]])
        {
            [dict setValue:[fullValues objectAtIndex:i] forKey:[fullKeys objectAtIndex:i]];
        }
    }

    return dict;
}

- (NSArray *)getCapableOptionsKeys
{
    NSMutableArray *arry = [NSMutableArray array];

    for (int i = 0; i < [fullKeys count]; i++)
    {
        if ([capableKeys containsObject:[fullKeys objectAtIndex:i]])
        {
            [arry addObject:[fullKeys objectAtIndex:i]];
        }
    }

    return arry;
}

- (NSString *)getDefaultKey
{
    
    NSString *str;
    
    if ([[self getCapableOptionsKeys] containsObject:mfpDefaultKey])
    {
        str = mfpDefaultKey;
    }
    else if ([[self getCapableOptionsKeys] containsObject:defaultKey])
    {
        str = defaultKey;
    }
    else if ([self getCapableOptionsKeys].count > 0){
        // リストの一番上
        str = [[self getCapableOptionsKeys] objectAtIndex:0];
    }
    else {
        str = @"";
    }
    
    return str;
}

- (NSString *)getDefaultKeyWithSelectableKeys:(NSArray *)selectableOptionKeys
{
    
    NSString *str;
    
    if ([selectableOptionKeys containsObject:mfpDefaultKey])
    {
        str = mfpDefaultKey;
    }
    else if ([selectableOptionKeys containsObject:defaultKey])
    {
        str = defaultKey;
    }
    else if (selectableOptionKeys.count > 0) {
        str = [selectableOptionKeys objectAtIndex:0];
    }
    else {
        str = @"";
    }
    
    return str;
}

// サブクラスで実装
- (void)setFullValues {}

- (NSUInteger)getFullKeyCount
{
    return [fullKeys count];
}

@end
