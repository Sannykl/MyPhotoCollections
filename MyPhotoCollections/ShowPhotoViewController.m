//
//  ShowPhotoViewController.m
//  MyPhotoCollections
//
//  Created by Sanny on 25.03.14.
//  Copyright (c) 2014 Sanny. All rights reserved.
//

#import "ShowPhotoViewController.h"
#import "PhotosController.h"
#import "CollectionsController.h"
#import "StorageController.h"
#import "MainViewController.h"
//#import "TwitterViewController.h"

@interface ShowPhotoViewController () <UIAlertViewDelegate>

@end

@implementation ShowPhotoViewController

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
    
    self.navigationItem.title = self.chosenPhoto.photoName;
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentDirectory = [paths objectAtIndex:0];
    NSString *imagePath = [documentDirectory stringByAppendingPathComponent:[NSString stringWithFormat:@"%@", self.chosenPhoto.photoFile]];
    
    self.showPhotoBlock.image = [UIImage imageWithContentsOfFile:imagePath];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    /*if ([segue.identifier isEqualToString:@"tweet"]) {
        TwitterViewController *twitter = (TwitterViewController *)[segue destinationViewController];
        twitter.photoToShare = self.chosenPhoto;
    }*/
}


- (IBAction)deletePhoto:(id)sender {
    UIAlertView *deleteAlert = [[UIAlertView alloc] initWithTitle:@"Attention" message:@"Do you want to delete this photo?" delegate:self cancelButtonTitle:@"NO" otherButtonTitles:@"YES", nil];
    [deleteAlert show];
}

- (IBAction)shareAction:(id)sender {
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentDirectory = [paths objectAtIndex:0];
    NSString *imagePath = [documentDirectory stringByAppendingPathComponent:[NSString stringWithFormat:@"%@", self.chosenPhoto.photoFile]];
    UIImage *image = [UIImage imageWithContentsOfFile:imagePath];
    
    SHKItem *item = [SHKItem image:image title:self.chosenPhoto.photoName];
    //item = [SHKItem text:self.chosenPhoto.photoDescription];
    
    SHKActionSheet *actionSheet = [SHKActionSheet actionSheetForItem:item];
    [actionSheet showFromToolbar:self.toolBar];
}

#pragma mark - Alert View Delegate section

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 1) {
        //NSLog(@"Collection name in ShowPhotoViewController: %@", self.chosenPhoto.collectionName);
        [[CollectionsController sharedController] isCollectionToDelete:self.chosenPhoto.collectionName];
        [[PhotosController sharedController] deletePhotoObject:self.chosenPhoto];
        [[StorageController sharedController] saveContext];
        
        if (![[CollectionsController sharedController] isEmptyCollection:self.chosenPhoto.collectionName]) {
            [self.delegate reloadCurrentCollection];
            [self.navigationController popViewControllerAnimated:YES];
        } else {
            [self.navigationController popToRootViewControllerAnimated:YES];
        }
    }
}


@end
