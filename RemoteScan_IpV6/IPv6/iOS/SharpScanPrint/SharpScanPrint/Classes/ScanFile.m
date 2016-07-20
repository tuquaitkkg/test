
#import "ScanFile.h"
#import "CommonUtil.h"
#import "GeneralFileUtility.h"

@implementation ScanFile

@synthesize isInit;
@synthesize scanFileName;
@synthesize scanFileNameBody;
@synthesize scanFilePath;
@synthesize thumbnailFilePath;
@synthesize printFilePath;
@synthesize updateDateFilePath;
@synthesize cacheDirectoryPath;
@synthesize parentDirectoryPathInScanFile;
@synthesize parentDirectoryPathOfCacheDirectory;
@synthesize thumbnailFileName;
@synthesize printFileName;
@synthesize updateDateFileName;
@synthesize cacheDirectoryName;
@synthesize parentDirectoryNameInScanFile;
@synthesize parentDirectoryNameOfCacheDirectory;
@synthesize fileType;
@synthesize thumbnailFileDirPath;
@synthesize printFileDirPath;

- (id)init
{
    if ((self = [super init]) == nil)
    {
        return nil;
    }
    
    isInit                                  = NO;
    scanFilePath                            = nil;
    scanFileName                            = nil;
    scanFileNameBody                        = nil;
    thumbnailFilePath	                    = nil;
    printFilePath		                    = nil;
    updateDateFilePath	                    = nil;
    cacheDirectoryPath	                    = nil;
    parentDirectoryPathInScanFile           = nil;
    parentDirectoryPathOfCacheDirectory     = nil;
    thumbnailFileName                       = nil;
    printFileName                           = nil;
    cacheDirectoryName		                = nil;
    parentDirectoryNameInScanFile           = nil;
    parentDirectoryNameOfCacheDirectory     = nil;
    fileType			                    = nil;
    thumbnailFileDirPath                    = nil;
    printFileDirPath                        = nil;
    return self;
}

- (void)dealloc
{
}

+ (NSString*)getScanDir{
    NSArray *docFolders = NSSearchPathForDirectoriesInDomains (NSDocumentDirectory, NSUserDomainMask, YES );
    NSString *homePath = [docFolders lastObject];
    // ルートディレクトリは、Documentsに決定
    NSString *documentsDirPath = homePath;
    
    return documentsDirPath;
}

+ (NSString*)getScanFileCacheDir{
    // Library/PrivateDocuments の取得
    NSString *privateDocumentsPath = [GeneralFileUtility getPrivateDocuments];
    // Library/PrivateDocuments/CacheDirectory の取得
    NSString *scanFileCacheDir = [privateDocumentsPath stringByAppendingPathComponent:@"CacheDirectory"];
    return scanFileCacheDir;
}

- (NSString*) getUpdateDateInScanFile{
    if (!self.isInit) {
        return nil;
    }
    
    if (![self existsFileInScanFile]) {
        return nil;
    }

    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSDictionary *attribute = [fileManager attributesOfItemAtPath:self.scanFilePath error:nil];
    NSDate *modificationDate = [attribute objectForKey:NSFileModificationDate];
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy/MM/dd HH:mm:ss"];
    [formatter setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:0]];
    
    return [formatter stringFromDate:modificationDate];
}

- (NSString*) getUpdateDateInCacheDirectory{
    if (!self.isInit) {
        return nil;
    }
    
    if (![self existsDirectoryInCacheDirectory]) {
        return nil;
    }

    NSFileManager *fileManager = [NSFileManager defaultManager];
    if (![fileManager fileExistsAtPath:self.updateDateFilePath]) {
        return nil;
    }

    NSFileHandle *fileHandle = [NSFileHandle fileHandleForReadingAtPath:self.updateDateFilePath];
    NSData *data = [fileHandle readDataToEndOfFile];
    [fileHandle closeFile];
    NSString *ret = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];

    return ret;
}

