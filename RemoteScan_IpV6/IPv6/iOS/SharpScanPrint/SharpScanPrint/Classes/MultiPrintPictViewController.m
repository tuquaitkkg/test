
#import "MultiPrintPictViewController.h"
#import "MultiPrintPictCell.h"
#import "SelectFileViewController.h"
#import "MulitPrintPictPreViewController.h"
#import "SendExSitePictViewController.h"

#import "SharpScanPrintAppDelegate.h"

#import <CFNetwork/CFNetwork.h>
#import <UIKit/UIKit.h>
#import "NSStreamAdditions.h"
#import "CommonManager.h"
#import "SharpScanPrintAppDelegate.h"
#import "ProfileDataManager.h"
#import "ProfileData.h"
#import "NUpViewController.h"
#import <ImageIO/ImageIO.h>
#import <AssetsLibrary/AssetsLibrary.h>

#import "RetentionSettingViewController.h"
#import "PrintRangeSettingViewController.h"
#import "ImageProcessing.h"

#import "SelectFileViewController.h"

// Socket通信用
#import <netinet/in.h>
#import <sys/socket.h>
#import <arpa/inet.h>
#import <netdb.h>      // IPv6対応

@interface MultiPrintPictViewController ()
{
}

@end

@implementation MultiPrintPictViewController

static void SocketCallBackForMulti(CFSocketRef socket, CFSocketCallBackType type, CFDataRef address, const void *data, void *info);

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
    // Do any additional setup after loading the view from its nib.
    
    //self.m_commProcessData = nil;
    //self.isDuringCommProcess = nil;

    self.addFileButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.addFileButton.frame = CGRectMake(45, 5, 50, 50);
    self.addFileButton.backgroundColor = [UIColor whiteColor];
    if (self.PrintPictViewID == PPV_PRINT_SELECT_FILE_CELL || self.PrintPictViewID == PPV_PRINT_MAIL_ATTACHMENT_CELL) {
        [self.addFileButton setBackgroundImage:[UIImage imageNamed:S_ICON_ADDPAGE] forState:UIControlStateNormal];
    } else if (self.PrintPictViewID == PPV_PRINT_SELECT_PICTURE_CELL) {
        [self.addFileButton setBackgroundImage:[UIImage imageNamed:S_ICON_ADDPAGE] forState:UIControlStateNormal];
    }
    [self.addFileButton addTarget:self action:@selector(addFileButtonPushed:) forControlEvents:UIControlEventTouchUpInside];
    
    self.editFileButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.editFileButton.frame = CGRectMake(130, 5, 50, 50);
    self.editFileButton.backgroundColor = [UIColor whiteColor];
    if (self.PrintPictViewID == PPV_PRINT_SELECT_FILE_CELL || self.PrintPictViewID == PPV_PRINT_MAIL_ATTACHMENT_CELL) {
        [self.editFileButton setBackgroundImage:[UIImage imageNamed:S_ICON_DELPAGE] forState:UIControlStateNormal];
    } else if (self.PrintPictViewID == PPV_PRINT_SELECT_PICTURE_CELL) {
        [self.editFileButton setBackgroundImage:[UIImage imageNamed:S_ICON_DELPAGE] forState:UIControlStateNormal];
    }
    [self.editFileButton addTarget:self action:@selector(editFileButtonPushed:) forControlEvents:UIControlEventTouchUpInside];
    
    self.selectFileArray = [[NSMutableArray alloc]initWithArray:self.selectFileArray];
    self.selectPictArray = [[NSMutableArray alloc]initWithArray:self.selectPictArray];
    
    if (self.PrintPictViewID == PPV_PRINT_SELECT_FILE_CELL || self.PrintPictViewID == PPV_PRINT_MAIL_ATTACHMENT_CELL) {
        if (self.selectFileArray.count > 1) {
            ScanData *scanData = [self.selectFileArray firstObject];
            self.SelFilePath = [NSString stringWithFormat:@"%@%@",scanData.fpath,scanData.fname];
        } else {
            ScanData *scanData = [self.selectFileArray firstObject];
            self.SelFilePath = [NSString stringWithFormat:@"%@%@",scanData.fpath,scanData.fname];
        }
    } else if (self.PrintPictViewID == PPV_PRINT_SELECT_PICTURE_CELL) {
        if (self.selectPictArray.count > 1) {
            self.PictEditInfo = self.selectPictArray.firstObject;
        } else {
            self.PictEditInfo = self.selectPictArray.firstObject;
        }
    }
    self.currentNum = 0;
    
    self.isFirstPrint = YES;
    self.isNextPrint = NO;
    self.isLastPrint = NO;
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.currentNum = 0;
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)addFileButtonPushed:(id)sender {
    
    // 通信中は処理しない
    if (self.isDuringCommProcess) {
        return;
    }
    
    
    if (self.PrintPictViewID == PPV_PRINT_SELECT_FILE_CELL) {
        // 複数印刷対応
        SelectFileViewController *pViewController = [[SelectFileViewController alloc]init];
        pViewController.PrevViewID = PV_PRINT_SELECT_FILE_CELL;
        UINavigationController *nc = [[UINavigationController alloc]initWithRootViewController:pViewController];
        nc.navigationBar.barStyle = NAVIGATION_BARSTYLE;
        [self presentViewController:nc animated:YES completion:nil];
    } else if (self.PrintPictViewID == PPV_PRINT_SELECT_PICTURE_CELL) {
        // 複数印刷対応
        if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
            ELCAlbumPickerController *albumController = [[ELCAlbumPickerController alloc] initWithNibName:@"ELCAlbumPickerController" bundle:[NSBundle mainBundle]];
            ELCImagePickerController *elcPicker = [[ELCImagePickerController alloc] initWithRootViewController:albumController];
            albumController.navigationController.navigationBar.barStyle = NAVIGATION_BARSTYLE;
            [albumController setParent:elcPicker];
            [elcPicker setDelegate:self];
            [elcPicker setMaximumImagesCount:-1];
            [self presentViewController:elcPicker animated:YES completion:nil];
        }
    }else if (self.PrintPictViewID == PPV_PRINT_MAIL_ATTACHMENT_CELL) {
        // 複数印刷対応
        AttachmentMailViewController* pViewController = [[AttachmentMailViewController alloc] init];
        pViewController.delegate = self;
        pViewController.selectFilePathArray = self.selectFileArray;
        UINavigationController *nc = [[UINavigationController alloc]initWithRootViewController:pViewController];
        nc.navigationBar.barStyle = NAVIGATION_BARSTYLE;

        [self presentViewController:nc animated:YES completion:nil];
    }
}

- (void)editFileButtonPushed:(id)sender {
    
    // 通信中は処理しない
    if (self.isDuringCommProcess) {
        return;
    }
    
    _tableView.editing = !_tableView.editing;
    // TODO: if文おかしい
    if (_tableView.editing) {
        if (self.PrintPictViewID == PPV_PRINT_SELECT_FILE_CELL || self.PrintPictViewID == PPV_PRINT_MAIL_ATTACHMENT_CELL) {
            [self.editFileButton setBackgroundImage:[UIImage imageNamed:S_ICON_EDIT_FINISH] forState:UIControlStateNormal];
        } else if (self.PrintPictViewID == PPV_PRINT_SELECT_PICTURE_CELL) {
            [self.editFileButton setBackgroundImage:[UIImage imageNamed:S_ICON_EDIT_FINISH] forState:UIControlStateNormal];
        }
    } else {
        if (self.PrintPictViewID == PPV_PRINT_SELECT_FILE_CELL || self.PrintPictViewID == PPV_PRINT_MAIL_ATTACHMENT_CELL) {
            [self.editFileButton setBackgroundImage:[UIImage imageNamed:S_ICON_DELPAGE] forState:UIControlStateNormal];
        } else if (self.PrintPictViewID == PPV_PRINT_SELECT_PICTURE_CELL) {
            [self.editFileButton setBackgroundImage:[UIImage imageNamed:S_ICON_DELPAGE] forState:UIControlStateNormal];
        }
    }
}

#pragma mark - ELCImagePickerControllerDelegate
// 複数印刷対応
- (void)elcImagePickerController:(ELCImagePickerController *)picker didFinishPickingMediaWithInfo:(NSArray *)info {
    DLog(@"info = %@",info);
    [self.selectPictArray addObjectsFromArray:info];
    NSNotification *n = [NSNotification notificationWithName:NK_PICT_EDIT_ACTION object:self.selectPictArray];
    NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
    [nc postNotification:n];
    [self.tableView reloadData];
    [self updateMenuButton];

    [self dismissViewControllerAnimated:YES completion:nil];
}

// 複数印刷対応
- (void)elcImagePickerControllerDidCancel:(ELCImagePickerController *)picker {
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - UITableViewDelegate

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCellEditingStyle style;
    
    // 通信中はセルのスタイルをNone
    if (self.isDuringCommProcess) {
        style = UITableViewCellEditingStyleNone;
    }
    else {
        style = UITableViewCellEditingStyleDelete;
    }
    
    return style;
}

- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
	return YES;
}

- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)sourceIndexPath toIndexPath:(NSIndexPath *)destinationIndexPath {
    NSInteger toIndex = destinationIndexPath.row;
	NSInteger fromIndex = sourceIndexPath.row;
    if (self.PrintPictViewID == PPV_PRINT_SELECT_FILE_CELL || self.PrintPictViewID == PPV_PRINT_MAIL_ATTACHMENT_CELL) {
        id obj = [self.selectFileArray objectAtIndex:fromIndex];
        [self.selectFileArray removeObjectAtIndex:fromIndex];
        [self.selectFileArray insertObject:obj atIndex:toIndex];
        if ([self.mppvcDelegate respondsToSelector:@selector(updatePrintFileArray:)]) {
            [self.mppvcDelegate updatePrintFileArray:self.selectFileArray];
        }
    } else if (self.PrintPictViewID == PPV_PRINT_SELECT_PICTURE_CELL) {
        id obj = [self.selectPictArray objectAtIndex:fromIndex];
        [self.selectPictArray removeObjectAtIndex:fromIndex];
        [self.selectPictArray insertObject:obj atIndex:toIndex];
        NSNotification *n = [NSNotification notificationWithName:NK_PICT_EDIT_ACTION object:self.selectPictArray];
        [[NSNotificationCenter defaultCenter]postNotification:n];
    }
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    // 通信中は削除処理しない
    if (self.isDuringCommProcess) {
        return;
    }
    
    [self.tableView beginUpdates];
    [self.tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
    if (self.PrintPictViewID == PPV_PRINT_SELECT_FILE_CELL || self.PrintPictViewID == PPV_PRINT_MAIL_ATTACHMENT_CELL) {
        [self.selectFileArray removeObjectAtIndex:indexPath.row];
        if ([self.mppvcDelegate respondsToSelector:@selector(updatePrintFileArray:)]) {
            [self.mppvcDelegate updatePrintFileArray:self.selectFileArray];
        }
    } else if (self.PrintPictViewID == PPV_PRINT_SELECT_PICTURE_CELL) {
        [self.selectPictArray removeObjectAtIndex:indexPath.row];
        NSNotification *n = [NSNotification notificationWithName:NK_PICT_EDIT_ACTION object:self.selectPictArray];
        NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
        [nc postNotification:n];
    }
    [self.tableView endUpdates];
    
    [self updateMenuButton];
    
    [self.tableView reloadData];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSInteger numOfRows = 0;
    if (self.PrintPictViewID == PPV_PRINT_SELECT_FILE_CELL || self.PrintPictViewID == PPV_PRINT_MAIL_ATTACHMENT_CELL) {
        numOfRows = self.selectFileArray.count;
    } else if (self.PrintPictViewID == PPV_PRINT_SELECT_PICTURE_CELL) {
        numOfRows = self.selectPictArray.count;
    }
    return numOfRows;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"CellIdentifier";
    MultiPrintPictCell *cell = (MultiPrintPictCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[MultiPrintPictCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    cell.selectImgView = nil;
    
    if (self.PrintPictViewID == PPV_PRINT_SELECT_FILE_CELL || self.PrintPictViewID == PPV_PRINT_MAIL_ATTACHMENT_CELL) {
        [cell setModel:[self.selectFileArray objectAtIndex:indexPath.row]hasDisclosure:FALSE];
    } else if (self.PrintPictViewID == PPV_PRINT_SELECT_PICTURE_CELL) {
        if (isIOS8_1Later) {
            [cell setPictModelByPhotos:[self.selectPictArray objectAtIndex:indexPath.row]];
        } else {
            [cell setPictModel:[self.selectPictArray objectAtIndex:indexPath.row]];
        }
    }
    return cell;
}

-(NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    return indexPath;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (self.PrintPictViewID == PPV_PRINT_SELECT_FILE_CELL || self.PrintPictViewID == PPV_PRINT_MAIL_ATTACHMENT_CELL) {
        MulitPrintPictPreViewController *pVC = [[MulitPrintPictPreViewController alloc]initWithNibName:@"SendExSitePictViewController" bundle:[NSBundle mainBundle]];
        pVC.PrintPictViewID = PPV_PRINT_MULTI_FILE_PREVIEW;
        ScanData *scanData = [self.selectFileArray objectAtIndex:indexPath.row];
        DLog(@"fullPath = %@%@",scanData.fpath,scanData.fname);
        DLog(@"imagePath = %@",scanData.imagename);
        pVC.SelFilePath = [NSString stringWithFormat:@"%@%@",scanData.fpath,scanData.fname];
        [self.navigationController pushViewController:pVC animated:YES];
    } else if (self.PrintPictViewID == PPV_PRINT_SELECT_PICTURE_CELL) {
        MulitPrintPictPreViewController *pVC = [[MulitPrintPictPreViewController alloc]initWithNibName:@"SendExSitePictViewController" bundle:[NSBundle mainBundle]];
        pVC.PrintPictViewID = PPV_OTHER;
        NSDictionary *info = [self.selectPictArray objectAtIndex:indexPath.row];
        for (NSInteger i = 0; i < [[info allKeys] count]; i++)
        {
            DLog(@"key: %@, value:%@", [[info allKeys] objectAtIndex:i], [info objectForKey:[[info allKeys] objectAtIndex:i]]);
        }
        if(![self.SelFilePath isEqualToString:self.indicatingImagePath]){
            pVC.PictEditInfo = info;        // image情報格納
        }
        pVC.IsPhotoView = TRUE;         // 遷移元画面設定
        
        [self.navigationController pushViewController:pVC animated:YES];
    }
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

// テーブルビュー 縦幅設定
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return N_HEIGHT_SEL_FILE;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 60;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    UIView *footerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 320, 60)];
    footerView.backgroundColor = [UIColor whiteColor];
    [footerView addSubview:self.addFileButton];
    [footerView addSubview:self.editFileButton];
    return footerView;
}

#pragma mark -

- (void)updateMenuButton {
    PrinterData* printerData = nil;
    printerData = [m_pPrinterMgr LoadPrinterDataAtIndexInclude2:[super getSelPickerRowWithIndex:BUTTON_PRINTER]];
    
    if ((self.selectFileArray.count == 0 && self.selectPictArray.count == 0) || printerData == nil) {
        [self SetButtonEnabled:NO];
        [self SetButtonEnabledDeleted:NO];
    } else {
        [self SetButtonEnabled:YES];
        [self SetButtonEnabledDeleted:YES];
        // はがき(など)選択時のボタン設定
        //[self paperSizeSelectAction];
        [super setDuplexBtnEnabled];
        
        // プリントリリース、リテンション活性/非活性処理
        [super setRetontionPrintReleaseBtnEnabled];
    }
}

#pragma mark - NSStreamDelegateMethods

// FTP送信Callback関数
- (void)stream:(NSStream *)aStream handleEvent:(NSStreamEvent)eventCode
{
    DLog(@"eventCode=%zd",eventCode);
    DLog(@"fist:%d, next:%d, last:%d", self.isFirstPrint, self.isNextPrint, self.isLastPrint);
    
    
    // タイマー停止
    if (nil != tm)
    {
        [tm invalidate];
        tm = nil;
    }
    
#pragma unused(aStream)
    [NSThread sleepUntilDate: [NSDate dateWithTimeIntervalSinceNow: 0.1]];
    assert(aStream == self.NetworkStream);
    CommonManager* commanager = [[CommonManager alloc]init];
    [commanager myrunLoop:0.5];
    
    switch (eventCode)
    {
        case NSStreamEventOpenCompleted:
			// timeoutタイマー開始
			tm =[NSTimer scheduledTimerWithTimeInterval:[self getJobTimeOut]
                                                 target:self
                                               selector:@selector(timerHandler:)
                                               userInfo:nil
                                                repeats:NO];
            if(!m_isCacel)
            {
                //
                // ランループの実行
                //
                
                //既に出ているアラートを消す
                [self dismissAlertView];
                
                SharpScanPrintAppDelegate* appDelegate = (SharpScanPrintAppDelegate*)[[UIApplication sharedApplication] delegate];
                // 処理実行フラグON
                appDelegate.IsRun = TRUE;
                
                //複数印刷の場合のメッセージ（進捗表示）
                NSString *msg = MSG_PRINT_FORWARD;
                if (self.PrintPictViewID == PPV_PRINT_SELECT_FILE_CELL || self.PrintPictViewID == PPV_PRINT_MAIL_ATTACHMENT_CELL)
                {
                    msg = [NSString stringWithFormat:@"%@ (%zd/%zd)",MSG_PRINT_FORWARD,self.currentNum+1, _filesToBePrintedArray.count];
                }
                else if (self.PrintPictViewID == PPV_PRINT_SELECT_PICTURE_CELL)
                {
                    msg = [NSString stringWithFormat:@"%@ (%zd/%zd)",MSG_PRINT_FORWARD,self.currentNum+1, self.selectPictArray.count];
                }
                //新たに転送中アラートを生成
                [self makePictureAlert:nil message:msg cancelBtnTitle:nil okBtnTitle:nil tag:1 showFlg:YES];
                
            }
            
            break;
            
        case NSStreamEventHasBytesAvailable:
            // FTP送信では発生しない
            assert(NO);
            break;
            
        case NSStreamEventHasSpaceAvailable://書き込み可能タイミング
			// タイマー開始
			tm =[NSTimer scheduledTimerWithTimeInterval:[self getJobTimeOut]
                                                 target:self
                                               selector:@selector(timerHandler:)
                                               userInfo:nil
                                                repeats:NO];
            // If we don't have any data buffered, go read the next chunk of data.
            if (self.BufferOffset == self.BufferLimit)
            {
                NSInteger bytesRead;
                
                bytesRead = [self.FileStream read:self.Buffer maxLength:kSendBufferSize];
                
                if (bytesRead == -1)
                {
                    [self StopSendWithStatus:MSG_PRINT_ERR];
                }
                else if (bytesRead == 0)
                {
                    self.BufferOffset = 0;
                    [self.NetworkStream write:&self.Buffer[self.BufferOffset]
                                    maxLength:0];
                    break;
                }
                else
                {
                    self.BufferOffset = 0;
                    self.BufferLimit  = bytesRead;
                }
            }
            
            // If we're not out of data completely, send the next chunk.
            if (self.BufferOffset != self.BufferLimit)
            {
                NSInteger   bytesWritten;
                bytesWritten = [self.NetworkStream write:&self.Buffer[self.BufferOffset]
                                               maxLength:self.BufferLimit - self.BufferOffset];
                assert(bytesWritten != 0);
                if (bytesWritten == -1)
                {
                    [self StopSendWithStatus:MSG_PRINT_ERR];
                }
                else
                {
                    self.BufferOffset += bytesWritten;
                }
            }
            
            break;
            
        case NSStreamEventErrorOccurred:
            DLog(@"case NSStreamEventErrorOccurred:");
            [self StopSendWithStatus:MSG_PRINT_ERR];
            
            break;
        case NSStreamEventEndEncountered:
            DLog(@"case NSStreamEventEndEncountered: ");
            m_bRet = TRUE;
            
            if (self.isFirstPrint && !self.isLastPrint)
            {//最初の印刷だったなら、
                if (self.PrintPictViewID == PPV_PRINT_SELECT_FILE_CELL && _filesToBePrintedArray.count == 1)
                {
                    self.isFirstPrint = NO;
                    self.isLastPrint = YES;
                    //終了
                    [self StopSendWithStatus:MSG_PRINT_COMPLETE];
                }
                else if (self.PrintPictViewID == PPV_PRINT_MAIL_ATTACHMENT_CELL && _filesToBePrintedArray.count == 1)
                {
                    self.isFirstPrint = NO;
                    self.isLastPrint = YES;
                    //終了
                    [self StopSendWithStatus:MSG_PRINT_COMPLETE];
                }
                else if (self.PrintPictViewID == PPV_PRINT_SELECT_PICTURE_CELL && _filesToBePrintedArray.count == 1)
                {
                    self.isFirstPrint = NO;
                    self.isLastPrint = YES;
                    //終了
                    [self StopSendWithStatus:MSG_PRINT_COMPLETE];
                }
                else
                {
                    //次へ
                    [self nextPrint];
                }
            }
            else if (self.isNextPrint)
            {//２つめ以降のの印刷だったなら
                //次に進む
                [self nextPrint];
            }
            else if (self.isLastPrint)
            {//最後の印刷だったなら
                //終了
                [self StopSendWithStatus:MSG_PRINT_COMPLETE];
                if (self.PrintPictViewID == PPV_PRINT_MAIL_ATTACHMENT_CELL) {
                    //メール添付ファイル印刷でできたフォルダを削除する
                    [TempAttachmentFileUtility deleteMailTmpDir];
                }
            }
            break;
        default:
            assert(NO);
            break;
    }
}

#pragma mark - alertCreate  : See PictureViewController.

#pragma mark - alertViewDelegateMethods
//ダイアログのボタン押下時
-(void)alertButtonPushed:(UIAlertController *)alertController tagIndex:(NSInteger)tagIndex buttonIndex:(NSInteger)buttonIndex
{
    [self alertButtonClicked:alertController tagIndex:tagIndex buttonIndex:buttonIndex];
    [self alertButtonDismiss:alertController tagIndex:tagIndex buttonIndex:buttonIndex];
}

// アラートボタン押下処理
-(void)alertButtonClicked:(UIAlertController *)alertController tagIndex:(NSInteger)tagIndex buttonIndex:(NSInteger)buttonIndex
{
    SharpScanPrintAppDelegate* appDelegate = (SharpScanPrintAppDelegate*)[[UIApplication sharedApplication] delegate];
    // 処理実行フラグoff
    appDelegate.IsRun = FALSE;
    
    switch (buttonIndex)
    {
        case 0://キャンセルボタン
            self.isContinuePrint = NO;
            
            if (tagIndex == 1) {
                // キャンセル操作
                _printCancelled = YES;//キャンセルフラグ
                m_isPrintStop = TRUE;
                
                DLog(@"印刷中断");
                if (m_isUseRawPrintMode) {
                    DLog(@"RAW印刷");
                } else if (self.NetworkStream != nil) {
                    DLog(@"FTP印刷");
                    [self networkStreamClose];
                }
                [self fileStreamClose];
                if (!m_isStop) {
                    m_isStop = YES;
                    m_bSendFile = FALSE;
                    m_isCacel = TRUE;
                    [m_pCmnMgr removeFile:self.PjlFileName];
                    
                    // 印刷中断アラート
                    [self makePictureAlert:nil message:MSG_PRINT_CANCEL cancelBtnTitle:MSG_BUTTON_OK okBtnTitle:nil tag:0 showFlg:YES];
                }
            }
            
            if (m_bRet) {
                m_isPrintStop = TRUE;
            } else {
                if(m_isStopSend)
                {
                    m_isPrintStop = TRUE;
                    m_isStopSend = FALSE;
                }
                if(ALERT_TAG_PRINT_CONFIRM == tagIndex)
                {
                    m_isPrintStop = TRUE;
                }
                if (m_bSendFile)
                {
                    // キャンセル操作
                    m_isCacel = TRUE;
                    [self StopSendWithStatus:MSG_PRINT_CANCEL];
                    [m_pCmnMgr removeFile:self.PjlFileName];
                }
                if(m_isDoSnmp)
                {
                    //SNMP取得時のキャンセル
                    m_isDoSnmp = NO;
                    [snmpManager stopGetMib];
                    snmpManager = NULL;
                }
            }
            break;
            
        default://OKボタン
            if(m_bShowMenu)
            {
                [self AnimationShowMenu];
            }
            else if (ALERT_TAG_PRINT_CONFIRM_OPTION_ERROR_RECONFIRM == tagIndex)//一つでも印刷不能ファイルがある場合
            {
                //印刷再確認
                self.hasEncryptionPdfData = NO;
                //印刷
                if(_filesToBePrintedArray.count > 0){
                    [self getData];
                    [self doPrint];
                }
            }
            break;
    }
}

// アラートボタンによる処理(アラートが閉じた後に呼ばれるメソッド)
-(void)alertButtonDismiss:(UIAlertController *)alertController tagIndex:(NSInteger)tagIndex buttonIndex:(NSInteger)buttonIndex
{
    SharpScanPrintAppDelegate* appDelegate = (SharpScanPrintAppDelegate*)[[UIApplication sharedApplication] delegate];
    // 処理実行フラグoff
    appDelegate.IsRun = FALSE;
    
    if(m_isPrintStop || !m_bResult) {
        SharpScanPrintAppDelegate* appDelegate = (SharpScanPrintAppDelegate*)[[UIApplication sharedApplication] delegate];
        // 処理実行フラグOFF
        appDelegate.IsRun = FALSE;
        m_isPrintStop = FALSE;
        m_bResult = TRUE;
        
        //中断後、再印刷可能にする処理
        //m_pThread = NO;
        //m_bAbort = NO;
        m_bSendFile = NO;
    }

    if(tagIndex == ALERT_TAG_PREVIEW_MEMORY_ERROR)
    {
        [self.navigationController popViewControllerAnimated:YES];
        return;
    }
    
    //
    // PROFILE情報の取得
    //
    profileDataManager = [[ProfileDataManager alloc] init];
    ProfileData *profileData = nil;
    profileData = [profileDataManager loadProfileDataAtIndex:0];
    
    switch (tagIndex)
    {
        case ALERT_TAG_PROGRESS_ALERT:
            break;
            
        case 2:
            break;
        case 3:
        {
            // 内部メモリへの保存
            // プライマリキー
            if(profileData.autoSelectMode)
            {
                PrinterData* printerData = nil;
                printerData = [m_pPrinterMgr LoadPrinterDataAtIndexInclude2:[super getSelPickerRowWithIndex:BUTTON_PRINTER]];

                [m_pPrintOutMgr SetLatestPrimaryKey:[printerData PrimaryKey]];
            }
            [self performSelector:@selector(moveView) withObject:nil afterDelay:0.1];
        }
            break;
        case 4:
        {
            switch (buttonIndex)
            {
                case 0:
                    // TOPメニューに戻る
                    [self.navigationController popToRootViewControllerAnimated:YES];
                    break;
                case 1:
                    // 前画面に戻る
                    [self.navigationController popViewControllerAnimated:YES];
                    break;
                default:
                    break;
            }
        }
            break;
           
        case ALERT_TAG_PRINT_CONFIRM://印刷確認
        {
            if (buttonIndex == 1) {
                // 初期化
                _printCancelled = NO;
                self.canPrint = NO;
                self.canPrintPDF = NO;
                self.canPrintOffice = NO;

                if(self.PrintPictViewID == PPV_PRINT_SELECT_PICTURE_CELL)
                {
                    [self checkMenuOptionStatus];
                    
                    if(self.isN_UpSet)
                    {
                        NSMutableString *errorMsg = [NSMutableString string];
                        [errorMsg appendFormat:@"%@\n\n",MSG_NOTPRINT_ALL];
                        [errorMsg appendFormat:@"%@\n",MSG_NOTPRINT_NUP];
                        [self CreateAllert:nil message:errorMsg btnTitle:MSG_BUTTON_OK];
                    }
                    else
                    {
                        // 複合機が「自動」か「手動」かを判定し、自動の場合のみ「プリンター情報取得アラート」を表示する
                        PrinterData* printerData = [m_pPrinterMgr LoadPrinterDataAtIndexInclude2:[self getSelPickerRowWithIndex:BUTTON_PRINTER]];
                        if([printerData getAddStatus]) {
                            // 手動追加MFPの場合はすべて印刷可能扱いとする。
                            self.canPrint = YES;
                            self.canPrintPDF = YES;
                            self.canPrintOffice = YES;
                        } else {
                            // 自動追加MFPの場合
                            [self CreateProgressAlert:nil message:MSG_PRINTEROPTION_GET withCancel:YES];
                        }
                        
                        [self updateMenuAndDataArray];
                        [self updatePrintData];
                        if(!_printCancelled){
                            dispatch_async(dispatch_get_main_queue(), ^{
                                switch (self.selectPictArray.count) {
                                    case 0:
                                        self.isFirstPrint = NO;
                                        self.isNextPrint = NO;
                                        self.isLastPrint = YES;
                                        break;
                                    case 1:
                                        self.isFirstPrint = YES;
                                        self.isNextPrint = NO;
                                        self.isLastPrint = YES;
                                        break;
                                    default:
                                        self.isFirstPrint = YES;
                                        self.isNextPrint = YES;
                                        self.isLastPrint = NO;
                                        break;
                                }
                                self.currentNum = 0;
                                [self doSnmp];
                            });
                        }
                    }
                }
                else
                {
                    
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [self multiPrintCheck];
                    });
                }
                return;
            }
        }
            break;
        case ALERT_TAG_COMMPROCESS: //プリンター/スキャナー情報の取得中です。
            break;
        
        default:
            break;
    }
}

