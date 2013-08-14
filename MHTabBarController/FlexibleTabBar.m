/*
 * Copyright (c) Amy Nugent
 *
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the "Software"), to deal
 * in the Software without restriction, including without limitation the rights
 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be included in
 * all copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 * THE SOFTWARE.
 */

#import "FlexibleTabBar.h"
#import "FTB-Settings.h"

static const NSInteger TagOffset = 1000;

@implementation FlexibleTabBar {
	UIView *tabButtonsContainerView;
	UIView *contentContainerView;
	UIImageView *indicatorImageView;
}

- (void)didReceiveMemoryWarning {
	[super didReceiveMemoryWarning];
    
	if ([self isViewLoaded] && self.view.window == nil)
	{
		self.view = nil;
		tabButtonsContainerView = nil;
		contentContainerView = nil;
		indicatorImageView = nil;
	}
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
	// Only rotate if all child view controllers agree on the new orientation.
	for (UIViewController *viewController in self.viewControllers)
	{
		if (![viewController shouldAutorotateToInterfaceOrientation:interfaceOrientation])
			return NO;
	}
	return YES;
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
	while ([tabButtonsContainerView.subviews count] > 0)
	{
		[[tabButtonsContainerView.subviews lastObject] removeFromSuperview];
	}
}

- (void)viewWillLayoutSubviews {
	[super viewWillLayoutSubviews];
	[self layoutTabButtons];
}

# pragma mark - geo
-(CGRect)tabsRect {
    CGFloat rectX, rectY, width, height;
    
    NSString *orient;
    if (IS_IPAD) orient = FTB_ORIENT_IPAD;
    else orient = FTB_ORIENT_IPHONE;
    
    if (isTop(orient) || isBottom(orient)) {
        height = FTB_SIZE;
        width = self.view.bounds.size.width;
        rectX = 0.0f;
        if (isTop(orient)) rectY = 0.0f;
        else rectY = self.view.bounds.size.height - height;
    } else {
        height = self.view.bounds.size.height;
        width = FTB_SIZE;
        rectY = 0.0f;
        if (isLeft(orient)) rectX = 0.0f;
        else rectX = self.view.bounds.size.width - width;
    }
    
    CGRect thisRect = CGRectMake(rectX, rectY, width, height);
    return thisRect;
}

-(CGRect)childViewRect {
    CGFloat rectX, rectY, width, height;
    
    NSString *orient;
    if (IS_IPAD) orient = FTB_ORIENT_IPAD;
    else orient = FTB_ORIENT_IPHONE;
    
    if (isTop(orient) || isBottom(orient)) {
        height = self.view.bounds.size.height - FTB_SIZE;
        width = self.view.bounds.size.width;
        rectX = 0.0f;
        if (isTop(orient)) rectY = FTB_SIZE;
        else rectY = 0.0f;
    } else {
        height = self.view.bounds.size.height;
        width = self.view.bounds.size.width - FTB_SIZE;
        rectY = 0.0f;
        if (isLeft(orient)) rectX = FTB_SIZE;
        else rectX = 0.0f;
    }
    
    CGRect thisRect = CGRectMake(rectX, rectY, width, height);
    return thisRect;
}

# pragma mark - layout

- (void)viewDidLoad {
	[super viewDidLoad];
    
	self.view.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    
	
	tabButtonsContainerView = [[UIView alloc] initWithFrame:[self tabsRect]];
	tabButtonsContainerView.autoresizingMask = UIViewAutoresizingFlexibleWidth;
	[self.view addSubview:tabButtonsContainerView];
    
	contentContainerView = [[UIView alloc] initWithFrame:[self childViewRect]];
	contentContainerView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
	[self.view addSubview:contentContainerView];
    
	indicatorImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"FlexibleTabBarIndicator"]];
	[self.view addSubview:indicatorImageView];
    
	[self reloadTabButtons];
}

