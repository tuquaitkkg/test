
#import <Foundation/Foundation.h>

@interface TempAttachmentFile : NSObject {
    BOOL        isInit;
    NSString	*attachmentFilePath;
    NSString	*thumbnailFilePath;
    NSString	*printFilePath;
    NSString	*cacheDirectoryPath;
    NSString	*parentDirectoryPathInAttachmentFile;
    NSString	*parentDirectoryPathOfCacheDirectory;
    NSString	*thumbnailFileName;
    NSString	*printFileName;
    NSString	*cacheDirectoryName;
    NSString	*parentDirectoryNameInAttachmentFile;
    NSString	*parentDirectoryNameOfCacheDirectory;
    NSString	*fileType;
}

@property (nonatomic, readonly) BOOL isInit;
@property (nonatomic, readonly) NSString *attachmentFilePath;
@property (nonatomic, readonly) NSString *thumbnailFilePath;
@property (nonatomic, readonly) NSString *printFilePath;
@property (nonatomic, readonly) NSString *cacheDirectoryPath;
@property (nonatomic, readonly) NSString *parentDirectoryPathInAttachmentFile;
@property (nonatomic, readonly) NSString *parentDirectoryPathOfCacheDirectory;
@property (nonatomic, readonly) NSString *thumbnailFileName;
@property (nonatomic, readonly) NSString *printFileName;
@property (nonatomic, readonly) NSString *cacheDirectoryName;
@property (nonatomic, readonly) NSString *parentDirectoryNameInAttachmentFile;
@property (nonatomic, readonly) NSString *parentDirectoryNameOfCacheDirectory;
@property (nonatomic, readonly) NSString *fileType;

+ (NSString*) getRootDir;
- (NSArray*) getPreviewFilePaths;
- (NSArray*) getPreviewFileNames;
- (NSArray*) getPreviewImages;
- (UIImage*) getThumbnailImage;

/** attachmentFile存在チェック */
- (BOOL) existsAttachmentFile;

- (BOOL) existsDirectoryInCacheDirectory;

/** プレビュー存在チェック */
- (BOOL) existsPreviewFile;

/** サムネイル存在チェック */
- (BOOL) existsThumbnailFile;

/** png印刷用jpg存在チェック */
- (BOOL) existsPrintFile;

- (BOOL) isDirectory;
- (BOOL) isZipFile;
- (BOOL) isEncryptedFile;
- (BOOL) isRetensionCapable;
- (BOOL) isNUPCapable;
- (TempAttachmentFile*)initWithFilePath:(NSString*)pFilePath;

@end