#pragma mark -

- (void)multiPrintCheckForAttachmentFile{
    
    TempAttachmentFiles *localAttachmentFiles = [[TempAttachmentFiles alloc]init];
    NSMutableArray *fileArray = [[NSMutableArray alloc]init];
    
    for(int i = 0;i < self.selectFileArray.count ;i ++ ){
        NSString * filePath = [[self.selectFileArray objectAtIndex:i] fpath];
        filePath = [filePath stringByAppendingPathComponent:[[self.selectFileArray objectAtIndex:i] fname]];
        TempAttachmentFile *localAttachmentFile = [[TempAttachmentFile alloc]initWithFilePath:filePath ];
        [fileArray addObject:localAttachmentFile];
    }
    
    localAttachmentFiles.attachmentFiles = fileArray;
    
    //別スレッドで処理
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        [self checkMenuOptionStatus];
        if(![self checkPclPsOfficeOption]) return;
        if(_printCancelled)
        {
            return;
        }
        // 複数ファイル印刷でPCLなしエラー
        if(!self.canPrint)
        {
            dispatch_async(dispatch_get_main_queue(), ^{
                // PCLオプションなし
                [self CreateAllert:nil message:MSG_NO_PRINTOPTION_PCL btnTitle:MSG_BUTTON_OK];
            });
            return;
        }
        [self updateMenuAndDataArray];
        [self updatePrintData];
        
        if (self.isOptionError == YES)
        {//オプションエラー
            NSMutableString *errorMsg = [NSMutableString string];
            
            if(![localAttachmentFiles hasPrintableFile :self.canPrintPDF :self.isN_UpSet :self.isRetentionSet :self.canPrintOffice]){
                [errorMsg appendFormat:@"%@\n\n",MSG_NOTPRINT_ALL];
                //"以下の理由により印刷できるファイルはありません。"
            }else if(self.selectFileArray.count > 0) {
                [errorMsg appendFormat:@"%@\n\n",MSG_NOTPRINT_CONFIRM];
                //"以下の理由により印刷できないファイルがあります。"
            }
            if( ![localAttachmentFiles isPrintablePS:self.canPrintPDF]){
                [errorMsg appendFormat:@"%@\n",MSG_NOTPRINT_PS];
            }
            if( self.isN_UpSet && ![localAttachmentFiles isNupCapable]){
                [errorMsg appendFormat:@"%@\n",MSG_NOTPRINT_NUP];
            }
            if( self.isRetentionSet && ![localAttachmentFiles isRetensionCapable]){
                [errorMsg appendFormat:@"%@\n",MSG_NOTPRINT_RETENTION];
            }
            if( ![localAttachmentFiles isPrintableOffice:self.canPrintOffice]) {
                [errorMsg appendFormat:@"%@\n",MSG_NOTPRINT_OFFICE];
            }
            
            // 今出てるアラートを消す
//            [self dismissMyAlert:0];
            [self dismissAlertView];
            dispatch_async(dispatch_get_main_queue(), ^{
                
                if(![localAttachmentFiles hasPrintableFile :self.canPrintPDF :self.isN_UpSet :self.isRetentionSet :self.canPrintOffice ]){
                    // OKボタン
                    [self CreateAllert:nil message:errorMsg btnTitle:MSG_BUTTON_OK];
                } else {
                    // OK、キャンセルボタン
                    [self CreateAllert:nil
                               message:errorMsg
                              btnTitle:MSG_BUTTON_OK
                        cancelBtnTitle:MSG_BUTTON_CANCEL
                               withTag:ALERT_TAG_PRINT_CONFIRM_OPTION_ERROR_RECONFIRM];
                }
            });
            
        } else {
            
            switch (_filesToBePrintedArray.count) {
                case 0:
                    self.isFirstPrint = NO;
                    self.isNextPrint = NO;
                    self.isLastPrint = YES;
                    break;
                case 1:
                    self.isFirstPrint = YES;
                    self.isNextPrint = NO;
                    self.isLastPrint = YES;
                    break;
                default:
                    self.isFirstPrint = YES;
                    self.isNextPrint = YES;
                    self.isLastPrint = NO;
                    break;
            }
            self.currentNum = 0;
            
            
            if(!_printCancelled)[self doSnmp];
        }
    });
}


