//
//  PhotoDescriptionViewController.h
//  MyPhotoCollections
//
//  Created by Sanny on 25.03.14.
//  Copyright (c) 2014 Sanny. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol PhotoDescriptionViewControllerDelegate;

@interface PhotoDescriptionViewController : UIViewController
@property (weak, nonatomic) IBOutlet UITextField *nameField;
@property (weak, nonatomic) IBOutlet UITextView *photoDescription;

@property (nonatomic, weak) id <PhotoDescriptionViewControllerDelegate> delegate;

- (IBAction)done:(id)sender;
- (IBAction)dismissKeyboard:(id)sender;
- (IBAction)clearNameField:(id)sender;
@end

@protocol PhotoDescriptionViewControllerDelegate

-(void)getPhotoName:(NSString *)photoName;
-(void)getPhotoDescription:(NSString *)photoDescription;

@end
