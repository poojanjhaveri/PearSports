//
//  PJ_SettingsViewController.m
//  PearSportsTrainerApp
//
//  Created by Poojan Jhaveri on 2/2/14.
//  Copyright (c) 2014 Poojan Jhaveri. All rights reserved.
//

#import "PJ_SettingsViewController.h"
#import "API.h"

@interface PJ_SettingsViewController ()

@end

@implementation PJ_SettingsViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
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

- (IBAction)logoutButtonTouched:(id)sender {
    
    [[API sharedInstance] logout];
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
