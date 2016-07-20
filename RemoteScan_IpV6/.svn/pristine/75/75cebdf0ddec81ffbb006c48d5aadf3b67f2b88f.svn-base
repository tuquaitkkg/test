
#import "RSS_FormatViewController_iPad.h"
#import "PickerViewController_iPad.h"
#import "SwitchDataCell.h"
#import "RemoteScanBeforePictViewController_iPad.h"

@interface RSS_FormatViewController_iPad ()

enum{
    E_TABLE_SECTION_FILE_FORMAT,
    E_TABLE_SECTION_COMPACT_PDF,
    E_TABLE_SECTION_COMPRESSION,
    E_TABLE_SECTION_PAGE_PER_FILE,
    E_TABLE_SECTION_PDF_PASSWORD,
    E_TABLE_SECTION_OCR_USE,
    E_TABLE_SECTION_OCR_LANGUAGE,
    E_TABLE_SECTION_OCR_OUTPUT_FONT,
    E_TABLE_SECTION_OCR_CORRECT_IMAGE_ROTATION,
    E_TABLE_SECTION_OCR_EXTRACT_FILE_NAME,
    E_TABLE_SECTION_OCR_ACCURACY,
    
    E_TABLE_SECTION_NUM,
};

@end

@implementation RSS_FormatViewController_iPad
@synthesize parentVCDelegate;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        fileFormatList = [[NSMutableArray alloc]initWithObjects:S_RS_XML_FILE_FORMAT_PDF, S_RS_XML_FILE_FORMAT_PDFA, S_RS_XML_FILE_FORMAT_TIFF, S_RS_XML_FILE_FORMAT_JPEG, nil];
        compressionPDFTypeList = [[NSMutableArray alloc]initWithObjects:S_RS_XML_NONE, S_RS_XML_FILE_FORMAT_COMPACT_PDF, S_RS_XML_FILE_FORMAT_COMPACT_PDF_ULTRA_FINE, nil];
        compressionRatioList = [[NSMutableArray alloc]initWithObjects:S_RS_XML_COMPRESSION_RATIO_LOW, S_RS_XML_COMPRESSION_RATIO_MIDDLE, S_RS_XML_COMPRESSION_RATIO_HIGH, S_RS_XML_FILE_FORMAT_PRIORITY_BLACK_PDF, nil];
        monoImageCompressionTypeList = [[NSMutableArray alloc]initWithObjects:S_RS_XML_COMPRESSION_NONE, S_RS_XML_COMPRESSION_MH, S_RS_XML_COMPRESSION_MMR, nil];
        ocrLanguageKeys = @[
                            @"ja",
                            @"en",
                            @"de",
                            @"fr",
                            @"es",
                            @"it",
                            @"nl",
                            @"ca_es",
                            @"sv",
                            @"no",
                            @"fi",
                            @"da",
                            @"cs",
                            @"pl",
                            @"hu",
                            @"el",
                            @"ru",
                            @"pt",
                            @"tr",
                            @"sk",
                            @"zh_cn",// 中国
                            @"zh_tw",// 台湾
                            @"ko",// 韓国
                            ];
        ocrOutputFontKeys = @[
                              @"ms_gothic",
                              @"ms_mincho",
                              @"ms_pgothic",
                              @"ms_pmincho",
                              @"simsun",
                              @"simhei",
                              @"mingliu",
                              @"pmingliu",
                              @"dotum",
                              @"batang",
                              @"malgun_gothic",
                              @"arial",
                              @"times_new_roman",
                              ];
        ocrAccuracyKeys = @[@"auto", @"priority_text"];
        
        strSelectFileFormatValue = fileFormatList[0];
        nSelectCompressionPDFTypeIndexRow = 0;
        strSelectCompressionRatioValue = compressionRatioList[1];
        nSelectMonoImageCompressionTypeListIndexRow = 0;
        strSelectOCRLanguageKey = ocrLanguageKeys[0];
        strSelectOCROutputFontKey = ocrOutputFontKeys[0];
        strSelectOCRAccuracyKey = ocrAccuracyKeys[0];
        
        bEveryPageFiling = NO;
        bEncrypt = NO;
        nSelectPageNum = 1;
        
        validOCR = NO;
        validOCRAccuracy = NO;
        bOCR = NO;
        bCorrectImageRotation = NO;
        bExtractFileName = NO;
        
    }
    return self;
}

- (id)initWithDelegate:(RemoteScanBeforePictViewController_iPad *)delegate
{
    self = [super initWithNibName:@"RSS_FormatViewController_iPad" bundle:nil];
    if(self){
        self.parentVCDelegate = delegate;
        
        fileFormatList = [[NSMutableArray alloc]init];
        [fileFormatList addObjectsFromArray:[parentVCDelegate.rssViewData.formatData getSelectableFileFormatArray]];
        strSelectFileFormatValue = [parentVCDelegate.rssViewData.formatData getSelectFileFormatValueName];
        
        compressionPDFTypeList = [[NSMutableArray alloc]init];
        [compressionPDFTypeList addObjectsFromArray:[parentVCDelegate.rssViewData.formatData getSelectableCompactPdfTypeArray]];
        nSelectCompressionPDFTypeIndexRow = [parentVCDelegate.rssViewData.formatData getSelectCompactPdfTypeIndex];
        
        compressionRatioList = [[NSMutableArray alloc]init];
        [compressionRatioList addObjectsFromArray:[parentVCDelegate.rssViewData.formatData getSelectableCompressionRatioArray:[parentVCDelegate.rssViewData.specialMode isMultiCropOn]]];
        strSelectCompressionRatioValue = [parentVCDelegate.rssViewData.formatData getSelectCompressionRatioValueName:strSelectFileFormatValue];
        
        monoImageCompressionTypeList = [[NSMutableArray alloc]init];
        [monoImageCompressionTypeList addObjectsFromArray:[parentVCDelegate.rssViewData.formatData getSelectableCompressionArray]];
        nSelectMonoImageCompressionTypeListIndexRow = [parentVCDelegate.rssViewData.formatData getSelectCompressionIndex];
        
        // 言語設定
        ocrLanguageKeys = [parentVCDelegate.rssViewData.formatData getSelectableOCRLanguageKeys];
        strSelectOCRLanguageKey = [parentVCDelegate.rssViewData.formatData getSelectOCRLanguageKey];
        
        // フォント
        strSelectOCROutputFontKey = [parentVCDelegate.rssViewData.formatData getSelectOCROutputFontKey];
        [self updateSelectableOutputFont];
        
        // OCR精度
        validOCRAccuracy = parentVCDelegate.rssViewData.formatData.validOCRAccuracy;
        ocrAccuracyKeys = [parentVCDelegate.rssViewData.formatData getSelectableOCRAccuracyKeys];
        strSelectOCRAccuracyKey = [parentVCDelegate.rssViewData.formatData getSelectOCRAccuracyKey];
        
        bEveryPageFiling = parentVCDelegate.rssViewData.formatData.isPagePerFile;
        nSelectPageNum = parentVCDelegate.rssViewData.formatData.selectPagePerFile;
        bEncrypt = parentVCDelegate.rssViewData.formatData.isEncript;
        
        // OCRスイッチを表示するかどうか
        validOCR = parentVCDelegate.rssViewData.formatData.validOCR;
        // OCRのON,OFF
        bOCR = parentVCDelegate.rssViewData.formatData.isOCR;
        // 原稿向き検知のON,OFF
        bCorrectImageRotation = parentVCDelegate.rssViewData.formatData.isCorrectImageRotation;
        // ファイル名抽出のON,OFF
        bExtractFileName = parentVCDelegate.rssViewData.formatData.isExtractFileName;
    }
    
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // セルのラインを表示する
    formatTableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    
    //// スクロールを無効にする
    //[formatTableView setScrollEnabled:NO];
    
    [scColorMode setTitle: S_BUTTON_FORMAT_COLOR forSegmentAtIndex: 0];
    [scColorMode setTitle: S_BUTTON_FORMAT_MONOCHROME forSegmentAtIndex: 1];
    // セグメントのラベルプロパティ変更
    [self changeSegmentLabelProperty: scColorMode];
    
    // テーブルの背景色を設定
    UIView* bgView = [[UIView alloc]initWithFrame:formatTableView.frame];
    [formatTableView setBackgroundView:bgView];

    // テーブルのセクションIDリストを初期化
    tableSectionIDs = [[NSMutableArray alloc]init];
    for(int i = 0; i < E_TABLE_SECTION_NUM; i++){
        if([self visibleSection:i]){
            [tableSectionIDs addObject:[NSNumber numberWithInt:i]];
        }
    }
    
    // ナビゲーションバーの設定
    if(parentVCDelegate){
        [parentVCDelegate setNavigationBarTitle:S_TITLE_FORMAT leftButton:nil rightButton:nil];
    }

    pageNumLbl                  = [[UILabel alloc]initWithFrame:(CGRect){0,0,0,0}];
    pageNumLbl.font             = [UIFont systemFontOfSize:14];
    pageNumLbl.textAlignment    = NSTextAlignmentRight;
    pageNumLbl.backgroundColor  = [UIColor clearColor];
    pageNumLbl.textColor        = [UIColor blackColor];
    pageNumLbl.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleRightMargin;
    
    // 名称テキストフィールド初期化
    passwordTextField = [[UITextField alloc] init];
    [passwordTextField setText:[parentVCDelegate.rssViewData.formatData password]];
    [self settingDefaultTextField: passwordTextField];

    // パスワード変更イベント
    [passwordTextField addTarget:self action:@selector(changePassowrdText:) forControlEvents:UIControlEventEditingChanged];
    [scColorMode setSelectedSegmentIndex: parentVCDelegate.rssViewData.formatData.nSelectColorMode];
    [self tapScColorMode:scColorMode];
    
    // フラグ初期化
    bBeforeJpeg = NO;

    // 前回選択値がjpegならフラグをYES
    if([parentVCDelegate.rssViewData.formatData getOriginalFileFormatIndex] == [parentVCDelegate.rssViewData.formatData getSelectFileFormatJpegIndex])
    {
        bBeforeJpeg = YES;
    }
}

