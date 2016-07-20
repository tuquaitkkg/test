
#import "SelectMailViewController.h"
#import "Define.h"
#import "ShowMailViewController.h"
#import "SendMailPictViewController.h"
#import "SendExSitePictViewController.h"
#import "SharpScanPrintAppDelegate.h"
#import "ScanDataCell.h"
#import <MailCore/MailCore.h>
#import <ImageIO/ImageIO.h>
#import <AssetsLibrary/AssetsLibrary.h>
#import "MailServerData.h"
#import "MailServerDataManager.h"
#import "SelectMailFolderCell.h"

#define EMAIL_LINE_COUNT 30 //初回に表示するメールの件数
#define EMAIL_LINE_SUBCOUNT 3 //self.emailLineNum.intValue　×　EMAIL_LINE_SUBCOUNT　までを一度に表示する最大値とする

@interface SelectMailViewController ()

@property (nonatomic,assign) BOOL isCanceled;
@property (nonatomic,strong) NSString *alertTitle;
@property (nonatomic,strong) NSNumber *emailLineNum;
@property (nonatomic,assign) BOOL reloadFlag;
@property (nonatomic,assign) NSInteger tmpMailNum;
@property (nonatomic,assign) NSInteger tmpFilterSetting;
@property (nonatomic,assign) NSInteger connectionProgression;
@end

@implementation SelectMailViewController
{
    NSString* pathDelimiter;
    BOOL isCompleteFirstViewDidApper;
}

@synthesize account;
@synthesize subFolders;
@synthesize inbox;
@synthesize messageList;
@synthesize listCount;

@synthesize PrevViewID;
@synthesize bSetTitle; // iPad用 タイトル表示フラグ
@synthesize selectIndexPath; // iPad用 選択行
@synthesize lastScrollOffSet; // iPad用 スクロール位置
@synthesize imapConnectionAlert;
@synthesize m_pstrSelectFolder;

@synthesize m_pMailList;
@synthesize rootDir;
@synthesize mArrSubFolder;
@synthesize bRootClassShow;
@synthesize nFolderCount;
@synthesize connectionProgression;
@synthesize delegate;

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self)
    {
        // Custom initialization
    }
    return self;
}

- (void)dealloc
{
    self.delegate = nil;
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
    NSArray *items = [NSArray arrayWithObjects:flexSpacer,refreshBtn,flexSpacer ,mailNumBtn,flexSpacer ,mailFilterBtn,flexSpacer,nil];
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
        SelectMailViewController* pMailView;
        pMailView = [[SelectMailViewController alloc] init];
        pMailView.bRootClassShow = NO;
        pMailView.nFolderCount = self.nFolderCount + 1;
        pMailView.rootDir = self.rootDir;
        pMailView.delegate = self.delegate;
        
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
    [super viewWillAppear:animated];
    
    [self.navigationController setToolbarHidden:NO animated:YES];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    if(account == nil && selectIndexPath == nil && isCompleteFirstViewDidApper == NO)
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

#pragma mark - Table view data source

// テーブルビュー セクション数設定
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

// テーブルビュー セクション内の行数設定
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
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
            //0件ではスクロールできなくする
            }if(listCount == 0){
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

// ヘッダー表示前にフォントを設定
- (void)tableView:(UITableView *)tableView willDisplayHeaderView:(UIView *)view forSection:(NSInteger)section
{
    UITableViewHeaderFooterView *heView = (UITableViewHeaderFooterView *)view;
    heView.textLabel.font = [UIFont systemFontOfSize:N_TABLE_FONT_SIZE_HEADER];
}

// テーブルビュー セル作成
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
//    NSString *CellIdentifier = [NSString stringWithFormat:@"Cell%02ld%02ld", (long)indexPath.section, (long)indexPath.row];
    NSString *CellIdentifier = @"Cell";
    LOG(@"%@",CellIdentifier);
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
        
        // データ取得
        CTCoreMessage* aMessage= nil;
        
        if (self.m_pMailList.count > [self StartIndexRow:indexPath]) {
            // 表示するメールの最初のインデックスを取得する
            aMessage = [self.m_pMailList objectAtIndex:[self StartIndexRow:indexPath]];
        }
        [mailCell setModel: aMessage hasDisclosure: TRUE];
        
        return mailCell;
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
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
}

