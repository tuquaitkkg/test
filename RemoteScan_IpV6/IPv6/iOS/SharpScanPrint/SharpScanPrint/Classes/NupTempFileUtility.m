
#import "NupTempFileUtility.h"
#import "ImageProcessing.h"
#import "CommonUtil.h"
#import "TIFFManager.h"
#import "PdfManager.h"

@implementation NupTempFileUtility

+ (NSString*)getNupTmpDir{
    // Library/PrivateDocuments の取得
    NSString *privateDocumentsPath = [GeneralFileUtility getPrivateDocuments];
    // Library/PrivateDocuments/NupTempFile の取得
    NSString *nupTmpDir = [privateDocumentsPath stringByAppendingPathComponent:@"NupTempFile"];

    return nupTmpDir;
}

+ (BOOL)initializeNupTmpDir {
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSString *nupTmpDir = [self getNupTmpDir];
    
    if ([fileManager fileExistsAtPath:nupTmpDir]) {
        [fileManager removeItemAtPath:nupTmpDir error:nil];
    }

    [fileManager createDirectoryAtPath:nupTmpDir
           withIntermediateDirectories:YES
                            attributes:nil
                                 error:NULL];
    
    return YES;
}

+ (NSNumber*)getFileSize:(NupTempFile*)pNupTempFile {
    if (![pNupTempFile existsPrintFile]) {
        return 0;
    }
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSDictionary *attribute = [fileManager attributesOfItemAtPath:pNupTempFile.printFilePath error:nil];
    return [attribute objectForKey:NSFileSize];
}

+ (NupTempFile*)createPrintFileTiff:(NSArray*)pTempFilePaths {
    NupTempFile *nupTempFile = [[NupTempFile alloc] initWithFilePaths:pTempFilePaths IsPdf:NO];
    
    ImageProcessing *ip = [[ImageProcessing alloc] init];

    int type = 7;
    NSMutableArray* inputDpi = [NSMutableArray array];
    NSMutableArray* inputWidth = [NSMutableArray array];
    NSMutableArray* inputHeight = [NSMutableArray array];
    NSMutableArray* inputImageLength = [NSMutableArray array];
    NSMutableArray* inputTempFilePaths = [NSMutableArray arrayWithArray:pTempFilePaths];
    for (int i = 0; i < [pTempFilePaths count]; i++) {
        NSString *tempFilePath = [pTempFilePaths objectAtIndex:i];
        UIImage *image = [UIImage imageWithContentsOfFile:tempFilePath];
        NSDictionary *fileDictionary = [[NSFileManager defaultManager] attributesOfItemAtPath:tempFilePath error:nil];
        NSInteger origFileSize = [fileDictionary fileSize];
        [inputDpi addObject:@"200"];
        [inputWidth addObject:[NSString stringWithFormat:@"%f",image.size.width]];
        [inputHeight addObject:[NSString stringWithFormat:@"%f",image.size.height]];
        [inputImageLength addObject:[NSString stringWithFormat:@"%zd",origFileSize]];
    }
    int nRet = [ip mergeTiffBinalyToMultiPageTiff :inputTempFilePaths
                                                  :type
                                                  :inputDpi
                                                  :inputWidth
                                                  :inputHeight
                                                  :inputImageLength
                                                  :nupTempFile.printFilePath];
    if (nRet < 0) {
        return nil;
    } else {
        return nupTempFile;
    }
}

+ (NupTempFile*)createPrintFilePdf:(NSArray*)pTempFilePaths Nup:(int)pNup NupOrder:(int)pNupOrder PaperSize:(int)pPaperSize {
    NupTempFile *nupTempFile = [[NupTempFile alloc] initWithFilePaths:pTempFilePaths IsPdf:YES];
    
    ImageProcessing *ip = [[ImageProcessing alloc] init];
    NSMutableArray* inputTempFilePaths = [NSMutableArray arrayWithArray:pTempFilePaths];
    NSString *outputfile = nupTempFile.printFilePath;
    
    int nRet = [ip mergeJpegToPdf:inputTempFilePaths
                   OutputFilePath:&outputfile
                              NUp:pNup
                         NUpOrder:pNupOrder
                      printBorder:NO
                        paperSize:pPaperSize];
    if (nRet < 0) {
        return nil;
    } else {
        return nupTempFile;
    }
}

