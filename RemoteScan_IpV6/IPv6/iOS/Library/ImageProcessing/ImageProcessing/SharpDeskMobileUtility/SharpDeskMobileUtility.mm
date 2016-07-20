//
//  SharpDeskMobileUtility.m
//  SharpDeskMobileUtility
//
//  Created by ssl on 2013/07/17.
//  Copyright (c) 2013年 Sharp Corporation. All rights reserved.
//

#import "SharpDeskMobileUtility.h"
#import "PDFCreator.h"
#import "convertG4toBMP.h"
#import "mergeTiffBinalyToMultiPageTiff.h"

@implementation SharpDeskMobileUtility

-(int) mergeJpegToPdfImple:(NSMutableArray*) inputfilepath OutputFilePath:(NSString*) outputfilepath printForm:(int) printForm NUp:(int) nup order:(int) order printBorder:(bool) printBorder
{
    if (inputfilepath == NULL) {
        return -1;
    }
    int count = [inputfilepath count];
    if (count == 0) {
        return -1;
    }

    char** path = new char*[count]();
    for(int i= 0; i< count; i++) {
        path[i] = (char*)[[inputfilepath objectAtIndex:i] UTF8String];
    }
    
    char* outPath = (char*)[outputfilepath UTF8String];
    PDFCreator *pdfCreator = new PDFCreator();
    int ret = pdfCreator->mergeJpegToPdf(path, count, outPath, printForm, nup, order, printBorder);
    pdfCreator->clear();
    delete pdfCreator;
    delete path;
    return ret;
}

-(int) mergeG4ToPdfImple:(NSMutableArray*) inputfilepath OutputFilePath:(NSString*) outputfilepath printForm:(int) printForm NUp:(int) nup order:(int) order printBorder:(bool) printBorder Width:(NSArray *) width Height:(NSArray *) height
{
    if (inputfilepath == NULL) {
        return -1;
    }
    int count = [inputfilepath count];
    if (count == 0) {
        return -1;
    }
    int widthCount = [width count];
    if (widthCount == 0 || count != widthCount){
        return -1;
    }
    
    int heightCount = [height count];
    if (widthCount == 0 || count != widthCount){
        return -1;
    }

    int w[widthCount];
    int h[heightCount];
    
    char** path = new char*[count]();
    for(int i= 0; i< count; i++) {
        path[i] = (char*)[[inputfilepath objectAtIndex:i] UTF8String];
        w[i]= [[width objectAtIndex:i] intValue];
        h[i]= [[height objectAtIndex:i] intValue];
    }
    
    char* outPath = (char*)[outputfilepath UTF8String];
    PDFCreator *pdfCreator = new PDFCreator();
    int ret = pdfCreator->mergeToPdf(path, count, w, h, ELMTYPE_G4, outPath, printForm, nup, order, printBorder);
    pdfCreator->clear();
    delete pdfCreator;
    delete path;
    return ret;
}

-(int) mergeG3ToPdfImple:(NSMutableArray*) inputfilepath OutputFilePath:(NSString*) outputfilepath printForm:(int) printForm NUp:(int) nup order:(int) order printBorder:(bool) printBorder Width:(NSArray *) width Height:(NSArray *) height
{
    if (inputfilepath == NULL) {
        return -1;
    }
    int count = [inputfilepath count];
    if (count == 0) {
        return -1;
    }
    int widthCount = [width count];
    if (widthCount == 0 || count != widthCount){
        return -1;
    }
    
    int heightCount = [height count];
    if (widthCount == 0 || count != widthCount){
        return -1;
    }
    
    int w[widthCount];
    int h[heightCount];
    
    char** path = new char*[count]();
    for(int i= 0; i< count; i++) {
        path[i] = (char*)[[inputfilepath objectAtIndex:i] UTF8String];
        w[i]= [[width objectAtIndex:i] intValue];
        h[i]= [[height objectAtIndex:i] intValue];
    }
    
    char* outPath = (char*)[outputfilepath UTF8String];
    PDFCreator *pdfCreator = new PDFCreator();
    int ret = pdfCreator->mergeToPdf(path, count, w, h, ELMTYPE_G3, outPath, printForm, nup, order, printBorder);
    pdfCreator->clear();
    delete pdfCreator;
    delete path;
    return ret;
}

