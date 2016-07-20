
#import <netinet/in.h>
#import <arpa/inet.h>
#import <sys/types.h>
#import <sys/socket.h>
#import <netdb.h>      // IPv6対応
#import "SettingSelDeviceViewController.h"
#import "Define.h"
#import "PrinterDataCell.h"
#import "SettingShowDeviceViewController.h"
#import "PrintOutDataManager.h"
#import "CommonUtil.h"
#import "SharpScanPrintAppDelegate.h"
#import "ExcludePrinterDataManager.h"

@implementation SettingSelDeviceViewController

@synthesize Services = m_parrServices;
@synthesize CurrentResolve = m_pnetServiceCurrentResolve;
@synthesize NetServiceBrowser = m_pnetServiceBrowser;
@synthesize TimeoutSearchForSearvice;

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
    [self StopCurrentResolve];
	[self.NetServiceBrowser stop];
    
    
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
    
    // 変数初期化
    m_parrServices = [[NSMutableArray alloc] init];
    m_nResolvedCnt = 0;
    
    // ナビゲーションバー
    // タイトル設定
    CGRect frame = CGRectMake(0, 0, 400, 44);
    UILabel* lblTitle = [[UILabel alloc]initWithFrame:frame];
    lblTitle.backgroundColor = [UIColor clearColor];
    lblTitle.textColor = NAVIGATION_TITLE_COLOR;
    lblTitle.font = [UIFont boldSystemFontOfSize:20];
    lblTitle.textAlignment = NSTextAlignmentCenter;
    lblTitle.text = [CommonUtil getSSID];
    lblTitle.adjustsFontSizeToFitWidth = YES;
    self.navigationItem.titleView = lblTitle;
    
    // 戻るボタンの名称変更
    UIBarButtonItem * barItemBack = [UIBarButtonItem new];
    barItemBack.title = S_BUTTON_BACK;
    self.navigationItem.backBarButtonItem = barItemBack;
    
    // 編集ボタン追加
    self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    // 色変更
    //self.navigationController.navigationBar.tintColor = [UIColor blackColor];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
    // タイマー停止
    [self StopTimer];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    // ヘッダー表示
    [self SetHeaderView];
    
    // PrinterDataManagerクラス初期化
    m_pPrinterMgr = [[PrinterDataManager alloc] init];
    // 最新プライマリキーを取得して選択中MFPを設定
    PrintOutDataManager* printOutManager = [[PrintOutDataManager alloc]init];
    
    // PrinterDataManagerクラス初期化
    PrinterDataManager* pPrinterMgr = [[PrinterDataManager alloc] init];
    NSInteger nSaveIdx = -1;
    nSaveIdx = [pPrinterMgr GetPrinterIndexForKey:[printOutManager GetLatestPrimaryKey]];
    
    // 指定したキーに一致するプリンタが見つからない場合
    if (nSaveIdx == -1)
    {
        //プリンタが登録されている場合
        if([pPrinterMgr CountOfPrinterData] > 0)
        {
            // 一番上のプリンタの情報更新
            //            [pPrinterMgr ReplacePrinterDataAtIndex:(NSUInteger)0
            //                                         newObject:[pPrinterMgr LoadPrinterDataAtIndex:0]];
            // 除外されていないプリンターの一番上のプリンターの情報更新
            NSUInteger PrinterDataIndex = [[[m_pPrinterMgr GetIndexListInclude]objectAtIndex:0] intValue];
            
            [pPrinterMgr ReplacePrinterDataAtIndex:PrinterDataIndex
                                         newObject:[pPrinterMgr LoadPrinterDataAtIndexInclude:0]];
            // DATファイルに保存
            [pPrinterMgr SavePrinterData];
            //            [printOutManager SetLatestPrimaryKey:[[pPrinterMgr LoadPrinterDataAtIndex:0] PrimaryKey]];
            [printOutManager SetLatestPrimaryKey:[[pPrinterMgr LoadPrinterDataAtIndex2:PrinterDataIndex] PrimaryKey]];
        }
    }
    
    [m_pPrinterMgr SetDefaultMFPIndex:[printOutManager GetLatestPrimaryKey] PrimaryKeyForCurrrentWifi:[printOutManager GetLatestPrimaryKeyForCurrentWiFi]];
    
    // テーブルビューのリロード
    [self.tableView reloadData];
    
    // ヘッダー表示に変更
    //// フッター表示
    //[self SetFooterView];
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

- (BOOL) isDidEnterBackground
{
    DLog(@"%s", __PRETTY_FUNCTION__);
    SharpScanPrintAppDelegate* appDelegate = (SharpScanPrintAppDelegate*)[[UIApplication sharedApplication] delegate];
    // 処理実行フラグ
    return (!appDelegate.IsRun);
}

/*
 - (void)viewWillDisappear:(BOOL)animated
 {
 [super viewWillDisappear:animated];
 }
 */

/*
 - (void)viewDidDisappear:(BOOL)animated
 {
 [super viewDidDisappear:animated];
 }
 */

