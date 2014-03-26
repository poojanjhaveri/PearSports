//
//  GA_WorkoutListForCalendar.h
//  PearSportsTrainerApp
//
//  Created by Garima Aggarwal on 3/25/14.
//  Copyright (c) 2014 Poojan Jhaveri. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GA_Workout.h"

@interface GA_WorkoutListForCalendar : NSObject

@property (strong, nonatomic) NSMutableArray *workoutList;
@property (strong, nonatomic) NSDate *date;
@property (strong, nonatomic) GA_Workout *workout;

- (void)addWorkoutToList:(GA_Workout*)w;
- (BOOL)checkIfDateExists:(NSString*)d;
- (GA_Workout*)getWorkout:(NSInteger*)i;
- (NSInteger) getWorkoutCount;

@end

