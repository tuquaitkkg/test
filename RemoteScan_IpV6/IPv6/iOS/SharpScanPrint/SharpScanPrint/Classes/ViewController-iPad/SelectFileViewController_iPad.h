
#import <UIKit/UIKit.h>
#import "ScanDataManager.h"
#import "SelectFileSortPopViewController_ipad.h"
#import "ScanDirectory.h"
#import "ScanDirectoryUtility.h"
#import "ScanFileUtility.h"
#import "ScanFile.h"
#import "TempFile.h"
// iPad用
@protocol UpdateSelectFileViewController
- (void)updateView:(UIViewController*) pViewController;
- (void)popRootView;
- (void)setPortraitMenu:(UIBarButtonItem *)barButtonItem;
@end
// iPad用
// iPad用
//@interface SelectFileViewController : UITableViewController <UIGestureRecognizerDelegate>
@interface SelectFileViewController_iPad : UITableViewController <UIGestureRecognizerDelegate,UIImagePickerControllerDelegate, UINavigationControllerDelegate, UpdateSelectFileViewController,UISearchBarDelegate, UISearchControllerDelegate>
// iPad用
{
    ScanDataManager* m_pScanMgr;                // ScanDataManagerクラス
    NSInteger m_nPrevViewID;                    // 遷移元画面
    UIPopoverController* m_popOver;             // iPad用 ImagePicker表示用PopOver
    BOOL m_bSetTitle;                           // iPad用 タイトル表示フラグ
    NSString				*baseDir;					// ホームディレクトリ/Documments/
    UIDeviceOrientation previousOrientation;
    
    UISearchController *m_searchController;
    
//    UISearchBar *m_pSearchBar;
    UIButton *sortTypeButton;

    SelectFileSortPopViewController_ipad     *sortMenuViewController;
    UIPopoverController     *sortViewPopoverController;
    ScanDirectory *scanDirectory;
    
    // indicator表示用
    UIActivityIndicatorView *indicator;
    BOOL _observing;   // iPad用 オブザーバー管理用フラグ
    
    UIBarButtonItem         *shareBtn;  // 複数ファイル共有ボタン
    UIActivityViewController *activityViewController;   // 複数ファイル共有用
    NSMutableArray          *mArray;    // 選択項目のindexPath保持

    // UISearchControllerへの置き換え対応
    BOOL bEndActiveAtKBNotification;    // キーボードが閉じられた通知処理で非アクティブ化されたフラグ。端末の回転時に使用。
    
}

@property(nonatomic) NSInteger PrevViewID;
@property(nonatomic) BOOL bSetTitle; // iPad用 タイトル表示フラグ
@property(nonatomic, strong) NSIndexPath* selectIndexPath; // iPad用 選択行
@property(nonatomic) CGPoint lastScrollOffSet; // iPad用 スクロール位置
@property(nonatomic, copy)  NSString    *baseDir;
@property (nonatomic,strong)    ScanDirectory   *scanDirectory;
@property(nonatomic, strong)    SelectFileSortPopViewController_ipad* sortMenuViewController;
@property(nonatomic, strong)    UIPopoverController     *sortViewPopoverController;
@property(nonatomic) BOOL bShowLeftBtn;//左側ボタンを表示するフラグ
@property(nonatomic, strong)    UIButton *sortTypeButton;
@property(nonatomic ) UIDeviceOrientation previousOrientation;
@property(nonatomic, strong) UIActivityIndicatorView* indicator; // indicator

// 画面遷移
- (void)MoveView:(NSIndexPath *)nIndexPath;

// 位置情報の状態を確認する// おそらく使われていない
//-(void)LocationInformationCheck:(NSDictionary *)info;
// 印刷画面に遷移
-(void)MovePrintPictView:(NSDictionary *)printinfo;

// iPad用
// 詳細画面切り替え
- (void)ChangeDetailView:(UIViewController*)pViewController  didSelectRowAtIndexPath:(NSIndexPath *)indexPath;
- (void) dismissMenuPopOver:(BOOL)bAnimated;
// iPad用

- (void)SetHeaderView;

- (void)showSortPopoverview: (UIBarButtonItem*)button; // for sorting menu popoverview

// 複数印刷対応_iPad
@property (nonatomic,assign) BOOL fromSelectFileVC;
@property (nonatomic,assign) BOOL pushFlag;
@property (nonatomic,strong) NSMutableArray *selectFilePathArray;

@end
