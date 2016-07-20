
#import "DetailTextLabelCell.h"
#import "Define.h"
#import "ProfileData.h"
#import "ProfileDataManager.h"

@implementation DetailTextLabelCell

//
// アクセサメソッドの自動合成(ゲッターとセッターの役割)
//
@synthesize textLabelCell;			// 表示名称(textLabel)
@synthesize detailTextLabelCell;	// 表示名称(detailTextLabel)

// ラベル間の余白
#define LABEL_SPACE 10

#pragma mark -
#pragma mark ProfileDataCell Manager


//-------------------------------------------------------------------------
// 状態と再利用識別子でテーブルセルを初期化して返す。
// なお、textLabelとdetailTextLabelの大きさを比率を与えて生成することが可能s。
//-------------------------------------------------------------------------
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier textLabelRatio:(int)textLabelRatio detailTextLabelRatio:(int)detailTextLabelRatio
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        // アクセサリを設定
        self.accessoryType = TABLE_CELL_ACCESSORY;
        // フレームを独自生成
        [self setOriginalFrame:textLabelRatio detailTextLabelRatio:detailTextLabelRatio];
    }
    return self;
}

//-------------------------------------------------------------------------
// textLabelとdetailTextLabelの大きさを比率を与えて生成する
// (例)2：3の比率で作成したい場合、下記の値を引数にセットする
// textLabelRatio:2
// detailTextLabelRatio:3
//-------------------------------------------------------------------------
- (void)setOriginalFrame:(int)textLabelRatio detailTextLabelRatio:(int)detailTextLabelRatio {
    
    // textLabelFrameの作成
    CGRect textLabelFrame = self.contentView.frame;
    // detailTextLabelFrameの作成
    CGRect detailTextLabelFrame = self.contentView.frame;
    
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
    
    // トータルラベルサイズ幅(textLabelFrame.size.width + detailTextLabelFrame.size.width)
    CGFloat totalLabelSizeWidth = self.contentView.frame.size.width - originSpace - LABEL_SPACE;
    // 分母(トータル比率)
    int totalRatio = textLabelRatio + detailTextLabelRatio;
    
    // textLabelの表示位置
    textLabelFrame.origin.x = originSpace;
    // textLabelの幅
    textLabelFrame.size.width = totalLabelSizeWidth * textLabelRatio / totalRatio;
    
    // detailTextLabelの幅
    detailTextLabelFrame.size.width = totalLabelSizeWidth * detailTextLabelRatio / totalRatio;
    // detailTextLabelの表示位置
    detailTextLabelFrame.origin.x = self.contentView.frame.size.width - detailTextLabelFrame.size.width;

    // textLabel生成
    textLabelCell = [[UILabel alloc]initWithFrame:textLabelFrame];
    textLabelCell.font = [UIFont systemFontOfSize:[UIFont systemFontSize]];
    textLabelCell.backgroundColor = [UIColor clearColor];
    textLabelCell.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleRightMargin;
    textLabelCell.adjustsFontSizeToFitWidth = YES;
    textLabelCell.numberOfLines = 2;
    textLabelCell.textAlignment = NSTextAlignmentLeft;
    [self.contentView addSubview:textLabelCell];
    
    // detailTextLabel生成
    detailTextLabelCell = [[UILabel alloc]initWithFrame:detailTextLabelFrame];
    detailTextLabelCell.font = [UIFont systemFontOfSize:[UIFont systemFontSize]];
    detailTextLabelCell.textColor = [UIColor lightGrayColor];
    detailTextLabelCell.backgroundColor = [UIColor clearColor];
    detailTextLabelCell.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleLeftMargin;
    detailTextLabelCell.adjustsFontSizeToFitWidth = YES;
    detailTextLabelCell.numberOfLines = 2;
    detailTextLabelCell.textAlignment = NSTextAlignmentRight;
    
    [self.contentView addSubview:detailTextLabelCell];
}

@end
