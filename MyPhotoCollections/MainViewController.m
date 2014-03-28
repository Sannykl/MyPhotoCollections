//
//  MainViewController.m
//  MyPhotoCollections
//
//  Created by Sanny on 25.03.14.
//  Copyright (c) 2014 Sanny. All rights reserved.
//

#import "MainViewController.h"
#import "SettingsViewController.h"
#import "SettingsController.h"
#import "CollectionsController.h"
#import "StorageController.h"
#import "CollectionsController.h"
#import "CurrentCollectionController.h"
#import "DropBoxViewController.h"

#import <DropboxSDK/DropboxSDK.h>

@interface MainViewController () <ShowPhotoViewControllerDelegate>

@property NSInteger numberOfCollections;
@end

@implementation MainViewController

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
    
    self.myTable.delegate = self;
    self.myTable.dataSource = self;
    
    NSError *error = nil;
    if (![[CollectionsController sharedController].fetchedResultsController performFetch:&error]) {
        NSLog(@"ERROR performing fetch: %@, %@", error, [error userInfo]);
    }
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self fetchedResultsController];
    [self.myTable reloadData];
    
    [self viewDidLoad];
    
    NSError *error = nil;
    if (![[CollectionsController sharedController].fetchedResultsController performFetch:&error]) {
        NSLog(@"ERROR performing fetch: %@, %@", error, [error userInfo]);
    }
    
    //NSLog(@"\n\n\n\n\nNumber of rows in tableView: %d\n\n\n\n\n", [[[CollectionsController sharedController].fetchedResultsController fetchedObjects] count]);
}

#pragma mark -

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"showCollection"]) {
        CurrentCollectionViewController *ccvc = (CurrentCollectionViewController *)[segue destinationViewController];
        NSIndexPath *indexPath = [self.myTable indexPathForSelectedRow];
        self.collection = [[CollectionsController sharedController].fetchedResultsController objectAtIndexPath:indexPath];
        ccvc.collection = self.collection;
        [CurrentCollectionController sharedController].currentCollection =  self.collection;
    }
    
}

#pragma mark - Table View section

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    [[CollectionsController sharedController] reloadFetchResult];
    //NSLog(@"\n\n\nCount of objects: %d\n\n\n", [[[CollectionsController sharedController].fetchedResultsController fetchedObjects] count]);
    
    id  sectionInfo = [[[CollectionsController sharedController].fetchedResultsController sections] objectAtIndex:section];
    
    return [sectionInfo numberOfObjects];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *cellIdentifire = @"cell";
    UITableViewCell *cell = [self.myTable dequeueReusableCellWithIdentifier:cellIdentifire];
    //NSLog(@"Index path: %@", indexPath);
    Collection *collection = [[[CollectionsController sharedController].fetchedResultsController fetchedObjects] objectAtIndex:indexPath.row];
    cell.textLabel.text = collection.collectionName;
    NSNumber *number = collection.imagesCount;
    NSInteger intNumber = [number intValue];
    NSString *photosCount = [[NSString alloc] initWithFormat:@"There are %d photos", intNumber];
    cell.detailTextLabel.text = photosCount;
    
    return cell;
}

#pragma mark - Image Picker Controller section

- (IBAction)takePhoto:(id)sender {
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    //picker.sourceType = UIImagePickerControllerSourceTypeCamera;
    //picker.cameraCaptureMode = UIImagePickerControllerCameraCaptureModePhoto;
    picker.sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
    picker.allowsEditing = NO;
    [self presentViewController:picker animated:YES completion:nil];
    picker.delegate = self;
}

-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    TakePhotoViewController *viewController = [[UIStoryboard storyboardWithName:@"MainStoryboard" bundle:nil] instantiateViewControllerWithIdentifier:@"takeNewPhoto"];
    viewController.myPhoto = [info objectForKey:UIImagePickerControllerOriginalImage];
    viewController.title = @"New photo";
    
    //RECEIVING EXIF DATA
    /*NSDictionary *metaData = [info objectForKey:UIImagePickerControllerMediaMetadata];
     
     CFStringRef originalDate = (__bridge CFStringRef)[metaData objectForKey:(id)kCGImagePropertyExifDateTimeOriginal];
     NSString *dateOfCreation = (__bridge NSString *)originalDate;
     
     NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
     [dateFormatter setDateFormat:@"YYYY-MM-DD HH:MM"];
     viewController.creationDate = [dateFormatter dateFromString:dateOfCreation];
     
     CFStringRef photoLocation = (__bridge CFStringRef)[metaData objectForKey:(id)kCGImagePropertyExifSubjectLocation];
     NSString *location = (__bridge NSString *)photoLocation;
     viewController.location = location;
     
     //NSLog(@"Date: %@ \nLocation: %@", dateOfCreation, location);*/
    
    Photo *photo = (Photo *)[NSEntityDescription insertNewObjectForEntityForName:@"Photo" inManagedObjectContext:[StorageController sharedController].managedObjectContext];
    viewController.currentPhoto = photo;
    
    
    [picker dismissViewControllerAnimated:NO completion:^{
        [self presentViewController:viewController
                           animated:NO
                         completion:nil];
    }];
}

#pragma mark - ShowPhotoViewControllerDelegate section

- (void)reloadMainView {
    [self viewWillAppear:YES];
    
    //[[CollectionsController sharedController] reloadFetchRequest];
}

#pragma mark - DropBox section

- (IBAction)didPressLink:(id)sender {
    if (![[DBSession sharedSession] isLinked]) {
        [[DBSession sharedSession] linkFromController:self];
    }
}


@end