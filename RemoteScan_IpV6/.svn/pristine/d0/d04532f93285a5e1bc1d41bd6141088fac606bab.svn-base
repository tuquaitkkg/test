
#import "CustomPickerViewController_iPad.h"
#import "Define.h"

@implementation CustomPickerViewController_iPad

@synthesize m_parrPickerRow;
@synthesize m_nSelRow;
@synthesize m_nSelRowInch;
@synthesize m_parrInchPickerRow;
@synthesize m_nSelRow2;
@synthesize m_nSelRowInch2;
@synthesize m_bInch;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
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

    UITableView *tableView = [[UITableView alloc]initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
    tableView.frame = CGRectMake(0,0,320,550);
    tableView.delegate = self;
    tableView.dataSource = self;
    tableView.scrollEnabled = NO;
    [self.view addSubview:tableView];

    // カスタムサイズのピッカー作成
    [self CreateCustomPickerView];

    // エラーメッセージ表記
    m_plblErrMsg = [[UILabel alloc]initWithFrame:CGRectMake(30, 0, 250, 40)];
    m_plblErrMsg.font = [UIFont systemFontOfSize:14];
    m_plblErrMsg.text = @"";
    m_plblErrMsg.backgroundColor = [UIColor clearColor];
    m_plblErrMsg.textColor = [UIColor redColor];
    m_plblErrMsg.minimumScaleFactor = 10 / m_plblErrMsg.font.pointSize;
    m_plblErrMsg.adjustsFontSizeToFitWidth = YES;
    m_plblErrMsg.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin;

    [tableView addSubview:m_plblErrMsg];
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
    // iPad用
}

// ピッカー作成
- (void)CreateCustomPickerView
{
    pCustomPicker = [[UIPickerView alloc] init];

	pCustomPicker.delegate = self;
	pCustomPicker.dataSource = self;

    //ピッカーのサイズを設定
    if (isIOS8Later) {
        [pCustomPicker setFrame:CGRectMake(0, 190, 320, 216)];
    } else {
        [pCustomPicker setFrame:CGRectMake(0, 150, 320, 250)];
    }

    // 選択時のインジケータを表示
	[pCustomPicker setShowsSelectionIndicator:TRUE];

    // 現在の選択項目を初期表示とする
    if(m_bInch)
    {
        NSInteger nSelRowTen = (m_nSelRow / 10);
        // 10の位
        [pCustomPicker selectRow:nSelRowTen inComponent:0 animated:NO];
        // 1の位 ※0の場合は1を設定
        NSInteger nSelRowOne = (m_nSelRow == 0) ? 1 : (m_nSelRow - nSelRowTen * 10);
        [pCustomPicker selectRow:nSelRowOne inComponent:1 animated:NO];
        [pCustomPicker selectRow:m_nSelRowInch inComponent:2 animated:NO];
    }
    else
    {
        NSInteger nSelRowHundred = (m_nSelRow / 100);
        // 100の位
        [pCustomPicker selectRow:nSelRowHundred inComponent:0 animated:NO];
        NSInteger nSelRowTen = (m_nSelRow < 26) ? 2 : ((m_nSelRow - nSelRowHundred * 100) / 10);
        // 10の位
        [pCustomPicker selectRow:nSelRowTen inComponent:1 animated:NO];
        // 1の位
        NSInteger nSelRowOne = (m_nSelRow < 26) ? 5 : (m_nSelRow - nSelRowHundred * 100 - nSelRowTen * 10);
        [pCustomPicker selectRow:nSelRowOne inComponent:2 animated:NO];

        m_nSelRow = nSelRowHundred * 100 + nSelRowTen * 10 + nSelRowOne;
    }

    [self.view addSubview:pCustomPicker];

}

// 列数返却
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 3;
}

