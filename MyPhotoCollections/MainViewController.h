//
//  MainViewController.h
//  MyPhotoCollections
//
//  Created by Sanny on 25.03.14.
//  Copyright (c) 2014 Sanny. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <ImageIO/CGImageProperties.h>
#import "TakePhotoViewController.h"
#import "Collection.h"
#import "CurrentCollectionViewController.h"

@interface MainViewController : UIViewController <UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITableViewDataSource, UITableViewDelegate, NSFetchedResultsControllerDelegate>

@property (nonatomic, strong) Collection *collection;
@property (weak, nonatomic) IBOutlet UITableView *myTable;
@property (nonatomic, strong)NSFetchedResultsController *fetchedResultsController;

- (IBAction)takePhoto:(id)sender;
- (IBAction)didPressLink:(id)sender;
@end
