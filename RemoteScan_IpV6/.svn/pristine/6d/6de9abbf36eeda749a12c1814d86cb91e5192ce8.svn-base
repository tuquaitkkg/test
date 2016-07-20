
#import "ScanFileUtility.h"
#import "CommonManager.h"
#import "CommonUtil.h"
#import "TIFFManager.h"
#import "GeneralFileUtility.h"
#import "MailServerDataManager.h"
#import "ProfileDataManager.h"

@implementation ScanFileUtility

+ (BOOL)deleteFile:(ScanFile*)pScanFile{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    if ([pScanFile existsFileInScanFile]) {
        [fileManager removeItemAtPath:pScanFile.scanFilePath error:nil];
    }

    if ([pScanFile existsThumbnailFile]) {
        [fileManager removeItemAtPath:pScanFile.thumbnailFilePath error:nil];
    }
    NSString *thumbnailFileDir = [pScanFile.thumbnailFilePath stringByDeletingLastPathComponent];
    if ([fileManager fileExistsAtPath:thumbnailFileDir]) {
        if ([GeneralFileUtility isEmptyDirectory:thumbnailFileDir]) {
            [fileManager removeItemAtPath:thumbnailFileDir error:nil];
        }
    }
    
    if ([pScanFile existsPrintFile]) {
        [fileManager removeItemAtPath:pScanFile.printFilePath error:nil];
    }
    NSString *printFileDir = [pScanFile.printFilePath stringByDeletingLastPathComponent];
    if ([fileManager fileExistsAtPath:printFileDir]) {
        if ([GeneralFileUtility isEmptyDirectory:printFileDir]) {
            [fileManager removeItemAtPath:printFileDir error:nil];
        }
    }
    
    if ([pScanFile existsPreviewFile]) {
        NSArray *previewFilePaths = [pScanFile getPreviewFilePaths];
        for (NSUInteger i = 0; i < previewFilePaths.count; i++) {
            NSString *previewFilePath = [previewFilePaths objectAtIndex:i];
            [fileManager removeItemAtPath:previewFilePath error:nil];
        }
    }
    if ([fileManager fileExistsAtPath:pScanFile.cacheDirectoryPath]) {
        if ([GeneralFileUtility isEmptyDirectory:pScanFile.cacheDirectoryPath]) {
            [fileManager removeItemAtPath:pScanFile.cacheDirectoryPath error:nil];
        }
    }
    
    if ([pScanFile existsUpdateDateFile]) {
        [fileManager removeItemAtPath:pScanFile.updateDateFilePath error:nil];
    }
    if ([fileManager fileExistsAtPath:pScanFile.cacheDirectoryPath]) {
        if ([GeneralFileUtility isEmptyDirectory:pScanFile.cacheDirectoryPath]) {
            [fileManager removeItemAtPath:pScanFile.cacheDirectoryPath error:nil];
        }
    }
    
    return YES;
}

+ (BOOL)rename:(ScanFile*)pScanFile FileName:(NSString*) pFileName{
    NSString *scanFilePath = [[pScanFile.scanFilePath stringByDeletingLastPathComponent] stringByAppendingPathComponent:pFileName];
    ScanFile *destination = [[ScanFile alloc] initWithScanFilePath:scanFilePath];
    if ([destination existsFileInScanFile]) {
        return NO;
    }
    return [self move:pScanFile Destination:destination];
}

+ (NSString*)getDocumentsDirectoryPath{
    //Documments の取得
    NSArray *documentsFolders = NSSearchPathForDirectoriesInDomains (NSDocumentDirectory, NSUserDomainMask, YES );
    NSString *rootDir = [documentsFolders lastObject];
    return rootDir;
}

+ (NSString*)getScanFileDirectoryPath{
    return [ScanFile getScanDir];
}

+ (BOOL)moveToDirectory:(ScanFile*)pScanFile Destination:(ScanDirectory*) pDestination{
    NSString *scanFilePath = [pDestination.scanDirectoryPath stringByAppendingPathComponent:pScanFile.scanFileName];
    ScanFile *destination = [[ScanFile alloc] initWithScanFilePath:scanFilePath];
    return [self move:pScanFile Destination:destination];
}

+ (BOOL)move:(ScanFile*)pScanFile Destination:(ScanFile*) pDestination{
    BOOL bRet = [self copy:pScanFile Destination:pDestination];
    if (bRet) {
        bRet = [self deleteFile:pScanFile];
    } else {
        [self deleteFile:pDestination];
    }
    
    return bRet;
}

