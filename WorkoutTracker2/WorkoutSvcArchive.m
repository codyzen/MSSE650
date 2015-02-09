//
//  WorkoutSvcArchive.m
//  WorkoutTracker2
//
//  Created by Cody McDonald on 2/8/15.
//  Copyright (c) 2015 msse650. All rights reserved.
//

#import "WorkoutSvcArchive.h"

@implementation WorkoutSvcArchive

NSString *filePath; //file path for archiving
NSMutableArray *workouts;   //workouts array

//making WorkoutSvcCache a singleton
+ (WorkoutSvcArchive *)sharedInstance {
    static WorkoutSvcArchive *_singletonInstance = nil;
    static dispatch_once_t once;
    dispatch_once(&once, ^{
        _singletonInstance = [[WorkoutSvcArchive alloc] init];
    });
    return _singletonInstance;
}


//************************************
//* Methods for archiving
//************************************

- (id) init {   //Constructor
    //initialize path to the archive file
    NSArray *directoryPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [directoryPaths objectAtIndex:0];
    //append file name
    filePath = [[NSString alloc] initWithString:[documentsDirectory stringByAppendingPathComponent:@"Workouts.archive"]];
    //read the archive
    [self readArchive]; //sets workouts with what's in archive file
    
    return self;
}

- (void) readArchive {
    NSFileManager *fileMgr = [NSFileManager defaultManager];
    if ([fileMgr fileExistsAtPath: filePath]){
        //if archive file exists, read the archived array of Workouts from file and
        //assign the unarchived array of Workouts to NSMutableArray *workouts
        workouts = [NSKeyedUnarchiver unarchiveObjectWithFile: filePath];
    }else{
        //if archive file does not exist, assign an empty array to NSMutableArray *workouts
        workouts = [NSMutableArray array];
    }
}

- (void) writeArchive {
    //archive current array of workouts to file
    [NSKeyedArchiver archiveRootObject: workouts toFile:filePath];
}



//************************************
//* Implement WorkoutSvc CRUD methods
//************************************

- (Workout *) createWorkout:(Workout *)workout{
    //TODO need to enforce unique constraint on workouts.name
    //i.e. iterate through array, if already exists return nill, handle nil from controller
    
    //do I need to read from archive here???
    
    NSLog(@"WorkoutSvcArchive::createWorkout -- Entering...");
    NSLog([NSString stringWithFormat:@"   ...workouts count before = %lu", workouts.count]);
    NSLog(@"   ...creating workout %@, %@, %@", workout.name, workout.location, workout.category);
    
    //check if workout name already exists in array using helper method
    int index = [self findWorkout:workout];
    if (index != 99999999){
        //a workout by this name exists -- cannot create!
        NSLog(@"   ...Workout already exists!!!");
        NSLog(@"WorkoutSvcArchive::updateWorkout -- Exiting...");
        return nil;
    }else {
        NSLog(@"   ...workout name does not exist, creating workout...");
        
        //there was not a match, create workout by adding array
        [workouts addObject:workout];
        
        //write new collection to archive
        [self writeArchive];
        
        NSLog([NSString stringWithFormat:@"   ...workouts count after = %lu", workouts.count]);
        NSLog(@"WorkoutSvcArchive::updateWorkout -- Exiting...");
        return workout;
    }
}


- (NSMutableArray *) retrieveAllWorkouts{
    //return array of current workouts
    //do I need to read from archive here?
    return workouts;
}


- (int) findWorkout:(Workout *)workout{
    //helper method to find specific workout from the array of current workouts
    
    bool exists = false;
    int index = 0;
    
    NSLog(@"   workout to find: %@", workout.name);
    
    //iterate through array to find index where workout name exists
    for (int i = 0; i < [workouts count]; i++) {
        Workout *arrayElement = [workouts objectAtIndex:i];
        NSLog(@"   index: %d, name: %@", i, arrayElement.name);
        //if(workout.name == arrayElement.name){
        if([workout.name isEqualToString:arrayElement.name]){
            //i is the index we want to replace at
            index = i;
            exists = true;
            break;
        }//if
    }//for
    
    if(exists){//there was a match
        return index;
    }else{
        return 99999999;
    }
}



- (Workout *) updateWorkout:(Workout *)workout{
    NSLog(@"WorkoutSvcArchive::updateWorkout -- Entering...");
    NSLog([NSString stringWithFormat:@"   ...workouts count before = %lu", workouts.count]);
    NSLog(@"   ...updating workout %@, %@, %@", workout.name, workout.location, workout.category);
    //find the workout in the workout array using helper method
    int index = [self findWorkout:workout];
    if (index != 99999999){
        //a workout by this name exists -- update workout
        [workouts replaceObjectAtIndex:index withObject:workout];
        //write updated workout list to the archive file
        [self writeArchive];
        NSLog(@"   ...Workout Replaced!!!");
        NSLog([NSString stringWithFormat:@"   ...workouts count after = %lu", workouts.count]);
        NSLog(@"WorkoutSvcArchive::updateWorkout -- Exiting...");
        return workout;
    }else {
        //there was not a match
        NSLog(@"   ...Workout Not Found...");
        NSLog([NSString stringWithFormat:@"   ...workouts count after = %lu", workouts.count]);
        NSLog(@"WorkoutSvcArchive::updateWorkout -- Exiting...");
        return nil;
        //when using update method, if result == 0 call createWorkout
    }
}

- (Workout *) deleteWorkout:(Workout *)workout{
    //TODO
    //find the workout in the workout array
    //delete the workout
    //create helper method findContact??
    //write updated workout list to the archive file
    
    NSLog(@"WorkoutSvcArchive::deleteWorkout -- Entering...");
    NSLog([NSString stringWithFormat:@"   ...workouts count before = %lu", workouts.count]);
    NSLog(@"   ...deleting workout %@, %@, %@", workout.name, workout.location, workout.category);
    
    //find the workout in the workout array using helper method
    int index = [self findWorkout:workout];
    if (index != 99999999){
        //a workout by this name exists -- delete workout
        [workouts removeObjectAtIndex:index];
        //write updated workout list to the archive file
        [self writeArchive];
        NSLog(@"   ...Workout at index %d Deleted!!!", index);
        NSLog([NSString stringWithFormat:@"   ...workouts count after = %lu", workouts.count]);
        NSLog(@"WorkoutSvcArchive::deleteWorkout -- Exiting...");
        return workout;
    }else {
        //there was not a match
        NSLog(@"   ...Workout Not Found...");
        NSLog([NSString stringWithFormat:@"   ...workouts count after = %lu", workouts.count]);
        NSLog(@"WorkoutSvcArchive::deleteWorkout -- Exiting...");
        return nil;
        //when using update method, if result == 0 call createWorkout
    }

}



@end
