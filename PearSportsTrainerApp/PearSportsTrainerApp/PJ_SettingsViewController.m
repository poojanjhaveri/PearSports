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
@property (weak, nonatomic) IBOutlet UISwitch *AcceptNewTrainees;

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
    
    [self getAvailabilityStatus];
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


-(void)getAvailabilityStatus
{
    NSString * token = [[[NSUserDefaults standardUserDefaults] objectForKey:@"CurrentUser" ] valueForKey:@"token"];
    NSString *tra_id = [NSString stringWithFormat:@"%@",[[API sharedInstance] getTraineeInfo].trainee_id];
    
    NSDictionary *parameters = [[NSDictionary alloc] initWithObjects:[NSArray arrayWithObjects:tra_id, nil] forKeys:[NSArray arrayWithObjects:@"trainee_id", nil]];
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    NSURLCredential *credential = [NSURLCredential credentialWithUser:token password:@"" persistence:NSURLCredentialPersistenceNone];
    [manager.requestSerializer setAuthorizationHeaderFieldWithUsername:token password:@""];
    
    
    NSString *urlstring = [NSString stringWithFormat:@"https://cs477-backend.herokuapp.com/trainer/status"];
    
    NSMutableURLRequest *reqst = [manager.requestSerializer requestWithMethod:@"GET" URLString:urlstring parameters:parameters error:nil];
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:reqst];
    [operation setCredential:credential];
    [operation setResponseSerializer:[AFJSONResponseSerializer alloc]];
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSLog(@"%@",responseObject);
        //    [self.AcceptNewTrainees setOn:!(self.AcceptNewTrainees.isOn) animated:YES];
        if([[[responseObject objectForKey:@"trainer"] objectForKey:@"status"] isEqualToString:@"available"])
        {
            [self.AcceptNewTrainees setOn:YES animated:YES];
        
        }
        else
        {
             [self.AcceptNewTrainees setOn:NO animated:YES];
            
        }

        
        
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        NSLog(@"Failure: %@", error);
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Unable to get Availability Request" message:@"Please check your internet connection." delegate:self cancelButtonTitle:@"Okay" otherButtonTitles:nil, nil];
        [alert show];
    }];
    
    [operation start];

}

- (IBAction)AcceptNewTraineeValueChanged:(id)sender {
    
    NSString *stringToSet = [[NSString alloc]init];
    if(self.AcceptNewTrainees.isOn)
    {
        stringToSet=@"available";
    }
    else
    {
        stringToSet=@"not_available";

    }
    
    
    NSString * token = [[[NSUserDefaults standardUserDefaults] objectForKey:@"CurrentUser" ] valueForKey:@"token"];
    NSString *tra_id = [NSString stringWithFormat:@"%@",[[API sharedInstance] getTraineeInfo].trainee_id];
    
    NSDictionary *parameters = [[NSDictionary alloc] initWithObjects:[NSArray arrayWithObjects:tra_id, nil] forKeys:[NSArray arrayWithObjects:@"trainee_id", nil]];
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    NSURLCredential *credential = [NSURLCredential credentialWithUser:token password:@"" persistence:NSURLCredentialPersistenceNone];
    [manager.requestSerializer setAuthorizationHeaderFieldWithUsername:token password:@""];
    
    

    
    NSString *urlstring = [NSString stringWithFormat:@"https://cs477-backend.herokuapp.com/trainer/status/%@",stringToSet];
    
    NSMutableURLRequest *reqst = [manager.requestSerializer requestWithMethod:@"POST" URLString:urlstring parameters:parameters error:nil];
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:reqst];
    [operation setCredential:credential];
    [operation setResponseSerializer:[AFJSONResponseSerializer alloc]];
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSLog(@"%@",responseObject);
    //    [self.AcceptNewTrainees setOn:!(self.AcceptNewTrainees.isOn) animated:YES];

        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {

        NSLog(@"Failure: %@", error);
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Unable to send request" message:@"Please check your internet connection." delegate:self cancelButtonTitle:@"Okay" otherButtonTitles:nil, nil];
        [alert show];
        [self.AcceptNewTrainees setOn:!(self.AcceptNewTrainees.isOn) animated:YES];
    }];
    
    [operation start];
    
}

@end
