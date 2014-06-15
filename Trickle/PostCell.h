//
//  PostCell.h
//  Trickle
//
//  Created by Jordan Cheney on 5/19/14.
//  Copyright (c) 2014 PrimaryCrew. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>

@interface PostCell : UITableViewCell
{
    PFUser *author;
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier post:(PFObject *)post;

@end
