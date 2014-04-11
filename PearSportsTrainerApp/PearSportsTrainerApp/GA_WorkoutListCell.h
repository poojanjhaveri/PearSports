//
//  GA_WorkoutListCell.h
//  PearSportsTrainerApp
//
//  Created by Poojan Jhaveri on 3/8/14.
//  Copyright (c) 2014 Poojan Jhaveri. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GA_WorkoutListCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIButton *addButton;
@property (weak, nonatomic) IBOutlet UILabel *colourCode;
@property (weak, nonatomic) IBOutlet UILabel *descriptionText;
@property (weak, nonatomic) IBOutlet UILabel *gradeText;
@property (weak, nonatomic) IBOutlet UILabel *activityTypeText;
@property (weak, nonatomic) IBOutlet UILabel *workoutName;

@end
