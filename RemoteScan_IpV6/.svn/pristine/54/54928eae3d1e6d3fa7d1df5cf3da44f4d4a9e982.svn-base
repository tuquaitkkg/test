
#import <UIKit/UIKit.h>
#import "SelectFileViewController.h"
#import "CreateFolderViewController.h"
#import "MoveViewController.h"
#import "FileNameChangeViewController.h"
#import "SelectFileSortPopViewController.h"
#import "ScanDirectory.h"
#import "ScanDirectoryUtility.h"
#import "ScanFile.h"
#import "ScanFileUtility.h"

@interface ArrengeSelectFileViewController : UITableViewController <UIGestureRecognizerDelegate, CreateFolderViewControllerDelegate,MoveViewControllerDelegate,FileNameChangeViewControllerDelegate,UISearchBarDelegate,UISearchControllerDelegate> {

    NSIndexPath             *m_IdexPath;//
	// インスタンス変数宣言
	//
    ScanDataManager			*manager;					// SCANマネージャクラス
	NSString				*baseDir;					// ホームディレクトリ/Documments/
//    NSString                *subDir;
//    NSString                *rootDir;
    
    NSMutableArray          *mArray; //選択項目のindexPath保持
    ScanDirectory           *scanDirectory;
	//
	// The saved state of the search UI if a memory warning removed the view.
	//
    PrintPictViewID         m_nPrevViewID;              // 遷移元画面
    
    UIBarButtonItem *trashBtn;
    UIBarButtonItem *moveBtn;
    UIBarButtonItem *nameChangeBtn;
    UIBarButtonItem *folderCreationBtn;

    UISearchController* m_searchController;
    
//    UISearchBar *m_pSearchBar;
    UIButton *sortTypeButton;
    SelectFileSortPopViewController   *sortViewPopUp;
    
    // indicator表示用
    UIActivityIndicatorView *indicator;
}

//
// プロパティの宣言
//
@property (nonatomic, copy)		NSString		*baseDir;		// ホームディレクトリ/Documments/
//@property (nonatomic, copy)     NSString        *subDir;
//@property (nonatomic, copy)     NSString        *rootDir;
@property (nonatomic)           PrintPictViewID PrevViewID;
@property (nonatomic,strong)    ScanDirectory   *scanDirectory;

@property(nonatomic, strong) UIActivityIndicatorView* indicator; // indicator

// 画面遷移
- (void)MoveView:(NSIndexPath *)nIndexPath;

// モーダル表示した画面を閉じる
- (void)OnClose;

- (void)SetHeaderView;

- (void)showSortPopupView: (UIButton*)button; // for sorting menu popoverview
- (void)changeSortType: (UIButton*) button;
- (void)closeSortPopupView;

@end
