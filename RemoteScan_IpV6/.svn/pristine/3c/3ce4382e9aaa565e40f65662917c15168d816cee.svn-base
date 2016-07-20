
#import "RSSVListTypeData.h"

// マルチクロップ統合
#import "RSSVBlankPageSkipData.h"
#import "RSSVMultiCropData.h"
#import "RSSESpecialModeData.h"

@interface RSSVSpecialModeData : RSSVListTypeData
{
    RSSVBlankPageSkip *blankPageSkipData;
    RSSVMultiCropData *multiCropData;
}

// 画面にリスト表示するNSArrayを返却
//- (NSArray *)getDetailArray;
//- (NSString *)getSelectDetailValueName;

////////////////////////
// マルチクロップと統合
///////////////////////
@property (nonatomic) RSSVBlankPageSkip *blankPageSkipData;
@property (nonatomic) RSSVMultiCropData *multiCropData;

//@property (nonatomic) BOOL isValidMultiCrop;

- (id)initWithSpecialMode:(RSSESpecialModeData *)specialModeData;

// MFPがマルチクロップ対応かどうか
- (BOOL)isMultiCropValid;

// マルチクロップがONかどうか
- (BOOL)isMultiCropOn;

// SpecialModeに設定すべき値を返す
- (NSString *)getSelectValue;

// SpecialModeに設定すべき値を設定する(未使用)
- (void)setSelectValue;

// 特別機能の値を設定する
- (void)setSelectKey:(NSString *)selectKey;

@end
