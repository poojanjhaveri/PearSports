//
//  GA_PlanViewController.h
//  PearSportsTrainerApp
//
//  Created by Garima Aggarwal on 4/15/14.
//  Copyright (c) 2014 Poojan Jhaveri. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GA_PersonalizePlan : UITableViewController

@property NSString *wName;
@property NSString *wSKU;
@property NSString *notes;
@property NSDate *wDate;
@property NSMutableArray *switches;

@property (weak, nonatomic) IBOutlet UILabel *workoutNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (weak, nonatomic) IBOutlet UIButton *scheduleBtn;

@property (weak, nonatomic) IBOutlet UISwitch *switch0;
@property (weak, nonatomic) IBOutlet UISwitch *switch1;
@property (weak, nonatomic) IBOutlet UISwitch *switch2;
@property (weak, nonatomic) IBOutlet UISwitch *switch3;
@property (weak, nonatomic) IBOutlet UISwitch *switch4;
@property (weak, nonatomic) IBOutlet UISwitch *switch5;
@property (weak, nonatomic) IBOutlet UISwitch *switch6;



@end
