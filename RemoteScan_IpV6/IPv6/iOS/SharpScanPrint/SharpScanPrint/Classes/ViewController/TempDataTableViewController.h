
#import <UIKit/UIKit.h>
#import "TempDataManager.h"
#import "CommonUtil.h"
#import "ScanAfterPreViewController.h"
#import "ScanBeforePictViewController.h"
#import "TempFile.h"
#import "Define.h"
#import "RootViewController.h"

@interface TempDataTableViewController : UITableViewController {
    
    TempDataManager			*tempManager;					// MFPデータ操作Manager
    NSString				*baseDir;					// ホームディレクトリ/Documments/
    BOOL                    m_bScanView;       //取り込みから遷移したからのフラグ

    UIBarButtonItem         *shareBtn;  // 複数ファイル共有ボタン
}
//
// プロパティの宣言
//
@property (nonatomic, copy)		NSString			*baseDir;		// ホームディレクトリ/Documments/
@property (nonatomic)BOOL                isScan;		// 取り込みフラグ
@property (nonatomic,strong) TempFile *tempFile;



//
// メソッドの宣言
//
- (IBAction)dosave:(id)sender;										// [保存]ボタン処理
- (IBAction)doCancel:(id)sender;										// [キャンセル]ボタン処理
// モーダル表示した画面を閉じ、TOPに戻る
- (void)OnClose;
// モーダル表示した画面を閉じる
- (void)OnCancel;
// 画面遷移
- (void)MoveView:(NSIndexPath *)nIndexPath;

@end
