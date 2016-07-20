
#import <UIKit/UIKit.h>

@interface ELCAlbumCell : UITableViewCell
{
    //
    // インスタンス変数宣言
    //
    UILabel		*albumNameLabel;    // アルバム名
    UIImageView *albumImageView;    // アルバムイメージ
}

//
// プロパティの宣言
//
@property (strong) UILabel		*albumNameLabel;    // アルバム名
@property (strong) UIImageView	*albumImageView;    // アルバムイメージ

//
// メソッドの宣言
//

@end
