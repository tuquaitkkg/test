
#import <UIKit/UIKit.h>
#import "PrintRangeCell.h"
#import "SwitchDataCell.h"

@protocol PrintRangeSettingViewControllerDelegate
-(void) printRangeSetting:(UIViewController*)viewController didCreatedSuccess:(BOOL)bSuccess;
@end

@interface PrintRangeSettingViewController : UITableViewController <UITextFieldDelegate, UIPickerViewDelegate, UIPickerViewDataSource>
{
    NSObject <PrintRangeSettingViewControllerDelegate> *__unsafe_unretained delegate;

    //
    // インスタンス変数宣言
    //
    
    UIPickerView *pickerView1;
    UIPickerView *pickerView2;
    UILabel *lblSeparate;
    NSInteger m_PrintRangeStyle;
    NSInteger m_PageMax;                      // 範囲指定MAXページ数
    NSInteger m_PageFrom;               // 範囲指定FROM
    NSInteger m_PageTo;                 // 範囲指定TO
    NSString* m_PageDirect;             // 直接指定
    BOOL noRangeDesignation;            // 「範囲指定」不可フラグ
    NSMutableArray* tableSectionIDs;
    NSString *pstrErrMessage;
}

//
// プロパティの宣言
//
@property(nonatomic, unsafe_unretained) id delegate;
@property (nonatomic, strong) PrintRangeCell		*pageDirectCell;         //
@property (nonatomic,strong) NSMutableArray* m_parrPickerRow;    // メニュー用ピッカー表示項目
@property NSInteger m_PrintRangeStyle;
@property NSInteger m_PageMax;
@property NSInteger m_PageFrom;
@property NSInteger m_PageTo;
@property BOOL noRangeDesignation;
@property(nonatomic, strong) NSString* m_PageDirect;

@end
