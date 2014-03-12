//
//  PJ_ClientListViewController.h
//  PearSportsTrainerApp
//
//  Created by Poojan Jhaveri on 2/4/14.
//  Copyright (c) 2014 Poojan Jhaveri. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PJ_ClientListViewController : UITableViewController

- (void) refreshView;

@property (weak, nonatomic) IBOutlet UIRefreshControl *refreshController;

@property (strong) UIActivityIndicatorView * activityIndicator;

@end
