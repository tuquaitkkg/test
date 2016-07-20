#import <Foundation/Foundation.h>
//#import "QuartzCore/CALayer.h"

@interface TempData : NSObject
{
	//
	// インスタンス変数宣言
	//
    NSString	*fname;									// 表示名称
    NSString	*crdate;								// 作成日時
    NSString	*imagename;								// 縮小画像ファイル名(png)
    NSString	*index;									// インデック(作成年月)
    NSInteger	sectionNumber;							// 
}

//
// プロパティの宣言
//
@property (nonatomic, copy)		NSString	*fname;				// 表示名称
@property (nonatomic, copy)		NSString	*crdate;			// 作成日時
@property (nonatomic, copy)		NSString	*imagename;			// 縮小画像ファイル名(png)
@property (nonatomic, copy)		NSString	*index;				// インデック(作成年月)
@property (nonatomic)			NSInteger	sectionNumber;

@end
