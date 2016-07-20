#import "PdfManager.h"

// PDF内のstreamデータ保持
@implementation StorinhPDFStream
CGPDFStreamRef stream = NULL;
CGPDFInteger width = NULL;
CGPDFInteger height = NULL;
+ (CGPDFStreamRef)getStream
{
    return stream;
}
+ (void)setStream:(CGPDFStreamRef)pStream{
    stream = pStream;
}
+ (CGPDFInteger)getWidth
{
    return width;
}
+ (void)setWidth:(CGPDFInteger)pWidth{
    width = pWidth;
}
+ (CGPDFInteger)getHeight
{
    return height;
}
+ (void)setHeight:(CGPDFInteger)pHeight{
    height = pHeight;
}


@end

@implementation PdfManager

// PDFの構造解析処理
void ListDictionaryObjects (const char *key, CGPDFObjectRef object, void *info) {
//    DLog(@"key: %s", key);
    CGPDFObjectType type = CGPDFObjectGetType(object);
    const char *subType = NULL;
    switch (type) {
        case kCGPDFObjectTypeDictionary:{
            // Dictionaryの場合は再解析
            CGPDFDictionaryRef objectDictionary;
            if (CGPDFObjectGetValue(object, kCGPDFObjectTypeDictionary, &objectDictionary)) {
                CGPDFDictionaryApplyFunction(objectDictionary, ListDictionaryObjects, NULL);
            }
        }
            break;
        case kCGPDFObjectTypeStream: {
            // streamの場合はstreamのdictionaryを取得
            CGPDFStreamRef stream;
            // 取得済みの場合は再取得しない
            if(NULL == [StorinhPDFStream getStream])
            {
                if(CGPDFObjectGetValue(object, kCGPDFObjectTypeStream, &stream))
                {
                    CGPDFDictionaryRef streamDictionary = CGPDFStreamGetDictionary(stream);
                    if (streamDictionary) {
                        // streamのdictionaryからsubtypeが取得できる場合はstreamを保持
                        if(CGPDFDictionaryGetName(streamDictionary, "Subtype", &subType))
                        {
                            [StorinhPDFStream setStream:stream];
                            
                        }
                    }
                }
            }
        }
            break;
            
        default:
            break;
            
    }}

// PDFの構造解析処理（WidthとHeightを取得）
void ListDictionaryObjectsGetSize (const char *key, CGPDFObjectRef object, void *info) {
    CGPDFObjectType type = CGPDFObjectGetType(object);
    switch (type) {
        case kCGPDFObjectTypeInteger:{
            if([[NSString stringWithCString:key encoding:NSUTF8StringEncoding] isEqualToString:@"Width"])
            {
                CGPDFInteger width;
                CGPDFObjectGetValue(object, kCGPDFObjectTypeInteger, &width);
                [StorinhPDFStream setWidth:width];
            } else if([[NSString stringWithCString:key encoding:NSUTF8StringEncoding] isEqualToString:@"Height"])
            {
                CGPDFInteger height;
                CGPDFObjectGetValue(object, kCGPDFObjectTypeInteger, &height);
                [StorinhPDFStream setHeight:height];
            }
        }
            break;
        default:
            break;
    }
}

