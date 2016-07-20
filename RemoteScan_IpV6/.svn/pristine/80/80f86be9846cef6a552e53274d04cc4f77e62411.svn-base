#import <Foundation/Foundation.h>

#import "TempData.h"
#import "TempDataCell.h"
#import "TempFile.h"
#import "TempFileUtility.h"
#import "ScanFile.h"

@interface TempDataManager : NSObject 
{
	//
	// インスタンス変数宣言
	//
    NSMutableArray			*TempDataList;			// TempDataクラス配列
//    NSMutableArray			*filteredList;			// TempDataクラス配列(Filter)
    NSMutableArray			*atempDataList;			// TempDataクラス配列(temp)
	NSString				*baseDir;				// ホームディレクトリ/Documments/
	NSUInteger				TempIndex;				// Index.plist のカレントIndex値
//	UITableView				*tView;					// SecondViewController内のTableView
    NSString                *saveFileName;          // 保存名
}

//
// プロパティの宣言
//
//@property (nonatomic, retain)	NSMutableArray *TempDataList;	// TempDataクラス配列
//@property (nonatomic, retain)	NSMutableArray *filteredList;	// TempDataクラス配列(Filter)
@property (nonatomic, strong)	NSMutableArray *atempDataList;	// TempDataクラス配列(temp)
@property (nonatomic, copy)		NSString *baseDir;				// ホームディレクトリ/Documments/
//@property (nonatomic, retain)	UITableView *tView;				// SecondViewController内のTableView
@property (nonatomic)			NSUInteger TempIndex;			// Index.plist のカレントIndex値
@property (nonatomic, copy)     NSString *fullPath;
@property (nonatomic, copy)     NSString *saveFileName;

//
// メソッドの宣言
//
- (id)init:(NSString*)directory;
- (NSUInteger)			countOfTempData;									// TempData クラスの要素数を戻す
// 指定したインデックスの TempData クラスを置き換える
- (TempData *)loadTempDataAtIndexPath:(NSIndexPath *)indexPath;
- (BOOL)				removeAtIndex:			(NSIndexPath *)indexPath;	// 指定したインデックスの TempData クラスを削除
- (BOOL)                removeFile;                                         //TempDataの削除
- (BOOL)				setIndexTempData:		(NSMutableArray *)tempDataList;
// 指定したcollection にTempData クラスを追加
- (BOOL)				addTempData:			(NSMutableArray *)collectionData addTempData:(TempData *)addTempData;
- (NSMutableArray *)	getTempData;					// スキャンデータの読み込み
- (void)				reGetTempData;					// スキャンデータの再読み込み
- (BOOL)moveTempData;
- (BOOL)copyTempData;
- (BOOL)controlTempData:(BOOL)isMove;




@end
