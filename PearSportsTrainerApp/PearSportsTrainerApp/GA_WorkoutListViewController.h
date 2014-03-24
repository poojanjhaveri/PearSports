//
//  GA_WorkoutListViewController.h
//  PearSportsTrainerApp
//
//  Created by Garima Aggarwal on 3/11/14.
//  Copyright (c) 2014 Poojan Jhaveri. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GA_Workout.h"

@interface GA_WorkoutListViewController : UITableViewController

@property (nonatomic, retain) NSMutableArray *workoutList;

@property NSDate *wDate;

@end
