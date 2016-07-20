
#import <UIKit/UIKit.h>
#import "PictureViewController.h"
#import "TempDataManager.h"
#import "RootViewController.h"
#import "ScanBeforePictViewController.h"
#import "TempFile.h"
#import "TempFileUtility.h"

@interface ScanAfterPictViewController : PictureViewController <UIDocumentInteractionControllerDelegate>{
    NSString    *SelImagePath;
	UIDocumentInteractionController *m_diCtrl;
}
@property (nonatomic, strong) NSString  *SelImagePath;
@property (nonatomic, strong) TempFile *tempFile;
@property (nonatomic,strong) UIDocumentInteractionController *m_diCtrl;

- (IBAction)doCancel:(id)sender;// [キャンセル]ボタン処理
// モーダル表示した画面を閉じ、TOPに戻る
- (void)OnClose;
// モーダル表示した画面を閉じる
- (void)OnCancel;

@end
