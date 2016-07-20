
#import "PickerModalBaseView.h"
#import "CommonUtil.h"

@implementation PickerModalBaseView
{
    UIView* _containerView;
    CGFloat _temporaryY;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        [self configureSelf];
    }
    return self;
}

- (void)configureSelf
{
    self.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.7];
    _containerView = [[UIView alloc] initWithFrame:CGRectZero];
    if([[[UIDevice currentDevice]systemVersion]floatValue]<7)
    {//iOS6まで
        _containerView.backgroundColor = [UIColor blackColor];
    }
    else
    {//iOS7から
        _containerView.backgroundColor = [UIColor whiteColor];
    }
    
    [self addSubview:_containerView];
    _temporaryY = 0;
}

- (void)addView:(UIView*)view
{
    view = [CommonUtil setView:view frameOriginY:_temporaryY];
    [_containerView addSubview:view];
    _containerView.frame = CGRectMake(0, 0, self.frame.size.height, _temporaryY + view.frame.size.height);
    if([[[UIDevice currentDevice]systemVersion]floatValue] >= 7)
    {
        _temporaryY += view.frame.size.height + 1;
    }else{
        _temporaryY += view.frame.size.height;
    }
}

- (void)addView:(UIView *)view frameOriginY:(CGFloat)y
{
    view = [CommonUtil setView:view frameOriginY:y];
    [_containerView addSubview:view];
}

- (void)showInView:(UIView*)view animated:(BOOL)animated
{
    if(animated)
    {
        CGRect rect =  _containerView.frame;
        rect.origin.y = view.frame.size.height;
        _containerView.frame = rect;
        [view addSubview:self];
        [UIView animateWithDuration:ANIMATION_DURATION_SEC
                         animations:^{
                             CGRect rect = _containerView.frame;
                             rect.origin.y = view.frame.size.height - rect.size.height;
                             _containerView.frame = rect;
                         }];
    }
    else
    {
        CGRect rect = _containerView.frame;
        rect.origin.y = view.frame.size.height - rect.size.height;
        _containerView.frame = rect;
        [view addSubview:self];
    }
}

- (void)dismissAnimated:(BOOL)animated
{
    UIView* superV = self.superview;
    
    if(animated)
    {
        CGRect rect = _containerView.frame;
        rect.origin.y = superV.frame.size.height;
        [UIView animateWithDuration:ANIMATION_DURATION_SEC animations:^{
             _containerView.frame = rect;
        } completion:^(BOOL finished) {
            if(finished)
            {
                [self removeFromSuperview];
            }
        }];
    }
    else
    {
        [self removeFromSuperview];
    }
    
    
}


/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