- (void)multiPrintCheck
{
    if(self.PrintPictViewID == PPV_PRINT_MAIL_ATTACHMENT_CELL){
        [self multiPrintCheckForAttachmentFile];
    } else {
        ScanFiles *localScanFiles = [[ScanFiles alloc]init];
        NSMutableArray *fileArray = [[NSMutableArray alloc]init];
        
        for(int i = 0;i < self.selectFileArray.count ;i ++ ){
            NSString * filePath = [[self.selectFileArray objectAtIndex:i] fpath];
            filePath = [filePath stringByAppendingPathComponent:[[self.selectFileArray objectAtIndex:i] fname]];
            ScanFile *localScanFile = [[ScanFile alloc]initWithScanFilePath:filePath];
            [fileArray addObject:localScanFile];
        }
        localScanFiles.scanFiles = fileArray;

        //別スレッドで処理
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            
            [self checkMenuOptionStatus];
            if(![self checkPclPsOfficeOption]) return;
            if(_printCancelled)
            {
                return;
            }
            // 複数ファイル印刷でPCLなしエラー
            if(!self.canPrint)
            {
                dispatch_async(dispatch_get_main_queue(), ^{
                    // PCLオプションなし
                    [self CreateAllert:nil message:MSG_NO_PRINTOPTION_PCL btnTitle:MSG_BUTTON_OK];
                });
                return;
            }
            [self updateMenuAndDataArray];
            [self updatePrintData];
            
            if (self.isOptionError == YES)
            {//オプションエラー
                NSMutableString *errorMsg = [NSMutableString string];
                
                if(![localScanFiles hasPrintableFile :self.canPrintPDF :self.isN_UpSet :self.isRetentionSet :self.canPrintOffice ]){
                    [errorMsg appendFormat:@"%@\n\n",MSG_NOTPRINT_ALL];
                    //"以下の理由により印刷できるファイルはありません。"
                }else if(self.selectFileArray.count > 0) {
                    [errorMsg appendFormat:@"%@\n\n",MSG_NOTPRINT_CONFIRM];
                    //"以下の理由により印刷できないファイルがあります。"
                }
                if( ![localScanFiles isPrintablePS:self.canPrintPDF]){
                    [errorMsg appendFormat:@"%@\n",MSG_NOTPRINT_PS];
                }
                if( self.isN_UpSet && ![localScanFiles isNupCapable]){
                    [errorMsg appendFormat:@"%@\n",MSG_NOTPRINT_NUP];
                }
                if( self.isRetentionSet && ![localScanFiles isRetensionCapable]){
                    [errorMsg appendFormat:@"%@\n",MSG_NOTPRINT_RETENTION];
                }
                
                if( ![localScanFiles isPrintableOffice:self.canPrintOffice]) {
                    [errorMsg appendFormat:@"%@\n",MSG_NOTPRINT_OFFICE];
                }
                
                // 今出てるアラートを消す
//                [self dismissMyAlert:0];
                [self dismissAlertView];
                dispatch_async(dispatch_get_main_queue(), ^{
                    
                    if(![localScanFiles hasPrintableFile :self.canPrintPDF :self.isN_UpSet :self.isRetentionSet :self.canPrintOffice ]){
                        // OKボタン
                        [self CreateAllert:nil message:errorMsg btnTitle:MSG_BUTTON_OK];
                    } else {
                        // OK、キャンセルボタン
                        [self CreateAllert:nil
                                   message:errorMsg
                                  btnTitle:MSG_BUTTON_OK
                            cancelBtnTitle:MSG_BUTTON_CANCEL
                                   withTag:ALERT_TAG_PRINT_CONFIRM_OPTION_ERROR_RECONFIRM];
                    }
                });
                
            } else {
                
                switch (_filesToBePrintedArray.count) {
                    case 0:
                        self.isFirstPrint = NO;
                        self.isNextPrint = NO;
                        self.isLastPrint = YES;
                        break;
                    case 1:
                        self.isFirstPrint = YES;
                        self.isNextPrint = NO;
                        self.isLastPrint = YES;
                        break;
                    default:
                        self.isFirstPrint = YES;
                        self.isNextPrint = YES;
                        self.isLastPrint = NO;
                        break;
                }
                self.currentNum = 0;
                
                
                if(!_printCancelled)[self doSnmp];
            }
        });
    }

}

- (void) moveView
{
    if(self.IsSite) {
        // 前画面に戻る
        [self.navigationController popViewControllerAnimated:YES];
    } else {
        // TOPメニューに戻る
        [self nextPrint];
    }
}

/**
 * 次の印刷へ進む
 */
