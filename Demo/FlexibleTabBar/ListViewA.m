//
//  ListViewA.m
//  FlexibleTabBar
//
//  Created by Amy Nugent on 29/08/13.
//  Copyright (c) 2013 Amy Nugent. All rights reserved.
//

#import "ListViewA.h"

@interface ListViewA () {
    NSArray *listOfItems;
}

@end

@implementation ListViewA


- (void)viewDidLoad
{
    [super viewDidLoad];
    // configure here
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"Cell"];
    listOfItems = [[NSArray alloc] initWithObjects:@"Apple",@"Orange",@"Pear",@"Pomengranate", nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return [listOfItems count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    // Configure the cell...
    cell.textLabel.text = [listOfItems objectAtIndex:indexPath.row];
    return cell;
}

@end
