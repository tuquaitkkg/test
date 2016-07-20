
#import "RSGetJobSettableElementsManager.h"

enum
{
    E_NEST_RESULT,
    E_NEST_GETJOBSETTABLEELEMENTSRESPONSE,
    E_NEST_XML_DOC_OUT,
    E_NEST_COMPLEX,
    E_NEST_PROPERTY,
    E_NEST_GETVALUE,
};

enum
{
    E_GET_NONE,

    E_GET_COLORMODE,
    E_GET_ORIGINALSIZE,
    E_GET_ORIGINALSOURCE,
    E_GET_SENDSIZE,
    E_GET_RESOLUTION,
    E_GET_EXPOSUREMODE,
    E_GET_EXPOSURELEVEL,
    E_GET_DUPLEXMODE,
    E_GET_DUPLEXDIR,
    E_GET_COMPRESSION,
    E_GET_COMPRESSIONRATIO,
    E_GET_FILEFORMAT,
    E_GET_SPECIALMODE,
    E_GET_PAGESPERFILE,
    E_GET_ROTATION,
    E_GET_PDFPASSWORD,
    E_GET_USEOCR,
    E_GET_OCRLANGUAGE,
    E_GET_OCROUTPUTFONT,
    E_GET_CORRECTIMAGEROTATION,
    E_GET_EXTRACTFILENAME,
    E_GET_OCRACCURACY,
};

@implementation RSGetJobSettableElementsManager

//@synthesize defaultColorMode;
//@synthesize colorModeList;
//@synthesize defaultManuscript;
//@synthesize manuscriptList;
//@synthesize defaultSaveSize;
//@synthesize saveSizeList;
//@synthesize defaultRotation;
//@synthesize rotationList;
//@synthesize defaultBothOrOneSide;
//@synthesize bothOrOneSideList;
//@synthesize defaultBothOrOneSideMode;
//@synthesize bothOrOneSideModeList;
//@synthesize defaultFileFormat;
//@synthesize fileFormatList;
//@synthesize defaultCompressionPDFType;
//@synthesize compressionPDFTypeList;
//@synthesize defaultCompressionRatio;
//@synthesize compressionRatioList;
//@synthesize defaultMonoImageCompressionType;
//@synthesize monoImageCompressionTypeList;
//@synthesize nDefPagesPerFileNum;
//@synthesize nMaxPagesPerFileNum;
//@synthesize nMinPagesPerFileNum;
//@synthesize defaultResolution;
//@synthesize resolutionList;
//@synthesize defaultColorDepth;
//@synthesize colorDepthList;
//@synthesize defaultColorDepthLevel;
//@synthesize colorDepthLevelList;
//@synthesize defaultBlankPageProcess;
//@synthesize blankPageProcessList;

@synthesize rsSettableElementsData;

// 初期化処理
- (id)initWithURL:(NSURL *)url
{
    self = [super initWithURL:url];
    if (self)
    {
        //        colorModeList                   = [[NSMutableArray alloc]init];
        //        manuscriptList                  = [[NSMutableArray alloc]init];
        //        saveSizeList                    = [[NSMutableArray alloc]init];
        //        rotationList                    = [[NSMutableArray alloc]init];
        //        bothOrOneSideList               = [[NSMutableArray alloc]init];
        //        bothOrOneSideModeList           = [[NSMutableArray alloc]init];
        //        fileFormatList                  = [[NSMutableArray alloc]init];
        //        compressionPDFTypeList          = [[NSMutableArray alloc]init];
        //        compressionRatioList            = [[NSMutableArray alloc]init];
        //        monoImageCompressionTypeList    = [[NSMutableArray alloc]init];
        //        resolutionList                  = [[NSMutableArray alloc]init];
        //        colorDepthList                  = [[NSMutableArray alloc]init];
        //        colorDepthLevelList             = [[NSMutableArray alloc]init];
        //        blankPageProcessList            = [[NSMutableArray alloc]init];

        rsSettableElementsData = [[RSSettableElementsData alloc] init];
    }
    return self;
}
// 解放処理