- (void)viewDidUnload
{
    fileFormatList = nil;
    compressionPDFTypeList = nil;
    compressionRatioList = nil;
    monoImageCompressionTypeList = nil;
    pageNumLbl = nil;
    formatTableView = nil;
    [super viewDidUnload];
}

// テキストフィールドのデフォルト設定
- (void)settingDefaultTextField:(UITextField*)textField
{
    textField.font                      = [UIFont systemFontOfSize:14];
    textField.contentVerticalAlignment	= UIControlContentVerticalAlignmentCenter;
    textField.backgroundColor			= [UIColor clearColor];
    textField.textColor					= [UIColor blackColor];
    textField.autoresizingMask			= UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleRightMargin;
    textField.keyboardType              = UIKeyboardTypeDefault;
    textField.keyboardAppearance        = UIKeyboardAppearanceLight;
    textField.clearButtonMode           = UITextFieldViewModeWhileEditing;
    textField.returnKeyType				= UIReturnKeyDone;
    if ([S_LANG isEqualToString:S_LANG_JA])
    {
        // 国内版の場合、表示文字を小さくする
        textField.adjustsFontSizeToFitWidth = YES;
        textField.minimumFontSize = 7;
    }
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
	return YES;
}


#pragma mark - UIObject Action
// カラーモード切替
- (IBAction)tapScColorMode:(UISegmentedControl *)sender
{
    // セグメントを切り替えるとフォント設定がクリアされるので再度設定する
    // セグメントのラベルプロパティ変更
    [self changeSegmentLabelProperty: scColorMode];

    if(sender.selectedSegmentIndex == 0){
        // カラーグレースケール
        [parentVCDelegate.rssViewData.formatData setSelectColorModeValue:E_RSSVFORMATDATA_COLOR_MODE_FULLCOLOR];
        // 白黒でjpegの場合は、tiffに変更する
        if(bBeforeJpeg)
        {
            strSelectFileFormatValue = [parentVCDelegate.rssViewData.formatData getSelectFileFormatJpegValue];
        }
    }else{
        // 白黒
        // JPEGの場合TIFFに変更されるので、フォーマット選択インデックスを再取得
        if([strSelectFileFormatValue isEqualToString:[parentVCDelegate.rssViewData.formatData getSelectFileFormatJpegValue]])
        {
            bBeforeJpeg = YES;
        }
        [parentVCDelegate.rssViewData.formatData setSelectColorModeValue:E_RSSVFORMATDATA_COLOR_MODE_MONOCHROME];

        // 選択しているフォーマットを表示する
//            nSelectFileFormatIndexRow = [parentVCDelegate.rssViewData.formatData getSelectFileFormatIndex];
        strSelectFileFormatValue = [parentVCDelegate.rssViewData.formatData getSelectFileFormatValue:sender.selectedSegmentIndex selectFileFormat:strSelectFileFormatValue];
    }
    // フォーマットリストの再取得
    [fileFormatList removeAllObjects];
    [fileFormatList addObjectsFromArray:[parentVCDelegate.rssViewData.formatData getSelectableFileFormatArray]];

    // 圧縮タイプリストの再取得
    [monoImageCompressionTypeList removeAllObjects];
    [monoImageCompressionTypeList addObjectsFromArray:[parentVCDelegate.rssViewData.formatData getSelectableCompressionArray]];
    
    // 言語設定の再取得
    ocrLanguageKeys = [parentVCDelegate.rssViewData.formatData getSelectableOCRLanguageKeys];
    
    // フォントの再取得
    [self updateSelectableOutputFont];

    // セクションの削除と挿入
    [self sectionDeleteAndInsert];
    [parentVCDelegate updateSetting];
}

// パスワード変更
- (IBAction)changePassowrdText:(UITextField *)sender
{
    [parentVCDelegate.rssViewData.formatData setPdfPasswordValue:sender.text];
}

-(IBAction)changeSwitchValue:(UISwitch*)sender
{
    switch (sender.tag) {
        case E_TABLE_SECTION_PAGE_PER_FILE:
            [parentVCDelegate.rssViewData.formatData setIsPagePerFile:sender.on];
            bEveryPageFiling = sender.on;
            break;
            
        case E_TABLE_SECTION_PDF_PASSWORD:
            [parentVCDelegate.rssViewData.formatData setIsEncript:sender.on];
            bEncrypt = sender.on;
            break;
            
        case E_TABLE_SECTION_OCR_USE:
            if (bOCR != sender.on) {
                bOCR = sender.on;
                [parentVCDelegate.rssViewData.formatData setIsOCR:bOCR];
                [self sectionDeleteAndInsert];
            }
            return;
            
        case E_TABLE_SECTION_OCR_CORRECT_IMAGE_ROTATION:
            // 原稿向き検知のON/OFFの切り替えのみ行う
            bCorrectImageRotation = sender.on;
            [parentVCDelegate.rssViewData.formatData setIsCorrectImageRotation:bCorrectImageRotation];
            return;
            
        case E_TABLE_SECTION_OCR_EXTRACT_FILE_NAME:
            // ファイル名抽出のON/OFFの切り替えのみ行う
            bExtractFileName = sender.on;
            [parentVCDelegate.rssViewData.formatData setIsExtractFileName:bExtractFileName];
            return;
            
        default:
            return;
            break;
    }
    
    int inSec = (int)[tableSectionIDs indexOfObject:[NSNumber numberWithInteger:sender.tag]];
    NSArray *indexPaths = [NSArray arrayWithObjects:[NSIndexPath indexPathForRow:1 inSection:inSec],nil];
    NSInteger nRowsCount = nRowsCount = [formatTableView numberOfRowsInSection:inSec];
    if(sender.on){
        if (nRowsCount == 1) {
            // 追加
            [formatTableView insertRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationAutomatic];
        }
    }else{
        if (nRowsCount == 2) {
            // 削除
            [formatTableView deleteRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationAutomatic];
        }
    }
}

