#import "SelectMailViewController_iPad.h"

#import "Define.h"
#import "ShowMailViewController_iPad.h"
#import "SendMailPictViewController_iPad.h"
#import "SendExSitePictViewController_iPad.h"
#import "ScanDataCell.h"

// iPad用
#import "RootViewController_iPad.h"
#import "SharpScanPrintAppDelegate.h"
#import <MobileCoreServices/UTCoreTypes.h>
// iPad用

#import <MailCore/MailCore.h>
#import <ImageIO/ImageIO.h>
#import <AssetsLibrary/AssetsLibrary.h>

#import "MailServerData.h"
#import "MailServerDataManager.h"
#import "SelectMailFolderCell.h"

#define EMAIL_LINE_COUNT 30 //初回に表示するメールの件数
#define EMAIL_LINE_SUBCOUNT 3 //self.emailLineNum.intValue　×　EMAIL_LINE_SUBCOUNT　までを一度に表示する最大値とする

#define CANCEL_BUTTON_TAG 10

@interface SelectMailViewController_iPad ()

@property (nonatomic,assign) BOOL isRotated;
@property (nonatomic,assign) BOOL isCanceled;
@property (nonatomic,assign) NSInteger connectionProgression;
@property (nonatomic,strong) NSString *alertTitle;
@property (nonatomic,strong) NSNumber *emailLineNum;
@property (nonatomic,assign) BOOL reloadFlag;
@property (nonatomic,assign) NSInteger tmpMailNum;
@property (nonatomic,assign) NSInteger tmpFilterSetting;
@end

@implementation SelectMailViewController_iPad
{
    NSString* pathDelimiter;
    BOOL isCompleteFirstViewDidApper;
}

@synthesize delegate;
@synthesize account;
@synthesize subFolders;
@synthesize inbox;
@synthesize messageList;
@synthesize listCount;
@synthesize isRotated;
@synthesize PrevViewID;
@synthesize bSetTitle; // iPad用 タイトル表示フラグ
@synthesize selectIndexPath; // iPad用 選択行
@synthesize lastScrollOffSet; // iPad用 スクロール位置
@synthesize imapConnectionAlert;
@synthesize m_pstrSelectFolder;
@synthesize previousOrientation;
@synthesize m_pMailList;
@synthesize rootDir;
@synthesize mArrSubFolder;
@synthesize bRootClassShow;
@synthesize nFolderCount;
@synthesize connectionProgression;

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
    messageList = nil;
    selectIndexPath = nil;
    self.reloadFlag = NO;
    self.isCanceled = NO;
    self.connectionProgression = 0;
    self.previousOrientation = [[UIDevice currentDevice] orientation];
    self.tableView.scrollEnabled = YES;
    isCompleteFirstViewDidApper = NO;
    [super viewDidLoad];
    
    // タイトル設定
    CGRect frame = CGRectMake(0, 0, 400, 44);
    UILabel* lblTitle = [[UILabel alloc]initWithFrame:frame];
    lblTitle.backgroundColor = [UIColor clearColor];
    lblTitle.textColor = NAVIGATION_TITLE_COLOR;
    lblTitle.font = [UIFont boldSystemFontOfSize:20];
    lblTitle.textAlignment = NSTextAlignmentCenter;
    lblTitle.text = S_TITLE_EMAIL_PRINT;
    lblTitle.adjustsFontSizeToFitWidth = YES;
    self.navigationItem.titleView = lblTitle;
    //self.navigationItem.title = S_TITLE_EMAIL_PRINT;

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didChangedOrientation:)
                                                 name:UIDeviceOrientationDidChangeNotification object:nil];
    
    
    // 戻るボタンの名称変更
    UIBarButtonItem * barItemBack = [UIBarButtonItem new];
    barItemBack.title = S_BUTTON_BACK;
    self.navigationItem.backBarButtonItem = barItemBack;
    
    // 閉じるボタンの生成
    closeBtn = [[UIBarButtonItem alloc] initWithTitle:S_BUTTON_CLOSE
                                                style:UIBarButtonItemStylePlain
                                               target:self
                                               action:@selector(cancelAction)];
    
    self.navigationItem.rightBarButtonItem = closeBtn;
    
    // Toolbar
    self.navigationController.toolbar.barStyle = TOOLBAR_BARSTYLE;
    
    // リフレッシュボタンの生成
    refreshBtn = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:S_ICON_MAILUPDATE]
                                                  style:UIBarButtonItemStylePlain
                                                 target:self
                                                 action:@selector(refreshBtnAction:)];
    // 取得件数ボタンの作成
    mailNumBtn = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:S_ICON_GET_MAIL_COUNT] style:UIBarButtonItemStylePlain target:self action:@selector(mailNumBtnAction:)];
    // フィルタリング設定ボタンの作成
    mailFilterBtn = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:S_ICON_MAIL_FILTER] style:UIBarButtonItemStylePlain target:self action:@selector(mailFilterBtnAction:)];

    //スペーサー
    UIBarButtonItem* flexSpacer = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    
    // ツールバーに追加
    NSArray *items = [NSArray arrayWithObjects:flexSpacer,refreshBtn, flexSpacer, mailNumBtn, flexSpacer, mailFilterBtn,flexSpacer,nil];
    self.toolbarItems = items;
    
    if(self.rootDir == nil)
    {
        m_pstrSelectFolder = @"INBOX";
    }else
    {
        m_pstrSelectFolder = self.rootDir;
    }
    
    if(bRootClassShow)
    {
        bRootClassShow = NO;
        m_pstrSelectFolder = @"";
        SelectMailViewController_iPad* pMailView;
        pMailView = [[SelectMailViewController_iPad alloc] init];
        pMailView.bRootClassShow = NO;
        pMailView.nFolderCount = self.nFolderCount + 1;
        pMailView.delegate = self.delegate;
//        // ナビゲーションバー左側にキャンセルボタンを設定
//        UIBarButtonItem* btnClose = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel
//                                                                                  target:self
//                                                                                  action:@selector(cancelAction)];
//        btnClose.tag = CANCEL_BUTTON_TAG;
//        self.navigationItem.leftBarButtonItem = btnClose;
        
        [self.navigationController pushViewController:pMailView animated:NO];
    }
    else
    {
        self.imapConnectionAlert = [self popupConnectingAlert];
    }
    pageNo_MaxUntilBefore = 0;
    
    MailServerDataManager* manager = [[MailServerDataManager alloc]init];
    MailServerData* mailServerData = [manager loadMailServerDataAtIndex:0];
    self.emailLineNum = [[NSNumber alloc]initWithInt:mailServerData.getNumber.intValue];
    self.tmpMailNum = mailServerData.getNumber.integerValue;
    self.tmpFilterSetting = mailServerData.filterSetting.integerValue;
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)viewWillAppear:(BOOL)animated
{
    [self SetHeaderView];
    [self.tableView reloadData];
    [super viewWillAppear:animated];
    
    [self.navigationController setToolbarHidden:NO animated:YES];
    
    // 選択状態解除
    [self.tableView deselectRowAtIndexPath:[self.tableView indexPathForSelectedRow] animated:YES];
    
    SharpScanPrintAppDelegate* pAppDelegate = (SharpScanPrintAppDelegate*)[[UIApplication sharedApplication] delegate];
    [pAppDelegate setPortraitMenuButton];
    
    if (selectIndexPath)
    {
        SharpScanPrintAppDelegate* pAppDelegate = (SharpScanPrintAppDelegate*)[[UIApplication sharedApplication] delegate];
        UINavigationController* pRootNavController = [pAppDelegate.splitViewController.viewControllers objectAtIndex:0];
        //左側のViewに設定されているクラスの名前を取得
        NSString* leftViewClassName = [pRootNavController.topViewController description];
        if (selectIndexPath != nil)
        {
            // 左側のViewにこのクラスが表示されている場合
            if([leftViewClassName isEqual:[self description]])
            {
                // 指定の行を選択状態
                [self.tableView selectRowAtIndexPath:selectIndexPath animated:YES scrollPosition:UITableViewScrollPositionNone];
                if(selectIndexPath.section)
                {
                    [self.tableView scrollToRowAtIndexPath:selectIndexPath atScrollPosition:UITableViewScrollPositionTop animated:YES];
                }
                else
                {
                    //0件の場合
                    [self.tableView setContentOffset:lastScrollOffSet];
                }
            }
        }
    }
}


- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    if(account == nil && isCompleteFirstViewDidApper == NO)
    {
        // 表示するメールの数の初期化
        maxNo = 0;
        pageNo = 1;

        if (self.imapConnectionAlert == nil) {
            self.imapConnectionAlert = [self popupConnectingAlert];
        }

        [self performSelectorInBackground:@selector(mailServerConnect) withObject:nil];
    }
    isCompleteFirstViewDidApper = YES;
}

- (void)viewDidDisappear:(BOOL)animated
{
    // アラートが出ているなら消しておく
    [self.imapConnectionAlert dismissViewControllerAnimated:YES completion:nil];
    
    [super viewDidDisappear:animated];
}

// iPad用
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // 横向きの場合
    if(interfaceOrientation == UIInterfaceOrientationLandscapeLeft || interfaceOrientation == UIInterfaceOrientationLandscapeRight)
    {
        // 縦向き表示時のメニューPopOverが表示されていたら閉じる
        [self dismissMenuPopOver:NO];
        // メニューボタンは削除
        [self setPortraitMenu:nil];
    }
    
    return YES;
}


-(void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)FromInterfaceOrientation
{
    if (FromInterfaceOrientation == UIInterfaceOrientationPortrait ||
        FromInterfaceOrientation == UIInterfaceOrientationPortraitUpsideDown)
	{
		// 縦向き
	}
	else
	{
		// 横向きから縦向きに変更
        //        if(self.subDir != nil)
        //        {
        //            // フォルダ階層遷移した為、メニューボタンは削除
        [self setPortraitMenu:nil];
        // 戻るボタンを表示
        UIBarButtonItem * barItemBack = [UIBarButtonItem new];
        barItemBack.title = S_BUTTON_BACK;
        self.navigationItem.backBarButtonItem = barItemBack;
        //        }
	}
}

#pragma mark - Table view data source

// テーブルビュー セクション数設定
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

// テーブルビュー セクション内の行数設定
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    //    // Return the number of rows in the section.
    NSInteger mln = 0;
    
    
    switch (section) {
        case 0:
        {
            if(self.isCanceled){
                
                //self.isCanceled = NO;
                break;
            }
            if ([self.mArrSubFolder count] == 0 &&
                [self.m_pMailList count] == 0) {
                // メールデータが取得できていない時
                break;
            }
            [self updateListCount];
            BOOL bVisibleNextMail = [self visibleGetNextMail];
            BOOL bVisiblePreviousMail = [self visibleGetPreviousMail];
            if(bVisibleNextMail && bVisiblePreviousMail)
            {
                mln = listCount + 2;
            }
            else if(bVisibleNextMail || bVisiblePreviousMail)
            {
                mln = listCount + 1;
            }else
            {
                mln = listCount;
            }
            //0件ではスクロールできなくする
            if(listCount == 0){
                self.tableView.scrollEnabled = NO;
            }else if(listCount > 0){
                self.tableView.scrollEnabled = YES;
            }
        }
            break;
        default:
            break;
    }
    return mln;
}

// テーブルビュー セクションのタイトル設定
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    if(self.m_pstrSelectFolder != nil)
    {
        return [NSString stringWithFormat:@"/%@" , self.m_pstrSelectFolder];
    }
    return @"/INBOX";
}

