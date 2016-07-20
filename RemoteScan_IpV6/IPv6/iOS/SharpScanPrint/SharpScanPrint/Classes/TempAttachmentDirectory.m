
#import "TempAttachmentDirectory.h"

@implementation TempAttachmentDirectory

@synthesize isInit;
@synthesize directoryNameInAttachmentDirectory;
@synthesize directoryNameInCacheDirectory;
@synthesize isRootDirectory;
@synthesize directoryPathInAttachmentDirectory;
@synthesize directoryPathInCacheDirectory;
@synthesize zipDestinationPath;

- (id)init
{
    if ((self = [super init]) == nil)
    {
        return nil;
    }
    
    isInit             = NO;
    directoryNameInAttachmentDirectory  = nil;
    directoryNameInCacheDirectory = nil;
    isRootDirectory    = NO;
    directoryPathInAttachmentDirectory  = nil;
    directoryPathInCacheDirectory = nil;
    zipDestinationPath  = nil;
    return self;
}

- (void)dealloc
{
}

- (TempAttachmentDirectory *) initWithDirectoryPath:(NSString*)pDirectoryPath {
    directoryNameInAttachmentDirectory  = [pDirectoryPath lastPathComponent];
    directoryNameInCacheDirectory = [pDirectoryPath lastPathComponent];
    directoryPathInAttachmentDirectory = [[pDirectoryPath stringByDeletingLastPathComponent] stringByAppendingPathComponent:[pDirectoryPath lastPathComponent]];
    directoryPathInCacheDirectory  = directoryPathInAttachmentDirectory;
    NSString *tempAttachmentRootPath = [TempAttachmentFileUtility getRootDir];

    isRootDirectory    = [tempAttachmentRootPath isEqualToString:directoryPathInAttachmentDirectory];

    isInit = YES;
    return self;
}

@end
