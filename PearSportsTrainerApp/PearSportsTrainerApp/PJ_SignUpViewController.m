//
//  PJ_SignUpViewController.m
//  PearSportsTrainerApp
//
//  Created by Poojan Jhaveri on 1/28/14.
//  Copyright (c) 2014 Poojan Jhaveri. All rights reserved.
//

#import "PJ_SignUpViewController.h"
#import "API.h"
#import <MBProgressHUD.h>

@interface PJ_SignUpViewController ()
@property (weak, nonatomic) IBOutlet UITextField *emailAddress;
@property (weak, nonatomic) IBOutlet UIButton *submitButton;

@end

@implementation PJ_SignUpViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (IBAction)emailAddressDone:(id)sender {
    [self.emailAddress resignFirstResponder];
}



- (IBAction)signUpButtonTouched:(id)sender {
    
    if([self.emailAddress.text length] > 0)
    {
        
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_LOW, 0), ^{
            

        
    
        AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
        //   manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    
    
        NSString *emailpass = [NSString stringWithFormat:@"%@",self.emailAddress.text];
    
        NSDictionary *parameters = @{@"email": emailpass};
        [manager POST:@"https://cs477-backend.herokuapp.com/sign-up" parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
           
            dispatch_async(dispatch_get_main_queue(), ^{
                [MBProgressHUD hideHUDForView:self.view animated:YES];
            });
            
        
        NSLog(@"JSON: %@", responseObject);
        [self textFieldShouldReturn:self.emailAddress];
            
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Sign-Up request sent" message:@"Please check your your email for continuing your process of registration." delegate:self cancelButtonTitle:@"Okay" otherButtonTitles:nil, nil];
                 [alert show];
        
        
        
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            
            dispatch_async(dispatch_get_main_queue(), ^{
                [MBProgressHUD hideHUDForView:self.view animated:YES];
            });
            
            if([operation.response statusCode]==400)
            {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Sign-Up request failed" message:@"Please check your your email address. This email address is already signed up." delegate:self cancelButtonTitle:@"Okay" otherButtonTitles:nil, nil];
                [alert show];
            }
            else{
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"No Internet Connection" message:@"Please try again." delegate:self cancelButtonTitle:@"Okay" otherButtonTitles:nil, nil];
                [alert show];
            }
            
            NSLog(@"Error: %@", error);

        
        }];
            
        });
    }
    else
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Sign Up Request Failed" message:@"Please enter a valid email address" delegate:self cancelButtonTitle:@"Okay" otherButtonTitles:nil, nil];
        [alert show];
        
        
    }
    
    

    
}

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.25];
    self.view.frame = CGRectMake(0,-120,320,568);
    [UIView commitAnimations];
    
}


- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.25];
    self.view.frame = CGRectMake(0,64,320,568);
    [UIView commitAnimations];
    
    [textField resignFirstResponder];
    
    
    return NO;
}




- (IBAction)cancelButtonTouched:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}




- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    
    if([textField.text length]>0)
    {
        [self.submitButton setEnabled:TRUE];
        [self.submitButton setBackgroundColor:[UIColor colorWithRed:0.137 green:0.756 blue:0.929 alpha:1.0]];
        
        
    }
    else  {
    
        [self.submitButton setEnabled:FALSE];
        [self.submitButton setBackgroundColor:[UIColor lightGrayColor]];

           }
    
    // Now you can use the value of textField.text for whatever you need to do.
    
    return YES;
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(buttonIndex==0)
    {
   //      [self dismissViewControllerAnimated:YES completion:nil];
    }
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


- (IBAction)backgroundTapped:(id)sender {
    
    [self textFieldShouldReturn:self.emailAddress];
}

@end
