
#import "GeneralFileUtility.h"
#import "TempAttachmentFile.h"
#import "TempFileUtility.h"
#import "ScanFileUtility.h"
#import "TempAttachmentFileUtility.h"

@implementation GeneralFileUtility

+ (NSString*)getPrivateDocuments{
    // Libraryの取得
    NSArray *libraryPaths = NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES);
    NSString *libraryPath = [libraryPaths lastObject];
    // Library/PrivateDocuments の取得
    NSString *privateDocumentsPath = [libraryPath stringByAppendingPathComponent:@"PrivateDocuments"];
    
    return privateDocumentsPath;
}

+ (BOOL)isTempFilePath:(NSString*) pFilePath{
    NSString *rootDir = [TempFile getTmpDir];
    
    return [self isSubItemOfDirectory:rootDir CheckItem:pFilePath];
}

+ (BOOL)isScanFilePath:(NSString*) pFilePath{
    NSString *rootDir = [ScanFile getScanDir];
    
    return [self isSubItemOfDirectory:rootDir CheckItem:pFilePath];
}

+ (BOOL)isTempAttachmentFilePath:(NSString*) pFilePath{
    NSString *rootDir = [TempAttachmentFile getRootDir];
    
    return [self isSubItemOfDirectory:rootDir CheckItem:pFilePath];
}

+ (BOOL)isSubItemOfDirectory:(NSString*) pDirectory CheckItem:(NSString*) pPath{
    BOOL bRet = NO;
    
    NSArray *dirPathComponents = [pDirectory pathComponents];
    NSArray *itemPathComponents = [pPath pathComponents];
    
    if ([dirPathComponents count] < [itemPathComponents count]) {
        for (NSInteger i = 0; i < [dirPathComponents count]; i++) {
            NSString *dirPathComponent = [dirPathComponents objectAtIndex:i];
            NSString *itemPathComponent = [itemPathComponents objectAtIndex:i];
            if (![dirPathComponent isEqualToString:itemPathComponent]) {
                return NO;
            }
        }
        bRet = YES;
    }
    
    return bRet;
}

+ (BOOL)createCacheFile:(NSString*)pFilePath{
    BOOL bRet = YES;
    
    if ([self isTempFilePath:pFilePath]) {
        TempFile *fileClass = [[TempFile alloc] initWithFileName:[pFilePath lastPathComponent]];
        bRet = [TempFileUtility createCacheFile:fileClass];
    } else if ([self isScanFilePath:pFilePath]) {
        ScanFile *fileClass = [[ScanFile alloc] initWithScanFilePath:pFilePath];
        bRet = [ScanFileUtility createCacheFile:fileClass];
    } else if ([self isTempAttachmentFilePath:pFilePath]) {
        TempAttachmentFile *fileClass = [[TempAttachmentFile alloc] initWithFilePath:pFilePath];
        bRet = [TempAttachmentFileUtility createCacheFile:fileClass];
    }
    
    return bRet;
}

+ (BOOL)createThumbnailFile:(NSString*)pFilePath{
    BOOL bRet = YES;
    
    if ([self isTempFilePath:pFilePath]) {
        TempFile *fileClass = [[TempFile alloc] initWithFileName:[pFilePath lastPathComponent]];
        bRet = [TempFileUtility createThumbnailFile:fileClass];
    } else if ([self isScanFilePath:pFilePath]) {
        ScanFile *fileClass = [[ScanFile alloc] initWithScanFilePath:pFilePath];
        bRet = [ScanFileUtility createThumbnailFile:fileClass];
    } else if ([self isTempAttachmentFilePath:pFilePath]) {
        TempAttachmentFile *fileClass = [[TempAttachmentFile alloc] initWithFilePath:pFilePath];
        bRet = [TempAttachmentFileUtility createThumbnailFile:fileClass];
    }
    
    return bRet;
}

+ (BOOL)createRequiredAllImageFiles:(NSString*)pFilePath{
    BOOL bRet = YES;
    
    if ([self isTempFilePath:pFilePath]) {
        TempFile *fileClass = [[TempFile alloc] initWithFileName:[pFilePath lastPathComponent]];
        bRet = [TempFileUtility createRequiredAllImageFiles:fileClass];
    } else if ([self isScanFilePath:pFilePath]) {
        ScanFile *fileClass = [[ScanFile alloc] initWithScanFilePath:pFilePath];
        bRet = [ScanFileUtility createRequiredAllImageFiles:fileClass];
    } else if ([self isTempAttachmentFilePath:pFilePath]) {
        TempAttachmentFile *fileClass = [[TempAttachmentFile alloc] initWithFilePath:pFilePath];
        bRet = [TempAttachmentFileUtility createRequiredAllImageFiles:fileClass];
    }
    
    return bRet;
}

