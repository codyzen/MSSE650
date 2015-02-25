//
//  WorkoutSvcCoreData.m
//  WorkoutTracker2
//
//  Created by Cody McDonald on 2/21/15.
//  Copyright (c) 2015 msse650. All rights reserved.
//

#import "WorkoutSvcCoreData.h"

#import <CoreData/CoreData.h>

@implementation WorkoutSvcCoreData

NSManagedObjectModel *model = nil;
NSPersistentStoreCoordinator *psc = nil;
NSManagedObjectContext *moc = nil;


//making WorkoutSvcSQLite a singleton
+ (WorkoutSvcCoreData *)sharedInstance {
    static WorkoutSvcCoreData *_singletonInstance = nil;
    static dispatch_once_t once;
    dispatch_once(&once, ^{
        _singletonInstance = [[WorkoutSvcCoreData alloc] init];
    });
    return _singletonInstance;
}


//*********************
//  CoreData methods
//*********************

- (void) initializeCoreData {
    //load the schema model
    NSLog(@"WorkoutSvcCoreData::initializeCoreData -- Entering...");
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"Model" withExtension:@"momd"];    //Model = schema name without extension
    model = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    
    //initialize the persistent store coordinator with the model
    //locate app directory
    NSURL *applicationDocumentsDirectory =[[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
    
    NSURL *storeURL = [applicationDocumentsDirectory URLByAppendingPathComponent:@"WorkoutMgr.sqlite"]; //WorkoutMgr.sqlite = SQLite database name
    NSError *error = nil;
    psc = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:model];
    if([psc addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:nil error:&error]){
        //initialize the managed object context, set the coordinator
        moc = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSMainQueueConcurrencyType];
        [moc setPersistentStoreCoordinator:psc];
    } else {
        NSLog(@"initializeCoreData FAILED with error: %@", error);
    }
    NSLog(@"WorkoutSvcCoreData::initializeCoreData -- Exiting...");
}


- (id) init{
    if (self = [super init]){
        NSLog(@"WorkoutSvcCoreData::init -- Entering...");
        //initialize CoreData
        [self initializeCoreData];
        NSLog(@"WorkoutSvcCoreData::init -- Exiting...");
        return self;
    }
    return nil;
}


- (Workout *) createWorkout:(NSString *)category
                    location:(NSString *)location
                        name:(NSString *)name {
    NSLog(@"WorkoutSvcCoreData::createWorkout -- Entering...");
    //create managed object
    Workout *managedWorkout = [self createManagedWorkout];
    //set properties of managed object
    managedWorkout.name = name;
    managedWorkout.location = location;
    managedWorkout.category = category;
    NSError *error;
    //save the context
    if (![moc save:&error]) {
        NSLog(@"createWorkout ERROR: %@", [error localizedDescription]);
    }
    NSLog(@"WorkoutSvcCoreData::createWorkout -- Exiting...");
    return managedWorkout;
}


- (Workout *) createManagedWorkout{
    NSLog(@"WorkoutSvcCoreData::createManagedWorkout -- Entering...");
    Workout *workout = [NSEntityDescription insertNewObjectForEntityForName:@"Workout" inManagedObjectContext:moc];
    NSLog(@"WorkoutSvcCoreData::createManagedWorkout -- Exiting...");
    return workout;
}


- (NSArray *) retrieveAllWorkouts {
    NSLog(@"WorkoutSvcCoreData::retrieveAllWorkouts -- Entering...");
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    //construct the fetch request;
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Workout" inManagedObjectContext:moc];
    [fetchRequest setEntity:entity];
    //sort workouts by name, ascending
    NSSortDescriptor *sortDescriptor =[[NSSortDescriptor alloc] initWithKey:@"name" ascending:YES];
    [fetchRequest setSortDescriptors:@[sortDescriptor]];
    NSError *error;
    //execute the fetch request
    NSArray *fetchedObjects = [moc executeFetchRequest:fetchRequest error:&error];
    NSLog(@"WorkoutSvcCoreData::retrieveAllWorkouts -- Exiting...");
    return fetchedObjects;
}


- (void) updateWorkout {
    NSLog(@"WorkoutSvcCoreData::updateWorkout -- Entering...");
    NSError *error;
    if(![moc save:&error]) {
        NSLog(@"updateWorkout ERROR: %@", [error localizedDescription]);
    }
    NSLog(@"WorkoutSvcCoreData::updateWorkout -- Exiting...");
}


- (Workout *) deleteWorkout: (Workout *) workout {
    NSLog(@"WorkoutSvcCoreData::deleteWorkout -- Entering...");
    [moc deleteObject:workout];
    NSLog(@"WorkoutSvcCoreData::deleteWorkout -- Exiting...");
    return workout;
}


@end
