//
//  PostCell.m
//  Trickle
//
//  Created by Jordan Cheney on 5/19/14.
//  Copyright (c) 2014 PrimaryCrew. All rights reserved.
//

#import "PostCell.h"

@implementation PostCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier post:(PFObject *)post
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        if ([post objectForKey:@"author"]) {
            NSString *message = [NSString stringWithFormat:@"%@ sent you a message!", [post objectForKey:@"author"]];
            self.textLabel.text = message;
            
        } else {
            self.textLabel.text = @"you got a message!";
        }
    }
    return self;
}

- (void)awakeFromNib
{
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
