//
//  GA_WorkoutsViewController.h
//  PearSportsTrainerApp
//
//  Created by Poojan Jhaveri on 2/23/14.
//  Copyright (c) 2014 Poojan Jhaveri. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GA_WorkoutListForCalendar.h"

@interface GA_ViewController : UITableViewController

@property (strong, nonatomic) NSArray *wIncompleteList;
@property (strong, nonatomic) NSArray *wCompleteList;

-(void) showAlert;

@end
