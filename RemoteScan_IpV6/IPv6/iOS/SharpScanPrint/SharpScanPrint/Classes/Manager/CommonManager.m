#import "CommonManager.h"
#import "CommonUtil.h"
#import "Define.h"
#import "TIFFManager.h"
#import <QuartzCore/QuartzCore.h>					// 画面キャプチャー用
#include <mach/host_info.h>
#include <mach/mach_init.h>
#include <mach/mach_host.h>
#import <ImageIO/ImageIO.h>


@implementation CommonManager

//
// アクセサメソッドの自動合成(ゲッターとセッターの役割)
//
@synthesize baseDir;								// ファイルパス

#pragma mark -
#pragma mark class method


#pragma mark -
#pragma mark CommonManager delegete

//
// イニシャライザ定義
//
- (id)init
{
	LOG_METHOD;
	
    if ((self = [super init]) == nil)
	{
        return nil;
    }
	
	NSArray *docFolders = NSSearchPathForDirectoriesInDomains (NSDocumentDirectory, NSUserDomainMask, YES );
	self.baseDir		= [docFolders lastObject];
	
    return self;									// 初期化処理の終了した self を戻す
}

//
// アプリケーションの終了直前に呼ばれるメソッド
//
- (void)dealloc
{
	LOG_METHOD;
    
    // 親クラスの解放処理を呼び出す
}


//
// ランループ
//
- (void) myrunLoop:(uint)delayTime
{
	//
    // 現在のランループを取得する
	//
    NSRunLoop   *runLoop	= [NSRunLoop currentRunLoop];
    NSDate      *startDate	= [NSDate date];
    BOOL        isContinue	= YES;
	
    while (isContinue)
    {
        @autoreleasepool
        {
            
            // 1秒間ランループを実行する
            [runLoop runUntilDate:[NSDate dateWithTimeIntervalSinceNow:1]];
            
            // もし、delayTime秒 以上経過していたら終了する
            if ([[NSDate date] timeIntervalSinceDate:startDate] > delayTime)
            {
                isContinue = NO;
            }
            
        }
    }
}

// シャープ製の複合機から取り込まれたデータか判別します。
- (BOOL)checkPdfBySharp:(NSString *)filePath
{
    CFURLRef url = CFURLCreateWithFileSystemPath(NULL, (CFStringRef)filePath, kCFURLPOSIXPathStyle, NO);
    //パスからPDFファイルを取得
    CGPDFDocumentRef document = CGPDFDocumentCreateWithURL (url);
    if(document == NULL){
        DLog(@"高圧縮PDFファイルの取得に失敗しました。");
    }
    CFRelease(url);
    
    NSString *tagString = S_PDF_SHARP_SCANHEADER_CREATOR;//文字列"Creator"
    NSString *keyString = S_PDF_SHARP_SCANHEADER_SHARP_CAPITAL;//文字列"Sharp"
    //NSString *keyStringABBYY = @"ABBYY";
    if([self getPDFInfo:document withTag:tagString withKey:keyString] ){ //||[self getPDFInfo:document withTag:tagString withKey:keyStringABBYY]){
        CGPDFDocumentRelease(document);
        return YES;
    }else{
        CGPDFDocumentRelease(document);
        return  NO;
    }
}

// 指定された情報がPDFのヘッダ内にあるか解析します。　引数TagString：Creatorなど、取得する項目名 keyString：Sharpなど検索したい文字列
-(BOOL)getPDFInfo:(CGPDFDocumentRef)document withTag:(NSString *)tagString withKey:(NSString *)keyString
{
    BOOL isKeyFound = NO;
    const char *tagCharactors =(char *)[tagString UTF8String];
    const char *keyCharactors =(char *)[keyString UTF8String];
    CGPDFStringRef stringRef;
    //PDFファイルの情報を取得します
    CGPDFDictionaryRef info = CGPDFDocumentGetInfo(document);
    
    //infoが取得できない場合解析中止
    if(!info ){
        DLog(@"高圧縮PDFファイルのデータ取得に失敗しました");
        return NO;
    }
    BOOL isDictionaryFound = CGPDFDictionaryGetString(info, tagCharactors, &stringRef);
    //NSString *dataString = [NSString stringWithCString:(const char *)CGPDFStringGetBytePtr(stringRef) encoding:NSUTF8StringEncoding];

    //ディクショナリーがとれない場合解析中止
    if(!isDictionaryFound){
        DLog(@"高圧縮PDFファイルのデータ構造取得に失敗しました");
        return  NO;
    }
    const unsigned char * dataChar = CGPDFStringGetBytePtr(stringRef);
    if(!dataChar){
        DLog(@"高圧縮PDFファイルのデータ解析に失敗しました");
        return NO;
    }
    //取得した情報と指定文字列を照合します
    //NSRange resultRange = [dataString rangeOfString:keyString options:NSRegularExpressionSearch];//NSStringによる照合
    if(searchString((const char *)dataChar, keyCharactors)){
        DLog(@"このファイルはシャープ複合機から取り込まれた高圧縮PDFです");
        isKeyFound = YES;
    }else{
        DLog(@"データ中に指定文字列が見つかりませんでした");
    }
    return isKeyFound;
}

