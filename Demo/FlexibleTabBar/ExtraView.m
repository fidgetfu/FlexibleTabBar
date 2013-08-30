//
//  ExtraView.m
//  FlexibleTabBar
//
//  Created by Amy Nugent on 29/08/13.
//  Copyright (c) 2013 Amy Nugent. All rights reserved.
//

#import "ExtraView.h"
#import "UIView+AutoLayout.h"
#import "FTB-Settings.h"

static const NSInteger TagOffset = 1000;

@interface ExtraView ()

@end

@implementation ExtraView {
    UIView *tabBar;
	UIView *contentContainer;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // to keep view from goind all the way under status and nav bar
    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.view.backgroundColor = [UIColor grayColor];
    
    /*
     * CREATE TAB BAR
     *
     */
    
    tabBar = [[UIView alloc] init];
    tabBar.translatesAutoresizingMaskIntoConstraints = NO; // Required for auto layout
    tabBar.backgroundColor = BAR_BG;
    [self.view addSubview:tabBar];
    
    UIView* divider = [[UIView alloc] init];
    divider.translatesAutoresizingMaskIntoConstraints = NO;
    divider.backgroundColor = DIVIDER;
    [self.view addSubview:divider];
    
    /*
     * CREATE CONTAINER VIEW
     *
     */
    
    contentContainer = [[UIView alloc] init];
    contentContainer.translatesAutoresizingMaskIntoConstraints = NO;
    contentContainer.backgroundColor = [UIColor clearColor];
    [self.view addSubview:contentContainer];
    
    // CONSTRAINTS
    
    NSDictionary* views = NSDictionaryOfVariableBindings(tabBar,divider);
    
    FTBOrientType orient = [self getOrient];
    
    switch (orient) {
        case orientTop:
            [self.view addVisualConstraints:@"|[tabBar]|" forViews:views];
            [self.view addVisualConstraints:@"|[divider]|" forViews:views];
            [self.view addVisualConstraints:@"V:|[divider][tabBar(barHeight)]" forViews:views withMetrics:FtbMetrics];
            break;
            
        case orientBottom:
            [self.view addVisualConstraints:@"|[tabBar]|" forViews:views];
            [self.view addVisualConstraints:@"|[divider]|" forViews:views];
            [self.view addVisualConstraints:@"V:[tabBar(barHeight)][divider]|" forViews:views withMetrics:FtbMetrics];
            break;
            
        case orientLeft:
            [self.view addVisualConstraints:@"V:|[tabBar]|" forViews:views];
            [self.view addVisualConstraints:@"V:|[divider]|" forViews:views];
            [self.view addVisualConstraints:@"|[tabBar(barHeight)][divider]" forViews:views withMetrics:FtbMetrics];
            break;
            
        case orientRight:
            [self.view addVisualConstraints:@"V:|[tabBar]|" forViews:views];
            [self.view addVisualConstraints:@"V:|[divider]|" forViews:views];
            [self.view addVisualConstraints:@"[divider][tabBar(barHeight)]|" forViews:views withMetrics:FtbMetrics];
            break;
    }
    
    if (IS_RETINA) {
        [self.view addVisualConstraints:@"[divider(pixRetina)]" forViews:views withMetrics:FtbMetrics];
    } else {
        [self.view addVisualConstraints:@"[divider(pixel)]" forViews:views withMetrics:FtbMetrics];
    }

    [self addTabButtons];
}

#pragma mark - Drawing

-(FTBOrientType)getOrient {
    FTBOrientType orient;
    if (IS_IPAD) orient = FTB_ORIENT_IPAD;
    else orient = FTB_ORIENT_IPHONE;
    return orient;
}

