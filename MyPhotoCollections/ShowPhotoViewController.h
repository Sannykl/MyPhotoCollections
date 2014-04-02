//
//  ShowPhotoViewController.h
//  MyPhotoCollections
//
//  Created by Sanny on 25.03.14.
//  Copyright (c) 2014 Sanny. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Photo.h"
#import <SHKItem.h>
#import <SHKTwitter.h>
#import <SHKActionSheet.h>
#import "CurrentCollectionViewController.h"

@protocol ShowPhotoViewControllerDelegate;

@interface ShowPhotoViewController : UIViewController
@property (weak, nonatomic) IBOutlet UIImageView *showPhotoBlock;
@property (weak, nonatomic) IBOutlet UIToolbar *toolBar;

@property (nonatomic, strong) Photo *chosenPhoto;
@property (nonatomic, strong) NSString *photoName;
@property NSInteger indexOfPhoto;

@property id<ShowPhotoViewControllerDelegate> delegate;

- (IBAction)deletePhoto:(id)sender;
- (IBAction)shareAction:(id)sender;
@end

@protocol ShowPhotoViewControllerDelegate

@optional

- (void)reloadCurrentCollection;

@end
