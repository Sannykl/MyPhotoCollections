//
//  PhotosController.h
//  MyPhotoCollections
//
//  Created by Sanny on 25.03.14.
//  Copyright (c) 2014 Sanny. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Photo.h"

@interface PhotosController : NSObject
@property (nonatomic, strong) Photo *photo;
@property (nonatomic, readonly) NSFetchedResultsController *fetchedResultsController;
@property NSInteger numberOfPhoto;

+ (instancetype)sharedController;
//- (Photo *)createPhotoObject;
- (void)savePhoto:(UIImage *)photo toCollection:(NSString *)collectionName onDate:(NSDate *)date;
- (void)deletePhotoObject:(Photo *)objectToDelete;
//- (Photo *)photoObjectAtIndex:(NSInteger)index;
- (NSArray *)getFetchRequest;
@end
