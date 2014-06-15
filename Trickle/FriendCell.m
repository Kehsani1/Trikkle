//
//  FriendCell.m
//  Trickle
//
//  Created by Jordan Cheney on 3/6/14.
//  Copyright (c) 2014 PrimaryCrew. All rights reserved.
//

#import <Parse/Parse.h>

#import "FriendCell.h"

#import "Cache.h"

@implementation FriendCell

@synthesize cellUser = _cellUser;
@synthesize taggedButton = _taggedButton;
@synthesize primaryButton = _primaryButton;
@synthesize secondaryButton = _secondaryButton;
@synthesize tertiaryButton = _tertiaryButton;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.taggedButton = @"None";
        self.textLabel.font = [self.textLabel.font fontWithSize:12.0f];
        
        //Create the three buttons for pushing
        self.primaryButton = [[UIButton alloc] initWithFrame:CGRectMake(self.frame.size.width-132, 0, 44, 44)];
        self.secondaryButton = [[UIButton alloc] initWithFrame:CGRectMake(self.frame.size.width-88, 0, 44, 44)];
        self.tertiaryButton = [[UIButton alloc] initWithFrame:CGRectMake(self.frame.size.width-44, 0, 44, 44)];
        
        [self.tertiaryButton addTarget:self action:@selector(onTertiaryPush:) forControlEvents:UIControlEventTouchDown];
        [self.secondaryButton addTarget:self action:@selector(onSecondaryPush:) forControlEvents:UIControlEventTouchDown];
        [self.primaryButton addTarget:self action:@selector(onPrimaryPush:) forControlEvents:UIControlEventTouchDown];
        
        int radius = 15;
        
        [self.primaryButton.layer addSublayer:[self makeCircle:radius]];
        [self.secondaryButton.layer addSublayer:[self makeCircle:radius]];
        [self.tertiaryButton.layer addSublayer:[self makeCircle:radius]];
        
        [self.primaryButton setTitle:@"P" forState:UIControlStateNormal];
        [self.secondaryButton setTitle:@"S" forState:UIControlStateNormal];
        [self.tertiaryButton setTitle:@"T" forState:UIControlStateNormal];
        
        [self.primaryButton setTitleColor:[UIColor blueColor] forState:(UIControlStateNormal | UIControlStateSelected | UIControlStateHighlighted)];
        [self.secondaryButton setTitleColor:[UIColor blueColor] forState:(UIControlStateNormal | UIControlStateSelected | UIControlStateHighlighted)];
        [self.tertiaryButton setTitleColor:[UIColor blueColor] forState:(UIControlStateNormal | UIControlStateSelected | UIControlStateHighlighted)];
        
        [self addSubview:self.primaryButton];
        [self addSubview:self.secondaryButton];
        [self addSubview:self.tertiaryButton];
    }
    return self;
}

- (CAShapeLayer *)makeCircle:(int)radius
{
    CAShapeLayer *circle = [CAShapeLayer layer];
    // Make a circular shape
    circle.path = [UIBezierPath bezierPathWithRoundedRect:CGRectMake(0, 0, 2.0*radius, 2.0*radius)
                                             cornerRadius:radius].CGPath;
    circle.fillColor = [UIColor clearColor].CGColor;
    circle.strokeColor = [UIColor blueColor].CGColor;
    circle.lineWidth = 1;
    
    circle.position = CGPointMake(22-radius, 22-radius);
    
    return circle;
}

- (void)setAssociatedUser:(PFUser *)user
{
    self.cellUser = user;
}

//- (void)setTaggedButton:(NSString *)taggedButton
//{
//    self.taggedButton = taggedButton;
//}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

#pragma mark - ()
- (void)buttonHelper:(NSString *)button on:(BOOL)on
{
    UIColor *textColor = [UIColor blueColor];
    UIColor *fillColor = [UIColor clearColor];
    if (on) {
        textColor = [UIColor greenColor];
        fillColor = [UIColor blueColor];
    }
    
    UIButton *tButton = nil;
    if ([button isEqualToString:@"primary"]) { tButton = self.primaryButton; }
    if ([button isEqualToString:@"secondary"]) { tButton = self.secondaryButton; }
    if ([button isEqualToString:@"tertiary"]) { tButton = self.tertiaryButton; }

    [tButton setTitleColor:textColor forState:(UIControlStateSelected | UIControlStateHighlighted | UIControlStateNormal)];
    CAShapeLayer *circle = [[[tButton layer] sublayers] objectAtIndex:0];
    circle.fillColor = fillColor.CGColor;
}

- (void)trickleFriendsHelper:(BOOL)add
{
    NSArray *trickleFriends = [[Cache sharedCache] trickleFriends];
    NSMutableArray *newTrickleFriends = [[NSMutableArray alloc] initWithArray:trickleFriends];
    
    if (add) { [newTrickleFriends addObject:self.cellUser.username]; }
    else { [newTrickleFriends removeObject:self.cellUser.username]; }
    
    [[Cache sharedCache] updateTrickleFriends:newTrickleFriends];
}