//// 配列の初期化
//-(void)initArray:(NSMutableArray*)array
//{
//    if(array){
//        for(id o in [array reverseObjectEnumerator]){
//            [array removeObject:o];
//        }
//    }else{
//        array = [[NSMutableArray alloc]init];
//    }
//}

// 情報取得開始
- (void)updateData
{
    // 各配列の初期化
    //    [self initArray:colorModeList];
    //    [self initArray:manuscriptList];
    //    [self initArray:saveSizeList];
    //    [self initArray:rotationList];
    //    [self initArray:bothOrOneSideList];
    //    [self initArray:bothOrOneSideModeList];
    //    [self initArray:fileFormatList];
    //    [self initArray:compressionPDFTypeList];
    //    [self initArray:compressionRatioList];
    //    [self initArray:monoImageCompressionTypeList];
    //    [self initArray:resolutionList];
    //    [self initArray:colorDepthList];
    //    [self initArray:colorDepthLevelList];
    //    [self initArray:blankPageProcessList];

    // リモートスキャン設定情報取得
    [super getRequest:@"mfpscan/GetJobSettableElements/v1?res=xml&reqType=remoteScanJob"];
}

// 情報取得をキャンセル
- (void)updateDataCancel
{
    [super disconnect];
}

// ダウンロード成功
- (void)compleatDownloadData
{
    // フラグの初期化
    nNest = E_NEST_RESULT;
    nGetValueStage = E_GET_NONE;

    NSLog(@"downloadData = %@", [[NSString alloc] initWithData:downloadData encoding:NSUTF8StringEncoding]);

    [super compleatDownloadData];
}

- (void)setRSSEListTypeData:(RSSEListTypeData *)data string:(NSString *)string
{
    if ([self string:strElement isEqualToString:@"value"])
    {
        [data setDefaultKey:string];
    }
    else if ([self string:strElement isEqualToString:@"allowed"])
    {
        [data addCapableKey:string];
    }
}

- (void)setRSSEintegerTypeData:(RSSEIntegerTypeData *)data string:(NSString *)string
{
    DLog(@"setRSSEintegerTypeData : %@ %@", strElement, string);
    if ([self string:strElement isEqualToString:@"value"])
    {
        [data setDefaultValue:string.intValue];
    }
    else if ([self string:strHasConstraintAttr isEqualToString:@"maxValue"])
    {
        [data setMaximumValue:string.intValue];
    }
    else if ([self string:strHasConstraintAttr isEqualToString:@"minValue"])
    {
        [data setMinimumValue:string.intValue];
    }
}

- (void)setRSSEPdfPasswordData:(RSSEPdfPasswordData *)data string:(NSString *)string
{
    DLog(@"setRSSEPdfPasswordData : %@ %@", strElement, string);
    if ([self string:strHasConstraintAttr isEqualToString:@"maxLength"])
    {
        [data setMaximumValue:string.intValue];
    }
    else if ([self string:strHasConstraintAttr isEqualToString:@"minLength"])
    {
        [data setMinimumValue:string.intValue];
    }
}

