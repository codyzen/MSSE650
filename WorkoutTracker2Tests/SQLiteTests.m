//
//  SQLiteTests.m
//  WorkoutTracker2
//
//  Created by Cody McDonald on 2/15/15.
//  Copyright (c) 2015 msse650. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>

#import "Workout.h"
#import "WorkoutSvcSQLite.h"

@interface SQLiteTests : XCTestCase

@end

@implementation SQLiteTests

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testExample {
    // This is an example of a functional test case.
    XCTAssert(YES, @"Pass");
}

- (void)testPerformanceExample {
    // This is an example of a performance test case.
    [self measureBlock:^{
        // Put the code you want to measure the time of here.
    }];
}


- (void) testWorkoutSvcSQLite{
    NSLog(@" ");
    NSLog(@"*** Starting testWorkoutSvcSQLite ***");
    
    WorkoutSvcSQLite *workoutSvc = [[WorkoutSvcSQLite alloc] init];
    
    //retrieve all workouts -- pre-creation count
    NSMutableArray *workouts1 = [workoutSvc retrieveAllWorkouts];
    NSLog(@"********************");
    NSLog(@"SQLiteTests::testWorkoutSvcSQLite -- Pre-Creation workout count: %lu", (unsigned long)workouts1.count);
    NSLog(@"********************");
    
    //create new workout
    Workout *workout1 = [[Workout alloc] init];
    workout1.name = @"TestWorkout1";
    workout1.location = @"TestLocation1";
    workout1.category = @"TestCategory1";
    [workoutSvc createWorkout:workout1];
    
    //retrieve all workouts -- post-creation count
    NSMutableArray *workouts2 = [workoutSvc retrieveAllWorkouts];
    NSLog(@"********************");
    NSLog(@"SQLiteTests::testWorkoutSvcSQLite -- Post-Creation workout count: %lu", (unsigned long)workouts2.count);
    NSLog(@"********************");
    
    //workouts1.count + 1 new workout created should equal workouts2.count
    XCTAssertEqual((workouts1.count + 1), workouts2.count, @"TEST FAILURE -- workout not added");
    
    //create workout with same name
    Workout *workout2 = [[Workout alloc] init];
    workout2.name = @"TestWorkout1";
    workout2.location = @"TestLocation2";
    workout2.category = @"TestCategory2";
    [workoutSvc createWorkout:workout2];
    
    //retrieve all workouts -- post-no-creation count
    NSMutableArray *workouts3 = [workoutSvc retrieveAllWorkouts];
    NSLog(@"********************");
    NSLog(@"SQLiteTests::testWorkoutSvcSQLite -- Post-No-Creation workout count: %lu", (unsigned long)workouts3.count);
    NSLog(@"********************");
    
    //attemted to create workout with same name, should have failed, workouts2.count should equal workouts2.count
    XCTAssertEqual(workouts2.count, workouts3.count, @"TEST FAILURE -- duplicate workout was added");
    
    //update workout
    workout1.name = @"NewTestWorkout1";
    workout1.location = @"NewTestLocation1";
    workout1.category = @"NewTestCategory1";
    [workoutSvc updateWorkout:workout1];
    
    //retrieve all workouts -- post-update count
    NSMutableArray *workouts4 = [workoutSvc retrieveAllWorkouts];
    NSLog(@"********************");
    NSLog(@"SQLiteTests::testWorkoutSvcSQLite -- Post-Update workout count: %lu", (unsigned long)workouts4.count);
    NSLog(@"********************");
    
    //updated workout, no new workout created, workouts3.count should equal workouts4.count
    XCTAssertEqual(workouts3.count, workouts4.count, @"TEST FAILURE -- workout was added on update");
    
    //delete workout
    [workoutSvc deleteWorkout:workout1];
    
    //retrieve all workouts -- post-deletion count
    NSMutableArray *workouts5 = [workoutSvc retrieveAllWorkouts];
    NSLog(@"********************");
    NSLog(@"SQLiteTests::testWorkoutSvcSQLite -- Post-Deletion workout count: %lu", (unsigned long)workouts5.count);
    NSLog(@"********************");
    
    //deleted workout, workouts4.count -1 should equal workouts5.count
    XCTAssertEqual((workouts4.count - 1), workouts5.count, @"TEST FAILURE -- deleted workout was not removed");
    
    NSLog(@"*** Ending test testWorkoutSvcSQLite ***");
    NSLog(@" ");
}


@end
