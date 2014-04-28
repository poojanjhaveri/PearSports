//
//  PJ_Client.h
//  PearSportsTrainerApp
//
//  Created by Devon on 2/9/14.
//  Copyright (c) 2014 Poojan Jhaveri. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PJ_Client : NSObject


@property (strong, nonatomic) NSString * name;
@property (copy) NSString * trainee_id;
@property int numNotifications;
@property (strong, nonatomic) NSString *  age;
@property (strong, nonatomic) NSString * dob;
@property (copy) NSString * email;
@property (strong, nonatomic) NSString * gender;
@property (strong, nonatomic) NSString *  height;
@property (strong, nonatomic) NSString * weight;
@property (strong, nonatomic) NSString * imageName;
@property (strong, nonatomic) NSString * lastWorkout;
@property (strong, nonatomic) NSString * notes;


/*
 
 WorkoutArray is an Array of Arrays. The first order of arrays corresponds to a particular week, the second order corresponds to a particular day.
 
 The indexes for the first order are...
 
 workoutArray[0] = An array of workouts (unscheduled, completed, missed, scheduled) corresponding to two weeks ago.
 workoutArray[1] = An array of workouts corresponding to last week.
 workoutArray[2] = An array of workouts corresponding to the current week.
 
 The indexes for the second order are...
 
 workoutArray[N][0] = Sunday of the N'th week.
 workoutArray[N][1] = Monday of the N'th week.
 ...
 workoutArray[N][6] = Saturday of the N'th week.
 
 
 Therefore, workoutArray[1][2] is the workout corresponding to Tuesday of last week.
 
 */

@property (nonatomic, strong) NSMutableArray * workoutArray;
@property (nonatomic, strong) NSMutableArray * lifeTimeStats;



@end