
#import "NupTempFile.h"
#import "NupTempFileUtility.h"

@implementation NupTempFile

@synthesize isInit;
@synthesize printFilePath;
@synthesize tempFilePaths;
@synthesize printFileName;
@synthesize tempFileNames;

- (id)init
{
    if ((self = [super init]) == nil)
    {
        return nil;
    }
    
    isInit              = NO;
    printFilePath       = nil;
    tempFilePaths       = nil;
    printFileName		= nil;
    tempFileNames       = nil;
    return self;
}

- (void)dealloc
{
}

- (BOOL) existsPrintFile {
    if (!self.isInit) {
        return NO;
    }
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    return [fileManager fileExistsAtPath:self.printFilePath];
}

- (BOOL) existsTempFile {
    if (!self.isInit) {
        return NO;
    }
    if (self.tempFilePaths == nil) {
        return NO;
    }
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    for (NSInteger i = 0; i < [self.tempFilePaths count]; i++) {
        NSString *fullPath = [self.tempFilePaths objectAtIndex:i];
        
        if (![fileManager fileExistsAtPath:fullPath]) {
            return NO;
        }
    }
    
    return YES;
}

- (NSString*) getNupTmpDir{
    NSString *nupTmpDir = [NupTempFileUtility getNupTmpDir];
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    [fileManager createDirectoryAtPath:nupTmpDir
           withIntermediateDirectories:YES
                            attributes:nil
                                 error:NULL];
    return nupTmpDir;
}

- (NupTempFile*) initWithFilePaths:(NSArray*)pFilePaths IsPdf:(BOOL)pIsPdf {
    NSString *nupTmpDir = [self getNupTmpDir];
    
    if (pFilePaths != nil && [pFilePaths count] > 0) {
        tempFilePaths = pFilePaths;
    } else {
        tempFilePaths = nil;
    }
    if (self.tempFilePaths != nil && [self.tempFilePaths count] > 0) {
        NSMutableArray *mutableList = [NSMutableArray array];
        for (NSInteger i = 0; i < [self.tempFilePaths count]; i++) {
            NSString *fullPath = [self.tempFilePaths objectAtIndex:i];
            NSString *fileName = [fullPath lastPathComponent];
            
            [mutableList addObject:fileName];
        }
        tempFileNames = [mutableList copy];
    } else {
        tempFileNames = nil;
    }
    
    if (pIsPdf) {
        printFileName = S_PRINT_DATA_FILENAME_FOR_PRINT_PDF;
    } else {
        printFileName = S_PRINT_DATA_FILENAME_FOR_PRINT_TIFF;
    }
    printFilePath = [nupTmpDir stringByAppendingPathComponent:self.printFileName];
    
    isInit = YES;

    return self;
}

@end