-(int) mergeNonCompToPdfImple:(NSMutableArray*) inputfilepath OutputFilePath:(NSString*) outputfilepath printForm:(int) printForm NUp:(int) nup order:(int) order printBorder:(bool) printBorder Width:(NSArray *) width Height:(NSArray *) height
{
    if (inputfilepath == NULL) {
        return -1;
    }
    int count = [inputfilepath count];
    if (count == 0) {
        return -1;
    }
    int widthCount = [width count];
    if (widthCount == 0 || count != widthCount){
        return -1;
    }
    
    int heightCount = [height count];
    if (widthCount == 0 || count != widthCount){
        return -1;
    }
    
    int w[widthCount];
    int h[heightCount];
    
    char** path = new char*[count]();
    for(int i= 0; i< count; i++) {
        path[i] = (char*)[[inputfilepath objectAtIndex:i] UTF8String];
        w[i]= [[width objectAtIndex:i] intValue];
        h[i]= [[height objectAtIndex:i] intValue];
    }
    
    char* outPath = (char*)[outputfilepath UTF8String];
    PDFCreator *pdfCreator = new PDFCreator();
    int ret = pdfCreator->mergeToPdf(path, count, w, h, ELMTYPE_NONECOMP, outPath, printForm, nup, order, printBorder);
    pdfCreator->clear();
    delete pdfCreator;
    delete path;
    return ret;
}

-(int) mergeTiffBinalyToMultiPageTiffImple : (NSMutableArray*) imageData : (int) type : (NSArray *) dpi : (NSArray *) width : (NSArray *) height : (NSArray *) imageLength : (NSString*) outputFilePath {

	// パラメータチェック
	if (imageData == NULL) {
		return -1;
	}

	// イメージデータ数取得
	int imageDataCount = [imageData count];
	if (imageDataCount == 0) {
		return -1;
	}

	// 解像度数取得
	int dpiCount = [dpi count];
	if (dpiCount == 0 || imageDataCount != dpiCount) {
		return -1;
	}

	// 幅数取得
	int widthCount = [width count];
	if (widthCount == 0 || imageDataCount != widthCount) {
		return -1;
	}

	// 高さ数取得
	int heightCount = [height count];
	if (heightCount == 0 || imageDataCount != heightCount) {
		return -1;
	}

	// イメージ長数取得
	int imageLengthCount = [imageLength count];
	if (imageLengthCount == 0 || imageDataCount != imageLengthCount) {
		return -1;
	}

	// パラメータ値格納用
	char** pathImageData = new char*[imageDataCount]();
	int    itype;
	int    id[dpiCount];
	int    iw[widthCount];
	int    ih[heightCount];
	int    ii[imageLengthCount];

	// パラメータ値取得
	itype = type;
	for (int i=0; i<imageDataCount; i++) {
		pathImageData[i] = (char*)[[imageData objectAtIndex:i] UTF8String];
		id[i]            = [[dpi         objectAtIndex:i] intValue];
		iw[i]            = [[width       objectAtIndex:i] intValue];
		ih[i]            = [[height      objectAtIndex:i] intValue];
		ii[i]            = [[imageLength objectAtIndex:i] intValue];
	}
    char* outPath = (char*)[outputFilePath UTF8String];

	// ライブラリ処理呼び出し
	int ret = mrgTIFFDataTIFFFile( (char **)pathImageData
								 , type
								 , id
								 , iw
								 , ih
								 , ii
								 , imageDataCount
								 , (char *)outPath );

	// 解放処理
    delete pathImageData;

    return ret;
}

/**
 * TIFFに含まれているG4をJPEGに変換する
 *
 * @param inputfilepath
 *            抽出対象TIFF
 * @param outputfilepath
 *            抽出したJEPGファイル
 * @return 実行結果(0 以上: ページ数 / 0 未満: エラーコード)<br />
 *         -1: ファイルが壊れている<br />
 *         -2: メモリ不足<br />
 *         -3: フォルダに十分な空き容量がない<br />
 *         -4: "inputfilepath" が見つからない<br />
 *         -5: 対応ファイルだがサポートされないファイル形式<br />
 *         -6: 取り込み不可ファイル(読み取り / 書き込み権限不足 or 対応外ファイル形式)<br />
 *         -9000: 未実装<br />
 *         -9999: 予期せぬエラー<br />
 */
