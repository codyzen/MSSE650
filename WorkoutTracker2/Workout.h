//
//  Workout.h
//  WorkoutTracker2
//
//  Created by Cody McDonald on 1/29/15.
//  Copyright (c) 2015 msse650. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Workout : NSObject <NSCoding>

//properties of a Workout object
@property (nonatomic) NSInteger *id;
@property (nonatomic) NSString *name;
@property (nonatomic) NSString *location;
@property (nonatomic) NSString *category;

//Workout constructor declaration
- (instancetype)initWithName:(NSString *)name location:(NSString *)location category:(NSString *)category;

@end
