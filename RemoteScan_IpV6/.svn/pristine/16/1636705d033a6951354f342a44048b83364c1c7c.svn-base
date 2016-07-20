
#import <UIKit/UIKit.h>

@protocol MultiPrintTableViewControllerDelegate <NSObject>
- (void)updatePrintFileArray:(NSMutableArray *)editedFileArray;
- (void)updatePrintPictArray:(NSMutableArray *)editedFileArray;
@end

@interface MultiPrintTableViewController_iPad : UITableViewController

@property (nonatomic,strong) NSMutableArray *selectFileArray;
@property (nonatomic,strong) NSMutableArray *selectPictArray;

// 遷移元画面ID
@property (nonatomic,assign) PrintPictViewID PrintPictViewID;
@property (nonatomic,assign) id <MultiPrintTableViewControllerDelegate> delegate;

@property (nonatomic, assign) BOOL isDuringCommProcess;     // プリンタ情報取得中フラグ - プリンタ情報取得キャンセル対応

- (void) dismissMenuPopOver:(BOOL)bAnimated;

@end
