
//#import <UIKit/UIKit.h>
//
//@interface AdvancedSearchResultViewController : UITableViewController
//
//@end
//
//  AdvancedSearchResultViewController_iPad.h
//  SharpScanPrint
//
//  Created by 33081000002001 on 13/02/28.
//  Copyright (c) 2013年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SelectFileViewController.h"
#import "MoveViewController.h"
#import "FileNameChangeViewController.h"
#import "SelectFileSortPopViewController.h"
#import "SearchResultViewController.h"
#import "ScanDirectory.h"
#import "ScanFileUtility.h"

@class AdvancedSearchResultViewController;
@protocol AdvancedSearchResultViewControllerDelegate <NSObject>
-(void)willDisAppearAdvancedSearchResultViewController:(AdvancedSearchResultViewController*)advancedSearchResultVC;
@end

@interface AdvancedSearchResultViewController: UITableViewController<UIGestureRecognizerDelegate, UINavigationControllerDelegate, UIImagePickerControllerDelegate, UISearchBarDelegate, UISearchControllerDelegate, MoveViewControllerDelegate,FileNameChangeViewControllerDelegate>
{
    ScanDataManager* m_pScanMgr;                // ScanDataManagerクラス
    PrintPictViewID m_nPrevViewID;                    // 遷移元画面
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
    
    SelectFileSortPopViewController *sortViewPopUp;
    SearchResultViewController *__unsafe_unretained sessionViewController; // 検索キーの共有
    
    // indicator表示用
    UIActivityIndicatorView *indicator;
    
    UIBarButtonItem         *shareBtn;  // 複数ファイル共有ボタン

//    SearchResultViewController
}
@property(nonatomic) ScanDirectory * scanDirectory;
@property(nonatomic) PrintPictViewID PrevViewID;
@property(nonatomic) BOOL bSetTitle; // iPad用 タイトル表示フラグ
@property(nonatomic, strong) NSIndexPath* selectIndexPath; // iPad用 選択行
@property(nonatomic) CGPoint lastScrollOffSet; // iPad用 スクロール位置
@property(nonatomic, copy)  NSString    *baseDir;
@property(nonatomic) BOOL bCanDelete; // iPad用 削除ボタン表示
@property(nonatomic, copy)  NSString    *pstrSearchKeyword;  // 検索バーに入力された文字
@property(nonatomic) BOOL bSubFolder;                        // 検索範囲(サブフォルダーを含む)
@property(nonatomic) BOOL bFillterFolder;                    // 検索対象(フォルダー)
@property(nonatomic) BOOL bFillterPdf;                       // 検索対象(PDF)
@property(nonatomic) BOOL bFillterTiff;                      // 検索対象(TIFF)
@property(nonatomic) BOOL bFillterImage;                     // 検索対象(JPEG,PNG)
@property(nonatomic) BOOL bFillterOffice;                    // 検索対象(OFFICE)
@property (nonatomic, unsafe_unretained)   SearchResultViewController        *sessionViewController; // 検索キーの共有

@property(unsafe_unretained)id<AdvancedSearchResultViewControllerDelegate> delegate;

@property(nonatomic, strong) UIActivityIndicatorView* indicator; // indicator

// 画面遷移
- (void)MoveView:(NSIndexPath *)nIndexPath;

// iPad用
// 詳細画面切り替え
- (void)ChangeDetailView:(UIViewController*)pViewController  didSelectRowAtIndexPath:(NSIndexPath *)indexPath;
- (void) dismissMenuPopOver:(BOOL)bAnimated;
// iPad用

- (void)SetHeaderView;

-(void)advancedSearchRightBarButtonClicked;

- (void)showSortPopupView: (UIButton*)button; // for sorting menu popoverview
- (void)changeSortType: (UIButton*) button;
- (void)closeSortPopupView;

- (void)setPortraitMenu:(UIBarButtonItem *)barButtonItem;
- (void)popRootView;

// 複数印刷対応
@property (nonatomic,assign) BOOL fromSelectFileVC;
@property (nonatomic,assign) BOOL pushFlag;
@property (nonatomic,strong) NSMutableArray *selectFilePathArray;

@end
