
@protocol WebPagePrintViewControllerDelegate
-(void) webPagePrint:(UIViewController*)viewController didWebPagePrintSuccess:(BOOL)bSuccess;
-(void) webPagePrint:(UIViewController*)viewController upLoadWebView:(NSString*)strFilePath;

@end

@interface WebPagePrintViewController : UIViewController <UITextFieldDelegate, UIWebViewDelegate>
{
    NSObject <WebPagePrintViewControllerDelegate> *__unsafe_unretained delegate;
    UIWebView       * m_webView;
    UIButton        * m_backButton;                 // 戻るボタン
    UIButton        * m_forwardButton;              // 進むボタン
    UITextField     * m_urlTextField;               // URL入力欄
}
@property (nonatomic, unsafe_unretained) id delegate;

@end