/*
 - (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
 {
 // Return YES for supported orientations
 return (interfaceOrientation == UIInterfaceOrientationPortrait);
 }
 */

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return N_NUM_SECTION_SETTING_MFP;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    //    return [m_pPrinterMgr CountOfPrinterData];
    return [m_pPrinterMgr CountOfPrinterDataInclude];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    // セル作成
    PrinterDataCell *cell = (PrinterDataCell*)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil)
    {
        cell = [[PrinterDataCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    // 表示データ取得
    PrinterData* printerData = nil;
    //    printerData = [m_pPrinterMgr LoadPrinterDataAtIndexWithSetDefaultMFP:indexPath];
    printerData = [m_pPrinterMgr LoadPrinterDataAtIndexWithSetDefaultMFPInclude:indexPath];
    
    // 表示データをセルに設定
    [cell SetCellPrinterInfo:printerData hasDisclosure:TRUE];
    
    return cell;
}

// テーブルビュー 縦幅設定
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return N_HEIGHT_SETTING_MFP_SEC;
}

/*
 // Override to support conditional editing of the table view.
 - (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
 {
 // Return NO if you do not want the specified item to be editable.
 return YES;
 }
 */

// 編集モード時の処理(削除・挿入)
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete)
    {
        NSUInteger RemoveDataIndex = [[[m_pPrinterMgr GetIndexListInclude]objectAtIndex:indexPath.row] intValue];
        
        // 印刷情報から削除
        //        [m_pPrinterMgr RemoveAtIndex:indexPath.row];
        [m_pPrinterMgr RemoveAtIndex:RemoveDataIndex];
        if(![m_pPrinterMgr SavePrinterData])
        {
            SharpScanPrintAppDelegate* appDelegate = (SharpScanPrintAppDelegate*)[[UIApplication sharedApplication] delegate];
            // 処理実行フラグON
            appDelegate.IsRun = TRUE;

            [self makeTmpExAlert:nil message:MSG_SAVE_ERR cancelBtnTitle:MSG_BUTTON_OK okBtnTitle:nil tag:0];
            
            return;
        }
        
        // 行削除
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
        
        // 一覧データの再取得
        m_pPrinterMgr = [[PrinterDataManager alloc] init];
        // 最新プライマリキーを取得して選択中MFPを設定
        PrintOutDataManager* printOutManager = [[PrintOutDataManager alloc]init];
        
        NSInteger nSaveIdx = -1;
        nSaveIdx = [m_pPrinterMgr GetPrinterIndexForKey:[printOutManager GetLatestPrimaryKey]];
        
        // 指定したキーに一致するプリンタが見つからない場合
        if (nSaveIdx == -1)
        {
            //プリンタが登録されている場合
            //            if([m_pPrinterMgr CountOfPrinterData] > 0)
            if([m_pPrinterMgr CountOfPrinterDataInclude] > 0)
            {
                // 一番上のプリンタの情報更新
                //                [m_pPrinterMgr ReplacePrinterDataAtIndex:(NSUInteger)0
                //                                             newObject:[m_pPrinterMgr LoadPrinterDataAtIndex:0]];
                // 除外されていないプリンターの一番上のプリンターの情報更新
                NSUInteger PrinterDataIndex = [[[m_pPrinterMgr GetIndexListInclude]objectAtIndex:0] intValue];
                
                [m_pPrinterMgr ReplacePrinterDataAtIndex:PrinterDataIndex
                                               newObject:[m_pPrinterMgr LoadPrinterDataAtIndexInclude:0]];
                // DATファイルに保存
                [m_pPrinterMgr SavePrinterData];
                //                [printOutManager SetLatestPrimaryKey:[[m_pPrinterMgr LoadPrinterDataAtIndex:0] PrimaryKey]];
                [printOutManager SetLatestPrimaryKey:[[m_pPrinterMgr LoadPrinterDataAtIndex2:PrinterDataIndex] PrimaryKey]];
            }
            
        }
        
        [m_pPrinterMgr SetDefaultMFPIndex:[printOutManager GetLatestPrimaryKey] PrimaryKeyForCurrrentWifi:[printOutManager GetLatestPrimaryKeyForCurrentWiFi]];
        // 一覧再描画
        [self.tableView performSelector:@selector(reloadData) withObject:nil afterDelay:0.5];
        
    }
    else if (editingStyle == UITableViewCellEditingStyleInsert)
    {
        // 行挿入：何もしない
    }
}


// 編集モード時の処理(移動)
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
    NSArray* IndexListInclude = [m_pPrinterMgr GetIndexListInclude];
    NSUInteger IndexListFromIndex = [[IndexListInclude objectAtIndex:fromIndexPath.row] intValue];
    NSUInteger IndexListToIndex = [[IndexListInclude objectAtIndex:toIndexPath.row] intValue];
    
    // 印刷情報の移動
    //    [m_pPrinterMgr MoveFromIndex:fromIndexPath.row
    //                         toIndex:toIndexPath.row];
    [m_pPrinterMgr MoveFromIndex:IndexListFromIndex
                         toIndex:IndexListToIndex];
    
    BOOL bReloadData = false;
    if(fromIndexPath.row != toIndexPath.row)
    {
        // 一覧再描画
        bReloadData = true;
    }
    if(![m_pPrinterMgr SavePrinterData])
    {
        SharpScanPrintAppDelegate* appDelegate = (SharpScanPrintAppDelegate*)[[UIApplication sharedApplication] delegate];
        // 処理実行フラグON
        appDelegate.IsRun = TRUE;
        
        [self makeTmpExAlert:nil message:MSG_SAVE_ERR cancelBtnTitle:MSG_BUTTON_OK okBtnTitle:nil tag:0];
        
        return;
    }
    else
    {
        // 並び替えアニメーション終了後(0.5秒後)に一覧を再描画
        if(bReloadData)
        {
            m_pPrinterMgr = [[PrinterDataManager alloc] init];
            // 最新プライマリキーを取得して選択中MFPを設定
            PrintOutDataManager* printOutManager = [[PrintOutDataManager alloc]init];
            [m_pPrinterMgr SetDefaultMFPIndex:[printOutManager GetLatestPrimaryKey] PrimaryKeyForCurrrentWifi:[printOutManager GetLatestPrimaryKeyForCurrentWiFi]];
            // 一覧再描画
            [self.tableView performSelector:@selector(reloadData) withObject:nil afterDelay:0.5];
        }
    }
}

// 編集モードによるセル移動可否を設定する
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
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
    
    SettingShowDeviceViewController* pSettingViewController;
    
    if(nIndexPath.section == 0)
    {
        pSettingViewController = [[SettingShowDeviceViewController alloc] initWithStyle:UITableViewStyleGrouped];
        // プリンタ情報をセット
        //        pSettingViewController.PrinterInfo = [m_pPrinterMgr LoadPrinterDataAtIndexWithSetDefaultMFP:nIndexPath];
        pSettingViewController.PrinterInfo = [m_pPrinterMgr LoadPrinterDataAtIndexWithSetDefaultMFPInclude:nIndexPath];
        // 画面遷移
        [self.navigationController pushViewController:pSettingViewController animated:YES];
    }
}

// ボタン押下関数
// 自動更新ボタン押下
- (IBAction)OnListUpdateButton:(id)sender
{
    SharpScanPrintAppDelegate* appDelegate = (SharpScanPrintAppDelegate*)[[UIApplication sharedApplication] delegate];
    // 処理実行フラグON
    appDelegate.IsRun = TRUE;
    
    // 編集モード完了
    [super setEditing:NO];
    
    
    //
    // IP アドレスチェック
    //
    NSString *strIpaddr	= [CommonUtil getIPAdder];
    NSUInteger len = [[strIpaddr stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] length];
    if (len <= 0)
    {
        [self makeTmpExAlert:nil message:MSG_NETWORK_ERR cancelBtnTitle:nil okBtnTitle:MSG_BUTTON_OK tag:0];
        
        return;
    }
    
    // 検索実行中はスリープしない
    [UIApplication sharedApplication].idleTimerDisabled = YES;
    
    // SNMP関係の初期化
    m_pDicPlace = [[NSMutableDictionary alloc]init];
    m_pDicFtpPort = [[NSMutableDictionary alloc]init];
    m_nMibCount = 0;
    isEnd = FALSE;
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"getMibEnd" object:nil];
    
    // アラートを表示
    [self CreateProgressAlert:nil message:MSG_SEARCH_DOING withCancel:YES];
    
    // Bonjourによる機器検索
    [self SearchForServicesOfType:S_WEB_SERVICE_TYPE inDomain:S_INIT_DOMAIN];
}