// テーブルビュー セル作成
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    @autoreleasepool {
        self.tableView.allowsSelection = YES;
//        NSString *CellIdentifier = [NSString stringWithFormat:@"Cell%02ld%02ld", (long)indexPath.section, (long)indexPath.row];
        NSString *CellIdentifier = @"Cell";
        
        // フォルダーが存在する場合、取得したフォルダーの数までフォルダー用のセルを表示する
        if([self.mArrSubFolder count] > 0 && [self.mArrSubFolder count] > indexPath.row)
        {
            CellIdentifier = [NSString stringWithFormat:@"%@_Fplder",CellIdentifier];
            SelectMailFolderCell *folderCell = (SelectMailFolderCell*)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
            if (!folderCell) {
                folderCell = [[SelectMailFolderCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
            }
            
            // フォルダーを表示する
            [folderCell setModel:[self.mArrSubFolder objectAtIndex:indexPath.row] hasDisclosure:TRUE];
            
            return folderCell;
            
        } //*TODO:前の%d件を取得する
        else if(indexPath.row == [self.mArrSubFolder count] && [self visibleGetPreviousMail])//フォルダーの数の次のセル　かつ　戻り件数がある場合
        {
            // セル作成
            CellIdentifier = [NSString stringWithFormat:@"%@_Previous",CellIdentifier];
           UITableViewCell *cell = (UITableViewCell*)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
            if (cell == nil)
            {
                cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
            }
            [cell.textLabel setFont:[UIFont systemFontOfSize:14]];
            [cell.textLabel setAdjustsFontSizeToFitWidth:TRUE];
            cell.textLabel.textAlignment = NSTextAlignmentCenter;
            cell.textLabel.text = [NSString stringWithFormat:S_EMAIL_INBOX_PREVIOUS, self.emailLineNum.intValue];
            
            return cell;
            
        }//*TODO:次の%d件を取得する
        else if((indexPath.row == listCount && [self visibleGetNextMail] && ![self visibleGetPreviousMail])
                || (indexPath.row == listCount+1 && [self visibleGetNextMail] && [self visibleGetPreviousMail]))//一番最後のセル　かつ　次の件数がある場合
        {
            // セル作成
            CellIdentifier = [NSString stringWithFormat:@"%@_Next",CellIdentifier];
            LOG(@"セルつくる3");
            UITableViewCell *cell = (UITableViewCell*)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
            if (cell == nil)
            {
                cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
            }
            if(!self.m_pMailList || self.m_pMailList.count == 0 ){
                return cell;
            }
            [cell.textLabel setFont:[UIFont systemFontOfSize:14]];
            [cell.textLabel setAdjustsFontSizeToFitWidth:TRUE];
            cell.textLabel.textAlignment = NSTextAlignmentCenter;
            cell.textLabel.text = [NSString stringWithFormat:S_EMAIL_INBOX_NEXT, self.emailLineNum.intValue];
            
            return cell;
        }
        else
        {
            CellIdentifier = [NSString stringWithFormat:@"%@_Message",CellIdentifier];
            MailDataCell *mailCell = (MailDataCell*)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
            if (mailCell == nil)
            {
                mailCell = [[MailDataCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
            }
            // メールを表示する
            
            // データ取得
            CTCoreMessage* aMessage= nil;
            
            // 表示するメールの最初のインデックスを取得する （取得キャンセル後の回転時には空のセルを返す）
            if( !self.m_pMailList || self.m_pMailList.count == 0 ||  indexPath.row >self.m_pMailList.count + self.mArrSubFolder.count ){
                self.tableView.allowsSelection = NO;
                CellIdentifier = [NSString stringWithFormat:@"%@_2",CellIdentifier];
                UITableViewCell *cell = (UITableViewCell*)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
                if (cell == nil)
                {
                    cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
                }
                return cell;
            }
            aMessage = [self.m_pMailList objectAtIndex:[self StartIndexRow:indexPath]];
            [mailCell setModel: aMessage hasDisclosure: TRUE];
            
            return mailCell;
        }
    }
}

// テーブルビュー 縦幅設定
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return N_HEIGHT_SEL_FILE;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if((indexPath.row == listCount && [self visibleGetNextMail] && ![self visibleGetPreviousMail])
       || (indexPath.row == listCount+1 && [self visibleGetNextMail] && [self visibleGetPreviousMail]))
    {
        [self getNextMail];
    }
    else if(indexPath.row == [self.mArrSubFolder count] && [self visibleGetPreviousMail])
    {
        [self getPreviousMail];
    }
    else{
        [self MoveView:indexPath];
    }
}

- (void)tableView:(UITableView *)tableView accessoryButtonTappedForRowWithIndexPath:(NSIndexPath *)indexPath
{
	@autoreleasepool
    {
        // アクセサリボタンの選択状態を解除するため、選択行を再読み込み
        [tableView reloadRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationNone];
        // 選択行を選択状態にする
        [tableView selectRowAtIndexPath:indexPath animated:NO scrollPosition:UITableViewScrollPositionNone];
        // 行選択イベント
        [self MoveView:indexPath];
        // 処理終了後にautoreleasePoolを解放
    }
}

- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event
{
    //    DLog(@"cancel");
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    //    DLog(@"began");
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    //    DLog(@"moved");
}

// 画面遷移
- (void)MoveView:(NSIndexPath *)nIndexPath
{
    [self.navigationController setToolbarHidden:YES animated:NO];
    // 選択したセルがフォルダーの場合
    if(nIndexPath.row < [mArrSubFolder count])
    {
        SelectMailViewController_iPad* pMailView;
        pMailView = [[SelectMailViewController_iPad alloc] init];
        
        if(self.rootDir == nil || [self.rootDir isEqualToString:@""])
        {
            pMailView.rootDir = [NSString stringWithFormat:@"%@",[self.mArrSubFolder objectAtIndex:nIndexPath.row]];
        }else{
            pMailView.rootDir = [NSString stringWithFormat:@"%@%@%@",self.rootDir ,pathDelimiter , [self.mArrSubFolder objectAtIndex:nIndexPath.row]];
        }
        pMailView.nFolderCount = self.nFolderCount + 1;
        pMailView.delegate = self.delegate;
        [self ChangeDetailView: pMailView didSelectRowAtIndexPath: nIndexPath];
    } else {
        // 遷移元画面から渡されたIDをもとに遷移先のViewControllerを決定する
        ShowMailViewController_iPad* pViewController = nil;
        
        pViewController = [[ShowMailViewController_iPad alloc] init];
        pViewController.messageListView = self;
        NSInteger messageId = [self StartIndexRow:nIndexPath];
        if (messageId >= 0) {
            pViewController.selectedMessage = [self.m_pMailList objectAtIndex:messageId];
            pViewController.uid = pViewController.selectedMessage.uid;
        }
        pViewController.m_pstrSelectedMail = self.m_pstrSelectFolder;
        pViewController.delegate = self.delegate;
        [self ChangeDetailView: pViewController didSelectRowAtIndexPath: nIndexPath];
    }
    //    // iPad用
    // 縦向き表示時のメニューPopOverが表示されていたら閉じる
    [self dismissMenuPopOver:YES];
}

// mail表示画面に遷移
-(void)MoveShowMailView:(NSDictionary *)info
{
    // mail表示画面に遷移
    ShowMailViewController_iPad* pViewController;
    pViewController = [[ShowMailViewController_iPad alloc] init];
    
    //画面遷移
    [self ChangeDetailView:pViewController didSelectRowAtIndexPath:nil];
    
}

// 詳細画面切換え
-(void)ChangeDetailView:(UIViewController*)pViewController didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    SharpScanPrintAppDelegate* pAppDelegate = (SharpScanPrintAppDelegate*)[[UIApplication sharedApplication] delegate];
    ////
    
    // 選択したセルがフォルダーの場合
    if(indexPath.row < [mArrSubFolder count])
    {
        [self.navigationController pushViewController:pViewController animated:YES];
    }else{

        if (pAppDelegate.IsPreview)
        {
            // 指定の行を選択状態
            [self.tableView selectRowAtIndexPath:selectIndexPath animated:NO scrollPosition:UITableViewScrollPositionNone];
            
            return;
        }
        
        if(selectIndexPath != nil)
        {
            // 選択
            selectIndexPath = indexPath;
            [self.tableView selectRowAtIndexPath:selectIndexPath animated:NO scrollPosition:UITableViewScrollPositionNone];
        }
        
        // 選択行保持
        NSUInteger newIndex[] = {indexPath.section, indexPath.row};
        selectIndexPath = [[NSIndexPath alloc] initWithIndexes:newIndex length:2];
        
        [self.navigationController pushViewController:pViewController animated:YES];
        
    }
}

//ダイアログのボタン押下時
-(void)alertButtonPushed:(UIAlertController *)alertController tagIndex:(NSInteger)tagIndex buttonIndex:(NSInteger)buttonIndex{
    [self alertButtonClicked:alertController tagIndex:tagIndex buttonIndex:buttonIndex];
    [self alertButtonDismiss:alertController tagIndex:tagIndex buttonIndex:buttonIndex];
}

-(void)alertButtonClicked:(UIAlertController *)alertController tagIndex:(NSInteger)tagIndex buttonIndex:(NSInteger)buttonIndex
{
    SharpScanPrintAppDelegate* appDelegate = (SharpScanPrintAppDelegate*)[[UIApplication sharedApplication] delegate];
    // 処理実行フラグoff
    appDelegate.IsRun = FALSE;
    
    if (tagIndex == 1) {
        [self cancelActionForConnectionAlert];
        NSOperationQueue *queue = [NSOperationQueue mainQueue];
        [queue addOperationWithBlock:^(){
            //            [self.imapConnectionAlert dismissWithClickedButtonIndex:0 animated:YES];
            // アラートを閉じる
            [self.imapConnectionAlert dismissViewControllerAnimated:YES completion:^{
            }];
            self.imapConnectionAlert = [self popupWaitAlert];
        }];
    } else if (tagIndex == 2) {
        [self cancelAction];
    }
}

-(void)alertButtonDismiss:(UIAlertController *)alertController tagIndex:(NSInteger)tagIndex buttonIndex:(NSInteger)buttonIndex
{
    // iPad用
    SharpScanPrintAppDelegate* appDelegate = (SharpScanPrintAppDelegate*)[[UIApplication sharedApplication] delegate];
    // iPad用　アラート消去時にリストを空にする
    if(self.isCanceled){
        maxNo = 0;
        [self removeMailList];
        [self.tableView reloadData];
        //0件ではスクロールできなくする
        self.tableView.scrollEnabled = NO;
    }
    self.isRotated = NO;
    // 処理実行フラグOFF
    appDelegate.IsRun = FALSE;
}

- (void)updateView:(UIViewController*) pViewController
{
    [self.navigationController pushViewController:pViewController animated:YES];
}

- (void)popRootView
{
    [self.navigationController popToRootViewControllerAnimated:YES];
}

// 縦表示時のメニューボタン設定
- (void)setPortraitMenu:(UIBarButtonItem *)barButtonItem
{
    if (self.navigationItem.leftBarButtonItem.tag == CANCEL_BUTTON_TAG) {
        // キャンセルボタンは関係ない
        return;
    }
    [self.navigationItem setLeftBarButtonItem:nil animated:YES];
    //    if (barButtonItem != nil && m_bSetTitle && self.subDir == nil)
    if (barButtonItem != nil && m_bSetTitle)
    {
        [self.navigationItem setLeftBarButtonItem:barButtonItem animated:YES];
    }
}

- (void) dismissMenuPopOver:(BOOL)bAnimated
{
    SharpScanPrintAppDelegate* pAppDelegate = (SharpScanPrintAppDelegate*)[[UIApplication sharedApplication] delegate];
    UINavigationController* pRootNavController = [pAppDelegate.splitViewController.viewControllers objectAtIndex:0];
    RootViewController_iPad* rootViewController = (RootViewController_iPad*)[pRootNavController.viewControllers objectAtIndex:0];
    
    // 縦向き表示時のメニューPopOverが表示されていたら閉じる
    [rootViewController dismissMenuPopOver:bAnimated];
}
//iPad用

// ヘッダー表示
- (void)SetHeaderView
{
}

- (void)mailServerConnect
{
    [self updateAlert:1];
    
    @autoreleasepool {
        CTCoreAccount* anAccount = [[CTCoreAccount alloc] init];
        MailServerDataManager* manager = [[MailServerDataManager alloc]init];
        MailServerData* mailServerData = [manager loadMailServerDataAtIndex:0];
        
        if (self.reloadFlag == YES) {
            if (self.tmpMailNum != MAIL_OPTION_TYPE_DEFAULT) {
                self.emailLineNum = @(self.tmpMailNum);
            }
            if (self.tmpFilterSetting != MAIL_OPTION_TYPE_DEFAULT) {
                mailServerData.filterSetting = @(self.tmpFilterSetting);
            }
        }
        if(self.isCanceled == YES){
            self.emailLineNum = 0;
            
        }
        NSOperationQueue *queue = [NSOperationQueue mainQueue];
        
        BOOL noError = NO;
        //self.isCanceled = NO;
        
        // メール設定画面でのアカウント名とパスワードが入力されているかチェックする
        if((mailServerData.accountName == nil || [mailServerData.accountName isEqualToString:@""])||(mailServerData.accountPassword == nil) || [mailServerData.accountPassword isEqualToString:@""])
        {
            [queue addOperationWithBlock:^(){
                [self popupSendingErrorAlert: [@"" stringByAppendingFormat: MSG_EMAIL_ACCOUNT_ERROR,SUBMSG_LOGINACCOUNT_ERR]];
            }];
            return;
        }
        else
        {
            if(account == nil)
            {
                NSString *decryptAccountName = mailServerData.accountName;
                if([decryptAccountName length] > 0)
                {
                    decryptAccountName = [CommonUtil decryptString:[CommonUtil base64Decoding:mailServerData.accountName] withKey:S_KEY_PJL];
                }
                NSString *decryptAccountPassword = mailServerData.accountPassword;
                if([decryptAccountPassword length] > 0)
                {
                    decryptAccountPassword = [CommonUtil decryptString:[CommonUtil base64Decoding:mailServerData.accountPassword] withKey:S_KEY_PJL];
                }
                
                [self updateAlert:15];
                NSDictionary *dicIPAddr = [CommonUtil getIPAddrDicForComm:mailServerData.hostname port:mailServerData.imapPortNo];
                NSString *strIPaddr = [dicIPAddr objectForKey:S_TARGET_IPADDRESS_DIC_KEY];
#ifdef IPV6_VALID
                if ([CommonUtil isValidIPv6StringFormat:strIPaddr]) {
                    // IPv6アドレスの場合は非省略形式にする
                    strIPaddr = [CommonUtil convertOmitIPv6ToFullIPv6:strIPaddr];
                }
#endif
                if ([strIPaddr length] < 1) {
                    noError = NO;
                }
                else {
                    noError = [anAccount connectToServer: strIPaddr
                                                    port: (int)[mailServerData.imapPortNo integerValue]
                                          connectionType: (mailServerData.bSSL)?CONNECTION_TYPE_TLS:CONNECTION_TYPE_PLAIN
                                                authType: IMAP_AUTH_TYPE_PLAIN
                                                   login: decryptAccountName
                                                password: decryptAccountPassword
                               ];
                }
                if(noError) {
                    account = anAccount;
                }
            }
            else{
                [self updateAlert:15];
                noError = YES;
            }
            
            if(noError)
            {
                // OSのバージョンを取得
                float osVersion = [[[UIDevice currentDevice] systemVersion] floatValue];
                [self updateAlert:30];
                subFolders = [account subscribedFolders];
                
                if (subFolders == nil) {
                    LOG(@"フォルダーデータ取得失敗");
                    [self timeOutAction];
                    return;
                }
                
                self.mArrSubFolder = [[NSMutableArray array]init];
                
                // フォルダー名でソート
                [self updateAlert:45];
                NSArray *sortArray = [subFolders allObjects];
                NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:nil ascending:YES];
                NSArray *subFoldersSort = [sortArray sortedArrayUsingDescriptors:@[sortDescriptor]];
                
                for(__strong NSString *nstr in subFoldersSort)
                {
                    @autoreleasepool {
                        // iOS4.3以前でUTF7_IMAPをデコード出来ないバグに対応
                        if(osVersion < 5.0f){
                            // フォルダー名を再取得
                            nstr = [CommonUtil FromModifiedUTF7String:nstr];
                        }
                        
                        // フォルダーの孫階層まで再帰的に取得してくるため、選択階層のフォルダのみ取得する
                        if (account.pathDelimiter) {
                            NSArray *mCompArray = [nstr componentsSeparatedByString:account.pathDelimiter];
                            //                NSArray *mRootArray = [m_pstrSelectFolder componentsSeparatedByString:account.pathDelimiter];
                            if([mCompArray count] == self.nFolderCount)
                            {
                                self.rootDir = m_pstrSelectFolder;
                                if([mCompArray count] == 1 || ([mCompArray count] > 1 && [nstr hasPrefix:self.rootDir])){
                                    //
                                    // 選択階層のフォルダー名を取得し、保存
                                    [self.mArrSubFolder addObject:[mCompArray lastObject]];
                                }
                                //                }
                            }
                        }
                    }
                }
                inbox = [account folderWithPath:m_pstrSelectFolder];
                [self updateAlert:60];
                
                NSUInteger totalMessages = 0;
                [inbox totalMessageCount:&totalMessages];
                NSUInteger fromNum = 0;
                NSUInteger toNum = 0;
                maxNo = totalMessages;
                
                NSInteger maxListcount = self.emailLineNum.intValue * pageNo;
                fromNum = maxListcount - self.emailLineNum.intValue;
                if (maxNo > maxListcount) {
                    toNum = maxListcount;
                } else {
                    toNum = maxNo;
                }
                
                //***　絞り込み検索検証
                NSPredicate *predicate1 = nil;
                NSDate *date = nil;
                NSPredicate *predicate2 = nil;
                NSPredicate *predicate = nil;
                NSArray *uids = nil;
                
                switch (mailServerData.filterSetting.intValue) {
                    case 0:
                    {
                        date = [NSDate dateWithTimeIntervalSince1970:0];
                        predicate1 = [NSPredicate predicateWithFormat:@"%K > %@",@"INTERNALDATE", date];
                        
                        uids = [inbox messagesUIDsMatchingPredicate:predicate1];
                        if (toNum > uids.count) {
                            toNum = uids.count;
                        }
                        NSMutableArray *arr = [[NSMutableArray alloc]init];
                        NSIndexSet *sets = [NSIndexSet indexSetWithIndexesInRange:NSMakeRange(fromNum, toNum-fromNum)];
                        [arr addObjectsFromArray:[uids objectsAtIndexes:sets]];
                        
                        if ([arr count] > 0) {
                            messageList = [inbox messagesFromUID:arr withFetchAttributes:CTFetchAttrEnvelope];
                        }
                    }
                        break;
                    case 1:
                    {
                        predicate1 = [NSPredicate predicateWithFormat:@"SEEN = 0"]; // 未読のみ
                        uids = [inbox messagesUIDsMatchingPredicate:predicate1];
                        if (toNum > uids.count) {
                            toNum = uids.count;
                        }
                        NSMutableArray *arr = [[NSMutableArray alloc]init];
                        NSIndexSet *sets = [NSIndexSet indexSetWithIndexesInRange:NSMakeRange(fromNum, toNum-fromNum)];
                        [arr addObjectsFromArray:[uids objectsAtIndexes:sets]];
                        
                        if ([arr count] > 0) {
                            messageList = [inbox messagesFromUID:arr withFetchAttributes:CTFetchAttrEnvelope];
                        }
                    }
                        break;
                    case 2:
                    {
                        //date = [NSDate zeroTimeDate:[NSDate date]];
                        date = [NSDate dateWithTimeIntervalSinceNow:-1*24*60*60]; // 30日前(マイナスを指定する事で過去に)
                        predicate1 = [NSPredicate predicateWithFormat:@"%K > %@",@"INTERNALDATE", date]; // 今日のメール
                        uids = [inbox messagesUIDsMatchingPredicate:predicate1];
                        if (toNum > uids.count) {
                            toNum = uids.count;
                        }
                        NSMutableArray *arr = [[NSMutableArray alloc]init];
                        NSIndexSet *sets = [NSIndexSet indexSetWithIndexesInRange:NSMakeRange(fromNum, toNum-fromNum)];
                        [arr addObjectsFromArray:[uids objectsAtIndexes:sets]];
                        
                        if ([arr count] > 0) {
                            messageList = [inbox messagesFromUID:arr withFetchAttributes:CTFetchAttrEnvelope];
                        }
                    }
                        break;
                    case 3:
                    {
                        date = [NSDate dateWithTimeIntervalSinceNow:-30*24*60*60]; // 30日前(マイナスを指定する事で過去に)
                        predicate1 = [NSPredicate predicateWithFormat:@"%K > %@",@"INTERNALDATE", date];
                        uids = [inbox messagesUIDsMatchingPredicate:predicate1];
                        if (toNum > uids.count) {
                            toNum = uids.count;
                        }
                        NSMutableArray *arr = [[NSMutableArray alloc]init];
                        NSIndexSet *sets = [NSIndexSet indexSetWithIndexesInRange:NSMakeRange(fromNum, toNum-fromNum)];
                        [arr addObjectsFromArray:[uids objectsAtIndexes:sets]];
                        
                        if ([arr count] > 0) {
                            messageList = [inbox messagesFromUID:arr withFetchAttributes:CTFetchAttrEnvelope];
                        }
                    }
                        break;
                    default:
                        // 設定されていない場合があるため
                        date = [NSDate dateWithTimeIntervalSince1970:0];
                        predicate1 = [NSPredicate predicateWithFormat:@"%K > %@",@"INTERNALDATE", date];
                        
                        uids = [inbox messagesUIDsMatchingPredicate:predicate1];
                        if (toNum > uids.count) {
                            toNum = uids.count;
                        }
                        NSMutableArray *arr = [[NSMutableArray alloc]init];
                        NSIndexSet *sets = [NSIndexSet indexSetWithIndexesInRange:NSMakeRange(fromNum, toNum-fromNum)];
                        [arr addObjectsFromArray:[uids objectsAtIndexes:sets]];
                        
                        if ([arr count] > 0) {
                            messageList = [inbox messagesFromUID:arr withFetchAttributes:CTFetchAttrEnvelope];
                        }
                        break;
                }
                LOG(@"predicate1:%@",predicate1);
                LOG(@"predicate2:%@",predicate2);
                LOG(@"predicate:%@",predicate);
                LOG(@"count:%lu",(unsigned long)[messageList count]);
                
                for (CTCoreMessage *cm in messageList) {//ログ用
                    // 日付のフォーマット指定
                    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
                    [formatter setLocale:[NSLocale systemLocale]];        // 12時間表示にならないように
                    [formatter setTimeZone:[NSTimeZone systemTimeZone]];  // localeを再設定する。
                    [formatter setDateFormat:@"yyyy/MM/dd HH:mm:ss"];
                    
                    LOG(@"Message:%@",[formatter stringFromDate:[cm senderDate]]);
                }
                
                //　絞り込んでいるのでmaxNoを更新
                if (uids.count < maxNo) {
                    maxNo = uids.count;
                }
                
                //***
                self.connectionProgression = 75;
                // ソート
                [self updateAlert:75];
                if (messageList.count) {
                    self.m_pMailList = [self sortTimeStamp:messageList];
                }

                if (self.isCanceled == NO) {
                    [self performSelectorOnMainThread:@selector(refreshDisplay) withObject:nil waitUntilDone:NO];
                }
                
                if(inbox) {
                    [inbox disconnect];
                    inbox = nil;
                }
            }
            else
            {
                if (self.isCanceled == NO) {
                    [queue addOperationWithBlock:^(){
                        // アラートを閉じる
                        [self.imapConnectionAlert dismissViewControllerAnimated:YES completion:^{
                        }];
                        [self popupSendingErrorAlertError:anAccount.lastError];
                    }];
                    return;
                } else {
                    // キャンセル
                    [self timeOutAction];
                    return;
                }
            }
        }
        [self updateAlert:100];
        
        [queue addOperationWithBlock:^(){
            // アラートを閉じる
            [self.imapConnectionAlert dismissViewControllerAnimated:YES completion:^{
            }];
        }];
    }
    if(self.isCanceled){
        //0件ではスクロールできなくする
        [self.m_pMailList removeAllObjects];
        [self.mArrSubFolder removeAllObjects];
        self.tableView.scrollEnabled = NO;
    }
    // テーブルを更新
    dispatch_sync(dispatch_get_main_queue(), ^{
        [self.tableView reloadData];
    });
    if(self.imapConnectionAlert){            //現在出ているアラートを消す
        dispatch_sync(dispatch_get_main_queue(), ^{
            // アラートを閉じる
            [self.imapConnectionAlert dismissViewControllerAnimated:YES completion:^{
            }];
        });
    }
    self.isRotated = NO;
    self.isCanceled = NO;
    connectionProgression = 0;
    if(account != nil) {
        pathDelimiter = account.pathDelimiter;
        [account disconnect];
        account = nil;
    }
}

