//
//  TSAppDelegate.m
//  TSInfiniteScroll
//
//  Created by Robin van Dijke on 02-05-12.
//  Copyright (c) 2012 Touchwonders B.V. All rights reserved.
//

#import "TSAppDelegate.h"

#import "TSViewController.h"

@implementation TSAppDelegate

@synthesize window = _window;
@synthesize viewController = _viewController;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.viewController = [[TSViewController alloc] init];
    self.window.rootViewController = self.viewController;
    
    [self.window makeKeyAndVisible];
    return YES;
}
@end
