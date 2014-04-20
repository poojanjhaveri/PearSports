//
//  PJ_LoginViewController.m
//  PearSportsTrainerApp
//
//  Created by Poojan Jhaveri on 1/16/14.
//  Copyright (c) 2014 Poojan Jhaveri. All rights reserved.
//

#import "PJ_LoginViewController.h"
#import "API.h"
#import "BZGFormFieldCell.h"
#import <MBProgressHUD.h>


#import "ReactiveCocoa.h"
#import "EXTScope.h"


@interface PJ_LoginViewController ()
@property (weak, nonatomic) IBOutlet UITextField *emailAddress;
@property (weak, nonatomic) IBOutlet UITextField *password;

@property (strong, nonatomic) UITableViewCell *signupCell;
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
    
    [self configureEmailFieldCell];
    [self configurePasswordFieldCell];
    
    self.formFieldCells = [NSMutableArray arrayWithArray:@[self.emailFieldCell,
                                                           self.passwordFieldCell]];
    self.formSection = 0;
    
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7)
    {
        self.edgesForExtendedLayout = UIRectEdgeNone;
        self.extendedLayoutIncludesOpaqueBars = NO;
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    

    
    
}


-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    self.emailFieldCell.validationState=BZGValidationStateNone;
    self.passwordFieldCell.validationState=BZGValidationStateNone;
}


-(void)processlogin :(NSString *)emailaddress password:(NSString *)pwtext
{
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_LOW, 0), ^{
        
        
        AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
        
        manager.requestSerializer = [AFJSONRequestSerializer serializer];
        
        [manager.requestSerializer clearAuthorizationHeader];
        [manager.requestSerializer setAuthorizationHeaderFieldWithUsername:emailaddress password:pwtext];
        
        
        NSHTTPCookieStorage *cookieStorage = [NSHTTPCookieStorage sharedHTTPCookieStorage]; NSArray *cookies = [cookieStorage cookies]; for (NSHTTPCookie *cookie in cookies) { [cookieStorage deleteCookie:cookie];  }
        
        
        [manager POST:@"https://cs477-backend.herokuapp.com/sign-in" parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject)
         {
            NSLog(@"JSON: %@", responseObject);
             [[API sharedInstance] saveCurrentUser:[responseObject objectForKey:@"trainer_info"]];
             self.emailFieldCell.textField.text=@"";
             self.passwordFieldCell.textField.text=@"";
             
             dispatch_async(dispatch_get_main_queue(), ^{
                 [MBProgressHUD hideHUDForView:self.view animated:YES];
             });
             
             [self performSegueWithIdentifier:@"LoggedIn" sender:self];
             
         } failure:^(AFHTTPRequestOperation *operation, NSError *error)
         
         {
             dispatch_async(dispatch_get_main_queue(), ^{
                 [MBProgressHUD hideHUDForView:self.view animated:YES];
             });
             
             if([operation.response statusCode]==401)
             {
                 UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Authentication Error" message:@"Please check your username and password." delegate:self cancelButtonTitle:@"Okay" otherButtonTitles:nil, nil];
                 [alert show];
             }
             else{
                 UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"No Internet Connection" message:@"Please try again." delegate:self cancelButtonTitle:@"Okay" otherButtonTitles:nil, nil];
                 [alert show];
             }
           
             
         }];

        
    });
    

    
    
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
        NSString *trimmed = [[alertView textFieldAtIndex:0].text stringByReplacingOccurrencesOfString:@" "  withString:@""];
        
        
        NSString *getstring = [NSString stringWithFormat:@"https://cs477-backend.herokuapp.com/password/reset/%@",trimmed];
        
        NSLog(@"getstring %@",getstring);
        
        
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_LOW, 0), ^{
        
        
        AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
        manager.responseSerializer = [AFJSONResponseSerializer serializerWithReadingOptions:NSJSONReadingAllowFragments];
        manager.requestSerializer = [AFJSONRequestSerializer serializer];
        
  //       manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
        [manager GET:getstring parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
            NSLog(@"JSON: %@", responseObject);
           
            dispatch_async(dispatch_get_main_queue(), ^{
                    [MBProgressHUD hideHUDForView:self.view animated:YES];
                });


            UIAlertView *resetpassword =[[UIAlertView alloc] initWithTitle:@"Reset password" message:@"Your reset password link has been sent to your email address." delegate:self cancelButtonTitle:@"Okay" otherButtonTitles:nil, nil];
            [resetpassword show];
            
            
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            
            dispatch_async(dispatch_get_main_queue(), ^{
                [MBProgressHUD hideHUDForView:self.view animated:YES];
            });

            
            
            if([operation.response statusCode]==400)
            {
                UIAlertView *resetpassword =[[UIAlertView alloc] initWithTitle:@"Reset password" message:@"Please verify the email address you entered. " delegate:self cancelButtonTitle:@"Okay" otherButtonTitles:nil, nil];
                [resetpassword show];
            }
            else
            {
            
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Internet Connectivity Error" message:@"Please check your internet connectivity and try again later." delegate:self cancelButtonTitle:@"Okay" otherButtonTitles:nil, nil];
            [alert show];
            }
        }];
        
        });
       

    
    }
}

