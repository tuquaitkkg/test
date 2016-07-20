
#import "RSS_FormatViewController.h"
#import "PickerViewController.h"
#import "SwitchDataCell.h"
#import "RemoteScanBeforePictViewController.h"
#import "SharpScanPrintAppDelegate.h"

@interface RSS_FormatViewController ()

enum{
    E_TABLE_SECTION_FILE_FORMAT,
    E_TABLE_SECTION_COMPACT_PDF,
    E_TABLE_SECTION_COMPRESSION,
    E_TABLE_SECTION_PAGE_PER_FILE,
    E_TABLE_SECTION_PDF_PASSWORD,
    
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
        
        nSelectFileFormatIndexRow = 0;
        nSelectCompressionPDFTypeIndexRow = 0;
        nSelectCompressionRatioIndexRow = 1;
        nSelectMonoImageCompressionTypeListIndexRow = 0;
        
        bEveryPageFiling = NO;
        bEncrypt = NO;
        nSelectPageNum = 1;
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
        nSelectFileFormatIndexRow = [parentVCDelegate.rssViewData.formatData getSelectFileFormatIndex];
        
        compressionPDFTypeList = [[NSMutableArray alloc]init];
        [compressionPDFTypeList addObjectsFromArray:[parentVCDelegate.rssViewData.formatData getSelectableCompactPdfTypeArray]];
        nSelectCompressionPDFTypeIndexRow = [parentVCDelegate.rssViewData.formatData getSelectCompactPdfTypeIndex];
        
        compressionRatioList = [[NSMutableArray alloc]init];
        [compressionRatioList addObjectsFromArray:[parentVCDelegate.rssViewData.formatData getSelectableCompressionRatioArray]];
        nSelectCompressionRatioIndexRow = [parentVCDelegate.rssViewData.formatData getSelectCompressionRatioIndex];
        
        monoImageCompressionTypeList = [[NSMutableArray alloc]init];
        [monoImageCompressionTypeList addObjectsFromArray:[parentVCDelegate.rssViewData.formatData getSelectableCompressionArray]];
        nSelectMonoImageCompressionTypeListIndexRow = [parentVCDelegate.rssViewData.formatData getSelectCompressionIndex];
        
