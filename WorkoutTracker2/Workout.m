//
//  Workout.m
//  WorkoutTracker2
//
//  Created by Cody McDonald on 1/29/15.
//  Copyright (c) 2015 msse650. All rights reserved.
//

#import "Workout.h"

@implementation Workout

static NSString *const NAME = @"name";
static NSString *const LOCATION = @"location";
static NSString *const CATEGORY = @"category";
static NSInteger *const ID = nil;

//Workout constructor implementation
- (instancetype)initWithName:(NSString *)name location:(NSString *)location category:(NSString *)category{
    //initialize Workout with super
    self = [super init];
    //initialize Workout properties
    if (self) {
        self.name = name;
        self.location = location;
        self.category = category;
    }
    
    return self;
}

- (NSString *) description {
    return [NSString stringWithFormat: @"%@ %@ %@", self.name, self.location, self.category];
}

//*************************
//* iOS Archiving methods
//*************************

- (void)encodeWithCoder:(NSCoder *)coder{
    //encode three properties
    //[coder encodeObject:self.name forKey:@"name"];
    [coder encodeObject:self.name forKey:NAME];
    [coder encodeObject:self.location forKey:LOCATION];
    [coder encodeObject:self.category forKey:CATEGORY];
}

- (id)initWithCoder:(NSCoder *)decoder{
    self = [super init];
    if (self){
        //_name = [decoder decodeObjectForKey:@"name"];
        _name = [decoder decodeObjectForKey:NAME];
        _location = [decoder decodeObjectForKey:LOCATION];
        _category = [decoder decodeObjectForKey:CATEGORY];
    }
    return self;
}

@end
