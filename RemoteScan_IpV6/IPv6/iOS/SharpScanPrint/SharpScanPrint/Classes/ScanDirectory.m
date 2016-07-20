
#import "ScanDirectory.h"
#import "ScanFile.h"
#import "GeneralFileUtility.h"
#import "ScanFileUtility.h"

@implementation ScanDirectory

@synthesize isInit;
@synthesize isRootDirectory;
@synthesize scanDirectoryName;
@synthesize cacheDirectoryName;
@synthesize scanDirectoryPath;
@synthesize cacheDirectoryPath;
@synthesize cacheDirectoryNameBody;
@synthesize dirPrefix;
@synthesize scanDirectoryNameBody;
@synthesize relativeDirectoryPathInScanFile;
@synthesize parentDirectoryPathInScanFile;

- (id)init
{
    if ((self = [super init]) == nil)
    {
        return nil;
    }
    /** 初期化済みフラグ */
    isInit                 = NO;
    
    /** /Documents/直下にいるか */
    isRootDirectory        = NO;
    
    /** ユーザが作ったフォルダを示す接頭辞"DIR-" */
    dirPrefix              = @"DIR-";
    
    /** フォルダ名 Documents側 */
    scanDirectoryName      = nil;
    
    /**  フォルダ名 Temp側*/
    cacheDirectoryName     = nil;
    
    /** キャッシュ格納場所の名前 */
    cacheDirectoryNameBody = nil;
    
    /** フォルダパス Documents側 */
    scanDirectoryPath      = nil;
    
    /** フォルダパス(temp側) */
    cacheDirectoryPath     = nil;
    
    /** フォルダのScanFile以下のパス（Documents側） */
    relativeDirectoryPathInScanFile = nil;
    
    return self;
}

- (void)dealloc
{
}

- (BOOL) isEmptyDirectoryInScanFile{
    if (!self.isInit) {
        return YES;
    }
    if (![self existsDirectoryInScanFile]) {
        return YES;
    }

    return [GeneralFileUtility isEmptyDirectory:self.scanDirectoryPath];
}

- (BOOL) isEmptyDirectoryInCacheDirectory{
    if (!self.isInit) {
        return YES;
    }
    if (![self existsDirectoryInCacheDirectory]) {
        return YES;
    }

    return [GeneralFileUtility isEmptyDirectory:self.cacheDirectoryPath];
}

- (BOOL) existsDirectoryInScanFile{
    if (!self.isInit) {
        return NO;
    }
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    return [fileManager fileExistsAtPath:self.scanDirectoryPath];
}

- (BOOL) existsDirectoryInCacheDirectory{
    if (!self.isInit) {
        return NO;
    }
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    return [fileManager fileExistsAtPath:self.cacheDirectoryPath];
}

+ (NSString *)getRelativePathInScanFile :(NSString*)pScanDirectoryPath {
    NSArray *rootArray = [[ScanFile getScanDir] pathComponents];
    NSArray *scanDirectoryArray = [pScanDirectoryPath pathComponents];
    if (rootArray.count <= scanDirectoryArray.count) {
        for(int i = 0; i < rootArray.count; i++){
            NSString *leftPath = [rootArray objectAtIndex:i];
            NSString *rightPath = [scanDirectoryArray objectAtIndex:i];
            if (![leftPath isEqualToString:rightPath]) {
                return nil;
            }
        }
    } else {
        return nil;
    }
    NSString *relativePath = @"";
    for(NSUInteger i = rootArray.count; i < scanDirectoryArray.count; i++){
        NSString *srcPath = [scanDirectoryArray objectAtIndex:i];
        if (srcPath.length < 1) {
            return nil;
        }
//        if (![srcPath hasPrefix:@"DIR-"]) {
//            return nil;
//        }
//        NSString *dstPath = [@"/" stringByAppendingString:[srcPath substringFromIndex:4]];
        NSString *dstPath = [@"/" stringByAppendingString:srcPath];
        relativePath = [relativePath stringByAppendingString:dstPath];
    }
    return relativePath;
}

+ (NSString *)getCacheDirectoryPathInScanFile :(NSString*)pScanDirectoryPath {
    NSArray *rootArray = [[ScanFile getScanDir] pathComponents];
    NSArray *scanDirectoryArray = [pScanDirectoryPath pathComponents];
    if (rootArray.count <= scanDirectoryArray.count) {
        for(int i = 0; i < rootArray.count; i++){
            NSString *leftPath = [rootArray objectAtIndex:i];
            NSString *rightPath = [scanDirectoryArray objectAtIndex:i];
            if (![leftPath isEqualToString:rightPath]) {
                return nil;
            }
        }
    } else {
        return nil;
    }
    NSString *cacheDirectoryPath = [ScanFileUtility getRootCacheDir];
    for(NSUInteger i = rootArray.count; i < scanDirectoryArray.count; i++){
        NSString *srcPath = [scanDirectoryArray objectAtIndex:i];
        if (srcPath.length < 1) {
            return nil;
        }
//        if (![srcPath hasPrefix:@"DIR-"]) {
//            return nil;
//        }
        // NSString *dstPath = [@"/" stringByAppendingString:[srcPath substringFromIndex:4]];
        NSString *dstPath = [@"/DIR-" stringByAppendingString:srcPath];
        cacheDirectoryPath = [cacheDirectoryPath stringByAppendingString:dstPath];
    }
    return cacheDirectoryPath;
}

