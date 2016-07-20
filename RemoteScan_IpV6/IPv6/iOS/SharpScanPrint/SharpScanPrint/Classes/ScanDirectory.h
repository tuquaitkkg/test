
#import <Foundation/Foundation.h>

@interface ScanDirectory : NSObject {
    BOOL        isInit;
    BOOL        isRootDirectory;
    NSString    *scanDirectoryName;
    NSString    *scanDirectoryNameBody;
    NSString    *cacheDirectoryName;
    NSString    *cacheDirectoryNameBody;
    NSString    *scanDirectoryPath;
    NSString    *cacheDirectoryPath;
    NSString    *dirPrefix;
    NSString	*parentDirectoryPathInScanFile;
}
/** 初期化済みフラグ */
@property (nonatomic, readonly) BOOL     isInit;

/** Documents/ScanFile/直下にいるか */
@property (nonatomic, readonly) BOOL     isRootDirectory;

/** フォルダ名 */
@property (nonatomic, readonly) NSString *scanDirectoryName;

/** フォルダ名 */
@property (nonatomic, readonly) NSString *scanDirectoryNameBody;

/** tempFile側のフォルダ名 */
@property (nonatomic, readonly) NSString *cacheDirectoryName;

/** 接頭辞を除いたフォルダ名 */
@property (nonatomic, readonly) NSString *cacheDirectoryNameBody;

/** フォルダパス（Documents側） */
@property (nonatomic, readonly) NSString *scanDirectoryPath;

/** フォルダのScanFile以下のパス（Documents側） */
@property (nonatomic, readonly) NSString *relativeDirectoryPathInScanFile;

/** フォルダパス(TempFile側) */
@property (nonatomic, readonly) NSString *cacheDirectoryPath;

/** ユーザがフォルダを作った時につく接頭辞"DIR-" */
@property (nonatomic, readonly) NSString *dirPrefix;

/**　親ディレクトリのフルパス　*/
@property (nonatomic, readonly) NSString *parentDirectoryPathInScanFile;

- (BOOL) isEmptyDirectoryInScanFile;
- (BOOL) isEmptyDirectoryInCacheDirectory;
- (BOOL) existsDirectoryInScanFile;
- (BOOL) existsDirectoryInCacheDirectory;

/** フォルダのフルパスから初期化するメソッドです */
- (ScanDirectory*)initWithScanDirectoryPath:(NSString*)pScanDirectoryPath;
- (ScanDirectory*)initWithCacheDirectoryPath:(NSString*)pCacheDirectoryPath;
/** フォルダ（scanFile側）の相対パスを絶対パスから取得するメソッドです */
+ (NSString *)getRelativePathInScanFile :(NSString*)pScanDirectoryPath;
@end
