//
//  PJ_InfoSubView.m
//  PearSportsTrainerApp
//
//  Created by Devon on 2/18/14.
//  Copyright (c) 2014 Poojan Jhaveri. All rights reserved.
//

#import "PJ_InfoSubView.h"

static float sq_start = 5;
static float sq_width = 20;
static float sq_height = 20;
static float sq_buffer = 20;

@implementation PJ_InfoSubView

@synthesize headerLabel, subViewType, workoutArray;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        // My bounding box :
        // Width : 270px
        // Height : 70px
        [self configureAndAddLabels];
        //[self configureAndAddRects];
        
        
    }
    return self;
}

- (void) updateHeaderLabelText
{
    if ([self subViewType] == SubViewThisWeek) {
        
        [self.headerLabel setText:@"This Week"];
        [self setWorkoutArray:[[NSArray alloc] initWithObjects:@"complete", @"missed", @"complete", @"unscheduled", @"unscheduled", @"scheduled", @"unscheduled", nil]];
        
    } else if ([self subViewType] == SubViewLastWeek) {
        
        [self.headerLabel setText:@"Last Week"];
        [self setWorkoutArray:[[NSArray alloc] initWithObjects:@"complete", @"complete", @"complete", @"unscheduled", @"unscheduled", @"missed", @"unscheduled", nil]];
        
        
    } else {
        
        [self.headerLabel setText:@"Two Weeks Ago"];
        [self setWorkoutArray:[[NSArray alloc] initWithObjects:@"missed", @"complete", @"complete", @"unscheduled", @"unscheduled", @"complete", @"unscheduled", nil]];

        
    }

}

- (void) configureAndAddLabels
{
    UILabel *hLabel = [[UILabel alloc] initWithFrame:CGRectMake(2, 2, 266, 14)];
    [hLabel setFont:[UIFont fontWithName:@"Helvetica Neue" size:12]];
    [hLabel setTextAlignment:NSTextAlignmentCenter];
    
    
    for (int i = 0; i < 7; i++) {
        
        float left = sq_start + (i * (sq_width + sq_buffer));
        
        UILabel *aLabel = [[UILabel alloc] initWithFrame:CGRectMake(left, 20, sq_width, sq_height)];
        [aLabel setFont:[UIFont fontWithName:@"Helvetica Neue" size:9]];
        [aLabel setTextAlignment:NSTextAlignmentCenter];
        if (i == 0) {
            
            aLabel.text = @"Sat";
            
        } else if (i == 6) {
            
            aLabel.text = @"Sun";
            
        } else if (i == 2) {
            
            aLabel.text = @"Tue";
            
        } else if (i == 4) {
            
            aLabel.text = @"Thu";
            
        } else if (i == 1) {
            
            aLabel.text = @"Mon";
            
        } else if (i == 3) {
            
            aLabel.text = @"Wed";
            
        } else {
            
            aLabel.text = @"Fri";
            
        }
        [self addSubview:aLabel];

        
    }
    
    
    [self setHeaderLabel:hLabel];
    
    [self addSubview:hLabel];

     
    
    
}

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    
    
    // Drawing code
    [super drawRect:rect];
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetRGBFillColor(context, 1.0, 1.0, 1.0, 1.0);
    CGContextFillRect(context, rect);
    
    for (int i = 0; i < 7; i++) {
        
        float left = sq_start + (i * (sq_width + sq_buffer));
        
        CGRect rectangle = CGRectMake(left, 40, sq_width, sq_height);
        if ([self workoutArray] != nil){
            if ([[self.workoutArray objectAtIndex:i]  isEqual: @"scheduled"] ) {
                
                CGContextSetRGBFillColor(context, 0.0, 0.0, 0.0, 0.0);
                
                CGPathRef path = CGPathCreateWithRect(rectangle, NULL);

                CGContextSetRGBStrokeColor(context, 0.0, 0.0, 0.0, 0.5);
                
                CGContextAddPath(context, path);
                CGContextDrawPath(context, kCGPathFillStroke);

                
            } else if ( [[self.workoutArray objectAtIndex:i]  isEqual: @"missed"] ) {
                
                CGContextSetRGBFillColor(context, 1.0, 0.0, 0.0, 1.0);
            } else if ( [[self.workoutArray objectAtIndex:i]  isEqual: @"complete"] ) {
                
                CGContextSetRGBFillColor(context, 0.0, 1.0, 0.0, 1.0);
                
            } else {
                
                CGContextSetRGBFillColor(context, 0.0, 0.0, 0.0, 0.0);
            }
        } else {
            CGContextSetRGBFillColor(context, 0.0, 0.0, 0.0, 0.0);

        }

        CGContextFillRect(context, rectangle);
        
    }
    
}


@end
