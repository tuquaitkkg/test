
#import "MailDataCell.h"
#import "Define.h"

@implementation MailDataCell

//
// アクセサメソッドの自動合成(ゲッターとセッターの役割)
//
@synthesize fromLabel;								// 差出人
@synthesize dateLabel;								// 受信日付
@synthesize subjectLabel;							// 件名
@synthesize imgView;								// アイコン

#define IMAGE_X		2
#define IMAGE_Y		2
#define IMAGE_W		65

#define FROM_X	75
#define FROM_Y	25
#define FROM_W	240
#define FROM_H	20

#define DATE_X		75
#define DATE_Y		45
#define DATE_W		240
#define DATE_H		20

#define SUBJECT_X		75
#define SUBJECT_Y		5
#define SUBJECT_W		240
#define SUBJECT_H		20

#pragma mark -
#pragma mark ScanDataCell Manager

//
// 状態と再利用識別子でテーブルセルを初期化して返す。
//
//
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier])
	{
		//
        // from: 差出人
		//
        CGRect fromFrame = CGRectMake(FROM_X, FROM_Y, FROM_W, FROM_H);
        fromLabel = [[UILabel alloc] initWithFrame:fromFrame ];
        fromLabel.backgroundColor = [UIColor clearColor];
        fromLabel.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleRightMargin;
        fromLabel.lineBreakMode = NSLineBreakByTruncatingMiddle;
		fromLabel.minimumScaleFactor = [UIFont smallSystemFontSize] / fromLabel.font.pointSize;
        [fromLabel setAdjustsFontSizeToFitWidth:TRUE];
 		[fromLabel setFont:[UIFont systemFontOfSize:[UIFont smallSystemFontSize]]];
		[fromLabel setTextColor:[UIColor grayColor]];
        [self.contentView addSubview:fromLabel];
        
		//
        // date:作成日付
		//
        CGRect dateFrame = CGRectMake(DATE_X, DATE_Y, DATE_W, DATE_H);
        dateLabel = [[UILabel alloc] initWithFrame:dateFrame];
        dateLabel.backgroundColor = [UIColor clearColor];
        dateLabel.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleRightMargin;
        dateLabel.lineBreakMode = NSLineBreakByTruncatingMiddle;
        dateLabel.minimumScaleFactor = [UIFont smallSystemFontSize] / dateLabel.font.pointSize;
        [dateLabel setAdjustsFontSizeToFitWidth:TRUE];
		[dateLabel setFont:[UIFont systemFontOfSize:[UIFont smallSystemFontSize]]];
		[dateLabel setTextColor:[UIColor grayColor]];
        [self.contentView addSubview:dateLabel];
        
		//
        // subject:件名
		//
        CGRect subjectFrame =  CGRectMake(SUBJECT_X, SUBJECT_Y, SUBJECT_W, SUBJECT_H);
        subjectLabel = [[UILabel alloc] initWithFrame:subjectFrame];
        subjectLabel.backgroundColor = [UIColor clearColor];
        subjectLabel.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleRightMargin;
        subjectLabel.lineBreakMode = NSLineBreakByTruncatingMiddle;
        subjectLabel.minimumScaleFactor = [UIFont smallSystemFontSize] / subjectLabel.font.pointSize;
        [subjectLabel setAdjustsFontSizeToFitWidth:TRUE];
		[subjectLabel setFont:[UIFont systemFontOfSize:[UIFont systemFontSize]]];
        [self.contentView addSubview:subjectLabel];
		
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

- (void)setModel:(CTCoreMessage*)aCoreMessage hasDisclosure:(BOOL)newDisclosure
{
    
	self.accessoryType = newDisclosure ? TABLE_CELL_ACCESSORY : UITableViewCellAccessoryNone;
   
    // 初期化
    NSString* dateText = @"";
    NSString* fromText = @"";
    NSString* subjectText = @"";
    
    // 日付
    if([aCoreMessage senderDate] == nil)
    {
        //　受信日時 nilの場合に落ちる問題に対応
        dateText = @"";
        
    }else{
        // 日付のフォーマット指定
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setLocale:[NSLocale systemLocale]];        // 12時間表示にならないように
        [formatter setTimeZone:[NSTimeZone systemTimeZone]];  // localeを再設定する。
        [formatter setDateFormat:@"yyyy/MM/dd HH:mm:ss"];
        
        //　受信日時
        dateText = [dateText stringByAppendingString:[NSString stringWithString:[formatter stringFromDate:[aCoreMessage senderDate]]]];
    }
    [dateLabel setText:dateText];

    // 差出人
    CTCoreAddress* aFromAddress = [[aCoreMessage from] anyObject]; //first one
    fromText = [fromText stringByAppendingFormat: @"%@<%@>", [aFromAddress name], [aFromAddress email]];
    [fromLabel setText: fromText]; // 差出人をセット

    //　件名
    if([aCoreMessage subject] == nil)
    {
        subjectText = @"";
    }else
    {
        subjectText = [subjectText stringByAppendingString:[aCoreMessage subject]];
    }
    [subjectLabel setText:subjectText];	// 件名をセット
    
    // Image
    [imgView setImage:[UIImage imageNamed:S_ICON_MAIL]];
    
}

- (void)setImageModel
{
    
    //    if (selectImgView.tag)
    //    {
    //        [selectImgView setImage:[UIImage imageNamed:S_ICON_SELECTFILE]];
    //    }
    //    else
    //    {
    //        [selectImgView setImage:[UIImage imageNamed:S_ICON_NON_SELECTFILE]];
    //    }
}


- (void)dealloc
{
    if(self.imgView != nil)
    {
        self.imgView.image = nil;
    }
    
}

@end
