
#import <Foundation/Foundation.h>
#import "TiffIfd.h"
#import "TiffTag.h"

@interface TIFFManager : NSObject {
    float m_bThumbnail;
}

-(BOOL) readHeader;
-(int) splitToJpeg:(NSMutableArray*) outputFiles;
-(BOOL) writeJpeg:(NSString*)strJpeg :(TiffIfd*)tiffIFD :(int)nPageNumbser;
-(BOOL) checkIFD:(TiffIfd*)srcIFD;
-(int) readIFD:(int)offset :(TiffIfd*)ifd;
-(BOOL) readTag:(long)offset :(TiffTag*) srcTag :(int*)nIfdByteCounts;
-(BOOL) readTIFF;
-(BOOL) readHeader;
-(int) getNumberOfPages;
-(int) readShortValue:(int) nextOffset;
-(int) readIntValue:(int) nextOffset;
-(short) shortValue:(NSData*) byteArray;
-(int) intValue:(NSData*) byteArray;

- (BOOL)splitToJpegByFilePath:(NSString*)strScanFilePath DestinationDirPath:(NSString*) strDestinationDir;
- (BOOL)splitToJpegByFilePath:(NSString*)strScanFilePath DestinationDirPath:(NSString*) strDestinationDir isThumbnail:(BOOL)bThumbnail;
-(BOOL)isCompressionJpg:(NSString*)strScanFilePath;

- (BOOL)splitToRawImageByFilePath:(NSString*)strScanFilePath DestinationDirPath:(NSString*) strDestinationDir arrDpi:(NSMutableArray*)arrDpi arrWidth:(NSMutableArray*)arrWidth arrHeight:(NSMutableArray*)arrHeight arrImageLength:(NSMutableArray*)arrImageLength outputfilepath:(NSMutableArray*) outputfiles fileExtention:(NSMutableArray*)fileExtentions;
- (BOOL)splitToRawImageByFilePath:(NSString*)strScanFilePath DestinationDirPath:(NSString*) strDestinationDir arrDpi:(NSMutableArray*)arrDpi arrWidth:(NSMutableArray*)arrWidth arrHeight:(NSMutableArray*)arrHeight arrImageLength:(NSMutableArray*)arrImageLength outputfilepath:(NSMutableArray*) outputfiles fileExtention:(NSMutableArray*)fileExtentions isThumbnail:(BOOL)bThumbnail;

@end
