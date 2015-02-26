//
//  WorkoutSvc.h
//  WorkoutTracker2
//
//  Created by Cody McDonald on 1/29/15.
//  Copyright (c) 2015 msse650. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Workout.h"

@protocol WorkoutSvc <NSObject>

//- (Workout *) createWorkout: (Workout *) workout;
- (Workout *) createWorkout:(NSString *)category location:(NSString *)location name:(NSString *)name;
//- (NSMutableArray *) retrieveAllWorkouts;
- (NSArray *) retrieveAllWorkouts;  //CoreData return type is NSArray, not NSMutableArray
//- (Workout *) updateWorkout: (Workout *) workout;
//- (void) updateWorkout;
- (bool) updateWorkout:(NSString *)name;
- (Workout *) deleteWorkout: (Workout *) workout;
- (void) deleteWorkoutByName: (NSString *) name;
- (BOOL) workoutExists:(NSString *) name;

@end
