//
//  NSBubbleData.m
//
//  Created by Alex Barinov
//  Project home page: http://alexbarinov.github.com/UIBubbleTableView/
//
//  This work is licensed under the Creative Commons Attribution-ShareAlike 3.0 Unported License.
//  To view a copy of this license, visit http://creativecommons.org/licenses/by-sa/3.0/
//

#import "NSBubbleData.h"
#import <QuartzCore/QuartzCore.h>

@implementation NSBubbleData

#pragma mark - Properties

@synthesize date = _date;
@synthesize type = _type;
@synthesize view = _view;
@synthesize insets = _insets;
@synthesize avatar = _avatar;

#pragma mark - Lifecycle

#if !__has_feature(objc_arc)
- (void)dealloc
{
    [_date release];
	_date = nil;
    [_view release];
    _view = nil;
    
    self.avatar = nil;

    [super dealloc];
}
#endif

#pragma mark - Text bubble

const UIEdgeInsets textInsetsMine = {5, 10, 11, 17};
const UIEdgeInsets textInsetsSomeone = {5, 15, 11, 10};


//EDITTTTTTTTT

//RECORDED AUDIO
+ (id)dataWithData:(NSURL *)data date:(NSDate *)date type:(NSBubbleType)type
{
#if !__has_feature(objc_arc)
    return [[[NSBubbleData alloc] initWithData:data date:date type:type] autorelease];
#else
    return [[NSBubbleData alloc] initWithData:data date:date type:type];
#endif
}

//SERVER AUDIO
+ (id)dataWithURL:(NSURL *)data date:(NSDate *)date type:(NSBubbleType)type
{
#if !__has_feature(objc_arc)
    return [[[NSBubbleData alloc] initWithURL:data date:date type:type] autorelease];
#else
    return [[NSBubbleData alloc] initWithURL:data date:date type:type];
#endif
}

//RECORDED AUDIO
- (id)initWithData:(NSURL *)data date:(NSDate *)date type:(NSBubbleType)type
{
    CGSize size;
    size.width = 50;
    size.height = 50;

    MyButton *buttonView = [[MyButton alloc] initWithFrame:CGRectMake(0, 0, size.width, size.height)];
    UIImage* infobuttonImg =[UIImage imageNamed:@"audio_basic.png"];
    [buttonView setImage:infobuttonImg forState:UIControlStateNormal];
    [buttonView setURL:data];
    [buttonView addTarget:self action:@selector(btnClicked:) forControlEvents:UIControlEventTouchUpInside];
    buttonView.serverAudio = NO;
    
#if !__has_feature(objc_arc)
    [buttonView autorelease];
#endif
    
    UIEdgeInsets insets = (type == BubbleTypeMine ? imageInsetsMine : imageInsetsSomeone);
    return [self initWithView:buttonView date:date type:type insets:insets];
}

//SERVER AUDIO
- (id)initWithURL:(NSURL *)data date:(NSDate *)date type:(NSBubbleType)type
{
    CGSize size;
    size.width = 50;
    size.height = 50;
    
    MyButton *buttonView = [[MyButton alloc] initWithFrame:CGRectMake(0, 0, size.width, size.height)];
    UIImage* infobuttonImg =[UIImage imageNamed:@"audio_basic.png"];
    [buttonView setImage:infobuttonImg forState:UIControlStateNormal];
    [buttonView setURL:data];
    [buttonView addTarget:self action:@selector(btnClicked:) forControlEvents:UIControlEventTouchUpInside];
    buttonView.serverAudio = YES;
    
#if !__has_feature(objc_arc)
    [buttonView autorelease];
#endif
    
    UIEdgeInsets insets = (type == BubbleTypeMine ? imageInsetsMine : imageInsetsSomeone);
    return [self initWithView:buttonView date:date type:type insets:insets];
}

