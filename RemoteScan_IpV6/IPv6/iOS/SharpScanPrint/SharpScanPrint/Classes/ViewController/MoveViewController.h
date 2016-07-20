
#import <UIKit/UIKit.h>
#import "SelectFileViewController.h"
#import "CommonManager.h"
#import "CreateFolderViewController.h"
#import "ScanFile.h"
#import "ScanDirectory.h"
#import "ScanFileUtility.h"
#import "ScanDirectoryUtility.h"
#import "TempAttachmentFiles.h"
#import "GeneralFileUtility.h"
#import "ExAlertController.h"

@protocol MoveViewControllerDelegate
-(void) move:(UIViewController*)viewController didMovedSuccess:(BOOL)bSuccess;
@end

@interface MoveViewController : UITableViewController <UIGestureRecognizerDelegate, CreateFolderViewControllerDelegate> {

    NSObject <MoveViewControllerDelegate> *__unsafe_unretained delegate;

    NSIndexPath             *m_IdexPath;//
	// インスタンス変数宣言
	//
    ScanDataManager			*manager;					// SCANマネージャクラス
	NSString				*baseDir;					// ホームディレクトリ/Documments/
    
    NSMutableArray          *mArray;
    BOOL                    alertFinished;
    BOOL                    cancelClick;
    
    UIBarButtonItem *cancelBtn;
    UIBarButtonItem *moveBtn;
    
    NSInteger               iErrCode;
    ScanDirectory           *scanDirectory;
}

//
// プロパティの宣言
//
@property (nonatomic, unsafe_unretained) id delegate;
@property (nonatomic, copy)		NSString		*baseDir;		// ホームディレクトリ/Documments/
@property (nonatomic, strong) NSMutableArray* HeaderShrinkStates;
@property (nonatomic, strong) NSMutableArray* beforeMoveArray;
@property (nonatomic, strong) NSMutableArray* beforeMoveName;
@property (nonatomic)			BOOL			isAttachment;

@property (nonatomic, strong) ScanDirectory *scanDirectory;
// セクションの折りたたみ、展開
- (void)shrinkRowInSection:(NSInteger)section;

// 画面遷移
- (void)MoveView:(NSIndexPath *)nIndexPath;

// 移動ファイルをチェック
- (NSInteger)CheckMoveFile;

// ファイル上書きチェック
- (NSInteger)CheckOverwriteFile:(NSMutableArray*)Array baseDirPath:(NSString*)baseDirPath;

// ファイル移動処理
-(NSInteger)fileMove:(NSString*)beforeMovePath baseDirPath:(NSString*)baseDirPath;

- (void)SetHeaderView;

@end
