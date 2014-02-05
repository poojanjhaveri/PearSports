//
//  API.h
//  PearSportsTrainerApp
//
//  Created by Poojan Jhaveri on 1/19/14.
//  Copyright (c) 2014 Poojan Jhaveri. All rights reserved.
//


#import "AFNetworking.h"


typedef void (^JSONResponseBlock)(NSDictionary* json);
@interface API : AFHTTPRequestOperationManager

//the authorized user
@property (strong, nonatomic) NSDictionary* user;
+(API *)sharedInstance;

//check whether there's an authorized user
-(BOOL)isAuthorized;
//-(void)commandWithParams:(NSMutableDictionary*)params filepath:(NSString *)filepath filename:(NSString *)filename apiurl:(NSString *)apiurl onCompletion:(JSONResponseBlock)completionBlock;
-(void)saveCurrentUser:(NSDictionary*)user;
-(void)logout;
@end
