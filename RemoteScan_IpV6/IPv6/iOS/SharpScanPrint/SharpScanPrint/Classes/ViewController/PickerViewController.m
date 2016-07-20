
#import "PickerViewController.h"
#import "Define.h"

#import "PickerModalBaseView.h"


@implementation PickerViewController
{
    PickerModalBaseView* _pickerModalBaseV;
}

@synthesize m_parrPickerRow;
@synthesize m_nSelRow;
@synthesize m_bSets;
@synthesize m_bScanPrint;
@synthesize pPicker;
@synthesize m_bUseContentSize;
@synthesize m_bSingleChar;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.m_bUseContentSize = NO;
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
    //    UIBarButtonItem *btnDecide = [[UIBarButtonItem alloc] initWithTitle:S_BUTTON_DECIDE style:UIBarButtonItemStyleBordered target:self action:@selector(OnDecideButton:)];
    //    [self.navigationItem setRightBarButtonItem:btnDecide];
    
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
    // iPad用
}

-(void)viewWillDisappear:(BOOL)animated
{
    //ピッカー閉じる
    [_pickerModalBaseV dismissAnimated:NO];
    
    [super viewWillDisappear:animated];
}

#pragma mark - ActionSheet or PickerModalView


- (PickerModalBaseView*)CreatePickerModalBase
{
    PickerModalBaseView* pmbv = [[PickerModalBaseView alloc] initWithFrame:self.navigationController.view.bounds];
    CGRect mainRec = [[UIScreen mainScreen] bounds];
//    CGRect naviRec =CGRectMake(0, 0, 320, 44);
    CGRect naviRec =CGRectMake(0, 0, mainRec.size.width, 44);
    // ナビゲーションバーを生成
    UINavigationBar *navigationBar = [[UINavigationBar alloc] initWithFrame:naviRec];
    // ナビゲーションアイテムを生成
    UINavigationItem* navigationItem = [[UINavigationItem alloc] initWithTitle:@""];
    
    UIBarButtonItem *pDecideBtn = [[UIBarButtonItem alloc] initWithTitle:S_BUTTON_DECIDE style:UIBarButtonItemStylePlain target:self action:@selector(OnMenuDecideButton:)];
    [navigationItem setRightBarButtonItem:pDecideBtn];
    
    UIBarButtonItem *pCancelBtn = [[UIBarButtonItem alloc] initWithTitle:S_BUTTON_CANCEL style:UIBarButtonItemStylePlain target:self action:@selector(OnMenuCancelButton:)];
    [navigationItem setLeftBarButtonItem:pCancelBtn];
    
    [navigationBar pushNavigationItem:navigationItem animated:NO];
    
    [pmbv addView:navigationBar];
    
    
    return pmbv;
}


// ピッカーを表示する
- (void)showPickerView
{
    // ベースビュー作成
    _pickerModalBaseV = [self CreatePickerModalBase];
    
    //ピッカー作成
    m_ppickerMenu = [self CreatePickerView];
    //ベースビューに追加
    [_pickerModalBaseV addView:m_ppickerMenu];
    
    //表示
    [_pickerModalBaseV showInView:self.navigationController.view animated:YES];
}

//非表示
- (void)dismissAnimated:(BOOL)animated
{
    [_pickerModalBaseV dismissAnimated:animated];
}

#pragma mark - PickerView Manage
// ピッカー作成
- (UIPickerView*)CreatePickerView
{
    CGRect mainRec = [[UIScreen mainScreen] bounds];
    // デフォルトの大きさ(320*250)のピッカー作成
    CGRect rickerRec = ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0?CGRectMake(0, 0, mainRec.size.width, 216):CGRectMake(0, 0, mainRec.size.width, 250));

	//UIPickerView *pPicker;
	
	pPicker = [[UIPickerView alloc] initWithFrame:rickerRec];
	
	pPicker.delegate = self;
	pPicker.dataSource = self;
	
    //    // ピッカー位置設定
    //    if(m_nSelPicker == PrvMenuIDThird)
    //    {
    //        [pPicker setFrame:CGRectMake(0, 0, 200, 250)];
    //    }
    
//    [pPicker setCenter:CGPointMake(160, 152)];
//    [pPicker setCenter:CGPointMake(160, mainRec.size.width/2)];
    // 選択時のインジケータを表示
	[pPicker setShowsSelectionIndicator:TRUE];
    
    // 現在の選択項目を初期表示する
    if(m_bSets)
    {   
        if(m_nSelRow < 1){m_nSelRow = 1;}
        if(m_nSelRow<10){
            [pPicker selectRow:0 inComponent:0 animated:NO];
            [pPicker selectRow:m_nSelRow inComponent:1 animated:NO];
        }else{
            [pPicker selectRow:m_nSelRow/10 inComponent:0 animated:NO];
            [pPicker selectRow:m_nSelRow%10 inComponent:1 animated:NO];       
        }
    }else{
        [pPicker selectRow:m_nSelRow inComponent:0 animated:NO];        
    }
	return pPicker;
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
    return [m_parrPickerRow count];
}

// ピッカーに表示する文字列を返却
- (NSString*)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    // 行インデックス番号を返す
    return [m_parrPickerRow objectAtIndex:row];
}

//
//ピッカーに表示する文字列を返却
//
- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view {
    UILabel* label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, [pickerView rowSizeForComponent:component].width-8, [pickerView rowSizeForComponent:component].height)];
    [label setText:[m_parrPickerRow objectAtIndex:row]];
    [label setFont:[UIFont boldSystemFontOfSize:16]];
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

- (void)OnMenuDecideButton:(id)sender
{
    m_bSingleChar = NO;
    [_pickerModalBaseV dismissAnimated:YES];
}

// アクションシートキャンセルボタン押下
- (void)OnMenuCancelButton:(id)sender
{
    m_bSingleChar = NO;
    [_pickerModalBaseV dismissAnimated:YES];
}

-(CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component
{
    if(m_bSingleChar){
        return 50;
    }
    
    else return pPicker.frame.size.width /[self numberOfComponentsInPickerView:pPicker];
}

@end
