//
//  CurrentCollectionController.h
//  MyPhotoCollections
//
//  Created by Sanny on 25.03.14.
//  Copyright (c) 2014 Sanny. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Collection.h"
@interface CurrentCollectionController : NSObject

@property (nonatomic, strong) NSFetchedResultsController *fetchedResultsController;
@property (nonatomic, readwrite) Collection *currentCollection;

+ (instancetype)sharedController;
- (void)setCurrentCollection:(Collection *)currentCollection;
@end