// タイムアウトの処理
- (void) timeOutAction {
    //現在出ているアラートを消す
    dispatch_sync(dispatch_get_main_queue(), ^{
        // アラートを閉じる
        [self.imapConnectionAlert dismissViewControllerAnimated:YES completion:^{
            if (self.isCanceled == NO) {
                // サーバー接続に失敗しました。を表示
                [self popupSendingErrorAlertError:nil];
            }
            self.account = nil;
            // メールデータを削除
            [self removeMailList];
            // テーブルを更新
            [self.tableView reloadData];
            
            self.isCanceled = NO;
        }];
    });
}

- (void)updateAlert:(int)p {
    //キャンセル時のアラートにはパーセント表示しない
    if(self.isCanceled){
        return;
    }

    NSOperationQueue *queue = [NSOperationQueue mainQueue];
    [queue addOperationWithBlock:^(){
        if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0) {
            self.alertTitle = [NSString stringWithFormat:@"%@ %d%%",MSG_WAIT,p];
        } else {
            self.alertTitle = [NSString stringWithFormat:@"%@ %d%%\n\n\n\n",MSG_WAIT,p];
        }
        [self.imapConnectionAlert setMessage:self.alertTitle];
    }];
}

// リフレッシュボタン
- (void)refreshDisplay
{
    [self SetHeaderView];
    
    // 選択状態解除
    [self.tableView deselectRowAtIndexPath:[self.tableView indexPathForSelectedRow] animated:YES];
    
    SharpScanPrintAppDelegate* pAppDelegate = (SharpScanPrintAppDelegate*)[[UIApplication sharedApplication] delegate];
    [pAppDelegate setPortraitMenuButton];
    
    if (selectIndexPath)
    {
        if(selectIndexPath.section)
        {
            // 指定の位置までスクロール
            [self.tableView scrollToRowAtIndexPath:selectIndexPath atScrollPosition:UITableViewScrollPositionTop animated:YES];
        }
        else
        {
            //0件の場合
            [self.tableView setContentOffset:lastScrollOffSet];
        }
    }
}

