//
//  FileManager.m
//  RSSReader
//
//  Created by Dzmitry Noska on 8/29/19.
//  Copyright © 2019 Dzmitry Noska. All rights reserved.
//

#import "FileManager.h"

@interface FileManager()
@property (strong, nonatomic) NSFileManager* fileManager;
@end

@implementation FileManager

static FileManager* shared;

+(instancetype) sharedFileManager {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        shared = [FileManager new];
        shared.fileManager = [NSFileManager defaultManager];
    });
    return shared;
}

#pragma mark - FeedItem

- (void)saveFeedItem:(FeedItem*) item toFileWithName:(NSString*) fileName {
    
    NSMutableArray* encodedItems = [[NSMutableArray alloc] initWithObjects:[NSKeyedArchiver archivedDataWithRootObject:item], nil];
    
    NSData* encodedArray = [NSKeyedArchiver archivedDataWithRootObject:encodedItems];
    
    NSArray* paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString* documentDirectory = [paths objectAtIndex:0];
    NSString* filePath = [documentDirectory stringByAppendingPathComponent:fileName];
    
    if ([self.fileManager fileExistsAtPath:filePath]) {
        //load file
        NSMutableArray<FeedItem *>* decodedItems = [self readFeedItemsFile:fileName];
        NSMutableArray<NSData *>* encodedFileContent = [[NSMutableArray alloc] init];
        for (FeedItem* decodedItem in decodedItems) {
            [encodedFileContent addObject:[NSKeyedArchiver archivedDataWithRootObject:decodedItem]];
        }
        
        [encodedFileContent addObject:[NSKeyedArchiver archivedDataWithRootObject:item]];
        
        NSData* encodedFileData = [NSKeyedArchiver archivedDataWithRootObject:encodedFileContent];
        [encodedFileData writeToFile:filePath atomically:YES];
        
    } else {
        [self.fileManager createFileAtPath:filePath contents:encodedArray attributes:nil];
    }
}

- (void) updateFeedItem:(FeedItem *) item atIndex:(NSUInteger) index inFile:(NSString *) fileName {
    NSMutableArray<FeedItem *>* items = [self readFeedItemsFile:fileName];
    if ([items count] > 1) {
        [items replaceObjectAtIndex:index withObject:item]; //// copy
        [self createAndSaveFeedItems:items toFileWithName:fileName];
    }
}

- (NSMutableArray<FeedItem *> *) readFeedItemsFile:(NSString*) fileName {
    
    NSArray* paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString* documentDirectory = [paths objectAtIndex:0];
    NSString* filePath = [documentDirectory stringByAppendingPathComponent:fileName];
    
    NSFileHandle* fileHandle = [NSFileHandle fileHandleForReadingAtPath:filePath];
    NSData* fileContent = [fileHandle readDataToEndOfFile];
    
    NSMutableArray<NSData *>* encodedObjects = [NSKeyedUnarchiver unarchiveObjectWithData:fileContent];
    NSMutableArray<FeedItem *>* decodedItems = [[NSMutableArray alloc] init];
    
    for (NSData* data in encodedObjects) {
        FeedItem* item = [NSKeyedUnarchiver unarchiveObjectWithData:data];
        if (item) {
            [decodedItems addObject:item];
        }
    }
    
    return decodedItems;
}

- (void) removeFeedItem:(FeedItem *) item  fromFile:(NSString *) fileName {
    
    NSMutableArray<FeedItem *>* items = [self readFeedItemsFile:fileName];
    
    for (FeedItem* feedItem in [items copy]) {
        if ([feedItem.link isEqualToString:item.link]) {
            [items removeObject:feedItem];
        }
    }
    
    [self removeAllObjectsFormFile:fileName];
    
    for (FeedItem* fI in [items copy]) {
        [self saveFeedItem:fI toFileWithName:fileName];
    }
}

