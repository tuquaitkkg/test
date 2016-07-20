
#import <UIKit/UIKit.h>
#import "AttachmentDataManager.h"
#import "SSZipArchive.h"
#import "ScanDataManager.h"
#import "TempAttachmentDirectory.h"
#import "TempAttachmentFileUtility.h"
#import "ScanFileUtility.h"

@protocol AttachmentMailViewControllerDelegate_iPad
-(void) mailAttachmentPrint:(UITableViewController*)viewController upLoadMailView:(NSString*)strFilePath;
- (NSInteger *) getArrThumbnailsCount;

@end

@interface AttachmentMailViewController_iPad : UITableViewController<UIWebViewDelegate>
{
    NSObject <AttachmentMailViewControllerDelegate_iPad> *__unsafe_unretained delegate;
    AttachmentDataManager* m_pScanMgr;                // AttachmentDataManagerクラス
    NSString                *rootShowDir;
    NSString                *zipPath;          //解凍するzipファイルのパス
    NSString                *destinationPath;  //解凍したファイルを置く場所
    NSString                *encryptPW;        //暗号化パスワード
    UITextField             *textField;
    UIBarButtonItem         *editBtn;
    UIBarButtonItem         *saveBtn;
    UIBarButtonItem         *printBtn;
    NSMutableArray          *mArray;
    BOOL                    isClose;
    NSMutableArray          *mAllArray;
    
    NSIndexPath             *selectIndexPath;
    TempAttachmentDirectory *attachmentDirectory;
}

@property (nonatomic, unsafe_unretained)   id              delegate;
@property (nonatomic, copy)     NSString        *rootShowDir;
@property (nonatomic, copy)     NSString        *zipPath;
@property (nonatomic, copy)     NSString        *destinationPath;
@property (nonatomic, copy)     NSString        *encryptPW;
@property (nonatomic,strong)    TempAttachmentDirectory  *attachmentDirectory;
@property (nonatomic, copy)     NSString        *printFilePath;

// 複数印刷対応
@property (nonatomic,assign) BOOL fromSelectFileVC;
@property (nonatomic,assign) BOOL pushFlag;
@property (nonatomic,strong) NSMutableArray *selectFilePathArray;

@property (nonatomic,assign) BOOL multiPrintFlag;

// 画面遷移
- (void)MoveView:(NSIndexPath *)nIndexPath;

@end
