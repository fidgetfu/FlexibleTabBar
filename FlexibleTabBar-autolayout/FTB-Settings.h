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

#define     FTB_STYLE          ftbStyleGrouped // grouped, spread

#define     TAB_NAMES          @[@"UITableView A", @"UITableView B", @"Storyboard"]
#define     TAB_SYMBOLS        @[@"!", @"#", @"$"]

#define     TAB_FONT_NAME      @"ftb"
#define     TAB_FONT_SIZE      36.0f

#define     FTB_BAR_SIZE       60.0f
#define     FTB_TAB_SIZE       65.0f

#define     FTB_ORIENT_IPHONE  orientLeft // top, left, right, bottom
#define     FTB_ORIENT_IPAD    orientLeft


// color for the selected tab
#define     TAB_SELECTED_FG    [UIColor colorWithRed:0.00f green:0.53f blue:0.61f alpha:1.00f]
#define     TAB_SELECTED_BG    [UIColor colorWithRed:0.49f green:0.83f blue:0.88f alpha:1.00f]
// unselected tabs (this is always the unselected color)
#define     TAB_FG             [UIColor colorWithRed:0.58f green:0.70f blue:0.71f alpha:1.00f]
#define     TAB_BG             [UIColor colorWithRed:0.79f green:0.87f blue:0.89f alpha:1.00f]
// BAR_BG shows as divider between tabs or as background,
// depending on how you choose to layout the bar
#define     BAR_BG             [UIColor colorWithRed:0.56f green:0.65f blue:0.67f alpha:1.00f]

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
    ftbStyleGrouped     // group all buttons at top or left of bar, fixed button size
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
