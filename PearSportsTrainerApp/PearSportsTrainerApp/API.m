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
@property (strong, nonatomic) NSDictionary* user;
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
        sharedInstance = [[self alloc] initWithBaseURL:[NSURL URLWithString:kAPIHost]];
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
        user = nil;
        
    }
    
    return self;
}

/*
-(void)commandWithParams:(NSMutableDictionary*)params filepath:(NSString *)filepath filename:(NSString *)filename apiurl:(NSString *)apiurl onCompletion:(JSONResponseBlock)completionBlock
{

    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    NSDictionary *parameters = params;
    NSURL *filePath;
    if([filepath length]!=0)
    {
    filePath = [NSURL fileURLWithPath:filepath];
    }
    NSString *posturl=[NSString stringWithFormat:@"http://cs477-backend.herokuapp.com/%@",apiurl];
    
    [manager POST:posturl parameters:parameters constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        [formData appendPartWithFileURL:filePath name:filename error:nil];
    } success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"Success: %@", responseObject);
        completionBlock(responseObject);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
        completionBlock([NSDictionary dictionaryWithObject:[error localizedDescription] forKey:@"error"]);
    }];
}
*/


-(BOOL)isAuthorized
{
    return [[user objectForKey:@"IdUser"] intValue]>0;
}

-(void)saveCurrentUser:(NSDictionary*)currentuser
{
    self.user=currentuser;
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
