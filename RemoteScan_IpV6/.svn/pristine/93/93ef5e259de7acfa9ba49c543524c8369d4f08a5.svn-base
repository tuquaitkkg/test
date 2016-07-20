
#import "RSS_CustomSizeSettingViewController.h"
#import "EditableCell.h"
#import "CustomPickerViewController.h"
#import "CommonUtil.h"
#import "PickerViewController.h"
#import "SharpScanPrintAppDelegate.h"
#import "ExAlertController.h"

@interface RSS_CustomSizeSettingViewController ()

@end

@implementation RSS_CustomSizeSettingViewController

@synthesize parentVCDelegate;
@synthesize	baseDir;							// ホームディレクトリ/Documments/
@synthesize bEdit;                              // カスタムサイズ編集のフラグ
@synthesize pCustomDataList;
@synthesize m_pRsCustomPaperSizeData;
@synthesize nSelectedRow;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}


- (id)initWithSettingName:(NSString*)name
{
    self = [self initWithNibName:@"RSS_CustomSizeSettingViewController" bundle:nil];
    if(self){
        if(name){
            // 既存設定を読み込む
            m_pstrName = name;
        }else{
            // 新規作成
            m_pstrName = nil;
        }
        nUnitType = UNIT_TYPE_MILLIMETER;
        nMillimeter_V = nMillimeter_H = 25;
        nInchHigh_V = nInchHigh_H = 1;
        nInchLow_V = nInchLow_H = 0;
        
        inchLowText = [[NSArray alloc]initWithObjects:@"-", @"1/8", @"1/4", @"3/8", @"1/2", @"5/8", @"3/4", @"7/8", nil];
        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // セルのラインを表示する
    customSizeSettingTableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    
    // スクロールの必要がないのでNO
    //customSizeSettingTableView.scrollEnabled = NO;
    
    // ナビゲーションバーの設定
    NSString* pstrTitle;
    if(bEdit)
    {
        // カスタムサイズの名称をタイトルに設定する
        pstrTitle = m_pstrName;
    }else
    {
        pstrTitle = S_TITLE_CUSTOMSIZE_REGISTER;
    }
    
    // タイトル設定
    CGRect frame = CGRectMake(0, 0, 400, 44);
    UILabel* lblTitle = [[UILabel alloc]initWithFrame:frame];
    lblTitle.backgroundColor = [UIColor clearColor];
    lblTitle.textColor = NAVIGATION_TITLE_COLOR;
    lblTitle.font = [UIFont boldSystemFontOfSize:20];
    if ([S_LANG isEqualToString:S_LANG_JA])
    {
        // 国内版の場合、表示文字を小さくする
        lblTitle.adjustsFontSizeToFitWidth = YES;
        lblTitle.minimumScaleFactor = 7 / lblTitle.font.pointSize;
    }else{
        if (!bEdit) {
            lblTitle.adjustsFontSizeToFitWidth = YES;
        }
    }
    lblTitle.textAlignment = NSTextAlignmentCenter;
    lblTitle.text = pstrTitle;
    lblTitle.lineBreakMode = NSLineBreakByTruncatingTail;
    self.navigationItem.titleView = lblTitle;
    
    // 戻るボタン(次のビュー用)
    UIBarButtonItem * barItemBack = [UIBarButtonItem new];
    barItemBack.title = S_BUTTON_BACK;
    self.navigationItem.backBarButtonItem = barItemBack;
    
    // 保存ボタン
    UIBarButtonItem* rightBtn = [[UIBarButtonItem alloc]initWithTitle:S_BUTTON_SAVEVAL style:UIBarButtonItemStyleDone target:self action:@selector(tapSaveBtn)];
    self.navigationItem.rightBarButtonItem = rightBtn;
    
    // 名称テキストフィールド初期化
    nameTextField = [[UITextField alloc] init];
    nameTextField.delegate = self;
    [self settingDefaultTextField:nameTextField];
    
    // ミリ単位設定ボタン初期化
    m_pBtnSizeMillimeter = [UIButton buttonWithType:UIButtonTypeCustom];
    [m_pBtnSizeMillimeter setExclusiveTouch: YES];
    m_pBtnSizeMillimeter.tag = BTN_TAG_MILLIMETER;
    [self settingDefaultButton:m_pBtnSizeMillimeter title:[NSString stringWithFormat:@"%d × %d ", nMillimeter_H,nMillimeter_V]];
    
    // インチ単位設定ボタン初期化
    m_pBtnSizeInch = [UIButton buttonWithType:UIButtonTypeCustom];
    [m_pBtnSizeInch setExclusiveTouch: YES];
    m_pBtnSizeInch.tag = BTN_TAG_INCH;
    [self settingDefaultButton:m_pBtnSizeInch title:[self setInchBtnTitle:nInchHigh_H :[inchLowText objectAtIndex:nInchLow_H] :nInchHigh_V :[inchLowText objectAtIndex:nInchLow_V]]];
    
    // 単位設定
    [unitTypeSeg setSelectedSegmentIndex:nUnitType];
    [unitTypeSeg setTitle:S_BUTTON_CUSTOMSIZE_REGISTER_MILLIMETER forSegmentAtIndex:0];
    [unitTypeSeg setTitle:S_BUTTON_CUSTOMSIZE_REGISTER_INCH forSegmentAtIndex:1];
    
    // CustomPickerViewの初期化
    pickerViewController = [[CustomPickerViewController alloc] init];
}

// iPhone用
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    // 設定ファイル格納ディレクトリの取得
    self.baseDir		= CommonUtil.settingFileDir;
    
    //
    // データ取得
    //
    pCustomDataList = [self readCustomData];
    
    if(bEdit)
    {
        nUnitType = m_pRsCustomPaperSizeData.bMilli == YES ? UNIT_TYPE_MILLIMETER : UNIT_TYPE_INCH;
        m_pstrName = m_pRsCustomPaperSizeData.name;
        nMillimeter_H = m_pRsCustomPaperSizeData.paperWidthMilli;
        nMillimeter_V = m_pRsCustomPaperSizeData.paperHeightMilli;
        nInchHigh_H = m_pRsCustomPaperSizeData.paperWidthInch;
        nInchHigh_V = m_pRsCustomPaperSizeData.paperHeightInch;
        nInchLow_H = [inchLowText indexOfObject:m_pRsCustomPaperSizeData.paperWidthInchLow];
        nInchLow_V = [inchLowText indexOfObject:m_pRsCustomPaperSizeData.paperHeightInchLow];
        myCustomSizeKey = m_pRsCustomPaperSizeData.customSizeKey;// カスタムサイズキーを引き継ぐ
        
    }else{
        nUnitType = UNIT_TYPE_MILLIMETER;
        m_pstrName = nil;
        nMillimeter_V = nMillimeter_H = 25;
        nInchHigh_V = nInchHigh_H = 1;
        nInchLow_V = nInchLow_H = 0;
        
    }
    // 単位設定
    [unitTypeSeg setSelectedSegmentIndex:nUnitType];
    [unitTypeSeg setTitle:S_BUTTON_CUSTOMSIZE_REGISTER_MILLIMETER forSegmentAtIndex:0];
    [unitTypeSeg setTitle:S_BUTTON_CUSTOMSIZE_REGISTER_INCH forSegmentAtIndex:1];
    
    // サイズの設定
    [m_pBtnSizeMillimeter setTitle:[NSString stringWithFormat:@"%d × %d ", nMillimeter_H,nMillimeter_V] forState:UIControlStateNormal];
    [m_pBtnSizeMillimeter setTitle:[NSString stringWithFormat:@"%d × %d ", nMillimeter_H,nMillimeter_V] forState:UIControlStateHighlighted];
    
    [m_pBtnSizeInch setTitle:[self setInchBtnTitle:nInchHigh_H :[inchLowText objectAtIndex:nInchLow_H] :nInchHigh_V :[inchLowText objectAtIndex:nInchLow_V]] forState:UIControlStateNormal];
    [m_pBtnSizeInch setTitle:[self setInchBtnTitle:nInchHigh_H :[inchLowText objectAtIndex:nInchLow_H] :nInchHigh_V :[inchLowText objectAtIndex:nInchLow_V]] forState:UIControlStateHighlighted];
    
    
    // リロード
    [customSizeSettingTableView reloadData];
    
}

