#import <Foundation/Foundation.h>

#import "ProfileData.h"

#define PROFILEDATA_DAT			@"/profileData.dat"
#define PROFILE_ICON			@"Delicious.png"

@interface ProfileDataManager : NSObject
{
	//
	// インスタンス変数宣言
	//
    NSMutableArray			*pProfileDataList;		// ProfileDataクラス配列
	NSString				*baseDir;				// 設定ファイル格納ディレクトリ
}

//
// プロパティの宣言
//
@property (nonatomic, strong)	NSMutableArray	*pProfileDataList;
@property (nonatomic, copy)		NSString		*baseDir;	// ホームディレクトリ/Documments/

//
// メソッドの宣言
//
- (NSMutableArray *)	ReadProfileData;		// プロパティリストを読み込んでProfileDataクラスを生成
- (BOOL)				saveProfileData;		// ProfileDataクラスの保存
//
- (NSUInteger)			countOfProfileData;		// ProfileData クラスの要素数を戻す
												// 指定したインデックスの ProfileDataクラスを取り出す
- (ProfileData *)	loadProfileDataAtIndex: (NSUInteger)index;
												// 指定したインデックスに ProfileDataクラスを追加 プリントサーバー用
- (BOOL)			addProfileDataAtIndex: (NSUInteger)index newObject:(ProfileData *)newObject;	
												// 指定したインデックスの ProfileDataクラスを置き換える
- (BOOL)			replaceProfileDataAtIndex: (NSUInteger)index newObject:(ProfileData *)newObject;

@end
