
#import <Foundation/Foundation.h>
#import "RSSEColorModeData.h"
#import "RSSECompressionData.h"
#import "RSSECompressionRatioData.h"
#import "RSSEDuplexDirData.h"
#import "RSSEDuplexModeData.h"
#import "RSSEExposureLevelData.h"
#import "RSSEExposureModeData.h"
#import "RSSEFileFormatData.h"
#import "RSSEManualSizeXData.h"
#import "RSSEManualSizeYData.h"
#import "RSSEOriginalSizeData.h"
#import "RSSEOriginalSourceData.h"
#import "RSSEPagesPerFileData.h"
#import "RSSEResolutionData.h"
#import "RSSERotationData.h"
#import "RSSESendSizeData.h"
#import "RSSESpecialModeData.h"
#import "RSSEPdfPasswordData.h"
#import "RSSEUseOCRData.h"
#import "RSSEOCRLanguageData.h"
#import "RSSEOCROutputFontData.h"
#import "RSSECorrectImageRotationData.h"
#import "RSSEExtractFileNameData.h"
#import "RSSEOCRAccuracyData.h"

@interface RSSettableElementsData : NSObject
{
    RSSEColorModeData *colorModeData;
    RSSEOriginalSizeData *originalSizeData;
    RSSEOriginalSourceData *originalSourceData;
    RSSESendSizeData *sendSizeData;
    RSSEResolutionData *resolutionData;
    RSSEExposureModeData *exposureModeData;
    RSSEExposureLevelData *exposureLevelData;
    RSSEDuplexModeData *duplexModeData;
    RSSEDuplexDirData *duplexDirData;
    RSSECompressionData *compressionData;
    RSSECompressionRatioData *compressionRatioData;
    RSSERotationData *rotationData;
    RSSEFileFormatData *fileFormatData;
    RSSESpecialModeData *specialModeData;
    RSSEPagesPerFileData *pagesPerFileData;
    RSSEPdfPasswordData *pdfPasswordData;
    RSSEUseOCRData *useOCRData;
    RSSEOCRLanguageData *ocrLanguageData;
    RSSEOCROutputFontData *ocrOutputFontData;
    RSSECorrectImageRotationData *correctImageRotationData;
    RSSEExtractFileNameData *extractFileNameData;
    RSSEOCRAccuracyData *ocrAccuracyData;
}

@property(nonatomic, strong) RSSEColorModeData *colorModeData;
@property(nonatomic, strong) RSSEOriginalSizeData *originalSizeData;
@property(nonatomic, strong) RSSESendSizeData *sendSizeData;
@property(nonatomic, strong) RSSEResolutionData *resolutionData;
@property(nonatomic, strong) RSSEExposureModeData *exposureModeData;
@property(nonatomic, strong) RSSEExposureLevelData *exposureLevelData;
@property(nonatomic, strong) RSSEDuplexModeData *duplexModeData;
@property(nonatomic, strong) RSSEDuplexDirData *duplexDirData;
@property(nonatomic, strong) RSSECompressionData *compressionData;
@property(nonatomic, strong) RSSECompressionRatioData *compressionRatioData;
@property(nonatomic, strong) RSSERotationData *rotationData;
@property(nonatomic, strong) RSSEFileFormatData *fileFormatData;
@property(nonatomic, strong) RSSESpecialModeData *specialModeData;
@property(nonatomic, strong) RSSEPagesPerFileData *pagesPerFileData;
@property(nonatomic, strong) RSSEPdfPasswordData *pdfPasswordData;
@property(nonatomic, strong) RSSEOriginalSourceData *originalSourceData;
@property(nonatomic, strong) RSSEUseOCRData *useOCRData;
@property(nonatomic, strong) RSSEOCRLanguageData *ocrLanguageData;
@property(nonatomic, strong) RSSEOCROutputFontData *ocrOutputFontData;
@property(nonatomic, strong) RSSECorrectImageRotationData *correctImageRotationData;
@property(nonatomic, strong) RSSEExtractFileNameData *extractFileNameData;
@property(nonatomic, strong) RSSEOCRAccuracyData *ocrAccuracyData;
@end
