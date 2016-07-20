
#import "RSSVListTypeData.h"
#import "RSSEDuplexDirData.h"
#import "RSSEDuplexModeData.h"

@interface RSSVDuplexData : RSSVListTypeData
{
    // RSSEDupulexModeDataから作成したものを格納
    NSMutableDictionary *modeDict;
    NSMutableArray *modeKeys;
    NSString *modeSelect;

    // RSSEDuplexDirDataから作成したものを格納
    NSMutableDictionary *dirDict;
    NSMutableArray *dirKeys;
    NSString *dirSelect;
}

- (id)initWithDuplexModeData:(RSSEDuplexModeData *)pMode duplexDirData:(RSSEDuplexDirData *)pDir;

// 選択されたDuplexModeのKey(ExecuteJobでセットするべき値)を返却
- (NSString *)getSelectDuplexModeValue;
// 選択されたDuplexDirのKey(ExecuteJobでセットするべき値)を返却
- (NSString *)getSelectDuplexDirValue;
// 選択された項目の画像名を返却（選択中の項目の画像を画面読み込む際に使用）
- (NSString *)getSelectValueImageName;
// 指定したインデックスの項目の画像名を返却（選択中の項目の画像を画面読み込む際に使用）
- (NSString *)getSelectValueImageName:(int)selectIndex;
// 選択したキーをセットする
- (void)setSelectModeKey:(NSString *)selectModeKey dirKey:(NSString *)selectDireKey;
// 選択された項目のkeyを返却（選択中の項目を判別する際に使用）
- (NSString *)getSelectValue;
@end
