
#import "TempAttachmentFiles.h"
#import "CommonUtil.h"

@implementation TempAttachmentFiles

@synthesize attachmentFiles;

- (id)init
{
    if ((self = [super init]) == nil)
    {
        return nil;
    }
    
    self.attachmentFiles = nil;
    return self;
}

- (void)dealloc
{
}

- (BOOL) hasEncryptedFile{
    if (self.attachmentFiles == nil) {
        return NO;
    }
    
    for (NSInteger i = 0; i < self.attachmentFiles.count; i++) {
        TempAttachmentFile *attachmentFile = [attachmentFiles objectAtIndex:i];
        if ([attachmentFile isEncryptedFile]) {
            return YES;
        }
    }
    
    return NO;
}

- (BOOL) isRetensionCapable{
    if (self.attachmentFiles == nil || self.attachmentFiles.count == 0) {
        return NO;
    }
    
    for (NSInteger i = 0; i < self.attachmentFiles.count; i++) {
        TempAttachmentFile *attachmentFile = [attachmentFiles objectAtIndex:i];
        if (![attachmentFile isRetensionCapable]) {
            return NO;
        }
    }
    
    return YES;
}

- (BOOL) isNupCapable{
    if (self.attachmentFiles == nil || self.attachmentFiles.count == 0) {
        return NO;
    }
    
    for (NSInteger i = 0; i < self.attachmentFiles.count; i++) {
        TempAttachmentFile *attachmentFile = [attachmentFiles objectAtIndex:i];
        if (![attachmentFile isNUPCapable]) {
            return NO;
        }
    }
    
    return YES;
}

- (BOOL) hasPrintableFile:(BOOL)psCapable :(BOOL)isNupSet :(BOOL)isRetentionSet :(BOOL)officeCapable{
    if (self.attachmentFiles == nil) {
        return NO;
    }
    
    BOOL hasPrintable = NO;
    for (NSInteger i = 0; i < self.attachmentFiles.count; i++) {
        hasPrintable = YES;
        TempAttachmentFile *attachmentFile = [attachmentFiles objectAtIndex:i];
        if (!psCapable && [CommonUtil pdfExtensionCheck:attachmentFile.attachmentFilePath]){
            hasPrintable = NO;
        }
        if (isNupSet && ![attachmentFile isNUPCapable] ){
            hasPrintable = NO;
        }
        if (isRetentionSet && ![attachmentFile isRetensionCapable] ){
            hasPrintable = NO;
        }
        if (!officeCapable && [CommonUtil officeExtensionCheck:attachmentFile.attachmentFilePath]) {
            hasPrintable = NO;
        }
        if(hasPrintable){
            return YES;
        }
    }
    return NO;
}

- (BOOL) isPrintablePS:(BOOL)psCapable{
    if(psCapable){
        return YES;
    }else{
        for (NSInteger i = 0; i < self.attachmentFiles.count; i++) {
            TempAttachmentFile * attachmentFile = [attachmentFiles objectAtIndex:i];
            if ([CommonUtil pdfExtensionCheck:attachmentFile.attachmentFilePath]) {
                return NO;
            }
        }
        return YES;
    }
}

- (BOOL) isPrintableOffice:(BOOL)officeCapable{
    if(officeCapable){
        return YES;
    }else{
        for (NSInteger i = 0; i < self.attachmentFiles.count; i++) {
            TempAttachmentFile * attachmentFile = [attachmentFiles objectAtIndex:i];
            if ([CommonUtil officeExtensionCheck:attachmentFile.attachmentFilePath]) {
                return NO;
            }
        }
        return YES;
    }
}


@end