- (void)saveFeedItems:(NSMutableArray<FeedItem*>*) items toFileWithName:(NSString*) fileName {
    
    NSMutableArray<NSData*>* encodedItems = [[NSMutableArray alloc] init];
    
    for (FeedItem* item in items) {
        [encodedItems addObject:[NSKeyedArchiver archivedDataWithRootObject:item]];
    }
    
    NSArray* paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString* documentDirectory = [paths objectAtIndex:0];
    NSString* filePath = [documentDirectory stringByAppendingPathComponent:fileName];
    
    if ([self.fileManager fileExistsAtPath:filePath]) {
        //load file
        NSMutableArray<FeedItem *>* decodedItems = [self readFeedItemsFile:fileName];
        NSMutableArray<NSData *>* encodedFileContent = [[NSMutableArray alloc] init];
        for (FeedItem* decodedItem in decodedItems) {
            [encodedFileContent addObject:[NSKeyedArchiver archivedDataWithRootObject:decodedItem]];
        }
        
        [encodedFileContent addObjectsFromArray:encodedItems];
        
        NSData* encodedFileData = [NSKeyedArchiver archivedDataWithRootObject:encodedFileContent];
        [encodedFileData writeToFile:filePath atomically:YES];
        
    } else {
        [self.fileManager createFileAtPath:filePath contents:[NSKeyedArchiver archivedDataWithRootObject:encodedItems] attributes:nil];
    }
}

- (void)createAndSaveFeedItems:(NSMutableArray<FeedItem*>*) items toFileWithName:(NSString*) fileName {
    NSMutableArray<NSData*>* encodedItems = [[NSMutableArray alloc] init];
    
    for (FeedItem* item in [items copy]) {
        [encodedItems addObject:[NSKeyedArchiver archivedDataWithRootObject:item]];
    }
    
    NSArray* paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString* documentDirectory = [paths objectAtIndex:0];
    NSString* filePath = [documentDirectory stringByAppendingPathComponent:fileName];
    
    [self.fileManager createFileAtPath:filePath contents:[NSKeyedArchiver archivedDataWithRootObject:encodedItems] attributes:nil];
}

#pragma mark - FeedResource

- (void)saveFeedResource:(FeedResource*) resource toFileWithName:(NSString*) fileName {
    NSMutableArray* encodedResource = [[NSMutableArray alloc] initWithObjects:[NSKeyedArchiver archivedDataWithRootObject:resource], nil];
    
    NSData* encodedArray = [NSKeyedArchiver archivedDataWithRootObject:encodedResource];
    
    NSArray* paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString* documentDirectory = [paths objectAtIndex:0];
    NSString* filePath = [documentDirectory stringByAppendingPathComponent:fileName];
    
    if ([self.fileManager fileExistsAtPath:filePath]) {
        //load file
        NSMutableArray<FeedResource *>* decodedResources = [self readFeedResourceFile:fileName];
        NSMutableArray<NSData *>* encodedFileContent = [[NSMutableArray alloc] init];
        for (FeedResource* decodedResource in decodedResources) {
            [encodedFileContent addObject:[NSKeyedArchiver archivedDataWithRootObject:decodedResource]];
        }
        
        [encodedFileContent addObject:[NSKeyedArchiver archivedDataWithRootObject:resource]];
        
        NSData* encodedFileData = [NSKeyedArchiver archivedDataWithRootObject:encodedFileContent];
        [encodedFileData writeToFile:filePath atomically:YES];
        
    } else {
        [self.fileManager createFileAtPath:filePath contents:encodedArray attributes:nil];
    }
}

