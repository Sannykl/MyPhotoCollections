//
//  ChooseCollectionViewController.h
//  MyPhotoCollections
//
//  Created by Sanny on 25.03.14.
//  Copyright (c) 2014 Sanny. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MainViewController.h"
#import "Photo.h"

@protocol ChooseCollectionViewControllerDelegate;

@interface ChooseCollectionViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITextField *collectionField;
//@property (weak, nonatomic) IBOutlet UITableViewCell *collectionCell;

@property (nonatomic, strong) MainViewController *mainViewController;
@property (weak, nonatomic) IBOutlet UITableView *collectionTable;

@property (nonatomic, weak) id <ChooseCollectionViewControllerDelegate> delegate;

@property (nonatomic, strong) Photo *currentPhoto;

- (IBAction)done:(id)sender;
- (IBAction)dismissKeyboard:(id)sender;
- (IBAction)clearColectionField:(id)sender;
@end

@protocol ChooseCollectionViewControllerDelegate

-(void)getCollectionName:(NSString *)collectionName;

@end
