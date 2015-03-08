//
//  Exercise.h
//  WorkoutTracker2
//
//  Created by Cody McDonald on 3/1/15.
//  Copyright (c) 2015 msse650. All rights reserved.
//

//#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@interface Exercise : NSManagedObject

@property (nonatomic, retain) NSNumber * distance;
@property (nonatomic, retain) NSString * distanceUnit;
@property (nonatomic, retain) NSNumber * id;
@property (nonatomic, retain) NSNumber * intensityPercent;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSNumber * reps;
@property (nonatomic, retain) NSNumber * restPeriod;
@property (nonatomic, retain) NSNumber * sets;
@property (nonatomic, retain) NSNumber * time;
@property (nonatomic, retain) NSString * timeUnit;

@end