/*
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    
    [textField resignFirstResponder];
    return NO;
}*/


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)configureEmailFieldCell
{
    self.emailFieldCell = [BZGFormFieldCell new];
    self.emailFieldCell.label.text = @"Email";
    [self.emailFieldCell.label setFont:[UIFont fontWithName:@"Avenir Roman" size:14 ]];
    self.emailFieldCell.textField.placeholder = NSLocalizedString(@"Email", nil);
    self.emailFieldCell.textField.keyboardType = UIKeyboardTypeEmailAddress;
    self.emailFieldCell.textField.delegate = self;
    @weakify(self)
    self.emailFieldCell.didEndEditingBlock = ^(BZGFormFieldCell *cell, NSString *text) {
        @strongify(self);
        if (text.length == 0) {
            cell.validationState = BZGValidationStateNone;
            cell.shouldShowInfoCell = NO;
            [self updateInfoCellBelowFormFieldCell:cell];
            return;
        }
    };
    
     self.emailFieldCell.shouldChangeTextBlock = ^BOOL(BZGFormFieldCell *cell, NSString *text) {
    
        if ([self validateEmail:text]) {
            cell.validationState = BZGValidationStateValid;
            cell.shouldShowInfoCell = NO;
        }
        else
        {
            cell.validationState = BZGValidationStateInvalid;
            [cell.infoCell setText:@"Email address is invalid."];
            cell.shouldShowInfoCell = YES;
        }
        [self updateInfoCellBelowFormFieldCell:cell];
         return YES;
     };
}

- (void)configurePasswordFieldCell
{
    self.passwordFieldCell = [BZGFormFieldCell new];
    self.passwordFieldCell.label.text = @"Password";
    [self.passwordFieldCell.label setFont:[UIFont fontWithName:@"Avenir Roman" size:14 ]];
    self.passwordFieldCell.textField.placeholder = NSLocalizedString(@"Password", nil);
    self.passwordFieldCell.textField.keyboardType = UIKeyboardTypeASCIICapable;
    self.passwordFieldCell.textField.secureTextEntry = YES;
    self.passwordFieldCell.textField.delegate = self;
    self.passwordFieldCell.shouldChangeTextBlock = ^BOOL(BZGFormFieldCell *cell, NSString *text) {
        // because this is a secure text field, reset the validation state every time.
        cell.validationState = BZGValidationStateNone;
        if (text.length < 1) {
            cell.validationState = BZGValidationStateInvalid;
            [cell.infoCell setText:@"Please enter your password"];
            cell.shouldShowInfoCell = YES;
        } else {
            cell.validationState = BZGValidationStateValid;
            cell.shouldShowInfoCell = NO;
        }
        return YES;
    };
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == self.formSection) {
        return [super tableView:tableView numberOfRowsInSection:section];
    } else {
        return 1;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == self.formSection) {
        return [super tableView:tableView cellForRowAtIndexPath:indexPath];
    } else {
        return self.signupCell;
    }
}

- (UITableViewCell *)signupCell
{
    UITableViewCell *cell = _signupCell;
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
        cell.textLabel.text = @"Log In";
        cell.textLabel.textAlignment = NSTextAlignmentCenter;
        RAC(cell, selectionStyle) =
        [RACSignal combineLatest:@[
                                   [RACObserve(self.emailFieldCell, validationState) skip:1],
                                   [RACObserve(self.passwordFieldCell, validationState) skip:1]]
                          reduce:^NSNumber *(NSNumber *e, NSNumber *p){
                              if (e.integerValue == BZGValidationStateValid
                                  && p.integerValue == BZGValidationStateValid) {
                                  return @(UITableViewCellSelectionStyleDefault);
                              } else {
                                  return @(UITableViewCellSelectionStyleNone);
                              }
                          }];
        
        RAC(cell.textLabel, textColor) =
        [RACSignal combineLatest:@[
                                   [RACObserve(self.emailFieldCell, validationState) skip:1],
                                   [RACObserve(self.passwordFieldCell, validationState) skip:1]]
                          reduce:^UIColor *(NSNumber *e, NSNumber *p){
                              if (e.integerValue == BZGValidationStateValid
                                  && p.integerValue == BZGValidationStateValid) {
                                  return [UIColor colorWithRed:19/255.0 green:144/255.0 blue:255/255.0 alpha:1.0];
                              } else {
                                  return [UIColor lightGrayColor];
                              }
                          }];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.textLabel.textColor = [UIColor lightGrayColor];
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
  
    if(indexPath.section==1 && indexPath.row==0 )
    {
        [self processlogin:self.emailFieldCell.textField.text password:self.passwordFieldCell.textField.text];
    }

}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == self.formSection) {
        return [super tableView:tableView heightForRowAtIndexPath:indexPath];
    } else {
        return 44;
    }
}



- (BOOL)validateEmail:(NSString *)emailStr {
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:emailStr];
}


- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    BZGFormFieldCell *cell = [BZGFormFieldCell parentCellForTextField:textField];
    if (!cell) {
        return;
    }
    if (cell.didBeginEditingBlock) {
        cell.didBeginEditingBlock(cell, textField.text);
    }
    [self updateInfoCellBelowFormFieldCell:cell];
    
  //  NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
    //   [self.tableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionMiddle animated:YES];
}


@end
