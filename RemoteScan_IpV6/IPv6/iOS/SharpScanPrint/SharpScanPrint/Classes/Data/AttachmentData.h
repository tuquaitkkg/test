
#import <Foundation/Foundation.h>

@interface AttachmentData : NSObject {
    //
	// インスタンス変数宣言
	//
    NSString	*fname;									// 表示名称
    NSString	*crdate;								// 作成日時
    NSString	*imagename;								// 縮小画像ファイル名(png)
    NSString	*index;									// インデック(作成年月)
    NSInteger	sectionNumber;							//
    NSString	*crdate_yymm;							// 作成年月(グループ化用)
    NSString	*crdate_yymmdd;							// 作成年月日(検索用)
    NSString	*filesize;								// ファイルサイズ
    BOOL        isDirectory;                            // ディレクトリの判別
    NSString	*fpath;                                 // 保存ファイルパス
}

//
// プロパティの宣言
//
@property (nonatomic, copy)		NSString	*fname;				// 表示名称
@property (nonatomic, copy)		NSString	*crdate;			// 作成日時
@property (nonatomic, copy)		NSString	*imagename;			// 縮小画像ファイル名(png)
@property (nonatomic, copy)		NSString	*index;				// インデック(作成年月)
@property (nonatomic)			NSInteger	sectionNumber;
@property (nonatomic, copy)		NSString	*crdate_yymm;		// 作成年月日
@property (nonatomic, copy)		NSString	*crdate_yymmdd;		// 作成年月日
@property (nonatomic, copy)     NSString    *filesize;          // ファイルサイズ
@property (nonatomic)           BOOL        isDirectory;        // ディレクトリの判別
@property (nonatomic, copy)     NSString    *fpath;             // 保存ファイルパス

- (NSString*)fileSizeUnit;
- (NSString*)fileSizeAbout;
- (NSString*)fileType;
- (NSInteger)fileTypeNumber;

@end
