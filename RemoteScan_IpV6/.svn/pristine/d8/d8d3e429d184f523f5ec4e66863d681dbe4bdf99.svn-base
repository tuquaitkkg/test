
#import "RSSVListTypeData.h"
#import "RSSEFileFormatData.h"
#import "RSSECompressionRatioData.h"
#import "RSSECompressionData.h"
#import "RSSEPagesPerFileData.h"
#import "RSSEPdfPasswordData.h"
#import "RSSVColorModeData.h"
#import "RSSVOriginalSizeData.h"
#import "RSSEUseOCRData.h"
#import "RSSEOCRLanguageData.h"
#import "RSSEOCROutputFontData.h"
#import "RSSECorrectImageRotationData.h"
#import "RSSEExtractFileNameData.h"
#import "RSSettableElementsData.h"
#import "RSSEOCRAccuracyData.h"

enum
{
    E_RSSVFORMATDATA_COLOR_MODE_FULLCOLOR,
    E_RSSVFORMATDATA_COLOR_MODE_MONOCHROME,
};

enum
{
    E_RSSVFORMATDATA_SETPASSOWRD_ERR_NONE,
    E_RSSVFORMATDATA_SETPASSOWRD_ERR_LENGTH_OVER,
    E_RSSVFORMATDATA_SETPASSOWRD_ERR_LENGTH_UNDER,
    E_RSSVFORMATDATA_SETPASSOWRD_ERR_FORMAT,
};

@class BoolAndRange;

@interface RSSVFormatData : RSSVListTypeData
{
    int nSelectColorMode;

    NSMutableArray *fileFormatArray;
    NSUInteger nSelectFileFormat;

    NSMutableArray *compactPdfTypeArray;
    NSMutableArray *compactPdfaTypeArray;
    NSMutableArray *compactPdfa_1aTypeArray;
    int nSelectCompactPdfType;

    RSSECompressionRatioData *compressionRatioData;
    int nSelectCompressionRatio;

    RSSECompressionData *compressionData;
    int nSelectCompression;

    BoolAndRange *selectablePagePerFile;
    BOOL isPagePerFile;
    int selectPagePerFile;
    BoolAndRange *selectableEncrypt;
    BOOL isEncript;
    NSString *password;
    
    RSSEOCRLanguageData *ocrLanguageData;
    NSString *strSelectOCRLanguageKey;
    RSSEOCROutputFontData *ocrOutputFontData;
    NSString *strSelectOCROutputFontKey;
    RSSEOCRAccuracyData *ocrAccuracyData;
    NSString *strSelectOCRAccuracyKey;
    
    NSInteger nBeforeFileFormat;
    
}
@property(nonatomic) int nSelectColorMode;
@property(nonatomic, readonly) BoolAndRange *selectablePagePerFile;
@property(nonatomic) BOOL isPagePerFile;
@property(nonatomic) int selectPagePerFile;
@property(nonatomic, readonly) BoolAndRange *selectableEncrypt;
@property(nonatomic) BOOL isEncript;
@property(nonatomic, readonly) NSString *password;
@property(nonatomic) BOOL validOCR;  // OCRが有効な場合YES
@property(nonatomic) BOOL isOCR;
@property(nonatomic) BOOL validCorrectImaegRotation;
@property(nonatomic) BOOL isCorrectImageRotation;
@property(nonatomic) BOOL validExtractFileName;
@property(nonatomic) BOOL isExtractFileName;
@property(nonatomic) BOOL validOCRAccuracy; // OCR精度が有効な場合YES

#pragma mark - Init
- (id)initWithColorMode:(int)colorMode
             fileFormat:(RSSEFileFormatData *)format
            compression:(RSSECompressionData *)compress
                  ratio:(RSSECompressionRatioData *)ratio
            pagePerFile:(RSSEPagesPerFileData *)pagePerFile
            pdfPassword:(RSSEPdfPasswordData *)pdfPass
                 useOCR:(RSSEUseOCRData *)useOCR
            ocrLanguage:(RSSEOCRLanguageData *)ocrLanguage
          ocrOutputFont:(RSSEOCROutputFontData *)ocrOutputFont
   correctImageRotation:(RSSECorrectImageRotationData *)correctImageRotation
        extractFileName:(RSSEExtractFileNameData *)extractFileName
            ocrAccuracy:(RSSEOCRAccuracyData *)ocrAccuracy
            multiCropOn:(BOOL)bMultiCrop
       originalSizeLong:(BOOL)bOriginalSizeLong;

#pragma mark - Get Selectable Array
- (NSArray *)getSelectableFileFormatArray;
- (NSArray *)getSelectableCompactPdfTypeArray;
- (NSArray *)getSelectableCompressionRatioArray:(BOOL)bMultiCrop;
- (NSArray *)getSelectableCompressionArray;
- (NSArray *)getSelectableOCRLanguageKeys;
- (NSArray *)getSelectableOCRLanguageValues:(NSArray *)ocrLanguageKeys;
- (NSArray *)getSelectableOCROutputFontKeys:(NSString *)ocrLanguageKey;
- (NSArray *)getSelectableOCROutputFontValues:(NSArray *)ocrOutputFontKeys;
- (NSArray *)getSelectableOCRAccuracyKeys;
- (NSArray *)getSelectableOCRAccuracyValues:(NSArray *)ocrAccuracyKeys;


