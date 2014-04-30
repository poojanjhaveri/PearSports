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
#import <MBProgressHUD.h>
#import <NZCircularImageView.h>


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
@synthesize imageView;

- (IBAction)imageButton:(id)sender {
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@""
                                                             delegate:self
                                                    cancelButtonTitle:@"Cancel"
                                               destructiveButtonTitle:nil
                                                    otherButtonTitles:@"Take a picture", @"Select from Library", nil];
    actionSheet.actionSheetStyle = UIActionSheetStyleBlackTranslucent;
    [actionSheet showInView:textInputView];
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    
    switch(buttonIndex)
    {
        case 0:
        {
            UIImagePickerController * picker = [[UIImagePickerController alloc] init];
            picker.delegate = self;
            picker.sourceType = UIImagePickerControllerSourceTypeCamera;
            [self presentViewController:picker animated:YES completion:^{}];
        }
            break;
        case 1:
        {
            UIImagePickerController * picker = [[UIImagePickerController alloc] init];
            picker.delegate = self;
            picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
            [self presentViewController:picker animated:YES completion:^{}];
        }
        default:
            [actionSheet dismissWithClickedButtonIndex:0 animated:YES];
            break;
    }
}

- (void) useCamera:(id)sender
{
    if ([UIImagePickerController isSourceTypeAvailable:
         UIImagePickerControllerSourceTypeCamera])
    {
        UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
        imagePicker.delegate = self;
        imagePicker.sourceType =
        UIImagePickerControllerSourceTypeCamera;
        imagePicker.mediaTypes = @[(NSString *) kUTTypeImage];
        imagePicker.allowsEditing = NO;
        [self presentViewController:imagePicker
                           animated:YES completion:nil];
        _newMedia = YES;
    }
}
- (void) useCameraRoll:(id)sender
{
    if ([UIImagePickerController isSourceTypeAvailable:
         UIImagePickerControllerSourceTypeSavedPhotosAlbum])
    {
        UIImagePickerController *imagePicker =
        [[UIImagePickerController alloc] init];
        imagePicker.delegate = self;
        imagePicker.sourceType =
        UIImagePickerControllerSourceTypePhotoLibrary;
        imagePicker.mediaTypes = @[(NSString *) kUTTypeImage];
        imagePicker.allowsEditing = NO;
        [self presentViewController:imagePicker
                           animated:YES completion:nil];
        _newMedia = NO;
    }
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    NSString *mediaType = info[UIImagePickerControllerMediaType];
    
    [self dismissViewControllerAnimated:YES completion:nil];
    
    if ([mediaType isEqualToString:(NSString *)kUTTypeImage]) {
        UIImage *image = info[UIImagePickerControllerOriginalImage];
        image = [self scaleAndRotateImage:image];
        
        imageView.image = image;
        //imageView.image = image;
        if (_newMedia)
            UIImageWriteToSavedPhotosAlbum(image,
                                           self,
                                           @selector(image:finishedSavingWithError:contextInfo:),
                                           nil);
        
        if(image != nil){
            NSBubbleData *imageBubble = [NSBubbleData dataWithImage:image date:[NSDate dateWithTimeIntervalSinceNow:0] type:BubbleTypeMine];
            imageBubble.avatar = nil;
            [bubbleData addObject:imageBubble];
            [bubbleTable reloadData];
            textField.text = @"";
            [textField resignFirstResponder];
            
            [bubbleTable scrollBubbleViewToBottomAnimated:NO];
            
            NSLog(@"Sending image to server");
            
            
            NSString *token = [[[NSUserDefaults standardUserDefaults] objectForKey:@"CurrentUser" ] valueForKey:@"token"];
            NSString *tra_id = [NSString stringWithFormat:@"%@",[[API sharedInstance] getTraineeInfo].trainee_id];
            NSData *theData = UIImagePNGRepresentation(image);
            //NSData *theData = [NSData dataWithContentsOfURL:soundFileURL];
            
            NSDictionary *parameters = [[NSDictionary alloc] initWithObjects:[NSArray arrayWithObjects:tra_id, nil] forKeys:[NSArray arrayWithObjects:@"trainee_id", nil]];
            
            AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
            NSURLCredential *credential = [NSURLCredential credentialWithUser:token password:@"" persistence:NSURLCredentialPersistenceNone];
            
            [manager.requestSerializer setAuthorizationHeaderFieldWithUsername:token password:@""];
            
            NSMutableURLRequest *reqst = [manager.requestSerializer multipartFormRequestWithMethod:@"POST" URLString:@"https://cs477-backend.herokuapp.com/message/image" parameters:parameters constructingBodyWithBlock: ^(id <AFMultipartFormData>formData){
                [formData appendPartWithFileData:theData name:@"content" fileName:[self dateString2] mimeType:@"image/png"];
            }];
            
            //NSMutableURLRequest *reqst = [manager.requestSerializer requestWithMethod:@"POST" URLString:@"https://cs477-backend.herokuapp.com/message/audio" parameters:parameters error:nil];
            
            AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:reqst];
            [operation setCredential:credential];
            [operation setResponseSerializer:[AFJSONResponseSerializer alloc]];
            [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
                NSLog(@"Success: %@", responseObject);
            } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                NSLog(@"Failure: %@", error);
                [self showLoadingError];
            }];
            
            NSLog(@"OPERATION IS %@",operation);
            
            [manager.operationQueue addOperation:operation];
            
        }
    }
    else if ([mediaType isEqualToString:(NSString *)kUTTypeMovie])
    {
        // Code here to support video if enabled
    }
}

