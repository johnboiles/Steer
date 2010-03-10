//
//  FFPlayerView.m
//  Steer
//
//  Created by Gabriel Handford on 3/10/10.
//  Copyright 2010. All rights reserved.
//

#import "FFPlayerView.h"

#import "FFAVFrameQueue.h"
#import "FFGLDrawable.h"
#import "FFNotifications.h"
#import "FFDefines.h"

@implementation FFPlayerView

- (id)init {
  if ((self = [super init])) {
    self.frame = CGRectMake(0, 0, 320, 480);
    
    /*!
    _displayLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 320, 30)];
    _displayLabel.textColor = [UIColor whiteColor];
    _displayLabel.backgroundColor = [UIColor blackColor];
    _displayLabel.font = [UIFont fontWithName:@"Helvetica" size:14];
    [self addSubview:_displayLabel];
     */
  
    //NSString *URLString = @"http://193.138.213.169/nphMotionJpeg?Resolution=160x120&Quality=Mobile";  
    //NSString *URLString = @"http://camera.kkbtv.com:8080/nphMotionJpeg?Resolution=320x240&Quality=Motion";  
    //NSString *URLString = @"http://bridgecam2.halton.gov.uk/mjpg/video.mjpg";
    
    NSString *URLString = @"http://wificar:carwifi@192.168.1.253/nphMotionJpeg?Resolution=160x120&Quality=Mobile";
    NSString *format = @"mjpeg";
    NSURL *URL = [NSURL URLWithString:URLString];
    
    FFAVFrameQueue *frameQueue = [[FFAVFrameQueue alloc] initWithURL:URL format:format];  
    FFGLDrawable *drawable = [[FFGLDrawable alloc] initWithFrameQueue:frameQueue];
    [frameQueue release];
    self.drawable = drawable;
    [drawable release];
    [self setAnimationInterval:(1.0 / 10.0)];  
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(_onDisplay:) name:FFDisplayNotification object:nil];    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(_onOpen) name:FFOpenNotification object:nil];
  }
  return self;
}

- (void)dealloc {
  [[NSNotificationCenter defaultCenter] removeObserver:self];
  [_displayLabel release];
  [super dealloc];
}

- (void)_onDisplay:(NSNotification *)notification {
  NSString *text = [notification object];
  FFDebug(@"%@", text);
  _displayLabel.text = text;
}

- (void)_onOpen {
  
}

- (void)start {
  [self startAnimation];
}

@end
