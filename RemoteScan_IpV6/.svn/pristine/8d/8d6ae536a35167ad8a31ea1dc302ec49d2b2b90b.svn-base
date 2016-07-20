
#import <Foundation/Foundation.h>
#import "ScanDirectory.h"
#import "ScanFile.h"
#import "ScanFileUtility.h"

@interface ScanDirectoryUtility : NSObject {
    
}

+ (BOOL)deleteDirectory:(ScanDirectory*)pScanDirectory;
+ (BOOL)rename:(ScanDirectory*)pScanDirectory DirectoryName:(NSString*) pDirectoryName;
+ (BOOL)move:(ScanDirectory*)pScanDirectory Destination:(ScanDirectory*) pDestination;
+ (BOOL)copy:(ScanDirectory*)pScanDirectory Destination:(ScanDirectory*) pDestination;
+ (NSArray*)searchScanDirectory:(NSString*)pDirectoryPath Keyword:(NSString*)pKeyword;
+ (NSArray*)getFilesInScanDirectory:(ScanDirectory*)pScanDirectory;
+ (NSArray*)getFilesInCacheDirectory:(ScanDirectory*)pScanDirectory;
+ (NSArray*)getDirectoriesInScanDirectory:(ScanDirectory*)pScanDirectory;
+ (NSArray*)getDirectoriesInCacheDirectory:(ScanDirectory*)pScanDirectory;

// 実データ(ファイル、ディレクトリ)が存在せず、CacheDirectory配下にのみ残っている場合に削除する
+ (BOOL)removeCacheDirectoriesNotExistScanData:(ScanDirectory*)pScanDirectory;

+ (BOOL)createDirectory:(ScanDirectory*)pScanDirectory;
@end