- (UIImage *)scaleAndRotateImage:(UIImage *)image {
    int kMaxResolution = 640; // Or whatever
    
    CGImageRef imgRef = image.CGImage;
    
    CGFloat width = CGImageGetWidth(imgRef);
    CGFloat height = CGImageGetHeight(imgRef);
    
    
    CGAffineTransform transform = CGAffineTransformIdentity;
    CGRect bounds = CGRectMake(0, 0, width, height);
    if (width > kMaxResolution || height > kMaxResolution) {
        CGFloat ratio = width/height;
        if (ratio > 1) {
            bounds.size.width = kMaxResolution;
            bounds.size.height = roundf(bounds.size.width / ratio);
        }
        else {
            bounds.size.height = kMaxResolution;
            bounds.size.width = roundf(bounds.size.height * ratio);
        }
    }
    
    CGFloat scaleRatio = bounds.size.width / width;
    CGSize imageSize = CGSizeMake(CGImageGetWidth(imgRef), CGImageGetHeight(imgRef));
    CGFloat boundHeight;
    UIImageOrientation orient = image.imageOrientation;
    switch(orient) {
            
        case UIImageOrientationUp: //EXIF = 1
            transform = CGAffineTransformIdentity;
            break;
            
        case UIImageOrientationUpMirrored: //EXIF = 2
            transform = CGAffineTransformMakeTranslation(imageSize.width, 0.0);
            transform = CGAffineTransformScale(transform, -1.0, 1.0);
            break;
            
        case UIImageOrientationDown: //EXIF = 3
            transform = CGAffineTransformMakeTranslation(imageSize.width, imageSize.height);
            transform = CGAffineTransformRotate(transform, M_PI);
            break;
            
        case UIImageOrientationDownMirrored: //EXIF = 4
            transform = CGAffineTransformMakeTranslation(0.0, imageSize.height);
            transform = CGAffineTransformScale(transform, 1.0, -1.0);
            break;
            
        case UIImageOrientationLeftMirrored: //EXIF = 5
            boundHeight = bounds.size.height;
            bounds.size.height = bounds.size.width;
            bounds.size.width = boundHeight;
            transform = CGAffineTransformMakeTranslation(imageSize.height, imageSize.width);
            transform = CGAffineTransformScale(transform, -1.0, 1.0);
            transform = CGAffineTransformRotate(transform, 3.0 * M_PI / 2.0);
            break;
            
        case UIImageOrientationLeft: //EXIF = 6
            boundHeight = bounds.size.height;
            bounds.size.height = bounds.size.width;
            bounds.size.width = boundHeight;
            transform = CGAffineTransformMakeTranslation(0.0, imageSize.width);
            transform = CGAffineTransformRotate(transform, 3.0 * M_PI / 2.0);
            break;
            
        case UIImageOrientationRightMirrored: //EXIF = 7
            boundHeight = bounds.size.height;
            bounds.size.height = bounds.size.width;
            bounds.size.width = boundHeight;
            transform = CGAffineTransformMakeScale(-1.0, 1.0);
            transform = CGAffineTransformRotate(transform, M_PI / 2.0);
            break;
            
        case UIImageOrientationRight: //EXIF = 8
            boundHeight = bounds.size.height;
            bounds.size.height = bounds.size.width;
            bounds.size.width = boundHeight;
            transform = CGAffineTransformMakeTranslation(imageSize.height, 0.0);
            transform = CGAffineTransformRotate(transform, M_PI / 2.0);
            break;
            
        default:
            [NSException raise:NSInternalInconsistencyException format:@"Invalid image orientation"];
            
    }
    
    UIGraphicsBeginImageContext(bounds.size);
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    if (orient == UIImageOrientationRight || orient == UIImageOrientationLeft) {
        CGContextScaleCTM(context, -scaleRatio, scaleRatio);
        CGContextTranslateCTM(context, -height, 0);
    }
    else {
        CGContextScaleCTM(context, scaleRatio, -scaleRatio);
        CGContextTranslateCTM(context, 0, -height);
    }
    
    CGContextConcatCTM(context, transform);
    
    CGContextDrawImage(UIGraphicsGetCurrentContext(), CGRectMake(0, 0, width, height), imgRef);
    UIImage *imageCopy = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return imageCopy;
}

