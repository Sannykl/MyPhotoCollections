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
 
    [[CollectionsController sharedController] reloadFetchResult];
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)didPressLink:(id)sender {
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
            //NSLog(@"Name of photo: %@", [arrayOfImage[i] photoFile]);
            localPath = [localDir stringByAppendingPathComponent:[arrayOfImage[i] photoFile]];
            [self.restClient uploadFile:[arrayOfImage[i] photoFile] toPath:destDir withParentRev:nil fromPath:localPath];
        }
    }
}

//remove photos from DropBox, which were deleted from Documents directory
- (void)removeDeprecatedImages {
    
    //doesn't work
    
    NSArray *imagesInDocuments = [[PhotosController sharedController].fetchedResultsController fetchedObjects];
    
    for (int i = 0; i < self.arrayOfDropBoxPhoto.count; i++) {
        NSInteger counter = 0;
        for (int j = 0; j < imagesInDocuments.count; j++) {
            //NSLog(@"\n\n\n%@\n", [self.arrayOfDropBoxPhoto[i] filename]);
            //NSLog(@"%@\n\n\n", [imagesInDocuments[j] photoFile]);
            if ([self.arrayOfDropBoxPhoto[i] filename] != [imagesInDocuments[j] photoFile]) {
                break;
            }
            counter++;
        }
        
        if (counter == imagesInDocuments.count) {
            
            [self deletePhotoFromDropBox:[self.arrayOfDropBoxPhoto[i] filename]];
        }
    }
}

//delete photo from DropBox
- (void)deletePhotoFromDropBox:(NSString *)fileName {
    
    NSString *destPath = [NSString stringWithFormat:@"/%@", fileName];
    [self.restClient deletePath:destPath];
}

//if CoreData directory on DropBox is empty return YES, else NO
- (BOOL)isCoreDataDirEmpty {
    
    BOOL empty = YES;
    if (self.arrayOfMetaData == nil) {
        empty = NO;
    }
    
    return empty;
}

//if photo on DropBox exists return YES, else NO
- (BOOL)isPhotoAlredyExistOnDropBox:(NSString *)nameOfPhoto {
    
    for (int i = 0; i < self.arrayOfDropBoxPhoto.count; i++) {
        //NSLog(@"Name photo on DropBox: %@\n", self.arrayOfDropBoxPhoto[i]);
        if ([[self.arrayOfDropBoxPhoto[i] filename] isEqualToString:nameOfPhoto]) {
            return YES;
        }
    }
    
    return NO;
}




#pragma mark - Download from DropBox section

//Download all files from DropBox to Documents
- (IBAction)downloadFromDropBox:(id)sender {
    
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
            localPath = [localDir stringByAppendingPathComponent:[self.arrayOfDropBoxPhoto[i] filename]];
            destPath = [NSString stringWithFormat:@"%@%@", destDir, [self.arrayOfDropBoxPhoto[i] filename]];
            [self.restClient loadFile:destPath intoPath:localPath];
        }
    }
    
}

//return YES if photo must be deleted
- (BOOL)isPhotoToDelete:(NSString *)fileName {
    
    BOOL delete = NO;
    
    
    
    return delete;
}

//return YES if photo already exist in Documents directory
- (BOOL)isPhotoExistInDocuments:(NSString *)fileName {
    
    BOOL exist = NO;
    
    
    
    return exist;
}

//delete file from Documents directory
- (void)deleteFileFromDocuments:(NSString *)fileName {
    
    NSString *localDir = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)[0];
    NSString *localPath = [localDir stringByAppendingPathComponent:fileName];
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSError *error;
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