+ (NupTempFile*)createPrintFileFromScanFile:(NSString*)pFilePath FileIndexs:(NSArray*)pFileIndexs Nup:(int)pNup NupOrder:(int)pNupOrder PaperSize:(int)pPaperSize IsError:(BOOL*)pIsError {
    if([CommonUtil tiffExtensionCheck:pFilePath]) {
        return [self createPrintFileFromScanFileTiff:pFilePath FileIndexs:pFileIndexs IsError:pIsError];
    } else if([CommonUtil pdfExtensionCheck:pFilePath] && ([CommonUtil IsPDFMakeFromSharp:pFilePath]||[CommonUtil IsCompactPDFFromSharp:pFilePath])) {
        return [self createPrintFileFromScanFilePdf:pFilePath FileIndexs:pFileIndexs Nup:pNup NupOrder:pNupOrder PaperSize:pPaperSize IsError:pIsError];
    } else {
        *pIsError = NO;
        return nil;
    }
}

+ (NupTempFile*)createPrintFileFromScanFileTiff:(NSString*)pFilePath FileIndexs:(NSArray*)pFileIndexs IsError:(BOOL*)pIsError {
    *pIsError = NO;
    NSMutableArray* arrDpi = [NSMutableArray array];
    NSMutableArray* arrWidth = [NSMutableArray array];
    NSMutableArray* arrHeight = [NSMutableArray array];
    NSMutableArray* arrImageLength = [NSMutableArray array];
    NSMutableArray* outputfiles = [NSMutableArray array];
    NSMutableArray* inputDpi = [NSMutableArray array];
    NSMutableArray* inputWidth = [NSMutableArray array];
    NSMutableArray* inputHeight = [NSMutableArray array];
    NSMutableArray* inputImageLength = [NSMutableArray array];
    NSMutableArray* inputfiles = [NSMutableArray array];
    NSMutableArray* fileExtentions = [NSMutableArray array];
    NSMutableArray* printRangeFileExtentions = [NSMutableArray array];
    // イメージファイルを抽出する
    TIFFManager* tiffManager = [[TIFFManager alloc] init];
    BOOL bRet = [tiffManager splitToRawImageByFilePath:pFilePath
                                    DestinationDirPath:[self getNupTmpDir]
                                                arrDpi:arrDpi
                                              arrWidth:arrWidth
                                             arrHeight:arrHeight
                                        arrImageLength:arrImageLength
                                        outputfilepath:outputfiles
                                         fileExtention:fileExtentions];
    if (bRet)
    {
        // 印刷範囲で指定されたPDFファイル内範囲指定された部分を抜き出す
        for (int i = 0; i < [pFileIndexs count]; i++) {
            [printRangeFileExtentions addObject:[fileExtentions objectAtIndex:[pFileIndexs[i] intValue]]];
        }

        // 指定された印刷範囲でファイルタイプが混在しているかどうか
        if([self isMixedTiff:printRangeFileExtentions]){
            // イメージファイルを抽出する
            bRet = [self replaceTiffToRawImage:pFilePath
                                    FileIndexs:pFileIndexs
                                  nupTempFiles:outputfiles
                                        arrDpi:arrDpi
                                      arrWidth:arrWidth
                                     arrHeight:arrHeight
                                arrImageLength:arrImageLength
                                 fileExtention:fileExtentions];
            if (!bRet) {
                return nil;
            }
        }
        
        for (int i = 0; i < [pFileIndexs count]; i++) {
            [inputDpi addObject:[arrDpi objectAtIndex:[pFileIndexs[i] intValue]]];
            [inputWidth addObject:[arrWidth objectAtIndex:[pFileIndexs[i] intValue]]];
            [inputHeight addObject:[arrHeight objectAtIndex:[pFileIndexs[i] intValue]]];
            [inputImageLength addObject:[arrImageLength objectAtIndex:[pFileIndexs[i] intValue]]];
            [inputfiles addObject:[outputfiles objectAtIndex:[pFileIndexs[i] intValue]]];
        }
        NupTempFile *nupTempFile = [[NupTempFile alloc] initWithFilePaths:[inputfiles copy] IsPdf:NO];
        int type = 0;

        // 指定された印刷範囲でファイルタイプが混在している場合は「type = 7」とする
        if([self isMixedTiff:printRangeFileExtentions]){
            type = 7;
            
        } else if ([printRangeFileExtentions containsObject:@".jpeg"]) {
            type = 7;
            
        } else if ([printRangeFileExtentions containsObject:@".g4"]) {
            type = 4;
            
        } else if ([printRangeFileExtentions containsObject:@".g3"]) {
            type = 3;
            
        } else if ([printRangeFileExtentions containsObject:@".nocomp"]) {
            type = 1;
            
        }
        
        ImageProcessing* ip = [[ImageProcessing alloc] init];
        int nRet = [ip mergeTiffBinalyToMultiPageTiff :inputfiles
                                                      :type
                                                      :inputDpi
                                                      :inputWidth
                                                      :inputHeight
                                                      :inputImageLength
                                                      :nupTempFile.printFilePath];
        if (0 <= nRet) {
            return nupTempFile;
        } else {
            *pIsError = YES;
        }
    }
    
    return nil;
}

