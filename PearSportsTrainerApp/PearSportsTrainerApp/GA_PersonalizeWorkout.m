//
//  GA_PersonalizeViewController.m
//  PearSportsTrainerApp
//
//  Created by Student on 3/17/14.
//  Copyright (c) 2014 Poojan Jhaveri. All rights reserved.
//

#import "GA_PersonalizeWorkout.h"
#import "API.h"

@interface GA_PersonalizeWorkout () <UITextViewDelegate>

@property (weak, nonatomic) IBOutlet UITextView *notesTextView;
@property (weak, nonatomic) IBOutlet UILabel *workoutNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (weak, nonatomic) IBOutlet UIButton *scheduleBtn;

@end

@implementation GA_PersonalizeWorkout

@synthesize wName = _wName;
@synthesize wSKU = _wSKU;
@synthesize notes = _notes;
@synthesize wDate = _wDate;

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
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];

    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"MM-dd-YYYY"];// you can use your format
    
    
    [self.notesTextView setText: [NSString stringWithFormat:@"%@", _notes]];
    [self.workoutNameLabel setText:[NSString stringWithFormat:@"%@", _wName]];
    [self.dateLabel setText:[NSString stringWithFormat:@"%@",[dateFormat stringFromDate:_wDate]]];

    [self.scheduleBtn addTarget:self action:@selector(buttonClicked: ) forControlEvents:UIControlEventTouchUpInside];
    
    
    [self.notesTextView setEditable:NO];
/*
    // Main Setup
    [self.notesTextView setDelegate:self];
    [self.notesTextView setReturnKeyType:UIReturnKeyDone];
    [self.notesTextView setSpellCheckingType:UITextSpellCheckingTypeDefault];
    self.parentViewController.view.backgroundColor = [UIColor whiteColor];
//    [[NSNotificationCenter defaultCenter] addObserver:self
//                                             selector:@selector(keyboardWillShown:)
//                                                 name:UIKeyboardWillShowNotification object:nil];
//    
//    [[NSNotificationCenter defaultCenter] addObserver:self
//                                             selector:@selector(keyboardWillBeHidden:)
//                                                 name:UIKeyboardWillHideNotification object:nil];
//    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]
//                                   initWithTarget:self
//                                   action:@selector(dismissKeyboard)];
//    
////    [self.view addGestureRecognizer:tap];
 */

}

- (IBAction) buttonClicked: (id)sender
{
    [self sendWorkOutRequest];
    [self.navigationController popToRootViewControllerAnimated:YES];
    
//    UIViewController *prevVC = [self.navigationController.viewControllers objectAtIndex:1];
//    [self.navigationController popToViewController:prevVC animated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Keyboard Handling
-(void)dismissKeyboard {
    [self.notesTextView resignFirstResponder];
}

- (void)keyboardWillShown:(NSNotification*)notification {
    NSDictionary* info = [notification userInfo];
    CGSize keyboardSize = [[info objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].size;
    
    [UIView beginAnimations:@"MoveView" context:nil];
    [UIView setAnimationDuration:[notification.userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue]];
    [UIView setAnimationCurve:[notification.userInfo[UIKeyboardAnimationCurveUserInfoKey] integerValue]];
    [UIView setAnimationBeginsFromCurrentState:YES];
    self.view.frame = CGRectMake(0, 0 - keyboardSize.height+89, self.view.frame.size.width, self.view.frame.size.height);
    [UIView commitAnimations];
    
}

- (void)keyboardWillBeHidden:(NSNotification*)notification {
    [UIView beginAnimations:@"MoveView" context:nil];
    [UIView setAnimationDuration:[notification.userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue]];
    [UIView setAnimationCurve:[notification.userInfo[UIKeyboardAnimationCurveUserInfoKey] integerValue]];
    [UIView setAnimationBeginsFromCurrentState:YES];
    self.view.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
    [UIView commitAnimations];
}

#pragma mark - Text View delegates
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    
    if([text isEqualToString:@"\n"]) {
        [textView resignFirstResponder];
        // @TODO UPDATE SERVER
        return NO;
    }
    
    return YES;
}

//sends the workout to backend to be added to the trainee
-(void)sendWorkOutRequest
{
    
    
//    NSLog(@"weekstart : %@",self.weekstart);
//    NSLog(@"weekend : %@",self.weekend);
    
    NSTimeInterval ti = [_wDate timeIntervalSince1970];
    
    
    NSString * token = [[[NSUserDefaults standardUserDefaults] objectForKey:@"CurrentUser" ] valueForKey:@"token"];
    NSString *tra_id = [NSString stringWithFormat:@"%@",[[API sharedInstance] getTraineeInfo].trainee_id];
    NSString *time_st = [NSString stringWithFormat:@"%f", ti];
    NSLog(@"workout date: %@", time_st);
    NSDictionary *parameters = [[NSDictionary alloc] initWithObjects:[NSArray arrayWithObjects:tra_id, time_st, nil] forKeys:[NSArray arrayWithObjects:@"trainee_id", @"start", nil]];
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    NSURLCredential *credential = [NSURLCredential credentialWithUser:token password:@"" persistence:NSURLCredentialPersistenceNone];
    [manager.requestSerializer setAuthorizationHeaderFieldWithUsername:token password:@""];

    NSString *urlstring = [NSString stringWithFormat:@"https://cs477-backend.herokuapp.com/workout/%@",self.wSKU];
    
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

#pragma mark - Navigation

// In a story board-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    
    
}





@end
