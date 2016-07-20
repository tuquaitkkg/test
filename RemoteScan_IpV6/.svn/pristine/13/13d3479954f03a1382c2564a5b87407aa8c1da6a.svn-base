
#import "RSS_BothOrOneSideViewController.h"
#import "RemoteScanBeforePictViewController.h"

@interface RSS_BothOrOneSideViewController ()

@end

@implementation RSS_BothOrOneSideViewController
@synthesize parentVCDelegate;
@synthesize nSelectSideTypeIndexRow;


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
    }
    return self;
}

-(id)initWithDuplexDataArray:(NSArray*)array delegate:(RemoteScanBeforePictViewController *)delegate
{
    self = [super initWithNibName:@"RSS_BothOrOneSideViewController" bundle:nil];
    if(self){
        self.parentVCDelegate = delegate;

        sideTypeList = [[NSArray alloc]initWithArray:array];
        self.nSelectSideTypeIndexRow = [parentVCDelegate.rssViewData.duplexData getSelectIndex];

    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    // セルのラインを表示する
    bothOrOneSideTableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    
    // スクロールの必要がないのでNO
    //bothOrOneSideTableView.scrollEnabled = NO;

    // タイトル設定
    CGRect frame = CGRectMake(0, 0, 400, 44);
    UILabel* lblTitle = [[UILabel alloc]initWithFrame:frame];
    lblTitle.backgroundColor = [UIColor clearColor];
    lblTitle.textColor = NAVIGATION_TITLE_COLOR;
    lblTitle.font = [UIFont boldSystemFontOfSize:20];
    lblTitle.textAlignment = NSTextAlignmentCenter;
    lblTitle.text = S_TITLE_BOTH;
    lblTitle.adjustsFontSizeToFitWidth = YES;
    self.navigationItem.titleView = lblTitle;
    //[self.navigationItem setTitle: S_TITLE_BOTH];
    
    // 保存ボタンの設定
    UIBarButtonItem* btnSave = [[UIBarButtonItem alloc] initWithTitle:S_BUTTON_SAVEVAL style:UIBarButtonItemStyleDone target:self action:@selector(dosave:)];
    
    self.navigationItem.rightBarButtonItem = btnSave;
    
    // 画像の初期化
    selectSideTypeImage.contentMode = UIViewContentModeScaleAspectFit;
    NSString* imgName = [parentVCDelegate.rssViewData.duplexData getSelectValueImageName];
    selectSideTypeImage.image = [UIImage imageNamed:imgName];
}

- (void)viewDidUnload
{
    sideTypeList = nil;

    bothOrOneSideTableView = nil;
    selectSideTypeImage = nil;
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
    return [sideTypeList count];
}

// テーブルセルの作成
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{

    static NSString *CellIdentifier = @"Cell";

    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    UILabel* titleLbl = nil;

    if(cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
//        cell.textLabel.font = [UIFont systemFontOfSize:14];
        
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
        
    }else{
        titleLbl = (UILabel*)[cell.contentView viewWithTag:3];
    }

    // セルタイトル
    titleLbl.text = [sideTypeList objectAtIndex:indexPath.row];
    // 選択状態
    cell.accessoryType = (indexPath.row == nSelectSideTypeIndexRow ? UITableViewCellAccessoryCheckmark:UITableViewCellAccessoryNone);

    return cell;
}

// 各セルの高さを設定
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return N_HEIGHT_SEL_DEFAULT;
}

// セルを選択したときの処理
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // ハイライトOFF
    [tableView deselectRowAtIndexPath:indexPath animated:YES];

    // 選択番号の更新
    self.nSelectSideTypeIndexRow = indexPath.row;
//    保存ボタンに処理を移動
//    [parentVCDelegate.rssViewData.duplexData setSelectValue:indexPath.row];
    // チェックの設定
    for(int i = 0; i < [sideTypeList count]; i++){
        UITableViewCell * cell = [tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:i inSection:indexPath.section]];
        int accessory = UITableViewCellAccessoryNone;
        if(i == indexPath.row){
            accessory = UITableViewCellAccessoryCheckmark;
        }

        [cell setAccessoryType:accessory];
    }

    // 画像更新
    NSString* imgName = [parentVCDelegate.rssViewData.duplexData getSelectValueImageName:(int)self.nSelectSideTypeIndexRow];
    selectSideTypeImage.image = [UIImage imageNamed:imgName];
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
    // 選択番号の更新
    [parentVCDelegate.rssViewData.duplexData setSelectValue:self.nSelectSideTypeIndexRow ];
    
    // 設定の更新
    [parentVCDelegate updateSetting];
    
    // 前画面に戻る
    [self.navigationController popViewControllerAnimated:YES];    
    
}
@end
