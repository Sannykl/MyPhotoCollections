//
//  MPCAppDelegate.m
//  MyPhotoCollections
//
//  Created by Sanny on 25.03.14.
//  Copyright (c) 2014 Sanny. All rights reserved.
//

#import "MPCAppDelegate.h"
#import "StorageController.h"

#import <DropboxSDK/DropboxSDK.h>

#import <DefaultSHKConfigurator.h>
#import <SHKConfiguration.h>
#import "SocialSHKConfiguration.h"

@interface MPCAppDelegate ()

@end

@implementation MPCAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    UINavigationController *nav = (UINavigationController *)self.window.rootViewController;
    [[nav viewControllers] objectAtIndex:0];
    
    //sharing to social networks
    [SHKConfiguration sharedInstanceWithConfigurator:[[SocialSHKConfiguration alloc] init]];
    
    //DropBox configuration
    DBSession *dbSession = [[DBSession alloc] initWithAppKey:@"e12unmyn2af7ujb" appSecret:@"rwei5c61f71u4ke" root:kDBRootAppFolder];
    [DBSession setSharedSession:dbSession];
    
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Saves changes in the application's managed object context before the application terminates.
    [[StorageController sharedController] saveContext];
}


#pragma mark - DropBox section

- (BOOL)application:(UIApplication *)application
            openURL:(NSURL *)url
  sourceApplication:(NSString *)sourceApplication
         annotation:(id)annotation {
    
    if ([[DBSession sharedSession] handleOpenURL:url]) {
        if ([[DBSession sharedSession] isLinked]) {
            NSLog(@"Application linked successfully!");
        }
        return  YES;
    }
    
    return NO;
}


@end
