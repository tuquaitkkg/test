#import "RemoteScanSettingViewData.h"
#import "RSCommonUtil.h"
#import "RSDefine.h"
#import "RemoteScanData.h"
#import "RemoteScanDataManager.h"

@implementation RemoteScanSettingViewData

@synthesize extraSizeListData;
@synthesize customSizeListData;

@synthesize colorMode;
@synthesize originalSize;
@synthesize sendSize;
@synthesize rotation;
@synthesize duplexData;

@synthesize resolution;
@synthesize exposureMode;
@synthesize exposureLevel;
@synthesize specialMode;

- (id)initWithRSSettableElementsData:(RSSettableElementsData *)data
{

    self = [super init];

    if (self)
    {
        // 保存されている設定を取得
        RemoteScanData *rsd = [[RemoteScanDataManager sharedManager] sharedRemoteScanSettings];
        
        // 特別機能(白紙飛ばし/マルチクロップ)
        specialMode = [[RSSVSpecialModeData alloc] initWithSpecialMode:data.specialModeData];
        [specialMode setSelectKey:rsd.specialMode];
        
        colorMode = [[RSSVColorModeData alloc] initWithDictionary:[data.colorModeData getCapableOptions]
                                                             keys:[data.colorModeData getCapableOptionsKeys]
                                                     defaultValue:[data.colorModeData getDefaultKey]];
        [colorMode setSelectKey:rsd.colorMode];

        //オリジナルサイズ
        originalSize = [[RSSVOriginalSizeData alloc] initWithDictionary:[data.originalSizeData getCapableOptions]
                                                                   keys:[data.originalSizeData getCapableOptionsKeys]
                                                           defaultValue:[data.originalSizeData getDefaultKey]];

        //外部サイズ（スキャナー機種依存）
        [self createExtraSize];
        //カスタムサイズ
        [self createCustomSize];

        //外部サイズリストを加える
        [self.originalSize addEntriesFromDictionary:[extraSizeListData getPagerSizeDict] keys:[extraSizeListData getPaperSizeArray]];
        //カスタムサイズリストを加える
        [self.originalSize addEntriesFromDictionary:[customSizeListData getPagerSizeDict] keys:[customSizeListData getPaperSizeArray]];

        // オリジナルサイズ(原稿サイズ)
        if ([specialMode isMultiCropOn]) {
            [self.originalSize setSelectKey:@"auto"];
        }
        else if (![rsd.originalSize isEqualToString:@"manual"])
        {
            [self.originalSize setSelectKey:rsd.originalSize];
        }
        else
        {

            NSString *mx = @"";
            NSString *my = @"";
            if ([rsd.ManualSizeName rangeOfString:@"extraSize"].location != NSNotFound)
            {
                // 追加用紙
                mx = [NSString stringWithFormat:@"%d", [[extraSizeListData getCustomPaperSizeData:rsd.ManualSizeName] getMilliWidth]];
                my = [NSString stringWithFormat:@"%d", [[extraSizeListData getCustomPaperSizeData:rsd.ManualSizeName] getMilliHeight]];
            }
            else if ([rsd.ManualSizeName rangeOfString:@"customSize"].location != NSNotFound)
            {
                for (int i = 0; i < [customSizeListData.getPaperSizeArray count]; i++)
                {
                    if ([[customSizeListData.getPaperSizeArray objectAtIndex:i] rangeOfString:rsd.ManualSizeName].location != NSNotFound)
                    {
                        // カスタムサイズ
                        mx = [NSString stringWithFormat:@"%d", [[customSizeListData getCustomPaperSizeData:rsd.ManualSizeName] getMilliWidth]];
                        my = [NSString stringWithFormat:@"%d", [[customSizeListData getCustomPaperSizeData:rsd.ManualSizeName] getMilliHeight]];
                    }
                }
            }

            if ([rsd.ManualSizeX isEqualToString:mx] && [rsd.ManualSizeY isEqualToString:my])
            {
                // そのまま登録
                [self.originalSize setSelectKey:rsd.ManualSizeName];
            }
            else
            {
                [self.originalSize setSelectKey:@"auto"];
            }
        }

        // 保存サイズ(送信サイズ)
        sendSize = [[RSSVListTypeData alloc] initWithDictionary:[data.sendSizeData getCapableOptions]
                                                           keys:[data.sendSizeData getCapableOptionsKeys]
                                                   defaultValue:[data.sendSizeData getDefaultKey]];
        if ([specialMode isMultiCropOn]) {
            [sendSize setSelectKey:@"auto"];
        }
        else {
            [sendSize setSelectKey:rsd.sendSize];
        }

        // 画像セットの方向
        rotation = [[RSSVListTypeData alloc] initWithDictionary:[data.rotationData getCapableOptions]
                                                           keys:[data.rotationData getCapableOptionsKeys]
                                                   defaultValue:[data.rotationData getDefaultKey]];
        // マルチクロップONもしくは長尺の場合はrot_off
        if ([specialMode isMultiCropOn] || [self.originalSize isLong]) {
            [rotation setSelectKey:@"rot_off"];
        }
        else {
            [rotation setSelectKey:rsd.rotation];
        }

        // 両面
        duplexData = [[RSSVDuplexData alloc] initWithDuplexModeData:data.duplexModeData duplexDirData:data.duplexDirData];
        if ([specialMode isMultiCropOn]) {
            if (![rsd.duplexDir isEqualToString:@""]) {
                [duplexData setSelectModeKey:@"simplex" dirKey:rsd.duplexDir];
            }
            else {
                [duplexData setSelectModeKey:@"simplex" dirKey:[duplexData getSelectDuplexDirValue]];
            }
            
        }
        else {
            [duplexData setSelectModeKey:rsd.duplexMode dirKey:rsd.duplexDir];
        }

        int selectColorMode = E_RSSVFORMATDATA_COLOR_MODE_FULLCOLOR;
        if ([self.colorMode isMonochrome:self.originalSize])
        {
            selectColorMode = E_RSSVFORMATDATA_COLOR_MODE_MONOCHROME;
        }
        self.formatData = [[RSSVFormatData alloc] initWithColorMode:selectColorMode
                                                         fileFormat:data.fileFormatData
                                                        compression:data.compressionData
                                                              ratio:data.compressionRatioData
                                                        pagePerFile:data.pagesPerFileData
                                                        pdfPassword:data.pdfPasswordData
                                                             useOCR:data.useOCRData
                                                        ocrLanguage:data.ocrLanguageData
                                                      ocrOutputFont:data.ocrOutputFontData
                                               correctImageRotation:data.correctImageRotationData
                                                    extractFileName:data.extractFileNameData
                                                        ocrAccuracy:data.ocrAccuracyData
                                                        multiCropOn:[specialMode isMultiCropOn]
                                                    originalSizeLong:[self.originalSize isLong]
                                                    ];
        
        [self.formatData setSavedKey:[specialMode isMultiCropOn] originalSizeLong:[self.originalSize isLong]];
        

        resolution = [[RSSVResolutionData alloc] initWithDictionary:[data.resolutionData getCapableOptions]
                                                               keys:[data.resolutionData getCapableOptionsKeys]
                                                       defaultValue:[data.resolutionData getDefaultKey]];
        [resolution setSelectKey:rsd.resolution];
        if ([specialMode isMultiCropOn]) {
            [self updateResolutionForMultiCropOn:NO];
        }
        
        

        exposureMode = [[RSSVListTypeData alloc] initWithDictionary:[data.exposureModeData getCapableOptions]
                                                               keys:[data.exposureModeData getCapableOptionsKeys]
                                                       defaultValue:[data.exposureModeData getDefaultKey]];
        [exposureMode setSelectKey:rsd.exposureMode];

        exposureLevel = [[RSSVIntegerTypeData alloc] initWithValue:[data.exposureLevelData getDefaultVale]
                                                      minimumValue:[data.exposureLevelData getMinimumValue]
                                                      maximumValue:[data.exposureLevelData getMaximumValue]];
        int el = [rsd.exposureLevel intValue];
        if (el >= exposureLevel.minimumValue && el <= exposureLevel.maximumValue)
        {
            exposureLevel.selectValue = el;
        }
        
    }
    return self;
}

