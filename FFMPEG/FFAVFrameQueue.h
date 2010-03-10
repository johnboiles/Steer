//
//  FFAVFrameQueue.h
//  FFMPEG
//
//  Created by Gabriel Handford on 3/8/10.
//  Copyright 2010. All rights reserved.
//

#import "FFPlayer.h"

@interface FFAVFrameQueue : NSObject {
  FFPlayer *_player;
  
  NSLock *_lock;
  
  NSURL *_URL;
  NSString *_format;
  
  AVFrame *_frame;
  NSInteger _frameIndex;
  NSInteger _readFrameIndex;
  
  uint8_t *_videoData;
  int _videoDataSize;
}

@property (readonly) FFPlayer *player;

- (id)initWithURL:(NSURL *)URL format:(NSString *)format;

- (AVFrame *)next;

- (uint8_t *)nextData;

@end
