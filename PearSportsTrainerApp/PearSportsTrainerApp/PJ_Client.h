//
//  PJ_Client.h
//  PearSportsTrainerApp
//
//  Created by Devon on 2/9/14.
//  Copyright (c) 2014 Poojan Jhaveri. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PJ_Client : NSObject


@property (copy) NSString * name;
@property (copy) NSString * trainee_id;
@property int numNotifications;
@property  (strong,nonatomic) NSString *  age;
@property (copy) NSString * dob;
@property (copy) NSString * email;
@property (copy) NSString * gender;
@property  NSString *  height;
@property  NSString * weight;
@property  NSString * imageName;

@property (nonatomic, strong) NSMutableArray * workoutArray;



@end
