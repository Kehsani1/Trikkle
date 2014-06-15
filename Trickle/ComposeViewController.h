//
//  ComposeViewController.h
//  Trickle
//
//  Created by Jordan Cheney on 2/26/14.
//  Copyright (c) 2014 PrimaryCrew. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ComposeViewController : UIViewController

@property (nonatomic, strong) NSArray *tagged;
@property (nonatomic, strong) UITextField *textBox;
@property (nonatomic, strong) UIImage *picture;
@property (nonatomic, strong) UIButton *primaryButton;
@property (nonatomic, strong) UIButton *secondaryButton;
@property (nonatomic, strong) UIButton *tertiaryButton;

@end
