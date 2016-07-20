
#import "RemoteScanData.h"

#define SAFE_STR(x) (x ? x : @"")

@implementation RemoteScanData

@synthesize colorMode;
@synthesize originalSize;
@synthesize ManualSizeX;
@synthesize ManualSizeY;
@synthesize ManualSizeName;
@synthesize sendSize;
@synthesize rotation;
@synthesize duplexMode;
@synthesize duplexDir;
@synthesize fileFormat;
@synthesize compression;
@synthesize compressionRatio;
@synthesize pagesPerFile;
@synthesize pdfPassword;
@synthesize resolution;
@synthesize exposureMode;
@synthesize exposureLevel;
@synthesize specialMode;
@synthesize selectColorMode;
@synthesize useOCR;
@synthesize ocrLanguage;
@synthesize ocrOutputFont;
@synthesize correctImageRotation;
@synthesize extractFileName;
@synthesize ocrAccuracy;

- (id)init
{
    self = [super init];
    if (self)
    {
        self.colorMode = @"";
        self.originalSize = @"";
        self.ManualSizeX = @"";
        self.ManualSizeY = @"";
        self.ManualSizeName = @"";
        self.sendSize = @"";
        self.rotation = @"";
        self.duplexMode = @"";
        self.duplexDir = @"";
        self.fileFormat = @"";
        self.compression = @"";
        self.compressionRatio = @"";
        self.pagesPerFile = @"";
        self.pdfPassword = @"";
        self.resolution = @"";
        self.exposureMode = @"";
        self.exposureLevel = @"";
        self.specialMode = @"";
        self.selectColorMode = @"";
        self.useOCR = @"";
        self.ocrLanguage = @"";
        self.ocrOutputFont = @"";
        self.correctImageRotation = @"";
        self.extractFileName = @"";
        self.ocrAccuracy = @"";
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)coder
{
    self = [super init];
    if (self)
    {
        self.colorMode = SAFE_STR([coder decodeObjectForKey:@"colorMode"]);
        self.originalSize = SAFE_STR([coder decodeObjectForKey:@"originalSize"]);
        self.ManualSizeX = SAFE_STR([coder decodeObjectForKey:@"ManualSizeX"]);
        self.ManualSizeY = SAFE_STR([coder decodeObjectForKey:@"ManualSizeY"]);
        self.ManualSizeName = SAFE_STR([coder decodeObjectForKey:@"ManualSizeName"]);
        self.sendSize = SAFE_STR([coder decodeObjectForKey:@"sendSize"]);
        self.rotation = SAFE_STR([coder decodeObjectForKey:@"rotation"]);
        self.duplexMode = SAFE_STR([coder decodeObjectForKey:@"duplexMode"]);
        self.duplexDir = SAFE_STR([coder decodeObjectForKey:@"duplexDir"]);
        self.fileFormat = SAFE_STR([coder decodeObjectForKey:@"fileFormat"]);
        self.compression = SAFE_STR([coder decodeObjectForKey:@"compression"]);
        self.compressionRatio = SAFE_STR([coder decodeObjectForKey:@"compressionRatio"]);
        self.pagesPerFile = SAFE_STR([coder decodeObjectForKey:@"pagesPerFile"]);
        self.pdfPassword = SAFE_STR([coder decodeObjectForKey:@"pdfPassword"]);
        self.resolution = SAFE_STR([coder decodeObjectForKey:@"resolution"]);
        self.exposureMode = SAFE_STR([coder decodeObjectForKey:@"exposureMode"]);
        self.exposureLevel = SAFE_STR([coder decodeObjectForKey:@"exposureLevel"]);
        self.specialMode = SAFE_STR([coder decodeObjectForKey:@"specialMode"]);
        self.selectColorMode = SAFE_STR([coder decodeObjectForKey:@"selectColorMode"]);
        self.useOCR = SAFE_STR([coder decodeObjectForKey:@"useOCR"]);
        self.ocrLanguage = SAFE_STR([coder decodeObjectForKey:@"ocrLanguage"]);
        self.ocrOutputFont = SAFE_STR([coder decodeObjectForKey:@"ocrOutputFont"]);
        self.correctImageRotation = SAFE_STR([coder decodeObjectForKey:@"correctImageRotation"]);
        self.extractFileName = SAFE_STR([coder decodeObjectForKey:@"extractFileName"]);
        self.ocrAccuracy = SAFE_STR([coder decodeObjectForKey:@"ocrAccuracy"]);
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)coder
{
    [coder encodeObject:SAFE_STR(colorMode) forKey:@"colorMode"];
    [coder encodeObject:SAFE_STR(originalSize) forKey:@"originalSize"];
    [coder encodeObject:SAFE_STR(ManualSizeX) forKey:@"ManualSizeX"];
    [coder encodeObject:SAFE_STR(ManualSizeY) forKey:@"ManualSizeY"];
    [coder encodeObject:SAFE_STR(ManualSizeName) forKey:@"ManualSizeName"];
    [coder encodeObject:SAFE_STR(sendSize) forKey:@"sendSize"];
    [coder encodeObject:SAFE_STR(rotation) forKey:@"rotation"];
    [coder encodeObject:SAFE_STR(duplexMode) forKey:@"duplexMode"];
    [coder encodeObject:SAFE_STR(duplexDir) forKey:@"duplexDir"];
    [coder encodeObject:SAFE_STR(fileFormat) forKey:@"fileFormat"];
    [coder encodeObject:SAFE_STR(compression) forKey:@"compression"];
    [coder encodeObject:SAFE_STR(compressionRatio) forKey:@"compressionRatio"];
    [coder encodeObject:SAFE_STR(pagesPerFile) forKey:@"pagesPerFile"];
    [coder encodeObject:SAFE_STR(pdfPassword) forKey:@"pdfPassword"];
    [coder encodeObject:SAFE_STR(resolution) forKey:@"resolution"];
    [coder encodeObject:SAFE_STR(exposureMode) forKey:@"exposureMode"];
    [coder encodeObject:SAFE_STR(exposureLevel) forKey:@"exposureLevel"];
    [coder encodeObject:SAFE_STR(specialMode) forKey:@"specialMode"];
    [coder encodeObject:SAFE_STR(selectColorMode) forKey:@"selectColorMode"];
    [coder encodeObject:SAFE_STR(useOCR) forKey:@"useOCR"];
    [coder encodeObject:SAFE_STR(ocrLanguage) forKey:@"ocrLanguage"];
    [coder encodeObject:SAFE_STR(ocrOutputFont) forKey:@"ocrOutputFont"];
    [coder encodeObject:SAFE_STR(correctImageRotation) forKey:@"correctImageRotation"];
    [coder encodeObject:SAFE_STR(extractFileName) forKey:@"extractFileName"];
    [coder encodeObject:SAFE_STR(ocrAccuracy) forKey:@"ocrAccuracy"];
}

- (NSString *)description
{

    return [NSString stringWithFormat:@"colorMode[%@], originalSize[%@], ManualSizeX[%@], ManualSizeY[%@], ManualSizeName[%@], sendSize[%@], rotation[%@], duplexMode[%@], duplexDir[%@], fileFormat[%@], compression[%@], compressionRatio[%@], pagesPerFile[%@], pdfPassword[%@], resolution[%@], exposureMode[%@], exposureLevel[%@], specialMode[%@], selectColorMode[%@], useOCR[%@], ocrLanguage[%@], ocrOutputFont[%@], correctImageRotation[%@], extractFileName[%@], ocrAccuracy[%@]",
                                      colorMode,
                                      originalSize,
                                      ManualSizeX,
                                      ManualSizeY,
                                      ManualSizeName,
                                      sendSize,
                                      rotation,
                                      duplexMode,
                                      duplexDir,
                                      fileFormat,
                                      compression,
                                      compressionRatio,
                                      pagesPerFile,
                                      pdfPassword,
                                      resolution,
                                      exposureMode,
                                      exposureLevel,
                                      specialMode,
                                      selectColorMode,
                                      useOCR,
                                      ocrLanguage,ocrOutputFont,
                                      correctImageRotation,
                                      extractFileName,
                                      ocrAccuracy];
}

@end