- (void)layoutTabButtons {
	NSUInteger index = 0;
	NSUInteger count = [self.viewControllers count];
    
    NSString *orient;
    if (IS_IPAD) orient = FTB_ORIENT_IPAD;
    else orient = FTB_ORIENT_IPHONE;
    
    CGRect tabBarRect = [self tabsRect];
    CGRect rect;
    if (isTop(orient) || isBottom(orient)) rect = CGRectMake(0.0f, 0.0f, floorf(tabBarRect.size.width / count), FTB_SIZE);
    else rect = CGRectMake(0.0f, 0.0f, FTB_SIZE, floorf(tabBarRect.size.height / count));
    
	indicatorImageView.hidden = YES;
    
	NSArray *buttons = [tabButtonsContainerView subviews];
	for (UIButton *button in buttons) {
        
        if (isTop(orient) || isBottom(orient)) {
            if (index == count - 1) rect.size.width = self.view.bounds.size.width - rect.origin.x;
            button.frame = rect;
            rect.origin.x += rect.size.width;
        } else {
            if (index == count - 1) rect.size.height = self.view.bounds.size.height - rect.origin.y;
            button.frame = rect;
            rect.origin.y += rect.size.height;
        }
        
		if (index == self.selectedIndex)
			[self centerIndicatorOnButton:button];
        
		++index;
	}
}

- (void)centerIndicatorOnButton:(UIButton *)button {
    NSString *orient;
    if (IS_IPAD) orient = FTB_ORIENT_IPAD;
    else orient = FTB_ORIENT_IPHONE;
    
	CGRect rect = indicatorImageView.frame;
    if (isTop(orient) || isBottom(orient)) {
        rect.origin.x = button.center.x - floorf(indicatorImageView.frame.size.width/2.0f);
        if (isBottom(orient)) {
            rect.origin.y = self.view.bounds.size.height - FTB_SIZE;
            indicatorImageView.transform = CGAffineTransformMakeRotation(M_PI);
        } else {
            rect.origin.y = FTB_SIZE - indicatorImageView.frame.size.height;
        }
        
    } else {
        rect.origin.y = button.center.y - floorf(indicatorImageView.frame.size.height/2.0f);
        if (isLeft(orient)) {
            rect.origin.x = FTB_SIZE - indicatorImageView.frame.size.width;
            indicatorImageView.transform = CGAffineTransformMakeRotation(-M_PI_2);
        } else {
            rect.origin.x = self.view.bounds.size.width - FTB_SIZE;
            indicatorImageView.transform = CGAffineTransformMakeRotation(M_PI_2);
        }
        
        
    }
	indicatorImageView.frame = rect;
	indicatorImageView.hidden = NO;
}

#pragma mark - button look

- (void)addTabButtons {
	NSUInteger index = 0;
	for (UIViewController *viewController in self.viewControllers)
	{
		UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
		button.tag = TagOffset + index;
		button.titleLabel.font = [UIFont fontWithName:BUTTON_FONT size:BUTTON_FONT_SIZE];
        
		UIOffset offset = viewController.tabBarItem.titlePositionAdjustment;
		button.titleEdgeInsets = UIEdgeInsetsMake(offset.vertical, offset.horizontal, 0.0f, 0.0f);
        
        NSString *name = tabNameFromIndex(index);
        
		[button setTitle:name forState:UIControlStateNormal];
        
		[button addTarget:self action:@selector(tabButtonPressed:) forControlEvents:UIControlEventTouchDown];
        
		[self deselectTabButton:button];
		[tabButtonsContainerView addSubview:button];
        
		++index;
	}
}

- (void)selectTabButton:(UIButton *)button {
    
    [button setBackgroundColor: BUTTON_HIGHLIGHT];
	[button setTitleColor:BUTTON_FG forState:UIControlStateNormal];
    
    //	[button setTitleShadowColor:[UIColor colorWithWhite:0.0f alpha:0.5f] forState:UIControlStateNormal];
}

- (void)deselectTabButton:(UIButton *)button {
    
    [button setBackgroundColor: BUTTON_BG];
	[button setTitleColor:BUTTON_FG forState:UIControlStateNormal];
    
    //	[button setTitleShadowColor:[UIColor whiteColor] forState:UIControlStateNormal];
}

# pragma mark - view controller organisation

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
	[self setSelectedIndex:newSelectedIndex animated:NO];
}

