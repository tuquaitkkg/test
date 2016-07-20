#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
#import "CommonUtil.h"

@interface PrintPictManager : NSObject
// 両面関連
// 両面印刷が出来る用紙サイズか判定
+ (BOOL)checkCanDuplexPaperSize:(NSString*)strPaperSize;
// 両面印刷ができる用紙タイプか判定
+ (BOOL)checkCanDuplexPaperType:(NSString*)strPaperType;

// ステープル関連
// ステープルを設定できる用紙サイズかどうかを判定する：用紙サイズ選択時
+ (BOOL)checkCanStaplePaperSize:(BOOL)isStapleless andPaperSize:(NSString*)strPaperSize;
// パンチを設定できる用紙サイズかどうかを判定する：用紙サイズ選択時
+ (BOOL)checkCanPunchPaperSize:(NSString*)strPaperSize;

//　仕上げ設定画面のステープルの活性/非活性を判定する
+ (BOOL)checkFinishingSettingViewStapleEnable:(STAPLE)staple andPaperSize:(NSString*)strPaperSize;
//　仕上げ設定画面のパンチの活性/非活性を判定する
+ (BOOL)checkFinishingSettingViewPunchEnable:(PunchData*)punchData andPaperSize:(NSString*)strPaperSize;

// ステープルを設定できる用紙タイプか判定する
+ (BOOL)checkCanStaplePaperType:(NSString*)strPaperType;
// パンチを設定できる用紙タイプか判定する
+ (BOOL)checkCanPunchPaperType:(NSString*)strPaperType;

// 針なしステープルが選択されているかどうかを判定
+ (BOOL)isStaplelessStapleSelected:(STAPLE)staple andSelectedIndex:(NSInteger)nSelectedIndex andPaperSize:(NSString*)strPaperSize;
// ステープルの選択肢リストを返す
+ (NSMutableArray*)getSelectableStaple:(STAPLE)staple andPaperSize:(NSString*)strPaperSize;
// パンチの選択肢リストを返す
+ (NSMutableArray*)getSelectablePunch:(PunchData*)punchData andPaperSize:(NSString*)strPaperSize;
// 現在選択しているステープルのPJL用の文字列を返す
+ (NSString*)getStaplePJLString:(NSString*)strStaple;
// 現在選択しているパンチのPJL用の文字列を返す
+ (NSString*)getPunchPJLString:(NSString*)strPunch;

// 印刷データが選択されている状態かどうかの判定
+ (BOOL)checkPrintDataSelected:(PrintPictViewID)printPictViewID
                  andFileCount:(NSInteger)selFileCnt
                  andPictCount:(NSInteger)selPictCnt
                  andTotalPage:(NSInteger)totalPageCnt
                   andFilePath:(NSString*)strFilePath
               andIsSingleData:(BOOL)isSingleData;
@end
