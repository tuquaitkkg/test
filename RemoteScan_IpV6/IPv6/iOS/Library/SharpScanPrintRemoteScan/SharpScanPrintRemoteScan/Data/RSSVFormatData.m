
#import "RSSVFormatData.h"
#import "RemoteScanDataManager.h"

@implementation RSSVFormatData
@synthesize nSelectColorMode, selectablePagePerFile, selectPagePerFile, isPagePerFile, selectableEncrypt, isEncript, password;

typedef enum FileFormatLimitType
{
    FF_LIMIT_NONE,
    FF_LIMIT_MULTICROP,
    FF_LIMIT_ORIGINALSIZELONG
    
} FileFormatLimitType;

#pragma mark - Init
- (id)initWithColorMode:(int)colorMode
             fileFormat:(RSSEFileFormatData *)format
            compression:(RSSECompressionData *)compress
                  ratio:(RSSECompressionRatioData *)ratio
            pagePerFile:(RSSEPagesPerFileData *)pagePerFile
            pdfPassword:(RSSEPdfPasswordData *)pdfPass
                 useOCR:(RSSEUseOCRData *)useOCR
            ocrLanguage:(RSSEOCRLanguageData *)ocrLanguage
          ocrOutputFont:(RSSEOCROutputFontData *)ocrOutputFont
   correctImageRotation:(RSSECorrectImageRotationData *)correctImageRotation
        extractFileName:(RSSEExtractFileNameData *)extractFileName
            ocrAccuracy:(RSSEOCRAccuracyData *)ocrAccuracy
            multiCropOn:(BOOL)bMultiCrop
       originalSizeLong:(BOOL)bOriginalSizeLong
{
    self = [super initWithDictionary:[format getCapableOptions] keys:[format getCapableOptionsKeys] defaultValue:[format getDefaultKey]];
    if (self)
    {
        // 選択中のカラーモード
        nSelectColorMode = colorMode;

        // ファイル形式を抽出
        BOOL bPdf, bEncryptPdf, bPdfa, bPdfa_1a, bTiff, bJpeg, bDocx, bXlsx, bPptx;
        bPdf = bEncryptPdf = bPdfa = bPdfa_1a = bTiff = bJpeg = bDocx = bXlsx = bPptx = NO;
        BOOL bCompactPdf, bUltraFinePdf, bEncryptCompactPdf, bEncryptUltraFinePdf, bCompactPdfa, bUltraFinePdfa, bCompactPdfa_1a, bUltraFinePdfa_1a;
        bCompactPdf = bUltraFinePdf = bEncryptCompactPdf = bEncryptUltraFinePdf = bCompactPdfa = bUltraFinePdfa = bCompactPdfa_1a = bUltraFinePdfa_1a = NO;

        fileFormatArray = [[NSMutableArray alloc] init];
        
        for (NSString *format in keys)
        {
            if ([format rangeOfString:@"pdfa_1a"].location != NSNotFound)
            {
                // pdfa_1a有効
                if (!bMultiCrop && !bOriginalSizeLong) {
                    bPdfa_1a = YES;
                }
                // 高圧縮
                if (!bCompactPdfa_1a)
                {
                    bCompactPdfa_1a = [format isEqualToString:@"compact_pdfa_1a"];
                }
                
                // 高圧縮高精細
                if (!bUltraFinePdfa_1a)
                {
                    bUltraFinePdfa_1a = [format isEqualToString:@"compact_pdfa_1a_ultra_fine"];
                }
            }
            else if ([format rangeOfString:@"pdfa"].location != NSNotFound)
            {
                // pdfa有効
                bPdfa = YES;
                // 高圧縮
                if (!bCompactPdfa)
                {
                    bCompactPdfa = [format isEqualToString:@"compact_pdfa"];
                }

                // 高圧縮高精細
                if (!bUltraFinePdfa)
                {
                    bUltraFinePdfa = [format isEqualToString:@"compact_pdfa_ultra_fine"];
                }
            }
            else if ([format rangeOfString:@"pdf"].location != NSNotFound)
            {
                if ([format rangeOfString:@"encrypt"].location != NSNotFound) {
                    // encrypt_pdf有効
                    bEncryptPdf = YES;
                    
                    // 高圧縮
                    if (!bEncryptCompactPdf)
                    {
                        bEncryptCompactPdf = [format isEqualToString:@"encrypt_compact_pdf"];
                    }
                    
                    // 高圧縮高精細
                    if (!bEncryptUltraFinePdf)
                    {
                        bEncryptUltraFinePdf = [format isEqualToString:@"encrypt_compact_pdf_ultra_fine"];
                    }

                }
                else {
                    // pdf有効
                    bPdf = YES;
                    
                    // 高圧縮
                    if (!bCompactPdf)
                    {
                        bCompactPdf = [format isEqualToString:@"compact_pdf"];
                    }
                    
                    // 高圧縮高精細
                    if (!bUltraFinePdf)
                    {
                        bUltraFinePdf = [format isEqualToString:@"compact_pdf_ultra_fine"];
                    }
                }
                
            }
            else if ([format isEqualToString:@"tiff"])
            {
                // tiff有効
                bTiff = YES;
            }
            else if ([format isEqualToString:@"jpeg"])
            {
                // tiff有効
                bJpeg = YES;
            }
            else if ([format isEqualToString:@"docx"])
            {
                if (!bMultiCrop && !bOriginalSizeLong) {
                    // docx有効
                    bDocx = YES;
                }
            }
            else if ([format isEqualToString:@"xlsx"])
            {
                if (!bMultiCrop && !bOriginalSizeLong) {
                    // xlsx有効
                    bXlsx = YES;
                }
            }
            else if ([format isEqualToString:@"pptx"])
            {
                if (!bMultiCrop && !bOriginalSizeLong) {
                    // pptx有効
                    bPptx = YES;
                }
            }

        }
        if (bPdf)
            [fileFormatArray addObject:@"pdf"];
        if (bPdfa_1a)
            [fileFormatArray addObject:@"pdfa_1a"];
        if (bPdfa)
            [fileFormatArray addObject:@"pdfa"];
        if (bTiff)
            [fileFormatArray addObject:@"tiff"];
        if (bJpeg)
            [fileFormatArray addObject:@"jpeg"];
        if (bDocx)
            [fileFormatArray addObject:@"docx"];
        if (bXlsx)
            [fileFormatArray addObject:@"xlsx"];
        if (bPptx)
            [fileFormatArray addObject:@"pptx"];
        
        nSelectFileFormat = 0;
        // set MFP default value
        NSString *strFormat = [self getFormat:select];
        if ([fileFormatArray containsObject:strFormat])
        {
            nSelectFileFormat = [fileFormatArray indexOfObject:strFormat];
        }
        
        compactPdfTypeArray = [[NSMutableArray alloc] initWithObjects:S_RS_COMPACT_PDF_TYPE_NONE, nil];
        if (bCompactPdf)
            [compactPdfTypeArray addObject:@"compact_pdf"];
        if (bUltraFinePdf)
            [compactPdfTypeArray addObject:@"compact_pdf_ultra_fine"];

        compactPdfaTypeArray = [[NSMutableArray alloc] initWithObjects:S_RS_COMPACT_PDF_TYPE_NONE, nil];
        if (bCompactPdfa)
            [compactPdfaTypeArray addObject:@"compact_pdfa"];
        if (bUltraFinePdfa)
            [compactPdfaTypeArray addObject:@"compact_pdfa_ultra_fine"];
        
        compactPdfa_1aTypeArray = [[NSMutableArray alloc] initWithObjects:S_RS_COMPACT_PDF_TYPE_NONE, nil];
        if (bCompactPdfa_1a)
            [compactPdfa_1aTypeArray addObject:@"compact_pdfa_1a"];
        if (bUltraFinePdfa_1a)
            [compactPdfa_1aTypeArray addObject:@"compact_pdfa_1a_ultra_fine"];
        
        // 圧縮率を格納
        compressionRatioData = ratio;
        
        // 圧縮形式を格納
        compressionData = compress;

        // ページ毎にファイル化
        selectablePagePerFile = [[BoolAndRange alloc] initWithEnable:YES min:[pagePerFile getMinimumValue] max:[pagePerFile getMaximumValue]];
        selectPagePerFile = [pagePerFile getDefaultVale];

        // 暗号化
        BOOL bEncript = NO;
        if ([self isVisibleEncrypt])
        {
            bEncript = YES;
        }
        selectableEncrypt = [[BoolAndRange alloc] initWithEnable:bEncript min:[pdfPass getMinimumValue] max:[pdfPass getMaximumValue]];
        password = [pdfPass getPassowrdValue];
        
        if ([useOCR isValidBoolean]) {
            // useOCRのデータがあるため、OCRを有効にする
            self.validOCR = YES;
            
            if ([[useOCR getDefaultKey] isEqualToString:@"true"]) {
                self.isOCR = YES;
            } else {
                self.isOCR = NO;
            }
            
            // 言語設定を格納
            ocrLanguageData = ocrLanguage;
            strSelectOCRLanguageKey = [ocrLanguage getDefaultKey];
            
            // フォントを格納
            ocrOutputFontData = ocrOutputFont;
            strSelectOCROutputFontKey = [ocrOutputFont getDefaultKeyWithSelectableKeys:[self getSelectableOCROutputFontKeys:strSelectOCRLanguageKey]];
            
            // 原稿向き検知
            if ([correctImageRotation isValidBoolean]) {
                self.validCorrectImaegRotation = YES;
                if ([[correctImageRotation getDefaultKey] isEqualToString:@"true"]) {
                    self.isCorrectImageRotation = YES;
                } else {
                    self.isCorrectImageRotation = NO;
                }
            } else {
                self.validCorrectImaegRotation = NO;
            }
            
            // ファイル名抽出
            if ([extractFileName isValidBoolean]) {
                self.validExtractFileName = YES;
                if ([[extractFileName getDefaultKey] isEqualToString:@"true"]) {
                    self.isExtractFileName = YES;
                } else {
                    self.isExtractFileName = NO;
                }
            } else {
                self.validExtractFileName = NO;
            }
            
            // OCR精度
            ocrAccuracyData = ocrAccuracy;
            strSelectOCRAccuracyKey = [ocrAccuracy getDefaultKey];
            if ([ocrAccuracy getCapableOptionsKeys].count > 0) {
                // OCRAccuracyのデータが取得できている場合
                self.validOCRAccuracy = YES;
            } else {
                self.validOCRAccuracy = NO;
            }
            
        } else {
            // useOCRのデータがないため、OCRを無効にする
            self.validOCR = NO;
            self.isOCR = NO;
            
            ocrLanguageData = ocrLanguage;
            strSelectOCRLanguageKey = [ocrLanguage getDefaultKey];
            
            ocrOutputFontData = ocrOutputFont;
            strSelectOCROutputFontKey = [ocrOutputFont getDefaultKey];
            
            self.validCorrectImaegRotation = NO;
            self.isCorrectImageRotation = NO;
            
            self.validExtractFileName = NO;
            self.isExtractFileName = NO;
            
            ocrAccuracyData = ocrAccuracy;
            strSelectOCRAccuracyKey = [ocrAccuracy getDefaultKey];
            self.validOCRAccuracy = NO;
        }
    }
    return self;
}