+ (BOOL)copy:(ScanFile*)pScanFile Destination:(ScanFile*) pDestination{
    BOOL bRet = [self deleteFile:pDestination];
    if (!bRet) {
        return NO;
    }

    NSFileManager *fileManager = [NSFileManager defaultManager];
    [fileManager createDirectoryAtPath:pDestination.parentDirectoryPathInScanFile
           withIntermediateDirectories:YES
                            attributes:nil
                                 error:NULL];
    
    if ([pScanFile existsThumbnailFile]) {
        [fileManager createDirectoryAtPath:[pDestination.thumbnailFilePath stringByDeletingLastPathComponent]
               withIntermediateDirectories:YES
                                attributes:nil
                                     error:NULL];
        bRet = [fileManager copyItemAtPath:pScanFile.thumbnailFilePath toPath:pDestination.thumbnailFilePath error:nil];
        if (!bRet) {
            return NO;
        }
    }
    
    if ([pScanFile existsPrintFile]) {
        [fileManager createDirectoryAtPath:[pDestination.printFilePath stringByDeletingLastPathComponent]
               withIntermediateDirectories:YES
                                attributes:nil
                                     error:NULL];
        bRet = [fileManager copyItemAtPath:pScanFile.printFilePath toPath:pDestination.printFilePath error:nil];
        if (!bRet) {
            return NO;
        }
    }
    
    if ([pScanFile existsPreviewFile]) {
        [fileManager createDirectoryAtPath:pDestination.cacheDirectoryPath
               withIntermediateDirectories:YES
                                attributes:nil
                                     error:NULL];
        NSArray *arrayNames = [pScanFile getPreviewFileNames];
        for (NSInteger i = 0; i < arrayNames.count; i++) {
            NSString *srcFileName = [arrayNames objectAtIndex:i];
            NSString *srcFilePath = [pScanFile.cacheDirectoryPath stringByAppendingPathComponent:srcFileName];
            
            NSString *dstFileName = srcFileName;
            NSString *dstFilePath = [pDestination.cacheDirectoryPath stringByAppendingPathComponent:dstFileName];
            bRet = [fileManager copyItemAtPath:srcFilePath toPath:dstFilePath error:nil];
            if (!bRet) {
                return NO;
            }
        }
    }

    if ([pScanFile existsFileInScanFile]) {
        bRet = [fileManager copyItemAtPath:pScanFile.scanFilePath toPath:pDestination.scanFilePath error:nil];
        if (!bRet) {
            return NO;
        }
    }
    
    if ([pDestination existsFileInScanFile]) {
        // updatedate.txt を作成する
        bRet = [ScanFileUtility saveUpdateDate:pDestination];
        if (!bRet) {
            return NO;
        }
    }
    
    return YES;
}

// キャッシュファイルを再作成するかどうかを判断する
+ (BOOL)cacheRecreateCheck:(ScanFile*)pScanFile{
    BOOL bRet = YES;

    // 実ファイルの作成時間を取得
    NSString *scanUpdateTime = [pScanFile getUpdateDateInScanFile];
    DLog(@"scanUpdateTime: %@",scanUpdateTime);

    // updatedate.txtの中身（作成時間）を取得
    NSString *cacheUpdateTime = [pScanFile getUpdateDateInCacheDirectory];
    DLog(@"cacheUpdateTime: %@",cacheUpdateTime);
    
    // 作成時間が同じ場合は、キャッシュ再作成は行わない
    if ([scanUpdateTime isEqualToString:cacheUpdateTime]) {
        bRet = NO;
    }
    
    return bRet;
}

+ (BOOL)save:(ScanFile*)pScanFile{
    return NO;
}

+ (NSNumber*)getFileSize:(ScanFile*)pScanFile{
    if (![pScanFile existsFileInScanFile]) {
        return 0;
    }
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSDictionary *attribute = [fileManager attributesOfItemAtPath:pScanFile.scanFilePath error:nil];
    return [attribute objectForKey:NSFileSize];
}

+ (BOOL)createRequiredAllImageFiles:(ScanFile*)pScanFile{
    if ([CommonUtil officeExtensionCheck:pScanFile.scanFilePath]) {
        // Officeファイルの場合はキャッシュを作らない
        return YES;
    }

    if (![self cacheRecreateCheck:pScanFile]) {
        // 実ファイル作成時間とupdatedate.txtの中身が同じ場合はキャッシュ再作成は行わない
        return YES;
    }
    
    BOOL bRet = YES;
    if(![self createPreviewFiles:pScanFile]){
        bRet = NO;
    }
    if(![self createThumbnailFile:pScanFile]){
        bRet = NO;
    }
    if(![self createPrintFile:pScanFile]){
        bRet = NO;
    }
    // updatedate.txt を作成する
    if(![self saveUpdateDate:pScanFile]){
        bRet = NO;
    }
    return  bRet;
}

+ (BOOL)createCacheFile:(ScanFile*)pScanFile{
    if (![self cacheRecreateCheck:pScanFile]) {
        // 実ファイル作成時間とupdatedate.txtの中身が同じ場合はキャッシュ再作成は行わない
        return YES;
    }
    
    BOOL bRet = YES;
    if(![self createPreviewFiles:pScanFile]){
        bRet = NO;
    }
    if(![self createPrintFile:pScanFile]){
        bRet = NO;
    }
    return  bRet;
}

