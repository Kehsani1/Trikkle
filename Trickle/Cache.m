//
//  Cache.m
//  Trickle
//
//  Created by Jordan Cheney on 2/28/14.
//  Copyright (c) 2014 PrimaryCrew. All rights reserved.
//

#import <Parse/Parse.h>

#import "Cache.h"

@implementation Cache

+ (id)sharedCache {
    static dispatch_once_t pred = 0;
    __strong static id _sharedObject = nil;
    dispatch_once(&pred, ^{
        _sharedObject = [[self alloc] init];
    });
    return _sharedObject;
}

- (id)init {
    self = [super init];
    if (self) {
        self.cache = [[NSCache alloc] init];
    }
    return self;
}

- (void)clear {
    [self.cache removeAllObjects];
}

- (void)updateProfilePicture:(UIImage *)pic
{
    [self.cache setObject:pic forKey:@"pic"];
    
    NSData *data = UIImageJPEGRepresentation(pic, 1.0f);
    PFFile *imageFile = [PFFile fileWithData:data];
    
    [imageFile saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if (!error) {
            PFObject *profilePicture = [PFObject objectWithClassName:@"pic"];
            [profilePicture setObject:imageFile forKey:@"data"];
            
            [[PFUser currentUser] setObject:profilePicture forKey:@"profilePic"];
        }
    }];
}
- (UIImage *)profilePicture
{
    if ([self.cache objectForKey:@"pic"]) {
        return [self.cache objectForKey:@"pic"];
    }
    @try {
        PFObject *profilePicture = [[PFUser currentUser] objectForKey:@"profilePic"];
        UIImage *pic = [UIImage imageWithData:[profilePicture objectForKey:@"data"]];
        [self.cache setObject:pic forKey:@"pic"];
        return pic;
    }
    @catch (NSException *exception) {
        NSLog(@"couldn't get picture");
    }
    @finally {
        return [UIImage imageNamed:@"noPic.png"];
    }
    
}
- (void)updateTrickleFriends:(NSArray *)trickleFriends
{
    [self.cache setObject:trickleFriends forKey:@"friends"];
    
    [[PFUser currentUser] setObject:trickleFriends forKey:@"friends"];
    [[PFUser currentUser] saveInBackground];
}
- (NSArray *)trickleFriends
{
    return [self.cache objectForKey:@"friends"];
}

- (void)updatePrimaryCrew:(NSArray *)primaryCrew
{
    [self.cache setObject:primaryCrew forKey:@"primary"];
    
    [[PFUser currentUser] setObject:primaryCrew forKey:@"primary"];
    [[PFUser currentUser] saveInBackground];
}
- (NSArray *)primaryCrew
{
    return [self.cache objectForKey:@"primary"];
}

- (void)updateSecondaryCrew:(NSArray *)secondaryCrew
{
    [self.cache setObject:secondaryCrew forKey:@"secondary"];
    
    [[PFUser currentUser] setObject:secondaryCrew forKey:@"secondary"];
    [[PFUser currentUser] saveInBackground];
}
- (NSArray *)secondaryCrew
{
    return [self.cache objectForKey:@"secondary"];
}

- (void)updateTertiaryCrew:(NSArray *)tertiaryCrew
{
    [self.cache setObject:tertiaryCrew forKey:@"tertiary"];
    
    [[PFUser currentUser] setObject:tertiaryCrew forKey:@"tertiary"];
    [[PFUser currentUser] saveInBackground];
}
- (NSArray *)tertiaryCrew
{
    return [self.cache objectForKey:@"tertiary"];
}

- (void)setFacebookFriends:(NSArray *)friends
{
    NSString *key = @"facebookFriends";
    [self.cache setObject:friends forKey:key];
}
- (NSArray *)facebookFriends {
    return [self.cache objectForKey:@"facebookFriends"];
}

- (void)getPosts
{
    PFQuery *postsQuery = [PFQuery queryWithClassName:@"Post"];
    [postsQuery whereKey:@"targets" equalTo:[PFUser currentUser].username];
    [postsQuery findObjectsInBackgroundWithBlock:^(NSArray *posts, NSError *error) {
        if (!error) {
            [self.cache setObject:posts forKey:@"posts"];
        }
    }];
}
- (NSArray *)posts
{
    return [self.cache objectForKey:@"posts"];
}

@end
