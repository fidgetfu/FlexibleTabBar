//
//  FTB-Settings.h
//  FlexibleTabBar
//
//  Created by Amy Nugent on 5/06/13.
//  Copyright (c) 2013 Amy Nugent. All rights reserved.
//

#ifndef FlexibleTabBar_FTB_Settings_h
#define FlexibleTabBar_FTB_Settings_h

// set the names for the tabs here. That way you can name the view correctly.
#define     tabNameFromIndex(a) [[NSArray arrayWithObjects:@"r",@"c",@"1",@"s",@"7",nil] objectAtIndex:a];

#define     FTB_HEIGHT          56.0f
#define     FTP_LOCATION        @"bottom"

#define     BUTTON_BG           [UIColor colorWithRed:0.69 green:0.75 blue:0.76 alpha:1.0]
#define     BUTTON_HIGHLIGHT    [UIColor colorWithRed:0.82 green:0.90 blue:0.93 alpha:1.0]
#define     BUTTON_FG           [UIColor colorWithRed:0.26 green:0.30 blue:0.31 alpha:1.0]
#define     BUTTON_FONT         @"fontello"
#define     BUTTON_FONT_SIZE    26.0f

#endif
