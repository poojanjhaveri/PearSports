//
//  PJ_InfoSubView.h
//  PearSportsTrainerApp
//
//  Created by Devon on 2/18/14.
//  Copyright (c) 2014 Poojan Jhaveri. All rights reserved.
//



#import <UIKit/UIKit.h>
@class PJ_ClientCell, PJ_Client;

enum InfoSubViewType{
    SubViewThisWeek,
    SubViewLastWeek,
    SubViewThirdWeek
};


@interface PJ_InfoSubView : UIView

@property (strong, nonatomic) UILabel * headerLabel;

@property (nonatomic) enum InfoSubViewType subViewType;

@property (nonatomic, strong) NSArray * workoutArray;

@property (nonatomic, weak) PJ_Client * client;

- (void) updateHeaderLabelText;

@end