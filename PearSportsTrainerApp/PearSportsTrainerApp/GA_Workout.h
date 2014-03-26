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
@property (nonatomic, copy) NSDate *date;
@property (nonatomic, copy) NSString *wdate;
@property (nonatomic, copy) NSString *duration;
@property (nonatomic, copy) NSString *avgHeartRate;
@property (nonatomic, copy) NSString *distance;
@property (nonatomic, copy) NSString *calories;
@property (nonatomic, copy) NSString *avgPace;
@property (nonatomic, copy) NSString *status;



@end
