
#import <UIKit/UIKit.h>
#import "AttachmentData.h"

@interface AttachmentDataCell : UITableViewCell
{
	//
	// インスタンス変数宣言
	//
    UILabel		*nameLabel;						// ファイル名称
    UILabel		*dateLabel;						// 作成日付
    UILabel		*fsizeLabel;					// ファイルサイズ
	UIImageView *imgView;
    UIImageView *selectImgView;
}

//
// プロパティの宣言
//
@property (strong) UILabel		*nameLabel;		// 表示名称
@property (strong) UILabel		*dateLabel;		// 作成日付
@property (strong) UILabel		*fsizeLabel;	// ファイルサイズ
@property (strong) UIImageView	*imgView;		// Attachment ファイル名称
@property (strong) UIImageView  *selectImgView;

//
// メソッドの宣言
//
- (void)setModel:(AttachmentData *)aAttachmentData hasDisclosure:(BOOL)newDisclosure;
- (void)setImageModel;

@end