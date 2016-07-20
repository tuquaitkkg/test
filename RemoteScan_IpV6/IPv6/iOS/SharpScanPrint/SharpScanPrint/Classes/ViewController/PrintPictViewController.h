
#import <UIKit/UIKit.h>
#import "PictureViewController.h"
#import "Define.h"
#import "CommonManager.h"
#import "PrinterDataManager.h"
#import "PrintServerDataManager.h"
#import "PrintOutDataManager.h"
#import "PJLDataManager.h"
#import "CommonUtil.h"
#import "SnmpManager.hh"
#import "WebPagePrintViewController.h"
#import "SelectMailViewController.h"
#import "ShowMailViewController.h"
#import "AttachmentMailViewController.h"
#import "GeneralFileUtility.h"
#import "ScanFile.h"
#import "ScanDirectory.h"
#import "ScanDirectoryUtility.h"
#import "ScanFileUtility.h"
#import "TempAttachmentFileUtility.h"
#import "NupTempFileUtility.h"
#import "NupTempFile.h"
#import "RSmfpifManager.h"
#import "RSmfpifServiceManager.h"
#import "PrintPictManager.h"
#import "PrintPictCommProcessData.h"

#define FOWARD_TIMEOUT	60.0							// タイムアウト時間(mm sec)




@protocol PrintPictViewControllerDelegate
-(void) showAttachmentMailView:(UIViewController*)viewController;
-(void) closeSelectMailViewShowAttachmentMailView:(UIViewController*)viewController closeView:(UIViewController*)closeView;

@end


@interface PrintPictViewController : PictureViewController <NSStreamDelegate,UIDocumentInteractionControllerDelegate,WebPagePrintViewControllerDelegate,SelectMailViewControllerDelegate,ShowMailViewControllerDelegate,AttachmentMailViewControllerDelegate,RSHttpCommunicationManagerDelegate, UIScrollViewDelegate>
{
    BOOL m_bSendFile;                       // FTP送信中フラグ
    BOOL m_bRet;                            // FTP送信結果
    CommonManager* m_pCmnMgr;               // CommonManagerクラス
    PrinterDataManager* m_pPrinterMgr;      // PrinterDataManagerクラス
    PrintServerDataManager* m_pPrintServerMgr;      // PrintServerDataManagerクラス
    PrintOutDataManager* m_pPrintOutMgr;    // PrintOutDataManagerクラス
    PJLDataManager* m_pPJLDataMgr;          // PJLDataManagerクラス
    ProfileDataManager *profileDataManager; // ProfileDataManagerクラス
    PrintOutDataManager* printOutManager;   // PrintOutDataManagerクラス
    // FTP関連
    NSOutputStream* m_pNetworkStream;   // ファイル書込みストリーム
    NSInputStream* m_pFileStream;       // 送信ファイルストリーム
    uint8_t m_pBuffer[kSendBufferSize]; // バッファ
    size_t m_stBufferOffset;            // バッファオフセット
    size_t m_stBufferLimit;             // 最大バッファ
    
    /*
    NSString* m_pstrNumSets;    // 選択中の部数設定
    NSString* m_pstrSide;       // 選択中の片面/両面設定
    NSString* m_pstrPaperSize;  // 選択中の用紙サイズ
    NSString* m_pstrPaperSizePJL;     // 選択中の用紙サイズのPJLの値
    NSString* m_pstrColorMode;  // 選択中のカラーモード
    NSString* m_stPjlFaileName;   // PJLファイル名
     */
    NSString* m_pstrNUp;  // 選択中の印刷範囲
    NSString *sizePJLBeforeSelect; // 一つ前に選ばれた用紙サイズのPJL
    
    /*
    NSString* m_pstrRetention;  // 選択中のリテンション
    NSString* m_pstrPrintRange;  // 選択中の印刷範囲
     */
    
    /*
    //リテンション
    BOOL noPrintOn;                     // 印刷せずにホールドフラグ
    BOOL authenticateOn;                // 認証フラグ
    NSString* pstrPassword;             // パスワード
     */
    
