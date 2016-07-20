
#import "TIFFManager.h"
#import "CommonUtil.h"
#import <ImageIO/ImageIO.h>


@implementation TIFFManager

NSFileHandle* handle;

int numberOfPages = 0;
int firstIFDOffset = 0;
Byte sizeOfTypes[13] = {0,1,1,2,4,8,1,1,2,4,8,4,8};

NSMutableArray* aIFD;

NSString* scanFilePath;
NSString* destFolder;
NSString* outputFileName;

- (BOOL)splitToJpegByFilePath:(NSString*)strScanFilePath DestinationDirPath:(NSString*) strDestinationDir
{
    return [self splitToJpegByFilePath:strScanFilePath DestinationDirPath:strDestinationDir isThumbnail:TRUE];
}

- (BOOL)splitToJpegByFilePath:(NSString*)strScanFilePath DestinationDirPath:(NSString*) strDestinationDir isThumbnail:(BOOL)bThumbnail;
{
    BOOL bRet = TRUE;
    
    @try {
        aIFD = [[NSMutableArray alloc]init];
        
        scanFilePath = strScanFilePath;
        destFolder = strDestinationDir;
        outputFileName = [strScanFilePath lastPathComponent];
        
        m_bThumbnail = bThumbnail;
        
        NSMutableArray* outputfiles = [[NSMutableArray alloc]init];
        
        [self splitToJpeg:outputfiles];
        
        if ([outputfiles count] == 0) {
            bRet = FALSE;
        }
    }
    @catch (NSException *exception) {
        bRet = FALSE;
    }
    @finally {
    }
    
    return  bRet;
}

-(BOOL)isCompressionJpg:(NSString*)strScanFilePath
{
    BOOL bRet = TRUE;
    
    @try {
        aIFD = [[NSMutableArray alloc]init];
        
        scanFilePath = strScanFilePath;
        //読み込み
        bRet = [self readTIFF];
        if(bRet)
        {
            for(int i = 0; i < MIN(numberOfPages, 999); i++)
            {
                TiffIfd* ifd = [aIFD objectAtIndex:i];
                //画像形式でないページが1ページでも含まれていたらFALSE
                if (ifd.nCompression != 7) {
                    bRet = FALSE;
                    break;
                }
            }
        }
    }
    @catch (NSException *exception) {
        bRet = FALSE;
    }
    @finally {
    }
    
    return  bRet;
}

-(BOOL) readTIFF
{
    handle = [NSFileHandle fileHandleForReadingAtPath:scanFilePath];
    
    // 巻き戻す
    [handle seekToFileOffset:0];
    
    // ページ数を数える
    numberOfPages = [self getNumberOfPages];
    
    // 1ページより小さい場合は
    if(numberOfPages < 1)
    {
        return FALSE;
    }
    
    // 巻き戻す
    [handle seekToFileOffset:0];
    
    // ヘッダを読む
    if([self readHeader] == FALSE)
    {
        return FALSE;
    }
    
    // 最初のIFDを読み込む
    TiffIfd* ifd = [[TiffIfd alloc]init];
    int nextOffset = [self readIFD:[self readIntValue:4] :ifd];
    if (![self checkIFD:ifd]) {
        // SplitByteCountが不正な場合
        return FALSE;
    }
    
    [aIFD addObject:ifd];
    
    // 残りのIFDを読み込む
    for(int i = 1; i < numberOfPages; i++)
    {
        ifd = [[TiffIfd alloc]init];
        nextOffset = [self readIFD:nextOffset  :ifd];
        if (![self checkIFD:ifd]) {
            // SplitByteCountが不正な場合
            return FALSE;
        }
        [aIFD addObject:ifd];
    }
    
    [handle closeFile];
    
    return TRUE;
}

-(BOOL) readHeader
{
    // エンディアン読み込み
    for(int i = 0; i < 2; i++)
    {
        NSData* byteEndian = [handle readDataOfLength:1];
        NSString * byteEncodeString = [[NSString alloc] initWithData:byteEndian encoding:NSASCIIStringEncoding];
        
        if (![byteEncodeString isEqual:@"I"]) {
            return YES;
        }
    }
    
    // TIFF マーカ読み込み
    int nMarker = [self readShortValue:2];
    
    // TIFFのマジックナンバー(42)かどうかチェック
    if(nMarker != 42)
    {
        return NO;
    }
    
    // IDF へのオフセット読み込み
    firstIFDOffset = [self readIntValue:4];
    
    return true;
    
}