#pragma mark - UITableViewDelegate
// セクション数
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [tableSectionIDs count];
}

// ヘッダー表示
- (void)SetHeaderView:(UITableView *)tableView
{
    tableView.tableHeaderView = scColorMode;
}

// セルの数
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    int res = 1;
    int sectionId = [[tableSectionIDs objectAtIndex:section] intValue];
    if(sectionId == E_TABLE_SECTION_COMPACT_PDF){
        // 高圧縮PDF
    }
    else if(sectionId == E_TABLE_SECTION_COMPRESSION){
        // 圧縮
    }
    else if(sectionId == E_TABLE_SECTION_PAGE_PER_FILE)
    {
        // ページ毎にファイル化
        // ON/OFF
        if(bEveryPageFiling){
            res = 2;
        }else{
            res = 1;
        }
    }
    else if(sectionId == E_TABLE_SECTION_PDF_PASSWORD)
    {
        // 暗号化
        // ON/OFF
        if(bEncrypt){
            res = 2;
        }else{
            res = 1;
        }
    }
    else if(sectionId == E_TABLE_SECTION_OCR_USE)
    {
        // OCR
        res = 1;
    }
    else if(sectionId == E_TABLE_SECTION_OCR_LANGUAGE)
    {
        // OCR言語設定
        res = 1;
    }
    else if(sectionId == E_TABLE_SECTION_OCR_OUTPUT_FONT)
    {
        // OCRフォント
        res = 1;
    }
    else if(sectionId == E_TABLE_SECTION_OCR_CORRECT_IMAGE_ROTATION)
    {
        // OCR原稿向き検知
        res = 1;
    }
    else if(sectionId == E_TABLE_SECTION_OCR_EXTRACT_FILE_NAME)
    {
        // OCRファイル名抽出
        res = 1;
    }
    
    return res;
}

-(BOOL)visibleSection:(int)sectionId
{
    BOOL res = YES;
//    NSString* fileType = [parentVCDelegate.rssViewData.formatData getSelectFileFormatValue];
    NSString* fileType = [self selectedFileType];
    
    if(sectionId == E_TABLE_SECTION_COMPACT_PDF){
        // 高圧縮PDF
        if([compressionPDFTypeList count] <= 1){
            // MPFが高圧縮に対応していない場合
            res = NO;
        }else{
            if([fileType rangeOfString:@"pdf"].location == NSNotFound){
                // pdf以外のときは非表示
                res = NO;
            }else if(scColorMode.selectedSegmentIndex != 0){
                // カラーモードが白黒のときは非表示
                res = NO;
            }
            else if ([parentVCDelegate.rssViewData.specialMode isMultiCropOn]) {
                // マルチクロップONのときは非表示
                res = NO;
            }
        }
    }
    else if(sectionId == E_TABLE_SECTION_COMPRESSION){
        // 圧縮
        if(scColorMode.selectedSegmentIndex == 0 &&
           [fileType rangeOfString:@"compact"].location != NSNotFound){
            // 高精細PDFの時は非表示
            res = NO;
        }
        
        if([fileType rangeOfString:@"docx"].location != NSNotFound ||
            [fileType rangeOfString:@"xlsx"].location != NSNotFound ||
            [fileType rangeOfString:@"pptx"].location != NSNotFound)
        {
            if(scColorMode.selectedSegmentIndex == 1){
                res = NO;
            }
        }
    }
    else if(sectionId == E_TABLE_SECTION_PAGE_PER_FILE){
        // ページ毎にファイル化
        if([fileType rangeOfString:@"jpeg"].location != NSNotFound){
            // JPEGの時は非表示
            res = NO;
        }
    }
    else if(sectionId == E_TABLE_SECTION_PDF_PASSWORD){
        
        // 暗号化
        if (![parentVCDelegate.rssViewData.formatData isVisibleEncrypt]) {
            res = NO;
            // 暗号化情報初期化
            bEncrypt = NO;
            [parentVCDelegate.rssViewData.formatData setIsEncript:bEncrypt];
            
            // switch off
            [self setTableSwitchValue:E_TABLE_SECTION_PDF_PASSWORD andValue:NO];
            
            passwordTextField.text = @"";
        }
    }
    else if(sectionId == E_TABLE_SECTION_OCR_USE){
        res = [self visibleUseOCRSection:fileType];
        
        if (!res) {
            // OCR情報初期化
            //[parentVCDelegate.rssViewData.formatData clearOcrValue];
            bOCR = NO;
            strSelectOCRLanguageKey = [parentVCDelegate.rssViewData.formatData getDefaultOCRLanguageKey];
            strSelectOCROutputFontKey = [parentVCDelegate.rssViewData.formatData getDefaultOCROutputFontKey];
            bCorrectImageRotation = NO;
            bExtractFileName = NO;
            strSelectOCRAccuracyKey = [parentVCDelegate.rssViewData.formatData getDefaultOCRAccuracyKey];
            
            // switch off
            [self setTableSwitchValue:E_TABLE_SECTION_OCR_USE andValue:bOCR];
            [self setTableSwitchValue:E_TABLE_SECTION_OCR_CORRECT_IMAGE_ROTATION andValue:bCorrectImageRotation];
            [self setTableSwitchValue:E_TABLE_SECTION_OCR_EXTRACT_FILE_NAME andValue:bExtractFileName];
        }
        
    }
    else if(sectionId == E_TABLE_SECTION_OCR_LANGUAGE ||
            sectionId == E_TABLE_SECTION_OCR_OUTPUT_FONT){
        if (![self visibleUseOCRSection:fileType]) {
            // OCRが非表示の場合は非表示
            res = NO;
        } else if (!bOCR) {
            // OCRがOFFの時は非表示
            res = NO;
        }
    }
    else if(sectionId == E_TABLE_SECTION_OCR_CORRECT_IMAGE_ROTATION){
        if (![self visibleUseOCRSection:fileType]) {
            // OCRが非表示の場合は非表示
            res = NO;
        } else if (!bOCR) {
            // OCRがOFFの時は非表示
            res = NO;
        } else if (!parentVCDelegate.rssViewData.formatData.validCorrectImaegRotation){
            // 画像向き検知が取得できなかった場合は非表示
            res = NO;
        }
    }
    else if(sectionId == E_TABLE_SECTION_OCR_EXTRACT_FILE_NAME){
        if (![self visibleUseOCRSection:fileType]) {
            // OCRが非表示の場合は非表示
            res = NO;
        } else if (!bOCR) {
            // OCRがOFFの時は非表示
            res = NO;
        } else if (!parentVCDelegate.rssViewData.formatData.validExtractFileName){
            // ファイル名抽出が取得できなかった場合は非表示
            res = NO;
        }
    }
    else if (sectionId == E_TABLE_SECTION_OCR_ACCURACY) {
        if (![self visibleUseOCRSection:fileType]) {
            // OCRが非表示の場合は非表示
            res = NO;
        } else if (!bOCR) {
            // OCRがOFFの時は非表示
            res = NO;
        } else if (!parentVCDelegate.rssViewData.formatData.validOCRAccuracy) {
            // OCR精度が取得できなかった場合は非表示
            res = NO;
        }
    }
    
    return res;
}

// OCRセクションが表示/非表示か返す
- (BOOL)visibleUseOCRSection:(NSString *)fileType
{
    if (!validOCR) {
        // OCRに関するデータを未取得のため、どんな場合も非表示
        return NO;
    }
    
    if (![parentVCDelegate.rssViewData.formatData isVisibleOCR:fileType]) {
        return NO;
    }
    
    if ([parentVCDelegate.rssViewData.specialMode isMultiCropOn] || [parentVCDelegate.rssViewData.originalSize isLong]) {
        // マルチクロップONの場合、長尺が選択されている場合
        return NO;
    }

    return YES;
}

