
#import "ScanFiles.h"
#import "ScanFile.h"
#import "CommonUtil.h"

@implementation ScanFiles

@synthesize scanFiles;

- (id)init
{
    if ((self = [super init]) == nil)
    {
        return nil;
    }
    
    self.scanFiles       = nil;
    return self;
}

- (void)dealloc
{
}

- (BOOL) hasEncryptedFile{
    if (self.scanFiles == nil) {
        return NO;
    }
    
    for (NSInteger i = 0; i < self.scanFiles.count; i++) {
        ScanFile *scanFile = [scanFiles objectAtIndex:i];
        if ([scanFile isEncryptedFile]) {
            return YES;
        }
    }
    
    return NO;
}

- (BOOL) isRetensionCapable{
    if (self.scanFiles == nil || self.scanFiles.count == 0) {
        return NO;
    }
    
    for (NSInteger i = 0; i < self.scanFiles.count; i++) {
        ScanFile *scanFile = [scanFiles objectAtIndex:i];
        if (![scanFile isRetensionCapable]) {
            return NO;
        }
    }
    
    return YES;
}

- (BOOL) isNupCapable{
    if (self.scanFiles == nil || self.scanFiles.count == 0) {
        return NO;
    }
    
    for (NSInteger i = 0; i < self.scanFiles.count; i++) {
        ScanFile *scanFile = [scanFiles objectAtIndex:i];
        if (![scanFile isNupCapable]) {
            return NO;
        }
    }
    
    return YES;
}

- (BOOL) hasPrintableFile:(BOOL)psCapable :(BOOL)isNupSet :(BOOL)isRetentionSet :(BOOL)officeCapable{
    if (self.scanFiles == nil) {
        return NO;
    }

    BOOL hasPrintable = NO;
    for (NSInteger i = 0; i < self.scanFiles.count; i++) {
        hasPrintable = YES;
        ScanFile *scanFile = [scanFiles objectAtIndex:i];
        if (!psCapable && [CommonUtil pdfExtensionCheck:scanFile.scanFilePath]){
            hasPrintable = NO;
        }
        if (isNupSet && ![scanFile isNupCapable] ){
            hasPrintable = NO;
        }
        if (isRetentionSet && ![scanFile isRetensionCapable] ){
            hasPrintable = NO;
        }
        if (!officeCapable && [CommonUtil officeExtensionCheck:scanFile.scanFilePath]) {
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
        for (NSInteger i = 0; i < self.scanFiles.count; i++) {
            ScanFile *scanFile = [scanFiles objectAtIndex:i];
            if ([CommonUtil pdfExtensionCheck:scanFile.scanFilePath]) {
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
        for (NSInteger i = 0; i < self.scanFiles.count; i++) {
            ScanFile *scanFile = [scanFiles objectAtIndex:i];
            if ([CommonUtil officeExtensionCheck:scanFile.scanFilePath]) {
                return NO;
            }
        }
        return YES;
    }
}

@end
