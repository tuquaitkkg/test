
#import <UIKit/UIKit.h>
#import "ProfileDataManager.h"
#import "CommonManager.h"
#import "PrintRangeCell.h"
#import "SwitchDataCell.h"

@protocol NUpViewControllerDelegate
-(void) nUpSetting:(UIViewController*)viewController didSelectedSuccess:(BOOL)bSuccess;

@end

@interface NUpViewController : UITableViewController <UIPickerViewDelegate, UIPickerViewDataSource>
{
    NSObject <NUpViewControllerDelegate> *__unsafe_unretained delegate;
    UIPickerView *pickerView1;
    UIPickerView *pickerView2;
    NSInteger nNUpStyle;
    NSMutableArray* tableSectionIDs;
    
    UILabel* plblNUpCellTitle;
    UILabel* plblSeqCellTitle;
    NSInteger nSeqRow;

}

//
// プロパティの宣言
//
@property(nonatomic, unsafe_unretained)    id                  delegate;
@property (nonatomic,strong)    NSMutableArray*     m_parrPickerRow;        // メニュー用ピッカー表示項目
@property (nonatomic,strong)    NSMutableArray*     m_parrTwoUpPickerRow;   // メニュー用ピッカー表示項目
@property (nonatomic,strong)    NSMutableArray*     m_parrFourUpPickerRow;  // メニュー用ピッカー表示項目
@property (nonatomic)           NSInteger           nNupRow;                // N-Upの選択行
@property (nonatomic)           NSInteger           nSeqRow;                // 順序の選択行
//
// メソッドの宣言
//
- (IBAction)dosave:(id)sender;                      //保存ボタン処理
@end
