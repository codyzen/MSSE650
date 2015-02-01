//
//  DetailViewController.m
//  WorkoutTracker2
//
//  Created by Cody McDonald on 1/31/15.
//  Copyright (c) 2015 msse650. All rights reserved.
//

#import "DetailViewController.h"
#import "WorkoutSvc.h"
#import "WorkoutSvcCache.h"

@interface DetailViewController ()

@end

@implementation DetailViewController

// Synthesize properties passed via segue
@synthesize selectedWorkout;

-(void) setSelectedWorkout:(Workout*) passedWorkout{
    selectedWorkout = passedWorkout;
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
    
    //TODO - handle empty form
    
    //dismiss keyboard
    [self.view endEditing:YES];
    //create workout
    
    NSLog(@"self.workoutNameTxt.text: %@",self.workoutNameTxt.text);
    NSLog(@"(self.workoutNameTxt.text != nil): %d",(self.workoutNameTxt != nil));
    NSLog(@"(self.workoutNameTxt.text == nil): %d",(self.workoutNameTxt == nil));
    
    if (self.workoutNameTxt.text != nil){
        //This is not working, returning true when it is nil XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
        NSLog(@"DetailViewController::createWorkoutBtn -- a workout name was entered");
        //a workout name was entered
        Workout *workoutNew = [[Workout alloc] init];
        workoutNew.name = self.workoutNameTxt.text;
        workoutNew.location = self.workoutLocationTxt.text;
        workoutNew.category = self.workoutCategoryTxt.text;
        //add new workout to data store (workout array)
        [[WorkoutSvcCache sharedInstance] createWorkout:workoutNew];
    }
    
    NSLog(@"DetailViewController::createWorkoutBtn -- Exiting...");
    [self.navigationController popToRootViewControllerAnimated:TRUE];
}


- (IBAction)updateWorkoutBtn:(id)sender {
    NSLog(@"DetailViewController::updateWorkoutBtn -- Entering...");
    //dismiss keyboard
    [self.view endEditing:YES];
    //create updated workout object
    Workout *workoutUpdated = [[Workout alloc] init];
    workoutUpdated.name = self.workoutNameTxt.text;
    workoutUpdated.location = self.workoutLocationTxt.text;
    workoutUpdated.category = self.workoutCategoryTxt.text;
    if(selectedWorkout.name != self.workoutNameTxt.text){
        //user is editing the workout name
        [[WorkoutSvcCache sharedInstance] deleteWorkout:selectedWorkout];
        [[WorkoutSvcCache sharedInstance] createWorkout:workoutUpdated];
    }else{
        //user is not editing the workout name
        [[WorkoutSvcCache sharedInstance] updateWorkout:workoutUpdated];
    }
    
    //TODO -- handle case where returned workout == nil (no workouts by that name exist in the array)

    NSLog(@"DetailViewController::updateWorkoutBtn -- Exiting...");
    [self.navigationController popToRootViewControllerAnimated:TRUE];
}


- (IBAction)deleteWorkoutBtn:(id)sender {
    NSLog(@"DetailViewController::deleteWorkoutBtn -- Entering...");
    //dismiss keyboard
    [self.view endEditing:YES];
    [[WorkoutSvcCache sharedInstance] deleteWorkout:selectedWorkout];
    NSLog(@"DetailViewController::deleteWorkoutBtn -- Exiting...");
    [self.navigationController popToRootViewControllerAnimated:TRUE];
}



//- (IBAction)doneBtn:(id)sender {
//    [self dismissViewControllerAnimated:YES completion:nil];
//}

@end
