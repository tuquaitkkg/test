
#import "TempAttachmentFile.h"
#import "CommonUtil.h"
#import "GeneralFileUtility.h"

@implementation TempAttachmentFile

@synthesize isInit;
@synthesize attachmentFilePath;
@synthesize thumbnailFilePath;
@synthesize printFilePath;
@synthesize cacheDirectoryPath;
@synthesize parentDirectoryPathInAttachmentFile;
@synthesize parentDirectoryPathOfCacheDirectory;
@synthesize thumbnailFileName;
@synthesize printFileName;
@synthesize cacheDirectoryName;
@synthesize parentDirectoryNameInAttachmentFile;
@synthesize parentDirectoryNameOfCacheDirectory;
@synthesize fileType;

- (id)init
{
    if ((self = [super init]) == nil)
    {
        return nil;
    }
    
    isInit              = NO;
    attachmentFilePath  = nil;
    thumbnailFilePath	= nil;
    printFilePath		= nil;
    cacheDirectoryPath	= nil;
    parentDirectoryPathInAttachmentFile    = nil;
    parentDirectoryPathOfCacheDirectory    = nil;
    thumbnailFileName   = nil;
    printFileName       = nil;
    cacheDirectoryName	= nil;
    parentDirectoryNameInAttachmentFile    = nil;
    parentDirectoryNameOfCacheDirectory    = nil;
    fileType			= nil;
    return self;
}

- (void)dealloc
{
}

+ (NSString*) getRootDir {
    // Library/PrivateDocuments の取得
    NSString *privateDocumentsPath = [GeneralFileUtility getPrivateDocuments];
    // Library/PrivateDocuments/TempAttachmentFile の取得
    NSString *rootDir = [privateDocumentsPath stringByAppendingPathComponent:@"TempAttachmentFile"];

    return rootDir;
}

- (NSArray*) getPreviewFilePaths {
    if (!self.isInit) {
        return nil;
    }
    
    if (![self existsDirectoryInCacheDirectory]) {
        return nil;
    }
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSMutableArray *mutablePaths = [NSMutableArray array];
    if ([CommonUtil pdfExtensionCheck:self.attachmentFilePath] || [CommonUtil tiffExtensionCheck:self.attachmentFilePath]) {
        NSString *fileNameFormat = @"%@%03d.jpg";
        for (NSInteger i = 0; i < 1000; i++) {
            NSString *fileName = [NSString stringWithFormat:fileNameFormat, @"preview", i];
            
            NSString *filePath = [self.cacheDirectoryPath stringByAppendingPathComponent:fileName];
            if (![fileManager fileExistsAtPath:filePath]) {
                break;
            }
            [mutablePaths addObject:filePath];
        }
    } else if ([CommonUtil jpegExtensionCheck:self.attachmentFilePath]) {
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

- (NSArray*) getPreviewFileNames {
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

- (NSArray*) getPreviewImages {
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

- (UIImage*) getThumbnailImage {
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

- (BOOL) existsAttachmentFile{
    if (!self.isInit) {
        return NO;
    }
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    return [fileManager fileExistsAtPath:self.attachmentFilePath];
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

- (BOOL) isDirectory {
    if (!self.isInit) {
        return NO;
    }

    BOOL isDir = NO;
    NSFileManager *fileManager = [NSFileManager defaultManager];

    if ([fileManager fileExistsAtPath:self.attachmentFilePath isDirectory:&isDir]) {
        return isDir;
    }
    
    return NO;
}

- (BOOL) isZipFile {
    if (!self.isInit) {
        return NO;
    }
    if ([self isDirectory]) {
        return NO;
    }
    
    return [fileType isEqualToString:@"zip"];
}

- (BOOL) isEncryptedFile{
    if (!self.isInit) {
        return NO;
    }
    
    if (![self existsAttachmentFile]) {
        return NO;
    }
    
    // PDF以外は無条件で暗号化以外
    if (![CommonUtil pdfExtensionCheck:self.attachmentFilePath]) {
        return NO;
    }
    
    // ディレクトリとファイル名を分割
    NSRange range = [self.attachmentFilePath rangeOfString:@"/" options:NSCaseInsensitiveSearch | NSBackwardsSearch];
    NSString* dirPath = [self.attachmentFilePath substringToIndex:range.location+1];
    dirPath	= [dirPath stringByReplacingOccurrencesOfString:@"/" withString:@"//"];
    dirPath = [NSString stringWithFormat:@"file:/%@",dirPath];
    NSString* filename = [self.attachmentFilePath substringFromIndex:(range.location+1)];
    
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

- (BOOL) isRetensionCapable {
    if (!self.isInit) {
        return NO;
    }
    
    if (![self existsAttachmentFile]) {
        return NO;
    }
    
    // 暗号化PDF以外はリテンション可能
    return ![self isEncryptedFile];
}

- (BOOL) isNUPCapable {
    if (!self.isInit) {
        return NO;
    }
    
    // PDF以外は無条件でN-UP不可
    if (![CommonUtil pdfExtensionCheck:self.attachmentFilePath]) {
        return NO;
    }
    
    NSArray *arrayPaths = [self getPreviewFilePaths];
    
    return (arrayPaths != nil);
}

- (TempAttachmentFile*)initWithFilePath:(NSString*)pFilePath {
    attachmentFilePath = pFilePath;
    
    NSString *filePathBody = [attachmentFilePath stringByDeletingPathExtension];
    NSString *fileNameBody = [filePathBody lastPathComponent];
    NSString *extension = [[attachmentFilePath lastPathComponent] pathExtension];

    parentDirectoryPathInAttachmentFile = [attachmentFilePath stringByDeletingLastPathComponent];
    parentDirectoryPathOfCacheDirectory = parentDirectoryPathInAttachmentFile;
    parentDirectoryNameInAttachmentFile = [parentDirectoryPathInAttachmentFile lastPathComponent];
    parentDirectoryNameOfCacheDirectory = [parentDirectoryPathOfCacheDirectory lastPathComponent];
    
    cacheDirectoryName = [NSString stringWithFormat:@"Cache-%@-%@", fileNameBody, extension];
    cacheDirectoryPath = [parentDirectoryPathOfCacheDirectory stringByAppendingPathComponent:cacheDirectoryName];

    //サムネイルファイル名
    thumbnailFileName = [NSString stringWithFormat:@"thumbnail.png"];
    //サムネイルファイルのパス
    thumbnailFilePath = [cacheDirectoryPath stringByAppendingPathComponent:thumbnailFileName];

    //pngの印刷用ファイル名
    printFileName = [NSString stringWithFormat:@"printfile.jpg"];
    //pngの印刷用ファイルのパス
    printFilePath = [cacheDirectoryPath stringByAppendingPathComponent:printFileName];

    fileType = [extension lowercaseString];
    isInit = YES;
    return self;
}

@end
