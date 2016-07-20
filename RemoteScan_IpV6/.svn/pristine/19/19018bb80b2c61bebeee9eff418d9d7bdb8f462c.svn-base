
#import <UIKit/UIKit.h>
#import "PreviewScrollViewManager.h"
#import "SelectMailViewController_iPad.h"

#import "ELCImagePickerController.h"
#import "ELCAlbumPickerController.h"
#import "GeneralFileUtility.h"
#import "PrintPictCommProcessData.h"
#import "ExAlertController.h"

enum{
    ALERT_TAG_PREVIEW_MEMORY_ERROR_IPAD = 11,
};

@protocol UpdatePictureViewController_iPad
- (void)updateView:(UIViewController*) pViewController;
- (void)updateView:(UIViewController*) pViewController animated:(BOOL)animated;
- (void)popRootView;
- (void)setPortraitMenu:(UIBarButtonItem *)barButtonItem;
@end

@interface PictureViewController_iPad : UIViewController <UIWebViewDelegate,UIPopoverControllerDelegate,UINavigationControllerDelegate,UISplitViewControllerDelegate,UIScrollViewDelegate,UpdatePictureViewController_iPad,ELCImagePickerControllerDelegate>
{
    
    IBOutlet UILabel *m_pLblNoImage;          // NoImage表示用ラベル
    IBOutlet UIImageView *m_pImgViewNoImage;      // NoImage表示用ビュー
    
    NSInteger m_nMenuBtnNum;            // メニュー表示するボタン数
    NSInteger m_nSelPicker;             // 選択中ピッカー
    
    /*
    NSInteger m_nSelPickerRow1;         // ピッカー1選択行
    NSInteger m_nSelPickerRow2;         // ピッカー2選択行
    NSInteger m_nSelPickerRow3;         // ピッカー3選択行
    NSInteger m_nSelPickerRow4;         // ピッカー4選択行
    NSInteger m_nSelPickerRow5;         // ピッカー5選択行
    NSInteger m_nSelPickerRow6;         // ピッカー6選択行
    NSInteger m_nSelPickerRow7;         // ピッカー7選択行
    */
    
    NSString *m_pstrPickerValue;        // ピッカー選択値 // iPad用
    NSDictionary *m_pdicEditInfo;       // 画像情報
    NSString *m_pstrFilePath;           // 読み込みファイルパス
    IBOutlet UIImageView *m_pPrintImageView;     // 印刷対象ImageView
    BOOL m_bPhotoView;                  // 遷移元画面がPhotoLibrary画面かどうか
	BOOL m_bFirstLoad;					// 画面ロード完了フラグ
    BOOL m_bAfterView;                  // 遷移元画面が取り込み完了画面かどうか
    BOOL m_bPrintPictView;              // 遷移元画面が印刷画面かどうか
    BOOL m_bSendExSitePictView;         // 遷移元画面がアプリケーションに送る画面かどうか
	
    UIActivityIndicatorView* m_pActivityIndicatorView;	// アクティビティインジケータ
    UIPopoverController *m_popOver;
    //UIButton* m_pbtnFirst;              // メニューボタン１
    //UIButton* m_pbtnSecond;             // メニューボタン２
    //UIButton* m_pbtnThird;              // メニューボタン３
    //UIButton* m_pbtnFourth;             // メニューボタン４
    //UIButton* m_pbtnFifth;             // メニューボタン５
    //UIButton* m_pbtnSixth;             // メニューボタン６
    //UIButton* m_pbtnSeventh;             // メニューボタン７
    //UIButton* m_pbtnEighth;             // メニューボタン８
    //UIButton* m_pbtnNinth;             // メニューボタン９
    //UIButton* m_pbtnTenth;             // メニューボタン１０
    
//----------------------------------------------------------
// 「他アプリで確認」と「印刷する」はラベルが不要であるため、
// ここで定義するラベルの数は、(最大ボタン数ー２)個となる。
// また、メニューラベル１(m_plblFirst)は存在せず、
// メニューラベル２(m_plblSecond)から定義する。
//----------------------------------------------------------
    UILabel* m_plblSecond;              // メニューラベル２
    UILabel* m_plblThird;               // メニューラベル３
    UILabel* m_plblFourth;              // メニューラベル４
    UILabel* m_plblFifth;               // メニューラベル５
    UILabel* m_plblSixth;               // メニューラベル６
    UILabel* m_plblSeventh;             // メニューラベル７
    UILabel* m_plblEighth;              // メニューラベル８
    UILabel* m_plblNinth;               // メニューラベル９
    UILabel* m_plblTenth;               // メニューラベル１０
    UILabel* m_plblEleventh;            // メニューラベル１１
    UILabel* m_plblTwelveth;            // メニューラベル１２
    UILabel* m_plblThirteenth;          // メニューラベル１３
    
    
    UIImageView* m_pimgSecond;          // メニュー画像2
    UIImageView* m_pimgThird;           // メニュー画像3
    UIImageView* m_pimgFourth;          // メニュー画像4
    UIImageView* m_pimgFifth;           // メニュー画像5
    UIImageView* m_pimgSixth;           // メニュー画像6
    UIImageView* m_pimgSeventh;         // メニュー画像7
    UIImageView* m_pimgEighth;          // メニュー画像8
    UIImageView* m_pimgNinth;           // メニュー画像9
    UIImageView* m_pimgTenth;           // メニュー画像10
    UIImageView* m_pimgEleventh;        // メニュー画像11
    UIImageView* m_pimgTwelveth;        // メニュー画像12
    UIImageView* m_pimgThirteenth;      // メニュー画像13
    
    
    ExAlertController *picture_alert;   // メッセージ表示
    
