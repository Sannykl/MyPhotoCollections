//
//  DropBoxViewController.m
//  MyPhotoCollections
//
//  Created by Sanny on 25.03.14.
//  Copyright (c) 2014 Sanny. All rights reserved.
//

#import "DropBoxViewController.h"
#import "PhotosController.h"
#import <DropboxSDK/DropboxSDK.h>
#import "CollectionsController.h"
#import "StorageController.h"
#import "CurrentCollectionController.h"

@interface DropBoxViewController () <DBRestClientDelegate>

@property (nonatomic, strong)DBRestClient *restClient;
@property (nonatomic, strong)NSMutableArray *arrayOfMetaData;
@property (nonatomic, strong)NSArray *arrayOfDropBoxPhoto;
@property (nonatomic, strong)NSArray *arrayOfLocalPhoto;

@end

@implementation DropBoxViewController

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
    
    //DropBox code is here
    self.restClient = [[DBRestClient alloc] initWithSession:[DBSession sharedSession]];
    self.restClient.delegate = self;
    
    [self.restClient loadMetadata:@"/"];
    [self.restClient loadMetadata:@"/CoreData/"];
    
    NSError *error = nil;
    if (![[PhotosController sharedController].fetchedResultsController performFetch:&error]) {
        NSLog(@"ERROR performing fetch: %@, %@", error, [error userInfo]);
    }
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:YES];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)backToMain:(id)sender {
    [[StorageController sharedController] reset];
    [[CollectionsController sharedController] reset];
    [[CurrentCollectionController sharedController] reset];
    [self dismissViewControllerAnimated:YES completion:nil];
}




#pragma mark - Upload To DropBox section

//upload all files from Documents to DropBox
- (IBAction)uploadToDropBox:(id)sender {
    
    [self removeDeprecatedImages];
    [self uploadCoreDataFiles];
    [self uploadImagesFromDocuments];
}

//upload CoreData files to DropBox
- (void)uploadCoreDataFiles {
    
    NSArray *coreDataFiles = [[NSArray alloc] initWithObjects:@"MyPhotoCollections.sqlite", @"MyPhotoCollections.sqlite-shm", @"MyPhotoCollections.sqlite-wal", nil];
    NSString *localDir = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)[0];
    NSString *localPath;
    NSString *destPath;
    NSString *destDir = @"/CoreData/";
    
    if (![self isCoreDataDirEmpty]) {
        for (int i = 0; i < coreDataFiles.count; i++) {
            destPath = [NSString stringWithFormat:@"%@%@", destDir, coreDataFiles[i]];
            [self.restClient deletePath:destPath];
        }
    }
    
    for (int i = 0; i < coreDataFiles.count; i++) {
        localPath = [localDir stringByAppendingPathComponent:coreDataFiles[i]];
        [self.restClient uploadFile:coreDataFiles[i] toPath:destDir withParentRev:nil fromPath:localPath];
    }
}

//upload images
- (void)uploadImagesFromDocuments {
    
    NSArray *arrayOfImage = [[PhotosController sharedController].fetchedResultsController fetchedObjects];
    
    NSString *localDir = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)[0];
    NSString *localPath;
    NSString *destDir = @"/";
    
    for (int i = 0; i < arrayOfImage.count; i++) {
        if (![self isPhotoAlredyExistOnDropBox:[arrayOfImage[i] photoFile]]) {
            //NSLog(@"\n\n\nPhoto name: %@\n\n\n", [arrayOfImage[i] photoFile]);
            localPath = [localDir stringByAppendingPathComponent:[arrayOfImage[i] photoFile]];
            [self.restClient uploadFile:[arrayOfImage[i] photoFile] toPath:destDir withParentRev:nil fromPath:localPath];
        }
    }
}

//remove photos from DropBox, which were deleted from Documents directory
- (void)removeDeprecatedImages {
    
    NSArray *imagesInDocuments = [[PhotosController sharedController].fetchedResultsController fetchedObjects];
    
    for (int i = 0; i < self.arrayOfDropBoxPhoto.count; i++) {
        if ([self isDeprecatedPhoto:[self.arrayOfDropBoxPhoto[i] filename] inArray:imagesInDocuments]) {
            
            [self deletePhotoFromDropBox:[self.arrayOfDropBoxPhoto[i] filename]];
        }
    }
}

//return YES if photo is deprecated, else return NO
- (BOOL)isDeprecatedPhoto:(NSString *)photoName inArray:(NSArray *)imagesInDocuments {
    
    for (int i = 0; i < imagesInDocuments.count; i++) {
        if ([photoName isEqualToString:@"CoreData"] || [[imagesInDocuments[i] photoFile] isEqualToString:photoName]) {
            return NO;
        }
    }
    
    return YES;
}

//delete photo from DropBox
- (void)deletePhotoFromDropBox:(NSString *)fileName {
    NSString *destPath = [NSString stringWithFormat:@"/%@", fileName];
    [self.restClient deletePath:destPath];
}

//if CoreData directory on DropBox is empty return YES, else NO
- (BOOL)isCoreDataDirEmpty {
    
    if (self.arrayOfMetaData == nil) {
        return  NO;
    }
    
    return YES;
}

//if photo on DropBox exists return YES, else NO
- (BOOL)isPhotoAlredyExistOnDropBox:(NSString *)nameOfPhoto {
    
    for (int i = 0; i < self.arrayOfDropBoxPhoto.count; i++) {
        if ([[self.arrayOfDropBoxPhoto[i] filename] isEqualToString:nameOfPhoto]) {
            return YES;
        }
    }
    
    return NO;
}




#pragma mark - Download from DropBox section

