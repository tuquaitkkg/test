
#import "RSSESpecialModeData.h"

@implementation RSSESpecialModeData
- (void)setFullValues
{
    fullKeys = [[NSArray alloc] initWithObjects:@"none", @"blank_page_skip", @"blank_and_back_shadow_skip", @"multi_crop", nil];
    fullValues = [[NSArray alloc] initWithObjects:S_RS_XML_SPECIAL_MODE_NONE, S_RS_XML_SPECIAL_MODE_BLANK_PAGE_SKIP, S_RS_XML_SPECIAL_MODE_BLANK_AND_BACK_SHADOW_SKIP, S_RS_XML_SPECIAL_MODE_MULTI_CROP, nil];
    defaultKey = @"none";
    
    // 白紙飛ばし
    fullKeys_blankPageSkip = [[NSArray alloc] initWithObjects:@"none", @"blank_page_skip", @"blank_and_back_shadow_skip", nil];
    fullValues_blankPageSkip = [[NSArray alloc] initWithObjects:S_RS_XML_SPECIAL_MODE_NONE, S_RS_XML_SPECIAL_MODE_BLANK_PAGE_SKIP, S_RS_XML_SPECIAL_MODE_BLANK_AND_BACK_SHADOW_SKIP, nil];
    detailValues_blankPageSkip = [[NSArray alloc] initWithObjects:S_RS_SPECIAL_MODE_DETAIL_NONE, S_RS_SPECIAL_MODE_DETAIL_BLANK_PAGE_SKIP, S_RS_SPECIAL_MODE_DETAIL_BLANK_AND_BACK_SHADOW_SKIP, nil];
    defaultKey_blankPageSkip = @"none";
    
}

- (NSDictionary *)getCapableOptionsForBlankPageSkip
{
    NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithDictionary:[super getCapableOptions]];
    
    for (int i = 0; i < [detailValues_blankPageSkip count]; i++)
    {
        if ([capableKeys containsObject:[fullKeys_blankPageSkip objectAtIndex:i]])
        {
            // 詳細文字列を追加する
            [dict setValue:[detailValues_blankPageSkip objectAtIndex:i] forKey:[NSString stringWithFormat:@"%@_detail", [fullKeys_blankPageSkip objectAtIndex:i]]];
        }
    }
    
    return dict;
}

- (NSArray *)getCapableOptionsKeysForBlankPageSkip
{
    NSMutableArray *arry = [NSMutableArray array];
    
    for (int i = 0; i < [fullKeys_blankPageSkip count]; i++)
    {
        if ([capableKeys containsObject:[fullKeys_blankPageSkip objectAtIndex:i]])
        {
            [arry addObject:[fullKeys_blankPageSkip objectAtIndex:i]];
        }
    }
    
    return arry;
}

- (NSString *)getDefaultKeyForBlankPageSkip
{
    
    NSString *str;
    
    if ([[self getCapableOptionsKeysForBlankPageSkip] containsObject:mfpDefaultKey])
    {
        str = mfpDefaultKey;
    }
    else if ([[self getCapableOptionsKeysForBlankPageSkip] containsObject:defaultKey])
    {
        str = defaultKey;
    }
    else if ([self getCapableOptionsKeysForBlankPageSkip].count > 0){
        // リストの一番上
        str = [[self getCapableOptionsKeysForBlankPageSkip] objectAtIndex:0];
    }
    else {
        str = @"";
    }
    
    return str;
}


@end
