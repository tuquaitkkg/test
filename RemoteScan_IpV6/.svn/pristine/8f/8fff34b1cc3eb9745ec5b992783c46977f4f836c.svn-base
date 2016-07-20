
#import "RSCustomPaperSizeListData.h"

@implementation RSCustomPaperSizeListData

- (id)init
{
    self = [super init];
    if (self)
    {
        keyArray = [[NSMutableArray alloc] init];
        valueArray = [[NSMutableArray alloc] init];
    }
    return self;
}

- (void)setValue:(RSCustomPaperSizeData *)value forKey:(NSString *)key
{
    [keyArray addObject:key];
    [valueArray addObject:value];
}

- (NSDictionary *)getPagerSizeDict
{
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];

    for (int i = 0; i < [keyArray count]; i++)
    {
        NSString *str = [keyArray objectAtIndex:i];
        BOOL isExtraSize = [str hasPrefix:@"extraSize"];
        if (isExtraSize)
        {
            // keyがextraSizeで始まる場合は表示名を編集しない
            [dict setObject:[[valueArray objectAtIndex:i] name] forKey:[keyArray objectAtIndex:i]];
        }
        else
        {
            // keyがextraSizeで始まらない(customSizeで始まる)場合は表示名を編集する
            [dict setObject:[[valueArray objectAtIndex:i] getDisplayName] forKey:[keyArray objectAtIndex:i]];
        }
    }

    return dict;
}

- (NSArray *)getPaperSizeArray
{
    return keyArray;
}

- (RSCustomPaperSizeData *)getCustomPaperSizeData:(NSString *)key
{
    return [valueArray objectAtIndex:[keyArray indexOfObject:key]];
}

@end
