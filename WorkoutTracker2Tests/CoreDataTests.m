//
//  CoreDataTests.m
//  WorkoutTracker2
//
//  Created by Cody McDonald on 2/25/15.
//  Copyright (c) 2015 msse650. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>
#import "WorkoutSvcCoreData.h"
//#import "Workout.h"


@interface CoreDataTests : XCTestCase

@end

@implementation CoreDataTests

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



//*********************************
// Core Data Tests
//*********************************


- (void) testWorkoutSvcCoreData{
    NSLog(@" ");
    NSLog(@"***************************************");
    NSLog(@"*** Starting testWorkoutSvcCoreData ***");
    NSLog(@"***************************************");
    
    [[WorkoutSvcCoreData sharedInstance] deleteWorkoutByName:@"TestWorkout0"];
    [[WorkoutSvcCoreData sharedInstance] deleteWorkoutByName:@"TestWorkout1"];
    [[WorkoutSvcCoreData sharedInstance] deleteWorkoutByName:@"TestWorkout2"];
    [[WorkoutSvcCoreData sharedInstance] deleteWorkoutByName:@"TestWorkout3"];
    NSLog(@"Core Data Tests preliminary -- workouts deleted");
    
    //[[WorkoutSvcCoreData sharedInstance] deleteWorkoutByName:@"TestWorkout0"];
    
    //create new workout
    Workout *workout0 = [[WorkoutSvcCoreData sharedInstance] createWorkout:@"TestCategory0" location:@"TestLocation0" name:@"TestWorkout0"];
    NSLog(@"****************************************");
    NSLog(@"*** Workout0 created: %@, %@, %@", workout0.name, workout0.location, workout0.category);
    NSLog(@"****************************************");
    
    //retrieve all workouts -- pre-creation count
    NSArray *workoutsArray1 = [[WorkoutSvcCoreData sharedInstance] retrieveAllWorkouts];
    NSLog(@"****************************************");
    NSLog(@"*** Pre-Creation workout count: %lu", (unsigned long)workoutsArray1.count);
    NSLog(@"****************************************");
    
    //create new workout
    Workout *workout1 = [[WorkoutSvcCoreData sharedInstance] createWorkout:@"TestCategory1" location:@"TestLocation1" name:@"TestWorkout1"];
    NSLog(@"****************************************");
    NSLog(@"*** Workout1 created: %@, %@, %@", workout1.name, workout1.location, workout1.category);
    NSLog(@"****************************************");
    
    //retrieve all workouts -- post-creation count
    NSArray *workoutsArray2 = [[WorkoutSvcCoreData sharedInstance] retrieveAllWorkouts];
    NSLog(@"****************************************");
    NSLog(@"*** Post-Creation workout count: %lu", (unsigned long)workoutsArray2.count);
    NSLog(@"****************************************");
    
    //TEST 1
    //workouts1.count + 1 new workout created should equal workouts2.count
    XCTAssertEqual((workoutsArray1.count + 1), workoutsArray2.count, @"TEST FAILURE -- workout not added");
    NSLog(@"****************************************");
    NSLog(@"*** TEST 1 COMPLETE...");
    NSLog(@"****************************************");
    
    //create workout with same name
    Workout *workout2 = [[WorkoutSvcCoreData sharedInstance] createWorkout:@"TestCategory1" location:@"TestLocation1" name:@"TestWorkout1"];
    NSLog(@"****************************************");
    NSLog(@"*** Workout2 creation ATTEMPTED (should fail): %@, %@, %@", workout2.name, workout2.location, workout2.category);
    NSLog(@"****************************************");
    
    //retrieve all workouts -- post-no-creation count
    NSArray *workoutsArray3 = [[WorkoutSvcCoreData sharedInstance] retrieveAllWorkouts];
    NSLog(@"****************************************");
    NSLog(@"*** Post-No-Creation workout count: %lu", (unsigned long)workoutsArray3.count);
    NSLog(@"****************************************");
    
    //TEST 2
    //attempted to create workout with same name, should have failed, workouts2.count should equal workouts2.count
    XCTAssertEqual(workoutsArray2.count, workoutsArray3.count, @"TEST FAILURE -- duplicate workout was added");
    NSLog(@"****************************************");
    NSLog(@"*** TEST 2 COMPLETE...");
    NSLog(@"****************************************");
    
    //update workout - no name change (workout1)
    workout1.name = @"TestWorkout1";
    workout1.location = @"TestLocation1 updated";
    workout1.category = @"TestCategory1 updated";
    [[WorkoutSvcCoreData sharedInstance] updateWorkout:workout1.name];
    NSLog(@"****************************************");
    NSLog(@"*** Workout1 updated: %@, %@, %@", workout1.name, workout1.location, workout1.category);
    NSLog(@"****************************************");
    
    //retrieve all workouts -- post-update count
    NSArray *workoutsArray4 = [[WorkoutSvcCoreData sharedInstance] retrieveAllWorkouts];
    NSLog(@"****************************************");
    NSLog(@"*** Post-Update workout count: %lu", (unsigned long)workoutsArray4.count);
    NSLog(@"****************************************");
    
    //Test 3
    //updated workout, no new workout created, workouts3.count should equal workouts4.count
    XCTAssertEqual(workoutsArray3.count, workoutsArray4.count, @"TEST FAILURE -- workout was added on update");
    NSLog(@"****************************************");
    NSLog(@"*** TEST 3 COMPLETE...");
    NSLog(@"****************************************");
    
    //update workout - name change (workout0)
    [[WorkoutSvcCoreData sharedInstance] deleteWorkout:workout0];
    Workout *workout3 = [[WorkoutSvcCoreData sharedInstance] createWorkout:@"TestCategory3" location:@"TestLocation3" name:@"TestWorkout0"];
    NSLog(@"****************************************");
    NSLog(@"*** Workout0 created: %@, %@, %@", workout3.name, workout3.location, workout3.category);
    NSLog(@"****************************************");
    
    //retrieve all workouts -- post-update count
    NSArray *workoutsArray5 = [[WorkoutSvcCoreData sharedInstance] retrieveAllWorkouts];
    NSLog(@"****************************************");
    NSLog(@"*** Post-Update workout count: %lu", (unsigned long)workoutsArray5.count);
    NSLog(@"****************************************");
    
    //Test 4
    //updated workout, workout deleted and workout created, workouts4.count should equal workouts5.count
    XCTAssertEqual(workoutsArray4.count, workoutsArray5.count, @"TEST FAILURE -- workout was added on update");
    NSLog(@"****************************************");
    NSLog(@"*** TEST 4 COMPLETE...");
    NSLog(@"****************************************");

    //delete workout
    [[WorkoutSvcCoreData sharedInstance] deleteWorkout:workout1];
    
    //retrieve all workouts -- post-deletion count
    NSArray *workoutsArray6 = [[WorkoutSvcCoreData sharedInstance] retrieveAllWorkouts];
    NSLog(@"****************************************");
    NSLog(@"*** Post-Deletion workout count: %lu", (unsigned long)workoutsArray6.count);
    NSLog(@"****************************************");
    
    //Test 5
    //deleted workout, workouts5.count -1 should equal workouts6.count
    XCTAssertEqual((workoutsArray5.count - 1), workoutsArray6.count, @"TEST FAILURE -- deleted workout was not removed");
    NSLog(@"****************************************");
    NSLog(@"*** TEST 5 COMPLETE...");
    NSLog(@"****************************************");
    
    //deleting all other workouts created for testing:
    [[WorkoutSvcCoreData sharedInstance] deleteWorkout:workout0];
    [[WorkoutSvcCoreData sharedInstance] deleteWorkout:workout1];
    //[[WorkoutSvcCoreData sharedInstance] deleteWorkout:workout2]; //deleteObject requires a non-nil argument
    [[WorkoutSvcCoreData sharedInstance] deleteWorkoutByName:workout2.name];
    [[WorkoutSvcCoreData sharedInstance] deleteWorkout:workout3];
    
    NSLog(@"****************************************");
    NSLog(@"*** Ending test testWorkoutSvcSQLite ***");
    NSLog(@"****************************************");
    NSLog(@" ");
}





@end
