//
//  CollectionsController.h
//  MyPhotoCollections
//
//  Created by Sanny on 25.03.14.
//  Copyright (c) 2014 Sanny. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Collection.h"

@interface CollectionsController : NSObject
@property (nonatomic, readwrite) Collection *collection;
@property (nonatomic, readonly) NSFetchedResultsController *fetchedResultsController;

+ (instancetype)sharedController;
- (Collection *)collection:(NSString *)collectionName forImage:(NSString *)photoName;
- (void)isCollectionToDelete:(NSString *)collectionName;
- (BOOL)isEmptyCollection:(NSString *)collectionName;
- (void)reloadFetchResult;
- (void)reset;
@end