    //印刷範囲
    BOOL isPrintRangeExpansionMode;        // 印刷範囲拡張有効かどうか
    NSInteger m_PrintRangeStyle;              // 印刷範囲タイプ（全てのページ/範囲指定/直接指定）
    NSUInteger m_PageMax;                      // 範囲指定MAXページ数
    NSInteger m_PageFrom;                     // 範囲指定FROM
    NSInteger m_PageTo;                       // 範囲指定TO
    NSString* m_PageDirect;             // 直接指定

    BOOL    m_isSite;
    BOOL    m_isSiteTemp;
    BOOL    m_isCacel;
    BOOL    m_isStopSend;
    BOOL    m_isStop; // 送信停止処理実行済みフラグ
    BOOL    m_isPrintStop; // 印刷処理終了フラグ
    BOOL    m_isDoSnmp;
    
    BOOL _printCancelled;//途中でキャンセルされたらYES
    
    
	NSTimer* tm; // ファイル転送タイマー
    UIBackgroundTaskIdentifier bgTask; // バックグラウンド実行タスク
    
    NSMutableArray* m_pArrPapersize;  //用紙サイズディクショナリ

    BOOL    m_isUseRawPrintMode;
    CFSocketRef m_Socket;
    
    SnmpManager* snmpManager;           // SNMPマネージャ
    
    UIDocumentInteractionController *m_diCtrl;
    
    IBOutlet UIScrollView *menuScrollView;
    IBOutlet UIButton *menuUpBtn;
    IBOutlet UIButton *menuDownBtn;
    
    BOOL bShowOriginalView;
    NSInteger nPreMenuBtnMaxID;
    
    /*
    // Nup
    NSInteger nNupRow;
    NSInteger nSeqRow;
    NSString* pstrSelectedNUp;
    NSString* pstrSelectedSeq;

    BOOL m_isPrint;                       // 印刷実行フラグ
    BOOL m_isVertical;                    // 縦/横フラグ
    */
    
    BOOL m_isAvailablePrintPDF;
    
    NSArray * _filesToBePrintedArray; // 印刷すべきファイルの配列。selectFileArrayからさらに抽出される
    
    NSString* selectedPrinterPrimaryKey; // 選択しているプリンターのキー
    
    BOOL isParseEnd;
    BOOL isEnd;                                 // 処理終了フラグ
    
    // プリンタが変更されたかどうかの判定関連
    //BOOL m_isShoudRemakeMenuButton;          // 再生成処理必要フラグ
    //NSString* m_strBeforeSelectedPrimaryKey;    // 前回使用していたプリンタのプライマリーキー
    
    ExAlertController	*m_pAlertCommProcess;      // プリンター情報取得中メッセージ表示用(プリントリリース、ステープル)
    
    // PictureViewのピッカー選択行の退避保持用
    NSInteger m_nSelPickerRowPrinter;
    NSInteger m_nSelPickerRowNum;
    NSInteger m_nSelPickerRowDuplex;
    NSInteger m_nSelPickerRowColor;
    NSInteger m_nSelPickerRowPaperSize;
    NSInteger m_nSelPickerRowPaperType;
    NSInteger m_nSelPickerRowPrintTarget;

}
@property (nonatomic,assign) BOOL m_isPrint;                       // 印刷実行フラグ
@property (nonatomic,assign) BOOL m_isVertical;                    // 縦/横フラグ
@property (nonatomic,strong) NSString *indicatingImagePath;        //今表示中の写真画像のパス
@property (nonatomic,strong) NSString* m_pstrRetention;  // 選択中のリテンション
@property (nonatomic,strong) NSString* m_pstrPrintRange;  // 選択中の印刷範囲

// 印刷対象
//@property (nonatomic,strong) NSString* m_pstrPrintTarget;  // 選択中の印刷対象
//@property (nonatomic,strong) NSString* m_pstrPrintTargetPJL;  // 選択中の印刷対象のPJLの値
@property (nonatomic, assign) BOOL showPrintTarget;         // 印刷対象表示フラグ
@property (nonatomic, assign) BOOL printAllSheetsOn;        // ブック全体

