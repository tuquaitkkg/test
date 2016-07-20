
#import <UIKit/UIKit.h>
@protocol FileNameChangeViewControllerDelegate
-(void) nameChange:(UIViewController*)viewController didNameChangeSuccess:(BOOL)bSuccess;
@end

@interface FileNameChangeViewController : UIViewController <UITextFieldDelegate>
{
    NSObject <FileNameChangeViewControllerDelegate> *__unsafe_unretained delegate;
 
    IBOutlet UILabel* m_fileName;              // ファイル名を入力
    IBOutlet UITextField* m_ptxtfileName;           // ファイル名
    
    NSString* m_pstrFilePath;           // 読み込みファイルパス
    NSString* m_pstrFileName;           // 選択ファイル名
    BOOL      isDirectory;
    
    UIAlertController *errorMessageView;
}
@property (nonatomic, unsafe_unretained) id delegate;
@property (nonatomic, strong) NSString* SelFilePath;
@property (nonatomic, strong) NSString* SelFileName;
@property (nonatomic) BOOL isDirectory;


// 入力チェック
//- (BOOL)CheckError;
- (NSInteger)CheckNewFileName;

// キャンセルし画面を閉じる
- (void)cancelAction;

- (void)setPortraitMenu:(UIBarButtonItem *)barButtonItem;

- (void)popRootView;

- (void)hideErrorMessage;

@end