#pragma mark - Get Selectable Array
// 画面にリスト表示するNSArrayを返却
// ファイル形式
- (NSArray *)getSelectableFileFormatArray
{
    NSMutableArray *resArray = [NSMutableArray array];

    for (NSString *key in fileFormatArray)
    {
        if (nSelectColorMode == E_RSSVFORMATDATA_COLOR_MODE_MONOCHROME &&
            [key isEqualToString:@"jpeg"])
        {
            // モノクロ時はJPEGを省く
            continue;
        }

        // 文字列格納
        [resArray addObject:[dict objectForKey:key]];
    }

    return resArray;
}
// 高圧縮PDFのタイプ
- (NSArray *)getSelectableCompactPdfTypeArray
{
    NSMutableArray *resArray = [NSMutableArray array];
    if ([[fileFormatArray objectAtIndex:nSelectFileFormat] isEqualToString:@"pdf"])
    {
        
        // pdf選択中
        for (NSString *key in compactPdfTypeArray)
        {
            if ([key isEqualToString:S_RS_COMPACT_PDF_TYPE_NONE])
            {
                // なし
                [resArray addObject:key];
            }
            else
            {
                [resArray addObject:[dict objectForKey:key]];
            }
        }
    }
    else if ([[fileFormatArray objectAtIndex:nSelectFileFormat] isEqualToString:@"pdfa"])
    {
        // pdfa選択中
        for (NSString *key in compactPdfaTypeArray)
        {
            if ([key isEqualToString:S_RS_COMPACT_PDF_TYPE_NONE])
            {
                // なし
                [resArray addObject:key];
            }
            else
            {
                [resArray addObject:[dict objectForKey:key]];
            }
        }
    }
    else if ([[fileFormatArray objectAtIndex:nSelectFileFormat] isEqualToString:@"pdfa_1a"])
    {
        // pdfa_1a選択中
        for (NSString *key in compactPdfa_1aTypeArray)
        {
            if ([key isEqualToString:S_RS_COMPACT_PDF_TYPE_NONE])
            {
                // なし
                [resArray addObject:key];
            }
            else
            {
                [resArray addObject:[dict objectForKey:key]];
            }
        }
    }
    return resArray;
}
// 圧縮率
- (NSArray *)getSelectableCompressionRatioArray:(BOOL)bMultiCrop
{
    NSString *fileFormat = [fileFormatArray objectAtIndex:nSelectFileFormat];
    NSArray *resArray = [self getSelectableCompressionRatioArrayByFileFormat:fileFormat andMultiCrop:bMultiCrop];
    
    return resArray;
}
// 圧縮形式
- (NSArray *)getSelectableCompressionArray
{
    NSMutableArray *resArray = [NSMutableArray array];
    for (NSString *key in [compressionData getCapableOptionsKeys])
    {
        if (nSelectColorMode == E_RSSVFORMATDATA_COLOR_MODE_MONOCHROME && [key isEqualToString:@"jpeg"])
        {
            // モノクロ時はjpegは表示しない
            continue;
        }
        [resArray addObject:[[compressionData getCapableOptions] objectForKey:key]];
    }
    return resArray;
}
// 言語設定
- (NSArray *)getSelectableOCRLanguageKeys
{
    return [ocrLanguageData getCapableOptionsKeys];
}
// 言語設定(値)
- (NSArray *)getSelectableOCRLanguageValues:(NSArray *)ocrLanguageKeys
{
    NSMutableArray *resArray = [NSMutableArray array];
    
    NSDictionary *dic = [ocrLanguageData getCapableOptions];
    for (NSString *key in ocrLanguageKeys)
    {
        NSString *value = dic[key];
        if (value)
        {
            [resArray addObject:value];
        }
    }
    
    return resArray;
}
// フォント
- (NSArray *)getSelectableOCROutputFontKeys:(NSString *)ocrLanguageKey
{
    NSMutableArray *validKeys = [[NSMutableArray alloc] init];
    if ([ocrLanguageKey isEqualToString:@"ja"])
    {
        // 日本語の場合の選択可能フォント
        [validKeys addObject:@"ms_gothic"];
        [validKeys addObject:@"ms_mincho"];
        [validKeys addObject:@"ms_pgothic"];
        [validKeys addObject:@"ms_pmincho"];
    }
    else if ([ocrLanguageKey isEqualToString:@"zh_cn"])
    {
        // 中国語の場合の選択可能フォント
        [validKeys addObject:@"simsun"];
        [validKeys addObject:@"simhei"];
    }
    else if ([ocrLanguageKey isEqualToString:@"zh_tw"])
    {
        // 台湾語の場合の選択可能フォント
        [validKeys addObject:@"mingliu"];
        [validKeys addObject:@"pmingliu"];
    }
    else if ([ocrLanguageKey isEqualToString:@"ko"])
    {
        // 韓国語の場合の選択可能フォント
        [validKeys addObject:@"dotum"];
        [validKeys addObject:@"batang"];
        [validKeys addObject:@"malgun_gothic"];
    }
    else
    {
        // 欧文の場合の選択可能フォント
        [validKeys addObject:@"arial"];
        [validKeys addObject:@"times_new_roman"];
    }
    
    NSArray *allKeys = [ocrOutputFontData getCapableOptionsKeys];
    NSMutableArray *resArray = [[NSMutableArray alloc] init];
    for (NSString *key in allKeys)
    {
        if ([validKeys containsObject:key])
        {
            [resArray addObject:key];
        }
    }
    
    return resArray;
}
// フォント(値)
- (NSArray *)getSelectableOCROutputFontValues:(NSArray *)ocrOutputFontKeys
{
    NSMutableArray *resArray = [NSMutableArray array];
    
    NSDictionary *dic = [ocrOutputFontData getCapableOptions];
    for (NSString *key in ocrOutputFontKeys)
    {
        NSString *value = dic[key];
        if (value)
        {
            [resArray addObject:value];
        }
    }
    
    return resArray;
}

// OCR精度(選択可能なリスト：Key)
- (NSArray *)getSelectableOCRAccuracyKeys
{
    return [ocrAccuracyData getCapableOptionsKeys];
}

// OCR精度(選択可能なリスト：値)
- (NSArray *)getSelectableOCRAccuracyValues:(NSArray *)ocrAccuracyKeys
{
    NSMutableArray *resArray = [NSMutableArray array];
    
    NSDictionary *dic = [ocrAccuracyData getCapableOptions];
    for (NSString *key in ocrAccuracyKeys)
    {
        NSString *value = dic[key];
        if (value)
        {
            [resArray addObject:value];
        }
    }
    
    return resArray;
}

