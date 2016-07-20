
#import <UIKit/UIKit.h>

// iPad用
@protocol UpdateVersionViewController
- (void)setPortraitMenu:(UIBarButtonItem *)barButtonItem;
@end
// iPad用

// iPad用
//@interface VersionInfoViewController : UIViewController
@interface VersionInfoViewController_iPad : UIViewController <UINavigationControllerDelegate,UIGestureRecognizerDelegate>
// iPad用
{
    IBOutlet UILabel*   m_tradeMark;            // 商標登録文言
    IBOutlet UILabel*   m_applicationName;      // アプリケーション名
    IBOutlet UILabel*   m_applicationName2;     // アプリケーション名2
    IBOutlet UILabel*   m_vesionNumber;         // バージョン番号
    IBOutlet UILabel*   m_copyright;            // コピーライト
    IBOutlet UILabel*   m_libraryLicense;       // ライブラリのライセンス表示
    IBOutlet UIButton*  m_librarySnmpPlus;      // SNMP++
    IBOutlet UIButton*  m_libraryMailCore;      // MailCore
    IBOutlet UIButton*  m_libraryLibEtPan;      // LibEtPan
    IBOutlet UIButton*  m_libraryiOSPorts;      // iOS Ports SDK
    IBOutlet UIButton*  m_libraryCyrusSASL;     // Cyrus SASL
    IBOutlet UIButton*  m_libraryOpenSSL;       // OpenSSL
    IBOutlet UIButton*  m_libraryELCImage;      // ELCImagePickerController
    IBOutlet UIButton*  m_libraryMiniZip;       // MiniZip
    IBOutlet UIImageView* m_imageView;          // ロゴ画像
    IBOutlet UIButton *m_btnSpecialMode;                // 特別モードヘルプ表示ボタン
    IBOutlet UIButton *m_btnPdfPrintRangeExpansionMode; // PDF印刷範囲拡張モード表示ボタン
}

// 変数解放
- (void)ReleaseObject:(id)object;

// ラベル文字列下詰め
- (void)AddAndKeepTextDown:(NSString *)newString 
                          :(UILabel *)txtLabel;

- (void)createGestureRecognizer;
- (void)handleLongPressGesture:(UILongPressGestureRecognizer*) sender;

- (void)createGestureRecognizerForPdfPrintRangeExpansion;
- (void)handleLongPressGestureForPdfPrintRangeExpansion:(UILongPressGestureRecognizer*) sender;
- (IBAction)OnClickPdfPrintRangeExpansionButton:(id)sender;
//PDF印刷範囲拡張モード表示ボタン生成
- (void)makePdfPrintRangeExpansionButton;

- (IBAction)onLicenseSNMPplus:(id)sender;
- (IBAction)onLicenseMailCore:(id)sender;
- (IBAction)onLicenseLibEtPan:(id)sender;
- (IBAction)onLicenseiOSPorts:(id)sender;
- (IBAction)onLicenseCyrusSASL:(id)sender;
- (IBAction)onLicenseOpenSSL:(id)sender;
- (IBAction)onLicenseELCImage:(id)sender;
- (IBAction)onLicenseMiniZip:(id)sender;

- (void)setPortraitMenu:(UIBarButtonItem *)barButtonItem;

@end
