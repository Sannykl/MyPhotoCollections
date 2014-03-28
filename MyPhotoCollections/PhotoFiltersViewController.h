//
//  PhotoFiltersViewController.h
//  MyPhotoCollections
//
//  Created by Sanny on 25.03.14.
//  Copyright (c) 2014 Sanny. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol PhotoFiltersViewControllerDelegate;

@interface PhotoFiltersViewController : UIViewController
@property (nonatomic, strong) UIImage *originalImage;
@property BOOL imageWithFilter;

@property (nonatomic, weak) id <PhotoFiltersViewControllerDelegate> delegate;

- (IBAction)withoutFilters:(id)sender;
- (IBAction)firstFilter:(id)sender;
- (IBAction)secondFilter:(id)sender;
- (IBAction)thirdFilter:(id)sender;
@end

@protocol PhotoFiltersViewControllerDelegate

-(void)getUiImage:(UIImage *)image withParameter:(BOOL)yes;

@end
