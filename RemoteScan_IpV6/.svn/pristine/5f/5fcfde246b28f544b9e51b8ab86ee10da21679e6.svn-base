
#import <Foundation/Foundation.h>

@protocol PreviewPageDelegate 
- (void)PreviewPageDidZoom:(float) zoomScale;
@end

@interface PreviewPage : UIScrollView <UIScrollViewDelegate>
{
    UIImageView *imageView;
    id __unsafe_unretained zoomDelegate;
}

@property (nonatomic, unsafe_unretained) id zoomDelegate;

- (void)setImage:(NSString *)image;

@end
