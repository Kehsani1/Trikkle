//
//  InformationViewController.h
//  Trickle
//
//  Created by Jordan Cheney on 2/27/14.
//  Copyright (c) 2014 PrimaryCrew. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>

@interface InformationViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, retain) IBOutlet UITableView *postTable;
@property (nonatomic, strong) NSString *crew;
@property (nonatomic, strong) NSArray *posts;

- (id)initWithCrew:(NSString *)crewString;

@end
