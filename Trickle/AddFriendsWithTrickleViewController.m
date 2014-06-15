//
//  AddFriendsWithTrickleViewController.m
//  Trickle
//
//  Created by Jordan Cheney on 3/4/14.
//  Copyright (c) 2014 PrimaryCrew. All rights reserved.
//
#import <Parse/Parse.h>

#import "AddFriendsWithTrickleViewController.h"
#import "FriendCell.h"
#import "AppDelegate.h"

#import "Cache.h"

@interface AddFriendsWithTrickleViewController () <UISearchDisplayDelegate>

@end

@implementation AddFriendsWithTrickleViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self)
    {
        self.pullToRefreshEnabled = YES;
        self.objectsPerPage = 15;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    UIBarButtonItem *cancelButton = [[UIBarButtonItem alloc] initWithTitle:@"Done" style:UIBarButtonItemStylePlain target:self action:@selector(cancelButtonAction:)];
    
    self.navigationItem.leftBarButtonItem = cancelButton;
    self.navigationItem.title = @"Trickle";
    
	UISearchBar *searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 30)];
    UISearchDisplayController *searchDisplayController = [[UISearchDisplayController alloc] initWithSearchBar:searchBar contentsController:self];
    searchDisplayController.delegate = self;
    searchDisplayController.searchResultsDataSource = self;
    
    self.tableView.tableHeaderView = searchBar;
}

- (PFQuery *)queryForTable {
    PFQuery *friendsQuery = [PFUser query];

    [friendsQuery whereKey:@"username" notContainedIn:[[Cache sharedCache] trickleFriends]];
    
    friendsQuery.cachePolicy = kPFCachePolicyNetworkOnly;
    
    if (self.objects.count == 0) {
        friendsQuery.cachePolicy = kPFCachePolicyCacheThenNetwork;
    }
    
    [friendsQuery orderByAscending:@"displayName"];
    
    return friendsQuery;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath object:(PFObject *)object
{
    static NSString *cellID = @"Cell";
    FriendCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    
    if (cell == nil)
    {
        cell = [[FriendCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    [cell setAssociatedUser:(PFUser *)object];
    
    PFUser *friend = (PFUser *)object;
    NSString *username = friend.username;
    if ([username length] > 15) {
        username = [username substringToIndex:15];
        username = [username stringByAppendingString:@"..."];
    }
    cell.textLabel.text = username;
    
    return cell;
}

- (NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    FriendCell *cell = (FriendCell *)[tableView cellForRowAtIndexPath:indexPath];
    if (cell.selectionStyle == UITableViewCellSelectionStyleNone) {
        return nil;
    }
    return indexPath;
}

- (IBAction)cancelButtonAction:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:NULL];
}

@end