        bEveryPageFiling = parentVCDelegate.rssViewData.formatData.isPagePerFile;
        nSelectPageNum = parentVCDelegate.rssViewData.formatData.selectPagePerFile;
        bEncrypt = parentVCDelegate.rssViewData.formatData.isEncript;
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
        lblTitle.textAlignment = UITextAlignmentCenter;
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
    pageNumLbl.textAlignment    = UITextAlignmentRight;
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
//    BOOL iPhoneSize4inches = [self.view.superview frame].size.height >= 500;
    BOOL iPhoneSize4inches = [[UIScreen mainScreen] bounds].size.height >= 500;
    if(iPhoneSize4inches){
        
        CGRect frame = CGRectMake(0,58,self.view.frame.size.width, 446);
        formatTableView.frame = frame;
    }
    else
    {
        CGRect frame = CGRectMake(0,58,self.view.frame.size.width,358);
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
            nSelectFileFormatIndexRow = [parentVCDelegate.rssViewData.formatData getSelectFileFormatJpegIndex];
        }else{
            nSelectFileFormatIndexRow = [parentVCDelegate.rssViewData.formatData getSelectFileFormatIndex:sender.selectedSegmentIndex selectFileFormat:nSelectFileFormatIndexRow];
        }
    }else{
        // 白黒
        // 保存ボタンに処理を移動
        // JPEGの場合TIFFに変更されるので、フォーマット選択インデックスを再取得

        if([parentVCDelegate.rssViewData.formatData getSelectFileFormatJpegIndex] == nSelectFileFormatIndexRow)
        {
            bBeforeJpeg = YES;
        }
//       [parentVCDelegate.rssViewData.formatData setSelectColorModeValue:E_RSSVFORMATDATA_COLOR_MODE_MONOCHROME];


        // 選択しているフォーマットを表示する
//            nSelectFileFormatIndexRow = [parentVCDelegate.rssViewData.formatData getSelectFileFormatIndex];
        nSelectFileFormatIndexRow = [parentVCDelegate.rssViewData.formatData getSelectFileFormatIndex:sender.selectedSegmentIndex selectFileFormat:nSelectFileFormatIndexRow];
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

-(IBAction)changeSwitchValue:(UISwitch*)sender
{
    switch (sender.tag) {
        case E_TABLE_SECTION_PAGE_PER_FILE:
//　保存ボタンに処理を移動
/*
            [parentVCDelegate.rssViewData.formatData setIsPagePerFile:sender.on];
*/
            bEveryPageFiling = sender.on;
            break;
            
        case E_TABLE_SECTION_PDF_PASSWORD:
//　保存ボタンに処理を移動
/*
            [parentVCDelegate.rssViewData.formatData setIsEncript:sender.on];
*/
            bEncrypt = sender.on;
            break;
            
        default:
            return;
            break;
    }
    
    int inSec = (int)[tableSectionIDs indexOfObject:[NSNumber numberWithInt:sender.tag]];
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
    return res;
}

-(BOOL)visibleSection:(int)sectionId
{
    BOOL res = YES;
//　保存ボタンに処理を移動 iPhone用
//    NSString* fileType = [parentVCDelegate.rssViewData.formatData getSelectFileFormatValue];
    NSString* fileType = [parentVCDelegate.rssViewData.formatData getSelectValue:scColorMode.selectedSegmentIndex selectFileFormat:nSelectFileFormatIndexRow selectCompactPdfType:nSelectCompressionPDFTypeIndexRow selectCompressionRatio:nSelectCompressionRatioIndexRow selectEncryption:bEncrypt];


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
        }
    }
    else if(sectionId == E_TABLE_SECTION_COMPRESSION){
        // 圧縮
        if(scColorMode.selectedSegmentIndex == 0 &&
           [fileType rangeOfString:@"compact"].location != NSNotFound){
            // 高精細PDFの時は非表示
            res = NO;
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
        if([fileType rangeOfString:@"pdfa"].location != NSNotFound ||
           [fileType rangeOfString:@"jpeg"].location != NSNotFound ||
           [fileType rangeOfString:@"tiff"].location != NSNotFound){
            // PDFA,JPEG,TIFFの時は非表示
            res = NO;
        }
    }
    
    return res;
}

// テーブルセルの作成
#define CELL_TITLE_LABEL_X 10
#define CELL_TITLE_LABEL_TAG 2000
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    int sectionId = [[tableSectionIDs objectAtIndex:indexPath.section] intValue];
    
    NSString *CellIdentifier = [NSString stringWithFormat:@"Cell%d_%d", sectionId, indexPath.row];
    
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
                [cell.contentView addSubview:titleLbl];
                
                // ページ数
                titleLbl.text = S_FORMAT_PAGENUM;
                //CGRect frame = CGRectMake(cell.contentView.frame.size.width - 70, 0, 50, cell.contentView.frame.size.height);
                CGRect frame = CGRectMake(cell.contentView.frame.size.width - 170, 0, 120, cell.contentView.frame.size.height);
                pageNumLbl.frame = frame;
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
    
    // セルタイトル
    cell.accessoryView = nil;
    switch (sectionId) {
        default:
        case E_TABLE_SECTION_FILE_FORMAT:
            //  ファイル形式
            titleLbl.text = [fileFormatList objectAtIndex:nSelectFileFormatIndexRow];
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
//                [parentVCDelegate updateSetting];
//            }
            break;
        case E_TABLE_SECTION_COMPRESSION:
            if(scColorMode.selectedSegmentIndex == 0){
                // カラー／グレースケール画像の圧縮率
                titleLbl.text = [compressionRatioList objectAtIndex:nSelectCompressionRatioIndexRow];
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
                pageNumLbl.text = [NSString stringWithFormat:@"%d  %@", (nSelectPageNum?nSelectPageNum:1), S_FORMAT_PAGE];
            }
            break;
        case E_TABLE_SECTION_PDF_PASSWORD:
            if(indexPath.row == 1)
            {
                // パスワード
                titleLbl.text = S_FORMAT_PASSWORD;
                // パスワードテキストフィールドの追加
                passwordTextField.secureTextEntry = YES;
                //passwordTextField.keyboardAppearance = UIKeyboardAppearanceAlert;///////
                CGRect frame = CGRectMake(120, 0, cell.contentView.frame.size.width - 120, cell.contentView.frame.size.height);
                passwordTextField.frame = frame;
                passwordTextField.delegate = self;
                [cell.contentView addSubview:passwordTextField];
            }
            
            break;
    }
    
    return cell;
    
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
    
    if(bShowPicker){
        // ピッカーを表示
        m_nSelPicker = cell.tag;
        [self showFormatSettingPickerViewFromCell:cell];
    }
}

