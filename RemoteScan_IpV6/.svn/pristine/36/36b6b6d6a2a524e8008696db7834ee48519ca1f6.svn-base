
#import <UIKit/UIKit.h>
#import "TempDataManager.h"
#import "CommonUtil.h"
#import "ScanAfterPreViewController_iPad.h"
#import "ScanBeforePictViewController_iPad.h"
#import "TempFile.h"
#import "Define.h"
#import "RootViewController_iPad.h"
#import "SaveScanAfterDataViewController.h"
#import "FileNameChangeViewController.h"

// iPad用
@protocol UpdateTempDataTableViewController
- (void)popRootView;
- (void)setPortraitMenu:(UIBarButtonItem *)barButtonItem;
@end
// iPad用

@interface TempDataTableViewController_iPad : UITableViewController <FileNameChangeViewControllerDelegate> {
    
    TempDataManager			*tempManager;					// MFPデータ操作Manager
    NSString				*baseDir;					// ホームディレクトリ/Documments/
    BOOL                    m_bScanView;       //取り込みから遷移したからのフラグ
    UIViewController        *__unsafe_unretained prevViewController;
    
    UIBarButtonItem         *shareBtn;  // 複数ファイル共有ボタン
    UIActivityViewController *activityViewController;   // 複数ファイル共有用
}
//
// プロパティの宣言
//
@property (nonatomic, copy)		NSString			*baseDir;		// ホームディレクトリ/Documments/
@property (nonatomic)BOOL                isScan;		// 取り込みフラグ
@property(nonatomic) BOOL bSetTitle; // iPad用 タイトル表示フラグ
@property(nonatomic, strong) NSIndexPath* selectIndexPath; // iPad用 選択行
@property(nonatomic) CGPoint lastScrollOffSet; // iPad用 スクロール位置
@property (nonatomic, unsafe_unretained) UIViewController *prevViewController;

@property(nonatomic ) UIDeviceOrientation previousOrientation;  // 複数ファイル共有回転時の閉じる処理用


//
// メソッドの宣言
//
- (IBAction)dosave:(id)sender;										// [保存]ボタン処理
- (IBAction)doCancel:(id)sender;										// [キャンセル]ボタン処理
// 画面遷移
- (void)MoveView:(NSIndexPath *)nIndexPath;

// iPad用
-(void)ChangeDetailView:(UIViewController*)pViewController didSelectRowAtIndexPath:(NSIndexPath *)indexPath;
- (void) dismissMenuPopOver:(BOOL)bAnimated;
// iPad用

- (void)setPortraitMenu:(UIBarButtonItem *)barButtonItem;

@end
