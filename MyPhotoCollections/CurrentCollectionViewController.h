//
//  CurrentCollectionViewController.h
//  MyPhotoCollections
//
//  Created by Sanny on 25.03.14.
//  Copyright (c) 2014 Sanny. All rights reserved.
//

#import <UIKit/UIKit.h>

#import <UIKit/UIKit.h>
#import "Collection.h"
#import "Photo.h"
#import "ShowPhotoViewController.h"

@interface CurrentCollectionViewController : UIViewController <UICollectionViewDataSource, UICollectionViewDelegate, NSFetchedResultsControllerDelegate>

@property (weak, nonatomic) IBOutlet UICollectionView *currentCollection;
//@property (nonatomic, strong) NSFetchedResultsController *fetchedResultsController;
//@property (nonatomic, strong) NSManagedObjectContext *managedObjectContext;

@property (nonatomic, strong) Collection *collection;
@property (nonatomic, strong) Photo *photo;

-(UIImage *)scaleImage:(UIImage *)image toSize:(CGSize)newSize;
@end
