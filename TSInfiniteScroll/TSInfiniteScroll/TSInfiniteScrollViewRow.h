//
//  TSInfiniteScrollViewRow.h
//  TSInfiniteScroll
//
//  Created by Robin van Dijke on 02-05-12.
//  Copyright (c) 2012 Touchwonders B.V. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 * Represents one row in the infinite scroll grid
 */

@interface TSInfiniteScrollViewRow : NSObject

/** Relative index of this row */
@property (nonatomic, assign) NSUInteger indexOfRow;

/** All itemViewControllers this row contains */
@property (nonatomic, strong) NSMutableArray *itemViewControllers;

@end
