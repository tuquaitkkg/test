
#import "ProfileDataCellMulti.h"
#import "Define.h"

@implementation ProfileDataCellMulti

//
// アクセサメソッドの自動合成(ゲッターとセッターの役割)
//
@synthesize nameLabelCell;							// 表示名称
@synthesize nameEditableCellMulti;						// 表示名称(入力)

#define NAME_X 10
#define NAME_Y 5
#define NAME_W 130
#define NAME_H 30

#define NAMEVAL_X 150
#define NAMEVAL_Y 5
#define NAMEVAL_W 155
#define NAMEVAL_H 30

#define NAME_X_IPAD 20
#define NAMEVAL_W_IPAD 165

#pragma mark -
#pragma mark ProfileDataCellMulti Manager
//
// 状態と再利用識別子でテーブルセルを初期化して返す。
//
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
	{
		// ハイライトなし
		self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        
		//
        // 表示名称
		//
        CGRect nameFrame = CGRectMake(NAME_X, NAME_Y, NAME_W, NAME_H);
        if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
        {
            // iPad用
            nameFrame = CGRectMake(NAME_X_IPAD, NAME_Y, NAME_W, NAME_H);
        }
        
        nameLabelCell = [[UILabel alloc] initWithFrame:nameFrame];
		[nameLabelCell setFont:[UIFont systemFontOfSize:14]];
        nameLabelCell.backgroundColor = [UIColor clearColor];
        [nameLabelCell setAdjustsFontSizeToFitWidth:TRUE];
        [self.contentView addSubview:nameLabelCell];
        
		//
        // 表示名称(入力)
		//
        CGRect nameeditFrame = CGRectMake(NAMEVAL_X, NAMEVAL_Y, NAMEVAL_W, NAMEVAL_H);
        if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
        {
            // iPad用
            CGFloat sep = 10.0;
            nameeditFrame = CGRectMake(NAMEVAL_X + sep, NAMEVAL_Y, NAMEVAL_W_IPAD - sep, NAMEVAL_H);
        }
        nameEditableCellMulti = [[EditableCellMulti alloc] initWithFrame:nameeditFrame];
        nameEditableCellMulti.backgroundColor = [UIColor clearColor];
        nameEditableCellMulti.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleRightMargin;
		[nameEditableCellMulti.textView setFont:[UIFont systemFontOfSize:14]];
        nameEditableCellMulti.textView.editable = TRUE;
        nameEditableCellMulti.textView.keyboardAppearance = UIKeyboardAppearanceLight;
        
        [self.contentView addSubview:nameEditableCellMulti];
      
        float iOSVersion = [[[UIDevice currentDevice] systemVersion] floatValue];

        // 位置を調整
        nameFrame = nameLabelCell.frame;
        
        if(iOSVersion >= 7.0 || UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
        {
            // iOS7以降 もしくはiPad
            nameFrame.origin.x = DISTANCE_2;
            nameFrame.size.width = nameeditFrame.origin.x - (nameFrame.origin.x + DISTANCE_1);
        }else{
            // iOS6以前
            nameFrame.origin.x = DISTANCE_1;
            nameFrame.size.width = nameeditFrame.origin.x - (nameFrame.origin.x + DISTANCE_1);
        }
        
		nameLabelCell.frame = nameFrame;

    }
    return self;
}

//
// アプリケーションの終了直前に呼ばれるメソッド
//


@end
