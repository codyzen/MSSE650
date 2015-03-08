//
//  ExerciseSvcCoreData.h
//  WorkoutTracker2
//
//  Created by Cody McDonald on 3/1/15.
//  Copyright (c) 2015 msse650. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ExerciseSvc.h"

//add protocol ExerciseSvc
@interface ExerciseSvcCoreData : NSObject <ExerciseSvc>

//Member variables must be declared in interface
@property (nonatomic) NSMutableArray *exercises;

//Method declaration
+ (ExerciseSvcCoreData *) sharedInstance;

@end