// 仕上げ
@property (nonatomic,assign) NSInteger nClosingRow;
@property (nonatomic,assign) NSInteger nStapleRow;
@property (nonatomic,assign) NSInteger nPunchRow;
@property (nonatomic,strong) NSString* pstrSelectedClosing;
@property (nonatomic,strong) NSString* pstrSelectedStaple;
@property (nonatomic,strong) NSString* pstrSelectedPunch;

// Nup
@property (nonatomic,assign) NSInteger nNupRow;
@property (nonatomic,assign) NSInteger nSeqRow;
@property (nonatomic,strong) NSString* pstrSelectedNUp;
@property (nonatomic,strong) NSString* pstrSelectedSeq;

//リテンション
@property (nonatomic,assign) BOOL initRetentionFlg;              // リテンション初期化フラグ
@property (nonatomic,assign) BOOL noPrintOn;                     // 印刷せずにホールドフラグ
@property (nonatomic,assign) BOOL authenticateOn;                // 認証フラグ
@property (nonatomic,strong) NSString* pstrPassword;             // パスワード

//プリントリリース
@property (nonatomic,assign) BOOL printReleaseOn;              // プリントリリース

@property (nonatomic,strong) NSString* m_pstrNumSets;    // 選択中の部数設定
@property (nonatomic,strong) NSString* m_pstrSide;       // 選択中の片面/両面設定
@property (nonatomic,strong) NSString* m_pstrPaperSize;  // 選択中の用紙サイズ
@property (nonatomic,strong) NSString* m_pstrPaperSizePJL;     // 選択中の用紙サイズのPJLの値
@property (nonatomic,strong) NSString *m_pstrPaperType;     // 選択中の用紙タイプ
@property (nonatomic,strong) NSString *m_pstrPaperTypePJL;  // 選択中の用紙タイプのPJLの値

@property (nonatomic,strong) NSString* m_pstrColorMode;  // 選択中のカラーモード
//@property (nonatomic,strong) NSString* m_stPjlFaileName;   // PJLファイル名

@property (nonatomic, unsafe_unretained) id delegate;

@property (nonatomic, strong) NSOutputStream* NetworkStream;
@property (nonatomic, strong) NSInputStream* FileStream;
@property (nonatomic, readonly) uint8_t* Buffer;
@property (nonatomic, assign) size_t BufferOffset;
@property (nonatomic, assign) size_t BufferLimit;

@property (nonatomic) BOOL IsSite;
@property (nonatomic) BOOL IsSiteTemp;
@property (nonatomic) BOOL IsCancel;
@property (nonatomic) BOOL IsStopSend;

@property (nonatomic, copy)NSString* PjlFileName;

@property (nonatomic,strong) UIDocumentInteractionController *m_diCtrl;

@property (nonatomic,strong) NSString* selectedPrinterPrimaryKey;

// FTP関連
// ファイル送信
- (NSInteger)StartSendFile:(NSString*)strFilePath;

// 送信中止
- (void)StopSendWithStatus:(NSString*)pstrStatus;
- (void)CreateDialogForStopSendWithStatus:(NSString *)pstrStatus;

- (void)getPictureFromPhotoLibrary;

// 印刷
-(void)doPrint;
// 利用可能なプリンターが存在しない場合のアラート作成
-(void)CreateNoPrinterAlert;
// バックグラウンド中に継続実行していた処理を終了
-(void)EndBackgroundTask;

// SNMP
- (void)doSnmp;
- (void)getMib;
- (void)getMibEnd;

//複数印刷対応
@property (nonatomic,strong) NSMutableArray *selectFileArray; /** 選択されたファイルの情報を格納*/
@property (nonatomic,strong) NSMutableArray *selectPictArray;
@property (nonatomic,assign) NSInteger currentNum;

//複数ファイル印刷中フラグ
@property (nonatomic,assign) BOOL isFirstPrint;/** １つ目のファイル*/
@property (nonatomic,assign) BOOL isNextPrint; /** ２つ目以降のファイル */
@property (nonatomic,assign) BOOL isLastPrint; /** 最後のファイル */


