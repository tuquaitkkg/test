
#import <UIKit/UIKit.h>
#import "SharpScanPrintAppDelegate.h"
#import "PreviewScrollViewManager.h"
#import "SelectMailViewController.h"
#import "ELCImagePickerController.h"
#import "ELCAlbumPickerController.h"
#import "PickerModalBaseView.h"
#import "PrintPictCommProcessData.h"
#import "ExAlertController.h"

#define DEFAULT_MENU_Y -45.0                        // メニュー表示Y座標
#define PLBL_PAGE_NUM_TAG 10
#define PAGE_DEL_BUTTON_TAG 20





@interface PictureViewController : UIViewController <UIPickerViewDelegate,
                                                     UIPickerViewDataSource,
                                                     UIWebViewDelegate,
                                                     UIScrollViewDelegate,
                                                     ELCImagePickerControllerDelegate
                                                     >
{
    IBOutlet UIWebView* m_pPreviewWebView;          // プレビュー表示用WebView
    IBOutlet UIScrollView* m_pPreviewScrollView;    // プレビュー表示用ScrollView
    IBOutlet UIButton* m_pbtnShowMenu;              // メニュー表示ボタン
    IBOutlet UIView* m_pMenuView;                   // メニュー表示用View
    IBOutlet UIImageView* m_pMenuImageView;         // メニュー表示用ImageView
    IBOutlet UIView* m_pMenuButtonView;             // メニュー矢印表示用View
    IBOutlet UIImageView* m_pMenuArrowImageView;    // メニュー矢印表示用ImageView
    IBOutlet UILabel*       m_pLblNoImage;          // NoImage表示用ラベル
    IBOutlet UIImageView*   m_pImgViewNoImage;      // NoImage表示用ビュー
    
    BOOL m_bShowMenu;                   // メニュー表示中フラグ
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
    NSInteger m_nSelPickerRowBefore;    // ピッカー表示時の選択行
    NSDictionary* m_pdicEditInfo;       // 画像情報
    NSString* m_pstrFilePath;           // 読み込みファイルパス
    UIImageView* m_pPrintImageView;     // 印刷対象ImageView
    BOOL m_bPhotoView;                  // 遷移元画面がPhotoLibrary画面かどうか
	BOOL m_bFirstLoad;					// 画面ロード完了フラグ
    BOOL m_bAfterView;                  // 遷移元画面が取り込み完了画面かどうか
    BOOL m_bPrintPictView;              // 遷移元画面が印刷画面かどうか
    BOOL m_bSendExSitePictView;         // 遷移元画面がアプリケーションに送る画面かどうか
	
    UIActivityIndicatorView* m_pActivityIndicatorView;	// アクティビティインジケータ

    PickerModalBaseView* _pickerModalBaseView; //iOS8対応　アクションシート代替

    UIPickerView* m_ppickerMenu;        // メニュー用ピッカービュー
    UISegmentedControl *segmentedControl; // ピッカービュー切り替え用
    NSMutableArray* m_parrPickerRow;    // メニュー用ピッカー表示項目
    NSMutableArray* m_parrPickerRow2;    // メニュー用ピッカー表示項目
    /*
    UIButton* m_pbtnFirst;              // メニューボタン１
    UIButton* m_pbtnSecond;             // メニューボタン２
    UIButton* m_pbtnThird;              // メニューボタン３
    UIButton* m_pbtnFourth;             // メニューボタン４
    UIButton* m_pbtnFifth;              // メニューボタン5
    UIButton* m_pbtnSixth;              // メニューボタン6
    UIButton* m_pbtnSeventh;            // メニューボタン7
    UIButton* m_pbtnEighth;             // メニューボタン8
    UIButton* m_pbtnNinth;             // メニューボタン9
    UIButton* m_pbtnTenth;              // メニューボタン10
    */
    ExAlertController *picture_alert;   // メッセージ表示
    
    BOOL m_bButtonEnable;                // ボタンの活性状態フラグ
    
    //スレッド
	BOOL m_bResult;						// 処理結果
	BOOL m_bThread;						// スレッドフラグ
	BOOL m_bAbort;						// 中断フラグ
    BOOL m_bFinLoad;                    // ファイル読み込み完了フラグ
    BOOL m_bCreateCache;                // キャッシュディレクトリ作成フラグ
	//NSThread *m_pThread;				// スレッド
    
    BOOL m_bOriginalViewer;             // 自前ビューア
//    PreviewPage *prevPage;
//    PreviewPage *currPage;
//    PreviewPage *nextPage;
//    UILabel*    m_plblPageNum;
//    UIButton*   m_pBtnRotateImage;
    
//    int currentPage;
    NSUInteger totalPage;
    
    NSArray* arrThumbnails;
    NSString* cacheDirPath;
    
    BOOL m_bEncryptedPdf;               // 暗号化PDFフラグ
    BOOL bRemoteScanSwitch;             // リモートスキャン切り替えスイッチ表示フラグ
    BOOL bNavRightBtn;                  // 設定ボタンを押下した時
    BOOL isMoveAttachmentMail;          //添付ファイル一覧画面からの遷移か
    BOOL isSingleChar;
    //PreviewScrollViewManager* previewScrollViewManager;
    
    int nFolderCount;
    NSString* pathDir;
}