-(int) splitToJpeg:(NSMutableArray*) outputFiles
{
    BOOL bReturn = NO;
    int nResult = -9999;
    
    bReturn = [self readTIFF];
    if(bReturn != YES)
    {
        // ファイルの読み込みに失敗
        return -1;
    }
    
    NSString* pstrPathExtension = @".jpg";
    if (!m_bThumbnail) {
        pstrPathExtension = @".tif";
    }
    
    for(int i = 0; i < MIN(numberOfPages, 999); i++)
    {
        DLog(@"splitToJpeg  %d/%d",i,numberOfPages);
        @autoreleasepool
        {
            NSString* suffix = [NSString stringWithFormat:@"%03d", i];
            
            NSString* fileName = [destFolder stringByAppendingPathComponent:@"preview"];
            fileName = [[fileName stringByAppendingString:suffix] stringByAppendingString:pstrPathExtension];

            bReturn = [self writeJpeg:fileName :[aIFD objectAtIndex:i] :i];
            if(bReturn == true)
            {
                [outputFiles addObject:fileName];
            }
        }
    }
    
    nResult = (int)[outputFiles count];
    
    return nResult;
}

-(BOOL) writeJpeg:(NSString*)strJpeg :(TiffIfd*)tiffIFD :(int)nPageNumbser
{
    int buff = 128*1024;
    if (!m_bThumbnail) {
        buff = tiffIFD.nImageLength * tiffIFD.nImageWidth;
    }
    
    if(tiffIFD.nCompression != 7)
    {
        if (m_bThumbnail) {
            // Jpeg 圧縮でない場合は画像抽出を試みる
            return [CommonUtil OutputJpegByUrl:scanFilePath outputFilePath:strJpeg maxPixelSize:1024 pageNumber:nPageNumbser];
        }
        
        @autoreleasepool
        {
            //オリジナルのファイルを取得
            handle = [NSFileHandle fileHandleForReadingAtPath:scanFilePath];
            //読み込み開始位置を設定
            [handle seekToFileOffset:0];
            
            NSMutableData* pData = [NSMutableData data];
            int nNewIfdOffset = 8;
            //ファイルヘッダ追加
            [pData appendData:[handle readDataOfLength:nNewIfdOffset]];
            while (TRUE) {
                //読み込み位置を各ページのデータの先頭に移動
                [handle seekToFileOffset:tiffIFD.nIfdOffset];
                //各ページごとのIFD追加
                [pData appendData:[handle readDataOfLength:tiffIFD.nIfdByteCounts - nNewIfdOffset]];
                
                //読み込み位置をIFDデータ先頭に移動
                [handle seekToFileOffset:tiffIFD.nIfdOffset + 2];
                for(int i = 0; i < tiffIFD.nNumberOfDirectoryEntry; i++)
                {
                    //タグ取得
                    NSData* byteTagID = [handle readDataOfLength:2];
                    int tagID = [self shortValue:byteTagID];
                    // タイプの読み込み
                    NSData* byteFieldType = [handle readDataOfLength:2];
                    int tagType = [self shortValue:byteFieldType];
                    // 値の数の読み込み
                    NSData* byteNumberOfValues = [handle readDataOfLength:4];
                    int nNumberOfValues = [self intValue:byteNumberOfValues];
                    // Offset の読み込み
                    NSData* byteOffset = [handle readDataOfLength:4];
                    int nOffSet = [self intValue:byteOffset];
                    //タグ情報が格納されているバイト数を算出
                    int bytesInField = sizeOfTypes[tagType] * nNumberOfValues;
                    
                    //タグがStripOffsetsの場合
                    if (tagID == 273 || bytesInField > 4)
                    {
                        //データポインタ更新
                        int nNewOffSet = nOffSet - tiffIFD.nIfdOffset + nNewIfdOffset;
                        Byte* buffer = (Byte *)malloc(4);
                        buffer[3] = (nNewOffSet >> 24) & 255;
                        buffer[2] = (nNewOffSet >> 16) & 255;
                        buffer[1] = (nNewOffSet >> 8) & 255;
                        buffer[0] = nNewOffSet & 255;
                        
                        NSInteger nPoint = [handle offsetInFile] - 4 - tiffIFD.nIfdOffset + nNewIfdOffset;
                        
                        [pData replaceBytesInRange:NSMakeRange(nPoint, 4) withBytes:buffer];
                        free(buffer);
                    }
                }
                //読み込み位置をデータの先頭に移動
                [handle seekToFileOffset:tiffIFD.nStripOffset];
                //１ページ分のデータを読み込み
                int readSize = MIN(buff, tiffIFD.nStripByteCounts);
                [pData appendData:[handle readDataOfLength:readSize]];
                
                if([handle offsetInFile] >= (tiffIFD.nStripByteCounts + tiffIFD.nIfdByteCounts))
                {
                    break;
                }
            }
            //出力ファイルに書き込む
            [pData writeToFile:strJpeg atomically:YES];
            //オリジナルファイルから読み込んだ情報を解放
            [handle closeFile];
        }
    }
    else
    {
        //出力ファイルパスにファイルを生成
        [[NSFileManager defaultManager] createFileAtPath:strJpeg contents:nil attributes:nil];
        
        @autoreleasepool
        {
            //ファイル出力用ハンドラ定義
            NSFileHandle * outputHandle = [NSFileHandle fileHandleForWritingAtPath:strJpeg];
            //オリジナルのファイルを取得
            handle = [NSFileHandle fileHandleForReadingAtPath:scanFilePath];
            //読み込み開始位置を設定
            [handle seekToFileOffset:tiffIFD.nStripOffset];
            
            NSInteger endPosition = [handle offsetInFile] + tiffIFD.nStripByteCounts;
            
            while (TRUE) {
                //１ページ分のデータを読み込み、出力ファイルに書き込む
                NSInteger readSize = MIN(buff, endPosition - [handle offsetInFile]);
                [outputHandle writeData:[handle readDataOfLength:readSize]];
                
                if([handle offsetInFile] >= endPosition)
                {
                    //オリジナルファイルから読み込んだ情報を解放
                    [handle closeFile];
                    [outputHandle closeFile];
                    break;
                }
            }
            //オリジナルファイルから読み込んだ情報を解放
            [handle closeFile];
            [outputHandle closeFile];
        }
    }
    
    //サムネイル出力の場合
    if (m_bThumbnail) {
        // 出力した画像の縮小
        CGDataProviderRef dataProvider = CGDataProviderCreateWithFilename(strdup([strJpeg UTF8String]));
        
        // 回転を考慮
        switch (tiffIFD.nOrientation) {
            case 2:
                // 画像は左右反対に保存
                [CommonUtil OutputJpegByDataProviderWithOrientation:dataProvider outputFilePath:strJpeg maxPixelSize:1024 orientation:UIImageOrientationUpMirrored];
                break;
            case 3:
                // 画像は上下・左右反対に保存
                [CommonUtil OutputJpegByDataProviderWithOrientation:dataProvider outputFilePath:strJpeg maxPixelSize:1024 orientation:UIImageOrientationDown];
                break;
            case 4:
                // 画像は上下反対に保存
                [CommonUtil OutputJpegByDataProviderWithOrientation:dataProvider outputFilePath:strJpeg maxPixelSize:1024 orientation:UIImageOrientationDownMirrored];
                break;
            case 5:
                // 画像は90度左回転して左右反対に保存
                [CommonUtil OutputJpegByDataProviderWithOrientation:dataProvider outputFilePath:strJpeg maxPixelSize:1024 orientation:UIImageOrientationLeftMirrored];
                break;
            case 6:
                // 画像は90度左回転して保存
                [CommonUtil OutputJpegByDataProviderWithOrientation:dataProvider outputFilePath:strJpeg maxPixelSize:1024 orientation:UIImageOrientationRight];
                break;
            case 7:
                //　画像は90度右回転して左右反対に保存
                [CommonUtil OutputJpegByDataProviderWithOrientation:dataProvider outputFilePath:strJpeg maxPixelSize:1024 orientation:UIImageOrientationRightMirrored];
                break;
            case 8:
                // ?????
                [CommonUtil OutputJpegByDataProviderWithOrientation:dataProvider outputFilePath:strJpeg maxPixelSize:1024 orientation:UIImageOrientationLeft];
                break;
            case 0:
            case 1:
            default:
                [CommonUtil OutputJpegByDataProviderWithOrientation:dataProvider outputFilePath:strJpeg maxPixelSize:1024 orientation:UIImageOrientationUp];
                break;
        }
        CGDataProviderRelease(dataProvider);
    }
    
    return YES;
}