#pragma mark - Get Selectable Array　iPhone用
// 画面にリスト表示するNSArrayを返却
// ファイル形式
- (NSArray *)getSelectableFileFormatArray:(NSInteger)nColorMode
{
    NSMutableArray *resArray = [NSMutableArray array];

    for (NSString *key in fileFormatArray)
    {
        if (nColorMode == E_RSSVFORMATDATA_COLOR_MODE_MONOCHROME &&
            [key isEqualToString:@"jpeg"])
        {
            // モノクロ時はJPEGを省く
            continue;
        }

        // 文字列格納
        [resArray addObject:[dict objectForKey:key]];
    }

    return resArray;
}
// 高圧縮PDFのタイプ
- (NSArray *)getSelectableCompactPdfTypeArray:(NSInteger)nFileFormat
{
    NSMutableArray *resArray = [NSMutableArray array];
    if ([[fileFormatArray objectAtIndex:nFileFormat] isEqualToString:@"pdf"])
    {
        // pdf選択中
        for (NSString *key in compactPdfTypeArray)
        {
            if ([key isEqualToString:S_RS_COMPACT_PDF_TYPE_NONE])
            {
                // なし
                [resArray addObject:key];
            }
            else
            {
                [resArray addObject:[dict objectForKey:key]];
            }
        }
    }
    else if ([[fileFormatArray objectAtIndex:nFileFormat] isEqualToString:@"pdfa"])
    {
        // pdfa選択中
        for (NSString *key in compactPdfaTypeArray)
        {
            if ([key isEqualToString:S_RS_COMPACT_PDF_TYPE_NONE])
            {
                // なし
                [resArray addObject:key];
            }
            else
            {
                [resArray addObject:[dict objectForKey:key]];
            }
        }
    }
    else if ([[fileFormatArray objectAtIndex:nFileFormat] isEqualToString:@"pdfa_1a"])
    {
        // pdfa_1a選択中
        for (NSString *key in compactPdfa_1aTypeArray)
        {
            if ([key isEqualToString:S_RS_COMPACT_PDF_TYPE_NONE])
            {
                // なし
                [resArray addObject:key];
            }
            else
            {
                [resArray addObject:[dict objectForKey:key]];
            }
        }
    }
    return resArray;
}
// 圧縮率
- (NSArray *)getSelectableCompressionRatioArray:(NSInteger)nFileFormat andMultiCrop:(BOOL)bMultiCrop
{
    NSString *fileFormat = [fileFormatArray objectAtIndex:nFileFormat];
    NSArray *resArray = [self getSelectableCompressionRatioArrayByFileFormat:fileFormat andMultiCrop:bMultiCrop];
    
    return resArray;
}

- (NSArray *)getSelectableCompressionRatioArrayByFileFormat:(NSString *)fileFormat andMultiCrop:(BOOL)bMultiCrop
{
    NSMutableArray *resArray = [NSMutableArray array];
    NSArray *compRatioArray = [compressionRatioData getCapableOptionsKeys];
    
    for (NSString *key in compRatioArray)
    {
        [resArray addObject:[[compressionRatioData getCapableOptions] objectForKey:key]];
    }
    
    if (bMultiCrop) {
        return resArray;
    }
    
    NSString *priorityBlack = [dict objectForKey:[NSString stringWithFormat:@"priority_black_%@", fileFormat]];
    if (priorityBlack)
    {
        [resArray addObject:priorityBlack];
    }
    
    return resArray;
}
// 圧縮形式
- (NSArray *)getSelectableCompressionArray:(NSInteger)nColorMode
{
    NSMutableArray *resArray = [NSMutableArray array];
    for (NSString *key in [compressionData getCapableOptionsKeys])
    {
        if (nColorMode == E_RSSVFORMATDATA_COLOR_MODE_MONOCHROME && [key isEqualToString:@"jpeg"])
        {
            // モノクロ時はjpegは表示しない
            continue;
        }
        [resArray addObject:[[compressionData getCapableOptions] objectForKey:key]];
    }
    return resArray;
}
// 画面で選択した項目をセットする
// 設定されている情報をもとに最終的なキーをselectに格納する
- (NSString *)getSelectValue:(NSInteger)nColorMode
            selectFileFormat:(NSInteger)nFileFormat
        selectCompactPdfType:(NSInteger)nCompactPdfType
      selectCompressionRatio:(NSInteger)nCompressionRatio
            selectEncryption:(BOOL)bEncryption

{
    NSString *selectKey = [fileFormatArray objectAtIndex:nFileFormat];
    if (nColorMode == E_RSSVFORMATDATA_COLOR_MODE_MONOCHROME)
    {
        // モノクロ
        if ([selectKey isEqualToString:@"jpeg"])
        {
            selectKey = [NSString stringWithFormat:@"tiff"];
        }
        
        // 暗号化判定(pdfのみ)
        if (bEncryption && [selectKey isEqualToString:@"pdf"])
        {
            // 暗号化
            selectKey = [NSString stringWithFormat:@"encrypt_%@", selectKey];
        }
    }
    else if ([selectKey isEqualToString:@"pdf"] || [selectKey isEqualToString:@"pdfa"] || [selectKey isEqualToString:@"pdfa_1a"])
    {
        // pdf/pdfa
        BOOL bPdf = [selectKey isEqualToString:@"pdf"];

        // 高圧縮高精細判定
        NSString *compact = [[NSString alloc] init];
        if ([selectKey isEqualToString:@"pdf"])
        {
            compact = [compactPdfTypeArray objectAtIndex:nCompactPdfType];
        }
        else if ([selectKey isEqualToString:@"pdfa"])
        {
            compact = [compactPdfaTypeArray objectAtIndex:nCompactPdfType];
        }
        else if ([selectKey isEqualToString:@"pdfa_1a"])
        {
            compact = [compactPdfa_1aTypeArray objectAtIndex:nCompactPdfType];
        }
        
        if ([compact rangeOfString:@"compact"].location != NSNotFound)
        {
            // 高圧縮
            selectKey = [NSString stringWithFormat:@"compact_%@", selectKey];
            if ([compact rangeOfString:@"ultra_fine"].location != NSNotFound)
            {
                // 高精細
                selectKey = [NSString stringWithFormat:@"%@_ultra_fine", selectKey];
            }
        }
        else
        {
            // 黒文字重視判定
            if ([compressionRatioData getCapableOptionsKeys].count <= nCompressionRatio)
            {
                // 黒文字重視が設定可能か
                if ([self chkCanSelectPirorityBlack:selectKey]) {
                    // 黒文字重視
                    selectKey = [NSString stringWithFormat:@"priority_black_%@", selectKey];
                }
            }
        }

        // 暗号化判定(pdfのみ)
        if (bEncryption && bPdf)
        {
            // 暗号化
            selectKey = [NSString stringWithFormat:@"encrypt_%@", selectKey];
        }
    }
    else
    {
        // tiff, jpeg, docx, xlsx, pptx
    }

    return selectKey;
}
// 画面で選択した項目をセットする
// 設定されている情報をもとに最終的なキーを渡す
- (NSString *)getSelectValue:(NSInteger)nColorMode
{
    NSString *selectKey = [fileFormatArray objectAtIndex:nSelectFileFormat];
    if (nColorMode == E_RSSVFORMATDATA_COLOR_MODE_MONOCHROME)
    {
        // モノクロ
        if ([selectKey isEqualToString:@"jpeg"])
        {
            //            selectKey = [NSString stringWithFormat:@"tiff"];
        }

        // 暗号化判定(pdfのみ)
        BOOL bPdf = [selectKey isEqualToString:@"pdf"];
        if (isEncript && bPdf)
        {
            // 暗号化
            selectKey = [NSString stringWithFormat:@"encrypt_%@", selectKey];
        }
    }
    else if ([selectKey isEqualToString:@"pdf"] || [selectKey isEqualToString:@"pdfa"] || [selectKey isEqualToString:@"pdfa_1a"])
    {
        // pdf/pdfa
        BOOL bPdf = [selectKey isEqualToString:@"pdf"];

        // 高圧縮高精細判定
        NSString *compact = [[NSString alloc] init];
        if ([selectKey isEqualToString:@"pdf"]) {
            compact = [compactPdfTypeArray objectAtIndex:nSelectCompactPdfType];
        }
        else if ([selectKey isEqualToString:@"pdfa"])
        {
            compact = [compactPdfaTypeArray objectAtIndex:nSelectCompactPdfType];
        }
        else if ([selectKey isEqualToString:@"pdfa_1a"])
        {
            compact = [compactPdfa_1aTypeArray objectAtIndex:nSelectCompactPdfType];
        }
        
        if ([compact rangeOfString:@"compact"].location != NSNotFound)
        {
            // 高圧縮
            selectKey = [NSString stringWithFormat:@"compact_%@", selectKey];
            if ([compact rangeOfString:@"ultra_fine"].location != NSNotFound)
            {
                // 高精細
                selectKey = [NSString stringWithFormat:@"%@_ultra_fine", selectKey];
            }
        }
        else
        {
            // 黒文字重視判定
            if ([compressionRatioData getCapableOptionsKeys].count <= nSelectCompressionRatio)
            {
                // 黒文字重視が設定可能か
                if ([self chkCanSelectPirorityBlack:selectKey]) {
                    // 黒文字重視
                    selectKey = [NSString stringWithFormat:@"priority_black_%@", selectKey];
                }
            }
        }

        // 暗号化判定(pdfのみ)
        if (isEncript && bPdf)
        {
            // 暗号化
            selectKey = [NSString stringWithFormat:@"encrypt_%@", selectKey];
        }
    }
    else
    {
        // tiff, jpeg, docx, xlsx, pptx
    }

    return selectKey;
}

