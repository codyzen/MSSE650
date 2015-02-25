//
//  DetailViewController.m
//  WorkoutTracker2
//
//  Created by Cody McDonald on 1/31/15.
//  Copyright (c) 2015 msse650. All rights reserved.
//

#import "DetailViewController.h"
#import "WorkoutSvc.h"
//#import "WorkoutSvcCache.h"
//#import "WorkoutSvcArchive.h"
//#import "WorkoutSvcSQLite.h"
#import "WorkoutSvcCoreData.h"
#import <CoreData/CoreData.h>
//#import "Workout.h" //!!!!

@interface DetailViewController ()

@end

@implementation DetailViewController

// Synthesize properties passed via segue
@synthesize selectedWorkout;

-(void) setSelectedWorkout:(Workout*) passedWorkout{
    selectedWorkout = passedWorkout;
    NSLog(@"workout selected: %@, %@, %@, %@", passedWorkout.id, passedWorkout.name, passedWorkout.location, passedWorkout.category);
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    //set label to Workout name
    self.workoutNameLbl.text = @"Workout Name";
    //set text box to Workout name
    self.workoutNameTxt.text = self.selectedWorkout.name;
    
    //set label to Location
    self.workoutLocationLbl.text = @"Location";
    //set text box to Location
    self.workoutLocationTxt.text = self.selectedWorkout.location;
    
    //set label to Category
    self.workoutCategoryLbl.text = @"Category";
    //set text box to Category
    self.workoutCategoryTxt.text = self.selectedWorkout.category;
    
    //if workout is not null
    if (selectedWorkout == nil) {
        //user is creating a new workout -- hide update and delete buttons
        _updateWorkoutBtnHandle.hidden = YES;
        _deleteWorkoutBtnHandle.hidden = YES;
        
    }else{
        //user is creating a new workout -- hide create button
        _createWorkoutBtnHandle.hidden = YES;
    }
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/



- (IBAction)createWorkoutBtn:(id)sender {
    NSLog(@"DetailViewController::createWorkoutBtn -- Entering...");
    
    //dismiss keyboard
    [self.view endEditing:YES];
    
    if([self.workoutNameTxt.text length] != 0){
        //a workout name was entered, create workout
        NSLog(@"DetailViewController::createWorkoutBtn -- a workout name was entered for creation");
        if([self workoutExists:self.workoutNameTxt.text]){
            //workout already exists, show alert box
            NSLog(@"DetailViewController::createWorkoutBtn -- workout already exists!!!!");
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Workout Already Exists"
                                                            message:@"A workout by this name already exists.  You can update the existing workout or create a new workout with a different name."
                                                           delegate:nil cancelButtonTitle:@"OK"
                                                  otherButtonTitles:nil];
            [alert show];
        } else {
            //workout doesn't already exists, can create it
            Workout *workoutAttempted = [[WorkoutSvcCoreData sharedInstance] createWorkout:self.workoutCategoryTxt.text location:self.workoutLocationTxt.text name:self.workoutNameTxt.text];
            NSLog(@"DetailViewController::createWorkoutBtn -- workout created: %@, %@, %@", workoutAttempted.name, workoutAttempted.location, workoutAttempted.category);
        }
    }
    NSLog(@"DetailViewController::createWorkoutBtn -- Exiting...");
    [self.navigationController popToRootViewControllerAnimated:TRUE];
}


- (IBAction)updateWorkoutBtn:(id)sender {
    NSLog(@"DetailViewController::updateWorkoutBtn -- Entering...");
    //dismiss keyboard
    [self.view endEditing:YES];
    
    if([selectedWorkout.name isEqualToString:self.workoutNameTxt.text]) {
        //user is not editing the workout name
        selectedWorkout.location = self.workoutLocationLbl.text;
        selectedWorkout.category = self.workoutCategoryTxt.text;
        [[WorkoutSvcCoreData sharedInstance] updateWorkout];
    }else{
        //user is editing the workout name...
        if([self workoutExists:self.workoutNameTxt.text]){
            //workout already exists, show alert box
            NSLog(@"DetailViewController::createWorkoutBtn -- workout already exists!!!!");
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Workout Already Exists"
                                                            message:@"A workout by this name already exists.  You can update the existing workout or create a new workout with a different name."
                                                           delegate:nil cancelButtonTitle:@"OK"
                                                  otherButtonTitles:nil];
            [alert show];
        } else {
            //workout does not already exist, create new workout
            [[WorkoutSvcCoreData sharedInstance] deleteWorkout:selectedWorkout];
            [[WorkoutSvcCoreData sharedInstance] createWorkout:self.workoutCategoryTxt.text location:self.workoutLocationTxt.text name:self.workoutNameTxt.text];
        }
    }
    
    NSLog(@"DetailViewController::updateWorkoutBtn -- Exiting...");
    [self.navigationController popToRootViewControllerAnimated:TRUE];
}


- (IBAction)deleteWorkoutBtn:(id)sender {
    NSLog(@"DetailViewController::deleteWorkoutBtn -- Entering...");
    //dismiss keyboard
    [self.view endEditing:YES];
    
    [[WorkoutSvcCoreData sharedInstance] deleteWorkout:selectedWorkout];
    NSLog(@"DetailViewController::deleteWorkoutBtn -- Exiting...");
    [self.navigationController popToRootViewControllerAnimated:TRUE];
}


- (BOOL) workoutExists:(NSString *) name {
    bool exists = false;
    NSString *tempName = @"";
    NSArray *workouts = [[WorkoutSvcCoreData sharedInstance] retrieveAllWorkouts];
    for(Workout *workout in workouts){
        tempName = workout.name;
        if([tempName isEqualToString:name]){
            //workout exists!
            exists = true;
            break;
        }
    }
    return exists;
}


@end
