
#import "FileNameChangeViewController.h"
#import "TempFile.h"

@interface RenameScanAfterDataViewController : FileNameChangeViewController
{
    NSString* deletePart;
    BOOL isMulti;
}

@property (assign) BOOL isMulti;
@property (nonatomic, strong)   TempFile * tempFile;

@end