// テーブルセルの作成
#define CELL_TITLE_LABEL_X_IPAD 20
#define CELL_TITLE_LABEL_TAG 2000
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    int sectionId = [[tableSectionIDs objectAtIndex:indexPath.section] intValue];
    
    NSString *CellIdentifier = [NSString stringWithFormat:@"Cell%d_%ld", sectionId, (long)indexPath.row];
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    UILabel* titleLbl = nil;
    
    if(cell == nil)
    {
        // タイトルラベルの作成
        titleLbl = [[UILabel alloc]init];
        titleLbl.font = [UIFont systemFontOfSize:[UIFont systemFontSize]];
        titleLbl.backgroundColor = [UIColor clearColor];
        titleLbl.tag = CELL_TITLE_LABEL_TAG;
        
        if(sectionId == E_TABLE_SECTION_PAGE_PER_FILE)
        {
            // ページ毎にファイル化
            if(indexPath.row == 0){
                SwitchDataCell* swCell = [[SwitchDataCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
                swCell.nameLabelCell.text = S_FORMAT_PAGE_PER_FILE;
                swCell.switchField.on = bEveryPageFiling;
                swCell.switchField.tag = E_TABLE_SECTION_PAGE_PER_FILE;
                [swCell.switchField addTarget:self action:@selector(changeSwitchValue:) forControlEvents:UIControlEventValueChanged];
                if ([parentVCDelegate.rssViewData.specialMode isMultiCropOn]) {
                    [swCell.nameLabelCell setEnabled:NO];
                    [swCell.switchField setEnabled:NO];
                }
                cell = swCell;
            }
            else
            {
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                
                // タイトルラベルの挿入
                CGRect titleLblFrame = cell.contentView.frame;
                titleLblFrame.origin.x += CELL_TITLE_LABEL_X_IPAD;
                titleLblFrame.size.width -= CELL_TITLE_LABEL_X_IPAD;
                titleLbl.frame = titleLblFrame;
                if ([parentVCDelegate.rssViewData.specialMode isMultiCropOn]) {
                    [titleLbl setEnabled:NO];
                }
                [cell.contentView addSubview:titleLbl];
                
                // ページ数
                titleLbl.text = S_FORMAT_PAGENUM;
                CGRect frame = CGRectMake(cell.contentView.frame.size.width - 70, 0, 50, cell.contentView.frame.size.height);
                pageNumLbl.frame = frame;
                if ([parentVCDelegate.rssViewData.specialMode isMultiCropOn]) {
                    [pageNumLbl setEnabled:NO];
                }
                [cell.contentView addSubview:pageNumLbl];
            }
        }
        else if(sectionId == E_TABLE_SECTION_PDF_PASSWORD)
        {
            // 暗号化
            if(indexPath.row == 0)
            {
                // 暗号化PDFの場合のみ表示
                SwitchDataCell* swSwitchDataCell = [[SwitchDataCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
                swSwitchDataCell.nameLabelCell.text = S_FORMAT_PDF_PASSWORD;
                swSwitchDataCell.switchField.on = bEncrypt;
                swSwitchDataCell.switchField.tag = E_TABLE_SECTION_PDF_PASSWORD;
                [swSwitchDataCell.switchField addTarget:self action:@selector(changeSwitchValue:) forControlEvents:UIControlEventValueChanged];
                cell = swSwitchDataCell;
            }
            else
            {
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                cell.editing = YES;
                
                // タイトルラベルの挿入
                CGRect titleLblFrame = cell.contentView.frame;
                titleLblFrame.origin.x += CELL_TITLE_LABEL_X_IPAD;
                titleLblFrame.size.width -= CELL_TITLE_LABEL_X_IPAD;
                titleLbl.frame = titleLblFrame;
                [cell.contentView addSubview:titleLbl];
                
            }
        }
        else if(sectionId == E_TABLE_SECTION_OCR_USE)
        {
            if(indexPath.row == 0)
            {
                SwitchDataCell* swSwitchDataCell = [[SwitchDataCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
                swSwitchDataCell.nameLabelCell.text = S_FORMAT_OCR;
                swSwitchDataCell.switchField.tag = E_TABLE_SECTION_OCR_USE;
                [swSwitchDataCell.switchField addTarget:self action:@selector(changeSwitchValue:)
                                       forControlEvents:UIControlEventValueChanged];
                cell = swSwitchDataCell;
            }
        }
        else if(sectionId == E_TABLE_SECTION_OCR_LANGUAGE)
        {
            if(indexPath.row == 0)
            {
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                cell.accessoryView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:S_IMAGE_PICKER]];
                
                // タイトルラベルの挿入
                CGRect titleLblFrame = cell.contentView.frame;
                titleLblFrame.origin.x += CELL_TITLE_LABEL_X_IPAD;
                titleLblFrame.size.width -= CELL_TITLE_LABEL_X_IPAD;
                titleLbl.frame = titleLblFrame;
                [cell.contentView addSubview:titleLbl];
            }
        }
        else if(sectionId == E_TABLE_SECTION_OCR_OUTPUT_FONT)
        {
            if(indexPath.row == 0)
            {
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                
                // タイトルラベルの挿入
                CGRect titleLblFrame = cell.contentView.frame;
                titleLblFrame.origin.x += CELL_TITLE_LABEL_X_IPAD;
                titleLblFrame.size.width -= CELL_TITLE_LABEL_X_IPAD;
                titleLbl.frame = titleLblFrame;
                [cell.contentView addSubview:titleLbl];
            }
        }
        else if(sectionId == E_TABLE_SECTION_OCR_CORRECT_IMAGE_ROTATION)
        {
            if(indexPath.row == 0)
            {
                SwitchDataCell* swSwitchDataCell = [[SwitchDataCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
                swSwitchDataCell.nameLabelCell.text = S_FORMAT_CORRECT_IMAGE_ROTATION;
                swSwitchDataCell.switchField.on = bCorrectImageRotation;
                swSwitchDataCell.switchField.tag = E_TABLE_SECTION_OCR_CORRECT_IMAGE_ROTATION;
                [swSwitchDataCell.switchField addTarget:self
                                                 action:@selector(changeSwitchValue:)
                                       forControlEvents:UIControlEventValueChanged];
                cell = swSwitchDataCell;
            }
        }
        else if(sectionId == E_TABLE_SECTION_OCR_EXTRACT_FILE_NAME)
        {
            if(indexPath.row == 0)
            {
                SwitchDataCell* swSwitchDataCell = [[SwitchDataCell alloc] initWithStyle:UITableViewCellStyleDefault
                                                                         reuseIdentifier:CellIdentifier];
                swSwitchDataCell.nameLabelCell.text = S_FORMAT_EXTRACT_FILE_NAME;
                swSwitchDataCell.switchField.on = bExtractFileName;
                swSwitchDataCell.switchField.tag = E_TABLE_SECTION_OCR_EXTRACT_FILE_NAME;
                [swSwitchDataCell.switchField addTarget:self
                                                 action:@selector(changeSwitchValue:)
                                       forControlEvents:UIControlEventValueChanged];
                cell = swSwitchDataCell;
            }
        }
        // sectionId == E_TABLE_SECTION_OCR_ACCURACYはelseと内容が同じなので省略。
        else
        {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            
            // タイトルラベルの挿入
            CGRect titleLblFrame = cell.contentView.frame;
            titleLblFrame.origin.x += CELL_TITLE_LABEL_X_IPAD;
            titleLblFrame.size.width -= CELL_TITLE_LABEL_X_IPAD;
            titleLbl.frame = titleLblFrame;
            [cell.contentView addSubview:titleLbl];
        }
        
    }else{
        titleLbl = (UILabel*)[cell.contentView viewWithTag:CELL_TITLE_LABEL_TAG];
    }
    cell.tag = sectionId;
    cell.exclusiveTouch = YES; // 同時押し禁止
    
    // セルタイトル
    cell.accessoryView = nil;
    switch (sectionId) {
        default:
        case E_TABLE_SECTION_FILE_FORMAT:
            //  ファイル形式
            titleLbl.text = strSelectFileFormatValue;
            cell.accessoryView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:S_IMAGE_PICKER]];
            break;
            
        case E_TABLE_SECTION_COMPACT_PDF:
            // 高圧縮PDFのタイプ
            titleLbl.text = [compressionPDFTypeList objectAtIndex:nSelectCompressionPDFTypeIndexRow];
            cell.accessoryView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:S_IMAGE_PICKER]];
//            // 圧縮PDFのタイプが高圧縮または高圧縮高精細の場合、解像度を300x300dpiに変更する。 白黒ボタンからカラーに戻った時に再度設定する
//            if([[parentVCDelegate.rssViewData.formatData getSelectFileFormatValue] rangeOfString:@"compact"].location != NSNotFound)
//            {
//                [parentVCDelegate.rssViewData.resolution setSelectKey: @"300"];
//            }
//            [parentVCDelegate updateSetting];
            break;
        case E_TABLE_SECTION_COMPRESSION:
            if(scColorMode.selectedSegmentIndex == 0){
                // カラー／グレースケール画像の圧縮率
                titleLbl.text = strSelectCompressionRatioValue;
            }else{
                // 白黒2値画像の圧縮形式
                titleLbl.text = [monoImageCompressionTypeList objectAtIndex:nSelectMonoImageCompressionTypeListIndexRow];
            }
            cell.accessoryView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:S_IMAGE_PICKER]];
            break;
        case E_TABLE_SECTION_PAGE_PER_FILE:
            // ページ毎にファイル化
            if(indexPath.row == 1){
                // ページ数(0のときは1ページとしておく)
                pageNumLbl.text = [NSString stringWithFormat:@"%zd  %@", (nSelectPageNum?nSelectPageNum:1), S_FORMAT_PAGE];
            }
            break;
        case E_TABLE_SECTION_PDF_PASSWORD:
            if(indexPath.row == 1)
            {
                // パスワード
                titleLbl.text = S_FORMAT_PASSWORD;
                // パスワードテキストフィールドの追加
                passwordTextField.secureTextEntry = YES;
                CGRect frame = CGRectMake(140, 0, cell.contentView.frame.size.width - 140, cell.contentView.frame.size.height);
                passwordTextField.frame = frame;
                passwordTextField.delegate = self;
                [cell.contentView addSubview:passwordTextField];
            }
            
            break;
        case E_TABLE_SECTION_OCR_USE:
            if(indexPath.row == 0)
            {
                SwitchDataCell* swSwitchDataCell = (SwitchDataCell*)cell;
                swSwitchDataCell.switchField.on = bOCR;
                swSwitchDataCell.switchField.enabled = [self isEnabledUseOCR];
            }
            break;
        case E_TABLE_SECTION_OCR_LANGUAGE:
            if(indexPath.row == 0){
                cell.accessoryView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:S_IMAGE_PICKER]];
                titleLbl.text = [parentVCDelegate.rssViewData.formatData getSelectOCRLanguageValue:strSelectOCRLanguageKey];
            }
            break;
        case E_TABLE_SECTION_OCR_OUTPUT_FONT:
            if(indexPath.row == 0){
                cell.accessoryView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:S_IMAGE_PICKER]];
                titleLbl.text = [parentVCDelegate.rssViewData.formatData getSelectOCROutputFontValue:strSelectOCROutputFontKey];
            }
            break;
        case E_TABLE_SECTION_OCR_CORRECT_IMAGE_ROTATION:
            if(indexPath.row == 0)
            {
                SwitchDataCell* swSwitchDataCell = (SwitchDataCell*)cell;
                swSwitchDataCell.switchField.on = bCorrectImageRotation;
            }
            break;
        case E_TABLE_SECTION_OCR_EXTRACT_FILE_NAME:
            if(indexPath.row == 0)
            {
                SwitchDataCell* swSwitchDataCell = (SwitchDataCell*)cell;
                swSwitchDataCell.switchField.on = bExtractFileName;
            }
            break;
        case E_TABLE_SECTION_OCR_ACCURACY:
            if (indexPath.row == 0) {
                cell.accessoryView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:S_IMAGE_PICKER]];
                titleLbl.text = [parentVCDelegate.rssViewData.formatData getSelectOCRAccuracyValue:strSelectOCRAccuracyKey];
            }
            break;
    }
    
    return cell;
    
}

