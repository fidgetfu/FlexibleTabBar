//
//  AppDelegate.m
//  FlexibleTabBar
//
//  Created by Amy Nugent on 29/08/13.
//  Copyright (c) 2013 Amy Nugent. All rights reserved.
//

#import "AppDelegate.h"

#import "FTB-Settings.h"
#import "ListViewA.h"
#import "ListViewB.h"
#import "FlexibleTabBar.h"

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    /*
     * SETTING UP FLEXIBLE TAB BAR
     * Here's how to use FlexibleTabBar with a few different views
     */
    
    // Create some views for it to manage
    // 1st view - a basic code-only table view controller
	ListViewA *listViewA = [[ListViewA alloc] initWithStyle:UITableViewStylePlain];
    listViewA.title = TabName(0);
    UINavigationController * navigationController1 = [[UINavigationController alloc]
                                                      initWithRootViewController:listViewA];
    // 2nd view - a basic code-only table view controller
	ListViewB *listViewB = [[ListViewB alloc] initWithStyle:UITableViewStylePlain];
    listViewB.title = TabName(1);
    UINavigationController * navigationController2 = [[UINavigationController alloc]
                                                      initWithRootViewController:listViewB];
    // 2nd view - a storyboard defined view
    UIStoryboard *viewStoryboard;
    if (IS_IPAD) viewStoryboard = [UIStoryboard storyboardWithName:@"iPad" bundle:nil];
    else viewStoryboard = [UIStoryboard storyboardWithName:@"iPhone" bundle:nil];
    UIViewController *viewController = [viewStoryboard instantiateViewControllerWithIdentifier:@"ViewController"];
    viewController.title = TabName(2);
    UINavigationController * navigationController3 = [[UINavigationController alloc]
                                                      initWithRootViewController:viewController];
    
    // Set up the tab bar controller with those views
	NSArray *viewControllers = @[navigationController1, navigationController2,navigationController3];
    
    FlexibleTabBar *tabBarController = [[FlexibleTabBar alloc] init];
    tabBarController.delegate = self;
    tabBarController.viewControllers = viewControllers;
    
    // CREATE THE WINDOW
	self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
	self.window.rootViewController = tabBarController;
	[self.window makeKeyAndVisible];
	return YES;
}

@end