- (void)createExtraSize
{
    extraSizeListData = [[RSCustomPaperSizeListData alloc] init];

    RSCustomPaperSizeData *extraSize1 = [[RSCustomPaperSizeData alloc] initWithMilliValue:S_RS_XML_SEND_SIZE_BUSINESSCARD //名刺
                                                                                    width:91
                                                                                   height:55];

    RSCustomPaperSizeData *extraSize2 = [[RSCustomPaperSizeData alloc] initWithMilliValue:S_RS_XML_SEND_SIZE_LTYPE
                                                                                    width:89
                                                                                   height:127];

    RSCustomPaperSizeData *extraSize3 = [[RSCustomPaperSizeData alloc] initWithMilliValue:S_RS_XML_SEND_SIZE_2LTYPE
                                                                                    width:178
                                                                                   height:127];

    RSCustomPaperSizeData *extraSize4 = [[RSCustomPaperSizeData alloc] initWithMilliValue:S_RS_XML_SEND_SIZE_CARD
                                                                                    width:86
                                                                                   height:54];

    //originalsizeの中に名刺が存在しなければ、名刺を加える
    if (![self.originalSize isExistKey:@"business_card"])
    {
        [extraSizeListData setValue:extraSize1 forKey:@"extraSize1"];
    }

    //その他加える
    [extraSizeListData setValue:extraSize2 forKey:@"extraSize2"];
    [extraSizeListData setValue:extraSize3 forKey:@"extraSize3"];
    [extraSizeListData setValue:extraSize4 forKey:@"extraSize4"];
}

