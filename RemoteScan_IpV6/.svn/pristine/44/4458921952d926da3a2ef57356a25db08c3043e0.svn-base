
#ifdef _UIVIEWCONTROLLER_CONTENTSIZEFORVIEWINPOPOVER_H_
#import "UIViewController+ContentSizeForViewInPopover.h"
#endif

@implementation UIViewController (ContentSizeForViewInPopover)

#if defined(_UIVIEWCONTROLLER_CONTENTSIZEFORVIEWINPOPOVER_H_) && __IPHONE_OS_VERSION_MIN_REQUIRED >= __IPHONE_7_0

- (CGSize)contentSizeForViewInPopover
{
    return self.preferredContentSize;
}

- (void)setContentSizeForViewInPopover:(CGSize)size
{
    self.preferredContentSize = size;
}

#endif

@end
