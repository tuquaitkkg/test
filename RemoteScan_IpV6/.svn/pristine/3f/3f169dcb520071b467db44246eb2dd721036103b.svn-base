
#import "TempAttachmentFileUtility.h"
#import "TempAttachmentFile.h"
#import "CommonManager.h"
#import "CommonUtil.h"
#import "TIFFManager.h"
#import "GeneralFileUtility.h"

@implementation TempAttachmentFileUtility

+ (BOOL)deleteMailTmpDir {
    NSFileManager *fileManager = [NSFileManager defaultManager];
    // Library/PrivateDocuments の取得
    NSString *privateDocumentsPath = [GeneralFileUtility getPrivateDocuments];
    // Library/PrivateDocuments/TempAttachmentFile の取得
    NSString *rootDir = [privateDocumentsPath stringByAppendingPathComponent:@"TempAttachmentFile"];

    if ([fileManager fileExistsAtPath:rootDir]) {
        [fileManager removeItemAtPath:rootDir error:nil];
    }
    return YES;
}

+ (BOOL)deleteFile:(TempAttachmentFile*)pTempAttachmentFile{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    if ([pTempAttachmentFile existsAttachmentFile]) {
        [fileManager removeItemAtPath:pTempAttachmentFile.attachmentFilePath error:nil];
    }
    
    if ([pTempAttachmentFile existsThumbnailFile]) {
        [fileManager removeItemAtPath:pTempAttachmentFile.thumbnailFilePath error:nil];
    }
    NSString *thumbnailFileDir = [pTempAttachmentFile.thumbnailFilePath stringByDeletingLastPathComponent];
    if ([fileManager fileExistsAtPath:thumbnailFileDir]) {
        if ([GeneralFileUtility isEmptyDirectory:thumbnailFileDir]) {
            [fileManager removeItemAtPath:thumbnailFileDir error:nil];
        }
    }
    
    if ([pTempAttachmentFile existsPrintFile]) {
        [fileManager removeItemAtPath:pTempAttachmentFile.printFilePath error:nil];
    }
    NSString *printFileDir = [pTempAttachmentFile.printFilePath stringByDeletingLastPathComponent];
    if ([fileManager fileExistsAtPath:printFileDir]) {
        if ([GeneralFileUtility isEmptyDirectory:printFileDir]) {
            [fileManager removeItemAtPath:printFileDir error:nil];
        }
    }
    
    if ([pTempAttachmentFile existsPreviewFile]) {
        NSArray *previewFilePaths = [pTempAttachmentFile getPreviewFilePaths];
        for (NSUInteger i = 0; i < previewFilePaths.count; i++) {
            NSString *previewFilePath = [previewFilePaths objectAtIndex:i];
            [fileManager removeItemAtPath:previewFilePath error:nil];
        }
    }
    if ([fileManager fileExistsAtPath:pTempAttachmentFile.cacheDirectoryPath]) {
        if ([GeneralFileUtility isEmptyDirectory:pTempAttachmentFile.cacheDirectoryPath]) {
            [fileManager removeItemAtPath:pTempAttachmentFile.cacheDirectoryPath error:nil];
        }
    }
    
    return YES;
}

+ (BOOL)createRequiredDirectories{
    
    // Library/PrivateDocuments の取得
    NSString *privateDocumentsPath = [GeneralFileUtility getPrivateDocuments];

    //添付ファイル用一時保存ファイルのディレクトリ取得
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSString *tmpDir = [privateDocumentsPath stringByAppendingPathComponent:@"TempAttachmentFile"];
    
    // 保存ファイルのディレクトリが存在しない場合は作成する。
    [fileManager createDirectoryAtPath:tmpDir
           withIntermediateDirectories:YES
                            attributes:nil
                                 error:NULL];
    return YES;
}

+ (BOOL)createRequiredAllImageFiles:(TempAttachmentFile*)pTempAttachmentFile{
    if ([CommonUtil officeExtensionCheck:pTempAttachmentFile.attachmentFilePath]) {
        // Officeファイルの場合はキャッシュを作らない
        return YES;
    }
    BOOL bRet = YES;
    if(![self createPreviewFiles:pTempAttachmentFile]){
        bRet = NO;
    }
    if(![self createThumbnailFile:pTempAttachmentFile]){
        bRet = NO;
    }
    if(![self createPrintFile:pTempAttachmentFile]){
        bRet = NO;
    }
    return  bRet;
}

