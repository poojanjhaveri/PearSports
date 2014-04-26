//
//  GA_PersonalizeViewController.h
//  PearSportsTrainerApp
//
//  Created by Student on 3/17/14.
//  Copyright (c) 2014 Poojan Jhaveri. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GA_Calendar.h"

@interface GA_PersonalizeWorkout : UITableViewController <UITextViewDelegate>

@property NSString *wName;
@property NSString *wSKU;
@property NSString *notes;
@property NSDate *wDate;

@end
