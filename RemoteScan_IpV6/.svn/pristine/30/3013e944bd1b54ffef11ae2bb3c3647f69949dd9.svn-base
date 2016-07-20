
#import "TempFileUtility.h"
#import "CommonManager.h"
#import "CommonUtil.h"
#import "TIFFManager.h"
#import "GeneralFileUtility.h"

@implementation TempFileUtility

+ (BOOL)deleteFile:(TempFile*)pTempFile {
    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    if ([pTempFile existsTempFile]) {
        [fileManager removeItemAtPath:pTempFile.tempFilePath error:nil];
    }
    
    if ([pTempFile existsThumbnailFile]) {
        [fileManager removeItemAtPath:pTempFile.thumbnailFilePath error:nil];
    }
    NSString *thumbnailFileDir = [pTempFile.thumbnailFilePath stringByDeletingLastPathComponent];
    if ([fileManager fileExistsAtPath:thumbnailFileDir]) {
        if ([GeneralFileUtility isEmptyDirectory:thumbnailFileDir]) {
            [fileManager removeItemAtPath:thumbnailFileDir error:nil];
        }
    }
    
    if ([pTempFile existsPrintFile]) {
        [fileManager removeItemAtPath:pTempFile.printFilePath error:nil];
    }
    NSString *printFileDir = [pTempFile.printFilePath stringByDeletingLastPathComponent];
    if ([fileManager fileExistsAtPath:printFileDir]) {
        if ([GeneralFileUtility isEmptyDirectory:printFileDir]) {
            [fileManager removeItemAtPath:printFileDir error:nil];
        }
    }
    
    if ([pTempFile existsPreviewFile]) {
        NSArray *previewFilePaths = [pTempFile getPreviewFilePaths];
        for (NSUInteger i = 0; i < previewFilePaths.count; i++) {
            NSString *previewFilePath = [previewFilePaths objectAtIndex:i];
            [fileManager removeItemAtPath:previewFilePath error:nil];
        }
    }
    if ([fileManager fileExistsAtPath:pTempFile.cacheDirectoryPath]) {
        if ([GeneralFileUtility isEmptyDirectory:pTempFile.cacheDirectoryPath]) {
            [fileManager removeItemAtPath:pTempFile.cacheDirectoryPath error:nil];
        }
    }
    
    return YES;
}

+ (NSNumber*)getFileSize:(TempFile*)pTempFile {
    if (![pTempFile existsTempFile]) {
        return 0;
    }
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSDictionary *attribute = [fileManager attributesOfItemAtPath:pTempFile.tempFilePath error:nil];
    return [attribute objectForKey:NSFileSize];
}

+ (BOOL)createRequiredAllImageFiles:(TempFile*)pTempFile{
    if ([CommonUtil officeExtensionCheck:pTempFile.tempFilePath]) {
        // Officeファイルの場合はキャッシュを作らない
        return YES;
    }
    BOOL bRet = YES;
    if(![self createPreviewFiles:pTempFile]){
        bRet = NO;
    }
    if(![self createThumbnailFile:pTempFile]){
        bRet = NO;
    }
    if(![self createPrintFile:pTempFile]){
        bRet = NO;
    }
    return  bRet;
}

+ (BOOL)createCacheFile:(TempFile*)pTempFile{
    BOOL bRet = YES;
    if(![self createPreviewFiles:pTempFile]){
        bRet = NO;
    }
    if(![self createPrintFile:pTempFile]){
        bRet = NO;
    }
    return  bRet;
}

+ (BOOL)createCacheFileForWeb{
    TempFile *tempFile = [[TempFile alloc] initWithPrintDataPdf];
    return [self createCacheFile:tempFile];
}

