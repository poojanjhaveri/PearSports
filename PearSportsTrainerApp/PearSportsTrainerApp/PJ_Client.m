//
//  PJ_Client.m
//  PearSportsTrainerApp
//
//  Created by Devon on 2/9/14.
//  Copyright (c) 2014 Poojan Jhaveri. All rights reserved.
//

#import "PJ_Client.h"

@implementation PJ_Client

@synthesize name, numNotifications, trainee_id,age=_age,height,weight=_weight,gender=_gender,dob=_dob,email,imageName,workoutArray, lastWorkout=_lastWorkout, notes=_notes;


-(void)setAge:(NSString *)age
{
    _age=age;
}

-(void)setDob:(NSString *)dob
{
    _dob = dob;
}

-(void)setWeight:(NSString *)weight
{
    _weight = weight;
}

-(void)setGender:(NSString *)gender
{
    _gender = gender;
}

-(void)setLastWorkout:(NSString *)lastWorkout
{
  _lastWorkout = lastWorkout;
}

-(void)setNotes:(NSString *)notes
{
  _notes = notes;
}
@end