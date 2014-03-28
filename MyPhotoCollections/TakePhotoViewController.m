//
//  TakePhotoViewController.m
//  MyPhotoCollections
//
//  Created by Sanny on 25.03.14.
//  Copyright (c) 2014 Sanny. All rights reserved.
//

#import "TakePhotoViewController.h"
#import "ChooseCollectionViewController.h"
#import "PhotoDescriptionViewController.h"
#import "PhotoFiltersViewController.h"
#import "MainViewController.h"
#import "PhotosController.h"
#import "CollectionsController.h"

@interface TakePhotoViewController () <ChooseCollectionViewControllerDelegate, PhotoDescriptionViewControllerDelegate, PhotoFiltersViewControllerDelegate>

@property (nonatomic, strong) NSString *collectionName;
@property (nonatomic, strong) NSString *photoName;
@property (nonatomic, strong) NSString *photoDescription;
@property (nonatomic, strong) NSNumber *numberOfPhoto;
@property BOOL imageWithFilter;

@end

@implementation TakePhotoViewController

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
    [self.photoBlock setImage:self.myPhoto];
    
    //self.currentPhoto = (Photo *)[NSEntityDescription entityForName:@"Photo" inManagedObjectContext:self.managedObjectContext];
    //[[PhotosController sharedController] createPhotoObject];
    
    [self setLocation:@"Ukraine, Cherkassy"];
    [self setCreationDate:[NSDate date]];
    //[self setNumberOfPhoto:[NSNumber numberWithInt:10]];
    
    self.collectionName = [self.currentCollection collectionName];
    self.photoName = [self.currentCollection titlePhoto];
    self.numberOfPhoto = [self.currentCollection imagesCount];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"chooseCollection"]) {
        ChooseCollectionViewController *chooseCollection = (ChooseCollectionViewController *)[segue destinationViewController];
        chooseCollection.delegate = self;
    }
    
    if ([segue.identifier isEqualToString:@"enterDescription"]) {
        PhotoDescriptionViewController *photoViewController = (PhotoDescriptionViewController *)[segue destinationViewController];
        photoViewController.delegate = self;
    }
    
    if ([segue.identifier isEqualToString:@"addEffects"]) {
        PhotoFiltersViewController *filtersController = (PhotoFiltersViewController *)[segue destinationViewController];
        /*if (self.imageWithFilter) {
         filtersController.originalImage = self.photoWithFilters;
         } else {
         filtersController.originalImage = self.myPhoto;
         }*/
        filtersController.originalImage = self.myPhoto;
        filtersController.delegate = self;
    }
    
}

- (IBAction)cancel:(id)sender {
    [[PhotosController sharedController] deletePhotoObject:[PhotosController sharedController].photo];
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (BOOL)isFullDescription {
    BOOL full = YES;
    if (self.collectionName == nil || [self.collectionName isEqualToString:@""] || self.photoName == nil || [self.photoName isEqualToString:@""] || self.photoDescription == nil || [self.photoDescription isEqualToString:@""]) {
        full = NO;
    }
    return full;
}

- (IBAction)savePhoto:(id)sender {
    //NSLog(@"Fetch Result: %@", [[PhotosController sharedController].fetchedResultsController fetchedObjects]);
    
    if (![self isFullDescription]) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Attention!" message:@"Befor saving You have to choose collection, enter images name and description" delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
        [alertView show];
    } else {
        
        [[PhotosController sharedController].photo setPhotoName:self.photoName];
        [[PhotosController sharedController].photo setPhotoDescription:self.photoDescription];
        [[PhotosController sharedController].photo setCollectionName:self.collectionName];
        [[PhotosController sharedController].photo setDate:self.creationDate];
        [[PhotosController sharedController].photo setLocation:self.location];
        
        NSString *photoFile = [[NSString alloc] initWithFormat:@"%@%@.png", self.photoName, [NSDate date]];
        NSString *imageFile = [[[[[[photoFile stringByReplacingOccurrencesOfString:@" " withString:@""] stringByReplacingOccurrencesOfString:@"/" withString:@""] stringByReplacingOccurrencesOfString:@"-" withString:@""] stringByReplacingOccurrencesOfString:@"_" withString:@""] stringByReplacingOccurrencesOfString:@"+" withString:@""] stringByReplacingOccurrencesOfString:@":" withString:@""];
        [[PhotosController sharedController].photo setPhotoFile:imageFile];
        
        [[CollectionsController sharedController] collection:self.collectionName forImage:self.photoName];
        //NSLog(@"Photo with filters: %@", self.photoWithFilters);
        
        if (self.photoWithFilters == nil) {
            [[PhotosController sharedController] savePhoto:self.myPhoto toCollection:self.collectionName onDate:self.creationDate];
        } else {
            [[PhotosController sharedController] savePhoto:self.photoWithFilters toCollection:self.collectionName onDate:self.creationDate];
        }
        
        //NSLog(@"\n\nCount of collections: %d\n\n", [[[CollectionsController sharedController].fetchedResultsController fetchedObjects] count]);
        
        [self dismissViewControllerAnimated:YES completion:nil];}
}


// чогось цей метод не працює
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    if ([text isEqualToString:@"\n"]) {
        [textView resignFirstResponder];
    }
    
    return YES;
}

//Choose Collection Delegate method
- (void)getCollectionName:(NSString *)collectionName {
    self.collectionName = collectionName;
}


//Photo Description Delegate methods
- (void)getPhotoName:(NSString *)photoName {
    self.photoName = photoName;
}

- (void)getPhotoDescription:(NSString *)photoDescription {
    self.photoDescription = photoDescription;
}


//Photo Filter View Controller Delegate method
- (void)getUiImage:(UIImage *)image withParameter:(BOOL)imageWithFilter{
    self.imageWithFilter = imageWithFilter;
    self.photoWithFilters = image;
    [self.photoBlock setImage:self.photoWithFilters];
    
}

- (IBAction)enterCollection:(id)sender {
    
}

- (IBAction)addDescription:(id)sender {
    
}

- (IBAction)addEffects:(id)sender {
    
}

@end