// 手動追加ボタン押下
- (IBAction)OnManualAddButton:(id)sender
{
    // 編集モード完了
    [super setEditing:NO];
    
    // 手動追加画面に遷移
    SettingShowDeviceViewController* pSettingViewController;
    pSettingViewController = [[SettingShowDeviceViewController alloc] initWithStyle:UITableViewStyleGrouped];
    // 画面遷移
    [self.navigationController pushViewController:pSettingViewController animated:YES];
}
//
//// フッター表示
// - (void)SetFooterView
// ヘッダー表示
- (void)SetHeaderView
{
    CGRect mainRec = [[UIScreen mainScreen] bounds];
    // 自動更新ボタン生成
	UIButton* pbtnAuto = [UIButton buttonWithType:UIButtonTypeCustom];                  // ボタンタイプ
    [pbtnAuto setExclusiveTouch: YES];
    pbtnAuto.frame = CGRectMake(10.0, 5.0, mainRec.size.width - 10, 50.0);                                 // ボタンサイズ
    // 背景画像設定
    [pbtnAuto setBackgroundImage:[UIImage imageNamed:S_IMAGE_BUTTON_GRAY] forState:UIControlStateNormal];
    
    pbtnAuto.titleEdgeInsets= UIEdgeInsetsMake(0.0, 20.0, 0.0, 0.0);                    // ボタンタイトル表示位置
	[pbtnAuto setTitle:S_BUTTON_AUTO_UPDATE forState:UIControlStateNormal];             // ボタン表示名称
	[pbtnAuto setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];        // ボタンのフォント
    pbtnAuto.titleLabel.font = [UIFont systemFontOfSize:15];                            // ボタンのフォントサイズ
    pbtnAuto.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;      // ボタンAlign
	[pbtnAuto addTarget:self action:@selector(OnListUpdateButton:) forControlEvents:UIControlEventTouchUpInside] ;
	
    // アイコン設定
    [pbtnAuto setImage:[UIImage imageNamed:S_ICON_SETTING_UPDATE] forState:UIControlStateNormal];
    UIEdgeInsets insets = pbtnAuto.imageEdgeInsets;
    insets.left = 10.0;
    pbtnAuto.imageEdgeInsets = insets;
    
	// 手動追加ボタン生成
	UIButton* pbtnManual = [UIButton buttonWithType:UIButtonTypeCustom];                // ボタンタイプ
    [pbtnManual setExclusiveTouch: YES];
    pbtnManual.frame = CGRectMake(10.0, 55.0, mainRec.size.width - 10, 50.0);                              // ボタンサイズ
    // 背景画像設定
    [pbtnManual setBackgroundImage:[UIImage imageNamed:S_IMAGE_BUTTON_GRAY] forState:UIControlStateNormal];
    
    pbtnManual.titleEdgeInsets= UIEdgeInsetsMake(0.0, 20.0, 0.0, 0.0);                  // ボタンタイトル表示位置
	[pbtnManual setTitle:S_BUTTON_MANUAL_ADD forState:UIControlStateNormal];            // ボタン表示名称
	[pbtnManual setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];      // ボタンのフォント
    pbtnManual.titleLabel.font = [UIFont systemFontOfSize:15];                          // ボタンのフォントサイズ
    pbtnManual.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;    // ボタンAlign
	[pbtnManual addTarget:self action:@selector(OnManualAddButton:) forControlEvents:UIControlEventTouchUpInside] ;
	
    // アイコン設定
    [pbtnManual setImage:[UIImage imageNamed:S_ICON_SETTING_ADD] forState:UIControlStateNormal];
    insets = pbtnManual.imageEdgeInsets;
    insets.left = 10.0;
    pbtnManual.imageEdgeInsets = insets;
    
    /*
     //フッターにボタン設定
     UIView *footerView = [[UIView alloc] initWithFrame:CGRectMake(5.0, 0.0, 300.0, 100.0)];
     [footerView addSubview:pbtnAuto];
     [footerView addSubview:pbtnManual];
     
     //TableViewにフッター設定
     self.tableView.tableFooterView = footerView;
     */
    
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(5.0, 0.0, 300.0, 100.0)];
    [headerView addSubview:pbtnAuto];
    [headerView addSubview:pbtnManual];
    //headerView.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin;
    //TableViewにヘッダー設定
    self.tableView.tableHeaderView = headerView;
    
}

// 処理中アラート表示
- (void)CreateProgressAlert:(NSString *)pstrTitle
                    message:(NSString *)pstrMessage
                 withCancel:(BOOL)bCancel
{
	@autoreleasepool
    {
        
        if (bCancel)
        {
            [self makeAlert:nil message:pstrMessage cancelBtnTitle:MSG_BUTTON_CANCEL okBtnTitle:nil tag:1];
        }
        else
        {
            [self makeAlert:nil message:pstrMessage cancelBtnTitle:nil okBtnTitle:nil tag:1];
        }
	}
}

// Bonjour関連
// サービス検索
- (BOOL)SearchForServicesOfType:(NSString *)pstrType inDomain:(NSString *)pstrDomain
{
    m_nResolvedCnt = 0;
    
    [self StopCurrentResolve];
	[self.NetServiceBrowser stop];
	[self.Services removeAllObjects];
    
	NSNetServiceBrowser *aNetServiceBrowser = [[NSNetServiceBrowser alloc] init];
	if(!aNetServiceBrowser)
    {
		return NO;
	}
    
	aNetServiceBrowser.delegate = self;
	self.NetServiceBrowser = aNetServiceBrowser;
	[self.NetServiceBrowser searchForServicesOfType:pstrType inDomain:pstrDomain];
    
    // 応答までに時間のかかる機種があるため、wait
    [NSThread sleepForTimeInterval:0.5f];
    
    // 1分後まで応答がない場合はサービス検索中断
    self.TimeoutSearchForSearvice = [NSTimer scheduledTimerWithTimeInterval:60.0f target:self selector:@selector(StopSearchForSeviceOfType:) userInfo:nil repeats:NO];
    
	[self.tableView reloadData];
	return YES;
}


-(void)StopSearchForSeviceOfTypeCloseAlert:(BOOL)isCloseAlert
{
    // タイマー停止
    [self StopTimer];
    // サービス検索中断
    [self StopCurrentResolve];
    [self.NetServiceBrowser stop];
    if(isCloseAlert)
    {
        if(nil != ex_alert)
        {
            [ex_alert dismissViewControllerAnimated:YES completion:^{
                [self alertButtonPushed:nil tagIndex:0 buttonIndex:0];
            }];
        }
    }
}

