
#import "EditableCellMulti.h"

@implementation EditableCellMulti
//
// アクセサメソッドの自動合成(ゲッターとセッターの役割)
//
@synthesize textView;
#pragma mark -
#pragma mark EditableCellMulti Manager

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
		textView = [[UIPlaceHolderTextView alloc] initWithFrame:frame];		
        //		textField.borderStyle				= UITextBorderStyleBezel;
        textView.font						= [UIFont systemFontOfSize:20.0];
        //textField.keyboardType				= UIKeyboardTypeDefault;
        textView.autocapitalizationType	= UITextAutocapitalizationTypeNone;
		//textField.returnKeyType				= UIReturnKeyDone;
		textView.backgroundColor			= [UIColor clearColor];
		textView.textColor					= [UIColor blackColor];
        textView.autoresizingMask			= UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleRightMargin;
        textView.contentMode = UIViewContentModeScaleToFill;
        textView.keyboardAppearance = UIKeyboardAppearanceLight;
        
		//
        // テキストフィールドをテーブルビューセルに追加
		//
        [self addSubview:textView];
    }
    return self;
}

//
// アプリケーションの終了直前に呼ばれるメソッド
//


@end
