//
//  InformationViewController.m
//  Trickle
//
//  Created by Jordan Cheney on 2/27/14.
//  Copyright (c) 2014 PrimaryCrew. All rights reserved.
//

#import "InformationViewController.h"
#import "PostView.h"
#import "PostCell.h"

#import "Cache.h"

@interface InformationViewController ()

@end

@implementation InformationViewController

@synthesize crew = _crew;

- (id)initWithCrew:(NSString *)crewString
{
    self = [super init];
    if (self) {
        self.crew = crewString;
    }
    
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    UIBarButtonItem *cancelButton = [[UIBarButtonItem alloc] initWithTitle:@"Cancel" style:UIBarButtonItemStyleBordered target:self action:@selector(cancelButtonAction:)];
    
    self.navigationItem.leftBarButtonItem = cancelButton;
    self.navigationItem.title = self.crew;
    
    _posts = [[Cache sharedCache] posts];
    
    _postTable = [[UITableView alloc] initWithFrame:self.view.frame style:UITableViewStylePlain];
    _postTable.dataSource = self;
    _postTable.delegate = self;
    
    [self.view addSubview:_postTable];
}

#pragma mark - TableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_posts count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellID = @"Cell";
    PostCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    NSUInteger row = indexPath.row;
    
    if (!cell) {
        cell = [[PostCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellID post:[_posts objectAtIndex:row]];
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    PostView *postView = [[PostView alloc] initWithPost:[_posts objectAtIndex:indexPath.row]];
    UINavigationController *postNavigationController = [[UINavigationController alloc] initWithRootViewController:postView];
    [self presentViewController:postNavigationController animated:YES completion:nil];
}

- (IBAction)cancelButtonAction:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
