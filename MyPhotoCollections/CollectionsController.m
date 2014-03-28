//
//  CollectionsController.m
//  MyPhotoCollections
//
//  Created by Sanny on 25.03.14.
//  Copyright (c) 2014 Sanny. All rights reserved.
//

#import "CollectionsController.h"
#import "StorageController.h"
#import "PhotosController.h"

@interface CollectionsController()

@end

@implementation CollectionsController

@synthesize fetchedResultsController = _fetchedResultsController;
@synthesize collection = _collection;

+ (instancetype)sharedController
{
    static id __sharedInstance;
    
    if (__sharedInstance == nil) {
        __sharedInstance = [[self alloc] init];
    }
    
    return __sharedInstance;
}

- (NSFetchedResultsController *)fetchedResultsController
{
    if (_fetchedResultsController != nil) {
        return _fetchedResultsController;
    }
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Collection"
                                              inManagedObjectContext:[StorageController sharedController].managedObjectContext];
    [fetchRequest setEntity:entity];
    
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"collectionName"
                                                                   ascending:YES];
    NSArray *sortDescriptors = [[NSArray alloc] initWithObjects:sortDescriptor, nil];
    [fetchRequest setSortDescriptors:sortDescriptors];
    
    _fetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest managedObjectContext:[StorageController sharedController].managedObjectContext sectionNameKeyPath:nil cacheName:nil];
    
    return _fetchedResultsController;
}

- (BOOL)checkingTheExistanceOfCollection:(NSString *)collection
{
    BOOL exist = NO;
    NSArray *arrayOfCollections = [self.fetchedResultsController fetchedObjects];
    
    for (int i = 0; i < [arrayOfCollections count]; i++)
    {
        if ([[[arrayOfCollections objectAtIndex:i] collectionName] isEqualToString:collection]) {
            exist = YES;
            _collection = [arrayOfCollections objectAtIndex:i];
            break;
        }
    }
    
    //return yes if collection exist
    return exist;
}

- (Collection *)collection:(NSString *)collectionName forImage:(NSString *)photoName
{
    NSError *error = nil;
    if (![self.fetchedResultsController performFetch:&error]) {
        NSLog(@"ERROR performing fetch: %@, %@", error, [error userInfo]);
        return nil;
    }
    
    if ([self checkingTheExistanceOfCollection:collectionName]) {
        
        NSInteger countOfImage = [_collection.imagesCount integerValue];
        countOfImage += 1;
        [PhotosController sharedController].numberOfPhoto = countOfImage;
        _collection.imagesCount = [NSNumber numberWithInteger:countOfImage];
        NSLog(@"Fetching: %@", _collection);
        
    } else {
        
        NSManagedObjectContext *context = [StorageController sharedController].managedObjectContext;
        _collection = [NSEntityDescription insertNewObjectForEntityForName:@"Collection" inManagedObjectContext:context];
        _collection.imagesCount = [NSNumber numberWithInteger:1];
        _collection.collectionName = collectionName;
        _collection.titlePhoto = [PhotosController sharedController].photo.photoFile;
        [PhotosController sharedController].numberOfPhoto = 1;
        NSLog(@"Creating: %@", _collection);
        
    }
    
    return _collection;
}

- (void)setCollection:(Collection *)collection {
    _collection = collection;
    
    NSFetchRequest *fetchRequest = self.fetchedResultsController.fetchRequest;
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"collectionName" ascending:YES];
    NSArray *sortDescriptors = [[NSArray alloc] initWithObjects:sortDescriptor, nil];
    [fetchRequest setSortDescriptors:sortDescriptors];
    
    NSError *error = nil;
    if (![self.fetchedResultsController performFetch:&error]) {
        NSLog(@"ERROR performing fetch: %@, %@", error, [error userInfo]);
    }
}

- (void)reloadFetchResult {
    NSFetchRequest *fetchRequest = self.fetchedResultsController.fetchRequest;
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"collectionName" ascending:YES];
    NSArray *sortDescriptors = [[NSArray alloc] initWithObjects:sortDescriptor, nil];
    [fetchRequest setSortDescriptors:sortDescriptors];
    
    NSError *error = nil;
    if (![self.fetchedResultsController performFetch:&error]) {
        NSLog(@"ERROR performing fetch: %@, %@", error, [error userInfo]);
    }
}


- (Collection *)getterCollection:(NSString *)collectionName {
    //NSLog(@"Collection name: %@", collectionName);
    NSArray *arrayOfCollections = [self.fetchedResultsController fetchedObjects];
    Collection *currentColelction = nil;
    
    for (int i=0; i < [arrayOfCollections count]; i++) {
        currentColelction = [arrayOfCollections objectAtIndex:i];
        if ([currentColelction.collectionName isEqualToString:collectionName]) {
            break;
        }
    }
    //NSLog(@"Collection to delete: %@", currentColelction);
    return currentColelction;
}

//method for redirection to main view controlle or previous view controller
//if collection empty return YES, else return NO
- (BOOL)isEmptyCollection:(NSString *)collectionName {
    BOOL empty = NO;
    
    NSInteger photosInCollection = [[self getterCollection:collectionName].imagesCount integerValue];
    //NSLog(@"\n\nNumber pf photos in collection: %d\n\n", photosInCollection);
    if (photosInCollection == 0) {
        empty = YES;
    } else {
        empty = NO;
    }
    
    //NSLog(empty ? @"\n\nGENERAL EMPTY PARAMETER: YES\n\n" : @"\n\nGENERAL EMPTY PARAMETER: NO\n\n");
    return empty;
}

- (void)isCollectionToDelete:(NSString *)collectionName {
    NSInteger countOfPhotos = [[self getterCollection:collectionName].imagesCount integerValue];
    //NSLog(@"Count of photos: %d", countOfPhotos);
    if (countOfPhotos <= 1) {
        //NSLog(@"Collection preparing to delete!");
        [self deleteCollection:collectionName];
    } else {
        //NSLog(@"Collection will not delete!");
        NSInteger photosInCollection = [[self getterCollection:collectionName].imagesCount integerValue];
        photosInCollection -= 1;
        [self getterCollection:collectionName].imagesCount  = [NSNumber numberWithInteger:photosInCollection];
    }
}

- (void)deleteCollection:(NSString *)collectionName {
    NSManagedObjectContext *context = [StorageController sharedController].managedObjectContext;
    [context deleteObject:[self getterCollection:collectionName]];
    NSLog(@"Deleting of collection doing here!");
}

@end
