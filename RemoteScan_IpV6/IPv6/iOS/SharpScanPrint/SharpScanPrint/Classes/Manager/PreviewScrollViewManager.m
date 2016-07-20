
#import "PreviewScrollViewManager.h"

@implementation PreviewScrollViewManager

@synthesize m_pPreviewScrollView;
@synthesize m_plblPageNum;
@synthesize currentPage;

-(id)initWithPicturePaths:(NSArray*) filePaths ScrollView:(UIScrollView*) scrollView
{
    self = [super init];
    if(self){
        
        arrThumbnails = filePaths;
        totalPage = [arrThumbnails count];
        
        m_pPreviewScrollView = scrollView;
        
        m_pPreviewScrollView.delegate = self;
        
        m_pPreviewScrollView.hidden = NO;
        
        m_pPreviewScrollView.showsHorizontalScrollIndicator = YES;          // 横スクロールバー表示
        m_pPreviewScrollView.showsVerticalScrollIndicator = YES;            // 縦スクロールバー表示
        
        m_pPreviewScrollView.contentSize = CGSizeMake(m_pPreviewScrollView.frame.size.width, m_pPreviewScrollView.frame.size.height * totalPage);
        m_pPreviewScrollView.pagingEnabled = YES;
        
        m_pPreviewScrollView.delegate = self;
        
        for (UIView *vi in m_pPreviewScrollView.subviews) {
            // 追加の前に不要なビューを消しておく
            if ([vi isKindOfClass:[PreviewPage class]]) {
                [vi removeFromSuperview];
            }
        }
        
        prevPage = [[PreviewPage alloc]initWithFrame:m_pPreviewScrollView.bounds];
        prevPage.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        [m_pPreviewScrollView addSubview:prevPage];
        
        currPage = [[PreviewPage alloc]initWithFrame:m_pPreviewScrollView.bounds];
        currPage.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        [m_pPreviewScrollView addSubview:currPage];
        currPage.zoomDelegate = self;
        
        nextPage = [[PreviewPage alloc]initWithFrame:m_pPreviewScrollView.bounds];
        nextPage.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        [m_pPreviewScrollView addSubview:nextPage];
        
        // ページ番号を表示
        CGRect rectLabel;
        if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
        {
            rectLabel = CGRectMake(15, 40, 80, 40);
        } else {
            rectLabel = CGRectMake(10, 15, 80, 40);
        }
        
        m_plblPageNum = [[UILabel alloc] initWithFrame:rectLabel];
        m_plblPageNum.backgroundColor = [[UIColor darkGrayColor] colorWithAlphaComponent:0.7] ;
        m_plblPageNum.textColor = [UIColor whiteColor];
        m_plblPageNum.textAlignment = NSTextAlignmentCenter;
        m_plblPageNum.layer.borderColor = [UIColor whiteColor].CGColor;
        m_plblPageNum.layer.borderWidth = 2.0;
        m_plblPageNum.layer.cornerRadius = 20.0;
        m_plblPageNum.clipsToBounds = true;
        m_plblPageNum.autoresizingMask = UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin;
        
        ///TODO: Page No
//    [self.view addSubview:m_plblPageNum];        
        
        currentPage = m_pPreviewScrollView.contentOffset.y / m_pPreviewScrollView.bounds.size.height;
        [self pageLoad:m_pPreviewScrollView];
        
        return self;
        
    }
    
    return nil;
}

- (void)resetPage {
    currentPage = 0;
    float pageWidth = m_pPreviewScrollView.bounds.size.width;
    float pageHeight = m_pPreviewScrollView.bounds.size.height;
    
    prevPage.hidden = YES;
    currPage.frame = CGRectMake(0, 0, pageWidth, pageHeight);
    
    if (arrThumbnails != nil && [arrThumbnails count] > 0) {
        [currPage setImage:[arrThumbnails objectAtIndex:currentPage]];
    }
    
    currPage.hidden = NO;
    if (currentPage < (totalPage - 1)) {
        nextPage.frame = CGRectMake(
                                    0,
                                    pageHeight * (currentPage + 1),
                                    pageWidth,
                                    pageHeight
                                    );
        [nextPage setImage:[arrThumbnails objectAtIndex:currentPage +1]];
        nextPage.hidden = NO;
    } else {
        nextPage.hidden = YES;
    }
    
    // ページ番号
    [m_plblPageNum performSelectorOnMainThread:@selector(setText:) withObject:[NSString stringWithFormat:@"%zd / %zd", currentPage + 1, totalPage] waitUntilDone:YES];
    
    [m_pPreviewScrollView setContentOffset:CGPointMake(0, pageHeight * currentPage)];
    
}

