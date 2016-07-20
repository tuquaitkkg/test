
#import "RSSVListTypeData.h"

@implementation RSSVListTypeData

- (id)initWithDictionary:(NSDictionary *)dictionary keys:(NSArray *)array defaultValue:(NSString *)defaultValue
{
    self = [super init];
    if (self)
    {
        if (dictionary != nil)
        {
            dict = [[NSMutableDictionary alloc] initWithDictionary:dictionary];
            DLog(@"%@", dict);
        }
        else
        {
            dict = [[NSMutableDictionary alloc] init];
        }
        if (array != nil)
        {
            keys = [[NSMutableArray alloc] initWithArray:array];
        }
        else
        {
            keys = [[NSMutableArray alloc] init];
        }

        select = [[NSString alloc] initWithString:defaultValue];
    }
    return self;
}

// ディクショナリの追加
- (void)addEntriesFromDictionary:(NSDictionary *)otherDictionary keys:(NSArray *)array
{
    [dict addEntriesFromDictionary:otherDictionary];
    [keys addObjectsFromArray:array];
}

// 画面にリスト表示するNSArrayを返却
- (NSArray *)getSelectableArray
{
    NSMutableArray *selectableArray = [[NSMutableArray alloc] init];
    for (NSString *str in keys)
    {
        DLog(@"%@ %@", str, [dict objectForKey:str]);
        [selectableArray addObject:[dict objectForKey:str]];
    }

    return selectableArray;
}
// 画面で選択した項目をセットする
- (void)setSelectValue:(NSInteger)selectIndex
{
    select = [keys objectAtIndex:selectIndex];
}
// 選択したキーをセットする
- (void)setSelectKey:(NSString *)selectKey
{
    if ([keys indexOfObject:selectKey] != NSNotFound)
    {
        select = selectKey;
    }
}
// 画面での選択値を返却する
- (NSUInteger)getSelectIndex
{
    return [keys indexOfObject:select];
}
// 選択された項目のKey(ExecuteJobでセットするべき値)を返却
- (NSString *)getSelectValue
{
    return select;
}
// 画面で指定した項目のkeyを返却（画面で指定した項目を表示する際に使用）
- (NSString *)getSelectValue:(int)selectIndex
{
    return [keys objectAtIndex:selectIndex];
}
// 選択された項目の表示名を返却（選択中の項目を画面表示する際に使用）
- (NSString *)getSelectValueName
{
    return [dict objectForKey:select];
}
// 指定した項目の表示名を返却（指定したkeyの項目を画面表示する際に使用）
- (NSString *)getSpecifiedValueName:(NSString *)specifiedKey
{
    return [dict objectForKey:specifiedKey];
}

//キーが存在するか
- (BOOL)isExistKey:(NSString *)key
{
    return [keys containsObject:key];
}

- (NSString *)description
{
    NSMutableString *str = [NSMutableString string];
    [str appendFormat:@"dict   = %@\n", dict];
    [str appendFormat:@"key    = %@\n", keys];
    [str appendFormat:@"select = %@", select];
    return str;
}
@end
