
#import <MobileCoreServices/UTCoreTypes.h>
#import "PrintSelectTypeViewController.h"
#import "SelectMailViewController.h"
#import "Define.h"
#import "PrintPictViewController.h"
#import "MultiPrintPictViewController.h"
#import "SelectFileViewController.h"
#import "SharpScanPrintAppDelegate.h"
#import "WebPagePrintViewController.h"
#import <ImageIO/ImageIO.h>
#import <AssetsLibrary/AssetsLibrary.h>
#import "AttachmentMailViewController.h"

@interface PrintSelectTypeViewController()

// 複数印刷対応
@property (nonatomic,strong) NSMutableArray *printFileArray;/** 選択されたファイルの情報を格納*/
@property (nonatomic,strong) NSMutableArray *printPictArray;/** */

@end

@implementation PrintSelectTypeViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self)
    {
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

- (void)viewDidLoad
{
    [super viewDidLoad];

    // セルのラインを表示する
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;

    // ナビゲーションバー
    // タイトル設定
    self.navigationItem.title = S_TITLE_PRINT;
    
    // 戻るボタンの名称変更
    UIBarButtonItem * barItemBack = [UIBarButtonItem new];
    barItemBack.title = S_BUTTON_BACK;
    self.navigationItem.backBarButtonItem = barItemBack;
    
    // 色変更
    //self.navigationController.navigationBar.tintColor = [UIColor blackColor];
    
    // 複数印刷対応
    NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
    [nc addObserver:self selector:@selector(closeBtnPushed:) name:NK_CLOSE_BUTTON_PUSHED object:nil];
    [nc addObserver:self selector:@selector(enterBtnPushed:) name:NK_ENTER_BUTTON_PUSHED object:nil];
    [nc addObserver:self selector:@selector(enterBtnPushed2:) name:NK_ENTER_BUTTON_PUSHED2 object:nil];
    [nc addObserver:self selector:@selector(backBtnPushed:) name:NK_BACK_BUTTON_PUSHED object:nil];
    [nc addObserver:self selector:@selector(moveMultiPrintPictNotification:) name:NK_PICT_ENTER_BUTTON_PUSHED object:nil];
    [nc addObserver:self selector:@selector(editMultiPrintPictNotification:) name:NK_PICT_EDIT_ACTION object:nil];
    
    self.printFileArray = [NSMutableArray arrayWithCapacity:0];
    self.printPictArray = [NSMutableArray arrayWithCapacity:0];
    
    nFolderCount = 1;
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
    {//データリセット
        [self.printFileArray removeAllObjects];
        [self.printPictArray removeAllObjects];
    }
}


- (void)viewDidUnload
{
    // 複数印刷対応
    NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
    [nc removeObserver:self];
    
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

#pragma mark - notificationHandler

// 複数印刷対応
- (void)closeBtnPushed:(NSNotification *)n
{
    [self dismissViewControllerAnimated:YES completion:nil];
}
// 複数印刷対応
- (void)enterBtnPushed:(NSNotification *)n
{
    SelectFileViewController *vc = (SelectFileViewController *)n.object;
    vc.PrevViewID = PV_PRINT_SELECT_FILE_CELL;
    DLog(@"vc.selectFilePathArray = %@",vc.selectFilePathArray);
    
    if (vc.selectFilePathArray.count > 0)
    {
        [self.printFileArray addObjectsFromArray:vc.selectFilePathArray];
    }
    DLog(@"self.printFileArray = %@, count = %lu",self.printFileArray,(unsigned long)self.printFileArray.count);
    
    [self dismissViewControllerAnimated:YES completion:nil];
    
    if (self.printFileArray.count == 1 && ![self.navigationController.viewControllers.lastObject isKindOfClass:[MultiPrintPictViewController class]])
    {
        PrintPictViewController *pVC = [[PrintPictViewController alloc]init];
        pVC.PrintPictViewID = PPV_PRINT_SELECT_FILE_CELL;
        ScanData *scanData = [self.printFileArray firstObject];
        DLog(@"fullPath = %@%@",scanData.fpath,scanData.fname);
        DLog(@"imagePath = %@",scanData.imagename);
        pVC.SelFilePath = [NSString stringWithFormat:@"%@%@",scanData.fpath,scanData.fname];
        pVC.selectFileArray = self.printFileArray;
        
        // 最上位のViewControllerがMultiPrintPictViewControllerの場合、このIF文の入ってこないので、下記処理は
        // 不要なはず。ただ、消すことによるデグレが怖いので、このままにしておきます。
        if ([self.navigationController.viewControllers.lastObject isKindOfClass:[MultiPrintPictViewController class]]) {
            MultiPrintPictViewController *beforeVC = (MultiPrintPictViewController *)self.navigationController.viewControllers.lastObject;
            pVC.isAddedPattern = YES;
            [pVC updateMenuAndDataArray];

            pVC.initRetentionFlg = beforeVC.initRetentionFlg;
            pVC.m_nSelPickerRow1 = beforeVC.m_nSelPickerRow1;
            pVC.m_nSelPickerRow2 = beforeVC.m_nSelPickerRow2;
            pVC.m_nSelPickerRow3 = beforeVC.m_nSelPickerRow3;
            pVC.m_nSelPickerRow4 = beforeVC.m_nSelPickerRow4;
            pVC.m_nSelPickerRow5 = beforeVC.m_nSelPickerRow5;
            pVC.m_nSelPickerRow6 = beforeVC.m_nSelPickerRow6;
            pVC.m_nSelPickerRow7 = beforeVC.m_nSelPickerRow7;
            pVC.m_nSelPickerRow8 = beforeVC.m_nSelPickerRow8;
            pVC.m_pstrColorMode = beforeVC.m_pstrColorMode;
            pVC.m_pstrNumSets = beforeVC.m_pstrNumSets;
            pVC.m_pstrPaperSize = beforeVC.m_pstrPaperSize;
            pVC.m_pstrPaperSizePJL = beforeVC.m_pstrPaperSizePJL;
            pVC.m_pstrPaperType = beforeVC.m_pstrPaperType;
            pVC.m_pstrPaperTypePJL = beforeVC.m_pstrPaperTypePJL;
            pVC.m_pstrPrintRange = beforeVC.m_pstrPrintRange;
            pVC.m_pstrRetention = beforeVC.m_pstrRetention;
            pVC.m_pstrSide = beforeVC.m_pstrSide;
            pVC.isInvalidDuplexSize = beforeVC.isInvalidDuplexSize;
            pVC.isInvalidDuplexType = beforeVC.isInvalidDuplexType;
            pVC.isInvalidStaplePaperSize = beforeVC.isInvalidStaplePaperSize;
            pVC.isInvalidStaplePaperType = beforeVC.isInvalidStaplePaperType;
            pVC.isInvalidPunchPaperSize = beforeVC.isInvalidPunchPaperSize;
            pVC.isInvalidPunchPaperType = beforeVC.isInvalidPunchPaperType;
            pVC.selectedPrinterPrimaryKey = beforeVC.selectedPrinterPrimaryKey;
            
            if (pVC.isSingleData) {
                if (pVC.hasN_UpData) {
                    pVC.nNupRow = beforeVC.nNupRow;
                    pVC.nSeqRow = beforeVC.nSeqRow;
                    pVC.pstrSelectedNUp = beforeVC.pstrSelectedNUp;
                    pVC.pstrSelectedSeq = beforeVC.pstrSelectedSeq;
                }
                if (pVC.hasEncryptionPdfData == NO) {
                    pVC.noPrintOn = beforeVC.noPrintOn;
                    pVC.authenticateOn = beforeVC.authenticateOn;
                    pVC.pstrPassword = beforeVC.pstrPassword;
                }
            } else {
                pVC.nNupRow = beforeVC.nNupRow;
                pVC.nSeqRow = beforeVC.nSeqRow;
                pVC.pstrSelectedNUp = beforeVC.pstrSelectedNUp;
                pVC.pstrSelectedSeq = beforeVC.pstrSelectedSeq;
                
                pVC.noPrintOn = beforeVC.noPrintOn;
                pVC.authenticateOn = beforeVC.authenticateOn;
                pVC.pstrPassword = beforeVC.pstrPassword;
            }
            pVC.printReleaseOn = beforeVC.printReleaseOn;
            pVC.canPrintRelease =beforeVC.canPrintRelease;

            pVC.nClosingRow = beforeVC.nClosingRow;
            pVC.nStapleRow = beforeVC.nStapleRow;
            pVC.nPunchRow = beforeVC.nPunchRow;
            pVC.pstrSelectedClosing = beforeVC.pstrSelectedClosing;
            pVC.pstrSelectedStaple = beforeVC.pstrSelectedStaple;
            pVC.pstrSelectedPunch = beforeVC.pstrSelectedPunch;
            pVC.staple = beforeVC.staple;
            pVC.punchData = beforeVC.punchData;
            
            [self.navigationController popViewControllerAnimated:NO];
        } else {
            [pVC updateMenuAndDataArray];
        }
        [self.navigationController pushViewController:pVC animated:NO];
    } else {
        MultiPrintPictViewController *pVC = [[MultiPrintPictViewController alloc]init];
        pVC.PrintPictViewID = PPV_PRINT_SELECT_FILE_CELL;
        pVC.selectFileArray = self.printFileArray;
        ScanData *scanData = [self.printFileArray firstObject];
        DLog(@"fullPath = %@%@",scanData.fpath,scanData.fname);
        DLog(@"imagePath = %@",scanData.imagename);
        pVC.SelFilePath = [NSString stringWithFormat:@"%@%@",scanData.fpath,scanData.fname];
        pVC.mppvcDelegate = self;
        [pVC.previewScrollViewManager.m_plblPageNum setHidden:YES];
        [pVC updateMenuAndDataArray];
        
        PrintPictViewController *beforeVC = nil;
        if ([self.navigationController.viewControllers.lastObject isKindOfClass:[PrintPictViewController class]]) {
            beforeVC = (PrintPictViewController *)self.navigationController.viewControllers.lastObject;
            [self copyValueOfPrintSetting:pVC beforeViewController:beforeVC];
            [self.navigationController popViewControllerAnimated:NO];
        }
        [self.navigationController pushViewController:pVC animated:NO];
    }
}

// 複数印刷画面に遷移する際の、値引き継ぎ
// ファイル印刷と写真印刷で共通のため外出しメソッド化
- (void)copyValueOfPrintSetting:(MultiPrintPictViewController *) pVC
          beforeViewController :(PrintPictViewController *) beforeVC
{
    pVC.isAddedPattern = YES;

    pVC.initRetentionFlg = beforeVC.initRetentionFlg;
    pVC.m_nSelPickerRow1 = beforeVC.m_nSelPickerRow1;
    pVC.m_nSelPickerRow2 = beforeVC.m_nSelPickerRow2;
    pVC.m_nSelPickerRow3 = beforeVC.m_nSelPickerRow3;
    pVC.m_nSelPickerRow4 = beforeVC.m_nSelPickerRow4;
    pVC.m_nSelPickerRow5 = beforeVC.m_nSelPickerRow5;
    pVC.m_nSelPickerRow6 = beforeVC.m_nSelPickerRow6;
    pVC.m_nSelPickerRow7 = beforeVC.m_nSelPickerRow7;
    pVC.m_nSelPickerRow8 = beforeVC.m_nSelPickerRow8;
    pVC.m_pstrColorMode = beforeVC.m_pstrColorMode;
    pVC.m_pstrNumSets = beforeVC.m_pstrNumSets;
    pVC.m_pstrPaperSize = beforeVC.m_pstrPaperSize;
    pVC.m_pstrPaperSizePJL = beforeVC.m_pstrPaperSizePJL;
    pVC.m_pstrPaperType = beforeVC.m_pstrPaperType;
    pVC.m_pstrPaperTypePJL = beforeVC.m_pstrPaperTypePJL;
    pVC.m_pstrPrintRange = beforeVC.m_pstrPrintRange;
    pVC.m_pstrRetention = beforeVC.m_pstrRetention;
    pVC.m_pstrSide = beforeVC.m_pstrSide;
    pVC.isInvalidDuplexSize = beforeVC.isInvalidDuplexSize;
    pVC.isInvalidDuplexType = beforeVC.isInvalidDuplexType;
    pVC.isInvalidStaplePaperSize = beforeVC.isInvalidStaplePaperSize;
    pVC.isInvalidStaplePaperType = beforeVC.isInvalidStaplePaperType;
    pVC.isInvalidPunchPaperSize = beforeVC.isInvalidPunchPaperSize;
    pVC.isInvalidPunchPaperType = beforeVC.isInvalidPunchPaperType;
    pVC.selectedPrinterPrimaryKey = beforeVC.selectedPrinterPrimaryKey;
    
    if (pVC.isSingleData) {
        if (pVC.hasN_UpData) {
            pVC.nNupRow = beforeVC.nNupRow;
            pVC.nSeqRow = beforeVC.nSeqRow;
            pVC.pstrSelectedNUp = beforeVC.pstrSelectedNUp;
            pVC.pstrSelectedSeq = beforeVC.pstrSelectedSeq;
        }
        if (pVC.hasEncryptionPdfData == NO) {
            pVC.noPrintOn = beforeVC.noPrintOn;
            pVC.authenticateOn = beforeVC.authenticateOn;
            pVC.pstrPassword = beforeVC.pstrPassword;
        }
    } else {
        pVC.nNupRow = beforeVC.nNupRow;
        pVC.nSeqRow = beforeVC.nSeqRow;
        pVC.pstrSelectedNUp = beforeVC.pstrSelectedNUp;
        pVC.pstrSelectedSeq = beforeVC.pstrSelectedSeq;
        
        pVC.noPrintOn = beforeVC.noPrintOn;
        pVC.authenticateOn = beforeVC.authenticateOn;
        pVC.pstrPassword = beforeVC.pstrPassword;
    }
    pVC.printReleaseOn = beforeVC.printReleaseOn;
    pVC.canPrintRelease =beforeVC.canPrintRelease;
    
    pVC.nClosingRow = beforeVC.nClosingRow;
    pVC.nStapleRow = beforeVC.nStapleRow;
    pVC.nPunchRow = beforeVC.nPunchRow;
    pVC.pstrSelectedClosing = beforeVC.pstrSelectedClosing;
    pVC.pstrSelectedStaple = beforeVC.pstrSelectedStaple;
    pVC.pstrSelectedPunch = beforeVC.pstrSelectedPunch;
    pVC.staple = beforeVC.staple;
    pVC.punchData = beforeVC.punchData;
}

//
/**
 * 複数印刷対応 メール添付ファイル
 * 画像が選択されたとき(AttachmentMailViewController等で画像ファイルが選択されたときのnotificationHandler
 */
- (void)enterBtnPushed2:(NSNotification *) n {
    
    //添付ファイルリスト画面
    AttachmentMailViewController *vc = (AttachmentMailViewController *)n.object;
//    vc.PrevViewID = PV_PRINT_SELECT_FILE_CELL;
    DLog(@"vc.selectFilePathArray = %@",vc.selectFilePathArray);
    
    if (vc.selectFilePathArray.count > 0)
    {//ファイルが選択されていれば
        //データを加える
        [self.printFileArray addObjectsFromArray:vc.selectFilePathArray];
    }
    DLog(@"self.printFileArray = %@, count = %lu",self.printFileArray,(unsigned long)self.printFileArray.count);
    
    //モーダルを消す
    [self dismissViewControllerAnimated:YES completion:nil];
    
    if (self.printFileArray.count == 1 && ![self.navigationController.viewControllers.lastObject isKindOfClass:[MultiPrintPictViewController class]])
    {//ファイルが１つ
        if ([self.navigationController.viewControllers.lastObject isKindOfClass:[PictureViewController class]])
        {//現在表示中の画面が画像プレビュー画面なら
            //一旦戻る
            [self.navigationController popViewControllerAnimated:NO];
        }
        //印刷プレビュー画面生成
        PrintPictViewController  *pVC = [[PrintPictViewController alloc]init];
        pVC.PrintPictViewID = PPV_PRINT_MAIL_ATTACHMENT_CELL;
        ScanData *scanData = [self.printFileArray firstObject];
        DLog(@"fullPath = %@%@",scanData.fpath,scanData.fname);
        DLog(@"imagePath = %@",scanData.imagename);
        pVC.SelFilePath = [NSString stringWithFormat:@"%@%@",scanData.fpath,scanData.fname];
        pVC.selectFileArray = self.printFileArray;
        //画面遷移
        [self.navigationController pushViewController:pVC animated:NO];
    }
    else
    {//複数ファイルのとき
        //複数ファイル用プレビュー画面生成
        MultiPrintPictViewController *pVC = [[MultiPrintPictViewController alloc]init];
        pVC.PrintPictViewID = PPV_PRINT_MAIL_ATTACHMENT_CELL;
        pVC.selectFileArray = self.printFileArray;
        ScanData *scanData = [self.printFileArray firstObject];
        DLog(@"fullPath = %@%@",scanData.fpath,scanData.fname);
        DLog(@"imagePath = %@",scanData.imagename);
        pVC.SelFilePath = [NSString stringWithFormat:@"%@%@",scanData.fpath,scanData.fname];
        pVC.mppvcDelegate = self;
        [pVC.previewScrollViewManager.m_plblPageNum setHidden:YES];
        
        if ([self.navigationController.viewControllers.lastObject isKindOfClass:[PictureViewController class]])
        {
            //印刷設定値の記憶
            PrintPictViewController* beforeVC = (PrintPictViewController *)self.navigationController.viewControllers.lastObject;
            if(beforeVC.PrintPictViewID == PPV_PRINT_MAIL_ATTACHMENT_CELL) {
                [self copyValueOfPrintSetting:pVC beforeViewController:beforeVC];
            }
            
            //一旦戻る
            [self.navigationController popViewControllerAnimated:NO];
        }
        //遷移
        [self.navigationController pushViewController:pVC animated:NO];
    }
}

/*
 * 戻りボタン押下
 */
// 複数印刷対応
- (void)backBtnPushed:(NSNotification *)n
{//データのリセットはviewDidAppearに移した。20140408
    //[self.printFileArray removeAllObjects];
    //[self.printPictArray removeAllObjects];
}


#pragma mark - MultiPrintPictViewControllerDelegate

/**
 * printFileArrayをリセットし、新たなデータをセットする
 * @param editedFileArray 新たなデータ
 */
- (void)updatePrintFileArray:(NSArray *)editedFileArray
{
    [self.printFileArray removeAllObjects];
    [self.printFileArray addObjectsFromArray:editedFileArray];
}

/**
 * printPictArrayをリセットし、新たなデータをセットする
 * @param editedFileArray 新たなデータ
 */
- (void)updatePrintPictArray:(NSArray *)editedFileArray {
    [self.printPictArray removeAllObjects];
    [self.printPictArray addObjectsFromArray:editedFileArray];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return N_NUM_SECTION_PRINT_SEL;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    if (section == 0)
    {
        return N_NUM_ROW_PRINT_SEL_SEC1;
    }
    else if (section == 1)
    {
        return N_NUM_ROW_PRINT_SEL_SEC2;
    }
    else
    {
        return 0;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    cell.accessoryType = TABLE_CELL_ACCESSORY;

    cell.textLabel.font = [UIFont systemFontOfSize:16];
    
    // アイコン名
    NSMutableString* pstrIconName = [[NSMutableString alloc] initWithCapacity:100];
    
    // 表示項目の設定
    if(indexPath.section == 0)
    {
        switch (indexPath.row)
        {
            case 0:
                cell.textLabel.text = S_PRINT_SEL_FILE;
                cell.textLabel.lineBreakMode = NSLineBreakByWordWrapping;
                cell.textLabel.numberOfLines = 2;
                cell.accessoryType = UITableViewCellAccessoryNone;
                [pstrIconName appendString:S_ICON_PRINT_SEL_FILE];
                break;
            case 1:
                cell.textLabel.text = S_PRINT_SEL_PICTURE;
                cell.textLabel.lineBreakMode = NSLineBreakByWordWrapping;
                cell.textLabel.numberOfLines = 2;
                cell.accessoryType = UITableViewCellAccessoryNone;
                [pstrIconName appendString:S_ICON_PRINT_SEL_PICTURE];
                break;
            default:
                break;
        }
    }
    else if (indexPath.section == 1)
    {
        switch (indexPath.row)
        {
            case 0:
                // ★TODO:他言語化
                cell.textLabel.text = S_PRINT_SEL_WEBPAGE;
                cell.textLabel.lineBreakMode = NSLineBreakByWordWrapping;
                cell.textLabel.numberOfLines = 2;
                cell.accessoryType = UITableViewCellAccessoryNone;
                [pstrIconName appendString:S_ICON_PRINT_WEBPAGE];
                break;
            case 1:
                cell.textLabel.text = S_PRINT_SEL_EMAIL;
                cell.textLabel.lineBreakMode = NSLineBreakByWordWrapping;
                cell.textLabel.numberOfLines = 2;
                cell.accessoryType = UITableViewCellAccessoryNone;
                [pstrIconName appendString:S_ICON_PRINT_EMAIL];
                break;
            default:
                break;
        }
    }
    
    // アイコン設定
    UIImage* pIconImage = [UIImage imageNamed: pstrIconName];
    cell.imageView.image = pIconImage;
    
    return cell;
}

// テーブルビューの縦幅設定
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.section == 0)
    {
        return N_HEIGHT_PRINT_SEL_SEC1;
    }
    else if (indexPath.section == 1)
    {
        return N_HEIGHT_PRINT_SEL_SEC2;
    }
    else
    {
        return 0;
    }
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

/*
 // Override to support conditional editing of the table view.
 - (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
 {
    // Return NO if you do not want the specified item to be editable.
    return YES;
 }
 */

/*
 // Override to support editing the table view.
 - (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
 {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
 }
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
 }
 }
 */

/*
 // Override to support rearranging the table view.
 - (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
 {
 }
 */

/*
 // Override to support conditional rearranging of the table view.
 - (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
 {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
 }
 */

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self MoveView:indexPath];
}

