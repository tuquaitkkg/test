
#import <UIKit/UIKit.h>
#import "EditableCell.h"

@interface PrintRangeCell : UITableViewCell
{
    //
	// インスタンス変数宣言
	//
	EditableCell		*nameEditableCell;				// 直接指定
}

//
// プロパティの宣言
//
@property (nonatomic, strong)	EditableCell	*nameEditableCell;	// 直接指定

//// テーブルのフォントサイズが小さい場合は二段表示にするか判定する
//- (int)changeFontSize:(NSString*)lblNameText;

@end
