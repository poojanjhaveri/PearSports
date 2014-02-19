//
//  PJ_ClientCell.m
//  PearSportsTrainerApp
//
//  Created by Devon on 2/17/14.
//  Copyright (c) 2014 Poojan Jhaveri. All rights reserved.
//

#import "PJ_ClientCell.h"
#import "PJ_InfoSubView.h"
#import "PJ_Client.h"
#import "PJ_NotificationView.h"

@implementation PJ_ClientCell
@synthesize client;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {

    }
    return self;
}

- (id) initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        
        NSLog(@"Got to this point");
                
        PJ_InfoSubView * isv = [[PJ_InfoSubView alloc] initWithFrame:CGRectMake(20.0f, 50.0f, 270.0f, 70.0f)];
        [self addSubview:isv];
        [self setInfoSubView:isv];
        [isv setCell:self];
        //[self.infoSubView setBackgroundColor:[UIColor redColor]];
        
        
        
    }
    return self;

}

- (void) loadClientData
{
    
    if ([self client] == nil) {
        
        return;
    }
    /* Name Label  = Tag 212 */
    
    UILabel *label;
    
    
    // Load dynamic content
    [self nameLabel].text = [self client].name;
    
    if ([self client].numNotifications > 0) {
    
        /* Notification Label  = Tag 213 */
    
        CGRect positionFrame = CGRectMake(247,20,20,20);
        PJ_NotificationView * noteView = [[PJ_NotificationView alloc] initWithFrame:positionFrame];
        [self.contentView addSubview:noteView];
        //[cell.contentView sendSubviewToBack:noteView];
    
        // Number of notifications label
    
        [self numNotificationsLabel].textColor = [UIColor whiteColor];
    
        // Load dynamic content
        [self numNotificationsLabel].text = [NSString stringWithFormat:@"%d", [self client].numNotifications];
        [self.contentView bringSubviewToFront:[self numNotificationsLabel]];
    } else {
        [self numNotificationsLabel].textColor = [UIColor whiteColor];
        [self numNotificationsLabel].text = @"";
        
    }
    
    
    
    
    
    
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
