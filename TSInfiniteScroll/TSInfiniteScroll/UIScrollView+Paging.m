//
//  UIScrollView+Paging.m
//  TSInfiniteScroll
//
//  Created by Robin van Dijke on 02-05-12.
//  Copyright (c) 2012 Touchwonders B.V. All rights reserved.
//

#import "UIScrollView+Paging.h"

@implementation UIScrollView (Paging)

- (void)setContentOffsetForPaging:(CGPoint)contentOffset animated:(BOOL)animated {    
    // find the closest paging point in the scrollView
    CGFloat pagingSize = self.frame.size.width;
    NSUInteger numberOfPagingIndex = (int)(contentOffset.x / pagingSize + 0.5);
    [self setContentOffset:CGPointMake(numberOfPagingIndex * pagingSize, contentOffset.y) animated:animated];
}

- (void)setContentSizeForPaging:(CGSize)contentSize {
    // find the closest paging point in the scrollView
    CGFloat pagingSize = self.frame.size.width;
    CGFloat contentSizeFraction = (contentSize.width / pagingSize) - (int)((contentSize.width / pagingSize) + 0.5);
    if (contentSizeFraction < 1.0 && contentSizeFraction > 0.0)
        contentSize.width = (int)((contentSize.width / pagingSize) + 1.5) * pagingSize;
    
    pagingSize = self.frame.size.height;
    contentSizeFraction = (contentSize.height / pagingSize) - (int)((contentSize.height / pagingSize) + 0.5);
    if (contentSizeFraction < 1.0 && contentSizeFraction > 0.0)
        contentSize.height = (int)((contentSize.height / pagingSize) + 1.5) * pagingSize;
    
    [self setContentSize:contentSize];
}

@end
