//
//  CoreDataMgr.m
//  WorkoutTracker2
//
//  Created by Cody McDonald on 3/1/15.
//  Copyright (c) 2015 msse650. All rights reserved.
//

#import "CoreDataMgr.h"

@implementation CoreDataMgr

NSManagedObjectModel *model; //= nil
NSPersistentStoreCoordinator *psc; //= nil
//NSManagedObjectContext *moc = nil;

static CoreDataMgr *coreDataManager;    //

//making ExerciseSvcSQLite a singleton
+ (CoreDataMgr *)sharedInstance {
    static CoreDataMgr *_singletonInstance = nil;
    static dispatch_once_t once;
    dispatch_once(&once, ^{
        _singletonInstance = [[CoreDataMgr alloc] init];
    });
    return _singletonInstance;
}

////Create Singleton instance of the database.
//+(CoreDataManager *)manager {
//    if (manager == nil) {
//        manager = [[CoreDataManager alloc] init];
//    }
//    return manager;
//}


- (id) init{
    if (self = [super init]){
        NSLog(@"CoreDataMgr::init -- Entering...");
        //initialize CoreData
        [self initializeCoreData];
        NSLog(@"CoreDataMgr::init -- Exiting...");
        return self;
    }
    return nil;
}


- (void) initializeCoreData {
    
    NSLog(@"CoreDataMgr::initializeCoreData -- Entering...");
    //load the schema model
    
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"Model" withExtension:@"momd"];    //Model = schema name without extension
    model = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    //initialize the persistent store coordinator with the model
    //locate app directory
    NSURL *applicationDocumentsDirectory =[[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
    
//    NSURL *storeURL = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:@"WorkoutIntervalDatabase.sqlite"];
    NSURL *storeURL = [applicationDocumentsDirectory URLByAppendingPathComponent:@"WorkoutMgr.sqlite"]; //WorkoutMgr.sqlite = SQLite database name
    
    NSLog(@"storeURL = %@", storeURL);

    NSLog(@"1");
    
    NSError *error = nil;
    psc = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:model];
    
    NSLog(@"2");
    
    //!!!!!!!
    //Find targeted mom file in the Resources directory
    NSString *momPath = [[NSBundle mainBundle] pathForResource:@"Model" ofType:@"momd"];
    NSLog(@"momd path: %@",momPath);
    
    
    
    //[self.moc release];
    //self.moc = nil;
    //[self.moc release];
    //self.moc = nil;
    //[psc release];
    //psc = nil;
    
    // Delete the sqlite file
    NSError *error2 = nil;
    if ([[NSFileManager defaultManager] fileExistsAtPath:storeURL.path]){
        [[NSFileManager defaultManager] removeItemAtURL:storeURL error:&error2];
        NSLog(@"if no error, then storeURL file removed");
    }
    
    
    
    
    
    //!!!!
    if ([psc addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:nil error:&error]) {
    //if ([psc addPersistentStoreWithType:NSSQLiteStoreType configuration:@{NSMigratePersistentStoresAutomaticallyOption:@YES, NSInferMappingModelAutomaticallyOption:@YES} URL:storeURL options:@{NSMigratePersistentStoresAutomaticallyOption:@YES, NSInferMappingModelAutomaticallyOption:@YES} error:&error]) {
        
        NSLog(@"3");

        //initialize the managed object context, set the coordinator
        self.moc = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSMainQueueConcurrencyType];
        
        NSLog(@"4");
        
        [self.moc setPersistentStoreCoordinator:psc];
    } else {
        NSLog(@"initializeCoreData FAILED with error: %@", error);
    }
    
    NSLog(@"5");
    
    NSLog(@"CoreDataMgr::initializeCoreData -- Exiting...");
}


+(NSManagedObjectContext *) getContext
{
    //return [[CoreDataMgr sharedInstance] moc];
    return [[self sharedInstance] moc];
}



- (NSURL *)documentsDirectory
{
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}
@end