- (void) viewWillDisappear:(BOOL)animated {
    
    [pickerViewController viewWillDisappear:animated];
    [super viewWillDisappear:animated];
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

// ボタンのデフォルト設定
- (void)settingDefaultButton:(UIButton*)button title:(NSString*)title
{
    [button.titleLabel setFont:[UIFont systemFontOfSize:14]];
    [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [button setTitleColor:[UIColor blackColor] forState:UIControlStateHighlighted];
    [button setTitle:title forState:UIControlStateNormal];
    [button setTitle:title forState:UIControlStateHighlighted];
    //    [button setAutoresizingMask:UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin];
    [button addTarget:self action:@selector(tapSettingButton:) forControlEvents:UIControlEventTouchUpInside];
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
    self.parentVCDelegate = nil;
    
    nameTextField = nil;
    
    m_pBtnSizeMillimeter = nil;
    m_pBtnSizeInch = nil;
    
    inchLowText = nil;
    
    customSizeSettingTableView = nil;
    unitTypeSeg = nil;
    [super viewDidUnload];
}


#pragma mark - UITableViewDelegate
// セクション数
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

// セルの数
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 2;
}

// テーブルセルの作成
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *CellIdentifier = [NSString stringWithFormat:@"Cell%@", (indexPath.row == 0 ? @"Name":[NSString stringWithFormat:@"Size%@", (unitTypeSeg.selectedSegmentIndex == 0 ? @"M" : @"I")])];
    UILabel* titleLbl = nil;
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if(cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        // タイトルラベルの作成
        CGRect titleLblFrame = cell.contentView.frame;
        
        if([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0)
        {
            // iOS7以降 もしくはiPad
            titleLblFrame.origin.x += 20;
            titleLblFrame.size.width -= 20;
        }else{
            // iOS6以前
            titleLblFrame.origin.x += 10;
            titleLblFrame.size.width -= 10;
        }
        
        titleLbl = [[UILabel alloc]initWithFrame:titleLblFrame];
        titleLbl.font = [UIFont systemFontOfSize:14];
        titleLbl.backgroundColor = [UIColor clearColor];
        titleLbl.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        titleLbl.tag = 3;
        
        [cell.contentView addSubview:titleLbl];
        
        // セルタイトル
        switch (indexPath.row) {
            case 0:
            {
                titleLbl.text = S_CUSTOMSIZE_REGISTER_NAME;
                // 名称テキストフィールドの追加
                CGRect frame = CGRectMake(100, 0, cell.contentView.frame.size.width - 100, cell.contentView.frame.size.height);
                nameTextField.frame = frame;
                nameTextField.text =  m_pstrName;
                [cell.contentView addSubview:nameTextField];
                
                break;
            }
            case 1:
            {
                titleLbl.text = S_CUSTOMSIZE_REGISTER_SIZE;
                if(unitTypeSeg.selectedSegmentIndex == 0){
                    // サイズ設定(ミリ単位)
                    CGRect frame = CGRectMake(cell.contentView.frame.size.width * 0.5 - 50, 0, 100, cell.contentView.frame.size.height);
                    m_pBtnSizeMillimeter.frame = frame;
                    m_pBtnSizeMillimeter.center = CGPointMake([[UIScreen mainScreen] bounds].size.width / 2, cell.center.y);
                    [cell.contentView addSubview:m_pBtnSizeMillimeter];
                    
                    
                }else{
                    // サイズ設定(インチ単位)
                    // 上位
                    CGRect frame = CGRectMake(cell.contentView.frame.size.width * 0.5 - 50, 0, 100, cell.contentView.frame.size.height);
                    m_pBtnSizeInch.frame = frame;
                    m_pBtnSizeInch.center = CGPointMake([[UIScreen mainScreen] bounds].size.width / 2, cell.center.y);
                    [cell.contentView addSubview:m_pBtnSizeInch];
                }
                
                // 単位表記
                UILabel* lbl = [[UILabel alloc]initWithFrame:CGRectMake([[UIScreen mainScreen] bounds].size.width - 85, 0, 60, cell.contentView.frame.size.height)];
                lbl.font = [UIFont systemFontOfSize:14];
                lbl.text = (unitTypeSeg.selectedSegmentIndex == 0 ? S_CUSTOMSIZE_REGISTER_MILLIMETER : S_CUSTOMSIZE_REGISTER_INCH);
                lbl.textAlignment = NSTextAlignmentRight;
                lbl.backgroundColor = [UIColor clearColor];
                [cell.contentView addSubview:lbl];
                
                break;
            }
            default:
                break;
        }
    }
    //    }
    return cell;
}

// 各セルの高さを設定
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return N_HEIGHT_SEL_DEFAULT;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // ハイライトOFF
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

// ヘッダーの高さを設定
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return TABLE_HEADER_HEIGHT_1;
}

