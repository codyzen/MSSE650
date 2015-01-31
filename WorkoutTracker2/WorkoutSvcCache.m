//
//  WorkoutSvcCache.m
//  WorkoutTracker2
//
//  Created by Cody McDonald on 1/25/15.
//  Copyright (c) 2015 msse650. All rights reserved.
//

#import "WorkoutSvcCache.h"


@implementation WorkoutSvcCache

//making WorkoutSvcCache a singleton
+ (WorkoutSvcCache *)sharedInstance {
    static WorkoutSvcCache *_singletonInstance = nil;
    static dispatch_once_t once;
    dispatch_once(&once, ^{
        _singletonInstance = [[WorkoutSvcCache alloc] init];
    });
    return _singletonInstance;
}

- (id) init{
    if (self = [super init]) {
        self.workouts = [NSMutableArray array];
        return self;
    }
    return nil;
}

- (Workout *) createWorkout: (Workout *) workout {
    NSLog(@"WorkoutSvcCache::createWorkout -- Entering...");
    
    //TODO need to enforce unique constraint on workouts.name
    //i.e. iterate through array, if already exists return nill, handle nil from controller
    
    NSLog([NSString stringWithFormat:@"workouts count before = %lu", self.workouts.count]);
    
    [self.workouts addObject: workout];
    
    NSLog([NSString stringWithFormat:@"workouts count after = %lu", self.workouts.count]);
    
    NSLog(@"WorkoutSvcCache::createWorkout -- Exiting...");
    return workout;
}

- (NSMutableArray *) retrieveAllWorkouts {
    return self.workouts;
}

- (Workout *) updateWorkout: (Workout *) workout { return workout;
    
    //Note: until we implement a DB, treating workout.name as the unique ientifier
    
    //iterate through array to find index where workout name exists
    int i;
    for (i = 0; i < [self.workouts count]; i++) {
        Workout *arrayElement = [self.workouts objectAtIndex:i];
        if(workout.name == arrayElement.name){
            //i is the index we want to replace at
            break;
        }
    }
    if(i < [self.workouts count]){   //there was a match
        //replace objet at index#
        [self.workouts replaceObjectAtIndex:i withObject:workout];
    } else {
        return nil;
        //when using update method, if result == 0 call createWorkout
    }
    
}

- (Workout *) deleteWorkout: (Workout *) workout {
    
    //Note: until we implement a DB, treating workout.name as the unique ientifier
    
    //iterate through array to find index where workout name exists
    int i;
    for (i = 0; i < [self.workouts count]; i++) {
        Workout *arrayElement = [self.workouts objectAtIndex:i];
        if(workout.name == arrayElement.name){
            //i is the index we want to remove
            break;
        }
    }
    [self.workouts removeObjectAtIndex:i];
    
    return workout;
    
}

@end
