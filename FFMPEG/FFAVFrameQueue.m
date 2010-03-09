//
//  FFAVFrameQueue.m
//  FFMPEG
//
//  Created by Gabriel Handford on 3/8/10.
//  Copyright 2010 Yelp. All rights reserved.
//

#import "FFAVFrameQueue.h"


@implementation FFAVFrameQueue

@synthesize player=_player;

- (id)initWithURL:(NSURL *)URL format:(NSString *)format {
  if ((self = [self init])) {
    _URL = [URL retain];
    _format = [format retain];
  }
  return self;
}

- (void)dealloc {
  [_player release];
  [_URL release];
  [_format release];
  [super dealloc];
}

- (void)_loadPlayer {
  NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
  
  // TODO(gabe): Must be power of 2 for texture
  FFPlayer *player = [[FFPlayer alloc] initWithWidth:256 height:256 pixelFormat:PIX_FMT_RGB24];
  
  if (![player openWithURL:_URL format:_format error:nil]) {
    [NSException raise:NSInternalInconsistencyException format:@"Couldn't open with player"];
  }
     
  [pool release];
  _player = player;
}

- (AVFrame *)next {
  static BOOL loadedPlayer = NO;
  if (!loadedPlayer) {
    loadedPlayer = YES;
    [NSThread detachNewThreadSelector:@selector(_loadPlayer) toTarget:self withObject:nil];      
  }
  
  if (![_player isOpen]) return NULL;
  
  return [_player readFrame:nil]; 
}

@end
