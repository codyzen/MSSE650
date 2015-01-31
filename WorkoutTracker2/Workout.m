//
//  Workout.m
//  WorkoutTracker2
//
//  Created by Cody McDonald on 1/29/15.
//  Copyright (c) 2015 msse650. All rights reserved.
//

#import "Workout.h"

@implementation Workout

//Workout constructor implementation
- (instancetype)initWithDay:(NSInteger)day month:(NSInteger)month year:(NSInteger)year name:(NSString *)name location:(NSString *)location category:(NSString *)category{
    //initialize Workout with super
    self = [super init];
    //initialize Workout properties
    if (self) {
        self.date = [[NSDate alloc] init];
        self.name = name;
        self.location = location;
        self.category = category;
    }
    
    return self;
}

- (NSString *) description {
    return [NSString stringWithFormat: @"%@ %@ %@", self.name, self.location, self.category];
}

@end
