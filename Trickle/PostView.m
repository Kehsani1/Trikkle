//
//  ViewController.m
//  Trickle
//
//  Created by Jordan Cheney on 5/19/14.
//  Copyright (c) 2014 PrimaryCrew. All rights reserved.
//

#import "PostView.h"

@interface PostView ()

@end

@implementation PostView

- (id)initWithPost:(PFObject *)init_post
{
    self = [super init];
    if (self) {
        post = init_post;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    UIBarButtonItem *cancelButton = [[UIBarButtonItem alloc] initWithTitle:@"Cancel" style:UIBarButtonItemStyleBordered target:self action:@selector(cancelButtonAction:)];
    
    self.navigationItem.leftBarButtonItem = cancelButton;
    self.navigationItem.title = [NSString stringWithFormat:@"Message from %@", [post objectForKey:@"author"]];
    UILabel *author = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 50)];
    author.text = [post objectForKey:@"author"];
    [self.view addSubview:author];
}

- (IBAction)cancelButtonAction:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
