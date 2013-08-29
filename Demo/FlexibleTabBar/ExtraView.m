//
//  ExtraView.m
//  FlexibleTabBar
//
//  Created by Amy Nugent on 29/08/13.
//  Copyright (c) 2013 Amy Nugent. All rights reserved.
//

#import "ExtraView.h"
#import "UIView+AutoLayout.h"
#import "FTB-Settings.h"

@interface ExtraView ()

@end

@implementation ExtraView

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // to keep view from goind all the way under status and nav bar
    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.view.backgroundColor = [UIColor grayColor];
    
    /*
     * CREATE TAB BAR
     *
     */
    
    UIView* tabBar = [[UIView alloc] init];
    tabBar.translatesAutoresizingMaskIntoConstraints = NO; // Required for auto layout
    tabBar.backgroundColor = BUTTON_FG;
    [self.view addSubview:tabBar];
    
    UIView* divider = [[UIView alloc] init];
    divider.translatesAutoresizingMaskIntoConstraints = NO;
    divider.backgroundColor = [UIColor darkGrayColor];
    [self.view addSubview:divider];
    
    // CONSTRAINTS
    
    NSDictionary* views = NSDictionaryOfVariableBindings(tabBar,divider);
    
    FTBOrientType orient;
    if (IS_IPAD) orient = FTB_IPAD_ORIENT;
    else orient = FTB_IPHONE_ORIENT;
    
    switch (orient) {
        case orientTop:
            [self.view addVisualConstraints:@"|[tabBar]|" forViews:views];
            [self.view addVisualConstraints:@"|[divider]|" forViews:views];
            [self.view addVisualConstraints:@"V:[divider][tabBar(barHeight)]|" forViews:views withMetrics:FTB_METRICS];
            break;
            
        case orientBottom:
            [self.view addVisualConstraints:@"|[tabBar]|" forViews:views];
            [self.view addVisualConstraints:@"|[divider]|" forViews:views];
            [self.view addVisualConstraints:@"V:|[tabBar(barHeight)][divider]" forViews:views withMetrics:FTB_METRICS];
            break;
            
        case orientLeft:
            [self.view addVisualConstraints:@"V:|[tabBar]|" forViews:views];
            [self.view addVisualConstraints:@"V:|[divider]|" forViews:views];
            [self.view addVisualConstraints:@"|[tabBar(barHeight)][divider]" forViews:views withMetrics:FTB_METRICS];
            break;
            
        case orientRight:
            [self.view addVisualConstraints:@"V:|[tabBar]|" forViews:views];
            [self.view addVisualConstraints:@"V:|[divider]|" forViews:views];
            [self.view addVisualConstraints:@"[divider][tabBar(barHeight)]|" forViews:views withMetrics:FTB_METRICS];
            break;
    }
    
    if (IS_RETINA) {
        [self.view addVisualConstraints:@"[divider(pixRetina)]" forViews:views withMetrics:FTB_METRICS];
    } else {
        [self.view addVisualConstraints:@"[divider(pixel)]" forViews:views withMetrics:FTB_METRICS];
    }
    
    /*
     *  CREATE TABS
     *
     */
    
    NSMutableArray* tabs = [NSMutableArray array];
    
    // Create the tabs
    [TAB_NAMES enumerateObjectsUsingBlock:^(NSString* tabName, NSUInteger idx, BOOL *stop) {
        // create the tab bar
        UIView* tab = [UIView new];
        tab.translatesAutoresizingMaskIntoConstraints = NO;
        tab.backgroundColor = BUTTON_BG;
        
        // create a label
        UILabel* label = [UILabel new];
        label.text = TabSymbol(idx);
        label.font = ButtonFont;
        label.textColor = BUTTON_FG;
        label.translatesAutoresizingMaskIntoConstraints = NO;
        [tab addSubview:label];
        // constraints for label
        [tab addEqualityConstraintOn:NSLayoutAttributeCenterX forSubview:label];
        [tab addEqualityConstraintOn:NSLayoutAttributeCenterY forSubview:label];
        
        // add the view to the tab bar
        [tabBar addSubview:tab];
        [tabs addObject:tab];
    }];
    
    // CONSTRAINTS
    
    for (int i = 0; i < tabs.count; i++) {
        UIView *tab = [tabs objectAtIndex:i];

        // different logic for each orientation
        switch (orient) {
            case orientRight:
            case orientLeft:
                if (i == 0) {
                    // leftmost tab
                    NSDictionary *oneView = NSDictionaryOfVariableBindings(tab);
                    [tabBar addVisualConstraints:@"V:|[tab]" forViews:oneView];
                    [tabBar addVisualConstraints:@"|[tab]|" forViews:oneView];
                } else {
                    UIView *prevTab = [tabs objectAtIndex:(i - 1)];
                    NSDictionary *tabviews = NSDictionaryOfVariableBindings(tab, prevTab);
                    if (i == tabs.count - 1) {
                        // rightmost tab
                        if (IS_RETINA) [tabBar addVisualConstraints:@"V:[prevTab]-pixRetina-[tab(==prevTab)]|" forViews:tabviews withMetrics:FTB_METRICS];
                        else [tabBar addVisualConstraints:@"V:[prevTab]-pixel-[tab(==prevTab)]|" forViews:tabviews withMetrics:FTB_METRICS];
                        
                    } else {
                        // other tabs
                        if (IS_RETINA) [tabBar addVisualConstraints:@"V:[prevTab]-pixRetina-[tab(==prevTab)]" forViews:tabviews withMetrics:FTB_METRICS];
                        else [tabBar addVisualConstraints:@"V:[prevTab]-pixel-[tab(==prevTab)]" forViews:tabviews withMetrics:FTB_METRICS];
                    }
                    [tabBar addVisualConstraints:@"|[tab]|" forViews:tabviews];
                }
                break;
                
            case orientTop:
            case  orientBottom:
                if (i == 0) {
                    // leftmost tab
                    NSDictionary *oneView = NSDictionaryOfVariableBindings(tab);
                    [tabBar addVisualConstraints:@"|[tab]" forViews:oneView];
                    [tabBar addVisualConstraints:@"V:|[tab]|" forViews:oneView];
                } else {
                    UIView *prevTab = [tabs objectAtIndex:(i - 1)];
                    NSDictionary *tabviews = NSDictionaryOfVariableBindings(tab, prevTab);
                    if (i == tabs.count - 1) {
                        // rightmost tab
                        if (IS_RETINA) [tabBar addVisualConstraints:@"[prevTab]-pixRetina-[tab(==prevTab)]|" forViews:tabviews withMetrics:FTB_METRICS];
                        else [tabBar addVisualConstraints:@"[prevTab]-pixel-[tab(==prevTab)]|" forViews:tabviews withMetrics:FTB_METRICS];
                        
                    } else {
                        // other tabs
                        if (IS_RETINA) [tabBar addVisualConstraints:@"[prevTab]-pixRetina-[tab(==prevTab)]" forViews:tabviews withMetrics:FTB_METRICS];
                        else [tabBar addVisualConstraints:@"[prevTab]-pixel-[tab(==prevTab)]" forViews:tabviews withMetrics:FTB_METRICS];
                    }
                    [tabBar addVisualConstraints:@"V:|[tab]|" forViews:tabviews];
                }
                break;
                
        }
        
    }

}

@end
