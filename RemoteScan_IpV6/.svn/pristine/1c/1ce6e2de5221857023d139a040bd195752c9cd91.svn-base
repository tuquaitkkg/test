
#import "AdvancedSearchViewController.h"
#import "RootViewController_iPad.h"
#import "SharpScanPrintAppDelegate.h"
#import "Define.h"
#import "SearchResultViewController_iPad.h"
#import "SearchResultViewController.h"
#import "AdvancedSearchResultViewController_iPad.h"
#import "AdvancedSearchResultViewController.h"


@interface AdvancedSearchViewController ()

@end

@implementation AdvancedSearchViewController

@synthesize bSubFolder;                         // 検索範囲(サブフォルダーを含む)
@synthesize bFillterFolder;                     // 検索対象(フォルダー)
@synthesize bFillterPdf;                        // 検索対象(PDF)
@synthesize bFillterTiff;                       // 検索対象(TIFF)
@synthesize bFillterImage;                      // 検索対象(JPEG,PNG)
@synthesize bFillterOffice;                     // 検索対象(OFFICE)
@synthesize sessionViewController;              // 検索キーを共有

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
 
    // セルのラインを表示する
    advancedSearchTableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;

    // ナビゲーションバー
    // タイトル設定
    CGRect frame = CGRectMake(0, 0, 400, 44);
    UILabel* lblTitle = [[UILabel alloc]initWithFrame:frame];
    lblTitle.backgroundColor = [UIColor clearColor];
    lblTitle.textColor = NAVIGATION_TITLE_COLOR;
    lblTitle.font = [UIFont boldSystemFontOfSize:14];
    lblTitle.textAlignment = NSTextAlignmentCenter;
    lblTitle.text = S_TITLE_ADVANCEDSEARCH;
    
    self.navigationItem.titleView = lblTitle;
    
    // ナビゲーションバー左側にキャンセルボタンを設定
    UIBarButtonItem* btnClose = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel
                                                                              target:self 
                                                                              action:@selector(cancelAction:)];
    self.navigationItem.leftBarButtonItem = btnClose; 
    
    
    // 検索ボタン追加
    UIBarButtonItem* btnSearch = [[UIBarButtonItem alloc] initWithTitle:S_BUTTON_SEARCH style:UIBarButtonItemStyleDone target:self action:@selector(searchAction:)];
    
    self.navigationItem.rightBarButtonItem = btnSearch;
        
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
}


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return YES;
}

#pragma mark - UITableViewDelegate
// セクション数
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

// セルの数
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(section == 0)
    {
        return 1;
    }else
    {
        return 5;
    }
}

