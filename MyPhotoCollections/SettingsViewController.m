//
//  SettingsViewController.m
//  MyPhotoCollections
//
//  Created by Sanny on 25.03.14.
//  Copyright (c) 2014 Sanny. All rights reserved.
//

#import "SettingsViewController.h"
#import "SettingsController.h"

@interface SettingsViewController ()

@end

@implementation SettingsViewController

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
    
    self.nameField.text = [SettingsController sharedController].settings.name;
    self.emailField.text = [SettingsController sharedController].settings.email;
    
    /*NSError *error = nil;
     if (![[SettingsController sharedController].fetchedResultsController performFetch:&error]) {
     NSLog(@"Error: %@", error);
     }*/
    
    //NSLog(@"%@", self.nameField);
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)done:(id)sender {
    [SettingsController sharedController].settings.name = self.nameField.text;
    [SettingsController sharedController].settings.email = self.emailField.text;
    
    //NSLog(@"%@", [SettingsController sharedController].settings);
    [[SettingsController sharedController] saveSettings];
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)dismissKeyboard:(id)sender {
    [self.view endEditing:YES];
    
    if ([self.nameField.text isEqualToString:@""]) {
        [self.nameField setText:@"Your name"];
    }
    
    if ([self.emailField.text isEqualToString:@""]) {
        [self.emailField setText:@"Your e-mail"];
    }
}

- (IBAction)clearNameField:(id)sender {
    if ([self.nameField.text isEqualToString:@"Your name"]) {
        [self.nameField setText:@""];
    }
}

- (IBAction)clearEmailField:(id)sender {
    if ([self.emailField.text isEqualToString:@"Your e-mail"]) {
        [self.emailField setText:@""];
    }
}

#pragma mark - Fetched Results Controller section

@end