// フッターの高さを設定
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return TABLE_FOOTER_HEIGHT_1;
}

#pragma mark - UISegmentedControl Action
- (IBAction)changedUnitTypeSegControl:(UISegmentedControl *)sender {
    
    nUnitType = (sender.selectedSegmentIndex == 0 ? UNIT_TYPE_MILLIMETER : UNIT_TYPE_INCH);
    [customSizeSettingTableView reloadData];
    
}

#pragma mark - UIButton Action
// 保存ボタン
-(void)tapSaveBtn
{
    // エラーチェックを行う
    if([self CheckError])
    {
        return;
    }
    
    // 入力値をセットする
    RSCustomPaperSizeData *rsCustomPaperSizeData = [[RSCustomPaperSizeData alloc]init];
    [rsCustomPaperSizeData setName:nameTextField.text];
    [rsCustomPaperSizeData setPaperWidthMilli:nMillimeter_H];
    [rsCustomPaperSizeData setPaperHeightMilli:nMillimeter_V];
    [rsCustomPaperSizeData setPaperWidthInch:nInchHigh_H];
    [rsCustomPaperSizeData setPaperHeightInch:nInchHigh_V];
    [rsCustomPaperSizeData setPaperWidthInchLow:[inchLowText objectAtIndex:nInchLow_H]];
    [rsCustomPaperSizeData setPaperHeightInchLow:[inchLowText objectAtIndex:nInchLow_V]];
    [rsCustomPaperSizeData setBMilli:unitTypeSeg.selectedSegmentIndex == 0 ? YES : NO];
    
    if(bEdit)
    {
        // 編集時は「カスタムサイズキー」をそのまま設定する
        [rsCustomPaperSizeData setCustomSizeKey:myCustomSizeKey];

        // 選択した行を変更
        [pCustomDataList replaceObjectAtIndex:nSelectedRow withObject:rsCustomPaperSizeData];
    }
    else
    {
        // 新規登録時は「カスタムサイズキー」を取得する
        [rsCustomPaperSizeData setCustomSizeKey:[self getCustomSizeKey]];

        // 最後尾に追加
        [pCustomDataList insertObject:rsCustomPaperSizeData atIndex:[pCustomDataList count]];
    }
    
    if([self saveCustomData])
    {
        DLog(@"success");
    }else{
        DLog(@"err");
    }
    
    [self.navigationController popViewControllerAnimated:YES];
}

