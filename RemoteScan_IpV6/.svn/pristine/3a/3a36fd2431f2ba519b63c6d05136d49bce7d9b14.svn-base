
#import <Foundation/Foundation.h>
#import "TempAttachmentFile.h"

@interface TempAttachmentFiles : NSObject {
    NSMutableArray    *attachmentFiles;
}
@property (nonatomic,strong) NSMutableArray *attachmentFiles;

- (BOOL) hasEncryptedFile;
- (BOOL) isRetensionCapable;
- (BOOL) isNupCapable;
- (BOOL) isPrintablePS:(BOOL)psCapable;
- (BOOL) isPrintableOffice:(BOOL)officeCapable;
- (BOOL) hasPrintableFile:(BOOL)psCapable :(BOOL)isNupSet :(BOOL)isRetentionSet :(BOOL)officeCapable;

@end