// 画面遷移
- (void)MoveView:(NSIndexPath *)nIndexPath
{
    [self.navigationController setToolbarHidden:YES animated:NO];
    
    // 遷移元画面から渡されたIDをもとに遷移先のViewControllerを決定する
    ShowMailViewController* pViewController = nil;
    
    pViewController = [[ShowMailViewController alloc] init];
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

// mail表示画面に遷移
-(void)MoveShowMailView:(NSDictionary *)info
{
    // mail表示画面に遷移
    ShowMailViewController* pViewController;
    pViewController = [[ShowMailViewController alloc] init];
    
    //画面遷移
    [self ChangeDetailView:pViewController didSelectRowAtIndexPath:nil];
}

// 詳細画面切換え
-(void)ChangeDetailView:(UIViewController*)pViewController didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // 選択したセルがフォルダーの場合
    if(indexPath.row < [mArrSubFolder count])
    {
        SelectMailViewController* pMailView;
        pMailView = [[SelectMailViewController alloc] init];
        
        if(self.rootDir == nil || [self.rootDir isEqualToString:@""])
        {
            pMailView.rootDir = [NSString stringWithFormat:@"%@",[self.mArrSubFolder objectAtIndex:indexPath.row]];
        }else{
            pMailView.rootDir = [NSString stringWithFormat:@"%@%@%@",self.rootDir ,pathDelimiter , [self.mArrSubFolder objectAtIndex:indexPath.row]];
            
        }
        pMailView.nFolderCount = self.nFolderCount + 1;
        pMailView.delegate = self.delegate;
        
        [self.navigationController pushViewController:pMailView animated:YES];
    } else {
        
        if (selectIndexPath != nil)
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
    } else if (tagIndex == 2) {
        [self cancelAction];
    }
}

