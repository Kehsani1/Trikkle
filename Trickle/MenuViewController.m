//
//  MenuViewController.m
//  Trickle
//
//  Created by Jordan Cheney on 2/26/14.
//  Copyright (c) 2014 PrimaryCrew. All rights reserved.
//

#import <Parse/Parse.h>
#import "MenuViewController.h"

#import "SWRevealViewController.h"
#import "AppDelegate.h"

@interface MenuViewController () 

@end

@implementation MenuViewController

@synthesize tableView = _tableView;

- (void)viewDidLoad
{
	[super viewDidLoad];
	
    self.title = NSLocalizedString(@"Menu", nil);
    
    self.tableView = [[UITableView alloc] initWithFrame:self.view.frame style:UITableViewStyleGrouped];

    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    
    [self.view addSubview:self.tableView];
    [self.view setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"PlainBG.png"]]];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSInteger numRows = 0;
    switch (section) {
        case 0:
            numRows = 4;
            break;
        case 1:
            numRows = 2;
            break;
        case 2:
            numRows = 1;
            break;
        default:
            numRows = 0;
            break;
    }
    return numRows;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellID = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    NSInteger section = indexPath.section;
    NSInteger row = indexPath.row;
    
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellID];
    }
    switch (section) {
        case 0:
            switch (row) {
                case 0:
                    cell.textLabel.text = @"Profile";
                    break;
                case 1:
                    cell.textLabel.text = @"Friends";
                    break;
                case 2:
                    cell.textLabel.text = @"Search For Friends";
                    break;
                case 3:
                    cell.textLabel.text = @"Groups";
                    break;
                default:
                    break;
            }
            break;
        case 1:
            switch (row) {
                case 0:
                    cell.textLabel.text = @"Settings";
                    break;
                case 1:
                    cell.textLabel.text = @"Add Passcode";
                    break;
                default:
                    break;
            }
        case 2:
            switch (row) {
                case 0:
                    cell.textLabel.text = @"Logout";
                    break;
                    
                default:
                    break;
            }
        default:
            break;
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger section = indexPath.section;
    NSInteger row = indexPath.row;
    
    switch (section) {
        case 0:
            switch (row) {
                case 0:
                    NSLog(@"Profile");
                    [(AppDelegate*)[[UIApplication sharedApplication] delegate] handleSeeProfileButtonPush];
                    break;
                case 1: {
                    NSLog(@"See friends");
                    [(AppDelegate*)[[UIApplication sharedApplication] delegate] handleSeeFriendsButtonPush];
                    break; }
                case 2:
                    NSLog(@"adding friends");
                    [(AppDelegate*)[[UIApplication sharedApplication] delegate] handleAddFriendsButtonPush];
                    break;
                case 3:
                    NSLog(@"See Groups");
                    [(AppDelegate*)[[UIApplication sharedApplication] delegate] handleSeeGroupsButtonPush];
                    break;
            }
            break;
        case 1:
            switch (row) {
                case 0:
                    NSLog(@"Opened settings window");
                    break;
                case 1:
                    NSLog(@"Opened add passcode window");
                    break;
                default:
                    break;
            }
        case 2:
            switch (row) {
                case 0: {
                    [(AppDelegate*)[[UIApplication sharedApplication] delegate] logOut];
                    break;
                }
                default:
                    break;
            }
        default:
            break;
    }
}
@end
