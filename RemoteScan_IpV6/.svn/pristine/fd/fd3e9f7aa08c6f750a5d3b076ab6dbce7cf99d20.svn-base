
#import <Foundation/Foundation.h>

@interface ImageProcessing : NSObject

enum NUP_ORDER_ENUM{
    NUP_ORDER_LEFT_TO_RIGHT = 0,
    NUP_ORDER_RIGHT_TO_LEFT,
    NUP_ORDER_UPPERLEFT_TO_RIGHT,
    NUP_ORDER_UPPERLEFT_TO_BOTTOM,
    NUP_ORDER_UPPERRIGHT_TO_LEFT,
    NUP_ORDER_UPPERRIGHT_TO_BOTTOM,
};

enum NUP_PEPERSIZE_ENUM{
    NUP_PAPERSIZE_A3WIDE,
    NUP_PAPERSIZE_A3,
    NUP_PAPERSIZE_A4,
    NUP_PAPERSIZE_A5,
    NUP_PAPERSIZE_B4,
    NUP_PAPERSIZE_B5,
    NUP_PAPERSIZE_LEDGER,
    NUP_PAPERSIZE_LETTER,
    NUP_PAPERSIZE_LEGAL,
    NUP_PAPERSIZE_EXECUTIVE,
    NUP_PAPERSIZE_INVOICE,
    NUP_PAPERSIZE_FOOLSCAP,
    NUP_PAPERSIZE_8k,
    NUP_PAPERSIZE_16k,
    NUP_PAPERSIZE_DL,
    NUP_PAPERSIZE_C5,
    NUP_PAPERSIZE_COM10,
    NUP_PAPERSIZE_MONARCH,
    NUP_PAPERSIZE_JPOST,
    NUP_PAPERSIZE_KAKUGATA2,
    NUP_PAPERSIZE_CHOKEI3,
    NUP_PAPERSIZE_YOKEI2,
    NUP_PAPERSIZE_YOKEI4,
};

-(int) convertPdfToJpeg:(NSString*) inputfilepath OutputFilePath:(NSMutableArray*) outputfilepath;

-(int) convertTiffToJpeg:(NSString*) inputfilepath OutputFilePath:(NSMutableArray*) outputfilepath;

-(int) mergeJpegToPdf:(NSMutableArray*) inputfilepath OutputFilePath:(NSString**) outputfilepath NUp:(int) nup NUpOrder:(int) nUpOrder printBorder:(BOOL) printBorder paperSize:(int) paperSize;

-(int) mergeG4ToPdf:(NSMutableArray*) inputfilepath OutputFilePath:(NSString**) outputfilepath NUp:(int) nup NUpOrder:(int) nUpOrder printBorder:(BOOL) printBorder paperSize:(int) paperSize Width:(NSArray *)w Height:(NSArray *)h;

-(int) mergeG3ToPdf:(NSMutableArray*) inputfilepath OutputFilePath:(NSString**) outputfilepath NUp:(int) nup NUpOrder:(int) nUpOrder printBorder:(BOOL) printBorder paperSize:(int) paperSize Width:(NSArray *)w Height:(NSArray *)h;

-(int) mergeNonCompToPdf:(NSMutableArray*) inputfilepath OutputFilePath:(NSString**) outputfilepath NUp:(int) nup NUpOrder:(int) nUpOrder printBorder:(BOOL) printBorder paperSize:(int) paperSize Width:(NSArray *)w Height:(NSArray *)h;

-(int) mergeTiffBinalyToMultiPageTiff : (NSMutableArray*) imageData : (int) type : (NSArray *) dpi : (NSArray *) width : (NSArray *) height : (NSArray *) imageLength : (NSString*) outputFilePath ;

@end
