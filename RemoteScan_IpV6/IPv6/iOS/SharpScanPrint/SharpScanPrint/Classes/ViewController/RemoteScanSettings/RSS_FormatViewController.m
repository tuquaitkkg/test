
#import "RSS_FormatViewController.h"
#import "PickerViewController.h"
#import "SwitchDataCell.h"
#import "RemoteScanBeforePictViewController.h"
#import "SharpScanPrintAppDelegate.h"
#import "ExAlertController.h"

@interface RSS_FormatViewController ()

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

// セグメントのラベルプロパティ変更メソッド
- (void)changeSegmentLabelProperty:(UISegmentedControl *)segmentedControl;

@end

@implementation RSS_FormatViewController
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

- (id)initWithDelegate:(RemoteScanBeforePictViewController *)delegate
{
    self = [super initWithNibName:@"RSS_FormatViewController" bundle:nil];
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
    
    // スクロールを有効にする
    formatTableView.scrollEnabled = YES;  //NO -> YES
    
    
    [scColorMode setTitle: S_BUTTON_FORMAT_COLOR forSegmentAtIndex: 0];
    [scColorMode setTitle: S_BUTTON_FORMAT_MONOCHROME forSegmentAtIndex: 1];
    // セグメントのラベルプロパティ変更
    [self changeSegmentLabelProperty: scColorMode];
    
    // テーブルのセクションIDリストを初期化
    tableSectionIDs = [[NSMutableArray alloc]init];
    for(int i = 0; i < E_TABLE_SECTION_NUM; i++){
        if([self visibleSection:i]){
            [tableSectionIDs addObject:[NSNumber numberWithInt:i]];
        }
    }
    
    // ナビゲーションバーの設定
    if(parentVCDelegate){
        // タイトル設定
        CGRect frame = CGRectMake(0, 0, 400, 44);
        UILabel* lblTitle = [[UILabel alloc]initWithFrame:frame];
        lblTitle.backgroundColor = [UIColor clearColor];
        lblTitle.textColor = NAVIGATION_TITLE_COLOR;
        lblTitle.font = [UIFont boldSystemFontOfSize:20];
        lblTitle.textAlignment = NSTextAlignmentCenter;
        lblTitle.text = S_TITLE_FORMAT;
        lblTitle.adjustsFontSizeToFitWidth = YES;
        self.navigationItem.titleView = lblTitle;
        //self.navigationItem.title = S_TITLE_FORMAT;
    }
    
    // 保存ボタンの設定
    UIBarButtonItem* btnSave = [[UIBarButtonItem alloc] initWithTitle:S_BUTTON_SAVEVAL style:UIBarButtonItemStyleDone target:self action:@selector(dosave:)];
    
    self.navigationItem.rightBarButtonItem = btnSave;
    
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
    
    NSLog(@"parentVCDelegate.rssViewData.formatData.nSelectColorMode: %d", parentVCDelegate.rssViewData.formatData.nSelectColorMode);
    [scColorMode setSelectedSegmentIndex: parentVCDelegate.rssViewData.formatData.nSelectColorMode];
    [self tapScColorMode:scColorMode];
    
    // フラグ初期化
    bBeforeJpeg = NO;

    // 前回選択値がjpegならフラグをYES
    if([parentVCDelegate.rssViewData.formatData getOriginalFileFormatIndex] == [parentVCDelegate.rssViewData.formatData getSelectFileFormatJpegIndex])
    {
        bBeforeJpeg = YES;
    }
    

    self.view.backgroundColor = BACKGROUND_COLOR;// TableViewに合わせた背景を設定
    if([[[UIDevice currentDevice] systemVersion] floatValue] >= 6.0 &&
       [[[UIDevice currentDevice] systemVersion] floatValue] < 7.0 &&
       UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
    {// iOS6のiPhoneだけ
        UITableView *tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
        [self.view addSubview:tableView];
        [self.view sendSubviewToBack:tableView];
    }
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    if (isIOS9Later) {
        // iOS9以降の場合は何もしない
        return;
    }
    
//    BOOL iPhoneSize4inches = [self.view.superview frame].size.height >= 500;
    BOOL iPhoneSize4inches = [[UIScreen mainScreen] bounds].size.height >= 568;
    BOOL iPhoneSize4_7inches = [[UIScreen mainScreen] bounds].size.height >= 667;
    BOOL iPhoneSize5_5inches = [[UIScreen mainScreen] bounds].size.height >= 736;
    if(iPhoneSize5_5inches){
        
        CGRect frame = CGRectMake(0,58,formatTableView.frame.size.width, formatTableView.frame.size.height -58);
        formatTableView.frame = frame;
    
    } else if(iPhoneSize4_7inches) {
        
        CGRect frame = CGRectMake(0,58,formatTableView.frame.size.width, formatTableView.frame.size.height -58);
        formatTableView.frame = frame;

    } else if(iPhoneSize4inches) {
        
        CGRect frame = CGRectMake(0,58,formatTableView.frame.size.width, formatTableView.frame.size.height -58);
        formatTableView.frame = frame;
    }
    else
    {
        CGRect frame = CGRectMake(0,58,formatTableView.frame.size.width,formatTableView.frame.size.height -58);
        formatTableView.frame = frame;
    };
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    // ナビゲーションバー上ボタンのマルチタップを制御する
    for (UIView * view in self.navigationController.navigationBar.subviews) {
        if ([view isKindOfClass: [UIView class]]) {
            [view setExclusiveTouch:YES];
        }
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
    
    //button.titleLabel.font            = [UIFont systemFontOfSize: 12];
    
    if ([S_LANG isEqualToString:S_LANG_JA])
    {
        // 国内版の場合、表示文字を小さくする
        textField.adjustsFontSizeToFitWidth = YES;
        textField.minimumFontSize = 7;
    }
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
// 保存ボタンに処理を移動
/*
        [parentVCDelegate.rssViewData.formatData setSelectColorModeValue:E_RSSVFORMATDATA_COLOR_MODE_FULLCOLOR];
*/
        
        // 白黒でjpegの場合は、tiffに変更する
// 保存ボタンに処理を移動　iPhone用
//        nSelectFileFormatIndexRow = [parentVCDelegate.rssViewData.formatData getSelectFileFormatIndex];
        if(bBeforeJpeg)
        {
            strSelectFileFormatValue = [parentVCDelegate.rssViewData.formatData getSelectFileFormatJpegValue];
        }else{
//            nSelectFileFormatIndexRow = [parentVCDelegate.rssViewData.formatData getSelectFileFormatIndex:sender.selectedSegmentIndex selectFileFormat:nSelectFileFormatIndexRow];
        }
    }else{
        // 白黒
        // 保存ボタンに処理を移動
        // JPEGの場合TIFFに変更されるので、フォーマット選択インデックスを再取得
        
        if([strSelectFileFormatValue isEqualToString:[parentVCDelegate.rssViewData.formatData getSelectFileFormatJpegValue]])
        {
            bBeforeJpeg = YES;
        }
        
//       [parentVCDelegate.rssViewData.formatData setSelectColorModeValue:E_RSSVFORMATDATA_COLOR_MODE_MONOCHROME];


        // 選択しているフォーマットを表示する
        //            nSelectFileFormatIndexRow = [parentVCDelegate.rssViewData.formatData getSelectFileFormatIndex];
        strSelectFileFormatValue = [parentVCDelegate.rssViewData.formatData getSelectFileFormatValue:sender.selectedSegmentIndex
                                                                                    selectFileFormat:strSelectFileFormatValue];
    }
    // フォーマットリストの再取得
    [fileFormatList removeAllObjects];
// 　保存ボタンに処理を移動　iPhone用
//    [fileFormatList addObjectsFromArray:[parentVCDelegate.rssViewData.formatData getSelectableFileFormatArray]];
    [fileFormatList addObjectsFromArray:[parentVCDelegate.rssViewData.formatData getSelectableFileFormatArray:sender.selectedSegmentIndex]];
    

  
    
    // 圧縮タイプリストの再取得
    [monoImageCompressionTypeList removeAllObjects];
// 保存ボタンに処理を移動　iPhone用
//    [monoImageCompressionTypeList addObjectsFromArray:[parentVCDelegate.rssViewData.formatData getSelectableCompressionArray]];
    [monoImageCompressionTypeList addObjectsFromArray:[parentVCDelegate.rssViewData.formatData getSelectableCompressionArray:sender.selectedSegmentIndex]];
    
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
// 保存ボタンに処理を移動
/*
    [parentVCDelegate.rssViewData.formatData setPdfPasswordValue:sender.text];
*/
}

// スイッチのON/OFFが切り替わった場合の処理(iPhoneでは設定値は変更しない)
-(IBAction)changeSwitchValue:(UISwitch*)sender
{
    switch (sender.tag) {
        case E_TABLE_SECTION_PAGE_PER_FILE:

            bEveryPageFiling = sender.on;
            break;
            
        case E_TABLE_SECTION_PDF_PASSWORD:

            bEncrypt = sender.on;
            break;
            
        case E_TABLE_SECTION_OCR_USE:
            if (bOCR != sender.on) {
                bOCR = sender.on;
                [self sectionDeleteAndInsert];
            }
            return;
            
        case E_TABLE_SECTION_OCR_CORRECT_IMAGE_ROTATION:
            // 原稿向き検知のON/OFFの切り替えのみ行う
            bCorrectImageRotation = sender.on;
            return;
            
        case E_TABLE_SECTION_OCR_EXTRACT_FILE_NAME:
            // ファイル名抽出のON/OFFの切り替えのみ行う
            bExtractFileName = sender.on;
            return;
            
        default:
            return;
            break;
    }
    
    int inSec = (int)[tableSectionIDs indexOfObject:[NSNumber numberWithInteger:sender.tag]];
    NSArray *indexPaths = [NSArray arrayWithObjects:[NSIndexPath indexPathForRow:1 inSection:inSec],nil];
    NSInteger nRowsCount = [formatTableView numberOfRowsInSection:inSec];
    
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
//　保存ボタンに処理を移動 iPhone用
//    NSString* fileType = [parentVCDelegate.rssViewData.formatData getSelectFileFormatValue];
    
    NSString *fileType = [self selectedFileType];


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
        if ([fileType rangeOfString:@"docx"].location != NSNotFound ||
            [fileType rangeOfString:@"xlsx"].location != NSNotFound ||
            [fileType rangeOfString:@"pptx"].location != NSNotFound)
        {
            if (scColorMode.selectedSegmentIndex == 1) {
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
        //if (![parentVCDelegate.rssViewData.formatData isVisibleEncrypt]) {
        
        if ([fileType rangeOfString:@"jpeg"].location != NSNotFound) {
            // JPEGの時は非表示
            res = NO;
        }
        else {
            NSInteger formatIndex = [fileFormatList indexOfObject:strSelectFileFormatValue];
            NSInteger compressionRatioIndex = [compressionRatioList indexOfObject:strSelectCompressionRatioValue];
            if (formatIndex == NSNotFound) {
                res = NO;
            }
            else if (![parentVCDelegate.rssViewData.formatData isVisibleEncrypt:formatIndex compactPdfType:nSelectCompressionPDFTypeIndexRow compressionRatio:compressionRatioIndex]) {
                res = NO;
            }
        }
        
        if (res == NO) {
            
            
            //[parentVCDelegate.rssViewData.formatData setIsEncript:bEncrypt];
            
            
            // switch off
            [self setTableSwitchValue:E_TABLE_SECTION_PDF_PASSWORD andValue:NO];
            
            // 暗号化情報初期化
            bEncrypt = NO;
            
            
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
            sectionId == E_TABLE_SECTION_OCR_OUTPUT_FONT) {
        if (![self visibleUseOCRSection:fileType]) {
            // OCRが非表示の場合は非表示
            res = NO;
        } else if (!bOCR) {
            // OCRがOFFの時は非表示
            res = NO;
        }
    }
    else if(sectionId == E_TABLE_SECTION_OCR_CORRECT_IMAGE_ROTATION) {
        if (![self visibleUseOCRSection:fileType]) {
            // OCRが非表示の場合は非表示
            res = NO;
        } else if (!bOCR) {
            // OCRがOFFの時は非表示
            res = NO;
        } else if (!parentVCDelegate.rssViewData.formatData.validCorrectImaegRotation) {
            // 画像向き検知が取得できなかった場合は非表示
            res = NO;
        }
    }
    else if(sectionId == E_TABLE_SECTION_OCR_EXTRACT_FILE_NAME) {
        if (![self visibleUseOCRSection:fileType]) {
            // OCRが非表示の場合は非表示
            res = NO;
        } else if (!bOCR) {
            // OCRがOFFの時は非表示
            res = NO;
        } else if (!parentVCDelegate.rssViewData.formatData.validExtractFileName) {
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
#define CELL_TITLE_LABEL_X 10
#define CELL_TITLE_LABEL_TAG 2000
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    int sectionId = [[tableSectionIDs objectAtIndex:indexPath.section] intValue];
    
    NSString *CellIdentifier = [NSString stringWithFormat:@"Cell%d_%ld", sectionId, (long)indexPath.row];
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    UILabel* titleLbl = nil;
    
    if(cell == nil)
    {
        if (isIOS9Later) {
            // iOS9以降の場合はここで設定する
            CGSize size = [[UIScreen mainScreen] bounds].size;
            float statusHeight = [[UIApplication sharedApplication] statusBarFrame].size.height;
            float navigationBarHeight = self.navigationController.navigationBar.frame.size.height;
            
            float originX = 0;
            float originY = 58;
            float width = size.width;
            float height = size.height - originY - statusHeight - navigationBarHeight;
            [formatTableView setFrame:CGRectMake(originX, originY, width, height)];
        }
        
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
                    // マルチクロップON時は非活性
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
                titleLblFrame.origin.x += CELL_TITLE_LABEL_X;
                titleLblFrame.size.width -= CELL_TITLE_LABEL_X;
                
                if([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0)
                {
                    // iOS7以降
                    titleLblFrame.origin.x += 10;
                    titleLblFrame.size.width -= 10;
                }
                
                titleLbl.frame = titleLblFrame;
                if ([parentVCDelegate.rssViewData.specialMode isMultiCropOn]) {
                    // マルチクロップON時は非活性
                    [titleLbl setEnabled:NO];
                }
                [cell.contentView addSubview:titleLbl];
                
                // ページ数
                titleLbl.text = S_FORMAT_PAGENUM;
                //CGRect frame = CGRectMake(cell.contentView.frame.size.width - 70, 0, 50, cell.contentView.frame.size.height);
                CGRect frame = CGRectMake(cell.contentView.frame.size.width - 170, 0, 120, cell.contentView.frame.size.height);
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
                titleLblFrame.origin.x += CELL_TITLE_LABEL_X;
                titleLblFrame.size.width -= CELL_TITLE_LABEL_X;
                
                if([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0)
                {
                    // iOS7以降
                    titleLblFrame.origin.x += 10;
                    titleLblFrame.size.width -= 10;
                }

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
                titleLblFrame.origin.x += CELL_TITLE_LABEL_X;
                titleLblFrame.size.width -= CELL_TITLE_LABEL_X;
                
                if([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0)
                {
                    // iOS7以降
                    titleLblFrame.origin.x += 10;
                    titleLblFrame.size.width -= 10;
                }
                
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
                titleLblFrame.origin.x += CELL_TITLE_LABEL_X;
                titleLblFrame.size.width -= CELL_TITLE_LABEL_X;
                
                if([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0)
                {
                    // iOS7以降
                    titleLblFrame.origin.x += 10;
                    titleLblFrame.size.width -= 10;
                }
                
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
        // sectionId == E_TABLE_SECTION_OCR_ACCURACYは内容がelseと同じ為省略。
        else
        {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            
            // タイトルラベルの挿入
            CGRect titleLblFrame = cell.contentView.frame;
            titleLblFrame.origin.x += CELL_TITLE_LABEL_X;
            titleLblFrame.size.width -= CELL_TITLE_LABEL_X;
            
            if([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0)
            {
                // iOS7以降
                titleLblFrame.origin.x += 10;
                titleLblFrame.size.width -= 10;
            }

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

//            // 圧縮PDFのタイプが高圧縮または高圧縮高精細の場合、解像度を300x300dpiに変更する。 白黒ボタンからカラーに戻った時に再度設定する
//            if([[parentVCDelegate.rssViewData.formatData getSelectFileFormatValue] rangeOfString:@"compact"].location != NSNotFound)
//            {
//                [parentVCDelegate.rssViewData.resolution setSelectKey: @"300"];
//                [parentVCDelegate updateSetting];
//            }
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
            if (indexPath.row == 0) {
                // スイッチの値を設定
                SwitchDataCell* swSwitchDataCell = (SwitchDataCell*)cell;
                swSwitchDataCell.switchField.on = bEncrypt;
            }
            if(indexPath.row == 1)
            {
                // パスワード
                titleLbl.text = S_FORMAT_PASSWORD;
                // パスワードテキストフィールドの追加
                passwordTextField.secureTextEntry = YES;
                CGRect frame = CGRectMake(120, 0, cell.contentView.frame.size.width - 120, cell.contentView.frame.size.height);
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
            if(indexPath.row == 0){
                cell.accessoryView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:S_IMAGE_PICKER]];
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
    
    if(bShowPicker){
        // ピッカーを表示
        m_nSelPicker = cell.tag;
        [self showFormatSettingPickerViewFromCell:cell indexPath:indexPath];
    }
}

// 各セクションのヘッダー設定
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    switch ([tableSectionIDs[section] intValue]) {
        case E_TABLE_SECTION_FILE_FORMAT:
            return S_TITLE_FORMAT_FILE_FORMAT;
            break;
        case E_TABLE_SECTION_COMPACT_PDF:
            if([self visibleSection:E_TABLE_SECTION_COMPACT_PDF]){
                return S_TITLE_FORMAT_COMPACT_PDF;
            }
            break;
        case E_TABLE_SECTION_COMPRESSION:
            if([self visibleSection:E_TABLE_SECTION_COMPRESSION]){
                if(scColorMode.selectedSegmentIndex == 0){
                    return S_TITLE_FORMAT_COLOR_COMPRESSION;
                }else{
                    return S_TITLE_FORMAT_MONOCHROME_COMPRESSION;
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
            if([self visibleSection:E_TABLE_SECTION_OCR_OUTPUT_FONT]){
                return S_TITLE_FORMAT_OCR_ACCURACY;
            }
            break;
        default:
            break;
    }
    return nil;
}

// 各セクションのフッターを決定する
- (UIView *) tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView* returnView = nil;
    return returnView;
}

-(CGFloat) tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
//    CGFloat h = 0.0;
    CGFloat h = TABLE_FOOTER_HEIGHT_1;
    return h;
}

#pragma mark - PickerView Manage
//-(void)showFormatSettingPickerViewFromCell:(UITableViewCell*)cell
-(void)showFormatSettingPickerViewFromCell:(UITableViewCell*)cell
                                 indexPath:(NSIndexPath *)indexPath
{
    // Picker表示用View設定

    NSMutableArray* setArray = [NSMutableArray array];
    NSUInteger nSelRow = 0;
    super.m_bSingleChar = NO;
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
            super.m_bSingleChar = YES;
            
            // ページ数
            // とりあえず0 ~ 9
            for(int i = 0; i <= 9; i++){
                [setArray addObject:[NSString stringWithFormat:@"%d", i]];
            }
            nSelRow = nSelectPageNum;
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
    
    m_parrPickerRow = [setArray copy];
    m_nSelRow = nSelRow;
    if(cell.tag == E_TABLE_SECTION_PAGE_PER_FILE)
    {
        m_bSets = YES;
    }
    else
    {
        m_bSets = NO;
    }
    m_bScanPrint = NO;
    
    [super showPickerView];
}

#pragma mark - PickerView Manage

// 決定ボタン押下時の処理(iPhoneでは設定値の保存はしない。このビュー内での変数値を変更。)
- (IBAction)OnMenuDecideButton:(id)sender
{
    
    // Todo getPickerValueActionで行っていた処理をここで行う

    NSInteger row = m_nSelRow;
    
    // アクションシート非表示
    [super OnMenuDecideButton:sender];
    
    // タイトルラベルを取得
    UITableViewCell* cell = [formatTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:(int)[tableSectionIDs indexOfObject:[NSNumber numberWithInteger:m_nSelPicker]]]];
    UILabel* titleLbl = (UILabel*)[cell.contentView viewWithTag:CELL_TITLE_LABEL_TAG];
    
    // 値の格納
    switch (m_nSelPicker) {
        case E_TABLE_SECTION_FILE_FORMAT:
        {
            //  ファイル形式
            strSelectFileFormatValue = fileFormatList[row];
        
            bBeforeJpeg = NO;
            
            // 圧縮PDFタイプ
            // 変更前の文字列を取得する
            NSString *strBeforeCompPdfType = [NSString string];
            if (compressionPDFTypeList.count > nSelectCompressionPDFTypeIndexRow) {
                strBeforeCompPdfType = compressionPDFTypeList[nSelectCompressionPDFTypeIndexRow];
            }
            
            // 圧縮PDFタイプを再取得する
            [compressionPDFTypeList removeAllObjects];
            [compressionPDFTypeList addObjectsFromArray:[parentVCDelegate.rssViewData.formatData getSelectableCompactPdfTypeArray:row]];
            // 圧縮PDFタイプのインデックスを再設定する -PDFの形式によってリストが変わる可能性があるので毎回更新する　対応していない形式の場合はなしになる
            nSelectCompressionPDFTypeIndexRow = [parentVCDelegate.rssViewData.formatData getCompactPdfTypeIndex:strBeforeCompPdfType];

            // 圧縮率のリストを再取得する
            [compressionRatioList removeAllObjects];
            [compressionRatioList addObjectsFromArray:[parentVCDelegate.rssViewData.formatData getSelectableCompressionRatioArray:row andMultiCrop:[parentVCDelegate.rssViewData.specialMode isMultiCropOn]]];
            if (![compressionRatioList containsObject:strSelectCompressionRatioValue])
            {
                [self setCompressionRatioDefaultValue];
            }
            
            // タイトルラベルの更新
            titleLbl.text = strSelectFileFormatValue;
            
//            [parentVCDelegate updateSetting];
            
            if (![self isEnabledUseOCR]) {
                // 強制的にYESにする
                bOCR = YES;
            }
        }
            break;
        case E_TABLE_SECTION_COMPACT_PDF:
            // 高圧縮PDFのタイプ
            nSelectCompressionPDFTypeIndexRow = row;
            
            // タイトルラベルの更新
            titleLbl.text = [compressionPDFTypeList objectAtIndex:nSelectCompressionPDFTypeIndexRow];
            break;
            
        case E_TABLE_SECTION_COMPRESSION:
            if(scColorMode.selectedSegmentIndex == 0){
                // カラー／グレースケール画像の圧縮率
                strSelectCompressionRatioValue = compressionRatioList[row];
                // タイトルラベルの更新
                titleLbl.text = strSelectCompressionRatioValue;
            }else{
                // 白黒2値画像の圧縮形式
                nSelectMonoImageCompressionTypeListIndexRow = row;
                // タイトルラベルの更新
                titleLbl.text = [monoImageCompressionTypeList objectAtIndex:nSelectMonoImageCompressionTypeListIndexRow];
            }
            break;
        case E_TABLE_SECTION_PAGE_PER_FILE:
            //  page select (no test)
            // ページ数
            nSelectPageNum = m_nSelRow;
            
            // ページ数更新
            pageNumLbl.text = [NSString stringWithFormat:@"%zd  %@", (nSelectPageNum?nSelectPageNum:1), S_FORMAT_PAGE];
            /**/
            break;
        case E_TABLE_SECTION_OCR_LANGUAGE:
            strSelectOCRLanguageKey = ocrLanguageKeys[row];
            // フォントの再取得
            [self updateSelectableOutputFont];
            break;
        case E_TABLE_SECTION_OCR_OUTPUT_FONT:
            strSelectOCROutputFontKey = ocrOutputFontKeys[row];
            break;
        case E_TABLE_SECTION_OCR_ACCURACY:
            strSelectOCRAccuracyKey = ocrAccuracyKeys[row];
            break;
        default:
            break;
    }
    
    // セクションの削除と挿入
    [self sectionDeleteAndInsert];
}

- (void)OnMenuCancelButton:(id)sender
{
    [super OnMenuCancelButton:sender];
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

#pragma mark - Keyboard　Event
- (void)keyboardWillShow:(NSNotification*)aNotification
{
    // スクロールを有効にする
    formatTableView.scrollEnabled = YES;
    
    // デバイスがどんな向きであっても、キーボードの座標はホームボタンが下になっている場合の座標で取得されるので注意
    CGRect keyboardRect = [[aNotification.userInfo objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
    float keyboardHeight = keyboardRect.size.height;
    
// フッターにkeyboardの高さ分のブランクのViewを入れて、スクロール幅を調整する
    UIView* footerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, formatTableView.frame.size.width, keyboardHeight)];

    formatTableView.tableFooterView = footerView;
    
// Keyboardサイズ分スクロールアップ
    [UIView animateWithDuration:0.3f
                     animations:^{
                         formatTableView.contentOffset = (CGPoint){0, formatTableView.contentOffset.y + keyboardHeight};
                     }
                     completion:nil];
}

- (void)keyboardWillHide:(NSNotification*)aNotification
{
    CGRect keyboardRect = [[aNotification.userInfo objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
    float keyboardHeight = keyboardRect.size.height;

// Keyboardサイズ分スクロールダウン    (終了後スクロール幅調整用に付加したフッターを取り除く)
    [UIView animateWithDuration:0.3f
                     animations:^{
                         formatTableView.contentOffset = (CGPoint){0, formatTableView.contentOffset.y - keyboardHeight};
                     }
                     completion:^(BOOL b){
                         formatTableView.tableFooterView = nil;
                     }];
}

#pragma mark - Keyboard Event
//
// 仮想キーボードの[DONE]キーが押された時のイベント処理
//

-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
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
                        [label setTextAlignment:NSTextAlignmentCenter];
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
}

#pragma mark - OnButtonClick
//
// 保存ボタン処理
//
-(IBAction)dosave:(id)sender
{
    // エラーチェック
    if(![self isValidPdfPassword])
    {
        return;
    }
    
    if(scColorMode.selectedSegmentIndex == 0){
        // カラーグレースケール
        [parentVCDelegate.rssViewData.formatData setSelectColorModeValue:E_RSSVFORMATDATA_COLOR_MODE_FULLCOLOR];
    }else
    {
        // 白黒
        // JPEGの場合TIFFに変更されるので、フォーマット選択インデックスを再取得
        [parentVCDelegate.rssViewData.formatData setSelectColorModeValue:E_RSSVFORMATDATA_COLOR_MODE_MONOCHROME];
    }
    
    //  ファイル形式
    if(bBeforeJpeg)
    {
        [parentVCDelegate.rssViewData.formatData setSelectFileFormatValue:[parentVCDelegate.rssViewData.formatData getSelectFileFormatJpegIndex]];
    }else
    {
        NSUInteger index = [parentVCDelegate.rssViewData.formatData getFileFormatIndex:strSelectFileFormatValue];
        [parentVCDelegate.rssViewData.formatData setSelectFileFormatValue:index];
    }

    // 高圧縮PDFのタイプ
    [parentVCDelegate.rssViewData.formatData setSelectCompactPdfTypeValue:(int)nSelectCompressionPDFTypeIndexRow];
    
    // カラー／グレースケール画像の圧縮率
    NSUInteger compressionRatioIndex = [parentVCDelegate.rssViewData.formatData getCompressionRatioIndex:strSelectCompressionRatioValue
                                                                                         fileFormatValue:strSelectFileFormatValue];
    [parentVCDelegate.rssViewData.formatData setSelectCompressionRatioValue:(int)compressionRatioIndex];
    
    // 白黒2値画像の圧縮形式
    [parentVCDelegate.rssViewData.formatData setSelectCompressionValue:(int)nSelectMonoImageCompressionTypeListIndexRow];
    
    // ページ数
    parentVCDelegate.rssViewData.formatData.selectPagePerFile = (int)nSelectPageNum;

    // スイッチのON,OFFを保存
    [parentVCDelegate.rssViewData.formatData setIsPagePerFile:bEveryPageFiling];
    [parentVCDelegate.rssViewData.formatData setIsEncript:bEncrypt];
    
    // パスワード
    [parentVCDelegate.rssViewData.formatData setPdfPasswordValue:passwordTextField.text];
    
    // OCRのON,OFFを保持
    [parentVCDelegate.rssViewData.formatData setIsOCR:bOCR];
    
    // 言語設定
    [parentVCDelegate.rssViewData.formatData setSelectOCRLanguageValue:strSelectOCRLanguageKey];
    
    // フォント
    [parentVCDelegate.rssViewData.formatData setSelectOCROutputFontValue:strSelectOCROutputFontKey];
    
    // 原稿向き検知のON,OFFを保持
    [parentVCDelegate.rssViewData.formatData setIsCorrectImageRotation:bCorrectImageRotation];
    
    // ファイル名抽出のON,OFFを保持
    [parentVCDelegate.rssViewData.formatData setIsExtractFileName:bExtractFileName];
    
    // OCR精度
    [parentVCDelegate.rssViewData.formatData setSelectOCRAccuracyValue:strSelectOCRAccuracyKey];
    
    // 各項目の設定値を使用してファイルフォーマットを設定
    [parentVCDelegate.rssViewData.formatData setSelectValue];
    
    // 親タイトルの更新
    [parentVCDelegate updateSetting];
    
    // 前画面に戻る
    [self.navigationController popViewControllerAnimated:YES];
    
}

#pragma mark -ErrorCheck
// フォーマット画面のパスワードのチェックを行い、エラーダイアログを表示する
-(BOOL)isValidPdfPassword
{
    BOOL result = YES;
    
    // 暗号化がオフの場合はチェックしない
    if (!bEncrypt || [[self selectedFileType] rangeOfString:@"encrypt"].location == NSNotFound)
    {
        return YES;
    }
    
    // 暗号化PDF以外の場合は暗号化の設定ができないため、パスワードのチェックをしない
    NSString* fileType = [self selectedFileType];
    if ([fileType rangeOfString:@"encrypt"].location == NSNotFound)
    {
        return YES;
    }
    
    // 暗号化PDF時のパスワードチェック
    NSString* encPassword = passwordTextField.text;
    if([encPassword isEqualToString:@""])
    {
        // 必須ですエラー
        result = NO;

        [self CreateAllertWithOKButton:nil message:[NSString stringWithFormat:MSG_REQUIRED_ERR, SUBMSG_PDFPASSWORD_ERR] startBtnTitle:MSG_BUTTON_OK withTag:1];
        
    } else if([encPassword length] > 32)
    {
        // 最大長エラー
        result = NO;
        
        [self CreateAllertWithOKButton:nil message:[NSString stringWithFormat:MSG_LENGTH_ERR, SUBMSG_PDFPASSWORD_ERR, SUBMSG_PDFPASSWORD_MAXLENGTH] startBtnTitle:MSG_BUTTON_OK withTag:1];
        
    } else if(![CommonUtil isAplhanumeric:encPassword])
    {
        // 半角英数字以外エラー
        result = NO;
        
        [self CreateAllertWithOKButton:nil message:[NSString stringWithFormat:MSG_CHAR_TYPE_ERR, SUBMSG_PDFPASSWORD_ERR, SUBMSG_PDFPASSWORD_FORMAT] startBtnTitle:MSG_BUTTON_OK withTag:1];
    }
    
    return result;
}

//ダイアログのボタン押下時
-(void)alertButtonPushed:(UIAlertController *)alertController tagIndex:(NSInteger)tagIndex buttonIndex:(NSInteger)buttonIndex
{
    SharpScanPrintAppDelegate* appDelegate = (SharpScanPrintAppDelegate*)[[UIApplication sharedApplication] delegate];
    // 処理実行フラグON
    appDelegate.IsRun = FALSE;
    
}
// メッセージボックス表示
- (void)CreateAllertWithOKButton:(NSString*)pstrTitle
                         message:(NSString*)pstrMsg
                   startBtnTitle:(NSString*)pstrStartBtnTitle
                         withTag:(NSInteger)nTag
{
    SharpScanPrintAppDelegate* appDelegate = (SharpScanPrintAppDelegate*)[[UIApplication sharedApplication] delegate];
    // 処理実行フラグON
    appDelegate.IsRun = TRUE;
    
    [self makeTmpExAlert:pstrTitle message:pstrMsg cancelBtnTitle:nil okBtnTitle:pstrStartBtnTitle tag:nTag];
}


// アラート表示
- (void) makeTmpExAlert:(NSString*)pstrTitle
                message:(NSString*)pstrMsg
         cancelBtnTitle:(NSString*)cancelBtnTitle
             okBtnTitle:(NSString*)okBtnTitle
                    tag:(NSInteger)tag
{
    ExAlertController *tmpAlert = [ExAlertController alertControllerWithTitle:pstrTitle
                                                                      message:pstrMsg
                                                               preferredStyle:UIAlertControllerStyleAlert];
    tmpAlert.tag = tag;
    
    // Cancel用のアクションを生成
    if (cancelBtnTitle != nil) {
        UIAlertAction *cancelAction =
        [UIAlertAction actionWithTitle:cancelBtnTitle
                                 style:UIAlertActionStyleCancel
                               handler:^(UIAlertAction * action) {
                                   
                                   // ボタンタップ時の処理
                                   [self alertButtonPushed:tmpAlert tagIndex:tag buttonIndex:0];
                               }];
        // コントローラにアクションを追加
        [tmpAlert addAction:cancelAction];
    }
    
    // OK用のアクションを生成
    if (okBtnTitle != nil) {
        // OK用ボタンIndex
        NSInteger okIndex = (cancelBtnTitle == nil) ? 0 : 1;
        
        UIAlertAction *okAction =
        [UIAlertAction actionWithTitle:okBtnTitle
                                 style:UIAlertActionStyleDefault
                               handler:^(UIAlertAction * action) {
                                   
                                   // ボタンタップ時の処理
                                   [self alertButtonPushed:tmpAlert tagIndex:tag buttonIndex:okIndex];
                               }];
        // コントローラにアクションを追加
        [tmpAlert addAction:okAction];
    }
    
    // アラート表示処理
    [self presentViewController:tmpAlert animated:YES completion:nil];
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