//// ローカライズ定義文字列に置き換える
//-(NSString*)replaceRSStr:(NSString*)str
//{
//    if(!str){
//        return nil;
//    }
//
//    NSString* retStr = [NSString stringWithFormat:@"%@", str];
//    if([self string:str isEqualToString:@"auto"]){
//        retStr = S_RS_XML_AUTO;
//    }else if([self string:str isEqualToString:@"monochrome"]){
//        retStr = S_RS_XML_MONOCHROME;
//    }else if([self string:str isEqualToString:@"grayscale"]){
//        retStr = S_RS_XML_GRAYSCALE;
//    }else if([self string:str isEqualToString:@"fullcolor"]){
//        retStr = S_RS_XML_FULLCOLOR;
//    }else if([self string:str isEqualToString:@"long"]){
//        retStr = S_RS_XML_LONG;
//    }else if([self string:str isEqualToString:@"invoice"]){
//        retStr = S_RS_XML_INVOICE;
//    }else if([self string:str isEqualToString:@"invoice_r"]){
//        retStr = S_RS_XML_INVOICE_R;
//    }else if([self string:str isEqualToString:@"letter"]){
//        retStr = S_RS_XML_LETTER;
//    }else if([self string:str isEqualToString:@"letter_r"]){
//        retStr = S_RS_XML_LETTER_R;
//    }else if([self string:str isEqualToString:@"foolscap"]){
//        retStr = S_RS_XML_FOOLSCAP;
//    }else if([self string:str isEqualToString:@"legal"]){
//        retStr = S_RS_XML_LEGAL;
//    }else if([self string:str isEqualToString:@"ledger"]){
//        retStr = S_RS_XML_LEDGER;
//    }else if([self string:str isEqualToString:@"a5"]){
//        retStr = S_RS_XML_A5;
//    }else if([self string:str isEqualToString:@"a5_r"]){
//        retStr = S_RS_XML_A5_R;
//    }else if([self string:str isEqualToString:@"b5"]){
//        retStr = S_RS_XML_B5;
//    }else if([self string:str isEqualToString:@"b5_r"]){
//        retStr = S_RS_XML_B5_R;
//    }else if([self string:str isEqualToString:@"a4"]){
//        retStr = S_RS_XML_A4;
//    }else if([self string:str isEqualToString:@"a4_r"]){
//        retStr = S_RS_XML_A4_R;
//    }else if([self string:str isEqualToString:@"b4"]){
//        retStr = S_RS_XML_B4;
//    }else if([self string:str isEqualToString:@"a3"]){
//        retStr = S_RS_XML_A3;
//    }else if([self string:str isEqualToString:@"8k"]){
//        retStr = S_RS_XML_8K;
//    }else if([self string:str isEqualToString:@"16k"]){
//        retStr = S_RS_XML_16K;
//    }else if([self string:str isEqualToString:@"16k_r"]){
//        retStr = S_RS_XML_16K_R;
//    }else if([self string:str isEqualToString:@"8/1_2x13_2/5"]){
//        retStr = S_RS_XML_8_1_2X13_2_5;
//    }else if([self string:str isEqualToString:@"8/1_2x13_1/2"]){
//        retStr = S_RS_XML_8_1_2X13_1_2;
//    }else if([self string:str isEqualToString:@"manual"]){
//        retStr = S_RS_XML_MANUAL;
//    }else if([self string:str isEqualToString:@"100"]){
//        retStr = S_RS_XML_100;
//    }else if([self string:str isEqualToString:@"150"]){
//        retStr = S_RS_XML_150;
//    }else if([self string:str isEqualToString:@"200"]){
//        retStr = S_RS_XML_200;
//    }else if([self string:str isEqualToString:@"300"]){
//        retStr = S_RS_XML_300;
//    }else if([self string:str isEqualToString:@"400"]){
//        retStr = S_RS_XML_400;
//    }else if([self string:str isEqualToString:@"600"]){
//        retStr = S_RS_XML_600;
//    }else if([self string:str isEqualToString:@"text"]){
//        retStr = S_RS_XML_TEXT;
//    }else if([self string:str isEqualToString:@"text_print_photo"]){
//        retStr = S_RS_XML_TEXT_PRINT_PHOTO;
//    }else if([self string:str isEqualToString:@"print_photo"]){
//        retStr = S_RS_XML_PRINT_PHOTO;
//    }else if([self string:str isEqualToString:@"text_photo"]){
//        retStr = S_RS_XML_TEXT_PHOTO;
//    }else if([self string:str isEqualToString:@"photo"]){
//        retStr = S_RS_XML_PHOTO;
//    }else if([self string:str isEqualToString:@"map"]){
//        retStr = S_RS_XML_MAP;
//    }else if([self string:str isEqualToString:@"simplex"]){
//        retStr = S_RS_XML_SIMPLEX;
//    }else if([self string:str isEqualToString:@"duplex"]){
//        retStr = S_RS_XML_DUPLEX;
//    }else if([self string:str isEqualToString:@"book"]){
//        retStr = S_RS_XML_BOOK;
//    }else if([self string:str isEqualToString:@"tablet"]){
//        retStr = S_RS_XML_TABLET;
//    }else if([self string:str isEqualToString:@"none"]){
//        retStr = S_RS_XML_NONE;
//    }else if([self string:str isEqualToString:@"mh"]){
//        retStr = S_RS_XML_MH;
//    }else if([self string:str isEqualToString:@"mmr"]){
//        retStr = S_RS_XML_MMR;
//    }else if([self string:str isEqualToString:@"jpeg"]){
//        retStr = S_RS_XML_JPEG;
//    }else if([self string:str isEqualToString:@"low"]){
//        retStr = S_RS_XML_LOW;
//    }else if([self string:str isEqualToString:@"middle"]){
//        retStr = S_RS_XML_MIDDLE;
//    }else if([self string:str isEqualToString:@"high"]){
//        retStr = S_RS_XML_HIGH;
//    }else if([self string:str isEqualToString:@"rot_off"]){
//        retStr = S_RS_XML_ROT_OFF;
//    }else if([self string:str isEqualToString:@"rot_90"]){
//        retStr = S_RS_XML_ROT_90;
//    }else if([self string:str isEqualToString:@"pdf"]){
//        retStr = S_RS_XML_PDF;
//    }else if([self string:str isEqualToString:@"pdfa"]){
//        retStr = S_RS_XML_PDFA;
//    }else if([self string:str isEqualToString:@"encrypt_pdf"]){
//        retStr = S_RS_XML_ENCRYPT_PDF;
//    }else if([self string:str isEqualToString:@"tiff"]){
//        retStr = S_RS_XML_TIFF;
//    }else if([self string:str isEqualToString:@"xps"]){
//        retStr = S_RS_XML_XPS;
//    }else if([self string:str isEqualToString:@"compact_pdf"]){
//        retStr = S_RS_XML_COMPACT_PDF;
//    }else if([self string:str isEqualToString:@"compact_pdf_ultra_fine"]){
//        retStr = S_RS_XML_COMPACT_PDF_ULTRA_FINE;
//    }else if([self string:str isEqualToString:@"compact_pdfa"]){
//        retStr = S_RS_XML_COMPACT_PDFA;
//    }else if([self string:str isEqualToString:@"compact_pdfa_ultra_fine"]){
//        retStr = S_RS_XML_COMPACT_PDFA_ULTRA_FINE;
//    }else if([self string:str isEqualToString:@"encrypt_compact_pdf"]){
//        retStr = S_RS_XML_ENCRYPT_COMPACT_PDF;
//    }else if([self string:str isEqualToString:@"encrypt_compact_pdf_ultra_fine"]){
//        retStr = S_RS_XML_ENCRYPT_COMPACT_PDF_ULTRA_FINE;
//    }else if([self string:str isEqualToString:@"priority_black_pdf"]){
//        retStr = S_RS_XML_PRIORITY_BLACK_PDF;
//    }else if([self string:str isEqualToString:@"priority_black_pdfa"]){
//        retStr = S_RS_XML_PRIORITY_BLACK_PDFA;
//    }else if([self string:str isEqualToString:@"encrypt_priority_black_pdf"]){
//        retStr = S_RS_XML_ENCRYPT_PRIORITY_BLACK_PDF;
//    }else if([self string:str isEqualToString:@"job_build"]){
//        retStr = S_RS_XML_JOB_BUILD;
//    }else if([self string:str isEqualToString:@"job_build_mixed_source"]){
//        retStr = S_RS_XML_JOB_BUILD_MIXED_SOURCE;
//    }else if([self string:str isEqualToString:@"blank_page_skip"]){
//        retStr = S_RS_XML_BLANK_PAGE_SKIP;
//    }else if([self string:str isEqualToString:@"blank_and_back_shadow_skip"]){
//        retStr = S_RS_XML_BLANK_AND_BACK_SHADOW_SKIP;
//    }
//
//    return retStr;
//}

