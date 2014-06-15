//
//  AddFriendsMainViewController.m
//  Trickle
//
//  Created by Jordan Cheney on 3/5/14.
//  Copyright (c) 2014 PrimaryCrew. All rights reserved.
//

#import "AddFriendsMainViewController.h"
#import "AppDelegate.h"

@interface AddFriendsMainViewController () <UITableViewDelegate, UITableViewDataSource>

@end

@implementation AddFriendsMainViewController

@synthesize tableView = _tableView;

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    UIBarButtonItem *cancelButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(cancelButtonAction:)];
    
    self.navigationItem.leftBarButtonItem = cancelButton;
    self.navigationItem.title = @"Add Friends";
    
    
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 100, self.view.frame.size.width, 88) style:UITableViewStylePlain];
    
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    
    self.tableView.contentInset = UIEdgeInsetsMake(-64, 0, -60, 0);
    
    [self.view addSubview:self.tableView];
    [self.view setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"PlainBG.png"]]];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellID = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    NSInteger row = indexPath.row;
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellID];
        cell.accessoryView.backgroundColor = [UIColor blackColor];
    }
    
    if (row == 0) {
        cell.textLabel.text = @"Add friends with facebook";
    }
    else if (row == 1) {
        cell.textLabel.text = @"Add friends with trickle";
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger row = indexPath.row;
    if (row == 0) {
        [(AppDelegate*)[[UIApplication sharedApplication] delegate] handleAddFriendsWithFacebook];
    }
    else if (row == 1) {
        [(AppDelegate*)[[UIApplication sharedApplication] delegate] handleAddFriendsWithTrickle];
    }
}

#pragma mark - ()
- (IBAction)cancelButtonAction:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:NULL];
}

@end