-(void)image:(UIImage *)image
finishedSavingWithError:(NSError *)error
 contextInfo:(void *)contextInfo
{
    if (error) {
        UIAlertView *alert = [[UIAlertView alloc]
                              initWithTitle: @"Save failed"
                              message: @"Failed to save image"
                              delegate: nil
                              cancelButtonTitle:@"OK"
                              otherButtonTitles:nil];
        [alert show];
    }
}

-(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

//Making a request to pull data from backend
//Data will be pulled everytime the messaging UI is displayed
//By:Edward Tam
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    
    self.tabBarController.navigationItem.title =@"Messaging";
    self.tabBarController.navigationItem.backBarButtonItem.title=@"Back";
    
    UIBarButtonItem *refresh = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"refresh.png"] style:UIBarButtonItemStylePlain target:self action:@selector(refreshChat)];
    
    
    [self.tabBarController.navigationItem setRightBarButtonItems:[NSArray arrayWithObjects: refresh, nil]];
    
}

- (void) refreshChat{
    int x = [bubbleData count];
    int count = 0;
    
    //bubbleData = nil;
    //bubbleData = [[NSMutableArray alloc]init];
    //[bubbleTable reloadData];
    
    NSLog(@"refreshing");
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_LOW, 0), ^{
        
        
        NSString * token = [[[NSUserDefaults standardUserDefaults] objectForKey:@"CurrentUser" ] valueForKey:@"token"];
        NSString *tra_id = [NSString stringWithFormat:@"%@",[[API sharedInstance] getTraineeInfo].trainee_id];
        NSDictionary *parameters = [[NSDictionary alloc] initWithObjects:[NSArray arrayWithObjects:tra_id, nil] forKeys:[NSArray arrayWithObjects:@"trainee_id", nil]];
        AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
        NSURLCredential *credential = [NSURLCredential credentialWithUser:token password:@"" persistence:NSURLCredentialPersistenceNone];
        [manager.requestSerializer setAuthorizationHeaderFieldWithUsername:token password:@""];
        NSMutableURLRequest *reqst = [manager.requestSerializer requestWithMethod:@"GET" URLString:@"https://cs477-backend.herokuapp.com/trainer/messages" parameters:parameters error:nil];
        AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:reqst];
        [operation setCredential:credential];
        [operation setResponseSerializer:[AFJSONResponseSerializer alloc]];
        [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
            NSLog(@"Success: %@", responseObject);
            
            NSDictionary *jsonDict = (NSDictionary *) responseObject;
            self.arr = [jsonDict objectForKey:@"message_list"];
            
            int num = [self.arr count];
            
            if(num <= x){
                //Don't need to do anything
            }
            else{
                [self.arr enumerateObjectsUsingBlock:^(id obj,NSUInteger idx, BOOL *stop){
                    //NSLog(@"index : %lu", (unsigned long)idx);
                    if((int)idx >= x){
                        if([[obj objectForKey:@"message_type"]  isEqual: @"text"]){
                            
                            NSString *textMsg = [obj objectForKey:@"content"];
                            NSNumber *val = [obj objectForKey:@"outgoing"];
                            BOOL i = [val boolValue];
                            //NSLog(@"Text: %@", textMsg);
                            
                            
                            NSNumber *time =[obj objectForKey:@"created_at"];
                            NSTimeInterval interval = [time doubleValue];
                            
                            if(i == 1){
                                NSBubbleData *sayBubble = [NSBubbleData dataWithText:textMsg date:[NSDate dateWithTimeIntervalSince1970:interval] type:BubbleTypeMine];
                                sayBubble.avatar = [UIImage imageNamed:@"pearsports.jpg"];
                                [bubbleData addObject:sayBubble];
                                [bubbleTable reloadData];
                                [bubbleTable scrollBubbleViewToBottomAnimated:NO];
                            }
                            else{
                                NSBubbleData *sayBubble = [NSBubbleData dataWithText:textMsg date:[NSDate dateWithTimeIntervalSince1970:interval] type:BubbleTypeSomeoneElse];
                                sayBubble.avatar = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:[[API sharedInstance] getTraineeInfo].imageName]]];;
                                [bubbleData addObject:sayBubble];
                                [bubbleTable reloadData];
                                [bubbleTable scrollBubbleViewToBottomAnimated:NO];
                            }
                            
                        }
                        else if([[obj objectForKey:@"message_type"]  isEqual: @"audio"]){
                            NSNumber *val = [obj objectForKey:@"outgoing"];
                            BOOL i = [val boolValue];
                            NSNumber *time =[obj objectForKey:@"created_at"];
                            NSTimeInterval interval = [time doubleValue];
                            
                            if(i == 1){
                                NSString *textMsg = [obj objectForKey:@"content"];
                                //NSLog(@"Audio: %@", textMsg);
                                
                                NSURL *sfURL = [[NSURL alloc] initWithString:textMsg];
                                
                                
                                NSBubbleData *audioBubble = [NSBubbleData dataWithURL:sfURL date:[NSDate dateWithTimeIntervalSince1970:interval] type:BubbleTypeMine];
                                audioBubble.avatar = [UIImage imageNamed:@"pearsports.jpg"];
                                [bubbleData addObject:audioBubble];
                                [bubbleTable reloadData];
                                [bubbleTable scrollBubbleViewToBottomAnimated:NO];
                            }
                            else{
                                NSString *textMsg = [obj objectForKey:@"content"];
                                //NSLog(@"Audio: %@", textMsg);
                                
                                NSURL *sfURL = [[NSURL alloc] initWithString:textMsg];
                                
                                NSBubbleData *audioBubble = [NSBubbleData dataWithURL:sfURL date:[NSDate dateWithTimeIntervalSince1970:interval] type:BubbleTypeSomeoneElse];
                                audioBubble.avatar = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:[[API sharedInstance] getTraineeInfo].imageName]]];
                                [bubbleData addObject:audioBubble];
                                [bubbleTable reloadData];
                                [bubbleTable scrollBubbleViewToBottomAnimated:NO];
                            }
                        }
                        else {
                            NSNumber *val = [obj objectForKey:@"outgoing"];
                            BOOL i = [val boolValue];
                            NSNumber *time =[obj objectForKey:@"created_at"];
                            NSTimeInterval interval = [time doubleValue];
                            
                            if(i == 1){
                                NSString *textMsg = [obj objectForKey:@"content"];
                                
                                NSURL *imageURL = [[NSURL alloc] initWithString:textMsg];
                                NSData *data = [NSData dataWithContentsOfURL:imageURL];
                                UIImage *img = [[UIImage alloc] initWithData:data];
                                //img = [self scaleAndRotateImage:img];

                                
                                NSBubbleData *imageBubble = [NSBubbleData dataWithImage:img date:[NSDate dateWithTimeIntervalSince1970:interval] type:BubbleTypeMine];
                                imageBubble.avatar = [UIImage imageNamed:@"pearsports.jpg"];
                                [bubbleData addObject:imageBubble];
                                [bubbleTable reloadData];
                                [bubbleTable scrollBubbleViewToBottomAnimated:NO];
                            }
                            else{
                                NSString *textMsg = [obj objectForKey:@"content"];
                                
                                NSURL *imageURL = [[NSURL alloc] initWithString:textMsg];
                                NSData *data = [NSData dataWithContentsOfURL:imageURL];
                                UIImage *img = [[UIImage alloc] initWithData:data];
                                
                                NSBubbleData *imageBubble = [NSBubbleData dataWithImage:img date:[NSDate dateWithTimeIntervalSince1970:interval] type:BubbleTypeSomeoneElse];
                                imageBubble.avatar = [UIImage imageNamed:@"pearsports.jpg"];
                                [bubbleData addObject:imageBubble];
                                [bubbleTable reloadData];
                                [bubbleTable scrollBubbleViewToBottomAnimated:NO];
                            }
                            
                        }
                    }
                    
                }];
            }
            dispatch_async(dispatch_get_main_queue(), ^{
                [MBProgressHUD hideHUDForView:self.view animated:YES];
            });
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            NSLog(@"Failure: %@", error);
            dispatch_async(dispatch_get_main_queue(), ^{
                [MBProgressHUD hideHUDForView:self.view animated:YES];
            });
            [self showLoadingError];
        }];
        
        //NSLog(@"OPERATION IS %@",operation);
        
        
        [manager.operationQueue addOperation:operation];
        
    });

}