-(ExAlertController*)popupConnectingAlert
{
    SharpScanPrintAppDelegate* appDelegate = (SharpScanPrintAppDelegate*)[[UIApplication sharedApplication] delegate];
    // 処理実行フラグON
    appDelegate.IsRun = TRUE;

    self.alertTitle = MSG_WAIT;
    ExAlertController *tmpAlert = [self makeTmpExAlert:nil message:self.alertTitle cancelBtnTitle:MSG_BUTTON_CANCEL okBtnTitle:nil tag:1 showFlg:YES];
    return tmpAlert;
}

-(void)popupSendingErrorAlertError:(NSError*) conError
{
    // アラートを閉じる
    [self.imapConnectionAlert dismissViewControllerAnimated:YES completion:^{
        SharpScanPrintAppDelegate* appDelegate = (SharpScanPrintAppDelegate*)[[UIApplication sharedApplication] delegate];
        // 処理実行フラグON
        appDelegate.IsRun = TRUE;
        
        [[NSOperationQueue mainQueue] addOperationWithBlock:^(){
            
            NSInteger tmpTag = 0;
            NSString *tmpBtnTitle = MSG_BUTTON_OK;
            if (conError) {
                tmpTag = 2;
                tmpBtnTitle = S_BUTTON_CLOSE;
            }
            [self showTmpExAlert:nil message:[self mailCoreErrorStringFromError: conError] cancelBtnTitle:tmpBtnTitle okBtnTitle:nil tag:tmpTag showFlg:YES];
        }];
    }];
    
}

