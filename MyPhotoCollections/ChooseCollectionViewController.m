//
//  ChooseCollectionViewController.m
//  MyPhotoCollections
//
//  Created by Sanny on 25.03.14.
//  Copyright (c) 2014 Sanny. All rights reserved.
//

#import "CollectionsController.h"
#import "ChooseCollectionViewController.h"

@interface ChooseCollectionViewController ()

@property NSInteger numberOfCollections;

@end

@implementation ChooseCollectionViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    self.collectionTable.delegate = self;
    self.collectionTable.dataSource = self;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table View Controller Delegate section

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    self.numberOfCollections = [[[CollectionsController sharedController].fetchedResultsController fetchedObjects] count];
    return self.numberOfCollections;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *cellIdentifire = @"collection";
    UITableViewCell *cell = [self.collectionTable dequeueReusableCellWithIdentifier:cellIdentifire];
    
    Collection *collection = [[[CollectionsController sharedController].fetchedResultsController fetchedObjects] objectAtIndex:indexPath.row];
    cell.textLabel.text = collection.collectionName;
    
    return cell;
}

#pragma mark -

- (IBAction)done:(id)sender {
    NSString *collectionName = [self selectedCollection];
    //NSLog(@"%@\n", collectionName);
    [self.delegate getCollectionName:collectionName];
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)dismissKeyboard:(id)sender {
    [self.view endEditing:YES];
    
    if ([self.collectionField.text isEqualToString:@""]) {
        [self.collectionField setText:@"New collection"];
    }
}

- (IBAction)clearColectionField:(id)sender {
    if ([self.collectionField.text isEqualToString:@"New collection"]) {
        [self.collectionField setText:@""];
    }
}

//0 if collectionName from textField, 1 if collectionName from tableView
-(BOOL)isEnterCollection {
    NSIndexPath *indexPath = [self.collectionTable indexPathForSelectedRow];
    BOOL yes = (([self.collectionField.text isEqualToString:@""] || [self.collectionField.text isEqualToString:@"New collection"]) && (indexPath))? NO : YES;
    return yes;
}

//determining selected collection
-(NSString *)selectedCollection {
    NSString *nameOfCollection;
    
    if (!self.isEnterCollection) {
        NSIndexPath *indexPath = [self.collectionTable indexPathForSelectedRow];
        nameOfCollection = [[[CollectionsController sharedController].fetchedResultsController objectAtIndexPath:indexPath] collectionName];
    } else {
        nameOfCollection = self.collectionField.text;
    }
    
    return nameOfCollection;
}




@end
