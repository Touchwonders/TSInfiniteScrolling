//
//  TSInfiniteScrollViewRow.m
//  TSInfiniteScroll
//
//  Created by Robin van Dijke on 02-05-12.
//  Copyright (c) 2012 Touchwonders B.V. All rights reserved.
//

#import "TSInfiniteScrollViewRow.h"
#import "TSInfiniteScrollItemViewController.h"

#define TSNumberOfColumns   5

@implementation TSInfiniteScrollViewRow
@synthesize indexOfRow;
@synthesize itemViewControllers;

- (id)init {
    self = [super init];
    
    if (self)
        itemViewControllers = [[NSMutableArray alloc] init];
    
    return self;
}

@end
