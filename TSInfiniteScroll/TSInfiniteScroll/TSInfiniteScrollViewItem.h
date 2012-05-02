//
//  TSInfiniteScrollViewItem.h
//  TSInfiniteScroll
//
//  Created by Robin van Dijke on 02-05-12.
//  Copyright (c) 2012 Touchwonders B.V. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 * A simple holder with information about one item
 *
 * Created by Robin van Dijke 
 */

@interface TSInfiniteScrollViewItem : NSObject

/** A single string which contains info about the current item its position */
@property (nonatomic, strong) NSString *string;

/** Reference to the background color */
@property (nonatomic, strong) UIColor *backgroundColor;

@end