// サービス検索中断
-(void)StopSearchForSeviceOfType:(NSTimer*)timer
{
    // タイマー停止
    [self StopSearchForSeviceOfTypeCloseAlert:TRUE];
    
    [self makeTmpExAlert:nil message:MSG_SEARCH_NOTHING cancelBtnTitle:MSG_BUTTON_OK okBtnTitle:nil tag:0];
}

// タイマー停止
- (void)StopTimer
{
    if(self.TimeoutSearchForSearvice != nil)
    {
        [self.TimeoutSearchForSearvice invalidate];
        self.TimeoutSearchForSearvice = nil;
    }
}

// サービス発見イベント
- (void)netServiceBrowser:(NSNetServiceBrowser*)netServiceBrowser didFindService:(NSNetService*)service moreComing:(BOOL)moreComing
{
    // タイマー停止
    [self StopTimer];
    
    // 見つかったサービスを追加
	[self.Services addObject:service];
    
    DLog(@"名前：%@", [service name]);
    DLog(@"ホスト名：%@", [service hostName]);
    DLog(@"ポート番号：%ld", (long)[service port]);
    DLog(@"ドメイン名：%@", [service domain]);
    DLog(@"タイプ：%@", [service type]);
    //DLog(@"IPアドレス：%@", [self GetIpAddress:service]);
    DLog(@"IPアドレス：%@", [self getIpAddressFromHostName:service]);
    
    // これ以上サービスが存在しない場合
    if (!moreComing)
    {
        // サービス検索完了時の処理
        [self EndSearchNetService];
	}
}

// ホスト名未解決イベント
- (void)netService:(NSNetService *)sender didNotResolve:(NSDictionary *)errorDict
{
	[self StopCurrentResolve];
    
    DLog(@"didNotResolve");
    
    DLog(@"CurrentResolve-名前：%@", [self.CurrentResolve name]);
    DLog(@"CurrentResolve-ホスト名：%@", [self.CurrentResolve hostName]);
    DLog(@"CurrentResolve-ポート番号：%ld", (long)[self.CurrentResolve port]);
    DLog(@"CurrentResolve-ドメイン名：%@", [self.CurrentResolve domain]);
    DLog(@"CurrentResolve-タイプ：%@", [self.CurrentResolve type]);
    DLog(@"CurrentResolve-IPアドレス：%@", [self getIpAddressFromHostName:self.CurrentResolve]);
    
    m_nResolvedCnt += 1;
    if (m_nResolvedCnt < [self.Services count])
    {
        // ホスト名解決
        [self ResolveAddress:m_nResolvedCnt];
    }
    else
    {
        // ホスト名解決完了
        [self StartSnmp];
    }
}

// SNMP開始
- (void)StartSnmp
{
    if(!snmpManagerArray)
    {
        snmpManagerArray = [[NSMutableArray alloc] init];
    } else {
        [snmpManagerArray removeAllObjects];
    }
    
    for (NSInteger nIndex = 0; nIndex < [self.Services count]; nIndex++)
    {
        NSNetService* service = [self.Services objectAtIndex:nIndex];
        
        NSString *resolveIPAddr = [self getIpAddressFromHostName:service];
        NSMutableDictionary *dicForGetMib = [[NSMutableDictionary alloc] init];
        [dicForGetMib setObject:resolveIPAddr forKey:@"IPAddress"];
        [dicForGetMib setObject:[service hostName] forKey:@"HostName"];
        
        [self performSelectorInBackground:@selector(getMib:) withObject:dicForGetMib];
        
        [NSThread sleepForTimeInterval:0.1f];
        m_nMibCount++;
    }
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getMibEnd:) name:@"getMibEnd" object:nil];
}

// Mib情報の取得
// 引数  IPアドレス：通信用
//        ホスト名：結果格納用のキー
- (void)getMib:(NSDictionary*)dic
{
    
    if (!([dic.allKeys containsObject:@"IPAddress"] && [dic.allKeys containsObject:@"HostName"])) {
        return;
    }
    if ([dic objectForKey:@"IPAddress"] == nil || [dic objectForKey:@"HostName"] == nil) {
        return;
    }
    
    ProfileDataManager* pManager = [[ProfileDataManager alloc]init];
    ProfileData* pData = [pManager loadProfileDataAtIndex:0];
    
    // Community String の設定
    NSMutableArray* communityString = [[NSMutableArray alloc]init];
    if(!pData.snmpSearchPublicMode)
    {
        [communityString addObject:S_SNMP_COMMUNITY_STRING_DEFAULT];
    }
    NSArray *strStrings = [pData.snmpCommunityString componentsSeparatedByString:@"\n"];
    for (NSString* strTmp in strStrings) {
        [communityString addObject:strTmp];
    }
    
    SnmpManager* manager = [[SnmpManager alloc]initWithIpAddress:[dic objectForKey:@"IPAddress"] port:N_SNMP_PORT];
    [snmpManagerArray addObject:manager];
    [manager setCommunityString:communityString];
    
    // 取得するOIDのセット
    NSMutableArray* arrOid = [[NSMutableArray alloc]init];
    [arrOid addObject:S_SNMP_OID_PLACE];
    [arrOid addObject:S_SNMP_OID_FTPPORT];
    
    NSMutableDictionary* dicMibList = [manager getMibByOid:arrOid];
    
    if(dicMibList != nil && [dicMibList count] != 0 && [dicMibList objectForKey:S_SNMP_OID_PLACE] != nil)
    {
        [m_pDicPlace setObject:[dicMibList objectForKey:S_SNMP_OID_PLACE] forKey:[dic objectForKey:@"HostName"]];
        [m_pDicFtpPort setObject:[dicMibList objectForKey:S_SNMP_OID_FTPPORT] forKey:[dic objectForKey:@"HostName"]];
    }
    
    if (isEnd || dicMibList == nil) {
        m_nMibCount--;
        return;
    }
    
    m_nMibCount--;
    [[NSNotificationCenter defaultCenter]postNotification:[NSNotification notificationWithName:@"getMibEnd" object:self]];
}

// Mib取得完了後処理
-(void)getMibEnd:(NSNotification*) notification
{
    if([self isDidEnterBackground])
    {
        return;
    }
    
    if (isEnd) {
        return;
    }
    if(m_nMibCount == 0)
    {
        isEnd = TRUE;
        [self performSelectorOnMainThread:@selector(EndResolveAddress) withObject:nil waitUntilDone:NO];
    }
    return;
}

