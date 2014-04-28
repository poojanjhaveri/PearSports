//
//  GA_Workout.h
//  PearSportsTrainerApp
//
//  Created by Poojan Jhaveri on 3/8/14.
//  Copyright (c) 2014 Poojan Jhaveri. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GA_Workout : NSObject

@property (nonatomic, copy) NSString *workoutName;
@property (nonatomic, copy) NSString *SKU;
@property (nonatomic, copy) NSString *workoutType;
@property (nonatomic, copy) NSDate *date;
@property (nonatomic, copy) NSString *wdate;
@property (nonatomic, copy) NSString *duration;
@property (nonatomic, copy) NSString *avgHeartRate;
@property (nonatomic, copy) NSString *distance;
@property (nonatomic, copy) NSString *calories;
@property (nonatomic, copy) NSString *avgPace;
@property (nonatomic, copy) NSString *status;
@property (nonatomic, copy) NSString *grade;
@property (nonatomic, copy) NSString *activityType;
@property (nonatomic, copy) NSString *shortDes;
@property (nonatomic, copy) NSString *longDes;
@property (nonatomic, copy) NSString *wID;
@property (nonatomic, copy) NSString *totalWeeks;
@property (nonatomic, copy) NSString *perWeek;
@property (nonatomic, copy) NSString *hrDataURL;
@property (nonatomic, copy) NSMutableArray *hrZones;
@property (nonatomic, copy) NSMutableArray *hrZonesData;
@property (nonatomic, copy) NSMutableArray *hrRawData;

@end
