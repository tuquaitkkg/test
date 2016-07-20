#import "TempFile.h"
#import "TempFileUtility.h"
#import "ExAlertController.h"

@protocol WebPagePrintViewControllerDelegate_iPad
-(void) webPagePrint:(UIViewController*)viewController didWebPagePrintSuccess:(BOOL)bSuccess;
-(void) webPagePrint:(UIViewController*)viewController upLoadWebView:(NSString*)strFilePath;

@end

@interface WebPagePrintViewController_iPad : UIViewController <UITextFieldDelegate, UIWebViewDelegate>
{
    NSObject <WebPagePrintViewControllerDelegate_iPad> *__unsafe_unretained delegate;
    UIWebView       * m_webView;
    UIButton        * m_backButton;                 // 戻るボタン
    UIButton        * m_forwardButton;              // 進むボタン
    UITextField     * m_urlTextField;               // URL入力欄
}
@property (nonatomic, unsafe_unretained) id delegate;
@property(nonatomic, strong) ExAlertController *ex_alert;
@end
