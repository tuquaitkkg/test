
#import <UIKit/UIKit.h>
#import "TempFile.h"
#import "TempFileUtility.h"
#import "ScanFile.h"
#import "ScanFileUtility.h"
#import "GeneralFileUtility.h"
// iPad用
@protocol UpdateRootViewController
- (void)updateView:(NSInteger)preViewID didSelectRowAtIndexPath:(NSIndexPath *)indexPath scrollOffset:(CGPoint)offset;
- (void)popRootView;
@end
// iPad用

@interface RootViewController_iPad : UITableViewController <UINavigationControllerDelegate, UISplitViewControllerDelegate,UpdateRootViewController>
{
    BOOL                    m_bExitView;       //取り込みから遷移したからのフラグ
    // iPad用
    BOOL                    m_bNoPopRootView;  // 一番最初の状態まで画面を戻すフラグ
    BOOL                    m_bRotation;       // 回転しているかの確認フラグ
    NSString                *subDir;
    NSString                *rootDir;
    // iPad用

}

@property (nonatomic)   BOOL                isExit;		// 取り込みフラグ
@property (nonatomic, strong)   NSURL       *siteUrl;		// ファイル連携URL
// iPad用
@property(nonatomic) BOOL m_bIgnoreDisappear; // 戻るボタン押下時の処理実行フラグ
@property(nonatomic, strong) NSIndexPath* selectIndexPath; // トップメニュー選択行
@property(nonatomic, strong) UIBarButtonItem* barItemMenu; // 縦表示時のメニューボタン
//@property(nonatomic, retain) UIPopoverController* m_popOver;
@property (nonatomic, copy)     NSString        *subDir;
@property (nonatomic, copy)     NSString        *rootDir;
@property (nonatomic, copy)     NSString        *pstrSearchKeyword;
@property(nonatomic) BOOL  bSubFolder;                          // 検索範囲(サブフォルダーを含む)
@property(nonatomic) BOOL  bFillterFolder;                      // 検索対象(フォルダー)
@property(nonatomic) BOOL  bFillterPdf;                         // 検索対象(PDF)
@property(nonatomic) BOOL  bFillterTiff;                        // 検索対象(TIFF)
@property(nonatomic) BOOL  bFillterImage;                       // 検索対象(JPEG,PNG)
@property(nonatomic) BOOL  bFillterOffice;                      // 検索対象(OFFICE)
@property(nonatomic) BOOL  bCanDelete;                          // 検索対象(削除)
@property (nonatomic, copy)     NSString        *pstrSelectFolder;  // E-mail印刷参照フォルダー

@property(nonatomic) BOOL  m_bVisibleMenuButton;                      // メニューボタン表示フラグ

// iPad用

//外部アプリから連携された場合の表示更新
-(void)setDefaultTopScreen;
-(void)showOpenUrlFile;

// 画面遷移
- (void)MoveView:(NSIndexPath *)nIndexPath;
// ヘルプ画面をモーダル表示
- (IBAction)OnShowHelp;
// モーダル表示したヘルプ画面を閉じる
- (void)OnHelpClose;
// モーダル表示した保存画面を閉じる
- (void)OnSaveClose;
// iPad用
// 詳細画面切換え
- (void)ChangeDetailView:(UIViewController*)pViewController;
// 縦向き表示時のメニューPopOverが表示されていたら閉じる
- (void) dismissMenuPopOver:(BOOL)banimated;
// 縦向き表示時の左側のViewをPopOver表示
-(void)ShowMenuPopOverView;
// iPad用
// トップ画面更新(検索用)
- (void)updateView:(NSInteger)preViewID searchPreViewID:(NSInteger)searchViewID didSelectRowAtIndexPath:(NSIndexPath *)indexPath scrollOffset:(CGPoint)offset;

@end
