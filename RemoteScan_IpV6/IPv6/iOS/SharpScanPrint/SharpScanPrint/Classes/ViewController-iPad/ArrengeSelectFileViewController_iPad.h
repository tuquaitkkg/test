
#import <UIKit/UIKit.h>
#import "SelectFileViewController_iPad.h"
#import "CreateFolderViewController.h"
#import "MoveViewController.h"
#import "FileNameChangeViewController.h"
#import "SelectFileSortPopViewController_ipad.h"
#import "ScanDirectory.h"
#import "ScanDirectoryUtility.h"
#import "ScanFile.h"
#import "ScanFileUtility.h"

// iPad用
@protocol UpdateArrangeSelectFileViewController
- (void)updateView:(UIViewController*) pViewController;
- (void)popRootView;
- (void)setPortraitMenu:(UIBarButtonItem *)barButtonItem;
@end
// iPad用

// iPad用
//@interface ArrengeSelectFileViewController : UITableViewController <UIGestureRecognizerDelegate> {
@interface ArrengeSelectFileViewController_iPad : UITableViewController <UIGestureRecognizerDelegate, UINavigationControllerDelegate, UpdateArrangeSelectFileViewController, CreateFolderViewControllerDelegate,MoveViewControllerDelegate,FileNameChangeViewControllerDelegate,UISearchBarDelegate,UISearchControllerDelegate> {
// iPad用
    NSIndexPath             *m_IdexPath;//
	// インスタンス変数宣言
	//
    ScanDataManager			*manager;					// SCANマネージャクラス
	NSString				*baseDir;					// ホームディレクトリ/Documments/
    
    ScanDirectory           *scanDirectory;
    
    NSMutableArray          *mArray;    
	
    UIBarButtonItem *trashBtn;
    UIBarButtonItem *moveBtn;
    UIBarButtonItem *nameChangeBtn;
    UIBarButtonItem *folderCreationBtn;
    UISearchController* m_searchController;
    
//    UISearchBar *m_pSearchBar;
    UIButton *sortTypeButton;

    SelectFileSortPopViewController_ipad     *sortMenuViewController;
    UIPopoverController     *sortViewPopoverController;
    
    // indicator表示用
    UIActivityIndicatorView *indicator;
    BOOL _observing;   // iPad用 オブザーバー管理用フラグ

    FileNameChangeViewController *fileNameChangeViewController;
    
    // UISearchControllerへの置き換え対応
    BOOL bEndActiveAtKBNotification;    // キーボードが閉じられた通知処理で非アクティブ化されたフラグ。端末の回転時に使用。

}

//
// プロパティの宣言
//
@property (nonatomic, copy)		NSString		*baseDir;		// ホームディレクトリ/Documments/
@property (nonatomic,strong)    ScanDirectory   *scanDirectory;
@property(nonatomic) BOOL bSetTitle; // iPad用 タイトル表示フラグ
@property(nonatomic, strong) NSIndexPath* selectIndexPath; // iPad用 選択行
@property(nonatomic) CGPoint lastScrollOffSet; // iPad用 スクロール位置
@property(nonatomic) BOOL bCanDelete; // iPad用 削除ボタン表示
@property(nonatomic, strong)    SelectFileSortPopViewController_ipad* sortMenuViewController;
@property(nonatomic, strong)    UIPopoverController     *sortViewPopoverController;
@property (nonatomic, strong)   NSString        *previewFileName;
@property(nonatomic, strong)    UIButton *sortTypeButton;
@property(nonatomic ) UIDeviceOrientation previousOrientation;
@property(nonatomic, strong) UIActivityIndicatorView* indicator; // indicator

// 画面遷移
- (void)MoveView:(NSIndexPath *)nIndexPath;
- (void) dismissMenuPopOver:(BOOL)bAnimated;

// モーダル表示した画面を閉じる
- (void)OnClose;

- (void)SetHeaderView;

- (void)showSortPopoverview: (UIBarButtonItem*)button; // for sorting menu popoverview

@end
