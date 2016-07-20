
#import <UIKit/UIKit.h>
#import "PictureViewController_iPad.h"
#import "CommonManager.h"


@interface SendExSitePictViewController_iPad : PictureViewController_iPad
<UIDocumentInteractionControllerDelegate>
{
	UIDocumentInteractionController *m_diCtrl;
    CommonManager* m_pCmnMgr;               // CommonManagerクラス
}


@property (nonatomic,strong) UIDocumentInteractionController *m_diCtrl;

@end
