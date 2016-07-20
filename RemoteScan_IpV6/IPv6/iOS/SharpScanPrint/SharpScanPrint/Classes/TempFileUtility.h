
#import <Foundation/Foundation.h>
#import "TempFile.h"
#import "CommonManager.h"
#import "TIFFManager.h"
#import "CommonUtil.h"
#import "ScanFile.h"
#import "TempDataManager.h"

@interface TempFileUtility : NSObject {
    
}

+ (NSNumber*)getFileSize:(TempFile*)pTempFile;

/** 必要な画像ファイルすべてを生成します */
+ (BOOL)createRequiredAllImageFiles:(TempFile*)pTempFile;
+ (BOOL)createThumbnailFile:(TempFile*)pTempFile;
+ (BOOL)createCacheFile:(TempFile*)pTempFile;
+ (BOOL)createPrintFile:(TempFile*)pTempFile;
+ (BOOL)createPreviewFiles:(TempFile*)pTempFile;
+ (BOOL)deleteFile:(TempFile*)pTempFile;
+ (BOOL)deletePreviewFiles:(TempFile*)pTempFile;
+ (BOOL)deletePrintFileByFileName:(NSString*)pTempFileName;
+ (BOOL)createCacheFileForWeb;
@end
