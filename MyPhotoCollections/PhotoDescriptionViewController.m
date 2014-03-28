//
//  PhotoDescriptionViewController.m
//  MyPhotoCollections
//
//  Created by Sanny on 25.03.14.
//  Copyright (c) 2014 Sanny. All rights reserved.
//

#import "PhotoDescriptionViewController.h"

@interface PhotoDescriptionViewController ()

@end

@implementation PhotoDescriptionViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*-(BOOL)isReadyToSave {
 BOOL yes = YES;
 
 if ([self.photoDescription.text isEqualToString:@""] || [self.photoDescription.text isEqualToString:@"Photo description"] || [self.nameField.text isEqualToString:@""] || [self.nameField.text isEqualToString:@"Photo name"]) {
 yes = NO;
 }
 
 return yes;
 }*/

- (IBAction)done:(id)sender {
    //if ([self isReadyToSave]) {
    [self.delegate getPhotoName:self.nameField.text];
    [self.delegate getPhotoDescription:self.photoDescription.text];
    [self dismissViewControllerAnimated:YES completion:nil];
    /*} else {
     UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error!" message:@"Please, enter photos name and description" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
     [alert show];
     }*/
}

- (IBAction)dismissKeyboard:(id)sender {
    [self.view endEditing:YES];
    
    if ([self.nameField.text isEqualToString:@""]) {
        [self.nameField setText:@"Photo name"];
    }
}

- (IBAction)clearNameField:(id)sender {
    if ([self.nameField.text isEqualToString:@"Photo name"]) {
        [self.nameField setText:@""];
    }
}
@end
