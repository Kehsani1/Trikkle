//
//  AddFriendsViewController.m
//  Trickle
//
//  Created by Jordan Cheney on 2/27/14.
//  Copyright (c) 2014 PrimaryCrew. All rights reserved.
//
#import <Parse/Parse.h>

#import "AddFriendsWithFacebookViewController.h"
#import "AppDelegate.h"
#import "FriendCell.h"

#import "Cache.h"

@interface AddFriendsWithFacebookViewController ()

@end

@implementation AddFriendsWithFacebookViewController

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
    self.navigationItem.title = @"Facebook";
}

- (PFQuery *)queryForTable {
    NSArray *facebookFriends = [[Cache sharedCache] facebookFriends];
    
    PFQuery *friendsQuery = [PFUser query];
    [friendsQuery whereKey:@"fbId" containedIn:facebookFriends];
    
    NSArray *trickleFriends = [[Cache sharedCache] trickleFriends];
    [friendsQuery whereKey:@"username" notContainedIn:trickleFriends];
    
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
    NSInteger row = indexPath.row;
    
    if (cell == nil) {
        cell = [[FriendCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellID];
    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    [cell setAssociatedUser:(PFUser *)object];
    
    if (([PFFacebookUtils isLinkedWithUser:[PFUser currentUser]])) {
        PFUser *friend = (PFUser *)object;
        NSString *username = friend.username;
        if ([username length] > 15) {
            username = [username substringToIndex:15];
            username = [username stringByAppendingString:@"..."];
        }
        cell.textLabel.text = username;
    }
    else if (row == 0) {
        cell.textLabel.text = @"Login in with Facebook to see friends";
    }
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
