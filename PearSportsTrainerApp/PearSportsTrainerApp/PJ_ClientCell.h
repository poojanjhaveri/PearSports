//
//  PJ_ClientCell.h
//  PearSportsTrainerApp
//
//  Created by Devon on 2/17/14.
//  Copyright (c) 2014 Poojan Jhaveri. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <NZCircularImageView.h>

@class PJ_InfoSubView, PJ_Client;

@interface PJ_ClientCell : UITableViewCell<UIPageViewControllerDataSource,UIPageViewControllerDelegate>

@property (nonatomic, strong) PJ_InfoSubView * infoSubView;
@property (nonatomic, weak) PJ_Client * client;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *numNotificationsLabel;
@property(strong,nonatomic) UIPageViewController *pageViewController;
@property (strong, nonatomic) NSMutableArray * viewControllers;
@property (weak, nonatomic) IBOutlet NZCircularImageView *clientImage;

- (void) loadClientData;

@end