// 各セルの高さを設定
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return N_HEIGHT_SEL_DEFAULT;
}

// テーブルセルのタッチ判定
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // セルの取得
    UITableViewCell * cell = [tableView cellForRowAtIndexPath:indexPath];
    BOOL bShowPicker = YES;
    
    int sectionId = [[tableSectionIDs objectAtIndex:indexPath.section] intValue];
    if((sectionId == E_TABLE_SECTION_PAGE_PER_FILE && indexPath.row == 0) ||
       sectionId == E_TABLE_SECTION_PDF_PASSWORD){
        // ページ毎に暗号化のスイッチのセルと、暗号化セクションはピッカーを表示しない
        bShowPicker = NO;
    }
    
    if ([parentVCDelegate.rssViewData.specialMode isMultiCropOn]) {
        if (sectionId == E_TABLE_SECTION_PAGE_PER_FILE && indexPath.row == 1) {
            // マルチクロップONの場合はページ数のセルはピッカーを表示しない
            bShowPicker = NO;
        }
    }
    
    if(sectionId == E_TABLE_SECTION_OCR_USE){
        bShowPicker = NO;
    }
    
    if(sectionId == E_TABLE_SECTION_OCR_CORRECT_IMAGE_ROTATION){
        bShowPicker = NO;
    }
    
    if(sectionId == E_TABLE_SECTION_OCR_EXTRACT_FILE_NAME){
        bShowPicker = NO;
    }
    
    if(bShowPicker){
        // ピッカーを表示
        m_nSelPicker = cell.tag;
        [self showFormatSettingPickerViewFromCell:cell];
    }
}

// 各セクションのヘッダー設定
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    NSString *title = @"";
    int sectionId = [[tableSectionIDs objectAtIndex:section] intValue];
    switch (sectionId) {
        case E_TABLE_SECTION_FILE_FORMAT:
            title = S_TITLE_FORMAT_FILE_FORMAT;
            break;
        case E_TABLE_SECTION_COMPACT_PDF:
            if([self visibleSection:E_TABLE_SECTION_COMPACT_PDF]){
                title = S_TITLE_FORMAT_COMPACT_PDF;
            }
            break;
        case E_TABLE_SECTION_COMPRESSION:
            if([self visibleSection:E_TABLE_SECTION_COMPRESSION]){
                if(scColorMode.selectedSegmentIndex == 0){
                    title = S_TITLE_FORMAT_COLOR_COMPRESSION;
                }else{
                    title = S_TITLE_FORMAT_MONOCHROME_COMPRESSION;
                }
            }
            break;
        case E_TABLE_SECTION_OCR_LANGUAGE:
            if([self visibleSection:E_TABLE_SECTION_OCR_LANGUAGE]){
                return S_TITLE_FORMAT_OCR_LANGUAGE;
            }
            break;
        case E_TABLE_SECTION_OCR_OUTPUT_FONT:
            if([self visibleSection:E_TABLE_SECTION_OCR_OUTPUT_FONT]){
                return S_TITLE_FORMAT_OCR_OUTPUT_FONT;
            }
            break;
        case E_TABLE_SECTION_OCR_ACCURACY:
            if ([self visibleSection:E_TABLE_SECTION_OCR_ACCURACY]) {
                return S_TITLE_FORMAT_OCR_ACCURACY;
            }
            break;
        default:
            break;
    }
    return title;
}

// ヘッダー表示前にフォントを設定
- (void)tableView:(UITableView *)tableView willDisplayHeaderView:(UIView *)view forSection:(NSInteger)section
{
    UITableViewHeaderFooterView *heView = (UITableViewHeaderFooterView *)view;
    heView.textLabel.font = [UIFont systemFontOfSize:N_TABLE_FONT_SIZE_HEADER];
}