#pragma mark - Set Select Value
// 画面で選択した項目をセットする
// 設定されている情報をもとに最終的なキーをselectに格納する
- (void)setSelectValue
{
    NSString *selectKey = [fileFormatArray objectAtIndex:nSelectFileFormat];
    //    if(nSelectColorMode == E_RSSVFORMATDATA_COLOR_MODE_MONOCHROME){
    //        // モノクロ
    //        if([selectKey isEqualToString:@"jpeg"]){
    ////            selectKey = [NSString stringWithFormat:@"tiff"];
    //        }
    //
    //    }else
    if ([selectKey isEqualToString:@"pdf"] || [selectKey isEqualToString:@"pdfa"] || [selectKey isEqualToString:@"pdfa_1a"])
    {
        // pdf/pdfa
        BOOL bPdf = [selectKey isEqualToString:@"pdf"];

        // 高圧縮高精細判定
        NSString *compact = [[NSString alloc] init];
        if ([selectKey isEqualToString:@"pdf"])
        {
            compact = [compactPdfTypeArray objectAtIndex:nSelectCompactPdfType];
        }
        else if ([selectKey isEqualToString:@"pdfa"])
        {
            compact = [compactPdfaTypeArray objectAtIndex:nSelectCompactPdfType];
        }
        else if ([selectKey isEqualToString:@"pdfa_1a"])
        {
            compact = [compactPdfa_1aTypeArray objectAtIndex:nSelectCompactPdfType];
        }
        
        if ([compact rangeOfString:@"compact"].location != NSNotFound)
        {
            // 高圧縮
            selectKey = [NSString stringWithFormat:@"compact_%@", selectKey];
            if ([compact rangeOfString:@"ultra_fine"].location != NSNotFound)
            {
                // 高精細
                selectKey = [NSString stringWithFormat:@"%@_ultra_fine", selectKey];
            }
        }
        else
        {
            // 黒文字重視判定
            if ([compressionRatioData getCapableOptionsKeys].count <= nSelectCompressionRatio)
            {
                // 黒文字重視が設定可能か
                if ([self chkCanSelectPirorityBlack:selectKey]) {
                    // 黒文字重視
                    selectKey = [NSString stringWithFormat:@"priority_black_%@", selectKey];
                }
                
            }
        }
        
        // 暗号化判定(pdfのみ)
        if (isEncript && bPdf)
        {
            // 暗号化
            selectKey = [NSString stringWithFormat:@"encrypt_%@", selectKey];
        }
    }
    else
    {
        // tiff, jpeg, docx, xlsx, pptx
    }

    select = [selectKey copy];
}
// ファイル形式
- (void)setSelectFileFormatValue:(NSUInteger)selectValue
{
    if (nSelectFileFormat != selectValue)
    {
        nSelectFileFormat = selectValue;
    }
}

// 高圧縮PDFのタイプ
- (void)setSelectCompactPdfTypeValue:(int)selectValue
{
    if (nSelectCompactPdfType != selectValue)
    {
        nSelectCompactPdfType = selectValue;
    }
}
// 圧縮率
- (void)setSelectCompressionRatioValue:(int)selectValue
{
    if (nSelectCompressionRatio != selectValue)
    {
        nSelectCompressionRatio = selectValue;
    }
}
// 圧縮形式
- (void)setSelectCompressionValue:(int)selectValue
{
    if (nSelectCompression != selectValue)
    {
        nSelectCompression = selectValue;
    }
}

// カラーモード
- (void)setSelectColorModeValue:(int)selectValue
{
    if (nSelectColorMode != selectValue)
    {
        nSelectColorMode = selectValue;
    }
}

// パスワード
- (int)setPdfPasswordValue:(NSString *)value
{
    int res = E_RSSVFORMATDATA_SETPASSOWRD_ERR_NONE;
    password = [value copy];
    return res;
}

// 言語設定
- (void)setSelectOCRLanguageValue:(NSString *)selectValue
{
    if (![strSelectOCRLanguageKey isEqualToString:selectValue])
    {
        strSelectOCRLanguageKey = selectValue;
    }
}

// フォント
- (void)setSelectOCROutputFontValue:(NSString *)selectValue
{
    if (![strSelectOCROutputFontKey isEqualToString:selectValue])
    {
        strSelectOCROutputFontKey = selectValue;
    }
}

// OCR精度
- (void)setSelectOCRAccuracyValue:(NSString *)selectValue
{
    if (![strSelectOCRAccuracyKey isEqualToString:selectValue])
    {
        strSelectOCRAccuracyKey = selectValue;
    }
}

- (BOOL)checkPasswordFormat:(NSString *)str
{
    BOOL res = YES;
    char *chars = (char *)[str UTF8String];
    for (int i = 0; i < str.length; i++)
    {
        if (chars[i] >= 'a' && chars[i] <= 'z')
        {
            continue;
        }
        else if (chars[i] >= 'A' && chars[i] <= 'Z')
        {
            continue;
        }
        else if (chars[i] >= '0' && chars[i] <= '9')
        {
            continue;
        }
        else if (chars[i] == '\0')
        {
            // 終端文字
            break;
        }

        // NG
        res = NO;
        break;
    }

    return res;
}

// 保存されているキーをセットする
- (void)setSavedKey:(BOOL)bMultiCropOn originalSizeLong:(BOOL)bOriginalSizeLong
{
    RemoteScanData *rsd = [[RemoteScanDataManager sharedManager] sharedRemoteScanSettings];

    //nSelectCompressionRatio = 1; // 圧縮率の初期値 @"middle"
    //nSelectCompression = 2;      // 圧縮アルゴリズムの初期値 @"mmr"

    // カラーモード
    nSelectColorMode = [rsd.selectColorMode intValue];

    // フォーマット
    NSString *fileFormat = [self getFormat:rsd.fileFormat];
    
    // 保存されている値がフォーマットの選択肢の中に含まれている場合のみ設定する
    if ([fileFormatArray containsObject:fileFormat])
    {
        // 選択されているファイルフォーマット情報更新
        nSelectFileFormat = [fileFormatArray indexOfObject:fileFormat];
        select = rsd.fileFormat;
        
    }
    
    //fileFormat = [self getFormat:select];

    // 高圧縮設定
    if (bMultiCropOn) {
        nSelectCompactPdfType = 0;
    }
    else {
        [self setCompactPdfTypeSelectIndex];
    }
    
    // 圧縮率
    [self setSelectCompressionRatio];
    
    // 圧縮アルゴリズム
    [self setSelectCompression];
    
    // ページ毎にファイル化
    if (![rsd.pagesPerFile isEqualToString:@""]) {
        // 保存が一度でもされていたら
        selectPagePerFile = [rsd.pagesPerFile intValue];
    }
    if (bMultiCropOn) {
        selectPagePerFile = 1;
    }
    if (selectPagePerFile > 0) {
        isPagePerFile = YES;
    }
    else {
        isPagePerFile = NO;
    }

    // 暗号化判定
    [self setIsEncryptValue:select];
    
    password = rsd.pdfPassword;
    
    // ファイル形式の決定
    [self setSelectValue];
    fileFormat = [self getFormat:select];
    
    // OCR
    if ([self isRequiredOCRFormat:fileFormat]) {
        self.isOCR = YES;
    }
    else {
        if ([rsd.useOCR isEqualToString:@"true"])
        {
            self.isOCR = YES;
        }
        else if ([rsd.useOCR isEqualToString:@"false"])
        {
            self.isOCR = NO;
        }
    }
    
    // 画像の向き検知
    if ([rsd.correctImageRotation isEqualToString:@"true"])
    {
        self.isCorrectImageRotation = YES;
    }
    else if ([rsd.correctImageRotation isEqualToString:@"false"])
    {
        self.isCorrectImageRotation = NO;
    }
    
    // ファイル名自動検出
    if ([rsd.extractFileName isEqualToString:@"true"])
    {
        self.isExtractFileName = YES;
    }
    else if ([rsd.extractFileName isEqualToString:@"false"])
    {
        self.isExtractFileName = NO;
    }
    
    // OCR精度
    NSArray *ocrAccuracyKeyArray = [ocrAccuracyData getCapableOptionsKeys];
    if ([ocrAccuracyKeyArray containsObject:rsd.ocrAccuracy])
    {
        strSelectOCRAccuracyKey = rsd.ocrAccuracy;
    }
    
    // OCR設定値
    if ([select isEqualToString:@"tiff"] || [select isEqualToString:@"jpeg"] || bMultiCropOn || bOriginalSizeLong)
    {
        // フォーマットがtiff,jpegの場合、もしくはマルチクロップON、もしくは長尺の場合はocrクリア
        [self clearOcrValue];
    }
    else
    {
        NSArray *ocrLanguageKeyArray = [ocrLanguageData getCapableOptionsKeys];
        if ([ocrLanguageKeyArray containsObject:rsd.ocrLanguage])
        {
            strSelectOCRLanguageKey = rsd.ocrLanguage;
        }
        
        NSArray *ocrOutputFontKeyArray = [self getSelectableOCROutputFontKeys:strSelectOCRLanguageKey];
        if ([ocrOutputFontKeyArray containsObject:rsd.ocrOutputFont])
        {
            strSelectOCROutputFontKey = rsd.ocrOutputFont;
        }
        else {
            // 言語設定値が保存された値で変わる場合や、保存しているフォントが未対応のMFPになった場合に取得しなおす
            //strSelectOCROutputFontKey = [ocrOutputFont getDefaultKeyWithSelectableKeys:ocrOutputFontKeyArray];
            strSelectOCROutputFontKey = [ocrOutputFontData getDefaultKeyWithSelectableKeys:ocrOutputFontKeyArray];
        }
    }
    
    //[self setSelectValue];
}

