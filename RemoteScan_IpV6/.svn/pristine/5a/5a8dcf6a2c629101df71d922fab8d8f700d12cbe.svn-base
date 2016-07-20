
#import <Foundation/Foundation.h>
#import "TempFile.h"
#import "TempFileUtility.h"

@interface ScanFile : NSObject {
    BOOL        isInit;
    NSString	*scanFileName;
    NSString	*scanFileNameBody;
    NSString	*scanFilePath;
    NSString	*thumbnailFilePath;
    NSString	*printFilePath;
    NSString	*updateDateFilePath;
    NSString	*cacheDirectoryPath;
    NSString	*parentDirectoryPathInScanFile;
    NSString	*parentDirectoryPathOfCacheDirectory;
    NSString	*thumbnailFileName;
    NSString	*printFileName;
    NSString	*updateDateFileName;
    NSString	*cacheDirectoryName;
    NSString	*parentDirectoryNameInScanFile;
    NSString	*parentDirectoryNameOfCacheDirectory;
    NSString	*fileType;
    NSString	*thumbnailFileDirPath;
    NSString    *printFileDirPath;
}
/** 初期化済みフラグ */
@property (nonatomic, readonly) BOOL isInit;

/** ファイル名拡張子つき（Documents/ScanFile） */
@property (nonatomic, readonly) NSString *scanFileName;

/** ファイルパス（Documents/ScanFile） */
@property (nonatomic, readonly) NSString *scanFilePath;

/** サムネイルのパス（PNGFILEフォルダ内） */
@property (nonatomic, readonly) NSString *thumbnailFilePath;

/** png印刷用のjpgファイルのパス */
@property (nonatomic, readonly) NSString *printFilePath;

/** ファイル作成日時保存ファイルのパス */
@property (nonatomic, readonly) NSString *updateDateFilePath;

/** 生成されるCache-始まりのキャッシュ置き場フォルダのパス */
@property (nonatomic, readonly) NSString *cacheDirectoryPath;

/** 親フォルダのパス（Documents/ScanFile） */
@property (nonatomic, readonly) NSString *parentDirectoryPathInScanFile;

/** 親フォルダのパス (TempFile内)*/
@property (nonatomic, readonly) NSString *parentDirectoryPathOfCacheDirectory;

/** サムネイルのファイル名（PNGFILEフォルダ内） */
@property (nonatomic, readonly) NSString *thumbnailFileName;

/** png印刷用のjpgファイル名 */
@property (nonatomic, readonly) NSString *printFileName;

/** ファイル作成日時保存ファイル名 */
@property (nonatomic, readonly) NSString *updateDateFileName;

/** 生成されるCache-始まりのキャッシュ置き場フォルダの名前 */
@property (nonatomic, readonly) NSString *cacheDirectoryName;

/**  親フォルダの名前（Documents/ScanFile）*/
@property (nonatomic, readonly) NSString *parentDirectoryNameInScanFile;

/** 親フォルダのパス（TempFile） */
@property (nonatomic, readonly) NSString *parentDirectoryNameOfCacheDirectory;

/** 拡張子 */
@property (nonatomic, readonly) NSString *fileType;

/** ファイル名（拡張子なし） */
@property (nonatomic, readonly) NSString *scanFileNameBody;

/** サムネイル格納フォルダのパス */
@property (nonatomic, readonly) NSString *thumbnailFileDirPath;

/** png印刷用のjpg格納フォルダのパス */
@property (nonatomic, readonly) NSString *printFileDirPath;

+ (NSString*) getScanDir;
+ (NSString*) getScanFileCacheDir;
- (NSString*) getUpdateDateInScanFile;
- (NSString*) getUpdateDateInCacheDirectory;
- (NSArray*) getPreviewFilePaths;
- (NSArray*) getPreviewFileNames;
- (NSArray*) getPreviewImages;
- (UIImage*) getThumbnailImage;
- (BOOL) existsFileInScanFile;
- (BOOL) existsDirectoryInCacheDirectory;

/** プレビュー存在チェック */
- (BOOL) existsPreviewFile;

/** サムネイル存在チェック */
- (BOOL) existsThumbnailFile;

/** png印刷用jpg存在チェック */
- (BOOL) existsPrintFile;

/** ファイル作成日時保存ファイル存在チェック */
- (BOOL) existsUpdateDateFile;

- (BOOL) isEncryptedFile;
- (BOOL) isRetensionCapable;
- (BOOL) isNupCapable;
- (ScanFile *)initWithScanFilePath:(NSString*)pScanFilePath;
- (ScanFile *)initWithCacheDirectoryPath:(NSString*)pCacheDirectoryPath;

@end