// 開始タグを検出
- (void)didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName attributes:(NSDictionary *)attributeDict
{
    // 現在のタグを保存
    strElement = elementName;

    // /result/GetJobSettableElementsResponse/xml-doc-out/complex/propertyまで階層を進める
    switch (nNest)
    {
    case E_NEST_RESULT:
        if ([self string:elementName isEqualToString:@"result"])
            nNest++;
        break;
    case E_NEST_GETJOBSETTABLEELEMENTSRESPONSE:
        if ([self string:elementName isEqualToString:@"GetJobSettableElementsResponse"])
            nNest++;
        break;
    case E_NEST_XML_DOC_OUT:
        if ([self string:elementName isEqualToString:@"xml-doc-out"])
            nNest++;
        break;
    case E_NEST_COMPLEX:
        if ([self string:elementName isEqualToString:@"complex"])
            nNest++;
        break;
    case E_NEST_PROPERTY:
        if ([self string:elementName isEqualToString:@"property"])
        {
            nNest++;

            // プロパティの取得
            NSString *sysName = [attributeDict valueForKey:@"sys-name"];
            if ([self string:sysName isEqualToString:@"ColorMode"])
            {
                nGetValueStage = E_GET_COLORMODE; // カラーモード
            }
            else if ([self string:sysName isEqualToString:@"OriginalSource"])
            {
                nGetValueStage = E_GET_ORIGINALSOURCE; // スキャン原稿の位置
            }
            else if ([self string:sysName isEqualToString:@"OriginalSize"])
            {
                nGetValueStage = E_GET_ORIGINALSIZE; // 原稿サイズ
            }
            else if ([self string:sysName isEqualToString:@"SendSize"])
            {
                nGetValueStage = E_GET_SENDSIZE; // 保存サイズ
            }
            else if ([self string:sysName isEqualToString:@"Resolution"])
            {
                nGetValueStage = E_GET_RESOLUTION; // 解像度
            }
            else if ([self string:sysName isEqualToString:@"ExposureMode"])
            {
                nGetValueStage = E_GET_EXPOSUREMODE; // 濃度
            }
            else if ([self string:sysName isEqualToString:@"ExposureLevel"])
            {
                nGetValueStage = E_GET_EXPOSURELEVEL; // 濃度レベル
            }
            else if ([self string:sysName isEqualToString:@"DuplexMode"])
            {
                nGetValueStage = E_GET_DUPLEXMODE; // 片面/両面
            }
            else if ([self string:sysName isEqualToString:@"DuplexDir"])
            {
                nGetValueStage = E_GET_DUPLEXDIR; // 両面モード
            }
            else if ([self string:sysName isEqualToString:@"Compression"])
            {
                nGetValueStage = E_GET_COMPRESSION; // 白黒2値画像の圧縮形式
            }
            else if ([self string:sysName isEqualToString:@"CompressionRatio"])
            {
                nGetValueStage = E_GET_COMPRESSIONRATIO; // カラー/グレースケール画像の圧縮率
            }
            else if ([self string:sysName isEqualToString:@"FileFormat"])
            {
                nGetValueStage = E_GET_FILEFORMAT; // ファイル形式
            }
            else if ([self string:sysName isEqualToString:@"SpecialMode"])
            {
                nGetValueStage = E_GET_SPECIALMODE; // 特別機能(白紙飛ばし/マルチクロップ)
            }
            else if ([self string:sysName isEqualToString:@"PagesPerFile"])
            {
                nGetValueStage = E_GET_PAGESPERFILE; // ページ毎にファイル化
            }
            else if ([self string:sysName isEqualToString:@"Rotation"])
            {
                nGetValueStage = E_GET_ROTATION; // 用紙向き
            }
            else if ([self string:sysName isEqualToString:@"PdfPassword"])
            {
                nGetValueStage = E_GET_PDFPASSWORD;
            }
            else if ([self string:sysName isEqualToString:@"UseOCR"])
            {
                nGetValueStage = E_GET_USEOCR;
            }
            else if ([self string:sysName isEqualToString:@"OCRLanguage"])
            {
                nGetValueStage = E_GET_OCRLANGUAGE;
            }
            else if ([self string:sysName isEqualToString:@"OCROutputFont"])
            {
                nGetValueStage = E_GET_OCROUTPUTFONT;
            }
            else if ([self string:sysName isEqualToString:@"CorrectImageRotation"])
            {
                nGetValueStage = E_GET_CORRECTIMAGEROTATION;
            }
            else if ([self string:sysName isEqualToString:@"ExtractFileName"])
            {
                nGetValueStage = E_GET_EXTRACTFILENAME;
            }
            else if ([self string:sysName isEqualToString:@"OCRAccuracy"])
            {
                nGetValueStage = E_GET_OCRACCURACY;
            }
        }
        break;

    case E_NEST_GETVALUE:
        // データ取得中
        if ([elementName isEqualToString:@"hasConstraint"])
        {
            strHasConstraintAttr = [attributeDict objectForKey:@"name"];
        }
        break;

    default:
        nNest = 0;
        break;
    }
}

