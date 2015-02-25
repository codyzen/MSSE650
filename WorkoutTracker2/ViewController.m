//
//  ViewController.m
//  WorkoutTracker2
//
//  Created by Cody McDonald on 1/30/15.
//  Copyright (c) 2015 msse650. All rights reserved.
//

#import "ViewController.h"
#import "Workout.h"
//#import "WorkoutSvcCache.h"
//#import "WorkoutSvcArchive.h"
//#import "WorkoutSvcSQLite.h"
#import "WorkoutSvcCoreData.h"
#import "DetailViewController.h"


@interface ViewController ()

@end


@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    NSLog(@"ViewControlller::viewDidLoad -- Entering...");
    //setting up dataSource and delegate
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    NSLog(@"ViewControlller::viewDidLoad -- Exiting...");
}

- (void)didReceiveMemoryWarning {
     NSLog(@"ViewControlller::didReceiveMemoryWarning -- Entering...");
     [super didReceiveMemoryWarning];
     // Dispose of any resources that can be recreated.
     NSLog(@"ViewControlller::didReceiveMemoryWarning -- Exiting...");
}

- (void)viewWillAppear:(BOOL)animated {
    NSLog(@"ViewController::viewWillAppear -- Entering...");
    NSLog(@"ViewController::viewWillAppear -- Exiting...");
}

//is called when we come "Back" to this view
- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    NSLog(@"ViewController::viewDidAppear -- Entering...");
    //reloading, which calls cellForRowAtIndexPath
    [self.tableView reloadData];
    NSLog(@"ViewController::viewDidAppear -- Exiting...");
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSLog(@"ViewController::numberOfRowsInSection -- Entering...");
    //NSLog([NSString stringWithFormat:@"retrieveAllWorkouts count = %lu", (unsigned long)[[[WorkoutSvcCache sharedInstance] retrieveAllWorkouts] count]]);
    //return self.workouts.count;
    NSLog(@"ViewController::numberOfRowsInSection -- calling retrieveAllWorkouts...");
    NSLog(@"ViewController::numberOfRowsInSection -- Exiting...");
    return [[[WorkoutSvcCoreData sharedInstance] retrieveAllWorkouts] count];
    //return [[[[WorkoutSvcSQLite alloc] init] retrieveAllWorkouts] count];

}


//only called when new cells scroll onto the screen, or if table hasn't been displayed before, or if you call reload (tableView.reload?)
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSLog(@"ViewController::cellForRowAtIndexPath -- Entering...");
    
    NSString *cellId = @"workoutCellId";
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
    }
    
    NSLog(@"ViewController::cellForRowAtIndexPath -- calling retrieveAllWorkouts...");
    //Workout *workout = [[[WorkoutSvcCache sharedInstance] retrieveAllWorkouts]objectAtIndex:indexPath.row];
    //Workout *workout = [[[WorkoutSvcArchive sharedInstance] retrieveAllWorkouts]objectAtIndex:indexPath.row];
    Workout *workout = [[[WorkoutSvcCoreData sharedInstance] retrieveAllWorkouts]objectAtIndex:indexPath.row];
    cell.textLabel.text = workout.name;
    
    
    //NSInteger row = indexPath.row;
    //Workout *workout = [self.workouts objectAtIndex:row];
    
    NSLog(@"ViewController::cellForRowAtIndexPath -- Exiting...");
    
    return cell;
}

#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSLog(@"ViewController::didSelectRowAtIndexPath -- Entering...");
    
    self.selectedItemIndex = indexPath;
    
    
    //perform segue from ViewController to DetailViewController
    [self performSegueWithIdentifier:@"WorkoutSelected" sender:self];
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];  //must call here to conform to Apple's human interface guidelines
    
    NSLog(@"ViewController::didSelectRowAtIndexPath -- Exiting...");
}


#pragma mark - Navigtion

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    // Get the new view controller using [segue destinationViewController].
    
    NSLog(@"ViewController::prepareForSegue -- Entering...");
    
    
    NSLog(@"prepare for segue from: %@",segue.identifier);
    
    // Check seque identifier
    if ([segue.identifier isEqualToString:@"WorkoutSelected"]){
        //NSLog(@"ViewController::prepareForSegue -- inside WorkoutSelected if...");
        
        NSLog(@"ViewController::prepareForSegue -- calling retrieveAllWorkouts...");
        
        //Create workout to pass
        //Workout *workoutToPass = [[[WorkoutSvcCache sharedInstance] retrieveAllWorkouts] objectAtIndex:self.selectedItemIndex.row];
        Workout *workoutToPass = [[[WorkoutSvcCoreData sharedInstance] retrieveAllWorkouts] objectAtIndex:self.selectedItemIndex.row];
        //Workout *workoutToPass = [[[[WorkoutSvcSQLite alloc] init] retrieveAllWorkouts] objectAtIndex:self.selectedItemIndex.row];
        
        NSLog(@"workout selected = %@", workoutToPass);
        
        //Pass workout to the destination view controller
        DetailViewController *detailViewCtrl = (DetailViewController *)[segue destinationViewController];
        detailViewCtrl.selectedWorkout = workoutToPass;

    }else if ([segue.identifier isEqualToString:@"CreateWorkout"]){
        NSLog(@"ViewController::prepareForSegue -- inside CreateNewWorkout if...");
        //Create workout to pass
        Workout *workoutToPass = nil;
        NSLog(@"workout selected = %@", workoutToPass);
        
        //Pass nil workout to the destination view controller
        DetailViewController *detailViewCtrl = [segue destinationViewController];
        detailViewCtrl.selectedWorkout = workoutToPass;

    }
    
    NSLog(@"ViewController::prepareForSegue -- Exiting...");
}


- (IBAction)createWorkoutBtn:(id)sender {
    NSLog(@"ViewController::createWorkoutBtn -- Entering...");
    
    //perform segue from ViewController to DetailViewController
    [self performSegueWithIdentifier:@"CreateWorkout" sender:self];
    
    NSLog(@"ViewController::createWorkoutBtn -- Exiting...");
    
}
@end
