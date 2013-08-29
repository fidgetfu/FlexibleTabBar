//
//  UIView+AutoLayout.h
//  FlexibleTabBar
//
//  Created by Amy Nugent on 29/08/13.
//  Copyright (c) 2013 Amy Nugent. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (AutoLayout)

- (void)addVisualConstraints:(NSString*)constraintString forViews:(NSDictionary*)views;
- (void)addVisualConstraints:(NSString*)constraintString forViews:(NSDictionary*)views withMetrics:(NSDictionary *)metrics;

- (void)addEqualityConstraintOn:(NSLayoutAttribute)attribute forSubview:(UIView*)subview;

@end