- (void)nextPrint
{
    [self networkStreamClose];
    [self fileStreamClose];

    m_isStopSend = TRUE;
    // 印刷終了後はスリープ可能状態に戻す
    [UIApplication sharedApplication].idleTimerDisabled = NO;
    // 印刷終了後はバックグラウンド処理を終了する
    [self EndBackgroundTask];


    SharpScanPrintAppDelegate* appDelegate = (SharpScanPrintAppDelegate*)[[UIApplication sharedApplication] delegate];
    m_isCacel = TRUE;
    m_bSendFile = FALSE;
    [m_pCmnMgr removeFile:self.PjlFileName];
    
    // バッファデータクリア
    self.BufferOffset = 0;
    self.BufferLimit = 0;
    *self.Buffer = NULL;
    
    // 処理実行フラグOFF
    appDelegate.IsRun = FALSE;
    m_isPrintStop = FALSE;
    m_bResult = TRUE;
    
    if (self.PrintPictViewID == PPV_PRINT_SELECT_FILE_CELL || self.PrintPictViewID == PPV_PRINT_MAIL_ATTACHMENT_CELL)
    {//ファイル選択　または　メール添付ファイル印刷
        if (self.currentNum < _filesToBePrintedArray.count-1)
        {//次のファイルがある
            self.currentNum = self.currentNum + 1;
            
            if (self.currentNum == _filesToBePrintedArray.count-1)
            {//次のファイルが最後
                self.isFirstPrint =NO;
                self.isNextPrint = NO;
                self.isLastPrint = YES;
            }else
            {//次のファイルは最後ではない
                self.isFirstPrint = NO;
                self.isNextPrint = YES;
            }
            
            SharpScanPrintAppDelegate* appDelegate = (SharpScanPrintAppDelegate*)[[UIApplication sharedApplication] delegate];
            appDelegate.IsRun = TRUE;
            
            m_isPrintStop = FALSE;
            m_isCacel = FALSE;
            
            
//            NSString *msg = [NSString stringWithFormat:@"%@ (%d/%d)",MSG_PRINT_FORWARD,self.currentNum+1, _filesToBePrintedArray.count];
//            [m_palert setMessage:msg];
            DLog(@"切断中です");
//            [[NSOperationQueue mainQueue] addOperationWithBlock:^(){
//                [self CreateProgressAlert:nil message:MSG_PRINT_DISCONNECT withCancel:NO];
//            }];
            //印刷
            [self doSnmp];
        }
        else
        {//次のファイルは無い。これで終わり
            [self.navigationController popToRootViewControllerAnimated:YES];
        }
    }
    else if (self.PrintPictViewID == PPV_PRINT_SELECT_PICTURE_CELL)
    {//画像選択
        if (self.currentNum < self.selectPictArray.count-1) {
            self.currentNum = self.currentNum + 1;
            if (self.currentNum == self.selectPictArray.count-1)
            {//次のファイルが最後
                self.isFirstPrint = NO;
                self.isNextPrint = NO;
                self.isLastPrint = YES;
            }else
            {//次のファイルは最後ではない
                self.isFirstPrint = NO;
                self.isNextPrint = YES;
            }
            SharpScanPrintAppDelegate* appDelegate = (SharpScanPrintAppDelegate*)[[UIApplication sharedApplication] delegate];
            appDelegate.IsRun = TRUE;
            
            m_isPrintStop = FALSE;
            m_isCacel = FALSE;
            
//            NSString *msg = [NSString stringWithFormat:@"%@ (%d/%d)",MSG_PRINT_FORWARD,self.currentNum+1,self.selectPictArray.count];
//            [m_palert setMessage:msg];
            DLog(@"切断中です");
//            [[NSOperationQueue mainQueue] addOperationWithBlock:^(){
//                [self CreateProgressAlert:nil message:MSG_PRINT_DISCONNECT withCancel:NO];
//            }];
            [self doSnmp];
        } else {
            [self.navigationController popToRootViewControllerAnimated:YES];
        }
    }
}

// TCP接続・ファイル送信スレッド
-(void)socketConnectThred:(NSDictionary*)dic
{
    @autoreleasepool
    {
        self.isCalledConnectCallBack = NO;
        //  スレッド処理
        NSData* data = [dic objectForKey:@"data"];
        NSData* address = [dic objectForKey:@"address"];
        
        CFSocketError SockError = CFSocketConnectToAddress(m_Socket, (__bridge CFDataRef)address, FOWARD_TIMEOUT);
        if (SockError == kCFSocketError) {
            [self socketDisconnectKCFSocketError];
            return;
        }
        
        while (!self.isCalledConnectCallBack)
        {
            [[NSRunLoop currentRunLoop]runUntilDate:[NSDate dateWithTimeIntervalSinceNow:1.0f]];
        }
        
        if (SockError == kCFSocketSuccess) {
            // 送信
            NSInteger packetLength = 1024 * 1;
            NSRange dataRange;
            NSInteger dataSize = data.length;
            NSInteger dataSplitCount = dataSize/packetLength;
            
            dataRange.length = packetLength;
            dataRange.location = 0;
            NSMutableArray *dataArray = [NSMutableArray array];
            for(NSInteger cnt = 0;cnt<dataSplitCount;cnt++){
                [dataArray addObject:[data subdataWithRange:dataRange]];
                dataRange.location += packetLength;
            }
            // 最後のデータは、レングスを調整してから処理を行う
            if (dataSize%packetLength != 0) {
                dataRange.length = dataSize%packetLength;
                [dataArray addObject:[data subdataWithRange:dataRange]];
            }
            
            BOOL isSendError = NO;
            
            // ジョブ送信のタイムアウト(秒)を取得する
            int jobTimeOut = [self getJobTimeOut];
            for(int i  =0 ; i <[dataArray count]; i ++){
                
                NSDate * sendStartDate = [NSDate date];
                
                NSData *packetData = [dataArray objectAtIndex:i];
                CFDataRef refData = CFDataCreate(kCFAllocatorDefault, [packetData bytes], [packetData length]);
                SockError = CFSocketSendData(m_Socket, NULL, refData, jobTimeOut);
                CFRelease(refData);
                
                NSTimeInterval sendDataTime = [[NSDate date] timeIntervalSinceDate: sendStartDate];
                
                // [送信中に複合機のLANが抜かれた場合を想定した処理]
                // 送信時間がタイムアウト時間を超えている場合
                if (sendDataTime >= jobTimeOut) {
                    /*
                     CFSocketSendData の結果としてLANが抜かれたタイミングによっては
                     kCFSocketSuccess を返してくる場合があるため
                     （エラーが返ってこない）
                     タイムアウトとみなす
                     */
                    SockError = kCFSocketTimeout;
                    DLog(@"タイムアウトとみなす");
                }

                
                if(SockError != kCFSocketSuccess){
                    isSendError = YES;
                    break;
                }
            }
            
            // ファイルサイズが小さいと転送中アラート表示中に固まる場合があるので、スリープを１秒入れておく
            [NSThread sleepForTimeInterval:1.0];

            if(!isSendError)
            {
                m_bRet = TRUE;
                [self socketDisconnect:m_Socket];
                if (self.isFirstPrint)
                {
                    if (self.PrintPictViewID == PPV_PRINT_SELECT_FILE_CELL && _filesToBePrintedArray.count == 1)
                    {
                        self.isFirstPrint = NO;
                        self.isLastPrint = YES;
                        [self StopSendWithStatus:MSG_PRINT_COMPLETE];
                    }
                    else if (self.PrintPictViewID == PPV_PRINT_MAIL_ATTACHMENT_CELL && _filesToBePrintedArray.count == 1)
                    {
                        self.isFirstPrint = NO;
                        self.isLastPrint = YES;
                        [self StopSendWithStatus:MSG_PRINT_COMPLETE];
                        
                    } else if (self.PrintPictViewID == PPV_PRINT_SELECT_PICTURE_CELL && _filesToBePrintedArray.count == 1) {
                        self.isFirstPrint = NO;
                        self.isLastPrint = YES;
                        [self StopSendWithStatus:MSG_PRINT_COMPLETE];
                    } else {
                        if(!_printCancelled)[self nextPrint];
                    }
                } else if (self.isNextPrint) {
                    if(!_printCancelled)[self nextPrint];
                } else if (self.isLastPrint) {
                    [self StopSendWithStatus:MSG_PRINT_COMPLETE];
                }
            }else{
                if(SockError == kCFSocketError){
                    // 送信失敗
                }else{
                    // タイムアウト
                }
                
                [self StopSendWithStatus:MSG_PRINT_ERR];
                [self socketDisconnect:m_Socket];
            }
        }else{
            //Error
            DLog(@"ERR:Socket Connect Error:%d", (int)SockError);
            [self StopSendWithStatus:MSG_PRINT_ERR];
            [self socketDisconnect:m_Socket];
        }
        
        DLog(@"socketConnectThred finish");
        
    }
}

// ソケット切断
- (void)socketDisconnect:(CFSocketRef)socket
{
    if(socket != NULL){
        CFSocketInvalidate(socket);
        CFRelease(socket);
        socket = NULL;
    }
}