+ (NSArray*)getPreviewFilePaths:(NSString*)pFilePath{
    NSArray *retArray = nil;
    
    if ([self isTempFilePath:pFilePath]) {
        TempFile *fileClass = [[TempFile alloc] initWithFileName:[pFilePath lastPathComponent]];
        retArray = [fileClass getPreviewFilePaths];
    } else if ([self isScanFilePath:pFilePath]) {
        ScanFile *fileClass = [[ScanFile alloc] initWithScanFilePath:pFilePath];
        retArray = [fileClass getPreviewFilePaths];
    } else if ([self isTempAttachmentFilePath:pFilePath]) {
        TempAttachmentFile *fileClass = [[TempAttachmentFile alloc] initWithFilePath:pFilePath];
        retArray = [fileClass getPreviewFilePaths];
    }
    
    return retArray;
}

+ (BOOL)copy:(TempFile*)pTempFile Destination:(ScanFile*) pDestination{
    BOOL bRet = [ScanFileUtility deleteFile:pDestination];
    if (!bRet) {
        return NO;
    }
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    [fileManager createDirectoryAtPath:pDestination.parentDirectoryPathInScanFile
           withIntermediateDirectories:YES
                            attributes:nil
                                 error:NULL];
    
    if ([pTempFile existsThumbnailFile]) {
        [fileManager createDirectoryAtPath:[pDestination.thumbnailFilePath stringByDeletingLastPathComponent]
               withIntermediateDirectories:YES
                                attributes:nil
                                     error:NULL];
        bRet = [fileManager copyItemAtPath:pTempFile.thumbnailFilePath toPath:pDestination.thumbnailFilePath error:nil];
        if (!bRet) {
            return NO;
        }
    }
    
    if ([pTempFile existsPrintFile]) {
        [fileManager createDirectoryAtPath:[pDestination.printFilePath stringByDeletingLastPathComponent]
               withIntermediateDirectories:YES
                                attributes:nil
                                     error:NULL];
        bRet = [fileManager copyItemAtPath:pTempFile.printFilePath toPath:pDestination.printFilePath error:nil];
        if (!bRet) {
            return NO;
        }
    }
    
    if ([pTempFile existsPreviewFile]) {
        [fileManager createDirectoryAtPath:pDestination.cacheDirectoryPath
               withIntermediateDirectories:YES
                                attributes:nil
                                     error:NULL];
        NSArray *arrayNames = [pTempFile getPreviewFileNames];
        for (NSInteger i = 0; i < arrayNames.count; i++) {
            NSString *srcFileName = [arrayNames objectAtIndex:i];
            NSString *srcFilePath = [pTempFile.cacheDirectoryPath stringByAppendingPathComponent:srcFileName];
            
            NSString *dstFileName = srcFileName;
            NSString *dstFilePath = [pDestination.cacheDirectoryPath stringByAppendingPathComponent:dstFileName];
            bRet = [fileManager copyItemAtPath:srcFilePath toPath:dstFilePath error:nil];
            if (!bRet) {
                return NO;
            }
        }
    }

    if ([pTempFile existsTempFile]) {
        bRet = [fileManager copyItemAtPath:pTempFile.tempFilePath toPath:pDestination.scanFilePath error:nil];
        if (!bRet) {
            return NO;
        }
    }
    
    if ([pDestination existsFileInScanFile]) {
        // updatedate.txt を作成する
        bRet = [ScanFileUtility saveUpdateDate:pDestination];
        if (!bRet) {
            return NO;
        }
    }
    
    return YES;
}

