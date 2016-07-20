
#import <UIKit/UIKit.h>
#import <MailCore/MailCore.h>

@interface MailDataCell : UITableViewCell
{
	//
	// インスタンス変数宣言
	//
    UILabel		*fromLabel;						// ファイル名称
    UILabel		*dateLabel;						// 作成日付
    UILabel		*subjectLabel;					// ファイルサイズ
	UIImageView *imgView;                       // アイコン
}

//
// プロパティの宣言
//
@property (strong) UILabel		*fromLabel;		// 表示名称
@property (strong) UILabel		*dateLabel;		// 作成日付
@property (strong) UILabel		*subjectLabel;	// ファイルサイズ
@property (strong) UIImageView	*imgView;		// アイコン

//
// メソッドの宣言
//
- (void)setModel:(CTCoreMessage*)aCoreMessage hasDisclosure:(BOOL)newDisclosure;
- (void)setImageModel;

@end
