
#import "TRSHttpCommunicationManager.h"

#import "RSSEListTypeData.h"
#import "RSSEIntegerTypeData.h"
//#import "RSSEColorModeData.h"
//#import "RSSEExposureLevelData.h"

//#import "RSSettableElementsData.h"
#import "TRSSettableElementsData.h"
//#import "RSSEColorModeData.h"
//#import "RSSECompressionData.h"
//#import "RSSEDuplexDirData.h"
//#import "RSSEDuplexModeData.h"
//#import "RSSEExposureLevelData.h"
//#import "RSSEExposureModeData.h"
//#import "RSSEFileFormatData.h"
//#import "RSSEManualSizeXData.h"
//#import "RSSEManualSizeYData.h"
//#import "RSSEOriginalSizeData.h"
//#import "RSSEPagesPerFileData.h"
//#import "RSSEResolutionData.h"
//#import "RSSERotationData.h"
//#import "RSSESendSizeData.h"
//#import "RSSESpecialModeData.h"

@interface TRSGetJobSettableElementsManager : TRSHttpCommunicationManager
{
    // カラーモード
    NSString* defaultColorMode;
    NSMutableArray* colorModeList;
    
    // 原稿
    NSString* defaultManuscript;
    NSMutableArray* manuscriptList;
    NSString* defaultSaveSize;
    NSMutableArray* saveSizeList;
    NSString* defaultRotation;
    NSMutableArray* rotationList;
    
    // 両面
    NSString* defaultBothOrOneSide;
    NSMutableArray* bothOrOneSideList;
    NSString* defaultBothOrOneSideMode;
    NSMutableArray* bothOrOneSideModeList;
    
    // フォーマット
    NSString* defaultFileFormat;
    NSMutableArray* fileFormatList;
    NSString* defaultCompressionPDFType;
    NSMutableArray* compressionPDFTypeList;
    NSString* defaultCompressionRatio;
    NSMutableArray* compressionRatioList;
    NSString* defaultMonoImageCompressionType;
    NSMutableArray* monoImageCompressionTypeList;
    int nDefPagesPerFileNum;
    int nMaxPagesPerFileNum;
    int nMinPagesPerFileNum;
    
    // 解像度
    NSString* defaultResolution;
    NSMutableArray* resolutionList;
    
    // その他の設定
    NSString* defaultColorDepth;
    NSMutableArray* colorDepthList;
    NSString* defaultColorDepthLevel;
    NSMutableArray* colorDepthLevelList;
    NSString* defaultBlankPageProcess;
    NSMutableArray* blankPageProcessList;
    
    int nNest;
    int nGetValueStage;
    NSString* strElement;
    NSString* strHasConstraintAttr;
    
    TRSSettableElementsData* rsSettableElementsData;
}

//@property (nonatomic, readonly) NSString* defaultColorMode;
//@property (nonatomic, readonly) NSArray* colorModeList;
//
//@property (nonatomic, readonly) NSString* defaultManuscript;
//@property (nonatomic, readonly) NSArray* manuscriptList;
//@property (nonatomic, readonly) NSString* defaultSaveSize;
//@property (nonatomic, readonly) NSArray* saveSizeList;
//@property (nonatomic, readonly) NSString* defaultRotation;
//@property (nonatomic, readonly) NSArray* rotationList;
//
//@property (nonatomic, readonly) NSString* defaultBothOrOneSide;
//@property (nonatomic, readonly) NSArray* bothOrOneSideList;
//@property (nonatomic, readonly) NSString* defaultBothOrOneSideMode;
//@property (nonatomic, readonly) NSArray* bothOrOneSideModeList;
//
//@property (nonatomic, readonly) NSString* defaultFileFormat;
//@property (nonatomic, readonly) NSArray* fileFormatList;
//@property (nonatomic, readonly) NSString* defaultCompressionPDFType;
//@property (nonatomic, readonly) NSArray* compressionPDFTypeList;
//@property (nonatomic, readonly) NSString* defaultCompressionRatio;
//@property (nonatomic, readonly) NSArray* compressionRatioList;
//@property (nonatomic, readonly) NSString* defaultMonoImageCompressionType;
//@property (nonatomic, readonly) NSArray* monoImageCompressionTypeList;
//@property (nonatomic, readonly) int nDefPagesPerFileNum;
//@property (nonatomic, readonly) int nMaxPagesPerFileNum;
//@property (nonatomic, readonly) int nMinPagesPerFileNum;
//
//@property (nonatomic, readonly) NSString* defaultResolution;
//@property (nonatomic, readonly) NSArray* resolutionList;
//
//@property (nonatomic, readonly) NSString* defaultColorDepth;
//@property (nonatomic, readonly) NSArray* colorDepthList;
//@property (nonatomic, readonly) NSString* defaultColorDepthLevel;
//@property (nonatomic, readonly) NSArray* colorDepthLevelList;
//@property (nonatomic, readonly) NSString* defaultBlankPageProcess;
//@property (nonatomic, readonly) NSArray* blankPageProcessList;

@property (nonatomic, readonly) TRSSettableElementsData* rsSettableElementsData;

//-(NSString*)replaceRSStr:(NSString*)str;
-(void)updateData;
-(void)updateDataCancel;

-(void)setRSSEListTypeData:(RSSEListTypeData*)data string:(NSString*)string;
-(void)setRSSEintegerTypeData:(RSSEIntegerTypeData*)data string:(NSString*)string;
-(void)setRSSEPdfPasswordData:(RSSEPdfPasswordData*)data string:(NSString*)string;

@end
