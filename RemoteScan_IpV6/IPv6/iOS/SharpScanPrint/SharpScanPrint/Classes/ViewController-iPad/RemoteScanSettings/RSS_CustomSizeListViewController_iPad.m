
#import "RSS_CustomSizeListViewController_iPad.h"
#import "RemoteScanBeforePictViewController_iPad.h"

@interface RSS_CustomSizeListViewController_iPad ()

@end

@implementation RSS_CustomSizeListViewController_iPad
@synthesize parentVCDelegate;
@synthesize	baseDir;							// ホームディレクトリ/Documments/

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
    }
    return self;
}

- (id)initWithStyle:(UITableViewStyle)style delegate:(RemoteScanBeforePictViewController_iPad *)delegate
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
        parentVCDelegate = delegate;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // セルのラインを表示する
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    
    // スクロールの必要がないのでNO
    //self.tableView.scrollEnabled = NO;
    
    // ナビゲーションバーの設定
    self.navigationItem.title = S_TITLE_CUSTOMSIZE;
    
    // 戻るボタン(次のビュー用)
    UIBarButtonItem * barItemBack = [UIBarButtonItem new];
    barItemBack.title = S_BUTTON_BACK;
    self.navigationItem.backBarButtonItem = barItemBack;
    
    // 編集ボタン
    //    UIBarButtonItem* rightBtn = [[[UIBarButtonItem alloc]initWithTitle:@"編集" style:UIBarButtonItemStylePlain target:self action:@selector(editMode)]autorelease];
    //    self.navigationItem.rightBarButtonItem = rightBtn;
    self.navigationItem.rightBarButtonItem = self.editButtonItem;
    self.editButtonItem.target = self;
    self.tableView.allowsSelectionDuringEditing = YES;
    
}

// iPad用
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    // 設定ファイル格納ディレクトリの取得
    self.baseDir		= CommonUtil.settingFileDir;
    //
    // データ取得
    //
    sizeList = [[NSMutableArray alloc] init];
    sizeList = [self readCustomData];
    
    [self.tableView reloadData];
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

-(void)editMode
{
    [self.tableView setEditing:(!self.tableView.editing) animated:YES];
}

- (void)viewDidUnload
{
    self.parentVCDelegate = nil;
    
    [super viewDidUnload];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
	return YES;
}


// 縦表示時のメニューボタン設定
- (void)setPortraitMenu:(UIBarButtonItem *)barButtonItem
{
    [self.navigationItem setLeftBarButtonItem:nil animated:NO];
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
    NSUInteger cellNum = 0;
    if(section == 0){
        // 新規追加
        cellNum = 1;
    }else{
        cellNum = [sizeList count];
    }
    
    return cellNum;
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
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    // セルタイトル
    if(indexPath.section == 0){
        cell.textLabel.text = S_CUSTOMSIZE_NEWADD;
        if([sizeList count] == 5)
        {
            // 5個登録済みの場合は、新規追加不可
            cell.textLabel.textColor = [UIColor grayColor];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.accessoryType = UITableViewCellAccessoryNone;
        }
        else
        {
            cell.textLabel.textColor = [UIColor blackColor];
            cell.selectionStyle = UITableViewCellSelectionStyleBlue;
        }
    }else
    {
        //        CustomSizeObject* csobj = [sizeList objectAtIndex:indexPath.row];
        //        cell.textLabel.text = [csobj outputString];
        //        cell.textLabel.text = [sizeList objectAtIndex:indexPath.row];
        
        
        RSCustomPaperSizeData *rsCustomPaperSizeData = nil;
        
        // プリンタ情報をDATファイルから取得
        rsCustomPaperSizeData = [sizeList objectAtIndex:indexPath.row];
        
        cell.textLabel.text = [rsCustomPaperSizeData getDisplayName];
        
    }
    
    return cell;
}