+ (BOOL)createThumbnailFile:(TempFile*)pTempFile {
    if ([CommonUtil officeExtensionCheck:pTempFile.tempFilePath]) {
        // Officeファイルの場合はキャッシュを作らない
        return YES;
    }
    if ([pTempFile existsThumbnailFile]) {
        return YES;
    }
    if (![pTempFile existsTempFile]) {
        return NO;
    }

    UIImage *resultImage = nil;
    int width = 100;
    int height = 120;
    
    //
    // ファイルの画像を貼り付けるための白紙のコンテキストを作成
    //
    CGColorSpaceRef imageColorSpace = CGColorSpaceCreateDeviceRGB();
    
    CGContextRef localContext = CGBitmapContextCreate(NULL, width, height, 8, width * 4,
                                                      imageColorSpace,
                                                      kCGImageAlphaPremultipliedLast);
    
    int defaultWidth = width;
    int defaultHeight = height;
    CGFloat correctX = 0; // 描画X座標補正値
    CGFloat correctY = 0; // 描画Y座標補正値
    // PDFの場合
    if ([CommonUtil pdfExtensionCheck:pTempFile.tempFileName])
    {
        NSArray * previewArray = [pTempFile getPreviewFilePaths];
        if(previewArray){
            resultImage = [[UIImage alloc] initWithContentsOfFile:[previewArray objectAtIndex:0]];

            // イメージサイズ取得
            CGFloat imageSize = CGImageGetWidth(resultImage.CGImage) * CGImageGetHeight(resultImage.CGImage) * 32 / 8;
            // 空きメモリ容量取得
            struct vm_statistics a_vm_info;
            mach_msg_type_number_t a_count = HOST_VM_INFO_COUNT;
            host_statistics(mach_host_self(), HOST_VM_INFO,(host_info_t)&a_vm_info, &a_count);
            CGFloat activeMemory = a_vm_info.free_count * vm_page_size;
            
            DLog(@"activeMemory:%f",activeMemory);
            DLog(@"imageSize:%f",imageSize);
            
            // イメージサイズが空きメモリ容量より大きい場合
            if (imageSize > activeMemory * N_NUM_PDF_ACTIVEMEMORY_MAXSIZE)
            {
                CGColorSpaceRelease(imageColorSpace);
                CGContextRelease(localContext);
                
                return YES;
            }
            
            // 縦横の縮小倍率を比較して小さい方の倍率で縮小
            CGFloat magnificationW = width / resultImage.size.width;
            CGFloat magnificationH = height / resultImage.size.height;
            if(magnificationW < 1 || magnificationH < 1)
            {
                // 縮小倍率取得
                CGFloat magnification = magnificationW;
                if(magnificationH < magnificationW)
                {
                    magnification = magnificationH;
                }
                // 縮小後サイズ更新
                width = resultImage.size.width * magnification;
                height = resultImage.size.height * magnification;
                // 描画座標補正
                correctX = (defaultWidth - width) / 2;
                correctY = (defaultHeight - height) / 2;
            }
        }else{
            CommonManager* commanager = [[CommonManager alloc] init];
            NSInteger iCheckPDFSize = [commanager checkPdfSize:pTempFile.tempFilePath firstPage:&resultImage width:width height:height];
            if(iCheckPDFSize != CHK_PDF_VIEW_OK)
            {
                CGColorSpaceRelease(imageColorSpace);
                CGContextRelease(localContext);
                
                // 読み込み不可PDFの場合
                if(iCheckPDFSize == CHK_PDF_NO_VIEW_FILE)
                {
                    return NO;
                }
                
                return YES;
            }
        }
    }
    // JPEG/TIFFの場合
    else if([CommonUtil tiffExtensionCheck:pTempFile.tempFileName] || [CommonUtil jpegExtensionCheck:pTempFile.tempFileName] || [CommonUtil pngExtensionCheck:pTempFile.tempFileName] )
    {
        NSArray * previewArray = [pTempFile getPreviewFilePaths];
        if(previewArray){
            resultImage = [[UIImage alloc] initWithContentsOfFile:[previewArray objectAtIndex:0]];
        }else{
            resultImage = [[UIImage alloc] initWithContentsOfFile:pTempFile.tempFilePath];
        }
        // イメージサイズ取得
        CGFloat imageSize = CGImageGetWidth(resultImage.CGImage) * CGImageGetHeight(resultImage.CGImage) * 32 / 8;
        // 空きメモリ容量取得
        struct vm_statistics a_vm_info;
        mach_msg_type_number_t a_count = HOST_VM_INFO_COUNT;
        host_statistics(mach_host_self(), HOST_VM_INFO,(host_info_t)&a_vm_info, &a_count);
        CGFloat activeMemory = a_vm_info.free_count * vm_page_size;
        
        DLog(@"activeMemory:%f",activeMemory);
        DLog(@"imageSize:%f",imageSize);
        
        // イメージサイズが空きメモリ容量より大きい場合
        if (imageSize > activeMemory * N_NUM_PDF_ACTIVEMEMORY_MAXSIZE)
        {
            CGColorSpaceRelease(imageColorSpace);
            CGContextRelease(localContext);
            
            return YES;
        }
        
        // 縦横の縮小倍率を比較して小さい方の倍率で縮小
        CGFloat magnificationW = width / resultImage.size.width;
        CGFloat magnificationH = height / resultImage.size.height;
        if(magnificationW < 1 || magnificationH < 1)
        {
            // 縮小倍率取得
            CGFloat magnification = magnificationW;
            if(magnificationH < magnificationW)
            {
                magnification = magnificationH;
            }
            // 縮小後サイズ更新
            width = resultImage.size.width * magnification;
            height = resultImage.size.height * magnification;
            // 描画座標補正
            correctX = (defaultWidth - width) / 2;
            correctY = (defaultHeight - height) / 2;
        }
    }
    // 解放
    CGColorSpaceRelease(imageColorSpace);
    CGContextRelease(localContext);
    
    UIGraphicsBeginImageContext(CGSizeMake(defaultWidth + 20, defaultHeight + 20));
    CGContextSetShadow(UIGraphicsGetCurrentContext(), CGSizeMake(2.0f, 2.0f), 4.0f); // blur
    
    [resultImage drawInRect:CGRectMake((5 + correctX), (10 + correctY), width+10, height )];
    
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    
    NSString *thumbnailFileDir = [pTempFile.thumbnailFilePath stringByDeletingLastPathComponent];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    [fileManager createDirectoryAtPath:thumbnailFileDir
           withIntermediateDirectories:YES
                            attributes:nil
                                 error:NULL];
    
    NSData *data = [[NSData alloc] initWithData:UIImagePNGRepresentation( newImage )];
    return [data writeToFile:pTempFile.thumbnailFilePath atomically:YES];
}

