
#import <Foundation/Foundation.h>


@interface PrintOutDataManager : NSObject
{
    NSUserDefaults* m_pUserDefault; // 設定値取得/登録
    NSString* m_pstrPrinterName;    // 最新印刷情報 プリンタ名
    NSString* m_pstrNumOfSets;      // 最新印刷情報 部数
    NSString* m_pstrSide;           // 最新印刷情報 両面/片面
}

// 最新印刷情報 プライマリキー取得
- (NSString*)GetLatestPrimaryKey; // プリンター

- (NSString*)GetLatestPrimaryKey2; // プリントサーバー

// 接続先WiFiでの最新印刷情報 プライマリキー取得
- (NSString*)GetLatestPrimaryKeyForCurrentWiFi; // プリンター

- (NSString*)GetLatestPrimaryKeyForCurrentWiFi2; // プリントサーバー

// 最新印刷情報 プリントタイプ　1:プリンター/スキャナー 2:プリントサーバー
- (NSInteger)GetLatestPrintType;

/*
// 最新印刷情報 部数index取得
- (NSInteger)GetLatestIdxNumOfSets;

// 最新印刷情報 部数取得
- (NSString*)GetLatestNumOfSets;

// 最新印刷情報 両面/片面index取得
- (NSInteger)GetLatestIdxSide;

// 最新印刷情報 両面/片面取得
- (NSString*)GetLatestSide;
*/

// 最新印刷情報 プライマリキー登録
- (BOOL)SetLatestPrimaryKey:(NSString*)pstrValue; // プリンター
- (BOOL)SetLatestPrimaryKey2:(NSString*)pstrValue; // プリントサーバー

// 最新印刷情報 プリントタイプ　1:プリンター/スキャナー 2:プリントサーバー
- (BOOL)SetLatestPrintType:(NSInteger)nValue;

/*
// 最新印刷情報 部数index登録
- (BOOL)SetLatestIdxNumOfSets:(NSInteger)nValue;

// 最新印刷情報 部数登録
- (BOOL)SetLatestNumOfSets:(NSString*)pstrVaule;

// 最新印刷情報 部数index登録
- (BOOL)SetLatestIdxSide:(NSInteger)nValue;

// 最新印刷情報 両面/片面登録
- (BOOL)SetLatestSide:(NSString*)pstrVaule;
*/
@end
