//
//  FFPlayer.m
//  FFMPEG
//
//  Created by Gabriel Handford on 3/6/10.
//  Copyright 2010. All rights reserved.
//

#import "FFPlayer.h"
#import "FFDefines.h"
#import "FFNotifications.h"

static AVPacket gFlushPacket;

struct SwsContext *gScaleContext = NULL;

@implementation FFPlayer

@synthesize width=_width, height=_height, open=_open;

+ (void)initialize {  
  av_register_all();
  
  av_init_packet(&gFlushPacket);
  gFlushPacket.data = (uint8_t*)"FLUSH";
}

- (id)init {
  return [self initWithWidth:320 height:240 pixelFormat:PIX_FMT_RGB24];
}

- (id)initWithWidth:(int)width height:(int)height pixelFormat:(enum PixelFormat)pixelFormat {
  if ((self = [super init])) {
    _width = width;
    _height = height;
    _pixelFormat = pixelFormat;
  }
  return self;
}

- (void)dealloc {
  [self close];
  [super dealloc];
}

- (BOOL)openWithURL:(NSURL *)URL format:(NSString *)format error:(NSError **)error {
  NSParameterAssert(URL);
  
  NSString *path;
  if ([URL isFileURL]) path = [URL path];
  else path = [URL absoluteString];
  
  AVInputFormat *avformat = NULL;
  if (format) {
    avformat = av_find_input_format([format UTF8String]);
    if (avformat == NULL) FFSetError(error, 5, @"Couldn't find specified format");
    else FFDebug(@"Format: %s (flags=%x)", avformat->long_name, avformat->flags);
  }

  FFDisplay(@"Opening: %@", path);
  int averror = av_open_input_file(&_formatContext, [path UTF8String], avformat, 0, NULL);
  if (averror != 0) {
    FFSetError(error, 10, @"Failed to open: %d", averror);
    FFDisplay(@"Failed to open: %d", averror);
    return NO;
  }
  
  _formatContext->flags = AVFMT_FLAG_NONBLOCK;
  _formatContext->max_analyze_duration = 1 * AV_TIME_BASE;
  _formatContext->max_delay = 0;
  _formatContext->preload = 0;
  FFDebug(@"Format context flags: %x", _formatContext->flags);
  FFDebug(@"Format max analyze flag: %d", _formatContext->max_analyze_duration);
  
  FFDebug(@"Find stream info");
  averror = av_find_stream_info(_formatContext);
  if (averror < 0) {
    av_close_input_file(_formatContext);
    FFSetError(error, 20, @"Failed to find stream info");
    return NO;
  }
    
  // Find video stream
  _videoStream = NULL;
  for (int i = 0; i < _formatContext->nb_streams; i++) {
    AVStream *stream = _formatContext->streams[i];
    FFDebug(@"Stream codec type: %d", stream->codec->codec_type);
    if (stream->codec->codec_type == CODEC_TYPE_VIDEO) {
      _videoStream = stream;      
    }
  }
  if (_videoStream == NULL) {
    FFSetError(error, 30, @"Couldn't find video stream");
    return NO;
  }
  
  FFDebug(@"Finding codec");
  AVCodec *codec = avcodec_find_decoder(_videoStream->codec->codec_id);
  if (!codec) {
    FFSetError(error, 40, @"Codec not found for video stream");
    return NO;
  }
  
  if (avcodec_open(_videoStream->codec, codec) < 0) {
    FFSetError(error, 41, @"Codec open failed for video stream");
    return NO;
  }
  
  // Frame after scaling and converting pixel format
  _destFrame = avcodec_alloc_frame();
  if (_destFrame == NULL) {
    FFSetError(error, 51, @"Couldn't allocate destination frame");
    return NO;
  }  
  
  // Video buffer
  int bytes = avpicture_get_size(_pixelFormat, _width, _height);		
  _videoBuffer = (uint8_t*)av_malloc(bytes * sizeof(uint8_t));
  if (_videoBuffer == NULL) {
    FFSetError(error, 60, @"Couldn't allocate video buffer");
    return NO;
  }
  
  // Assign video buffer to dest frame
  avpicture_fill((AVPicture *)_destFrame, _videoBuffer, _pixelFormat, _width, _height);

  [self performSelectorOnMainThread:@selector(_notifyOpened) withObject:nil waitUntilDone:NO];
    
  _open = YES;
  FFDebug(@"Opened");
  return YES;
}

- (void)_notifyOpened {
  [[NSNotificationCenter defaultCenter] postNotificationName:FFOpenNotification object:nil];
}

- (int)bufferLength {
  return avpicture_get_size(_pixelFormat, _width, _height);
}

- (BOOL)readFrame:(AVFrame *)frame error:(NSError **)error {
  
  AVPacket packet;
  
  // Read the packet
  if (av_read_frame(_formatContext, &packet) < 0) { 
    FFSetError(error, 100, @"Failed to read frame");
    return NO;
  }
  
  //FFDebug(@"Packet size: %d", packet->size);
  
  // Ignore packet if not part of our video stream
  if (packet.stream_index != _videoStream->index) {
    FFDebug(@"Packet not part of video stream");
    return NO;
  }
  
  // If flush packet, flush and continue
  if (packet.data == gFlushPacket.data) {
    FFDebug(@"avcodec_flush_buffers");
    avcodec_flush_buffers(_videoStream->codec);
    return NO;
  }
  
  // Decode the frame (from the packet)
  int gotFrame = 0;
  int bytesDecoded = avcodec_decode_video2(_videoStream->codec, frame, &gotFrame, &packet);
  //FFDebug(@"Decoded %d", bytesDecoded);
  
  av_free_packet(&packet);
  
  if (bytesDecoded < 0) {
    FFSetError(error, 110, @"Error while decoding frame");
    return NO;
  }
  
  if (!gotFrame) {
    FFSetError(error, 120, @"Incomplete decoded frame");
    return NO;
  }  

  return YES;
}

- (AVFrame *)scaleFrame:(AVFrame *)frame error:(NSError **)error {
    
      
  // Scale the frame into destFrame
  int videoWidth = _videoStream->codec->coded_width;
  int videoHeight = _videoStream->codec->coded_height;
  gScaleContext = sws_getCachedContext(gScaleContext, 
                                       videoWidth, videoHeight, _videoStream->codec->pix_fmt, 
                                       _width, _height, _pixelFormat, 
                                       SWS_BICUBIC, NULL, NULL, NULL);
  
  if (gScaleContext == NULL) {
    FFSetError(error, 100, @"Failed to read frame");
    return NULL;
  }
  
  sws_scale(gScaleContext, frame->data, frame->linesize, 0,
            _height, _destFrame->data, _destFrame->linesize);
      
  return _destFrame;
}

- (void)close {
  if (_formatContext != NULL) av_close_input_file(_formatContext);
  _formatContext = NULL;
  if (_destFrame != NULL) av_free(_destFrame);
  _destFrame = NULL;
  if (_videoBuffer != NULL) av_free(_videoBuffer);
  _videoBuffer = NULL;  
  _open = NO;
}

@end
