//
//  AppDelegate.h
//  Trickle
//
//  Created by Jordan Cheney on 2/25/14.
//  Copyright (c) 2014 PrimaryCrew. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>

@class SWRevealViewController;
@class PFLogInViewController;

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) PFLogInViewController *loginViewController;
@property (strong, nonatomic) UIViewController *menuViewController;
@property (strong, nonatomic) SWRevealViewController *mainViewController;

@property (strong, nonatomic) NSMutableData *profilePic;

- (void)launchLogInViewController;
- (void)handleCrewButtonPush:(NSString *)crew;
- (void)handleComposeButtonPush;
- (void)handleSeeProfileButtonPush;
- (void)handleSeeFriendsButtonPush;
- (void)handleAddFriendsButtonPush;
- (void)handleSeeGroupsButtonPush;
- (void)handleAddFriendsWithFacebook;
- (void)handleAddFriendsWithTrickle;
- (void)logOut;

@end
