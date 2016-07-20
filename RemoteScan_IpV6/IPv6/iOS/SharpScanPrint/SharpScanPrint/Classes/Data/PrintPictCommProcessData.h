#import <Foundation/Foundation.h>
#import "PrinterDataManager.h"
#import "PunchData.h"

@interface PrintPictCommProcessData : NSObject

//@property (nonatomic, strong) NSOperationQueue *queue;
@property (nonatomic, assign) STAPLE *staple;
@property (nonatomic, strong) PunchData *punchData;
@property (nonatomic, assign) BOOL canPrintRelease;
//@property (nonatomic, strong) PrinterData *printerData;
@property (nonatomic, assign) NSInteger selPrinterPickerRow;

@end
