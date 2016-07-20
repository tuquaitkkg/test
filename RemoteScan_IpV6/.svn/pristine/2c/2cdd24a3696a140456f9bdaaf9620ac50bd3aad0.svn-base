
#import "RSSVListTypeData.h"

// マルチクロップ統合
#import "RSSVBlankPageSkipData.h"
#import "RSSVMultiCropData.h"
#import "RSSESpecialModeData.h"

@interface RSSVSpecialModeData : RSSVListTypeData
{
    RSSVBlankPageSkipData *blankPageSkipData;
    RSSVMultiCropData *multiCropData;
}

@property (nonatomic) RSSVBlankPageSkipData *blankPageSkipData;
@property (nonatomic) RSSVMultiCropData *multiCropData;

- (id)initWithSpecialMode:(RSSESpecialModeData *)specialModeData;

// MFPがマルチクロップ対応かどうか
- (BOOL)isMultiCropValid;

// マルチクロップがONかどうか
- (BOOL)isMultiCropOn;

// SpecialModeに設定すべき値を返す
- (NSString *)getSelectValue;

// SpecialModeに設定すべき値を設定する
- (void)setSelectValue;

// 特別機能の値を設定する
- (void)setSelectKey:(NSString *)selectKey;

@end