// TCP通信コールバック
static void SocketCallBackForMulti(CFSocketRef socket, CFSocketCallBackType type, CFDataRef address, const void *data, void *info)
{
    
    MultiPrintPictViewController *selfClass = (__bridge MultiPrintPictViewController *)(info);
    
    if (CFSocketIsValid(socket) == FALSE) {
        // ソケットが利用できない
        DLog(@"[SocketCallBack] Socket Disonnect 1");
        [selfClass socketDisconnect:socket];
        [selfClass StopSendWithStatus:MSG_PRINT_ERR];
        
    }else{
        if (type == kCFSocketConnectCallBack) {
            // 接続完了
            DLog(@"[SocketCallBack] Socket Connect!!");
        }
        else if (type == kCFSocketDataCallBack) {
            // データ取得
            NSData* RcvData = (__bridge NSData*)data;
            if ([RcvData length] == 0){
                // サーバーから切断
                DLog(@"[SocketCallBack] Socket Disonnect 2");
                
            }else{
                // その他
                //                NSString *TempStr = [[NSString alloc] initWithData:RcvData encoding:NSASCIIStringEncoding];
                //                DLog(@"[SocketCallBack] %@", TempStr);
            }
        }else{
            // その他のタイプ
            DLog(@"[SocketCallBack] type:%d", (int)type);
        }
    }
    if (type == kCFSocketConnectCallBack) {
        selfClass.isCalledConnectCallBack = YES;
    }
}

/**
 @brief TCP通信:ソケット接続エラー時用の処理(IPv6対応特殊な場合)
 @details ソケット接続解除とメッセージ表示を行う。
 例えばIPv4のみ環境でIPv6形式のアドレスを指定してソケット作成を行うとコールバックされず、
 　　　　　キャンセルなどの処理が行われない処理フローとなっているので、そのような場合のエラー処理。
 */
- (void)socketDisconnectKCFSocketError {
    NSLog(@"[SocketError] Socket Disonnect");
    [self socketDisconnect:m_Socket];
    [self StopSendWithStatus:MSG_PRINT_ERR];
}

// data取得処理
- (void)getData
{
    ScanData *scanData = [_filesToBePrintedArray objectAtIndex:self.currentNum];
    self.SelFilePath = [NSString stringWithFormat:@"%@%@",scanData.fpath,scanData.fname];
    [self updateOriginalViewerValue:self.SelFilePath];
//    [self deleteTempPrintFile];
    [self getPictureFromPhotoLibrary];
}

// SNMPによるMIB取得処理
- (void)doSnmp
{
    if(_printCancelled)return;

    m_isDoSnmp = YES;
    
    m_bSendFile = TRUE;
    m_isStop = FALSE;
    
    SharpScanPrintAppDelegate* appDelegate = (SharpScanPrintAppDelegate*)[[UIApplication sharedApplication] delegate];
    // 処理実行フラグON
    appDelegate.IsRun = TRUE;
        
    if (self.PrintPictViewID == PPV_PRINT_SELECT_FILE_CELL || self.PrintPictViewID == PPV_PRINT_MAIL_ATTACHMENT_CELL)
    {//ファイル選択またはメール添付ファイル印刷
        ScanData *scanData = [_filesToBePrintedArray objectAtIndex:self.currentNum];
        self.SelFilePath = [NSString stringWithFormat:@"%@%@",scanData.fpath,scanData.fname];
        [self updateOriginalViewerValue:self.SelFilePath];
    }
    else if (self.PrintPictViewID == PPV_PRINT_SELECT_PICTURE_CELL)
    {//画像選択
        self.PictEditInfo = [self.selectPictArray objectAtIndex:self.currentNum];
//        [self deleteTempPrintFile];
        [self getPictureFromPhotoLibrary];
        return;
    }
    
    [self performSelectorInBackground:@selector(getMib) withObject:nil];
}

// Mib情報の取得
- (void)getMib
{
    
    if(self.canPrintPDF)
    {//既にPDF印刷が可能であることが判明しているとき
        m_isDoSnmp = NO;
        // 印刷開始
        [self performSelectorOnMainThread:@selector(getMibEnd) withObject:nil waitUntilDone:YES];
//        [self performSelectorInBackground:@selector(getMibEnd) withObject:nil];
        return;
    }
    
    // 写真印刷の二回目以降
    if (self.PrintPictViewID == PPV_PRINT_SELECT_PICTURE_CELL && !self.isFirstPrint) {
        m_isDoSnmp = NO;
        // 印刷開始
        [self performSelectorOnMainThread:@selector(getMibEnd) withObject:nil waitUntilDone:YES];
        return;
    }
    
    PrinterData* printerData = nil;
    printerData = [m_pPrinterMgr LoadPrinterDataAtIndexInclude2:[super getSelPickerRowWithIndex:BUTTON_PRINTER]];

    //以下、mibチェックして印刷
    
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
    NSDictionary *dicIPAddr = [CommonUtil getIPAddrDicForComm:[printerData getIPAddress]
                                                         port:[NSString stringWithFormat:@"%@", [NSNumber numberWithInteger:N_SNMP_PORT]]];
    snmpManager = [[SnmpManager alloc]initWithIpAddress:[CommonUtil optIPAddrForComm:[dicIPAddr objectForKey:S_TARGET_IPADDRESS_DIC_KEY]] port:N_SNMP_PORT];
    [snmpManager setCommunityString:communityString];
    
    //==========================================================
    //PCL,PS判定開始
    if(!m_isDoSnmp)
    {
        return;
    }
    //-------------------------
    //以下のフラグについて判定を行う
    BOOL isExistsPCL = NO;
    BOOL isExistsPS  = NO;
    //-------------------------
    
    //判定実行
    BOOL result = NO;
    if([printerData getAddStatus]) {
        // 手動追加MFPの場合は、SNMP通信せず、PCLオプション、PSオプション、Office対応はすべて有効として処理を続ける。
        result = YES;
        isExistsPCL = YES;
        isExistsPS = YES;
    } else {
        result = [CommonUtil checkPrinterSpecWithSnmpManager:snmpManager PCL:&isExistsPCL PS:&isExistsPS];
    }
    
    if(!m_isDoSnmp)
    {
        return;
    }
    m_isDoSnmp = NO;
    //PCL,PS判定終了
    //==========================================================
    
    
    if (self.isFirstPrint)
    {//最初のファイルの印刷時
        m_isAvailablePrintPDF = YES;
        
    } else if (self.isNextPrint) {
        
    } else if (self.isLastPrint) {
        
    }

    if(result)
    {//情報取得成功
        if(!isExistsPCL)
        {
            // PCLオプションなし
            [self CreateAllert:nil message:MSG_NO_PRINTOPTION_PCL btnTitle:MSG_BUTTON_OK];
        }
        else if(!isExistsPS && m_pstrFilePath != nil && [CommonUtil pdfExtensionCheck:m_pstrFilePath])
        {
            // PSオプションなし
            if(self.PrintPictViewID == WEB_PRINT_VIEW || self.PrintPictViewID == EMAIL_PRINT_VIEW){
                m_isAvailablePrintPDF = NO;
            }
            else{
                [self CreateAllert:nil message:MSG_NO_PRINTOPTION_PS btnTitle:MSG_BUTTON_OK];
            }
            
            
        }
        else
        {
            // 印刷開始
            [self performSelectorOnMainThread:@selector(getMibEnd) withObject:nil waitUntilDone:YES];
//            [self performSelectorInBackground:@selector(getMibEnd) withObject:nil];
        }
    }
    else
    {//情報取得失敗
        [self CreateAllert:nil message:MSG_NETWORK_ERR btnTitle:MSG_BUTTON_OK];
    }
}

// Mib取得完了後処理
-(void)getMibEnd
{
        //印刷前チェックしてから印刷(doPrint)へ
    if(!_printCancelled)[self CheckBeforePrinting];
}

// ファイル送信分岐
- (NSInteger)StartSendFile:strFilePath
{
    NSInteger nRet = SUCCESS;           // 戻り値
    
    if(m_isUseRawPrintMode){
        // Rawプリント
        nRet = [self StartSendFileForRawPrint:strFilePath];
    }else{
        // FTPで送信
        nRet = [self StartSendFileForFTP:strFilePath];
    }
    
    return nRet;
}

