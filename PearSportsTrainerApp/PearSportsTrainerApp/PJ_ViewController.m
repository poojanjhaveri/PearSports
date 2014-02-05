//
//  PJ_ViewController.m
//  PearSportsTrainerApp
//
//  Created by Poojan Jhaveri on 1/6/14.
//  Copyright (c) 2014 Poojan Jhaveri. All rights reserved.
//

#import "PJ_ViewController.h"
#import "PJ_LoginViewController.h"
#import "API.h"

@interface PJ_ViewController ()

@end

@implementation PJ_ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
   
	// Do any additional setup after loading the view, typically from a nib.
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:NO];
    NSLog(@"user is %@",[[NSUserDefaults standardUserDefaults] objectForKey:@"CurrentUser" ]);
    if ([[NSUserDefaults standardUserDefaults] objectForKey:@"CurrentUser" ]==NULL){
        
        [self performSegueWithIdentifier:@"NeedToLogin" sender:self];
    }
    else
    {
        [self performSegueWithIdentifier:@"AlreadyLoggedIn" sender:self];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
