
#import "ScanDirectoryUtility.h"

@implementation ScanDirectoryUtility

+ (BOOL)deleteDirectory:(ScanDirectory*)pScanDirectory{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    if ([pScanDirectory existsDirectoryInScanFile]) {
        [fileManager removeItemAtPath:pScanDirectory.scanDirectoryPath error:nil];
    }
    if ([pScanDirectory existsDirectoryInCacheDirectory]) {
        [fileManager removeItemAtPath:pScanDirectory.cacheDirectoryPath error:nil];
    }

    return YES;
}

+ (BOOL)rename:(ScanDirectory*)pScanDirectory DirectoryName:(NSString*) pDirectoryName{
    NSString *scanDirectoryPath = [[pScanDirectory.scanDirectoryPath stringByDeletingLastPathComponent] stringByAppendingPathComponent:pDirectoryName];
    ScanDirectory *destination = [[ScanDirectory alloc] initWithScanDirectoryPath:scanDirectoryPath];
    if ([destination existsDirectoryInScanFile]) {
        return NO;
    }
    return [self move:pScanDirectory Destination:destination];
}

+ (BOOL)move:(ScanDirectory*)pScanDirectory Destination:(ScanDirectory*) pDestination{
    BOOL bRet = [self copy:pScanDirectory Destination:pDestination];
    if (bRet) {
        bRet = [self deleteDirectory:pScanDirectory];
    }
    
    return bRet;
}

+ (BOOL)copy:(ScanDirectory*)pScanDirectory Destination:(ScanDirectory*) pDestination{
    if (![pScanDirectory existsDirectoryInScanFile]) {
        return NO;
    }
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if (![pDestination existsDirectoryInScanFile]) {
        [fileManager createDirectoryAtPath:pDestination.scanDirectoryPath
               withIntermediateDirectories:YES
                                attributes:nil
                                     error:NULL];
    }
    NSArray *filePaths = [ScanDirectoryUtility getFilesInScanDirectory:pScanDirectory];
    if (filePaths != nil && [filePaths count] > 0) {
        for (NSInteger i = 0; i < [filePaths count]; i++) {
            NSString *srcFullPath = [filePaths objectAtIndex:i];
            NSString *fileName = [srcFullPath lastPathComponent];
            NSString *dstFullPath = [pDestination.scanDirectoryPath stringByAppendingPathComponent:fileName];
            ScanFile *srcScanFile = [[ScanFile alloc] initWithScanFilePath:srcFullPath];
            ScanFile *dstScanFile = [[ScanFile alloc] initWithScanFilePath:dstFullPath];
            BOOL bRet = [ScanFileUtility copy:srcScanFile Destination:dstScanFile];
            if (!bRet) {
                return NO;
            }
        }
    }
    NSArray *directoryPaths = [ScanDirectoryUtility getDirectoriesInScanDirectory:pScanDirectory];
    if (directoryPaths != nil && [directoryPaths count] > 0) {
        for (NSInteger i = 0; i < [directoryPaths count]; i++) {
            NSString *srcFullPath = [directoryPaths objectAtIndex:i];
            NSString *directoryName = [srcFullPath lastPathComponent];
            NSString *dstFullPath = [pDestination.scanDirectoryPath stringByAppendingPathComponent:directoryName];
            ScanDirectory *srcScanDirectory = [[ScanDirectory alloc] initWithScanDirectoryPath:srcFullPath];
            ScanDirectory *dstScanDirectory = [[ScanDirectory alloc] initWithScanDirectoryPath:dstFullPath];
            BOOL bRet = [ScanDirectoryUtility copy:srcScanDirectory Destination:dstScanDirectory];
            if (!bRet) {
                return NO;
            }
        }
    }
    
    return YES;
}

+ (NSArray*)searchScanDirectory:(NSString*)pDirectoryPath Keyword:(NSString*)pKeyword{
    return nil;
}

+ (NSArray*)getFilesInScanDirectory:(ScanDirectory*)pScanDirectory{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    NSArray *baseList = [fileManager contentsOfDirectoryAtPath:pScanDirectory.scanDirectoryPath error:nil];
    if (baseList == nil || [baseList count] == 0) {
        return nil;
    }
    
    NSMutableArray *mutableList = [NSMutableArray array];
    for (NSInteger i = 0; i < [baseList count]; i++) {
        NSString *pathComponent = [baseList objectAtIndex:i];
        NSString *fullPath = [pScanDirectory.scanDirectoryPath stringByAppendingPathComponent:pathComponent];
        
        BOOL isDir = NO;
        if ([fileManager fileExistsAtPath:fullPath isDirectory:&isDir]) {
            if (!isDir) {
                [mutableList addObject:fullPath];
            }
        }
    }
    
    return [mutableList copy];
}

