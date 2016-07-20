
#import <UIKit/UIKit.h>
#import "ProfileDataManager.h"
#import "CommonManager.h"
#import "PrintRangeCell.h"
#import "SwitchDataCell.h"

@protocol FinishingViewControllerDelegate
-(void) finishingSetting:(UIViewController*)viewController didSelectedSuccess:(BOOL)bSuccess;

@end

@interface FinishingViewController : UITableViewController <UIPickerViewDelegate, UIPickerViewDataSource>
{
    NSObject <FinishingViewControllerDelegate> *__unsafe_unretained delegate;
    UIPickerView *pickerView1;
    UIPickerView *pickerView2;
    UIPickerView *pickerView3;
    NSMutableArray* tableSectionIDs;
    
    UILabel* plblClosingCellTitle;
    UILabel* plblStapleCellTitle;
    UILabel* plblPunchCellTitle;
    
    BOOL noVisibleStaple;           // ステープル欄表示不可
    BOOL noVisiblePunch;            // パンチ欄表示不可
}

//
// プロパティの宣言
//
@property(nonatomic, unsafe_unretained)    id       delegate;
@property (nonatomic,strong)    NSMutableArray*     m_parrClosingPickerRow;   // とじ位置用ピッカー表示項目
@property (nonatomic,strong)    NSMutableArray*     m_parrStaplePickerRow;    // ステープル用ピッカー表示項目
@property (nonatomic,strong)    NSMutableArray*     m_parrPunchPickerRow;     // パンチ用ピッカー表示項目
@property (nonatomic)           NSInteger           nClosingRow;              // とじ位置の選択行
@property (nonatomic)           NSInteger           nStapleRow;               // ステープルの選択行
@property (nonatomic)           NSInteger           nPunchRow;                // パンチの選択行
@property (nonatomic, assign)   BOOL                canStaple;                // ステープルが選択可能かどうか
@property (nonatomic, assign)   BOOL                canPunch;                 // パンチが選択可能かどうか
@property (nonatomic, assign)   BOOL                noVisibleStaple;          // ステープル欄表示不可(YESの場合)
@property (nonatomic, assign)   BOOL                noVisiblePunch;           // パンチ欄表示不可(YESの場合)
//
// メソッドの宣言
//
- (IBAction)dosave:(id)sender;                      //保存ボタン処理
@end