-(void)btnClicked:(id)sender {
    MyButton *buttonClicked = (MyButton *)sender;
    //NSLog(@"clicked %@", buttonClicked.audioUrl);
    
    _audioSession = [AVAudioSession sharedInstance];
	[_audioSession setCategory:AVAudioSessionCategoryPlayAndRecord error: nil];
	[_audioSession setActive:YES error:nil];

    if(buttonClicked.serverAudio == YES){
        NSData *_objectData = [NSData dataWithContentsOfURL:buttonClicked.audioUrl];
        NSError *error;
        
        self.audioPlayer = [[AVAudioPlayer alloc] initWithData:_objectData error:&error];
        self.audioPlayer.numberOfLoops = 0;
        self.audioPlayer.volume = 25.0f;
        [self.audioPlayer prepareToPlay];
        
        if (self.audioPlayer == nil)
            NSLog(@"%@", [error description]);
        else
            [self.audioPlayer play];
    }
    else{
        
         NSArray *dirPaths;
         NSString *docsDir;
         
         dirPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
         docsDir = [dirPaths objectAtIndex:0];
         
         NSURL *url = buttonClicked.audioUrl;
         
         NSError *error;
         
         _audioPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:url error:&error];
         _audioPlayer.delegate = self;
        self.audioPlayer.numberOfLoops = 0;
        self.audioPlayer.volume = 25.0f;
         [_audioPlayer prepareToPlay];
         
         if (error)
         NSLog(@"Error: %@",[error localizedDescription]);
         else
         [_audioPlayer play];
         
    }
    
}

-(void)audioPlayerDidFinishPlaying:
(AVAudioPlayer *)player successfully:(BOOL)flag
{
    //NSLog(@"finished");
}

//////////////////////////////////////////

+ (id)dataWithText:(NSString *)text date:(NSDate *)date type:(NSBubbleType)type
{
#if !__has_feature(objc_arc)
    return [[[NSBubbleData alloc] initWithText:text date:date type:type] autorelease];
#else
    return [[NSBubbleData alloc] initWithText:text date:date type:type];
#endif    
}

- (id)initWithText:(NSString *)text date:(NSDate *)date type:(NSBubbleType)type
{
    UIFont *font = [UIFont systemFontOfSize:[UIFont systemFontSize]];
    CGSize size = [(text ? text : @"") sizeWithFont:font constrainedToSize:CGSizeMake(220, 9999) lineBreakMode:NSLineBreakByWordWrapping];
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, size.width, size.height)];
    label.numberOfLines = 0;
    label.lineBreakMode = NSLineBreakByWordWrapping;
    label.text = (text ? text : @"");
    label.font = font;
    label.backgroundColor = [UIColor clearColor];
    
#if !__has_feature(objc_arc)
    [label autorelease];
#endif
    
    UIEdgeInsets insets = (type == BubbleTypeMine ? textInsetsMine : textInsetsSomeone);
    return [self initWithView:label date:date type:type insets:insets];
}

#pragma mark - Image bubble

const UIEdgeInsets imageInsetsMine = {11, 13, 16, 22};
const UIEdgeInsets imageInsetsSomeone = {11, 18, 16, 14};


+ (id)dataWithImage:(UIImage *)image date:(NSDate *)date type:(NSBubbleType)type
{
#if !__has_feature(objc_arc)
    return [[[NSBubbleData alloc] initWithImage:image date:date type:type] autorelease];
#else
    return [[NSBubbleData alloc] initWithImage:image date:date type:type];
#endif    
}

- (id)initWithImage:(UIImage *)image date:(NSDate *)date type:(NSBubbleType)type
{
    CGSize size = image.size;
    if (size.width > 170)
    {
        size.height /= (size.width / 170);
        size.width = 170;
    }
    
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, size.width, size.height)];
    imageView.image = image;
    imageView.layer.cornerRadius = 5.0;
    imageView.layer.masksToBounds = YES;

    
#if !__has_feature(objc_arc)
    [imageView autorelease];
#endif
    
    UIEdgeInsets insets = (type == BubbleTypeMine ? imageInsetsMine : imageInsetsSomeone);
    return [self initWithView:imageView date:date type:type insets:insets];       
}

#pragma mark - Custom view bubble

+ (id)dataWithView:(UIView *)view date:(NSDate *)date type:(NSBubbleType)type insets:(UIEdgeInsets)insets
{
#if !__has_feature(objc_arc)
    return [[[NSBubbleData alloc] initWithView:view date:date type:type insets:insets] autorelease];
#else
    return [[NSBubbleData alloc] initWithView:view date:date type:type insets:insets];
#endif    
}

- (id)initWithView:(UIView *)view date:(NSDate *)date type:(NSBubbleType)type insets:(UIEdgeInsets)insets  
{
    self = [super init];
    if (self)
    {
#if !__has_feature(objc_arc)
        _view = [view retain];
        _date = [date retain];
#else
        _view = view;
        _date = date;
#endif
        _type = type;
        _insets = insets;
    }
    return self;
}

@end