@property (nonatomic,strong) 	NSThread *m_pThread;				// スレッド


@property (nonatomic, strong) PreviewScrollViewManager *previewScrollViewManager;
@property (nonatomic, strong) NSDictionary* PictEditInfo;
@property (nonatomic, strong) NSString* SelFilePath;
@property (nonatomic) BOOL IsPhotoView;
@property (nonatomic) BOOL IsAfterView;
@property (nonatomic) BOOL IsPrintPictView;
@property (nonatomic) BOOL IsBeforeView;
@property (nonatomic) BOOL IsSendExSitePictView;
@property (nonatomic) BOOL bRemoteScanSwitch;
@property (nonatomic) BOOL isMoveAttachmentMail;   // 添付ファイル一覧画面からの遷移か
@property(nonatomic) PrintPictViewID PrintPictViewID;
@property (nonatomic, strong) SelectMailViewController* smViewController;
@property (nonatomic, strong) UINavigationController *smNavigationController;
@property (nonatomic,assign) BOOL isDuplexPrint;          //両面印刷かどうか
@property (nonatomic,assign) BOOL isInvalidDuplexSize;       //はがきなどの両面印刷不可のサイズが選択されている
@property (nonatomic,assign) BOOL isInvalidDuplexType;       //はがきなどの両面印刷不可のタイプが選択されている
@property (nonatomic,assign) BOOL isInvalidStaplePaperSize;     // ステープル不可の用紙サイズが選択されている
@property (nonatomic,assign) BOOL isInvalidStaplePaperType;     // ステープル不可の用紙タイプが選択されている
@property (nonatomic,assign) BOOL isInvalidPunchPaperSize;      // パンチ不可の用紙サイズが選択されている
@property (nonatomic,assign) BOOL isInvalidPunchPaperType;      // パンチ不可の用紙タイプが選択されている
@property (nonatomic,strong) NSMutableArray *mailFormatArray;//メールの属性を格納する配列

// 初期化関連
// 変数初期化
- (void)InitObject;

// メインビュー初期化
- (void)InitView:(NSString*)pstrTitle           // 画面タイトル
      menuBtnNum:(NSInteger)nMenuBtnNum;        // メニュー表示するボタン数

- (void)InitView:(NSString*)pstrTitle           // 画面タイトル
      menuBtnNum:(NSInteger)nMenuBtnNum         // メニュー表示するボタン数
setHiddenNoImage:(BOOL)bSetHiddenNoImage;       // NoImage表示フラグ

// メニュー作成
- (void)CreateMenu:(NSInteger)nMenuBtnID        // メニューボタンID
           btnName:(NSString*)pstrBtnName       // ボタン表示名称
         initValue:(NSString*)pstrInitValue     // ボタンに表示する初期値
          iconName:(NSString*)pstrIconName;     // ボタンに表示するアイコン名称

// メニューボタン作成
- (UIButton*)CreateMenuButton:(NSInteger)nMenuBtnID     // メニューボタンID
                      btnName:(NSString*)pstrBtnName    // ボタン表示名称
                    initValue:(NSString*)pstrInitValue  // ボタンに表示する初期値
                     iconName:(NSString*)pstrIconName   // ボタンに表示するアイコン名称
                    eventFunc:(SEL)pstrEventFunc;       // ボタン押下イベント関数名

//No Image表示切替
- (void)setNoImageHidden:(BOOL)bHidden;

// スレッド
// 実行スレッド
- (void)ActionThread;

// スレッドの開始
- (void)StartThread;

// スレッド停止
- (void)StopThread;

//キャッシュ作成
-(void)createCashForFile:(NSString*)pstrFilePath;

//// ファイル表示
//- (void)ShowFile:(NSString*)pstrFileResource    // 画面表示ファイル
//        fileType:(NSString*)pstrFileType;       // ファイルの種類(PDF,JPEG等)
//
// ファイル表示(フルパス指定)
- (void)ShowFile:(NSString*)pstrFilePath;       // 画面表示ファイルパス
// ファイル表示(フルパス指定)
// Web,Emailファイルを追加時
- (void)ShowFileUpdate:(NSString*)pstrFilePath;        // 画面表示ファイルパス