    BOOL m_bButtonEnable;                // ボタンの活性状態フラグ
    UIView *m_pMenuView;
    
    //スレッド
	BOOL m_bResult;						// 処理結果
	BOOL m_bThread;						// スレッドフラグ
	BOOL m_bAbort;						// 中断フラグ
    BOOL m_bFinLoad;                    // ファイル読み込み完了フラグ
    BOOL m_bCreateCache;                // キャッシュディレクトリ作成フラグ
	NSThread *m_pThread;				// スレッド
    
    BOOL m_bOriginalViewer;             // 自前ビューア
        
    NSUInteger totalPage;
    
    NSArray *arrThumbnails;
    NSString *cacheDirPath;
    
    BOOL m_bEncryptedPdf;               // 暗号化PDFフラグ
    
    UIViewController *__unsafe_unretained prevViewController; // 一つ前の画面のコントローラ
    BOOL        isMoveAttachmentMail;   //添付ファイル一覧画面からの遷移か
    
    BOOL bNavRightBtn;                  // 設定ボタンを押下した時
}

@property (nonatomic,assign) NSInteger m_nSelPickerRow1;         // ピッカー1選択行
@property (nonatomic,assign) NSInteger m_nSelPickerRow2;         // ピッカー2選択行
@property (nonatomic,assign) NSInteger m_nSelPickerRow3;         // ピッカー3選択行
@property (nonatomic,assign) NSInteger m_nSelPickerRow4;         // ピッカー4選択行
@property (nonatomic,assign) NSInteger m_nSelPickerRow5;         // ピッカー5選択行
@property (nonatomic,assign) NSInteger m_nSelPickerRow6;         // ピッカー6選択行
@property (nonatomic,assign) NSInteger m_nSelPickerRow7;         // ピッカー7選択行
@property (nonatomic,assign) NSInteger m_nSelPickerRow8;         // ピッカー7選択行

@property (nonatomic,strong) UIButton* m_pbtnFirst;              // メニューボタン１
@property (nonatomic,strong) UIButton* m_pbtnSecond;              // メニューボタン２
@property (nonatomic,strong) UIButton* m_pbtnThird;              // メニューボタン３
@property (nonatomic,strong) UIButton* m_pbtnFourth;              // メニューボタン４
@property (nonatomic,strong) UIButton* m_pbtnFifth;              // メニューボタン５
@property (nonatomic,strong) UIButton* m_pbtnSixth;              // メニューボタン６
@property (nonatomic,strong) UIButton* m_pbtnSeventh;             // メニューボタン７
@property (nonatomic,strong) UIButton* m_pbtnEighth;             // メニューボタン８
@property (nonatomic,strong) UIButton* m_pbtnNinth;             // メニューボタン９
@property (nonatomic,strong) UIButton* m_pbtnTenth;             // メニューボタン１０
@property (nonatomic,strong) UIButton* m_pbtnEleventh;             // メニューボタン１１
@property (nonatomic,strong) UIButton* m_pbtnTwelveth;             // メニューボタン12
@property (nonatomic,strong) UIButton* m_pbtnThirteenth;             // メニューボタン13
@property (nonatomic,strong) UIButton* m_pbtnFourteenth;          // メニューボタン14

@property (nonatomic,strong) UIButton *m_pBtnRotateImage;   //回転ボタン
@property (nonatomic,strong) UIButton *m_pBtnPageAddImage;  //ページ追加ボタン

