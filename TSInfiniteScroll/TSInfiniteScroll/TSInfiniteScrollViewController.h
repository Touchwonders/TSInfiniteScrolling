//
//  TSInfiniteScrollViewController.h
//  TSInfiniteScroll
//
//  Created by Robin van Dijke on 02-05-12.
//  Copyright (c) 2012 Touchwonders B.V. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 * InfiniteScrollView - Touchwonders
 */

@class TSInfiniteScrollItemViewController;

@interface TSInfiniteScrollViewController : UIViewController <UIScrollViewDelegate> {
    NSMutableArray *items;
    NSMutableArray *rows;
    
    UIScrollView *gridView;
    
    CGFloat lastDifferenceInYContentOffset;
    
    NSInteger currentSelectedRowIndex;
    NSUInteger absoluteSelectedRowIndex;
    CGPoint previousContentOffsetForInfiniteScrolling;
    BOOL scrollingDown;
    
    NSUInteger numberOfRows;
    NSInteger totalNumberOfRows;
    BOOL doNotReOrder;
}

/**
 * Rebuilds the whole grid to display the given item
 * in correct state.
 *
 * @param item The item to be displayed after rebuilding
 */
- (void)displayItem:(TSInfiniteScrollItemViewController *)item;

@end
