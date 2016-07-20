

#import <UIKit/UIKit.h>
#import "RSS_CustomSizeListViewController.h"
#import "PickerViewController.h"

@class RemoteScanBeforePictViewController;

@interface RSS_FormatViewController : PickerViewController<UITextFieldDelegate> //UIViewController <UIPopoverControllerDelegate>
{
    RemoteScanBeforePictViewController* __unsafe_unretained parentVCDelegate;
    
    IBOutlet UITableView *formatTableView;
    IBOutlet UISegmentedControl *scColorMode;
    
    NSMutableArray* tableSectionIDs;
    
    NSMutableArray* fileFormatList;
    NSMutableArray* compressionPDFTypeList;
    NSMutableArray* compressionRatioList;
    NSMutableArray* monoImageCompressionTypeList;
    
    int nSelectFileFormatIndexRow;
    int nSelectCompressionPDFTypeIndexRow;
    int nSelectCompressionRatioIndexRow;
    int nSelectMonoImageCompressionTypeListIndexRow;
    
    BOOL bEveryPageFiling;
    UILabel* pageNumLbl;
    int nSelectPageNum;
    
    int m_nSelPicker;
    
    UITextField* passwordTextField;
    float keyOffset;// 名称
    BOOL bEncrypt;
    
    BOOL bVisibleCompactPdfSection;
    BOOL bVisibleCompressionSection;
    
    BOOL bBeforeJpeg;
    
}

@property (nonatomic, unsafe_unretained) RemoteScanBeforePictViewController* parentVCDelegate;

- (id)initWithDelegate:(RemoteScanBeforePictViewController *)delegate;

- (IBAction)tapScColorMode:(UISegmentedControl *)sender;
- (IBAction)changePassowrdText:(UITextField *)sender;

- (void)keyboardWillShow:(NSNotification*)aNotification;
- (void)keyboardWillHide:(NSNotification*)aNotification;

@end
