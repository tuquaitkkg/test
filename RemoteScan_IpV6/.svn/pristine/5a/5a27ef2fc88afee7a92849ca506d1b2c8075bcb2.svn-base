
#import <UIKit/UIKit.h>
#import "ScanDataManager.h"
#import "SelectFileSortPopViewController.h"
#import "ScanDirectory.h"
#import "ScanDirectoryUtility.h"
#import "ScanFileUtility.h"
#import "ScanFile.h"
#import "TempFile.h"

@interface SelectFileViewController : UITableViewController <UIGestureRecognizerDelegate, UISearchBarDelegate, UISearchControllerDelegate>

{
    ScanDataManager* m_pScanMgr;                // ScanDataManagerクラス
    PrintPictViewID         m_nPrevViewID;                    // 遷移元画面
    NSString				*baseDir;					// ホームディレクトリ/Documments/
    
    UISearchController *m_searchController;
    //    UISearchBar *m_pSearchBar;
    UIButton *sortTypeButton;
    
    SelectFileSortPopViewController   *sortViewPopUp;
    ScanDirectory *scanDirectory;
    
    // indicator表示用
    UIActivityIndicatorView *indicator;
    
    UIBarButtonItem         *shareBtn;  // 複数ファイル共有ボタン
    NSMutableArray          *mArray;    // 選択項目のindexPath保持
}

@property(nonatomic) PrintPictViewID PrevViewID;
@property (nonatomic, copy)		NSString		*baseDir;		// ホームディレクトリ/Documments/

@property (nonatomic,strong)    ScanDirectory   *scanDirectory;
@property(nonatomic) BOOL bSetTitle; // iPad用 タイトル表示フラグ
@property(nonatomic, strong) NSIndexPath* selectIndexPath; // iPad用 選択行
@property(nonatomic) CGPoint lastScrollOffSet; // iPad用 スクロール位置

@property(nonatomic, strong) UIActivityIndicatorView* indicator; // indicator

// 画面遷移
- (void)MoveView:(NSIndexPath *)nIndexPath;

// ヘッダー表示
- (void)SetHeaderView;

- (void)showSortPopupView: (UIButton*)button; // for sorting menu popoverview
- (void)changeSortType: (UIButton*) button;
- (void)closeSortPopupView;

// 複数印刷対応
@property (nonatomic,assign) BOOL fromSelectFileVC;
@property (nonatomic,assign) BOOL pushFlag;
@property (nonatomic,strong) NSMutableArray *selectFilePathArray;

@end