- (NSMutableArray<FeedResource *> *) readFeedResourceFile:(NSString*) fileName {
    NSArray* paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString* documentDirectory = [paths objectAtIndex:0];
    NSString* filePath = [documentDirectory stringByAppendingPathComponent:fileName];
    
    NSFileHandle* fileHandle = [NSFileHandle fileHandleForReadingAtPath:filePath];
    NSData* fileContent = [fileHandle readDataToEndOfFile];
    
    NSMutableArray<NSData *>* encodedObjects = [NSKeyedUnarchiver unarchiveObjectWithData:fileContent];
    NSMutableArray<FeedResource *>* decodedResources = [[NSMutableArray alloc] init];
    
    for (NSData* data in encodedObjects) {
        FeedResource* resource = [NSKeyedUnarchiver unarchiveObjectWithData:data];
        [decodedResources addObject:resource];
    }
    
    return decodedResources;
}

- (void) removeFeedResource:(FeedResource *) resource  fromFile:(NSString *) fileName {
    NSMutableArray<FeedResource *>* resorces = [self readFeedResourceFile:fileName];
    
    for (FeedResource* feedResource in [resorces copy]) {
        if ([[feedResource.url absoluteString] isEqualToString:[resource.url absoluteString]]) {
            [resorces removeObject:feedResource];
        }
    }
    
    [self removeAllObjectsFormFile:fileName];
    
    for (FeedResource* fR in [resorces copy]) {
        [self saveFeedResource:fR toFileWithName:fileName];
    }
}

- (void) removeAllObjectsFormFile:(NSString *) fileName {
    
    NSArray* paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString* documentDirectory = [paths objectAtIndex:0];
    NSString* filePath = [documentDirectory stringByAppendingPathComponent:fileName];
    [self.fileManager createFileAtPath:filePath contents:nil attributes:nil];
}


- (NSMutableArray<NSString *>*) readStringsFromFile:(NSString *) fileName {
    NSArray* paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString* documentDirectory = [paths objectAtIndex:0];
    NSString* filePath = [documentDirectory stringByAppendingPathComponent:fileName];
    
    NSFileHandle* fileHandle = [NSFileHandle fileHandleForReadingAtPath:filePath];
    NSData* fileContent = [fileHandle readDataToEndOfFile];
    NSMutableArray<NSString *>* str = [NSKeyedUnarchiver unarchiveObjectWithData:fileContent];
    return str;
}

- (void) saveString:(NSString *) stringToSave toFile:(NSString *) fileName {
    
    NSArray* paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString* documentDirectory = [paths objectAtIndex:0];
    NSString* filePath = [documentDirectory stringByAppendingPathComponent:fileName];
    
    if ([self.fileManager fileExistsAtPath:filePath]) {
        
        NSFileHandle* fileHandle = [NSFileHandle fileHandleForReadingAtPath:filePath];
        NSData* fileContent = [fileHandle readDataToEndOfFile];
        NSMutableArray<NSString *>* savedItems = [NSKeyedUnarchiver unarchiveObjectWithData:fileContent];
        if (savedItems) {
            [savedItems addObject:stringToSave];
        } else {
            savedItems = [[NSMutableArray alloc] initWithObjects:stringToSave, nil];
        }
        
        
        NSData* encodedFileData = [NSKeyedArchiver archivedDataWithRootObject:savedItems];
        [encodedFileData writeToFile:filePath atomically:YES];
    } else {
        [self.fileManager createFileAtPath:filePath contents:[NSKeyedArchiver archivedDataWithRootObject:[[NSMutableArray alloc] initWithObjects:stringToSave, nil]] attributes:nil];
    }
}

- (void) removeString:(NSString *) string fromFile:(NSString *) fileName {
    
    NSArray* paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString* documentDirectory = [paths objectAtIndex:0];
    NSString* filePath = [documentDirectory stringByAppendingPathComponent:fileName];
    
    if ([self.fileManager fileExistsAtPath:filePath]) {
        
        NSMutableArray<NSString *>* strings = [self readStringsFromFile:fileName];
        
        for (NSString* str in [strings copy]) {
            if ([str isEqualToString:string]) {
                [strings removeObject:str];
            }
        }
        
        [self removeAllObjectsFormFile:fileName];
        
        for (NSString* str in strings) {
            [self saveString:str toFile:fileName];
        }
        
    }
}

@end
