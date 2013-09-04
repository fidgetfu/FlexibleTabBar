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
    NSDictionary *metrics;
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
    contentContainer.backgroundColor = [UIColor blueColor];
    [self.view addSubview:contentContainer];
    
    // set metrics based on display type
    if (IS_RETINA) metrics = @{@"pixel":@0.5, @"barHeight":@FTB_BAR_SIZE, @"tabWidth":@FTB_TAB_SIZE};
    else metrics = @{@"pixel":@1.0, @"barHeight":@FTB_BAR_SIZE, @"tabWidth":@FTB_TAB_SIZE};

    // CONSTRAINTS
    NSDictionary* views = NSDictionaryOfVariableBindings(tabBar,divider,contentContainer);
    
    FTBOrientType orient = [self getOrient];
    
    switch (orient) {
        case orientTop:
            [self.view addVisualConstraints:@"|[tabBar]|" forViews:views];
            [self.view addVisualConstraints:@"|[divider]|" forViews:views];
            [self.view addVisualConstraints:@"|[contentContainer]|" forViews:views];
            [self.view addVisualConstraints:@"V:|[tabBar(==barHeight)][divider]" forViews:views withMetrics:metrics];
            [self.view addVisualConstraints:@"V:[divider][contentContainer]|" forViews:views];
            break;
            
        case orientBottom:
            [self.view addVisualConstraints:@"|[tabBar]|" forViews:views];
            [self.view addVisualConstraints:@"|[divider]|" forViews:views];
            [self.view addVisualConstraints:@"|[contentContainer]|" forViews:views];
            [self.view addVisualConstraints:@"V:[divider][tabBar(==barHeight)]|" forViews:views withMetrics:metrics];
            [self.view addVisualConstraints:@"V:|[contentContainer][divider(==pixel)]" forViews:views];
            break;
            
        case orientLeft:
            [self.view addVisualConstraints:@"V:|[tabBar]|" forViews:views];
            [self.view addVisualConstraints:@"V:|[divider]|" forViews:views];
            [self.view addVisualConstraints:@"V:|[contentContainer]|" forViews:views];
            [self.view addVisualConstraints:@"|[tabBar(==barHeight)][divider]" forViews:views withMetrics:metrics];
            [self.view addVisualConstraints:@"[divider][contentContainer]|" forViews:views];
            break;
            
        case orientRight:
            [self.view addVisualConstraints:@"V:|[tabBar]|" forViews:views];
            [self.view addVisualConstraints:@"V:|[divider]|" forViews:views];
            [self.view addVisualConstraints:@"V:|[contentContainer]|" forViews:views];
            [self.view addVisualConstraints:@"[divider][tabBar(==barHeight)]|" forViews:views withMetrics:metrics];
            [self.view addVisualConstraints:@"|[contentContainer][divider]" forViews:views];
            break;
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
    
    NSMutableArray* tabs = [NSMutableArray array];
    
    // Create the tabs
    [self.viewControllers enumerateObjectsUsingBlock:^(UIViewController* aView, NSUInteger idx, BOOL *stop) {
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
        [self deselectTabButton:tab];
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
                        if (IS_RETINA) [tabBar addVisualConstraints:@"V:[prevTab]-pixel-[tab(==prevTab)]|" forViews:tabviews withMetrics:metrics];
                        else [tabBar addVisualConstraints:@"V:[prevTab]-pixel-[tab(==prevTab)]|" forViews:tabviews withMetrics:metrics];
                        
                    } else {
                        // other tabs
                        if (IS_RETINA) [tabBar addVisualConstraints:@"V:[prevTab]-pixel-[tab(==prevTab)]" forViews:tabviews withMetrics:metrics];
                        else [tabBar addVisualConstraints:@"V:[prevTab]-pixel-[tab(==prevTab)]" forViews:tabviews withMetrics:metrics];
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
                        if (IS_RETINA) [tabBar addVisualConstraints:@"[prevTab]-pixel-[tab(==prevTab)]|" forViews:tabviews withMetrics:metrics];
                        else [tabBar addVisualConstraints:@"[prevTab]-pixel-[tab(==prevTab)]|" forViews:tabviews withMetrics:metrics];
                        
                    } else {
                        // other tabs
                        if (IS_RETINA) [tabBar addVisualConstraints:@"[prevTab]-pixel-[tab(==prevTab)]" forViews:tabviews withMetrics:metrics];
                        else [tabBar addVisualConstraints:@"[prevTab]-pixel-[tab(==prevTab)]" forViews:tabviews withMetrics:metrics];
                    }
                    [tabBar addVisualConstraints:@"V:|[tab]|" forViews:tabviews];
                }
                break;
                
        }
        
    }
    
    /*
        
		[self deselectTabButton:button];
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


- (void)selectTabButton:(UIView *)tab {
    
    [tab setBackgroundColor:TAB_SELECTED_BG];
	//[button setTitleColor:TAB_SELECTED_FG forState:UIControlStateNormal];
}

- (void)deselectTabButton:(UIView *)tab {
    
    [tab setBackgroundColor:TAB_BG];
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
			UIView *fromButton = (UIView *)[tabBar viewWithTag:TagOffset + _selectedIndex];
			[self deselectTabButton:fromButton];
			fromViewController = self.selectedViewController;
		}
        
		_selectedIndex = newSelectedIndex;
        
		UIView *toButton;
		if (_selectedIndex != NSNotFound)
		{
			toButton = (UIView *)[tabBar viewWithTag:TagOffset + _selectedIndex];
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
