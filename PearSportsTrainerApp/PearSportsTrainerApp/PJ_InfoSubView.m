//
//  PJ_InfoSubView.m
//  PearSportsTrainerApp
//
//  Created by Devon on 2/18/14.
//  Copyright (c) 2014 Poojan Jhaveri. All rights reserved.
//

#import "PJ_InfoSubView.h"

@implementation PJ_InfoSubView

@synthesize headerLabel, leftSectionSubdataLabel, rightSectionSubdataLabel, leftSectionDataLabel, rightSectionDataLabel, subViewType;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        // My bounding box :
        // Width : 270px
        // Height : 70px
        [self configureAndAddLabels];
        
        
    }
    return self;
}

- (void) updateLabels
{
    
    if (self.subViewType == SubViewWorkoutTimes) {
        [self headerLabel].text = @"Workout Time";
        [[self headerLabel] setTextColor:[UIColor blueColor]];
        [self leftSectionDataLabel].text = @"10:39";
        [[self leftSectionDataLabel] setTextColor:[UIColor greenColor]];
        [self rightSectionDataLabel].text = @"08:29";
        [self leftSectionSubdataLabel].text = @"this week";
        [self rightSectionSubdataLabel].text = @"last week";
    } else {
        [self headerLabel].text = @"Miles Ran";
        [[self headerLabel] setTextColor:[UIColor blueColor]];
        [self leftSectionDataLabel].text = @"4.39";
        [[self leftSectionDataLabel] setTextColor:[UIColor redColor]];
        [self rightSectionDataLabel].text = @"6.45";
        [self leftSectionSubdataLabel].text = @"this week";
        [self rightSectionSubdataLabel].text = @"last week";
    }
    
    
    
}


- (void) configureAndAddLabels
{
    UILabel *hLabel = [[UILabel alloc] initWithFrame:CGRectMake(2, 2, 266, 12)];
    [hLabel setFont:[UIFont fontWithName:@"Helvetica Neue" size:12]];
    [hLabel setTextAlignment:NSTextAlignmentCenter];
    
    UILabel *lsdLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 17, 115, 21)];
    [lsdLabel setFont:[UIFont fontWithName:@"Helvetica Neue" size:21]];
    [lsdLabel setTextAlignment:NSTextAlignmentCenter];
    
    UILabel *rsdLabel = [[UILabel alloc] initWithFrame:CGRectMake(145, 17, 115, 21)];
    [rsdLabel setFont:[UIFont fontWithName:@"Helvetica Neue" size:21]];
    [rsdLabel setTextAlignment:NSTextAlignmentCenter];
    
    UILabel *lssLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 41, 115, 12)];
    [lssLabel setFont:[UIFont fontWithName:@"Helvetica Neue" size:12]];
    [lssLabel setTextAlignment:NSTextAlignmentCenter];
    [lssLabel setTextColor:[UIColor lightGrayColor]];
    
    UILabel *rssLabel = [[UILabel alloc] initWithFrame:CGRectMake(145, 41, 115, 12)];
    [rssLabel setFont:[UIFont fontWithName:@"Helvetica Neue" size:12]];
    [rssLabel setTextAlignment:NSTextAlignmentCenter];
    [rssLabel setTextColor:[UIColor lightGrayColor]];
    
    [self setHeaderLabel:hLabel];
    [self setLeftSectionDataLabel:lsdLabel];
    [self setRightSectionDataLabel:rsdLabel];
    [self setLeftSectionSubdataLabel:lssLabel];
    [self setRightSectionSubdataLabel:rssLabel];
    
    [self addSubview:hLabel];
    [self addSubview:lsdLabel];
    [self addSubview:rsdLabel];
    [self addSubview:lssLabel];
    [self addSubview:rssLabel];
    
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
