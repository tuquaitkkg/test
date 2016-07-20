//
//  SharpDeskMobileUtility.m
//  SharpDeskMobileUtility
//
//  Created by ssl on 2013/07/17.
//  Copyright (c) 2013年 Sharp Corporation. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface SharpDeskMobileUtility : NSObject

-(int) mergeJpegToPdfImple:(NSMutableArray*) inputfilepath OutputFilePath:(NSString*) outputfilepath printForm:(int) printForm NUp:(int) nup order:(int) order printBorder:(bool) printBorder ;

-(int) mergeG4ToPdfImple:(NSMutableArray*) inputfilepath OutputFilePath:(NSString*) outputfilepath printForm:(int) printForm NUp:(int) nup order:(int) order printBorder:(bool) printBorder Width:(NSArray *)width Height:(NSArray *)height ;

-(int) mergeG3ToPdfImple:(NSMutableArray*) inputfilepath OutputFilePath:(NSString*) outputfilepath printForm:(int) printForm NUp:(int) nup order:(int) order printBorder:(bool) printBorder Width:(NSArray *)width Height:(NSArray *)height ;

-(int) mergeNonCompToPdfImple:(NSMutableArray*) inputfilepath OutputFilePath:(NSString*) outputfilepath printForm:(int) printForm NUp:(int) nup order:(int) order printBorder:(bool) printBorder Width:(NSArray *)width Height:(NSArray *)height ;

-(int) mergeTiffBinalyToMultiPageTiffImple : (NSMutableArray*) imageData : (int) type : (NSArray *) dpi : (NSArray *) width : (NSArray *) height : (NSArray *) imageLength : (NSString*) outputFilePath ;

-(int)convertPdfToTiff:(NSString*) inputfilepath : (NSMutableArray*) outputfilepath ;
//-(int)convertG4ImageIncludedInTiff:(NSString*) inputfilepath : (NSMutableArray*) outputfilepath ;

-(int) convertTiffG4BinalyToJpeg : (Byte*) imageData : (int) width : (int) height : (NSString*) outputfilepath ;

-(NSString *) writeJpeg : (NSString *) inputFilePath ;

// this method is coded in the convertG4toBMP.cpp. so, this definition should be removed. isn't it?
////-(int) cnvG4BMPFromData : (Byte*) imageData : (int) width : (int) height : (NSString*) outputfilepath ;

@end