// 各セクションのフッターを決定する
- (UIView *) tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView* returnView = nil;
    return returnView;
}

-(CGFloat) tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    CGFloat h = 0.0;
    return h;
}

#pragma mark - PickerView Manage
-(void)showFormatSettingPickerViewFromCell:(UITableViewCell*)cell
{
    // ポップオーバーの2重表示を防止
    if (m_popOver && m_popOver.popoverVisible) {
        return;
    }
    
    // Picker表示用View設定
    PickerViewController_iPad *pickerViewController;
    pickerViewController = [[PickerViewController_iPad alloc] init];
    pickerViewController.m_bSingleChar = NO;
    // popOverサイズを設定
    CGSize contentSize = CGSizeMake(320, 216);

    NSMutableArray* setArray = [NSMutableArray array];
    NSUInteger nSelRow = 0;
    switch (cell.tag) {
        case E_TABLE_SECTION_FILE_FORMAT:
            //  ファイル形式
            [setArray addObjectsFromArray:fileFormatList];
            nSelRow = [fileFormatList indexOfObject:strSelectFileFormatValue];
            break;
        case E_TABLE_SECTION_COMPACT_PDF:
            // 高圧縮PDFのタイプ
            [setArray addObjectsFromArray:compressionPDFTypeList];
            nSelRow = nSelectCompressionPDFTypeIndexRow;
            break;
        case E_TABLE_SECTION_COMPRESSION:
            if(scColorMode.selectedSegmentIndex == 0){
                // カラー／グレースケール画像の圧縮率
                [setArray addObjectsFromArray:compressionRatioList];
                nSelRow = [compressionRatioList indexOfObject:strSelectCompressionRatioValue];
            }else{
                // 白黒2値画像の圧縮形式
                [setArray addObjectsFromArray:monoImageCompressionTypeList];
                nSelRow = nSelectMonoImageCompressionTypeListIndexRow;
            }
            break;
        case E_TABLE_SECTION_PAGE_PER_FILE:
            // ページ数
            pickerViewController.m_bSingleChar = YES;
            // とりあえず0 ~ 9
            for(int i = 0; i <= 9; i++){
                [setArray addObject:[NSString stringWithFormat:@"%d", i]];
            }
            nSelRow = nSelectPageNum;
            contentSize = CGSizeMake(200, 216);
            break;
        case E_TABLE_SECTION_OCR_LANGUAGE:
            [setArray addObjectsFromArray:[parentVCDelegate.rssViewData.formatData getSelectableOCRLanguageValues:ocrLanguageKeys]];
            if ([ocrLanguageKeys containsObject:strSelectOCRLanguageKey]) {
                nSelRow = [ocrLanguageKeys indexOfObject:strSelectOCRLanguageKey];
            } else {
                nSelRow = 0;
            }
            break;
        case E_TABLE_SECTION_OCR_OUTPUT_FONT:
            [setArray addObjectsFromArray:[parentVCDelegate.rssViewData.formatData getSelectableOCROutputFontValues:ocrOutputFontKeys]];
            if ([ocrOutputFontKeys containsObject:strSelectOCROutputFontKey]) {
                nSelRow = [ocrOutputFontKeys indexOfObject:strSelectOCROutputFontKey];
            } else {
                nSelRow = 0;
            }
            break;
        case E_TABLE_SECTION_OCR_ACCURACY:
            [setArray addObjectsFromArray:[parentVCDelegate.rssViewData.formatData getSelectableOCRAccuracyValues:ocrAccuracyKeys]];
            if ([ocrAccuracyKeys containsObject:strSelectOCRAccuracyKey]) {
                nSelRow = [ocrAccuracyKeys indexOfObject:strSelectOCRAccuracyKey];
            } else {
                nSelRow = 0;
            }
            break;
        default:
            return;
            break;
    }

    // ピッカーのサイズをcontentSizeForViewInPopoverで決める
    pickerViewController.m_bUseContentSize = YES;
    pickerViewController.contentSizeForViewInPopover = contentSize;

    pickerViewController.m_parrPickerRow = setArray;
    pickerViewController.m_nSelRow = nSelRow;
    pickerViewController.m_notificationName = @"Format Picker";
    if(cell.tag == E_TABLE_SECTION_PAGE_PER_FILE)
    {
        pickerViewController.m_bSets = YES;
    }
    else
    {
        pickerViewController.m_bSets = NO;
    }
    pickerViewController.m_bScanPrint = NO;

    UINavigationController* pickerNavController = [[UINavigationController alloc] initWithRootViewController:pickerViewController];
    [pickerNavController setNavigationBarHidden:NO];

    // popOver release
    if (m_popOver != nil)
    {
        m_popOver = nil;
    }
    // popOver生成
    if(m_popOver == nil)
    {
        m_popOver = [[UIPopoverController alloc] initWithContentViewController:pickerNavController];
        m_popOver.delegate = self;
        if(pickerViewController.m_bSingleChar){
            m_popOver.popoverContentSize = CGSizeMake(200, 250);
        }
        else  {
            m_popOver.popoverContentSize = CGSizeMake(320, 250);
        }
    }

    // popOver表示
    UIPopoverArrowDirection arrowDirect = (cell.tag < 3 ? UIPopoverArrowDirectionUp : UIPopoverArrowDirectionDown);
    if(!m_popOver.popoverVisible)
    {
        [m_popOver presentPopoverFromRect:cell.contentView.frame inView:cell.contentView permittedArrowDirections:arrowDirect animated:YES];

        // 通知の監視を開始
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getPickerValueAction:) name:@"Format Picker" object:nil];
    }
}

