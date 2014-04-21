//
//  PJ_ClientStore.h
//  PearSportsTrainerApp
//
//  Created by Devon on 2/9/14.
//  Copyright (c) 2014 Poojan Jhaveri. All rights reserved.
//

#import <Foundation/Foundation.h>

enum WORKOUTS {
    
    INCOMPLETE = 0,
    COMPLETE = 1,
    FUTURE = 2
    
};

@interface PJ_ClientStore : NSObject


@property (nonatomic, strong) NSMutableArray * clients;


+ (id) sharedClientStore;


- (void) updateData;
- (void) updateDataAndPerformSelector:(SEL)aSelector withTarget:(id)aTarget onError:(SEL)errorSelector;

// Only for testing
- (void) addRandomClients;

@end