- (NSArray*) getPreviewFilePaths{
    if (!self.isInit) {
        return nil;
    }
    
    if (![self existsDirectoryInCacheDirectory]) {
        return nil;
    }
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSMutableArray *mutablePaths = [NSMutableArray array];
    if ([CommonUtil pdfExtensionCheck:self.scanFilePath] || [CommonUtil tiffExtensionCheck:self.scanFilePath]) {
        NSString *fileNameFormat = @"%@%03d.jpg";
        for (NSInteger i = 0; i < 1000; i++) {
            NSString *fileName = [NSString stringWithFormat:fileNameFormat, @"preview", i];
            
            NSString *filePath = [self.cacheDirectoryPath stringByAppendingPathComponent:fileName];
            if (![fileManager fileExistsAtPath:filePath]) {
                break;
            }
            [mutablePaths addObject:filePath];
        }
    } else if ([CommonUtil jpegExtensionCheck:self.scanFilePath]) {
        NSString* filePath = [self.cacheDirectoryPath stringByAppendingPathComponent:@"preview.jpg"];
        DLog(@"filePath = %@", filePath);
        if ([fileManager fileExistsAtPath:filePath]) {
            [mutablePaths addObject:filePath];
        }
    } else {
        NSString *fileNameFormat = @"%@.jpg";
        NSString *fileName = [NSString stringWithFormat:fileNameFormat, @"preview"];
        NSString *filePath = [self.cacheDirectoryPath stringByAppendingPathComponent:fileName];
        if ([fileManager fileExistsAtPath:filePath]) {
            [mutablePaths addObject:filePath];
        }
    }

    NSArray *arrayPaths = nil;
    if (mutablePaths.count > 0) {
        arrayPaths = [mutablePaths copy];
    }
    
    return arrayPaths;
}

- (NSArray*) getPreviewFileNames{
    if (!self.isInit) {
        return nil;
    }
    
    NSArray *arrayPaths = [self getPreviewFilePaths];
    if (arrayPaths == nil) {
        return nil;
    }
    
    NSMutableArray *mutableNames = [NSMutableArray array];
    for (NSInteger i = 0; i < arrayPaths.count; i++) {
        NSString *filePath = [arrayPaths objectAtIndex:i];
        NSString *fileName = [filePath lastPathComponent];
        
        [mutableNames addObject:fileName];
    }
    
    return [mutableNames copy];
}

- (NSArray*) getPreviewImages{
    if (!self.isInit) {
        return nil;
    }
    
    NSArray *arrayPaths = [self getPreviewFilePaths];
    if (arrayPaths == nil) {
        return nil;
    }
    
    NSMutableArray *mutableImages = [NSMutableArray array];
    for (NSInteger i = 0; i < arrayPaths.count; i++) {
        UIImage *image = [UIImage imageWithContentsOfFile:[arrayPaths objectAtIndex:i]];
        
        [mutableImages addObject:image];
    }
    
    return [mutableImages copy];
}

- (UIImage*) getThumbnailImage{
    if (!self.isInit) {
        return nil;
    }
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if (![fileManager fileExistsAtPath:self.thumbnailFilePath]) {
        return nil;
    }
    
    UIImage *icon = [UIImage imageWithContentsOfFile:self.thumbnailFilePath];
    
    return icon;
}

- (BOOL) existsFileInScanFile{
    if (!self.isInit) {
        return NO;
    }
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    return [fileManager fileExistsAtPath:self.scanFilePath];
}

- (BOOL) existsDirectoryInCacheDirectory{
    if (!self.isInit) {
        return NO;
    }
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    return [fileManager fileExistsAtPath:self.cacheDirectoryPath];
}

- (BOOL) existsPreviewFile{
    if (!self.isInit) {
        return NO;
    }
    
    NSArray *arrayPaths = [self getPreviewFilePaths];
    
    return (arrayPaths != nil);
}

- (BOOL) existsThumbnailFile{
    if (!self.isInit) {
        return NO;
    }
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    return [fileManager fileExistsAtPath:self.thumbnailFilePath];
}

- (BOOL) existsPrintFile{
    if (!self.isInit) {
        return NO;
    }
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    return [fileManager fileExistsAtPath:self.printFilePath];
}

- (BOOL) existsUpdateDateFile{
    if (!self.isInit) {
        return NO;
    }
    NSFileManager *fileManager = [NSFileManager defaultManager];
    return [fileManager fileExistsAtPath:self.updateDateFilePath];
}

