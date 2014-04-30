//
//  GA_PlanViewController.m
//  PearSportsTrainerApp
//
//  Created by Garima Aggarwal on 4/15/14.
//  Copyright (c) 2014 Poojan Jhaveri. All rights reserved.
//

#import "GA_PersonalizePlan.h"
#import "API.h"

@interface GA_PersonalizePlan ()



@end

@implementation GA_PersonalizePlan

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.switches = [[NSMutableArray alloc] init];
    [self.switches addObject:self.switch0];
    [self.switches addObject:self.switch1];
    [self.switches addObject:self.switch2];
    [self.switches addObject:self.switch3];
    [self.switches addObject:self.switch4];
    [self.switches addObject:self.switch5];
    [self.switches addObject:self.switch6];
    
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"MM-dd-YYYY"];// you can use your format
    
    
    [self.workoutNameLabel setText:[NSString stringWithFormat:@"%@", _wName]];
    [self.dateLabel setText:[NSString stringWithFormat:@"%@",[dateFormat stringFromDate:_wDate]]];
    
    [self.scheduleBtn addTarget:self action:@selector(buttonClicked: ) forControlEvents:UIControlEventTouchUpInside];

}

- (IBAction) buttonClicked: (id)sender
{
    NSLog(@"Tap");
    
    [self sendWorkOutRequest];
    [self.navigationController popToRootViewControllerAnimated:YES];
    
//    UIViewController *prevVC = [self.navigationController.viewControllers objectAtIndex:1];
//    [self.navigationController popToViewController:prevVC animated:YES];

}

//sends the plan to backend to be added to the trainee
-(void)sendWorkOutRequest
{
    

    
    NSTimeInterval ti = [_wDate timeIntervalSince1970];
    
    
    NSString * token = [[[NSUserDefaults standardUserDefaults] objectForKey:@"CurrentUser" ] valueForKey:@"token"];
    NSString *tra_id = [NSString stringWithFormat:@"%@",[[API sharedInstance] getTraineeInfo].trainee_id];

    NSString *result = @"[";
    for(int i=0; i<7; i++){
        UISwitch *s = [self.switches objectAtIndex:i];
        if(s.on){
            NSLog(@"%d is on",i);
            result = [result stringByAppendingString:[NSString stringWithFormat:@"%i,",i]];
        }
    }
    result = [result substringToIndex:(result.length - 1)];
    result = [result stringByAppendingString:[NSString stringWithFormat:@"]"]];

    
    NSString *time_st = [NSString stringWithFormat:@"%f", ti];
    NSLog(@"workout date: %@", time_st);
    NSDictionary *parameters = [[NSDictionary alloc] initWithObjects:[NSArray arrayWithObjects:tra_id, result, time_st, nil] forKeys:[NSArray arrayWithObjects:@"trainee_id", @"weekdays", @"start", nil]];
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    NSURLCredential *credential = [NSURLCredential credentialWithUser:token password:@"" persistence:NSURLCredentialPersistenceNone];
    [manager.requestSerializer setAuthorizationHeaderFieldWithUsername:token password:@""];
    
    NSString *urlstring = [NSString stringWithFormat:@"https://cs477-backend.herokuapp.com/plan/%@",self.wSKU];
    
    NSMutableURLRequest *reqst = [manager.requestSerializer requestWithMethod:@"POST" URLString:urlstring parameters:parameters error:nil];
    
    //    NSMutableURLRequest *reqst = [manager.requestSerializer requestWithMethod:@"POST" URLString:@"https://cs477-backend.herokuapp.com/workout/@%a",  parameters:parameters error:nil];
    
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:reqst];
    [operation setCredential:credential];
    [operation setResponseSerializer:[AFJSONResponseSerializer alloc]];
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"Success: %@", responseObject);
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Failure: %@", error);
        
        [self showLoadingError];
    }];
    
    [manager.operationQueue addOperation:operation];
}

-(void) showLoadingError
{
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"There was an error retrieving the data." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [alert setTag:12];
    [alert show];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