-(BOOL) checkIFD:(TiffIfd*)srcIFD
{
    //    DLog(@"%d", [srcIFD.tags count]);
    
    for(TiffTag* tag in srcIFD.tags)
    {
        //        DLog(@"%d %d", tag.tagID, tag.nOffSet);
        switch (tag.tagID) {
            case 278:
                srcIFD.nRowsPerStrip = tag.nOffSet;
                break;
            case 273:
                srcIFD.nStripOffset = tag.nOffSet;
                break;
            case 279:
                if (tag.nOffSet == 0) {
                    return false;
                }
                srcIFD.nStripByteCounts = tag.nOffSet;
                break;
            case 256:
                srcIFD.nImageWidth = tag.nOffSet;
                break;
            case 257:
                srcIFD.nImageLength = tag.nOffSet;
                break;
            case 259:
                srcIFD.nCompression = tag.nOffSet;
                break;
            case 274:
                srcIFD.nOrientation = tag.nOffSet;
                break;
            case 282:
                srcIFD.nXResolusion = tag.nOffSet;
                srcIFD.nXResolusionMolecule = [self readIntValue:srcIFD.nXResolusion];
                srcIFD.nXResolusionDenominator = [self readIntValue:(srcIFD.nXResolusion + 4)];
                break;
            case 283:
                srcIFD.nYResolusion = tag.nOffSet;
                srcIFD.nYResolusionMolecule = [self readIntValue:srcIFD.nYResolusion];
                srcIFD.nYResolusionDenominator = [self readIntValue:(srcIFD.nYResolusion + 4)];
                break;
            default:
                break;
        }
    }
    return true;
}


