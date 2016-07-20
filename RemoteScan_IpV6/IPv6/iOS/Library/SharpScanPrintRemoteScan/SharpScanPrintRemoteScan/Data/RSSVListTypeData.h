
#import <Foundation/Foundation.h>

@interface RSSVListTypeData : NSObject
{
    NSMutableDictionary *dict;
    NSMutableArray *keys;
    NSString *select;
}

- (id)initWithDictionary:(NSDictionary *)dictionary keys:(NSArray *)keys defaultValue:(NSString *)defaultValue;

// ディクショナリの追加
- (void)addEntriesFromDictionary:(NSDictionary *)otherDictionary keys:(NSArray *)array;
// 画面にリスト表示するNSArrayを返却
- (NSArray *)getSelectableArray;
// 画面で選択した項目をセットする
- (void)setSelectValue:(NSInteger)selectValue;
// 選択したキーをセットする
- (void)setSelectKey:(NSString *)selectKey;
// 画面での選択値を返却する
- (NSUInteger)getSelectIndex;
// 選択された項目のKey(ExecuteJobでセットするべき値)を返却
- (NSString *)getSelectValue;
// 画面で指定した項目のkeyを返却（画面で指定した項目を表示する際に使用）
- (NSString *)getSelectValue:(int)selectIndex;
// 選択された項目の表示名を返却（選択中の項目を画面表示する際に使用）
- (NSString *)getSelectValueName;
// 指定した項目の表示名を返却（指定したkeyの項目を画面表示する際に使用）
- (NSString *)getSpecifiedValueName:(NSString *)specifiedKey;
//キーが存在するか判定
- (BOOL)isExistKey:(NSString *)key;

@end