- (void)tableView:(UITableView *)tableView accessoryButtonTappedForRowWithIndexPath:(NSIndexPath *)indexPath
{
    [self MoveView:indexPath];

}

// 画面遷移
- (void)MoveView:(NSIndexPath *)nIndexPath
{
    // セルの複数タップを制御する
    if ( ! [self.navigationController.visibleViewController isKindOfClass: [self class]] ) {
        DLog(@"visibleViewController is Invalid");
        return;
    }

    SelectFileViewController * pViewController;
    //UIImagePickerController* imgPicker;
    
    if(nIndexPath.section == 0)
    {
        switch (nIndexPath.row)
        {
            case 0:
            {
                pViewController = [[SelectFileViewController alloc] init];
                // 複数印刷対応
                pViewController.PrevViewID = PV_PRINT_SELECT_FILE_CELL;
                UINavigationController *nc = [[UINavigationController alloc]initWithRootViewController:pViewController];
                nc.navigationBar.barStyle = NAVIGATION_BARSTYLE;
                [self presentViewController:nc animated:YES completion:nil];
                
                //[self.navigationController pushViewController:pViewController animated:YES];
            }
                break;
            case 1:
            {
                // 複数印刷対応
                [CommonUtil DeleteDir:[CommonUtil tmpDir]];
                if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
                    ELCAlbumPickerController *albumController = [[ELCAlbumPickerController alloc] initWithNibName:@"ELCAlbumPickerController" bundle:[NSBundle mainBundle]];
                    ELCImagePickerController *elcPicker = [[ELCImagePickerController alloc] initWithRootViewController:albumController];
                    albumController.navigationController.navigationBar.barStyle = NAVIGATION_BARSTYLE;
                    [albumController setParent:elcPicker];
                    [elcPicker setDelegate:self];
                    [elcPicker setMaximumImagesCount:-1];
                    [self presentViewController:elcPicker animated:YES completion:nil];
                }
            }
                break;
            default:
                break;
        }
    }
    else if (nIndexPath.section == 1)
    {
        switch (nIndexPath.row)
        {
            case 0: {
                // Webページを印刷する
//                WebPagePrintViewController * webPagePrintViewController = [[WebPagePrintViewController alloc] init];
//                [self.navigationController pushViewController:webPagePrintViewController animated:YES];
//                [webPagePrintViewController release];
                
                PrintPictViewController* pPrintPictViewController = nil;
                pPrintPictViewController = [[PrintPictViewController alloc] init];
                pPrintPictViewController.SelFilePath	= S_PRINT_DATA_FILENAME_FOR_PRINT_PDF;
                pPrintPictViewController.PrintPictViewID = WEB_PRINT_VIEW;
                
//                [self.navigationController pushViewController:pPrintPictViewController animated:YES];

                WebPagePrintViewController* pWebPagePrintViewController = [[WebPagePrintViewController alloc] init];
                pWebPagePrintViewController.delegate = pPrintPictViewController;
                
                // モーダル表示
                UINavigationController *navigationController =
                [[UINavigationController alloc]initWithRootViewController:pWebPagePrintViewController];
                navigationController.navigationBar.barStyle = NAVIGATION_BARSTYLE;
                [navigationController setModalPresentationStyle:UIModalPresentationPageSheet];
                [UIView animateWithDuration:0.3 animations:^{
                    [self presentViewController:navigationController animated:YES completion:nil];
                } completion:^(BOOL finished) {
                    [self.navigationController pushViewController:pPrintPictViewController animated:NO];
                }];
                

            }
                break;
            case 1:{
                
                PrintPictViewController* pPrintPictViewController = nil;
                pPrintPictViewController = [[PrintPictViewController alloc] init];
                pPrintPictViewController.delegate = self;
                pPrintPictViewController.SelFilePath	= S_PRINT_DATA_FILENAME_FOR_PRINT_PDF;
                pPrintPictViewController.PrintPictViewID = EMAIL_PRINT_VIEW;
                
//                [self.navigationController pushViewController:pPrintPictViewController animated:YES];
                
                if (pPrintPictViewController.smNavigationController == nil) {
                    pPrintPictViewController.smViewController = [[SelectMailViewController alloc] init];
                    
                    [pPrintPictViewController.smViewController setPrevViewID: SendMailSelectTypeView];
                    pPrintPictViewController.smViewController.bRootClassShow = YES;
                    pPrintPictViewController.smViewController.nFolderCount = nFolderCount;
                    pPrintPictViewController.smViewController.rootDir = pathDir;
                    pPrintPictViewController.smViewController.delegate = pPrintPictViewController;
                    // モーダル表示
                    pPrintPictViewController.smNavigationController =
                    [[UINavigationController alloc]initWithRootViewController:pPrintPictViewController.smViewController];
                    pPrintPictViewController.smNavigationController.navigationBar.barStyle = NAVIGATION_BARSTYLE;
                    [pPrintPictViewController.smNavigationController setModalPresentationStyle:UIModalPresentationPageSheet];
                    [pPrintPictViewController presentViewController:pPrintPictViewController.smNavigationController  animated:YES completion:nil];
                    
                    [UIView animateWithDuration:0.3 animations:^{
                        [self presentViewController:pPrintPictViewController.smNavigationController  animated:YES completion:nil];
                    } completion:^(BOOL finished) {
                        [self.navigationController pushViewController:pPrintPictViewController animated:NO];
                    }];

                }
                else
                {
                    // モーダル表示
                    [pPrintPictViewController presentViewController:pPrintPictViewController.smNavigationController  animated:YES completion:nil];
                }
                
            }
                break;
            default:
                break;
        }

    }
}

