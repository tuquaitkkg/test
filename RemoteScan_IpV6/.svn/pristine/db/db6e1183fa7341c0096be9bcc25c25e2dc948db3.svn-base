
#import "ButtonDataCell.h"
#import "Define.h"

@implementation ButtonDataCell
//
// アクセサメソッドの自動合成(ゲッターとセッターの役割)
//
@synthesize nameLabelCell;							// 表示名称
@synthesize buttonCell;                             // ボタン

#define NAME_X 10
#define NAME_Y 7
#define NAME_W 270
#define NAME_H 30

#define NAMEVAL_X 10//180
#define NAMEVAL_Y 7
#define NAMEVAL_W 280//80
#define NAMEVAL_H 30

#define NAME_X_IPAD 10//100
#define NAME_W_IPAD 620
#define NAMEVAL_X_IPAD 180
#define NAMEVAL_W_IPAD 300

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
		// ハイライトなし
//		self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        self.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        
		//
        // 表示名 - ラベル
		//
        CGRect nameFrame = CGRectMake(NAME_X, NAME_Y, NAME_W, NAME_H);
        if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
        {
            // iPad用
            nameFrame = CGRectMake(NAME_X_IPAD, NAME_Y, NAME_W_IPAD, NAME_H);
        }
        nameLabelCell = [[UILabel alloc] initWithFrame:nameFrame];
        nameLabelCell.backgroundColor = [UIColor clearColor];
		[nameLabelCell setFont:[UIFont systemFontOfSize:14]];
        [nameLabelCell setAdjustsFontSizeToFitWidth:TRUE];
        nameLabelCell.textAlignment = NSTextAlignmentCenter;
        [self.contentView addSubview:nameLabelCell];
		
		//
        // button    - ボタン
		//
        /*
        CGRect btnFrame = CGRectMake(NAMEVAL_X, NAMEVAL_Y, NAMEVAL_W, NAMEVAL_H);
        if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
        {
            // iPad用
            btnFrame = CGRectMake(NAMEVAL_X_IPAD, NAMEVAL_Y, NAMEVAL_W_IPAD, NAMEVAL_H);
        }

        buttonCell = [[UIButton buttonWithType:UIButtonTypeRoundedRect]retain];
        buttonCell.frame = btnFrame;
        
        buttonCell.autoresizingMask = UIViewAutoresizingNone;

//        buttonCell.contentMode = UIViewContentModeRight;
        
        [buttonCell.titleLabel setFont:[UIFont systemFontOfSize:14]];
        [buttonCell setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [buttonCell setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];

//        [buttonCell setBackgroundImage:[UIImage imageNamed:S_IMAGE_BUTTON_BLUE] forState:UIControlStateNormal];
                
        [self.contentView addSubview:buttonCell];
		*/
    }
	
    return self;

}

// テーブルのフォントサイズが小さい場合は二段表示にするか判定する
- (int)changeFontSize:(NSString*)lblNameText
{
    int iChangeFontSize = -1;
    for(int uFontSize = 14; uFontSize > 0 ; uFontSize--)
    {
        CGSize boundingSize = CGSizeMake(NAME_W, NAME_H*2);
        if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
        {
            // iPad用
            boundingSize = CGSizeMake(NAME_W_IPAD, NAME_H*2);
        }
        // 指定したフォントサイズでのラベルのサイズを取得する
        CGSize labelsize = [lblNameText sizeWithFont:
                            [UIFont systemFontOfSize:uFontSize]
                                   constrainedToSize:boundingSize
                                       lineBreakMode:NSLineBreakByWordWrapping];
        
        // 各フォントサイズで二段表示時の高さを取得した場合、そのフォントサイズを返す
        switch (uFontSize) {
            case 14:
                if(labelsize.height != 36)
                {
                    continue;
                }
                break;
                
            case 13:
                if(labelsize.height != 32)
                {
                    continue;
                }
                break;
                
            case 12:
                if(labelsize.height != 30)
                {
                    continue;
                }
                break;
            case 11:
                if(labelsize.height != 28)
                {
                    continue;
                }
                break;
            case 10:
                if(labelsize.height != 26)
                {
                    continue;
                }
                break;
            case 9:
                if(labelsize.height != 24)
                {
                    continue;
                }
                break;
            case 8:
                if(labelsize.height != 22)
                {
                    continue;
                }
                break;
            case 7:
                if(labelsize.height != 20)
                {
                    continue;
                }
                break;
            case 6:
                if(labelsize.height != 16)
                {
                    continue;
                }
                break;
            case 5:
                if(labelsize.height != 14)
                {
                    continue;
                }
                break;
            case 4:
                if(labelsize.height != 12)
                {
                    continue;
                }
                break;
            case 3:
                if(labelsize.height != 10)
                {
                    continue;
                }
                break;
            case 2:
                if(labelsize.height != 8)
                {
                    continue;
                }
                break;
            case 1:
                if(labelsize.height != 6)
                {
                    continue;
                }
                break;
                
            default:
                break;
        }
        
        iChangeFontSize = uFontSize;
        
        return iChangeFontSize;
    }
    return -1;
}

//
// アプリケーションの終了直前に呼ばれるメソッド
//


@end