#pragma mark - Get Select Index
// 画面での選択値を返却する
- (NSUInteger)getSelectFileFormatIndex
{
    if (nSelectColorMode == E_RSSVFORMATDATA_COLOR_MODE_MONOCHROME && ([select isEqualToString:@"jpeg"] || nSelectFileFormat == [fileFormatArray indexOfObject:@"jpeg"]))
    {
        // 白黒でJPEGの場合、TIFFに変更する
        return [fileFormatArray indexOfObject:@"tiff"];
    }
    return nSelectFileFormat;
}
// 保存している値を返却する
- (NSUInteger)getOriginalFileFormatIndex
{
    return nSelectFileFormat;
}

- (int)getSelectCompactPdfTypeIndex
{
    return nSelectCompactPdfType;
}
- (int)getSelectCompressionRatioIndex
{
    return nSelectCompressionRatio;
}
- (int)getSelectCompressionIndex
{
    return nSelectCompression;
}
- (NSString *)getSelectOCRLanguageKey
{
    return strSelectOCRLanguageKey;
}
- (NSString *)getSelectOCROutputFontKey
{
    return strSelectOCROutputFontKey;
}
- (NSString *)getSelectOCRAccuracyKey
{
    return strSelectOCRAccuracyKey;
}
#pragma mark - Get Select Index　iPhone用
- (NSUInteger)getSelectFileFormatIndex:(NSInteger)nColorMode selectFileFormat:(NSInteger)nFileFormat
{
    // TODO: selectの比較は不要？
//    if (nColorMode == E_RSSVFORMATDATA_COLOR_MODE_MONOCHROME && ([select isEqualToString:@"jpeg"] || nFileFormat == [fileFormatArray indexOfObject:@"jpeg"]))
    if (nColorMode == E_RSSVFORMATDATA_COLOR_MODE_MONOCHROME && nFileFormat == [fileFormatArray indexOfObject:@"jpeg"])
    {
        // 白黒でJPEGの場合、TIFFに変更する
        return [fileFormatArray indexOfObject:@"tiff"];
    }
    else if (nColorMode == E_RSSVFORMATDATA_COLOR_MODE_FULLCOLOR && nFileFormat == [fileFormatArray indexOfObject:@"jpeg"])
    {
        //        nBeforeFileFormat = 0;
        // カラーモードで前回JPEGからTIFFに変更されていた場合は前回値に変更する
        return nFileFormat;
    }
    //    return nFileFormat;
    return nFileFormat;
}

- (NSString *)getSelectFileFormatValue:(NSInteger)nColorMode selectFileFormat:(NSString *)strFileFormatValue
{
    // TODO: selectの比較は不要？
//    if (nColorMode == E_RSSVFORMATDATA_COLOR_MODE_MONOCHROME && ([select isEqualToString:@"jpeg"] || [strFileFormatValue isEqualToString:[dict objectForKey:@"jpeg"]]))
    if (nColorMode == E_RSSVFORMATDATA_COLOR_MODE_MONOCHROME && [strFileFormatValue isEqualToString:[dict objectForKey:@"jpeg"]])
    {
        // 白黒でJPEGの場合、TIFFに変更する
        return [dict objectForKey:@"tiff"];
    }
    else if (nColorMode == E_RSSVFORMATDATA_COLOR_MODE_FULLCOLOR && [strFileFormatValue isEqualToString:[dict objectForKey:@"jpeg"]])
    {
        //        nBeforeFileFormat = 0;
        // カラーモードで前回JPEGからTIFFに変更されていた場合は前回値に変更する
        return strFileFormatValue;
    }
    
    return strFileFormatValue;
}

- (NSUInteger)getFileFormatIndex:(NSString *)value
{
    for (NSString *key in dict.keyEnumerator) {
        if ([value isEqualToString:dict[key]]) {
            return [fileFormatArray indexOfObject:key];
        }
    }
    
    return 0;
}

// 高圧縮タイプのインデックスを再設定する
- (NSUInteger)getCompactPdfTypeIndex:(NSString *)value
{
    NSArray *capableArray = [self getSelectableCompactPdfTypeArray];
    
    if ([capableArray indexOfObject:value] != NSNotFound) {
        return [capableArray indexOfObject:value];
    }
    
    return 0;   // デフォルト=なし
    
}

- (NSUInteger)getCompressionRatioIndex:(NSString *)value fileFormatValue:(NSString *)fileFormatValue
{
    NSDictionary *dic = [compressionRatioData getCapableOptions];
    NSArray *compressionRatioKeys = [compressionRatioData getCapableOptionsKeys];
    
    for (NSString *key in dic.keyEnumerator) {
        if ([value isEqualToString:dic[key]]) {
            return [compressionRatioKeys indexOfObject:key];
        }
    }
    
    NSInteger fileFormatIndex = [self getFileFormatIndex:fileFormatValue];
    NSString *fileFormatKey = fileFormatArray[fileFormatIndex];
    NSString *priorityBlack = [dict objectForKey:[NSString stringWithFormat:@"priority_black_%@", fileFormatKey]];
    if (priorityBlack)
    {
        if ([value isEqualToString:priorityBlack]) {
            return dic.count;
        }
    }
    
    return 0;
    
}

- (NSUInteger)getSelectFileFormatJpegIndex
{
    // JPEGの場合、JPEGの番号を返す
    return [fileFormatArray indexOfObject:@"jpeg"];
}

- (NSString *)getSelectFileFormatJpegValue
{
    // JPEGの場合、JPEGの値を返す
    return [dict objectForKey:@"jpeg"];
}

- (NSString *)getSelectOCRLanguageValue:(NSString *)ocrLanguageKey
{
    NSDictionary *dic = [ocrLanguageData getCapableOptions];
    NSString *value = dic[ocrLanguageKey];
    
    if (!value) {
        return @"";
    }
    
    return value;
}

- (NSString *)getSelectOCROutputFontValue:(NSString *)ocrOutputFontKey
{
    NSDictionary *dic = [ocrOutputFontData getCapableOptions];
    NSString *value = dic[ocrOutputFontKey];
    
    if (!value) {
        return @"";
    }
    
    return value;
}

// OCR精度
- (NSString *)getSelectOCRAccuracyValue:(NSString *)ocrAccuracyKey
{
    NSDictionary *dic = [ocrAccuracyData getCapableOptions];
    NSString *value = dic[ocrAccuracyKey];
    
    if (!value) {
        return @"";
    }
    
    return value;
}

#pragma mark - Get Select Value
// 選択された項目のKey(ExecuteJobでセットするべき値)を返却
- (NSString *)getSelectFileFormatValue
{
    // 情報を最新情報で更新してから返す
    [self setSelectValue];
    return select;
}

- (NSString *)getSelectCompressionRatioValue
{
    if ([[compressionRatioData getCapableOptionsKeys] count] <= nSelectCompressionRatio)
    {
        // error
        return @"priority_black_";
    }
    return [[compressionRatioData getCapableOptionsKeys] objectAtIndex:nSelectCompressionRatio];
}
- (NSString *)getSelectCompressionValue
{
    return [[compressionData getCapableOptionsKeys] objectAtIndex:nSelectCompression];
}
- (NSString *)getSelectEncryptValue
{
    return password;
}
- (NSString *)getSelectOCRLanguageValue
{
    return [self getSelectOCRLanguageValue:strSelectOCRLanguageKey];
}
- (NSString *)getSelectOCROutputFontValue
{
    return [self getSelectOCROutputFontValue:strSelectOCROutputFontKey];
}
- (NSString *)getSelectOCRAccuracyValue
{
    return [self getSelectOCRAccuracyValue:strSelectOCRAccuracyKey];
}

