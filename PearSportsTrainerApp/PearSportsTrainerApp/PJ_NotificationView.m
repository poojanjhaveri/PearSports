//
//  PJ_NotificationView.m
//  PearSportsTrainerApp
//
//  Created by Devon on 2/9/14.
//  Copyright (c) 2014 Poojan Jhaveri. All rights reserved.
//

#import "PJ_NotificationView.h"

@implementation PJ_NotificationView


- (void) drawRect:(CGRect) rect {
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    // Draw white BG
    CGContextSetRGBFillColor(context, 255.0f/255.0f, 255.0/255.0f, 255.0/255.0f, 1.0f);
    CGContextFillRect(context, rect);
    
    // Draw number of notifications
    
    UIFont* font = [UIFont fontWithName:@"Arial" size:6];
    UIColor* textColor = [UIColor whiteColor];
    NSDictionary* stringAttrs = @{ NSFontAttributeName : font, NSForegroundColorAttributeName : textColor };
    
    NSAttributedString* attrStr = [[NSAttributedString alloc] initWithString:@"3" attributes:stringAttrs];
    
    [attrStr drawInRect:rect];
    
    //[attrStr drawAtPoint:CGPointMake(1.0f, 1.0f)];
    
    // Draw red circle
    CGContextSetFillColorWithColor(context, [UIColor redColor].CGColor);
    CGContextSetAlpha(context, 1.0);
    CGContextFillEllipseInRect(context, CGRectMake(0,0,self.frame.size.width,self.frame.size.height));
    CGContextSetStrokeColorWithColor(context, [UIColor redColor].CGColor);
    CGContextStrokeEllipseInRect(context, CGRectMake(0,0,self.frame.size.width,self.frame.size.height));
    
}

@end
