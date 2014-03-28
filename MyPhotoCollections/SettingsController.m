//
//  SettingsController.m
//  MyPhotoCollections
//
//  Created by Sanny on 25.03.14.
//  Copyright (c) 2014 Sanny. All rights reserved.
//

#import "SettingsController.h"
#import "StorageController.h"

@interface SettingsController()

@property (nonatomic, readonly) NSFetchedResultsController *fetchedResultsController;

@end

@implementation SettingsController

@synthesize fetchedResultsController = _fetchedResultsController;
@synthesize settings = _settings;

+ (instancetype) sharedController
{
    static id __sharedInstance;
    
    if (__sharedInstance == nil)
    {
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
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Settings"
                                              inManagedObjectContext:[StorageController sharedController].managedObjectContext];
    [fetchRequest setEntity:entity];
    
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"name"
                                                                   ascending:YES];
    NSArray *sortDescriptors = [[NSArray alloc] initWithObjects:sortDescriptor, nil];
    [fetchRequest setSortDescriptors:sortDescriptors];
    
    _fetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest managedObjectContext:[StorageController sharedController].managedObjectContext sectionNameKeyPath:nil cacheName:nil];
    
    NSError *error = nil;
    if (![self.fetchedResultsController performFetch:&error])
    {
        NSLog(@"ERROR performing fetch: %@, %@", error, [error userInfo]);
        return nil;
    }
    
    return _fetchedResultsController;
}

//return YES if settings empty
- (BOOL)isEmptySettings {
    BOOL empty = NO;
    
    id<NSFetchedResultsSectionInfo> sectionInfo = [self.fetchedResultsController sections][0];
    NSUInteger numberOfObjects = sectionInfo.numberOfObjects;
    
    if (numberOfObjects == 0) {
        empty = YES;
    }
    
    return empty;
}

- (Settings *)settings
{
    NSError *error = nil;
    if (![self.fetchedResultsController performFetch:&error])
    {
        NSLog(@"ERROR performing fetch: %@, %@", error, [error userInfo]);
        return nil;
    }
    
    //NSLog(@"%@", [self.fetchedResultsController sections]);
    
    //id<NSFetchedResultsSectionInfo> sectionInfo = [self.fetchedResultsController sections][0];
    //NSUInteger numberOfObjects = sectionInfo.numberOfObjects;
    
    if(![self isEmptySettings])
    {
        
        _settings = [self.fetchedResultsController objectAtIndexPath:[NSIndexPath indexPathForRow:0
                                                                                        inSection:0]];
        //NSLog(@"Fetching:%@", _settings);
    }
    else
    {
        NSManagedObjectContext * context = [[StorageController sharedController] managedObjectContext];
        _settings = [NSEntityDescription insertNewObjectForEntityForName:NSStringFromClass([Settings class])
                                                  inManagedObjectContext:context];
        //NSLog(@"Creating:%@", _settings);
        
    }
    
    return _settings;
}

- (void)saveSettings
{
    [[StorageController sharedController] saveContext];
}

- (NSInteger)numberOfObjetcsInArray
{
    return [[self.fetchedResultsController fetchedObjects] count];
}

@end
