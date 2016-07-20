
#import "ImageProcessing.h"
#import "SharpDeskMobileUtility/SharpDeskMobileUtility.h"

@implementation ImageProcessing

-(int) convertPdfToJpeg:(NSString*) inputfilepath OutputFilePath:(NSMutableArray*) outputfilepath
{
    NSString* output = [[inputfilepath stringByDeletingPathExtension] stringByAppendingPathExtension:@"jpg"];
    
    [outputfilepath addObject:output];
    
    return 1;
}

-(int) convertTiffToJpeg:(NSString*) inputfilepath OutputFilePath:(NSMutableArray*) outputfilepath
{
    NSString* output = [[inputfilepath stringByDeletingPathExtension] stringByAppendingPathExtension:@"jpg"];
    
    [outputfilepath addObject:output];
    
    return 1;
}


-(int) mergeJpegToPdf:(NSMutableArray*) inputfilepath OutputFilePath:(NSString**) outputfilepath NUp:(int) nup NUpOrder:(int) nUpOrder printBorder:(BOOL) printBorder paperSize:(int) paperSize
{
    NSString* path= (NSString*)(*outputfilepath);
    
    SharpDeskMobileUtility *sharpDeskMobileUtility = [[SharpDeskMobileUtility alloc] init];
	int ret = [sharpDeskMobileUtility mergeJpegToPdfImple:inputfilepath OutputFilePath:path printForm:paperSize NUp:nup order:nUpOrder printBorder:printBorder];
	
    return ret;
}

-(int) mergeG4ToPdf:(NSMutableArray*) inputfilepath OutputFilePath:(NSString**) outputfilepath NUp:(int) nup NUpOrder:(int) nUpOrder printBorder:(BOOL) printBorder paperSize:(int) paperSize Width:(NSArray *)w Height:(NSArray *)h
{
    NSString* path= (NSString*)(*outputfilepath);
    
    SharpDeskMobileUtility *sharpDeskMobileUtility = [[SharpDeskMobileUtility alloc] init];
	int ret = [sharpDeskMobileUtility mergeG4ToPdfImple:inputfilepath OutputFilePath:path printForm:paperSize NUp:nup order:nUpOrder printBorder:printBorder Width:w Height:h];
	
    return ret;
}

-(int) mergeG3ToPdf:(NSMutableArray*) inputfilepath OutputFilePath:(NSString**) outputfilepath NUp:(int) nup NUpOrder:(int) nUpOrder printBorder:(BOOL) printBorder paperSize:(int) paperSize Width:(NSArray *)w Height:(NSArray *)h
{
    NSString* path= (NSString*)(*outputfilepath);
    
    SharpDeskMobileUtility *sharpDeskMobileUtility = [[SharpDeskMobileUtility alloc] init];
	int ret = [sharpDeskMobileUtility mergeG3ToPdfImple:inputfilepath OutputFilePath:path printForm:paperSize NUp:nup order:nUpOrder printBorder:printBorder Width:w Height:h];
	
    return ret;
}

-(int) mergeNonCompToPdf:(NSMutableArray*) inputfilepath OutputFilePath:(NSString**) outputfilepath NUp:(int) nup NUpOrder:(int) nUpOrder printBorder:(BOOL) printBorder paperSize:(int) paperSize Width:(NSArray *)w Height:(NSArray *)h
{
    NSString* path= (NSString*)(*outputfilepath);
    
    SharpDeskMobileUtility *sharpDeskMobileUtility = [[SharpDeskMobileUtility alloc] init];
	int ret = [sharpDeskMobileUtility mergeNonCompToPdfImple:inputfilepath OutputFilePath:path printForm:paperSize NUp:nup order:nUpOrder printBorder:printBorder Width:w Height:h];
	
    return ret;
}

-(int) mergeTiffBinalyToMultiPageTiff : (NSMutableArray*) imageData : (int) type : (NSArray *) dpi : (NSArray *) width : (NSArray *) height : (NSArray *) imageLength : (NSString*) outputFilePath
{
    SharpDeskMobileUtility *sharpDeskMobileUtility = [[SharpDeskMobileUtility alloc] init];
	int ret = [sharpDeskMobileUtility mergeTiffBinalyToMultiPageTiffImple: imageData : type : dpi : width : height : imageLength : outputFilePath ];
	
    return ret;
    
}


@end
