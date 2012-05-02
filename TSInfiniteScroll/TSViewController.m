//
//  TSViewController.m
//  TSInfiniteScroll
//
//  Created by Robin van Dijke on 02-05-12.
//  Copyright (c) 2012 Touchwonders B.V. All rights reserved.
//

#import "TSViewController.h"
#import "TSInfiniteScrollViewController.h"

@implementation TSViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    scrollViewController = [[TSInfiniteScrollViewController alloc] init];
    [self.view addSubview:scrollViewController.view];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return UIInterfaceOrientationIsLandscape(interfaceOrientation);
}

@end
