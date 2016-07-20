
#import <UIKit/UIKit.h>

@class RemoteScanBeforePictViewController_iPad;

@interface RSS_FormatViewController_iPad : UIViewController <UIPopoverControllerDelegate, UITextFieldDelegate>
{
    RemoteScanBeforePictViewController_iPad* __unsafe_unretained parentVCDelegate;
    
    IBOutlet UITableView *formatTableView;
    IBOutlet UISegmentedControl *scColorMode;
    
    NSMutableArray* tableSectionIDs;
    
    NSMutableArray* fileFormatList;
    NSMutableArray* compressionPDFTypeList;
    NSMutableArray* compressionRatioList;
    NSMutableArray* monoImageCompressionTypeList;
    NSArray *ocrLanguageKeys;
    NSArray *ocrOutputFontKeys;
    NSArray *ocrAccuracyKeys;
    
//    NSUInteger nSelectFileFormatIndexRow;
    NSString *strSelectFileFormatValue;
    NSInteger nSelectCompressionPDFTypeIndexRow;
//    NSInteger nSelectCompressionRatioIndexRow;
    NSString *strSelectCompressionRatioValue;
    NSInteger nSelectMonoImageCompressionTypeListIndexRow;
    NSString *strSelectOCRLanguageKey;
    NSString *strSelectOCROutputFontKey;
    NSString *strSelectOCRAccuracyKey;
    
    BOOL bEveryPageFiling;
    UILabel* pageNumLbl;
    int nSelectPageNum;
    
    UIPopoverController* m_popOver;
    NSInteger m_nSelPicker;
    
    UITextField* passwordTextField;         // 名称
    BOOL bEncrypt;
    
    BOOL validOCR;
    BOOL validOCRAccuracy;
    BOOL bOCR;
    BOOL bCorrectImageRotation;
    BOOL bExtractFileName;
    
    
    BOOL bVisibleCompactPdfSection;
    BOOL bVisibleCompressionSection;

    BOOL bBeforeJpeg;

}

@property (nonatomic, unsafe_unretained) RemoteScanBeforePictViewController_iPad* parentVCDelegate;

- (id)initWithDelegate:(RemoteScanBeforePictViewController_iPad *)delegate;
- (IBAction)tapScColorMode:(UISegmentedControl *)sender;
- (IBAction)changePassowrdText:(UITextField *)sender;
//- (IBAction)textFieldDoneEditing:(id)sender;

- (void)keyboardWillShow:(NSNotification*)aNotification;
- (void)keyboardWillHide:(NSNotification*)aNotification;

// ポップオーバーを閉じる
-(void)popoverClose;

@end
