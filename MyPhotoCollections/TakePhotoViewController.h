//
//  TakePhotoViewController.h
//  MyPhotoCollections
//
//  Created by Sanny on 25.03.14.
//  Copyright (c) 2014 Sanny. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Collection.h"
#import "Photo.h"

@protocol  TakePhotoViewControllerDelegate;

@interface TakePhotoViewController : UIViewController

@property (nonatomic, strong) NSString *location;
@property (nonatomic, strong) NSDate *creationDate;

@property (weak, nonatomic) IBOutlet UIImageView *photoBlock;
@property (nonatomic, strong) UIImage *myPhoto;
@property (nonatomic, strong) UIImage *photoWithFilters;
@property (nonatomic, strong) Collection *currentCollection;
@property (nonatomic, strong) Photo *currentPhoto;
@property (nonatomic, weak) id <TakePhotoViewControllerDelegate> delegate;

@property (nonatomic, strong) NSManagedObjectContext *managedObjectContext;

- (IBAction)cancel:(id)sender;
- (IBAction)enterCollection:(id)sender;
- (IBAction)addDescription:(id)sender;
- (IBAction)addEffects:(id)sender;
- (IBAction)savePhoto:(id)sender;
@end

@protocol TakePhotoViewControllerDelegate

-(void)takeViewControllerDidSave;
-(void)takeViewControllerDidCancel:(Collection *)collectionToDelete;

@end