+ (NupTempFile*)createPrintFileFromScanFilePdf:(NSString*)pFilePath FileIndexs:(NSArray*)pFileIndexs Nup:(int)pNup NupOrder:(int)pNupOrder PaperSize:(int)pPaperSize IsError:(BOOL*)pIsError {
    *pIsError = NO;
    NSMutableArray* arrWidth = [NSMutableArray array];
    NSMutableArray* arrHeight = [NSMutableArray array];
    NSMutableArray* outputfiles = [NSMutableArray array];
    NSMutableArray* inputWidth = [NSMutableArray array];
    NSMutableArray* inputHeight = [NSMutableArray array];
    NSMutableArray* inputfiles = [NSMutableArray array];
    NSMutableArray* fileExtentions = [NSMutableArray array];
    NSMutableArray* printRangeFileExtentions = [NSMutableArray array];
    NSString* fileExtention = nil;
    // イメージファイルを抽出する
    BOOL bRet = [PdfManager pdfToRawImage:pFilePath
                                  dirPath:[self getNupTmpDir]
                              isThumbnail:YES
                                    isWeb:NO
                                 arrWidth:arrWidth
                                arrHeight:arrHeight
                           outputfilepath:outputfiles
                            fileExtention:fileExtentions];
    if (bRet)
    {
        // 印刷範囲で指定されたPDFファイル内範囲指定された部分を抜き出す
        for (int i = 0; i < [pFileIndexs count]; i++) {
            [printRangeFileExtentions addObject:[fileExtentions objectAtIndex:[pFileIndexs[i] intValue]]];
        }
        
        // 指定された印刷範囲でファイルタイプが混在しているかどうか
        if([self isMixedPdf:printRangeFileExtentions]){
            // イメージファイルを置き換える
            bRet = [self replacePdfToRawImage:pFilePath
                                   FileIndexs:pFileIndexs
                                 nupTempFiles:outputfiles
                                fileExtention:fileExtentions];
            if (!bRet) {
                return nil;
            }
            for (int i = 0; i < [pFileIndexs count]; i++) {
                [inputfiles addObject:[outputfiles objectAtIndex:[pFileIndexs[i] intValue]]];
            }
            
        } else {
            for (int i = 0; i < [pFileIndexs count]; i++) {
                [inputWidth addObject:[arrWidth objectAtIndex:[pFileIndexs[i] intValue]]];
                [inputHeight addObject:[arrHeight objectAtIndex:[pFileIndexs[i] intValue]]];
                [inputfiles addObject:[outputfiles objectAtIndex:[pFileIndexs[i] intValue]]];
            }            
        }

        ImageProcessing* ip = [[ImageProcessing alloc] init];
        NupTempFile *nupTempFile = [[NupTempFile alloc] initWithFilePaths:[inputfiles copy] IsPdf:YES];
        NSString *outputfile = nupTempFile.printFilePath;
        int nRet = -1;
        
        // 指定された印刷範囲でファイルタイプが混在している場合は「jpeg」とする
        if([self isMixedPdf:printRangeFileExtentions]){
            fileExtention = @"jpeg";
            
        } else if ([printRangeFileExtentions containsObject:@"jpeg"]) {
            fileExtention = @"jpeg";
            
        } else {
            fileExtention = @"raw";
        }
        
        if([fileExtention isEqualToString:@"jpeg"])
        {
            nRet = [ip mergeJpegToPdf:inputfiles
                       OutputFilePath:&outputfile
                                  NUp:pNup
                             NUpOrder:pNupOrder
                          printBorder:NO
                            paperSize:pPaperSize];
        } else {
            nRet = [ip mergeNonCompToPdf:inputfiles
                          OutputFilePath:&outputfile
                                     NUp:pNup
                                NUpOrder:pNupOrder
                             printBorder:NO
                               paperSize:pPaperSize
                                   Width:inputWidth
                                  Height:inputHeight];
        }
        if (0 <= nRet) {
            return nupTempFile;
        } else {
            *pIsError = YES;
        }
    }
    
    return nil;
}

