//
//  PJ_ClientStore.m
//  PearSportsTrainerApp
//
//  Created by Devon on 2/9/14.
//  Copyright (c) 2014 Poojan Jhaveri. All rights reserved.
//

#import "PJ_ClientStore.h"
#import "PJ_Client.h"

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
    [client3 setNumNotifications:1];
    
    
    [[[PJ_ClientStore sharedClientStore] clients] addObject:client1];
    [[[PJ_ClientStore sharedClientStore] clients] addObject:client2];
    [[[PJ_ClientStore sharedClientStore] clients] addObject:client3];
    
    NSLog(@"Number of clients = %d", [[PJ_ClientStore sharedClientStore] clients].count);
    
}


@end
