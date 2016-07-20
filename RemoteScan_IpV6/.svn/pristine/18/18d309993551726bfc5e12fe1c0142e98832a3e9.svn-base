
#import <Foundation/Foundation.h>
#import "PrinterData.h"

@interface PrinterDataManager : NSObject
{
    NSMutableArray* m_parrPrinterData;  // プリンタ情報
    NSString* m_pstrBaseDir;            // ホームディレクトリ/Documments/
    NSInteger m_nDefaultMfPIndex;       // 選択中MFP
}

@property (nonatomic, strong) NSMutableArray* PrinterDataList;
@property (nonatomic, copy) NSString* BaseDir;
@property (nonatomic)NSInteger DefaultMFPIndex;

// プロパティリストを読み込んでPrinterDataクラスを生成
- (NSMutableArray *)ReadPrinterData;

// プロパティリストを読み込んでPrinterDataクラスを生成（除外されていないMFP）
- (NSMutableArray *)ReadPrinterDataInclude;

// プロパティリストを読み込んでPrinterDataクラスを生成（除外MFP）
- (NSMutableArray *)ReadPrinterDataExclude;

// 除外されていないプリンタのリストとDATファイルのIndexをひも付ける
- (NSMutableArray*)GetIndexListInclude;

// 除外プリンタのリストとDATファイルのIndexをひも付ける
- (NSMutableArray*)GetIndexListExclude;
// PrinterDataクラスの保存
- (BOOL)SavePrinterData;

// PrinterDataクラスの要素数返却
- (NSUInteger)CountOfPrinterData;

// PrinterDataクラスの要素数返却（除外されていないMFP）
- (NSUInteger)CountOfPrinterDataInclude;

// PrinterDataクラスの要素数返却（除外MFP）
- (NSUInteger)CountOfPrinterDataExclude;

// 指定したインデックスのPrinterDataクラスを取り出す
- (PrinterData*)LoadPrinterDataAtIndex:(NSIndexPath*)indexPath;

// 指定したインデックスのPrinterDataクラスを取り出す（除外されていないMFP）
- (PrinterData*)LoadPrinterDataAtIndexInclude:(NSIndexPath*)indexPath;

// 指定したインデックスのPrinterDataクラスを取り出す（除外MFP）
- (PrinterData*)LoadPrinterDataAtIndexExclude:(NSIndexPath*)indexPath;

// 指定したインデックスのPrinterDataクラスを取り出し、選択中MFPフラグを設定
- (PrinterData*)LoadPrinterDataAtIndexWithSetDefaultMFP:(NSIndexPath*)indexPath;

// 指定したインデックスのPrinterDataクラスを取り出し、選択中MFPフラグを設定（除外されていないMFP）
- (PrinterData*)LoadPrinterDataAtIndexWithSetDefaultMFPInclude:(NSIndexPath*)indexPath;

- (PrinterData*)LoadPrinterDataAtIndex2:(NSUInteger)uIndex;

- (PrinterData*)LoadPrinterDataAtIndexInclude2:(NSUInteger)uIndex;

- (PrinterData*)LoadPrinterDataAtIndexExclude2:(NSUInteger)uIndex;

// 指定したインデックスにPrinterDataクラスを追加
- (BOOL)AddPrinterDataAtIndex:(NSUInteger)uIndex
                    newObject:(PrinterData *)newData;	

// 指定したインデックスのPrinterDataクラスを置き換える
- (BOOL)ReplacePrinterDataAtIndex:(NSUInteger)uIndex 
                        newObject:(PrinterData *)newData;

// 指定したインデックスのPrinterDataクラスを移動
- (BOOL)MoveFromIndex:(NSUInteger)uFromIndex
              toIndex:(NSUInteger)uToIndex;

// 指定したインデックスのPrinterDataクラスを削除
- (BOOL)RemoveAtIndex:(NSUInteger)uIndex;

// 指定したキー(ホスト名)に一致するPrinterDataクラスのインデックスを返却
- (NSInteger)GetPrinterIndexForKey:(NSString*)pstrKey;

// 指定したキー(ホスト名)に一致するPrinterDataクラスのインデックスを返却
- (NSInteger)GetPrinterIndexForKeyInclude:(NSString*)pstrKey;

// FTPポート番号更新
- (void)SetPortNo:(NSUInteger)uIndex
           portNo:(NSString*)pstrPortNo;

// FTPポート番号取得
- (NSString*)GetPortNo:(NSUInteger)uIndex;

// 選択中MFPのIndex保持
- (void)SetDefaultMFPIndex:(NSString*) pstrKey PrimaryKeyForCurrrentWifi:(NSString*) pstrKeyForCurrentWiFi;

// リモートスキャン対応スキャナーの数を返却する
- (int) countRemoteScanCapableScanner;

@end
