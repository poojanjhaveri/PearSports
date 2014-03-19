//
//  MyButton.h
//  Message
//
//  Created by Elsen Wiraatmadja on 2/3/14.
//  Copyright (c) 2014 Elsen Wiraatmadja. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MyButton : UIButton{
    NSURL *_audioUrl;
    BOOL serverAudio;
}
@property (nonatomic, retain) NSURL *audioUrl;
@property (assign) BOOL serverAudio;

-(void) setURL:(NSURL *)url;

@end