+ (NSArray*)getFilesInCacheDirectory:(ScanDirectory*)pScanDirectory{
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    NSArray *baseList = [fileManager contentsOfDirectoryAtPath:pScanDirectory.cacheDirectoryPath error:nil];
    if (baseList == nil || [baseList count] == 0) {
        return nil;
    }
    
    NSMutableArray *mutableList = [NSMutableArray array];
    for (NSInteger i = 0; i < [baseList count]; i++) {
        NSString *pathComponent = [baseList objectAtIndex:i];
        NSString *fullPath = [pScanDirectory.cacheDirectoryPath stringByAppendingPathComponent:pathComponent];
        
        BOOL isDir = NO;
        if ([fileManager fileExistsAtPath:fullPath isDirectory:&isDir]) {
            if (!isDir) {
                [mutableList addObject:fullPath];
            }
        }
    }
    
    return [mutableList copy];
}

+ (NSArray*)getDirectoriesInScanDirectory:(ScanDirectory*)pScanDirectory{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    NSArray *baseList = [fileManager contentsOfDirectoryAtPath:pScanDirectory.scanDirectoryPath error:nil];
    if (baseList == nil || [baseList count] == 0) {
        return nil;
    }
    
    NSMutableArray *mutableList = [NSMutableArray array];
    for (NSInteger i = 0; i < [baseList count]; i++) {
        NSString *pathComponent = [baseList objectAtIndex:i];
        NSString *fullPath = [pScanDirectory.scanDirectoryPath stringByAppendingPathComponent:pathComponent];
        
        BOOL isDir = NO;
        if ([fileManager fileExistsAtPath:fullPath isDirectory:&isDir]) {
            if (isDir) {
//                if ([pathComponent hasPrefix:@"DIR-"]) {
//                    [mutableList addObject:fullPath];
//                }
            // DIR-は不要
            [mutableList addObject:fullPath];
            }
        }
    }
    
    return [mutableList copy];
}

+ (NSArray*)getDirectoriesInCacheDirectory:(ScanDirectory*)pScanDirectory{
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    NSArray *baseList = [fileManager contentsOfDirectoryAtPath:pScanDirectory.cacheDirectoryPath error:nil];
    if (baseList == nil || [baseList count] == 0) {
        return nil;
    }
    
    NSMutableArray *mutableList = [NSMutableArray array];
    for (NSInteger i = 0; i < [baseList count]; i++) {
        NSString *pathComponent = [baseList objectAtIndex:i];
        NSString *fullPath = [pScanDirectory.cacheDirectoryPath stringByAppendingPathComponent:pathComponent];
        
        BOOL isDir = NO;
        if ([fileManager fileExistsAtPath:fullPath isDirectory:&isDir]) {
            if (isDir) {
                // if ([pathComponent hasPrefix:@"DIR-"]) {
                //     [mutableList addObject:fullPath];
                // }
                // DIR-は不要
                [mutableList addObject:fullPath];
            }
        }
    }
    
    return [mutableList copy];
}

+ (NSArray*)getNormalDirectories:(NSArray*)baseList{
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    if (baseList == nil || [baseList count] == 0) {
        return nil;
    }
    
    NSMutableArray *mutableList = [NSMutableArray array];
    for (NSInteger i = 0; i < [baseList count]; i++) {
        NSString *fullPath = [baseList objectAtIndex:i];
        NSString *fileName = [fullPath lastPathComponent];
        
        BOOL isDir = NO;
        if ([fileManager fileExistsAtPath:fullPath isDirectory:&isDir]) {
            if (isDir) {
                if ([fileName hasPrefix:@"DIR-"]) {
                    [mutableList addObject:fullPath];
                }
            }
        }
    }
    
    return [mutableList copy];
}

+ (NSArray*)getCacheDirectories:(NSArray*)baseList{
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    if (baseList == nil || [baseList count] == 0) {
        return nil;
    }
    
    NSMutableArray *mutableList = [NSMutableArray array];
    for (NSInteger i = 0; i < [baseList count]; i++) {
        NSString *fullPath = [baseList objectAtIndex:i];
        NSString *fileName = [fullPath lastPathComponent];
        
        BOOL isDir = NO;
        if ([fileManager fileExistsAtPath:fullPath isDirectory:&isDir]) {
            if (isDir) {
                if ([fileName hasPrefix:@"Cache-"]) {
                    [mutableList addObject:fullPath];
                }
            }
        }
    }
    
    return [mutableList copy];
}