-(void) showLoadingError
{
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"ERROR! Please check your internet connection!" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [alert setTag:12];
    [alert show];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    
    [textInputView setBackgroundColor:[UIColor groupTableViewBackgroundColor]];
    
    
    NSLog(@"TRainee name : %@ %@ %@ %@ %@ %@",[[API sharedInstance] getTraineeInfo].name,[[API sharedInstance] getTraineeInfo].age,[[API sharedInstance] getTraineeInfo].weight,[[API sharedInstance] getTraineeInfo].height,[[API sharedInstance] getTraineeInfo].gender,[[API sharedInstance] getTraineeInfo].trainee_id);
    
    // Do any additional setup after loading the view, typically from a nib.
    _audioSession = [AVAudioSession sharedInstance];
	[_audioSession setCategory:AVAudioSessionCategoryPlayAndRecord error: nil];
	[_audioSession setActive:YES error:nil];
    self.recording = NO;
    
    //BUBBLE
    
    NSBubbleData *heyBubble = [NSBubbleData dataWithText:@"Hi" date:[NSDate dateWithTimeIntervalSinceNow:-300] type:BubbleTypeSomeoneElse];
   
    heyBubble.avatar =  [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:[[API sharedInstance] getTraineeInfo].imageName]]];
    
    NSBubbleData *photoBubble = [NSBubbleData dataWithImage:[UIImage imageNamed:@"halloween.jpg"] date:[NSDate dateWithTimeIntervalSinceNow:-290] type:BubbleTypeSomeoneElse];
    photoBubble.avatar = [UIImage imageNamed:@"avatar1.png"];
    
    NSBubbleData *testBubble = [NSBubbleData dataWithText:@"Yay.." date:[NSDate dateWithTimeIntervalSinceNow:-300] type:BubbleTypeSomeoneElse];
    testBubble.avatar = [UIImage imageNamed:@"avatar1.png"];

    
    NSBubbleData *replyBubble = [NSBubbleData dataWithText:@"Wow.." date:[NSDate dateWithTimeIntervalSinceNow:-5] type:BubbleTypeMine];
    replyBubble.avatar = nil;
    
    bubbleData = [[NSMutableArray alloc] initWithObjects: nil];
 //   bubbleData = [ [NSMutableArray alloc] initWithObjects:heyBubble, nil];
    bubbleTable.bubbleDataSource = self;
    
    // The line below sets the snap interval in seconds. This defines how the bubbles will be grouped in time.
    // Interval of 300 means that if the next messages comes in 5 minutes since the last message, it will be added into the same group.
    // Groups are delimited with header which contains date and time for the first message in the group.
    
    bubbleTable.snapInterval = 300;
    
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
    
    //self.tabBarController.navigationItem.title =@"Messages";
    //[self.tabBarController.navigationItem setRightBarButtonItems:nil];
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_LOW, 0), ^{
    
    
    NSString * token = [[[NSUserDefaults standardUserDefaults] objectForKey:@"CurrentUser" ] valueForKey:@"token"];
    NSString *tra_id = [NSString stringWithFormat:@"%@",[[API sharedInstance] getTraineeInfo].trainee_id];
    NSDictionary *parameters = [[NSDictionary alloc] initWithObjects:[NSArray arrayWithObjects:tra_id, nil] forKeys:[NSArray arrayWithObjects:@"trainee_id", nil]];
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    NSURLCredential *credential = [NSURLCredential credentialWithUser:token password:@"" persistence:NSURLCredentialPersistenceNone];
    [manager.requestSerializer setAuthorizationHeaderFieldWithUsername:token password:@""];
    NSMutableURLRequest *reqst = [manager.requestSerializer requestWithMethod:@"GET" URLString:@"https://cs477-backend.herokuapp.com/trainer/messages" parameters:parameters error:nil];
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:reqst];
    [operation setCredential:credential];
    [operation setResponseSerializer:[AFJSONResponseSerializer alloc]];
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"Success: %@", responseObject);
        
        NSDictionary *jsonDict = (NSDictionary *) responseObject;
        self.arr = [jsonDict objectForKey:@"message_list"];
        
        [self.arr enumerateObjectsUsingBlock:^(id obj,NSUInteger idx, BOOL *stop){
            if([[obj objectForKey:@"message_type"]  isEqual: @"text"]){
                
                NSString *textMsg = [obj objectForKey:@"content"];
                NSNumber *val = [obj objectForKey:@"outgoing"];
                BOOL i = [val boolValue];
                //NSLog(@"Text: %@", textMsg);
                
                
                NSNumber *time =[obj objectForKey:@"created_at"];
                NSTimeInterval interval = [time doubleValue];
                
                if(i == 1){
                    NSBubbleData *sayBubble = [NSBubbleData dataWithText:textMsg date:[NSDate dateWithTimeIntervalSince1970:interval] type:BubbleTypeMine];
                    sayBubble.avatar = [UIImage imageNamed:@"pearsports.jpg"];
                    [bubbleData addObject:sayBubble];
                    [bubbleTable reloadData];
                    [bubbleTable scrollBubbleViewToBottomAnimated:NO];
                }
                else{
                    NSBubbleData *sayBubble = [NSBubbleData dataWithText:textMsg date:[NSDate dateWithTimeIntervalSince1970:interval] type:BubbleTypeSomeoneElse];
                    sayBubble.avatar = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:[[API sharedInstance] getTraineeInfo].imageName]]];
                    [bubbleData addObject:sayBubble];
                    [bubbleTable reloadData];
                    [bubbleTable scrollBubbleViewToBottomAnimated:NO];
                }
                
            }
            else if([[obj objectForKey:@"message_type"]  isEqual: @"audio"]){
                NSNumber *val = [obj objectForKey:@"outgoing"];
                BOOL i = [val boolValue];
                NSNumber *time =[obj objectForKey:@"created_at"];
                NSTimeInterval interval = [time doubleValue];
                
                if(i == 1){
                    NSString *textMsg = [obj objectForKey:@"content"];
                    //NSLog(@"Audio: %@", textMsg);
                    
                    NSURL *sfURL = [[NSURL alloc] initWithString:textMsg];
                    
                    
                    NSBubbleData *audioBubble = [NSBubbleData dataWithURL:sfURL date:[NSDate dateWithTimeIntervalSince1970:interval] type:BubbleTypeMine];
                    audioBubble.avatar = [UIImage imageNamed:@"pearsports.jpg"];
                    [bubbleData addObject:audioBubble];
                    [bubbleTable reloadData];
                    [bubbleTable scrollBubbleViewToBottomAnimated:NO];
                }
                else{
                    NSString *textMsg = [obj objectForKey:@"content"];
                    //NSLog(@"Audio: %@", textMsg);
                    
                    NSURL *sfURL = [[NSURL alloc] initWithString:textMsg];
                    
                    NSBubbleData *audioBubble = [NSBubbleData dataWithURL:sfURL date:[NSDate dateWithTimeIntervalSince1970:interval] type:BubbleTypeSomeoneElse];
                    audioBubble.avatar = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:[[API sharedInstance] getTraineeInfo].imageName]]];;
                    [bubbleData addObject:audioBubble];
                    [bubbleTable reloadData];
                    [bubbleTable scrollBubbleViewToBottomAnimated:NO];
                }
            }
            else {
                NSNumber *val = [obj objectForKey:@"outgoing"];
                BOOL i = [val boolValue];
                NSNumber *time =[obj objectForKey:@"created_at"];
                NSTimeInterval interval = [time doubleValue];
                
                if(i == 1){
                    NSString *textMsg = [obj objectForKey:@"content"];
                    
                    NSURL *imageURL = [[NSURL alloc] initWithString:textMsg];
                    NSData *data = [NSData dataWithContentsOfURL:imageURL];
                    UIImage *img = [[UIImage alloc] initWithData:data];
                    
                    NSBubbleData *imageBubble = [NSBubbleData dataWithImage:img date:[NSDate dateWithTimeIntervalSince1970:interval] type:BubbleTypeMine];
                    imageBubble.avatar = [UIImage imageNamed:@"pearsports.jpg"];
                    [bubbleData addObject:imageBubble];
                    [bubbleTable reloadData];
                    [bubbleTable scrollBubbleViewToBottomAnimated:NO];
                }
                else{
                    NSString *textMsg = [obj objectForKey:@"content"];
                    
                    NSURL *imageURL = [[NSURL alloc] initWithString:textMsg];
                    NSData *data = [NSData dataWithContentsOfURL:imageURL];
                    UIImage *img = [[UIImage alloc] initWithData:data];
                    
                    NSBubbleData *imageBubble = [NSBubbleData dataWithImage:img date:[NSDate dateWithTimeIntervalSince1970:interval] type:BubbleTypeSomeoneElse];
                    imageBubble.avatar = [UIImage imageNamed:@"pearsports.jpg"];
                    [bubbleData addObject:imageBubble];
                    [bubbleTable reloadData];
                    [bubbleTable scrollBubbleViewToBottomAnimated:NO];
                }
 
            }
        }];
        dispatch_async(dispatch_get_main_queue(), ^{
            [MBProgressHUD hideHUDForView:self.view animated:YES];
        });
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Failure: %@", error);
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [MBProgressHUD hideHUDForView:self.view animated:YES];
        });
        [self showLoadingError];
    }];
    
    //NSLog(@"OPERATION IS %@",operation);
    
    
    [manager.operationQueue addOperation:operation];
    
    });

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
        frame.origin.y -= 166;
        //frame.size.height -= kbSize.height-50;
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
        frame.origin.y += 166;
        //frame.size.height += kbSize.height-50;
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
    return [[formatter stringFromDate:[NSDate date]] stringByAppendingString:@".m4a"];
}

