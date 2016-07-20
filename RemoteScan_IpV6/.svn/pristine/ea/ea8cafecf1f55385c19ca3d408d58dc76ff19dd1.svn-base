
#import <UIKit/UIKit.h>

@interface RootViewController : UITableViewController 
{
    BOOL                    m_bExitView;       //取り込みから遷移したからのフラグ
}

@property (nonatomic)   BOOL                isExit;		// 取り込みフラグ
@property (nonatomic, strong)   NSURL       *siteUrl;		// ファイル連携URL


// 画面遷移
- (void)MoveView:(NSIndexPath *)nIndexPath;
// ヘルプ画面をモーダル表示
- (IBAction)OnShowHelp;
// モーダル表示したヘルプ画面を閉じる
- (void)OnHelpClose;

@end
