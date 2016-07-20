
#import <Foundation/Foundation.h>
#import "EditableCell.h"

@interface PrinterDetailDataCell : UITableViewCell
{
	UILabel* m_plblCellTitle;       // Cellのタイトル
	UILabel* m_plblCellValue;       // Cellの値
    EditableCell* m_pEditCellValue; // Cellの値（入力）
    BOOL m_bEditCell;               // 入力可能セルかどうか
}

@property (nonatomic, strong) UILabel* CellTitle;
@property (nonatomic, strong) UILabel* CellValue;
@property (nonatomic, strong) EditableCell* EditCellValue;
@property (nonatomic) BOOL IsEditCell;

// 初期化メソッド
- (id)initWithStyle:(UITableViewCellStyle)style
    reuseIdentifier:(NSString *)reuseIdentifier
         isEditCell:(BOOL)isEditCell;

// プリンタ情報設定
- (void)SetCellPrinterInfo:(NSString*)pstrTitle
                     value:(NSString*)pstrValue
             hasDisclosure:(BOOL)newDisclosure
                IsEditCell:(BOOL)bEditCell
              keyboardType:(UIKeyboardType)pKeyboardType;

// テーブルのフォントサイズが小さい場合は二段表示にするか判定する
- (int)changeFontSize:(NSString*)lblNameText;
@end