- (NSString *) dateString2
{
    // return a formatted string for a file name
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"ddMMMYY_hhmmssa";
    return [[formatter stringFromDate:[NSDate date]] stringByAppendingString:@".png"];
}


- (IBAction)recordVoice:(id)sender
{
    if(self.recording==NO){
        
        dirPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        docsDir = [dirPaths objectAtIndex:0];
        
        soundFilePath = [docsDir stringByAppendingPathComponent:[self dateString]];
        soundFileURL = [NSURL fileURLWithPath:soundFilePath];
        
        /*
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
                                        nil];*/
        
        NSDictionary *recordSettings = [NSDictionary dictionaryWithObjectsAndKeys:
                                        [NSNumber numberWithInt:kAudioFormatMPEG4AAC], AVFormatIDKey,
                                        [NSNumber numberWithFloat:44100.0], AVSampleRateKey,
                                        [NSNumber numberWithInt:1], AVNumberOfChannelsKey,
                                        [NSNumber numberWithInt:AVAudioQualityHigh], AVSampleRateConverterAudioQualityKey,
                                        [NSNumber numberWithInt:128000], AVEncoderBitRateKey,
                                        [NSNumber numberWithInt:16], AVEncoderBitDepthHintKey,
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
        
        [bubbleTable scrollBubbleViewToBottomAnimated:NO];
        
        
        
        NSString *token = [[[NSUserDefaults standardUserDefaults] objectForKey:@"CurrentUser" ] valueForKey:@"token"];
        NSString *tra_id = [NSString stringWithFormat:@"%@",[[API sharedInstance] getTraineeInfo].trainee_id];
        NSData *theData = [NSData dataWithContentsOfURL:soundFileURL];
        
        //NSDictionary *parameters = [[NSDictionary alloc] initWithObjects:[NSArray arrayWithObjects:tra_id, theData, nil] forKeys:[NSArray arrayWithObjects:@"trainee_id",@"content", nil]];
         NSDictionary *parameters = [[NSDictionary alloc] initWithObjects:[NSArray arrayWithObjects:tra_id, nil] forKeys:[NSArray arrayWithObjects:@"trainee_id", nil]];
        
        AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
        NSURLCredential *credential = [NSURLCredential credentialWithUser:token password:@"" persistence:NSURLCredentialPersistenceNone];
        
        [manager.requestSerializer setAuthorizationHeaderFieldWithUsername:token password:@""];
        
        NSMutableURLRequest *reqst = [manager.requestSerializer multipartFormRequestWithMethod:@"POST" URLString:@"https://cs477-backend.herokuapp.com/message/audio" parameters:parameters constructingBodyWithBlock: ^(id <AFMultipartFormData>formData){
            [formData appendPartWithFileData:theData name:@"content" fileName:[self dateString] mimeType:@"audio/m4a"];
        }];
        
        //NSMutableURLRequest *reqst = [manager.requestSerializer requestWithMethod:@"POST" URLString:@"https://cs477-backend.herokuapp.com/message/audio" parameters:parameters error:nil];
        
        AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:reqst];
        [operation setCredential:credential];
        [operation setResponseSerializer:[AFJSONResponseSerializer alloc]];
        [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
            NSLog(@"Success: %@", responseObject);
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            NSLog(@"Failure: %@", error);
            [self showLoadingError];
        }];
        
        NSLog(@"OPERATION IS %@",operation);
        
        [manager.operationQueue addOperation:operation];
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
        
       
        NSString *token = [[[NSUserDefaults standardUserDefaults] objectForKey:@"CurrentUser" ] valueForKey:@"token"];
        NSString *tra_id = [NSString stringWithFormat:@"%@",[[API sharedInstance] getTraineeInfo].trainee_id];
        NSString *message = textField.text;
        
        NSDictionary *parameters = [[NSDictionary alloc] initWithObjects:[NSArray arrayWithObjects:tra_id,message, nil] forKeys:[NSArray arrayWithObjects:@"trainee_id",@"content", nil]];
        
        AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
        NSURLCredential *credential = [NSURLCredential credentialWithUser:token password:@"" persistence:NSURLCredentialPersistenceNone];
        
        [manager.requestSerializer setAuthorizationHeaderFieldWithUsername:token password:@""];
        //[manager.requestSerializer setAuthorizationHeaderFieldWithUsername:@"daniel@somefakeemail.com" password:@"password1"];
        
        NSMutableURLRequest *reqst = [manager.requestSerializer requestWithMethod:@"POST" URLString:@"https://cs477-backend.herokuapp.com/message/text" parameters:parameters error:nil];

        AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:reqst];
        [operation setCredential:credential];
        [operation setResponseSerializer:[AFJSONResponseSerializer alloc]];
        [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
            NSLog(@"Success: %@", responseObject);
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            NSLog(@"Failure: %@", error);
            [self showLoadingError];
        }];
        
        NSLog(@"OPERATION IS %@",operation);
        
        [manager.operationQueue addOperation:operation];
        
    }
   
    
    textField.text = @"";
    [textField resignFirstResponder];
    [bubbleTable scrollBubbleViewToBottomAnimated:NO];
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
