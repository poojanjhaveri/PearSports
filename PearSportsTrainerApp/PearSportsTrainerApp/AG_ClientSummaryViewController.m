//
//  PJ_ClientSummaryViewController.m
//  PearSportsTrainerApp
//
//  Created by Alfonso Garza on 2/23/14.
//  Copyright (c) 2014 Poojan Jhaveri. All rights reserved.
//

#import "AG_ClientSummaryViewController.h"
#import "API.h"
#import <NZCircularImageView.h>

@interface AG_ClientSummaryViewController () <UITextViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *chartsTableView;
@property (weak, nonatomic) IBOutlet UITextView *notesTextView;
@property (weak, nonatomic) IBOutlet NZCircularImageView *clientImageView;
@property (weak, nonatomic) IBOutlet UILabel *goalLabel;
@property (weak, nonatomic) IBOutlet UILabel *ageLabel;
@property (weak, nonatomic) IBOutlet UILabel *weightLabel;
@property (weak, nonatomic) IBOutlet UILabel *totalCalories;
@property (weak, nonatomic) IBOutlet UILabel *totalDistance;
@property (weak, nonatomic) IBOutlet UILabel *totalTime;
@end

@implementation AG_ClientSummaryViewController

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
    self.tabBarController.navigationItem.title =[[API sharedInstance] getTraineeInfo].name;
    [self.tabBarController.navigationItem setRightBarButtonItems:nil];
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    // Client Setup
    // @TODO update with actual inforamtion
    [self.notesTextView setText:[[API sharedInstance] getTraineeInfo].notes];
    [self.goalLabel setText:[[API sharedInstance] getTraineeInfo].gender];
    
    int weight = [[[API sharedInstance] getTraineeInfo].weight intValue] / 1000;
    [self.weightLabel setText:[NSString stringWithFormat:@"%d lbs", weight]];
    
    [self.ageLabel setText:[NSString stringWithFormat:@"%@", [[API sharedInstance] getTraineeInfo].age]];
    
  
      [self.clientImageView setImageWithURL:[NSURL URLWithString:[[API sharedInstance] getTraineeInfo].imageName]];
  
    [self updateLifeTimeStats];
  
    // Main Setup
    [self.notesTextView setDelegate:self];
    [self.notesTextView setReturnKeyType:UIReturnKeyDone];
    [self.notesTextView setSpellCheckingType:UITextSpellCheckingTypeDefault];
    self.parentViewController.view.backgroundColor = [UIColor whiteColor];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShown:)
                                                 name:UIKeyboardWillShowNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillBeHidden:)
                                                 name:UIKeyboardWillHideNotification object:nil];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]
                                   initWithTarget:self
                                   action:@selector(dismissKeyboard)];
    
    [self.view addGestureRecognizer:tap];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // typically you need know which item the user has selected.
    // this method allows you to keep track of the selection
    NSLog(@"selelele");
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView
           editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    return UITableViewCellEditingStyleDelete;
}

// This will tell your UITableView how many rows you wish to have in each section.
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

// This will tell your UITableView what data to put in which cells in your table.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifer = @"MyStaticCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifer];
    
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifer];
    }
    
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    cell.textLabel.text = @"Summary Charts";
    
    return cell;
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
    self.view.frame = CGRectMake(0, 0 - keyboardSize.height + 49, self.view.frame.size.width, self.view.frame.size.height);
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
      
      NSString *tra_id = [NSString stringWithFormat:@"%@",[[API sharedInstance] getTraineeInfo].trainee_id];
      NSString *notes = [self.notesTextView text];
      
      [[API sharedInstance] getTraineeInfo].notes = notes;

      NSDictionary *parameters = [[NSDictionary alloc] initWithObjects:[NSArray arrayWithObjects:tra_id, notes, nil] forKeys:[NSArray arrayWithObjects:@"trainee_id", @"notes", nil]];
      
        NSString *url = @"https://cs477-backend.herokuapp.com/trainee/notes";

        AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
        
        NSMutableURLRequest *request = [manager.requestSerializer requestWithMethod:@"POST"
                                                                          URLString:url
                                                                         parameters:parameters
                                                                              error:nil];
        
        AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
        [operation setResponseSerializer:[AFJSONResponseSerializer alloc]];
        [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
                } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
          NSLog(@"Couldn't load HR Data.");
        }];
        
        [manager.operationQueue addOperation:operation];
        

        return NO;
    }
    
    return YES;
}


#pragma mark - Update information

-(void) updateLifeTimeStats
{
  
  NSString * token = [[[NSUserDefaults standardUserDefaults] objectForKey:@"CurrentUser" ] valueForKey:@"token"];
  
  NSURLCredential *credential = [NSURLCredential credentialWithUser:token
                                                           password:@""
                                                        persistence:NSURLCredentialPersistenceNone];
  
  NSString *url = [NSString stringWithFormat:@"http://cs477-backend.herokuapp.com/stats?trainee_id=%@",
                   [[API sharedInstance] getTraineeInfo].trainee_id];
  
  AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
  [manager.requestSerializer setAuthorizationHeaderFieldWithUsername:token password:@""];
  
  NSMutableURLRequest *request = [manager.requestSerializer requestWithMethod:@"GET"
                                                                    URLString:url
                                                                   parameters:nil
                                                                        error:nil];
  
  AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
  [operation setCredential:credential];
  [operation setResponseSerializer:[AFJSONResponseSerializer alloc]];
  [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
    
    [self.totalCalories setText:[NSString stringWithFormat:@"%@", [[responseObject objectForKey:@"trainee_stats"] objectForKey:@"calories"]]];
    [self.totalDistance setText:[NSString stringWithFormat:@"%@ mi", [[responseObject objectForKey:@"trainee_stats"] objectForKey:@"distance_mi"]]];
    [self.totalTime setText:[NSString stringWithFormat:@"%@", [[responseObject objectForKey:@"trainee_stats"] objectForKey:@"duration_formatted"]]];
    
  } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
    NSLog(@"Error loading lifetime stats: %@", error);
  }];
  
  [manager.operationQueue addOperation:operation];
  
}

@end