//
//  API.m
//  PearSportsTrainerApp
//
//  Created by Poojan Jhaveri on 1/19/14.
//  Copyright (c) 2014 Poojan Jhaveri. All rights reserved.
//

#import "API.h"
#import "AFNetworking.h"


//the web location of the service
#define kAPIHost @"http://localhost"
#define kAPIPath @"PearSports/"


@interface API ()
//the authorized user
@property (strong, nonatomic) NSMutableDictionary* user;
@property (strong, nonatomic) PJ_Client* currenttrainee;
@end

@implementation API
@synthesize user;


#pragma mark - Singleton methods
/**
 * Singleton methods
 */

+(API*)sharedInstance
{
    static API *sharedInstance = nil;
    static dispatch_once_t oncePredicate;
    dispatch_once(&oncePredicate, ^{
        sharedInstance = [[self alloc] init];
    });
    
    return sharedInstance;
}


#pragma mark - init
//intialize the API class with the destination host name

-(API*)init
{
    //call super init
    self = [super init];
    
    if (self != nil) {
        //initialize the object
        user = [[NSMutableDictionary alloc] initWithObjectsAndKeys:nil, nil];
        
    }
    
    return self;
}




-(BOOL)isAuthorized
{
    return [[user objectForKey:@"IdUser"] intValue]>0;
}

-(void)saveCurrentUser:(NSMutableDictionary*)currentuser
{
   
    self.user=[NSMutableDictionary dictionaryWithDictionary:currentuser];
 // So that if a new user signs up and we dont have data from pear trainee, then we give him a default name so as to atleast login and show it in UI
    if([currentuser objectForKey:@"first_name"])
    {
        
              [self.user setObject:@"" forKey:@"first_name"];
    }
    
    if([currentuser objectForKey:@"last_name"])
    {
         [self.user setObject:@"" forKey:@"last_name"];
    }
    
    
    [[NSUserDefaults standardUserDefaults] setObject:self.user forKey:@"CurrentUser" ];
}

-(void)saveTrainee:(PJ_Client*)trainee
{
    self.currenttrainee=trainee;
}


-(PJ_Client *)getTraineeInfo
{
    return self.currenttrainee;
}

-(void)logout
{
    self.user=NULL;
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"CurrentUser"];
}

@end
