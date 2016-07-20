
#import <Foundation/Foundation.h>
#import "EditableCell.h"

enum
{
    ITEM_NUMBER_DEFAULT,       // デフォルトで使用する場合
    ITEM_NUMBER_JOB_TIME_OUT,  // ジョブ送信のタイムアウト(秒)
};

@interface ProfileDataCell : UITableViewCell
{
	//
	// インスタンス変数宣言
	//
	UILabel				*nameLabelCell;					// 表示名称
	EditableCell		*nameEditableCell;				// 表示名称(入力)
}

//
// プロパティの宣言
//
@property (nonatomic, strong)	UILabel			*nameLabelCell;		// 表示名称
@property (nonatomic, strong)	EditableCell	*nameEditableCell;	// 表示名称(入力)	

// テーブルのフォントサイズが小さい場合は二段表示にするか判定する
- (int)changeFontSize:(NSString*)lblNameText;
// 「itemNumber」でテーブルセルを初期化する
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier itemNumber:(int)itemNumber;

@end