+ (BOOL)pdfToJpg:(NSString*)sScanFilePath dirPath:(NSString*)sDirPath isThumbnail:(BOOL)bThumbnail isWeb:(BOOL)bWeb
{
    BOOL bRet = TRUE;
    // Sharp製MFPから取り込まれたPDFの場合
    @try {
        // PDFファイルの読み込み
        CFURLRef url = CFURLCreateWithFileSystemPath(NULL, (CFStringRef)sScanFilePath, kCFURLPOSIXPathStyle, NO);
        
        CGPDFDocumentRef document = CGPDFDocumentCreateWithURL (url);
        
        // 暗号化されている場合
        if(CGPDFDocumentIsEncrypted(document) && !CGPDFDocumentIsUnlocked(document))
        {
            bRet = FALSE;
        }
        
        if(bRet)
        {
            NSInteger nNumberOfPages = CGPDFDocumentGetNumberOfPages(document);
            for(int i = 0; i < nNumberOfPages; i++)
            {
                DLog(@"pdfToJpg  %d/%ld",i,(long)nNumberOfPages);
                @autoreleasepool
                {
                    
                    if (!document) {
                        document = CGPDFDocumentCreateWithURL (url);
                    }
                    
                    //指定ページの情報を取得
                    CGPDFPageRef pageRef = CGPDFDocumentGetPage(document, i+1);
                    
                    CGPDFDictionaryRef dict = CGPDFPageGetDictionary(pageRef);
                    //PDF解析
                    CGPDFDictionaryApplyFunction(dict, ListDictionaryObjects, NULL);
                    
                    CGPDFStreamRef stream = [StorinhPDFStream getStream];
                    CGPDFDictionaryRef dictStream = CGPDFStreamGetDictionary(stream);
                    
                    // streamの種別を取得
                    const char *subType = NULL;
                    if(!CGPDFDictionaryGetName(dictStream, "Subtype", &subType))
                    {
                        // 種別が取得できない場合は以降の処理を行わない
                        bRet = FALSE;
                        break;
                    }
                    // 種別がImageかチェック
                    if(strcmp(subType, "Image") != 0)
                    {
                        bRet = FALSE;
                        break;
                    }
                    
                    //PDFのFormat取得
                    CGPDFDataFormat format;
                    CFDataRef imageDataRef = CGPDFStreamCopyData(stream, &format);
                    
                    CommonManager* commonManager = [[CommonManager alloc] init];
                    NSInteger checkcode = 0;
                    if (! bWeb) { // メール、web印刷以外はメモリーチェック
                        checkcode = [commonManager checkPdfSize:sScanFilePath];
                        
                        if (checkcode != 0) {
                            // 表示できないので
                            bRet = FALSE;
                            break;
                        }
                    }
                    if (bThumbnail) {
                        // 保存ファイル名
                        
                        NSString* suffix;
                        NSString* fileName;
                        NSString* filePath;
                        if(bWeb)
                        {
                            //同じ名前のファイルが見つからなくなるまでファイル名の末尾をインクリメントする
                            for(int count = i ;count < 10000 ; count++)
                            {
                                // 保存ファイル名
                                suffix = [NSString stringWithFormat:@"%03d", count];
                                fileName = [[@"preview" stringByAppendingString:suffix] stringByAppendingPathExtension:@"jpg"];
                                filePath = [sDirPath stringByAppendingPathComponent:fileName];
                                if(![[NSFileManager defaultManager] fileExistsAtPath:filePath])
                                {
                                    break;
                                }
                            }
                        } else {
                            suffix = [NSString stringWithFormat:@"%03d", i];
                            fileName = [[@"preview" stringByAppendingString:suffix] stringByAppendingPathExtension:@"jpg"];
                            filePath = [sDirPath stringByAppendingPathComponent:fileName];
                        }
                        
                        //サイズ取得
                        CGRect pageRect = CGPDFPageGetBoxRect(pageRef, kCGPDFMediaBox);
                        CGFloat pdfScale = 1.0;
                        pageRect.size = CGSizeMake(pageRect.size.width*pdfScale, pageRect.size.height*pdfScale);
                        
                        //フォーマットが画像で、高圧縮PDF以外の場合
                        if (!bWeb && format != CGPDFDataFormatRaw && ![CommonUtil IsCompactPDFFromSharp:sScanFilePath])
                        {
                            CGDataProviderRef dataProvider = CGDataProviderCreateWithCFData(imageDataRef);
                            //ファイル保存
                            [CommonUtil OutputJpegByDataProvider:dataProvider outputFilePath:filePath maxPixelSize:1024];
                            CGDataProviderRelease(dataProvider);
                            
                            // 出力ファイルのサイズをチェックし、0バイトの場合は削除
                            NSFileManager *fileManager = [NSFileManager defaultManager];
                            NSDictionary* fileAttributes = [fileManager attributesOfItemAtPath:filePath error:nil];
                            if (fileAttributes.fileSize == 0) {
                                [fileManager removeItemAtPath:filePath error:nil];
                            }
                        }
                        else if(!bWeb && [CommonUtil IsCompactPDFFromSharp:sScanFilePath] && checkcode != CHK_PDF_VIEW_OK)
                        {
                            // 高圧縮でメモリ不足になる可能性があるためJPEG化はしない
                            break;
                        }
                        //フォーマットが画像以外の場合はサムネイルが取得できないため、該当ページの情報を描画して保存
                        else
                        {
                            if (!bWeb && [CommonUtil IsCompactPDFFromSharp:sScanFilePath] && (pageRect.size.width *  pageRect.size.height) >
                                N_COMPACT_PDF_A3_SIZE)
                            {
                                // 高圧縮で画像のサイズがA4以上の場合は、出力しない
                                break;
                            }

                            // renders its content.
                            UIGraphicsBeginImageContext(pageRect.size);
                            
                            CGContextRef context = UIGraphicsGetCurrentContext();
                            // First fill the background with white.
                            CGContextSetRGBFillColor(context, 1.0,1.0,1.0,1.0);
                            CGContextFillRect(context,pageRect);
                            CGContextSaveGState(context);
                            // Flip the context so that the PDF page is rendered
                            // right side up.
                            CGContextTranslateCTM(context, 0.0, pageRect.size.height);
                            CGContextScaleCTM(context, 1.0, -1.0);
                            
                            // Scale the context so that the PDF page is rendered
                            // at the correct size for the zoom level.
                            CGContextScaleCTM(context, pdfScale,pdfScale);
                            //CGContextRotateCTM(context, -M_PI);
                            CGContextDrawPDFPage(context, pageRef);
                            CGContextRestoreGState(context);
                            
                            // コンテキストからCGImageを作成
                            CGImageRef imgRef = CGBitmapContextCreateImage(context);
                            UIGraphicsEndImageContext();
                            
                            //ファイル保存
                            NSData *data = [[NSData alloc] initWithData:UIImageJPEGRepresentation([UIImage imageWithCGImage:imgRef], 0.8)];
                            [data writeToFile:filePath atomically:YES];
                            
                            CGImageRelease(imgRef);
                            CGPDFDocumentRelease(document);
                            document = nil;
                        }
                        
                        CFRelease(imageDataRef);
                        // stream初期化
                        stream = NULL;
                        [StorinhPDFStream setStream:NULL];
                    }
                }
            }
        }
        
        if (document) {
            CGPDFDocumentRelease(document);
        }
        
        CFRelease(url);
        
        if(!bRet)
        {
            // 失敗したらキャッシュディレクトリを削除しておく
            [CommonUtil DeleteDir:sDirPath];
        }
    }
    @catch (NSException *exception) {
        // TODO
        bRet = FALSE;
        
        // 失敗したらキャッシュディレクトリを削除しておく
        [CommonUtil DeleteDir:sDirPath];
    }
    @finally {
        // TODO
    }
    
    return bRet;
}

