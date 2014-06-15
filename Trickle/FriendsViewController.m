//
//  FriendsViewController.m
//  Trickle
//
//  Created by Jordan Cheney on 3/6/14.
//  Copyright (c) 2014 PrimaryCrew. All rights reserved.
//

#import "FriendsViewController.h"
#import "FriendCell.h"

#import "Cache.h"

@interface FriendsViewController ()

@end

@implementation FriendsViewController

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
    self.navigationItem.title = @"Friends";
}

- (PFQuery *)queryForTable {
    NSArray *trickleFriends = [[Cache sharedCache] trickleFriends];
    
    PFQuery *friendsQuery = [PFUser query];
    [friendsQuery whereKey:@"username" containedIn:trickleFriends];
    
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
    
    if (cell == nil) {
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
    if ([friend objectForKey:@"pic"]) {
        cell.imageView.image = [friend objectForKey:@"pic"];
    } else {
        cell.imageView.image = [UIImage imageNamed:@"noPic.png"];
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
