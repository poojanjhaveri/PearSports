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
}
@property (nonatomic, retain) NSURL *audioUrl;

-(void) setURL:(NSURL *)url;


@end