// PDFファイル内にファイルタイプが混在しているかどうか
+ (BOOL)isMixedPdf:(NSArray*)fileExtentions {
    int typeCnt = 0;
    if([fileExtentions containsObject:@"jpeg"]) typeCnt++;
    if([fileExtentions containsObject:@"raw"]) typeCnt++;

    // 複数タイプ存在する場合
    if(typeCnt > 1) {
        return YES;
    } else {
        return NO;
    }
}

// TIFFファイル内にファイルタイプが混在しているかどうか
+ (BOOL)isMixedTiff:(NSArray*)fileExtentions {
    int typeCnt = 0;
        
    if([fileExtentions containsObject:@".jpeg"]) typeCnt++;
    if([fileExtentions containsObject:@".g4"]) typeCnt++;
    if([fileExtentions containsObject:@".g3"]) typeCnt++;
    if([fileExtentions containsObject:@".nocomp"]) typeCnt++;
    if([fileExtentions containsObject:@".other"]) typeCnt++;

    // 複数タイプ存在する場合
    if(typeCnt > 1) {
        return YES;
    } else {
        return NO;
    }
}

// PDFファイル内にファイルタイプが混在している場合は、Nup印刷用ファイルをプレビューファイルに置き換える
+ (BOOL)replacePdfToRawImage:(NSString*)pFilePath
                  FileIndexs:(NSArray*)pFileIndexs
                nupTempFiles:(NSMutableArray*)nupTempFiles
               fileExtention:(NSMutableArray*)fileExtentions{

    NSFileManager *fileManager = [NSFileManager defaultManager];
    BOOL bRet = YES;

    // プレビューファイルを取得する
    NSArray *previewFilePaths = [GeneralFileUtility getPreviewFilePaths:pFilePath];
    if (previewFilePaths == nil) {
        // プレビューファイル未存在のためNGとする
        return NO;
    }

    for (int i = 0; i < [pFileIndexs count]; i++) {
        // 配列番号
        int n = [pFileIndexs[i] intValue];
        
        NSString *fileExtention = [fileExtentions objectAtIndex:n];

        // 拡張子が「raw」の場合、プレビューファイルと置き換える
        if ([fileExtention isEqualToString:@"raw"]) {
            // 置き換え対象の印刷用ファイルを取得する
            NSString *nupTempFile = [nupTempFiles objectAtIndex:n];
            NSString *nupTempFileName = [nupTempFile lastPathComponent];
            NSString *nupTempFilePath = [nupTempFile stringByDeletingLastPathComponent];
            
            // 置き換え対象のファイルを削除
            bRet = [fileManager removeItemAtPath:nupTempFile error:NULL];
            if (!bRet) {
                break;
            }

            // 対応するプレビューファイルを取り出す
            NSString *previewFile = [previewFilePaths objectAtIndex:n];
            // プレビューファイルの拡張子
            NSString *extention = [[previewFile lastPathComponent] pathExtension];

            // 置き換えるjpgファイルパスを作成
            NSString *dstFileName = [[nupTempFileName stringByDeletingPathExtension] stringByAppendingPathExtension:extention];
            NSString *dstFile = [nupTempFilePath stringByAppendingPathComponent:dstFileName];

            // プレビューファイルを印刷用ファイル名でコピーする
            bRet = [fileManager copyItemAtPath:previewFile toPath:dstFile error:nil];
            if (!bRet) {
                break;
            }
            
            // リストの要素を置き換える
            [nupTempFiles replaceObjectAtIndex:n withObject:dstFile];
            [fileExtentions replaceObjectAtIndex:n withObject:@"jpeg"];
        }
    }
    return bRet;
}