-(void)performInvocation:(NSInvocation *)anInvocation{
	[anInvocation invokeWithTarget:self];
}

// 複数印刷対応
- (void)elcImagePickerController:(ELCImagePickerController *)picker didFinishPickingMediaWithInfo:(NSArray *)info {
    if (info.count == 0) {
        [self dismissViewControllerAnimated:YES completion:nil];
        return;
    }

    DLog(@"info = %@",info);
    
    if (isIOS8_1Later) {
        // エラーチェックなし
    } else {
        // エラーチェック
        for (NSDictionary *assetDic in info) {
            // 選択メディア
            NSString* pstrMediaType = [assetDic objectForKey:UIImagePickerControllerMediaType];
            // Imageの場合
            if (CFStringCompare((CFStringRef)pstrMediaType, kUTTypeImage, 0) == kCFCompareEqualTo)
            {
                NSString* path = [[assetDic objectForKey:UIImagePickerControllerReferenceURL] absoluteString];
                NSString* ext = [path substringFromIndex:[path rangeOfString:@"ext="].location + 4];
                
                if(![CommonUtil extensionCheck:ext])
                {
                    // Photo Albumを閉じる
                    [self dismissViewControllerAnimated:YES completion:^{
                        SharpScanPrintAppDelegate* appDelegate = (SharpScanPrintAppDelegate*)[[UIApplication sharedApplication] delegate];
                        // 処理実行フラグON
                        appDelegate.IsRun = TRUE;
                        
                        //
                        // アラート表示
                        //
                        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil
                                                                                                 message:MSG_NO_VIEW_FILE
                                                                                          preferredStyle:UIAlertControllerStyleAlert];
                        // OK用のアクションを生成
                        UIAlertAction * okAction =
                        [UIAlertAction actionWithTitle:MSG_BUTTON_OK
                                                 style:UIAlertActionStyleDefault
                                               handler:^(UIAlertAction * action) {
                                                   
                                                   // ボタンタップ時の処理
                                                   [self appDelegateIsRunOff];
                                               }];
                        
                        // コントローラにアクションを追加
                        [alertController addAction:okAction];
                        // アラート表示処理
                        [self presentViewController:alertController animated:YES completion:nil];
                    }];
                    return;
                }
            }
            else
            {
                // ToDo:エラーメッセージ表示
            }
        }
    }
    
    [self.printPictArray addObjectsFromArray:info];
    [self dismissViewControllerAnimated:YES completion:nil];
    [self moveMultiPrintPictView];
}