-(void)alertButtonDismiss:(UIAlertController *)alertController tagIndex:(NSInteger)tagIndex buttonIndex:(NSInteger)buttonIndex
{
    SharpScanPrintAppDelegate* appDelegate = (SharpScanPrintAppDelegate*)[[UIApplication sharedApplication] delegate];
    // 処理実行フラグoff
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

// ヘッダー表示
- (void)SetHeaderView
{
    [self.tableView selectRowAtIndexPath:selectIndexPath animated:YES scrollPosition:UITableViewScrollPositionNone];
}

- (void)mailServerConnect
{
    [self updateAlert:1];

    @autoreleasepool {
        CTCoreAccount* anAccount = [[CTCoreAccount alloc] init];
        MailServerDataManager* manager = [[MailServerDataManager alloc]init];
        MailServerData* mailServerData = [manager loadMailServerDataAtIndex:0];
        DLog(@"%d",self.reloadFlag);
        if (self.reloadFlag == YES) {
            if (self.tmpMailNum != MAIL_OPTION_TYPE_DEFAULT) {
                self.emailLineNum = @(self.tmpMailNum);
            }
            if (self.tmpFilterSetting != MAIL_OPTION_TYPE_DEFAULT) {
                mailServerData.filterSetting = @(self.tmpFilterSetting);
            }
        }
        if(self.isCanceled == YES){
            [self removeMailList];
            //self.emailLineNum = 0;
        }
        NSOperationQueue *queue = [NSOperationQueue mainQueue];
        
        BOOL noError = NO;
        //self.isCanceled = NO;
        
        if((mailServerData.accountName == nil || [mailServerData.accountName isEqualToString:@""])||(mailServerData.accountPassword == nil) || [mailServerData.accountPassword isEqualToString:@""])
        {
            [queue addOperationWithBlock:^(){
                // アラートを閉じる
                [self.imapConnectionAlert dismissViewControllerAnimated:YES completion:^{
                    [self popupSendingErrorAlert: [@"" stringByAppendingFormat: MSG_EMAIL_ACCOUNT_ERROR,SUBMSG_LOGINACCOUNT_ERR]];
                }];

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
                                                    port: [mailServerData.imapPortNo intValue]
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
                            if([mCompArray count] == self.nFolderCount)
                            {
                                self.rootDir = m_pstrSelectFolder;
                                if([mCompArray count] == 1 || ([mCompArray count] > 1 && [nstr hasPrefix:self.rootDir])){
                                    
                                    // 選択階層のフォルダー名を取得し、保存
                                    [self.mArrSubFolder addObject:[mCompArray lastObject]];
                                }
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
                
                //messageList = [inbox messagesFromSequenceNumber:fromNum to:toNum withFetchAttributes: CTFetchAttrEnvelope];
                //***　絞り込み検索検証
                NSPredicate *predicate = nil;
                NSDate *date = nil;
                NSArray *uids = nil;
                
                switch (mailServerData.filterSetting.intValue) {
                    case 0:
                    {
                        date = [NSDate dateWithTimeIntervalSince1970:0];
                        predicate = [NSPredicate predicateWithFormat:@"%K > %@",@"INTERNALDATE", date];
                        
                        uids = [inbox messagesUIDsMatchingPredicate:predicate];
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
                        predicate = [NSPredicate predicateWithFormat:@"SEEN = 0"]; // 未読のみ
                        uids = [inbox messagesUIDsMatchingPredicate:predicate];
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
                        predicate = [NSPredicate predicateWithFormat:@"%K > %@",@"INTERNALDATE", date]; // 今日のメール
                        uids = [inbox messagesUIDsMatchingPredicate:predicate];
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
                        predicate = [NSPredicate predicateWithFormat:@"%K > %@",@"INTERNALDATE", date];
                        uids = [inbox messagesUIDsMatchingPredicate:predicate];
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
                        predicate = [NSPredicate predicateWithFormat:@"%K > %@",@"INTERNALDATE", date];
                        
                        uids = [inbox messagesUIDsMatchingPredicate:predicate];
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
                LOG(@"predicate:%@",predicate);
                LOG(@"count:%lu",(unsigned long)[messageList count]);
                
#ifdef DEBUG
                // 日付のフォーマット指定
                NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
                [formatter setLocale:[NSLocale systemLocale]];        // 12時間表示にならないように
                [formatter setTimeZone:[NSTimeZone systemTimeZone]];  // localeを再設定する。
                [formatter setDateFormat:@"yyyy/MM/dd HH:mm:ss"];
                
                LOG(@"firstObject : %@",[formatter stringFromDate:[(CTCoreMessage *)[messageList firstObject] senderDate]]);
                LOG(@"lastObject  : %@",[formatter stringFromDate:[(CTCoreMessage *)[messageList lastObject] senderDate]]);

                for (CTCoreMessage *cm in messageList) {//ログ用
                    LOG(@"Message:%@",[formatter stringFromDate:[cm senderDate]]);
                }
#endif
                
                //　絞り込んでいるのでmaxNoを更新
                if (uids.count < maxNo) {
                    maxNo = uids.count;
                }
                
                //***

                // ソート
                self.connectionProgression = 75;
                [self updateAlert:75];
                if (messageList.count) {
                    [self sortTimeStamp:messageList];
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
                            [self popupSendingErrorAlertError:anAccount.lastError];
                        }];
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
        [self removeMailList];
        self.tableView.scrollEnabled = NO;
    }
    // テーブルを更新
    [self.tableView performSelectorOnMainThread:@selector(reloadData) withObject:nil waitUntilDone:YES];
    if(self.imapConnectionAlert && self.isCanceled){
        //現在出ているアラートを消す
        dispatch_sync(dispatch_get_main_queue(), ^{
            // アラートを閉じる
            [self.imapConnectionAlert dismissViewControllerAnimated:YES completion:^{
            }];
        });
    }
    self.isCanceled = NO;
    self.connectionProgression = 0;
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
            [self alertButtonDismiss:self.imapConnectionAlert tagIndex:self.imapConnectionAlert.tag buttonIndex:0];
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
    if(self.isCanceled){
        return;
    }
    NSOperationQueue *queue = [NSOperationQueue mainQueue];
    [queue addOperationWithBlock:^(){
        self.alertTitle = [NSString stringWithFormat:@"%@\n%d%%",MSG_WAIT,p];
        [self.imapConnectionAlert setMessage:self.alertTitle];
    }];
}

-(ExAlertController*)popupConnectingAlert
{
    DLog();

    SharpScanPrintAppDelegate* appDelegate = (SharpScanPrintAppDelegate*)[[UIApplication sharedApplication] delegate];
    // 処理実行フラグON
    appDelegate.IsRun = TRUE;
    
    self.alertTitle = [NSString stringWithFormat:@"%@",MSG_WAIT];
    ExAlertController *tmpAlert = [self makeTmpExAlert:nil message:self.alertTitle cancelBtnTitle:MSG_BUTTON_CANCEL okBtnTitle:nil tag:1 showFlg:YES];
    return tmpAlert;
}

-(ExAlertController *)popupWaitAlert{
    self.alertTitle = nil;
    self.alertTitle = [NSString stringWithFormat:MSG_WAIT];
    ExAlertController *tmpAlert = [self makeTmpExAlert:nil message:self.alertTitle cancelBtnTitle:nil okBtnTitle:nil tag:1 showFlg:YES];
    return tmpAlert;
}

-(void)popupSendingErrorAlertError:(NSError*) conError
{
    SharpScanPrintAppDelegate* appDelegate = (SharpScanPrintAppDelegate*)[[UIApplication sharedApplication] delegate];
    // 処理実行フラグON
    appDelegate.IsRun = TRUE;
    
    NSInteger tmpTag = 0;
    NSString *tmpBtnTitle = MSG_BUTTON_OK;
    if (conError) {
        tmpTag = 2;
        tmpBtnTitle = S_BUTTON_CLOSE;
    }
    [self showTmpExAlert:nil message:[self mailCoreErrorStringFromError: conError] cancelBtnTitle:tmpBtnTitle okBtnTitle:nil tag:tmpTag showFlg:YES];
    
}

-(void)popupSendingErrorAlert:(NSString*) errorMessage
{
    SharpScanPrintAppDelegate* appDelegate = (SharpScanPrintAppDelegate*)[[UIApplication sharedApplication] delegate];
    // 処理実行フラグON
    appDelegate.IsRun = TRUE;
    
    [self showTmpExAlert:nil message:errorMessage cancelBtnTitle:S_BUTTON_CLOSE okBtnTitle:nil tag:3 showFlg:YES];
}

- (NSString*) mailCoreErrorStringFromError:(NSError*)errCode
{
    NSString *description = MSG_EMAIL_CONNECT_ERROR;
    return description;
}

// リフレッシュボタン押下時のアクション
- (void)refreshBtnAction:(id)sender
{
    if(self.connectionProgression > 74){
        return;
    }
    self.tableView.scrollEnabled = YES;
    self.isCanceled =NO;
    // 表示するメールの数の初期化
    maxNo = 0;
    pageNo = 1;
    pageNo_MaxUntilBefore = 0;

    // しばおま表示
    self.imapConnectionAlert = [self popupConnectingAlert];
    [self performSelectorInBackground:@selector(mailServerDisconnectAndConnect) withObject:nil];
}

// メールサーバとの切断後、再接続します。
- (void)mailServerDisconnectAndConnect
{
    if (self.account)
    {
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
    OptionChangeTableViewController *vc = [[OptionChangeTableViewController alloc]initWithType:MAIL_OPTION_TYPE_1 withIndex:self.tmpMailNum];
    vc.delegate = self;
    UINavigationController *nv = [[UINavigationController alloc]initWithRootViewController:vc];
    [self presentViewController:nv animated:YES completion:nil];
}

// フィルタリング設定ボタン押下時のアクション
- (void)mailFilterBtnAction:(id)sender {
    OptionChangeTableViewController *vc = [[OptionChangeTableViewController alloc]initWithType:MAIL_OPTION_TYPE_2 withIndex:self.tmpFilterSetting];
    vc.delegate = self;
    UINavigationController *nv = [[UINavigationController alloc]initWithRootViewController:vc];
    [self presentViewController:nv animated:YES completion:nil];
}

- (void)cancelBtnPushed {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)mailNumChanged:(NSInteger)value {
    [self dismissViewControllerAnimated:YES completion:^{
        self.reloadFlag = YES;
        self.tmpMailNum = value;
        [self.m_pMailList removeAllObjects];
        [self refreshBtnAction:nil];
    }];
}

- (void)filterChanged:(NSInteger)value {
    [self dismissViewControllerAnimated:YES completion:^{
        self.reloadFlag = YES;
        self.tmpFilterSetting = value;
        [self.m_pMailList removeAllObjects];
        [self refreshBtnAction:nil];
    }];
}

// メールを日時でソートする
-(NSMutableArray*)sortTimeStamp:(NSArray*)array
{
    // リスト追加
    if (self.m_pMailList == nil || pageNo_MaxUntilBefore == 0) {
        self.m_pMailList = [[NSMutableArray alloc]initWithArray:array];
    }else{
        [self.m_pMailList addObjectsFromArray:array];
    }
    // 日付でソート
    [self.m_pMailList sortUsingComparator: ^(id obj1, id obj2){
        return [[obj2 senderDate] compare:[obj1 senderDate]];
    }];
    
    return self.m_pMailList;
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