// 行数返却
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    if(m_bInch)
    {
        if(0 == component)
        {
            // 10の位は0から1
            return 2;
        }
        if(2 == component)
        {
            // インチの位はインチの数
            return [m_parrInchPickerRow count];
        }
    }else
    {
        if(0 == component)
        {
            if(m_bSelectedV)
            {
                // 縦の場合は100の位は0から2
                return 3;
            }
            else
            {
                // 横の場合は100の位は0から4
                return 5;
            }
        }
    }
    return [m_parrPickerRow count];
}

// ピッカーに表示する文字列を返却
- (NSString*)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    // インチの場合は文字列を返す
    if(m_bInch)
    {
        if(2 == component)
        {
            return [m_parrInchPickerRow objectAtIndex:row];
        }
    }
    // 行インデックス番号を返す
    return [m_parrPickerRow objectAtIndex:row];
}

// ピッカーの値選択時の動作
- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{

    m_plblErrMsg.text = @"";

    if(m_bInch)
    {
        NSInteger nRowTen = [pCustomPicker selectedRowInComponent:0];
        NSInteger nRowOne = [pCustomPicker selectedRowInComponent:1];
        NSInteger nRowInch = [pCustomPicker selectedRowInComponent:2];

        if(!m_bSelectedV)
        {

            m_nSelRow = nRowTen * 10 + nRowOne;
            m_nSelRowInch = nRowInch;

            if(m_nSelRow > 17 || (m_nSelRow == 17 && m_nSelRowInch > 0)|| (m_nSelRow == 0))
            {
                m_plblErrMsg.text = MSG_REMOTESCAN_WIDTH_INCH;
            }

            if(0 == m_nSelRow)
            {
                m_nSelRow = 1;
            }
            NSInteger nSelRowTen = (m_nSelRow / 10);
            // 1の位 ※18以上の場合は1の位は7を設定
            NSInteger nSelRowOne = (m_nSelRow > 17) ? 7 : (m_nSelRow - nSelRowTen * 10);
            [pickerView selectRow:nSelRowOne inComponent:1 animated:YES];

            // インチの位 *17以上の場合、0なら-に設定
            NSInteger nSelRowInch = (m_nSelRow > 16 || (nRowTen == 0 && nRowOne == 0)) ? 0 : m_nSelRowInch;
            [pickerView selectRow:nSelRowInch inComponent:2 animated:YES];

            m_nSelRow = nSelRowTen * 10 + nSelRowOne;
            m_nSelRowInch = nSelRowInch;

            NSString* strSelRow = [NSString stringWithFormat:@"%ld",(long)m_nSelRow];
            m_pLblHighInch_H.text = strSelRow;
            m_pLblLowInch_H.text = [m_parrInchPickerRow objectAtIndex:m_nSelRowInch];


        }
        else
        {
            m_nSelRow2 = nRowTen * 10 + nRowOne;
            m_nSelRowInch2 = nRowInch;

            if(m_nSelRow2 > 11 || (m_nSelRow2 == 11 && m_nSelRowInch2 > 5) || m_nSelRow2 == 0)
            {
                m_plblErrMsg.text = MSG_REMOTESCAN_HEIGHT_INCH;
            }

            if(0 == m_nSelRow2)
            {
                m_nSelRow2 = 1;
            }
            NSInteger nSelRowTen = (m_nSelRow2 / 10);
            // 1の位 ※12以上の場合は1の位は1を設定
            NSInteger nSelRowOne = (m_nSelRow2 > 11) ? 1 : (m_nSelRow2 - nSelRowTen * 10);
            [pickerView selectRow:nSelRowOne inComponent:1 animated:YES];

            // インチの位 *12以上、11の場合の最大値は5/8に設定
            NSInteger nSelRowInch2 = ((m_nSelRow2 > 11) || (m_nSelRow2 == 11 && m_nSelRowInch2 > 5) ) ? 5 : (nRowTen == 0 && nRowOne == 0) ? 0 :m_nSelRowInch2;
            [pickerView selectRow:nSelRowInch2 inComponent:2 animated:YES];

            m_nSelRow2 = nSelRowTen * 10 + nSelRowOne;
            m_nSelRowInch2 = nSelRowInch2;

            NSString* strSelRow = [NSString stringWithFormat:@"%ld ",(long)m_nSelRow2];
            m_pLblHighInch_V.text = strSelRow;
            m_pLblLowInch_V.text = [m_parrInchPickerRow objectAtIndex:m_nSelRowInch2];
        }
    }else
    {
        NSInteger nRowHundred = [pCustomPicker selectedRowInComponent:0];
        NSInteger nRowTen = [pCustomPicker selectedRowInComponent:1];
        NSInteger nRowOne = [pCustomPicker selectedRowInComponent:2];

        if(!m_bSelectedV)
        {
            m_nSelRow =  nRowHundred * 100 + nRowTen * 10 + nRowOne;

            if(m_nSelRow > 432 || (25 > m_nSelRow))
            {
                m_plblErrMsg.text = MSG_REMOTESCAN_WIDTH_MILLIMETER;
            }

            if(25 > m_nSelRow)
            {
                m_nSelRow = 25;
            }
            NSInteger nSelRowHundred = (m_nSelRow > 432) ? 4 : (m_nSelRow / 100);
            NSInteger nSelRowTen = (m_nSelRow > 432) ? 3 : ((m_nSelRow - nSelRowHundred * 100) / 10);
            NSInteger nSelRowOne = (m_nSelRow > 432) ? 2 : (m_nSelRow -nSelRowHundred * 100 - nSelRowTen * 10);

            // 100の位 ※432以上の場合は100の位は4を設定
            [pickerView selectRow:nSelRowHundred inComponent:0 animated:YES];
            // 10の位 ※432以上の場合は10の位は3を設定
            [pickerView selectRow:nSelRowTen inComponent:1 animated:YES];
            // 1の位 ※432以上の場合は1の位は2を設定
            [pickerView selectRow:nSelRowOne inComponent:2 animated:YES];

            m_nSelRow = nSelRowHundred * 100 + nSelRowTen * 10 + nSelRowOne;

            NSString* strSelRow = [NSString stringWithFormat:@"%ld",(long)m_nSelRow];
            m_pLblHighInch_H.text = strSelRow;
        }
        else
        {
            m_nSelRow2 = nRowHundred * 100 + nRowTen * 10 + nRowOne;

            if(m_nSelRow2 > 297 || (25 > m_nSelRow2))
            {
                m_plblErrMsg.text = MSG_REMOTESCAN_HEIGHT_MILLIMETER;
            }

            if(25 > m_nSelRow2)
            {
                m_nSelRow2 = 25;
            }
            NSInteger nSelRowHundred = (m_nSelRow2 > 297) ? 2 : (m_nSelRow2 / 100);
            NSInteger nSelRowTen = (m_nSelRow2 > 297) ? 9 : ((m_nSelRow2 - nSelRowHundred * 100) / 10);
            NSInteger nSelRowOne = (m_nSelRow2 > 297) ? 7 : (m_nSelRow2 -nSelRowHundred * 100 - nSelRowTen * 10);

            // 100の位 ※297以上の場合は100の位は2を設定
            [pickerView selectRow:nSelRowHundred inComponent:0 animated:YES];
            // 10の位 ※297以上の場合は10の位は9を設定
            [pickerView selectRow:nSelRowTen inComponent:1 animated:YES];
            // 1の位 ※297以上の場合は1の位は7を設定
            [pickerView selectRow:nSelRowOne inComponent:2 animated:YES];


            m_nSelRow2 = nSelRowHundred * 100 + nSelRowTen * 10 + nSelRowOne;

            NSString* strSelRow = [NSString stringWithFormat:@"%ld",(long)m_nSelRow2];
            m_pLblHighInch_V.text = strSelRow;
        }
    }
}

