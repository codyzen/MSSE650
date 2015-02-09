//
//  WorkoutSvcArchive.h
//  WorkoutTracker2
//
//  Created by Cody McDonald on 2/8/15.
//  Copyright (c) 2015 msse650. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WorkoutSvc.h"

//add protocol WorkoutSvc
@interface WorkoutSvcArchive : NSObject <WorkoutSvc>

// Member variables must be declared in interface
@property (nonatomic) NSMutableArray *workouts;

// Method declaration
+ (WorkoutSvcArchive *)sharedInstance;
+ (int) findWorkout:(Workout *)workout;


@end
