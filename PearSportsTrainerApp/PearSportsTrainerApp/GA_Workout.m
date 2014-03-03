//
//  GA_Workout.m
//  PearSportsTrainerApp
//
//  Created by Garima Aggarwal on 2/27/14.
//  Copyright (c) 2014 Poojan Jhaveri. All rights reserved.
//

#import "GA_Workout.h"

@implementation GA_Workout

@synthesize workoutName = _workoutName;


-(void)setName:(NSString *) name
{
    _workoutName = name;
    NSLog(@"workoutName: %@",name);
}


@end
