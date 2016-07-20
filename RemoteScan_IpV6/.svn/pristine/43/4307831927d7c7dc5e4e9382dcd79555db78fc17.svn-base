
#import <UIKit/UIKit.h>
#import "PictureViewController_iPad.h"
#import "ScanDataManager.h"
#import "ArrangePictViewController_iPad.h"
#import "CommonManager.h"
#import "ScanFile.h"
#import "ScanFileUtility.h"

@interface ArrangePictViewController_iPad : PictureViewController_iPad <UIDocumentInteractionControllerDelegate>{
    NSString    *SelImagePath;
    NSIndexPath *IndexPath;
    ExAlertController			*alert;						// メッセージ表示
    UIDocumentInteractionController *m_diCtrl;
    CommonManager* m_pCmnMgr;               // CommonManagerクラス
}
@property (nonatomic,strong) UIDocumentInteractionController *m_diCtrl;
@property (nonatomic, strong) NSString  *SelImagePath;
@property (nonatomic, strong) NSIndexPath  *IndexPath;

@end
