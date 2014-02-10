//
//  PJ_ClientStore.h
//  PearSportsTrainerApp
//
//  Created by Devon on 2/9/14.
//  Copyright (c) 2014 Poojan Jhaveri. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PJ_ClientStore : NSObject


@property (nonatomic, strong) NSMutableArray * clients;


+ (id) sharedClientStore;


// Only for testing
- (void) addRandomClients;

@end
