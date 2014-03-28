//
//  Collection.h
//  MyPhotoCollections
//
//  Created by Sanny on 25.03.14.
//  Copyright (c) 2014 Sanny. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Collection : NSManagedObject

@property (nonatomic, retain) NSString * collectionName;
@property (nonatomic, retain) NSNumber * imagesCount;
@property (nonatomic, retain) NSString * titlePhoto;

@end