- (BOOL) isEncryptedFile{
    if (!self.isInit) {
        return NO;
    }
    
    if (![self existsFileInScanFile]) {
        return NO;
    }
    
    // PDF以外は無条件で暗号化以外
    if (![CommonUtil pdfExtensionCheck:self.scanFilePath]) {
        return NO;
    }
    
    // ディレクトリとファイル名を分割
    NSRange range = [self.scanFilePath rangeOfString:@"/" options:NSCaseInsensitiveSearch | NSBackwardsSearch];
    NSString* dirPath = [self.scanFilePath substringToIndex:range.location+1];
    dirPath	= [dirPath stringByReplacingOccurrencesOfString:@"/" withString:@"//"];
    dirPath = [NSString stringWithFormat:@"file:/%@",dirPath];
    NSString* filename = [self.scanFilePath substringFromIndex:(range.location+1)];
    
    // URLエンコード
    dirPath = [dirPath stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    CGPDFDocumentRef document;
    CFURLRef	path;
    CFURLRef	url;
    
    //
    // PDFファイルの読み込み
    //
    path	= CFURLCreateWithString( kCFAllocatorDefault, (CFStringRef)dirPath, NULL );
    url		= CFURLCreateCopyAppendingPathComponent(kCFAllocatorDefault, path, (CFStringRef)filename, false);
    CFRelease(path);
    
    document = CGPDFDocumentCreateWithURL (url);
    CFRelease(url);
    
    // 暗号化されている場合
    BOOL isEncrypted = NO;
    if(CGPDFDocumentIsEncrypted(document) && !CGPDFDocumentIsUnlocked(document))
    {
        isEncrypted = YES;
    }
    CGPDFDocumentRelease(document);
    
    return isEncrypted;
}

- (BOOL) isRetensionCapable{
    if (!self.isInit) {
        return NO;
    }
    
    if (![self existsFileInScanFile]) {
        return NO;
    }
    
    // 暗号化PDF以外はリテンション可能
    return ![self isEncryptedFile];
}

- (BOOL) isNupCapable{
    if (!self.isInit) {
        return NO;
    }
    
    // PDF以外は無条件でN-UP不可
    if (![CommonUtil pdfExtensionCheck:self.scanFilePath]) {
        return NO;
    }

    NSArray *arrayPaths = [self getPreviewFilePaths];
    
    return (arrayPaths != nil);
}

- (ScanFile *)initWithScanFilePath:(NSString*)pScanFilePath{
    isInit = YES;
    
    scanFilePath = pScanFilePath;
    //拡張子つきファイル名
    NSString * scanFileNameLocal = [pScanFilePath lastPathComponent];
    
    //ファイル名拡張子なし
    NSString *fileNameBody = [scanFileNameLocal stringByDeletingPathExtension];
    //拡張子
    fileType = [scanFileNameLocal pathExtension];
    
    // /Documents/ScanFile
    parentDirectoryPathInScanFile  = [pScanFilePath stringByDeletingLastPathComponent];
    // parentDirectoryPathInScanFileからparentDirectoryPathOfCacheDirectoryを取得
    parentDirectoryPathOfCacheDirectory = [ScanFile getParentDirectoryPathOfCacheDirectory:parentDirectoryPathInScanFile];

    // Cache-のフォルダ名
    cacheDirectoryName = [NSString stringWithFormat:@"Cache-%@-%@", fileNameBody, fileType];
    // Cache-のフルパス
    cacheDirectoryPath = [parentDirectoryPathOfCacheDirectory stringByAppendingPathComponent:cacheDirectoryName];
    
    parentDirectoryNameInScanFile         = [parentDirectoryPathInScanFile lastPathComponent];
    parentDirectoryNameOfCacheDirectory   = [parentDirectoryPathOfCacheDirectory lastPathComponent];

    //サムネイルファイル名
    thumbnailFileName = [NSString stringWithFormat:@"thumbnail.png"];
    //サムネイルファイルのパス
    thumbnailFilePath = [cacheDirectoryPath stringByAppendingPathComponent:thumbnailFileName];
    
    //pngの印刷用ファイル名
    printFileName = [NSString stringWithFormat:@"printfile.jpg"];
    //pngの印刷用ファイルのパス
    printFilePath = [cacheDirectoryPath stringByAppendingPathComponent:printFileName];
    
    //ファイル作成日時保存ファイル名
    updateDateFileName = [NSString stringWithFormat:@"updatedate.txt"];
    //ファイル作成日時保存ファイルのパス
    updateDateFilePath = [cacheDirectoryPath stringByAppendingPathComponent:updateDateFileName];
    
    return self;
}

- (ScanFile *)initWithCacheDirectoryPath:(NSString*)pCacheDirectoryPath{
    isInit = YES;
    
    cacheDirectoryPath = pCacheDirectoryPath;
    parentDirectoryPathOfCacheDirectory = [cacheDirectoryPath stringByDeletingLastPathComponent];

    // parentDirectoryPathOfCacheDirectoryからparentDirectoryPathInScanFileを取得
    parentDirectoryPathInScanFile = [ScanFile getParentDirectoryPathInScanFile:parentDirectoryPathOfCacheDirectory];

    NSString *tempCacheDirectoryName = [pCacheDirectoryPath lastPathComponent];
    NSRange extensionRange = [tempCacheDirectoryName rangeOfString:@"-" options:NSBackwardsSearch];
    NSString *tempExtension = [tempCacheDirectoryName substringFromIndex:extensionRange.location + 1];
    //拡張子
    fileType = tempExtension;
    
    //ファイル名拡張子なし
    NSString *tempScanFileNameBody = [tempCacheDirectoryName substringWithRange:NSMakeRange(6, extensionRange.location - 6)];
    NSString *tempScanFileName = [tempScanFileNameBody stringByAppendingPathExtension:tempExtension];
    
    //拡張子つきファイル名
    scanFileName = tempScanFileName;

    // ScanFileフルパス
    scanFilePath = [parentDirectoryPathInScanFile stringByAppendingPathComponent:scanFileName];
    
    parentDirectoryNameInScanFile         = [parentDirectoryPathInScanFile lastPathComponent];
    parentDirectoryNameOfCacheDirectory   = [parentDirectoryPathOfCacheDirectory lastPathComponent];
    
    
    //サムネイルファイル名
    thumbnailFileName = [NSString stringWithFormat:@"thumbnail.png"];
    //サムネイルファイルのパス
    thumbnailFilePath = [cacheDirectoryPath stringByAppendingPathComponent:thumbnailFileName];
    
    //pngの印刷用ファイル名
    printFileName = [NSString stringWithFormat:@"printfile.jpg"];
    //pngの印刷用ファイルのパス
    printFilePath = [cacheDirectoryPath stringByAppendingPathComponent:printFileName];
    
    //ファイル作成日時保存ファイル名
    updateDateFileName = [NSString stringWithFormat:@"updatedate.txt"];
    //ファイル作成日時保存ファイルのパス
    updateDateFilePath = [cacheDirectoryPath stringByAppendingPathComponent:updateDateFileName];
    
    return self;
}

+ (NSString *)getParentDirectoryPathOfCacheDirectory :(NSString*)pParentDirectoryPathInScanFile {
    NSArray *rootArray = [[ScanFile getScanDir] pathComponents];
    NSArray *scanDirectoryArray = [pParentDirectoryPathInScanFile pathComponents];
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
    NSString *parentDirectoryPathOfCacheDirectory = [self getScanFileCacheDir];
    for(NSUInteger i = rootArray.count; i < scanDirectoryArray.count; i++){
        NSString *srcPath = [scanDirectoryArray objectAtIndex:i];
        if (srcPath.length < 1) {
            return nil;
        }
        NSString *dstPath = [@"/DIR-" stringByAppendingString:srcPath];
        parentDirectoryPathOfCacheDirectory = [parentDirectoryPathOfCacheDirectory stringByAppendingString:dstPath];
    }
    return parentDirectoryPathOfCacheDirectory;
}

// parentDirectoryPathOfCacheDirectoryからparentDirectoryPathInScanFileを取得
+ (NSString *)getParentDirectoryPathInScanFile :(NSString*)pParentDirectoryPathOfCacheDirectory {
    NSArray *rootArray = [[ScanFile getScanFileCacheDir] pathComponents];
    NSArray *cacheDirectoryArray = [pParentDirectoryPathOfCacheDirectory pathComponents];
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
    NSString *parentDirectoryPathInScanFile = [self getScanDir];
    for(NSUInteger i = rootArray.count; i < cacheDirectoryArray.count; i++){
        NSString *srcPath = [cacheDirectoryArray objectAtIndex:i];
        if (srcPath.length < 5) {
            return nil;
        }
        if (![srcPath hasPrefix:@"DIR-"]) {
            return nil;
        }
        NSString *dstPath = [@"/" stringByAppendingString:[srcPath substringFromIndex:4]];
        parentDirectoryPathInScanFile = [parentDirectoryPathInScanFile stringByAppendingString:dstPath];
    }
    return parentDirectoryPathInScanFile;
}

@end