+ (NSString*)drawJpgToData:(NSString*)sScanFilePath pageRef:(CGPDFPageRef*)pageRef pegeNumber:(int)pageNum dirPath:(NSString*)sDirPath
{
    CGPDFDictionaryRef dict = CGPDFPageGetDictionary(*pageRef);
    //PDF解析
    CGPDFDictionaryApplyFunction(dict, ListDictionaryObjects, NULL);
    
    CGPDFStreamRef stream = [StorinhPDFStream getStream];
    
    CGPDFDataFormat format;
    CFDataRef imageDataRef = CGPDFStreamCopyData(stream, &format);
    int checkcode = 0;
    
    // 保存ファイル名
    NSString* suffix;
    NSString* fileName;
    NSString* filePath;
    
    suffix = [NSString stringWithFormat:@"%03d", pageNum];
    fileName = [[[[sScanFilePath lastPathComponent] stringByDeletingPathExtension] stringByAppendingString:suffix] stringByAppendingPathExtension:@"jpg"];
    filePath = [sDirPath stringByAppendingPathComponent:fileName];
    
    //メディアボックスからサイズ取得
    CGRect pageRect = CGPDFPageGetBoxRect(*pageRef, kCGPDFMediaBox);
    
    int longerSide = pageRect.size.height;
    if(pageRect.size.width > pageRect.size.height){
        longerSide = pageRect.size.width;
    }
    int pdfScale = S_PDF_SHARP_RAWPRINT_THRESHOLD / longerSide;
    if(pdfScale == 0){
        pdfScale = 1;
    }
    pageRect.size = CGSizeMake(pageRect.size.width*pdfScale, pageRect.size.height*pdfScale);
    if([CommonUtil IsCompactPDFFromSharp:sScanFilePath] && checkcode != CHK_PDF_VIEW_OK)
    {
        // 高圧縮でメモリ不足になる可能性があるためJPEG化はしない
        return NULL;
    }
    //ページ情報からコンテクストに描画する
    else
    {
        // renders its content.
        UIGraphicsBeginImageContext(pageRect.size);
        
        CGContextRef context = UIGraphicsGetCurrentContext();
        // First fill the background with white.
        CGContextSetRGBFillColor(context, 1.0,1.0,1.0,1.0);
        CGContextFillRect(context,pageRect);
        CGContextSaveGState(context);
        // Flip the context so that the PDF page is rendered
        // right side up.
        CGContextTranslateCTM(context, 0.0, pageRect.size.height);
        CGContextScaleCTM(context, 1.0, -1.0);
        
        // Scale the context so that the PDF page is rendered
        // at the correct size for the zoom level.
        CGContextScaleCTM(context, pdfScale,pdfScale);
        //CGContextRotateCTM(context, -M_PI);
        CGContextDrawPDFPage(context, *pageRef);
        CGContextRestoreGState(context);
        
        // コンテクストからCGImageを作成
        CGImageRef imgRef = CGBitmapContextCreateImage(context);
        UIGraphicsEndImageContext();
        
        //ファイル保存
        NSData *data = [[NSData alloc] initWithData:UIImageJPEGRepresentation([UIImage imageWithCGImage:imgRef], 0.8)];
        [data writeToFile:filePath atomically:YES];
        CGImageRelease(imgRef);
    }
    CFRelease(imageDataRef);
    
    return filePath;
}

