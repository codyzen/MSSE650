//
//  WorkoutTracker2Tests.m
//  WorkoutTracker2Tests
//
//  Created by Cody McDonald on 1/30/15.
//  Copyright (c) 2015 msse650. All rights reserved.
//
//  **********************************
//  ** To run tests, Product > Test **
//  **********************************

#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>

#import "Workout.h"
#import "WorkoutSvcArchive.h"

@interface WorkoutTracker2Tests : XCTestCase

@end

@implementation WorkoutTracker2Tests

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
    //name1
    Workout *workout = [[Workout alloc] init];
    workout.name = @"name1";
    workout.location = @"location1";
    workout.category = @"category1";
    WorkoutSvcArchive *workoutSvc = [[WorkoutSvcArchive alloc] init];
    [workoutSvc deleteWorkout:(Workout *) workout];
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
    
    //name1
    Workout *workout = [[Workout alloc] init];
    workout.name = @"name1";
    workout.location = @"location1";
    workout.category = @"category1";
    WorkoutSvcArchive *workoutSvc = [[WorkoutSvcArchive alloc] init];
    [workoutSvc deleteWorkout:(Workout *) workout];
}

- (void)testWorkoutSvcArchiveCreateNewWorkout {
    
    NSLog(@"WoroutTracker2Tests::testWorkoutSvcArchiveCreateNewWorkout -- Entering...");
    
    WorkoutSvcArchive *workoutSvc = [[WorkoutSvcArchive alloc] init];
    
    int count1 = [[workoutSvc retrieveAllWorkouts] count];
    NSLog(@"Workouts count1: %i", count1);
    
    Workout *workout = [[Workout alloc] init];
    workout.name = @"name1";
    workout.location = @"location1";
    workout.category = @"category1";
    
    [workoutSvc createWorkout:(Workout *) workout]; //*** creating workout name1 ***
    
    int count2 = [[workoutSvc retrieveAllWorkouts] count];
    NSLog(@"Workouts count2: %i", count2);
    
    //STAssertEquals((count1 + 1), count2, @"TEST FAILURE -- count1 + 1 != count 2");
    XCTAssertEqual(count1 + 1, count2, @"TEST FAILURE -- count1 + 1 != count 2");
    
    NSLog(@"WoroutTracker2Tests::testWorkoutSvcArchiveCreateNewWorkout -- Exiting...");
    
    //XCTAssert(YES, @"Pass");
}

- (void)testWorkoutSvcArchiveCreateExistingWorkout {
    
    NSLog(@"WoroutTracker2Tests::testWorkoutSvcArchiveCreateExistingWorkout -- Entering...");
    
    Workout *workout1 = [[Workout alloc] init];
    workout1.name = @"name1";
    workout1.location = @"location1";
    workout1.category = @"category1";
    
    WorkoutSvcArchive *workoutSvc = [[WorkoutSvcArchive alloc] init];
    [workoutSvc createWorkout:(Workout *) workout1];
    int count1 = [[workoutSvc retrieveAllWorkouts] count];
    NSLog(@"Workouts count1: %i", count1);
    
    Workout *workout2 = [[Workout alloc] init];
    workout2.name = @"name1";
    workout2.location = @"location123";
    workout2.category = @"category123";
    
    [workoutSvc createWorkout:(Workout *) workout2]; //***THIS SHOULD BE A DUPLICATE BECAUSE WE'VE ALREADY RUN TEST1
    
    int count2 = [[workoutSvc retrieveAllWorkouts] count];
    NSLog(@"Workouts count2: %i", count2);
    
    //STAssertEquals((count1 + 1), count2, @"TEST FAILURE -- count1 + 1 != count 2");
    XCTAssertEqual(count1, count2, @"TEST FAILURE -- count1 != count 2");
    
    NSLog(@"WoroutTracker2Tests::testWorkoutSvcArchiveCreateExistingWorkout -- Exiting...");
    
    //XCTAssert(YES, @"Pass");
}

- (void)testWorkoutSvcArchiveUpdateExistingWorkout {
    
    NSLog(@"WoroutTracker2Tests::testWorkoutSvcArchiveUpdateExistingWorkout -- Entering...");
    
    Workout *workout1 = [[Workout alloc] init];
    workout1.name = @"name1";
    workout1.location = @"location123";
    workout1.category = @"category123";
 
    WorkoutSvcArchive *workoutSvc = [[WorkoutSvcArchive alloc] init];
    
    int count1 = [[workoutSvc retrieveAllWorkouts] count];
    NSLog(@"Workouts count1: %i", count1);
    
    [workoutSvc updateWorkout:(Workout *) workout1];
    
    int count2 = [[workoutSvc retrieveAllWorkouts] count];
    NSLog(@"Workouts count2: %i", count2);
    
    //STAssertEquals((count1 + 1), count2, @"TEST FAILURE -- count1 + 1 != count 2");
    XCTAssertEqual(count1, count2, @"TEST FAILURE -- count1 != count 2");
    
    NSLog(@"WoroutTracker2Tests::testWorkoutSvcArchiveUpdateExistingWorkout -- Exiting...");
    
    //XCTAssert(YES, @"Pass");
}


- (void)testWorkoutSvcArchiveDeleteExistingWorkout {
    
    NSLog(@"WoroutTracker2Tests::testWorkoutSvcArchiveDeleteExistingWorkout -- Entering...");
    
    Workout *workout1 = [[Workout alloc] init];
    workout1.name = @"name1";
    workout1.location = @"location1";
    workout1.category = @"category1";
    
    WorkoutSvcArchive *workoutSvc = [[WorkoutSvcArchive alloc] init];
    [workoutSvc createWorkout:(Workout *) workout1];
    int count1 = [[workoutSvc retrieveAllWorkouts] count];
    NSLog(@"Workouts count1: %i", count1);
    
    [workoutSvc deleteWorkout:(Workout *) workout1];
    
    int count2 = [[workoutSvc retrieveAllWorkouts] count];
    NSLog(@"Workouts count2: %i", count2);
    
    //STAssertEquals((count1 + 1), count2, @"TEST FAILURE -- count1 + 1 != count 2");
    XCTAssertEqual(count1 - 1, count2, @"TEST FAILURE -- count1 - 1 != count 2");
    
    NSLog(@"WoroutTracker2Tests::testWorkoutSvcArchiveDeleteExistingWorkout -- Exiting...");
    
    //XCTAssert(YES, @"Pass");
}



- (void)testPerformanceExample {
    // This is an example of a performance test case.
    [self measureBlock:^{
        // Put the code you want to measure the time of here.
    }];
}

@end