// 実データ(ファイル、ディレクトリ)が存在せず、CacheDirectory配下にのみ残っている場合に削除する
+ (BOOL)removeCacheDirectoriesNotExistScanData:(ScanDirectory*)pScanDirectory{

    // CacheDirectory内のディレクトリを取得する
    NSArray *cacheDirectoryPaths = [self getDirectoriesInCacheDirectory:pScanDirectory];
    
    // Cache-ディレクトリを取得する
    NSArray *cacheDirectories = [self getCacheDirectories:cacheDirectoryPaths];
    // 通常ディレクトリを取得する
    NSArray *normalDirectories = [self getNormalDirectories:cacheDirectoryPaths];

    // 不要なCache-ディレクトリを削除する
    [self removeCacheByCacheDirectories:cacheDirectories];
    // 不要な通常ディレクトリを削除する
    [self removeCacheByNormalDirectories:normalDirectories];

    return YES;
}

// 不要なCache-ディレクトリを削除する
+ (BOOL)removeCacheByCacheDirectories:(NSArray*)cacheDirectories{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    BOOL bRet = YES;
    NSError *error;
    
    // ディレクトリ存在チェック
    for (NSInteger i = 0; i < [cacheDirectories count]; i++) {
        NSString *cacheFullPath = [cacheDirectories objectAtIndex:i];
        ScanFile *localScanFile = [[ScanFile alloc] initWithCacheDirectoryPath:cacheFullPath];
        NSString *scanPath = localScanFile.scanFilePath;
        
        BOOL isExist = YES;
        BOOL isDir = NO;
        
        // ファイルの存在確認
        if ([fileManager fileExistsAtPath:scanPath isDirectory:&isDir]) {
            if (!isDir) {
                // 対象ファイルあり
                DLog(@"対象ファイルあり：%@", scanPath);
            } else {
                // 対象ファイルは存在しないが、同名ディレクトリが存在
                DLog(@"対象ファイルなし(同名ディレクトリあり)：%@", scanPath);
                isExist = NO;
            }
            
        } else {
            // 対象ファイルなし
            DLog(@"対象ファイルなし：%@", scanPath);
            isExist = NO;
        }
        
        // 対象ファイルが存在しないため、キャッシュを削除
        if (!isExist) {
            bRet = [fileManager removeItemAtPath:cacheFullPath error:&error];
            if (bRet) {
                DLog(@"ファイルの削除に成功：%@", cacheFullPath);
            } else {
                DLog(@"ファイルの削除に失敗：%@", error.description);
                break;
            }
        }
        
    }
    
    return bRet;
}

// 不要な通常ディレクトリを削除する
+ (BOOL)removeCacheByNormalDirectories:(NSArray*)normalDirectories{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    BOOL bRet = YES;
    NSError *error;
    
    // ディレクトリ存在チェック
    for (NSInteger i = 0; i < [normalDirectories count]; i++) {
        NSString *cacheFullPath = [normalDirectories objectAtIndex:i];
        ScanDirectory *localScanDirctory = [[ScanDirectory alloc] initWithCacheDirectoryPath:cacheFullPath];
        NSString *scanPath = localScanDirctory.scanDirectoryPath;
        
        BOOL isExist = YES;
        BOOL isDir = NO;
        
        // ディレクトリの存在確認
        if ([fileManager fileExistsAtPath:scanPath isDirectory:&isDir]) {
            if (isDir) {
                // 対象ディレクトリあり
                DLog(@"対象ディレクトリあり：%@", scanPath);
            } else {
                // 対象ディレクトリは存在しないが、同名ファイルが存在
                DLog(@"対象ディレクトリなし(同名ファイルあり)：%@", scanPath);
                isExist = NO;
            }
            
        } else {
            // 対象ディレクトリなし
            DLog(@"対象ディレクトリなし：%@", scanPath);
            isExist = NO;
        }
        
        // 対象ディレクトリが存在しないため、キャッシュを削除
        if (!isExist) {
            bRet = [fileManager removeItemAtPath:cacheFullPath error:&error];
            if (bRet) {
                DLog(@"ディレクトリの削除に成功：%@", cacheFullPath);
            } else {
                DLog(@"ディレクトリの削除に失敗：%@", error.description);
                break;
            }
        }
        
    }
    
    return bRet;
}

+ (BOOL)createDirectory:(ScanDirectory*)pScanDirectory{
    BOOL bRet = NO;

    NSFileManager *fileManager = [NSFileManager defaultManager];
    if (![pScanDirectory existsDirectoryInScanFile]) {
        
        bRet = [fileManager createDirectoryAtPath:pScanDirectory.scanDirectoryPath
               withIntermediateDirectories:YES
                                attributes:nil
                                     error:NULL];
    }
    if (bRet && ![pScanDirectory existsDirectoryInCacheDirectory]) {
        bRet = [fileManager createDirectoryAtPath:pScanDirectory.cacheDirectoryPath
               withIntermediateDirectories:YES
                                attributes:nil
                                     error:NULL];
    }
    
    return bRet;
}

@end
