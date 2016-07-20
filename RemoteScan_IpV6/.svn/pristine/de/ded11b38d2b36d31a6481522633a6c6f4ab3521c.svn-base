
#import <UIKit/UIKit.h>
#import "AttachmentMailViewController_iPad.h"
#import "SelectMailViewController_iPad.h"
#import "Define.h"
#import "CommonManager.h"
#import "CommonUtil.h"
#import "FilteredWebCache.h"
#import "TempAttachmentDirectory.h"
#import "ExAlertController.h"

@protocol ShowMailViewControllerDelegate_iPad
-(void) mailPrint:(UIViewController*)viewController upLoadMailView:(NSString*)strFilePath;
-(void) mailPrint:(UIViewController*)viewController showAttachmentMailView:(UIViewController*)attachmentViewController;

@end

@interface ShowMailViewController_iPad : UIViewController<UIWebViewDelegate>
{
    NSObject <ShowMailViewControllerDelegate_iPad> *__unsafe_unretained delegate;
    SelectMailViewController_iPad* messageListView;
    IBOutlet UIWebView *emailBody;
    IBOutlet UIToolbar *imageToolBar;
    IBOutlet UIBarButtonItem *imageOnOffButton;
    IBOutlet UIBarButtonItem *imageAttachButton;
    IBOutlet UIBarButtonItem *imageSelectButton;
    NSInteger uid;
    BOOL imageOn;
    BOOL attachMove;
    NSMutableArray* attachFileName;
    FilteredWebCache *cache;
    TempAttachmentDirectory * attachmentDirectory;
    
    ExAlertController			*alert;						// メッセージ表示
    //スレッド
	BOOL m_bThread;						// スレッドフラグ
	BOOL m_bAbort;						// 中断フラグ
	NSThread *m_pThread;				// スレッド
    BOOL m_print;                       // 拡大判断用
    BOOL m_related;                     // 拡大率切り替えよう
    int pages;                          //ページ数
}

@property (nonatomic, strong) IBOutlet UIWebView *emailBody;
@property (nonatomic, strong) IBOutlet UIToolbar *imageToolBar;
@property (nonatomic, strong) IBOutlet UIBarButtonItem *imageOnOffButton;
@property (nonatomic, strong) IBOutlet UIBarButtonItem *imageAttachButton;
@property (nonatomic, strong) IBOutlet UIBarButtonItem *imageSelectButton;
@property (nonatomic, strong) SelectMailViewController_iPad* messageListView;
@property (nonatomic, strong) NSMutableArray* attachFileName;
@property (nonatomic) NSInteger uid;
@property (nonatomic) BOOL imageOn;
@property (nonatomic) BOOL attachMove;
@property (nonatomic, copy) NSString *m_pstrSelectedMail;
@property (nonatomic, unsafe_unretained) id delegate;
@property (nonatomic,strong) CTCoreMessage *selectedMessage;
@property (nonatomic,strong) CTCoreAccount * account;
@property (nonatomic, strong) CTCoreFolder *inbox;
@property (nonatomic, strong) NSString *mailFormat;
@property (nonatomic, strong) NSMutableArray* mailFormatArrayOfPages;
@property (nonatomic, strong) TempAttachmentDirectory *attachmentDirectory;

- (IBAction)imageOnOff:(id)sender;

- (void)setPortraitMenu:(UIBarButtonItem *)barButtonItem;

- (void)setPortraitMenu:(UIBarButtonItem *)barButtonItem;
- (void)popRootView;

- (IBAction)imageAttach:(id)sender;
- (IBAction)imageSelect:(id)sender;
@end