#pragma mark - Get Selectable Array iPhone用
// ファイル形式
- (NSArray *)getSelectableFileFormatArray:(NSInteger)nColorMode;
// 高圧縮PDFのタイプ
- (NSArray *)getSelectableCompactPdfTypeArray:(NSInteger)nFileFormat;
// 圧縮率
- (NSArray *)getSelectableCompressionRatioArray:(NSInteger)nFileFormat andMultiCrop:(BOOL)bMultiCrop;
// 圧縮形式
- (NSArray *)getSelectableCompressionArray:(NSInteger)nColorMode;
- (NSString *)getSelectValue:(NSInteger)nColorMode
            selectFileFormat:(NSInteger)nFileFormat
        selectCompactPdfType:(NSInteger)nCompactPdfType
      selectCompressionRatio:(NSInteger)nCompressionRatio
            selectEncryption:(BOOL)bEncryption;
- (NSString *)getSelectValue:(NSInteger)nColorMode;

#pragma mark - Set Select Value
- (void)setSelectFileFormatValue:(NSUInteger)selectValue;
- (void)setSelectCompactPdfTypeValue:(int)selectValue;
- (void)setSelectCompressionRatioValue:(int)selectValue;
- (void)setSelectCompressionValue:(int)selectValue;

- (void)setSelectColorModeValue:(int)selectValue;
- (int)setPdfPasswordValue:(NSString *)value;

- (void)setSelectOCRLanguageValue:(NSString *)selectValue;
- (void)setSelectOCROutputFontValue:(NSString *)selectValue;
- (void)setSelectOCRAccuracyValue:(NSString *)selectValue;

- (void)setSavedKey:(BOOL)bMultiCropOn originalSizeLong:(BOOL)bOriginalSizeLong;

- (void)setSelectValue;

#pragma mark - Get Select Index
- (NSUInteger)getSelectFileFormatIndex;
- (NSUInteger)getOriginalFileFormatIndex;
- (int)getSelectCompactPdfTypeIndex;
- (int)getSelectCompressionRatioIndex;
- (int)getSelectCompressionIndex;
- (NSString *)getSelectOCRLanguageKey;
- (NSString *)getSelectOCROutputFontKey;
- (NSString *)getSelectOCRAccuracyKey;

#pragma mark - Get Select Index　iPhone用
- (NSUInteger)getSelectFileFormatIndex:(NSInteger)nColorMode selectFileFormat:(NSInteger)nFileFormat;
- (NSString *)getSelectFileFormatValue:(NSInteger)nColorMode selectFileFormat:(NSString *)strFileFormatValue;
- (NSUInteger)getFileFormatIndex:(NSString *)value;
- (NSUInteger)getCompactPdfTypeIndex:(NSString *)value;
- (NSUInteger)getCompressionRatioIndex:(NSString *)value fileFormatValue:(NSString *)fileFormatValue;
- (NSUInteger)getSelectFileFormatJpegIndex;
- (NSString *)getSelectFileFormatJpegValue;
- (NSString *)getSelectOCRLanguageValue:(NSString *)ocrLanguageKey;
- (NSString *)getSelectOCROutputFontValue:(NSString *)ocrOutputFontKey;
- (NSString *)getSelectOCRAccuracyValue:(NSString *)ocrAccuracyKey;

#pragma mark - Get Select Value
- (NSString *)getSelectFileFormatValue;
- (NSString *)getSelectCompressionRatioValue;
- (NSString *)getSelectCompressionValue;
- (NSString *)getSelectEncryptValue;
- (NSString *)getSelectOCRLanguageValue;
- (NSString *)getSelectOCROutputFontValue;
- (NSString *)getSelectOCRAccuracyValue;

#pragma mark - Get Select Value Name
- (NSString *)getSelectFileFormatValueName;
- (NSString *)getSelectCompactPdfTypeValueName;
- (NSString *)getSelectCompressionRatioValueName:(NSString *)fileFormatValue;
- (NSString *)getSelectCompressionValueName;

#pragma mark - Get Default Value
- (NSString *)getDefaultOCRLanguageKey;
- (NSString *)getDefaultOCROutputFontKey;
- (NSString *)getDefaultOCRAccuracyKey;

#pragma mark - 
- (NSString *)getDisplayFormatName:(RSSVColorModeData *)colorMode
                      originalSize:(RSSVOriginalSizeData *)originalSize;
- (NSString *)getDisplayFormatKey:(RSSVColorModeData *)colorMode
                     originalSize:(RSSVOriginalSizeData *)originalSize;

- (BOOL)isVisibleOCR:(NSString *)fileFormatKey;
- (BOOL)isCompactPdf:(NSString *)fileFormatKey;
- (BOOL)isPriorityBlack:(NSString *)fileFormatKey;
- (BOOL)isVisibleEncrypt;
- (BOOL)isVisibleEncrypt:(NSInteger)formatIndex compactPdfType:(NSInteger)compactPdfTypeIndex compressionRatio:(NSInteger)compressionRatioIndex;
- (void)clearOcrValue;

- (BOOL)updateFormatDataForMultiCropOn:(RSSEFileFormatData *)rsseFileFormatData;
- (void)updateFormatDataToLimitNone;
- (void)updateFormatDataForOriginalSizeLong:(RSSEFileFormatData *)rsseFileFormatData;

#pragma mark - Get Default Index
- (int)getCompRatioDefaultSelectValue;

@end

#pragma mark -
#pragma mark Bool And Range Class
@interface BoolAndRange : NSObject
{
    BOOL enable;
    int max, min;
}
@property(nonatomic) BOOL enable;
@property(nonatomic) int max;
@property(nonatomic) int min;
- (id)initWithEnable:(BOOL)bEnable min:(int)nMin max:(int)nMax;
@end
