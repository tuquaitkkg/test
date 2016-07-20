
#import <UIKit/UIKit.h>
#import "RemoteScanSettingViewData.h"
#import "RSCustomPaperSizeData.h"

@interface RemoteScanData : NSObject
{
    NSString *colorMode;
    NSString *originalSize;
    NSString *ManualSizeX;
    NSString *ManualSizeY;
    NSString *ManualSizeName;
    NSString *sendSize;
    NSString *rotation;
    NSString *duplexMode;
    NSString *duplexDir;
    NSString *fileFormat;
    NSString *compression;
    NSString *compressionRatio;
    NSString *pagesPerFile;
    NSString *pdfPassword;
    NSString *resolution;
    NSString *exposureMode;
    NSString *exposureLevel;
    NSString *specialMode;
    NSString *selectColorMode;
    NSString *useOCR;
    NSString *ocrLanguage;
    NSString *ocrOutputFont;
    NSString *correctImageRotation;
    NSString *extractFileName;
    NSString *ocrAccuracy;
}

@property(nonatomic, copy) NSString *colorMode;
@property(nonatomic, copy) NSString *originalSize;
@property(nonatomic, copy) NSString *ManualSizeX;
@property(nonatomic, copy) NSString *ManualSizeY;
@property(nonatomic, copy) NSString *ManualSizeName;
@property(nonatomic, copy) NSString *sendSize;
@property(nonatomic, copy) NSString *rotation;
@property(nonatomic, copy) NSString *duplexMode;
@property(nonatomic, copy) NSString *duplexDir;
@property(nonatomic, copy) NSString *fileFormat;
@property(nonatomic, copy) NSString *compression;
@property(nonatomic, copy) NSString *compressionRatio;
@property(nonatomic, copy) NSString *pagesPerFile;
@property(nonatomic, copy) NSString *pdfPassword;
@property(nonatomic, copy) NSString *resolution;
@property(nonatomic, copy) NSString *exposureMode;
@property(nonatomic, copy) NSString *exposureLevel;
@property(nonatomic, copy) NSString *specialMode;
@property(nonatomic, copy) NSString *selectColorMode;
@property(nonatomic, copy) NSString *useOCR;
@property(nonatomic, copy) NSString *ocrLanguage;
@property(nonatomic, copy) NSString *ocrOutputFont;
@property(nonatomic, copy) NSString *correctImageRotation;
@property(nonatomic, copy) NSString *extractFileName;
@property(nonatomic, copy) NSString *ocrAccuracy;

@end
