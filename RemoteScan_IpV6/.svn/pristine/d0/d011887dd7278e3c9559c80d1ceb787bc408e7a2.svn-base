
#import "TempData.h"


@implementation TempData
//
// アクセサメソッドの自動合成(ゲッターとセッターの役割)
//
@synthesize fname;									// 表示名称
@synthesize crdate;									// 作成日時
@synthesize imagename;								// 縮小画像ファイル名(png)
@synthesize index;									// インデック(作成年月)
@synthesize sectionNumber;							// 

//
// イニシャライザ定義
//
- (id)init
{
	LOG_METHOD;
	
    if ((self = [super init]) == nil)
	{
        return nil;
    }
	
	self.fname			= nil;
	self.crdate			= nil;
	self.imagename		= nil;
	self.index			= nil;
	
    return self;
}

//
// アプリケーションの終了直前に呼ばれるメソッド
//
- (void)dealloc
{
	LOG_METHOD;
	
    								// 親クラスの解放処理を呼び出す
}

@end
