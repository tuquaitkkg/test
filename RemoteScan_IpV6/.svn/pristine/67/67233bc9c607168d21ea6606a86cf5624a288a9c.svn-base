
#import "PickerViewController_iPad.h"
#import "Define.h"
#import "PrintOutDataManager.h"
#import "PrinterDataManager.h"
#import "PrintServerDataManager.h"


@implementation PickerViewController_iPad

@synthesize m_parrPickerRow;
@synthesize m_parrPickerRow2;
@synthesize m_nSelRow;
@synthesize m_bSets;
@synthesize m_bScanPrint;
@synthesize m_bUseContentSize;
@synthesize pPicker;
@synthesize segmentedControl;
@synthesize m_bSingleChar;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.m_bUseContentSize = NO;
        
        self.m_notificationName = @"Picker Value";
    }
    return self;
}


- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

/*
 // Implement loadView to create a view hierarchy programmatically, without using a nib.
 - (void)loadView
 {
 }
 */

 // Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Navigation Barに決定ボタン表示
    UIBarButtonItem *btnDecide = [[UIBarButtonItem alloc] initWithTitle:S_BUTTON_DECIDE style:UIBarButtonItemStylePlain target:self action:@selector(OnDecideButton:)];
    [self.navigationItem setRightBarButtonItem:btnDecide];

    // ピッカー作成
    [self CreatePickerView];
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
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
    // iPad用
    if (nil != m_parrPickerRow)
    {
        m_parrPickerRow = nil;
    }
    if (nil != m_parrPickerRow2)
    {
        m_parrPickerRow2 = nil;
    }
    // iPad用
}

// ピッカー作成
- (void)CreatePickerView
{	
    pPicker = [[UIPickerView alloc] init];
	
	pPicker.delegate = self;
	pPicker.dataSource = self;
	
    //ピッカーのサイズを設定
    if(m_bUseContentSize)
    {
        if (isIOS8Later) {
            if(self.m_bSingleChar){
                [pPicker setFrame:CGRectMake(0, 40, 200, 216)];
            }else{
                [pPicker setFrame:CGRectMake(0, 40, 320, 216)];
            }
        } else {
            [pPicker setFrame:(CGRect){0, 0, self.contentSizeForViewInPopover}];
        }
    }
    else if(m_bScanPrint)
    {
        if (isIOS8Later) {
            [pPicker setFrame:CGRectMake(0, 40, 500, 260)];
        } else {
            [pPicker setFrame:CGRectMake(0, 0, 500, 250)];
        }
    }
    else if(m_bSets)
    {
        if (isIOS8Later) {
            [pPicker setFrame:CGRectMake(0, 40, 200, 216)];
        } else {
            [pPicker setFrame:CGRectMake(0, 0, 200, 250)];
        }
    }
    else
    {
        if (isIOS8Later) {
            [pPicker setFrame:CGRectMake(0, 40, 320, 216)];
        } else {
            [pPicker setFrame:CGRectMake(0, 0, 320, 250)];
        }
    }

    // 選択時のインジケータを表示
	[pPicker setShowsSelectionIndicator:TRUE];
    
    // 現在の選択項目を初期表示とする
    if(!m_bSets)
    {
        [pPicker selectRow:m_nSelRow inComponent:0 animated:NO];
    }
    else
    {
        NSInteger nSelRowTen = (m_nSelRow / 10);
        // 10の位
        [pPicker selectRow:nSelRowTen inComponent:0 animated:NO];
        // 1の位 ※0の場合は1を設定
        NSInteger nSelRowOne = (m_nSelRow == 0) ? 1 : (m_nSelRow - nSelRowTen * 10);
        [pPicker selectRow:nSelRowOne inComponent:1 animated:NO];
    }
    
    [self.view addSubview:pPicker];
}

// 列数返却
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    NSInteger numPicker = 1;
    // 部数の場合は２列
    if(m_bSets)
    {
        numPicker = 2;
    }
    return numPicker;
}

// 行数返却
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    if (segmentedControl && segmentedControl.selectedSegmentIndex == 1) {
        return [m_parrPickerRow2 count];
    } else {
        return [m_parrPickerRow count];
    }
}

// ピッカーに表示する文字列を返却
- (NSString*)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    // 行インデックス番号を返す
    if (segmentedControl && segmentedControl.selectedSegmentIndex == 1) {
        return [m_parrPickerRow2 objectAtIndex:row];
    } else {
        return [m_parrPickerRow objectAtIndex:row];
    }
}

//
//ピッカーに表示する文字列を返却
//
- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view {
    UILabel* label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, [pickerView rowSizeForComponent:component].width-8, [pickerView rowSizeForComponent:component].height)];
    if (segmentedControl && segmentedControl.selectedSegmentIndex == 1) {
        [label setText:[m_parrPickerRow2 objectAtIndex:row]];
    } else {
        [label setText:[m_parrPickerRow objectAtIndex:row]];
    }
    [label setFont:[UIFont boldSystemFontOfSize:15]];
    [label setBackgroundColor:[UIColor clearColor]];
    if(m_bSingleChar){
        label.textAlignment = NSTextAlignmentCenter;
    }
    return label;
}

