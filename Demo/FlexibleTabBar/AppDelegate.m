//
//  AppDelegate.m
//  FlexibleTabBar
//
//  Created by Amy Nugent on 29/08/13.
//  Copyright (c) 2013 Amy Nugent. All rights reserved.
//

#import "AppDelegate.h"

#import "FTB-Settings.h"
#import "ListView.h"
#import "ExtraView.h"

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    /*
     * SETTING UP FLEXIBLE TAB BAR
     * Here's how to use FlexibleTabBar with a few different views
     */
    
    // Create some views for it to manage
    // 1st view - a basic code-only table view controller
	ListView *listView = [[ListView alloc] initWithStyle:UITableViewStylePlain];
    listView.title = TabName(0);
    UINavigationController * navigationController1 = [[UINavigationController alloc]
                                                      initWithRootViewController:listView];
    // 2nd view - a storyboard defined view
    UIStoryboard *viewStoryboard;
    if (IS_IPAD) viewStoryboard = [UIStoryboard storyboardWithName:@"iPad" bundle:nil];
    else viewStoryboard = [UIStoryboard storyboardWithName:@"iPhone" bundle:nil];
    UIViewController *viewController = [viewStoryboard instantiateViewControllerWithIdentifier:@"ViewController"];
    viewController.title = TabName(1);
    UINavigationController * navigationController2 = [[UINavigationController alloc]
                                                      initWithRootViewController:viewController];

    // 3rd view controller, vanilla
    ExtraView *extraView = [[ExtraView alloc] init];
    extraView.title = TabName(2);
    UINavigationController * navigationController3 = [[UINavigationController alloc]
                                                      initWithRootViewController:extraView];
    
    // Set up the tab bar controller with those views
	NSArray *viewControllers = @[navigationController1, navigationController2, navigationController3];
	FlexibleTabBar *tabBarController = [[FlexibleTabBar alloc] init];
    
	tabBarController.delegate = self;
	tabBarController.viewControllers = viewControllers;
    
	// Can select a tab to be open by default like this:
	tabBarController.selectedIndex = 2;
    // or
	//tabBarController.selectedViewController = ListView3;
    
    // CREATE THE WINDOW
	self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
	self.window.rootViewController = tabBarController;
	[self.window makeKeyAndVisible];
	return YES;
}

/*
 These are OPTIONAL
 delegate methods.
 */

- (BOOL)flexTabBar:(FlexibleTabBar *)tabBarController shouldSelectViewController:(UIViewController *)viewController atIndex:(NSUInteger)index {
	
	// Uncomment this to prevent "Tab 3" from being selected.
	//return (index != 2);
	return YES;
}

- (void)flexTabBar:(FlexibleTabBar *)tabBarController didSelectViewController:(UIViewController *)viewController atIndex:(NSUInteger)index {
	
}

@end
