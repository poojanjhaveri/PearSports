//
//  ViewController.h
//
//  Created by Alex Barinov
//  Project home page: http://alexbarinov.github.com/UIBubbleTableView/
//
//  This work is licensed under the Creative Commons Attribution-ShareAlike 3.0 Unported License.
//  To view a copy of this license, visit http://creativecommons.org/licenses/by-sa/3.0/
//

#import <UIKit/UIKit.h>
#import "UIBubbleTableViewDataSource.h"
#import <AVFoundation/AVFoundation.h>
#import <CoreGraphics/CoreGraphics.h>
#import <MobileCoreServices/MobileCoreServices.h>

@interface EWViewController : UIViewController <UIBubbleTableViewDataSource, AVAudioRecorderDelegate, AVAudioPlayerDelegate, UIActionSheetDelegate,UIImagePickerControllerDelegate, UINavigationControllerDelegate>

@property (strong, nonatomic) AVAudioRecorder *audioRecorder;
@property (strong, nonatomic) AVAudioPlayer *audioPlayer;
@property (strong, nonatomic) AVAudioSession *audioSession;
@property (nonatomic, assign) BOOL recording;
@property (strong, nonatomic) NSArray *arr;
@property (strong, nonatomic) UIImage *selectedImage;
@property (strong) UIActivityIndicatorView * activityIndicator;
@property BOOL newMedia;

@property(nonatomic,retain)IBOutlet UIImageView *imageView;


- (IBAction)recordVoice:(id)sender;
- (NSString*) dateString;

@end
