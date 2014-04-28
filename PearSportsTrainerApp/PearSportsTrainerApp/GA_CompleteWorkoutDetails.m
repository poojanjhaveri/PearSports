//
//  GA_DetailViewController.m
//  PearSportsTrainerApp
//
//  Created by Garima Aggarwal on 3/23/14.
//  Copyright (c) 2014 Poojan Jhaveri. All rights reserved.
//

#import "GA_CompleteWorkoutDetails.h"
#import "AG_WorkoutHRZonesChartViewController.h"
#import "AG_WorkoutHRLineChartViewController.h"
#import "API.h"

@interface GA_CompleteWorkoutDetails () <UITextViewDelegate>

@property (weak, nonatomic) IBOutlet UITextView *notesTextView;
@property (weak, nonatomic) IBOutlet UIImageView *workoutImageView;
@property (weak, nonatomic) IBOutlet UILabel *workoutNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *workoutDateLabel;

@property (weak, nonatomic) IBOutlet UILabel *durationLabel;
@property (weak, nonatomic) IBOutlet UILabel *avgHRLabel;
@property (weak, nonatomic) IBOutlet UILabel *distanceLabel;
@property (weak, nonatomic) IBOutlet UILabel *caloriesLabel;
@property (weak, nonatomic) IBOutlet UILabel *avgPaceLabel;


@end

@implementation GA_CompleteWorkoutDetails

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
    // @TODO update with actual inforamtion
    if(workout == nil){
        [self.notesTextView setText:@"User Notes will Go Here"];
        [self.durationLabel setText:@"1:30:29"];
        [self.avgHRLabel setText:@"144 bpm"];
        [self.distanceLabel setText:@"5.55 miles"];
        [self.caloriesLabel setText:@"405"];
        [self.avgPaceLabel setText:@"1:52"];

        [self.workoutNameLabel setText:@"Workout Name"];
        [self.workoutDateLabel setText:@"March 29, 2014"];

        UIImage *image = [UIImage imageNamed: @"workout.jpeg"];
        [self.workoutImageView setImage: image];
    }
   else{
       if([workout.longDes isEqualToString:@"(null)"])
           [self.notesTextView setText:[NSString stringWithFormat:@"%@", workout.shortDes]];
       else{
           NSLog(@"Long Des: %@", workout.longDes);
           [self.notesTextView setText:[NSString stringWithFormat:@"%@", workout.longDes]];
       }

       [self.durationLabel setText:[NSString stringWithFormat:@"%@", workout.duration]];
        [self.avgHRLabel setText:[NSString stringWithFormat:@"%@ bpm", workout.avgHeartRate]];
        [self.distanceLabel setText:[NSString stringWithFormat:@"%@ miles", workout.distance]];
        [self.caloriesLabel setText:[NSString stringWithFormat:@"%@", workout.calories]];
        [self.avgPaceLabel setText:@"1:52"];
       
        [self.workoutNameLabel setText:[NSString stringWithFormat:@"%@", workout.workoutName]];
        [self.workoutDateLabel setText:[NSString stringWithFormat:@"%@", workout.wdate]];
        
        UIImage *image = [UIImage imageNamed: @"workout.jpeg"];
        [self.workoutImageView setImage: image];
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



#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
  if([segue.identifier isEqualToString:@"HRZoneCharts"]){
    
    AG_WorkoutHRZonesChartViewController *destViewController = segue.destinationViewController;
    destViewController.workout = [self workout];
  }
  if([segue.identifier isEqualToString:@"HRLineCharts"]){

    AG_WorkoutHRLineChartViewController *destViewController = segue.destinationViewController;
    destViewController.workout = [self workout];
  }

}

@end
