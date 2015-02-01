//
//  ViewController.h
//  WorkoutTracker2
//
//  Created by Cody McDonald on 1/30/15.
//  Copyright (c) 2015 msse650. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>
//added datasource and delegate

//Variables
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic) NSIndexPath *selectedItemIndex;
@property (weak, nonatomic) IBOutlet UINavigationItem *masterNavBar;

- (IBAction)createWorkoutBtn:(id)sender;


@end