- (IBAction)OnDecideButton:(id)sender
{
    NSString* strSelRow = [NSString stringWithFormat:@"%ld",(long)m_nSelRow];
    NSString* strSelRow2 = [NSString stringWithFormat:@"%ld",(long)m_nSelRowInch];
    NSString* strSelRow3 = [NSString stringWithFormat:@"%ld",(long)m_nSelRow2];
    NSString* strSelRow4 = [NSString stringWithFormat:@"%ld",(long)m_nSelRowInch2];
    NSString* strSelValue;
    NSString* strSelValue2;
    NSString* strSelValue3;
    NSString* strSelValue4;

    strSelValue = strSelRow;
    strSelValue2 = [m_parrInchPickerRow objectAtIndex:m_nSelRowInch];
    strSelValue3 = strSelRow3;
    strSelValue4 = [m_parrInchPickerRow objectAtIndex:m_nSelRowInch2];
    //通知処理
    NSArray *dicObjects;
    NSArray *keys;

    if(m_bInch)
    {
        dicObjects = [NSArray arrayWithObjects:strSelRow, strSelValue, strSelRow2, strSelValue2, strSelRow3, strSelValue3, strSelRow4, strSelValue4 ,nil];
        keys = [NSArray arrayWithObjects:@"ROW", @"VALUE" ,@"ROW2" ,@"VALUE2", @"ROW3", @"VALUE3", @"ROW4", @"VALUE4", nil];
    }
    else
    {
        dicObjects = [NSArray arrayWithObjects:strSelRow, strSelValue, strSelRow3, strSelValue3,nil];
        keys = [NSArray arrayWithObjects:@"ROW", @"VALUE", @"ROW3", @"VALUE3", nil];

    }

    NSDictionary *dic = [NSDictionary dictionaryWithObjects:dicObjects forKeys:keys];
    NSNotification *notification = [NSNotification notificationWithName:@"Picker Value" object:self userInfo:dic];
    [[NSNotificationCenter defaultCenter] postNotification:notification];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
	return YES;
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

    static NSString *CellIdentifier = @"Cell";

    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];

    if(cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        cell.textLabel.font = [UIFont systemFontOfSize:14];

    }

    // 表示項目の設定
    switch (indexPath.row)
    {
        case 0: {
            cell.textLabel.text = @"";

            UILabel* m_plblWidth = [[UILabel alloc]initWithFrame:CGRectMake(cell.contentView.frame.size.width * 0.1 + 15, 0, 100, cell.contentView.frame.size.height)];
            m_plblWidth.font = [UIFont systemFontOfSize:14];
            m_plblWidth.text = S_CUSTOMSIZE_REGISTER_WIDTH;
            //            m_pLblHighInch_H.textColor = [UIColor whiteColor];
            m_plblWidth.backgroundColor = [UIColor clearColor];
            m_plblWidth.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin;
            [cell.contentView addSubview:m_plblWidth];

            // サイズ（上位）表記
            m_pLblHighInch_H = [[UILabel alloc]initWithFrame:CGRectMake(cell.contentView.frame.size.width * 0.5, 0, 60, cell.contentView.frame.size.height)];
            m_pLblHighInch_H.font = [UIFont systemFontOfSize:14];
            m_pLblHighInch_H.text = [NSString stringWithFormat:@"%ld",(long)m_nSelRow];
//            m_pLblHighInch_H.textColor = [UIColor whiteColor];
            m_pLblHighInch_H.backgroundColor = [UIColor clearColor];
            m_pLblHighInch_H.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin;
            [cell.contentView addSubview:m_pLblHighInch_H];
            if(m_bInch)
            {
                m_pLblLowInch_H = [[UILabel alloc]initWithFrame:CGRectMake(cell.contentView.frame.size.width * 0.5 + 50, 0, 60, cell.contentView.frame.size.height)];
                m_pLblLowInch_H.font = [UIFont systemFontOfSize:14];
                m_pLblLowInch_H.text = [NSString stringWithFormat:@"%@",[m_parrInchPickerRow objectAtIndex:m_nSelRowInch]];
//                m_pLblLowInch_H.textColor = [UIColor whiteColor];
                m_pLblLowInch_H.backgroundColor = [UIColor clearColor];
                m_pLblLowInch_H.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin;
                [cell.contentView addSubview:m_pLblLowInch_H];
            }

            UILabel* m_pLblUnit = [[UILabel alloc]initWithFrame:CGRectMake(cell.contentView.frame.size.width * 0.5 + 100, 0, 60, cell.contentView.frame.size.height)];
            m_pLblUnit.font = [UIFont systemFontOfSize:14];
            m_pLblUnit.backgroundColor = [UIColor clearColor];
            m_pLblUnit.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin;
            if(m_bInch)
            {
                m_pLblUnit.text = S_CUSTOMSIZE_REGISTER_INCH;
            }
            else
            {
                m_pLblUnit.text = S_CUSTOMSIZE_REGISTER_MILLIMETER;
            }
            [cell.contentView addSubview:m_pLblUnit];

            [tableView selectRowAtIndexPath:indexPath animated:NO scrollPosition:UITableViewScrollPositionNone];

            break;
        }
        case 1: {
            cell.textLabel.text = @"";
            UILabel* m_plblHeight = [[UILabel alloc]initWithFrame:CGRectMake(cell.contentView.frame.size.width * 0.1 + 15, 0, 100, cell.contentView.frame.size.height)];
            m_plblHeight.font = [UIFont systemFontOfSize:14];
            m_plblHeight.text = S_CUSTOMSIZE_REGISTER_HEIGHT;
            //            m_pLblHighInch_H.textColor = [UIColor whiteColor];
            m_plblHeight.backgroundColor = [UIColor clearColor];
            m_plblHeight.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin;
            [cell.contentView addSubview:m_plblHeight];

            // サイズ（上位）表記
            m_pLblHighInch_V = [[UILabel alloc]initWithFrame:CGRectMake(cell.contentView.frame.size.width * 0.5, 0, 60, cell.contentView.frame.size.height)];
            m_pLblHighInch_V.font = [UIFont systemFontOfSize:14];
            m_pLblHighInch_V.text = [NSString stringWithFormat:@"%ld",(long)m_nSelRow2];
            m_pLblHighInch_V.backgroundColor = [UIColor clearColor];
            m_pLblHighInch_V.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin;
            [cell.contentView addSubview:m_pLblHighInch_V];

            if(m_bInch)
            {
                m_pLblLowInch_V = [[UILabel alloc]initWithFrame:CGRectMake(cell.contentView.frame.size.width * 0.5 + 50, 0, 60, cell.contentView.frame.size.height)];
                m_pLblLowInch_V.font = [UIFont systemFontOfSize:14];
                m_pLblLowInch_V.text = [NSString stringWithFormat:@"%@",[m_parrInchPickerRow objectAtIndex:m_nSelRowInch2]];
                m_pLblLowInch_V.backgroundColor = [UIColor clearColor];
                m_pLblLowInch_V.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin;
                [cell.contentView addSubview:m_pLblLowInch_V];
            }

            UILabel* m_pLblUnit2 = [[UILabel alloc]initWithFrame:CGRectMake(cell.contentView.frame.size.width * 0.5 + 100, 0, 60, cell.contentView.frame.size.height)];
            m_pLblUnit2.font = [UIFont systemFontOfSize:14];
            m_pLblUnit2.backgroundColor = [UIColor clearColor];
            m_pLblUnit2.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin;
            if(m_bInch)
            {
                m_pLblUnit2.text = S_CUSTOMSIZE_REGISTER_INCH;
            }
            else
            {
                m_pLblUnit2.text = S_CUSTOMSIZE_REGISTER_MILLIMETER;
            }
            [cell.contentView addSubview:m_pLblUnit2];

            break;
        }
        default:
            break;
    }

    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger nSelRowHundred;
    NSInteger nSelRowTen;
    NSInteger nSelRowOne;

    m_plblErrMsg.text = @"";

    switch (indexPath.row) {
        case 0:
//            m_pLblHighInch_H.textColor = [UIColor whiteColor];
//            m_pLblLowInch_H.textColor = [UIColor whiteColor];
//            m_pLblHighInch_V.textColor = [UIColor blackColor];
//            m_pLblLowInch_V.textColor = [UIColor blackColor];
            m_bSelectedV = NO;

            if(m_bInch)
            {
//
                nSelRowTen = (m_nSelRow / 10);
                // 10の位
                [pCustomPicker selectRow:nSelRowTen inComponent:0 animated:NO];
                // 1の位 ※0の場合は1を設定
                nSelRowOne = (m_nSelRow == 0) ? 1 : (m_nSelRow - nSelRowTen * 10);
                [pCustomPicker selectRow:nSelRowOne inComponent:1 animated:NO];
                [pCustomPicker selectRow:m_nSelRowInch inComponent:2 animated:NO];
            }
            else
            {
                // ピッカーに表示する文字列を更新する
                [pCustomPicker reloadAllComponents];

                // 100の位
                nSelRowHundred = (m_nSelRow / 100);
                [pCustomPicker selectRow:nSelRowHundred inComponent:0 animated:NO];
                // 10の位
                if(m_nSelRow > 432)
                {
                    nSelRowTen = 3;
                }
                else
                {
                    nSelRowTen = (m_nSelRow < 25) ? 2 : ((m_nSelRow - nSelRowHundred * 100) / 10);
                }
                [pCustomPicker selectRow:nSelRowTen inComponent:1 animated:NO];
                // 1の位 ※0の場合は1を設定
                if(m_nSelRow > 432)
                {
                    nSelRowOne = 2;
                }
                else
                {
                    nSelRowOne = (m_nSelRow < 25) ? 5 : (m_nSelRow - nSelRowHundred * 100 - nSelRowTen * 10);
                }
                [pCustomPicker selectRow:nSelRowOne inComponent:2 animated:NO];

            }
            break;
        case 1:
//            m_pLblHighInch_V.textColor = [UIColor whiteColor];
//            m_pLblLowInch_V.textColor = [UIColor whiteColor];
//            m_pLblHighInch_H.textColor = [UIColor blackColor];
//            m_pLblLowInch_H.textColor = [UIColor blackColor];
            m_bSelectedV = YES;

            if(m_bInch)
            {
                nSelRowTen = (m_nSelRow2 / 10);
                // 10の位
                [pCustomPicker selectRow:nSelRowTen inComponent:0 animated:NO];
                // 1の位 ※0の場合は1を設定
                nSelRowOne = (m_nSelRow2 == 0) ? 1 : (m_nSelRow2 - nSelRowTen * 10);
                [pCustomPicker selectRow:nSelRowOne inComponent:1 animated:NO];
                [pCustomPicker selectRow:m_nSelRowInch2 inComponent:2 animated:NO];
            }
            else
            {
                // ピッカーに表示する文字列を更新する
                [pCustomPicker reloadAllComponents];

                // 100の位
                nSelRowHundred = (m_nSelRow2 / 100);
                [pCustomPicker selectRow:nSelRowHundred inComponent:0 animated:NO];
                // 10の位
                if(297 < m_nSelRow2)
                {
                    nSelRowTen = 9;
                }
                else
                {
                    nSelRowTen = (m_nSelRow2 < 25) ? 2 : (m_nSelRow2 - nSelRowHundred * 100) / 10;
                }
                [pCustomPicker selectRow:nSelRowTen inComponent:1 animated:NO];
                // 1の位 ※0の場合は1を設定
                if(297 < m_nSelRow2)
                {
                    nSelRowOne = 7;
                }
                else
                {
                    nSelRowOne = (m_nSelRow2 < 25) ? 5 : (m_nSelRow2 - nSelRowHundred * 100 - nSelRowTen * 10);
                }
                [pCustomPicker selectRow:nSelRowOne inComponent:2 animated:NO];
            }
            break;
        default:
            break;
    }

}

// セクションのタイトルを決定する
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    // 空白を入れてセルの高さを調節
    return @" ";
}

-(CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component
{
    return 50;
}


@end
