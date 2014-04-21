//
//  API.h
//  PearSportsTrainerApp
//
//  Created by Poojan Jhaveri on 1/19/14.
//  Copyright (c) 2014 Poojan Jhaveri. All rights reserved.
//


#import "AFNetworking.h"
#import "PJ_Client.h"


typedef void (^JSONResponseBlock)(NSDictionary* json);
@interface API : AFHTTPRequestOperationManager


+(API *)sharedInstance;

//check whether there's an authorized user
-(BOOL)isAuthorized;
//-(void)commandWithParams:(NSMutableDictionary*)params filepath:(NSString *)filepath filename:(NSString *)filename apiurl:(NSString *)apiurl onCompletion:(JSONResponseBlock)completionBlock;
-(void)saveCurrentUser:(NSMutableDictionary*)user;


// TO save current trainee
-(void)saveTrainee:(PJ_Client *)trainee;
-(PJ_Client *)getTraineeInfo;

-(void)logout;
@end
