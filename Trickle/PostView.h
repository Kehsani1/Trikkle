//
//  ViewController.h
//  Trickle
//
//  Created by Jordan Cheney on 5/19/14.
//  Copyright (c) 2014 PrimaryCrew. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>

@interface PostView : UIViewController
{
    PFObject *post;
}

- (id)initWithPost:(PFObject *)init_post;

@end
