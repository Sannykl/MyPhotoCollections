//
//  DropBoxViewController.h
//  MyPhotoCollections
//
//  Created by Sanny on 25.03.14.
//  Copyright (c) 2014 Sanny. All rights reserved.
//

#import "MainViewController.h"

@interface DropBoxViewController : UIViewController
@property (nonatomic, strong)NSFetchRequest *fetchRequest;
@property (nonatomic, strong)MainViewController *mainController;

- (IBAction)uploadToDropBox:(id)sender;
- (IBAction)downloadFromDropBox:(id)sender;
- (IBAction)backToMain:(id)sender;
@end

