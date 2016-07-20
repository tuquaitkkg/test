
#import "ELCAlbumCell.h"

@implementation ELCAlbumCell

//
// アクセサメソッドの自動合成(ゲッターとセッターの役割)
//
@synthesize albumNameLabel; // アルバム名
@synthesize albumImageView; // アルバムイメージ

#define IMAGE_X		2
#define IMAGE_Y		2
#define IMAGE_W		53
#define IMAGE_H		53

#define S_NAME_X	75
#define S_NAME_Y	16
#define S_NAME_W	225
#define S_NAME_H	25

#pragma mark -
#pragma mark ELCAlbumCell Manager

//
// 状態と再利用識別子でテーブルセルを初期化して返す。
//
//
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier])
    {
        //
        // albumNameLabel:アルバム名
        //
        CGRect nameFrame = CGRectMake(S_NAME_X, S_NAME_Y, S_NAME_W, S_NAME_H);
        albumNameLabel = [[UILabel alloc] initWithFrame:nameFrame ];
        albumNameLabel.backgroundColor = [UIColor clearColor];
        albumNameLabel.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleRightMargin;
        albumNameLabel.lineBreakMode = NSLineBreakByTruncatingMiddle;
        albumNameLabel.minimumScaleFactor = [UIFont systemFontSize] / albumNameLabel.font.pointSize;
        [albumNameLabel setAdjustsFontSizeToFitWidth:TRUE];
        [self.contentView addSubview:albumNameLabel];
        
        //
        // albumImageView:アルバムイメージ
        //
        CGRect imageFrame = CGRectMake(IMAGE_X, IMAGE_Y, IMAGE_W, IMAGE_H);
        albumImageView = [[UIImageView alloc] initWithFrame:imageFrame];
        albumImageView.contentMode = UIViewContentModeScaleAspectFit;
        
        [self.contentView addSubview:albumImageView];
        
    }
    return self;
}


- (void)dealloc
{
    if(self.albumImageView != nil)
    {
        self.albumImageView.image = nil;
    }
    
}

@end
