//
//  LoginViewController.m
//  Trickle
//
//  Created by Jordan Cheney on 3/2/14.
//  Copyright (c) 2014 PrimaryCrew. All rights reserved.
//

#import <Parse/Parse.h>

#import "LoginViewController.h"
#import "AppDelegate.h"

@interface LoginViewController () <PFSignUpViewControllerDelegate>

@end

@implementation LoginViewController

- (void)viewDidLoad:(BOOL)animated
{
    [super viewDidLoad];
	
    // If not logged in, we will show a PFLogInViewController
    self.facebookPermissions= @[@"friends_about_me"];
    PFSignUpViewController *signUpViewController = [[PFSignUpViewController alloc] init];
    signUpViewController.delegate = self;
    [self setSignUpController:signUpViewController];
        
    // Present LogInViewController
    [self presentViewController:self animated:YES completion:nil];
}

@end
