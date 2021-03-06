//
//  FlexibleTabBar.h
//  FlexibleTabBar
//
//  Created by Amy Nugent on 29/08/13.
//  Copyright (c) 2013 Amy Nugent. All rights reserved.
//

@protocol ExtraViewDelegate;

@interface FlexibleTabBar : UIViewController

@property (nonatomic, copy) NSArray *viewControllers;
@property (nonatomic, weak) UIViewController *selectedViewController;
@property (nonatomic, assign) NSUInteger selectedIndex;
@property (nonatomic, weak) id <ExtraViewDelegate> delegate;

- (void)setSelectedIndex:(NSUInteger)index;
- (void)setSelectedViewController:(UIViewController *)viewController;

@end

/*
 * The delegate protocol for FlexibleTabBar.
 */
@protocol ExtraViewDelegate <NSObject>
@optional
- (BOOL)flexTabBar:(FlexibleTabBar *)tabBarController shouldSelectViewController:(UIViewController *)viewController atIndex:(NSUInteger)index;
- (void)flexTabBar:(FlexibleTabBar *)tabBarController didSelectViewController:(UIViewController *)viewController atIndex:(NSUInteger)index;
@end