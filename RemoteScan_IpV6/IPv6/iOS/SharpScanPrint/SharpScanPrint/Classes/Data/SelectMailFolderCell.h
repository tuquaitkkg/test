
#import <UIKit/UIKit.h>
#import <MailCore/MailCore.h>

@interface SelectMailFolderCell : UITableViewCell
{
	//
	// インスタンス変数宣言
	//
    UILabel		*nameLabel;						// ファイル名称
	UIImageView *imgView;                       // サムネイル
}

//
// プロパティの宣言
//
@property (strong) UILabel		*nameLabel;		// フォルダー名称
@property (strong) UIImageView	*imgView;		// サムネイル

//
// メソッドの宣言
//
- (void)setModel:(NSString *)aFileName hasDisclosure:(BOOL)newDisclosure;
- (void)setImageModel;

@end