// ホスト名解決イベント
- (void)netServiceDidResolveAddress:(NSNetService *)service
{
    DLog(@"netServiceDidResolveAddress");
    
    DLog(@"netServiceDidResolveAddress-service名前：%@", [service name]);
    DLog(@"netServiceDidResolveAddress-CurrentResolve名前：%@", [self.CurrentResolve name]);
    DLog(@"netServiceDidResolveAddress-m_nResolvedCnt名前：%@", [[self.Services objectAtIndex:m_nResolvedCnt] name]);
    
	if (service == self.CurrentResolve)
    {
        [self StopCurrentResolve];
        
        DLog(@"名前：%@", [service name]);
        DLog(@"ホスト名：%@", [service hostName]);
        DLog(@"ポート番号：%ld", (long)[service port]);
        DLog(@"ドメイン名：%@", [service domain]);
        DLog(@"タイプ：%@", [service type]);
        DLog(@"IPアドレス：%@", [self getIpAddressFromHostName:service]);
        
        NSData* txtRecordData = [service TXTRecordData];
        NSDictionary* dictTxtRecord = [NSNetService dictionaryFromTXTRecordData:txtRecordData];
        
        for (NSInteger i = 0; i < [[dictTxtRecord allKeys] count]; i++)
        {
//            NSString * key = [[dictTxtRecord allKeys] objectAtIndex:i];
//            NSString * value = [[NSString alloc] initWithData:[dictTxtRecord objectForKey: key] encoding:NSUTF8StringEncoding];
//            
//            DLog(@"key: %@, value:%@", key, value);
        }
        
        // サービス情報更新
        [self.Services removeObjectAtIndex:m_nResolvedCnt];
        [self.Services insertObject:service atIndex:m_nResolvedCnt];
        
        m_nResolvedCnt += 1;
        if (m_nResolvedCnt < [self.Services count])
        {
            // ホスト名解決
            [self ResolveAddress:m_nResolvedCnt];
        }
        else
        {
            // ホスト名解決完了
            [self StartSnmp];
        }
    }
    else
    {
        [self StopCurrentResolve];
        DLog(@"検索不一致エラー");
        
//        NSData* txtRecordData = [service TXTRecordData];
//        NSDictionary* dictTxtRecord = [NSNetService dictionaryFromTXTRecordData:txtRecordData];
//        NSString* pstrTy = [[NSString alloc]initWithData:[dictTxtRecord objectForKey:@"ty"]encoding:NSUTF8StringEncoding];
//        NSString* strPlace = [[NSString alloc]initWithData:[dictTxtRecord objectForKey:@"note"]encoding:NSUTF8StringEncoding];
        
        DLog(@"service-名前：%@", [service name]);
        DLog(@"service-ホスト名：%@", [service hostName]);
//        DLog(@"service-製品名：%@", pstrTy);
//        DLog(@"service-設置場所：%@", strPlace);
        DLog(@"service-ポート番号：%ld", (long)[service port]);
        DLog(@"service-ドメイン名：%@", [service domain]);
        DLog(@"service-タイプ：%@", [service type]);
        DLog(@"service-IPアドレス：%@", [self getIpAddressFromHostName:service]);
        
        DLog(@"CurrentResolve-名前：%@", [self.CurrentResolve name]);
        DLog(@"CurrentResolve-ホスト名：%@", [self.CurrentResolve hostName]);
        DLog(@"CurrentResolve-ポート番号：%ld", (long)[self.CurrentResolve port]);
        DLog(@"CurrentResolve-ドメイン名：%@", [self.CurrentResolve domain]);
        DLog(@"CurrentResolve-タイプ：%@", [self.CurrentResolve type]);
        DLog(@"CurrentResolve-IPアドレス：%@", [self getIpAddressFromHostName:self.CurrentResolve]);
        
        m_nResolvedCnt += 1;
        if (m_nResolvedCnt < [self.Services count])
        {
            // ホスト名解決
            [self ResolveAddress:m_nResolvedCnt];
        }
        else
        {
            // ホスト名解決完了
            [self StartSnmp];
        }
        
        // debugコード
        [self makeTmpExAlert:nil message:@"検索不一致エラー" cancelBtnTitle:MSG_BUTTON_OK okBtnTitle:nil tag:0];
        
    }
}

// サービス検索完了
- (void)EndSearchNetService
{
    DLog(@"サービス検索完了：%lu", (unsigned long)[self.Services count]);
    [self.NetServiceBrowser stop];
    [self ResolveAddress:0];
}

// ホスト名解決
- (void)ResolveAddress:(NSInteger)nIndex
{
    DLog(@"ResolveAddress：%ld", (long)nIndex);
    DLog(@"ResolveAddress-名前：%@", [[self.Services objectAtIndex:nIndex] name]);
    
    // 詳細情報取得
    self.CurrentResolve = [self.Services objectAtIndex:nIndex];
    [self.CurrentResolve setDelegate:self];
    [self.CurrentResolve resolveWithTimeout:0.0];
}

// ホスト名解決中断
- (void)StopCurrentResolve
{
	[self.CurrentResolve stop];
	self.CurrentResolve = nil;
}

