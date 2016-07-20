
#import <Foundation/Foundation.h>
#import "CommonUtil.h"
#import "ProfileDataManager.h"
#import "PrintRangeSettingViewController.h"

@interface PJLDataManager : NSObject
{
    NSString* m_pstrBaseDir;    // ホームディレクトリ/Documments/
    ProfileDataManager      *profileDataManager;
    NSString* pstrSpoolKey;
}

@property (nonatomic, copy) NSString* BaseDir;


// PJLData作成
- (NSString*)CreatePJLData:(NSInteger)nNumOfSets     // 部数
                      Side:(NSInteger)nSide          // 片面/両面
                 ColorMode:(NSInteger)nColormode     // カラーモード
                 PaperSize:(NSString*)pstrPapersize     // 用紙サイズ
                 PaperType:(NSString*)pstrPapertype     // 用紙タイプ
               Orientation:(NSInteger)nOrientation           // 印刷の向き
            PrintRangeInfo:(PrintRangeSettingViewController*)printRangeInfo   // 印刷範囲情報
               PrintTarget:(NSInteger)printTarget               // 印刷対象
             RetentionHold:(BOOL)bRetentionHold                 // リテンション(ホールドする/しない)
             RetentionAuth:(BOOL)bRetentionAuth                 // リテンション(認証 あり/なし)
         RetentionPassword:(NSString*)pstrRetentionPassword     // リテンション(パスワード)
                 Finishing:(STAPLE)staple               // 仕上げ(ステープル対応/非対応)
                ClosingRow:(NSInteger)nClosingRow       // とじ位置(左とじ/右とじ/上とじ)
                    Staple:(NSString*)pstrStaple    // ステープル(なし/1箇所とじ/2箇所とじ/針なしステープル)
                  CanPunch:(PunchData*)punchData        // パンチ可否
                     Punch:(NSString*)pstrPunch         // パンチ(2穴/3穴/4穴/4穴(幅広))
                    NupRow:(NSInteger)nNupRow        // N-Up(1-Up/2-Up/4-Up)
                    SeqRow:(NSInteger)nSeqRow        // 順序
                IsVertical:(BOOL)isVertical          // 縦/横フラグ
                  FilePath:(NSString*)pstrFilePath   // 送信ファイルパス
                   JobName:(NSString*)pstrJobname   // ジョブ名
              PrintRelease:(NSInteger)printRelease; // プリントリリース

// PJLヘッダ作成
- (NSString*)CreatePJLHeader:(NSString*)pstrFileName   // ファイル名
                   NumOfSets:(NSInteger)nNumOfSets     // 部数
                        Side:(NSInteger)nSide          // 片面/両面
                   ColorMode:(NSInteger)nColormode     // カラーモード
                   PaperSize:(NSString*)pstrPapersize     // 用紙サイズ
                   PaperType:(NSString*)pstrPapertype       // 用紙タイプ
                 Orientation:(NSInteger)nOrientation           // 印刷の向き
              PrintRangeInfo:(PrintRangeSettingViewController*)printRangeInfo   // 印刷範囲情報
                 PrintTarget:(NSInteger)printTarget                 // 印刷対象
               RetentionHold:(BOOL)bRetentionHold                 // リテンション(ホールドする/しない)
               RetentionAuth:(BOOL)bRetentionAuth                 // リテンション(認証 あり/なし)
           RetentionPassword:(NSString*)pstrRetentionPassword     // リテンション(パスワード)
                   Finishing:(STAPLE)staple               // 仕上げ(ステープル対応/非対応)
                  ClosingRow:(NSInteger)nClosingRow       // とじ位置(左とじ/右とじ/上とじ)
                      Staple:(NSString*)pstrStaple        // ステープル(なし/1箇所とじ/2箇所とじ/針なしステープル)
                    CanPunch:(PunchData*)punchData        // パンチ可否
                       Punch:(NSString*)pstrPunch         // パンチ(2穴/3穴/4穴/4穴(幅広))
                      NupRow:(NSInteger)nNupRow        // N-Up(1-Up/2-Up/4-Up)
                      SeqRow:(NSInteger)nSeqRow        // 順序
                  IsVertical:(BOOL)isVertical          // 縦/横フラグ
                pstrFilePath:(NSString*)pstrFilePath   //ファイルパス
                PrintRelease:(NSInteger)printRelease;  //プリントリリース
// PJLフッタ作成
- (NSString*)CreatePJLFooter:(NSString*)pstrFileName;   //ファイル名

// 片面/両面設定取得
- (NSString*)GetDuplexSetting:(NSInteger)nSide;     // 片面/両面

// とじ位置の取得
- (NSString*)GetBindingSetting:(NSInteger)nSide ClosingRow:(NSInteger)nClosingRow;

// ステープルの取得
//- (NSString*)GetStapleSetting:(NSInteger)nStapleRow;
- (NSString*)GetStapleSetting:(NSString*)pstrStaple;

// カラーモード取得
- (NSString*)GetColormodeSetting:(NSInteger)nColormode; // カラーモード

// レンダーモード取得
- (NSString*)GetRendermodeSetting:(NSInteger)nColormode // レンダーモード
                  HighQuarityMode:(BOOL)bHighQuarityMode; // 高品質印刷

// 印刷範囲取得
- (NSString*)GetPrintRangeSetting:(PrintRangeSettingViewController*)printRangeInfo; // 印刷範囲情報

@end
