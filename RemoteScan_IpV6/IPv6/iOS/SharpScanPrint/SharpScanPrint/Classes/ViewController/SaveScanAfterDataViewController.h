
#import <UIKit/UIKit.h>
#import "SelectFileViewController.h"
#import "CommonManager.h"
#import "CreateFolderViewController.h"
#import "TempFile.h"
#import "TempFileUtility.h"
#import "ScanFileUtility.h"

@interface SaveScanAfterDataViewController : UITableViewController <UIGestureRecognizerDelegate, CreateFolderViewControllerDelegate> {
    NSIndexPath             *m_IdexPath;//
	// インスタンス変数宣言
	//
    ScanDataManager			*manager;					// SCANマネージャクラス
	NSString				*baseDir;					// ホームディレクトリ/Documments/
    NSString                *subDir;
    NSString                *rootDir;
    
    NSMutableArray          *mArray;
    BOOL                    alertFinished;
    BOOL                    cancelClick;
    
    NSUserDefaults          *savePath;
    
    UIBarButtonItem *cancelBtn;
    UIBarButtonItem *saveBtn;
    
    NSString                *renamedName;                // リネームした名前
}

//
// プロパティの宣言
//
@property (nonatomic, copy)		NSString		*baseDir;		// ホームディレクトリ/Documments/
@property (nonatomic, copy)     NSString        *subDir;
@property (nonatomic, copy)     NSString        *rootDir;
@property (nonatomic, copy)     NSString        *beforeDir;
@property (nonatomic, strong) NSMutableArray* HeaderShrinkStates;
@property (nonatomic, strong) NSMutableArray* beforeMoveArray;
@property (nonatomic, strong) NSMutableArray* beforeMoveName;
@property (nonatomic)			BOOL			bScanAfter;
@property (nonatomic, strong)   NSString        *renamedName;
@property (nonatomic, strong)   TempFile * tempFile;

// セクションの折りたたみ、展開
- (void)shrinkRowInSection:(NSInteger)section;

// 画面遷移
- (void)MoveView:(NSIndexPath *)nIndexPath;

//// 前回保存した階層まで直接移動する
- (void)DirectMoveView;

// モーダル表示した画面を閉じる
- (void)OnClose;

- (void)SetHeaderView;

// ファイルを保存する
- (void)saveAction:(id)sender;
// TempFileから保存する
- (BOOL)copyTempData:(TempDataManager*)tempManager;
// 保存中のファイルと重複しないファイル名(ファイルパス)を取得する
- (NSMutableArray*) getTargetFilePathArray:(TempDataManager*)tempManager isError:(BOOL*)isError;

@end
