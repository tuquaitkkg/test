#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
#import "CommonUtil.h"
#import "PdfManager.h"
#import "ImageProcessing.h"

#define PING_DIR	@"PINGFILE"
#define PING_EXT	@"png"

@interface CommonManager : NSObject
{
	//
	// インスタンス変数宣言
	//
	NSString				*baseDir;				// ホームディレクトリ/Documments/
	int						savingImag_cmpFlg;		// 写真フォルダに保存・完了フラグ
}

//
// プロパティの宣言
//
@property (nonatomic, copy)	NSString	*baseDir;	// ホームディレクトリ/Documments/


//
// メソッドの宣言
//
- (void) myrunLoop:(uint)delayTime;					// ランループの実行

// PDFサイズをチェックし、1ページ目の画像を生成
- (NSInteger)checkPdfSize:(NSString *)filePath
            firstPage:(UIImage**)image;
// PDFサイズをチェックし、1ページ目の画像を指定サイズで生成　(サイズ未指定の場合はオリジナルのサイズで生成)
-(NSInteger)checkPdfSize:(NSString *)filePath
               firstPage:(UIImage**)image width:(int)width height:(int)height;

// PDFサイズをチェックする。1ページ目の画像を生成しない
- (NSInteger)checkPdfSize:(NSString *)filePath;
// PDFサイズをチェックする。1ページ目の画像を生成しない　(サイズ未指定の場合はオリジナルのサイズで生成)
-(NSInteger)checkPdfSize:(NSString *)filePath
                   width:(int)width height:(int)height;

// PDFに埋め込まれている画像の情報を取得（引数：CGPDFDocumentRef、　抽出したいタグ名）
-(BOOL)getPDFInfo:(CGPDFDocumentRef)document withTag:(NSString *)tagString withKey:(NSString *)keyString;

// PDFがシャープ製かどうかチェックする
- (BOOL)checkPdfBySharp:(NSString *)filePath;

// PDFに埋め込まれている画像のピクセルサイズを取得
- (CGFloat)getImageSizeToPDF:(CGPDFDocumentRef)document;

// ファイルに保存(ディレクトリ固定)
- (BOOL) saveFile:  (NSData*)data fileName:(NSString*)fname saveDir:(NSString *)saveDir;	

// ファイルに保存(Tempフォルダ固定)
- (NSString*) saveTempFile:(NSData*)data fileName:(NSString*)strFilename;
// ファイル削除
- (BOOL)removeTempFile:(NSString*)strFilename;

- (BOOL) removeFile:(NSString*)fileName;			// ファイル削除

- (BOOL)moveFile:(NSString*)strFromFilename :(NSString*)strToFilename; // ファイル移動
- (BOOL)copyFile:(NSString*)strFromFilename :(NSString*)strToFilename; // ファイルコピー
- (BOOL) makeDir:   (NSString*)dirName saveDir:(NSString *)saveDir;				// ディレクトリの生成
- (BOOL) existsFile:(NSString*)fileName;			// ファイル・ディレクトリが存在するか
- (BOOL) existsFile:(NSString*)fileName :(NSString*)filePath;//ファイル・ディレクトリが存在するかチェック(パス指定)
// PDFの構造解析処理
void ListDictionaryObjects (const char *key, CGPDFObjectRef object, void *info);

// キャッシュファイルの作成
- (BOOL)createCacheFile:(NSString*)dirPath filename:(NSString*)scanFilename;
// キャッシュファイルの作成(Web,Email用)
- (BOOL)createCacheFile2:(NSString*)dirPath filename:(NSString*)scanFilename;

- (BOOL)pdfToJpg:(NSString*)sScanFilePath dirPath:(NSString*)sDirPath isThumbnail:(BOOL)bThumbnail;

- (BOOL)existsCacheDirByScanFilePath:(NSString*)filePath;
- (BOOL)existsPrintFilePathByScanFilePath:(NSString*)filePath;

// ボタンのフォントサイズが小さい場合は二段表示にするか判定する
- (int)changeBtnFontSize:(NSString*)lblNameText;

// ボタンを2行表示するかチェック
-(void)btnTwoLineChange:(UIButton*)btnName;

// Web,Email印刷用ページ削除時 フォルダ内の画像ファイルをリネームする
- (void)renamingInFilepath:(NSString*)filePath;


@end

