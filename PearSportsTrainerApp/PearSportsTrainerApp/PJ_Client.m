//
//  PJ_Client.m
//  PearSportsTrainerApp
//
//  Created by Devon on 2/9/14.
//  Copyright (c) 2014 Poojan Jhaveri. All rights reserved.
//

#import "PJ_Client.h"

@implementation PJ_Client

@synthesize name, numNotifications, trainee_id,age=_age,height,weight,gender,dob,email,imageName,workoutArray;


-(void)setAge:(NSString *)age
{
    _age=age;
    NSLog(@"%@",age);
}

@end