- (void)addTabButtons {
    
    NSAssert([self.viewControllers count] != [TAB_NAMES count], @"FlexibleTabBar needs an equal number of tab names and view controllers!");
    
    NSMutableArray* tabs = [NSMutableArray array];
    
    // Create the tabs
    [TAB_NAMES enumerateObjectsUsingBlock:^(NSString* tabName, NSUInteger idx, BOOL *stop) {
        // create the tab bar
        UIView* tab = [UIView new];
        tab.translatesAutoresizingMaskIntoConstraints = NO;
        tab.backgroundColor = TAB_BG;
        tab.tag = TagOffset + idx;
        UITapGestureRecognizer *tabTouch = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tabButtonPressed:)];
        [tabTouch setNumberOfTapsRequired:1];
        [tabTouch setNumberOfTouchesRequired:1];
        [tab addGestureRecognizer:tabTouch];
        
        // create a label
        UILabel* label = [UILabel new];
        label.text = TabSymbol(idx);
        label.font = ButtonFont;
        label.textColor = TAB_FG;
        label.translatesAutoresizingMaskIntoConstraints = NO;
        [tab addSubview:label];
        // constraints for label
        [tab addEqualityConstraintOn:NSLayoutAttributeCenterX forSubview:label];
        [tab addEqualityConstraintOn:NSLayoutAttributeCenterY forSubview:label];
        
        // add the view to the tab bar
        [tabBar addSubview:tab];
        [tabs addObject:tab];
    }];
    
    // CONSTRAINTS
    
    for (int i = 0; i < tabs.count; i++) {
        UIView *tab = [tabs objectAtIndex:i];
        
        // different logic for each orientation
        FTBOrientType orient = [self getOrient];
        switch (orient) {
            case orientRight:
            case orientLeft:
                if (i == 0) {
                    // leftmost tab
                    NSDictionary *oneView = NSDictionaryOfVariableBindings(tab);
                    [tabBar addVisualConstraints:@"V:|[tab]" forViews:oneView];
                    [tabBar addVisualConstraints:@"|[tab]|" forViews:oneView];
                } else {
                    UIView *prevTab = [tabs objectAtIndex:(i - 1)];
                    NSDictionary *tabviews = NSDictionaryOfVariableBindings(tab, prevTab);
                    if (i == tabs.count - 1) {
                        // rightmost tab
                        if (IS_RETINA) [tabBar addVisualConstraints:@"V:[prevTab]-pixRetina-[tab(==prevTab)]|" forViews:tabviews withMetrics:FtbMetrics];
                        else [tabBar addVisualConstraints:@"V:[prevTab]-pixel-[tab(==prevTab)]|" forViews:tabviews withMetrics:FtbMetrics];
                        
                    } else {
                        // other tabs
                        if (IS_RETINA) [tabBar addVisualConstraints:@"V:[prevTab]-pixRetina-[tab(==prevTab)]" forViews:tabviews withMetrics:FtbMetrics];
                        else [tabBar addVisualConstraints:@"V:[prevTab]-pixel-[tab(==prevTab)]" forViews:tabviews withMetrics:FtbMetrics];
                    }
                    [tabBar addVisualConstraints:@"|[tab]|" forViews:tabviews];
                }
                break;
                
            case orientTop:
            case  orientBottom:
                if (i == 0) {
                    // leftmost tab
                    NSDictionary *oneView = NSDictionaryOfVariableBindings(tab);
                    [tabBar addVisualConstraints:@"|[tab]" forViews:oneView];
                    [tabBar addVisualConstraints:@"V:|[tab]|" forViews:oneView];
                } else {
                    UIView *prevTab = [tabs objectAtIndex:(i - 1)];
                    NSDictionary *tabviews = NSDictionaryOfVariableBindings(tab, prevTab);
                    if (i == tabs.count - 1) {
                        // rightmost tab
                        if (IS_RETINA) [tabBar addVisualConstraints:@"[prevTab]-pixRetina-[tab(==prevTab)]|" forViews:tabviews withMetrics:FtbMetrics];
                        else [tabBar addVisualConstraints:@"[prevTab]-pixel-[tab(==prevTab)]|" forViews:tabviews withMetrics:FtbMetrics];
                        
                    } else {
                        // other tabs
                        if (IS_RETINA) [tabBar addVisualConstraints:@"[prevTab]-pixRetina-[tab(==prevTab)]" forViews:tabviews withMetrics:FtbMetrics];
                        else [tabBar addVisualConstraints:@"[prevTab]-pixel-[tab(==prevTab)]" forViews:tabviews withMetrics:FtbMetrics];
                    }
                    [tabBar addVisualConstraints:@"V:|[tab]|" forViews:tabviews];
                }
                break;
                
        }
        
    }
    
    /*
	NSUInteger index = 0;
	for (UIViewController *viewController in self.viewControllers)
	{
		UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
		button.tag = TagOffset + index;
		button.titleLabel.font = ButtonFont;
        
		UIOffset offset = viewController.tabBarItem.titlePositionAdjustment;
		button.titleEdgeInsets = UIEdgeInsetsMake(offset.vertical, offset.horizontal, 0.0f, 0.0f);
        
        NSString *name = TabSymbol(index);
        
		[button setTitle:name forState:UIControlStateNormal];
        
		[button addTarget:self action:@selector(tabButtonPressed:) forControlEvents:UIControlEventTouchDown];
        
		[self deselectTabButton:button];
		[tabBar addSubview:button];
        
		++index;
	}
     */
}

- (void)reloadTabButtons {
	[self removeTabButtons];
	[self addTabButtons];
    
	// Force redraw of the previously active tab.
	NSUInteger lastIndex = _selectedIndex;
	_selectedIndex = NSNotFound;
	self.selectedIndex = lastIndex;
}

