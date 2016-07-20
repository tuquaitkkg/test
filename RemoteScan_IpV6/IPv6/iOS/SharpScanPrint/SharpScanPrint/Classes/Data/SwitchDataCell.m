
#import "SwitchDataCell.h"
#import "Define.h"


@implementation SwitchDataCell
//
// アクセサメソッドの自動合成(ゲッターとセッターの役割)
//
@synthesize nameLabelCell;							// 表示名称
@synthesize switchField;							// 表示名 - ラベル

#define NAME_X 10
#define NAME_Y 7
#define NAME_W 170
#define NAME_H 30

#define NAMEVAL_X 210
#define NAMEVAL_Y 7
#define NAMEVAL_W 115
#define NAMEVAL_H 30

#define NAME_X_IPAD 20
#define NAME_W_IPAD 400
#define NAMEVAL_X_IPAD 200

#pragma mark -
#pragma mark SwitchDataCell Manager

//
// 状態と再利用識別子でテーブルセルを初期化して返す。
//
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) 
	{
		// ハイライトなし
		self.selectionStyle = UITableViewCellSelectionStyleNone;
        
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
        nameLabelCell.autoresizingMask = UIViewAutoresizingFlexibleWidth;
		[nameLabelCell setFont:[UIFont systemFontOfSize:14]];
        [nameLabelCell setAdjustsFontSizeToFitWidth:TRUE];
        [self.contentView addSubview:nameLabelCell];
		
		//
        // SW    - スイッチ
		//
        CGRect switchFrame = CGRectMake(NAMEVAL_X, NAMEVAL_Y, NAMEVAL_W, NAMEVAL_H);
        if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
        {
            // iPad用
            switchFrame = CGRectMake(NAMEVAL_X_IPAD, NAMEVAL_Y, NAMEVAL_W, NAMEVAL_H);
        }
        switchField = [[UISwitch alloc] initWithFrame:switchFrame];	
        switchField.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin;
        switchField.contentMode = UIViewContentModeRight;
        [self.contentView addSubview:switchField];
        
        float iOSVersion = [[[UIDevice currentDevice] systemVersion] floatValue];
//        DLog(@"iOS %f", iOSVersion);
//        DLog(@"x:%f width:%f",switchField.frame.origin.x,switchField.frame.size.width);
        
        // スイッチとラベルの位置を調整
        switchFrame = switchField.frame;
        nameFrame = nameLabelCell.frame;
        
        if(iOSVersion >= 7.0 || UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
        {
            // iOS7以降 もしくはiPad
            switchFrame.origin.x = self.contentView.frame.size.width - (switchFrame.size.width + DISTANCE_2);
            nameFrame.origin.x = DISTANCE_2;
            nameFrame.size.width = switchFrame.origin.x - (nameFrame.origin.x + DISTANCE_1);
        }else{
            // iOS6以前
            switchFrame.origin.x = self.contentView.frame.size.width - (switchFrame.size.width + DISTANCE_1);
            nameFrame.origin.x = DISTANCE_1;
            nameFrame.size.width = switchFrame.origin.x - (nameFrame.origin.x + DISTANCE_1);
        }
        
        switchField.frame = switchFrame;
		nameLabelCell.frame = nameFrame;
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