// セルを選択したときの処理
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // セルの複数タップを制御する
    if ( ! [self.navigationController.visibleViewController isKindOfClass: [self class]] ) {
        DLog(@"visibleViewController is Invalid");
        return;
    }
    
    if(!m_pCustomSizeSettingVC){
        m_pCustomSizeSettingVC = [[RSS_CustomSizeSettingViewController_iPad alloc]initWithSettingName:nil];
    }
    if(indexPath.section == 0)
    {
        m_pCustomSizeSettingVC.bEdit = NO;
        if([sizeList count] == 5)
        {
            return;
        }
    }
    else if(indexPath.section == 1)
    {
        RSCustomPaperSizeData *rsCustomPaperSizeData = nil;
        
        // プリンタ情報をDATファイルから取得
        rsCustomPaperSizeData = [sizeList objectAtIndex:indexPath.row];
        
        m_pCustomSizeSettingVC = [[RSS_CustomSizeSettingViewController_iPad alloc]initWithSettingName:rsCustomPaperSizeData.name];
        m_pCustomSizeSettingVC.bEdit = YES;
        m_pCustomSizeSettingVC.m_pRsCustomPaperSizeData = rsCustomPaperSizeData;
        m_pCustomSizeSettingVC.nSelectedRow = indexPath.row;
    }
    if((self.tableView.editing == NO) || (indexPath.section == 0)){
        [super setEditing:NO];
        [self.navigationController pushViewController:m_pCustomSizeSettingVC animated:YES];
    }
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    m_pCustomSizeSettingVC = nil;
}

// 編集可/不可の設定
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    BOOL canEdit = YES;
	if (indexPath.section == 0) {
		canEdit = NO;
    } else {
        // 選択されている原稿
        NSString *original = [parentVCDelegate.rssViewData.originalSize getSelectValue];
        
        RSCustomPaperSizeData *tempData = [sizeList objectAtIndex:indexPath.row];
        // カスタムサイズの原稿が選択されている場合
        if ([original isEqualToString:tempData.customSizeKey]) {
            canEdit = NO;
        }
	}
	return canEdit;
}

// 並べ替え可/不可の設定
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    BOOL ret = NO;
    if(indexPath.section == 1){
        ret = YES;
    }
    return ret;
}

// 並べ替え処理
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
    if(fromIndexPath.section == toIndexPath.section) {
        if(sizeList && toIndexPath.row < [sizeList count]) {
            id item = [sizeList objectAtIndex:fromIndexPath.row];
            [sizeList removeObject:item];
            [sizeList insertObject:item atIndex:toIndexPath.row];
            
            if([self saveCustomData])
            {
                DLog(@"move");
            };
        }
    }
}

// セクションを超える並べ替え設定
- (NSIndexPath *)tableView:(UITableView *)tableView targetIndexPathForMoveFromRowAtIndexPath:(NSIndexPath *)fromIndexPath toProposedIndexPath:(NSIndexPath *)toIndexPath
{
    NSIndexPath* retIndex = toIndexPath;
    if(fromIndexPath.section == toIndexPath.section){
        
    }else if(fromIndexPath.section < toIndexPath.section){
        retIndex = [NSIndexPath indexPathForRow:sizeList.count - 1 inSection:fromIndexPath.section];
    }else{
        retIndex = [NSIndexPath indexPathForRow:0 inSection:fromIndexPath.section];
    }
    return retIndex;
}

// 削除処理
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.section == 1){
        if (editingStyle == UITableViewCellEditingStyleDelete) {
            [sizeList removeObjectAtIndex:indexPath.row]; // 削除ボタンが押された行のデータを配列から削除します。
            [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
            
            if([self saveCustomData])
            {
                [self.tableView reloadData];
                DLog(@"delete");
            };
        }
    }
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
                // PrinterDataクラスの生成
                RSCustomPaperSizeData *rsCustomPaperSizeData = [[RSCustomPaperSizeData alloc]init];
                // プリンタ情報をDATファイルから取得
                rsCustomPaperSizeData = [obj objectAtIndex:nIndex];
                // プリンタ情報をPrinterDataクラスに追加
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
// PROFILEの保存
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
            
            if (![NSKeyedArchiver archiveRootObject:sizeList toFile:fileName]) {
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


@end
