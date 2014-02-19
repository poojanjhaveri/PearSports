//
//  PJ_InfoSubView.h
//  PearSportsTrainerApp
//
//  Created by Devon on 2/18/14.
//  Copyright (c) 2014 Poojan Jhaveri. All rights reserved.
//



#import <UIKit/UIKit.h>
@class PJ_ClientCell;

enum InfoSubViewStatus{
    SubViewWorkoutTimes = 0,
    SubViewMilesRan = 1
    
};


@interface PJ_InfoSubView : UIView

@property (weak, nonatomic) PJ_ClientCell * cell;

@property (strong, nonatomic) UILabel * headerLabel;

@property (strong, nonatomic) UILabel * leftSectionDataLabel;
@property (strong, nonatomic) UILabel * rightSectionDataLabel;

@property (strong, nonatomic) UILabel * leftSectionSubdataLabel;
@property (strong, nonatomic) UILabel * rightSectionSubdataLabel;

@property (nonatomic) enum InfoSubViewStatus subViewStatus;


@end
