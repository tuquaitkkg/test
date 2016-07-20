
#import <UIKit/UIKit.h>
#import "Define.h"
#import "RSCustomPaperSizeData.h"

enum{
    UNIT_TYPE_MILLIMETER_IPAD,
    UNIT_TYPE_INCH_IPAD,
};

enum{
    BTN_TAG_MILLIMETER_IPAD,
    BTN_TAG_INCH_IPAD,
    BTN_TAG_LOW_V_IPAD,
    BTN_TAG_LOW_H_IPAD,
};

// カスタムサイズ用オブジェクト
@interface CustomSizeObject : NSObject
{
    NSString* name;     // 設定名
    int unit;           // タイプ(UNIT_TYPE_MILLIMETER, UNIT_TYPE_INCH)
    int v, h;           // 幅, 高さ
    int low_v, low_h;   // 0 〜 7
    NSArray* inchLowStr;
}
@property (nonatomic, strong) NSString* name;
@property (nonatomic) int unit, v, h, low_v, low_h;
-(id)initWithString:(NSString*)str;
-(NSString*)outputString;
@end



@class RemoteScanBeforePictViewController_iPad;

@interface RSS_CustomSizeSettingViewController_iPad : UIViewController <UIPickerViewDelegate, UIPopoverControllerDelegate>
{
    RemoteScanBeforePictViewController_iPad* __unsafe_unretained parentVCDelegate;

    IBOutlet UITableView *customSizeSettingTableView;
    IBOutlet UISegmentedControl *unitTypeSeg;

    UITextField* nameTextField;         // 名称
    int nMillimeter_V, nMillimeter_H;   // 25x25 〜 297x432
    
    UIButton* m_pBtnSizeMillimeter;         // サイズ（ミリ単位設定時)
    UIButton* m_pBtnSizeInch;               // サイズ（インチ単位設定時)
    
    int nInchHigh_V, nInchHigh_H;       // 1x1 〜 11(5/8)x17
    NSUInteger nInchLow_V, nInchLow_H;         // 0 〜 7
    NSArray* inchLowText;

    int nUnitType;   // UNIT_TYPE_MILLIMETER:ミリ単位設定　UNIT_TYPE_INCH:インチ単位設定
    
    UIPopoverController* m_popOver;
    NSInteger m_nSelPicker;
      
    BOOL bEdit;         // カスタムサイズ編集のフラグ
    NSString* m_pstrName;
    
    NSString* myCustomSizeKey;    // カスタムサイズキー

}

@property (nonatomic, unsafe_unretained) RemoteScanBeforePictViewController_iPad* parentVCDelegate;
@property (nonatomic, copy)		NSString		*baseDir;	// ホームディレクトリ/Documments/
@property (nonatomic)   BOOL    bEdit;// カスタムサイズ編集のフラグ
@property (nonatomic, strong)	NSMutableArray	*pCustomDataList;
@property (nonatomic, strong)	RSCustomPaperSizeData	*m_pRsCustomPaperSizeData;
@property (nonatomic) NSInteger nSelectedRow;

- (id)initWithSettingName:(NSString*)name;
- (IBAction)changedUnitTypeSegControl:(UISegmentedControl *)sender;

- (void)setPortraitMenu:(UIBarButtonItem *)barButtonItem;

@end

