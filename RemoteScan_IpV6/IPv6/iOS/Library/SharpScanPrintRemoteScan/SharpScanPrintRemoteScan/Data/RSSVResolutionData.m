
#import "RSSVResolutionData.h"

@implementation RSSVResolutionData
// 選択可能な解像度を取得する
- (NSArray *)getSelectableResolutionValues:(RSSVFormatData *)formatData
                                 colorMode:(RSSVColorModeData *)colorMode
                              originalSize:(RSSVOriginalSizeData *)originalSize
                                 multiCrop:(BOOL)bMultiCrop;
{
    
    if (bMultiCrop) {
        // マルチクロップONの場合は600dpiは選択できない
        NSMutableArray *resArray = [[self getSelectableArray] mutableCopy];
        [resArray removeObject:S_RS_XML_RESOLUTION_600];
        
        return resArray;
    }

    if ([colorMode isMonochrome:originalSize]) {
        // 白黒2値の場合は全部の値
        return [self getSelectableArray];
    }
    
    NSString *fileFormatKey = [formatData getSelectFileFormatValue];
    if([formatData isCompactPdf:fileFormatKey])
    {
        // 高圧縮PDFの場合は300dpiのみ
        return [self selectResolutionValues:@[@"300"]];
    }
    
    if ([formatData isPriorityBlack:fileFormatKey])
    {
        // 黒文字重視の場合は300dpiのみ
        return [self selectResolutionValues:@[@"300"]];
    }
    
    // 上記以外の場合は全部の値
    return [self getSelectableArray];
}

// 指定したキーの解像度のみを取得する
- (NSArray *)selectResolutionValues:(NSArray *)selectKeys
{
    NSMutableArray *selectableArray = [[NSMutableArray alloc] init];
    
    for (NSString *str in selectKeys)
    {
        [selectableArray addObject:[dict objectForKey:str]];
    }
    
    return selectableArray;
}

// 選択中の解像度のキーを取得する
- (NSString *)getSelectResolutionKey:(RSSVFormatData *)formatData
                           colorMode:(RSSVColorModeData *)colorMode
                        originalSize:(RSSVOriginalSizeData *)originalSize
{
    if ([colorMode isMonochrome:originalSize]) {
        // 白黒2値の場合は選択中の値
        return [self getSelectValue];
    }
    
    NSString *fileFormatKey = [formatData getSelectFileFormatValue];
    if([formatData isCompactPdf:fileFormatKey])
    {
        // 高圧縮PDFの場合は300dpiで固定
        return @"300";
    }
    
    if ([formatData isPriorityBlack:fileFormatKey])
    {
        // 黒文字重視の場合は300dpiで固定
        return @"300";
    }
    
    // 上記以外の場合は選択中の値
    return [self getSelectValue];
}

// 解像度を値で設定する
- (void)setSelectResolutionValue:(NSString *)resolutionValue
{
    for (NSString *key in dict.keyEnumerator) {
        NSString *value = dict[key];
        if ([value isEqualToString:resolutionValue]) {
            [self setSelectKey:key];
            break;
        }
    }
}

@end