#pragma mark - Get Select Value Name
// 選択された項目の表示名を返却（選択中の項目を画面表示する際に使用）
- (NSString *)getSelectFileFormatValueName
{
    return [dict objectForKey:[fileFormatArray objectAtIndex:nSelectFileFormat]];
}
- (NSString *)getSelectCompactPdfTypeValueName
{
    NSArray *array = nil;
    if ([[fileFormatArray objectAtIndex:nSelectFileFormat] isEqualToString:@"pdf"])
    {
        array = compactPdfTypeArray;
    }
    else if ([[fileFormatArray objectAtIndex:nSelectFileFormat] isEqualToString:@"pdfa"])
    {
        array = compactPdfaTypeArray;
    }
    else if ([[fileFormatArray objectAtIndex:nSelectFileFormat] isEqualToString:@"pdfa_1a"]) {
        array = compactPdfa_1aTypeArray;
    }
    return [dict objectForKey:[array objectAtIndex:nSelectCompactPdfType]];
}
- (NSString *)getSelectCompressionRatioValueName:(NSString *)fileFormatValue
{
    NSDictionary *dic = [compressionRatioData getCapableOptions];
    NSArray *array = [compressionRatioData getCapableOptionsKeys];
    
    if (nSelectCompressionRatio < array.count) {
        return [dic objectForKey:[array objectAtIndex:nSelectCompressionRatio]];
    }
    
    if (nSelectCompressionRatio >= array.count) {
        NSInteger fileFormatIndex = [self getFileFormatIndex:fileFormatValue];
        NSString *fileFormatKey = fileFormatArray[fileFormatIndex];
        NSString *priorityBlack = [dict objectForKey:[NSString stringWithFormat:@"priority_black_%@", fileFormatKey]];
        if (priorityBlack)
        {
            return priorityBlack;
        }
    }
    
    nSelectCompressionRatio = [self getCompRatioDefaultSelectValue];
    
    return [dic objectForKey:[array objectAtIndex:nSelectCompressionRatio]];
}
- (NSString *)getSelectCompressionValueName
{
    NSDictionary *dic = [compressionData getCapableOptions];
    NSArray *array = [compressionData getCapableOptionsKeys];
    return [dic objectForKey:[array objectAtIndex:nSelectCompression]];
}

#pragma mark - Get Default Key
- (NSString *)getDefaultOCRLanguageKey
{
    return [ocrLanguageData getDefaultKey];
}

- (NSString *)getDefaultOCROutputFontKey
{
    return [ocrOutputFontData getDefaultKey];
}

- (NSString *)getDefaultOCRAccuracyKey
{
    return [ocrAccuracyData getDefaultKey];
}

#pragma mark -
// 画面に表示させるフォーマットの名称を取得する
- (NSString *)getDisplayFormatName:(RSSVColorModeData *)colorMode
                      originalSize:(RSSVOriginalSizeData *)originalSize
{
    NSString *formatName = [self getDisplayFormatKey:colorMode
                                        originalSize:originalSize];
    
    return dict[formatName];
}

// 画面に表示させるフォーマットの名称のキーを取得する
- (NSString *)getDisplayFormatKey:(RSSVColorModeData *)colorMode
                     originalSize:(RSSVOriginalSizeData *)originalSize
{
    NSString *fileFormatKey = fileFormatArray[nSelectFileFormat];
    
    if (![colorMode isMonochrome:originalSize])
    {
        return fileFormatKey;
    }
    
    if (![fileFormatKey isEqualToString:@"jpeg"])
    {
        return fileFormatKey;
    }
    
    return @"tiff";
}

// OCRの設定の表示が必要な場合YESを返す
- (BOOL)isVisibleOCR:(NSString *)fileFormatKey
{
    if ([fileFormatKey isEqualToString:@"tiff"]) {
        return NO;
    }
    
    if ([fileFormatKey isEqualToString:@"jpeg"]) {
        return NO;
    }
    
    return YES;
}

// 高圧縮タイプのPDFの場合YESを返す
- (BOOL)isCompactPdf:(NSString *)fileFormatKey
{
    // ファイル形式がPDF以外の場合、高圧縮PDFではない
    if ([fileFormatKey rangeOfString:@"pdf"].location == NSNotFound) {
        return NO;
    }
    
    // ファイル形式が高圧縮以外の場合、高圧縮PDFではない
    if ([fileFormatKey rangeOfString:@"compact"].location == NSNotFound) {
        return NO;
    }
    
    return YES;
}

// 圧縮率が黒文字重視の場合YESを返す
- (BOOL)isPriorityBlack:(NSString *)fileFormatKey
{
    // ファイル形式が黒文字重視以外の場合、黒文字重視ではない
    if ([fileFormatKey rangeOfString:@"priority_black"].location == NSNotFound) {
        return NO;
    }
    
    return YES;
}

// 暗号化をUIに表示するかどうかの判定
- (BOOL)isVisibleEncrypt {
    
    NSString *selectKey = [fileFormatArray objectAtIndex:nSelectFileFormat];
    
    NSArray *selectableArray = [[NSArray alloc] init];
    
    if ([selectKey isEqualToString:@"pdf"]) {
        selectableArray = [compactPdfTypeArray copy];
    }
    else {
        return NO;
    }
    
    if ([[selectableArray objectAtIndex:nSelectCompactPdfType] isEqualToString:S_RS_COMPACT_PDF_TYPE_NONE]
        && [compressionRatioData getCapableOptionsKeys].count != nSelectCompressionRatio
        && [self checkFileFormatSupported:@"encrypt_pdf"])
    {
        return YES;
    }
    else if ([[selectableArray objectAtIndex:nSelectCompactPdfType] isEqualToString:S_RS_COMPACT_PDF_TYPE_NONE]
             && [compressionRatioData getCapableOptionsKeys].count == nSelectCompressionRatio
             && [self checkFileFormatSupported:@"encrypt_priority_black_pdf"])
    {
        return YES;
    }
    else if ([self isCompactPdfSelected:[selectableArray objectAtIndex:nSelectCompactPdfType]]
             && [self checkFileFormatSupported:@"encrypt_compact_pdf"])
    {
        return YES;
    }
    else if ([self isCompactPdfUltraFineSelected:[selectableArray objectAtIndex:nSelectCompactPdfType]]
             && [self checkFileFormatSupported:@"encrypt_compact_pdf_ultra_fine"])
    {
        return YES;
    }
    
    return NO;
}

/**
 @brief 暗号化をUIに表示するかどうかの判定
 @details フォーマット設定画面から呼び出し(iPhone用)
 */
- (BOOL)isVisibleEncrypt:(NSInteger)formatIndex compactPdfType:(NSInteger)compactPdfTypeIndex compressionRatio:(NSInteger)compressionRatioIndex {
    
    NSString *selectKey = [fileFormatArray objectAtIndex:formatIndex];
    
    NSArray *selectableArray = [[NSArray alloc] init];
    
    if ([selectKey isEqualToString:@"pdf"]) {
        selectableArray = [compactPdfTypeArray copy];
    }
    else {
        return NO;
    }
    
    if ([[selectableArray objectAtIndex:compactPdfTypeIndex] isEqualToString:S_RS_COMPACT_PDF_TYPE_NONE]
        && [compressionRatioData getCapableOptionsKeys].count != compressionRatioIndex
        && [self checkFileFormatSupported:@"encrypt_pdf"])
    {
        return YES;
    }
    else if ([[selectableArray objectAtIndex:compactPdfTypeIndex] isEqualToString:S_RS_COMPACT_PDF_TYPE_NONE]
             && [compressionRatioData getCapableOptionsKeys].count == compressionRatioIndex
             && [self checkFileFormatSupported:@"encrypt_priority_black_pdf"])
    {
        return YES;
    }
    else if ([self isCompactPdfSelected:[selectableArray objectAtIndex:compactPdfTypeIndex]]
             && [self checkFileFormatSupported:@"encrypt_compact_pdf"])
    {
        return YES;
    }
    else if ([self isCompactPdfUltraFineSelected:[selectableArray objectAtIndex:compactPdfTypeIndex]]
             && [self checkFileFormatSupported:@"encrypt_compact_pdf_ultra_fine"])
    {
        return YES;
    }
    
    return NO;
}


#pragma mark -
#pragma mark Private Method
// ファイル形式（全部）
- (NSArray *)getFileFormatValueAllArray
{
    NSMutableArray *resArray = [NSMutableArray array];
    
    for (NSString *key in fileFormatArray)
    {
        // 文字列格納
        [resArray addObject:[dict objectForKey:key]];
    }
    
    return resArray;
}