-(void)pageLoad:(UIScrollView *)scrollView {
    float pageWidth = scrollView.bounds.size.width;
    float pageHeight = scrollView.bounds.size.height;
    
    // ページ範囲チェック＆訂正
    if (currentPage < 0) {
        // 先頭ページ
        currentPage = 0;
    }
    else if (currentPage >= totalPage) {
        // 最終ページ
        currentPage = totalPage ;
    }
    
    if (currentPage > 0) {
        prevPage.frame =  CGRectMake(
                                     0,
                                     pageHeight * (currentPage - 1),
                                     pageWidth,
                                     pageHeight
                                     );
        [prevPage setImage:[arrThumbnails objectAtIndex:currentPage -1]];
        prevPage.hidden = NO;
    } else {
        prevPage.hidden = YES;
    }
    
    currPage.frame = CGRectMake(
                                0,
                                pageHeight * currentPage,
                                pageWidth,
                                pageHeight
                                );
    
    if (arrThumbnails != nil && [arrThumbnails count] > 0) {
        [currPage setImage:[arrThumbnails objectAtIndex:currentPage]];
    }
    
    currPage.hidden = NO;
    
    if (currentPage < (totalPage - 1)) {
        nextPage.frame = CGRectMake(
                                    0,
                                    pageHeight * (currentPage + 1),
                                    pageWidth,
                                    pageHeight
                                    );
        [nextPage setImage:[arrThumbnails objectAtIndex:currentPage +1]];
        nextPage.hidden = NO;
    } else {
        nextPage.hidden = YES;
    }
    if (currentPage < totalPage) {
        // ページ番号
        [m_plblPageNum performSelectorOnMainThread:@selector(setText:) withObject:[NSString stringWithFormat:@"%zd / %zd", currentPage + 1, totalPage] waitUntilDone:YES];
    } else {
        // ページ番号
        [m_plblPageNum performSelectorOnMainThread:@selector(setText:) withObject:[NSString stringWithFormat:@"%zd / %zd", currentPage, totalPage] waitUntilDone:YES];
    }
    
    [scrollView setContentOffset:CGPointMake(0, pageHeight * currentPage)];
}

- (void)adjustCurrentPage
{
    currentPage = m_pPreviewScrollView.contentOffset.y / m_pPreviewScrollView.bounds.size.height;
}

- (void)rotate
{
    prevPage.transform = CGAffineTransformRotate(prevPage.transform, M_PI/2);
    nextPage.transform = CGAffineTransformRotate(nextPage.transform, M_PI/2);
    
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.5];
    
    currPage.transform = CGAffineTransformRotate(currPage.transform, M_PI/2);
    
    [UIView commitAnimations];
    
    currentPage = m_pPreviewScrollView.contentOffset.y / m_pPreviewScrollView.bounds.size.height;
    
    [self pageLoad:m_pPreviewScrollView];
}

-(NSInteger)getCurrentPage
{
    return currentPage;
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    m_pPreviewScrollView.contentSize = CGSizeMake(m_pPreviewScrollView.frame.size.width, m_pPreviewScrollView.frame.size.height * totalPage);
    
    [prevPage setZoomScale:currPage.zoomScale];
    [nextPage setZoomScale:currPage.zoomScale];
    
    CGFloat position = fabs(scrollView.contentOffset.y) / scrollView.bounds.size.height;
    CGFloat delta = position - fabs((CGFloat)currentPage);
    DLog(@"delta:%f", delta);
    
    if (fabs(delta) >= 1.0f && m_pPreviewScrollView.contentSize.height > 0) {
        currentPage = round(m_pPreviewScrollView.contentOffset.y / m_pPreviewScrollView.bounds.size.height);
        [self pageLoad:scrollView];
    }
}

#pragma mark - PreviewPageDelegate
- (void)PreviewPageDidZoom:(float) zoomScale
{
    if (zoomScale > prevPage.minimumZoomScale) {
        m_pPreviewScrollView.scrollEnabled = NO;
    }
    else
    {
        m_pPreviewScrollView.scrollEnabled = YES;
    }
}



@end