- (void)createCustomSize
{
    // カスタムサイズキーが存在するかどうか
    BOOL isCustomSizeKey = YES;
    // 再設定用リスト
    NSMutableArray *tempList = [NSMutableArray array];

    customSizeListData = [[RSCustomPaperSizeListData alloc] init];

    NSArray *m_parrCustomData = [[NSArray alloc] initWithArray:[self readCustomData]];
    for (int i = 0; i < [m_parrCustomData count]; i++)
    {
        RSCustomPaperSizeData *rsCustomPaperSizeData = nil;
        rsCustomPaperSizeData = [m_parrCustomData objectAtIndex:i];
        
        // カスタムサイズキーがある場合
        if ([rsCustomPaperSizeData.customSizeKey length]) {
            // カスタムサイズデータを設定する
            [customSizeListData setValue:rsCustomPaperSizeData forKey:rsCustomPaperSizeData.customSizeKey];

        // カスタムサイズキーが未設定の場合(リリース前にカスタムサイズ設定済みの場合があれば、カスタムサイズキーを設定する)
        } else {
            isCustomSizeKey = NO;
            switch (i)
            {
                case 0:
                    rsCustomPaperSizeData.customSizeKey = @"customSize1";
                    break;
                case 1:
                    rsCustomPaperSizeData.customSizeKey = @"customSize2";
                    break;
                case 2:
                    rsCustomPaperSizeData.customSizeKey = @"customSize3";
                    break;
                case 3:
                    rsCustomPaperSizeData.customSizeKey = @"customSize4";
                    break;
                case 4:
                    rsCustomPaperSizeData.customSizeKey = @"customSize5";
                    break;
                default:
                    break;
            }
            [customSizeListData setValue:rsCustomPaperSizeData forKey:rsCustomPaperSizeData.customSizeKey];
        }
        
        // カスタムサイズキーを設定したデータを再設定用リストに追加する
        [tempList addObject:rsCustomPaperSizeData];
    }
    
    // カスタムサイズキーが未設定だった場合は、カスタムサイズ情報を書き込んでおく
    if (!isCustomSizeKey) {
        [self saveCustomData:tempList];
    }
}

// プロパティリストを読み込んでRSCustomPaperSizeDataクラスを生成
- (NSMutableArray *)readCustomData
{
    //
    // 自動解放プールの作成
    //
    @autoreleasepool
    {
        @try
        {
            //
            // 読み込む
            //
            id obj;

            NSString *pstrFileName = [RSCommonUtil.settingFileDir stringByAppendingString:S_CUSTOMSIZEDATA_DAT];

            // initWithCoder が call される
            obj = [NSKeyedUnarchiver unarchiveObjectWithFile:pstrFileName];

            NSMutableArray *parrTempData = [[NSMutableArray alloc] initWithCapacity:[obj count]];

            for (NSInteger nIndex = 0; nIndex < [obj count]; nIndex++)
            {
                // RSCustomPaperSizeDataクラスの生成
                RSCustomPaperSizeData *rsCustomPaperSizeData = [[RSCustomPaperSizeData alloc] init];
                // カスタムサイズ情報をDATファイルから取得
                rsCustomPaperSizeData = [obj objectAtIndex:nIndex];
                // カスタムサイズ情報をRSCustomPaperSizeDataクラスに追加
                [parrTempData addObject:rsCustomPaperSizeData];
            }
            return parrTempData;
        }
        @finally
        {
        }
    }

    return nil;
}

//
// カスタムサイズ情報の保存
//
- (BOOL)saveCustomData:(NSMutableArray *)rsCustomPaperSizeDataList
{
    //
    // 自動解放プールの作成
    //
    @autoreleasepool
    {
        @try {
            //
            // アーカイブする
            //
            NSString *fileName	= [RSCommonUtil.settingFileDir stringByAppendingString:S_CUSTOMSIZEDATA_DAT];
            
            if (![NSKeyedArchiver archiveRootObject:rsCustomPaperSizeDataList toFile:fileName]) {
                return FALSE;
                DLog(@"FALSE");
            };
            
        }
        @finally
        {
        }
    }
    
    return TRUE;
}

