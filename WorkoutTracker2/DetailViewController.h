//
//  DetailViewController.h
//  WorkoutTracker2
//
//  Created by Cody McDonald on 1/31/15.
//  Copyright (c) 2015 msse650. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Workout.h"

@interface DetailViewController : UIViewController

//Variables
@property (nonatomic) Workout *selectedWorkout;

//Labels
@property (weak, nonatomic) IBOutlet UILabel *workoutNameLbl;
@property (weak, nonatomic) IBOutlet UILabel *workoutLocationLbl;
@property (weak, nonatomic) IBOutlet UILabel *workoutCategoryLbl;

//Text Boxes
@property (weak, nonatomic) IBOutlet UITextField *workoutNameTxt;
@property (weak, nonatomic) IBOutlet UITextField *workoutLocationTxt;
@property (weak, nonatomic) IBOutlet UITextField *workoutCategoryTxt;

//Buttons
- (IBAction)updateWorkoutBtn:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *updateWorkoutBtnHandle;

- (IBAction)deleteWorkoutBtn:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *deleteWorkoutBtnHandle;

- (IBAction)createWorkoutBtn:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *createWorkoutBtnHandle;


- (IBAction)doneBtn:(id)sender;


@property (weak, nonatomic) IBOutlet UINavigationItem *detailNavBar;





- (void)setSelectedWorkout:(Workout*) passedWorkout;


@end
