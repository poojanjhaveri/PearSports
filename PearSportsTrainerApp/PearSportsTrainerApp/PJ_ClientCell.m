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
#import "DM_SinglePageView.h"
#import <NZCircularImageView.h>

@implementation PJ_ClientCell
@synthesize client, viewControllers;

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
        
        [self setViewControllers:[[NSMutableArray alloc] init]];
        [self initiatePageViewController];

        
    }
    return self;

}

- (void) initiatePageViewController
{
    
    self.pageViewController = [[UIPageViewController alloc] initWithTransitionStyle:UIPageViewControllerTransitionStyleScroll navigationOrientation:UIPageViewControllerNavigationOrientationHorizontal options:nil];
    self.pageViewController.dataSource = self;
    [[self.pageViewController view] setFrame:CGRectMake(20, 50, 270, 100)];
    
    [self.pageViewController setDelegate:self];

    [self.contentView addSubview:self.pageViewController.view];

    
}

- (void) loadClientData
{
    [self initializeInfoSubviews];
    
    
    if ([self client] == nil) {
        
        return;
    }

    // NAME LABEL
    
    //[self nameLabel].text = [self client].name;
    
    // For testing
    [self nameLabel].text = self.client.name;
//    self.clientImage.image=[UIImage imageNamed:self.client.imageName];
    [self.clientImage setImageWithURL:[NSURL URLWithString:self.client.imageName]];
       
    // NOTIFICATION LABEL
    
    if ([self client].numNotifications > 0) {
    
    
        CGRect positionFrame = CGRectMake(247, 10,20,20);
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

- (void) initializeInfoSubviews
{
    
    if ([self viewControllers].count == 0) {
    
        DM_SinglePageView *first = [[DM_SinglePageView alloc] initWithInfoSubviewType:SubViewThisWeek client:[self client]];
        DM_SinglePageView *second = [[DM_SinglePageView alloc] initWithInfoSubviewType:SubViewLastWeek client:[self client]];
        DM_SinglePageView *third = [[DM_SinglePageView alloc]
                                    initWithInfoSubviewType:SubViewThirdWeek client:[self client] ];
        
    
        first.index=0;
        second.index=1;
        third.index=2;
    
        [self.viewControllers addObject:first];
        [self.viewControllers addObject:second];
        [self.viewControllers addObject:third];
    
    
        NSArray *viewControllerForDisplay = [NSArray arrayWithObject:first];
    
        [self.pageViewController setViewControllers:viewControllerForDisplay direction:UIPageViewControllerNavigationDirectionForward animated:NO completion:nil];
    }

    
}


- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerBeforeViewController:(UIViewController *)viewController {
    
    NSUInteger index = [(DM_SinglePageView *)viewController index];
    if (index == 0) {
        return nil;
    }
    
    return [self viewControllerAtIndex:(index-1)];
}


- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerAfterViewController:(UIViewController *)viewController {
    
    NSUInteger index = [(DM_SinglePageView *)viewController index];
    
    if (index == [self viewControllers].count - 1) {
        return nil;
    }
    return [self viewControllerAtIndex:(index+1)];
}


- (UIViewController *)viewControllerAtIndex:(NSUInteger)index {
    
    DM_SinglePageView *page;
    page = [[self viewControllers] objectAtIndex:index];
    return page;
    
}

- (NSInteger)presentationCountForPageViewController:(UIPageViewController *)pageViewController {
    // The number of items reflected in the page indicator.
    return [self.viewControllers count];
}



- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}




- (NSInteger)presentationIndexForPageViewController:(UIPageViewController *)pageViewController {
    // The selected item reflected in the page indicator.
    return 0;
}

@end
