
#import <UIKit/UIKit.h>
#import <MailCore/MailCore.h>
#import "MailDataCell.h"
#import "OptionChangeTableViewController_iPad.h"
#import "ExAlertController.h"
// iPad用

@protocol SelectMailViewControllerDelegate_iPad
-(void) selectMail:(UIViewController*)viewController didSelectMailSuccess:(BOOL)bSuccess;

@end

@interface SelectMailViewController_iPad : UITableViewController<UIGestureRecognizerDelegate,UIImagePickerControllerDelegate, UINavigationControllerDelegate,OptionValueChangedDelegate,UIPopoverControllerDelegate>
// iPad用
{
    NSObject <SelectMailViewControllerDelegate_iPad> *__unsafe_unretained delegate;
    NSInteger m_nPrevViewID;                    // 遷移元画面
    BOOL m_bSetTitle;                           // iPad用 タイトル表示フラグ    
    
    CTCoreAccount *account;
    NSSet *subFolders;
    NSSet *allFolders;
    CTCoreFolder *inbox;
    NSArray *messageList;
    NSInteger listCount;
    UIDeviceOrientation previousOrientation;
    NSIndexPath* selectIndexPath;
    CGPoint lastScrollOffSet;
    
    ExAlertController *imapConnectionAlert;
    
    NSMutableArray *mArrSubFolder;
    
    UIBarButtonItem *backFolderBtn;
    UIBarButtonItem *refreshBtn;
    UIBarButtonItem *mailNumBtn;
    UIBarButtonItem *mailFilterBtn;
    UIBarButtonItem *closeBtn;
    
    IBOutlet UIToolbar *imageToolBar;
    
    NSInteger pageNo;
    NSInteger maxNo;

    NSInteger pageNo_MaxUntilBefore;    //前回までの最大ページ

    //スレッド
	BOOL m_bThread;						// スレッドフラグ
	BOOL m_bAbort;						// 中断フラグ
	NSThread *m_pThread;				// スレッド

}

@property(nonatomic, strong) CTCoreAccount *account;
@property(nonatomic, strong) NSSet *subFolders;
@property(nonatomic, strong) CTCoreFolder *inbox;
@property(nonatomic, strong) NSArray *messageList;
@property(nonatomic) NSInteger listCount;

@property(nonatomic) NSInteger PrevViewID;
@property(nonatomic) BOOL bSetTitle; // iPad用 タイトル表示フラグ
@property(nonatomic, strong) NSIndexPath* selectIndexPath; // iPad用 選択行
@property(nonatomic) CGPoint lastScrollOffSet; // iPad用 スクロール位置
@property(nonatomic, strong) ExAlertController* imapConnectionAlert;
@property (nonatomic, copy) NSString *m_pstrSelectFolder;
@property(nonatomic ) UIDeviceOrientation previousOrientation;

@property(nonatomic, strong) NSMutableArray *m_pMailList;

@property (nonatomic, copy)     NSString        *rootDir;
@property(nonatomic, strong) NSMutableArray *mArrSubFolder;

@property(nonatomic) BOOL bRootClassShow; // ルート階層表示フラグ
@property(nonatomic) NSInteger nFolderCount;
@property (nonatomic, unsafe_unretained) id delegate;
// 画面遷移
- (void)MoveView:(NSIndexPath *)nIndexPath;

// 位置情報の状態を確認する
//-(void)LocationInformationCheck:(NSDictionary *)info;
// 印刷画面に遷移
//-(void)MovePrintPictView:(NSDictionary *)printinfo;

// iPad用
// 詳細画面切り替え
- (void)ChangeDetailView:(UIViewController*)pViewController  didSelectRowAtIndexPath:(NSIndexPath *)indexPath;
- (void) dismissMenuPopOver:(BOOL)bAnimated;
// iPad用

- (void)SetHeaderView;

//- (void)showSortPopoverview: (UIBarButtonItem*)button; // for sorting menu popoverview
//

- (void)setPortraitMenu:(UIBarButtonItem *)barButtonItem;

- (void)popRootView;

@property (nonatomic,strong) UIPopoverController *optionPopoverController;

@end
