
#import <Foundation/Foundation.h>
#import "Define.h"

@interface PaperSetMatrix : NSObject
{
    NSArray* paperMatrixPortrate;
    NSArray* paperMatrixLandscape;
    NSArray* paperIndex;
}

@property (nonatomic, strong) NSArray* paperMatrixPortrate;
@property (nonatomic, strong) NSArray* paperMatrixLandscape;
@property (nonatomic, strong) NSArray* paperIndex;

//- (NSArray*)scan:(NSString*)scanPaperList orientation: (NSInteger)orientation;
//- (NSArray*)save:(NSString*)savePaperList orientation: (NSInteger)orientation;

- (BOOL)originalSize:(NSString*)scanPaper sendSize: (NSString*)savePaper rotation: (NSString*)rotation;
- (void)setMatirx;
@end
