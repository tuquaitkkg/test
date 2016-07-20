
#import <UIKit/UIKit.h>
#import "PictureViewController_iPad.h"
#import "TempDataManager.h"
#import "RootViewController_iPad.h"
#import "ScanBeforePictViewController_iPad.h"
#import "TempFile.h"
#import "TempFileUtility.h"
#import "CommonManager.h"
#import "FileNameChangeViewController.h"

@interface ScanAfterPictViewController_iPad : PictureViewController_iPad <UIDocumentInteractionControllerDelegate, FileNameChangeViewControllerDelegate>{
    NSString    *SelImagePath;
    UIDocumentInteractionController *m_diCtrl;
    CommonManager* m_pCmnMgr;               // CommonManagerクラス

}
@property (nonatomic, strong) NSString  *SelImagePath;
@property (nonatomic, strong) TempFile *tempFile;
@property (nonatomic, strong) UIDocumentInteractionController *m_diCtrl;

- (IBAction)doCancel:(id)sender;            // [キャンセル]ボタン処理

@end
