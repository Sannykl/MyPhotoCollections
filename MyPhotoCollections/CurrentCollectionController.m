//
//  CurrentCollectionController.m
//  MyPhotoCollections
//
//  Created by Sanny on 25.03.14.
//  Copyright (c) 2014 Sanny. All rights reserved.
//

#import "CurrentCollectionController.h"
#import "StorageController.h"

@implementation CurrentCollectionController

@synthesize fetchedResultsController = _fetchedResultsController;

+ (instancetype)sharedController {
    static id __sharedInstance;
    
    if (__sharedInstance == nil) {
        __sharedInstance = [[self alloc] init];
    }
    
    return __sharedInstance;
}

- (void)reset {
    _fetchedResultsController = nil;
}

- (NSFetchedResultsController *)fetchedResultsController {
    if (_fetchedResultsController != nil) {
        return _fetchedResultsController;
    }
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Photo" inManagedObjectContext:[StorageController sharedController].managedObjectContext];
    [fetchRequest setEntity:entity];
    
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"date" ascending:YES];
    NSArray *sortDescriptors = [[NSArray alloc] initWithObjects:sortDescriptor, nil];
    [fetchRequest setSortDescriptors:sortDescriptors];
    
    _fetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest managedObjectContext:[StorageController sharedController].managedObjectContext sectionNameKeyPath:nil cacheName:nil];
    
    //NSLog(@"Number of fetch objects: %d", [[self.fetchedResultsController fetchedObjects] count]);
    
    return _fetchedResultsController;
}

- (void)setCurrentCollection:(Collection *)currentCollection {
    _currentCollection = currentCollection;
    NSString *attributeName = @"collectionName";
    NSString *attributeValue = self.currentCollection.collectionName;
    
    NSFetchRequest *fetchRequest = self.fetchedResultsController.fetchRequest;
    [fetchRequest setPredicate:[NSPredicate predicateWithFormat:@"%K = %@", attributeName, attributeValue]];
    
    NSError *error = nil;
    if (![[CurrentCollectionController sharedController].fetchedResultsController performFetch:&error]) {
        NSLog(@"ERROR performing fetch: %@, %@", error, [error userInfo]);
    }
    
}

@end
