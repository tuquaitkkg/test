
#import "ScanData.h"
#import "Define.h"
#import "CommonUtil.h"
#import <limits.h>


@implementation ScanData

//
// アクセサメソッドの自動合成(ゲッターとセッターの役割)
//
@synthesize fname;									// 表示名称
@synthesize crdate;									// 作成日時
@synthesize imagename;								// 縮小画像ファイル名(png)
@synthesize index;									// インデック(作成年月)
@synthesize sectionNumber;							// 
@synthesize crdate_yymm;							// 作成年月(グループ化用)
@synthesize crdate_yymmdd;							// 作成年月日(検索用)
@synthesize filesize;								// ファイルサイズ
@synthesize isDirectory;                            // ディレクトリの判別
@synthesize fpath;

//
// イニシャライザ定義
//
- (id)init
{
	//LOG_METHOD;
	
    if ((self = [super init]) == nil)
	{
        return nil;
    }
	
	self.fname			= nil;
	self.crdate			= nil;
	self.imagename		= nil;
	self.index			= nil;
	self.crdate_yymm	= nil;
    self.crdate_yymmdd	= nil;
	self.filesize       = nil;
    self.fpath          = nil;
    return self;
}

//
// アプリケーションの終了直前に呼ばれるメソッド
//
- (void)dealloc
{
	//LOG_METHOD;
	
    								// 親クラスの解放処理を呼び出す
}

- (NSString*)fileSizeUnit
{
    NSString *byteStr = S_UNIT_BYTE;
    float fSize = [self.filesize floatValue];
    int    bytecnt = 0;
    while (fSize > 1024) {
        fSize = fSize / 1024;
        bytecnt++;
    }
    switch (bytecnt) {
        case 0:
            break;
        case 1:
            byteStr = S_UNIT_KB;
            break;
        case 2:
            byteStr = S_UNIT_MB;
            break;
        default:
            byteStr = S_UNIT_GB;
            break;
    }
    return [byteStr copy];
}

- (NSString*)fileSizeAbout
{
    NSString *byteStr = S_UNIT_BYTE;
    float fSize = [self.filesize floatValue];
    int    bytecnt = 0;
    while (fSize > 1024) {
        fSize = fSize / 1024;
        bytecnt++;
    }
    switch (bytecnt) {
        case 0:
            break;
        case 1:
            byteStr = S_UNIT_KB;
            break;
        case 2:
            byteStr = S_UNIT_MB;
            break;
        default:
            byteStr = S_UNIT_GB;
            break;
    }
    return [NSString stringWithFormat:@"%.1f %@", fSize, byteStr];
}

- (NSString*)fileType;
{
    NSString *filetype = @"unknown";
    // pdfファイルチェック
    if([CommonUtil pdfExtensionCheck: self.fname])
    {
        filetype = @"PDF";
    }
    // tiffファイルチェック
    else if([CommonUtil tiffExtensionCheck: self.fname])
    {
        filetype = @"TIFF";
    }
    // jpegファイルチェック
    else if([CommonUtil jpegExtensionCheck: self.fname])
    {
        filetype = @"JPEG";
    }
    // pngファイルチェック
    else if([CommonUtil pngExtensionCheck: self.fname])
    {
        filetype = @"PNG";
    }
    // WORDファイルチェック
    else if ([CommonUtil wordExtensionCheck:self.fname])
    {
        filetype = @"DOCX";
    }
    // EXCELファイルチェック
    else if ([CommonUtil excelExtensionCheck:self.fname])
    {
        filetype = @"XLSX";
    }
    // POWERPOINTファイルチェック
    else if ([CommonUtil powerpointExtensionCheck:self.fname])
    {
        filetype = @"PPTX";
    }
    else
    {
        filetype = @"UNKNOWN";
    }
    return [filetype copy];
}

- (NSInteger)fileTypeNumber
{
    NSInteger filetypenumber = NSIntegerMax;
    // pdfファイルチェック
    if([CommonUtil pdfExtensionCheck: self.fname])
    {
        filetypenumber = 1;
    }
    // tiffファイルチェック
    else if([CommonUtil tiffExtensionCheck: self.fname])
    {
        filetypenumber = 2;
    }
    // jpegファイルチェック
    else if([CommonUtil jpegExtensionCheck: self.fname])
    {
        filetypenumber = 3;
    }
    // pngファイルチェック
    else if([CommonUtil pngExtensionCheck: self.fname])
    {
        filetypenumber = 4;
    }
    // wordファイルチェック
    else if([CommonUtil wordExtensionCheck: self.fname])
    {
        filetypenumber = 5;
    }
    // excelファイルチェック
    else if([CommonUtil excelExtensionCheck: self.fname])
    {
        filetypenumber = 6;
    }
    // powerpointファイルチェック
    else if([CommonUtil powerpointExtensionCheck: self.fname])
    {
        filetypenumber = 7;
    }

    else
    {
        filetypenumber = NSIntegerMax;
    }
    return filetypenumber;
}
#import "Define.h"
#import "CommonUtil.h"
#import <limits.h>

@end
