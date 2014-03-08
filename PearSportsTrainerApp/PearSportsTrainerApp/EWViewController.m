//
//  ViewController.m
//
//  Created by Alex Barinov
//  Project home page: http://alexbarinov.github.com/UIBubbleTableView/
//
//  This work is licensed under the Creative Commons Attribution-ShareAlike 3.0 Unported License.
//  To view a copy of this license, visit http://creativecommons.org/licenses/by-sa/3.0/
//

//
// Images used in this example by Petr Kratochvil released into public domain
// http://www.publicdomainpictures.net/view-image.php?image=9806
// http://www.publicdomainpictures.net/view-image.php?image=1358
//

#import "EWViewController.h"
#import "UIBubbleTableView.h"
#import "UIBubbleTableViewDataSource.h"
#import "NSBubbleData.h"
#import "API.h"
#import <AFNetworking.h>

//TODO AUTOSCROLL

@interface EWViewController ()
{
    IBOutlet UIBubbleTableView *bubbleTable;
    IBOutlet UIView *textInputView;
    IBOutlet UITextField *textField;
    IBOutlet UIButton *recordButton;
    NSMutableArray *bubbleData;
    
    NSString *soundFilePath;
    NSURL *soundFileURL;
    
    NSArray *dirPaths;
    NSString *docsDir;

}

@end

@implementation EWViewController

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    self.tabBarController.navigationItem.title =@"Messages";
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    NSLog(@"TRainee name : %@ %@ %@ %@ %@ %@",[[API sharedInstance] getTraineeInfo].name,[[API sharedInstance] getTraineeInfo].age,[[API sharedInstance] getTraineeInfo].weight,[[API sharedInstance] getTraineeInfo].height,[[API sharedInstance] getTraineeInfo].gender,[[API sharedInstance] getTraineeInfo].trainee_id);
    
    // Do any additional setup after loading the view, typically from a nib.
    _audioSession = [AVAudioSession sharedInstance];
	[_audioSession setCategory:AVAudioSessionCategoryPlayAndRecord error: nil];
	[_audioSession setActive:YES error:nil];
    self.recording = NO;
    
    /*
    dirPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    docsDir = [dirPaths objectAtIndex:0];
    
    soundFilePath = [docsDir stringByAppendingPathComponent:[self dateString]];
    soundFileURL = [NSURL fileURLWithPath:soundFilePath];
    
    NSDictionary *recordSettings = [NSDictionary
                                    dictionaryWithObjectsAndKeys:
                                    [NSNumber numberWithInt:AVAudioQualityMin],
                                    AVEncoderAudioQualityKey,
                                    [NSNumber numberWithInt:16],
                                    AVEncoderBitRateKey,
                                    [NSNumber numberWithInt: 2],
                                    AVNumberOfChannelsKey,
                                    [NSNumber numberWithFloat:44100.0],
                                    AVSampleRateKey,
                                    nil];
    
    NSError *error = nil;
    
    _audioRecorder = [[AVAudioRecorder alloc] initWithURL:soundFileURL settings:recordSettings error:&error];
    [_audioRecorder setDelegate:self];
    
    if (error)
        NSLog(@"error: %@", [error localizedDescription]);
    else
        [_audioRecorder prepareToRecord];
     */
    
    //BUBBLE
    
    NSBubbleData *heyBubble = [NSBubbleData dataWithText:@"Hi" date:[NSDate dateWithTimeIntervalSinceNow:-300] type:BubbleTypeSomeoneElse];
    heyBubble.avatar = [UIImage imageNamed:[[API sharedInstance] getTraineeInfo].imageName];
    
    NSBubbleData *photoBubble = [NSBubbleData dataWithImage:[UIImage imageNamed:@"halloween.jpg"] date:[NSDate dateWithTimeIntervalSinceNow:-290] type:BubbleTypeSomeoneElse];
    photoBubble.avatar = [UIImage imageNamed:@"avatar1.png"];
    
    NSBubbleData *testBubble = [NSBubbleData dataWithText:@"Yay.." date:[NSDate dateWithTimeIntervalSinceNow:-300] type:BubbleTypeSomeoneElse];
    testBubble.avatar = [UIImage imageNamed:@"avatar1.png"];

    
    NSBubbleData *replyBubble = [NSBubbleData dataWithText:@"Wow.." date:[NSDate dateWithTimeIntervalSinceNow:-5] type:BubbleTypeMine];
    replyBubble.avatar = nil;
    
    bubbleData = [[NSMutableArray alloc] initWithObjects:heyBubble, nil];
    //bubbleData = [ [NSMutableArray alloc] init];
    bubbleTable.bubbleDataSource = self;
    
    // The line below sets the snap interval in seconds. This defines how the bubbles will be grouped in time.
    // Interval of 120 means that if the next messages comes in 2 minutes since the last message, it will be added into the same group.
    // Groups are delimited with header which contains date and time for the first message in the group.
    
    bubbleTable.snapInterval = 120;
    
    // The line below enables avatar support. Avatar can be specified for each bubble with .avatar property of NSBubbleData.
    // Avatars are enabled for the whole table at once. If particular NSBubbleData misses the avatar, a default placeholder will be set (missingAvatar.png)
    
    bubbleTable.showAvatars = YES;
    
    // Uncomment the line below to add "Now typing" bubble
    // Possible values are
    //    - NSBubbleTypingTypeSomebody - shows "now typing" bubble on the left
    //    - NSBubbleTypingTypeMe - shows "now typing" bubble on the right
    //    - NSBubbleTypingTypeNone - no "now typing" bubble
    
    //bubbleTable.typingBubble = NSBubbleTypingTypeSomebody;
    
    [bubbleTable reloadData];
    
    // Keyboard events
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWasShown:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillBeHidden:) name:UIKeyboardWillHideNotification object:nil];
    
}

