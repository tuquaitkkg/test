
#import "PrinterDataCell.h"
#import "Define.h"

@implementation PrinterDataCell

@synthesize PrinterName = m_plblPrinterName;
@synthesize IconImageView = m_pIconImageView;
@synthesize PrinterIpAddress = m_plblPrinterIpAddress;


- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        // 表示名称
        CGRect rectName = CGRectMake(MFP_SETTING_NAME_X, MFP_SETTING_NAME_Y, MFP_SETTING_NAME_W, MFP_SETTING_NAME_H);
        m_plblPrinterName = [[UILabel alloc] initWithFrame:rectName];
        m_plblPrinterName.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleRightMargin;
        m_plblPrinterName.backgroundColor = [UIColor clearColor];
        [m_plblPrinterName setAdjustsFontSizeToFitWidth:TRUE];
        if (![S_LANG isEqualToString:S_LANG_JA])
        {
            // 海外版の場合
            m_plblPrinterName.minimumScaleFactor = [UIFont systemFontSize] / m_plblPrinterName.font.pointSize;
        }
        else
        {
            // 国内版の場合、表示文字を小さくする
            m_plblPrinterName.minimumScaleFactor = 7 / m_plblPrinterName.font.pointSize;
        }
        //m_plblPrinterName.lineBreakMode = NSLineBreakByTruncatingMiddle;
        m_plblPrinterName.lineBreakMode = NSLineBreakByTruncatingTail;
        [self.contentView addSubview:m_plblPrinterName];
        
        // IPアドレス
        CGRect rectIpAddress = CGRectMake(MFP_SETTING_IPADDRESS_X, MFP_SETTING_IPADDRESS_Y, MFP_SETTING_IPADDRESS_W, MFP_SETTING_IPADDRESS_H);
        m_plblPrinterIpAddress = [[UILabel alloc] initWithFrame:rectIpAddress];
        m_plblPrinterIpAddress.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleRightMargin;
        m_plblPrinterIpAddress.backgroundColor = [UIColor clearColor];
        m_plblPrinterIpAddress.minimumScaleFactor = [UIFont systemFontSize] / m_plblPrinterIpAddress.font.pointSize;
        [m_plblPrinterIpAddress setAdjustsFontSizeToFitWidth:TRUE];
        [m_plblPrinterIpAddress setFont:[UIFont systemFontOfSize:[UIFont smallSystemFontSize]]];
        [self.contentView addSubview:m_plblPrinterIpAddress];
        
        // アイコン
        CGRect rectImage = CGRectMake(MFP_SETTING_IMAGE_X, MFP_SETTING_IMAGE_Y, MFP_SETTING_IMAGE_W, MFP_SETTING_IMAGE_H);
        m_pIconImageView = [[UIImageView alloc] initWithFrame:rectImage];
        [self.contentView addSubview:m_pIconImageView];
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


// プリンタ情報設定
- (void)SetCellPrinterInfo:(PrinterData*)printerData
             hasDisclosure:(BOOL)newDisclosure
{
    self.accessoryType = newDisclosure ? TABLE_CELL_ACCESSORY : UITableViewCellAccessoryNone;

    // 表示名称
    m_plblPrinterName.text = printerData.getPrinterName;
    
    // IPアドレス
    m_plblPrinterIpAddress.text = printerData.IpAddress;
    
	// アイコン
    if (!self.isPrintServer) {
        // プリンター/スキャナー
        if(printerData.DefaultMFP)
        {
            if(printerData.getAddStatus)
            {
                //選択中のMFP(手動登録アイコン)
                [m_pIconImageView setImage:[UIImage imageNamed:S_ICON_SETTING_DEFAULT_MANUALY]];
            }
            else
            {
                //選択中のMFP(自動登録アイコン)
                [m_pIconImageView setImage:[UIImage imageNamed:S_ICON_SETTING_DEFAULT]];
            }
        }
        else
        {
            if(printerData.getAddStatus)
            {
                //選択中のMFP(手動登録アイコン)
                [m_pIconImageView setImage:[UIImage imageNamed:S_ICON_SETTING_MFPLIST_MANUALY]];
            }
            else
            {
                //選択されていないMFP(自動登録アイコン)
                [m_pIconImageView setImage:[UIImage imageNamed:S_ICON_SETTING_MFPLIST]];
            }
        }
    } else {
        // プリントサーバー
        if(printerData.DefaultMFP)
        {
            //選択中のMFP(手動登録アイコン)
            [m_pIconImageView setImage:[UIImage imageNamed:S_ICON_SETTING_DEFAULT_SERVER]];
        }
        else
        {
            //選択中のMFP(手動登録アイコン)
            [m_pIconImageView setImage:[UIImage imageNamed:S_ICON_SETTING_MFPLIST_SERVER]];
        }
    }
}

@end
