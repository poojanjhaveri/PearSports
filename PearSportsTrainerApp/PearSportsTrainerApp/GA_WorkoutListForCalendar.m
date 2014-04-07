//
//  GA_WorkoutListForCalendar.m
//  PearSportsTrainerApp
//
//  Created by Garima Aggarwal on 3/25/14.
//  Copyright (c) 2014 Poojan Jhaveri. All rights reserved.
//

#import "GA_WorkoutListForCalendar.h"

@implementation GA_WorkoutListForCalendar

@synthesize workoutList;
@synthesize date;
@synthesize workout;


- (id)init
{
    self = [super init];
    if (self) {
        self.workoutList = [[NSMutableArray alloc] init];
//        GA_Workout *ga = [[GA_Workout alloc] init];
//        ga.workoutName = @"Schedule a workout";
//        [self addWorkoutToList:ga];
    }
    return self;
}

- (void)addWorkoutToList:(GA_Workout*)w
{
    if(w == nil){
        NSLog(@"Nil");
    }
    else{
        workout = w;
        [self.workoutList addObject:workout];
    }
}

- (BOOL)checkIfDateExists:(NSString*)d
{
    NSDateFormatter *format = [[NSDateFormatter alloc] init];
    format.dateFormat = @"yyyy-MM-dd";
    
    NSString *wDate = [format stringFromDate:(date)];
    
    if([wDate isEqualToString: d]){
        return true;
    }
    
    return false;
}

- (GA_Workout*)getWorkout:(NSInteger*)i
{
    if(workoutList.count > 0)
        workout = [workoutList objectAtIndex:(int)i];
    return workout;
}

- (NSInteger) getWorkoutCount
{
    return self.workoutList.count;
}


@end