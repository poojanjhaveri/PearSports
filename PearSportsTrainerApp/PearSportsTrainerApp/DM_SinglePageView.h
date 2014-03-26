//
//  DM_ViewController.h
//  PearSportsTrainerApp
//
//  Created by Poojan Jhaveri on 2/20/14.
//  Copyright (c) 2014 Poojan Jhaveri. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PJ_InfoSubView.h"
@class PJ_Client;

@interface DM_SinglePageView : UIViewController


@property (assign, nonatomic) NSInteger index;

- (id)initWithInfoSubviewType:(enum InfoSubViewType) aType client:(PJ_Client *)aClient;


@end