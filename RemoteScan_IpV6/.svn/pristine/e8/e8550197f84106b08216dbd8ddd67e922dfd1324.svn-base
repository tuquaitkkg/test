
#import "AttachmentDataCell.h"
#import "CommonUtil.h"
#import "Define.h"
#import "CommonManager.h"
#import "TempAttachmentFile.h"

@implementation AttachmentDataCell

//
// アクセサメソッドの自動合成(ゲッターとセッターの役割)
//
@synthesize nameLabel;								// ファイル名称
@synthesize dateLabel;								// 作成日付
@synthesize fsizeLabel;								// ファイルサイズ
@synthesize imgView;								// Attachment ファイル名称
@synthesize selectImgView;

#define IMAGE_X		2
#define IMAGE_Y		2
#define IMAGE_W		65

#define S_NAME_X	75
#define S_NAME_Y	20
#define S_NAME_W	200
#define S_NAME_H	25

//#define DATE_X		75
//#define DATE_Y		35
//#define DATE_W		130
//#define DATE_H		20

//#define SIZE_X		200
//#define SIZE_Y		35
//#define SIZE_W		80
//#define SIZE_H		20

#pragma mark -
#pragma mark AttachmentDataCell Manager

//
// 状態と再利用識別子でテーブルセルを初期化して返す。
//
//
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier])
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
        //        [nameLabel setFont:[UIFont systemFontOfSize:[UIFont smallSystemFontSize]]];
        //        [nameLabel setTextColor:[UIColor grayColor]];
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
        
        //
        // selectImgView:チェックボックス
        //
        CGRect selectImageFrame = CGRectMake(-33 + 7, (0.5 * ((UITableView *)self.superview).rowHeight) - (0.5 * 24), 24, 90);
        selectImgView = [[UIImageView alloc] initWithFrame:selectImageFrame];
        selectImgView.tag = 0;
        selectImgView.contentMode = UIViewContentModeScaleAspectFit;
        
        [self.contentView addSubview:selectImgView];
        
    }
    return self;
}

//- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
//    [super setSelected:selected animated:animated];
//}