+ (NSString *)getScanFilePathInCacheDirectory :(NSString*)pCacheDirectoryPath {
    NSArray *rootArray = [[ScanFile getScanFileCacheDir] pathComponents];
    NSArray *cacheDirectoryArray = [pCacheDirectoryPath pathComponents];
    if (rootArray.count <= cacheDirectoryArray.count) {
        for(int i = 0; i < rootArray.count; i++){
            NSString *leftPath = [rootArray objectAtIndex:i];
            NSString *rightPath = [cacheDirectoryArray objectAtIndex:i];
            if (![leftPath isEqualToString:rightPath]) {
                return nil;
            }
        }
    } else {
        return nil;
    }
    NSString *scanFilePath = [ScanFileUtility getRootDir];
    for(NSUInteger i = rootArray.count; i < cacheDirectoryArray.count; i++){
        NSString *srcPath = [cacheDirectoryArray objectAtIndex:i];
        if (srcPath.length < 5) {
            return nil;
        }
        if (![srcPath hasPrefix:@"DIR-"]) {
            return nil;
        }
        // 「DIR-」以降を取得
        NSString *dstPath = [@"/" stringByAppendingString:[srcPath substringFromIndex:4]];
        scanFilePath = [scanFilePath stringByAppendingString:dstPath];
    }
    return scanFilePath;
}

- (ScanDirectory*)initWithScanDirectoryPath:(NSString*)pScanDirectoryPath{
    /** ユーザが作ったフォルダを示す接頭辞"DIR-" */
    dirPrefix              = @"DIR-";
    
    scanDirectoryPath = [[pScanDirectoryPath stringByDeletingLastPathComponent] stringByAppendingPathComponent:[pScanDirectoryPath lastPathComponent]];
    cacheDirectoryPath = [ScanDirectory getCacheDirectoryPathInScanFile:scanDirectoryPath];
    
    scanDirectoryName = [scanDirectoryPath lastPathComponent];
    scanDirectoryNameBody = [scanDirectoryName stringByDeletingPathExtension];
    cacheDirectoryName = [cacheDirectoryPath lastPathComponent];
    cacheDirectoryNameBody = [cacheDirectoryName stringByDeletingPathExtension];

    parentDirectoryPathInScanFile = [scanDirectoryPath stringByDeletingLastPathComponent];

    NSString *scanRootDirectoryPath = [ScanFile getScanDir];
    isRootDirectory = [scanRootDirectoryPath isEqualToString:scanDirectoryPath];
    
    relativeDirectoryPathInScanFile = [ScanDirectory getRelativePathInScanFile:scanDirectoryPath];
    isInit = (relativeDirectoryPathInScanFile != nil);
    return self;
}

- (ScanDirectory*)initWithCacheDirectoryPath:(NSString*)pCacheDirectoryPath{
    /** ユーザが作ったフォルダを示す接頭辞"DIR-" */
    dirPrefix              = @"DIR-";

    cacheDirectoryPath = [[pCacheDirectoryPath stringByDeletingLastPathComponent] stringByAppendingPathComponent:[pCacheDirectoryPath lastPathComponent]];

    scanDirectoryPath = [ScanDirectory getScanFilePathInCacheDirectory:cacheDirectoryPath];

    
    cacheDirectoryName = [cacheDirectoryPath lastPathComponent];
    cacheDirectoryNameBody = [cacheDirectoryName stringByDeletingPathExtension];

    scanDirectoryName = [scanDirectoryPath lastPathComponent];
    scanDirectoryNameBody = [scanDirectoryName stringByDeletingPathExtension];
    
    parentDirectoryPathInScanFile = [scanDirectoryPath stringByDeletingLastPathComponent];
    
    NSString *scanRootDirectoryPath = [ScanFile getScanDir];
    isRootDirectory = [scanRootDirectoryPath isEqualToString:scanDirectoryPath];
    
    relativeDirectoryPathInScanFile = [ScanDirectory getRelativePathInScanFile:scanDirectoryPath];
    isInit = (relativeDirectoryPathInScanFile != nil);
    return self;
    
}

@end
