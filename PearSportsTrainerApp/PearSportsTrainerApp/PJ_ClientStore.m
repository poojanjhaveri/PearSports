//
//  PJ_ClientStore.m
//  PearSportsTrainerApp
//
//  Created by Devon on 2/9/14.
//  Copyright (c) 2014 Poojan Jhaveri. All rights reserved.
//

#import "PJ_ClientStore.h"
#import "PJ_Client.h"
#import "API.h"

@implementation PJ_ClientStore

@synthesize clients;


- (id) init {
    
    if (self = [super init]) {
     
        clients = [[NSMutableArray alloc] init];
        
    }
    
    return self;
    
}

+ (id) sharedClientStore
{
    
    static PJ_ClientStore * sharedMyClientStore = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedMyClientStore = [[self alloc] init];
    });
    return sharedMyClientStore;
    
    
}

- (void) addRandomClients
{
    PJ_Client * client1 = [[PJ_Client alloc] init];
    [client1 setName:@"John Doe"];
    [client1 setNumNotifications:2];
    
    PJ_Client * client2 = [[PJ_Client alloc] init];
    [client2 setName:@"Jane Fonda"];
    [client2 setNumNotifications:5];
    
    PJ_Client * client3 = [[PJ_Client alloc] init];
    [client3 setName:@"Devon Meyer"];
    [client3 setNumNotifications:0];
    
    
    [[[PJ_ClientStore sharedClientStore] clients] addObject:client1];
    [[[PJ_ClientStore sharedClientStore] clients] addObject:client2];
    [[[PJ_ClientStore sharedClientStore] clients] addObject:client3];
    
    NSLog(@"Number of clients = %ld", [[PJ_ClientStore sharedClientStore] clients].count);
    
}

- (void) updateData
{
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    
    
    NSString * token = [[[NSUserDefaults standardUserDefaults] objectForKey:@"CurrentUser" ] valueForKey:@"token"];
    
    [manager.requestSerializer setAuthorizationHeaderFieldWithUsername:token password:@""];
    
    [manager GET:@"https://cs477-backend.herokuapp.com/trainee_list" parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject)
     {
         
         [self.clients removeAllObjects];
         //NSLog(@"%@", responseObject);
         
         NSMutableArray * traineeList = [NSMutableArray arrayWithArray:responseObject[@"trainee_list"]];
         
         NSLog(@"Trainee List : %@", traineeList);
         
         for (NSString * trainee_id in traineeList) {
             PJ_Client * theTrainee = [[PJ_Client alloc] init];
             [theTrainee setName:@""];
             [theTrainee setTrainee_id:trainee_id];
             
             [self.clients addObject:theTrainee];
         }
         
         /*for (NSString * trainee_id in traineeList) {
             [self updateClientDataForTraineeWithId:trainee_id];
         }*/
         
         
         
         
         
         
     } failure:^(AFHTTPRequestOperation *operation, NSError *error)
     
     {
         
         
         NSLog(@"Error: %@", error);
         
         
     }];

    
}

- (void) updateDataAndPerformSelector:(SEL)aSelector withTarget:(id)aTarget
{
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    
    
    NSString * token = [[[NSUserDefaults standardUserDefaults] objectForKey:@"CurrentUser" ] valueForKey:@"token"];
    
    [manager.requestSerializer setAuthorizationHeaderFieldWithUsername:token password:@""];
    
    [manager GET:@"https://cs477-backend.herokuapp.com/trainee_list" parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject)
     {
        [self.clients removeAllObjects];
         
         
         [[responseObject objectForKey:@"trainee_list"] enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
             
             PJ_Client * theTrainee = [[PJ_Client alloc] init];
             [theTrainee setName:[obj objectForKey:@"screen_name"]];
             [theTrainee setTrainee_id:key];
             [theTrainee setAge:[obj objectForKey:@"age"]];
             [theTrainee setDob:[obj objectForKey:@"dob"]];
             [theTrainee setEmail:[obj objectForKey:@"email"]];
             [theTrainee setGender:[obj objectForKey:@"gender"]];
             [theTrainee setHeight:[obj objectForKey:@"height"]];
             [theTrainee setWeight:[obj objectForKey:@"weight"]];

             [self.clients addObject:theTrainee];
             
             NSLog(@"%@ %@",obj,key);
         }];
         
         

         
      /*
         [products enumerateObjectsUsingBlock:^(id obj,NSUInteger idx, BOOL *stop){
             NSLog(@"%@",obj);
             
             PJ_Client * theTrainee = [[PJ_Client alloc] init];
             [theTrainee setName:@""];
             [theTrainee setTrainee_id:obj];
             [self.clients addObject:theTrainee];
         }];
         */
         
         /*
         NSMutableArray * traineeList = responseObject[@"trainee_list"];
         
         NSLog(@"Trainee List : %@", traineeList);
         
         for (NSString * trainee_id in traineeList) {
             PJ_Client * theTrainee = [[PJ_Client alloc] init];
             [theTrainee setName:@""];
             [theTrainee setTrainee_id:trainee_id];
             [self.clients addObject:theTrainee];
         }
         */
         /*for (NSString * trainee_id in traineeList) {
          [self updateClientDataForTraineeWithId:trainee_id];
          }*/
         
         [aTarget performSelector:aSelector];

         
         
         
         
         
         
     } failure:^(AFHTTPRequestOperation *operation, NSError *error)
     
     {
         
         
         NSLog(@"Error: %@", error);
         
         
     }];
    
}


/*- (void) updateClientDataForTraineeWithId:(NSString *)someId
{
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    
    
    NSString * token = [[[NSUserDefaults standardUserDefaults] objectForKey:@"CurrentUser" ] valueForKey:@"token"];
    
    [manager.requestSerializer setAuthorizationHeaderFieldWithUsername:token password:@""];
    
    NSMutableDictionary * params = [[NSMutableDictionary alloc] init];
    
    
    [params setObject:someId forKey:@"trainee_id"];
    [params setObject:@"False" forKey:@"all"];
    
    [manager GET:@"https://cs477-backend.herokuapp.com/trainee/stats" parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject)
     {
         
         
         NSLog(@"%@", responseObject);
         
         
         
         
         
     } failure:^(AFHTTPRequestOperation *operation, NSError *error)
     
     {
         
         
         NSLog(@"Error: %@", error);
         
         
     }];
    
}*/



@end
