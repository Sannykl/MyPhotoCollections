//
//  CurrentCollectionViewController.m
//  MyPhotoCollections
//
//  Created by Sanny on 25.03.14.
//  Copyright (c) 2014 Sanny. All rights reserved.
//

#import "CurrentCollectionViewController.h"
#import "StorageController.h"
#import "CurrentCollectionController.h"

@interface CurrentCollectionViewController () <ShowPhotoViewControllerDelegate>

@end

@implementation CurrentCollectionViewController

@synthesize currentCollection;
//@synthesize fetchedResultsController = _fetchedResultsController;

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
    
    [self.navigationItem setTitle:self.collection.collectionName];
    
    currentCollection.delegate = self;
    currentCollection.dataSource = self;
    
    
    NSLog(@"\n\n\nFetch request array: %@\n\n\n", [[CurrentCollectionController sharedController].fetchedResultsController fetchedObjects]);
    
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self.currentCollection reloadData];
    [self viewDidLoad];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark -

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"showPhoto"]) {
        ShowPhotoViewController *showPhoto = (ShowPhotoViewController *)[segue destinationViewController];
        NSArray *indexPaths = [self.currentCollection indexPathsForSelectedItems];
        Photo *selectedPhoto = [[CurrentCollectionController sharedController].fetchedResultsController objectAtIndexPath:[indexPaths objectAtIndex:0]];
        showPhoto.chosenPhoto = selectedPhoto;
        showPhoto.indexOfPhoto = [[indexPaths objectAtIndex:0] row] +1;
        showPhoto.delegate = self;
    }
}

#pragma mark - Fetched Results Controller section


#pragma mark - Collection View section

-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return [[[CurrentCollectionController sharedController].fetchedResultsController fetchedObjects] count];
}

-(UICollectionViewCell *)collectionView:collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    NSString *itemIdentifire = @"item";
    self.photo = [[CurrentCollectionController sharedController].fetchedResultsController objectAtIndexPath:indexPath];
    NSLog(@"Photo object: %@", self.photo);
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentDirectory = [paths objectAtIndex:0];
    NSString *imagePath = [documentDirectory stringByAppendingPathComponent:[NSString stringWithFormat:@"%@", self.photo.photoFile]];
    NSLog(@"Image path: %@", imagePath);
    UIImage *image = [UIImage imageWithContentsOfFile:imagePath];
    UIImage *smallImage = [self scaleImage:image toSize:CGSizeMake(100.0, 100.0)];
    
    UIImageView *imageView = [[UIImageView alloc] initWithImage:smallImage];
    
    UICollectionViewCell *item = [currentCollection dequeueReusableCellWithReuseIdentifier:itemIdentifire forIndexPath:indexPath];
    [item addSubview:imageView];
    
    return item;
}

-(UIImage *)scaleImage:(UIImage *)image toSize:(CGSize)newSize {
    
    float width = newSize.width;
    float height = newSize.height;
    
    UIGraphicsBeginImageContext(newSize);
    CGRect rect = CGRectMake(0, 0, width, height);
    
    if (image.size.width < image.size.height) {
        CGFloat difference = image.size.width / width;
        rect.size.width  = width;
        rect.size.height = image.size.height / difference;
    } else {
        CGFloat difference = image.size.height / height;
        rect.size.height  = height;
        rect.size.width = image.size.width / difference;
    }
    
    [image drawInRect: rect];
    
    UIImage *smallImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return smallImage;
}

#pragma mark - Show Photo View Controller Delegate section

- (void)reloadCurrentCollection {
    [self viewWillAppear:YES];
    
    [[CurrentCollectionController sharedController] setCurrentCollection:self.collection];
    NSLog(@"\n\n\nFetch request array: %@\n\n\n", [[CurrentCollectionController sharedController].fetchedResultsController fetchedObjects]);
}

@end

