//
//  UIView+AutoLayout.m
//  FlexibleTabBar
//
//  Created by Amy Nugent on 29/08/13.
//  Copyright (c) 2013 Amy Nugent. All rights reserved.
//

#import "UIView+AutoLayout.h"

@implementation UIView (AutoLayout)

- (void)addVisualConstraints:(NSString*)constraintString
                    forViews:(NSDictionary*)views {
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:constraintString
                                                                 options:0
                                                                 metrics:nil
                                                                   views:views]];
}

- (void)addVisualConstraints:(NSString*)constraintString
                    forViews:(NSDictionary*)views
                 withMetrics:(NSDictionary *)metrics {
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:constraintString
                                                                 options:0
                                                                 metrics:metrics
                                                                   views:views]];
}

- (void)addEqualityConstraintOn:(NSLayoutAttribute)attribute forSubview:(UIView*)subview {
    [self addConstraint:[NSLayoutConstraint constraintWithItem:subview
                                                      attribute:attribute
                                                      relatedBy:NSLayoutRelationEqual
                                                         toItem:self
                                                      attribute:attribute
                                                     multiplier:1.0
                                                       constant:0.0]];
}

@end