// FTP Serverへのファイル送信
- (NSInteger)StartSendFileForFTP:strFilePath
{
    NSInteger nRet = SUCCESS;           // 戻り値
    BOOL bRet = TRUE;                   // NetworkStream戻り値
    NSURL* url;                         // 送信先URL
    CFWriteStreamRef ftpWriteStream;    // 書き込み用ストリーム
    
    m_bRet = FALSE;
    
    // ストリーム初期化
    self.NetworkStream = nil;
    self.FileStream = nil;
    
    // ファイルパスが存在しない
    if (strFilePath == nil || ![[NSFileManager defaultManager] fileExistsAtPath:strFilePath])
    {
        nRet = ERR_INVALID_FILEPATH;
    }
    

    // プリンタ情報取得
    PrinterData* printerData = nil;
    printerData = [m_pPrinterMgr LoadPrinterDataAtIndexInclude2:[super getSelPickerRowWithIndex:BUTTON_PRINTER]];

    // ファイルパス、ip,部数、両面設定を引数に
    DLog(@"strFilePath = %@",strFilePath);
    DLog(@"self.SelFilePath = %@",self.SelFilePath);
    
    DLog(@"nNupRow : %zd  nSeqRow : %zd  m_isVertical : %d",self.nNupRow ,self.nSeqRow, self.m_isVertical);
    
    //縦横判定
    if (arrThumbnails.count != 0) {
        UIImage* image = [[UIImage alloc] initWithContentsOfFile:[arrThumbnails objectAtIndex:0]];
        self.m_isVertical = image.size.width <= image.size.height;
        if (!self.m_isVertical && self.nNupRow == 1) {
            self.nSeqRow = 0;
        }
    } else {
        self.nSeqRow = 0;
    }
    
    // 印刷範囲情報を作成する
    PrintRangeSettingViewController *printRangeInfo = [self makePrintRangeInfo];
    
    NSString* pjlFilePath = [m_pPJLDataMgr CreatePJLData:[super getSelPickerRowWithIndex:BUTTON_NUM]
                                                    Side:[super getSelPickerRowWithIndex:BUTTON_DUPLEX]
                                               ColorMode:[super getSelPickerRowWithIndex:BUTTON_COLOR]
                                               PaperSize:self.m_pstrPaperSizePJL
                                               PaperType:self.m_pstrPaperTypePJL
                                             Orientation:[super getSelPickerRowWithIndex:BUTTON_PAPERSIZE]
                                          PrintRangeInfo:printRangeInfo
                                             PrintTarget:[self getPrintTargetValue]
                                           RetentionHold:self.noPrintOn
                                           RetentionAuth:self.authenticateOn
                                       RetentionPassword:self.pstrPassword
                                               Finishing:self.staple
                                              ClosingRow:self.nClosingRow
                                                  Staple:[PrintPictManager getStaplePJLString:self.pstrSelectedStaple]
                                                CanPunch:self.punchData
                                                   Punch:[PrintPictManager getPunchPJLString:self.pstrSelectedPunch]
                                                  NupRow:self.nNupRow
                                                  SeqRow:self.nSeqRow
                                              IsVertical:self.m_isVertical
                                                FilePath:strFilePath
                                                 JobName:self.SelFilePath
                                            PrintRelease:[self getPrintReleaseValue]];
    // Pjl ファイル名を取得
    self.PjlFileName = [pjlFilePath lastPathComponent];
    DLog(@"self.PjlFileName = %@",self.PjlFileName);
    
    // FTP接続先
    NSDictionary *dicIPAddr = [CommonUtil getIPAddrDicForComm:[printerData IpAddress] port:[printerData FtpPortNo]];
    NSString* pstrFtp = [[NSString alloc]initWithFormat: @"ftp://%@:%@", [CommonUtil optIPAddrForComm:[dicIPAddr objectForKey:S_TARGET_IPADDRESS_DIC_KEY]],[printerData FtpPortNo]];
    DLog(@"pstrFtp = %@",pstrFtp);
    
    url = [NSURL URLWithString:pstrFtp];
    
    if (url == nil) {
        nRet = ERR_INVALID_HOSTNAME;
    }
    
    if (nRet == SUCCESS)
    {
        //DLog([pjlFilePath lastPathComponent]);
        // 送信するファイル名のみ取得してURLに追加
        url = CFBridgingRelease(CFURLCreateCopyAppendingPathComponent(NULL, (CFURLRef) url, (CFStringRef) [pjlFilePath lastPathComponent], false));
        //DLog([strFilePath lastPathComponent]);
        //url = [NSMakeCollectable(CFURLCreateCopyAppendingPathComponent(NULL, (CFURLRef) url, (CFStringRef) [strFilePath lastPathComponent], false)) autorelease];
        // URL生成失敗
        if (url == nil)
        {
            nRet = ERR_INVALID_URL;
        }
    }
    
    if (nRet == SUCCESS)
    {
        //DLog(pjlFilePath);
        
        //DLog(strFilePath);
        // 送信ファイルのストリームをオープン
        self.FileStream = [NSInputStream inputStreamWithFileAtPath:pjlFilePath];
        //self.FileStream = [NSInputStream inputStreamWithFileAtPath:strFilePath];
        assert(self.FileStream != nil);
        
//        [self.FileStream open];
        [self.FileStream performSelectorInBackground:@selector(open) withObject:nil];

        // 送信先のURL作成
        ftpWriteStream = CFWriteStreamCreateWithFTPURL(NULL, (__bridge CFURLRef) url);
        
        // URL生成失敗
        if (ftpWriteStream == nil)
        {
            nRet = ERR_INVALID_URL;
        }
    }
    
    if (nRet == SUCCESS)
    {
        self.NetworkStream = (__bridge NSOutputStream*) ftpWriteStream;
        if (ftpWriteStream != nil)
        {
            CFRelease(ftpWriteStream);
        }
        
        // ユーザ名はanonymous、パスワードは「なし」固定
        bRet = [self.NetworkStream setProperty:S_PRINT_LOGIN_ID
                                        forKey:(id)kCFStreamPropertyFTPUserName];
        if (bRet)
        {
            bRet = [self.NetworkStream setProperty:S_PRINT_LOGIN_PASSWORD
                                            forKey:(id)kCFStreamPropertyFTPPassword];
        }
        // FTPサーバとのコネクションを再利用するかのフラグ。Falseにすることで転送後にコネクションをクローズする
        if (bRet)
        {
            bRet = [self.NetworkStream setProperty:(id)kCFBooleanFalse forKey:(id)kCFStreamPropertyFTPAttemptPersistentConnection];
        }
        if (bRet)
        {
            self.NetworkStream.delegate = self;
            [self.NetworkStream scheduleInRunLoop:[NSRunLoop currentRunLoop]
                                          forMode:NSDefaultRunLoopMode];
            
//            [self.NetworkStream open];
            [self.NetworkStream performSelectorInBackground:@selector(open) withObject:nil];
            DLog(@"転送開始");
        }
        else
        {
            // 送信パラメータ設定失敗
            nRet = ERR_FAILED_SET_SENDPRM;
        }
    }
    return nRet;
}

// socket通信関数
// TCP接続処理
- (NSInteger)socketConnectWithIPAddr:(NSString*)ipaddr port:(int)port data:(NSData*)data
{
    DLog(@"転送開始");
    DLog(@"ipaddr:%@, port:%d", ipaddr, port);
    CFSocketContext ctx;
    ctx.version = 0;
    ctx.info = (__bridge void *)self;
    ctx.retain = NULL;
    ctx.release = NULL;
    ctx.copyDescription = NULL;
    
    NSString *strPort = [NSString stringWithFormat:@"%d", port];
    struct addrinfo hints;
    struct addrinfo *ai0 = NULL;    // addrinfoリストの先頭の要素
    struct addrinfo *ai;            // 処理中のaddrinfoリストの要素
    
    memset(&hints, 0, sizeof(hints));
    hints.ai_addrlen = sizeof(hints);
#ifdef IPV6_VALID
    if ([CommonUtil isValidIPv4StringFormat:ipaddr]) {
        hints.ai_family = AF_INET;
    }
    else if ([CommonUtil isValidIPv6StringFormat:ipaddr]) {
        hints.ai_family = AF_INET6;
    }
    else {
        hints.ai_family = AF_UNSPEC;
    }
#else
    hints.ai_family = AF_INET;
#endif
    hints.ai_socktype = SOCK_STREAM;
    hints.ai_protocol = IPPROTO_TCP;
    hints.ai_flags = AI_PASSIVE;
    
    int err = getaddrinfo([ipaddr UTF8String], [strPort UTF8String], &hints, &ai0);
    if (err != 0) {
        DLog(@"[SocketCallBack] getaddrinfoError");
        [self StopSendWithStatus:@"getaddrinfoError"];
        return ERR_INVALID_URL;
    }
    
    BOOL isIpv6 = NO;
    NSData *address = nil;
    // 得られたアドレス情報のループ
    for (ai = ai0; ai != NULL; ai = ai->ai_next) {
        
        if (ai != NULL) {
            
            if(!address && (ai->ai_family == AF_INET))
            {
                address = [NSData dataWithBytes:ai->ai_addr length:ai->ai_addrlen];
            }
            else if (!address && (ai->ai_family == AF_INET6))
            {
                address = [NSData dataWithBytes:ai->ai_addr length:ai->ai_addrlen];
                isIpv6 = YES;
            }

        }
    }
    freeaddrinfo(ai0);
    
    if (!address) {
        DLog(@"[SocketCallBack] getaddrinfoError-NotFoundIPAddress");
        [self StopSendWithStatus:@"getaddrinfoError-NotFoundIPAddress"];
        return ERR_INVALID_URL;
    }
    
    // ソケットの作成
    SInt32 addrFamily = PF_INET;
    if (isIpv6) {
        addrFamily = PF_INET6;
    }

    m_Socket = CFSocketCreate(kCFAllocatorDefault,
                              addrFamily, SOCK_STREAM,
                              IPPROTO_TCP,
                              kCFSocketConnectCallBack | kCFSocketDataCallBack,
                              SocketCallBackForMulti, //コールバック関数登録
                              &ctx
                              );
    
    if (m_Socket == NULL){
        DLog(@"[SocketCallBack] ERR:CreateError");
        [self StopSendWithStatus:MSG_PRINT_ERR];
        return ERR_INVALID_URL;
    }
    
    CFRunLoopSourceRef sourceRef = CFSocketCreateRunLoopSource(kCFAllocatorDefault, m_Socket, 0);
    CFRunLoopAddSource(CFRunLoopGetCurrent(), sourceRef, kCFRunLoopCommonModes);
    CFRelease(sourceRef);
    
        
    CFSocketNativeHandle socket = CFSocketGetNative(m_Socket);
    int set = 1;
    setsockopt(socket, SOL_SOCKET, SO_NOSIGPIPE, (void *)&set, sizeof(int));
    
    // TCP接続・送信
    NSDictionary* dic = [NSDictionary dictionaryWithObjectsAndKeys:data, @"data", address, @"address", nil];
    [NSThread detachNewThreadSelector:@selector(socketConnectThred:) toTarget:self withObject:dic];
    
    return SUCCESS;
}