// ExecuteJobのGetパラメータを返却
- (NSMutableDictionary *)getExecuteJobParameter
{
    NSMutableDictionary *requestParameter = [[NSMutableDictionary alloc] init];

    // カラーモード
    [requestParameter setValue:[colorMode getSelectColorModeKey:originalSize] forKey:@"ColorMode"];

    // 原稿サイズ
    if ([[extraSizeListData getPaperSizeArray] containsObject:[self.originalSize getSelectValue]])
    {
        // 追加用紙が選択された場合
        [requestParameter setValue:@"manual" forKey:@"OriginalSize"];
        [requestParameter setValue:[NSString stringWithFormat:@"%d", [[extraSizeListData getCustomPaperSizeData:[self.originalSize getSelectValue]] getMilliWidth]] forKey:@"ManualSizeX"];
        [requestParameter setValue:[NSString stringWithFormat:@"%d", [[extraSizeListData getCustomPaperSizeData:[self.originalSize getSelectValue]] getMilliHeight]] forKey:@"ManualSizeY"];
        // ExecuteJobには送らない
        //        [requestParameter setValue:[originalSize getSelectValue] forKey:@"ManualSizeName"];
    }
    else if ([[customSizeListData getPaperSizeArray] containsObject:[self.originalSize getSelectValue]])
    {
        // カスタムサイズ用紙が選択された場合
        [requestParameter setValue:@"manual" forKey:@"OriginalSize"];
        [requestParameter setValue:[NSString stringWithFormat:@"%d", [[customSizeListData getCustomPaperSizeData:[self.originalSize getSelectValue]] getMilliWidth]] forKey:@"ManualSizeX"];
        [requestParameter setValue:[NSString stringWithFormat:@"%d", [[customSizeListData getCustomPaperSizeData:[self.originalSize getSelectValue]] getMilliHeight]] forKey:@"ManualSizeY"];
        // ExecuteJobには送らない
        //        [requestParameter setValue:[originalSize getSelectValue] forKey:@"ManualSizeName"];
    }
    else
    {
        //MFPから取得した用紙サイズ
        [requestParameter setValue:[self.originalSize getSelectValue] forKey:@"OriginalSize"];
    }

    // 保存サイズ
    if ([[extraSizeListData getPaperSizeArray] containsObject:[sendSize getSelectValue]])
    {
        // 追加用紙が選択された場合
        [requestParameter setValue:@"manual" forKey:@"SendSize"];
        [requestParameter setValue:[NSString stringWithFormat:@"%d", [[extraSizeListData getCustomPaperSizeData:[sendSize getSelectValue]] getMilliWidth]] forKey:@"ManualSizeX"];
        [requestParameter setValue:[NSString stringWithFormat:@"%d", [[extraSizeListData getCustomPaperSizeData:[sendSize getSelectValue]] getMilliHeight]] forKey:@"ManualSizeY"];
    }
    else if ([[customSizeListData getPaperSizeArray] containsObject:[sendSize getSelectValue]])
    {
        // カスタムサイズ用紙が選択された場合
        [requestParameter setValue:@"manual" forKey:@"SendSize"];
        [requestParameter setValue:[NSString stringWithFormat:@"%d", [[customSizeListData getCustomPaperSizeData:[sendSize getSelectValue]] getMilliWidth]] forKey:@"ManualSizeX"];
        [requestParameter setValue:[NSString stringWithFormat:@"%d", [[customSizeListData getCustomPaperSizeData:[sendSize getSelectValue]] getMilliHeight]] forKey:@"ManualSizeY"];
    }
    else
    {
        //MFPから取得した用紙サイズ
        [requestParameter setValue:[sendSize getSelectValue] forKey:@"SendSize"];
    }
    
    // 解像度
    NSString *resolutionKey = [resolution getSelectResolutionKey:self.formatData
                                                       colorMode:self.colorMode
                                                    originalSize:self.originalSize];
    [requestParameter setValue:resolutionKey forKey:@"Resolution"];

    // 濃度レベルが0（自動）以外の場合
    if (0 != [exposureLevel selectValue])
    {
        // 濃度
        [requestParameter setValue:[exposureMode getSelectValue] forKey:@"ExposureMode"];
    }
    // 濃度レベル
    [requestParameter setValue:[NSString stringWithFormat:@"%d", [exposureLevel selectValue]] forKey:@"ExposureLevel"];
    [requestParameter setValue:[duplexData getSelectDuplexModeValue] forKey:@"DuplexMode"];
    if ([[duplexData getSelectDuplexModeValue] isEqualToString:@"duplex"])
    {
        [requestParameter setValue:[duplexData getSelectDuplexDirValue] forKey:@"DuplexDir"];
    }

    // ファイル形式を取得する
    NSString *fileFormat = nil;

    if ([colorMode isMonochrome:originalSize])
    {
        // 白黒２値の場合
        //        [formatData setSelectColorModeValue:E_RSSVFORMATDATA_COLOR_MODE_MONOCHROME];
        fileFormat = [self.formatData getSelectValue:E_RSSVFORMATDATA_COLOR_MODE_MONOCHROME];
    }
    else
    {
        // カラーモードが自動、フルカラーと、グレースケールの場合
        //        [formatData setSelectColorModeValue:E_RSSVFORMATDATA_COLOR_MODE_FULLCOLOR];
        fileFormat = [self.formatData getSelectValue:E_RSSVFORMATDATA_COLOR_MODE_FULLCOLOR];
    }

    if ([colorMode isMonochrome:originalSize] && [fileFormat isEqualToString:@"jpeg"])
    {
        [requestParameter setValue:@"tiff" forKey:@"FileFormat"];
    }
    else
    {
        [requestParameter setValue:fileFormat forKey:@"FileFormat"];
    }

    if ([fileFormat rangeOfString:@"compact"].location == NSNotFound && [fileFormat rangeOfString:@"priority_black"].location == NSNotFound) //プライオリティブラックがなかったら
    {
        // 高圧縮(高精細)PDF以外

        if ([colorMode isMonochrome:originalSize] || [originalSize isLong])
        {
            // 白黒２値もしくは長尺
            
            // 圧縮形式がUIに表示されているかの判定(Ofiiceかそうでないか)
            if ([self needMonoochromeCompression:fileFormat])
            {
                // 圧縮形式を取得
                NSString *compression = [self.formatData getSelectCompressionValue];
                if (compression)
                {
                    [requestParameter setValue:compression forKey:@"Compression"];
                }
            }
            else
            {
                // 白黒2値でOfficeの場合は圧縮形式none
                [requestParameter setValue:@"none" forKey:@"Compression"];
            }
        }
        else
        {
            // 自動/フルカラー/グレースケール
            // 圧縮率を取得
            NSString *compressionRatio = [self.formatData getSelectCompressionRatioValue];
            if (compressionRatio)
            {
                // カラーの場合は圧縮形式(Compression)にjpegを指定する
                [requestParameter setValue:@"jpeg" forKey:@"Compression"];
                // jpegを指定する場合は、圧縮率(compressionRatio)を指定する
                [requestParameter setValue:compressionRatio forKey:@"CompressionRatio"];
            }
        }
    }
    else
    {
        // 高圧縮・高圧縮高精細・黒文字重視の場合、Compression = "jpeg"、CompressionRatio = なし
        [requestParameter setValue:@"jpeg" forKey:@"Compression"];
    }
    
    [requestParameter setValue:[rotation getSelectValue] forKey:@"Rotation"];

    if (self.formatData.isPagePerFile)
    {
        // ページ数(0なら1)として送る
        [requestParameter setValue:[NSString stringWithFormat:@"%d", (self.formatData.selectPagePerFile ? self.formatData.selectPagePerFile : 1)] forKey:@"PagesPerFile"];
    }
    else
    {
        // ページ毎にファイル化機能が無効の場合は、0を送る
        [requestParameter setValue:[NSString stringWithFormat:@"0"] forKey:@"PagesPerFile"];
    }

    if (self.formatData.isEncript && [fileFormat rangeOfString:@"encrypt"].location != NSNotFound)
    {
        [requestParameter setValue:[self.formatData getSelectEncryptValue] forKey:@"PdfPassword"];
    }

    // ExecuteJobには送らない
    //    [requestParameter setValue:[NSString stringWithFormat:@"%d", formatData.nSelectColorMode] forKey:@"SelectColorMode"];

    // 特別機能(白紙飛ばし/マルチクロップ)
    [requestParameter setValue:[specialMode getSelectValue] forKey:@"SpecialMode"];
    
    // UseOCRが取得できた、かつOCRの設定が表示されている場合のみ設定する
    if (self.formatData.validOCR && [self.formatData isVisibleOCR:fileFormat])
    {
        if (self.formatData.isOCR)
        {
            [requestParameter setValue:@"true" forKey:@"UseOCR"];
            
            NSString *ocrLanguageKey = [self.formatData getSelectOCRLanguageKey];
            if ([[self.formatData getSelectableOCRLanguageKeys] containsObject:ocrLanguageKey])
            {
                [requestParameter setValue:ocrLanguageKey forKey:@"OCRLanguage"];
            }
            
            NSString *ocrOutputFontKey = [self.formatData getSelectOCROutputFontKey];
            if ([[self.formatData getSelectableOCROutputFontKeys:ocrLanguageKey] containsObject:ocrOutputFontKey]) {
                [requestParameter setValue:ocrOutputFontKey forKey:@"OCROutputFont"];
            }
            
            // 原稿向き検知が取得できた場合のみ設定する
            if (self.formatData.validCorrectImaegRotation)
            {
                if (self.formatData.isCorrectImageRotation)
                {
                    [requestParameter setValue:@"true" forKey:@"CorrectImageRotation"];
                }
                else
                {
                    [requestParameter setValue:@"false" forKey:@"CorrectImageRotation"];
                }
            }
            
            // ファイル名抽出が取得できた場合のみ設定する
            if (self.formatData.validExtractFileName)
            {
                if (self.formatData.isExtractFileName)
                {
                    [requestParameter setValue:@"true" forKey:@"ExtractFileName"];
                }
                else
                {
                    [requestParameter setValue:@"false" forKey:@"ExtractFileName"];
                }
            }
            
            // OCR精度が対応の場合のみ設定する
            if (self.formatData.validOCRAccuracy) {
                NSString *ocrAccuracyKey = [self.formatData getSelectOCRAccuracyKey];
                if ([[self.formatData getSelectableOCRAccuracyKeys] containsObject:ocrAccuracyKey])
                {
                    [requestParameter setValue:ocrAccuracyKey forKey:@"OCRAccuracy"];
                }
            }
        }
        else
        {
            // OCRがNOの場合はUseOCR以外の情報は設定しない
            [requestParameter setValue:@"false" forKey:@"UseOCR"];
        }
    }

    return requestParameter;
}

