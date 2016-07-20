
#import "MultiPrintTableViewController_iPad.h"
#import "MultiPrintPictCell.h"
#import "SharpScanPrintAppDelegate.h"
#import "RootViewController_iPad.h"
#import "PrintPictViewController_iPad.h"

@interface MultiPrintTableViewController_iPad ()

@end

@implementation MultiPrintTableViewController_iPad

- (id)initWithStyle:(UITableViewStyle)style {
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //編集ボタン
    if (self.PrintPictViewID == PPV_PRINT_SELECT_FILE_CELL
        || self.PrintPictViewID == PPV_PRINT_SELECT_PICTURE_CELL
        || self.PrintPictViewID == PPV_PRINT_MAIL_ATTACHMENT_CELL) {
//        UIBarButtonItem *button = self.editButtonItem;
//        [button setTitle:nil];
//        [button setImage:[UIImage imageNamed:S_ICON_PRINT_FINISH]];
//        self.navigationItem.rightBarButtonItem = button;
        self.navigationItem.rightBarButtonItem = self.editButtonItem;
  }
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

// iPad用
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // 横向きの場合
    if (interfaceOrientation == UIInterfaceOrientationLandscapeLeft || interfaceOrientation == UIInterfaceOrientationLandscapeRight) {
        // 縦向き表示時のメニューPopOverが表示されていたら閉じる
        [self dismissMenuPopOver:NO];
    }
    return YES;
}

- (void)dismissMenuPopOver:(BOOL)bAnimated {
    SharpScanPrintAppDelegate* pAppDelegate = (SharpScanPrintAppDelegate*)[[UIApplication sharedApplication] delegate];
    UINavigationController* pRootNavController = [pAppDelegate.splitViewController.viewControllers objectAtIndex:0];
    RootViewController_iPad* rootViewController = (RootViewController_iPad*)[pRootNavController.viewControllers objectAtIndex:0];
    
    // 縦向き表示時のメニューPopOverが表示されていたら閉じる
    [rootViewController dismissMenuPopOver:bAnimated];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
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

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"CellIdentifier";
    MultiPrintPictCell *cell = (MultiPrintPictCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[MultiPrintPictCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    cell.selectImgView = nil;
    
    SharpScanPrintAppDelegate* pAppDelegate = (SharpScanPrintAppDelegate*)[[UIApplication sharedApplication] delegate];
    UINavigationController* pRootNavController = [pAppDelegate.splitViewController.viewControllers objectAtIndex:0];
    //左側のViewに設定されているクラスの名前を取得
    NSString* leftViewClassName = [pRootNavController.topViewController description];
    
    if([leftViewClassName isEqual:[self description]]){
        // 左側のViewにこのクラスが表示されている場合
        
        //すべてのセルに">"表示する
        if (self.PrintPictViewID == PPV_PRINT_SELECT_PICTURE_CELL) {
            if (isIOS8_1Later) {
                [cell setPictModelByPhotos:[self.selectPictArray objectAtIndex:indexPath.row]];
            } else {
                [cell setPictModel:[self.selectPictArray objectAtIndex:indexPath.row]];
            }
        } else {
            [cell setModel:[self.selectFileArray objectAtIndex:indexPath.row ] hasDisclosure:YES];
        }
    }else if(self.presentingViewController != nil){
        //モーダルではフォルダに>あり。ファイルにはなし
        if (self.PrintPictViewID == PPV_PRINT_SELECT_FILE_CELL || self.PrintPictViewID == PPV_PRINT_MAIL_ATTACHMENT_CELL) {
            [cell setModel:[self.selectFileArray objectAtIndex:indexPath.row]hasDisclosure:NO];
        } else if (self.PrintPictViewID == PPV_PRINT_SELECT_PICTURE_CELL) {
            if (isIOS8_1Later) {
                [cell setPictModelByPhotos:[self.selectPictArray objectAtIndex:indexPath.row]];
            } else {
                [cell setPictModel:[self.selectPictArray objectAtIndex:indexPath.row]];
            }
        }
    }else{
        [cell setModel:[self.selectFileArray objectAtIndex:indexPath.row ] hasDisclosure:YES];
    }
    return cell;
}

// テーブルビュー 縦幅設定
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return N_HEIGHT_SEL_FILE;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self refreshPreView:indexPath];
    [self dismissMenuPopOver:YES];
}

#pragma mark - Table View Delegate

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCellEditingStyle style;
    
    // 通信中はセルのスタイルをNone
    if (self.isDuringCommProcess) {
        style = UITableViewCellEditingStyleNone;
    }
    else {
        style = UITableViewCellEditingStyleDelete;
    }
    
    //style = UITableViewCellEditingStyleDelete;
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
        if ([self.delegate respondsToSelector:@selector(updatePrintFileArray:)]) {
            [self.delegate updatePrintFileArray:self.selectFileArray];
        }
    } else if (self.PrintPictViewID == PPV_PRINT_SELECT_PICTURE_CELL) {
        id obj = [self.selectPictArray objectAtIndex:fromIndex];
        [self.selectPictArray removeObjectAtIndex:fromIndex];
        [self.selectPictArray insertObject:obj atIndex:toIndex];
        if ([self.delegate respondsToSelector:@selector(updatePrintPictArray:)]) {
            [self.delegate updatePrintPictArray:self.selectPictArray];
        }
    }
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    // 通信中は処理しない
    if (self.isDuringCommProcess) {
        return;
    }
    
    [self.tableView beginUpdates];
    [self.tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
    if (self.PrintPictViewID == PPV_PRINT_SELECT_FILE_CELL || self.PrintPictViewID == PPV_PRINT_MAIL_ATTACHMENT_CELL) {
        [self.selectFileArray removeObjectAtIndex:indexPath.row];
        if ([self.delegate respondsToSelector:@selector(updatePrintFileArray:)]) {
            [self.delegate updatePrintFileArray:self.selectFileArray];
        }
    } else if (self.PrintPictViewID == PPV_PRINT_SELECT_PICTURE_CELL) {
        [self.selectPictArray removeObjectAtIndex:indexPath.row];
        if ([self.delegate respondsToSelector:@selector(updatePrintPictArray:)]) {
            [self.delegate updatePrintPictArray:self.selectPictArray];
        }
    }
    [self.tableView endUpdates];
    [self updatePreview];
}

