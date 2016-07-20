
#import "SelectMailFolderCell.h"
#import "Define.h"

@implementation SelectMailFolderCell

//
// アクセサメソッドの自動合成(ゲッターとセッターの役割)
//
@synthesize nameLabel;								// ファイル名称
@synthesize imgView;								// フォルダーアイコン

#define IMAGE_X		2
#define IMAGE_Y		2
#define IMAGE_W		65

#define S_NAME_X	75
#define S_NAME_Y	10
#define S_NAME_W	200
#define S_NAME_H	25

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier])
	{        
		//
        // fname:表示名
		//
        CGRect nameFrame = CGRectMake(S_NAME_X, S_NAME_Y, S_NAME_W, S_NAME_H);
        nameLabel = [[UILabel alloc] initWithFrame:nameFrame ];
        nameLabel.backgroundColor = [UIColor clearColor];
        nameLabel.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleRightMargin;
        nameLabel.lineBreakMode = NSLineBreakByTruncatingMiddle;
		nameLabel.minimumScaleFactor = [UIFont systemFontSize] / nameLabel.font.pointSize;
        [nameLabel setAdjustsFontSizeToFitWidth:TRUE];
        [self.contentView addSubview:nameLabel];
        
		//
        // imgView:サムネイル
		//
        CGRect imageFrame = CGRectMake(IMAGE_X, IMAGE_Y, IMAGE_W, N_HEIGHT_SEL_FILE - 5);
		imgView = [[UIImageView alloc] initWithFrame:imageFrame];
        imgView.contentMode = UIViewContentModeScaleAspectFit;
		
		[self.contentView addSubview:imgView];
        
    }
    return self;

}

- (void)setModel:(NSString *)aFileName hasDisclosure:(BOOL)newDisclosure
{
    self.accessoryType = newDisclosure ? TABLE_CELL_ACCESSORY : UITableViewCellAccessoryNone;

    // フォルダー名を表示する
    nameLabel.text      = aFileName;
    nameLabel.frame     = (CGRect){nameLabel.frame.origin.x, 0, nameLabel.frame.size.width, N_HEIGHT_SEL_FILE};
    
    // フォルダーアイコンを表示する
    [imgView setImage:[UIImage imageNamed:S_ICON_DIR]];
}

- (void)setImageModel
{
    
}

//
//
//
- (void)dealloc
{
    if(self.imgView != nil)
    {
        self.imgView.image = nil;
    }
    
}


@end