// RemoteScanの画面設定値を返却
- (NSMutableDictionary *)getRemoteScanParameter
{
    NSMutableDictionary *requestParameter = [[NSMutableDictionary alloc] init];

    [requestParameter setValue:[self.colorMode getSelectValue] forKey:@"ColorMode"];

    // 原稿サイズ
    if ([[extraSizeListData getPaperSizeArray] containsObject:[self.originalSize getSelectValue]])
    {
        // 追加用紙が選択された場合
        [requestParameter setValue:@"manual" forKey:@"OriginalSize"];
        [requestParameter setValue:[NSString stringWithFormat:@"%d", [[extraSizeListData getCustomPaperSizeData:[self.originalSize getSelectValue]] getMilliWidth]] forKey:@"ManualSizeX"];
        [requestParameter setValue:[NSString stringWithFormat:@"%d", [[extraSizeListData getCustomPaperSizeData:[self.originalSize getSelectValue]] getMilliHeight]] forKey:@"ManualSizeY"];
        [requestParameter setValue:[self.originalSize getSelectValue] forKey:@"ManualSizeName"];
    }
    else if ([[customSizeListData getPaperSizeArray] containsObject:[self.originalSize getSelectValue]])
    {
        // カスタムサイズ用紙が選択された場合
        [requestParameter setValue:@"manual" forKey:@"OriginalSize"];
        [requestParameter setValue:[NSString stringWithFormat:@"%d", [[customSizeListData getCustomPaperSizeData:[self.originalSize getSelectValue]] getMilliWidth]] forKey:@"ManualSizeX"];
        [requestParameter setValue:[NSString stringWithFormat:@"%d", [[customSizeListData getCustomPaperSizeData:[self.originalSize getSelectValue]] getMilliHeight]] forKey:@"ManualSizeY"];
        [requestParameter setValue:[self.originalSize getSelectValue] forKey:@"ManualSizeName"];
    }
    else
    {
        //MFPから取得した用紙サイズ
        [requestParameter setValue:[self.originalSize getSelectValue] forKey:@"OriginalSize"];
    }

    // 保存サイズ
    if ([[extraSizeListData getPaperSizeArray] containsObject:[sendSize getSelectValue]])
    {
        // 追加用紙が選択された場合
        [requestParameter setValue:@"manual" forKey:@"SendSize"];
        [requestParameter setValue:[NSString stringWithFormat:@"%d", [[extraSizeListData getCustomPaperSizeData:[sendSize getSelectValue]] getMilliWidth]] forKey:@"ManualSizeX"];
        [requestParameter setValue:[NSString stringWithFormat:@"%d", [[extraSizeListData getCustomPaperSizeData:[sendSize getSelectValue]] getMilliHeight]] forKey:@"ManualSizeY"];
    }
    else if ([[customSizeListData getPaperSizeArray] containsObject:[sendSize getSelectValue]])
    {
        // カスタムサイズ用紙が選択された場合
        [requestParameter setValue:@"manual" forKey:@"SendSize"];
        [requestParameter setValue:[NSString stringWithFormat:@"%d", [[customSizeListData getCustomPaperSizeData:[sendSize getSelectValue]] getMilliWidth]] forKey:@"ManualSizeX"];
        [requestParameter setValue:[NSString stringWithFormat:@"%d", [[customSizeListData getCustomPaperSizeData:[sendSize getSelectValue]] getMilliHeight]] forKey:@"ManualSizeY"];
    }
    else
    {
        //MFPから取得した用紙サイズ
        [requestParameter setValue:[sendSize getSelectValue] forKey:@"SendSize"];
    }

    [requestParameter setValue:[resolution getSelectValue] forKey:@"Resolution"];
    [requestParameter setValue:[exposureMode getSelectValue] forKey:@"ExposureMode"];
    [requestParameter setValue:[NSString stringWithFormat:@"%d", [exposureLevel selectValue]] forKey:@"ExposureLevel"];
    [requestParameter setValue:[duplexData getSelectDuplexModeValue] forKey:@"DuplexMode"];
    if ([[duplexData getSelectDuplexModeValue] isEqualToString:@"duplex"])
    {
        [requestParameter setValue:[duplexData getSelectDuplexDirValue] forKey:@"DuplexDir"];
    }

    // ファイル形式を取得する
    NSString *fileFormat = [self.formatData getSelectFileFormatValue];

    if ([self.colorMode isMonochrome:self.originalSize])
    {
        // 白黒２値の場合
        [self.formatData setSelectColorModeValue:E_RSSVFORMATDATA_COLOR_MODE_MONOCHROME];
        [self.formatData setSelectValue];
    }
    else
    {
        // カラーモードが自動、フルカラーと、グレースケールの場合
        [self.formatData setSelectColorModeValue:E_RSSVFORMATDATA_COLOR_MODE_FULLCOLOR];
    }

    [requestParameter setValue:fileFormat forKey:@"FileFormat"];

    DLog(@"fileFormat = %@", fileFormat);

    // 画面設定値を全て保存するため、条件は不要
    //    if([fileFormat rangeOfString:@"compact"].location == NSNotFound && [fileFormat rangeOfString:@"priority_black"].location == NSNotFound)  //プライオリティブラックがなかったら
    //    {
    // 高圧縮(高精細)PDF以外

    //        if([[colorMode getSelectValue] isEqualToString:@"monochrome"]){
    //            // 白黒
    //            // 圧縮形式を取得
    NSString *compression = [self.formatData getSelectCompressionValue];
    //            if(compression){
    [requestParameter setValue:compression forKey:@"Compression"];
    //            }
    //        }else{
    //            // カラー/グレースケール
    //            // 圧縮率を取得
    if ([fileFormat rangeOfString:@"priority_black"].location == NSNotFound)
    {
        NSString *compressionRatio = [self.formatData getSelectCompressionRatioValue];
        if (compressionRatio)
        {
            [requestParameter setValue:compressionRatio forKey:@"CompressionRatio"];
        }
    }
    //            }
    //        }
    //    }
    [requestParameter setValue:[rotation getSelectValue] forKey:@"Rotation"];

    if (self.formatData.isPagePerFile)
    {
        [requestParameter setValue:[NSString stringWithFormat:@"%d", (self.formatData.selectPagePerFile ? self.formatData.selectPagePerFile : 1)] forKey:@"PagesPerFile"];
    }
    else {
        [requestParameter setValue:[NSString stringWithFormat:@"%d", 0] forKey:@"PagesPerFile"];
    }
    
    if (self.formatData.isEncript)
    {
        [requestParameter setValue:[self.formatData getSelectEncryptValue] forKey:@"PdfPassword"];
    }

    [requestParameter setValue:[NSString stringWithFormat:@"%d", self.formatData.nSelectColorMode] forKey:@"SelectColorMode"];

    // 特別機能(白紙飛ばし/マルチクロップ)
    [requestParameter setValue:[specialMode getSelectValue] forKey:@"SpecialMode"];
    
    if (self.formatData.isOCR)
    {
        [requestParameter setValue:@"true" forKey:@"UseOCR"];
    }
    else
    {
        [requestParameter setValue:@"false" forKey:@"UseOCR"];
    }
    
    [requestParameter setValue:[self.formatData getSelectOCRLanguageKey] forKey:@"OCRLanguage"];
    [requestParameter setValue:[self.formatData getSelectOCROutputFontKey] forKey:@"OCROutputFont"];
    
    if (self.formatData.isCorrectImageRotation)
    {
        [requestParameter setValue:@"true" forKey:@"CorrectImageRotation"];
    }
    else
    {
        [requestParameter setValue:@"false" forKey:@"CorrectImageRotation"];
    }
    
    if (self.formatData.isExtractFileName)
    {
        [requestParameter setValue:@"true" forKey:@"ExtractFileName"];
    }
    else
    {
        [requestParameter setValue:@"false" forKey:@"ExtractFileName"];
    }
    // OCR精度
    [requestParameter setValue:[self.formatData getSelectOCRAccuracyKey] forKey:@"OCRAccuracy"];
    
    return requestParameter;
}

