#import <Foundation/Foundation.h>

#import "TempData.h"

@interface TempDataCell : UITableViewCell
{
	//
	// インスタンス変数宣言
	//
    UILabel		*nameLabel;						// ファイル名称
	UIImageView *imgView;
}

//
// プロパティの宣言
//
@property (strong) UILabel		*nameLabel;		// 表示名称
@property (strong) UIImageView	*imgView;		// Scan ファイル名称

//
// メソッドの宣言
//
- (void)setModel:(TempData *)aScanData hasDisclosure:(BOOL)newDisclosure;

@end


//
//
//
@interface FileDataCell : UITableViewCell
{
	//
	// インスタンス変数宣言
	//
	UILabel				*nameLabelCell;					// 表示名称

}

//
// プロパティの宣言
//
@property (nonatomic, strong)	UILabel			*nameLabelCell;		// 表示名称


@end