- (void)setSelectedIndex:(NSUInteger)newSelectedIndex animated:(BOOL)animated {
	NSAssert(newSelectedIndex < [self.viewControllers count], @"View controller index out of bounds");
    
	if ([self.delegate respondsToSelector:@selector(flex_tabBarController:shouldSelectViewController:atIndex:)])
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
			UIButton *fromButton = (UIButton *)[tabButtonsContainerView viewWithTag:TagOffset + _selectedIndex];
			[self deselectTabButton:fromButton];
			fromViewController = self.selectedViewController;
		}
        
		NSUInteger oldSelectedIndex = _selectedIndex;
		_selectedIndex = newSelectedIndex;
        
		UIButton *toButton;
		if (_selectedIndex != NSNotFound)
		{
			toButton = (UIButton *)[tabButtonsContainerView viewWithTag:TagOffset + _selectedIndex];
			[self selectTabButton:toButton];
			toViewController = self.selectedViewController;
		}
        
		if (toViewController == nil)  // don't animate
		{
			[fromViewController.view removeFromSuperview];
		}
		else if (fromViewController == nil)  // don't animate
        {
			toViewController.view.frame = contentContainerView.bounds;
			[contentContainerView addSubview:toViewController.view];
			[self centerIndicatorOnButton:toButton];
            
			if ([self.delegate respondsToSelector:@selector(flex_tabBarController:didSelectViewController:atIndex:)])
				[self.delegate flexTabBar:self didSelectViewController:toViewController atIndex:newSelectedIndex];
		}
		else if (animated) {
			CGRect rect = contentContainerView.bounds;
            
            NSString *orient;
            if (IS_IPAD) orient = FTB_ORIENT_IPAD;
            else orient = FTB_ORIENT_IPHONE;
            
			if (oldSelectedIndex < newSelectedIndex) {
                // going right to left
				if (isTop(orient) || isBottom(orient)) rect.origin.x = rect.size.width;
                if (isLeft(orient)) rect.origin.x = rect.size.width - FTB_SIZE;
            } else {
                // going left to right
				if (isTop(orient) || isBottom(orient)) rect.origin.x = -rect.size.width;
                if (isLeft(orient)) rect.origin.x = - rect.size.width - FTB_SIZE;
            }
            
			toViewController.view.frame = rect;
			tabButtonsContainerView.userInteractionEnabled = NO;
            
			[self transitionFromViewController:fromViewController
                              toViewController:toViewController
                                      duration:0.3f
                                       options:UIViewAnimationOptionLayoutSubviews | UIViewAnimationOptionCurveEaseOut
                                    animations:^
             {
                 CGRect rect = fromViewController.view.frame;
                 
                 if (oldSelectedIndex < newSelectedIndex) {
                     if (isTop(orient) || isBottom(orient)) rect.origin.x = -rect.size.width;
                     if (isLeft(orient)) rect.origin.x = - rect.size.width - FTB_SIZE;
                 } else {
                     if (isTop(orient) || isBottom(orient)) rect.origin.x = rect.size.width;
                     if (isLeft(orient)) rect.origin.x = rect.size.width - FTB_SIZE;
                 }
                 
                 fromViewController.view.frame = rect;
                 toViewController.view.frame = contentContainerView.bounds;
                 [self centerIndicatorOnButton:toButton];
             }
                                    completion:^(BOOL finished)
             {
                 tabButtonsContainerView.userInteractionEnabled = YES;
                 
                 if ([self.delegate respondsToSelector:@selector(flex_tabBarController:didSelectViewController:atIndex:)])
                     [self.delegate flexTabBar:self didSelectViewController:toViewController atIndex:newSelectedIndex];
             }];
            
		}
		else  // not animated
		{
			[fromViewController.view removeFromSuperview];
            
			toViewController.view.frame = contentContainerView.bounds;
			[contentContainerView addSubview:toViewController.view];
			[self centerIndicatorOnButton:toButton];
            
			if ([self.delegate respondsToSelector:@selector(flex_tabBarController:didSelectViewController:atIndex:)])
				[self.delegate flexTabBar:self didSelectViewController:toViewController atIndex:newSelectedIndex];
		}
	}
}

- (UIViewController *)selectedViewController {
	if (self.selectedIndex != NSNotFound)
		return (self.viewControllers)[self.selectedIndex];
	else
		return nil;
}

- (void)setSelectedViewController:(UIViewController *)newSelectedViewController {
	[self setSelectedViewController:newSelectedViewController animated:NO];
}

- (void)setSelectedViewController:(UIViewController *)newSelectedViewController animated:(BOOL)animated {
	NSUInteger index = [self.viewControllers indexOfObject:newSelectedViewController];
	if (index != NSNotFound)
		[self setSelectedIndex:index animated:animated];
}

- (void)tabButtonPressed:(UIButton *)sender {
    // check for the header defined value
    BOOL shouldAnimate = FTB_ANIMATED;
    // override if tab bar is vertical
    NSString *orient;
    if (IS_IPAD) orient = FTB_ORIENT_IPAD;
    else orient = FTB_ORIENT_IPHONE;
    if (isLeft(orient) || isRight(orient)) shouldAnimate = NO;
	[self setSelectedIndex:sender.tag - TagOffset animated:shouldAnimate];
}


@end