// 現在の設定を保存する
- (BOOL)saveRemoteScanSettings
{
    //    return [[RemoteScanDataManager sharedManager] saveRemoteScanSettings:[self getExecuteJobParameter]];
    // 設定を保存する時は、画面設定値を全て保存する"getRemoteScanParameter"で保存を行う
    return [[RemoteScanDataManager sharedManager] saveRemoteScanSettings:[self getRemoteScanParameter]];
}

// 現在保存されている設定値を読み込む
- (RemoteScanData *)loadRemoteScanSettings
{
    return [[RemoteScanDataManager sharedManager] loadRemoteScanSettings];
}

// カスタムサイズの設定を更新する
- (RSSVOriginalSizeData *)reloadOriginalSize:(RSSettableElementsData *)data ManuscriptSizeIndexRow:(NSInteger)row
{

    // 選択していた原稿を一時退避する
    NSString *selectedOriginalSize = [self.originalSize getSelectValue];

    // 現在のRSSettableElementsDataを原稿サイズにセット
    originalSize = [[RSSVOriginalSizeData alloc] initWithDictionary:[data.originalSizeData getCapableOptions]
                                                               keys:[data.originalSizeData getCapableOptionsKeys]
                                                       defaultValue:[data.originalSizeData getDefaultKey]];
    // 最新のカスタムサイズの値を取得する
    [self createExtraSize];
    [self createCustomSize];

    // 最新のカスタムサイズを追加する
    [self.originalSize addEntriesFromDictionary:[extraSizeListData getPagerSizeDict] keys:[extraSizeListData getPaperSizeArray]];
    [self.originalSize addEntriesFromDictionary:[customSizeListData getPagerSizeDict] keys:[customSizeListData getPaperSizeArray]];

    // 選択していた原稿を再設定する
    [self.originalSize setSelectKey:selectedOriginalSize];
    
    return self.originalSize;
}