- (IBAction)onTertiaryPush:(id)sender
{
    BOOL isNone = [self.taggedButton isEqualToString:@"None"];
    if (isNone) {
        [self buttonHelper:@"tertiary" on:YES];
    } else {
        [self buttonHelper:self.taggedButton on:NO];
        if (![self.taggedButton isEqualToString:@"tertiary"]) { [self buttonHelper:@"tertiary" on:YES]; }
    }
    
    NSLog(@"%@", self.tertiaryButton.titleLabel.textColor);
    
    NSArray *crew = nil;
    if ([self.taggedButton isEqualToString:@"primary"]) { crew = [[Cache sharedCache] primaryCrew]; }
    else if ([self.taggedButton isEqualToString:@"secondary"]) { crew = [[Cache sharedCache] secondaryCrew]; }
    else if ([self.taggedButton isEqualToString:@"tertiary"] || isNone) { crew = [[Cache sharedCache] tertiaryCrew]; }
    
    NSMutableArray *newCrew = [[NSMutableArray alloc] initWithArray:crew];
    if (isNone) { [newCrew addObject:self.cellUser.username]; }
    else { [newCrew removeObject:self.cellUser.username]; }
    
    if ([self.taggedButton isEqualToString:@"primary"]) { [[Cache sharedCache] updatePrimaryCrew:newCrew]; }
    else if ([self.taggedButton isEqualToString:@"secondary"]) { [[Cache sharedCache] updateSecondaryCrew:newCrew]; }
    else if ([self.taggedButton isEqualToString:@"tertiary"] || isNone) {
        [[Cache sharedCache] updateTertiaryCrew:newCrew];
        [self trickleFriendsHelper:isNone];
    }
    
    if ([self.taggedButton isEqualToString:@"tertiary"]) { self.taggedButton = @"None"; }
    else { self.taggedButton = @"tertiary"; }
}
- (IBAction)onSecondaryPush:(id)sender
{
    BOOL isNone = [self.taggedButton isEqualToString:@"None"];
    if (isNone) {
        [self buttonHelper:@"secondary" on:YES];
    } else {
        [self buttonHelper:self.taggedButton on:NO];
        if (![self.taggedButton isEqualToString:@"secondary"]) { [self buttonHelper:@"secondary" on:YES]; }
    }
    
    NSArray *crew = nil;
    if ([self.taggedButton isEqualToString:@"primary"]) { crew = [[Cache sharedCache] primaryCrew]; }
    else if ([self.taggedButton isEqualToString:@"secondary"] || isNone) { crew = [[Cache sharedCache] secondaryCrew]; }
    else if ([self.taggedButton isEqualToString:@"tertiary"]) { crew = [[Cache sharedCache] tertiaryCrew]; }
    
    NSMutableArray *newCrew = [[NSMutableArray alloc] initWithArray:crew];
    if (isNone) { [newCrew addObject:self.cellUser.username]; }
    else { [newCrew removeObject:self.cellUser.username]; }
    
    if ([self.taggedButton isEqualToString:@"primary"]) { [[Cache sharedCache] updatePrimaryCrew:newCrew]; }
    else if ([self.taggedButton isEqualToString:@"secondary"] || isNone) {
        [[Cache sharedCache] updateSecondaryCrew:newCrew];
        [self trickleFriendsHelper:isNone];
    }
    else if ([self.taggedButton isEqualToString:@"tertiary"]) { [[Cache sharedCache] updateTertiaryCrew:newCrew]; }
    
    if ([self.taggedButton isEqualToString:@"secondary"]) { self.taggedButton = @"None"; }
    else { self.taggedButton = @"secondary"; }
}
- (IBAction)onPrimaryPush:(id)sender
{
    BOOL isNone = [self.taggedButton isEqualToString:@"None"];
    if (isNone) {
        [self buttonHelper:@"primary" on:YES];
    } else {
        [self buttonHelper:self.taggedButton on:NO];
        if (![self.taggedButton isEqualToString:@"primary"]) { [self buttonHelper:@"primary" on:YES]; }
    }
    
    NSArray *crew = nil;
    if ([self.taggedButton isEqualToString:@"primary"] || isNone) { crew = [[Cache sharedCache] primaryCrew]; }
    else if ([self.taggedButton isEqualToString:@"secondary"]) { crew = [[Cache sharedCache] secondaryCrew]; }
    else if ([self.taggedButton isEqualToString:@"tertiary"]) { crew = [[Cache sharedCache] tertiaryCrew]; }
    
    NSMutableArray *newCrew = [[NSMutableArray alloc] initWithArray:crew];
    if (isNone) { [newCrew addObject:self.cellUser.username]; }
    else { [newCrew removeObject:self.cellUser.username]; }
    
    if ([self.taggedButton isEqualToString:@"primary"] || isNone) {
        [[Cache sharedCache] updatePrimaryCrew:newCrew];
        [self trickleFriendsHelper:isNone];
    }
    else if ([self.taggedButton isEqualToString:@"secondary"]) { [[Cache sharedCache] updateSecondaryCrew:newCrew]; }
    else if ([self.taggedButton isEqualToString:@"tertiary"]) { [[Cache sharedCache] updateTertiaryCrew:newCrew]; }
    
    if ([self.taggedButton isEqualToString:@"primary"]) { self.taggedButton = @"None"; }
    else { self.taggedButton = @"primary"; }
}

@end