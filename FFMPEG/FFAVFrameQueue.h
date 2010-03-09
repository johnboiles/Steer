//
//  FFAVFrameQueue.h
//  FFMPEG
//
//  Created by Gabriel Handford on 3/8/10.
//  Copyright 2010 Yelp. All rights reserved.
//

#import "FFPlayer.h"

@interface FFAVFrameQueue : NSObject {
  FFPlayer *_player;
  
  NSURL *_URL;
  NSString *_format;
}

@property (readonly) FFPlayer *player;

- (id)initWithURL:(NSURL *)URL format:(NSString *)format;

- (AVFrame *)next;

@end
