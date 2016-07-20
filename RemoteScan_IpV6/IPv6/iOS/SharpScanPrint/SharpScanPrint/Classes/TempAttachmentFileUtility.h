
#import <Foundation/Foundation.h>
#import "TempAttachmentFile.h"

@interface TempAttachmentFileUtility : NSObject {
    
}
/** 必要な画像ファイルすべてを生成します */
+ (BOOL)createRequiredAllImageFiles:(TempAttachmentFile*)pTempAttachmentFile;
+ (BOOL)createRequiredDirectories;
+ (BOOL)createCacheFile:(TempAttachmentFile*)pTempAttachmentFile;
+ (BOOL)createThumbnailFile:(TempAttachmentFile*)pTempAttachmentFile;
+ (BOOL)createPrintFile:(TempAttachmentFile*)pTempAttachmentFile;
+ (BOOL)createPreviewFiles:(TempAttachmentFile*)pTempAttachmentFile;
+ (BOOL)deletePreviewFiles:(TempAttachmentFile*)pTempAttachmentFile;
+ (BOOL)deleteMailTmpDir;
+ (NSString*) getRootDir;
@end
