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

#define     TAB_NAMES          @[@"UITableView A", @"UITableView B", @"Storyboard"]
#define     TAB_SYMBOLS        @[@"!", @"#", @"$"] // will be used as the tab label

#define     TAB_FONT_NAME      @"ftb" // recommend using a symbol font
#define     TAB_FONT_SIZE      36.0f // like Fontello

// set some sizes and bar options
// for iPad and iPhone individually

#define     FTB_BAR_SIZE_IPAD       60.0f
#define     FTB_TAB_SIZE_IPAD       65.0f

#define     FTB_BAR_SIZE_IPHONE       44.0f
#define     FTB_TAB_SIZE_IPHONE       56.0f

#define     FTB_ORIENT_IPAD    orientLeft // top, left, right, bottom
#define     FTB_ORIENT_IPHONE  orientBottom

#define     FTB_STYLE_IPAD     ftbStyleGrouped // grouped, spread
#define     FTB_STYLE_IPHONE   ftbStyleSpread

// set some colors for the tabs and bar
#define     TAB_SELECTED_FG    [UIColor colorWithRed:0.00f green:0.53f blue:0.61f alpha:1.00f]
#define     TAB_SELECTED_BG    [UIColor colorWithRed:0.49f green:0.83f blue:0.88f alpha:1.00f]
#define     TAB_FG             [UIColor colorWithRed:0.58f green:0.70f blue:0.71f alpha:1.00f]
#define     TAB_BG             [UIColor colorWithRed:0.79f green:0.87f blue:0.89f alpha:1.00f]
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