// 各セクションのヘッダー設定
- (UIView *) tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView* returnView = nil;
    int sectionId = [[tableSectionIDs objectAtIndex:section] intValue];
    
    // ビューを作成
    returnView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.bounds.size.width, 40)];

    // タイトルラベル作成
    UILabel* titleLbl = [[UILabel alloc]initWithFrame:CGRectMake(20, 0, tableView.bounds.size.width - 40, 32)];
    [titleLbl setNumberOfLines:0];
    [titleLbl setBackgroundColor:[UIColor clearColor]];
    [titleLbl setTextColor:[UIColor colorWithRed:0.29f green:0.34f blue:0.43f alpha:1.00f]];
    [titleLbl setShadowColor:[UIColor whiteColor]];
    [titleLbl setShadowOffset:CGSizeMake(0, 1)];
    // フォントサイズを調整
    [titleLbl setFont:[UIFont boldSystemFontOfSize:16.0]];
    
    if([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0)
    {   // iOS7以上
        [titleLbl setFont:[UIFont systemFontOfSize:14.0]];
        [titleLbl setTextColor:[UIColor grayColor]];
    }

    [titleLbl setAdjustsFontSizeToFitWidth: YES];

    switch (sectionId) {
        case E_TABLE_SECTION_FILE_FORMAT:
            [titleLbl setText:S_TITLE_FORMAT_FILE_FORMAT ];
            break;
        case E_TABLE_SECTION_COMPACT_PDF:
            if([self visibleSection:E_TABLE_SECTION_COMPACT_PDF]){
                [titleLbl setText:S_TITLE_FORMAT_COMPACT_PDF];
            }
            break;
        case E_TABLE_SECTION_COMPRESSION:
            if([self visibleSection:E_TABLE_SECTION_COMPRESSION]){
                if(scColorMode.selectedSegmentIndex == 0){
                    [titleLbl setText:S_TITLE_FORMAT_COLOR_COMPRESSION];
                }else{
                    [titleLbl setText:S_TITLE_FORMAT_MONOCHROME_COMPRESSION];
                }
            }
        default:
            break;
    }
    
    [returnView addSubview:titleLbl];

    return returnView;

}

