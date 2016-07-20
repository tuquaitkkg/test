
#import <UIKit/UIKit.h>
#import "PictureViewController.h"
#import <MessageUI/MessageUI.h>
#import <MessageUI/MFMailComposeViewController.h>

@interface SendMailPictViewController : PictureViewController <MFMailComposeViewControllerDelegate,UIDocumentInteractionControllerDelegate> {
	UIDocumentInteractionController *m_diCtrl;
}
@property (nonatomic,strong) UIDocumentInteractionController *m_diCtrl;
-(void) showComposerSheet;
-(void) setAlert:(NSString *) aDescription;
-(BOOL) canSendFileSize;
@end
