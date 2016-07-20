
#import <UIKit/UIKit.h>
#import "PictureViewController_iPad.h"
#import "TempFile.h"
#import "CommonManager.h"

@interface ScanAfterPreViewController_iPad : PictureViewController_iPad <UIDocumentInteractionControllerDelegate>{
    NSString				*resource;					// ファイル名称
	NSString				*fileType;					// ファイル形式
    UIDocumentInteractionController *m_diCtrl;
    CommonManager* m_pCmnMgr;               // CommonManagerクラス

}
@property (nonatomic, copy)		NSString	*resource;	// ファイル名称
@property (nonatomic, copy)		NSString	*fileType;	// ファイル形式
@property (nonatomic,strong) UIDocumentInteractionController *m_diCtrl;
@property (nonatomic,strong) TempFile *tempFile;
@end
