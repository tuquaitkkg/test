#import "CommonManager.h"
#import "TempDataCell.h"
#import "CommonUtil.h"
#import "Define.h"

@implementation TempDataCell

//
// アクセサメソッドの自動合成(ゲッターとセッターの役割)
//
@synthesize nameLabel;								// ファイル名称
@synthesize imgView;								// Temp ファイル名称

#define IMAGE_X		4
#define IMAGE_Y		2
#define IMAGE_W		60

#define S_NAME_X	90
#define S_NAME_Y	10
#define S_NAME_W	200
#define S_NAME_H	40

#define DATE_X		90
#define DATE_Y		30
#define DATE_W		130
#define DATE_H		20

#define SIZE_X		90
#define SIZE_Y		50
#define SIZE_W		80
#define SIZE_H		20

#pragma mark -
#pragma mark ScanDataCell Manager

//
// 状態と再利用識別子でテーブルセルを初期化して返す。
//
//
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
	{
		// ハイライトなし
        //		self.selectionStyle = UITableViewCellSelectionStyleNone;
        
		//
        // fname:表示名
		//
        CGRect nameFrame = CGRectMake(S_NAME_X, S_NAME_Y, S_NAME_W, S_NAME_H);
        nameLabel = [[UILabel alloc] initWithFrame:nameFrame ];
        nameLabel.backgroundColor = [UIColor clearColor];
        nameLabel.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleRightMargin;
        nameLabel.lineBreakMode = NSLineBreakByTruncatingMiddle;
        //        [nameLabel setFont:[UIFont systemFontOfSize:[UIFont smallSystemFontSize]]];
        //        [nameLabel setTextColor:[UIColor grayColor]];
		nameLabel.minimumScaleFactor = ([UIFont systemFontSize] / nameLabel.font.pointSize);
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

//- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
//    [super setSelected:selected animated:animated];
//}

- (void)setModel:(TempData *)aTempData hasDisclosure:(BOOL)newDisclosure
{
    
	self.accessoryType = newDisclosure ? TABLE_CELL_ACCESSORY : UITableViewCellAccessoryNone;
    
	//
	// セット
	//
	nameLabel.text		= aTempData.fname;				// Temp ファイル名称をセット
    
    
	//
	// 縮小イメージをセット
	//
	//NSArray		*docFolders = NSSearchPathForDirectoriesInDomains (NSDocumentDirectory, NSUserDomainMask, YES ); 
	NSString	*baseDir	= [CommonUtil tmpDir];
    NSString    *imagePath  = [baseDir stringByAppendingPathComponent:[CommonUtil thumbnailPath:aTempData.fname]];
    //	imgView.backgroundColor = [UIColor colorWithRed:0.6 green:0.6 blue:1.0 alpha:1.0];
    
    // サムネイルファイル存在確認
    UIImage* icon = [UIImage imageWithContentsOfFile: imagePath];
    if(icon != nil)
    {
        [imgView setImage:[UIImage imageWithContentsOfFile: imagePath]];
    }
    else
    {
        // 存在しない場合はデフォルトのサムネイルを表示
        if([CommonUtil pdfExtensionCheck:aTempData.fname])
        {
            [imgView setImage:[UIImage imageNamed: S_ICON_PDF]];
        }
        else if([CommonUtil jpegExtensionCheck:aTempData.fname])
        {
            [imgView setImage:[UIImage imageNamed: S_ICON_JPG]];
        }
        else if([CommonUtil tiffExtensionCheck:aTempData.fname])
        {
            [imgView setImage:[UIImage imageNamed: S_ICON_TIFF]];
        }
        else if([CommonUtil pngExtensionCheck:aTempData.fname])
        {
            [imgView setImage:[UIImage imageNamed: S_ICON_PNG]];
        }
        else if([CommonUtil wordExtensionCheck:aTempData.fname])
        {
            [imgView setImage:[UIImage imageNamed: S_ICON_WORD]];
        }
        else if([CommonUtil excelExtensionCheck:aTempData.fname])
        {
            [imgView setImage:[UIImage imageNamed: S_ICON_EXCEL]];
        }
        else if([CommonUtil powerpointExtensionCheck:aTempData.fname])
        {
            [imgView setImage:[UIImage imageNamed: S_ICON_POWERPOINT]];
        }
        else
        {
            [imgView setImage:[UIImage imageNamed:S_THUMBNAIL_BROKEN]];
        }
    }
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

//
//
//
@implementation FileDataCell

//
// アクセサメソッドの自動合成(ゲッターとセッターの役割)
//
@synthesize nameLabelCell;							// 表示名称

#define NAME_X 20
#define NAME_Y 5
#define NAME_W 100
#define NAME_H 25

#define NAMEVAL_X 130
#define NAMEVAL_Y 5
#define NAMEVAL_W 185
#define NAMEVAL_H 25

//
//
//
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) 
	{
		// ハイライトなし
		self.selectionStyle = UITableViewCellSelectionStyleNone;
		
		//
        // 表示名称
		//
        CGRect nameFrame = CGRectMake(NAME_X, NAME_Y, NAME_W, NAME_H);
        nameLabelCell = [[UILabel alloc] initWithFrame:nameFrame];
        nameLabelCell.backgroundColor = [UIColor clearColor];
		[nameLabelCell setFont:[UIFont systemFontOfSize:14]];
        [nameLabelCell setAdjustsFontSizeToFitWidth:TRUE];
        [self.contentView addSubview:nameLabelCell];
		
    }
	
    return self;
}

//
// アプリケーションの終了直前に呼ばれるメソッド
//

@end