+ (BOOL)createPrintFile:(TempFile*)pTempFile {
    if ([pTempFile existsPrintFile]) {
        return YES;
    }
    if (![CommonUtil pngExtensionCheck:pTempFile.tempFileName]) {
        return YES;
    }
    if (![pTempFile existsTempFile]) {
        return NO;
    }

    NSString *printFileDir = [pTempFile.printFilePath stringByDeletingLastPathComponent];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    [fileManager createDirectoryAtPath:printFileDir
           withIntermediateDirectories:YES
                            attributes:nil
                                 error:NULL];
    
    if([CommonUtil isExistsFreeMemoryJpegConvert:pTempFile.tempFilePath])
    {
        @autoreleasepool{
            @try {
                // 空きメモリあり
                NSURL* url = [[NSURL alloc] initFileURLWithPath:pTempFile.tempFilePath];
                CFDictionaryRef options = (__bridge CFDictionaryRef)[NSDictionary dictionaryWithObjectsAndKeys:
                                                                     (id)kCFBooleanTrue, (id)kCGImageSourceCreateThumbnailWithTransform,
                                                                     (id)kCFBooleanTrue, (id)kCGImageSourceCreateThumbnailFromImageIfAbsent,
                                                                     (id)kCFBooleanTrue, (id)kCGImageSourceCreateThumbnailFromImageAlways,
                                                                     (id)[NSNumber numberWithFloat:1024], (id)kCGImageSourceThumbnailMaxPixelSize,
                                                                     nil];
                CGImageSourceRef imageSource =CGImageSourceCreateWithURL((__bridge CFURLRef)url, options);
                CGImageRef imgRef= CGImageSourceCreateImageAtIndex(imageSource, 0, options);
                UIImage* image = [UIImage imageWithCGImage:imgRef];
                
                // JPEGへの変換
                NSData* data = [[NSData alloc] initWithData:UIImageJPEGRepresentation(image, 1)];
                [data writeToFile:pTempFile.printFilePath atomically:YES];
                
                data = nil;
                CFRelease(imgRef);
                image = nil;
                
                CFRelease(imageSource);
            }
            @catch (NSException *exception) {
                return NO;
            }
        }
    } else {
        return NO;
    }
    
    return YES;
}

+ (BOOL)createPreviewFiles:(TempFile*)pTempFile {
    if (![pTempFile existsTempFile]) {
        return NO;
    }
    if (!pTempFile.isWEB && [pTempFile existsPreviewFile]) {
        return YES;
    }
    BOOL bRet = YES;
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    [fileManager createDirectoryAtPath:pTempFile.cacheDirectoryPath
           withIntermediateDirectories:YES
                            attributes:nil
                                 error:NULL];
    
    if([CommonUtil pdfExtensionCheck:pTempFile.tempFilePath] && (pTempFile.isWEB||[CommonUtil IsPDFMakeFromSharp:pTempFile.tempFilePath]||[CommonUtil IsCompactPDFFromSharp:pTempFile.tempFilePath])) {
        bRet = [self createPreviewFilesFromPdf:pTempFile];
    }
    else if ([CommonUtil tiffExtensionCheck:pTempFile.tempFilePath]) {
        bRet = [self createPreviewFilesFromTiff:pTempFile];
    }
    else if ([CommonUtil jpegExtensionCheck:pTempFile.tempFilePath]) {
        bRet = [self createPreviewFilesFromJpeg:pTempFile];
    }
    else if ([CommonUtil pngExtensionCheck:pTempFile.tempFilePath]) {
        bRet = [self createPreviewFilesFromPng:pTempFile];
    }
    
    return bRet;
}

