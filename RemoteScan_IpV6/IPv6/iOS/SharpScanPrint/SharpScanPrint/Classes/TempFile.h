
#import <Foundation/Foundation.h>

@interface TempFile : NSObject {
    BOOL        isInit;
    NSString    *thumbnailFilePath;
    NSString    *printFilePath;
    NSString    *cacheDirectoryPath;
    NSString    *tempFilePath;
    NSString    *thumbnailFileName;
    NSString    *printFileName;
    NSString    *cacheDirectoryName;
    NSString    *tempFileName;
    NSString    *fileType;
    NSNumber    *previousViewController;
    BOOL        isWEB;
}

/** 初期化済みフラグ */
@property (nonatomic, readonly) BOOL isInit;

/** サムネイルのパス（PNGFILEフォルダ内） */
@property (nonatomic, readonly) NSString *thumbnailFilePath;

/** png印刷用のjpgファイルのパス */
@property (nonatomic, readonly) NSString *printFilePath;

/** 生成されるCache-始まりのキャッシュ置き場フォルダのパス */
@property (nonatomic, readonly) NSString *cacheDirectoryPath;

/** 一時ファイルパス（Documents/TempFile） */
@property (nonatomic, readonly) NSString *tempFilePath;

/** サムネイルのファイルのパス */
@property (nonatomic, readonly) NSString *thumbnailFileName;

/** png印刷用のjpgファイル名 */
@property (nonatomic, readonly) NSString *printFileName;

/** 生成されるCache-始まりのキャッシュ置き場フォルダの名前 */
@property (nonatomic, readonly) NSString *cacheDirectoryName;

/** tempファイルのファイル名 */
@property (nonatomic, readonly) NSString *tempFileName;

/** 拡張子 */
@property (nonatomic, readonly) NSString *fileType;

/** メール、ウェブかどうか */
@property (nonatomic, readonly) BOOL isWEB;

/** TempFileディレクトリを取得 */
+ (NSString*) getTmpDir;

/** プレビューファイルjpgのパスすべてを取得 */
- (NSArray*) getPreviewFilePaths;

/** プレビューファイルjpgの名前すべてを取得 */
- (NSArray*) getPreviewFileNames;

/** プレビューファイルjpgの画像すべてを取得 */
- (NSArray*) getPreviewImages;

/** tempFile存在チェック */
- (BOOL) existsTempFile;

/** プレビュー存在チェック */
- (BOOL) existsPreviewFile;

/** サムネイル存在チェック */
- (BOOL) existsThumbnailFile;

/** png印刷用jpg存在チェック */
- (BOOL) existsPrintFile;

/** ファイル名によりtempFileの"がわ"を生成 */
- (TempFile *)initWithFileName:(NSString*)pFileName;

/** ウェブ、メール印刷のときにtempFileの"がわ"を生成 */
- (TempFile *)initWithPrintDataPdf;

@end
