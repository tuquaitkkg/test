
#import <UIKit/UIKit.h>

@interface ButtonDataCell : UITableViewCell{
    //
	// インスタンス変数宣言
	//
	UILabel				*nameLabelCell;					// 表示名 - ラベル
	UIButton			*buttonCell;					// button - ボタン
}
//
// プロパティの宣言
//
@property (nonatomic, strong)	UILabel		*nameLabelCell;		// 表示名 - ラベル
@property (nonatomic, strong)	UIButton	*buttonCell;		// button    - ボタンチ

// テーブルのフォントサイズが小さい場合は二段表示にするか判定する
- (int)changeFontSize:(NSString*)lblNameText;
@end
