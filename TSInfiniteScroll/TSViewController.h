//
//  TSViewController.h
//  TSInfiniteScroll
//
//  Created by Robin van Dijke on 02-05-12.
//  Copyright (c) 2012 Touchwonders B.V. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 * Simple demo for the TSInfiniteScrollViewController.
 * For more info, check the blogpost at
 * http://www.touchwonders.com/infinite-scrolling-messing-with-uiscrollview
 *
 * Created by Touchwonders B.V. 
 */

@class TSInfiniteScrollViewController;

@interface TSViewController : UIViewController {
    TSInfiniteScrollViewController *scrollViewController;
}

@end