+ (BOOL)createThumbnailFile:(ScanFile*)pScanFile{
    // 既に存在し、キャッシュ再作成が不要な場合は、何もしない
    if ([pScanFile existsThumbnailFile] && ![self cacheRecreateCheck:pScanFile]) {
        return YES;
    }
    if ([CommonUtil officeExtensionCheck:pScanFile.scanFilePath]) {
        // Officeファイルの場合はキャッシュを作らない
        return YES;
    }
    if (![pScanFile existsFileInScanFile]) {
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
    if ([CommonUtil pdfExtensionCheck:[pScanFile.scanFilePath lastPathComponent]])
    {
        NSArray * previewArray = [pScanFile getPreviewFilePaths];
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
            NSInteger iCheckPDFSize = [commanager checkPdfSize:pScanFile.scanFilePath firstPage:&resultImage width:width height:height];
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
    else if([CommonUtil tiffExtensionCheck:[pScanFile.scanFilePath lastPathComponent]] || [CommonUtil jpegExtensionCheck:[pScanFile.scanFilePath lastPathComponent]] || [CommonUtil pngExtensionCheck:[pScanFile.scanFilePath lastPathComponent]] )
    {
        NSArray * previewArray = [pScanFile getPreviewFilePaths];
        if(previewArray){
            resultImage = [[UIImage alloc] initWithContentsOfFile:[previewArray objectAtIndex:0]];
        }else{
            resultImage = [[UIImage alloc] initWithContentsOfFile:pScanFile.scanFilePath];
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
    
    NSString *thumbnailFileDir = [pScanFile.thumbnailFilePath stringByDeletingLastPathComponent];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    [fileManager createDirectoryAtPath:thumbnailFileDir
           withIntermediateDirectories:YES
                            attributes:nil
                                 error:NULL];
    
    NSData *data = [[NSData alloc] initWithData:UIImagePNGRepresentation( newImage )];
    return [data writeToFile:pScanFile.thumbnailFilePath atomically:YES];
}

+ (BOOL)createPrintFile:(ScanFile*)pScanFile{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    // 既に存在し、キャッシュ再作成が不要な場合は、何もしない
    if ([fileManager fileExistsAtPath:pScanFile.printFilePath] && ![self cacheRecreateCheck:pScanFile]) {
        return YES;
    }
    if (![CommonUtil pngExtensionCheck:[pScanFile.scanFilePath lastPathComponent]]) {
        return YES;
    }
    if (![pScanFile existsFileInScanFile]) {
        return NO;
    }
    
    NSString *printFileDir = [pScanFile.printFilePath stringByDeletingLastPathComponent];
    [fileManager createDirectoryAtPath:printFileDir
           withIntermediateDirectories:YES
                            attributes:nil
                                 error:NULL];
    
    if([CommonUtil isExistsFreeMemoryJpegConvert:pScanFile.scanFilePath])
    {
        @autoreleasepool{
            @try {
                // 空きメモリあり
                NSURL* url = [[NSURL alloc] initFileURLWithPath:pScanFile.scanFilePath];
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
                [data writeToFile:pScanFile.printFilePath atomically:YES];
                
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

+ (BOOL)deletePreviewFiles:(ScanFile*)pScanFile {
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSArray *arrayPaths = [pScanFile getPreviewFilePaths];
    if (arrayPaths != nil) {
        for (NSInteger i = 0; i < arrayPaths.count; i++) {
            NSString *filePath = [arrayPaths objectAtIndex:i];
            [fileManager removeItemAtPath:filePath error:nil];
        }
    }
    
    return YES;
}

+ (BOOL)createPreviewFilesFromPdf:(ScanFile*)pScanFile {
    @autoreleasepool{
        [PdfManager pdfToJpg:pScanFile.scanFilePath dirPath:pScanFile.cacheDirectoryPath isThumbnail:YES isWeb:NO];
    }
    return YES;
}

+ (BOOL)createPreviewFilesFromTiff:(ScanFile*)pScanFile {
    @autoreleasepool{
        @try {
            TIFFManager* tiffManager = [[TIFFManager alloc] init];
            BOOL bRet = [tiffManager splitToJpegByFilePath:pScanFile.scanFilePath DestinationDirPath:pScanFile.cacheDirectoryPath];
            
            if(!bRet)
            {
                [self deletePreviewFiles:pScanFile];
                return NO;
            }
        }
        @catch (NSException *exception) {
            [self deletePreviewFiles:pScanFile];
            return NO;
        }
        @finally {
            // TODO
        }
    }
    return YES;
}

+ (BOOL)createPreviewFilesFromJpeg:(ScanFile*)pScanFile {
    @autoreleasepool{
        // 出力した画像の縮小
        CGDataProviderRef dataProvider = CGDataProviderCreateWithFilename(strdup([pScanFile.scanFilePath UTF8String]));
        NSString* cacheFilePath = [pScanFile.cacheDirectoryPath stringByAppendingPathComponent:@"preview.jpg"];
        [CommonUtil OutputJpegByDataProvider:dataProvider outputFilePath:cacheFilePath maxPixelSize:1024];
        CGDataProviderRelease(dataProvider);
    }
    return YES;
}

+ (BOOL)createPreviewFilesFromPng:(ScanFile*)pScanFile {
    @autoreleasepool{
        if([CommonUtil isExistsFreeMemoryJpegConvert:pScanFile.scanFilePath])
        {
            @try {
                // 空きメモリあり
                NSURL* url = [[NSURL alloc] initFileURLWithPath:pScanFile.scanFilePath];
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
                NSString* previewFilePath = [pScanFile.cacheDirectoryPath stringByAppendingPathComponent:@"preview.jpg"];
                
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

+ (BOOL)createPreviewFiles:(ScanFile*)pScanFile{
    if (![pScanFile existsFileInScanFile]) {
        return NO;
    }
    // 既に存在し、キャッシュ再作成が不要な場合は、何もしない
    if ([pScanFile existsPreviewFile] && ![self cacheRecreateCheck:pScanFile]) {
        return YES;
    }
    BOOL bRet = YES;
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    [fileManager createDirectoryAtPath:pScanFile.cacheDirectoryPath
           withIntermediateDirectories:YES
                            attributes:nil
                                 error:NULL];
    
    if([CommonUtil pdfExtensionCheck:pScanFile.scanFilePath] && ([CommonUtil IsPDFMakeFromSharp:pScanFile.scanFilePath]||[CommonUtil IsCompactPDFFromSharp:pScanFile.scanFilePath])) {
        bRet = [self createPreviewFilesFromPdf:pScanFile];
    }
    else if ([CommonUtil tiffExtensionCheck:pScanFile.scanFilePath]) {
        bRet = [self createPreviewFilesFromTiff:pScanFile];
    }
    else if ([CommonUtil jpegExtensionCheck:pScanFile.scanFilePath]) {
        bRet = [self createPreviewFilesFromJpeg:pScanFile];
    }
    else if ([CommonUtil pngExtensionCheck:pScanFile.scanFilePath]) {
        bRet = [self createPreviewFilesFromPng:pScanFile];
    }
    
    return bRet;
}

+ (BOOL)saveUpdateDate:(ScanFile*)pScanFile{
    NSString *updateDate = [pScanFile getUpdateDateInScanFile];
    if (updateDate == nil) {
        return NO;
    }
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if ([fileManager fileExistsAtPath:pScanFile.updateDateFilePath]) {
        [fileManager removeItemAtPath:pScanFile.updateDateFilePath error:nil];
    }

    // キャッシュディレクトリ作成(暗号化ファイルなどは未存在であるためここで作成しておく)
    if (![fileManager createDirectoryAtPath:pScanFile.cacheDirectoryPath
               withIntermediateDirectories:YES
                                attributes:nil
                                     error:NULL]) {
        // ディレクトリ作成失敗
        return NO;
    }

    return [updateDate writeToFile:pScanFile.updateDateFilePath atomically:YES encoding:NSUTF8StringEncoding error:nil];
}

+ (NSArray*)searchScanFile:(NSString*)pDirectoryPath Keyword:(NSString*)pKeyword{
    return nil;
}

+ (NSArray*)searchScanFileInDetail:(NSArray*)pArgs{
    return nil;
}

+ (NSArray*)searchScanDirectoryInDetail:(NSArray*)pArgs{
    return nil;
}

+ (NSString*)createNumberedFileName :(NSString*)renamedFileName defaultFileName:(NSString*)defaultFileName{

    NSString * numberedName = [[defaultFileName lastPathComponent] stringByDeletingPathExtension];
    NSString *numberString = [numberedName substringFromIndex:numberedName.length -4];

    NSString * renamedFileNameBody = [renamedFileName stringByDeletingPathExtension];
    renamedFileNameBody = [renamedFileNameBody stringByAppendingString:numberString];
    NSString * outputFileName = [renamedFileNameBody stringByAppendingPathExtension:[defaultFileName pathExtension]];
    return outputFileName;
}

+ (NSString*) getRootDir {
    NSArray *docFolders = NSSearchPathForDirectoriesInDomains (NSDocumentDirectory, NSUserDomainMask, YES );
    NSString *homeDir  = [docFolders lastObject];
    // ルートディレクトリは、Documentsに決定
    NSString *rootDir = homeDir;

    return rootDir;
}

+ (NSString*)getRootCacheDir{
    // Library/PrivateDocuments の取得
    NSString *privateDocumentsPath = [GeneralFileUtility getPrivateDocuments];
    // Library/PrivateDocuments/CacheDirectory の取得
    NSString *rootCacheDir = [privateDocumentsPath stringByAppendingPathComponent:@"CacheDirectory"];
    return rootCacheDir;
}

// -------------------------------------------------------------------------------------------------------------
// Version2.2へデータ移行する
// Library/PrivateDocumentsが既に存在すれば、移行済みとする
// 移行前なら以下の手順で移行する
// -------------------------------------------------------------------------------------------------------------
// 移行手順
// Documents/設定ファイル(XXX.dat) --> Library/PrivateDocuments直下へ移動
// Documents/TempFile            --> 削除
// Documents/TempAttachmentFile  --> 削除
// Documents/TempPrintFile       --> 削除
// Documents/ScanFile --> Documents/ScanFile 内のデータを変換する
//                    --> 変換後データをDocuments直下へ移動させる
//                        但し、すでに存在する場合は、移動させずにそのまま残す
//                    --> Documents/ScanFile 内に残データがなければディレクトリを削除する。残データありの場合はそのまま残す。
// -------------------------------------------------------------------------------------------------------------
+ (BOOL)convertToVersion2_2 {
    
    BOOL bRet;
    
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSString *privateDocuments = [GeneralFileUtility getPrivateDocuments];

    // Library/PrivateDocuments を作成する
    [fileManager createDirectoryAtPath:privateDocuments
           withIntermediateDirectories:YES
                            attributes:nil
                                 error:NULL];

    // Documents/ 配下にある各種設定ファイル(.dat)をLibrary/PrivateDocuments/直下に移動させる
    bRet = [self moveDatFile];
    if (!bRet) {
        DLog(@"datFileの移行に失敗しました");
    }
    
    // Documents/ 配下の不要ディレクトリを削除する(TempFile,TempAttachmentFile,TempPrintFile)
    bRet = [self deleteTempDirectory];
    if (!bRet) {
        DLog(@"不要ディレクトリの削除に失敗しました");
    }
    
    // Documents/ScanFile/ 配下のデータ変換処理を行う
    bRet = [self convertScanFileData];
    if (!bRet) {
        DLog(@"ScanFileディレクトリデータ変換に失敗しました");
    }

    // Documents/ScanFile/ 配下のデータを Documents/ 直下に移動させる
    bRet = [self moveScanFileData];
    if (!bRet) {
        DLog(@"ScanFileディレクトリ内データの移動に失敗しました");
    }
    
    return YES;
}

// -----------------------------------------------------------------------------------------
// Version2.2 に移行済みかどうか
// Library/PrivateDocumentsの存在確認により、移行済みかどうかを判断する
// -----------------------------------------------------------------------------------------
+ (BOOL)isConvertVersion2_2 {
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    BOOL bRet;
    BOOL isDir;
    
    NSString *privateDocuments = [GeneralFileUtility getPrivateDocuments];

    // 移行済みなら何もしない
    if ([fileManager fileExistsAtPath:privateDocuments isDirectory:&isDir] && isDir) {
        DLog(@"Version2.2 へ移行済みです。");
        bRet = YES;
        
    } else {
        DLog(@"Version2.2 ではありません。");
        bRet = NO;

    }
    
    return bRet;
}

// -----------------------------------------------------------
// 設定ファイル(.dat)を移動させる
// 移動前：Documents/XXX.dat
// 移動後：Library/PrivateDocuments/XXX.dat
// -----------------------------------------------------------
+ (BOOL)moveDatFile{
    
    // 移動前 ルートディレクトリ
    NSString *documentsRoot = [ScanFileUtility getRootDir];
    
    // 移動後 ルートディレクトリ
    NSString *privateDocuments = [GeneralFileUtility getPrivateDocuments];
    
    // 移行するDATファイル用配列
    NSMutableArray *datFileList = [NSMutableArray array];
    
    // プリンタ情報DATファイル
    [datFileList addObject:S_PRINTERDATA_DAT];
    // 除外プリンタ情報DATファイル
    [datFileList addObject:S_EXCLUDEPRINTERDATA_DAT];
    // カスタムサイズDATファイル
    [datFileList addObject:S_CUSTOMSIZEDATA_DAT];
    // リモートスキャン設定DATファイル
    [datFileList addObject:S_REMOTESCANSETTING_DAT];
    // プリントサーバー情報DATファイル
    [datFileList addObject:S_PRINTSERVERDATA_DAT];
    // メールサーバーDATファイル
    [datFileList addObject:MAILSERVERDATA_DAT];
    // プロファイルデータ設定DATファイル
    [datFileList addObject:PROFILEDATA_DAT];
    
    BOOL bRet = YES;
    BOOL isDir;
    NSString *datFile;
    NSFileManager *fileManager = [NSFileManager defaultManager];
    for (datFile in datFileList) {
        // フルパス取得
        NSString *fullPath = [documentsRoot stringByAppendingString:datFile];
        // Documents/datFile を Library/PrivateDocuments直下に移動
        if ([fileManager fileExistsAtPath:fullPath isDirectory:&isDir] && !isDir) {
            NSString *dstFullPath = [privateDocuments stringByAppendingString:datFile];
            bRet = [fileManager moveItemAtPath:fullPath toPath:dstFullPath error:NULL];

            if (!bRet) {
                DLog(@"datFileの移動に失敗しました: %@",fullPath);
            }
        }
        
    }
    
    return YES;
}

// ----------------------------------------------------------------
// 不要なディレクトリを削除する
// 削除対象：Documents/TempFile
// 削除対象：Documents/TempAttachmentFile
// 削除対象：Documents/TempPrintFile
// ----------------------------------------------------------------
+ (BOOL)deleteTempDirectory{
    
    NSString *documentsRoot = [ScanFileUtility getRootDir];
    
    NSString *tempFilePath = [documentsRoot stringByAppendingPathComponent:@"TempFile"];
    NSString *tempAttachmentFilePath = [documentsRoot stringByAppendingPathComponent:@"TempAttachmentFile"];
    NSString *tempPrintFilePath = [documentsRoot stringByAppendingPathComponent:@"TempPrintFile"];
    
    // 不要ディレクトリ削除用配列
    NSMutableArray *deleteDirectoryList = [NSMutableArray array];
    
    [deleteDirectoryList addObject:tempFilePath];
    [deleteDirectoryList addObject:tempAttachmentFilePath];
    [deleteDirectoryList addObject:tempPrintFilePath];
    
    BOOL bRet = YES;
    BOOL isDir;
    NSString *deleteDirectory;
    NSFileManager *fileManager = [NSFileManager defaultManager];
    for (deleteDirectory in deleteDirectoryList) {
        // フルパス取得
        NSString *fullPath = deleteDirectory;
        // 存在すれば削除する
        if ([fileManager fileExistsAtPath:fullPath isDirectory:&isDir] && isDir) {
            bRet = [fileManager removeItemAtPath:fullPath error:NULL];

            if (!bRet) {
                DLog(@"不要ディレクトリの削除に失敗しました: %@",fullPath);
            }
        }
    }
    
    return YES;
}

// -----------------------------------------------------------------------
// ScanFileディレクトリ内のデータを移行用データに変換する
// 変換前データ：Documents/ScanFile/ファイル名
//           ：Documents/ScanFile/DIR-フォルダ名
//           ：Documents/ScanFile/F-ファイル名-拡張子
//           ：Documents/ScanFile/PNGFILE
// 変換後データ：Documents/ScanFile/ファイル名
//           ：Documents/ScanFile/フォルダ名
//           ：Documents/ScanFile/F-ファイル名-拡張子  --> 削除する
//           ：Documents/ScanFile/PNGFILE           --> 削除する
// -----------------------------------------------------------------------
+ (BOOL)convertScanFileData{
    
    NSString *documentsRoot = [ScanFileUtility getRootDir];
    
    // Documents/ScanFileディレクトリ確認
    NSString *oldScanFilePath = [documentsRoot stringByAppendingPathComponent:@"ScanFile"];
    BOOL bRet = YES;
    
    // Documents/ScanFile において、データ変換を行う
    bRet = [self convertData:oldScanFilePath];
    if (!bRet) {
        DLog(@"ScanFileディレクトリ内データ変換失敗あり");
    }
    
    return YES;
}

//// -----------------------------------------------------------------------
//// ディレクトリ内のデータを変換する(再帰用)
//// 同階層に同名ファイルとディレクトリがある場合は、ディレクトリをリネームする
//// -----------------------------------------------------------------------
//+ (BOOL)convertData:(NSString*)targetPath{
//    
//    DLog(@"--- ディレクトリ内のデータ変換を開始します。対象ディレクトリ：%@ ---", targetPath);
//
//    NSFileManager *fileManager = [NSFileManager defaultManager];
//    NSArray *baseList = [fileManager contentsOfDirectoryAtPath:targetPath error:nil];
//    
//    // 不要ディレクトリを削除する
//    BOOL bRet = YES;
//    BOOL isDir;
//    NSMutableArray *normalDirectoryList = [NSMutableArray array];
//    for (NSString *tempName in baseList) {
//        // フルパス取得
//        NSString *fullPath = [targetPath stringByAppendingPathComponent:tempName];
//        // ディレクトリの場合
//        if ([fileManager fileExistsAtPath:fullPath isDirectory:&isDir] && isDir) {
//            
//            if ([tempName hasPrefix:@"F-"] || [tempName isEqualToString:@"PNGFILE"]) {
//                // 「F-」から始まるディレクトリまたは「PNGFILE」ディレクトリは不要なので削除する
//                bRet = [fileManager removeItemAtPath:fullPath error:NULL];
//                if (!bRet) {
//                    // 削除失敗
//                    DLog(@"不要ディレクトリの削除に失敗しました：%@", fullPath);
//                }
//                
//            } else {
//                // 通常ディレクトリを追加する
//                [normalDirectoryList addObject:fullPath];
//            }
//        } else {
//            // ファイルは何もしない
//            DLog(@"移行済みファイル: %@",fullPath);
//        }
//    }
//    
//    // 通常ディレクトリをリネームする
//    NSMutableArray *nextDirectoryList = [NSMutableArray array];
//    NSMutableArray *renamedFailureList = [NSMutableArray array];
//    for (NSString *normalDirectory in normalDirectoryList) {
//        // 通常ディレクトリ取得
//        NSString *directoryName = [normalDirectory lastPathComponent];
//        // 通常ディレクトリから「DIR-」を省く
//        if ([directoryName hasPrefix:@"DIR-"]) {
//            directoryName = [directoryName substringFromIndex:4];
//        }
//        // リネーム後のディレクトリパスを作成
//        NSString *renamedDirectory = [[normalDirectory stringByDeletingLastPathComponent] stringByAppendingPathComponent:directoryName];
//        // 通常ディレクトリをリネームする
//        bRet = [fileManager moveItemAtPath:normalDirectory toPath:renamedDirectory error:NULL];
//        if (!bRet) {
//            // リネーム失敗
//            DLog(@"リネームに失敗しました。リネーム前：%@、リネーム後：%@", normalDirectory, renamedDirectory);
//            // 同階層に同一ファイル名とディレクトリ名が存在する場合、リネームに失敗するため
//            // リネーム前のディレクトリパスをリネーム失敗リストに追加する
//            [renamedFailureList addObject:normalDirectory];
//            
//        } else {
//            // リネーム後のディレクトリパスを追加する
//            [nextDirectoryList addObject:renamedDirectory];
//        }
//    }
//    
//    // リネーム失敗ディレクトリに対してindexをつけて再度リネームを試みる
//    for (NSString *renameFailureDirectory in renamedFailureList) {
//        DLog(@"同階層に同名ディレクトリが存在するため、インデックスをつけてリネームします：%@", renameFailureDirectory);
//
//        // 通常ディレクトリ取得
//        NSString *directoryName = [renameFailureDirectory lastPathComponent];
//        // 通常ディレクトリから「DIR-」を省く
//        if ([directoryName hasPrefix:@"DIR-"]) {
//            directoryName = [directoryName substringFromIndex:4];
//        }
//        // リネーム後のディレクトリパス
//        NSString *renamedDirectory;
//
//        // 連番でディレクトリ名リネーム
//        for (NSInteger iRenameIndex = 1; iRenameIndex <= 10000; iRenameIndex++)
//        {
//            NSString *tmpDirectoryName = [NSString stringWithFormat:@"%@(%zd)",
//                                          directoryName,
//                                          iRenameIndex];
//            // 200文字以内でリネームする
//            if(tmpDirectoryName.length > 200){
//                tmpDirectoryName = [NSString stringWithFormat:@"%@(%zd)",
//                                    [directoryName substringToIndex:198 - [NSString stringWithFormat:@"%zd", iRenameIndex].length],
//                                    iRenameIndex];
//            }
//            // リネーム後のディレクトリパス
//            renamedDirectory = [[renameFailureDirectory stringByDeletingLastPathComponent] stringByAppendingPathComponent:tmpDirectoryName];
//            
//            // ディレクトリ存在確認
//            if(![fileManager fileExistsAtPath:renamedDirectory])
//            {
//                break;
//            }
//        }
//
//        // ディレクトリ存在確認
//        if ([fileManager fileExistsAtPath:renamedDirectory]) {
//            // 10000回リネームしても同名ディレクトリが存在するため、リネームを諦める
//            DLog(@"同名ディレクトリのリネーム回数の上限を超えました: %@",renameFailureDirectory);
//            
//            // リネーム前のディレクトリパスを追加する
//            [nextDirectoryList addObject:renameFailureDirectory];
//
//        } else {
//            // インデックス付きディレクトリ名でリネームする
//            bRet = [fileManager moveItemAtPath:renameFailureDirectory toPath:renamedDirectory error:NULL];
//            if (!bRet) {
//                // リネーム失敗
//                DLog(@"リネームに失敗しました。リネーム前：%@、リネーム後：%@", renameFailureDirectory, renamedDirectory);
//                // リネーム前のディレクトリパスを追加する
//                [nextDirectoryList addObject:renameFailureDirectory];
//                
//            } else {
//                // リネーム後のディレクトリパスを追加する
//                [nextDirectoryList addObject:renamedDirectory];
//            }
//        }
//    }
//    
//    // ディレクトリに対して再帰処理
//    for (NSString *nextTargetPath in nextDirectoryList) {
//        // 再帰処理
//        [self convertData:nextTargetPath];
//    }
//    DLog(@"--- ディレクトリ内のデータ変換を終了します。対象ディレクトリ：%@ ---", targetPath);
//    return YES;
//}

// -----------------------------------------------------------------------
// ディレクトリ内のデータを変換する(再帰用)
// 同階層に同名ファイルとディレクトリがある場合は、ディレクトリをリネームしない
// -----------------------------------------------------------------------
+ (BOOL)convertData:(NSString*)targetPath{
    
    DLog(@"--- ディレクトリ内のデータ変換を開始します。対象ディレクトリ：%@ ---", targetPath);
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSArray *baseList = [fileManager contentsOfDirectoryAtPath:targetPath error:nil];
    
    // 不要ディレクトリを削除する
    BOOL bRet = YES;
    BOOL isDir;
    NSMutableArray *normalDirectoryList = [NSMutableArray array];
    for (NSString *tempName in baseList) {
        // フルパス取得
        NSString *fullPath = [targetPath stringByAppendingPathComponent:tempName];
        // ディレクトリの場合
        if ([fileManager fileExistsAtPath:fullPath isDirectory:&isDir] && isDir) {
            
            if ([tempName hasPrefix:@"F-"] || [tempName isEqualToString:@"PNGFILE"]) {
                // 「F-」から始まるディレクトリまたは「PNGFILE」ディレクトリは不要なので削除する
                bRet = [fileManager removeItemAtPath:fullPath error:NULL];
                if (!bRet) {
                    // 削除失敗
                    DLog(@"不要ディレクトリの削除に失敗しました：%@", fullPath);
                }
                
            } else {
                // 通常ディレクトリを追加する
                [normalDirectoryList addObject:fullPath];
            }
        } else {
            // ファイルは何もしない
            DLog(@"移行済みファイル: %@",fullPath);
        }
    }
    
    // 通常ディレクトリをリネームする
    NSMutableArray *nextDirectoryList = [NSMutableArray array];
    for (NSString *normalDirectory in normalDirectoryList) {
        // 通常ディレクトリ取得
        NSString *directoryName = [normalDirectory lastPathComponent];
        // 通常ディレクトリから「DIR-」を省く
        if ([directoryName hasPrefix:@"DIR-"]) {
            directoryName = [directoryName substringFromIndex:4];
        }
        // リネーム後のディレクトリパスを作成
        NSString *renamedDirectory = [[normalDirectory stringByDeletingLastPathComponent] stringByAppendingPathComponent:directoryName];
        // 通常ディレクトリをリネームする
        bRet = [fileManager moveItemAtPath:normalDirectory toPath:renamedDirectory error:NULL];
        if (!bRet) {
            // リネーム失敗
            DLog(@"リネームに失敗しました。リネーム前：%@、リネーム後：%@", normalDirectory, renamedDirectory);
            // リネームに失敗した場合は、リネーム前の名前で登録する
            [nextDirectoryList addObject:normalDirectory];
            
        } else {
            // リネーム後のディレクトリパスを追加する
            [nextDirectoryList addObject:renamedDirectory];
        }
    }
    
    // ディレクトリに対して再帰処理
    for (NSString *nextTargetPath in nextDirectoryList) {
        // 再帰処理
        [self convertData:nextTargetPath];
    }
    DLog(@"--- ディレクトリ内のデータ変換を終了します。対象ディレクトリ：%@ ---", targetPath);
    return YES;
}

// -----------------------------------------------------------------------
// Documents/ScanFile/ の中身 を Documents/ 直下に移動させる
// 予約語ディレクトリは移動不可のため、そのまま残す
// すでに存在する場合も移動不可のため、そのまま残す
// -----------------------------------------------------------------------
+ (BOOL)moveScanFileData{
    NSString *documentsRoot = [ScanFileUtility getRootDir];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    BOOL bRet = YES;
    
    // Documents/ScanFileディレクトリ確認
    NSString *oldScanFilePath = [documentsRoot stringByAppendingPathComponent:@"ScanFile"];
    NSArray *convertDataList = [fileManager contentsOfDirectoryAtPath:oldScanFilePath error:nil];
    for (NSString *convertData in convertDataList) {
        
        // フルパス取得
        NSString *fullPath = [oldScanFilePath stringByAppendingPathComponent:convertData];

        // 予約語ディレクトリの場合はそのまま残す。
        if ([CommonUtil checkReservedWord:convertData]) {
            DLog(@"予約語ディレクトリのためそのまま残す: %@",fullPath);
            continue;
        }
        
        // 移動先フルパス取得
        NSString *dstFullPath = [documentsRoot stringByAppendingPathComponent:convertData];

        // すでにDocuments/ 直下に存在する場合もそのまま残す。
        if ([fileManager fileExistsAtPath:dstFullPath]) {
            DLog(@"移動先にデータが存在します。移動前フルパス: %@、移動前フルパス: %@", fullPath, dstFullPath);
            continue;
            
        } else {
            // 存在しないので、移動させる
            bRet = [fileManager moveItemAtPath:fullPath toPath:dstFullPath error:NULL];
            if (!bRet) {
                DLog(@"データ移行に失敗しました: %@",fullPath);
            }
        }
    }
    
    // Documents/ScanFile/ の中身が空になれば、ScanFileを削除しておく
    NSArray *restDataList = [fileManager contentsOfDirectoryAtPath:oldScanFilePath error:NULL];
    if ([restDataList count] == 0) {
        // Documents/ScanFile/ の中身が空になれば、ScanFileディレクトリを削除しておく
        if ([fileManager fileExistsAtPath:oldScanFilePath]) {
            bRet = [fileManager removeItemAtPath:oldScanFilePath error:NULL];
            if (!bRet) {
                DLog(@"ScanFileディレクトリの削除に失敗しました: %@",oldScanFilePath);
            }
        }
    }

    return YES;
}


// -----------------------------------------------------------
// Version2.2 移行前に戻す（動作確認用）
// （動作確認試験終了後、削除しておくこと）
//   設定ファイル(xxx.dat)をDocuments/直下に戻す
//   Library/PrivateDocuments　ディレクトリを削除
// -----------------------------------------------------------
+ (BOOL)reverseBeforeV2_2{
    NSString *documentsRoot = [ScanFileUtility getRootDir];
    NSString *privateDocuments = [GeneralFileUtility getPrivateDocuments];
    
    // 移行するDATファイル用配列
    NSMutableArray *datFileList = [NSMutableArray array];
    
    // プリンタ情報DATファイル
    [datFileList addObject:S_PRINTERDATA_DAT];
    // 除外プリンタ情報DATファイル
    [datFileList addObject:S_EXCLUDEPRINTERDATA_DAT];
    // カスタムサイズDATファイル
    [datFileList addObject:S_CUSTOMSIZEDATA_DAT];
    // リモートスキャン設定DATファイル
    [datFileList addObject:S_REMOTESCANSETTING_DAT];
    // プリントサーバー情報DATファイル
    [datFileList addObject:S_PRINTSERVERDATA_DAT];
    // メールサーバーDATファイル
    [datFileList addObject:MAILSERVERDATA_DAT];
    // プロファイルデータ設定DATファイル
    [datFileList addObject:PROFILEDATA_DAT];
    
    BOOL bRet = YES;
    BOOL isDir;
    NSString *datFile;
    NSFileManager *fileManager = [NSFileManager defaultManager];
    for (datFile in datFileList) {
        // フルパス取得
        NSString *fullPath = [privateDocuments stringByAppendingString:datFile];
        // Library/PrivateDocuments/datFile を Documents直下に移動
        if ([fileManager fileExistsAtPath:fullPath isDirectory:&isDir] && !isDir) {
            NSString *dstFullPath = [documentsRoot stringByAppendingString:datFile];
            bRet = [fileManager moveItemAtPath:fullPath toPath:dstFullPath error:NULL];
        }
        if (!bRet) {
            DLog(@"datFileの移動に失敗しました: %@",fullPath);
        }
        
    }
    
    // V2.2以前に戻すために削除
    [fileManager removeItemAtPath:privateDocuments error:NULL];
    
    return YES;
}

@end
