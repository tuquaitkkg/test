
#import <UIKit/UIKit.h>
#import "PictureViewController.h"
#import "ScanDataManager.h"
#import "ArrangePictViewController.h"
#import "ScanFile.h"
#import "ScanFileUtility.h"

@interface ArrangePictViewController : PictureViewController <UIDocumentInteractionControllerDelegate>{
    NSString    *SelImagePath;
    NSIndexPath *IndexPath;
    UIAlertController *alert;	// メッセージ表示
    
	UIDocumentInteractionController *m_diCtrl;
}
@property (nonatomic, strong) NSString  *SelImagePath;
@property (nonatomic, strong) NSIndexPath  *IndexPath;
@property (nonatomic,strong) UIDocumentInteractionController *m_diCtrl;
@end
