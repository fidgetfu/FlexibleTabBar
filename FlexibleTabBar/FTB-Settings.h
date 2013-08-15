//
//  FTB-Settings.h
//  FlexibleTabBar
//
//  Created by Amy Nugent on 5/06/13.
//  Copyright (c) 2013 Amy Nugent. All rights reserved.
//

#ifndef FlexibleTabBar_FTB_Settings_h
#define FlexibleTabBar_FTB_Settings_h

#define IS_IPAD      (UI_USER_INTERFACE_IDIOM() != UIUserInterfaceIdiomPhone)
#define IS_IPHONE    (!IS_IPAD)
#define isTop(a)     [a isEqualToString:@"top"]
#define isLeft(a)    [a isEqualToString:@"left"]
#define isRight(a)   [a isEqualToString:@"right"]
#define isBottom(a)  [a isEqualToString:@"bottom"]

/*  
 *  SETTINGS
 *  Edit these settings to get FTB to fit the look of your app
 */

#define     FTB_SIZE            50.0f
#define     FTB_ORIENT_IPHONE   @"bottom"
#define     FTB_ORIENT_IPAD     @"bottom"
#define     FTB_ANIMATED        NO

#define     BUTTON_BG           [UIColor colorWithRed:0.93f green:0.93f blue:0.93f alpha:1.00f]
#define     BUTTON_FG           [UIColor colorWithRed:0.60f green:0.60f blue:0.60f alpha:1.00f]
#define     BUTTON_SELECT_FG    [UIColor colorWithRed:0.43f green:0.52f blue:0.36f alpha:1.00f]
#define     BUTTON_SELECT_BG    [UIColor colorWithRed:0.73f green:0.88f blue:0.60f alpha:1.00f]
#define     BUTTON_FONT         @"fontello"
#define     BUTTON_FONT_SIZE    36.0f

// set the names for the tabs here (separate from view name)
#define     tabNameFromIndex(a) [[NSArray arrayWithObjects:@"r",@"c",@"l",@"s",@"g",nil] objectAtIndex:a];

#endif