// Picker選択値取得
- (void)getPickerValueAction:(NSNotification*)notification
{
    NSInteger row = [[[notification userInfo] objectForKey:@"ROW"] intValue];
    NSString* str = (NSString*)[[notification userInfo] objectForKey:@"VALUE"];

    // popOverを閉じる
    [m_popOver dismissPopoverAnimated:YES];

    // タイトルラベルを取得
    UITableViewCell* cell = [formatTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:(int)[tableSectionIDs indexOfObject:[NSNumber numberWithInteger:m_nSelPicker]]]];
    UILabel* titleLbl = (UILabel*)[cell.contentView viewWithTag:CELL_TITLE_LABEL_TAG];
    
    // 値の格納
    switch (m_nSelPicker) {
        case E_TABLE_SECTION_FILE_FORMAT:
        {
            //  ファイル形式
            strSelectFileFormatValue = fileFormatList[row];
            
            [parentVCDelegate.rssViewData.formatData setSelectFileFormatValue:[parentVCDelegate.rssViewData.formatData getFileFormatIndex:strSelectFileFormatValue]];
            
            bBeforeJpeg = NO;

            // 圧縮PDFタイプを再取得する
            // 変更前の文字列を取得する
            NSString *strBeforeCompPdfType = [NSString string];
            if (compressionPDFTypeList.count > nSelectCompressionPDFTypeIndexRow) {
                strBeforeCompPdfType = compressionPDFTypeList[nSelectCompressionPDFTypeIndexRow];
            }
            
            [compressionPDFTypeList removeAllObjects];
            [compressionPDFTypeList addObjectsFromArray:[parentVCDelegate.rssViewData.formatData getSelectableCompactPdfTypeArray:row]];
            
            // 圧縮PDFタイプのインデックスを再設定する -PDFの形式によってリストが変わる可能性があるので毎回更新する　対応していない場合はなしになる
            nSelectCompressionPDFTypeIndexRow = [parentVCDelegate.rssViewData.formatData getCompactPdfTypeIndex:strBeforeCompPdfType];
            [parentVCDelegate.rssViewData.formatData setSelectCompactPdfTypeValue:(int)nSelectCompressionPDFTypeIndexRow];
            
            
            // 圧縮率のリストを再取得する
            [compressionRatioList removeAllObjects];
            [compressionRatioList addObjectsFromArray:[parentVCDelegate.rssViewData.formatData getSelectableCompressionRatioArray:row andMultiCrop:[parentVCDelegate.rssViewData.specialMode isMultiCropOn]]];
            if (![compressionRatioList containsObject:strSelectCompressionRatioValue])
            {
                [self setCompressionRatioDefaultValue];
            }
            
            // タイトルラベルの更新
            titleLbl.text = strSelectFileFormatValue;
            
            if (![self isEnabledUseOCR]) {
                // 強制的にYESにする
                bOCR = YES;
                [parentVCDelegate.rssViewData.formatData setIsOCR:bOCR];
            }
        }
            
            break;
        
        case E_TABLE_SECTION_COMPACT_PDF:
            // 高圧縮PDFのタイプ
            nSelectCompressionPDFTypeIndexRow = row;
            
            [parentVCDelegate.rssViewData.formatData setSelectCompactPdfTypeValue:(int)row];
            
            // 黒文字重視が選択されている場合で、高圧縮、高圧縮高精細が選択された場合は圧縮率の値を初期化する
            if ([strSelectCompressionRatioValue isEqualToString:S_RS_XML_FILE_FORMAT_PRIORITY_BLACK_PDF] ||
                [strSelectCompressionRatioValue isEqualToString:S_RS_XML_FILE_FORMAT_PRIORITY_BLACK_PDFA] ||
                [strSelectCompressionRatioValue isEqualToString:S_RS_XML_FILE_FORMAT_PRIORITY_BLACK_PDFA_1A] ||
                [strSelectCompressionRatioValue isEqualToString:S_RS_XML_FILE_FORMAT_ENCRYPT_PRIORITY_BLACK_PDF]) {
                
                if([[parentVCDelegate.rssViewData.formatData getSelectFileFormatValue] rangeOfString:@"compact"].location != NSNotFound)
                {
                    [self setCompressionRatioDefaultValue];
                }
            }

//            // 圧縮PDFのタイプが高圧縮または高圧縮高精細の場合、解像度を300x300dpiに変更する。
//            if([[parentVCDelegate.rssViewData.formatData getSelectFileFormatValue] rangeOfString:@"compact"].location != NSNotFound)
//            {
//                [parentVCDelegate.rssViewData.resolution setSelectKey: @"300"];
//            }
//            [parentVCDelegate updateSetting];
            
            // タイトルラベルの更新
            titleLbl.text = [compressionPDFTypeList objectAtIndex:nSelectCompressionPDFTypeIndexRow];
            break;
        case E_TABLE_SECTION_COMPRESSION:
            if(scColorMode.selectedSegmentIndex == 0){
                // カラー／グレースケール画像の圧縮率
                strSelectCompressionRatioValue = compressionRatioList[row];
                NSUInteger compressionRatioIndex = [parentVCDelegate.rssViewData.formatData getCompressionRatioIndex:strSelectCompressionRatioValue
                                                                                                     fileFormatValue:strSelectFileFormatValue];
                [parentVCDelegate.rssViewData.formatData setSelectCompressionRatioValue:(int)compressionRatioIndex];

                // タイトルラベルの更新
                titleLbl.text = strSelectCompressionRatioValue;
            }else{
                // 白黒2値画像の圧縮形式
                nSelectMonoImageCompressionTypeListIndexRow = row;
                [parentVCDelegate.rssViewData.formatData setSelectCompressionValue:(int)row];

                // タイトルラベルの更新
                titleLbl.text = [monoImageCompressionTypeList objectAtIndex:nSelectMonoImageCompressionTypeListIndexRow];
            }
            break;
        case E_TABLE_SECTION_PAGE_PER_FILE:
            // ページ数
            nSelectPageNum = str.intValue;
            parentVCDelegate.rssViewData.formatData.selectPagePerFile = str.intValue;

            // ページ数更新
            pageNumLbl.text = [NSString stringWithFormat:@"%d  %@", (nSelectPageNum?nSelectPageNum:1), S_FORMAT_PAGE];
            break;
        case E_TABLE_SECTION_OCR_LANGUAGE:
            strSelectOCRLanguageKey = ocrLanguageKeys[row];
            [parentVCDelegate.rssViewData.formatData setSelectOCRLanguageValue:strSelectOCRLanguageKey];
            
            // フォントの再取得
            [self updateSelectableOutputFont];
            
            break;
        case E_TABLE_SECTION_OCR_OUTPUT_FONT:
            strSelectOCROutputFontKey = ocrOutputFontKeys[row];
            [parentVCDelegate.rssViewData.formatData setSelectOCROutputFontValue:strSelectOCROutputFontKey];
            break;
        case E_TABLE_SECTION_OCR_ACCURACY:
            strSelectOCRAccuracyKey = ocrAccuracyKeys[row];
            [parentVCDelegate.rssViewData.formatData setSelectOCRAccuracyValue:strSelectOCRAccuracyKey];
            break;
        default:
            break;
    }
    
    [parentVCDelegate.rssViewData.formatData setSelectValue];
    
    [parentVCDelegate updateSetting];

    // セクションの削除と挿入
    [self sectionDeleteAndInsert];

    // 通知の監視を終了
    [[NSNotificationCenter defaultCenter] removeObserver:self];

}

#pragma mark - Table Section Delete And Insert
// セクションの削除と挿入
-(void)sectionDeleteAndInsert
{
    // セクションの削除
    NSMutableIndexSet* modIndexes = [NSMutableIndexSet indexSet];
    for(int secid = 0; secid < E_TABLE_SECTION_NUM; secid++){
        int check = [self checkSectionDeleteOrInsert:secid];
        if(check == -1){
            // 削除リストに追加
            NSUInteger sec = [tableSectionIDs indexOfObject:[NSNumber numberWithInt:secid]];
            [modIndexes addIndex:sec];
        }
    }
    if(modIndexes.count){
        // 削除実行
        [tableSectionIDs removeObjectsAtIndexes:modIndexes];
        [formatTableView deleteSections:modIndexes withRowAnimation:UITableViewRowAnimationAutomatic];
        
        // 削除を実行した場合は、アニメーション後に挿入のチェックのためにもう一度呼び出す
        [self performSelector:@selector(sectionDeleteAndInsert) withObject:nil afterDelay:0.5];
    }else{
        
        // セクションの挿入
        int sectionCount = 0;
        [modIndexes removeAllIndexes];
        for(int secid = 0; secid < E_TABLE_SECTION_NUM; secid++){
            int check = [self checkSectionDeleteOrInsert:secid];
            if(check == 1){
                // 挿入リストに追加
                [modIndexes addIndex:sectionCount];
                sectionCount++;
            }else if(check != -1){
                NSUInteger indexNum = [tableSectionIDs indexOfObject:[NSNumber numberWithInt:secid]];
                if(indexNum != NSNotFound){
                    // 表示中ならばカウント
                    sectionCount++;
                }
            }
        }
        if(modIndexes.count){
            // テーブルのセクションIDリストを取得
            [tableSectionIDs removeAllObjects];
            for(int i = 0; i < E_TABLE_SECTION_NUM; i++){
                if([self visibleSection:i]){
                    [tableSectionIDs addObject:[NSNumber numberWithInt:i]];
                }
            }
            
            // 挿入実行
            [formatTableView insertSections:modIndexes withRowAnimation:UITableViewRowAnimationAutomatic];
            
            // 挿入アニメーション後にテーブルを更新
            [formatTableView performSelector:@selector(reloadData) withObject:nil afterDelay:0.5];
        }else{
            // テーブルを更新
            [formatTableView reloadData];
        }
    }
}

// セクションの挿入or削除判定
-(int)checkSectionDeleteOrInsert:(int)sectionId
{
    int res = 0;
    NSUInteger indexNum = [tableSectionIDs indexOfObject:[NSNumber numberWithInt:sectionId]];
    if(indexNum != NSNotFound){
        // 表示中
        if(![self visibleSection:sectionId]){
            // 削除する
            res = -1;
        }
    }else{
        // 非表示中
        if([self visibleSection:sectionId]){
            // 挿入する
            res = 1;
        }
    }
    return res;
}

