//
//  TSInfiniteScrollItemViewController.h
//  TSInfiniteScroll
//
//  Created by Robin van Dijke on 02-05-12.
//  Copyright (c) 2012 Touchwonders B.V. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 * Represents one item within a row
 */

@class TSInfiniteScrollViewItem;

@interface TSInfiniteScrollItemViewController : UIViewController {
    UILabel *label;
}

/** Information object for this itemViewController */
@property (nonatomic, strong) TSInfiniteScrollViewItem *item;

/** Hide or not? */
@property (nonatomic, assign) BOOL hidden;

@end
