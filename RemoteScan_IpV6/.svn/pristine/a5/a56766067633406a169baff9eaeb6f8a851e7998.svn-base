
#import <UIKit/UIKit.h>


@interface PickerViewController_iPad : UIViewController <UIPickerViewDelegate, UIPickerViewDataSource> {

}
@property (nonatomic,strong) NSMutableArray* m_parrPickerRow;    // メニュー用ピッカー表示項目
@property (nonatomic,strong) NSMutableArray* m_parrPickerRow2;    // メニュー用ピッカー表示項目
@property (nonatomic) NSInteger m_nSelRow;         // ピッカー選択行
@property (nonatomic) NSString *m_notificationName;  // 通知の名前
@property (nonatomic) BOOL m_bSets;         // 部数選択フラグ    
@property (nonatomic) BOOL m_bScanPrint;         // プリンター、スキャナ選択フラグ
@property (nonatomic) BOOL m_bUseContentSize;   // contentSizeForViewInPopoverの値でピッカーを作成するフラグ
@property (nonatomic) BOOL m_bSingleChar;
@property (nonatomic,strong) UIPickerView *pPicker;
@property (nonatomic,strong) UISegmentedControl *segmentedControl;

// ピッカー作成
- (void)CreatePickerView;

- (void)addSegmentedControl;

@end
