
#import <UIKit/UIKit.h>
#import "PictureViewController.h"


@interface SendExSitePictViewController : PictureViewController
<UIDocumentInteractionControllerDelegate>
{
	UIDocumentInteractionController *m_diCtrl;
}


@property (nonatomic,strong) UIDocumentInteractionController *m_diCtrl;

@end
