//
//  GA_WorkoutsViewController.h
//  PearSportsTrainerApp
//
//  Created by Poojan Jhaveri on 2/23/14.
//  Copyright (c) 2014 Poojan Jhaveri. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GA_WorkoutsViewController : UITableViewController

@property (strong, nonatomic) IBOutlet UIButton *addWorkoutBtn;

-(IBAction)addWorkout:(UIButton *)sender;

@end
