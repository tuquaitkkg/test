
#import <Foundation/Foundation.h>
#import "ScanData.h"

@interface ScanDataManager : NSObject {
    //
	// インスタンス変数宣言
	//
    NSMutableArray			*ScanDataList;			// ScanDataクラス配列
    NSMutableArray			*filteredList;			// ScanDataクラス配列(Filter)
    NSMutableArray			*scanTempDataList;		// ScanDataクラス配列(temp)
    NSMutableArray			*scanFolderDataList;	// ScanDataクラス配列(temp)
//    NSMutableArray			*scanDataList;			// ScanDataクラス配列(temp)
	NSString				*baseDir;				// ホームディレクトリ/Documments/
	NSUInteger				TempIndex;				// Index.plist のカレントIndex値
//	UITableView				*tView;					// SecondViewController内のTableView
    NSString                *m_fullPath;
    
    NSMutableArray          *m_indexList;             // sectionのインデックスリスト
}

//
// プロパティの宣言
//
@property (nonatomic, copy)		NSString *baseDir;				// ホームディレクトリ/Documments/
//@property (nonatomic, retain)	UITableView *tView;             // ファイル選択画面のTableView
@property (nonatomic, copy)     NSString *fullPath;
@property (nonatomic)			BOOL     IsMoveView;            // 移動する画面
@property (nonatomic)           BOOL     IsSearchView;          // 検索画面
@property (nonatomic)           BOOL     IsAdvancedSearch;      // 詳細検索画面
@property (nonatomic, copy)     NSString *searchKeyword;        // 検索文字
@property(nonatomic)            BOOL     IsSubFolder;           // 検索範囲(サブフォルダーを含む)
@property(nonatomic)            BOOL     IsFillterFolder;       // 検索対象(フォルダー)
@property(nonatomic)            BOOL     IsFillterPdf;          // 検索対象(PDF)
@property(nonatomic)            BOOL     IsFillterTiff;         // 検索対象(TIFF)
@property(nonatomic)            BOOL     IsFillterImage;        // 検索対象(JPEG,PNG)
@property(nonatomic)            BOOL     IsFillterOffice;       // 検索対象(OFFICE)
//
// メソッドの宣言
//
- (NSUInteger)			countOfScanData;									// TempData クラスの要素数を戻す
// 指定したインデックスの ScanData クラスを置き換える
- (BOOL)				removeAtIndex:			(NSIndexPath *)indexPath;	// 指定したインデックスの TempData クラスを削除
// 指定したcollection にScanData クラスを追加
- (BOOL)				addScanData:			(NSMutableArray *)collectionData addScanData:(ScanData *)addScanData;
- (NSMutableArray *)	getScanData;					// スキャンデータの読み込み
- (void)				reGetScanData;					// スキャンデータの再読み込み

- (ScanData *) loadScanDataAtIndexPath:(NSIndexPath *)indexPath;             // 指定したインデックスの ScanDataクラスを取り出す
- (NSMutableArray *) loadScanDataAtSection:	(NSUInteger)section;		// 指定したインデックスの ScanDataクラスを取り出す(section指定)

- (BOOL)checkFolderData:(NSString*)dirName;

// 指定した文字に一致する ScanDataクラスを取り出す
//
//- (void)loadFillterData:(NSString*)searchText;

// ScanDataクラスの検索結果の数を戻す
- (NSUInteger) countOfSearchScanData;    // 期待される値がセクション数なので, numberOfSectionを返すように変更

// ファイルパスに一致するScanDataのindexPath (section, row)を返す  存在しない場合はnilを返す
- (NSIndexPath*) indexOfScanDataWithFilePath: (NSString*)fileFullPath;
// section, rowのScanDataのfilePathを返す
- (NSString*) filePathAtIndexPath: (NSIndexPath *)indexPath;

@end
