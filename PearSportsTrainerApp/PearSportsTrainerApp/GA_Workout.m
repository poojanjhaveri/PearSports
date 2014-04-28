//
//  GA_Workout.m
//  PearSportsTrainerApp
//
//  Created by Poojan Jhaveri on 3/8/14.
//  Copyright (c) 2014 Poojan Jhaveri. All rights reserved.
//

#import "GA_Workout.h"

@implementation GA_Workout

@synthesize workoutName;
@synthesize SKU;
@synthesize workoutType;
@synthesize date;
@synthesize wdate;
@synthesize duration;
@synthesize avgHeartRate;
@synthesize distance;
@synthesize calories;
@synthesize avgPace;
@synthesize status;
@synthesize grade;
@synthesize activityType;
@synthesize shortDes;
@synthesize longDes;
@synthesize wID;
@synthesize totalWeeks;
@synthesize perWeek;
@synthesize hrZones;
@synthesize hrZonesData;
@synthesize hrDataURL;

- (id)init
{
    self = [super init];
    if (self) {
      self.hrZones = [[NSMutableArray alloc] init];
      self.hrZonesData = [[NSMutableArray alloc] init];
      self.hrRawData = [[NSMutableArray alloc] init];
    }
    return self;
}


@end