-(int)convertPdfToTiff:(NSString*) inputfilepath : (NSMutableArray*) outputfilepath {
//-(int)convertG4ImageIncludedInTiff:(NSString*) inputfilepath : (NSMutableArray*) outputfilepath {

    // ImageProcessing Convert TiffG4 to Jpeg
    const char *     strInputFilePath;
	char *           strOutputFilePathAll;
    int              intPageCount = 0;

    // 入力ファイル存在チェック
    NSFileManager * fileManager = [NSFileManager defaultManager];
    if ( ![fileManager fileExistsAtPath:inputfilepath] ){
        return -4;
    }

	// 入力ファイル名取得
	strInputFilePath = ( char * )[inputfilepath UTF8String];

	// サイズ分の領域を確保
	strOutputFilePathAll = new char[ TIFF_PAGE_MAX * 256 + 1 ];
	if( strOutputFilePathAll == NULL ){
		return -2;
	}

	intPageCount = cnvG4BMP( strInputFilePath , strOutputFilePathAll );
	if( intPageCount < 0 ){
		// メモリ解放
		free( strOutputFilePathAll );

        // エラーコードを返す
        // -1 or -2 or -5 or -6 が返る
		return intPageCount;
	}

	// JPEGファイル出力
    for( int i = 0 ; i < intPageCount ; i++ ){
        // Bitmapファイル名を取得
        NSString* tempString = [NSString stringWithCString:&strOutputFilePathAll[ 256 * i ] encoding:NSUTF8StringEncoding];

        // JPEGファイル出力
        NSString * jpgFileName = [self writeJpeg:tempString];
        if( jpgFileName != nil ){
            // アウトパラメータにJPEGファイル名をセット
            [outputfilepath addObject:jpgFileName];
        }
        else{
            return -3;
        }

        // Bitmapファイル削除
        NSError *       error;
        NSFileManager * fileManager = [NSFileManager defaultManager];
        if( ![fileManager removeItemAtPath:tempString error:&error] ){
            // メモリ解放
            free( strOutputFilePathAll );

            return -9999;
        }
    }

	// メモリ解放
	free( strOutputFilePathAll );

    return intPageCount;
}

/**
 * TIFFG4のバイナリデータをJPEGファイルに出力
 *
 * @param imageData
 *            TIFFG4のバイナリデータ
 * @param width
 *            TIFFG4のバイナリデータの元画像の幅
 * @param height
 *            TIFFG4のバイナリデータの元画像の高さ
 * @param outputfilepath
 *            出力するJPEGファイルのフルパス
 * @return 実行結果(1 正常終了: / 0 未満: エラーコード)<br />
 *         -1: ファイルが壊れている<br />
 *         -2: メモリ不足<br />
 *         -3: フォルダに十分な空き容量がない<br />
 *         -4: "outputfilepath" が不適切<br />
 *         -5: TIFFだがG4でない<br />
 *         -6: 取り込み不可ファイル(読み取り / 書き込み権限不足 or 対応外ファイル形式)<br />
 *         -9000: 未実装<br />
 *         -9999: 予期せぬエラー<br />
 */
-(int) convertTiffG4BinalyToJpeg : (Byte*) imageData : (int) width : (int) height : (NSString*) outputfilepath {

	BYTE *       bInputImageData;
	const char * strOutputFilePath;
	int          intRet = 0;

	// イメージデータ取得
    bInputImageData = imageData;

    // TIFFG4のバイナリデータから作成するビッtマップファイルのパスを作成
    NSString * ext = [outputfilepath pathExtension];
    if( ![ext isEqualToString:@"jpg"] && ![ext isEqualToString:@"jpeg"] ){
        return -4;
    }
    NSArray  * array             = [outputfilepath componentsSeparatedByString:ext];
    NSString * bmpFileNameParent = [array objectAtIndex:0];
    NSString * bmpFileName       = [bmpFileNameParent stringByAppendingString:@"bmp"];

	// 出力ファイル名取得
    strOutputFilePath = ( char * )[bmpFileName UTF8String];

	// BMP出力
	intRet = cnvG4BMPFromData( bInputImageData , width , height , strOutputFilePath );
	if( intRet < 0 ){
        // エラー処理
        // -1 or -2 or -6 が返る
        // ※正常終了時は1が返る
		return intRet;
	}

    // JPEGファイル出力
    NSString * jpgFileName = [self writeJpeg:bmpFileName];
    if( jpgFileName == nil ){
        return -3;
    }

    // Bitmapファイル削除
    NSError *       error;
    NSFileManager * fileManager = [NSFileManager defaultManager];
    if( ![fileManager removeItemAtPath:bmpFileName error:&error] ){
        return -9999;
    }

	return 1;
}

-(NSString *) writeJpeg : (NSString *) inputFilePath {

    // BitmapデータをJPEGデータに変換
    NSData  * dataBMP = [NSData dataWithContentsOfFile:inputFilePath];
    UIImage * image   = [UIImage imageWithData:dataBMP];
    NSData  * jpgData = UIImageJPEGRepresentation( image , 1.0f );

    // JPEGファイル名作成
    NSArray  * arrayPath         = [inputFilePath componentsSeparatedByString:@".bmp"];
    NSString * jpgFileNameParent = [arrayPath objectAtIndex:0];
    NSString * jpgFileName       = [jpgFileNameParent stringByAppendingPathExtension:@"jpg"];

    // JPEGファイル出力
    if( ![jpgData writeToFile:jpgFileName atomically:YES] ){
        return nil;
    }

    return jpgFileName;
}

@end
