
#import <Foundation/Foundation.h>

@interface RSCustomPaperSizeData : NSObject
{
    NSString *name;       // 名称
    int paperWidthMilli;  // 幅（ミリ）
    int paperHeightMilli; // 高さ（ミリ）
    int paperWidthInch;   // 幅（インチ）
    int paperHeightInch;  // 高さ（インチ）
    NSString *paperWidthInchLow;
    NSString *paperHeightInchLow;

    NSString *customSizeKey; // customSize1〜5 のどれかを設定する

    BOOL bMilli;
}

@property(nonatomic, copy) NSString *name;
@property(nonatomic) int paperWidthMilli;
@property(nonatomic) int paperHeightMilli;
@property(nonatomic) int paperWidthInch;
@property(nonatomic) int paperHeightInch;
@property(nonatomic, copy) NSString *paperWidthInchLow;
@property(nonatomic, copy) NSString *paperHeightInchLow;

@property(nonatomic, copy) NSString *customSizeKey;

@property(nonatomic) BOOL bMilli;

- (id)initWithInchValue:(NSString *)paperName width:(float)paperWidth height:(float)paperHeight;
- (id)initWithMilliValue:(NSString *)paperName width:(float)paperWidth height:(float)paperHeight;

- (NSString *)getDisplayName;
- (int)getMilliWidth;
- (int)getMilliHeight;
- (float)getFloatInch:(NSString *)strInchLow;

@end