// ホスト名解決完了
- (void)EndResolveAddress
{
    DLog(@"%s", __PRETTY_FUNCTION__);

    if([self isDidEnterBackground])
    {
        return;
    }
    
    isEnd = TRUE;
    
    // 検索中アラートは消さない
    //    [m_palert dismissWithClickedButtonIndex:0 animated:NO];
    
    // 既存更新件数
    NSInteger nUpdCount = 0;
    // 新規追加件数
    NSInteger nAddCount = 0;
    
    NSInteger nSaveIdx = -1;
    
    //    ExcludePrinterDataManager* exPrinterData = [[[ExcludePrinterDataManager alloc] init] autorelease];
    
    // プリンタ情報保存
    for (NSInteger nIndex = 0; nIndex < [self.Services count]; nIndex++)
    {
        NSNetService* service = [self.Services objectAtIndex:nIndex];
        NSData* txtRecordData = [service TXTRecordData];
        NSDictionary* dictTxtRecord = [NSNetService dictionaryFromTXTRecordData:txtRecordData];
        NSString* pstrTy = [[NSString alloc]initWithData:[dictTxtRecord objectForKey:@"ty"]encoding:NSUTF8StringEncoding];
        
        NSString *resolveIPAddr = [self getIpAddressFromHostName:service];  // ホスト名の名前解決
        
        // SHARP製品のプリンターで、かつ除外リストに含まれないプリンターのみ追加 + ホスト名を名前解決してIPアドレスが取得できた場合のみ追加
        if (([service hostName] != nil) && ([pstrTy hasPrefix:@"SHARP "]) && (resolveIPAddr != nil))
        {
            if([pstrTy hasSuffix:@"DS"])
            {//コンビニモデル(〜DSは追加しない)
                continue;
            }
            // "SHARP DM-"、"SHARP AL-"で始まれば、プリンタ情報を更新/追加しない
            if ([pstrTy hasPrefix:@"SHARP DM-"] ||
                [pstrTy hasPrefix:@"SHARP AL-"]) {
                continue;
            }
            // 国内版で、"SHARP AR-"で始まる場合、プリンタ情報を更新/追加しない
            if ([S_LANG isEqualToString:S_LANG_JA] && [pstrTy hasPrefix:@"SHARP AR-"])
            {
                continue;
            }
            
            // プリンター・スキャナーリストに追加
            nSaveIdx = [m_pPrinterMgr GetPrinterIndexForKey:[service hostName]];
        }
        else
        {
            // ホスト名がNULLの場合はプリンタ情報を更新/追加しない
            continue;
        }
        
        // SNMPで値が取得できない場合はプリンタ情報を更新/追加しない
        if ([m_pDicPlace objectForKey:[service hostName]] != nil)
        {
        } else {
            continue;
        }
        
        // プリンタ情報格納
        PrinterData* newData = [[PrinterData alloc] init];
        NSString* strHostName = [service hostName];
        NSString* strPortNo = [NSString stringWithFormat:@"%ld", (long)[service port]];
        NSString* strPlace = [[NSString alloc]initWithData:[dictTxtRecord objectForKey:@"note"]encoding:NSUTF8StringEncoding];
        if ([m_pDicPlace objectForKey:strHostName] != nil)
        {
            // 設置場所がSNMPで取得できていたらそちらで上書き
            strPlace = [m_pDicPlace objectForKey:strHostName];
        }
        
        if (nSaveIdx > -1)
        {
            //編集したプリンタ情報の取得
            PrinterDataManager* mData = [[PrinterDataManager alloc] init];
            newData = [mData LoadPrinterDataAtIndex2:nSaveIdx];
            
            //名称、製品名、FTPポートNo、設置場所以外は再取得
            [newData setPrimaryKey:strHostName];                // プリンタ情報のプライマリキー
            [newData setHostName:strHostName];                  // ホスト名
            // ホスト名の名前解決を行ってIPアドレスを取得する
            [newData setIpAddress:resolveIPAddr]; // プリンタIPアドレス
            
            [newData setPortNo:strPortNo];                      // サービスに割当てられたポートNo
            [newData setServiceName:[service type]];            // サービス名
        }
        else
        {
            [newData setPrimaryKey:strHostName];                // プリンタ情報のプライマリキー
            [newData setHostName:strHostName];                  // ホスト名
            
            // 製品名の設定
            ProfileDataManager* pManager = [[ProfileDataManager alloc]init];
            ProfileData* pData = [pManager loadProfileDataAtIndex:0];
            if(pData.deviceNameStyle == SETTING_DEVICENAME_STYLE_LOCATION){
                // 製品名と設置場所を表示
                if([CommonUtil strLength:[strPlace stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]]] == 0){
                    // 設置場所が空の場合は製品名のみ
                    // プリンタ名：製品名
                    [newData setPrinterName:pstrTy];
                }
                else
                {
                    // プリンタ名：製品名(設置場所)
                    [newData setPrinterName:[[[pstrTy stringByAppendingString:@"("] stringByAppendingString:strPlace] stringByAppendingString:@")"]];
                }
            }else if(pData.deviceNameStyle == SETTING_DEVICENAME_STYLE_IP_ADDRESS){
                // 製品名とIPアドレスを表示
                // プリンタ名：製品名(IPアドレス)
                [newData setPrinterName:[[[pstrTy stringByAppendingString:@"("] stringByAppendingString:resolveIPAddr] stringByAppendingString:@")"]];
            }
            
            [newData setProductName:pstrTy];                    // 製品名
            [newData setIpAddress:resolveIPAddr];               // プリンタIPアドレス
            
            [newData setPortNo:strPortNo];                      // サービスに割当てられたポートNo
            if([m_pDicFtpPort objectForKey:strHostName] != nil) {
                [newData setFtpPortNo:[m_pDicFtpPort objectForKey:strHostName]];           // FTPポートNo
            } else {
                [newData setFtpPortNo:N_NUM_FTP_PORT_NO];           // FTPポートNo
            }
            [newData setRawPortNo:N_NUM_RAWPRINT_PORT_NO];      // RawポートNo
            [newData setPlace:strPlace];                        // 設置場所
            [newData setServiceName:[service type]];            // サービス名
        }
        
        if ([self isDidEnterBackground])
        {
            return;
        }

        // リモートスキャンなどの対応有無チェック

        //--------------------
        // mfpif.xml取得
        //--------------------
        NSURL* url = [NSURL URLWithString:[NSString stringWithFormat:@"http://%@:%d/", [CommonUtil optIPAddrForComm:resolveIPAddr], 80]];
        mfpManager = [[RSmfpifManager alloc] initWithURL:url];
        
        mfpManager.parserDelegate = self;
        BOOL isSucceeded = [mfpManager updateData];
        isParseEnd = FALSE;
        NSDate *startDate = [NSDate date];
        // Xmlパースが終了するまで待つ
        while (!isParseEnd)
        {
            [[NSRunLoop currentRunLoop]runUntilDate:[NSDate dateWithTimeIntervalSinceNow:0.1f]];
            
            // もし、10秒 以上経過していたら終了する
            // または検索をキャンセルした場合終了する
            if ([[NSDate date] timeIntervalSinceDate:startDate] > 10)
            {
                isParseEnd = YES;
                DLog(@"Parse Time out 10sec");
            }
            if([self isDidEnterBackground])
            {
                return;
            }
        }
        
        //リクエスト時にエラー
        if(!isSucceeded){
            continue;
        }
        //ネットワークエラー
        if([mfpManager.errCode isEqualToString:@"NETWORK_ERROR"]){
            DLog(@"ネットワークエラー errorCode:%@",mfpManager.errCode);
            continue;
        }
        //通信エラー（statusCodeが200番台以外）
        if(mfpManager.statusCodeNumber/100 != 2){
            DLog(@"通信 statusCode:%ld",(long)mfpManager.statusCodeNumber);
            [mfpManager disconnect];
            continue;
        }
        //xmlパース失敗
        if([mfpManager.errCode isEqualToString:@"XML_PARSE_ERROR"]){
            DLog(@"パースエラー errorCode:%@",mfpManager.errCode);
            [mfpManager disconnect];
            continue;
        }
        [newData setIsCapableNetScan:[mfpManager isCapableNetScan]];
        if([mfpManager isCapableNetScan]){                                         
            [newData setIsCapableRemoteScan:[mfpManager isCapableRemoteScan]];
        } else {
            [newData setIsCapableRemoteScan:NO];
        }
        [newData setIsCapableNovaLight:[mfpManager isCapableNovaLight]];
        
        [newData setIsCapablePrintRelease:[mfpManager isCapablePrintRelease]];
        
        //--------------------
        // mfpif-service取得
        //--------------------
        if(newData.IsCapableRemoteScan || newData.isCapablePrintRelease){
            // リモートスキャン有効時にはリモートスキャン用ポートを取得する
            // プリントリリース有効時にはプリントリリース親機かどうかを取得する
            url = [NSURL URLWithString: [NSString stringWithFormat:@"http://%@:%d/", [CommonUtil optIPAddrForComm:resolveIPAddr], 80]];
            mfpServiceManager = [[RSmfpifServiceManager alloc] initWithURL:url];
            
            // 取得したい値を指定
            mfpServiceManager.setOsaHttpPortGetFlag = newData.IsCapableRemoteScan;
            mfpServiceManager.setPrintReleaseDataReceiveGetFlag = newData.isCapablePrintRelease;
            
            mfpServiceManager.parserDelegate = self;
            [mfpServiceManager updateData:mfpManager.serviceUrl];
            
            isParseEnd = FALSE;
            startDate = [NSDate date];
            // Xmlパースが終了するまで待つ
            while (!isParseEnd)
            {
                [[NSRunLoop currentRunLoop]runUntilDate:[NSDate dateWithTimeIntervalSinceNow:0.1f]];
                
                // もし、10秒 以上経過していたら終了する
                // または検索をキャンセルした場合終了する
                if ([[NSDate date] timeIntervalSinceDate:startDate] > 10)
                {
                    isParseEnd = YES;
                    DLog(@"Parse Time out 10sec");
                }
                
                if([self isDidEnterBackground])
                {
                    return;
                }
            }
            if(newData.IsCapableRemoteScan) {
                // リモートスキャン関係の値をセット
                newData.RSPortNo = mfpServiceManager.portNo;
                if(!mfpServiceManager.portNo || [mfpServiceManager.portNo isEqualToString: @""])
                {
                    [newData setIsCapableRemoteScan:NO];
                }
            }
            if(newData.isCapablePrintRelease) {
                // プリントリリース関係の値をセット
                newData.enabledDataReceive = mfpServiceManager.enabledDataReceive;
            }
        }
        
        if (nSaveIdx > -1)
        {
            // 既存情報更新
            [m_pPrinterMgr ReplacePrinterDataAtIndex:(NSUInteger)nSaveIdx
                                           newObject:newData];
            // 既存更新
            nUpdCount += 1;
        }
        else
        {
            // 最後尾に追加
            [m_pPrinterMgr AddPrinterDataAtIndex:[m_pPrinterMgr CountOfPrinterData]
                                       newObject:newData];
            
            // 新規追加
            nAddCount += 1;
        }
        // DATファイルに保存
        if(![m_pPrinterMgr SavePrinterData])
        {
            DLog(@"検索中メッセージ消去");
            // 検索中メッセージ消去
            [ex_alert dismissViewControllerAnimated:YES completion:^{
                [self alertButtonPushed:nil tagIndex:0 buttonIndex:0];
                [self makeTmpExAlert:nil message:MSG_SAVE_ERR cancelBtnTitle:MSG_BUTTON_OK okBtnTitle:nil tag:0];
            }];
            
            return;
        }
        
    }
    
    m_pPrinterMgr = [[PrinterDataManager alloc] init];
    // 最新プライマリキーを取得して選択中MFPを設定
    PrintOutDataManager* printOutManager = [[PrintOutDataManager alloc]init];
    [m_pPrinterMgr SetDefaultMFPIndex:[printOutManager GetLatestPrimaryKey] PrimaryKeyForCurrrentWifi:[printOutManager GetLatestPrimaryKeyForCurrentWiFi]];
    // TableView更新
    [self.tableView reloadData];
    
    DLog(@"検索中メッセージ消去");
    // 検索中メッセージ消去
    [ex_alert dismissViewControllerAnimated:YES completion:^{
        [self alertButtonPushed:nil tagIndex:0 buttonIndex:0];
        
        // 完了メッセージ
        NSString* pstrMessage = @"";
        if ([self.Services count] > 0)
        {
            if (nAddCount > 0)
            {
                pstrMessage = [NSString stringWithFormat:MSG_SEARCH_COMPLETE, nAddCount];
            }
            else
            {
                pstrMessage =MSG_SEARCH_COMPLETE_UPDATEONLY;
            }
        }
        else
        {
            pstrMessage =MSG_SEARCH_NOTHING;
        }
        [self makeTmpExAlert:nil message:pstrMessage cancelBtnTitle:MSG_BUTTON_OK okBtnTitle:nil tag:0];
    }];
}