// タグ以外の文字を検出
- (void)foundCharacters:(NSString *)string
{
    // 各パラメータの取得
    switch (nGetValueStage)
    {
    default:
    case E_GET_NONE:
        break;

    case E_GET_COLORMODE:
        [self setRSSEListTypeData:rsSettableElementsData.colorModeData string:string];
        break;

    case E_GET_ORIGINALSIZE:
        [self setRSSEListTypeData:rsSettableElementsData.originalSizeData string:string];
        break;

    case E_GET_ORIGINALSOURCE:
        [self setRSSEListTypeData:rsSettableElementsData.originalSourceData string:string];
        break;

    case E_GET_SENDSIZE:
        [self setRSSEListTypeData:rsSettableElementsData.sendSizeData string:string];
        break;

    case E_GET_RESOLUTION:
        [self setRSSEListTypeData:rsSettableElementsData.resolutionData string:string];
        break;

    case E_GET_EXPOSUREMODE:
        [self setRSSEListTypeData:rsSettableElementsData.exposureModeData string:string];
        break;

    case E_GET_EXPOSURELEVEL:
        [self setRSSEintegerTypeData:rsSettableElementsData.exposureLevelData string:string];

        break;

    case E_GET_DUPLEXMODE:
        [self setRSSEListTypeData:rsSettableElementsData.duplexModeData string:string];
        break;

    case E_GET_DUPLEXDIR:
        [self setRSSEListTypeData:rsSettableElementsData.duplexDirData string:string];
        break;

    case E_GET_COMPRESSION:
        [self setRSSEListTypeData:rsSettableElementsData.compressionData string:string];
        break;

    case E_GET_COMPRESSIONRATIO:
        [self setRSSEListTypeData:rsSettableElementsData.compressionRatioData string:string];
        break;

    case E_GET_FILEFORMAT:
        [self setRSSEListTypeData:rsSettableElementsData.fileFormatData string:string];
        break;

    case E_GET_SPECIALMODE:
        [self setRSSEListTypeData:rsSettableElementsData.specialModeData string:string];
        break;

    case E_GET_PAGESPERFILE:
        [self setRSSEintegerTypeData:rsSettableElementsData.pagesPerFileData string:string];
        break;

    case E_GET_ROTATION:
        [self setRSSEListTypeData:rsSettableElementsData.rotationData string:string];
        break;

    case E_GET_PDFPASSWORD:
        [self setRSSEPdfPasswordData:rsSettableElementsData.pdfPasswordData string:string];
            break;

    case E_GET_USEOCR:
        [self setRSSEListTypeData:rsSettableElementsData.useOCRData string:string];
        break;
            
    case E_GET_OCRLANGUAGE:
        [self setRSSEListTypeData:rsSettableElementsData.ocrLanguageData string:string];
        break;
            
    case E_GET_OCROUTPUTFONT:
        [self setRSSEListTypeData:rsSettableElementsData.ocrOutputFontData string:string];
        break;
            
    case E_GET_CORRECTIMAGEROTATION:
        [self setRSSEListTypeData:rsSettableElementsData.correctImageRotationData string:string];
        break;
            
    case E_GET_EXTRACTFILENAME:
        [self setRSSEListTypeData:rsSettableElementsData.extractFileNameData string:string];
        break;
    case E_GET_OCRACCURACY:
        [self setRSSEListTypeData:rsSettableElementsData.ocrAccuracyData string:string];
        break;
    }
}

// 終了タグを検出
- (void)didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName
{
    if (nNest == E_NEST_GETVALUE && [self string:elementName isEqualToString:@"property"])
    {
        // property終了
        nNest = E_NEST_PROPERTY;
        nGetValueStage = E_GET_NONE;
    }
}

- (void)parserDidEndDocument
{
}

@end
