//
//  FFPlayer.h
//  FFMPEG
//
//  Created by Gabriel Handford on 3/6/10.
//  Copyright 2010. All rights reserved.
//

#include "libavutil/avstring.h"
#include "libavutil/pixdesc.h"
#include "libavformat/avformat.h"
#include "libavdevice/avdevice.h"
#include "libswscale/swscale.h"
#include "libavcodec/audioconvert.h"
#include "libavcodec/colorspace.h"
#include "libavcodec/opt.h"
#include "libavcodec/dsputil.h"

#import <libswscale/swscale.h>

@interface FFPlayer : NSObject {
  AVFormatContext *_formatContext;
  AVFrame *_frame;
  AVFrame *_destFrame;
  
  AVStream *_videoStream;
  
  uint8_t *_videoBuffer;  
  
  enum PixelFormat _pixelFormat;
  
  int _width;
  int _height;
  
  BOOL _open;
}

@property (readonly, nonatomic) int width;
@property (readonly, nonatomic) int height;
@property (readonly, nonatomic, getter=isOpen) BOOL open;

- (id)initWithWidth:(int)width height:(int)height pixelFormat:(enum PixelFormat)pixelFormat;

- (BOOL)openWithURL:(NSURL *)URL format:(NSString *)format error:(NSError **)error;

- (AVFrame *)readFrame:(NSError **)error;

- (void)close;

@end