//Download all files from DropBox to Documents
- (IBAction)downloadFromDropBox:(id)sender {
    
    [self removeDeprecatedImagesFromDocuments];
    [self downloadCoreData];
    [self downloadPhoto];
}

//download CoreData files from DropBox to Documents
- (void)downloadCoreData {
    
    NSArray *coreDataFiles = [[NSArray alloc] initWithObjects:@"MyPhotoCollections.sqlite", @"MyPhotoCollections.sqlite-shm", @"MyPhotoCollections.sqlite-wal", nil];
    NSString *localDir = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)[0];
    NSString *localPath;
    NSString *destDir = @"/CoreData/";
    NSString *destPath;
    
    for (int j = 0; j <coreDataFiles.count; j++) {
        [self deleteFileFromDocuments:coreDataFiles[j]];
    }
    
    for (int i = 0; i < coreDataFiles.count; i++) {
        localPath = [localDir stringByAppendingPathComponent:coreDataFiles[i]];
        destPath = [NSString stringWithFormat:@"%@%@", destDir, coreDataFiles[i]];
        [self.restClient loadFile:destPath intoPath:localPath];
    }

}

//download photos from DropBox to Documents
- (void)downloadPhoto {
    
    NSString *localDir = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)[0];
    NSString *localPath;
    NSString *destDir = @"/";
    NSString *destPath;
    
    for (int i = 0; i < self.arrayOfDropBoxPhoto.count; i++) {
        if (![self isPhotoExistInDocuments:[self.arrayOfDropBoxPhoto[i] filename]]) {
            localPath = [localDir stringByAppendingPathComponent:[[self.arrayOfDropBoxPhoto objectAtIndex:i] filename]];
            destPath = [NSString stringWithFormat:@"%@%@", destDir, [[self.arrayOfDropBoxPhoto objectAtIndex:i] filename]];
            [self.restClient loadFile:destPath intoPath:localPath];
        }
    }
    
}

//remove deprecated photos from Documents directory
- (void)removeDeprecatedImagesFromDocuments {
    
    NSArray *arrayOfPhotos = [[PhotosController sharedController].fetchedResultsController fetchedObjects];
    
    for (int i = 0; i < arrayOfPhotos.count; i++) {
        if ([self isPhotoToDelete:[arrayOfPhotos[i] photoFile]]) {
            [self deleteFileFromDocuments:[arrayOfPhotos[i] photoFile]];
        }
    }
}

//return YES if photo must be deleted
- (BOOL)isPhotoToDelete:(NSString *)photoName {
    
    NSLog(@"\n\n\nPhoto name: %@\n\n\n", photoName);
    
    for (int i = 0; i < self.arrayOfDropBoxPhoto.count; i++) {
        if ([photoName isEqualToString:[self.arrayOfDropBoxPhoto[i] filename]]) {
            NSLog(@"\nPhoto to delete: %@\n", [self.arrayOfDropBoxPhoto[i] filename]);
            return NO;
        }
    }
    
    return YES;
}

//return YES if photo exist in Documents directory
- (BOOL)isPhotoExistInDocuments:(NSString *)photoName {
        
    return NO;
}

//delete file from Documents directory
- (void)deleteFileFromDocuments:(NSString *)fileName {
    
    NSString *localDir = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)[0];
    NSString *localPath = [localDir stringByAppendingPathComponent:fileName];
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSError *error;
    
    NSLog(@"\n\nPath to elete: %@\n\n", localPath);
    
    [fileManager removeItemAtPath:localPath error:&error];
}




#pragma mark - DBRestClientDelegate section

//upload file delegate methods
- (void)restClient:(DBRestClient *)client
      uploadedFile:(NSString *)destPath
              from:(NSString *)srcPath
          metadata:(DBMetadata *)metadata {
    
    NSLog(@"File uploaded successfully to path: %@", metadata.path);
}

- (void)restClient:(DBRestClient *)restClient uploadFileFailedWithError:(NSError *)error {
    
    NSLog(@"File upload filed with error: %@", error);
}

//load metadata delegate methods
- (void)restClient:(DBRestClient *)client
    loadedMetadata:(DBMetadata *)metadata {
  
    if (metadata.isDirectory) {
        NSLog(@"Folder '%@' contains:", metadata.path);
        for (DBMetadata *file in metadata.contents) {
            NSLog(@"  %@", file.filename);
        }
    }
    
    if ([metadata.path isEqualToString:@"/CoreData/"]) {
        int i = 0;
        for (DBMetadata *file in metadata.contents) {
            self.arrayOfMetaData[i] = file.filename;
            i++;
        }
        
    }
    
    if ([metadata.path isEqualToString:@"/"]) {
        self.arrayOfDropBoxPhoto = metadata.contents;
        
    }
}

- (void)restClient:(DBRestClient *)restClient loadMetadataFailedWithError:(NSError *)error {
    
    NSLog(@"Error loading metadata: %@", error);
}

//load file delegate methods
- (void)restClient:(DBRestClient *)client
        loadedFile:(NSString *)destPath
       contentType:(NSString *)contentType
          metadata:(DBMetadata *)metadata {
    
    NSLog(@"File loaded into %@", destPath);
}

- (void)restClient:(DBRestClient *)restClient loadFileFailedWithError:(NSError *)error {
    
    NSLog(@"There was an error loading the file: %@", error);
}

//delete file delegate methods
- (void)restClient:(DBRestClient *)restClient
       deletedPath:(NSString *)path {
    
    NSLog(@"File at path '%@' successfully deleted", path);
}

- (void)restClient:(DBRestClient *)restClient deletePathFailedWithError:(NSError *)error {
    
    NSLog(@"There was an error loading the file: %@", error);
}

@end