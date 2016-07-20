
#import "PrinterDetailDataCell.h"
#import "Define.h"

@implementation PrinterDetailDataCell

@synthesize CellTitle = m_plblCellTitle;
@synthesize CellValue = m_plblCellValue;
@synthesize EditCellValue = m_pEditCellValue;
@synthesize IsEditCell = m_bEditCell;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier isEditCell:(BOOL)isEditCell
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        // ハイライトなし
		self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        // Cellのタイトル
        CGRect rectTitle = CGRectMake(MFP_SETTING_DETAIL_TITLE_X, MFP_SETTING_DETAIL_TITLE_Y, MFP_SETTING_DETAIL_TITLE_W, MFP_SETTING_DETAIL_TITLE_H);
        if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
        {
            // iPad用
            rectTitle = CGRectMake(MFP_SETTING_DETAIL_TITLE_X_IPAD, MFP_SETTING_DETAIL_TITLE_Y, MFP_SETTING_DETAIL_TITLE_W_IPAD, MFP_SETTING_DETAIL_TITLE_H);
        }
        m_plblCellTitle = [[UILabel alloc] initWithFrame:rectTitle];
        m_plblCellTitle.backgroundColor = [UIColor clearColor];
        [m_plblCellTitle setFont:[UIFont systemFontOfSize:14]];
        [m_plblCellTitle setAdjustsFontSizeToFitWidth:TRUE];
        [self.contentView addSubview:m_plblCellTitle];

        m_bEditCell = isEditCell;
        
        float iOSVersion = [[[UIDevice currentDevice] systemVersion] floatValue];

		if (isEditCell)
        {
            // Cellの値(入力)
            CGRect rectValue = CGRectMake(MFP_SETTING_DETAIL_VAL_X, MFP_SETTING_DETAIL_VAL_Y, MFP_SETTING_DETAIL_VAL_W, MFP_SETTING_DETAIL_VAL_H);
            if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
            {
                // iPad用
                rectValue = CGRectMake(MFP_SETTING_DETAIL_VAL_X_IPAD, MFP_SETTING_DETAIL_VAL_Y, MFP_SETTING_DETAIL_VAL_W_IPAD, MFP_SETTING_DETAIL_VAL_H);
            }
            m_pEditCellValue = [[EditableCell alloc] initWithFrame:rectValue];
            m_pEditCellValue.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleRightMargin;
            m_pEditCellValue.backgroundColor = [UIColor clearColor];
            [m_pEditCellValue.textField setFont:[UIFont systemFontOfSize:14]];
           
            if ([S_LANG isEqualToString:S_LANG_JA])
            {
                // 国内版の場合、表示文字を小さくする
                m_pEditCellValue.textField.adjustsFontSizeToFitWidth = YES;
                m_pEditCellValue.textField.minimumFontSize = 7;
            }
            [self.contentView addSubview:m_pEditCellValue];
            
            // テキストフィールドとラベルの位置を調整
            rectTitle = m_plblCellTitle.frame;
            rectValue = m_pEditCellValue.textField.frame;
            
            if(iOSVersion >= 7.0 || UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
            {
                // iOS7以降 もしくはiPad
                rectValue.origin.x = self.contentView.frame.size.width - (rectValue.size.width + DISTANCE_2);
                rectTitle.origin.x = DISTANCE_2;
                rectTitle.size.width = rectValue.origin.x - (rectTitle.origin.x + DISTANCE_1);
            }else{
                // iOS6以前
                rectValue.origin.x = self.contentView.frame.size.width - (rectValue.size.width + DISTANCE_1);
                rectTitle.origin.x = DISTANCE_1;
                rectTitle.size.width = rectValue.origin.x - (rectTitle.origin.x + DISTANCE_1);
            }
            
            m_plblCellTitle.frame = rectTitle;
            m_pEditCellValue.textField.frame = rectValue;

        }
        else
        {
            // Cellの値
            CGRect rectValue = CGRectMake(MFP_SETTING_DETAIL_VAL_X, MFP_SETTING_DETAIL_VAL_Y, MFP_SETTING_DETAIL_VAL_W, MFP_SETTING_DETAIL_VAL_H);
            if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
            {
                // iPad用
                rectValue = CGRectMake(MFP_SETTING_DETAIL_VAL_X_IPAD, MFP_SETTING_DETAIL_VAL_Y, MFP_SETTING_DETAIL_VAL_W_IPAD, MFP_SETTING_DETAIL_VAL_H);
            }
            m_plblCellValue = [[UILabel alloc] initWithFrame:rectValue];
            m_plblCellValue.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleRightMargin;
            m_plblCellValue.backgroundColor = [UIColor clearColor];
            [m_plblCellValue setFont:[UIFont systemFontOfSize:14]];
            
            if ([S_LANG isEqualToString:S_LANG_JA])
            {
                // 国内版の場合、表示文字を小さくする
                m_plblCellValue.adjustsFontSizeToFitWidth = YES;
                m_plblCellValue.minimumScaleFactor = 7 / m_plblCellValue.font.pointSize;
            }
            //m_plblCellValue.lineBreakMode = NSLineBreakByTruncatingMiddle;
            [self.contentView addSubview:m_plblCellValue];            
            // テキストフィールドとラベルの位置を調整
            rectTitle = m_plblCellTitle.frame;
            rectValue = m_plblCellValue.frame;
            
            if(iOSVersion >= 7.0 || UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
            {
                // iOS7以降 もしくはiPad
                rectValue.origin.x = self.contentView.frame.size.width - (rectValue.size.width + DISTANCE_2);
                rectTitle.origin.x = DISTANCE_2;
                rectTitle.size.width = rectValue.origin.x - (rectTitle.origin.x + DISTANCE_1);
            }else{
                // iOS6以前
                rectValue.origin.x = self.contentView.frame.size.width - (rectValue.size.width + DISTANCE_1);
                rectTitle.origin.x = DISTANCE_1;
                rectTitle.size.width = rectValue.origin.x - (rectTitle.origin.x + DISTANCE_1);
            }
            
            m_plblCellTitle.frame = rectTitle;
            m_plblCellValue.frame = rectValue;

        }
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
	
    // Configure the view for the selected state
}


// プリンタ情報設定
- (void)SetCellPrinterInfo:(NSString*)pstrTitle
                     value:(NSString*)pstrValue
             hasDisclosure:(BOOL)newDisclosure
                IsEditCell:(BOOL)bEditCell
              keyboardType:(UIKeyboardType)pKeyboardType
{
    self.accessoryType = newDisclosure ? TABLE_CELL_ACCESSORY : UITableViewCellAccessoryNone;

    // Cellのタイトル
    m_plblCellTitle.text = pstrTitle;
    
    if (![S_LANG isEqualToString:S_LANG_EN]) {
        // 自動調整サイズを取得
        CGFloat actualFontSize;
        [m_plblCellTitle.text 
         sizeWithFont:m_plblCellTitle.font
         minFontSize:(m_plblCellTitle.minimumScaleFactor * m_plblCellTitle.font.pointSize)
         actualFontSize:&actualFontSize 
         forWidth:m_plblCellTitle.bounds.size.width 
         lineBreakMode:m_plblCellTitle.lineBreakMode];
        
        // 自動調整したフォントサイズが10以下なら、二段表示するか判定を行う
        if(actualFontSize < 11)
        {
            int iFontSize = [self changeFontSize:m_plblCellTitle.text];
            if (iFontSize != -1)
            {
                m_plblCellTitle.lineBreakMode = NSLineBreakByWordWrapping;
                m_plblCellTitle.numberOfLines = 2;
                [m_plblCellTitle setFont:[UIFont systemFontOfSize:iFontSize]];
                // サイズ調整
                CGRect frame =  m_plblCellTitle.frame;
                frame.size.height = 36;
                m_plblCellTitle.frame = frame;
            }
            
        }
    }
    else
    {
        //英語表示時
        m_plblCellTitle.lineBreakMode = NSLineBreakByWordWrapping;
        m_plblCellTitle.numberOfLines = 2;
        // サイズ調整
        CGRect frame =  m_plblCellTitle.frame;
        frame.size.height = 36;
        m_plblCellTitle.frame = frame;        
    }

    if (bEditCell)
    {
        // Cellの値(入力)
        m_pEditCellValue.textField.text = pstrValue;
        //m_pEditCellValue.textField.keyboardAppearance = UIKeyboardAppearanceAlert;
        m_pEditCellValue.textField.keyboardAppearance = UIKeyboardAppearanceLight;
        m_pEditCellValue.textField.keyboardType = pKeyboardType;
        if ([S_LANG isEqualToString:S_LANG_JA])
        {
            // 国内版の場合、表示文字を小さくする
            m_pEditCellValue.textField.adjustsFontSizeToFitWidth = YES;
            m_pEditCellValue.textField.minimumFontSize = 7;
        }
    }
    else
    {
        // Cellの値
        m_plblCellValue.text = pstrValue;        
    }
}

// テーブルのフォントサイズが小さい場合は二段表示にするか判定する
- (int)changeFontSize:(NSString*)lblNameText
{
    int iChangeFontSize = -1;
    for(int uFontSize = 14; uFontSize > 0 ; uFontSize--)
    {
        CGSize boundingSize = CGSizeMake(MFP_SETTING_DETAIL_TITLE_W, MFP_SETTING_DETAIL_TITLE_H*2);
        if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
        {
            // iPad用
            boundingSize = CGSizeMake(MFP_SETTING_DETAIL_TITLE_W_IPAD, MFP_SETTING_DETAIL_TITLE_H*2);
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

@end
