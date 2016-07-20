
#import <Foundation/Foundation.h>
#import <QuartzCore/QuartzCore.h>
#import "PreviewPage.h"

@interface PreviewScrollViewManager : NSObject <UIScrollViewDelegate, PreviewPageDelegate>
{
    NSInteger currentPage;
    NSInteger totalPage;
    
    NSArray* arrThumbnails;
    
    PreviewPage* prevPage;
    PreviewPage* currPage;
    PreviewPage* nextPage;
    
    UIScrollView* m_pPreviewScrollView;
    
    UILabel* m_plblPageNum;
}

-(id)initWithPicturePaths:(NSArray*) filePaths ScrollView:(UIScrollView*) scrollView;
-(void)pageLoad:(UIScrollView *)scrollView;
-(void)adjustCurrentPage;
-(void)rotate;
-(NSInteger)getCurrentPage;

@property (nonatomic,strong) UIScrollView* m_pPreviewScrollView;
@property (nonatomic,strong) UILabel* m_plblPageNum;
@property (nonatomic,assign) NSInteger currentPage;

- (void)resetPage;

@end
