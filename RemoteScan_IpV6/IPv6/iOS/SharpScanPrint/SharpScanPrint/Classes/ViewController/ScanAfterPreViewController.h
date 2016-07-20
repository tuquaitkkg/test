
#import <UIKit/UIKit.h>
#import "PictureViewController.h"
#import "TempFile.h"

@interface ScanAfterPreViewController : PictureViewController <UIDocumentInteractionControllerDelegate>{
    NSString				*resource;					// ファイル名称
	NSString				*fileType;					// ファイル形式
	UIDocumentInteractionController *m_diCtrl;
}
@property (nonatomic, copy)		NSString	*resource;	// ファイル名称
@property (nonatomic, copy)		NSString	*fileType;	// ファイル形式
@property (nonatomic,strong) UIDocumentInteractionController *m_diCtrl;
@property (nonatomic,strong) TempFile *tempFile;
@end
