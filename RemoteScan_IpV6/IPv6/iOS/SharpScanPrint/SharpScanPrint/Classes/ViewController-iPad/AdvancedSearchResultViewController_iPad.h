
#import <UIKit/UIKit.h>
#import "SelectFileViewController_iPad.h"
#import "MoveViewController.h"
#import "FileNameChangeViewController.h"
#import "ArrengeSelectFileViewController_iPad.h"
#import "SearchResultViewController_iPad.h"
#import "ScanDirectory.h"
#import "ScanFileUtility.h"

@class AdvancedSearchResultViewController_iPad;
@protocol AdvancedSearchResultViewController_iPadDelegate <NSObject>
-(void)willDisAppearAdvancedSearchResultViewController:(AdvancedSearchResultViewController_iPad*)advancedSearchResultVC;
@end

@interface AdvancedSearchResultViewController_iPad: UITableViewController<UIGestureRecognizerDelegate, UINavigationControllerDelegate, UIImagePickerControllerDelegate, UISearchBarDelegate, UISearchControllerDelegate, MoveViewControllerDelegate,FileNameChangeViewControllerDelegate>
{    
    ScanDataManager* m_pScanMgr;                // ScanDataManagerクラス
    NSInteger m_nPrevViewID;                    // 遷移元画面
    UIPopoverController* m_popOver;             // iPad用 ImagePicker表示用PopOver
    BOOL m_bSetTitle;                           // iPad用 タイトル表示フラグ
    NSString				*baseDir;					// ホームディレクトリ/Documments/
    
    NSString                *pstrSearchKeyword;  // 検索バーに入力された文字
    ScanDirectory           *scanDirectory;
    //整理する画面用
    NSMutableArray  *mArray;
    UIBarButtonItem *trashBtn;
    UIBarButtonItem *moveBtn;
    UIBarButtonItem *nameChangeBtn;
    
    UISearchController* m_searchController;
    
//    UISearchBar *m_pSearchBar;
    UIButton *sortTypeButton;
    UIButton* m_pbtnAdvancedSearch;
    UIDeviceOrientation previousOrientation;
    SelectFileSortPopViewController_ipad    *sortMenuViewController;
    UIPopoverController                     *sortViewPopoverController;
    SearchResultViewController_iPad         *__unsafe_unretained sessionViewController; // 検索キーの共有
    
    // indicator表示用
    UIActivityIndicatorView *indicator;
    BOOL _observing;   // iPad用 オブザーバー管理用フラグ
    
    UIBarButtonItem         *shareBtn;  // 複数ファイル共有ボタン
    UIActivityViewController *activityViewController;   // 複数ファイル共有用

    // UISearchControllerへの置き換え対応
    BOOL bEndActiveAtKBNotification;    // キーボードが閉じられた通知処理で非アクティブ化されたフラグ。端末の回転時に使用。

}

@property(unsafe_unretained)id<AdvancedSearchResultViewController_iPadDelegate> delegate;

@property(nonatomic) ScanDirectory * scanDirectory;
@property(nonatomic) NSInteger PrevViewID;
@property(nonatomic) BOOL bSetTitle; // iPad用 タイトル表示フラグ
@property(nonatomic, strong) NSIndexPath* selectIndexPath; // iPad用 選択行
@property(nonatomic) CGPoint lastScrollOffSet; // iPad用 スクロール位置
@property(nonatomic, copy)  NSString    *baseDir;
@property(nonatomic) BOOL bCanDelete; // iPad用 削除ボタン表示
@property(nonatomic, copy)  NSString    *pstrSearchKeyword;   // 検索バーに入力された文字
@property(nonatomic) BOOL bSubFolder;                        // 検索範囲(サブフォルダーを含む)
@property(nonatomic) BOOL bFillterFolder;                    // 検索対象(フォルダー)
@property(nonatomic) BOOL bFillterPdf;                       // 検索対象(PDF)
@property(nonatomic) BOOL bFillterTiff;                      // 検索対象(TIFF)
@property(nonatomic) BOOL bFillterImage;                     // 検索対象(JPEG,PNG)
@property(nonatomic) BOOL bFillterOffice;                    // 検索対象(OFFICE)
@property(nonatomic, strong) SelectFileSortPopViewController_ipad* sortMenuViewController;
@property(nonatomic, strong) UIPopoverController     *sortViewPopoverController;
@property(nonatomic, unsafe_unretained) SearchResultViewController_iPad *sessionViewController; // 検索キーの共有
@property(nonatomic, strong)    UIButton *sortTypeButton;
@property(nonatomic ) UIDeviceOrientation previousOrientation;
@property(nonatomic, strong) UIActivityIndicatorView* indicator; // indicator

// 画面遷移
- (void)MoveView:(NSIndexPath *)nIndexPath;

// iPad用
// 詳細画面切り替え
- (void)ChangeDetailView:(UIViewController*)pViewController  didSelectRowAtIndexPath:(NSIndexPath *)indexPath;
- (void) dismissMenuPopOver:(BOOL)bAnimated;
// iPad用

- (void)SetHeaderView;

- (void)advancedSearchRightBarButtonClicked;

- (void)showSortPopoverview: (UIBarButtonItem*)button; // for sorting menu popoverview

- (void)popRootView;

// 複数印刷対応_iPad
@property (nonatomic,assign) BOOL fromSelectFileVC;
@property (nonatomic,strong) NSMutableArray *selectFilePathArray;

@property(nonatomic, weak) NSString* arrangePreviewFileName; //整理する画面で表示しているファイルのパス

@end