// 新規登録時に「カスタムサイズキー」を取得する
- (NSString*)getCustomSizeKey
{
    NSString *customSizeKey = @"";
    
    NSMutableArray *customSizeKeyList = [NSMutableArray array];
    for (RSCustomPaperSizeData *tempData in pCustomDataList) {
        // 現在使用中のcustomSizeキーを取り出す
        [customSizeKeyList addObject:tempData.customSizeKey];
    }
    
    // 設定可能な「カスタムサイズキー」を探す
    if (![customSizeKeyList containsObject:@"customSize1"]) {
        customSizeKey = @"customSize1";
    } else if (![customSizeKeyList containsObject:@"customSize2"]) {
        customSizeKey = @"customSize2";
    } else if (![customSizeKeyList containsObject:@"customSize3"]) {
        customSizeKey = @"customSize3";
    } else if (![customSizeKeyList containsObject:@"customSize4"]) {
        customSizeKey = @"customSize4";
    } else if (![customSizeKeyList containsObject:@"customSize5"]) {
        customSizeKey = @"customSize5";
    }
    return customSizeKey;
}

// 入力チェック
- (NSInteger)CheckError
{
    NSInteger nRet = ERR_SUCCESS;
	NSString* pstrMessage = @"";
	NSString* pstrText = @"";
    
    // カスタムサイズの名称チェック
    if (nRet == ERR_SUCCESS)
    {
        nRet = [CommonUtil IsRSCustomSizeName:nameTextField.text];
        pstrText = S_CUSTOMSIZE_REGISTER_NAME;
    }
    // エラーメッセージ表示
	if (nRet != ERR_SUCCESS)
	{
		switch (nRet)
		{
			case ERR_NO_INPUT:	// 未入力
				pstrMessage = [NSString stringWithFormat:MSG_REQUIRED_ERR, pstrText];
				break;
			case ERR_INVALID_FORMAT:	// 入力形式不正（文字数範囲超過）
                pstrMessage = [NSString stringWithFormat:MSG_LENGTH_ERR, pstrText, S_RS_CUSTOMSIZE_50LETTER];
				break;
			default:
				break;
		}
        
        // アラートを表示する
        [self profileAlert:nil errMessage:pstrMessage];
	}
	return nRet;
}

