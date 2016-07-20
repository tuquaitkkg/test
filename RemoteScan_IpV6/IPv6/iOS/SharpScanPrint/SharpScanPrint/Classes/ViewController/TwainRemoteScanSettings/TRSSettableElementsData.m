
#import "TRSSettableElementsData.h"

@implementation TRSSettableElementsData

@synthesize colorModeData;
@synthesize originalSizeData;
@synthesize originalSourceData;
@synthesize sendSizeData;
@synthesize resolutionData;
@synthesize exposureModeData;
@synthesize exposureLevelData;
@synthesize duplexModeData;
@synthesize duplexDirData;
@synthesize compressionData;
@synthesize compressionRatioData;
@synthesize rotationData;
@synthesize fileFormatData;
@synthesize specialModeData;
@synthesize pagesPerFileData;
@synthesize pdfPasswordData;

- (id)init {
    self = [super init];
    if (self) {
        colorModeData = [[RSSEColorModeData alloc]init];
        originalSizeData = [[RSSEOriginalSizeData alloc]init];
        originalSourceData = [[RSSEOriginalSourceData alloc]init];
        sendSizeData = [[RSSESendSizeData alloc]init];
        resolutionData = [[RSSEResolutionData alloc]init];
        exposureModeData = [[RSSEExposureModeData alloc]init];
        exposureLevelData = [[RSSEExposureLevelData alloc]init];
        duplexModeData = [[RSSEDuplexModeData alloc]init];
        duplexDirData = [[RSSEDuplexDirData alloc]init];
        compressionData = [[RSSECompressionData alloc]init];
        compressionRatioData = [[RSSECompressionRatioData alloc]init];
        rotationData = [[RSSERotationData alloc]init];
        fileFormatData = [[RSSEFileFormatData alloc]init];
        specialModeData = [[RSSESpecialModeData alloc]init];
        pagesPerFileData = [[RSSEPagesPerFileData alloc]init];
        pdfPasswordData = [[RSSEPdfPasswordData alloc]init];
    }
    return self;
}

@end
