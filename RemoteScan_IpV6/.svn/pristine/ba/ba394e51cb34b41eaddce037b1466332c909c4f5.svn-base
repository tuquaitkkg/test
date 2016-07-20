
#import <UIKit/UIKit.h>
#import "SharpScanPrintAppDelegate.h"


@interface PickerViewController : UIViewController <UIPickerViewDelegate, UIPickerViewDataSource>
{
    UIPickerView* m_ppickerMenu;        // メニュー用ピッカービュー
    
    NSInteger m_nSelPickerRowBefore;   // ピッカー表示時の選択行
    
    NSMutableArray* m_parrPickerRow;
    NSInteger m_nSelRow;
    BOOL m_bSets;
    BOOL m_bScanPrint;
    BOOL m_bUseContentSize;
    BOOL m_bSingleChar;
}
@property (nonatomic,strong) NSMutableArray* m_parrPickerRow;    // メニュー用ピッカー表示項目
@property (nonatomic) NSInteger m_nSelRow;         // ピッカー選択行    
@property (nonatomic) BOOL m_bSets;         // 部数選択フラグ    
@property (nonatomic) BOOL m_bScanPrint;         // プリンター、スキャナ選択フラグ
@property (nonatomic) BOOL m_bUseContentSize;   // contentSizeForViewInPopoverの値でピッカーを作成するフラグ
@property (nonatomic) BOOL m_bSingleChar;      //ピッカーの列が１列１文字であるかどうか
@property (nonatomic,strong) UIPickerView *pPicker;


// ピッカーを表示する
- (void)showPickerView;

// ピッカーを消す
- (void)dismissAnimated:(BOOL)animated;


//決定ボタン押下
- (void)OnMenuDecideButton:(id)sender;


//キャンセルボタン押下
- (void)OnMenuCancelButton:(id)sender;

@end
