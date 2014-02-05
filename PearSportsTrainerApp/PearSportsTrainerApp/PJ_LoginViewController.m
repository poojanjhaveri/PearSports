//
//  PJ_LoginViewController.m
//  PearSportsTrainerApp
//
//  Created by Poojan Jhaveri on 1/16/14.
//  Copyright (c) 2014 Poojan Jhaveri. All rights reserved.
//

#import "PJ_LoginViewController.h"
#import "API.h"

@interface PJ_LoginViewController ()
@property (weak, nonatomic) IBOutlet UITextField *emailAddress;
@property (weak, nonatomic) IBOutlet UITextField *password;

@end

@implementation PJ_LoginViewController

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

- (IBAction)loginButtonPressed:(id)sender {
    
     AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
   //     manager.responseSerializer = [AFJSONResponseSerializer serializer];
        manager.requestSerializer = [AFJSONRequestSerializer serializer];
    
    NSLog(@"%@ %@",self.emailAddress.text,self.password.text);
//    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    [manager.requestSerializer setAuthorizationHeaderFieldWithUsername:self.emailAddress.text password:self.password.text];
     
     [manager POST:@"https://cs477-backend.herokuapp.com/sign-in" parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject)
    {
         
        NSLog(@"JSON: %@", responseObject);
        [[API sharedInstance] saveCurrentUser:[responseObject objectForKey:@"trainer_info"]];
        self.emailAddress.text=@"";
        self.password.text=@"";
        [self performSegueWithIdentifier:@"LoggedIn" sender:self];
     
     } failure:^(AFHTTPRequestOperation *operation, NSError *error)
    
    {
         
        NSLog(@"Error: %@", error);
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Authentication Error" message:@"Please check your username and password." delegate:self cancelButtonTitle:@"Okay" otherButtonTitles:nil, nil];
        [alert show];
        
     }];
     

}

- (IBAction)forgotPasswordTouched:(id)sender {
    UIAlertView *forgotalert = [[UIAlertView alloc] initWithTitle:@"Forgot Password" message:@"Please enter your emaill address" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Send", nil];
    forgotalert.alertViewStyle=UIAlertViewStylePlainTextInput;
    [forgotalert show];
}


- (BOOL)alertViewShouldEnableFirstOtherButton:(UIAlertView *)alertView
{
    
    if(alertView.alertViewStyle == UIAlertViewStylePlainTextInput)
    {
    UITextField *textField = [alertView textFieldAtIndex:0];
    if ([textField.text length] == 0)
    {
        return NO;
    }
    }
    return YES;
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(buttonIndex==1)
    {
        NSString *getstring = [NSString stringWithFormat:@"https://cs477-backend.herokuapp.com/password/reset/%@",[alertView textFieldAtIndex:0].text];
        
        AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
        manager.responseSerializer = [AFJSONResponseSerializer serializer];
        manager.requestSerializer = [AFJSONRequestSerializer serializer];
        
  //       manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
        [manager GET:getstring parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
            NSLog(@"JSON: %@", responseObject);
            if(!([[responseObject objectForKey:@"type"] isEqualToString:@"message"]))
            {
                UIAlertView *resetpassword =[[UIAlertView alloc] initWithTitle:@"Reset password" message:@"Please verify the email address you entered. " delegate:self cancelButtonTitle:@"Okay" otherButtonTitles:nil, nil];
                [resetpassword show];
            }
            else
            {
            
            UIAlertView *resetpassword =[[UIAlertView alloc] initWithTitle:@"Reset password" message:@"Your reset password link has been sent to your email address." delegate:self cancelButtonTitle:@"Okay" otherButtonTitles:nil, nil];
            [resetpassword show];
            }
            
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            NSLog(@"Error: %@", error);
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Authentication failed" message:@"Please check your password and email address" delegate:self cancelButtonTitle:@"Okay" otherButtonTitles:nil, nil];
            [alert show];
        }];
       

    
    }
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    
    [textField resignFirstResponder];
    return NO;
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
