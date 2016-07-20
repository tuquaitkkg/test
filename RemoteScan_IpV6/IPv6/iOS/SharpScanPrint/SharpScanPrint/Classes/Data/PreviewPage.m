
#import "PreviewPage.h"

NSInteger m_nRotateNum = 0;

@implementation PreviewPage

@synthesize zoomDelegate;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        imageView = [[UIImageView alloc] initWithFrame:self.bounds];
        imageView.contentMode = UIViewContentModeScaleAspectFit;
        [self addSubview:imageView];        
        
        self.delegate = self;
        self.minimumZoomScale = 1.0;
        self.maximumZoomScale = 2.0;
    }
    return self;
}

- (void)adjustScrollView:(BOOL)animate {
	[self setZoomScale:self.minimumZoomScale animated:animate];
}

- (void)setImage:(NSString *)imagePath {
    float scale = self.zoomScale;
    
    [self adjustScrollView:NO];
    imageView.frame = self.bounds;
    imageView.image = [UIImage imageWithContentsOfFile:imagePath];
    [self setZoomScale:scale];
    
}

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView {
	return imageView;
}

- (void)scrollViewDidZoom:(UIScrollView *)scrollView
{
    imageView.frame = (CGRect){0,0,self.contentSize};

    if (zoomDelegate) {
        [zoomDelegate PreviewPageDidZoom:self.zoomScale];
    }
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
	UITouch *touch = [touches anyObject];
	if ([touch tapCount] >1) {
        if(self.zoomScale != self.minimumZoomScale)
        {
            [self adjustScrollView:YES];            
        }
        else
        {
            [UIView beginAnimations:nil context:nil];
            [UIView setAnimationDuration:0.4];
            
            [self setZoomScale:self.maximumZoomScale];
            
            [UIView commitAnimations];
        }
	}
}


@end