//const char型の文字列String1から文字列String2を検索します
char *searchString(const char *string1, const char *string2)
{
    size_t n;
    n = strlen(string2);
    while (1) {
         // string2の先頭の１文字を探す
        string1 = strchr(string1, string2[0]);
        // 見つからなければNULLを返して終わり
        if (string1 == NULL)
            return (NULL);
        // 見つかったらn文字比較
        if(strncmp(string1, string2, n) == 0)
            // 一致したらポインタを返す
            return (char *)string1;
        // ポインタを一つ進める
        string1++;
    }
}

// PDFサイズをチェックし、1ページ目の画像を生成
- (NSInteger)checkPdfSize:(NSString *)filePath
            firstPage:(UIImage**)image
{
    return [self checkPdfSize:filePath firstPage:image width:0 height:0 createImage:YES];
}

// PDFサイズをチェックし、1ページ目の画像を指定サイズで生成　(サイズ未指定の場合はオリジナルのサイズで生成)
-(NSInteger)checkPdfSize:(NSString *)filePath
               firstPage:(UIImage**)image
                   width:(int)width
                  height:(int)height
{
    return [self checkPdfSize:filePath firstPage:image width:width height:height createImage:YES];
}

// PDFサイズをチェックし、1ページ目の画像を指定サイズで生成　(サイズ未指定の場合はオリジナルのサイズで生成)
-(NSInteger)checkPdfSize:(NSString *)filePath
               firstPage:(UIImage**)image
                   width:(int)width
                  height:(int)height
             createImage:(BOOL)createImage
{
    // ディレクトリとファイル名を分割
    NSRange range = [filePath rangeOfString:@"/" options:NSCaseInsensitiveSearch | NSBackwardsSearch];
    NSString* dirPath = [filePath substringToIndex:range.location+1];
    dirPath	= [dirPath stringByReplacingOccurrencesOfString:@"/" withString:@"//"];
//    dirPath	= [dirPath stringByReplacingOccurrencesOfString:@" " withString:@"%20"];
    dirPath = [NSString stringWithFormat:@"file:/%@",dirPath];
    NSString* filename = [filePath substringFromIndex:(range.location+1)];

    // URLエンコード
    dirPath = [dirPath stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
 	CGPDFDocumentRef document;
	CFURLRef	path;
	CFURLRef	url;
    
	//
	// PDFファイルの読み込み
	//
	path	= CFURLCreateWithString( kCFAllocatorDefault, (CFStringRef)dirPath, NULL );
	url		= CFURLCreateCopyAppendingPathComponent(kCFAllocatorDefault, path, (CFStringRef)filename, false);
	CFRelease(path);
	
	document = CGPDFDocumentCreateWithURL (url);
	CFRelease(url);
    
    // 暗号化されている場合
    if(CGPDFDocumentIsEncrypted(document) && !CGPDFDocumentIsUnlocked(document))
    {
        CGPDFDocumentRelease(document);

        return CHK_PDF_ENCRYPTED_FILE;
    }
    
	// 総ページ数取得
	size_t count = CGPDFDocumentGetNumberOfPages (document);
    DLog(@"count:%tu",count);
    
    // ページ数が取得できない場合
    if(count == 0)
    {
        CGPDFDocumentRelease(document);

        return CHK_PDF_NO_VIEW_FILE;
    }
    
    // 空きメモリ容量取得
    struct vm_statistics a_vm_info;
    mach_msg_type_number_t a_count = HOST_VM_INFO_COUNT;
    host_statistics(mach_host_self(), HOST_VM_INFO,(host_info_t)&a_vm_info, &a_count);
    CGFloat activeMemory = a_vm_info.free_count * vm_page_size;

    struct host_basic_info a_host;
    mach_msg_type_number_t b_count = HOST_BASIC_INFO_COUNT;
    host_info(mach_host_self(), HOST_BASIC_INFO, (host_info_t)&a_host, &b_count);
    CGFloat maxMemory = a_host.max_mem;
    DLog(@"\n端末の搭載メモリ : %f",maxMemory);
    
    CGFloat pdfSize = 0;
    // Sharp製品から取り込まれたPDFかチェック
    if([CommonUtil IsPDFMakeFromSharp:filePath] || [CommonUtil IsCompactPDFFromSharp:filePath])
    {
        // PDFに埋め込まれている画像イメージのピクセルサイズを取得
        pdfSize = [self getImageSizeToPDF:document];
        
        activeMemory = a_vm_info.free_count * vm_page_size;
        CGFloat inactiveMemory = a_vm_info.inactive_count * vm_page_size;
        DLog(@"\n\n   activeMemory    : %f", activeMemory); // 空きメモリ
        DLog(@"\n   inactiveMemory  : %f", inactiveMemory); // 現在非使用中
        DLog(@"\n   freeMemory      : %f", ((activeMemory + inactiveMemory) * N_NUM_PDF_ACTIVEMEMORY_MAXSIZE)); // フリー
        DLog(@"\n   pdfSize         : %f", pdfSize); // ファイルサイズ

        char *c = (char *)malloc(pdfSize / N_NUM_PDF_ACTIVEMEMORY_MAXSIZE);
        
        if (c == NULL) {
            // メモリ確保に失敗
            if ((activeMemory+inactiveMemory * N_NUM_PDF_ACTIVEMEMORY_MAXSIZE) <= pdfSize)
            {
                CGPDFDocumentRelease(document);
                
                return CHK_PDF_OVER_ACTIVEMEMORY_MAXSIZE;
            }
        } else {
            // メモリ確保に成功
            strcpy(c, "");

            free(c);
            
        }
    }
    
    // Sharp製以外、または画像イメージのピクセルサイズが取得できなかった場合
    if(0 == pdfSize)
    {
        // ファイルサイズ取得
        NSFileManager* lFileManager = [NSFileManager defaultManager];
        NSError* err = nil;
        NSDictionary* attr = [lFileManager attributesOfItemAtPath:filePath error:&err];
        CGFloat fileSize = [[attr objectForKey:NSFileSize] floatValue];
        
        // 1ページの平均サイズが規定値超過の場合
        if(fileSize / count > 1024 * 1024 * N_NUM_PDF_1PAGE_MAXSIZE)
        {
            CGPDFDocumentRelease(document);
            
            return CHK_PDF_OVER_1PAGE_MAXSIZE;
        }
        // ファイルサイズが空きメモリ容量より大きい場合
        if (fileSize > activeMemory * N_NUM_PDF_ACTIVEMEMORY_MAXSIZE)
        {
            CGPDFDocumentRelease(document);
            
            return CHK_PDF_OVER_ACTIVEMEMORY_MAXSIZE;
        }
    }
    
    if(!createImage)
    {
        CGPDFDocumentRelease(document);
        return CHK_PDF_VIEW_OK;
    }
    
    // 1ページ目を読み込み
    CGPDFPageRef pageRef = CGPDFDocumentGetPage(document, 1);
    
    // Page保持
    CGPDFPageRetain(pageRef);
    
    // determine the size of the PDF page
    CGRect pageRect = CGPDFPageGetBoxRect(pageRef, kCGPDFMediaBox);
    
    // Create a low res image representation of the PDF page to display before the TiledPDFView
    // renders its content.
    UIGraphicsBeginImageContext(pageRect.size);
    
    CGContextRef context;
    if(width != 0)
    {
        CGColorSpaceRef imageColorSpace = CGColorSpaceCreateDeviceRGB();
        
        context = CGBitmapContextCreate(NULL, width, height, 8, width * 4,
                                        imageColorSpace,
                                        kCGImageAlphaPremultipliedLast);
        // 描画時に使用する拡大縮小・移動用トランスフォームのインスタンス作成
        CGContextSaveGState(context);
        
        // PDF画像の縦横サイズの指定
        CGAffineTransform pdfTransform  = CGPDFPageGetDrawingTransform(pageRef, kCGPDFMediaBox,
                                                                       CGRectMake(0, 0, width, height), 0, TRUE);
        CGContextConcatCTM(context, pdfTransform);
        
        CGColorSpaceRelease(imageColorSpace);

    }
    else
    {
        context = UIGraphicsGetCurrentContext();
        
        CGContextSaveGState(context);
        
        // 上下反転した画像になってしまうので、反転させる
        CGContextTranslateCTM(context, 0, pageRect.size.height);
        CGContextScaleCTM(context, 1, -1);
    }
    
    // 白紙のコンテキストにPDF画像を貼り付け
    CGContextDrawPDFPage(context, pageRef);
    CGContextRestoreGState(context);
    
    //
    // コンテキストからCGImageを作成
    //
    CGImageRef imgRef = CGBitmapContextCreateImage(context);
    // CGImageを元にUIImageを作成
    *image = [[UIImage alloc] initWithCGImage:imgRef];
    CGImageRelease(imgRef);
    
    UIGraphicsEndImageContext();

    if (width != 0)
    {
        CGContextRelease(context);
    }
    
    if(0 == pdfSize)
    {
        // 1ページ目のサイズを取得してバイト数計算
        pdfSize = (((((*image).size.width * (*image).size.height) * count) * 32)/8);
        DLog(@"pdfSize:%f",pdfSize);

        // 空きメモリ容量再取得
        host_statistics(mach_host_self(), HOST_VM_INFO,(host_info_t)&a_vm_info, &a_count);
        activeMemory = a_vm_info.free_count * vm_page_size;
        
        if ((activeMemory * N_NUM_PDF_ACTIVEMEMORY_MAXSIZE) <= pdfSize)
        {
            CGPDFPageRelease(pageRef);
            CGPDFDocumentRelease(document);

            return CHK_PDF_OVER_ACTIVEMEMORY_MAXSIZE;
        }
    }
    
    CGPDFPageRelease(pageRef);
    CGPDFDocumentRelease(document);

    return CHK_PDF_VIEW_OK;
}

// PDFサイズをチェックする。1ページ目の画像を生成しない
- (NSInteger)checkPdfSize:(NSString *)filePath
{
    UIImage* img = nil;
    return [self checkPdfSize:filePath firstPage:&img width:0 height:0 createImage:NO];
}
// PDFサイズをチェックする。1ページ目の画像を生成しない　(サイズ未指定の場合はオリジナルのサイズで生成)
-(NSInteger)checkPdfSize:(NSString *)filePath
                   width:(int)width height:(int)height
{
    UIImage* img = nil;
    return [self checkPdfSize:filePath firstPage:&img width:0 height:0 createImage:NO];
}

//
// 完了を知らせるメソッド
//
- (void) savingImageIsFinished:(UIImage *)_image
	  didFinishSavingWithError:(NSError *)_error
				   contextInfo:(void *)_contextInfo
{
	DLog(@"finished"); //仮にコンソールに表示する
	
	savingImag_cmpFlg = 1;			// 写真フォルダに保存・完了フラグ
}

// PDFの画像ピクセルサイズ取得
- (CGFloat)getImageSizeToPDF:(CGPDFDocumentRef)document
{
    // streamの種類
    const char *subType = NULL, *colorSpaceName;
    CGPDFInteger width = 0;
    CGPDFInteger height = 0;
    CGPDFInteger bps = 0;
    CGPDFInteger spp = 0;
    CGPDFArrayRef colorSpaceArray = NULL;
    
    // 1ページ目の情報を取得
    CGPDFPageRef pageRef = CGPDFDocumentGetPage(document, 1);

    CGPDFDictionaryRef dict = CGPDFPageGetDictionary(pageRef);
    
    CGPDFDictionaryApplyFunction(dict, ListDictionaryObjects, NULL);
 
    CGPDFStreamRef stream = [StorinhPDFStream getStream];
    CGPDFDictionaryRef dictStream = CGPDFStreamGetDictionary(stream);
    
    // streamの種別を取得
    if(!CGPDFDictionaryGetName(dictStream, "Subtype", &subType))
    {
        // 種別が取得できない場合は以降の処理を行わない
        return 0;
    }
    // 種別がImageかチェック
    if(strcmp(subType, "Image") != 0)
    {
        return 0;
    }
    // 以下のパラメータを取得。取得できない場合は以降の処理を行わない
    if(!CGPDFDictionaryGetInteger(dictStream, "Width", &width))
    {
        return 0;
    }
    if(!CGPDFDictionaryGetInteger(dictStream, "Height", &height))
    {
        return 0;
    }
    if(!CGPDFDictionaryGetInteger(dictStream, "BitsPerComponent", &bps))
    {
        return 0;
    }
        
    if(CGPDFDictionaryGetArray(dictStream, "ColorSpace", &colorSpaceArray))
    {
        spp = 3;
    }
    else if(CGPDFDictionaryGetName(dictStream, "ColorSpace", &colorSpaceName))
    {
        if(strcmp(colorSpaceName, "DeviceRGB") == 0)
        {
            spp = 3;
        }
        else if(strcmp(colorSpaceName, "DeviceCMYK") == 0)
        {
            spp = 4;
        }
        else if(strcmp(colorSpaceName, "DeviceGray") == 0 ||
                bps == 1)
        {
            spp = 1;
        }
    }
    // stream初期化
    [StorinhPDFStream setStream:NULL];

    // ピクセルサイズ取得
    return (bps * spp * width * height) / 8;
}

//
// ファイル削除
//
- (BOOL)removeFile:(NSString*)fname
{
	TRACE(@"ファイル削除[%@]", fname);
    BOOL ret = YES;
    if(nil != fname)
    {
        
	
        NSFileManager	*fileManager	= [NSFileManager defaultManager];
	
        if ([fileManager removeItemAtPath:fname error:NULL] != YES)
        {
            LOG(@"[common]removeFile:Error[%@]", fname);
            ret = NO;
        }
    }
    
	return ret;
}

//
// ファイルに保存(ディレクトリ固定)
//
- (BOOL)saveFile:(NSData*)data fileName:(NSString*)fname saveDir:(NSString *)saveDir
{
	TRACE(@"ファイルに保存[%@]", fname);
    
	BOOL ret = YES;

    NSString    *filePath   = [saveDir stringByAppendingPathComponent:[CommonUtil thumbnailPath:fname]];
	
	if ([data writeToFile:filePath atomically:YES] != YES)
	{
		LOG(@"[common]saveFile:Error[%@]", fname);
		ret = NO;
	}	
	
	return ret;
}

//
// ファイルに保存(Tempフォルダ固定)
//
- (NSString*)saveTempFile:(NSData*)data fileName:(NSString*)strFilename
{
    TRACE(@"ファイルに保存[%@]", strFilename);
    
    NSString* strFilePath = [NSString stringWithFormat:@"%@/%@", [CommonUtil tmpDir], strFilename];
    
    if ([data writeToFile:strFilePath atomically:YES] != YES)
    {
        strFilePath = nil;
	}
    return strFilePath;
}

//
// ファイル削除
//
- (BOOL)removeTempFile:(NSString*)strFilename
{
	TRACE(@"ファイル削除[%@]", strFilename);
    
	BOOL bRet = YES;
	
	NSFileManager* fileManager = [NSFileManager defaultManager];
	
    NSString* path	=[NSString stringWithFormat:@"%@/%@", [CommonUtil tmpDir], strFilename];
    
	if ([fileManager removeItemAtPath:path error:NULL] != YES)
	{
		LOG(@"[common]removeFile:Error[%@]", path);
		bRet = NO;
	}
    
	return bRet;
}

//
// ファイル移動
//
- (BOOL)moveFile:(NSString*)strFromFilename :(NSString*)strToFilename
{
	BOOL bRet = YES;
    NSError *pError;
	
	NSFileManager* fileManager = [NSFileManager defaultManager];
	    
	if ([fileManager moveItemAtPath:strFromFilename toPath:strToFilename error:&pError] != YES)
	{
		bRet = NO;
	}
    
	return bRet;
}

//
// ファイルコピー
//
- (BOOL)copyFile:(NSString*)strFromFilename :(NSString*)strToFilename
{
	BOOL bRet = YES;
    NSError *pError;
	
	NSFileManager* fileManager = [NSFileManager defaultManager];
    
	if ([fileManager copyItemAtPath:strFromFilename toPath:strToFilename error:&pError] != YES)
	{
		bRet = NO;
	}
    
	return bRet;
}

//
// ディレクトリの生成
//
- (BOOL)makeDir:(NSString*)dirName saveDir:(NSString *)saveDir
{
	
    if ([self existsFile:dirName]) return NO;
	
    NSString* path = [saveDir stringByAppendingString:@"/"];
	path=[path stringByAppendingPathComponent:dirName];
	if (![[NSFileManager defaultManager] createDirectoryAtPath:path withIntermediateDirectories:NO attributes:nil error:NULL])
	{
		DLog(@"can't make directory %@", path);
        return NO;
	}
    return YES;
}


//
//ファイル・ディレクトリが存在するかチェック
//
- (BOOL)existsFile:(NSString*)fileName
{
#if 0
	TRACE(@"ファイル・ディレクトリが存在するかチェック[%@]", fileName);
#endif
    
    NSString* path=[NSHomeDirectory() stringByAppendingPathComponent:@"Documents"];
    
	path=[path stringByAppendingPathComponent:fileName];
	
	return [[NSFileManager defaultManager] fileExistsAtPath:path];
}

//
//ファイル・ディレクトリが存在するかチェック(パス指定)
//
- (BOOL)existsFile:(NSString*)fileName :(NSString*)filePath
{
#if 0
	TRACE(@"ファイル・ディレクトリが存在するかチェック[%@]", fileName);
#endif
        
	filePath=[filePath stringByAppendingPathComponent:fileName];
	
	return [[NSFileManager defaultManager] fileExistsAtPath:filePath];
}

//
//キャッシュファイルの作成
//
- (BOOL)createCacheFile:(NSString*)dirPath filename:(NSString*)scanFilename
{
    @autoreleasepool
    {
        
        BOOL bRet = TRUE;
        
        NSString* sCacheDirName = [CommonUtil GetCacheDirName:scanFilename];
        NSString* sCacheDirPath = [dirPath stringByAppendingPathComponent:sCacheDirName];
        NSString* sScanFilePath = [dirPath stringByAppendingPathComponent:[scanFilename lastPathComponent]];
        
        // 格納先ディレクトリが既に存在する場合は、何もしない
        if([self existsCacheDirByScanFilePath:sScanFilePath])
        {
            return TRUE;
        }
        
        // 格納ディレクトリの作成
        if ([CommonUtil CreateDir:sCacheDirPath]) {
        }
        else
        {
            // ディレクトリ作成失敗
            return  TRUE;
        }
        
        // PDFかどうか　＋　（　Sharp製の複合機で取り込まれたファイルかチェック　or　シャープのコンパクトPDFかチェック　）
        if([CommonUtil pdfExtensionCheck:sScanFilePath] && ([CommonUtil IsPDFMakeFromSharp:sScanFilePath]||[CommonUtil IsCompactPDFFromSharp:sScanFilePath]))
        {
            [self pdfToJpg:sScanFilePath dirPath:sCacheDirPath isThumbnail:YES];
        }
        else if([CommonUtil tiffExtensionCheck:sScanFilePath])// tiffファイルチェック
        {
            // TIFFの場合
            @try {
                TIFFManager* tiffManager = [[TIFFManager alloc]init];
                bRet = [tiffManager splitToJpegByFilePath:sScanFilePath DestinationDirPath:sCacheDirPath];
                
                if(!bRet)
                {
                    // 失敗したらキャッシュディレクトリを削除しておく
                    [CommonUtil DeleteDir:sCacheDirPath];
                }
            }
            @catch (NSException *exception) {
                // TODO
                bRet = FALSE;
                
                // 失敗したらキャッシュディレクトリを削除しておく
                [CommonUtil DeleteDir:sCacheDirPath];
            }
            @finally {
                // TODO
            }
        }
        else if([CommonUtil jpegExtensionCheck:sScanFilePath])// jpegファイルチェック
        {
            // JPEGの場合
            // 出力した画像の縮小
            CGDataProviderRef dataProvider = CGDataProviderCreateWithFilename(strdup([sScanFilePath UTF8String]));
            NSString* cacheFilePath = [sCacheDirPath stringByAppendingPathComponent:[sScanFilePath lastPathComponent]];
            [CommonUtil OutputJpegByDataProvider:dataProvider outputFilePath:cacheFilePath maxPixelSize:1024];
            CGDataProviderRelease(dataProvider);
        }
        else if([CommonUtil pngExtensionCheck:sScanFilePath])// pngファイルチェック
        {
            
            if([CommonUtil isExistsFreeMemoryJpegConvert:sScanFilePath])
            {
                @try {
                    // 空きメモリあり
                    NSURL* url = [[NSURL alloc] initFileURLWithPath:sScanFilePath];
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
                    NSString* printFilePath = [[sCacheDirPath stringByAppendingPathComponent:@"PRINTFILE"] stringByAppendingPathComponent:[CommonUtil GetPrintFileName:sScanFilePath]];
                    NSData* data = [[NSData alloc] initWithData:UIImageJPEGRepresentation(image, 1)];
                    [data writeToFile:printFilePath atomically:YES];
                    
                    data = nil;
                    CFRelease(imgRef);
                    image = nil;
                    
                    imgRef = CGImageSourceCreateThumbnailAtIndex(imageSource, 0, options);
                    image = [UIImage imageWithCGImage:imgRef];
                    
                    // プレビュー用JPEGの生成
                    NSString* previewFilePath = [sCacheDirPath stringByAppendingPathComponent:[[[sScanFilePath lastPathComponent] stringByDeletingPathExtension] stringByAppendingPathExtension:@"jpg" ]];
                    
                    data = [[NSData alloc] initWithData:UIImageJPEGRepresentation(image, 0.8)];
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
                // 失敗したらキャッシュディレクトリを削除しておく
                [CommonUtil DeleteDir:sCacheDirPath];
                
                bRet = FALSE;
            }
        }
        
        
        return bRet;
    }
}

//
// Webページ、Email用のキャッシュファイルの作成
//
- (BOOL)createCacheFile2:(NSString*)dirPath filename:(NSString*)scanFilename
{
    @autoreleasepool
    {
        
        BOOL bRet = TRUE;
        
        NSString* sCacheDirName = [CommonUtil GetCacheDirName:scanFilename];
        NSString* sCacheDirPath = [dirPath stringByAppendingPathComponent:sCacheDirName];
        NSString* sScanFilePath = [dirPath stringByAppendingPathComponent:[scanFilename lastPathComponent]];
        
        // 格納ディレクトリの作成
        if ([CommonUtil CreateDir2:sCacheDirPath]) {
        }
        else
        {
            // ディレクトリ作成失敗
            return  TRUE;
        }
        
        if([CommonUtil pdfExtensionCheck:sScanFilePath])
        {
            [self pdfToJpg2:sScanFilePath dirPath:sCacheDirPath isThumbnail:YES];
        }
        else
        {
            // 失敗したらキャッシュディレクトリを削除しておく
            [CommonUtil DeleteDir:sCacheDirPath];
            
            bRet = FALSE;
        }
        
        
        return bRet;
    }
}

- (BOOL)pdfToJpg:(NSString*)sScanFilePath dirPath:(NSString*)sDirPath isThumbnail:(BOOL)bThumbnail
{
    return [PdfManager pdfToJpg:sScanFilePath dirPath:sDirPath isThumbnail:bThumbnail isWeb:NO];
}

// Web,Email印刷用のJPEG変換
- (BOOL)pdfToJpg2:(NSString*)sScanFilePath dirPath:(NSString*)sDirPath isThumbnail:(BOOL)bThumbnail
{
    return [PdfManager pdfToJpg:sScanFilePath dirPath:sDirPath isThumbnail:bThumbnail isWeb:YES];
}

- (BOOL)existsCacheDirByScanFilePath:(NSString*)filePath
{
	return [[NSFileManager defaultManager] fileExistsAtPath:[CommonUtil GetCacheDirByScanFilePath:filePath]];
}

- (BOOL)existsPrintFilePathByScanFilePath:(NSString*)filePath
{
	return [[NSFileManager defaultManager] fileExistsAtPath:[[CommonUtil GetCacheDirByScanFilePath:filePath] stringByAppendingPathComponent:@"PRINTFILE"]];
}

- (NSString*)getPrintFilePathByScanFilePath:(NSString*)filePath
{
    NSString* returnValue = [[[CommonUtil GetCacheDirByScanFilePath:filePath] stringByAppendingPathComponent:@"PRINTFILE"] stringByAppendingPathComponent:[filePath lastPathComponent]];
    
    if([[NSFileManager defaultManager] fileExistsAtPath:returnValue])
    {
        return returnValue;
    } else {
        return nil;
    }
}

// ボタンのフォントサイズが小さい場合は二段表示にするか判定する
- (int)changeBtnFontSize:(NSString*)lblNameText
{
    int iChangeFontSize = -1;
    for(int uFontSize = 15; uFontSize > 0 ; uFontSize--)
    {
        CGSize boundingSize = CGSizeMake(115, 60*2);
        if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
        {
            // iPad用
            boundingSize = CGSizeMake(105, 60*2);
        }
        // 指定したフォントサイズでのラベルのサイズを取得する
        CGSize labelsize = [lblNameText sizeWithFont:
                            [UIFont systemFontOfSize:uFontSize]
                                   constrainedToSize:boundingSize
                                       lineBreakMode:NSLineBreakByWordWrapping];
        DLog(@"labelsize.height = %f",labelsize.height);
        
        // 各フォントサイズで二段表示時の高さを取得した場合、そのフォントサイズを返す
        switch (uFontSize) {
            case 15:
                if(labelsize.height != 38)
                {
                    continue;
                }
                break;
                
            case 14:
                if(labelsize.height != 36)
                {
                    continue;
                }
                break;
                
            case 13:
                if(labelsize.height != 32)
                {
                    continue;
                }
                break;
                
            case 12:
                if(labelsize.height != 30)
                {
                    continue;
                }
                break;
            case 11:
                if(labelsize.height != 28)
                {
                    continue;
                }
                break;
            case 10:
                if(labelsize.height != 26)
                {
                    continue;
                }
                break;
            case 9:
                if(labelsize.height != 24)
                {
                    continue;
                }
                break;
            case 8:
                if(labelsize.height != 22)
                {
                    continue;
                }
                break;
            case 7:
                if(labelsize.height != 20)
                {
                    continue;
                }
                break;
            case 6:
                if(labelsize.height != 16)
                {
                    continue;
                }
                break;
            case 5:
                if(labelsize.height != 14)
                {
                    continue;
                }
                break;
            case 4:
                if(labelsize.height != 12)
                {
                    continue;
                }
                break;
            case 3:
                if(labelsize.height != 10)
                {
                    continue;
                }
                break;
            case 2:
                if(labelsize.height != 8)
                {
                    continue;
                }
                break;
            case 1:
                if(labelsize.height != 6)
                {
                    continue;
                }
                break;
                
            default:
                break;
        }
        
        iChangeFontSize = uFontSize;
        
        return iChangeFontSize;
    }
    return -1;
}

// ボタンを2行表示するかチェック
-(void)btnTwoLineChange:(UIButton*)btnName
{
    // 自動調整サイズを取得
    CGFloat actualFontSize;
    [btnName.titleLabel.text 
     sizeWithFont:btnName.titleLabel.font
     minFontSize:(btnName.titleLabel.minimumScaleFactor * btnName.titleLabel.font.pointSize)
     actualFontSize:&actualFontSize 
     forWidth:btnName.titleLabel.bounds.size.width 
     lineBreakMode:btnName.titleLabel.lineBreakMode];
    
    // 自動調整したフォントサイズが10以下なら、二段表示するか判定を行う
    if(actualFontSize < 11)
    {
        int iFontSize = [self changeBtnFontSize:btnName.titleLabel.text];
        if (iFontSize != -1)
        {
            DLog(@"%i",iFontSize);
            btnName.titleLabel.lineBreakMode = NSLineBreakByWordWrapping;
            btnName.titleLabel.numberOfLines = 2;
            [btnName.titleLabel setFont:[UIFont systemFontOfSize:iFontSize]];
        }
    }
}

// Web,Email印刷用ページ削除時 フォルダ内の画像ファイルをリネームする
- (void)renamingInFilepath:(NSString*)filePath
{
    NSFileManager* fileManager = [NSFileManager defaultManager];
    // フォルダのパス
    NSString *folderPath = [filePath stringByDeletingLastPathComponent];
    NSError *error;
    NSArray *cacheFiles = [fileManager contentsOfDirectoryAtPath:folderPath error:&error];
    //キャッシュフォルダの中にはPRINTFILEフォルダも含まれるため、ファイル拡張子で絞り込みを行う
    cacheFiles = [cacheFiles filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"pathExtension IN %@ or pathExtension IN %@ or pathExtension IN %@ or pathExtension IN %@", @"jpeg", @"JPG", @"jpg", @"JPEG"]];
    int count = 0;
   
    // ファイルやディレクトリの一覧を表示する
    for (NSString *baseFileName in cacheFiles) {
        NSString* baseFilePath  = [folderPath stringByAppendingPathComponent:baseFileName];
        DLog(@"baseFilePath:%@", baseFilePath);
        NSString* suffix;
        NSString* fileName;
        NSString* filePath;
        // 保存ファイル名
        suffix = [NSString stringWithFormat:@"%02d", count];
        fileName = [[[[baseFileName stringByDeletingPathExtension] substringWithRange:NSMakeRange(0, [[baseFileName stringByDeletingPathExtension] length] -2)]  stringByAppendingString:suffix] stringByAppendingPathExtension:@"jpg"];
        filePath = [folderPath stringByAppendingPathComponent:fileName];
        DLog(@"filePath:%@", filePath);
        
        if(![[NSFileManager defaultManager] fileExistsAtPath:filePath])
        {
            DLog(@"%@ -> %@", baseFileName, fileName);
            [fileManager moveItemAtPath:baseFilePath toPath:filePath error:&error];
        }
        count++;
    }
    // 確認
    NSArray *cacheFiles2 = [fileManager contentsOfDirectoryAtPath:folderPath error:&error];
    for (NSString *str in cacheFiles2) {
        DLog(@"str:%@", str);
    }
}

@end
