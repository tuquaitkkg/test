
#import <UIKit/UIKit.h>
#import "PrinterData.h"


@interface PrinterDataCell : UITableViewCell
{
    UILabel* m_plblPrinterName;         // プリンタ表示名称
    UIImageView* m_pIconImageView;      // アイコン
    UILabel* m_plblPrinterIpAddress;    // IPアドレス
}

@property (nonatomic, strong) UILabel* PrinterName;
@property (nonatomic, strong) UIImageView* IconImageView;
@property (nonatomic, strong) UILabel* PrinterIpAddress;
@property (nonatomic) BOOL isPrintServer;
// プリンタ情報設定
- (void)SetCellPrinterInfo:(PrinterData*)printerData
             hasDisclosure:(BOOL)newDisclosure;

@end