@property (nonatomic,strong) IBOutlet UIWebView *m_pPreviewWebView;          // プレビュー表示用WebView
@property (nonatomic,strong) IBOutlet UIScrollView *m_pPreviewScrollView;    // プレビュー表示用ScrollView

@property (nonatomic,strong) PreviewScrollViewManager *previewScrollViewManager;
@property (nonatomic,strong) NSDictionary *PictEditInfo;
@property (nonatomic,strong) NSString *SelFilePath;
@property (nonatomic) BOOL IsPhotoView;
@property (nonatomic) BOOL IsAfterView;
@property (nonatomic) BOOL IsPrintPictView;
@property (nonatomic) BOOL IsSendExSitePictView;
@property (nonatomic,unsafe_unretained) UIViewController *prevViewController;
@property (nonatomic) BOOL        isMoveAttachmentMail;   // 添付ファイル一覧画面からの遷移か
@property (nonatomic,assign) BOOL isDuplexPrint;          //両面印刷かどうか
@property (nonatomic,assign) BOOL isInvalidDuplexSize;          //はがきなどの両面印刷不可のサイズが選択されている
@property (nonatomic,assign) BOOL isInvalidDuplexType;          //はがきなどの両面印刷不可のタイプが選択されている
@property (nonatomic,assign) BOOL isInvalidStaplePaperSize;     // ステープル不可の用紙サイズが選択されている
@property (nonatomic,assign) BOOL isInvalidStaplePaperType;     // ステープル不可の用紙タイプが選択されている
@property (nonatomic,assign) BOOL isInvalidPunchPaperSize;      // パンチ不可の用紙サイズが選択されている
@property (nonatomic,assign) BOOL isInvalidPunchPaperType;      // パンチ不可の用紙タイプが選択されている
@property (nonatomic) PrintPictViewID PrintPictViewID;           // 遷移元画面ID
@property (nonatomic,strong) SelectMailViewController_iPad *smViewController;
@property (nonatomic,strong) UINavigationController *smNavigationController;

@property (nonatomic,strong) NSMutableArray *mailFormtArray;//メールの属性を格納する配列

// プリンター情報取得キャンセル対応
@property (nonatomic, assign) BOOL isDuringCommProcess;                     // プリンター情報取得中フラグ
@property (nonatomic, assign) BOOL m_isShoudRemakeMenuButton;               // 再生成処理必要フラグ
@property (nonatomic, strong) NSOperationQueue *queue;

// 初期化関連
// 変数初期化
- (void)InitObject;

// メインビュー初期化
- (void)InitView:(NSString*)pstrTitle                // 画面タイトル
      menuBtnNum:(NSInteger)nMenuBtnNum              // メニュー表示するボタン数
      hidesBackButton:(BOOL)bHidden                  // 戻るボタン非表示
      hidesSettingButton:(BOOL)bSettingButtonHidden; // 設定ボタン非表示

- (void)InitView:(NSString*)pstrTitle                // 画面タイトル
      menuBtnNum:(NSInteger)nMenuBtnNum              // メニュー表示するボタン数
      hidesBackButton:(BOOL)bHidden                  // 戻るボタン非表示
      hidesSettingButton:(BOOL)bSettingButtonHidden // 設定ボタン非表示
      setHiddenNoImage:(BOOL)bSetHiddenNoImage;       // NoImage表示フラグ

// メニュー作成
- (void)CreateMenu:(NSInteger)nMenuBtnID         // メニューボタンID
           btnName:(NSString*)pstrBtnName        // ボタン表示名称
          iconName:(NSString*)pstrIconName       // ボタンに表示するアイコン名称
           lblName:(NSString*)pstrLblName;       // ラベル表示名称
// メニューボタン作成
- (UIButton *)CreateMenuButton:(NSInteger)nMenuBtnID     // メニューボタンID
                      btnName:(NSString*)pstrBtnName    // ボタン表示名称
                     iconName:(NSString*)pstrIconName   // ボタンに表示するアイコン名称
                    eventFunc:(SEL)pstrEventFunc;       // ボタン押下イベント関数名
// メニューアイコン作成
- (UIImageView *)CreateMenuIcon:(NSInteger)nMenuBtnID     // メニューボタンID
                     iconName:(NSString*)pstrIconName;  // ボタンに表示するアイコン名称
// メニューラベル作成
- (UILabel *)CreateMenuLabel:(NSInteger)nMenuBtnID        // メニューボタンID
                   lblName:(NSString*)pstrLblName;      // ラベル表示名称

//No Image表示切替
- (void)setNoImageHidden:(BOOL)bHidden;


// iPad用

// スレッド
// 実行スレッド
- (void)ActionThread;

