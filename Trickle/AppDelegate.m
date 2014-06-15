//
//  AppDelegate.m
//  Trickle
//
//  Created by Jordan Cheney on 2/25/14.
//  Copyright (c) 2014 PrimaryCrew. All rights reserved.
//

#import <Parse/Parse.h>

#import "AppDelegate.h"
#import "LoginViewController.h"
#import "MainViewController.h"
#import "MenuViewController.h"
#import "InformationViewController.h"
#import "ComposeViewController.h"
#import "AddFriendsWithFacebookViewController.h"
#import "AddFriendsWithTrickleViewController.h"
#import "AddFriendsMainViewController.h"
#import "FriendsViewController.h"

#import "SWRevealViewController.h"
#import "Cache.h"

@interface AppDelegate() <SWRevealViewControllerDelegate, PFLogInViewControllerDelegate, PFSignUpViewControllerDelegate>

@end

@implementation AppDelegate

@synthesize window = _window;
@synthesize loginViewController = _loginViewController;
@synthesize menuViewController = _menuViewController;
@synthesize mainViewController = _mainViewController;
@synthesize profilePic = _profilePic;

#pragma mark - UIApplicationDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    
    //Initialize backend and social network
    [Parse setApplicationId:@"ZyTuiWFXMDB4JzEN4cNy4JvUa9oXgMq2i4EXp1fQ" clientKey:@"zf1TvXtJlaYrh49Qmon4VviVCt5H6FqQQbh5MnvP"];
    [PFFacebookUtils initializeFacebook];
    
    // Set default ACLs
    PFACL *defaultACL = [PFACL ACL];
    [defaultACL setPublicReadAccess:YES];
    [PFACL setDefaultACL:defaultACL withAccessForCurrentUser:YES];
    
    [self launchMainViewController];
    
    return YES;
}

- (void)launchLogInViewController
{
    self.loginViewController = [[LoginViewController alloc] init];
    self.loginViewController.delegate = self;
    self.loginViewController.fields = PFLogInFieldsUsernameAndPassword | PFLogInFieldsFacebook | PFLogInFieldsSignUpButton;
    [self.mainViewController presentViewController:self.loginViewController animated:YES completion:nil];
}

- (void)launchMainViewController
{
    //Create main view and set it to window
    MainViewController *frontViewController = [[MainViewController alloc] init];
    MenuViewController *menuViewController = [[MenuViewController alloc] init];
    
    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:frontViewController];
    UINavigationController *menuNavigationController = [[UINavigationController alloc] initWithRootViewController:menuViewController];
    
    SWRevealViewController *revealController = [[SWRevealViewController alloc] initWithRearViewController:menuNavigationController frontViewController:navigationController];
    revealController.delegate = self;
    
    self.mainViewController = revealController;
    
    [self performSelectorInBackground:@selector(updateCache:) withObject:nil];
    
    if ([PFFacebookUtils isLinkedWithUser:[PFUser currentUser]]) {
        [self performSelectorInBackground:@selector(getFacebookFriends:) withObject:nil];
    }
    
    self.window.rootViewController = self.mainViewController;
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
}

#pragma mark - Facebook Initializations
- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url
{
    return [PFFacebookUtils handleOpenURL:url];
}

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url
  sourceApplication:(NSString *)sourceApplication annotation:(id)annotation
{
    return [FBAppCall handleOpenURL:url
                  sourceApplication:sourceApplication
                        withSession:[PFFacebookUtils session]];
}

#pragma mark - LoginViewDelegate
- (void)logInViewController:(PFLogInViewController *)logInController didLogInUser:(PFUser *)user
{
    //See if user is a first time facebook user and get there facebookID and profile picture if they are
    if ([PFFacebookUtils isLinkedWithUser:user] || ![user objectForKey:@"fbId"]) {
        [FBRequestConnection
         startForMeWithCompletionHandler:^(FBRequestConnection *connection, id result, NSError *error) {
             if (!error) {
                 NSString *facebookId = [result objectForKey:@"id"];
                 // URL should point to https://graph.facebook.com/{facebookId}/picture?type=large&return_ssl_resources=1
                 NSURL *pictureURL = [NSURL URLWithString:[NSString stringWithFormat:@"https://graph.facebook.com/%@/picture?type=large&return_ssl_resources=1", facebookId]];
             
                 NSMutableURLRequest *urlRequest = [NSMutableURLRequest requestWithURL:pictureURL cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:2.0f];
                 // Run network request asynchronously
                 NSURLConnection *urlConnection = [[NSURLConnection alloc] initWithRequest:urlRequest delegate:self];
                 
                 self.profilePic = [[NSMutableData alloc] init];
                 [user setObject:facebookId forKey:@"fbId"];
                 [user saveInBackground];
                 
             }
         }];
    }
    [self launchMainViewController];
    [self.loginViewController dismissViewControllerAnimated:YES completion:NULL];
}

// Sent to the delegate when the log in attempt fails.
- (void)logInViewController:(PFLogInViewController *)logInController didFailToLogInWithError:(NSError *)error
{
    NSLog(@"Failed to log in...");
}