- (NSInteger)StartSendFileForRawPrint:strFilePath
{
    NSInteger nRet = SUCCESS;           // 戻り値
    
    // ファイルパスが存在しない
    if (strFilePath == nil || ![[NSFileManager defaultManager] fileExistsAtPath:strFilePath])
    {
        //        nRet = ERR_INVALID_FILEPATH;
    }
    
    // プリンタ情報取得
    PrinterData* printerData = nil;
    printerData = [m_pPrinterMgr LoadPrinterDataAtIndexInclude2:[super getSelPickerRowWithIndex:BUTTON_PRINTER]];
    
    //縦横判定
    if (arrThumbnails.count != 0) {
        UIImage* image = [[UIImage alloc] initWithContentsOfFile:[arrThumbnails objectAtIndex:0]];
        self.m_isVertical = image.size.width <= image.size.height;
        if (!self.m_isVertical && self.nNupRow == 1) {
            self.nSeqRow = 0;
        }
    } else {
        self.nSeqRow = 0;
    }

    // 印刷範囲情報を作成する
    PrintRangeSettingViewController *printRangeInfo = [self makePrintRangeInfo];
    
    // ファイルパス、ip,部数、両面設定を引数に
    NSString* pjlFilePath = [m_pPJLDataMgr CreatePJLData:[super getSelPickerRowWithIndex:BUTTON_NUM]
                                                    Side:[super getSelPickerRowWithIndex:BUTTON_DUPLEX]
                                               ColorMode:[super getSelPickerRowWithIndex:BUTTON_COLOR]
                                               PaperSize:self.m_pstrPaperSizePJL
                                               PaperType:self.m_pstrPaperTypePJL
                                             Orientation:[super getSelPickerRowWithIndex:BUTTON_PAPERSIZE]
                                          PrintRangeInfo:printRangeInfo
                                             PrintTarget:[self getPrintTargetValue]
                                           RetentionHold:self.noPrintOn
                                           RetentionAuth:self.authenticateOn
                                       RetentionPassword:self.pstrPassword
                                               Finishing:self.staple
                                              ClosingRow:self.nClosingRow
                                                  Staple:[PrintPictManager getStaplePJLString:self.pstrSelectedStaple]
                                                CanPunch:self.punchData
                                                   Punch:[PrintPictManager getPunchPJLString:self.pstrSelectedPunch]
                                                  NupRow:self.nNupRow
                                                  SeqRow:self.nSeqRow
                                              IsVertical:self.m_isVertical
                                                FilePath:strFilePath
                                                 JobName:self.SelFilePath
                                            PrintRelease:[self getPrintReleaseValue]];
    // Pjl ファイル名を取得
    self.PjlFileName = [pjlFilePath lastPathComponent];
    
    NSData* sendData = [NSData dataWithContentsOfFile:pjlFilePath];
    NSDictionary *dicIPAddr = [CommonUtil getIPAddrDicForComm:[printerData IpAddress] port:[printerData RawPortNo]];
    nRet = [self socketConnectWithIPAddr:[dicIPAddr objectForKey:S_TARGET_IPADDRESS_DIC_KEY] port:[[printerData RawPortNo]intValue] data:sendData]; // ここではIPv6アドレスでも括弧をつけない
    
    return nRet;
}

// 送信中止
- (void)StopSendWithStatus:(NSString *)pstrStatus
{
    // タイマー停止
    if (nil != tm)
    {
        [tm invalidate];
        tm = nil;
    }
    
    if(!m_isStop)
    {
        m_isStop = TRUE;
        
        if(m_isUseRawPrintMode){
            // RawPrintモード
            [self CreateDialogForStopSendWithStatus:pstrStatus];
            
        }else{
            // 転送中です
            [picture_alert dismissViewControllerAnimated:YES completion:^{
                [self alertButtonDismiss:picture_alert tagIndex:picture_alert.tag buttonIndex:0];
                // FTPモード
                [self performSelector:@selector(CreateDialogForStopSendWithStatus:) withObject:pstrStatus afterDelay:0.01];
            }];
        }
    }
}

//-(void)dismissMyAlert:(NSNumber*)isAnimatedNum
//{
//    BOOL animated = YES;
//    if(isAnimatedNum){
//        animated = [isAnimatedNum boolValue];
//    }
//    [m_palert dismissWithClickedButtonIndex:0 animated:animated]; //
//}

- (void)CreateDialogForStopSendWithStatus:(NSString *)pstrStatus
{
    if(m_isUseRawPrintMode)
    {
        // RawPrintモード(切断中アラートを表示しない)
        // スレッドで呼び出されるので、メインスレッドでアラートを消す
//        [self performSelectorOnMainThread:@selector(dismissMyAlert:) withObject:[NSNumber numberWithBool:YES] waitUntilDone:YES];
        DLog(@"転送終了");
    }
    else if (self.NetworkStream != nil)
    {
        // FTPモード
        [self networkStreamClose];
        DLog(@"転送終了");
    }
    [self fileStreamClose];
    
    if (pstrStatus != nil)
    {

        m_isStopSend = TRUE;
        // 印刷終了後はスリープ可能状態に戻す
        [UIApplication sharedApplication].idleTimerDisabled = NO;
        // 印刷終了後はバックグラウンド処理を終了する
        [self EndBackgroundTask];
        
        //既に出ているアラートを消す
//        [self dismissAlertView];
        
//        m_palert = nil;
        
        //既に出ているアラートを消す
        if(picture_alert){
            if([NSThread isMainThread]){
                [picture_alert dismissViewControllerAnimated:YES completion:^{
                }];
                picture_alert = nil;
                [self changeDialogForStopSendWithStatus:pstrStatus];
            }else{
                // メインスレッドでアラートを閉じる処理をするが、同期的に処理を行いたいため、
                // semaphoreで同期化しています。
                dispatch_semaphore_t semaphore = dispatch_semaphore_create(0);
                dispatch_async(dispatch_get_main_queue(), ^{
                    [picture_alert dismissViewControllerAnimated:YES completion:^{
                        [self changeDialogForStopSendWithStatus:pstrStatus];
                    }];
                    dispatch_semaphore_signal(semaphore);
                });
                dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
            }
        } else {
            [self changeDialogForStopSendWithStatus:pstrStatus];
        }
    }
}

- (void)changeDialogForStopSendWithStatus:(NSString *)pstrStatus
{
    SharpScanPrintAppDelegate* appDelegate = (SharpScanPrintAppDelegate*)[[UIApplication sharedApplication] delegate];
    // 処理実行フラグON
    appDelegate.IsRun = TRUE;
    
    DLog(@"pstrStatus = %@",pstrStatus);
    if([self isMoveAttachmentMail])
    {
        if(pstrStatus == MSG_PRINT_COMPLETE)
        {
            // 添付ファイル印刷
            [self makePictureAlert:nil message:[NSString stringWithFormat:@"%@\r\n%@",pstrStatus, MSG_PRINT_COMPLETE_ATTACHMENT_MAIL] cancelBtnTitle:MSG_BUTTON_NO okBtnTitle:MSG_BUTTON_YES tag:4 showFlg:YES];
        } else {
            [self makePictureAlert:nil message:pstrStatus cancelBtnTitle:MSG_BUTTON_NO okBtnTitle:MSG_BUTTON_YES tag:0 showFlg:YES];
        }
    }
    else
    {
        if(pstrStatus == MSG_PRINT_COMPLETE)
        {
            if(self.hasEncryptionPdfData && !self.isRetentionSet){
                // 暗号化PDFが存在し、かつリテンションがoffのときの転送完了時はメッセージを切り替える
                [self makePictureAlert:nil message:MSG_PRINT_COMPLETE_PDF_ENCRYPTION cancelBtnTitle:MSG_BUTTON_OK okBtnTitle:nil tag:3 showFlg:YES];
            } else {
                [self makePictureAlert:nil message:pstrStatus cancelBtnTitle:MSG_BUTTON_OK okBtnTitle:nil tag:3 showFlg:YES];
            }
        } else {
            [self makePictureAlert:nil message:pstrStatus cancelBtnTitle:MSG_BUTTON_OK okBtnTitle:nil tag:0 showFlg:YES];
        }
    }
    // 転送が完了しました
}

- (void)networkStreamClose {
    if (self.NetworkStream != nil) {
        [self.NetworkStream close];
        [self.NetworkStream removeFromRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
        self.NetworkStream.delegate = nil;
        self.NetworkStream = nil;
    }
}

- (void)fileStreamClose {
    if (self.FileStream != nil)
    {
        [self.FileStream close];
        self.FileStream = nil;
    }
}

- (void)updateOriginalViewerValue:(NSString *)pstrFilePath {
    // 自前ビューアで表示するかのチェック
    m_bOriginalViewer = FALSE;
    totalPage = 0;
    
    if([CommonUtil pngExtensionCheck:pstrFilePath])
    {
        // PNG形式でキャッシュがないときには再作成
        [GeneralFileUtility createCacheFile:pstrFilePath];
    }
    
    NSArray *previewFilePaths = [GeneralFileUtility getPreviewFilePaths:pstrFilePath];
    if(previewFilePaths != nil)
    {
        // 自前ビューアでの表示
        DLog(@"%@", @"自前ビューアでの表示チェック1");
        
        arrThumbnails = previewFilePaths;
        
        totalPage = [arrThumbnails count];
        
        if(totalPage > 0)
        {
            m_bOriginalViewer = TRUE;
        }
    }
}
//- (void)deleteTempPrintFile { //写真印刷の時くる 書き換え対象
//    // ファイルがあれば削除
//    [TempFileUtility deletePrintFileByFileName:S_TEMP_PRINT_JPG];
//    [TempFileUtility deletePrintFileByFileName:S_TEMP_PRINT_TIF];
//    [TempFileUtility deletePrintFileByFileName:S_TEMP_PRINT_PNG];
//}

- (void)ShowFileInOriginalView:pstrFilePath {
    [super ShowFileInOriginalView:pstrFilePath];
    // 不要なラベルを削除
    UIView *labelView = [self.view viewWithTag:PLBL_PAGE_NUM_TAG];
    [labelView removeFromSuperview];
}

- (void)ShowFileInOriginalViewUpdate {
    [super ShowFileInOriginalViewUpdate];
    // 不要なラベルを削除
    UIView *labelView = [self.view viewWithTag:PLBL_PAGE_NUM_TAG];
    [labelView removeFromSuperview];
}


@end