-(void)popupSendingErrorAlert:(NSString*) errorMessage
{
    // アラートを閉じる
    [self.imapConnectionAlert dismissViewControllerAnimated:YES completion:^{
        
        SharpScanPrintAppDelegate* appDelegate = (SharpScanPrintAppDelegate*)[[UIApplication sharedApplication] delegate];
        // 処理実行フラグON
        appDelegate.IsRun = TRUE;
        
        [[NSOperationQueue mainQueue] addOperationWithBlock:^(){
            
            [self showTmpExAlert:nil message:errorMessage cancelBtnTitle:S_BUTTON_CLOSE okBtnTitle:nil tag:3 showFlg:YES];
        }];
    }];
    
}

-(ExAlertController *)popupWaitAlert{
    self.alertTitle = [NSString stringWithFormat:MSG_WAIT];
    ExAlertController *tmpAlert = [self makeTmpExAlert:nil message:self.alertTitle cancelBtnTitle:nil okBtnTitle:nil tag:1 showFlg:YES];
    return tmpAlert;
}

- (NSString*) mailCoreErrorStringFromError:(NSError*)errCode
{
    NSString *description = MSG_EMAIL_CONNECT_ERROR;
    return description;
}

- (void)refreshList{
    // 表示するメールの数の初期化
    maxNo = 0;
    pageNo = 1;
    pageNo_MaxUntilBefore = 0;
    self.isCanceled =NO;
    self.tableView.scrollEnabled = YES;
    
    // しばおま表示
    self.imapConnectionAlert = [self popupConnectingAlert];
    [self performSelectorInBackground:@selector(mailServerDisconnectAndConnect) withObject:nil];
}
// リフレッシュボタン押下時のアクション
- (void)refreshBtnAction:(id)sender
{
    self.tableView.scrollEnabled = YES;
    if(self.connectionProgression > 74){
        return;
    }
    if (self.optionPopoverController.popoverVisible) {
        [self.optionPopoverController dismissPopoverAnimated:YES];
    }else{
        // 表示するメールの数の初期化
        maxNo = 0;
        pageNo = 1;
        pageNo_MaxUntilBefore = 0;
        self.isCanceled = NO;
        
        // しばおま表示
        self.imapConnectionAlert = [self popupConnectingAlert];
        [self performSelectorInBackground:@selector(mailServerDisconnectAndConnect) withObject:nil];
    }
}