-(int) readIFD:(int)offset :(TiffIfd*)ifd
{
    int nNextIFDOffset = 0;
    int nIfdByteCounts = 0;
    
    ifd.nIfdOffset = offset;
    ifd.nNumberOfDirectoryEntry = [self readShortValue:offset];
    
    // タグを読み込む
    for(int i = 0; i < ifd.nNumberOfDirectoryEntry; i++)
    {
        TiffTag* tag = [[TiffTag alloc]init];
        [self readTag:[handle offsetInFile] :tag :&nIfdByteCounts];
        [ifd.tags addObject:tag];
    }
    
    //    DLog(@"%d", [ifd.tags count]);
    
    ifd.nIfdByteCounts = nIfdByteCounts + (8 + 2 + ifd.nNumberOfDirectoryEntry * 12 + 4);
    
    nNextIFDOffset = [self readIntValue:(offset + 2 + ifd.nNumberOfDirectoryEntry * 12)];
    
    return nNextIFDOffset;
}

-(BOOL) readTag:(long)offset :(TiffTag*) srcTag :(int*)nIfdByteCounts
{
    [handle seekToFileOffset:offset];
    
    // タグIDの読み込み
    srcTag.byteTagID = [handle readDataOfLength:2];
    srcTag.tagID = [self shortValue:srcTag.byteTagID];
    //    DLog(@"%d", srcTag.tagID);
    
    // タイプの読み込み
    srcTag.byteFieldType = [handle readDataOfLength:2];
    srcTag.tagType = [self shortValue:srcTag.byteFieldType];
    //    DLog(@"%d", srcTag.tagType);
    
    // 値の数の読み込み
    srcTag.byteNumberOfValues = [handle readDataOfLength:4];
    srcTag.nNumberOfValues = [self intValue:srcTag.byteNumberOfValues];
    //    DLog(@"%d", srcTag.nNumberOfValues);
    
    //タグ情報が格納されているバイト数を加算
    int bytesInField = sizeOfTypes[srcTag.tagType] * srcTag.nNumberOfValues;
    if (bytesInField > 4)
    {
        *nIfdByteCounts += bytesInField;
    }
    
    // Offset の読み込み
    srcTag.byteOffset = [handle readDataOfLength:4];
    srcTag.nOffSet = [self intValue:srcTag.byteOffset];
    //    DLog(@"%d", srcTag.nOffSet);
    
    return YES;
}

-(int) getNumberOfPages
{
    int nNumberOfPages = 0;
    int nNumberOfDirectoryEntry = 0;
    int nextOffset = 8;
    nextOffset = [self readIntValue:(4)];
    
    while(nextOffset > 0)
    {
        nNumberOfPages++;
        
        nNumberOfDirectoryEntry = [self readShortValue:nextOffset];
        if(nNumberOfDirectoryEntry < 0)
        {
            nextOffset = 0;
        }
        else
        {
            nextOffset = [self readIntValue:(nextOffset + 2 + nNumberOfDirectoryEntry * 12)];
        }
    }
    return nNumberOfPages;
    
}

