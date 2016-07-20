
#import "RSSVDuplexData.h"
#define DICT_KEY(m, d) [NSString stringWithFormat:@"%@+%@", m, d]

@implementation RSSVDuplexData

// 初期化のオーバーライド
// メンバを初期化するだけで、値は格納しない
- (id)initWithDictionary:(NSDictionary *)dictionary keys:(NSArray *)array defaultValue:(NSString *)defaultValue
{
    self = [super initWithDictionary:nil keys:nil defaultValue:@""];
    if (self)
    {
        modeDict = [[NSMutableDictionary alloc] init];
        modeKeys = [[NSMutableArray alloc] init];
        modeSelect = @"";

        dirDict = [[NSMutableDictionary alloc] init];
        dirKeys = [[NSMutableArray alloc] init];
        dirSelect = @"";
    }
    return self;
}

// ModeとDirを指定して初期化
- (id)initWithDuplexModeData:(RSSEDuplexModeData *)pMode duplexDirData:(RSSEDuplexDirData *)pDir
{
    self = [self initWithDictionary:nil keys:nil defaultValue:@""];
    if (self)
    {
        [modeDict addEntriesFromDictionary:[pMode getCapableOptions]];
        [modeKeys addObjectsFromArray:[pMode getCapableOptionsKeys]];
        modeSelect = [pMode getDefaultKey];

        [dirDict addEntriesFromDictionary:[pDir getCapableOptions]];
        [dirKeys addObjectsFromArray:[pDir getCapableOptionsKeys]];
        dirSelect = [pDir getDefaultKey];

        [self updateMember];

        select = [DICT_KEY(modeSelect, dirSelect) copy];
    }
    return self;
}

// メンバ(dict, keys)の値を更新する
- (void)updateMember
{
    // 統合した情報を格納
    for (NSString *modeKey in modeKeys)
    {
        if ([modeKey isEqualToString:@"simplex"])
        {
            // 片面
            for (NSString *dirKey in dirKeys)
            {
                // book or tablet
                NSString *modeName = [NSString stringWithFormat:@"%@", [modeDict objectForKey:modeKey]];
                NSString *keyName = DICT_KEY(modeKey, dirKey);
                [dict setObject:modeName forKey:keyName];
            }

            NSMutableDictionary *keyDic = [NSMutableDictionary dictionary];
            [keyDic setObject:modeKey forKey:@"mode"];
            [keyDic setObject:@"book" forKey:@"dir"];

            [keys addObject:keyDic];
        }
        else if ([modeKey isEqualToString:@"duplex"])
        {
            // 両面
            for (NSString *dirKey in dirKeys)
            {
                // book or tablet
                NSString *modeName = [NSString stringWithFormat:@"%@ %@ ", [modeDict objectForKey:modeKey], [dirDict objectForKey:dirKey]];
                NSString *keyName = DICT_KEY(modeKey, dirKey);
                [dict setObject:modeName forKey:keyName];

                NSMutableDictionary *keyDic = [NSMutableDictionary dictionary];
                [keyDic setObject:modeKey forKey:@"mode"];
                [keyDic setObject:dirKey forKey:@"dir"];

                [keys addObject:keyDic];
            }
        }
    }
}

// Modeディクショナリの追加
- (void)addEntriesFromModeDictionary:(NSDictionary *)otherDictionary keys:(NSArray *)array
{
    [modeDict addEntriesFromDictionary:otherDictionary];
    [modeKeys addObjectsFromArray:array];

    [self updateMember];
}
// Dirディクショナリの追加
- (void)addEntriesFromDirDictionary:(NSDictionary *)otherDictionary keys:(NSArray *)array
{
    [dirDict addEntriesFromDictionary:otherDictionary];
    [dirKeys addObjectsFromArray:array];

    [self updateMember];
}

// 画面にリスト表示するNSArrayを返却
- (NSArray *)getSelectableArray
{
    NSMutableArray *selectableArray = [[NSMutableArray alloc] init];
    for (NSDictionary *dic in keys)
    {
        NSString *mode = [dic objectForKey:@"mode"];
        NSString *dir = dirSelect;
        if ([mode isEqualToString:@"duplex"])
        {
            dir = [dic objectForKey:@"dir"];
        }
        DLog(@"%@ %@", DICT_KEY(mode, dir), [dict objectForKey:DICT_KEY(mode, dir)]);
        [selectableArray addObject:[dict objectForKey:DICT_KEY(mode, dir)]];
    }

    return selectableArray;
}

// 画面で選択した項目をセットする
- (void)setSelectValue:(NSInteger)selectIndex
{
    NSDictionary *dic = [keys objectAtIndex:selectIndex];
    modeSelect = [dic objectForKey:@"mode"];
    dirSelect = [dic objectForKey:@"dir"];

    select = [DICT_KEY(modeSelect, dirSelect) copy];
}

// 選択したキーをセットする
- (void)setSelectModeKey:(NSString *)selectModeKey dirKey:(NSString *)selectDireKey
{
    if (![selectModeKey isEqualToString:@""] && ![selectDireKey isEqualToString:@""])
    {
        modeSelect = selectModeKey;
        dirSelect = selectDireKey;

        select = [DICT_KEY(modeSelect, dirSelect) copy];
    }
}

// 画面での選択値を返却する
- (NSUInteger)getSelectIndex
{
    NSUInteger res = 0;

    NSArray *selectableArray = [self getSelectableArray];
    NSString *selectName = [self getSelectValueName];
    res = [selectableArray indexOfObject:selectName];

    return res;
}

// 選択されたDuplexModeのKey(ExecuteJobでセットするべき値)を返却
- (NSString *)getSelectDuplexModeValue
{
    return modeSelect;
}
// 選択されたDuplexDirのKey(ExecuteJobでセットするべき値)を返却
- (NSString *)getSelectDuplexDirValue
{
    return dirSelect;
}

// 選択された項目の表示名を返却（選択中の項目を画面表示する際に使用）
- (NSString *)getSelectValueName
{
    return [dict objectForKey:select];
}

// 選択された項目のkeyを返却（選択中の項目を判別する際に使用）
- (NSString *)getSelectValue
{
    return select;
}

// 選択された項目の画像名を返却（選択中の項目の画像を画面読み込む際に使用）
- (NSString *)getSelectValueImageName
{
    // "Duplex_simplex.png" or "Duplex_duplex_book.png" or "Duplex_duplex_tablet.png"
    NSString *imgName = @"";
    imgName = [NSString stringWithFormat:@"Duplex_%@", modeSelect];

    if ([modeSelect isEqualToString:@"duplex"])
    {
        // 両面
        imgName = [NSString stringWithFormat:@"%@_%@", imgName, dirSelect];
    }

    [imgName stringByAppendingPathExtension:@"png"];

    return imgName;
}

// 指定したインデックスの項目の画像名を返却（選択中の項目の画像を画面読み込む際に使用）
- (NSString *)getSelectValueImageName:(int)selectIndex
{
    NSDictionary *dic = [keys objectAtIndex:selectIndex];
    // "Duplex_simplex.png" or "Duplex_duplex_book.png" or "Duplex_duplex_tablet.png"
    NSString *imgName = @"";
    imgName = [NSString stringWithFormat:@"Duplex_%@", [dic objectForKey:@"mode"]];

    if ([[dic objectForKey:@"mode"] isEqualToString:@"duplex"])
    {
        // 両面
        imgName = [NSString stringWithFormat:@"%@_%@", imgName, [dic objectForKey:@"dir"]];
    }

    [imgName stringByAppendingPathExtension:@"png"];

    return imgName;
}

@end
