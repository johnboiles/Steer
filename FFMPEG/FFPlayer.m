//
//  FFPlayer.m
//  FFMPEG
//
//  Created by Gabriel Handford on 3/6/10.
//  Copyright 2010. All rights reserved.
//

#import "FFPlayer.h"
#import "FFDefines.h"

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
    if (avformat == NULL) FFSetError(@"Couldn't find specified format", error, 5);
  }
  
  FFDebug(@"Opening: %@", path);
  if (av_open_input_file(&_formatContext, [path UTF8String], avformat, 0, NULL) != 0) {
    FFSetError(@"Failed to open file", error, 10);
    return NO;
  }
  
  if (av_find_stream_info(_formatContext) < 0) {
    av_close_input_file(_formatContext);
    FFSetError(@"Failed to find stream info", error, 20);
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
    FFSetError(@"Couldn't find video stream", error, 30);
    return NO;
  }
  
  FFDebug(@"Finding codec");
  AVCodec *codec = avcodec_find_decoder(_videoStream->codec->codec_id);
  if (!codec) {
    FFSetError(@"Codec not found for video stream", error, 40);
    return NO;
  }
  
  if (avcodec_open(_videoStream->codec, codec) < 0) {
    FFSetError(@"Codec open failed for video stream", error, 41);
    return NO;
  }
  
  // Frame decoded from video stream (before conversion)
  _frame = avcodec_alloc_frame();
  if (_frame == NULL) {
    FFSetError(@"Couldn't allocate frame", error, 50);
    return NO;
  }  
  
  // Frame after scaling and converting pixel format
  _destFrame = avcodec_alloc_frame();
  if (_destFrame == NULL) {
    FFSetError(@"Couldn't allocate destination frame", error, 51);
    return NO;
  }  
  
  // Video buffer
  int bytes = avpicture_get_size(_pixelFormat, _width, _height);		
  _videoBuffer = (uint8_t*)av_malloc(bytes * sizeof(uint8_t));
  if (_videoBuffer == NULL) {
    FFSetError(@"Couldn't allocate video buffer", error, 60);
    return NO;
  }
  
  // Assign video buffer to dest frame
  avpicture_fill((AVPicture *)_destFrame, _videoBuffer, _pixelFormat, _width, _height);

  FFDebug(@"Opened");
  _open = YES;
  return YES;
}

- (AVFrame *)readFrame:(NSError **)error {
  
  // Read the packet
  AVPacket packet;
  if (av_read_frame(_formatContext, &packet) < 0) { 
    FFSetError(@"Failed to read frame", error, 100);
    return NULL;
  }
    
  //FFDebug(@"Packet size: %d", packet.size);
    
  // Ignore packet if not part of our video stream
  if (packet.stream_index != _videoStream->index) {
    FFDebug(@"Packet not part of video stream");
    return NULL;
  }
    
  // If flush packet, flush and continue
  if (packet.data == gFlushPacket.data) {
    FFDebug(@"avcodec_flush_buffers");
    avcodec_flush_buffers(_videoStream->codec);
    return NULL;
  }
    
  // Decode the frame (from the packet)
  int gotFrame = 0;
  int bytesDecoded = avcodec_decode_video2(_videoStream->codec, _frame, &gotFrame, &packet);
  //FFDebug(@"Decoded %d", bytesDecoded);    
  av_free_packet(&packet);
  
  if (bytesDecoded < 0) {
    FFSetError(@"Error while decoding frame", error, 110);
    return NULL;
  }
  
  if (!gotFrame) {
    FFSetError(@"Incomplete decoded frame", error, 120);
    return NULL;
  }    
  
  // Scale the frame into destFrame
  int videoWidth = _videoStream->codec->coded_width;
  int videoHeight = _videoStream->codec->coded_height;
  gScaleContext = sws_getCachedContext(gScaleContext, 
                                       videoWidth, videoHeight, _videoStream->codec->pix_fmt, 
                                       _width, _height, _pixelFormat, 
                                       SWS_BICUBIC, NULL, NULL, NULL);
  
  if (gScaleContext == NULL) {
    FFSetError(@"Failed to read frame", error, 100);
    return NULL;
  }
  
  sws_scale(gScaleContext, _frame->data, _frame->linesize, 0,
            _height, _destFrame->data, _destFrame->linesize);
      
  return _destFrame;
}

- (void)close {
  if (_frame) av_free(_frame);
  _frame = NULL;
  if (_formatContext) av_close_input_file(_formatContext);
  _formatContext = NULL;
  if (_videoBuffer) av_free(_videoBuffer);
  _videoBuffer = NULL;  
  if (_destFrame) av_free(_destFrame);
  _destFrame = NULL;
  _open = NO;
}

@end