- (void)removeTabButtons {
	while ([tabBar.subviews count] > 0) {
		[[tabBar.subviews lastObject] removeFromSuperview];
	}
}


- (void)selectTabButton:(UIButton *)button {
    
    [button setBackgroundColor:TAB_SELECTED_BG];
	//[button setTitleColor:TAB_SELECTED_FG forState:UIControlStateNormal];
}

- (void)deselectTabButton:(UIButton *)button {
    
    [button setBackgroundColor:TAB_BG];
	//[button setTitleColor:TAB_FG forState:UIControlStateNormal];
    
}


# pragma mark - Child View Control

- (void)tabButtonPressed:(UIGestureRecognizer *)gestrec {
	[self setSelectedIndex:([gestrec.view tag] - TagOffset)];
}

- (void)setSelectedViewController:(UIViewController *)newSelectedViewController {
	NSUInteger index = [self.viewControllers indexOfObject:newSelectedViewController];
	if (index != NSNotFound)
		[self setSelectedIndex:index];
}

- (UIViewController *)selectedViewController {
	if (self.selectedIndex != NSNotFound)
		return (self.viewControllers)[self.selectedIndex];
	else
		return nil;
}

- (void)setViewControllers:(NSArray *)newViewControllers {
	NSAssert([newViewControllers count] >= 2, @"FlexibleTabBar requires at least two view controllers");
    
	UIViewController *oldSelectedViewController = self.selectedViewController;
    
	// Remove the old child view controllers.
	for (UIViewController *viewController in _viewControllers)
	{
		[viewController willMoveToParentViewController:nil];
		[viewController removeFromParentViewController];
	}
    
	_viewControllers = [newViewControllers copy];
    
	// This follows the same rules as UITabBarController for trying to
	// re-select the previously selected view controller.
	NSUInteger newIndex = [_viewControllers indexOfObject:oldSelectedViewController];
	if (newIndex != NSNotFound)
		_selectedIndex = newIndex;
	else if (newIndex < [_viewControllers count])
		_selectedIndex = newIndex;
	else
		_selectedIndex = 0;
    
	// Add the new child view controllers.
	for (UIViewController *viewController in _viewControllers)
	{
		[self addChildViewController:viewController];
		[viewController didMoveToParentViewController:self];
	}
    
	if ([self isViewLoaded])
		[self reloadTabButtons];
}

- (void)setSelectedIndex:(NSUInteger)newSelectedIndex {
	NSAssert(newSelectedIndex < [self.viewControllers count], @"View controller index out of bounds");
    
	if ([self.delegate respondsToSelector:@selector(flexTabBar:shouldSelectViewController:atIndex:)])
	{
		UIViewController *toViewController = (self.viewControllers)[newSelectedIndex];
		if (![self.delegate flexTabBar:self shouldSelectViewController:toViewController atIndex:newSelectedIndex])
			return;
	}
    
	if (![self isViewLoaded])
	{
		_selectedIndex = newSelectedIndex;
	}
	else if (_selectedIndex != newSelectedIndex)
	{
		UIViewController *fromViewController;
		UIViewController *toViewController;
        
		if (_selectedIndex != NSNotFound)
		{
			UIButton *fromButton = (UIButton *)[tabBar viewWithTag:TagOffset + _selectedIndex];
			[self deselectTabButton:fromButton];
			fromViewController = self.selectedViewController;
		}
        
		_selectedIndex = newSelectedIndex;
        
		UIButton *toButton;
		if (_selectedIndex != NSNotFound)
		{
			toButton = (UIButton *)[tabBar viewWithTag:TagOffset + _selectedIndex];
			[self selectTabButton:toButton];
			toViewController = self.selectedViewController;
		}
        
		if (toViewController == nil)
		{
			[fromViewController.view removeFromSuperview];
		}
		else if (fromViewController == nil)
        {
			toViewController.view.frame = contentContainer.bounds;
			[contentContainer addSubview:toViewController.view];
            
			if ([self.delegate respondsToSelector:@selector(flexTabBar:didSelectViewController:atIndex:)])
				[self.delegate flexTabBar:self didSelectViewController:toViewController atIndex:newSelectedIndex];
		}
		else
		{
			[fromViewController.view removeFromSuperview];
            
			toViewController.view.frame = contentContainer.bounds;
			[contentContainer addSubview:toViewController.view];
            
			if ([self.delegate respondsToSelector:@selector(flexTabBar:didSelectViewController:atIndex:)])
				[self.delegate flexTabBar:self didSelectViewController:toViewController atIndex:newSelectedIndex];
		}
        
	}
    
}


@end