-(int) readShortValue:(int) nextOffset
{
    [handle seekToFileOffset:nextOffset];
    
    NSData * byteArray = [handle readDataOfLength:2];
    
    int retunvalue = [self shortValue:byteArray];
    
    //    DLog(@"%d", retunvalue);
    
    return retunvalue;
}

-(int) readIntValue:(int) nextOffset
{
    [handle seekToFileOffset:nextOffset];
    
    NSData * byteArray = [handle readDataOfLength:4];
    
    int retunvalue = [self intValue:byteArray];
    
    //    DLog(@"%d", retunvalue);
    
    return retunvalue;
}

-(short) shortValue:(NSData*) byteArray
{
    if ([byteArray length] != 2) {
        return 0;
    }
    
    NSData* dataValue2 = [byteArray subdataWithRange:NSMakeRange(0, 1)];
    NSData* dataValue1 = [byteArray subdataWithRange:NSMakeRange(1, 1)];
    
    int nValue1 = *(int*)[dataValue1 bytes];
    int nValue2 = *(int*)[dataValue2 bytes];
    
    nValue1 = nValue1 << 8 | nValue2;
    return (short)nValue1;
}

-(int) intValue:(NSData*) byteArray
{
    if ([byteArray length] != 4) {
        return 0;
    }
    
    NSData* dataValue4 = [byteArray subdataWithRange:NSMakeRange(0, 1)];
    NSData* dataValue3 = [byteArray subdataWithRange:NSMakeRange(1, 1)];
    NSData* dataValue2 = [byteArray subdataWithRange:NSMakeRange(2, 1)];
    NSData* dataValue1 = [byteArray subdataWithRange:NSMakeRange(3, 1)];
    
    int nValue1 = *(int*)[dataValue1 bytes];
    int nValue2 = *(int*)[dataValue2 bytes];
    int nValue3 = *(int*)[dataValue3 bytes];
    int nValue4 = *(int*)[dataValue4 bytes];
    
    nValue1 = nValue1 << 8 | nValue2;
    nValue1 = nValue1 << 8 | nValue3;
    nValue1 = nValue1 << 8 | nValue4;
    return nValue1;
}

-(NSData*)intData:(int) nValue
{
    Byte* buffer = (Byte *)malloc(4);
    buffer[3] = (nValue >> 24) & 255;
    buffer[2] = (nValue >> 16) & 255;
    buffer[1] = (nValue >> 8) & 255;
    buffer[0] = nValue & 255;
    
    NSData* dataValue = [NSData dataWithBytes:buffer length:4];
    free(buffer);
    
    return dataValue;
}

- (BOOL)splitToRawImageByFilePath:(NSString*)strScanFilePath DestinationDirPath:(NSString*) strDestinationDir arrDpi:(NSMutableArray*)arrDpi arrWidth:(NSMutableArray*)arrWidth arrHeight:(NSMutableArray*)arrHeight arrImageLength:(NSMutableArray*)arrImageLength outputfilepath:(NSMutableArray*) outputfiles fileExtention:(NSMutableArray*)fileExtentions
{
    return [self splitToRawImageByFilePath:strScanFilePath DestinationDirPath:strDestinationDir arrDpi:arrDpi arrWidth:arrWidth arrHeight:arrHeight arrImageLength:arrImageLength outputfilepath: outputfiles fileExtention:fileExtentions isThumbnail:TRUE];
}

- (BOOL)splitToRawImageByFilePath:(NSString*)strScanFilePath DestinationDirPath:(NSString*) strDestinationDir arrDpi:(NSMutableArray*)arrDpi arrWidth:(NSMutableArray*)arrWidth arrHeight:(NSMutableArray*)arrHeight arrImageLength:(NSMutableArray*)arrImageLength outputfilepath:(NSMutableArray*) outputfiles fileExtention:(NSMutableArray*)fileExtentions isThumbnail:(BOOL)bThumbnail;
{
    BOOL bRet = TRUE;
    
    @try {
        aIFD = [[NSMutableArray alloc]init];
        
        scanFilePath = strScanFilePath;
        destFolder = strDestinationDir;
        outputFileName = [strScanFilePath lastPathComponent];
        
        m_bThumbnail = bThumbnail;
        
        [self splitToRawImage:outputfiles
                       arrDpi:arrDpi
                     arrWidth:arrWidth
                    arrHeight:arrHeight
               arrImageLength:arrImageLength
                fileExtention:fileExtentions];
        
        if ([outputfiles count] == 0) {
            bRet = FALSE;
        }
    }
    @catch (NSException *exception) {
        bRet = FALSE;
    }
    @finally {
    }
    
    return  bRet;
}

