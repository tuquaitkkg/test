
#import <Foundation/Foundation.h>
#import "TempFile.h"
#import "ScanFile.h"
#import "TempAttachmentFile.h"

@interface GeneralFileUtility : NSObject {
    
}

+ (NSString*)getPrivateDocuments;
+ (BOOL)isTempFilePath:(NSString*) pFilePath;
+ (BOOL)isScanFilePath:(NSString*) pFilePath;
+ (BOOL)isTempAttachmentFilePath:(NSString*) pFilePath;
+ (BOOL)isSubItemOfDirectory:(NSString*) pDirectory CheckItem:(NSString*) pPath;
+ (BOOL)createCacheFile:(NSString*)pFilePath;
+ (BOOL)createThumbnailFile:(NSString*)pFilePath;
+ (BOOL)createRequiredAllImageFiles:(NSString*)pFilePath;
+ (NSArray*)getPreviewFilePaths:(NSString*)pFilePath;

/** 必要な画像ファイルすべてを移動しScanFileを生成します */
+ (BOOL)move:(TempFile*)pTempFile Destination:(ScanFile*) pDestination;

/** 必要な画像ファイルすべてをコピーしScanFileを生成します */
+ (BOOL)copy:(TempFile*)pTempFile Destination:(ScanFile*) pDestination;

/** 必要な画像ファイルすべてをコピーしScanFileを生成します */
+ (BOOL)copy:(TempAttachmentFile*)pTempAttachmentFile ToScanFile:(ScanFile*) pDestination;

/** ディレクトリ階層配下にファイルが一つもなければYESを返します(空フォルダはOK) */
+ (BOOL)isEmptyDirectory:(NSString*)pDirectoryPath;

/** ディレクトリならYESを返します*/
+ (BOOL)isDirectory:(NSString*)pDirectoryPath;

/** ファイルパスからPrintFileのパスを返します */
+ (NSString*) getPrintFilePath:(NSString*)pFilePath;

/** ファイルパスからthumbnailFileのパスを返します */
+ (NSString*) getThumbnailFilePath:(NSString*)pFilePath;

/** ディレクトリを消します*/
+ (BOOL)deleteDirectory:(NSString*)dirName;
@end