// メールサーバとの切断後、再接続します。
- (void)mailServerDisconnectAndConnect
{
    if (self.account) {
        //[self.account disconnect];
        
        MailServerDataManager* manager = [[MailServerDataManager alloc]init];
        MailServerData* mailServerData = [manager loadMailServerDataAtIndex:0];
        if (self.tmpMailNum != MAIL_OPTION_TYPE_DEFAULT) {
            self.emailLineNum = @(self.tmpMailNum);
        }
        if (self.tmpFilterSetting != MAIL_OPTION_TYPE_DEFAULT) {
            mailServerData.filterSetting = @(self.tmpFilterSetting);
        }
        //self.account = nil;
    }
    
    // キャンセルされたら再取得には行かない
    if(self.isCanceled)
    {
        return;
    }
    
    [self mailServerConnect];
}

// 取得件数ボタン押下時のアクション
- (void)mailNumBtnAction:(id)sender {
    if(self.connectionProgression > 74){
        return;
    }
    if (self.optionPopoverController.popoverVisible) {
        [self.optionPopoverController dismissPopoverAnimated:YES];
    } else {
        OptionChangeTableViewController_iPad *vc = [[OptionChangeTableViewController_iPad alloc]initWithType:MAIL_OPTION_TYPE_1 withIndex:self.tmpMailNum];
        vc.delegate = self;
        UINavigationController *nv = [[UINavigationController alloc]initWithRootViewController:vc];
        self.optionPopoverController = [[UIPopoverController alloc]initWithContentViewController:nv];
        self.optionPopoverController.delegate = self;
        [self.optionPopoverController presentPopoverFromBarButtonItem:mailNumBtn permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
    }
}

// フィルタリング設定ボタン押下時のアクション
- (void)mailFilterBtnAction:(id)sender {
    if(self.connectionProgression > 74){
        return;
    }
    if (self.optionPopoverController.popoverVisible) {
        [self.optionPopoverController dismissPopoverAnimated:YES];
    } else {
        OptionChangeTableViewController_iPad *vc = [[OptionChangeTableViewController_iPad alloc]initWithType:MAIL_OPTION_TYPE_2 withIndex:self.tmpFilterSetting];
        vc.delegate = self;
        UINavigationController *nv = [[UINavigationController alloc]initWithRootViewController:vc];
        self.optionPopoverController = [[UIPopoverController alloc]initWithContentViewController:nv];
        self.optionPopoverController.delegate = self;
        [self.optionPopoverController presentPopoverFromBarButtonItem:mailFilterBtn permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
    }
}

- (void)popoverControllerDidDismissPopover:(UIPopoverController *)popoverController {
    [self.optionPopoverController dismissPopoverAnimated:YES];
}

- (void)popoverController:(UIPopoverController *)popoverController willRepositionPopoverToRect:(inout CGRect *)rect inView:(inout UIView *__autoreleasing *)view {
    [self.optionPopoverController dismissPopoverAnimated:YES];
}

- (void)cancelBtnPushed {
    [self.optionPopoverController dismissPopoverAnimated:YES];
}

- (void)mailNumChanged:(NSInteger)value {
    [self.optionPopoverController dismissPopoverAnimated:YES];
    self.reloadFlag = YES;
    self.tmpMailNum = value;
    [self.m_pMailList removeAllObjects];
    [self refreshList];
}

- (void)filterChanged:(NSInteger)value {
    [self.optionPopoverController dismissPopoverAnimated:YES];
    self.reloadFlag = YES;
    self.tmpFilterSetting = value;
    [self.m_pMailList removeAllObjects];
    [self refreshList];
}

// メールを日時でソートする
-(NSMutableArray*)sortTimeStamp:(NSArray*)array
{
    // リスト追加
    NSMutableArray *copiedArray = [self.m_pMailList mutableCopy];

    if (copiedArray == nil || pageNo_MaxUntilBefore == 0) {
        copiedArray = [[NSMutableArray alloc]initWithArray:array];
    }else{
        [copiedArray addObjectsFromArray:array];
    }
    // 日付でソート
    [copiedArray sortUsingComparator: ^(id obj1, id obj2){
        return [[obj2 senderDate] compare:[obj1 senderDate]];
    }];
    
    return copiedArray;
}

-(void)removeMailList{
    [self.m_pMailList removeAllObjects];
    [self.mArrSubFolder removeAllObjects];
}

// 次のメールを取得する
-(void)getNextMail
{
    pageNo++;
    
    if (pageNo_MaxUntilBefore >= pageNo) {
        [self.tableView reloadData];
    }else{
        // しばおま表示
        self.imapConnectionAlert = [self popupConnectingAlert];
        [self performSelectorInBackground:@selector(mailServerConnect) withObject:nil];
        pageNo_MaxUntilBefore = pageNo;
    }
}

// 前のメールを取得する
-(void)getPreviousMail
{
    pageNo--;
    
    [self.tableView reloadData];
}

// 次のメールを取得するを表示するか判定する
-(BOOL)visibleGetNextMail
{
    // 表示可能なメールがある場合
    if(maxNo - (pageNo * self.emailLineNum.intValue) > 0)
    {
        return YES;
    }else
    {
        return NO;
    }
}

// 前のメールを取得するを表示するか判定する
-(BOOL)visibleGetPreviousMail
{
    if(pageNo > 3)
    {
        return YES;
    }else
    {
        return NO;
    }
}

-(void)updateListCount
{
    NSInteger maxListcount = self.emailLineNum.intValue * pageNo;
    
    // 表示するメールの最初のインデックスを取得する
    NSInteger nStartIndex = (pageNo - EMAIL_LINE_SUBCOUNT) * self.emailLineNum.intValue;
    if(nStartIndex < 0)
    {
        nStartIndex = 0;
    }
    
    // メールの数の最大値を保存
    if(maxNo > maxListcount)
    {
        if(pageNo > EMAIL_LINE_SUBCOUNT)
        {
            // 表示件数を超えている場合
            listCount = self.emailLineNum.intValue * EMAIL_LINE_SUBCOUNT + [self.mArrSubFolder count];
        }
        else{
            // 表示件数以内の場合
            listCount = maxListcount + [self.mArrSubFolder count];
        }
    }else{
        if(pageNo > EMAIL_LINE_SUBCOUNT)
        {
            // 表示件数を超えている場合
            listCount = maxNo - nStartIndex + [self.mArrSubFolder count];
        }else
        {
            // 表示件数以内の場合
            listCount = maxNo + [self.mArrSubFolder count];
        }
    }
}

// キャンセルし画面を閉じる
- (void)cancelAction
{
    if(delegate){
        if([delegate respondsToSelector:@selector(selectMail:didSelectMailSuccess:)]){
            // デリゲートメソッドの呼び出し(モーダルビューも閉じる)
            [delegate selectMail:self didSelectMailSuccess:NO];
        }
    }else {
        NSNotification *n = [NSNotification notificationWithName:NK_CLOSE_BUTTON_PUSHED object:self];
        NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
        [nc postNotification:n];
    }
    [self.account disconnect];
}

// 接続中のキャンセル処理
- (void)cancelActionForConnectionAlert {
    self.isCanceled = YES;
    if(self.connectionProgression > 74){
        return;
    }
    NSOperationQueue *queue = [NSOperationQueue mainQueue];
    [queue addOperationWithBlock:^(){
        // アラートを閉じる
        [self.imapConnectionAlert dismissViewControllerAnimated:YES completion:^{
        }];
        self.imapConnectionAlert = [self popupWaitAlert];
    }];
}

// 選択されたメールのインデックスを取得する
-(NSInteger)StartIndexRow:(NSIndexPath*)index
{
    // 表示するメールの最初のインデックスを取得する
    NSInteger nStartIndex = (pageNo - EMAIL_LINE_SUBCOUNT) * self.emailLineNum.intValue;
    if(nStartIndex < 0)
    {
        nStartIndex = 0;
    }
    
    NSInteger nMailCount = index.row - [self.mArrSubFolder count];
    if([self visibleGetPreviousMail])
    {
        nMailCount--;
    }
    
    return nStartIndex + nMailCount;
}

- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration {
    [self.optionPopoverController dismissPopoverAnimated:NO];
}
- (void)didChangedOrientation:(NSNotification *)notification
{
    float osVersion = [[[UIDevice currentDevice] systemVersion] floatValue];
    if(osVersion < 8.0){
        return;
    }
    UIDeviceOrientation orientation = [(UIDevice*)[notification object] orientation];
    switch (orientation) {
            
        case UIDeviceOrientationPortrait:
            // iPhoneを縦にして、ホームボタンが下にある状態
            break;
            
        case UIDeviceOrientationPortraitUpsideDown:
            // iPhoneを縦にして、ホームボタンが上にある状態
            break;
            
        case UIDeviceOrientationLandscapeLeft:
            // iPhoneを横にして、ホームボタンが左にある状態
            break;
            
        case UIDeviceOrientationLandscapeRight:
            // iPhoneを横にして、ホームボタンが右にある状態
            break;
        case UIDeviceOrientationUnknown:
            // 向きが分からない状態
            return;
            
        case UIDeviceOrientationFaceUp:
            // iPhoneの液晶面を大空に向けた状態
            return;
            
        case UIDeviceOrientationFaceDown:
            // iPhoneの液晶面を大地に向けた状態
            return;
        default:
            break;
    }
    if(orientation != self.previousOrientation &&(self.previousOrientation != UIDeviceOrientationUnknown || self.previousOrientation != UIDeviceOrientationFaceUp || self.previousOrientation != UIDeviceOrientationFaceDown)){
        self.isRotated = YES;
        if (self.optionPopoverController.popoverVisible) {
            [self.optionPopoverController dismissPopoverAnimated:YES];
        }
    }
    self.previousOrientation = orientation;
}

// アラート表示
- (void) showTmpExAlert:(NSString*)pstrTitle
                message:(NSString*)pstrMsg
         cancelBtnTitle:(NSString*)cancelBtnTitle
             okBtnTitle:(NSString*)okBtnTitle
                    tag:(NSInteger)tag
                showFlg:(BOOL)showFlg
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
    
    if (showFlg) {
        // アラート表示処理
        [self presentViewController:tmpAlert animated:YES completion:nil];
    }
}

// アラート表示
- (ExAlertController*) makeTmpExAlert:(NSString*)pstrTitle
                              message:(NSString*)pstrMsg
                       cancelBtnTitle:(NSString*)cancelBtnTitle
                           okBtnTitle:(NSString*)okBtnTitle
                                  tag:(NSInteger)tag
                              showFlg:(BOOL)showFlg
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
    
    if (showFlg) {
        // アラート表示処理
        [self presentViewController:tmpAlert animated:YES completion:nil];
    }
    return tmpAlert;
}

@end
