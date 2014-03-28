//
//  PhotoFiltersViewController.m
//  MyPhotoCollections
//
//  Created by Sanny on 25.03.14.
//  Copyright (c) 2014 Sanny. All rights reserved.
//

#import "PhotoFiltersViewController.h"

@interface PhotoFiltersViewController ()

@property (nonatomic, strong) UIImage *imageToWorking;

@end

@implementation PhotoFiltersViewController

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
    
    //NSLog(@"%@", self.originalImage);
    self.imageToWorking = self.originalImage;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)withoutFilters:(id)sender {
    [self.delegate getUiImage:self.originalImage withParameter:NO];
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)firstFilter:(id)sender {
    CIContext *context = [CIContext contextWithOptions:nil];
    //convert UIImage to CGImageRef
    CGImageRef cgImage = [self.imageToWorking CGImage];
    CIImage *image = [CIImage imageWithCGImage:cgImage];
    CIFilter *filter = [CIFilter filterWithName:@"CISepiaTone"];
    [filter setValue:image forKey:kCIInputImageKey];
    [filter setValue:@1.0f forKey:kCIInputIntensityKey];
    CIImage *result = [filter valueForKey:kCIOutputImageKey];
    CGRect extent = [result extent];
    CGImageRef newCGImage = [context createCGImage:result fromRect:extent];
    UIImage *newImage = [[UIImage alloc] initWithCGImage:newCGImage];
    self.imageToWorking = newImage;
    [self.delegate getUiImage:newImage withParameter:YES];
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)secondFilter:(id)sender {
    CIContext *context = [CIContext contextWithOptions:nil];
    //convert UIImage to CGImageRef
    CGImageRef cgImage = [self.imageToWorking CGImage];
    CIImage *image = [CIImage imageWithCGImage:cgImage];
    CIFilter *filter = [CIFilter filterWithName:@"CIPhotoEffectTonal"];
    [filter setValue:image forKey:kCIInputImageKey];
    //[filter setValue:[NSNumber numberWithFloat:8.0f] forKey:kCIInputRadiusKey];
    CIImage *result = [filter valueForKey:kCIOutputImageKey];
    CGRect extent = [result extent];
    CGImageRef newCGImage = [context createCGImage:result fromRect:extent];
    UIImage *newImage = [[UIImage alloc] initWithCGImage:newCGImage];
    self.imageToWorking = newImage;
    [self.delegate getUiImage:newImage withParameter:YES];
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)thirdFilter:(id)sender {
    CIContext *context = [CIContext contextWithOptions:nil];
    //convert UIImage to CGImageRef
    CGImageRef cgImage = [self.imageToWorking CGImage];
    CIImage *image = [CIImage imageWithCGImage:cgImage];
    //CIFilter *filter = [CIFilter filterWithName:@"CIPhotoEffectInstant"];
    //[filter setValue:image forKey:kCIInputImageKey];
    CIFilter *filter = [CIFilter filterWithName:@"CIBloom"];
    [filter setValue:image forKey:kCIInputImageKey];
    [filter setValue:[NSNumber numberWithFloat:20.0] forKey:kCIInputRadiusKey];
    [filter setValue:[NSNumber numberWithFloat:2.0] forKey:kCIInputIntensityKey];
    CIImage *result = [filter valueForKey:kCIOutputImageKey];
    CGRect extent = [result extent];
    CGImageRef newCGImage = [context createCGImage:result fromRect:extent];
    UIImage *newImage = [[UIImage alloc] initWithCGImage:newCGImage];
    self.imageToWorking = newImage;
    [self.delegate getUiImage:newImage withParameter:YES];
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