- (void)setModel:(AttachmentData *)aAttachmentData hasDisclosure:(BOOL)newDisclosure
{
    
	self.accessoryType = newDisclosure ? TABLE_CELL_ACCESSORY : UITableViewCellAccessoryNone;
    
	//
	// セット
	//
    if(aAttachmentData.isDirectory)
    {
        // "DIR-"を取り除いて表示する
        nameLabel.text      = [aAttachmentData.fname substringFromIndex:4];
        nameLabel.frame     = (CGRect){nameLabel.frame.origin.x, 0, nameLabel.frame.size.width, N_HEIGHT_SEL_FILE};
        
        // 日付とファイルサイズ非表示
        dateLabel.hidden = fsizeLabel.hidden = YES;
    }else
    {
        nameLabel.text		= aAttachmentData.fname;				// Attachment ファイル名称をセット
        nameLabel.frame     = (CGRect){S_NAME_X, S_NAME_Y, nameLabel.frame.size.width, S_NAME_H};
        dateLabel.text		= aAttachmentData.crdate;				// 作成日付をセット
        fsizeLabel.text		= [aAttachmentData fileSizeAbout];	// ファイルサイズをセット
        
        // 日付とファイルサイズ表示
        dateLabel.hidden = fsizeLabel.hidden = NO;
    }
    //
	// 縮小イメージをセット
	//
    NSString	*imagePath;
//    NSString    *oldImagePath;
    NSString    *baseDir;
    NSString    *attachmentFilePath;

    if(aAttachmentData.fpath == nil)
    {
        baseDir = [CommonUtil tmpAttachmentDir];
    }
    else
    {
        baseDir = aAttachmentData.fpath;
    }
    attachmentFilePath = [baseDir stringByAppendingPathComponent:aAttachmentData.fname];
    TempAttachmentFile *tempAttachmentFile = [[TempAttachmentFile alloc] initWithFilePath:attachmentFilePath];
    imagePath = tempAttachmentFile.thumbnailFilePath;

    //	imgView.backgroundColor = [UIColor colorWithRed:0.6 green:0.6 blue:1.0 alpha:1.0];
    
    // サムネイルファイル存在確認
    UIImage* icon = [UIImage imageWithContentsOfFile: imagePath];
    if(aAttachmentData.isDirectory)
    {
        // ディレクトリならアイコンを表示
        if([CommonUtil directoryCheck:aAttachmentData.fpath name:aAttachmentData.fname])
        {
            [imgView setImage:[UIImage imageNamed:S_ICON_DIR]];
        }
        
    }
    else if(icon != nil)
    {
        [imgView setImage:[UIImage imageWithContentsOfFile: imagePath]];
    }
    // 存在しない場合はデフォルトのサムネイルを表示
    else if([CommonUtil wordExtensionCheck:aAttachmentData.fname])
    {
        [imgView setImage:[UIImage imageNamed: S_ICON_WORD]];
    }
    else if([CommonUtil excelExtensionCheck:aAttachmentData.fname])
    {
        [imgView setImage:[UIImage imageNamed: S_ICON_EXCEL]];
    }
    else if([CommonUtil powerpointExtensionCheck:aAttachmentData.fname])
    {
        [imgView setImage:[UIImage imageNamed: S_ICON_POWERPOINT]];
    }
    else if([CommonUtil pdfExtensionCheck:aAttachmentData.fname])
    {
        [imgView setImage:[UIImage imageNamed: S_ICON_PDF]];
    }
    else if([CommonUtil jpegExtensionCheck:aAttachmentData.fname])
    {
        [imgView setImage:[UIImage imageNamed: S_ICON_JPG]];
    }
    else if([CommonUtil tiffExtensionCheck:aAttachmentData.fname])
    {
        [imgView setImage:[UIImage imageNamed: S_ICON_TIFF]];
    }
    else if([CommonUtil pngExtensionCheck:aAttachmentData.fname])
    {
        [imgView setImage:[UIImage imageNamed: S_ICON_PNG]];
    }
    else
    {
        [imgView setImage:[UIImage imageNamed:S_THUMBNAIL_BROKEN]];
    }

    // 不要だと思われるため、ここからコメントにしておく -- start
//    else
//    {
//        // 必要かどうか判断できないため、直前で取得するように変更しておく
//        oldImagePath = [baseDir stringByAppendingPathComponent:[CommonUtil oldThumbnailPath:aAttachmentData.fname]];
//
//        if([[NSFileManager defaultManager] fileExistsAtPath:oldImagePath])
//        {
//            // 旧仕様の縮小画像が存在する場合、アイコンを作成し直す
//            CommonManager* commanager = [[CommonManager alloc]init];
//            BOOL bCreate = [commanager createThumbnail:baseDir filename:aAttachmentData.fname page:1 width:100 height:120 saveDir:baseDir isCache:NO];
//            
//            // 再度、読み込み直す
//            if(bCreate){
//                icon = [UIImage imageWithContentsOfFile: imagePath];
//            }
//        }
//        
//        if(icon != nil)
//        {
//            // 旧仕様に対応完了
//            [imgView setImage:[UIImage imageWithContentsOfFile: imagePath]];
//            
//            // 旧仕様のアイコンファイルを削除するか判定
//            BOOL bDelete = YES;
//            NSError* error = nil;
//            NSFileManager* fm = [NSFileManager defaultManager];
//            NSArray* fileList = [fm contentsOfDirectoryAtPath:baseDir error:&error];
//            if(error){
//                // ファイル一覧取得エラー
//                DLog(@"ファイル一覧取得エラー:%@", error);
//                bDelete = NO;
//            }else{
//                // チェックする拡張子を含まないファイル名を取得
//                NSString* checkFileName = [[oldImagePath lastPathComponent] stringByDeletingPathExtension];
//                for(NSString* dirFileName in fileList) {
//                    // 拡張子を含まないファイル名でチェック
//                    if([[dirFileName stringByDeletingPathExtension] isEqualToString:checkFileName]){
//                        // まだ旧仕様ファイルを参照しているかチェック
//                        NSString* newIconPath = [baseDir stringByAppendingPathComponent:[CommonUtil thumbnailPath:dirFileName]];
//                        if(![fm fileExistsAtPath:newIconPath]){
//                            // まだ参照しているファイルがあるので削除しない
//                            bDelete = NO;
//                            break;
//                        }
//                    }
//                }
//            }
//            
//            if(bDelete){
//                [fm removeItemAtPath:oldImagePath error:&error];
//                if(error){
//                    // 削除エラー
//                    DLog(@"削除エラー:%@", error);
//                }
//            }
//        }
//        else
//        {
//            // 存在しない場合はデフォルトのサムネイルを表示
//            if([CommonUtil pdfExtensionCheck:aAttachmentData.fname])
//            {
//                [imgView setImage:[UIImage imageNamed: S_ICON_PDF]];
//            }
//            else if([CommonUtil jpegExtensionCheck:aAttachmentData.fname])
//            {
//                [imgView setImage:[UIImage imageNamed: S_ICON_JPG]];
//            }
//            else if([CommonUtil tiffExtensionCheck:aAttachmentData.fname])
//            {
//                [imgView setImage:[UIImage imageNamed: S_ICON_TIFF]];
//            }
//            else if([CommonUtil pngExtensionCheck:aAttachmentData.fname])
//            {
//                [imgView setImage:[UIImage imageNamed: S_ICON_PNG]];
//            }
//            else if([CommonUtil wordExtensionCheck:aAttachmentData.fname])
//            {
//                [imgView setImage:[UIImage imageNamed: S_ICON_WORD]];
//            }
//            else if([CommonUtil excelExtensionCheck:aAttachmentData.fname])
//            {
//                [imgView setImage:[UIImage imageNamed: S_ICON_EXCEL]];
//            }
//            else if([CommonUtil powerpointExtensionCheck:aAttachmentData.fname])
//            {
//                [imgView setImage:[UIImage imageNamed: S_ICON_POWERPOINT]];
//            }
//            else
//            {
//                [imgView setImage:[UIImage imageNamed:S_THUMBNAIL_BROKEN]];
//            }
//        }
//    }
    // 不要だと思われるため、ここまでコメントにしておく -- end
    
//    if (selectImgView.tag)
//    {
//        [selectImgView setImage:[UIImage imageNamed:S_ICON_SELECTFILE]];
//    }
//    else
//    {
//        [selectImgView setImage:[UIImage imageNamed:S_ICON_NON_SELECTFILE]];
//    }
    if (self.isEditing)
    {
        if (selectImgView.tag == 0)
        {
            [selectImgView setImage:[UIImage imageNamed:S_ICON_NON_SELECTFILE]];
        }
    }
    else
    {
        if (selectImgView.tag)
        {
            [selectImgView setImage:[UIImage imageNamed:S_ICON_SELECTFILE]];
        }
        else
        {
            [selectImgView setImage:[UIImage imageNamed:S_ICON_NON_SELECTFILE]];
        }
        
    }

    /*// サムネイル
     NSString* pstrImagePath = [m_pScanMgr.baseDir stringByAppendingPathComponent:[CommonUtil thumbnailPath:scanData.fname]];
     cell.imageView.image = [UIImage imageWithContentsOfFile: pstrImagePath];
     */
    
}

- (void)setImageModel
{
    
    if (selectImgView.tag)
    {
        [selectImgView setImage:[UIImage imageNamed:S_ICON_SELECTFILE]];
    }
    else
    {
        [selectImgView setImage:[UIImage imageNamed:S_ICON_NON_SELECTFILE]];
    }
}

// 編集モード時のインジケーターの表示領域を設ける
- (void)layoutSubviews {
	[UIView beginAnimations:nil context:nil];
	[UIView setAnimationBeginsFromCurrentState:YES];
    
	[super layoutSubviews];
    
    if (self.isEditing) {
		CGRect contentFrame    = self.contentView.frame;
		contentFrame.origin.x  = 33;//0;//EDITING_HORIZONTAL_OFFSET;
		self.contentView.frame = contentFrame;
	} else {
		CGRect contentFrame    = self.contentView.frame;
		contentFrame.origin.x  = 0;
		self.contentView.frame = contentFrame;
	}
    
	[UIView commitAnimations];
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
