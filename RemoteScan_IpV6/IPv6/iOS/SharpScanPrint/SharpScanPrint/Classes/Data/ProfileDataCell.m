
#import "ProfileDataCell.h"
#import "Define.h"


@implementation ProfileDataCell

//
// アクセサメソッドの自動合成(ゲッターとセッターの役割)
//
@synthesize nameLabelCell;							// 表示名称
@synthesize nameEditableCell;						// 表示名称(入力)

#define NAME_X 10
#define NAME_Y 5
#define NAME_W 130
#define NAME_H 30

#define NAMEVAL_X 150
#define NAMEVAL_Y 5
#define NAMEVAL_W 155
#define NAMEVAL_H 30

#define NAME_X_IPAD 20
#define NAME_W_IPAD 160
#define NAMEVAL_X_IPAD 180
#define NAMEVAL_W_IPAD 135

// 固定スペース
#define FIXED_SPACE 20
#define RIGHT_SPACE 3

// ジョブ送信のタイムアウト(秒)のタイトル項目におけるセル幅
#define JOB_TIME_OUT_WIDTH 220

#pragma mark -
#pragma mark ProfileDataCell Manager

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
            nameFrame = CGRectMake(NAME_X_IPAD, NAME_Y, NAME_W_IPAD, NAME_H);
        }
        
        nameLabelCell = [[UILabel alloc] initWithFrame:nameFrame];
		[nameLabelCell setFont:[UIFont systemFontOfSize:14]];
        nameLabelCell.backgroundColor = [UIColor clearColor];
//        nameLabelCell.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        [nameLabelCell setAdjustsFontSizeToFitWidth:TRUE];
        [self.contentView addSubview:nameLabelCell];
        
		//
        // 表示名称(入力)
		//
        CGRect nameeditFrame = CGRectMake(NAMEVAL_X, NAMEVAL_Y, NAMEVAL_W, NAMEVAL_H);
        if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
        {
            // iPad用
            nameeditFrame = CGRectMake(NAMEVAL_X_IPAD, NAMEVAL_Y, NAMEVAL_W_IPAD, NAMEVAL_H);
        }
        nameEditableCell = [[EditableCell alloc] initWithFrame:nameeditFrame];
        nameEditableCell.backgroundColor = [UIColor clearColor];
        nameEditableCell.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleRightMargin;
		[nameEditableCell.textField setFont:[UIFont systemFontOfSize:14]];
        [self.contentView addSubview:nameEditableCell];

        float iOSVersion = [[[UIDevice currentDevice] systemVersion] floatValue];
//        DLog(@"iOS %f", iOSVersion);
//        DLog(@"x:%f width:%f",switchField.frame.origin.x,switchField.frame.size.width);

        // テキストフィールドとラベルの位置を調整
        nameFrame = nameLabelCell.frame;
        nameeditFrame = nameEditableCell.textField.frame;
        
        if(iOSVersion >= 7.0 || UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
        {
            // iOS7以降 もしくはiPad
            nameeditFrame.origin.x = self.contentView.frame.size.width - (nameeditFrame.size.width + DISTANCE_2);
            nameFrame.origin.x = DISTANCE_2;
            nameFrame.size.width = nameeditFrame.origin.x - (nameFrame.origin.x + DISTANCE_1);
        }else{
            // iOS6以前
            nameeditFrame.origin.x = self.contentView.frame.size.width - (nameeditFrame.size.width + DISTANCE_1);
            nameFrame.origin.x = DISTANCE_1;
            nameFrame.size.width = nameeditFrame.origin.x - (nameFrame.origin.x + DISTANCE_1);
        }
        
        nameLabelCell.frame = nameFrame;
		nameEditableCell.textField.frame = nameeditFrame;

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


//-------------------------------------------------------------------------
// 「itemNumber」でテーブルセルを初期化する
//-------------------------------------------------------------------------
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier itemNumber:(int)itemNumber
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        // ハイライトなし
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        // フレームを独自生成
        [self setOriginalFrame:itemNumber];
    }
    return self;
}

//-------------------------------------------------------------------------
// nameLabelCellとnameEditableCellの大きさを「itemNumber」によって決定する。
// 「itemNumber」を増やす場合は、対応するメソッドを作成すること。
//-------------------------------------------------------------------------
- (void)setOriginalFrame:(int)itemNumber {

    // ジョブ送信のタイムアウト(秒)
    if (itemNumber == ITEM_NUMBER_JOB_TIME_OUT) {
        [self makeJobTimeOut];
    }
}

// ジョブ送信のタイムアウト(秒)項目におけるセルを作成する
- (void)makeJobTimeOut {
    
    // nameLabelCellのFrame作成
    CGRect leftFrame = self.contentView.frame;
    // nameEditableCellのFrameの作成
    CGRect rightFrame = self.contentView.frame;
    
    float iOSVersion = [[[UIDevice currentDevice] systemVersion] floatValue];
    CGFloat originSpace;
    
    if(iOSVersion >= 7.0 || UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
    {
        // iOS7以降 もしくはiPad
        originSpace = 20;
        
    }else {
        // iOS6以前
        originSpace = 10;
    }
    
    // 使用可能な幅(leftFrame.size.width + rightFrame.size.width)
    CGFloat totalSizeWidth = self.contentView.frame.size.width - originSpace - FIXED_SPACE;
    
    // nameLabelCellの表示位置
    leftFrame.origin.x = originSpace;
    // nameLabelCellの幅
    leftFrame.size.width = JOB_TIME_OUT_WIDTH;
    
    // nameEditableCellの幅
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        rightFrame.size.width = totalSizeWidth - leftFrame.size.width - RIGHT_SPACE;
    }
    else {
        rightFrame.size.width = totalSizeWidth - leftFrame.size.width;
    }
    // nameEditableCellの表示位置
    rightFrame.origin.x = originSpace + leftFrame.size.width + FIXED_SPACE;
    
    // nameLabelCell生成
    nameLabelCell = [[UILabel alloc] initWithFrame:leftFrame];
    nameLabelCell.font = [UIFont systemFontOfSize:[UIFont systemFontSize]];
    nameLabelCell.backgroundColor = [UIColor clearColor];
    nameLabelCell.adjustsFontSizeToFitWidth = YES;
    nameLabelCell.numberOfLines = 2;
    nameLabelCell.textAlignment = NSTextAlignmentLeft;
    [self.contentView addSubview:nameLabelCell];
    
    // nameEditableCell生成
    nameEditableCell = [[EditableCell alloc] initWithFrame:rightFrame];
    nameEditableCell.textField.font = [UIFont systemFontOfSize:[UIFont systemFontSize]];
    nameEditableCell.backgroundColor = [UIColor clearColor];
    nameEditableCell.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleRightMargin;
    [self.contentView addSubview:nameEditableCell];
}


//
// アプリケーションの終了直前に呼ばれるメソッド
//

@end