/*
- (void)viewDidAppear:(BOOL)animated{
    [bubbleTable setContentOffset:CGPointMake(0.0, bubbleTable.contentSize.height - bubbleTable.bounds.size.height)
                   animated:NO];
    
    [bubbleTable scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:[bubbleData count]-1 inSection:0]
                     atScrollPosition:UITableViewScrollPositionBottom
                             animated:YES];
    
    NSLog(@"Called");
}
 */

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}

#pragma mark - UIBubbleTableViewDataSource implementation

- (NSInteger)rowsForBubbleTable:(UIBubbleTableView *)tableView
{
    return [bubbleData count];
}

- (NSBubbleData *)bubbleTableView:(UIBubbleTableView *)tableView dataForRow:(NSInteger)row
{
    return [bubbleData objectAtIndex:row];
}

#pragma mark - Keyboard events

- (void)keyboardWasShown:(NSNotification*)aNotification
{
    NSDictionary* info = [aNotification userInfo];
    CGSize kbSize = [[info objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;
    
    [UIView animateWithDuration:0.2f animations:^{
        
        CGRect frame = textInputView.frame;
        frame.origin.y -= kbSize.height-50;
        textInputView.frame = frame;
        
        frame = bubbleTable.frame;
        frame.size.height -= kbSize.height-50;
        bubbleTable.frame = frame;
        
        
    }];
}

- (void)keyboardWillBeHidden:(NSNotification*)aNotification
{
    NSDictionary* info = [aNotification userInfo];
    CGSize kbSize = [[info objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;
    
    [UIView animateWithDuration:0.2f animations:^{
        
        CGRect frame = textInputView.frame;
        frame.origin.y += kbSize.height-50;
        textInputView.frame = frame;
        
        frame = bubbleTable.frame;
        frame.size.height += kbSize.height-50;
        bubbleTable.frame = frame;
        
    }];
}

#pragma mark - Actions

//NOT USED FOR NOW
- (NSString *) dateString
{
    // return a formatted string for a file name
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"ddMMMYY_hhmmssa";
    return [[formatter stringFromDate:[NSDate date]] stringByAppendingString:@".caf"];
}


- (IBAction)recordVoice:(id)sender
{
    if(self.recording==NO){
        
        dirPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        docsDir = [dirPaths objectAtIndex:0];
        
        soundFilePath = [docsDir stringByAppendingPathComponent:[self dateString]];
        soundFileURL = [NSURL fileURLWithPath:soundFilePath];
        
        NSDictionary *recordSettings = [NSDictionary
                                        dictionaryWithObjectsAndKeys:
                                        [NSNumber numberWithInt:AVAudioQualityMin],
                                        AVEncoderAudioQualityKey,
                                        [NSNumber numberWithInt:16],
                                        AVEncoderBitRateKey,
                                        [NSNumber numberWithInt: 2],
                                        AVNumberOfChannelsKey,
                                        [NSNumber numberWithFloat:44100.0],
                                        AVSampleRateKey,
                                        nil];
        
        NSError *error = nil;
        
        _audioRecorder = [[AVAudioRecorder alloc] initWithURL:soundFileURL settings:recordSettings error:&error];
        [_audioRecorder setDelegate:self];
        
        if (error)
            NSLog(@"error: %@", [error localizedDescription]);
        else
            [_audioRecorder prepareToRecord];

        
        self.recording = YES;
        [recordButton setImage:[UIImage imageNamed:@"stop.png"] forState:UIControlStateNormal];
        [_audioRecorder record];
        
    }
    else{
        self.recording = NO;
        [recordButton setImage:[UIImage imageNamed:@"microphonehot.png"] forState:UIControlStateNormal];
        [_audioRecorder stop];
        
        
        NSBubbleData *audioBubble = [NSBubbleData dataWithData:soundFileURL date:[NSDate dateWithTimeIntervalSinceNow:0] type:BubbleTypeMine];
        audioBubble.avatar = nil;
        [bubbleData addObject:audioBubble];
        [bubbleTable reloadData];
        textField.text = @"";
        [textField resignFirstResponder];
        
        [bubbleTable scrollBubbleViewToBottomAnimated:YES];
        
        /*
        NSBubbleData *audioBubble = [NSBubbleData dataWithImage:[UIImage imageNamed:@"audio_basic.png"] date:[NSDate dateWithTimeIntervalSinceNow:0] type:BubbleTypeMine];
        audioBubble.avatar = nil;
        [bubbleData addObject:audioBubble];
        [bubbleTable reloadData];
        textField.text = @"";
        [textField resignFirstResponder];
         */
    }
   
}



- (IBAction)doneEditing:(id)sender {
    
    
    /*[bubbleTable scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:[bubbleData count]-1 inSection:0]
                       atScrollPosition:UITableViewScrollPositionBottom
                               animated:YES];
     */
    bubbleTable.typingBubble = NSBubbleTypingTypeNobody;
    
    if((textField.text && textField.text.length > 0)){
        NSBubbleData *sayBubble = [NSBubbleData dataWithText:textField.text date:[NSDate dateWithTimeIntervalSinceNow:0] type:BubbleTypeMine];
        [bubbleData addObject:sayBubble];
        [bubbleTable reloadData];
        
  
        AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
        
        [manager setRequestSerializer:[AFHTTPRequestSerializer serializer]];
        [manager.requestSerializer clearAuthorizationHeader];
        [manager.requestSerializer setAuthorizationHeaderFieldWithUsername:@"daniel@somefakeemail.com" password:@"password1"];
        
        manager.responseSerializer = [AFJSONResponseSerializer serializer];
        manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"application/json"];
        
    
        
         NSDictionary *parameters = @{@"trainee_id":[NSString stringWithFormat:@"%@",[[API sharedInstance] getTraineeInfo].trainee_id], @"content":[NSString stringWithFormat:@"hi"], @"outgoing":[NSString stringWithFormat:@"true"]};
       
        [manager POST:@"http://cs477-backend.herokuapp.com/message/text" parameters:parameters
              success:^(AFHTTPRequestOperation *operation, id responseObject){
                  
                  NSLog(@"%@",responseObject);
                  
                    if([responseObject objectForKey:@"error"]){
                        
                        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Text request failed" message:@"Please check." delegate:self cancelButtonTitle:@"Okay" otherButtonTitles:nil, nil];
                        [alert show];
                    }
                    else{
                        
                        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Text request sent" message:@"Good" delegate:self cancelButtonTitle:@"Okay" otherButtonTitles:nil, nil];
                        [alert show];
                    }
      
              } failure:^(AFHTTPRequestOperation *operation, NSError *error){
             
                    NSLog(@"Error: %@", error);
                    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Sending Error" message:@"Please check Internet and everything" delegate:self cancelButtonTitle:@"Okay" otherButtonTitles:nil, nil];
                    [alert show];
              }
         ];
 
    }
   
    
    textField.text = @"";
    [textField resignFirstResponder];
    [bubbleTable scrollBubbleViewToBottomAnimated:YES];
}

-(void)audioPlayerDecodeErrorDidOccur:(AVAudioPlayer *)player error:(NSError *)error
{
    NSLog(@"Decode Error occurred");
}

-(void)audioRecorderDidFinishRecording:(AVAudioRecorder *)recorder successfully:(BOOL)flag
{
}

-(void)audioRecorderEncodeErrorDidOccur:(AVAudioRecorder *)recorder error:(NSError *)error
{
    NSLog(@"Encode Error occurred");
}

@end