// WebVeiwへのファイル表示(フルパス指定)
- (void)ShowFileInWebView:(NSString*)pstrFilePath;      // 画面表示ファイルパス

// ScrollViewへのファイル表示(フルパス指定)
- (void)ShowFileInScrollView:(NSString*)pstrFilePath;   // 画面表示ファイルパス
- (void)ShowImageInScrollView:(UIImage*)img
                  showMessage:(BOOL)showAlert;          // 画面イメージ

// 自前ビューアでのファイル表示（フルパス指定）
- (void)ShowFileInOriginalView:pstrFilePath;

// ファイル表示失敗時処理
- (void)ShowFileError;

// ボタン押下関数
// ナビゲーションバー 設定ボタン押下
- (IBAction)OnNavBarRightButton:(id)sender;
// メニュー表示ボタン押下
- (IBAction)OnShowMenuButton:(id)sender;

// アニメーション関数
// メニュー表示アニメーション
- (void)AnimationShowMenu;
- (void)AnimationNotShowMenu;

// メニュー非表示から表示へアニメーションする時のY座標
- (CGFloat)AnimationShowMenuRectY;

// メニュー矢印アニメーション開始
- (void)AnimationShowMenuArrow;
// メニュー矢印アニメーション完了
- (void)EndAnimationShowMenuArrow;

// 画面表示時メニュー表示アニメーション
- (void)AnimationShowStartMenu;

// 画面表示時メニュー表示アニメーション1完了
- (void)EndAnimationShowStartMenu;

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

// ピッカー作成
- (UIPickerView*)CreatePickerView;


// pickerModaiView決定ボタン押下
- (void)OnMenuDecideButton:(id)sender;
// pickerModaiViewキャンセルボタン押下
- (void)OnMenuCancelButton:(id)sender;

// その他サブ関数
// ボタン押下Enabled設定
- (void)SetButtonEnabled:(BOOL)bEnable;
//- (void)SetButtonEnabled:(BOOL)bEnable andBtnIndex:(NSInteger)btnIndex;
- (void)SetButtonEnabledDeleted:(BOOL)bEnable;

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

-(void)dismissAlertView;
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
// 処理中アラート表示
- (void)CreateProgressAlert:(NSString *)pstrTitle 
                    message:(NSString *)pstrMessage 
                 withCancel:(BOOL)bCancel;

- (BOOL)showOriginalViewerCheck:(NSString*)selFilePath;
- (void)ShowFileInOriginalView:pstrFilePath;
- (void)ShowFileInOriginalViewUpdate;

@property (nonatomic,strong) NSMutableArray *multiPrintPictTempArray;

@property (nonatomic,assign) NSInteger m_nSelPickerRow1;         // ピッカー1選択行
@property (nonatomic,assign) NSInteger m_nSelPickerRow2;         // ピッカー2選択行 //プリンターorスキャナー選択？
@property (nonatomic,assign) NSInteger m_nSelPickerRow3;         // ピッカー3選択行
@property (nonatomic,assign) NSInteger m_nSelPickerRow4;         // ピッカー4選択行
@property (nonatomic,assign) NSInteger m_nSelPickerRow5;         // ピッカー5選択行
@property (nonatomic,assign) NSInteger m_nSelPickerRow6;         // ピッカー6選択行
@property (nonatomic,assign) NSInteger m_nSelPickerRow7;         // ピッカー7選択行
@property (nonatomic,assign) NSInteger m_nSelPickerRow8;         // ピッカー8選択行

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
@property (nonatomic,strong) UIButton* m_pbtnEleventh;          // メニューボタン１１
@property (nonatomic,strong) UIButton* m_pbtnTwelveth;          // メニューボタン12
@property (nonatomic,strong) UIButton* m_pbtnThirteenth;          // メニューボタン13
@property (nonatomic,strong) UIButton* m_pbtnFourteenth;          // メニューボタン14

@property (nonatomic,strong) UIButton *m_pBtnRotateImage;
@property (nonatomic,strong) UIButton *m_pBtnPageAddImage;
@property (nonatomic,strong) UIButton *m_pBtnPageDelImage;

@property (nonatomic,strong) IBOutlet UIWebView *m_pPreviewWebView;          // プレビュー表示用WebView
@property (nonatomic,strong) IBOutlet UIScrollView *m_pPreviewScrollView;    // プレビュー表示用ScrollView
@property (nonatomic,assign) BOOL isSingleChar;

// プリンター情報取得キャンセル対応
@property (nonatomic, assign) BOOL isDuringCommProcess;                     // プリンター情報取得中フラグ
@property (nonatomic, strong) NSOperationQueue *queue;
@property (nonatomic, assign) BOOL m_isShoudRemakeMenuButton;               // 再生成処理必要フラグ

@end
