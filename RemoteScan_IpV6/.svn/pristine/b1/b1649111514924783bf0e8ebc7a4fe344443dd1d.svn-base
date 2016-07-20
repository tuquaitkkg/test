
#import <UIKit/UIKit.h>

@interface CustomPickerViewController_iPad : UIViewController <UIPickerViewDelegate, UIPickerViewDataSource,UITableViewDelegate,UITableViewDataSource> {
    
    UILabel *m_pLblHighInch_V; //縦上位
    UILabel *m_pLblHighInch_H; //横上位
    UILabel *m_pLblLowInch_V; //縦下位
    UILabel *m_pLblLowInch_H; //横下位
    
    BOOL m_bSelectedV;
    
    UIPickerView *pCustomPicker;
    
    UILabel* m_plblErrMsg;
}
@property (nonatomic,strong) NSMutableArray* m_parrPickerRow;    // メニュー用ピッカー表示項目
@property (nonatomic) NSInteger m_nSelRow;         // ピッカー選択行     
@property (nonatomic) NSInteger m_nSelRowInch; // inchピッカー選択
@property (nonatomic,strong) NSMutableArray* m_parrInchPickerRow;    // メニュー用ピッカー表示項目
@property (nonatomic) NSInteger m_nSelRow2;
@property (nonatomic) NSInteger m_nSelRowInch2;
@property (nonatomic) BOOL m_bInch;        // リモートスキャンフラグ     
// ピッカー作成
- (void)CreateCustomPickerView;


@end