//
// 各セクションのタイトルを決定する
//
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    NSString *title = @"";
    switch (section) {
        case 0:
            title = S_LABEL_SEARCH_SCOPE;
            break;
        case 1:
        {
            title = S_LABEL_SEARCH_TARGET;
            break;
        }
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

// テーブルセルの作成
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *CellIdentifier = [NSString stringWithFormat:@"Cell%02ld%02ld", (long)indexPath.section, (long)indexPath.row];
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    UILabel* titleLbl = nil;

    if(cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.textLabel.font = [UIFont systemFontOfSize:14];
        
        // セルタイトル
        if(indexPath.section == 0)
        {
            switch (indexPath.row) {
                case 0:
                {
                    swSubFolderCell = [[SwitchDataCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
                    swSubFolderCell.nameLabelCell.text = S_LABEL_INCLUDE_SUBFOLDERS;
                    swSubFolderCell.switchField.on = (bSubFolder) ? NO : YES;
                    cell = swSubFolderCell;  
                }
                    break;
                
                default:
                    break;
            }
        }else
        {
            // タイトルラベルの作成
            CGRect titleLblFrame = cell.contentView.frame;
            
            if([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0 ||
               UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
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

            switch (indexPath.row) {
                case 0:
                {
                    titleLbl.text = S_LABEL_FILTER_FOLDER;
                    bFillterFolder ? [cell setAccessoryType:UITableViewCellAccessoryNone] : [cell setAccessoryType:UITableViewCellAccessoryCheckmark];
                    break;
                }
                case 1:
                {
                    titleLbl.text = S_LABEL_FILTER_PDF;
                    bFillterPdf ? [cell setAccessoryType:UITableViewCellAccessoryNone] : [cell setAccessoryType:UITableViewCellAccessoryCheckmark];
                    break;
                }
                case 2:
                {
                    titleLbl.text = S_LABEL_FILTER_TIFF;
                    bFillterTiff ? [cell setAccessoryType:UITableViewCellAccessoryNone] : [cell setAccessoryType:UITableViewCellAccessoryCheckmark];
                    break;
                }
                case 3:
                {
                    titleLbl.text = S_LABEL_FILTER_IMAGE;
                    bFillterImage ? [cell setAccessoryType:UITableViewCellAccessoryNone] : [cell setAccessoryType:UITableViewCellAccessoryCheckmark];
                    break;
                }
                case 4:
                {
                    titleLbl.text = S_LABEL_FILTER_OFFICE;
                    bFillterOffice ? [cell setAccessoryType:UITableViewCellAccessoryNone] : [cell setAccessoryType:UITableViewCellAccessoryCheckmark];
                    break;
                }
                default:
                    break;
            }
        }
    }
    
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

    if(indexPath.section == 1)
    {
        // チェックの設定
        UITableViewCell * cell = [tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:indexPath.row inSection:indexPath.section]];

        int accessory = UITableViewCellAccessoryNone;
        if(cell.accessoryType == accessory){
            accessory = UITableViewCellAccessoryCheckmark;
            
            switch (indexPath.row) {
                case 0:
                    bFillterFolder = NO;
                    break;
                case 1:
                    bFillterPdf = NO;
                    break;
                case 2:
                    bFillterTiff = NO;
                    break;
                case 3:
                    bFillterImage = NO;
                    break;
                case 4:
                    bFillterOffice = NO;
                    break;
                default:
                    break;
            }
        }else
        {
            switch (indexPath.row) {
                case 0:
                    bFillterFolder = YES;
                    break;
                case 1:
                    bFillterPdf = YES;
                    break;
                case 2:
                    bFillterTiff = YES;
                    break;
                case 3:
                    bFillterImage = YES;
                    break;
                case 4:
                    bFillterOffice = YES;
                    break;
                default:
                    break;
            }
            
        }
        [cell setAccessoryType:accessory];
    }
}

// ヘッダーの高さを設定
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return TABLE_HEADER_HEIGHT_2;
}

// フッターの高さを設定
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return TABLE_FOOTER_HEIGHT_1;
}

#pragma mark - UIButtonControl Action
- (void)cancelAction:(id)sender
{

    [self dismissViewControllerAnimated:YES completion:nil];
    // iPad用
    if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
    {
//        SharpScanPrintAppDelegate* pAppDelegate = (SharpScanPrintAppDelegate*)[[UIApplication sharedApplication] delegate];
//        UINavigationController* pRootNavController = [pAppDelegate.splitViewController.viewControllers objectAtIndex:0];
//        RootViewController_iPad* rootViewController_ipad = (RootViewController_iPad*)[pRootNavController.viewControllers objectAtIndex:0];
//        [rootViewController_ipad OnHelpClose];
    }
    else
    {
        // iPad用
        // Modal表示のため、呼び出し元で閉じる処理を行う
//        SharpScanPrintAppDelegate* appDelegate = (SharpScanPrintAppDelegate*)[[UIApplication sharedApplication] delegate];
//        ArrengeSelectFileViewController* pArrengeSelectFileViewController = (ArrengeSelectFileViewController*)appDelegate.navigationController.topViewController;
//        
//        [pArrengeSelectFileViewController OnClose];
    }
}

- (void)searchAction:(id)sender
{
    // 複数印刷対応
    if (self.fromSelectFileVC) {
        SearchResultViewController *vc = (SearchResultViewController *)self.sessionViewController;
        vc.bSubFolder = !swSubFolderCell.switchField.on;
        vc.bFillterFolder = bFillterFolder;
        vc.bFillterPdf = bFillterPdf;
        vc.bFillterTiff = bFillterTiff;
        vc.bFillterImage = bFillterImage;
        vc.bFillterOffice = bFillterOffice;
        [vc advancedSearchRightBarButtonClicked];
        return;
    }
    
    // モーダルを閉じて検索結果画面から詳細検索結果画面に遷移する。
    // iPad用
    if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
    {        
        SharpScanPrintAppDelegate* pAppDelegate = (SharpScanPrintAppDelegate*)[[UIApplication sharedApplication] delegate];
        
        // 右側のViewを取得
        UINavigationController* pDetailNavController = [pAppDelegate.splitViewController.viewControllers objectAtIndex:1];
        
        // 右側Viewに戻り先画面がある場合
        if([pDetailNavController.viewControllers count] > 1)
        {    
                   
            if([[pDetailNavController.viewControllers objectAtIndex:[pDetailNavController.viewControllers count]-1] isKindOfClass:[SearchResultViewController_iPad class]])
            {
                // 移動元画面を指定する
                SearchResultViewController_iPad* pSearchResultViewController_iPad = (SearchResultViewController_iPad*)
                [pDetailNavController.viewControllers objectAtIndex:[pDetailNavController.viewControllers count]-1];
                pSearchResultViewController_iPad.bSubFolder = !swSubFolderCell.switchField.on;
                pSearchResultViewController_iPad.bFillterFolder = bFillterFolder;
                pSearchResultViewController_iPad.bFillterPdf = bFillterPdf;
                pSearchResultViewController_iPad.bFillterTiff = bFillterTiff;
                pSearchResultViewController_iPad.bFillterImage = bFillterImage;
                pSearchResultViewController_iPad.bFillterOffice = bFillterOffice;
                [pSearchResultViewController_iPad advancedSearchRightBarButtonClicked];
            }
            else if([[pDetailNavController.viewControllers objectAtIndex:[pDetailNavController.viewControllers count]-1] isKindOfClass:[AdvancedSearchResultViewController_iPad class]])
            {
                // 移動元画面を指定する
                AdvancedSearchResultViewController_iPad* pAdvancedSearchResultViewController_iPad = (AdvancedSearchResultViewController_iPad*)
                [pDetailNavController.viewControllers objectAtIndex:[pDetailNavController.viewControllers count]-1];
                pAdvancedSearchResultViewController_iPad.bSubFolder = !swSubFolderCell.switchField.on;
                pAdvancedSearchResultViewController_iPad.bFillterFolder = bFillterFolder;
                pAdvancedSearchResultViewController_iPad.bFillterPdf = bFillterPdf;
                pAdvancedSearchResultViewController_iPad.bFillterTiff = bFillterTiff;
                pAdvancedSearchResultViewController_iPad.bFillterImage = bFillterImage;
                pAdvancedSearchResultViewController_iPad.bFillterOffice = bFillterOffice;
                pAdvancedSearchResultViewController_iPad.sessionViewController
                                    = (SearchResultViewController_iPad*)(self.sessionViewController);
                [pAdvancedSearchResultViewController_iPad advancedSearchRightBarButtonClicked]; 
            }else
            {
                // 左側のビューを取得する
                UINavigationController* pRootNavController = [pAppDelegate.splitViewController.viewControllers objectAtIndex:0];
                // 左側Viewに戻り先画面がある場合
                if([pRootNavController.viewControllers count] > 1)
                {
                    if([[pRootNavController.viewControllers objectAtIndex:[pRootNavController.viewControllers count]-1] isKindOfClass:[SearchResultViewController_iPad class]])
                    {
                        // 移動元画面を指定する
                        SearchResultViewController_iPad* pSearchResultViewController_iPad = (SearchResultViewController_iPad*)
                        [pRootNavController.viewControllers objectAtIndex:[pRootNavController.viewControllers count]-1];
                        pSearchResultViewController_iPad.bSubFolder = !swSubFolderCell.switchField.on;
                        pSearchResultViewController_iPad.bFillterFolder = bFillterFolder;
                        pSearchResultViewController_iPad.bFillterPdf = bFillterPdf;
                        pSearchResultViewController_iPad.bFillterTiff = bFillterTiff;
                        pSearchResultViewController_iPad.bFillterImage = bFillterImage;
                        pSearchResultViewController_iPad.bFillterOffice = bFillterOffice;
                        self.sessionViewController = pSearchResultViewController_iPad;
                        [pSearchResultViewController_iPad advancedSearchRightBarButtonClicked];
                    }
                    else if([[pRootNavController.viewControllers objectAtIndex:[pRootNavController.viewControllers count]-1] isKindOfClass:[AdvancedSearchResultViewController_iPad class]])
                    {
                        // 移動元画面を指定する
                        AdvancedSearchResultViewController_iPad* pAdvancedSearchResultViewController_iPad = (AdvancedSearchResultViewController_iPad*)
                        [pRootNavController.viewControllers objectAtIndex:[pRootNavController.viewControllers count]-1];
                        pAdvancedSearchResultViewController_iPad.bSubFolder = !swSubFolderCell.switchField.on;
                        pAdvancedSearchResultViewController_iPad.bFillterFolder = bFillterFolder;
                        pAdvancedSearchResultViewController_iPad.bFillterPdf = bFillterPdf;
                        pAdvancedSearchResultViewController_iPad.bFillterTiff = bFillterTiff;
                        pAdvancedSearchResultViewController_iPad.bFillterImage = bFillterImage;
                        pAdvancedSearchResultViewController_iPad.bFillterOffice = bFillterOffice;
                        pAdvancedSearchResultViewController_iPad.sessionViewController
                                    = (SearchResultViewController_iPad*)(self.sessionViewController);
                        [pAdvancedSearchResultViewController_iPad advancedSearchRightBarButtonClicked];
                    }
                }
            }
        }
        else
        {
            SearchResultViewController_iPad* pSearchResultViewController_iPad = (SearchResultViewController_iPad*)
            [pDetailNavController.viewControllers objectAtIndex:0];
            self.sessionViewController = pSearchResultViewController_iPad;
            [pSearchResultViewController_iPad advancedSearchRightBarButtonClicked];
        }
    }
    else
    {
        SharpScanPrintAppDelegate* pAppDelegate = (SharpScanPrintAppDelegate*)[[UIApplication sharedApplication] delegate];
        UINavigationController* pDetailNavController = pAppDelegate.navigationController;
        if([[pDetailNavController.viewControllers objectAtIndex:[pDetailNavController.viewControllers count]-1] isKindOfClass:[SearchResultViewController class]])
        {
            // 移動元画面を指定する
            SearchResultViewController* pSearchResultViewController = (SearchResultViewController*)
            [pDetailNavController.viewControllers objectAtIndex:[pDetailNavController.viewControllers count]-1];
            pSearchResultViewController.bSubFolder = !swSubFolderCell.switchField.on;
            pSearchResultViewController.bFillterFolder = bFillterFolder;
            pSearchResultViewController.bFillterPdf = bFillterPdf;
            pSearchResultViewController.bFillterTiff = bFillterTiff;
            pSearchResultViewController.bFillterImage = bFillterImage;
            pSearchResultViewController.bFillterOffice = bFillterOffice;
            //            self.sessionViewController = (SearchResultViewController*)(pSearchResultViewController);
           [pSearchResultViewController advancedSearchRightBarButtonClicked];
        }
        else if([[pDetailNavController.viewControllers objectAtIndex:[pDetailNavController.viewControllers count]-1] isKindOfClass:[AdvancedSearchResultViewController class]])
        {
            // 移動元画面を指定する
            AdvancedSearchResultViewController* pAdvancedSearchResultViewController = (AdvancedSearchResultViewController*)
            [pDetailNavController.viewControllers objectAtIndex:[pDetailNavController.viewControllers count]-1];
            pAdvancedSearchResultViewController.bSubFolder = !swSubFolderCell.switchField.on;
            pAdvancedSearchResultViewController.bFillterFolder = bFillterFolder;
            pAdvancedSearchResultViewController.bFillterPdf = bFillterPdf;
            pAdvancedSearchResultViewController.bFillterTiff = bFillterTiff;
            pAdvancedSearchResultViewController.bFillterImage = bFillterImage;
            pAdvancedSearchResultViewController.bFillterOffice = bFillterOffice;
            pAdvancedSearchResultViewController.sessionViewController = (SearchResultViewController*)self.sessionViewController;
            [pAdvancedSearchResultViewController advancedSearchRightBarButtonClicked];
        }
    }
}

@end