// ピッカーの値選択時の動作
- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    if(m_bSets)
    {
        // m_bSets == YESの場合は２桁
        NSInteger tenPlace = [pickerView selectedRowInComponent:0];
        NSInteger onePlace = [pickerView selectedRowInComponent:1];
        m_nSelRow = (tenPlace * 10) + onePlace;
        if(0 == m_nSelRow)
        {
            m_nSelRow = 1;
        }
    }
    else
    {
        m_nSelRow = row;
    }
}

- (IBAction)OnDecideButton:(id)sender
{
    NSString* strSelRow = [NSString stringWithFormat:@"%ld",(long)m_nSelRow];
    NSString* strSelValue;
    if(m_bSets)
    {
        strSelValue = strSelRow;
    }
    else
    {
        if (segmentedControl && segmentedControl.selectedSegmentIndex == 1) {
            strSelValue = [m_parrPickerRow2 objectAtIndex:m_nSelRow];
        } else {
            strSelValue = [m_parrPickerRow objectAtIndex:m_nSelRow];
        }
    }
    //通知処理
    NSArray *dicObjects = [NSArray arrayWithObjects:strSelRow, strSelValue, nil];
    NSArray *keys = [NSArray arrayWithObjects:@"ROW", @"VALUE" , nil];
    NSDictionary *dic = [NSDictionary dictionaryWithObjects:dicObjects forKeys:keys];
    NSNotification *notification = [NSNotification notificationWithName:self.m_notificationName object:self userInfo:dic];
    [[NSNotificationCenter defaultCenter] postNotification:notification];
    
    if (segmentedControl) {
        // デフォルトの印刷先を設定する
        PrintOutDataManager* printOutManager = [[PrintOutDataManager alloc]init];
        [printOutManager SetLatestPrintType:segmentedControl.selectedSegmentIndex];
    }
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{    
    // Return YES for supported orientations
	return YES;
}

// プリンタ、プリントサーバー切り替えようのセグメントコントロールを追加
- (void)addSegmentedControl {
    // UISegmentedControl を真ん中に追加
    UIImage *image1 = [UIImage imageNamed:S_ICON_PRINTER];
    UIImage *image2 = [UIImage imageNamed:S_ICON_PRINTSERVER];
    NSArray *items = [NSArray arrayWithObjects:image1, image2, nil];
    segmentedControl = [[UISegmentedControl alloc] initWithItems:items];
    segmentedControl.momentary = NO;
    segmentedControl.contentMode = UIViewContentModeScaleAspectFit;
    segmentedControl.frame = CGRectMake(segmentedControl.frame.origin.x, segmentedControl.frame.origin.y, segmentedControl.frame.size.width + 16.0f * [items count], segmentedControl.frame.size.height);
    [segmentedControl addTarget:self action:@selector(segmentedControlAction:) forControlEvents:UIControlEventValueChanged];
    
    // プリンタかプリントサーバーかの設定を確認する
    PrintOutDataManager* printOutManager = [[PrintOutDataManager alloc]init];
    NSInteger select = [printOutManager GetLatestPrintType];

    [segmentedControl setSelectedSegmentIndex:select];
    //    [self.navigationItem setTitleView:segmentedControl]; // TODO: プリントサーバー機能を一旦外す
}

// ピッカービューのアイテムを切り替える
- (void)segmentedControlAction:(UISegmentedControl *)sc {
    [pPicker reloadAllComponents];
    
    // 最新プライマリキーを取得して選択中MFPを設定
    PrintOutDataManager* printOutManager = [[PrintOutDataManager alloc]init];
    NSInteger nSaveIdx = -1;

    // デフォルト指定のプリンターもしくはプリントダーバーを選択する
    if (sc.selectedSegmentIndex == 0) {
        // PrinterDataManagerクラス初期化
        PrinterDataManager *m_pPrinterMgr = [[PrinterDataManager alloc] init];
        nSaveIdx = [m_pPrinterMgr GetPrinterIndexForKey:[printOutManager GetLatestPrimaryKey]];
        [pPicker selectRow:nSaveIdx inComponent:0 animated:NO];
        m_nSelRow = nSaveIdx;
    }else {
        // PrintServerDataManagerクラス初期化
        PrintServerDataManager *m_pPrintServerMgr = [[PrintServerDataManager alloc] init];
        nSaveIdx = [m_pPrintServerMgr GetPrinterIndexForKey:[printOutManager GetLatestPrimaryKey2]];
        [pPicker selectRow:nSaveIdx inComponent:0 animated:NO];
        m_nSelRow = nSaveIdx;
    }
    
}

-(CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component
{
    if(m_bSingleChar){
        return 50;
    }
    
    else return( pPicker.frame.size.width )/[self numberOfComponentsInPickerView:pPicker];
}

@end
