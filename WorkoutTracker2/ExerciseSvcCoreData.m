//
//  ExerciseSvcCoreData.m
//  WorkoutTracker2
//
//  Created by Cody McDonald on 3/1/15.
//  Copyright (c) 2015 msse650. All rights reserved.
//

#import "ExerciseSvcCoreData.h"
#import "CoreDataMgr.h"
#import <CoreData/CoreData.h>

@implementation ExerciseSvcCoreData

//NSManagedObjectModel *model = nil;
//NSPersistentStoreCoordinator *psc = nil;
//NSManagedObjectContext *moc = nil;

//making ExerciseSvcSQLite a singleton
+ (ExerciseSvcCoreData *)sharedInstance {
    static ExerciseSvcCoreData *_singletonInstance = nil;
    static dispatch_once_t once;
    dispatch_once(&once, ^{
        _singletonInstance = [[ExerciseSvcCoreData alloc] init];
    });
    return _singletonInstance;
}


//*********************
//  CoreData methods
//*********************

//- (void) initializeCoreData {
//    //load the schema model
//    NSLog(@"ExerciseSvcCoreData::initializeCoreData -- Entering...");
//    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"Model" withExtension:@"momd"];    //Model = schema name without extension
//    model = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
//    
//    //initialize the persistent store coordinator with the model
//    //locate app directory
//    NSURL *applicationDocumentsDirectory =[[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
//    
//    //!!!! TODO using WorkoutMgr.sqlite, because using same DB as Workouts???
//    NSURL *storeURL = [applicationDocumentsDirectory URLByAppendingPathComponent:@"WorkoutMgr.sqlite"]; //WorkoutMgr.sqlite = SQLite database name
//    NSError *error = nil;
//    psc = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:model];
//    if([psc addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:nil error:&error]){
//        //initialize the managed object context, set the coordinator
//        moc = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSMainQueueConcurrencyType];
//        [moc setPersistentStoreCoordinator:psc];
//    } else {
//        NSLog(@"initializeCoreData FAILED with error: %@", error);
//    }
//    NSLog(@"ExerciseSvcCoreData::initializeCoreData -- Exiting...");
//}
//
//
//- (id) init{
//    if (self = [super init]){
//        NSLog(@"ExerciseSvcCoreData::init -- Entering...");
//        //initialize CoreData
//        [self initializeCoreData];
//        NSLog(@"ExerciseSvcCoreData::init -- Exiting...");
//        return self;
//    }
//    return nil;
//}


//************************
//  Exercise/CRUD methods
//************************


- (Exercise *) createExercise:(NSString *)name
                         sets:(NSNumber *)sets
                         reps:(NSNumber *)reps
                   restPeriod:(NSNumber *)restPeriod
                     timeUnit:(NSString *)timeUnit
                         time:(NSNumber *)time
                     distance:(NSNumber *)distance
                 distanceUnit:(NSString *)distanceUnit
             intensityPercent:(NSNumber *)intensityPercent {
    
    NSLog(@"ExerciseSvcCoreData::createExercise -- Entering...");
    
    //Check if exercise already exists
    if([self exerciseExists:name]){
        NSLog(@"ExerciseSvcCoreData::createExercise -- EXERCISE ALREADY EXISTS -- Exiting...");
        return nil;
    } else {
        //create managed object
        Exercise *managedExercise = [self createManagedExercise];
        //set properties of managed object
        managedExercise.name = name;
        managedExercise.sets = sets;
        managedExercise.reps = reps;
        managedExercise.restPeriod = restPeriod;
        managedExercise.timeUnit = timeUnit;
        managedExercise.time = time;
        managedExercise.distance = distance;
        managedExercise.distanceUnit = distanceUnit;
        managedExercise.intensityPercent = intensityPercent;
        
        NSError *error;
        //save the context
        if (![[CoreDataMgr getContext] save:&error]) {
            NSLog(@"createExercise ERROR: %@", [error localizedDescription]);
        }
        NSLog(@"ExerciseSvcCoreData::createExercise -- Exercise created -- Exiting...");
        return managedExercise;
    }
}


//internal method
- (Exercise *) createManagedExercise{
    NSLog(@"ExerciseSvcCoreData::createManagedExercise -- Entering...");
    Exercise *exercise = [NSEntityDescription insertNewObjectForEntityForName:@"Exercise" inManagedObjectContext:[CoreDataMgr getContext]];
    NSLog(@"ExerciseSvcCoreData::createManagedExercise -- Exiting...");
    return exercise;
}


- (NSArray *) retrieveAllExercises {
    NSLog(@"ExerciseSvcCoreData::retrieveAllExercises -- Entering...");
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    //construct the fetch request;
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Exercise" inManagedObjectContext:[CoreDataMgr getContext]];
    [fetchRequest setEntity:entity];
    //sort exercises by name, ascending
    NSSortDescriptor *sortDescriptor =[[NSSortDescriptor alloc] initWithKey:@"name" ascending:YES];
    [fetchRequest setSortDescriptors:@[sortDescriptor]];
    NSError *error;
    //execute the fetch request
    NSArray *fetchedObjects = [[CoreDataMgr getContext] executeFetchRequest:fetchRequest error:&error];
    NSLog(@"ExerciseSvcCoreData::retrieveAllExercises -- Exiting...");
    return fetchedObjects;
}


- (bool) updateExercise:(NSString *)name {
    NSLog(@"ExerciseSvcCoreData::updateExercise -- Entering...");
    bool updated = false;
    if([self exerciseExists:name]){
        //exercise exists already, can't update to this exercise name
    } else {
        //exercise doesn't already exist, CAN update to this exercise name
        NSError *error;
        if(![[CoreDataMgr getContext] save:&error]) {
            NSLog(@"updateExercise ERROR: %@", [error localizedDescription]);
        }
        NSLog(@"ExerciseSvcCoreData::updateExercise -- Exiting...");
        updated = true;
    }
    return updated;
}


- (Exercise *) deleteExercise: (Exercise *) exercise {
    NSLog(@"ExerciseSvcCoreData::deleteExercise -- Entering...");
    if([exercise.name isEqualToString:@""]){
        //null exercise entered, do nothing
    } else {
        //valid exercise object entered, delete exercise
        [[CoreDataMgr getContext] deleteObject:exercise];
    }
    NSLog(@"ExerciseSvcCoreData::deleteExercise -- Exiting...");
    return exercise;
}


- (void) deleteExerciseByName: (NSString *) name {
    NSLog(@"ExerciseSvcCoreData::deleteExercise -- Entering...");
    int row = 0;
    NSString *tempName = @"";
    NSArray *exercises = self.retrieveAllExercises;
    if([name isEqualToString:@""]){
        //do nothing
        NSLog(@"null name entered");
    } else {
        //a valid name string was entered
        for(Exercise *exercise in exercises){
            tempName = exercise.name;
            if([tempName isEqualToString:name]){
                //exercise exists!
                [[CoreDataMgr getContext] deleteObject:exercise];
                NSLog(@"Exercise deleted: %@", exercise.name);
                break;
            }
            row = row +1;
        }
    }
    
    NSLog(@"ExerciseSvcCoreData::deleteExercise -- Exiting...");
}


- (BOOL) exerciseExists:(NSString *) name {
    bool exists = false;
    NSString *tempName = @"";
    NSArray *exercises = self.retrieveAllExercises;
    for(Exercise *exercise in exercises){
        tempName = exercise.name;
        if([tempName isEqualToString:name]){
            //exercise exists!
            exists = true;
            break;
        }
    }
    return exists;
}





@end