+ (BOOL)copy:(TempAttachmentFile*)pTempAttachmentFile ToScanFile:(ScanFile*) pDestination{
    BOOL bRet = [ScanFileUtility deleteFile:pDestination];
    if (!bRet) {
        return NO;
    }
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    [fileManager createDirectoryAtPath:pDestination.parentDirectoryPathInScanFile
           withIntermediateDirectories:YES
                            attributes:nil
                                 error:NULL];
    
    if ([pTempAttachmentFile existsThumbnailFile]) {
        [fileManager createDirectoryAtPath:[pDestination.thumbnailFilePath stringByDeletingLastPathComponent]
               withIntermediateDirectories:YES
                                attributes:nil
                                     error:NULL];
        bRet = [fileManager copyItemAtPath:pTempAttachmentFile.thumbnailFilePath toPath:pDestination.thumbnailFilePath error:nil];
        if (!bRet) {
            return NO;
        }
    }
    
    if ([pTempAttachmentFile existsPrintFile]) {
        [fileManager createDirectoryAtPath:[pDestination.printFilePath stringByDeletingLastPathComponent]
               withIntermediateDirectories:YES
                                attributes:nil
                                     error:NULL];
        bRet = [fileManager copyItemAtPath:pTempAttachmentFile.printFilePath toPath:pDestination.printFilePath error:nil];
        if (!bRet) {
            return NO;
        }
    }
    
    if ([pTempAttachmentFile existsPreviewFile]) {
        [fileManager createDirectoryAtPath:pDestination.cacheDirectoryPath
               withIntermediateDirectories:YES
                                attributes:nil
                                     error:NULL];
        NSArray *arrayNames = [pTempAttachmentFile getPreviewFileNames];
        for (NSInteger i = 0; i < arrayNames.count; i++) {
            NSString *srcFileName = [arrayNames objectAtIndex:i];
            NSString *srcFilePath = [pTempAttachmentFile.cacheDirectoryPath stringByAppendingPathComponent:srcFileName];
            
            NSString *dstFileName = srcFileName;
            NSString *dstFilePath = [pDestination.cacheDirectoryPath stringByAppendingPathComponent:dstFileName];
            bRet = [fileManager copyItemAtPath:srcFilePath toPath:dstFilePath error:nil];
            if (!bRet) {
                return NO;
            }
        }
    }
    
    if ([pTempAttachmentFile existsAttachmentFile]) {
        bRet = [fileManager copyItemAtPath:pTempAttachmentFile.attachmentFilePath toPath:pDestination.scanFilePath error:nil];
        if (!bRet) {
            return NO;
        }
    }
    
    if ([pDestination existsFileInScanFile]) {
        // updatedate.txt を作成する
        bRet = [ScanFileUtility saveUpdateDate:pDestination];
        if (!bRet) {
            return NO;
        }
    }
    
    return YES;
}

+ (BOOL)move:(TempFile*)pTempFile Destination:(ScanFile*) pDestination{
    BOOL bRet = [self copy:pTempFile Destination:pDestination];
    if (bRet) {
        bRet = [TempFileUtility deleteFile:pTempFile];
    } else {
        [ScanFileUtility deleteFile:pDestination];
    }
    
    return bRet;
}

+ (BOOL)isEmptyDirectory:(NSString*)pDirectoryPath{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSArray *paths = [fileManager contentsOfDirectoryAtPath:pDirectoryPath error:nil];
    if (paths != nil && paths.count > 0) {
        for (NSUInteger i = 0; i < paths.count; i++) {
            NSString *childItem = [paths objectAtIndex:i];
            NSString *childPath = [pDirectoryPath stringByAppendingPathComponent:childItem];
            BOOL isDir = NO;
            [fileManager fileExistsAtPath:childPath isDirectory:&isDir];
            if (isDir) {
                BOOL isEmpty = [self isEmptyDirectory:childPath];
                if (!isEmpty) {
                    return NO;
                }
            } else {
                return NO;
            }
        }
    }
    return YES;
}

+ (BOOL)isDirectory:(NSString*)pDirectoryPath{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    BOOL isDir = NO;
    if([fileManager fileExistsAtPath:pDirectoryPath isDirectory:&isDir]){
        return  isDir;
    }
    return NO;
}

+ (BOOL)deleteDirectory:(NSString*)pDirectoryPath{
    BOOL bRet = NO;
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if([self isDirectory:pDirectoryPath])
    {
        bRet = [fileManager removeItemAtPath:pDirectoryPath error:NULL];
    }
    return bRet;
}

+ (NSString*) getPrintFilePath:(NSString*)pFilePath{
    NSString *printFilePath = @"";
    
    if ([self isTempFilePath:pFilePath]) {
        TempFile *fileClass = [[TempFile alloc] initWithFileName:[pFilePath lastPathComponent]];
        printFilePath = fileClass.printFilePath;
    } else if ([self isScanFilePath:pFilePath]) {
        ScanFile *fileClass = [[ScanFile alloc] initWithScanFilePath:pFilePath];
        printFilePath = fileClass.printFilePath;
    } else if ([self isTempAttachmentFilePath:pFilePath]) {
        TempAttachmentFile *fileClass = [[TempAttachmentFile alloc] initWithFilePath:pFilePath];
        printFilePath = fileClass.printFilePath;
    }
    
    return printFilePath;
}

+ (NSString*) getThumbnailFilePath:(NSString*)pFilePath{
    NSString *thumbnailFilePath = @"";
    
    if ([self isTempFilePath:pFilePath]) {
        TempFile *fileClass = [[TempFile alloc] initWithFileName:[pFilePath lastPathComponent]];
        thumbnailFilePath = fileClass.thumbnailFilePath;
    } else if ([self isScanFilePath:pFilePath]) {
        ScanFile *fileClass = [[ScanFile alloc] initWithScanFilePath:pFilePath];
        thumbnailFilePath = fileClass.thumbnailFilePath;
    } else if ([self isTempAttachmentFilePath:pFilePath]) {
        TempAttachmentFile *fileClass = [[TempAttachmentFile alloc] initWithFilePath:pFilePath];
        thumbnailFilePath = fileClass.thumbnailFilePath;
    }
    
    return thumbnailFilePath;
}
@end