// 複数印刷対応
- (void)elcImagePickerControllerDidCancel:(ELCImagePickerController *)picker {
    [self dismissViewControllerAnimated:YES completion:nil];
}

// おそらく使われていない
//// Photo Album画像選択イベント
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
}

// 印刷画面に遷移
-(void)MovePrintPictView:(NSDictionary *)info
{
    // 印刷画面に遷移
    PictureViewController* pViewController;
    pViewController = [[PrintPictViewController alloc] init];
    pViewController.PrintPictViewID = PPV_PRINT_SELECT_PICTURE_CELL;
    pViewController.multiPrintPictTempArray = [NSMutableArray arrayWithObject:info];
    for (NSInteger i = 0; i < [[info allKeys] count]; i++)
    {
        DLog(@"key: %@, value:%@", [[info allKeys] objectAtIndex:i], [info objectForKey:[[info allKeys] objectAtIndex:i]]);
    }
    pViewController.PictEditInfo = info;        // image情報格納
    pViewController.IsPhotoView = TRUE;         // 遷移元画面設定
    [pViewController.previewScrollViewManager.m_plblPageNum setHidden:YES];
    [self.navigationController pushViewController:pViewController animated:NO];

    // Photo Albumを閉じる
    [self dismissViewControllerAnimated:YES completion:nil];
}

