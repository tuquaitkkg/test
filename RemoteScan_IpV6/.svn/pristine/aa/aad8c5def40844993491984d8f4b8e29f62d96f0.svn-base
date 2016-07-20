
#import <Foundation/Foundation.h>
#import "ScanFile.h"
#import "ScanDirectory.h"

@interface ScanFileUtility : NSObject {
    
}

+ (BOOL)deleteFile:(ScanFile*)pScanFile;
+ (BOOL)rename:(ScanFile*)pScanFile FileName:(NSString*) pFileName;
+ (BOOL)move:(ScanFile*)pScanFile Destination:(ScanFile*) pDestination;
+ (BOOL)moveToDirectory:(ScanFile*)pScanFile Destination:(ScanDirectory*) pDestination;
+ (BOOL)copy:(ScanFile*)pScanFile Destination:(ScanFile*) pDestination;
+ (BOOL)cacheRecreateCheck:(ScanFile*)pScanFile;
+ (BOOL)save:(ScanFile*)pScanFile;
+ (NSString*) getRootDir;
+ (NSString*) getRootCacheDir;
+ (BOOL)convertToVersion2_2;
+ (BOOL)isConvertVersion2_2;

+ (NSNumber*)getFileSize:(ScanFile*)pScanFile;
+ (BOOL)createThumbnailFile:(ScanFile*)pScanFile;
+ (BOOL)createPrintFile:(ScanFile*)pScanFile;
+ (BOOL)createPreviewFiles:(ScanFile*)pScanFile;
+ (BOOL)saveUpdateDate:(ScanFile*)pScanFile;
+ (NSArray*)searchScanFile:(NSString*)pDirectoryPath Keyword:(NSString*)pKeyword;
+ (NSArray*)searchScanFileInDetail:(NSArray*)pArgs;
+ (NSArray*)searchScanDirectoryInDetail:(NSArray*)pArgs;
+ (NSString*)getDocumentsDirectoryPath;
+ (NSString*)getScanFileDirectoryPath;
+ (NSString*)createNumberedFileName :(NSString*)renamedFileName defaultFileName:(NSString*)defaultFileName;
/** 必要な画像ファイルすべてを生成します */
+ (BOOL)createRequiredAllImageFiles:(ScanFile*)pScanFile;
+ (BOOL)createCacheFile:(ScanFile*)pScanFile;
@end
