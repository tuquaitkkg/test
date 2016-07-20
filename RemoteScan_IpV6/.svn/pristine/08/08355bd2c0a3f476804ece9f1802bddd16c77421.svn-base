
#import <UIKit/UIKit.h>
#import "SharpScanPrintAppDelegate.h"

@interface CustomPickerViewController : UIViewController
<UIPickerViewDelegate, UIPickerViewDataSource,
UITableViewDelegate, UITableViewDataSource>
{
    UITableView* m_errorLabel;          // エラーメッセージ表示用
    UITableView* m_tableMenue;          // 縦/横設定用メニュー
    UIPickerView* m_ppickerMenu;        // メニュー用ピッカービュー
    
    NSInteger m_nSelPickerRowBefore;   // ピッカー表示時の選択行
    
    NSMutableArray* m_parrPickerRow;
    NSInteger m_nSelRow;
    BOOL m_bSets;
    BOOL m_bScanPrint;
    BOOL m_bUseContentSize;
    
    UILabel *m_pLblHighInch_V; //縦上位
    UILabel *m_pLblHighInch_H; //横上位
    UILabel *m_pLblLowInch_V; //縦下位
    UILabel *m_pLblLowInch_H; //横下位
    
    BOOL m_bSelectedV;
    
    UIPickerView *pCustomPicker;
    
    UILabel* m_plblErrMsg;
    
//    UIButton* pDecideBtn;
    
//    NSInteger row;
//    NSString* str;
//    NSString* str2;
//    NSString* str3;
//    NSString* str4;

}
@property (nonatomic,strong) NSMutableArray* m_parrPickerRow;    // メニュー用ピッカー表示項目
@property (nonatomic) NSInteger m_nSelRow;         // ピッカー選択行    
@property (nonatomic) NSInteger m_nSelRowInch; // inchピッカー選択  added
///[[[
@property (nonatomic,strong) NSMutableArray* m_parrInchPickerRow;    // メニュー用ピッカー表示項目
@property (nonatomic) NSInteger m_nSelRow2;
@property (nonatomic) NSInteger m_nSelRowInch2;

@property (nonatomic) BOOL m_bInch;        // リモートスキャンフラグ     

@property (nonatomic) BOOL m_bSets;         // 部数選択フラグ    
@property (nonatomic) BOOL m_bScanPrint;         // プリンター、スキャナ選択フラグ
@property (nonatomic) BOOL m_bUseContentSize;   // contentSizeForViewInPopoverの値でピッカーを作成するフラグ





// ピッカーを表示する
- (void)showPickerViewWithDelegate: (id)delegate;

//ボタンアクション
- (void)OnMenuDecideButton:(id)sender;
- (void)OnMenuCancelButton:(id)sender;
@end
