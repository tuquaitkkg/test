
#import <Foundation/Foundation.h>
#import "TempAttachmentFileUtility.h"

@interface TempAttachmentDirectory : NSObject {
    BOOL        isInit;
    NSString	*directoryNameInAttachmentDirectory;
    NSString	*directoryNameInCacheDirectory;
    BOOL        isRootDirectory;
    NSString	*directoryPathInAttachmentDirectory;
    NSString	*directoryPathInCacheDirectory;
    NSString    *zipDestinationPath;
}

@property (nonatomic, readonly) BOOL isInit;
@property (nonatomic, readonly) NSString *directoryNameInAttachmentDirectory;
@property (nonatomic, readonly) NSString *directoryNameInCacheDirectory;
@property (nonatomic, readonly) BOOL isRootDirectory;
@property (nonatomic, readonly) NSString *directoryPathInAttachmentDirectory;
@property (nonatomic, readonly) NSString *directoryPathInCacheDirectory;
@property (nonatomic, readonly) NSString *destinationPath;
@property (nonatomic, readonly) NSString *zipDestinationPath;
- (TempAttachmentDirectory *) initWithDirectoryPath:(NSString*)pDirectoryPath;

@end
