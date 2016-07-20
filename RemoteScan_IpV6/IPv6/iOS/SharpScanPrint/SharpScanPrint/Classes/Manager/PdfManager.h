#import <Foundation/Foundation.h>
#import <ImageIO/ImageIO.h>
#import "CommonUtil.h"
#import "CommonManager.h"

// PDF内のstreamデータ保持
@interface StorinhPDFStream : NSObject
+ (CGPDFStreamRef)getStream;
+ (void)setStream:(CGPDFStreamRef)pStream;
@end

@interface PdfManager : NSObject

+ (BOOL)pdfToJpg:(NSString*)sScanFilePath dirPath:(NSString*)sDirPath isThumbnail:(BOOL)bThumbnail isWeb:(BOOL)bWeb;

+ (BOOL)pdfToRawImage:(NSString*)sScanFilePath dirPath:(NSString*)sDirPath isThumbnail:(BOOL)bThumbnail isWeb:(BOOL)bWeb arrWidth:(NSMutableArray*)arrWidth arrHeight:(NSMutableArray*)arrHeight outputfilepath:(NSMutableArray*) outputfiles fileExtention:(NSMutableArray*)fileExtentions;

@end
