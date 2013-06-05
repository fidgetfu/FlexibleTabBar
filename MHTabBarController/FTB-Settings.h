//
//  FTB-Settings.h
//  FlexibleTabBar
//
//  Created by Amy Nugent on 5/06/13.
//  Copyright (c) 2013 Amy Nugent. All rights reserved.
//

#ifndef FlexibleTabBar_FTB_Settings_h
#define FlexibleTabBar_FTB_Settings_h

// SOME SETTINGS
#define IS_IPHONE (!IS_IPAD)
#define IS_IPAD (UI_USER_INTERFACE_IDIOM() != UIUserInterfaceIdiomPhone)

// set the names for the tabs here. That way you can name the view and the tab separately. I find you frequently want a shorter tab name than view name. This is especially true if you're using an Icon font like fontAwesome to display icons in the title.
#define     tabNameFromIndex(a) [[NSArray arrayWithObjects:@"r",@"c",@"l",@"s",@"g",nil] objectAtIndex:a];

#define     FTB_SIZE            56.0f
#define     FTB_ORIENTATION     @"bottom"
#define     FTB_ANIMATED        YES

#define     BUTTON_BG           [UIColor colorWithRed:0.69 green:0.75 blue:0.76 alpha:1.0]
#define     BUTTON_HIGHLIGHT    [UIColor colorWithRed:0.82 green:0.90 blue:0.93 alpha:1.0]
#define     BUTTON_FG           [UIColor colorWithRed:0.26 green:0.30 blue:0.31 alpha:1.0]
#define     BUTTON_FONT         @"fontello"
#define     BUTTON_FONT_SIZE    36.0f

// SOME LOGIC

#define     ftbIsTop            [FTB_ORIENTATION isEqualToString:@"top"]
#define     ftbIsLeft           [FTB_ORIENTATION isEqualToString:@"left"]
#define     ftbIsRight          [FTB_ORIENTATION isEqualToString:@"right"]
#define     ftbIsBottom         [FTB_ORIENTATION isEqualToString:@"bottom"]

#endif
