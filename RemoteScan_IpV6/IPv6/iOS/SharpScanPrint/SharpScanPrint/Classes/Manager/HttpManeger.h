#import <Foundation/Foundation.h>

#define POST_ADD_NST	@"addressentry_desktop_nst.html"        // プロファイル登録
#define POST_ADD_HTML	@"addressentry_desktop.html"            // プロファイル登録
#define POST_MOD_NST	@"addressentry_desktop_nst_edit.html"	// プロファイル更新
#define POST_DEL_NST	@"addressdelete_nst.html"               // プロファイル削除
#define POST_TIMEOUT 20.0                                       // タイムアウト時間(mm sec)


enum  HTTP_POST_MODE
{
	HTTP_POST_ADD = 1,				// プロファイル登録
	HTTP_POST_MOD,					// プロファイル更新
	HTTP_POST_DEL					// プロファイル削除
};

enum  HTTP_USERA_MODE
{
	HTTP_USERA_INVALID = 0,			// 無効
	HTTP_USERA_VALID				// 有効
};

@interface HttpManeger : NSObject
{
	//
	// インスタンス変数宣言
	//	
	NSString		*myname;		// 宛先名（必須）	ggt_textbox(4)	(表示名)
	NSString		*user;			// ユーザ名		ggt_textbox(16)	(ユーザ名)
	NSString		*password;		// パスワード		ggt_textbox(17)	(パスワード)
	NSString		*format;		// ファイル形式	ggt_select(12)	(画像フォーマット)
	NSString		*serchStr;		// 検索文字（必須）	ggt_textbox(5)	(検索文字列)
	NSString		*ipAder;		// IPアドレス		ggt_textbox(9)	(IPアドレス)
	NSString		*mfpipAder;		// IPアドレス
	
	NSURLConnection		*urlconnection;				// 
	int					postMode;					// 1:登録/2:更新/3:削除
	NSMutableData		*receivedData;				// 受信データ
	NSMutableDictionary	*notificationData;			// 通知データ
	NSTimer				*tm;						// タイマー
	NSString			*errMsg;					// エラー内容
	int					userAuthen;					// ユーザ認証(0:無効/1:有効)
}
//
// プロパティの宣言
//
@property (nonatomic, copy) NSString	*myname;	// 宛先名（必須）
@property (nonatomic, copy) NSString	*user;		// ユーザ名
@property (nonatomic, copy) NSString	*password;	// パスワード
@property (nonatomic, copy) NSString	*format;	// ファイル形式
@property (nonatomic, copy) NSString	*serchStr;	// 検索文字（必須）
@property (nonatomic, copy) NSString	*ipAder;	// IPアドレス
@property (nonatomic, copy) NSString	*mfpipAder;	// MFP IPアドレス
@property (nonatomic, copy) NSString	*errMsg;	// エラー内容

//
// メソッドの宣言
//
- (void) addPostRequest:(int) userAuthentication;		// 登録(1)
- (void) modPostRequest;								// 更新(2)
- (void) delPostRequest;								// 削除(3)
- (void) makePostData:(NSMutableURLRequest *)request;

- (int) responceDataJudge_add;							// 登録(1) 結果判定
- (int) responceDataJudge_title:(NSString *)strData;	// 登録(1) 結果判定(タイトル)
- (int) responceDataJudge_mod;							// 更新(2) 結果判定（未使用）
- (int) responceDataJudge_del;							// 削除(3) 結果判定

- (NSString *)stringByURLEncoding:(NSString *)originalString;	// URLエンコード
- (int) getHttpErrNO:(NSString*)orgData;						// エラー番号取得

#pragma mark NOTIFICATIONS
- (void)callHttpAddResponceNotification   : (NSMutableDictionary *)aDictionary;	// 通知：プロファイル登録
- (void)callHttpModResponceNotification   : (NSMutableDictionary *)aDictionary;	// 通知：プロファイル更新
- (void)callHttpDelResponceNotification   : (NSMutableDictionary *)aDictionary;	// 通知：プロファイル削除
- (void)callHttpInternalErrorNotification : (NSMutableDictionary *)aDictionary;	// 通知：ネットワークエラー

@end




