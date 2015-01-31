//
//  WorkoutSvcCache.h
//  WorkoutTracker2
//
//  Created by Cody McDonald on 1/29/15.
//  Copyright (c) 2015 msse650. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WorkoutSvc.h"

//add protocol WorkoutSvc
@interface WorkoutSvcCache : NSObject <WorkoutSvc>

// Member variables must be declared in interface
@property (nonatomic) NSMutableArray *workouts;

// Method declaration
+ (WorkoutSvcCache *)sharedInstance;

@end
