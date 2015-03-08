//
//  ExerciseSvc.h
//  WorkoutTracker2
//
//  Created by Cody McDonald on 3/1/15.
//  Copyright (c) 2015 msse650. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Exercise.h"

@protocol ExerciseSvc <NSObject>

- (Exercise *) createExercise:(NSString *)name
                         sets:(NSNumber *)sets
                         reps:(NSNumber *)reps
                   restPeriod:(NSNumber *)restPeriod
                     timeUnit:(NSString *)timeUnit
                         time:(NSNumber *)time
                     distance:(NSNumber *)distance
                 distanceUnit:(NSString *)distanceUnit
             intensityPercent:(NSNumber *)intensityPercent;


- (NSArray *) retrieveAllExercises;  //CoreData return type is NSArray, not NSMutableArray


- (bool) updateExercise:(NSString *) name;


- (Exercise *) deleteExercise: (Exercise *) exercise;


- (void) deleteExerciseByName: (NSString *) name;


- (BOOL) exerciseExists:(NSString *) name;


@end