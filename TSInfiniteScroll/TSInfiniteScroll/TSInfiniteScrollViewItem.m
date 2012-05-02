//
//  TSInfiniteScrollViewItem.m
//  TSInfiniteScroll
//
//  Created by Robin van Dijke on 02-05-12.
//  Copyright (c) 2012 Touchwonders B.V. All rights reserved.
//

#import "TSInfiniteScrollViewItem.h"

@implementation TSInfiniteScrollViewItem
@synthesize string;
@synthesize backgroundColor;

- (id)init {
    self = [super init];
    
    if (self)
        backgroundColor = [UIColor redColor];
    
    return self;
}

@end
