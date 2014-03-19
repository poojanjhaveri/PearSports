//
//  MyButton.m
//  Message
//
//  Created by Elsen Wiraatmadja on 2/3/14.
//  Copyright (c) 2014 Elsen Wiraatmadja. All rights reserved.
//

#import "MyButton.h"

@implementation MyButton

@synthesize audioUrl = _audioUrl;
@synthesize serverAudio = _serverAudio;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

-(void) setURL:(NSURL *)url{
    self.audioUrl = url;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
