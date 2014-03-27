//
//  DM_ViewController.m
//  PearSportsTrainerApp
//
//  Created by Poojan Jhaveri on 2/20/14.
//  Copyright (c) 2014 Poojan Jhaveri. All rights reserved.
//

#import "DM_SinglePageView.h"
#import "PJ_InfoSubView.h"
#import "PJ_Client.h"

@interface DM_SinglePageView ()

@end

@implementation DM_SinglePageView

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        PJ_InfoSubView * isv = [[PJ_InfoSubView alloc] initWithFrame:CGRectMake(20.0f, 50.0f, 270.0f, 70.0f)];
        [self setView:isv];
    }
    return self;
}

- (id)initWithInfoSubviewType:(enum InfoSubViewType) aType client:(PJ_Client *)aClient
{
    self = [super initWithNibName:nil bundle:nil];
    if (self)
    {
        PJ_InfoSubView * isv = [[PJ_InfoSubView alloc] initWithFrame:CGRectMake(20.0f, 50.0f, 270.0f, 70.0f)];
        [self setView:isv];
        [isv setClient:aClient];
        [isv setSubViewType:aType];
        [isv updateHeaderLabelText];
        
    }
    return self;
}

- (id) initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        
        PJ_InfoSubView * isv = [[PJ_InfoSubView alloc] initWithFrame:CGRectMake(20.0f, 50.0f, 270.0f, 70.0f)];
        [self setView:isv];
    }
    return self;
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end