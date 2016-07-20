
#import <Foundation/Foundation.h>


@interface ExcludePrinterDataManager : NSObject {
    
    NSMutableArray* m_parrPrinterData;  // プリンタ情報
    NSString* m_pstrBaseDir;            // ホームディレクトリ/Documments/
//    BOOL m_bFirst;                      // 初回設定フラグ
}

@property(nonatomic,strong) NSMutableArray* ExcludePrinterData;

//@property(nonatomic) BOOL bFirst; // 初回設定フラグ

// 除外プリンタ情報取得
- (void)GetExcludePrinterData;
// 除外プリンタ情報保存
- (BOOL)SaveExcludePrinterData;
// 最後尾にデータを追加して除外プリンタ情報保存
- (BOOL)SaveExcludePrinterData:(NSString*)pAddExcludePrinterName;
// PrinterDataクラスの要素数返却
- (NSUInteger)CountOfExcludePrinterData;
// 指定したインデックスの除外プリンタ情報返却
- (NSString*)LoadExcludePrinterDataAtIndex:(NSUInteger)uIndex;
// 指定したインデックスにPrinterDataクラスを追加
- (BOOL)AddExcludePrinterDataAtIndex:(NSString*)pAddPrinterName;
// 指定したインデックスのPrinterDataクラスを削除
- (BOOL)RemoveAtIndex:(NSUInteger)uIndex;
// 除外リスト初期化
- (void)InitExcludePrinterData;
// 除外リスト一致チェック
- (BOOL)IsExcludePrinterData:(NSString*)pPrinterName;

@end
