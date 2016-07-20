
#import <UIKit/UIKit.h>

@interface PickerModalBaseView : UIView

#define ANIMATION_DURATION_SEC 0.3

/** 表示させたいviewを追加。追加した順にorigin.yを自動的に設定してくれる。 追加されたviewの高さ分_containerViewの高さも増える*/
- (void)addView:(UIView*)view;

/** 表示させたいviewを追加。origin.yは指定のものを使う。 _containerViewの大きさは変更されない*/
- (void)addView:(UIView *)view frameOriginY:(CGFloat)y;

/** 表示 */
- (void)showInView:(UIView*)view animated:(BOOL)animated;

/** 消去 */
- (void)dismissAnimated:(BOOL)animated;

@end
