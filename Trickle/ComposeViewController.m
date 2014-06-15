//
//  ComposeViewController.m
//  Trickle
//
//  Created by Jordan Cheney on 2/26/14.
//  Copyright (c) 2014 PrimaryCrew. All rights reserved.
//
#include <Parse/Parse.h>

#import "ComposeViewController.h"
#import "MainViewController.h"
#import "SWRevealViewController.h"

#import "Cache.h"

@interface ComposeViewController () <UISearchDisplayDelegate, UIActionSheetDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate>

@end

@implementation ComposeViewController

@synthesize tagged = _tagged;
@synthesize textBox = _textBox;
@synthesize picture = _picture;
@synthesize primaryButton = _primaryButton;
@synthesize secondaryButton = _secondaryButton;
@synthesize tertiaryButton = _tertiaryButton;

- (void)viewDidLoad
{
    [super viewDidLoad];
	[self.view setBackgroundColor:[UIColor whiteColor]];
    
    UIBarButtonItem *cancelButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(cancelButtonAction:)];
    
    self.navigationItem.leftBarButtonItem = cancelButton;
    self.navigationItem.title = @"New Message";
    
    UIToolbar *topBar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 64, self.view.frame.size.width, 44)];
    
    UIBarButtonItem *toMessage = [[UIBarButtonItem alloc] initWithTitle:@"To:" style:UIBarButtonItemStylePlain target:self action:nil];
    [self makeButtons];
    UIBarButtonItem *tButton = [[UIBarButtonItem alloc] initWithCustomView:self.tertiaryButton];
    UIBarButtonItem *sButton = [[UIBarButtonItem alloc] initWithCustomView:self.secondaryButton];
    UIBarButtonItem *pButton = [[UIBarButtonItem alloc] initWithCustomView:self.primaryButton];
    UIBarButtonItem *flexibleSpace = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:self action:nil];
    UIBarButtonItem *addFriend = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:nil];
    
    [topBar setItems:[NSArray arrayWithObjects:toMessage, tButton, sButton, pButton, flexibleSpace, addFriend, nil] animated:YES];
    
    [self.view addSubview:topBar];
    
    self.textBox = [[UITextField alloc] initWithFrame:CGRectMake(10, 108, self.view.frame.size.width-20, self.view.frame.size.height/2-88)];
    [self.textBox setBackgroundColor:[UIColor whiteColor]];
    self.textBox.placeholder = @"Type message here";
    self.textBox.contentVerticalAlignment = UIControlContentVerticalAlignmentTop;
    [self.textBox becomeFirstResponder];
    
    [self.view addSubview:self.textBox];
    
    UIToolbar *bottomBar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height/2+25, self.view.frame.size.width, 44)];
    UIBarButtonItem *camera = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCamera target:self action:@selector(onCameraPush:)];
    UIBarButtonItem *send = [[UIBarButtonItem alloc] initWithTitle:@"Send" style:UIBarButtonItemStyleBordered target:self action:@selector(postButtonAction:)];
    [bottomBar setItems:[NSArray arrayWithObjects:camera, flexibleSpace, send, nil] animated:YES];
    
    [self.view addSubview:bottomBar];
}

- (void)makeButtons
{
    //Create the three buttons for pushing
    self.primaryButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 44, 44)];
    self.secondaryButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 44, 44)];
    self.tertiaryButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 44, 44)];
    
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
    
    self.primaryButton.titleLabel.textColor = [UIColor blueColor];
    self.secondaryButton.titleLabel.textColor = [UIColor blueColor];
    self.tertiaryButton.titleLabel.textColor = [UIColor blueColor];
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

#pragma mark - Button actions

- (IBAction)cancelButtonAction:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:NULL];
}

- (IBAction)postButtonAction:(id)sender
{
    PFObject *post = [PFObject objectWithClassName:@"Post"];
    [post setObject:[self.textBox text] forKey:@"content"];
    
    NSData *data = UIImageJPEGRepresentation(self.picture, 1.0f);
    PFFile *imageFile = [PFFile fileWithData:data];
    PFObject *postPicture = [PFObject objectWithClassName:@"pic"];
    [postPicture setObject:imageFile forKey:@"data"];
    
    [post setObject:postPicture forKey:@"picture"];
    [post setObject:[PFUser currentUser].username forKey:@"author"];
    [post setObject:[[PFUser currentUser] objectForKey:@"profilePic"] forKey:@"authorPic"];
    [post setObject:self.tagged forKey:@"targets"];
    [post setObject:[NSDate date] forKey:@"time"];
    
    [post saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if (!error) {
            [[Cache sharedCache] getPosts];
            [self dismissViewControllerAnimated:YES completion:NULL];
        }
    }];
}

- (IBAction)onCameraPush:(id)sender
{
    UIActionSheet *cameraChoices = [[UIActionSheet alloc] initWithTitle:@"" delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"Take a photo", @"Choose existing", nil];
    [cameraChoices showInView:self.view];
}

#pragma mark - ActionSheetDelegate
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == actionSheet.cancelButtonIndex) {
        return;
    }
    
    UIImagePickerController * imagePicker = [[UIImagePickerController alloc] init];
    imagePicker.allowsEditing = YES;
    if ([[actionSheet buttonTitleAtIndex:buttonIndex]  isEqual:@"Take a photo"]) {
        imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
    }
    else {
        imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    }
    
    imagePicker.delegate = self;
    [self presentViewController:imagePicker animated:YES completion:nil];
}

- (IBAction)onTertiaryPush:(id)sender
{
    self.tagged = [[Cache sharedCache] trickleFriends];
}
- (IBAction)onSecondaryPush:(id)sender
{
    NSArray *secondary = [[Cache sharedCache] secondaryCrew];
    NSArray *primary = [[Cache sharedCache] primaryCrew];
    self.tagged = [primary arrayByAddingObjectsFromArray:secondary];
}
- (IBAction)onPrimaryPush:(id)sender
{
    self.tagged = [[Cache sharedCache] primaryCrew];
}

#pragma mark - UIImagePickerDelegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    self.picture = [info objectForKey:UIImagePickerControllerEditedImage];
    self.textBox.leftView = [[UIImageView alloc] initWithImage:self.picture];
    [self dismissViewControllerAnimated:YES completion:nil];
}
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [self dismissViewControllerAnimated:YES completion:nil];
}
@end