+ (BOOL)deletePreviewFiles:(TempFile*)pTempFile {
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSArray *arrayPaths = [pTempFile getPreviewFilePaths];
    if (arrayPaths != nil) {
        for (NSInteger i = 0; i < arrayPaths.count; i++) {
            NSString *filePath = [arrayPaths objectAtIndex:i];
            [fileManager removeItemAtPath:filePath error:nil];
        }
    }
    
    return YES;
}

+ (BOOL)deletePrintFileByFileName:(NSString*)pTempFileName{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    TempFile *tempFile = [[TempFile alloc] initWithFileName:pTempFileName];
    if ([tempFile existsPrintFile]) {
        [fileManager removeItemAtPath:tempFile.printFilePath error:nil];
    }
    return YES;
}

+ (BOOL)createPreviewFilesFromPdf:(TempFile*)pTempFile {
    @autoreleasepool{
        [PdfManager pdfToJpg:pTempFile.tempFilePath dirPath:pTempFile.cacheDirectoryPath isThumbnail:YES isWeb:pTempFile.isWEB];
    }
    return YES;
}

+ (BOOL)createPreviewFilesFromTiff:(TempFile*)pTempFile {
    @autoreleasepool{
        @try {
            TIFFManager* tiffManager = [[TIFFManager alloc] init];
            BOOL bRet = [tiffManager splitToJpegByFilePath:pTempFile.tempFilePath DestinationDirPath:pTempFile.cacheDirectoryPath];
            
            if(!bRet)
            {
                [self deletePreviewFiles:pTempFile];
                return NO;
            }
        }
        @catch (NSException *exception) {
            [self deletePreviewFiles:pTempFile];
            return NO;
        }
        @finally {
            // TODO
        }
    }
    return YES;
}

+ (BOOL)createPreviewFilesFromJpeg:(TempFile*)pTempFile {
    @autoreleasepool{
        // 出力した画像の縮小
        CGDataProviderRef dataProvider = CGDataProviderCreateWithFilename(strdup([pTempFile.tempFilePath UTF8String]));
        NSString* cacheFilePath = [pTempFile.cacheDirectoryPath stringByAppendingPathComponent:@"preview.jpg"];
        [CommonUtil OutputJpegByDataProvider:dataProvider outputFilePath:cacheFilePath maxPixelSize:1024];
        CGDataProviderRelease(dataProvider);
    }
    return YES;
}

+ (BOOL)createPreviewFilesFromPng:(TempFile*)pTempFile {
    @autoreleasepool{
        if([CommonUtil isExistsFreeMemoryJpegConvert:pTempFile.tempFilePath])
        {
            @try {
                // 空きメモリあり
                NSURL* url = [[NSURL alloc] initFileURLWithPath:pTempFile.tempFilePath];
                CFDictionaryRef options = (__bridge CFDictionaryRef)[NSDictionary dictionaryWithObjectsAndKeys:
                                                                     (id)kCFBooleanTrue, (id)kCGImageSourceCreateThumbnailWithTransform,
                                                                     (id)kCFBooleanTrue, (id)kCGImageSourceCreateThumbnailFromImageIfAbsent,
                                                                     (id)kCFBooleanTrue, (id)kCGImageSourceCreateThumbnailFromImageAlways,
                                                                     (id)[NSNumber numberWithFloat:1024], (id)kCGImageSourceThumbnailMaxPixelSize,
                                                                     nil];
                CGImageSourceRef imageSource =CGImageSourceCreateWithURL((__bridge CFURLRef)url, options);
                CGImageRef imgRef= CGImageSourceCreateImageAtIndex(imageSource, 0, options);
                UIImage* image = [UIImage imageWithCGImage:imgRef];
                
                // プレビュー用JPEGの生成
                NSString* previewFilePath = [pTempFile.cacheDirectoryPath stringByAppendingPathComponent:@"preview.jpg"];
                
                NSData* data = [[NSData alloc] initWithData:UIImageJPEGRepresentation(image, 0.8)];
                [data writeToFile:previewFilePath atomically:YES];
                
                data = nil;
                CFRelease(imgRef);
                image = nil;
                
                CFRelease(imageSource);
            }
            @catch (NSException *exception) {
                // TODO:
            }
            @finally {
                // TODO:
            }
        } else {
            return NO;
        }
    }
    return YES;
}
@end
