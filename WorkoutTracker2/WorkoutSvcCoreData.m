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
    
    //Check if workout already exists
    if([self workoutExists:name]){
        NSLog(@"WorkoutSvcCoreData::createWorkout -- WORKOUT ALREADY EXISTS -- Exiting...");
        return nil;
    } else {
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
        NSLog(@"WorkoutSvcCoreData::createWorkout -- Workout created -- Exiting...");
        return managedWorkout;
    }
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


- (bool) updateWorkout:(NSString *)name {
    NSLog(@"WorkoutSvcCoreData::updateWorkout -- Entering...");
    bool updated = false;
    if([self workoutExists:name]){
        //workout exists already, can't update to this workout name
    } else {
        //workout doesn't already exist, CAN update to this workout name
        NSError *error;
        if(![moc save:&error]) {
            NSLog(@"updateWorkout ERROR: %@", [error localizedDescription]);
        }
        NSLog(@"WorkoutSvcCoreData::updateWorkout -- Exiting...");
        updated = true;
    }
    return updated;
}


- (Workout *) deleteWorkout: (Workout *) workout {
    NSLog(@"WorkoutSvcCoreData::deleteWorkout -- Entering...");
    if([workout.name isEqualToString:@""]){
        //null workout entered, do nothing
    } else {
        //valid workout object entered, delete workout
        [moc deleteObject:workout];
    }
    NSLog(@"WorkoutSvcCoreData::deleteWorkout -- Exiting...");
    return workout;
}


- (void) deleteWorkoutByName: (NSString *) name {
    NSLog(@"WorkoutSvcCoreData::deleteWorkout -- Entering...");
    int row = 0;
    NSString *tempName = @"";
    NSArray *workouts = self.retrieveAllWorkouts;
    if([name isEqualToString:@""]){
        //do nothing
        NSLog(@"null name entered");
    } else {
        //a valid name string was entered
        for(Workout *workout in workouts){
            tempName = workout.name;
            if([tempName isEqualToString:name]){
                //workout exists!
                [moc deleteObject:workout];
                NSLog(@"Workout deleted: %@", workout.name);
                break;
            }
            row = row +1;
        }
    }
    
    NSLog(@"WorkoutSvcCoreData::deleteWorkout -- Exiting...");
}


- (BOOL) workoutExists:(NSString *) name {
    bool exists = false;
    NSString *tempName = @"";
    NSArray *workouts = self.retrieveAllWorkouts;
    //NSArray *workouts = [[WorkoutSvcCoreData sharedInstance] retrieveAllWorkouts];
    for(Workout *workout in workouts){
        tempName = workout.name;
        if([tempName isEqualToString:name]){
            //workout exists!
            exists = true;
            break;
        }
    }
    return exists;
}


@end