-(int) splitToRawImage:(NSMutableArray*) outputFiles arrDpi:(NSMutableArray*)arrDpi arrWidth:(NSMutableArray*)arrWidth arrHeight:(NSMutableArray*)arrHeight arrImageLength:(NSMutableArray*)arrImageLength fileExtention:(NSMutableArray*)fileExtentions
{
    BOOL bReturn = NO;
    int nResult = -9999;
    
    bReturn = [self readTIFF];
    if(bReturn != YES)
    {
        // ファイルの読み込みに失敗
        return -1;
    }
    
    for(int i = 0; i < MIN(numberOfPages, 999); i++)
    {
        TiffIfd* tiffIFD = [aIFD objectAtIndex:i];
        NSString *fileExtention = @".jpg";
        
        switch (tiffIFD.nCompression) {
            case 7:
                fileExtention = @".jpeg";
                break;
            case 3:
                fileExtention = @".g3";
                break;
            case 4:
                fileExtention = @".g4";
                break;
            case 1:
                fileExtention = @".nocomp";
                break;
            default:
                fileExtention = @".other";
                break;
        }
        [fileExtentions addObject:fileExtention];

        // 解像度の計算
        int resoluton = 0;
        float xResolution = (float)tiffIFD.nXResolusionMolecule / (float)tiffIFD.nXResolusionDenominator;
        float yResolution = (float)tiffIFD.nYResolusionMolecule / (float)tiffIFD.nYResolusionDenominator;
        DLog(@"Resolution : %f, %f", xResolution, yResolution);
        // 小さい解像度を設定する
        if(xResolution <= yResolution){
            resoluton = (int)xResolution;
        } else{
            resoluton = (int)yResolution;
        }
        
        [arrDpi addObject:[NSString stringWithFormat:@"%d",resoluton]];
        [arrWidth addObject:[NSString stringWithFormat:@"%d",tiffIFD.nImageWidth]];
        [arrHeight addObject:[NSString stringWithFormat:@"%d",tiffIFD.nImageLength]];
        [arrImageLength addObject:[NSString stringWithFormat:@"%d",tiffIFD.nStripByteCounts]];
        
        NSString* suffix = [NSString stringWithFormat:@"%03d", i];
        
        NSString* fileName = [destFolder stringByAppendingPathComponent:[outputFileName stringByDeletingPathExtension]];
        fileName = [[fileName stringByAppendingString:suffix] stringByAppendingString:fileExtention];
        
        bReturn = [self writeRawImage:fileName :tiffIFD :i];
        if(bReturn == true)
        {
            // 印刷対象のファイルパスを配列に格納する
            [outputFiles addObject:fileName];
        }
    }
    
    nResult = (int)[outputFiles count];
    
    return nResult;
}

-(BOOL) writeRawImage:(NSString*)strImage :(TiffIfd*)tiffIFD :(int)nPageNumbser
{
    int buff = 128*1024;
    if (!m_bThumbnail) {
        buff = tiffIFD.nImageLength * tiffIFD.nImageWidth;
    }
    
    DLog(@"%@, w=%d, h=%d", strImage, tiffIFD.nImageWidth, tiffIFD.nImageLength);
    
    //出力ファイルパスにファイルを生成
    [[NSFileManager defaultManager] createFileAtPath:strImage contents:nil attributes:nil];
    
    @autoreleasepool
    {
        //ファイル出力用ハンドラ定義
        NSFileHandle * outputHandle = [NSFileHandle fileHandleForWritingAtPath:strImage];
        //オリジナルのファイルを取得
        handle = [NSFileHandle fileHandleForReadingAtPath:scanFilePath];
        //読み込み開始位置を設定
        [handle seekToFileOffset:tiffIFD.nStripOffset];
        
        int endPosition = (int)[handle offsetInFile] + tiffIFD.nStripByteCounts;
        
        while (TRUE) {
            //１ページ分のデータを読み込み、出力ファイルに書き込む
            int readSize = MIN(buff, endPosition - (int)[handle offsetInFile]);
            [outputHandle writeData:[handle readDataOfLength:readSize]];
            
            if([handle offsetInFile] >= endPosition)
            {
                break;
            }
        }
        //オリジナルファイルから読み込んだ情報を解放
        [handle closeFile];
        [outputHandle closeFile];
    }
    
    return YES;
}


@end
