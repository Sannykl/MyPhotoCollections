//
//  SettingsViewController.h
//  MyPhotoCollections
//
//  Created by Sanny on 25.03.14.
//  Copyright (c) 2014 Sanny. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Settings.h"

@interface SettingsViewController : UIViewController
@property (weak, nonatomic) IBOutlet UITextField *nameField;
@property (weak, nonatomic) IBOutlet UITextField *emailField;

- (IBAction)done:(id)sender;
- (IBAction)dismissKeyboard:(id)sender;
- (IBAction)clearNameField:(id)sender;
- (IBAction)clearEmailField:(id)sender;
@end