// スレッドの開始
- (void)StartThread;

// スレッド停止
- (void)StopThread;

// ファイル表示
// 画面表示ファイル
//// ファイルの種類(PDF,JPEG等)
//- (void)ShowFile:(NSString*)pstrFileResource fileType:(NSString*)pstrFileType;

// ファイル表示(フルパス指定)
- (void)ShowFile:(NSString*)pstrFilePath;

// ファイル表示(フルパス指定)
// Web,Emailファイルを追加時
- (void)ShowFileUpdate:(NSString*)pstrFilePath;

// WebVeiwへのファイル表示(フルパス指定)
- (void)ShowFileInWebView:(NSString*)pstrFilePath;

// ScrollViewへのファイル表示(フルパス指定)
- (void)ShowFileInScrollView:(NSString*)pstrFilePath;
- (void)ShowImageInScrollView:(UIImage*)img showMessage:(BOOL)showAlert;

// 自前ビューアでのファイル表示（フルパス指定）
- (void)ShowFileInOriginalView:pstrFilePath;

// ファイル表示失敗時処理
- (void)ShowFileError;

// ナビゲーションバー 設定ボタン押下
- (IBAction)OnNavBarRightButton:(id)sender;

// ピッカービュー関連
// ピッカー表示
- (void)ShowPickerView:(NSInteger)nMenuBtnID            // メニューボタンID
            pickerMenu:(NSMutableArray*)parrPickerMenu; // メニュー用ピッカー表示項目

- (void)ShowPickerView:(NSInteger)nMenuBtnID            // メニューボタンID
              pickerID:(NSInteger)nPikcerID             // ピッカーID
            pickerMenu:(NSMutableArray*)parrPickerMenu; // メニュー用ピッカー表示項目

- (void)ShowPickerView:(NSInteger)nMenuBtnID            // メニューボタンID
              pickerID:(NSInteger)nPickerID             // ピッカーID
            pickerMenu:(NSMutableArray*)parrPickerMenu // メニュー用ピッカー表示項目
            pickerMenu2:(NSMutableArray*)parrPickerMenu2 // メニュー用ピッカー表示項目
               isPrint:(BOOL)isPrint;

// その他サブ関数
// ボタン押下Enabled設定
- (void)SetButtonEnabled:(BOOL)bEnable;

// Picker選択値設定
- (void)setPickerValue;

// 変数解放
- (void)ReleaseObject:(id)object;

// メッセージボックス表示
- (void)CreateAllert:(NSString*)pstrTitle
             message:(NSString*)pstrMsg
            btnTitle:(NSString*)pstrBtnTitle;

// メッセージボックス表示
- (void)CreateAllert:(NSString*)pstrTitle
             message:(NSString*)pstrMsg
            btnTitle:(NSString*)pstrBtnTitle
             withTag:(NSInteger)nTag;

// メッセージボックス表示
- (void)CreateAlert:(NSString*)pstrTitle
            message:(NSString*)pstrMsg
        cancelTitle:(NSString*)cancelTitle
            okTitle:(NSString*)okTitle
            withTag:(NSInteger)nTag;

// メッセージボックス表示
- (void)CreateAllert:(NSString*)pstrTitle
             message:(NSString*)pstrMsg
            btnTitle:(NSString*)pstrBtnTitle
      cancelBtnTitle:(NSString*)pstrCanceBtnTitle
             withTag:(NSInteger)nTag;

// 処理中アラート表示
- (void)CreateProgressAlert:(NSString *)pstrTitle 
                    message:(NSString *)pstrMessage 
                 withCancel:(BOOL)bCancel;

// Webページ印刷を行う画面から遷移したかをチェックする
- (BOOL)isMoveWebPagePrint;

- (BOOL)showOriginalViewerCheck:(NSString*)selFilePath;

-(void)dismissAlertPicture;

-(void)showAlertOnMainThread;

// アラート表示
- (void)makePictureAlert:(NSString*)pstrTitle
                 message:(NSString*)pstrMsg
          cancelBtnTitle:(NSString*)cancelBtnTitle
              okBtnTitle:(NSString*)okBtnTitle
                     tag:(NSInteger)tag
                 showFlg:(BOOL)showFlg;
// アラート表示
- (void) makeTmpExAlert:(NSString*)pstrTitle
                message:(NSString*)pstrMsg
         cancelBtnTitle:(NSString*)cancelBtnTitle
             okBtnTitle:(NSString*)okBtnTitle
                    tag:(NSInteger)tag;

@property (nonatomic,strong) NSMutableArray *multiPrintPictTempArray;

@end
