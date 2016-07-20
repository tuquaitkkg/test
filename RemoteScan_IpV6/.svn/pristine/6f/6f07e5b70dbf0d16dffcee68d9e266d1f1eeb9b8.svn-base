
#import <UIKit/UIKit.h>
#import "PictureViewController_iPad.h"
#import <MessageUI/MessageUI.h>
#import <MessageUI/MFMailComposeViewController.h>
#import "CommonManager.h"

@interface SendMailPictViewController_iPad : PictureViewController_iPad <MFMailComposeViewControllerDelegate, UIDocumentInteractionControllerDelegate> 
{
    UIDocumentInteractionController *m_diCtrl;
    CommonManager* m_pCmnMgr;               // CommonManagerクラス
}

@property (nonatomic,strong) UIDocumentInteractionController *m_diCtrl;

-(void) showComposerSheet;
-(void) setAlert:(NSString *) aDescription;
-(BOOL) canSendFileSize;
@end
