//
//  ViewController.m
//  Trickle
//
//  Created by Jordan Cheney on 2/25/14.
//  Copyright (c) 2014 PrimaryCrew. All rights reserved.
//

#import <Parse/Parse.h>

#import "MainViewController.h"
#import "AppDelegate.h"

#import "SWRevealViewController.h"

@interface MainViewController ()

@end

@implementation MainViewController

- (void)viewWillAppear:(BOOL)animated
{
    if (![PFUser currentUser]) {
        [(AppDelegate*)[[UIApplication sharedApplication] delegate] launchLogInViewController];
    }
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    [self.view setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"PlainBG.png"]]];
    
    SWRevealViewController *viewController = self.revealViewController;
    
    [viewController panGestureRecognizer];
    [viewController tapGestureRecognizer];
    
    UIBarButtonItem *revealButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"reveal-icon.png"] style:UIBarButtonItemStyleBordered target:viewController action:@selector(revealToggle:)];
    UIBarButtonItem *composeButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCompose target:self action:@selector(composeMessageAction:)];
    
    self.navigationItem.leftBarButtonItem = revealButton;
    self.navigationItem.rightBarButtonItem = composeButton;
    self.navigationItem.title = [PFUser currentUser].username;
    
    //Create the three crus
    UIButton *tertiary = [[UIButton alloc] init];
    UIButton *secondary = [[UIButton alloc] init];
    UIButton *primary = [[UIButton alloc] init];
    
    [tertiary addTarget:self action:@selector(onTertiaryPush:) forControlEvents:UIControlEventTouchUpInside];
    [secondary addTarget:self action:@selector(onSecondaryPush:) forControlEvents:UIControlEventTouchUpInside];
    [primary addTarget:self action:@selector(onPrimaryPush:) forControlEvents:UIControlEventTouchUpInside];
    
    //Set some convienience values and important radii
    CGFloat width = self.view.frame.size.width;
    CGFloat height = self.view.frame.size.height;
    
    CGFloat tertiaryRadius = width - 20;
    CGFloat secondaryRadius = width - 115;
    CGFloat primaryRadius = width - 225;
    
    [tertiary setFrame:CGRectMake(width/2 - tertiaryRadius/2, height/2 - tertiaryRadius/2, tertiaryRadius, tertiaryRadius)];
    [tertiary.layer setCornerRadius:tertiaryRadius/2];
    [secondary setFrame:CGRectMake(width/2 - secondaryRadius/2, height/2 - secondaryRadius/2, secondaryRadius, secondaryRadius)];
    [secondary.layer setCornerRadius:secondaryRadius/2];
    [primary setFrame:CGRectMake(width/2 - primaryRadius/2, height/2 - primaryRadius/2, primaryRadius, primaryRadius)];
    [primary.layer setCornerRadius:primaryRadius/2];
    
    [tertiary.layer setBackgroundColor:[UIColor whiteColor].CGColor];
    [secondary.layer setBackgroundColor:[UIColor whiteColor].CGColor];
    [primary.layer setBackgroundColor:[UIColor whiteColor].CGColor];
    
    [tertiary.layer setBorderColor:[UIColor blueColor].CGColor];
    [secondary.layer setBorderColor:[UIColor blueColor].CGColor];
    [primary.layer setBorderColor:[UIColor blueColor].CGColor];
    
    [tertiary.layer setBorderWidth:3.0f];
    [secondary.layer setBorderWidth:3.0f];
    [primary.layer setBorderWidth:3.0f];
    
    tertiary.clipsToBounds = YES;
    secondary.clipsToBounds = YES;
    primary.clipsToBounds = YES;
    
    [self.view addSubview:tertiary];
    [self.view addSubview:secondary];
    [self.view addSubview:primary];
}

#pragma mark - Handle new posts
- (void)postsWaiting:(NSArray *)posts
{
    for (int i = 0; i < [posts count]; i++) {
        
    }
}

#pragma mark - Handle Button Pushes
- (IBAction)composeMessageAction:(id)sender {
    [(AppDelegate*)[[UIApplication sharedApplication] delegate] handleComposeButtonPush];
}

- (IBAction)onTertiaryPush:(id)sender {
    [(AppDelegate*)[[UIApplication sharedApplication] delegate] handleCrewButtonPush:@"tertiary"];
}
- (IBAction)onSecondaryPush:(id)sender {
    [(AppDelegate*)[[UIApplication sharedApplication] delegate] handleCrewButtonPush:@"secondary"];
}
- (IBAction)onPrimaryPush:(id)sender {
    [(AppDelegate*)[[UIApplication sharedApplication] delegate] handleCrewButtonPush:@"primary"];
}

@end