- (void)updatePreview {
    SharpScanPrintAppDelegate *pAppDelegate = (SharpScanPrintAppDelegate *)[[UIApplication sharedApplication] delegate];
    UINavigationController *pRootNavController = [pAppDelegate.splitViewController.viewControllers objectAtIndex:1];
    PrintPictViewController_iPad *vc = (PrintPictViewController_iPad *)pRootNavController.viewControllers.lastObject;
    
    if (self.PrintPictViewID == PPV_PRINT_SELECT_FILE_CELL || self.PrintPictViewID == PPV_PRINT_MAIL_ATTACHMENT_CELL) {
        if (self.selectFileArray.count == 0) {
            vc.SelFilePath = nil;
            vc.selectFileArray = self.selectFileArray;
            NSArray *subViews = vc.previewScrollViewManager.m_pPreviewScrollView.subviews;
            for (UIView *subView in subViews) {
                [subView removeFromSuperview];
            }
            [vc.previewScrollViewManager.m_plblPageNum setHidden:YES];
            [vc setNoImageHidden:NO];
            [vc SetButtonEnabled:NO];
            [vc.m_pBtnRotateImage removeFromSuperview];
            vc.m_pBtnPageAddImage.frame = CGRectMake(vc.m_pPreviewScrollView.frame.origin.x + vc.m_pPreviewScrollView.frame.size.width - 75, 50, 50, 50);
        } else {
            [self refreshPreView:[NSIndexPath indexPathForRow:0 inSection:0]];// TODO: リフレッシュする際に一つ目のファイルを選択するようにここで指定している
            [self.tableView reloadData];
        }
    } else if (self.PrintPictViewID == PPV_PRINT_SELECT_PICTURE_CELL) {
        if (self.selectPictArray.count == 0) {
            vc.PictEditInfo = nil;
            vc.SelFilePath = nil;
            vc.selectPictArray = self.selectPictArray;
            NSArray *subViews = vc.previewScrollViewManager.m_pPreviewScrollView.subviews;
            for (UIView *subView in subViews) {
                [subView removeFromSuperview];
            }
            [vc.previewScrollViewManager.m_plblPageNum setHidden:YES];
            [vc setNoImageHidden:NO];
            [vc SetButtonEnabled:NO];
            [vc.m_pBtnRotateImage removeFromSuperview];
            vc.m_pBtnPageAddImage.frame = CGRectMake(vc.m_pPreviewScrollView.frame.origin.x + vc.m_pPreviewScrollView.frame.size.width - 75, 50, 50, 50);
        } else {
            [self refreshPreView:[NSIndexPath indexPathForRow:0 inSection:0]];
            [self.tableView reloadData];
        }
    }
}

- (void)refreshPreView:(NSIndexPath *)indexPath {
    SharpScanPrintAppDelegate *pAppDelegate = (SharpScanPrintAppDelegate *)[[UIApplication sharedApplication] delegate];
    UINavigationController *pRootNavController = [pAppDelegate.splitViewController.viewControllers objectAtIndex:1];
    PrintPictViewController_iPad *vc = (PrintPictViewController_iPad *)pRootNavController.viewControllers.lastObject;
    
    for (UIView *subView in vc.previewScrollViewManager.m_pPreviewScrollView.subviews) {
        [subView removeFromSuperview];
    }
    for (UIView *subView in vc.m_pPreviewScrollView.subviews) {
        [subView removeFromSuperview];
    }

    vc.selectFileArray = self.selectFileArray;

    [vc.previewScrollViewManager.m_plblPageNum setHidden:YES];
    [vc.m_pBtnRotateImage removeFromSuperview];
    [vc.m_pBtnPageAddImage removeFromSuperview];
    [vc.previewScrollViewManager resetPage];
    
    NSString *selPath = nil;
    if (self.PrintPictViewID == PPV_PRINT_SELECT_FILE_CELL || self.PrintPictViewID == PPV_PRINT_MAIL_ATTACHMENT_CELL) {
        ScanData *data = [self.selectFileArray objectAtIndex:indexPath.row];
        selPath = [NSString stringWithFormat:@"%@%@",data.fpath,data.fname];
        vc.SelFilePath = selPath;
        [vc ActionThread];
    } else if (self.PrintPictViewID == PPV_PRINT_SELECT_PICTURE_CELL) {
        if(![vc.SelFilePath isEqualToString:vc.indicatingImagePath]){
            vc.PictEditInfo = [self.selectPictArray objectAtIndex:indexPath.row];
            [vc ActionThread];
        }
    }
}

@end
