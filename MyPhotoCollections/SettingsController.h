//
//  SettingsController.h
//  MyPhotoCollections
//
//  Created by Sanny on 25.03.14.
//  Copyright (c) 2014 Sanny. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Settings.h"

@interface SettingsController : NSObject
@property (nonatomic, strong) Settings *settings;

- (void)saveSettings;
+ (instancetype)sharedController;
- (NSInteger)numberOfObjetcsInArray;
- (BOOL)isEmptySettings;
@end
