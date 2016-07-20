
#import <UIKit/UIKit.h>
#import "ELCImagePickerController.h"
#import "ELCAlbumPickerController.h"
#import "MultiPrintPictViewController_iPad.h"
#import "MultiPrintTableViewController_iPad.h"

@interface PrintSelectTypeViewController_iPad : UITableViewController<UINavigationControllerDelegate, ELCImagePickerControllerDelegate, MultiPrintTableViewControllerDelegate, PrintPictViewControllerDelegate_iPad>
{
    
    int nFolderCount;
    NSString* pathDir;
    
    PrinterDataManager* m_pPrinterMgr;      // PrinterDataManagerクラス
   
}

@property(nonatomic, strong) NSIndexPath* selectIndexPath; // iPad用 選択行
@property(nonatomic) BOOL m_bVisibleMenuButton; // 縦表示時のメニューボタン表示フラグ
@property (nonatomic, copy)     NSString        *subDir;
@property (nonatomic, copy)     NSString        *rootDir;
@property (nonatomic, copy)     NSString        *pstrSearchKeyword;
@property(nonatomic) BOOL  bSubFolder;                          // 検索範囲(サブフォルダーを含む)
@property(nonatomic) BOOL  bFillterFolder;                      // 検索対象(フォルダー)
@property(nonatomic) BOOL  bFillterPdf;                         // 検索対象(PDF)
@property(nonatomic) BOOL  bFillterTiff;                        // 検索対象(TIFF)
@property(nonatomic) BOOL  bFillterImage;                       // 検索対象(JPEG,PNG)
@property(nonatomic) BOOL  bFillterOffice;                      // 検索対象(OFFICE)
@property(nonatomic) BOOL  bCanDelete;                      // 検索対象(削除)

// 画面遷移
- (void)MoveView:(NSIndexPath *)nIndexPath;

// 画面更新
- (void)updateView:(NSInteger)preViewID didSelectRowAtIndexPath:(NSIndexPath *)indexPath scrollOffset:(CGPoint)offset subDir:(NSString*)pSubDir rootDir:(NSString*)pRootDir;

- (void)popRootView;

- (void)setPortraitMenu:(UIBarButtonItem *)barButtonItem;

@end
