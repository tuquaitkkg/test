
#import <UIKit/UIKit.h>
#import "PrintPictViewController.h"
#import "ScanFile.h"
#import "ScanFiles.h"
#import "ScanFileUtility.h"
#import "GeneralFileUtility.h"
#import "TempFileUtility.h"
#import "TempAttachmentFiles.h"

@protocol MultiPrintPictViewControllerDelegate <NSObject>
- (void)updatePrintFileArray:(NSArray *)editedFileArray;
- (void)updatePrintPictArray:(NSArray *)editedFileArray;
@end
@interface MultiPrintPictViewController : PrintPictViewController <UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,assign) BOOL isIndicatingError;
@property (nonatomic,strong) IBOutlet UITableView *tableView;
@property (nonatomic,strong) UIButton *addFileButton;
@property (nonatomic,strong) UIButton *editFileButton;
@property (nonatomic,assign) id <MultiPrintPictViewControllerDelegate> mppvcDelegate;

@end
