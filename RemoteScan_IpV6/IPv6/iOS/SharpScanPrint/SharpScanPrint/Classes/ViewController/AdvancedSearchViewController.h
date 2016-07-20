
#import <UIKit/UIKit.h>
#import "SwitchDataCell.h"

@interface AdvancedSearchViewController : UIViewController
{
    IBOutlet UITableView *advancedSearchTableView;
    BOOL     m_bSubFolder;
    BOOL     m_bFillterFolder;
    BOOL     m_bFillterPdf;
    BOOL     m_bFillterTiff;
    BOOL     m_bFillterImage;
    BOOL     m_bFillterOffice;
    
    SwitchDataCell *swSubFolderCell;
    UITableViewController *__unsafe_unretained sessionViewController;
}

@property(nonatomic) BOOL bSubFolder;                        // 検索範囲(サブフォルダーを含む)
@property(nonatomic) BOOL bFillterFolder;                    // 検索対象(フォルダー)
@property(nonatomic) BOOL bFillterPdf;                       // 検索対象(PDF)
@property(nonatomic) BOOL bFillterTiff;                      // 検索対象(TIFF)
@property(nonatomic) BOOL bFillterImage;                     // 検索対象(JPEG,PNG)
@property(nonatomic) BOOL bFillterOffice;                    // 検索対象(OFFICE)
@property(nonatomic, unsafe_unretained) UITableViewController *sessionViewController; // 検索キーの共有
// 複数印刷対応
@property (nonatomic,assign) BOOL fromSelectFileVC;

@end
