//
//  FFMPEGAppDelegate.m
//  FFMPEG
//
//  Created by Gabriel Handford on 3/4/10.
//  Copyright 2010. All rights reserved.
//

#import "FFMPEGAppDelegate.h"

#import "FFGLDrawable.h"
//#import "FFGLTestDrawable.h"

@implementation FFMPEGAppDelegate

- (void)dealloc {
	[_window release];
	[_GLViewController release];	
  [_frameQueue dealloc];
	[super dealloc];
}

- (void)applicationDidFinishLaunching:(UIApplication *)application { 
  [UIApplication sharedApplication].statusBarHidden = YES;
  
  _window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
  
  //NSURL *URL = [NSURL fileURLWithPath:[[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"dancing.avi"]];
  
  NSString *testURLString = @"http://bridgecam2.halton.gov.uk/mjpg/video.mjpg";  
  //NSString *testURLString = @"http://monet-n-sky.as.utexas.edu/mjpg/video.mjpg";
  //NSString *testURLString = @"mms://NZPWMserver1.si.edu/CLC7538a79sbc60ea";
  //NSString *testURLString = @"http://wificar:carwifi@192.168.1.253/nphMotionJpeg?Resolution=320x240&Quality=Standard";
  NSURL *URL = [NSURL URLWithString:testURLString];
  
	//FFGLTestDrawable *GLDrawable = [[[FFGLTestDrawable alloc] init] autorelease];
    
  _frameQueue = [[FFAVFrameQueue alloc] initWithURL:URL format:nil];

  FFGLDrawable *GLDrawable = [[[FFGLDrawable alloc] initWithFrameQueue:_frameQueue] autorelease];
	_GLViewController = [[GHGLViewController alloc] initWithDrawable:GLDrawable];
  [_GLViewController.GLView setAnimationInterval:(1.0 / 10.0)];
	[_window addSubview:_GLViewController.view];
	[_window makeKeyAndVisible];
	[_GLViewController.GLView startAnimation];
}

- (void)applicationWillResignActive:(UIApplication *)application {
	[_GLViewController.GLView stopAnimation];
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
	[_GLViewController.GLView startAnimation];
}

- (void)applicationWillTerminate:(UIApplication *)application {
	[_GLViewController.GLView stopAnimation];
}

@end
