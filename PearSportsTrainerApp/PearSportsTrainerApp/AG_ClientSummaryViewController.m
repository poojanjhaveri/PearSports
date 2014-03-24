//
//  PJ_ClientSummaryViewController.m
//  PearSportsTrainerApp
//
//  Created by Alfonso Garza on 2/23/14.
//  Copyright (c) 2014 Poojan Jhaveri. All rights reserved.
//

#import "AG_ClientSummaryViewController.h"
#import "API.h"

@interface AG_ClientSummaryViewController () <UITextViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *chartsTableView;
@property (weak, nonatomic) IBOutlet UITextView *notesTextView;
@property (weak, nonatomic) IBOutlet UIImageView *clientImageView;
@property (weak, nonatomic) IBOutlet UILabel *goalLabel;
@property (weak, nonatomic) IBOutlet UILabel *ageLabel;
@property (weak, nonatomic) IBOutlet UILabel *weightLabel;
@property (weak, nonatomic) IBOutlet UILabel *lastWorkoutLabel;
@property (weak, nonatomic) IBOutlet UILabel *lastContactLabel;
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
  [self.notesTextView setText:@"User Notes will Go Here"];
  [self.goalLabel setText:@"Weight Loss"];
  [self.ageLabel setText:@"47"];
  //  [self.weightLabel setText:[[API sharedInstance] getTraineeInfo].dob];
  [self.weightLabel setText:@"123lb"];
  [self.lastWorkoutLabel setText:@"Today at 6:00pm"];
  [self.lastContactLabel setText:@"Yesterday"];
    self.clientImageView.image=[UIImage imageNamed:[[API sharedInstance] getTraineeInfo].imageName];
  
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
    return NO;
  }
  
  return YES;
}

@end
