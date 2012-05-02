//
//  UIScrollView+Paging.h
//  TSInfiniteScroll
//
//  Created by Robin van Dijke on 02-05-12.
//  Copyright (c) 2012 Touchwonders B.V. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIScrollView (Paging)

/**
 * Sets the offset of a scrollView while keeping
 * the paging size in mind
 *
 * @param contentOffset The new desired contentOffset
 * @param animated Animate the adjustment or not
 */
- (void)setContentOffsetForPaging:(CGPoint)contentOffset animated:(BOOL)animated;

/**
 * Sets the contentSize of a scrollView while keeping
 * the paging size in mind
 *
 * @param contentSize The new desired contentSize
 */
- (void)setContentSizeForPaging:(CGSize)contentSize;

@end
