
#import <UIKit/UIKit.h>
#import "ELCImagePickerController.h"
#import "ELCAlbumPickerController.h"
#import "MultiPrintPictViewController.h"

@interface PrintSelectTypeViewController : UITableViewController<UINavigationControllerDelegate, UIImagePickerControllerDelegate,ELCImagePickerControllerDelegate,MultiPrintPictViewControllerDelegate,PrintPictViewControllerDelegate>
{
    
    int nFolderCount;
    NSString* pathDir;
    
    PrinterDataManager* m_pPrinterMgr;      // PrinterDataManagerクラス

}

// 画面遷移
- (void)MoveView:(NSIndexPath *)nIndexPath;

// 位置情報の状態を確認する
//-(void)LocationInformationCheck:(NSDictionary *)info;
// 印刷画面に遷移
-(void)MovePrintPictView:(NSDictionary *)printinfo;


@end