// IPアドレス取得
- (NSString*)GetIpAddress:(NSNetService*)sender
{
    NSString* strRet = nil;
    NSArray* parrAddr;
    struct sockaddr* socketAddress;
    char hbuf[NI_MAXHOST];
    char sbuf[NI_MAXSERV];
    int nCount;
    
    parrAddr = [sender addresses];
    
    // 配列内で IPv4 アドレスを検索
    for (nCount = 0; nCount < [parrAddr count]; nCount++)
    {
        socketAddress = (struct sockaddr*)[[parrAddr objectAtIndex:nCount] bytes];
        
        // アドレスが IPv4 アドレスの場合にのみ続行する
        if (socketAddress && socketAddress->sa_family == AF_INET)
        {
            if (getnameinfo(socketAddress, socketAddress->sa_len, hbuf, sizeof(hbuf), sbuf, sizeof(sbuf), NI_NUMERICHOST | NI_NUMERICSERV) == 0) {
                strRet = [NSString stringWithCString:hbuf encoding:NSUTF8StringEncoding];
            }
        }
        
        // IPv6
        if (socketAddress && socketAddress->sa_family == AF_INET6) {
            if (getnameinfo(socketAddress, socketAddress->sa_len, hbuf, sizeof(hbuf), sbuf, sizeof(sbuf), NI_NUMERICHOST | NI_NUMERICSERV) == 0) {
                
                // inet_ptonで変換できる時のみ格納
                if ([CommonUtil isValidIPv6StringFormat:[NSString stringWithCString:hbuf encoding:NSUTF8StringEncoding]]) {
                    strRet = [NSString stringWithCString:hbuf encoding:NSUTF8StringEncoding];
                }
            }
        }

    }
    
    // IPアドレス返却
    return strRet;
}

/**
 @brief ホスト名とポート番号からIPアドレスを取得する
 @details 端末のIPアドレスを取得し、取得できたアドレス形式のアドレスを格納する。
 　　　　　 格納したアドレスを確認し、値のあるものを返却する。両方が格納されている場合はIPv4を返却する。
 　　　　　　(IPv4が格納されている時点でIPv4を返却する。)
 */