// 白黒2値の場合に圧縮形式が必要な場合YESを返す
- (BOOL)needMonoochromeCompression:(NSString *)fileFormat
{
    if ([fileFormat isEqualToString:@"docx"])
    {
        return NO;
    }
    
    if ([fileFormat isEqualToString:@"xlsx"])
    {
        return NO;
    }
    
    if ([fileFormat isEqualToString:@"pptx"])
    {
        return NO;
    }
    
    return YES;
}


#pragma mark - Update Value For MultiCrop ON

// マルチクロップONによる他項目の値の変更
- (void)updateRssViewDataForMultiCropOn:(RSSEFileFormatData *)rsseFileFormatData {
    
    // 原稿サイズ
    [originalSize setSelectKey:@"auto"];
    
    // 保存サイズ
    [sendSize setSelectKey:@"auto"];
    
    // 画像セットの方向
    [rotation setSelectKey:@"rot_off"];
    
    // 両面
    [duplexData setSelectModeKey:@"simplex" dirKey:[duplexData getSelectDuplexDirValue]];
    
    // ファイル形式 (/ OCR必須フォーマット / 高圧縮PDFのタイプ / 圧縮率 /)
    BOOL bResolutionLimited = [self.formatData updateFormatDataForMultiCropOn:rsseFileFormatData];
    
    // ページ毎にファイル化/ページ数
    self.formatData.isPagePerFile = YES;
    self.formatData.selectPagePerFile = 1;
    
    // OCR
    [self.formatData clearOcrValue];
    
    // 解像度
    [self updateResolutionForMultiCropOn:bResolutionLimited];
    
    // 白紙飛ばし
    [specialMode.blankPageSkipData setSelectKey:@"none"];
    
}