// 高圧縮タイプの選択インデックスを設定
- (void)setCompactPdfTypeSelectIndex {
    
    RemoteScanData *rsd = [[RemoteScanDataManager sharedManager] sharedRemoteScanSettings];
    
    NSString *selectKey = [fileFormatArray objectAtIndex:nSelectFileFormat];    // フォーマット
    NSString *fileFormat = select;  // 現在選択されているファイル形式
    NSString *strMergeSavedKey = selectKey; // 保存値と現在選択されているファイル形式のフォーマットを組み合わせたもの
    
    // 設定可能なリストを作成
    NSArray *selectableArray = [[NSArray alloc] init];
    if ([selectKey isEqualToString:@"pdf"]) {
        selectableArray = [compactPdfTypeArray copy];
        if ([fileFormat rangeOfString:@"encrypt_"].location != NSNotFound) {
            // MFPが対応しているかどうか判定する(暗号化高圧縮/高精細もしくは通常の高圧縮/高精細が対応していれば高圧縮を選択する)
            if ([self checkFileFormatSupported:fileFormat]
                || [self checkFileFormatSupported:[fileFormat stringByReplacingOccurrencesOfString:@"encrypt_" withString:@""]]) {
                // 暗号化PDFの場合は通常のPDFの高圧縮タイプのリストからインデックスを得る為、「encrypt_」を削除する。
                fileFormat = [fileFormat stringByReplacingOccurrencesOfString:@"encrypt_" withString:@""];
            }
        }
    }
    else if ([selectKey isEqualToString:@"pdfa"])
    {
        selectableArray = [compactPdfaTypeArray copy];
    }
    else if ([selectKey isEqualToString:@"pdfa_1a"])
    {
        selectableArray = [compactPdfa_1aTypeArray copy];
    }
    
    // 保存値の高圧縮タイプと現在のファイル形式のフォーマットを組み合わせる
    if ([rsd.fileFormat rangeOfString:@"compact"].location != NSNotFound)
    {
        // 高圧縮
        strMergeSavedKey = [NSString stringWithFormat:@"compact_%@", strMergeSavedKey];
        if ([rsd.fileFormat rangeOfString:@"ultra_fine"].location != NSNotFound)
        {
            // 高精細
            strMergeSavedKey = [NSString stringWithFormat:@"%@_ultra_fine", strMergeSavedKey];
        }
    }
    else if (![rsd.fileFormat isEqualToString:@""]) {
        // 保存値があって、高圧縮が選択されていない場合
        nSelectCompactPdfType = 0;
        return;
    }

    NSUInteger index = [selectableArray indexOfObject:strMergeSavedKey];
    if (index != NSNotFound) {
        // 高圧縮タイプの保存値が設定できる場合
        nSelectCompactPdfType = (int)index;
    }
    else {
        // 高圧縮タイプの保存値が設定できない場合
        NSUInteger index = [selectableArray indexOfObject:fileFormat];
        if (index != NSNotFound) {
            nSelectCompactPdfType = (int)index;
        }
        else {
            nSelectCompactPdfType = 0;  // none
        }
    }

}

// 圧縮率の選択インデックス設定
//- (void)setSelectCompressionRatio:(NSString*)fileFormat {
- (void)setSelectCompressionRatio {
    
    RemoteScanData *rsd = [[RemoteScanDataManager sharedManager] sharedRemoteScanSettings];
    
    // 保存値が設定できる場合は設定、そうでない場合は「中」を設定
    if (![self setSelectCompressionRatioWithFileFormat:rsd.fileFormat compressionRatio:rsd.compressionRatio]) {
        nSelectCompressionRatio = [self getCompRatioDefaultSelectValue];
    }
}

/**
 @brief 引数の圧縮率が設定できる場合はインデックス情報を更新してyesを返す
 @detail 引数のファイルフォーマット(保存値)を参照して黒文字重視かどうか判定し、
 　　　　　黒文字重視の場合は前処理で変更後のファイル形式を使用して黒文字重視が選択可能か判定する。
*/
- (BOOL)setSelectCompressionRatioWithFileFormat:(NSString *)strFileFormat compressionRatio:(NSString *)strCompressionRatio {
    NSArray *compRatioKeyArray = [compressionRatioData getCapableOptionsKeys];
    // check can select @"priority_black"
    if ([self isPriorityBlack:strFileFormat]) {
        // 黒文字重視が選択可能か判定 現在のファイル形式を参照
        //if ([self chkCanSelectPirorityBlack:strFileFormat]) {
        if ([self chkCanSelectPirorityBlack:select]) {
            // 黒文字重視
            NSNumber *num = [[NSNumber alloc]initWithInteger:compRatioKeyArray.count];
            nSelectCompressionRatio = num.unsignedIntValue;
            
            return YES;
        }
    }
    else {
        
        NSUInteger index = [compRatioKeyArray indexOfObject:strCompressionRatio];
        if (index != NSNotFound) {
            nSelectCompressionRatio = (int)index;
            return YES;
        }
    }
    return NO;
}

// 圧縮率のcapableリストにmiddleがあればそのインデックスを、なければ0を返す。(デフォルト設定用)
- (int)getCompRatioDefaultSelectValue {
    
    NSArray *capableArray = [[NSArray alloc] init];
    capableArray = [compressionRatioData getCapableOptionsKeys];
    
    NSUInteger index = [capableArray indexOfObject:@"middle"];
    if (index != NSNotFound) {
        return (int)index;
    }
    
    return 0;
    
}

// 圧縮形式の選択インデックスを設定する
- (void)setSelectCompression {
    
    RemoteScanData *rsd = [[RemoteScanDataManager sharedManager] sharedRemoteScanSettings];
    
    if (![self setSelectCompressionWithString:rsd.compression]) {
        
        nSelectCompression = [self getCompressionDefaultSelectValue];
        
    }
    
}

// 引数の圧縮形式が設定できる場合はインデックス情報を更新してyesを返す
- (BOOL)setSelectCompressionWithString:(NSString *)strCompression {
    NSArray *compressionKeyArray = [[NSArray alloc] init];
    compressionKeyArray = [compressionData getCapableOptionsKeys];
    
    NSUInteger index = [compressionKeyArray indexOfObject:strCompression];
    if (index != NSNotFound) {
        nSelectCompression = (int)index;
        return YES;
    }
    
    return NO;
}

// 圧縮形式のcapableリストに@"mmr"があればそのインデックスを、なければ0を返す。
- (int)getCompressionDefaultSelectValue {
    
    NSArray *capableArray = [[NSArray alloc] init];
    capableArray = [compressionData getCapableOptionsKeys];
    
    NSUInteger index = [capableArray indexOfObject:@"mmr"];
    if (index != NSNotFound) {
        return (int)index;
    }
    
    return 0;
}

- (NSMutableArray*)getListForFileFormatArray:(FileFormatLimitType)limitType {
    NSMutableArray *resArray = [[NSMutableArray alloc] init];
    BOOL bPdf, bEncryptPdf, bPdfa, bPdfa_1a, bTiff, bJpeg, bDocx, bXlsx, bPptx;
    bPdf = bEncryptPdf = bPdfa = bPdfa_1a = bTiff = bJpeg = bDocx = bXlsx = bPptx = NO;
    
    for (NSString *format in keys)
    {
        if ([format rangeOfString:@"pdfa_1a"].location != NSNotFound)
        {
            if (limitType == FF_LIMIT_NONE) {
                // pdfa_1a有効
                bPdfa_1a = YES;
            }
        }
        else if ([format rangeOfString:@"pdfa"].location != NSNotFound)
        {
            // pdfa有効
            bPdfa = YES;
        }
        else if ([format rangeOfString:@"pdf"].location != NSNotFound)
        {
            if ([format rangeOfString:@"encrypt"].location != NSNotFound) {
                // encrypt_pdf有効
                bEncryptPdf = YES;
            }
            else {
                // pdf有効
                bPdf = YES;
                
            }
        }
        else if ([format isEqualToString:@"tiff"])
        {
            // tiff有効
            bTiff = YES;
        }
        else if ([format isEqualToString:@"jpeg"])
        {
            // jpeg有効
            bJpeg = YES;
        }
        else if ([format isEqualToString:@"docx"])
        {
            if (limitType == FF_LIMIT_NONE) {
                // docx有効
                bDocx = YES;
            }
        }
        else if ([format isEqualToString:@"xlsx"])
        {
            if (limitType == FF_LIMIT_NONE) {
                // xlsx有効
                bXlsx = YES;
            }
        }
        else if ([format isEqualToString:@"pptx"])
        {
            if (limitType == FF_LIMIT_NONE) {
                // pptx有効
                bPptx = YES;
            }
        }
    }
    if (bPdf)
        [resArray addObject:@"pdf"];
    if (bPdfa_1a)
        [resArray addObject:@"pdfa_1a"];
    if (bPdfa)
        [resArray addObject:@"pdfa"];
    if (bTiff)
        [resArray addObject:@"tiff"];
    if (bJpeg)
        [resArray addObject:@"jpeg"];
    if (bDocx)
        [resArray addObject:@"docx"];
    if (bXlsx)
        [resArray addObject:@"xlsx"];
    if (bPptx)
        [resArray addObject:@"pptx"];

    return resArray;
}

