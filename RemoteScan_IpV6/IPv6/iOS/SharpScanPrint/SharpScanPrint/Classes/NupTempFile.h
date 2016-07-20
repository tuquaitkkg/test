
#import <Foundation/Foundation.h>

@interface NupTempFile : NSObject {
    BOOL        isInit;
    NSString	*printFilePath;
    NSArray     *tempFilePaths;
    NSString	*printFileName;
    NSArray     *tempFileNames;
}

@property (nonatomic, readonly) BOOL isInit;
@property (nonatomic, readonly) NSString *printFilePath;
@property (nonatomic, readonly) NSArray *tempFilePaths;
@property (nonatomic, readonly) NSString *printFileName;
@property (nonatomic, readonly) NSArray *tempFileNames;

- (BOOL) existsPrintFile;
- (BOOL) existsTempFile;
- (NupTempFile*) initWithFilePaths:(NSArray*)pFilePaths IsPdf:(BOOL)pIsPdf;

@end
