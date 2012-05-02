//
//  TSInfiniteScrollItemViewController.m
//  TSInfiniteScroll
//
//  Created by Robin van Dijke on 02-05-12.
//  Copyright (c) 2012 Touchwonders B.V. All rights reserved.
//

#import "TSInfiniteScrollItemViewController.h"
#import "TSInfiniteScrollViewItem.h"

@interface TSInfiniteScrollItemViewController ()

// simple responder to a tap gesture
- (void)changeBackgroundColor;

@end

@implementation TSInfiniteScrollItemViewController
@synthesize item;
@synthesize hidden;

- (void)viewDidLoad {
    UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                                           action:@selector(changeBackgroundColor)];
    [self.view addGestureRecognizer:tapGestureRecognizer];
}

- (void)setHidden:(BOOL)_hidden {
    hidden = _hidden;
    self.view.hidden = hidden;
}

- (void)setItem:(TSInfiniteScrollViewItem *)_item {
    item = _item;
    
    if (label == nil){
        label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 200, 20)];
        [self.view addSubview:label];
    }
    
    label.text = item.string;
    self.view.backgroundColor = item.backgroundColor;
}

#pragma mark - Private
- (void)changeBackgroundColor {
    self.view.backgroundColor = [UIColor greenColor];
    item.backgroundColor = self.view.backgroundColor;
}

@end
