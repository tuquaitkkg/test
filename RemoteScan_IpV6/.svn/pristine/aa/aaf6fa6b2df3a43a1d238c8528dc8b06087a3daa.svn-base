
#import <Foundation/Foundation.h>
#import "NupTempFile.h"
#import "GeneralFileUtility.h"

@interface NupTempFileUtility : NSObject {
    
}

+ (NSString*)getNupTmpDir;
+ (BOOL)initializeNupTmpDir;
+ (NSNumber*)getFileSize:(NupTempFile*)pNupTempFile;
+ (NupTempFile*)createPrintFileTiff:(NSArray*)pTempFilePaths;
+ (NupTempFile*)createPrintFilePdf:(NSArray*)pTempFilePaths Nup:(int)pNup NupOrder:(int)pNupOrder PaperSize:(int)pPaperSize;
+ (NupTempFile*)createPrintFileFromScanFile:(NSString*)pFilePath FileIndexs:(NSArray*)pFileIndexs Nup:(int)pNup NupOrder:(int)pNupOrder PaperSize:(int)pPaperSize IsError:(BOOL*)pIsError;

@end
