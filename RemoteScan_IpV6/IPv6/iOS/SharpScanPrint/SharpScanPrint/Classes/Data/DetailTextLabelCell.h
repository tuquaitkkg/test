
#import <UIKit/UIKit.h>

@interface DetailTextLabelCell : UITableViewCell
{
    //
    // インスタンス変数宣言
    //
    UILabel				*textLabelCell;					// 表示名称(textLabel)
    UILabel				*detailTextLabelCell;			// 表示名称(detailTextLabel)
}

//
// プロパティの宣言
//
@property (nonatomic, strong)	UILabel	*textLabelCell;         // 表示名称(textLabel)
@property (nonatomic, strong)	UILabel	*detailTextLabelCell;	// 表示名称(detailTextLabel)

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier textLabelRatio:(int)textLabelRatio detailTextLabelRatio:(int)detailTextLabelRatio;
- (void)setOriginalFrame:(int)textLabelRatio detailTextLabelRatio:(int)detailTextLabelRatio;

@end
