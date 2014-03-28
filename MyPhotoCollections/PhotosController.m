//
//  PhotosController.m
//  MyPhotoCollections
//
//  Created by Sanny on 25.03.14.
//  Copyright (c) 2014 Sanny. All rights reserved.
//

#import "PhotosController.h"
#import "StorageController.h"

@implementation PhotosController

@synthesize fetchedResultsController = _fetchedResultsController;

+ (instancetype)sharedController {
    static id __sharedInstance;
    
    if (__sharedInstance == nil) {
        __sharedInstance = [[self alloc] init];
    }
    
    return __sharedInstance;
}

- (NSFetchedResultsController *)fetchedResultsController {
    if (_fetchedResultsController != nil) {
        return _fetchedResultsController;
    }
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Photo"
                                              inManagedObjectContext:[StorageController sharedController].managedObjectContext];
    [fetchRequest setEntity:entity];
    
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"photoName"
                                                                   ascending:YES];
    NSArray *sortDescriptors = [[NSArray alloc] initWithObjects:sortDescriptor, nil];
    [fetchRequest setSortDescriptors:sortDescriptors];
    
    _fetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest managedObjectContext:[StorageController sharedController].managedObjectContext sectionNameKeyPath:nil cacheName:nil];
    
    return _fetchedResultsController;
}

/*-(Photo *)createPhotoObject {
    self.photo = [NSEntityDescription insertNewObjectForEntityForName:@"Photo" inManagedObjectContext:[StorageController sharedController].managedObjectContext];
    NSLog(@"Photo object created!!!");
    return self.photo;
}*/

-(void)savePhoto:(UIImage *)photo toCollection:(NSString *)collectionPhoto onDate:(NSDate *)date{
    NSData *imageData = UIImagePNGRepresentation(photo);
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentDirectory = [paths objectAtIndex:0];
    //NSLog(@"\n%@_%@.png\n", collectionPhoto, date);
    NSString *imagePath = [documentDirectory stringByAppendingPathComponent:[NSString stringWithFormat:@"%@", self.photo.photoFile]];
    //NSLog(@"\nImage Path::: %@", imagePath);
    
    [imageData writeToFile:imagePath atomically:NO];
    
    [[StorageController sharedController] saveContext];
}

-(void)deletePhotoObject:(Photo *)objectToDelete {
    NSManagedObjectContext *context = [StorageController sharedController].managedObjectContext;
    [context deleteObject:objectToDelete];
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSString *documentsPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString *filePath = [documentsPath stringByAppendingString:[NSString stringWithFormat:@"/%@", objectToDelete.photoFile]];
    NSLog(@"\nPhoto Path::: %@", filePath);
    NSError *error = nil;
    BOOL success = [fileManager removeItemAtPath:filePath error:&error];
    
    if (!success) {
        NSLog(@"Error: %@", error);
    }
    [[StorageController sharedController] saveContext];
    NSLog(@"Photo object deleted!!!");
    
    
}

- (NSArray *)getFetchRequest {
    NSFetchRequest *fetchRequest = self.fetchedResultsController.fetchRequest;
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"photoName" ascending:YES];
    NSArray *sortDescriptors = [[NSArray alloc] initWithObjects:sortDescriptor, nil];
    [fetchRequest setSortDescriptors:sortDescriptors];
    
    NSError *error = nil;
    if (![self.fetchedResultsController performFetch:&error]) {
        NSLog(@"ERROR performing fetch: %@, %@", error, [error userInfo]);
    }
    
    NSArray *arrayOfPhoto = [[StorageController sharedController].managedObjectContext executeFetchRequest:fetchRequest error:&error];
    
    return arrayOfPhoto;
}

/*- (Photo *)photoObjectAtIndex:(NSInteger)index {
 Photo *photoObject = [self.fetchedResultsController fetchedObjects][index];
 NSLog(@"\nObject: %@\n", [self.fetchedResultsController fetchedObjects][0]);
 return photoObject;
 }*/

@end