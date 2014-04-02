//
//  DropBoxViewController.h
//  MyPhotoCollections
//
//  Created by Sanny on 25.03.14.
//  Copyright (c) 2014 Sanny. All rights reserved.
//

@interface DropBoxViewController : UIViewController
@property (nonatomic, strong)NSFetchRequest *fetchRequest;

- (IBAction)uploadToDropBox:(id)sender;
- (IBAction)downloadFromDropBox:(id)sender;
- (IBAction)backToMain:(id)sender;
@end