//
// アラート表示
//
-(void)profileAlert:(NSString *)errTitle errMessage:(NSString *)errMessage
{
    SharpScanPrintAppDelegate* appDelegate = (SharpScanPrintAppDelegate*)[[UIApplication sharedApplication] delegate];
    // 処理実行フラグON
    appDelegate.IsRun = TRUE;
    
    [self makeTmpExAlert:errTitle message:errMessage cancelBtnTitle:MSG_BUTTON_OK okBtnTitle:nil tag:0];
	[super viewDidLoad];
    
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

//ダイアログのボタン押下時
-(void)alertButtonPushed:(UIAlertController *)alertController tagIndex:(NSInteger)tagIndex buttonIndex:(NSInteger)buttonIndex
{
    SharpScanPrintAppDelegate* appDelegate = (SharpScanPrintAppDelegate*)[[UIApplication sharedApplication] delegate];
    // 処理実行フラグON
    appDelegate.IsRun = FALSE;
}

// プロパティリストを読み込んでPrinterDataクラスを生成
- (NSMutableArray *)readCustomData
{
    //
	// 自動解放プールの作成
	//
    @autoreleasepool
    {
        @try {
            //
            // 読み込む
            //
            id obj;
            
            NSString *pstrFileName = [ CommonUtil.settingFileDir stringByAppendingString:S_CUSTOMSIZEDATA_DAT];
            
            // initWithCoder が call される
            obj = [NSKeyedUnarchiver unarchiveObjectWithFile:pstrFileName];
            
            NSMutableArray *parrTempData = [[NSMutableArray alloc] initWithCapacity:[obj count]];
            
            for (NSInteger nIndex = 0; nIndex < [obj count]; nIndex++)
            {
                // RSCustomPaperSizeDataクラスの生成
                RSCustomPaperSizeData *rsCustomPaperSizeData = [[RSCustomPaperSizeData alloc]init];
                // カスタムサイズ情報をDATファイルから取得
                rsCustomPaperSizeData = [obj objectAtIndex:nIndex];
                // カスタムサイズ情報をRSCustomPaperSizeDataクラスに追加
                [parrTempData addObject:rsCustomPaperSizeData];
                
            }
            return parrTempData;
        }
        @finally {
        }
    }
    
    return nil;
    
}

//
// カスタムサイズ情報の保存
//
- (BOOL)saveCustomData
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
            NSString *fileName	= [CommonUtil.settingFileDir stringByAppendingString:S_CUSTOMSIZEDATA_DAT];
            
            if (![NSKeyedArchiver archiveRootObject:pCustomDataList toFile:fileName]) {
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


// インチ単位設定ボタンを押したときの処理
- (void)tapSettingButton:(UIButton*)btn
{
    m_nSelPicker = btn.tag;
    [self showInchSettingPickerView:btn];
}

- (NSString*)setInchBtnTitle:(int)nInchWidthHigh :(NSString*)pstrInchWidthLow :(int)nInchHeightHigh :(NSString*)pstrInchHeightLow
{
    
    NSString* m_pstrInchBtnTitle = @"";
    
    if([pstrInchWidthLow isEqualToString:@"-"] && ![pstrInchHeightLow isEqualToString:@"-"])
    {
        m_pstrInchBtnTitle = [NSString stringWithFormat:@"%d × %d %@ ", nInchWidthHigh,nInchHeightHigh,pstrInchHeightLow];
    }
    else if(![pstrInchWidthLow isEqualToString:@"-"] && [pstrInchHeightLow isEqualToString:@"-"])
    {
        m_pstrInchBtnTitle = [NSString stringWithFormat:@"%d %@ × %d ", nInchWidthHigh,pstrInchWidthLow,nInchHeightHigh];
    }
    else if([pstrInchWidthLow isEqualToString:@"-"] && [pstrInchHeightLow isEqualToString:@"-"])
    {
        m_pstrInchBtnTitle = [NSString stringWithFormat:@"%d × %d ", nInchWidthHigh,nInchHeightHigh];
    }
    else
    {
        m_pstrInchBtnTitle = [NSString stringWithFormat:@"%d %@ × %d %@ ", nInchWidthHigh,pstrInchWidthLow,nInchHeightHigh,pstrInchHeightLow];
    }
    
    
    return m_pstrInchBtnTitle;
}

#pragma mark - PickerView Manage
-(void)showInchSettingPickerView:(UIButton*)btn
{
    // キーボードを閉じる
    [nameTextField resignFirstResponder];
    
    // Picker表示用View設定
    NSMutableArray* setArray = [NSMutableArray array];
    NSMutableArray* setInchArray = nil;
    int nSelRow = 0;
    int nSelRow2 = 0;
    NSUInteger nSelInchRow = 0;
    NSUInteger nSelInchRow2 = 0;
    
    switch (btn.tag) {
        case BTN_TAG_MILLIMETER:
            // 数値を設定
            for(int i = 0; i <= 9; i++){
                [setArray addObject:[NSString stringWithFormat:@"%d", i]];
            }
            nSelRow = nMillimeter_H;
            nSelRow2 = nMillimeter_V;
            
            // ミリの場合のフラグを設定
            pickerViewController.m_bInch = NO;
            break;
            
        case BTN_TAG_INCH:
            // 数値を設定
            for(int i = 0; i <= 9; i++){
                [setArray addObject:[NSString stringWithFormat:@"%d", i]];
            }
            nSelRow = nInchHigh_H;
            nSelRow2 = nInchHigh_V;
            
            // インチの場合、分数表示用の桁を設定
            setInchArray = [inchLowText copy];
            nSelInchRow = nInchLow_H;//(setInchArray.count - 1) - nInchLow_H;
            nSelInchRow2 = nInchLow_V;//(setInchArray.count - 1) - nInchLow_V;
            
            // インチの場合の値とフラグを設定
            pickerViewController.m_nSelRowInch = nSelInchRow;
            pickerViewController.m_nSelRowInch2 = nSelInchRow2;
            pickerViewController.m_parrInchPickerRow = [setInchArray copy];
            pickerViewController.m_bInch = YES;
            
            break;
            
        default:
            // 例外処理
            return;
            break;
    }
    
    pickerViewController.m_parrPickerRow = [setArray copy];
    pickerViewController.m_nSelRow = nSelRow;
    pickerViewController.m_nSelRow2 = nSelRow2;
    
    // ピッカーを表示する
    [pickerViewController showPickerViewWithDelegate:self];
    
    // 通知の監視を開始
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getPickerValueAction:) name:@"Picker Value" object:nil];
}