// TIFFファイル内にファイルタイプが混在している場合は、Nup印刷用ファイルとプレビューファイルをマージする
+ (BOOL)replaceTiffToRawImage:(NSString*)pFilePath
                   FileIndexs:(NSArray*)pFileIndexs
                 nupTempFiles:(NSMutableArray*)nupTempFiles
                       arrDpi:(NSMutableArray*)arrDpi
                     arrWidth:(NSMutableArray*)arrWidth
                    arrHeight:(NSMutableArray*)arrHeight
               arrImageLength:(NSMutableArray*)arrImageLength
                fileExtention:(NSMutableArray*)fileExtentions{
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    BOOL bRet = YES;
    
    // プレビューファイルを取得する
    NSArray *previewFilePaths = [GeneralFileUtility getPreviewFilePaths:pFilePath];
    if (previewFilePaths == nil) {
        // プレビューファイル未存在のためNGとする
        return NO;
    }

    for (int i = 0; i < [pFileIndexs count]; i++) {
        // 配列番号
        int n = [pFileIndexs[i] intValue];

        NSString *fileExtention = [fileExtentions objectAtIndex:n];
        
        // 拡張子が「.jpeg」以外の場合、プレビューファイルと置き換える
        if (![self isJpeg:fileExtention]) {
            // 置き換え対象の印刷用ファイルを取得する
            NSString *nupTempFile = [nupTempFiles objectAtIndex:n];
            NSString *nupTempFileName = [nupTempFile lastPathComponent];
            NSString *nupTempFilePath = [nupTempFile stringByDeletingLastPathComponent];
            
            // 置き換え対象のファイルを削除
            bRet = [fileManager removeItemAtPath:nupTempFile error:NULL];
            if (!bRet) {
                break;
            }
            
            // 対応するプレビューファイルを取り出す
            NSString *previewFile = [previewFilePaths objectAtIndex:n];
            // プレビューファイルの拡張子
            NSString *extention = [[previewFile lastPathComponent] pathExtension];
            
            // 置き換えるjpgファイルパスを作成
            NSString *dstFileName = [[nupTempFileName stringByDeletingPathExtension] stringByAppendingPathExtension:extention];
            NSString *dstFile = [nupTempFilePath stringByAppendingPathComponent:dstFileName];
            
            // プレビューファイルを印刷用ファイル名でコピーする
            bRet = [fileManager copyItemAtPath:previewFile toPath:dstFile error:nil];
            if (!bRet) {
                break;
            }
            
            // 置き換えたファイル情報を取得する
            UIImage *image = [UIImage imageWithContentsOfFile:dstFile];
            NSDictionary *fileDictionary = [[NSFileManager defaultManager] attributesOfItemAtPath:dstFile error:nil];
            NSInteger origFileSize = [fileDictionary fileSize];
            CGFloat width = image.size.width;
            CGFloat height = image.size.height;
            
            // リストの要素を置き換える
            [nupTempFiles replaceObjectAtIndex:n withObject:dstFile];
            [fileExtentions replaceObjectAtIndex:n withObject:@".jpeg"];
            
            [arrDpi replaceObjectAtIndex:n withObject:@"200"];
            [arrWidth replaceObjectAtIndex:n withObject:[NSString stringWithFormat:@"%f",width]];
            [arrHeight replaceObjectAtIndex:n withObject:[NSString stringWithFormat:@"%f",height]];
            [arrImageLength replaceObjectAtIndex:n withObject:[NSString stringWithFormat:@"%zd",origFileSize]];
        }
    }
    return bRet;
}

// ファイル拡張子が「.jpeg」かどうか
+ (BOOL)isJpeg:(NSString*)fileExtention {
    if ([fileExtention isEqualToString:@".jpeg"]) {
        return YES;
    }
    return NO;
}

@end
