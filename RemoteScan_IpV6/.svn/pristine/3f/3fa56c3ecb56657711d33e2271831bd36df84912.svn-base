
#import <UIKit/UIKit.h>
#import "TempFile.h"
#import "ScanDirectory.h"
#import "ScanDirectoryUtility.h"

@protocol CreateFolderViewControllerDelegate
-(void) createFolder:(UIViewController*)viewController didCreatedSuccess:(BOOL)bSuccess;
@end

@interface CreateFolderViewController : UIViewController <UITextFieldDelegate>
{
    NSObject <CreateFolderViewControllerDelegate> *__unsafe_unretained delegate;

    IBOutlet UILabel* m_folderName;              // ファイル名を入力
    IBOutlet UITextField* m_ptxtfolderName;           // ファイル名
}
@property (nonatomic, unsafe_unretained) id delegate;
@property (nonatomic) BOOL bSaveView;// 保存画面からの遷移フラグ
@property (nonatomic,strong) ScanDirectory *scanDirectory;

// フォルダー名をチェック
- (NSInteger)CheckNewFolderName;

- (void)setPortraitMenu:(UIBarButtonItem *)barButtonItem;

- (void)popRootView;

@end