// ファイル形式からフォーマットを取得
- (NSString*)getFormat:(NSString*)strFileFormat {
    
    // フォーマット
    NSString *format = @"";
    if ([strFileFormat rangeOfString:@"pdfa_1a"].location != NSNotFound)
    {
        format = @"pdfa_1a";
    }
    else if ([strFileFormat rangeOfString:@"pdfa"].location != NSNotFound)
    {
        format = @"pdfa";
    }
    else if ([strFileFormat rangeOfString:@"pdf"].location != NSNotFound)
    {
        format = @"pdf";
    }
    else if ([strFileFormat isEqualToString:@"tiff"])
    {
        format = @"tiff";
    }
    else if ([strFileFormat isEqualToString:@"jpeg"])
    {
        format = @"jpeg";
    }
    else if ([strFileFormat isEqualToString:@"docx"])
    {
        format = @"docx";
    }
    else if ([strFileFormat isEqualToString:@"xlsx"])
    {
        format = @"xlsx";
    }
    else if ([strFileFormat isEqualToString:@"pptx"])
    {
        format = @"pptx";
    }
    else
    {
        format = @"error";
    }
    
    return format;
    
}

// ファイル形式から暗号化PDFかどうかのフラグを設定
- (void)setIsEncryptValue:(NSString*)strFileFormat {
    
    if ([strFileFormat rangeOfString:@"encrypt_"].location != NSNotFound)
    {
        if ([self isVisibleEncrypt]) {
            isEncript = YES;
        }
        else {
            isEncript = NO;
        }
        
    }
    else
    {
        isEncript = NO;
    }

}

// 黒文字重視対応か判定する 引数はファイル形式またはフォーマット
- (BOOL)chkCanSelectPirorityBlack:(NSString*)fileFormat {
    
    NSString *strCheck = [NSString stringWithFormat:@"priority_black_%@", [self getFormat:fileFormat]];
    
    if ([self checkFileFormatSupported:strCheck]) {
        return YES;
    }
    
    return NO;
}

// 高圧縮か
- (BOOL)isCompactPdfSelected:(NSString*)str {
 
    if ([str isEqualToString:@"compact_pdf"]) {
        return YES;
    }
    else if ([str isEqualToString:@"compact_pdfa"]) {
        return YES;
    }
    else if ([str isEqualToString:@"compact_pdfa_1a"]) {
        return YES;
    }
    else if ([str isEqualToString:@"encrypt_compact_pdf"]) {
        return YES;
    }
    return NO;
    
}

// 高圧縮高精細か
- (BOOL)isCompactPdfUltraFineSelected:(NSString*)str {
    
    if ([str isEqualToString:@"compact_pdf_ultra_fine"]) {
        return YES;
    }
    else if ([str isEqualToString:@"compact_pdfa_ultra_fine"]) {
        return YES;
    }
    else if ([str isEqualToString:@"compact_pdfa_1a_ultra_fine"]) {
        return YES;
    }
    else if ([str isEqualToString:@"encrypt_compact_pdf_ultra_fine"]) {
        return YES;
    }
    
    return NO;
}

// 渡された文字列のファイルフォーマットがMFPで対応しているか
- (BOOL)checkFileFormatSupported:(NSString*)str {
    
    if ([keys indexOfObject:str] != NSNotFound) {
        return YES;
    }
    
    return NO;
}

// OCRの設定をクリアする
- (void)clearOcrValue {
    
    self.isOCR = NO;
    strSelectOCRLanguageKey = [ocrLanguageData getDefaultKey];
    strSelectOCROutputFontKey = [ocrOutputFontData getDefaultKey];
    self.isCorrectImageRotation = NO;
    self.isExtractFileName = NO;
    strSelectOCRAccuracyKey = [ocrAccuracyData getDefaultKey];
}


#pragma mark - SetValues For MultiCrop On

/**
 @brief マルチクロップONになった時のフォーマットデータの更新処理
 @details 戻り値：高圧縮PDFもしくは黒文字重視が選択されていたかどうか
          GetSettableElementsにてマルチクロップがONである場合にも呼ばれる → 呼ばないように変更(別の処理方法にて対応)
 */
- (BOOL)updateFormatDataForMultiCropOn:(RSSEFileFormatData *)rsseFileFormatData {
    
    NSString *strFileFormat = [self getSelectFileFormatValue];  // 設定値に設定されているファイル形式を取得(初回の場合は保存値またはMFPのデフォルト値)
    NSString *strFormat = [self getFormat:strFileFormat];
    
    BOOL bRes = NO;     // 高圧縮PDFもしくは黒文字重視が選択されていたかどうか
    
    // フォーマットのリスト更新
    fileFormatArray = [self getListForFileFormatArray:FF_LIMIT_MULTICROP];
    nSelectFileFormat = [fileFormatArray indexOfObject:strFormat];
    
    if ([self isRequiredOCRFormat:strFormat] || [strFormat isEqualToString:@""] || nSelectFileFormat == NSNotFound) {
        // OCR必須のフォーマット もしくは保存値がMFP未対応のフォーマットであった場合
        NSString *strNewFileFormat = [rsseFileFormatData getDefaultKey]; // MFPのデフォルト値を選択する
        nSelectFileFormat = 0;
        // set MFP default value
        NSString *strNewFormat = [self getFormat:strNewFileFormat];
        if ([fileFormatArray containsObject:strNewFormat])
        {
            nSelectFileFormat = [fileFormatArray indexOfObject:strNewFormat];
        }
    }
    
    // 高圧縮PDFのタイプ
    if ([self isCompactPdfUltraFineSelected:strFileFormat] || [self isCompactPdfSelected:strFileFormat]) {
        nSelectCompactPdfType = 0;
        bRes = YES;
    }
    // 圧縮率
    NSArray *capableArray = [[NSArray alloc] init];
    capableArray = [compressionRatioData getCapableOptionsKeys];
    if ([self isPriorityBlack:strFileFormat] || nSelectCompressionRatio >= capableArray.count) {
        // 黒文字重視の場合は「中」を選択 (「中」を検索してなければ１番目を選択する形)
        nSelectCompressionRatio = [self getCompRatioDefaultSelectValue];
        bRes = YES;
    }
    
    // ファイル形式の最終的な調整処理
    [self setSelectValue];
    
    return bRes;
}

// OCR必須のファイルフォーマットかどうかの判定
- (BOOL)isRequiredOCRFormat:(NSString *)strFormat {
    
    if ([strFormat isEqualToString:@"pdfa_1a"] || [strFormat isEqualToString:@"docx"] || [strFormat isEqualToString:@"xlsx"] || [strFormat isEqualToString:@"pptx"]) {
        return YES;
    }
    return NO;
    
}

#pragma mark -OCR and OriginalSizeLong

/**
 @brief 原稿サイズ長尺が選択されたときのフォーマットデータの更新処理
 */
- (void)updateFormatDataForOriginalSizeLong:(RSSEFileFormatData *)rsseFileFormatData {
    
    
    NSString *strFileFormat = [self getSelectFileFormatValue];  // 設定値に設定されているファイル形式を取得(初回の場合は保存値またはMFPのデフォルト値)
    NSString *strFormat = [self getFormat:strFileFormat];
    
    // フォーマットのリスト更新
    fileFormatArray = [self getListForFileFormatArray:FF_LIMIT_ORIGINALSIZELONG];
    nSelectFileFormat = [fileFormatArray indexOfObject:strFormat];
    
    if ([self isRequiredOCRFormat:strFormat] || [strFormat isEqualToString:@""] || nSelectFileFormat == NSNotFound) {
        // OCR必須のフォーマット もしくは保存値がMFP未対応のフォーマットであった場合
        NSString *strNewFileFormat = [rsseFileFormatData getDefaultKey]; // MFPのデフォルト値を選択する
        nSelectFileFormat = 0;
        // set MFP default value
        NSString *strNewFormat = [self getFormat:strNewFileFormat];
        if ([fileFormatArray containsObject:strNewFormat])
        {
            nSelectFileFormat = [fileFormatArray indexOfObject:strNewFormat];
        }
    }
    
    // ファイル形式の最終的な調整処理
    [self setSelectValue];
    
}

/**
 @brief ファイル形式リストの制限解除
 @detail マルチクロッップOFF、長尺から長尺以外になった場合。
 */
- (void)updateFormatDataToLimitNone {
    
    NSString *strFileFormat = [self getSelectFileFormatValue];
    NSString *strFormat = [self getFormat:strFileFormat];
    
    // フォーマットのリスト更新
    fileFormatArray = [[self getListForFileFormatArray:FF_LIMIT_NONE] mutableCopy];
    
    // フォーマットの選択インデックスを更新
    nSelectFileFormat = [fileFormatArray indexOfObject:strFormat];
}

@end

#pragma mark -
#pragma mark Bool And Range Class
@implementation BoolAndRange
@synthesize enable, max, min;
- (id)initWithEnable:(BOOL)bEnable min:(int)nMin max:(int)nMax
{
    self = [super init];
    if (self)
    {
        self.enable = bEnable;
        // 必ず max <= min になるようにする
        self.max = (nMax > nMin ? nMax : nMin);
        self.min = (nMax < nMin ? nMax : nMin);
    }
    return self;
}
@end