// 複数印刷画面に遷移
- (void)moveMultiPrintPictView {
    if (self.printPictArray.count > 1) {
        MultiPrintPictViewController *pVC = [[MultiPrintPictViewController alloc]init];
        [pVC.previewScrollViewManager.m_plblPageNum setHidden:YES];
        
        pVC.PrintPictViewID = PPV_PRINT_SELECT_PICTURE_CELL;
        pVC.selectPictArray = self.printPictArray;
        pVC.PictEditInfo = self.printPictArray.firstObject;
        pVC.IsPhotoView = TRUE;
        [self.navigationController pushViewController:pVC animated:NO];
    } else {
        [self MovePrintPictView:self.printPictArray.firstObject];
    }
}

- (void)moveMultiPrintPictNotification:(NSNotification *)n {
    NSMutableArray *ary = (NSMutableArray *)n.object;
    MultiPrintPictViewController *pVC = [[MultiPrintPictViewController alloc]init];
    MultiPrintPictViewController *beforeVC = [self.navigationController.viewControllers lastObject];
    NSString *printerPrimaryKey = beforeVC.selectedPrinterPrimaryKey;
//    LOG(@"printerPrimaryKey:%@",printerPrimaryKey);
    [self.navigationController popViewControllerAnimated:NO];
    if (self.printPictArray.count > 0) {
        [self.printPictArray removeAllObjects];
    }
    [self.printPictArray addObjectsFromArray:ary];
    if (self.printPictArray.count > 1) {
        
        pVC.PrintPictViewID = PPV_PRINT_SELECT_PICTURE_CELL;
        pVC.selectPictArray = self.printPictArray;
        pVC.PictEditInfo = self.printPictArray.firstObject;
        pVC.IsPhotoView = TRUE;
        [pVC.previewScrollViewManager.m_plblPageNum setHidden:YES];
        pVC.selectedPrinterPrimaryKey = printerPrimaryKey;
        
        [self copyValueOfPrintSetting:pVC beforeViewController:beforeVC];

        [self.navigationController pushViewController:pVC animated:NO];
    } else {
        [self MovePrintPictView:self.printPictArray.firstObject];
    }
    if (ary.count > 0) {
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}

- (void)editMultiPrintPictNotification:(NSNotification *)n {
    NSMutableArray *ary = (NSMutableArray *)n.object;
    if (ary.count > 0) {
        [self.printPictArray removeAllObjects];
        [self.printPictArray addObjectsFromArray:ary];
    }
}

// 処理実行フラグをOFFにする
- (void)appDelegateIsRunOff {
    // ボタンタップ時の処理
    SharpScanPrintAppDelegate* appDelegate = (SharpScanPrintAppDelegate*)[[UIApplication sharedApplication] delegate];
    // 処理実行フラグOFF
    appDelegate.IsRun = FALSE;
}

- (void)closeSelectMailViewShowAttachmentMailView:(UIViewController*)viewController closeView:(UIViewController*)closeView
{
    PrintPictViewController* ppViewController = (PrintPictViewController*)viewController;
    [self.navigationController popViewControllerAnimated:NO];
    
    SelectMailViewController* con = (SelectMailViewController*)closeView;
    
    if(floor(NSFoundationVersionNumber) < NSFoundationVersionNumber_iOS_5_0)
    {//iOS4
        // モーダルを閉じる
        [con dismissViewControllerAnimated:YES completion:nil];
        
        // 閉じるのを待って次のモーダルを表示
        [self performSelector:@selector(showAttachmentMailView:) withObject:ppViewController afterDelay:1.5];
    }
    else
    {// iOS5以上なら
        
        [con dismissViewControllerAnimated:YES completion:^{
            AttachmentMailViewController *pViewController = [[AttachmentMailViewController alloc] init];
            pViewController.delegate = ppViewController;
            //メール添付ファイル表示画面屁の遷移時にメール添付のルートディレクトリを渡します
            pViewController.attachmentDirectory = [[TempAttachmentDirectory alloc]initWithDirectoryPath:[TempAttachmentFileUtility getRootDir]];
           // モーダル表示
            UINavigationController *navigationController = [[UINavigationController alloc]initWithRootViewController:pViewController];
            navigationController.navigationBar.barStyle = NAVIGATION_BARSTYLE;
            [navigationController setModalPresentationStyle:UIModalPresentationPageSheet];
            
            [self presentViewController:navigationController animated:YES completion:^{
                [self.navigationController pushViewController:viewController animated:NO];
            }];
        }];
    }
}

- (void)showAttachmentMailView:(UIViewController*)viewController
{
    AttachmentMailViewController* pViewController = nil;
    pViewController = [[AttachmentMailViewController alloc] init];
    pViewController.delegate = viewController;
    // モーダル表示
    UINavigationController *navigationController = [[UINavigationController alloc]initWithRootViewController:pViewController];
    navigationController.navigationBar.barStyle = NAVIGATION_BARSTYLE;
    [navigationController setModalPresentationStyle:UIModalPresentationPageSheet];
    
    [UIView animateWithDuration:0.3 animations:^{
        [self presentViewController:navigationController animated:YES completion:nil];
    } completion:^(BOOL finished) {
        [self.navigationController pushViewController:viewController animated:NO];
    }];

}

@end