// マルチクロップOFFによる他項目の値の変更
- (void)updateRssViewDataForMultiCropOff {
    
    // ファイル形式のリスト更新
    [self.formatData updateFormatDataToLimitNone];
    
}

// マルチクロップONになったときの解像度の更新処理
- (void)updateResolutionForMultiCropOn:(BOOL)bResolutionLimited {
    
    // 高圧縮PDFである場合か黒文字重視が直前の状態で選択されていた場合は
    // 300dpiを固定で選択するようにし、下の処理をさせない。
    // 白黒２値の場合はこの処理はしない。
    if (bResolutionLimited && ![colorMode isMonochrome:originalSize]) {
        
        if ([resolution isExistKey:@"300"]) {
            [resolution setSelectKey:@"300"];
        }
        else {
            
        }
        return;
    }
    
    if ([[resolution getSelectValueName] isEqualToString:S_RS_XML_RESOLUTION_600]) {
        
        // 600dpiが選択されていた場合
        
        //// この時点で一番大きいインデックスに設定する場合 ////
        /*
         NSInteger maxIndex =  [resolution getSelectableResolutionValues:self.formatData
         colorMode:colorMode
         originalSize:originalSize
         multiCrop:YES].count - 1;
         
         NSString *newKey = [resolution getSelectValue:(int)maxIndex];
         [resolution setSelectKey:newKey];
         */
        //////////
        
        //// この時点で一番大きい値を探して設定する場合 リストの最大値が現在は600dpiであることを前提としている(SDM仕様) ////
        NSArray *selectableArray = [[resolution getSelectableResolutionValues:self.formatData
                                                                    colorMode:colorMode
                                                                 originalSize:originalSize
                                                                    multiCrop:YES] copy];
        
        
        //array = @[@"90", @"300", @"100", @"700", @"1200", @"500"];
        
        selectableArray = [selectableArray sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
            NSStringCompareOptions compareOptions = (NSNumericSearch);
            return [obj1 compare:obj2 options:compareOptions];
        }];
        
        NSInteger maxIndex = selectableArray.count - 1;
        NSString *newKey = [resolution getSelectValue:(int)maxIndex];
        [resolution setSelectKey:newKey];
        
        //////////
        
        //// 一番近いインデックスに設定する場合 ////
        /*
         NSInteger index = [resolution getSelectIndex];
         NSString *newKey;
         if (index - 1 >= 0) {
         newKey = [resolution getSelectValue:(int)index - 1];
         }
         else if (index == 0 && [resolution getSelectableArray].count > 1) {
         newKey = [resolution getSelectValue:(int)index + 1];
         }
         [resolution setSelectKey:newKey];
         */
        //////////
    }
}

#pragma mark - Update Value For OriginalSizeLong Selected

// 長尺選択による他(画面)項目の値の変更
- (void)updateRssViewDataForLongSizeSelect:(RSSEFileFormatData *)rsseFileFormatData {
    
    // ファイル形式
    [self.formatData updateFormatDataForOriginalSizeLong:rsseFileFormatData];
    
    // OCR
    [self.formatData clearOcrValue];

}

// ファイル形式のリスト更新(制限なしにする)
- (void)updateRssViewDataForLongSizeDeselect {
    
    // ファイル形式のリスト更新
    [self.formatData updateFormatDataToLimitNone];
}

@end