// 各ヘッダーの高さ
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    CGFloat h = TABLE_FOOTER_HEIGHT_1;
    int sectionId = [[tableSectionIDs objectAtIndex:section] intValue];
    if(sectionId == E_TABLE_SECTION_FILE_FORMAT && [self visibleSection:E_TABLE_SECTION_FILE_FORMAT]){
        h = 40.0;
    }
    else if(sectionId == E_TABLE_SECTION_COMPACT_PDF && [self visibleSection:E_TABLE_SECTION_COMPACT_PDF]){
        h = 40.0;
    }
    else if(sectionId == E_TABLE_SECTION_COMPRESSION && [self visibleSection:E_TABLE_SECTION_COMPRESSION]){
        h = 40.0;
    }
    return h;
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
{
    // Picker表示用View設定

    NSMutableArray* setArray = [NSMutableArray array];
    int nSelRow = 0;
    switch (cell.tag) {
        case E_TABLE_SECTION_FILE_FORMAT:
            //  ファイル形式
            [setArray addObjectsFromArray:fileFormatList];
            nSelRow = nSelectFileFormatIndexRow;
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
                nSelRow = nSelectCompressionRatioIndexRow;
            }else{
                // 白黒2値画像の圧縮形式
                [setArray addObjectsFromArray:monoImageCompressionTypeList];
                nSelRow = nSelectMonoImageCompressionTypeListIndexRow;
            }
            break;
        case E_TABLE_SECTION_PAGE_PER_FILE:
            // ページ数
            // とりあえず0 ~ 9
            for(int i = 0; i <= 9; i++){
                [setArray addObject:[NSString stringWithFormat:@"%d", i]];
            }
            nSelRow = nSelectPageNum;
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

- (IBAction)OnMenuDecideButton:(id)sender
{
    
    // Todo getPickerValueActionで行っていた処理をここで行う

    NSInteger row = m_nSelRow;
    
    // アクションシート非表示
    [m_pactsheetMenu dismissWithClickedButtonIndex:-1 animated:YES];
    
    // タイトルラベルを取得
    UITableViewCell* cell = [formatTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:(int)[tableSectionIDs indexOfObject:[NSNumber numberWithInt:m_nSelPicker]]]];
    UILabel* titleLbl = (UILabel*)[cell.contentView viewWithTag:CELL_TITLE_LABEL_TAG];
    
    // 値の格納
    switch (m_nSelPicker) {
        case E_TABLE_SECTION_FILE_FORMAT:
            //  ファイル形式
            nSelectFileFormatIndexRow = row;
//　保存ボタンに処理を移動
/*
            [parentVCDelegate.rssViewData.formatData setSelectFileFormatValue:row];
*/  
//            [parentVCDelegate.rssViewData.formatData setBeforeFileFormatValue:row];
            bBeforeJpeg = NO;
            
            // 圧縮PDFタイプを再取得する
            [compressionPDFTypeList removeAllObjects];
//　保存ボタンに処理を移動 iPhone用
//            [compressionPDFTypeList addObjectsFromArray:[parentVCDelegate.rssViewData.formatData getSelectableCompactPdfTypeArray]];
            [compressionPDFTypeList addObjectsFromArray:[parentVCDelegate.rssViewData.formatData getSelectableCompactPdfTypeArray:nSelectFileFormatIndexRow]];


            // 圧縮率のリストを再取得する
            [compressionRatioList removeAllObjects];
//　保存ボタンに処理を移動　iPhone用 
//            [compressionRatioList addObjectsFromArray:[parentVCDelegate.rssViewData.formatData getSelectableCompressionRatioArray]];
            [compressionRatioList addObjectsFromArray:[parentVCDelegate.rssViewData.formatData getSelectableCompressionRatioArray:nSelectFileFormatIndexRow]];

            if(nSelectCompressionRatioIndexRow >= compressionRatioList.count){
                // 黒文字重視設定が使えない場合は低圧縮に変更する対応
                nSelectCompressionRatioIndexRow = 0;
//　保存ボタンに処理を移動
/*
                [parentVCDelegate.rssViewData.formatData setSelectCompressionRatioValue:0];
*/
            }
            
            // タイトルラベルの更新
            titleLbl.text = [fileFormatList objectAtIndex:nSelectFileFormatIndexRow];
//            [parentVCDelegate updateSetting];
            break;
        case E_TABLE_SECTION_COMPACT_PDF:
            // 高圧縮PDFのタイプ
            nSelectCompressionPDFTypeIndexRow = row;
//　保存ボタンに処理を移動
/*
            [parentVCDelegate.rssViewData.formatData setSelectCompactPdfTypeValue:row];
*/

//            // 圧縮PDFのタイプが高圧縮または高圧縮高精細の場合、解像度を300x300dpiに変更する。
//            if([[parentVCDelegate.rssViewData.formatData getSelectFileFormatValue] rangeOfString:@"compact"].location != NSNotFound)
//            {
//                [parentVCDelegate.rssViewData.resolution setSelectKey: @"300"];
//                [parentVCDelegate updateSetting];
//            }
            
            // タイトルラベルの更新
            titleLbl.text = [compressionPDFTypeList objectAtIndex:nSelectCompressionPDFTypeIndexRow];
            break;
        case E_TABLE_SECTION_COMPRESSION:
            if(scColorMode.selectedSegmentIndex == 0){
                // カラー／グレースケール画像の圧縮率
                nSelectCompressionRatioIndexRow = row;
//　保存ボタンに処理を移動
/*
                [parentVCDelegate.rssViewData.formatData setSelectCompressionRatioValue:row];
*/
                // タイトルラベルの更新
                titleLbl.text = [compressionRatioList objectAtIndex:nSelectCompressionRatioIndexRow];
            }else{
                // 白黒2値画像の圧縮形式
                nSelectMonoImageCompressionTypeListIndexRow = row;
//　保存ボタンに処理を移動
/*
                [parentVCDelegate.rssViewData.formatData setSelectCompressionValue:row];
*/              
                // タイトルラベルの更新
                titleLbl.text = [monoImageCompressionTypeList objectAtIndex:nSelectMonoImageCompressionTypeListIndexRow];
            }
            break;
        case E_TABLE_SECTION_PAGE_PER_FILE:
           //  page select (no test)
            // ページ数
            nSelectPageNum = m_nSelRow;
// 保存ボタンに処理を移動          
/*
            parentVCDelegate.rssViewData.formatData.selectPagePerFile = nSelectPageNum;
 */            
            // ページ数更新
            pageNumLbl.text = [NSString stringWithFormat:@"%d  %@", (nSelectPageNum?nSelectPageNum:1), S_FORMAT_PAGE];
            /**/
            break;
            
        default:
            break;
    }
// 保存ボタンに処理を移動
/*
    // 親タイトルの更新
    [parentVCDelegate updateSetting];    
*/
    // セクションの削除と挿入
    [self sectionDeleteAndInsert];    
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
        UISegmentedControl * seg = segment;

        // 左側のセグメントの場合
        if (seg.frame.origin.x == 0 && seg.frame.origin.y == 0) {
            // 各セグメントのラベル
            for (id label in [segment subviews]) {
                if ([label isKindOfClass:[UILabel class]]) {
                    // フォントサイズ変更
                    [label setFont:[UIFont boldSystemFontOfSize: 13]];
                    // 文字が左寄せになるので、センターへ設定
                    [label setTextAlignment: UITextAlignmentCenter];
                    break;
                }
            }
        }
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
        [parentVCDelegate.rssViewData.formatData setSelectFileFormatValue:            nSelectFileFormatIndexRow];
    }
    // 圧縮率のリストを再取得する
    [parentVCDelegate.rssViewData.formatData setSelectCompressionRatioValue:nSelectCompressionRatioIndexRow];
    
    // 高圧縮PDFのタイプ
    [parentVCDelegate.rssViewData.formatData setSelectCompactPdfTypeValue:nSelectCompressionPDFTypeIndexRow];
    
    // カラー／グレースケール画像の圧縮率
    [parentVCDelegate.rssViewData.formatData setSelectCompressionRatioValue:nSelectCompressionRatioIndexRow];
    
    // 白黒2値画像の圧縮形式
    [parentVCDelegate.rssViewData.formatData setSelectCompressionValue:nSelectMonoImageCompressionTypeListIndexRow];
    
    // ページ数
    parentVCDelegate.rssViewData.formatData.selectPagePerFile = nSelectPageNum;

    // スイッチのON,OFFを保存
    [parentVCDelegate.rssViewData.formatData setIsPagePerFile:bEveryPageFiling];
    [parentVCDelegate.rssViewData.formatData setIsEncript:bEncrypt];
    
    // パスワード
    [parentVCDelegate.rssViewData.formatData setPdfPasswordValue:passwordTextField.text];
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
    if (!bEncrypt)
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
        // フォーマットエラー
        result = NO;
        
        [self CreateAllertWithOKButton:nil message:[NSString stringWithFormat:MSG_FORMAT_ERR, SUBMSG_PDFPASSWORD_ERR, SUBMSG_PDFPASSWORD_FORMAT] startBtnTitle:MSG_BUTTON_OK withTag:1];
    }
    
    return result;
}
#pragma mark - UIAlertViewDelegate
//
// アラートボタンによる処理(アラートが閉じた後に呼ばれるメソッド)
//
- (void)alertView:(UIAlertView *)alerts didDismissWithButtonIndex:(NSInteger)buttonIndex
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
    
    UIAlertView *m_palert = nil;
    m_palert = [[UIAlertView alloc] initWithTitle:nil
                                          message:pstrMsg
                                         delegate:self
                                cancelButtonTitle:nil
                                otherButtonTitles:pstrStartBtnTitle, nil];
    
    m_palert.tag = nTag;
    [m_palert performSelectorOnMainThread:@selector(show) withObject:nil waitUntilDone:YES];
}

@end
