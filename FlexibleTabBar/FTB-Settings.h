//
//  FTB-Settings.h
//  FlexibleTabBar
//
//  Created by Amy Nugent on 5/06/13.
//  Copyright (c) 2013 Amy Nugent. All rights reserved.
//

#ifndef FlexibleTabBar_FTB_Settings_h
#define FlexibleTabBar_FTB_Settings_h

typedef enum FTBOrientType : NSUInteger {
    orientTop,  // which side of the screen to place the tab bar
    orientBottom,
    orientLeft,
    orientRight
} FTBOrientType;

typedef enum FTBStyleType : NSUInteger {
    ftbStyleSpread,     // spread the tab buttons out so they fill the bar
    ftbStyleSpaced,     // set the buttons at a fixed size evenly spaced across the bar
    ftbStyleGrouped     // group all buttons but one at left, the last on the right
} FTBStyleType;

/*  
 *  SETTINGS
 *  Edit these settings to get FTB to fit the look of your app
 */

#define     TAB_NAMES           @[@"UITableView", @"Storyboard", @"UIView"]
#define     TAB_SYMBOLS         @[@"!", @"#", @"$"]

#define     FTB_SIZE            44.0f
#define     FTB_TAB_SIZE        44.0f

#define     FTB_IPHONE_ORIENT   orientLeft // top, left, right, bottom
#define     FTB_IPAD_ORIENT     orientRight
#define     FTB_STYLE           ftbStyleSpread // grouped, spaced, spread

#define     BUTTON_FONT_NAME    @"ftb"
#define     BUTTON_FONT_SIZE    36.0f

#define     BUTTON_SELECT_FG    [UIColor colorWithRed:0.14f green:0.37f blue:0.57f alpha:1.00f]
#define     BUTTON_SELECT_BG    [UIColor colorWithRed:0.22f green:0.57f blue:0.89f alpha:1.00f]
#define     BUTTON_FG           [UIColor colorWithRed:0.10f green:0.16f blue:0.42f alpha:1.00f]
#define     BUTTON_BG           [UIColor colorWithRed:0.16f green:0.25f blue:0.64f alpha:1.00f]
#define     BAR                 [UIColor colorWithRed:1.00f green:1.00f blue:1.00f alpha:1.00f]
#define     DIVIDER             [UIColor darGrayColor]

// deprecated in next update - don't want any animation in the new library
#define     FTB_ANIMATED        NO
// deprecated in next update - using FTB_STYLE instead
#define     FTB_SPREAD          NO
// replaced with new ENUM type declaration
#define     FTB_ORIENT_IPHONE   @"bottom" // top, left, right, bottom
#define     FTB_ORIENT_IPAD     @"bottom"

/*
 * MACROS
 * Don't touch
 */

#define FTB_METRICS     @{@"pixel":@1.0, @"pixRetina":@0.5, @"barHeight":@FTB_SIZE, @"tabWidth":@FTB_TAB_SIZE}

#define IS_IPAD      (UI_USER_INTERFACE_IDIOM() != UIUserInterfaceIdiomPhone)
#define IS_IPHONE    (!IS_IPAD)
#define IS_RETINA    ([[UIScreen mainScreen] respondsToSelector:@selector(displayLinkWithTarget:selector:)] && ([UIScreen mainScreen].scale == 2.0))

#define isTop(a)     [a isEqualToString:@"top"]
#define isLeft(a)    [a isEqualToString:@"left"]
#define isRight(a)   [a isEqualToString:@"right"]
#define isBottom(a)  [a isEqualToString:@"bottom"]

#define TabName(a)     [TAB_NAMES objectAtIndex:a];
#define TabSymbol(a)   [TAB_SYMBOLS objectAtIndex:a];
#define ButtonFont     [UIFont fontWithName:BUTTON_FONT_NAME size:BUTTON_FONT_SIZE]

#endif