- (NSString*)getIpAddressFromHostName:(NSNetService*)sender {
    
    NSString *strHostName = [sender hostName];
    NSString *strPort = [NSString stringWithFormat:@"%@", [NSNumber numberWithInteger:[sender port]]];
    
    struct addrinfo hints;
    struct addrinfo *ai0 = NULL;    // addrinfoリストの先頭の要素
    struct addrinfo *ai;            // 処理中のaddrinfoリストの要素
    
    memset(&hints, 0, sizeof(hints));
    hints.ai_addrlen = sizeof(hints);
    hints.ai_socktype = SOCK_STREAM;
    hints.ai_protocol = IPPROTO_TCP;
    //hints.ai_flags = AI_PASSIVE;
    hints.ai_flags = AI_V4MAPPED | AI_ADDRCONFIG;
    
#ifdef IPV6_VALID
    // 端末のIPアドレスによって指定するfamilyを変える
    NetworkInformation *niManager = [[NetworkInformation alloc] init];
    if (niManager.primaryIPv4Address != nil && niManager.primaryIPv6Address != nil) {
        hints.ai_family = AF_UNSPEC;
    }
    else if (niManager.primaryIPv6Address != nil) {
        hints.ai_family = AF_INET6;
    }
    else  {
        hints.ai_family = AF_INET;
    }
#else
    hints.ai_family = AF_INET;
#endif
    
    char buf[1024];
    
    int err = getaddrinfo([strHostName UTF8String], [strPort UTF8String], &hints, &ai0);
    if (err != 0) {
        NSLog(@"getaddringoError : GetIpAddressFromHostName");
        return @"";
    }
    
    NSString *address = nil;
    NSString *address6 = nil;
    NSString *strRes = nil;
    
    // 得られたアドレス情報のループ
    for (ai = ai0; ai != NULL; ai = ai->ai_next) {
        
        if (ai != NULL) {
            
            if(!address && ai->ai_family == AF_INET)
            {
                struct in_addr addr = ((struct sockaddr_in *)(ai->ai_addr))->sin_addr;
                if(inet_ntop(AF_INET, &addr, buf, sizeof(buf)) == NULL){
                    perror("inet_ntop() of IPv6");
                    printf("inet_ntop() error\n");
                    //return;
                }
                address = [NSString stringWithCString:buf encoding:NSUTF8StringEncoding];
                
            }
            if (!address6 && ai->ai_family == AF_INET6)
            {
                // 16進数の一般的な表記に変換 bufに結果が入る
                struct in6_addr addr6 = ((struct sockaddr_in6 *)(ai->ai_addr))->sin6_addr;
                if(inet_ntop(AF_INET6, &addr6, buf, sizeof(buf)) == NULL){
                    perror("inet_ntop() of IPv6");
                    printf("inet_ntop() error\n");
                    //return;
                }
                printf("%s\n", buf);
                
                if ([CommonUtil isIPv6GlobalAddress:[NSString stringWithCString:buf encoding:NSUTF8StringEncoding]]) {
                    address6 = [NSString stringWithCString:buf encoding:NSUTF8StringEncoding];
                }
                
            }
        }
    }
    freeaddrinfo(ai0);
    
    if (address) {
        strRes = address;
    }
    else {
        strRes = address6;
    }
    
    return strRes;
}

// アラートボタン押下処理
-(void)alertButtonPushed:(UIAlertController *)alertController tagIndex:(NSInteger)tagIndex buttonIndex:(NSInteger)buttonIndex
{
    if(tagIndex == 1)
    {
        // スリープ可能状態に戻す
        [UIApplication sharedApplication].idleTimerDisabled = NO;
        SharpScanPrintAppDelegate* appDelegate = (SharpScanPrintAppDelegate*)[[UIApplication sharedApplication] delegate];

        switch (buttonIndex)
        {
            case 0:
                // キャンセル押下時
                [self StopSearchForSeviceOfTypeCloseAlert:FALSE];
                isEnd = TRUE;
                for (SnmpManager* manager in snmpManagerArray) {
                    [manager stopGetMib];
                }
                
                // 処理実行フラグOFF
                appDelegate.IsRun = FALSE;

                //                snmpManager = nil;
                break;
            default:
                break;
        }

        if (isEnd) {
            // 処理実行フラグOFF
            appDelegate.IsRun = FALSE;
        }

    } else {
        SharpScanPrintAppDelegate* appDelegate = (SharpScanPrintAppDelegate*)[[UIApplication sharedApplication] delegate];
        // 処理実行フラグOFF
        appDelegate.IsRun = FALSE;
    }
}

#pragma mark - RSHttpCommunicationManager delegate

-(void)rsManagerDidFinishParsing:(RSHttpCommunicationManager*)manager
{
    // 終了
    isParseEnd = YES;
}

-(void)rsManagerDidFailWithError:(RSHttpCommunicationManager*)manager
{
    // 終了
    isParseEnd = YES;
    DLog(@"Parse Failed.");
}

// アラート表示(インスタンス変数使用)
- (void)makeAlert:(NSString*)pstrTitle
          message:(NSString*)pstrMsg
   cancelBtnTitle:(NSString*)cancelBtnTitle
       okBtnTitle:(NSString*)okBtnTitle
              tag:(NSInteger)tag
{
    ex_alert = [ExAlertController alertControllerWithTitle:pstrTitle
                                                   message:pstrMsg
                                            preferredStyle:UIAlertControllerStyleAlert];
    ex_alert.tag = tag;
    
    // Cancel用のアクションを生成
    if (cancelBtnTitle != nil) {
        UIAlertAction *cancelAction =
        [UIAlertAction actionWithTitle:cancelBtnTitle
                                 style:UIAlertActionStyleCancel
                               handler:^(UIAlertAction * action) {
                                   
                                   // ボタンタップ時の処理
                                   [self alertButtonPushed:ex_alert tagIndex:tag buttonIndex:0];
                               }];
        // コントローラにアクションを追加
        [ex_alert addAction:cancelAction];
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
                                   [self alertButtonPushed:ex_alert tagIndex:tag buttonIndex:okIndex];
                               }];
        // コントローラにアクションを追加
        [ex_alert addAction:okAction];
    }
    // アラート表示処理
    [self presentViewController:ex_alert animated:YES completion:nil];
}

// アラート表示
- (void) makeTmpExAlert:(NSString*)pstrTitle
                message:(NSString*)pstrMsg
         cancelBtnTitle:(NSString*)cancelBtnTitle
             okBtnTitle:(NSString*)okBtnTitle
                    tag:(NSInteger)tag
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
    
    // アラート表示処理
    [self presentViewController:tmpAlert animated:YES completion:nil];
}

@end
