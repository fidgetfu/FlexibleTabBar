//
//  FTB-Settings.h
//  FlexibleTabBar
//
//  Created by Amy Nugent on 5/06/13.
//  Copyright (c) 2013 Amy Nugent. All rights reserved.
//

#ifndef FlexibleTabBar_FTB_Settings_h
#define FlexibleTabBar_FTB_Settings_h

/*
 *  SETTINGS
 *  Edit these settings to get FTB to fit the look of your app
 */

#define     TAB_NAMES          @[@"UITableView", @"Storyboard"]
#define     TAB_SYMBOLS        @[@"!", @"#"]

#define     FTB_ORIENT_IPHONE  orientBottom // top, left, right, bottom
#define     FTB_ORIENT_IPAD    orientBottom
#define     FTB_STYLE          ftbStyleSpread // grouped, spaced, spread

#define     FTB_BAR_SIZE       44.0f
#define     FTB_TAB_SIZE       44.0f

#define     TAB_FONT_NAME      @"ftb"
#define     TAB_FONT_SIZE      36.0f

#define     TAB_SELECTED_FG    [UIColor colorWithRed:0.14f green:0.37f blue:0.57f alpha:1.00f]
#define     TAB_SELECTED_BG    [UIColor colorWithRed:0.22f green:0.57f blue:0.89f alpha:1.00f]
#define     TAB_FG             [UIColor colorWithRed:0.10f green:0.16f blue:0.42f alpha:1.00f]
#define     TAB_BG             [UIColor colorWithRed:0.16f green:0.25f blue:0.64f alpha:1.00f]
#define     BAR_BG             TAB_FG   // background to show between buttons
#define     DIVIDER            [UIColor darkGrayColor] // pixel divider between tab bar and content view

/*
 * DEFINITIONS
 * look up options here
 */

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
 * MACROS
 * Don't touch
 */

#define IS_IPAD        (UI_USER_INTERFACE_IDIOM() != UIUserInterfaceIdiomPhone)
#define IS_IPHONE      (!IS_IPAD)
#define IS_RETINA      ([[UIScreen mainScreen] respondsToSelector:@selector(displayLinkWithTarget:selector:)] && ([UIScreen mainScreen].scale == 2.0))

#define TabName(a)     [TAB_NAMES objectAtIndex:a];
#define TabSymbol(a)   [TAB_SYMBOLS objectAtIndex:a];
#define ButtonFont     [UIFont fontWithName:TAB_FONT_NAME size:TAB_FONT_SIZE]

#endif
