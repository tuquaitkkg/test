
#import "TempFile.h"
#import "CommonUtil.h"
#import "GeneralFileUtility.h"

@implementation TempFile

@synthesize isInit;
@synthesize thumbnailFilePath;
@synthesize printFilePath;
@synthesize cacheDirectoryPath;
@synthesize tempFilePath;
@synthesize thumbnailFileName;
@synthesize printFileName;
@synthesize cacheDirectoryName;
@synthesize tempFileName;
@synthesize fileType;
@synthesize isWEB;

- (id)init
{
    if ((self = [super init]) == nil)
    {
        return nil;
    }
    
    isInit             = NO;
    thumbnailFilePath	= nil;
    printFilePath		= nil;
    cacheDirectoryPath	= nil;
    tempFilePath       = nil;
    thumbnailFileName  = nil;
    printFileName      = nil;
    cacheDirectoryName	= nil;
    tempFileName       = nil;
    fileType           = nil;
    isWEB             = NO;
    return self;
}

- (void)dealloc
{
}

- (BOOL) existsDirectoryInCacheDirectory{
    if (!self.isInit) {
        return NO;
    }
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    return [fileManager fileExistsAtPath:self.cacheDirectoryPath];
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
    if ([CommonUtil pdfExtensionCheck:self.tempFilePath] || [CommonUtil tiffExtensionCheck:self.tempFilePath]) {
        NSString *fileNameFormat = @"%@%03d.jpg";
        for (NSInteger i = 0; i < 1000; i++) {
            NSString *fileName = [NSString stringWithFormat:fileNameFormat, @"preview", i];
            
            NSString *filePath = [self.cacheDirectoryPath stringByAppendingPathComponent:fileName];
            if (![fileManager fileExistsAtPath:filePath]) {
                break;
            }
            [mutablePaths addObject:filePath];
        }
    } else if ([CommonUtil jpegExtensionCheck:self.tempFilePath]) {
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

- (BOOL) existsTempFile{
    if (!self.isInit) {
        return NO;
    }
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    return [fileManager fileExistsAtPath:self.tempFilePath];
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

+ (NSString*) getTmpDir{
    // Library/PrivateDocuments の取得
    NSString *privateDocumentsPath = [GeneralFileUtility getPrivateDocuments];
    // Library/PrivateDocuments/TempFile の取得
    NSString *tmpDir = [privateDocumentsPath stringByAppendingPathComponent:@"TempFile"];
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    [fileManager createDirectoryAtPath:tmpDir
           withIntermediateDirectories:YES
                            attributes:nil
                                 error:NULL];
    return tmpDir;
}

- (TempFile *)initWithFileName:(NSString*)pFileName{
    NSString *tmpDir = [TempFile getTmpDir];
    
    tempFileName = [pFileName lastPathComponent];
    tempFilePath = [tmpDir stringByAppendingPathComponent:tempFileName];

    NSString *fileNameBody = [tempFileName stringByDeletingPathExtension];
    NSString *extension = [tempFileName pathExtension];
    
    cacheDirectoryName = [NSString stringWithFormat:@"Cache-%@-%@", fileNameBody, extension];
    cacheDirectoryPath = [tmpDir stringByAppendingPathComponent:cacheDirectoryName];
    
    //サムネイルファイル名
    thumbnailFileName = [NSString stringWithFormat:@"thumbnail.png"];
    //サムネイルファイルのパス
    thumbnailFilePath = [cacheDirectoryPath stringByAppendingPathComponent:thumbnailFileName];
    
    //pngの印刷用ファイル名
    printFileName = [NSString stringWithFormat:@"printfile.jpg"];
    //pngの印刷用ファイルのパス
    printFilePath = [cacheDirectoryPath stringByAppendingPathComponent:printFileName];

    fileType = [extension lowercaseString];
    isWEB = NO;
    isInit = YES;
    return self;
}

- (TempFile *)initWithPrintDataPdf{
    TempFile *ret = [self initWithFileName:S_PRINT_DATA_FILENAME_FOR_PRINT_PDF];
    isWEB = YES;
    return ret;
}

@end
