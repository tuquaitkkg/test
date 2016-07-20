
#import <UIKit/UIKit.h>
#import "Define.h"
#import "RSCustomPaperSizeData.h"
#import "CustomPickerViewController.h"

enum{
    UNIT_TYPE_MILLIMETER,
    UNIT_TYPE_INCH,
};

enum{
    BTN_TAG_MILLIMETER,
    BTN_TAG_INCH,
    BTN_TAG_LOW_V,
    BTN_TAG_LOW_H,
};

@class RemoteScanBeforePictViewController;

@interface RSS_CustomSizeSettingViewController : UIViewController<UITextFieldDelegate>
{
    RemoteScanBeforePictViewController* __unsafe_unretained parentVCDelegate;
    
    CustomPickerViewController* pickerViewController;
    
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
    
    NSInteger m_nSelPicker;
    
    BOOL bEdit;         // カスタムサイズ編集のフラグ
    NSString* m_pstrName;
    
    NSInteger m_nSelPickerRowBefore;    // ピッカー表示時の選択行
    NSString* myCustomSizeKey;    // カスタムサイズキー
}

@property (nonatomic, unsafe_unretained) RemoteScanBeforePictViewController* parentVCDelegate;
@property (nonatomic, copy)		NSString		*baseDir;	// ホームディレクトリ/Documments/
@property (nonatomic) BOOL    bEdit;// カスタムサイズ編集のフラグ
@property (nonatomic, strong)	NSMutableArray	*pCustomDataList;
@property (nonatomic, strong)	RSCustomPaperSizeData	*m_pRsCustomPaperSizeData;
@property (nonatomic) NSInteger nSelectedRow;

- (id)initWithSettingName:(NSString*)name;
//- (id)initWithDelegate:(RemoteScanBeforePictViewController *)delegate;
- (IBAction)changedUnitTypeSegControl:(UISegmentedControl *)sender;

@end
