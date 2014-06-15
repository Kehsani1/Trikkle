//
//  FriendCell.h
//  Trickle
//
//  Created by Jordan Cheney on 3/6/14.
//  Copyright (c) 2014 PrimaryCrew. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>

@interface FriendCell : UITableViewCell

@property (nonatomic, retain) PFUser *cellUser;
@property (nonatomic, retain) NSString *taggedButton;
@property (nonatomic, retain) UIButton *primaryButton;
@property (nonatomic, retain) UIButton *secondaryButton;
@property (nonatomic, retain) UIButton *tertiaryButton;

- (void)setAssociatedUser:(PFUser *)user;
- (void)setTaggedButton:(NSString *)taggedButton;

@end
