
#import <Foundation/Foundation.h>

@interface ScanFiles : NSObject {
    NSMutableArray    *scanFiles;
}

@property (nonatomic,strong) NSMutableArray *scanFiles;

- (BOOL) hasEncryptedFile;
- (BOOL) isRetensionCapable;
- (BOOL) isNupCapable;
- (BOOL) isPrintablePS:(BOOL)psCapable;
- (BOOL) isPrintableOffice:(BOOL)officeCapable;
- (BOOL) hasPrintableFile:(BOOL)psCapable :(BOOL)isNupSet :(BOOL)isRetentionSet :(BOOL)officeCapable;
@end
