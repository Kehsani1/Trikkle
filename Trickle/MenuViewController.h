//
//  MenuViewController.h
//  Trickle
//
//  Created by Jordan Cheney on 2/26/14.
//  Copyright (c) 2014 PrimaryCrew. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MenuViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, retain) IBOutlet UITableView *tableView;

@end