+ (BOOL)createCacheFile:(TempAttachmentFile*)pTempAttachmentFile{
    BOOL bRet = YES;
    if(![self createPreviewFiles:pTempAttachmentFile]){
        bRet = NO;
    }
    if(![self createPrintFile:pTempAttachmentFile]){
        bRet = NO;
    }
    return  bRet;
}

+ (BOOL)createThumbnailFile:(TempAttachmentFile*)pTempAttachmentFile {
    if ([CommonUtil officeExtensionCheck:pTempAttachmentFile.attachmentFilePath]) {
        // Officeファイルの場合はキャッシュを作らない
        return YES;
    }
    if ([pTempAttachmentFile existsThumbnailFile]) {
        return YES;
    }
    if (![pTempAttachmentFile existsAttachmentFile]) {
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
    
    NSString *attachmentFileName = [pTempAttachmentFile.attachmentFilePath lastPathComponent];
    
    // PDFの場合
    if ([CommonUtil pdfExtensionCheck:attachmentFileName])
    {
        NSArray * previewArray = [pTempAttachmentFile getPreviewFilePaths];
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
            NSInteger iCheckPDFSize = [commanager checkPdfSize:pTempAttachmentFile.attachmentFilePath firstPage:&resultImage width:width height:height];
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
    else if([CommonUtil tiffExtensionCheck:attachmentFileName] || [CommonUtil jpegExtensionCheck:attachmentFileName] || [CommonUtil pngExtensionCheck:attachmentFileName] )
    {
        NSArray * previewArray = [pTempAttachmentFile getPreviewFilePaths];
        if(previewArray){
            resultImage = [[UIImage alloc] initWithContentsOfFile:[previewArray objectAtIndex:0]];
        }else{
            resultImage = [[UIImage alloc] initWithContentsOfFile:pTempAttachmentFile.attachmentFilePath];
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
    
    NSString *thumbnailFileDir = [pTempAttachmentFile.thumbnailFilePath stringByDeletingLastPathComponent];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    [fileManager createDirectoryAtPath:thumbnailFileDir
           withIntermediateDirectories:YES
                            attributes:nil
                                 error:NULL];
    
    NSData *data = [[NSData alloc] initWithData:UIImagePNGRepresentation( newImage )];
    return [data writeToFile:pTempAttachmentFile.thumbnailFilePath atomically:YES];
}

+ (BOOL)createPrintFile:(TempAttachmentFile*)pTempAttachmentFile {
    if ([pTempAttachmentFile existsPrintFile]) {
        return YES;
    }
    if (![CommonUtil pngExtensionCheck:[pTempAttachmentFile.attachmentFilePath lastPathComponent]]) {
        return YES;
    }
    if (![pTempAttachmentFile existsAttachmentFile]) {
        return NO;
    }
    
    NSString *printFileDir = [pTempAttachmentFile.printFilePath stringByDeletingLastPathComponent];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    [fileManager createDirectoryAtPath:printFileDir
           withIntermediateDirectories:YES
                            attributes:nil
                                 error:NULL];
    
    if([CommonUtil isExistsFreeMemoryJpegConvert:pTempAttachmentFile.attachmentFilePath])
    {
        @autoreleasepool{
            @try {
                // 空きメモリあり
                NSURL* url = [[NSURL alloc] initFileURLWithPath:pTempAttachmentFile.attachmentFilePath];
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
                [data writeToFile:pTempAttachmentFile.printFilePath atomically:YES];
                
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

+ (BOOL)createPreviewFiles:(TempAttachmentFile*)pTempAttachmentFile {
    if (![pTempAttachmentFile existsAttachmentFile]) {
        return NO;
    }
    if ([pTempAttachmentFile existsPreviewFile]) {
        return YES;
    }
    BOOL bRet = YES;
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    [fileManager createDirectoryAtPath:pTempAttachmentFile.cacheDirectoryPath
           withIntermediateDirectories:YES
                            attributes:nil
                                 error:NULL];
    
    NSString *attachmentFileName = [pTempAttachmentFile.attachmentFilePath lastPathComponent];
    
    if([CommonUtil pdfExtensionCheck:attachmentFileName] && ([CommonUtil IsPDFMakeFromSharp:pTempAttachmentFile.attachmentFilePath]||[CommonUtil IsCompactPDFFromSharp:pTempAttachmentFile.attachmentFilePath])) {
        bRet = [self createPreviewFilesFromPdf:pTempAttachmentFile];
    }
    else if ([CommonUtil tiffExtensionCheck:attachmentFileName]) {
        bRet = [self createPreviewFilesFromTiff:pTempAttachmentFile];
    }
    else if ([CommonUtil jpegExtensionCheck:attachmentFileName]) {
        bRet = [self createPreviewFilesFromJpeg:pTempAttachmentFile];
    }
    else if ([CommonUtil pngExtensionCheck:attachmentFileName]) {
        bRet = [self createPreviewFilesFromPng:pTempAttachmentFile];
    }
    
    return bRet;
}

+ (BOOL)createPreviewFilesFromPdf:(TempAttachmentFile*)pTempAttachmentFile {
    @autoreleasepool{
        [PdfManager pdfToJpg:pTempAttachmentFile.attachmentFilePath dirPath:pTempAttachmentFile.cacheDirectoryPath isThumbnail:YES isWeb:NO];
    }
    return YES;
}

+ (BOOL)createPreviewFilesFromTiff:(TempAttachmentFile*)pTempAttachmentFile {
    @autoreleasepool{
        @try {
            TIFFManager* tiffManager = [[TIFFManager alloc] init];
            BOOL bRet = [tiffManager splitToJpegByFilePath:pTempAttachmentFile.attachmentFilePath DestinationDirPath:pTempAttachmentFile.cacheDirectoryPath];
            
            if(!bRet)
            {
                [self deletePreviewFiles:pTempAttachmentFile];
                return NO;
            }
        }
        @catch (NSException *exception) {
            [self deletePreviewFiles:pTempAttachmentFile];
            return NO;
        }
        @finally {
            // TODO
        }
    }
    return YES;
}

+ (BOOL)createPreviewFilesFromJpeg:(TempAttachmentFile*)pTempAttachmentFile {
    @autoreleasepool{
        // 出力した画像の縮小
        CGDataProviderRef dataProvider = CGDataProviderCreateWithFilename(strdup([pTempAttachmentFile.attachmentFilePath UTF8String]));
        NSString* cacheFilePath = [pTempAttachmentFile.cacheDirectoryPath stringByAppendingPathComponent:@"preview.jpg"];
        [CommonUtil OutputJpegByDataProvider:dataProvider outputFilePath:cacheFilePath maxPixelSize:1024];
        CGDataProviderRelease(dataProvider);
    }
    return YES;
}

+ (BOOL)createPreviewFilesFromPng:(TempAttachmentFile*)pTempAttachmentFile {
    @autoreleasepool{
        if([CommonUtil isExistsFreeMemoryJpegConvert:pTempAttachmentFile.attachmentFilePath])
        {
            @try {
                // 空きメモリあり
                NSURL* url = [[NSURL alloc] initFileURLWithPath:pTempAttachmentFile.attachmentFilePath];
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
                NSString* previewFilePath = [pTempAttachmentFile.cacheDirectoryPath stringByAppendingPathComponent:@"preview.jpg"];
                
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

+ (BOOL)deletePreviewFiles:(TempAttachmentFile*)pTempAttachmentFile {
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSArray *arrayPaths = [pTempAttachmentFile getPreviewFilePaths];
    if (arrayPaths != nil) {
        for (NSInteger i = 0; i < arrayPaths.count; i++) {
            NSString *filePath = [arrayPaths objectAtIndex:i];
            [fileManager removeItemAtPath:filePath error:nil];
        }
    }
    
    return YES;
}

+ (NSString*) getRootDir {
    return [TempAttachmentFile getRootDir];
}

@end
