
#import <Foundation/Foundation.h>
#import "MailServerData.h"

#define MAILSERVERDATA_DAT		@"/mailServerData.dat"

@interface MailServerDataManager : NSObject
{
	//
	// インスタンス変数宣言
	//
    NSMutableArray			*paMailServerDataList;	// ProfileDataクラス配列
	NSString				*baseDir;				// 設定ファイル格納ディレクトリ
}

//
// プロパティの宣言
//
@property (nonatomic, strong)	NSMutableArray	*pMailServerDataList;
@property (nonatomic, copy)		NSString		*baseDir;	// ホームディレクトリ/Documments/

//
// メソッドの宣言
//
- (NSMutableArray *)	ReadMailServerData;		// プロパティリストを読み込んでProfileDataクラスを生成
- (BOOL)				saveMailServerData;		// ProfileDataクラスの保存
//
- (NSUInteger)			countOfMailServerData;		// ProfileData クラスの要素数を戻す
// 指定したインデックスの ProfileDataクラスを取り出す
- (MailServerData *)	loadMailServerDataAtIndex: (NSUInteger)index;
// 指定したインデックスに ProfileDataクラスを追加
- (BOOL)			addMailServerDataAtIndex: (NSUInteger)index newObject:(MailServerData *)newObject;
// 指定したインデックスの ProfileDataクラスを置き換える
- (BOOL)			replaceMailServerDataAtIndex: (NSUInteger)index newObject:(MailServerData *)newObject;


@end
