
#import "RSSVBlankPageSkipData.h"

@implementation RSSVBlankPageSkipData

// 画面にリスト表示するNSArrayを返却
- (NSArray *)getDetailArray
{
    NSMutableArray *detailArray = [[NSMutableArray alloc] init];
    for (__strong NSString *str in keys)
    {
        str = [NSString stringWithFormat:@"%@_detail", str];
        DLog(@"%@ %@", str, [dict objectForKey:str]);
        [detailArray addObject:[dict objectForKey:str]];
    }
    
    return detailArray;
}

// 選択された項目の詳細情報を返却（選択中の項目を画面表示する際に使用）
- (NSString *)getSelectDetailValueName
{
    return [dict objectForKey:[NSString stringWithFormat:@"%@_detail", select]];
}

@end

