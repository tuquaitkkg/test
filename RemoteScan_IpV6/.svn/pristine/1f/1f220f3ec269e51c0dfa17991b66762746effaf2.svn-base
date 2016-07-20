
#import "RSS_ColorModeViewController.h"
#import "RemoteScanBeforePictViewController.h"

@interface RSS_ColorModeViewController ()

@end

@implementation RSS_ColorModeViewController
@synthesize parentVCDelegate;
@synthesize nSelectedIndexRow;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(id)initWithColorModeArray:(NSArray*)array delegate:(RemoteScanBeforePictViewController *)delegate
{
    self = [super initWithNibName:@"RSS_ColorModeViewController" bundle:nil];
    if(self){
        self.parentVCDelegate = delegate;

        // 原稿サイズが長尺の場合は白黒2値のみ選択可能とする
        if([parentVCDelegate.rssViewData.originalSize isLong])
        {
            colorModeArray = [[NSArray alloc]initWithObjects:[parentVCDelegate.rssViewData.colorMode getSpecifiedValueName:@"monochrome"], nil];            
            // 選択セルの検索
            self.nSelectedIndexRow = 0;
        }else
        {
            colorModeArray = [[NSArray alloc]initWithArray:array];            
            // 選択セルの検索
            self.nSelectedIndexRow = [parentVCDelegate.rssViewData.colorMode getSelectIndex];

        }
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    // セルのラインを表示する
    colorModeTableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    
    // スクロールの必要がないのでNO
    //colorModeTableView.scrollEnabled = NO;

    // タイトル設定
    CGRect frame = CGRectMake(0, 0, 400, 44);
    UILabel* lblTitle = [[UILabel alloc]initWithFrame:frame];
    lblTitle.backgroundColor = [UIColor clearColor];
    lblTitle.textColor = NAVIGATION_TITLE_COLOR;
    lblTitle.font = [UIFont boldSystemFontOfSize:20];
    lblTitle.textAlignment = NSTextAlignmentCenter;
    lblTitle.text = S_TITLE_COLORMODE;
    lblTitle.adjustsFontSizeToFitWidth = YES;
    self.navigationItem.titleView = lblTitle;
    //self.navigationItem.title = S_TITLE_COLORMODE;
    
    // 保存ボタンの設定
    UIBarButtonItem* btnSave = [[UIBarButtonItem alloc] initWithTitle:S_BUTTON_SAVEVAL style:UIBarButtonItemStyleDone target:self action:@selector(dosave:)];
    
    self.navigationItem.rightBarButtonItem = btnSave;
    
}

- (void)viewDidUnload
{
    colorModeTableView = nil;
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
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


#pragma mark - UITableViewDelegate
// セクション数
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

// セルの数
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [colorModeArray count];
}

// テーブルセルの作成
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{

    static NSString *CellIdentifier = @"Cell";

    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];

    UILabel* titleLbl = nil;
    if(cell == nil){
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        
        // タイトルラベルの作成
        CGRect titleLblFrame = cell.contentView.frame;
        
        if([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0)
        {
            // iOS7以降
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
                
    }else{
        titleLbl = (UILabel*)[cell.contentView viewWithTag:3];
    }

    DLog(@"%ld, %@", (long)indexPath.row, [colorModeArray objectAtIndex:indexPath.row]);
    // セルタイトル
    titleLbl.text = [colorModeArray objectAtIndex:indexPath.row];
    // 選択状態
    cell.accessoryType = (indexPath.row == nSelectedIndexRow ? UITableViewCellAccessoryCheckmark:UITableViewCellAccessoryNone);

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

    // 選択番号の更新
    self.nSelectedIndexRow = indexPath.row;

    // チェックの設定
    for(int i = 0; i < [colorModeArray count]; i++){
        UITableViewCell * cell = [tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:i inSection:indexPath.section]];
        int accessory = UITableViewCellAccessoryNone;
        if(i == indexPath.row){
            accessory = UITableViewCellAccessoryCheckmark;
        }

        [cell setAccessoryType:accessory];
    }

//保存ボタンに移動
//    // 原稿サイズが長尺以外の場合のみ更新する
//    if(![[parentVCDelegate.rssViewData.originalSize getSelectValue] isEqualToString:@"long"])
//    {   
//        // 設定の更新
//    
//        [parentVCDelegate.rssViewData.colorMode setSelectValue:indexPath.row];
//        [parentVCDelegate updateSetting];
//    }
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

#pragma mark -OnButtonClick
//
// 保存ボタン処理
//
-(IBAction)dosave:(id)sender
{
    // 原稿サイズが長尺以外の場合のみ更新する
    if(![parentVCDelegate.rssViewData.originalSize isLong])
    {   
        // 設定の更新
        
        [parentVCDelegate.rssViewData.colorMode setSelectValue:self.nSelectedIndexRow ];
        [parentVCDelegate updateSetting];
    }
    
    // 前画面に戻る
    [self.navigationController popViewControllerAnimated:YES];    
    
}

@end
