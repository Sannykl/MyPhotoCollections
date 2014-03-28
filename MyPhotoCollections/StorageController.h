//
//  StorageController.h
//  MyPhotoCollections
//
//  Created by Sanny on 25.03.14.
//  Copyright (c) 2014 Sanny. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface StorageController : NSObject
@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;

+ (instancetype)sharedController;
- (void)saveContext;
@end