+ (BOOL)pdfToRawImage:(NSString*)sScanFilePath dirPath:(NSString*)sDirPath isThumbnail:(BOOL)bThumbnail isWeb:(BOOL)bWeb arrWidth:(NSMutableArray*)arrWidth arrHeight:(NSMutableArray*)arrHeight outputfilepath:(NSMutableArray*) outputfiles fileExtention:(NSMutableArray*)fileExtentions
{
    BOOL bRet = TRUE;
    // Sharp製MFPから取り込まれたPDFの場合
    @try {
        // PDFファイルの読み込み
        CFURLRef url = CFURLCreateWithFileSystemPath(NULL, (CFStringRef)sScanFilePath, kCFURLPOSIXPathStyle, NO);
        
        CGPDFDocumentRef document = CGPDFDocumentCreateWithURL (url);
        
        // 暗号化されている場合
        if(CGPDFDocumentIsEncrypted(document) && !CGPDFDocumentIsUnlocked(document))
        {
            bRet = FALSE;
        }
        
        if(bRet)
        {
            NSInteger nNumberOfPages = CGPDFDocumentGetNumberOfPages(document);
            for(int i = 0; i < nNumberOfPages; i++)
            {
                @autoreleasepool
                {
                    
                    if (!document) {
                        document = CGPDFDocumentCreateWithURL (url);
                    }
                    
                    //指定ページの情報を取得
                    CGPDFPageRef pageRef = CGPDFDocumentGetPage(document, i+1);
                    
                    CGPDFDictionaryRef dict = CGPDFPageGetDictionary(pageRef);
                    //PDF解析
                    CGPDFDictionaryApplyFunction(dict, ListDictionaryObjects, NULL);
                    
                    CGPDFStreamRef stream = [StorinhPDFStream getStream];
                    CGPDFDictionaryRef dictStream = CGPDFStreamGetDictionary(stream);
                    
                    // streamの種別を取得
                    const char *subType = NULL;
                    if(!CGPDFDictionaryGetName(dictStream, "Subtype", &subType))
                    {
                        // 種別が取得できない場合は以降の処理を行わない
                        bRet = FALSE;
                        break;
                    }
                    // 種別がImageかチェック
                    if(strcmp(subType, "Image") != 0)
                    {
                        bRet = FALSE;
                        break;
                    }
                    
                    // PDFの構造解析処理（WidthとHeightを取得）
                    CGPDFDictionaryApplyFunction(dictStream, ListDictionaryObjectsGetSize, NULL);
                    
                    CGPDFInteger width = [StorinhPDFStream getWidth];
                    CGPDFInteger height = [StorinhPDFStream getHeight];
                    [arrWidth addObject:[NSString stringWithFormat:@"%zd",width]];
                    [arrHeight addObject:[NSString stringWithFormat:@"%zd",height]];
                    
                    //PDFのFormat取得
                    CGPDFDataFormat format;
                    CFDataRef imageDataRef = CGPDFStreamCopyData(stream, &format);
                    
                    if (bThumbnail) {
                        // 保存ファイル名
                        
                        NSString* suffix;
                        NSString* fileName;
                        NSString* filePath;
                        NSString* fileExtention;
                        
                        //フォーマットが画像の場合
                        if (format != CGPDFDataFormatRaw)
                        {
                            fileExtention = @"jpeg";
                        }
                        //フォーマットが画像以外の場合はサムネイルが取得できないため、該当ページの情報を描画して保存
                        else
                        {
                            fileExtention = @"raw";
                        }
                        [fileExtentions addObject:fileExtention];
                        
                        
                        if(bWeb)
                        {
                            //同じ名前のファイルが見つからなくなるまでファイル名の末尾をインクリメントする
                            for(int count = i ;count < 10000 ; count++)
                            {
                                // 保存ファイル名
                                suffix = [NSString stringWithFormat:@"%03d", count];
                                fileName = [[[[sScanFilePath lastPathComponent] stringByDeletingPathExtension] stringByAppendingString:suffix] stringByAppendingPathExtension:fileExtention];
                                filePath = [sDirPath stringByAppendingPathComponent:fileName];
                                // 印刷対象のファイルパスを配列に格納する
                                [outputfiles addObject:filePath];
                                
                                if(![[NSFileManager defaultManager] fileExistsAtPath:filePath])
                                {
                                    break;
                                }
                            }
                        } else if(format == CGPDFDataFormatRaw ){
                            //フォーマットがRAWのときそのまま渡します
                            suffix = [NSString stringWithFormat:@"%03d", i];
                            fileName = [[[[sScanFilePath lastPathComponent] stringByDeletingPathExtension] stringByAppendingString:suffix] stringByAppendingPathExtension:fileExtention];
                            filePath = [sDirPath stringByAppendingPathComponent:fileName];
                            // 印刷対象のファイルパスを配列に格納する
                            [outputfiles addObject:filePath];
                        } else {
                            if([CommonUtil IsCompactPDFFromSharp:sScanFilePath]){
                                //PDF1.4（高圧縮）のとき書き出してJPGファイルを作ります
                                [outputfiles addObject:[self drawJpgToData:sScanFilePath pageRef:&pageRef pegeNumber:i dirPath:sDirPath]];
                            }
                            else{
                                // PDFからJpegファイルを作ります
                                CGPDFDictionaryApplyFunction(dictStream, ListDictionaryObjectsGetSize, NULL);
                                CGDataProviderRef dataProvider = CGDataProviderCreateWithCFData(imageDataRef);
                                UIImage* image = [CommonUtil GetUIImageByDataProvider:dataProvider maxPixelSize:width*height];
                                image = [UIImage imageWithCGImage:image.CGImage scale:image.scale orientation:UIImageOrientationUp];
                                NSData  *data = [[NSData alloc] initWithData:UIImageJPEGRepresentation(image, 0.8)];
                                
                                suffix = [NSString stringWithFormat:@"%03d", i];
                                fileName = [[[[sScanFilePath lastPathComponent] stringByDeletingPathExtension] stringByAppendingString:suffix] stringByAppendingPathExtension:fileExtention];
                                filePath = [sDirPath stringByAppendingPathComponent:fileName];
                                //ファイル保存
                                [data writeToFile:filePath atomically:YES];
                                // 印刷対象のファイルパスを配列に格納する
                                [outputfiles addObject:filePath];
    
                            }
                        }
                        [[NSFileManager defaultManager]createFileAtPath: filePath contents:nil attributes:nil];
                        NSFileHandle* fileHandleForImage = [NSFileHandle fileHandleForWritingAtPath:filePath];
                        [fileHandleForImage writeData:(__bridge NSData*)imageDataRef];
                        
                        CFRelease(imageDataRef);
                        // stream初期化
                        stream = NULL;
                        [StorinhPDFStream setStream:NULL];
                    }
                }
            }
        }
        
        if (document) {
            CGPDFDocumentRelease(document);
        }
        
        CFRelease(url);
        
        if(!bRet)
        {
            // 失敗したらキャッシュディレクトリを削除しておく
            [CommonUtil DeleteDir:sDirPath];
        }
    }
    @catch (NSException *exception) {
        bRet = FALSE;
        
        // 失敗したらキャッシュディレクトリを削除しておく
        [CommonUtil DeleteDir:sDirPath];
    }
    @finally {
    }
    
    return bRet;
}

@end