#pragma mark - Rotate Event
-(void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration
{
    if(m_popOver){
        if(m_popOver.popoverVisible){
            // popOverを閉じる
            [m_popOver dismissPopoverAnimated:YES];
        }
    }
}

#pragma mark - UIPopoverControllerDelegate
-(void)popoverControllerDidDismissPopover:(UIPopoverController *)popoverController
{
    if(popoverController == m_popOver){
        // 通知の監視を終了
        [[NSNotificationCenter defaultCenter] removeObserver:self];
    }
}

#pragma mark - Keyboard　Event
- (void)keyboardWillShow:(NSNotification*)aNotification
{
    if(UIInterfaceOrientationIsPortrait([[UIApplication sharedApplication] statusBarOrientation])){
        // 縦のときは処理不要
        return;
    }

    // スクロールを有効にする
    [formatTableView setScrollEnabled:YES];
    
    // デバイスがどんな向きであっても、キーボードの座標はホームボタンが下になっている場合の座標で取得されるので注意
    CGRect keyboardRect = [[aNotification.userInfo objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
    float keyboardHeight = keyboardRect.size.width;
    formatTableView.contentSize = (CGSize){formatTableView.contentSize.width, formatTableView.contentSize.height + keyboardHeight};
    keyboardHeight -= (self.view.frame.size.height - (formatTableView.frame.origin.y + formatTableView.frame.size.height) + 105);// 高さを補正

    // フッターにブランクのViewを入れて、スクロール幅を調整する
    UIView* footerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, formatTableView.frame.size.width, keyboardHeight + 105)];
    formatTableView.tableFooterView = footerView;

    [UIView animateWithDuration:0.3f
                     animations:^{
                         formatTableView.contentOffset = (CGPoint){0, keyboardHeight};
                     }
                     completion:nil];


}

- (void)keyboardWillHide:(NSNotification*)aNotification
{
    if(UIInterfaceOrientationIsPortrait([[UIApplication sharedApplication] statusBarOrientation])){
        // 縦のときは処理不要
        return;
    }

    [UIView animateWithDuration:0.3f
                     animations:^{
                         formatTableView.contentSize = formatTableView.frame.size;
                     }
                     completion:^(BOOL b){
                         formatTableView.tableFooterView = nil;
//                         // スクロールを無効にする
//                         [formatTableView setScrollEnabled:NO];
                     }];
}


#pragma mark - Keyboard Event
//
// 仮想キーボードの[DONE]キーが押された時のイベント処理
//

-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    [self changePassowrdText:textField];
    [textField resignFirstResponder];
    return YES;
}

// ポップオーバーを閉じる
-(void)popoverClose
{
    if(m_popOver){
        if(m_popOver.popoverVisible){
            // popOverを閉じる
            [m_popOver dismissPopoverAnimated:YES];
        }
    }
    if (m_popOver != nil)
    {
        m_popOver = nil;
    }
}

#pragma mark - private method

// セグメントのラベルプロパティ変更メソッド
- (void)changeSegmentLabelProperty:(UISegmentedControl *)segmentedControl {
    
    // 各セグメント
    for (id segment in [segmentedControl subviews]) {
        if(isIOS7Later)
        {
            // 各セグメントのラベル
            for (id label in [segment subviews]) {
                if ([label isKindOfClass:[UILabel class]]) {
                    // フォントサイズ変更
                    [label setFont:[UIFont boldSystemFontOfSize: 13]];
                    [label setAdjustsFontSizeToFitWidth:YES];
                    [label setMinimumFontSize:10];
                }
            }
        } else {
            UISegmentedControl * seg = segment;
            
            // 左側のセグメントの場合
            if (seg.frame.origin.x == 0 && seg.frame.origin.y == 0) {
                // 各セグメントのラベル
                for (id label in [segment subviews]) {
                    if ([label isKindOfClass:[UILabel class]]) {
                        // フォントサイズ変更
                        [label setFont:[UIFont boldSystemFontOfSize: 13]];
                        // 文字が左寄せになるので、センターへ設定
                        [label setTextAlignment: NSTextAlignmentCenter];
                        break;
                    }
                }
            }
        }
    }
}

//
// OCRの設定が有効か無効かを取得する
//
-(BOOL)isEnabledUseOCR
{
    NSString* fileType = [self selectedFileType];
    
    if ([fileType rangeOfString:@"pdfa_1a"].location != NSNotFound) {
        return NO;
    }
    
    if ([fileType isEqualToString:@"docx"]) {
        return NO;
    }
    
    if ([fileType isEqualToString:@"xlsx"]) {
        return NO;
    }
    
    if ([fileType isEqualToString:@"pptx"]) {
        return NO;
    }
    
    return YES;
}

-(NSString *)selectedFileType
{
    NSUInteger fileFormatIndex = [parentVCDelegate.rssViewData.formatData getFileFormatIndex:strSelectFileFormatValue];
    NSUInteger compressionRatioIndex = [parentVCDelegate.rssViewData.formatData getCompressionRatioIndex:strSelectCompressionRatioValue
                                                                                         fileFormatValue:strSelectFileFormatValue];
    NSString* fileType = [parentVCDelegate.rssViewData.formatData getSelectValue:scColorMode.selectedSegmentIndex
                                                                selectFileFormat:fileFormatIndex
                                                            selectCompactPdfType:nSelectCompressionPDFTypeIndexRow
                                                          selectCompressionRatio:compressionRatioIndex
                                                                selectEncryption:bEncrypt];
    
    return fileType;
}

// フォントの選択肢の再取得
- (void)updateSelectableOutputFont
{
    ocrOutputFontKeys = [parentVCDelegate.rssViewData.formatData getSelectableOCROutputFontKeys:strSelectOCRLanguageKey];
    if ([ocrOutputFontKeys containsObject:strSelectOCROutputFontKey])
    {
        return;
    }
    
    if (ocrOutputFontKeys.count > 0)
    {
        strSelectOCROutputFontKey = ocrOutputFontKeys[0];
    }
    else
    {
        strSelectOCROutputFontKey = @"";
    }
    
    [parentVCDelegate.rssViewData.formatData setSelectOCROutputFontValue:strSelectOCROutputFontKey];
}

// 指定されたセクションIDのSwitchの値を変える
- (void)setTableSwitchValue:(NSInteger)sectionId andValue:(BOOL)value {
    
    // セクション番号を取得する
    NSInteger nSectioNo = [self getTableSectionNo:sectionId];
    if (nSectioNo == -1) {
        return;
    }
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:nSectioNo];
    UITableViewCell *cell = [formatTableView cellForRowAtIndexPath:indexPath];
    if ([[cell viewWithTag:sectionId] isKindOfClass:[SwitchDataCell class]]) {
        SwitchDataCell *customCell = (SwitchDataCell*)[cell viewWithTag:sectionId];
        customCell.switchField.on = value;
    }
    
}

// 指定されたセクションIDの現在のセクション番号を返す
- (NSInteger)getTableSectionNo:(NSInteger)tableSectionId {
    
    for (NSInteger iCnt = 0; iCnt < tableSectionIDs.count; iCnt++) {
        if ([[tableSectionIDs objectAtIndex:iCnt] integerValue] == tableSectionId) {
            return iCnt;
        }
    }
    
    return -1;
}

// 圧縮率の選択値を初期化する
- (void)setCompressionRatioDefaultValue {
    
    NSUInteger index = [compressionRatioList indexOfObject:S_RS_XML_COMPRESSION_RATIO_MIDDLE];
    if (index != NSNotFound) {
        strSelectCompressionRatioValue = compressionRatioList[index];
    }
    else {
        strSelectCompressionRatioValue = compressionRatioList[0];
    }
    NSUInteger compressionRatioIndex = [parentVCDelegate.rssViewData.formatData getCompressionRatioIndex:strSelectCompressionRatioValue
                                                                                         fileFormatValue:strSelectFileFormatValue];
    [parentVCDelegate.rssViewData.formatData setSelectCompressionRatioValue:(int)compressionRatioIndex];
    
}

@end