// Picker選択値取得
- (void)getPickerValueAction:(NSNotification*)notification
{
    //    NSInteger row = [[[notification userInfo] objectForKey:@"ROW"] intValue];
    NSString* str = (NSString*)[[notification userInfo] objectForKey:@"VALUE"];
    NSString* str2 = (NSString*)[[notification userInfo] objectForKey:@"VALUE2"];
    NSString* str3 = (NSString*)[[notification userInfo] objectForKey:@"VALUE3"];
    NSString* str4 = (NSString*)[[notification userInfo] objectForKey:@"VALUE4"];
    
    NSString* m_pSizeTitle = @"";
    
    switch (m_nSelPicker) {
        case BTN_TAG_MILLIMETER:
            m_pSizeTitle = [NSString stringWithFormat:@"%@ × %@ ",str,str3];
            
            nMillimeter_H = [str intValue];
            nMillimeter_V = [str3 intValue];
            [m_pBtnSizeMillimeter setTitle:m_pSizeTitle forState:UIControlStateNormal];
            [m_pBtnSizeMillimeter setTitle:m_pSizeTitle forState:UIControlStateHighlighted];
            break;
        case BTN_TAG_INCH:
            nInchHigh_H = [str intValue];
            nInchLow_H = [inchLowText indexOfObject:str2];
            nInchHigh_V = [str3 intValue];
            nInchLow_V =  [inchLowText indexOfObject:str4];
            
            m_pSizeTitle = [self setInchBtnTitle:nInchHigh_H :str2 :nInchHigh_V :str4];
            
            [m_pBtnSizeInch setTitle:m_pSizeTitle forState:UIControlStateNormal];
            [m_pBtnSizeInch setTitle:m_pSizeTitle forState:UIControlStateHighlighted];
            
            break;
        default:
            // 例外処理
            return;
            break;
    }
    
    // 通知の監視を終了
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"Picker Value" object:nil];
    
}

#pragma mark - Keyboard Event
//
// 仮想キーボードの[DONE]キーが押された時のイベント処理
//

-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
}

@end
