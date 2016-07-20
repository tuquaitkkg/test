
#import "EditableCell.h"

@implementation EditableCell

//
// アクセサメソッドの自動合成(ゲッターとセッターの役割)
//
@synthesize textField;

#pragma mark -
#pragma mark EditableCell Manager

//
// 状態と再利用識別子でテーブルセルを初期化して返す。
//
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if ((self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]))
	{
        // Initialization code
    }
    return self;
}

//
// 
//
- (id)initWithFrame:(CGRect)frame
{
	if (self = [super initWithFrame:frame])
	{
		// ハイライトなし
		self.selectionStyle = UITableViewCellSelectionStyleNone;
		
		//
        // Initialization code
		//
		textField = [[UITextField alloc] initWithFrame:frame];		
        //		textField.borderStyle				= UITextBorderStyleBezel;
        textField.font						= [UIFont systemFontOfSize:20.0];
        textField.contentVerticalAlignment	= UIControlContentVerticalAlignmentCenter;
        //textField.keyboardType				= UIKeyboardTypeDefault;
        textField.keyboardAppearance        = UIKeyboardAppearanceLight;
        textField.autocapitalizationType	= UITextAutocapitalizationTypeNone;
		//textField.returnKeyType				= UIReturnKeyDone;
		textField.backgroundColor			= [UIColor clearColor];
		textField.textColor					= [UIColor blackColor];
        textField.autoresizingMask			= UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleRightMargin;
        
		//
        // TextFieldの右側にＸボタンを表示
		//
        textField.clearButtonMode = UITextFieldViewModeWhileEditing;
        
		//
        // テキストフィールドをテーブルビューセルに追加
		//
        [self addSubview:textField];
    }
    return self;
}

//
// アプリケーションの終了直前に呼ばれるメソッド
//

@end