- (NSString *)MergeJpegToOutputfile;
- (NSString *)getPrintFilePath:(NSString *)SelFilePath;

@property (nonatomic,assign) BOOL hasEncryptionPdfData;
@property (nonatomic,assign) BOOL hasGeneralPdfData;//一般PDFかどうか(暗号化PDFは除く)
@property (nonatomic,assign) BOOL hasN_UpData;
@property (nonatomic,assign) BOOL hasOfficeData;//Officeファイル有無
@property (nonatomic,assign) BOOL hasExcelData;//Excelファイル有無
@property (nonatomic,assign) STAPLE staple;//STAPLE
@property (nonatomic,strong) PunchData *punchData;//パンチ情報
@property (nonatomic,assign) BOOL canPrintRelease;//プリントリリース有効
@property (nonatomic,assign) BOOL isAllEncryptionPDF;
@property (nonatomic,assign) BOOL isAllN_UpData; //選択されたファイルのすべてがN-UP可能であることを示すフラグ
@property (nonatomic,assign) BOOL isSingleData;
@property (nonatomic,assign) BOOL hasOriginalTiffData;
@property (nonatomic,strong) NSMutableArray *N_UpDataArray;
@property (nonatomic,strong) NSMutableArray *encryptionPdfDataArray;
@property (nonatomic,strong) NSMutableArray *pdfDataArray;
@property (nonatomic,strong) NSMutableArray *officeDataArray;
@property (nonatomic,assign) BOOL isN_UpSet; // N-UP オプションが選択されているかどうか(1-UPならNO)
@property (nonatomic,assign) BOOL isPrintRangeSet;
@property (nonatomic,assign) BOOL isRetentionSet;
@property (nonatomic,assign) BOOL isContinuePrint;
@property (nonatomic,assign) BOOL canPrint;
@property (nonatomic,assign) BOOL canPrintPDF;
@property (nonatomic,assign) BOOL canPrintOffice;
@property (nonatomic,assign) BOOL isOptionError;
@property (nonatomic,assign) BOOL isAddedPattern;
@property (nonatomic,assign) BOOL isCalledConnectCallBack;//コールバックが呼ばれたかどうかのフラグ

- (void)updateMenuAndDataArray;
- (void)checkMenuOptionStatus;
- (void)updatePrintData;

// 印刷前のチェック
- (void)CheckBeforePrinting;

/**
 * プリンタの能力情報（PCLオプション・PS拡張キット・Office対応有無を取得する
 * このメソッドを呼び出し後、canPrintPDFプロパティを読め。
 * @return プリンタとの通信に成功すればYES
 */
- (BOOL)checkPclPsOfficeOption;

-(void) showAttachmentMailView:(UIViewController*)attachmentViewController;

//- (void)paperSizeSelectAction;

// アプリケーション動作設定画面に設定中のリテンション設定で初期化する
- (void)initRetention;
// PDF印刷範囲拡張有効かどうかを確認する
- (void)checkPdfPrintRangeExpansionMode;
// 印刷範囲情報を作成する
- (PrintRangeSettingViewController*)makePrintRangeInfo;

- (NSInteger)getPrintReleaseValue;
- (NSInteger)getPrintTargetValue; //印刷対象PJL作成メソッド呼び出し時使用

// 指定されたボタンIDから該当するピッカーの選択行インデックスを返す
- (NSInteger)getSelPickerRowWithIndex:(enum PRINTER_SETTING_BUTTON)btnId;

// リテンション、プリントリリースボタンの活性非活性
- (void)setRetontionPrintReleaseBtnEnabled;

// ジョブ送信のタイムアウト(秒)を取得する
- (int)getJobTimeOut;

// 両面印刷ボタンの活性非活性
- (void)setDuplexBtnEnabled;

// プリンター情報取得処理がキャンセルされたときのボタン非活性処理
- (void)setBtnEnabledForCancelRsMng;

@end
