//
//  Cache.h
//  Trickle
//
//  Created by Jordan Cheney on 2/28/14.
//  Copyright (c) 2014 PrimaryCrew. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Cache : NSObject

@property (nonatomic, strong) NSCache *cache;

+ (id)sharedCache;

- (void)clear;

- (void)updateProfilePicture:(UIImage *)pic;
- (UIImage *)profilePicture;

- (void)updateTrickleFriends:(NSArray *)trickleFriends;
- (NSArray *)trickleFriends;

- (void)updatePrimaryCrew:(NSArray *)primaryCrew;
- (NSArray *)primaryCrew;

- (void)updateSecondaryCrew:(NSArray *)secondaryCrew;
- (NSArray *)secondaryCrew;

- (void)updateTertiaryCrew:(NSArray *)tertiaryCrew;
- (NSArray *)tertiaryCrew;

- (void)setFacebookFriends:(NSArray *)friends;
- (NSArray *)facebookFriends;

- (void)getPosts;
- (NSArray *)posts;

@end
