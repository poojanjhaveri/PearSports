//
//  GA_WorkoutListCell.m
//  PearSportsTrainerApp
//
//  Created by Poojan Jhaveri on 3/8/14.
//  Copyright (c) 2014 Poojan Jhaveri. All rights reserved.
//

#import "GA_WorkoutListCell.h"

@implementation GA_WorkoutListCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        
        
    }
    return self;
}

-(id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        // Do your custom initialization here
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