- (void)getFacebookFriends:(id)result
{
    // Issue a Facebook Graph API request to get your user's friend list
    [FBRequestConnection startWithGraphPath:@"me/friends" parameters:@{@"fields":@"name,installed,first_name,picture"} HTTPMethod:@"GET" completionHandler:^(FBRequestConnection *connection, id result, NSError *error) {
        if (!error) {
            NSArray *friendObjects = [result objectForKey:@"data"];
            NSMutableArray *friends = [NSMutableArray arrayWithObject:[friendObjects objectAtIndex:0]];
            for (NSDictionary *friendObject in friendObjects) {
                if ([[friendObject objectForKey:@"installed"] boolValue]) {
                    [friends addObject:friendObject];
                }
            }
            [[Cache sharedCache] setFacebookFriends:friends];
        }
    }];
}

- (void)updateCache:(id)result
{
    NSArray *friends = [[PFUser currentUser] objectForKey:@"friends"];
    NSArray *primary = [[PFUser currentUser] objectForKey:@"primary"];
    NSArray *secondary = [[PFUser currentUser] objectForKey:@"secondary"];
    NSArray *tertiary = [[PFUser currentUser] objectForKey:@"tertiary"];
        
    if (friends) { [[Cache sharedCache] updateTrickleFriends:friends]; }
    else { [[Cache sharedCache] updateTrickleFriends:[[NSMutableArray alloc] initWithCapacity:0]]; }
    if (primary) { [[Cache sharedCache] updatePrimaryCrew:primary]; }
    else { [[Cache sharedCache] updatePrimaryCrew:[[NSMutableArray alloc] initWithCapacity:0]]; }
    if (secondary) { [[Cache sharedCache] updateSecondaryCrew:secondary]; }
    else { [[Cache sharedCache] updateSecondaryCrew:[[NSMutableArray alloc] initWithCapacity:0]]; }
    if (tertiary) { [[Cache sharedCache] updateTertiaryCrew:tertiary]; }
    else { [[Cache sharedCache] updateTertiaryCrew:[[NSMutableArray alloc] initWithCapacity:0]]; }
    
    [[Cache sharedCache] getPosts];
}

#pragma mark - URLConnectionDelegate
// Called every time a chunk of the data is received
- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
    [self.profilePic appendData:data]; // Build the image
}

// Called when the entire image is finished downloading
- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
    [[Cache sharedCache] updateProfilePicture:[UIImage imageWithData:self.profilePic]];
}

#pragma mark - MainViewControllerDelegate
- (void)updatePostCircles
{
    NSArray *posts = [[Cache sharedCache] posts];
}
- (void)handleCrewButtonPush:(NSString *)crew
{
    InformationViewController *infoViewController = [[InformationViewController alloc] initWithCrew:crew];
    UINavigationController *infoNavigationController = [[UINavigationController alloc] initWithRootViewController:infoViewController];
    [self.mainViewController presentViewController:infoNavigationController animated:YES completion:nil];
}

- (void)handleComposeButtonPush
{
    ComposeViewController *composeViewController = [[ComposeViewController alloc] init];
    UINavigationController *composeNavigationController = [[UINavigationController alloc] initWithRootViewController:composeViewController];
    [self.mainViewController presentViewController:composeNavigationController animated:YES completion:nil];
}

#pragma mark - MenuViewControllerDelegate
- (void)handleSeeProfileButtonPush
{
    return;
}

- (void)handleSeeFriendsButtonPush
{
    self.menuViewController = [[FriendsViewController alloc] init];
    UINavigationController *friendsNavController = [[UINavigationController alloc] initWithRootViewController:self.menuViewController];
    [self.mainViewController presentViewController:friendsNavController animated:YES completion:nil];
}

- (void)handleAddFriendsButtonPush
{
    self.menuViewController = [[AddFriendsMainViewController alloc] init];
    UINavigationController *addFriendsMainNavigationController = [[UINavigationController alloc]initWithRootViewController:self.menuViewController];
    [self.mainViewController presentViewController:addFriendsMainNavigationController animated:YES completion:nil];
}

- (void)handleSeeGroupsButtonPush
{
    
}

- (void)handleAddFriendsWithFacebook
{
    AddFriendsWithFacebookViewController *addFriendsFacebookViewController = [[AddFriendsWithFacebookViewController alloc] init];
    UINavigationController *addFriendsWithFacebookNavController = [[UINavigationController alloc] initWithRootViewController:addFriendsFacebookViewController];
    [self.menuViewController presentViewController:addFriendsWithFacebookNavController animated:YES completion:nil];
}

- (void)handleAddFriendsWithTrickle
{
    AddFriendsWithTrickleViewController *addFriendsTrickleViewController = [[AddFriendsWithTrickleViewController alloc] init];
    UINavigationController *addFriendsWithTrickleNavController = [[UINavigationController alloc]initWithRootViewController:addFriendsTrickleViewController];
    [self.menuViewController presentViewController:addFriendsWithTrickleNavController animated:YES completion:nil];
}

- (void)logOut
{
    [[Cache sharedCache] clear];
    
    // Clear all caches
    [PFQuery clearAllCachedResults];
    
    // Log out
    [PFUser logOut];
    
    [self launchLogInViewController];
}

@end