//
//  GA_IncDetailViewController.m
//  PearSportsTrainerApp
//
//  Created by Garima Aggarwal on 3/29/14.
//  Copyright (c) 2014 Poojan Jhaveri. All rights reserved.
//

#import "GA_IncompleteWorkoutDetails.h"
#import "API.h"

@interface GA_IncompleteWorkoutDetails () <UITextViewDelegate>

@property (weak, nonatomic) IBOutlet UITextView *notesTextView;
@property (weak, nonatomic) IBOutlet UILabel *workoutNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *workoutDateLabel;

@end

@implementation GA_IncompleteWorkoutDetails

@synthesize workout;

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
    
    if(workout == nil){
        [self.notesTextView setText:@"User Notes will Go Here"];

        [self.workoutNameLabel setText:@"Workout Name"];
        [self.workoutDateLabel setText:@"Workout Date"];
    }
    else{
        if([workout.longDes isEqualToString:@"(null)"])
            [self.notesTextView setText:[NSString stringWithFormat:@"%@", workout.shortDes]];
        else{
            NSLog(@"Long Des: %@", workout.longDes);
            [self.notesTextView setText:[NSString stringWithFormat:@"%@", workout.longDes]];
        }
        
        [self.workoutNameLabel setText:workout.workoutName];
        [self.workoutDateLabel setText:workout.wdate];
    }
    
        [self.notesTextView setEditable:NO];
/*
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
 */

}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    
    self.navigationItem.title  = [[API sharedInstance] getTraineeInfo].name;
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
