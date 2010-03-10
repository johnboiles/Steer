//
//  SteerAppDelegate.m
//  Steer
//
//  Created by John Boiles on 3/6/10.
//  Copyright __MyCompanyName__ 2010. All rights reserved.
//

#import "SteerAppDelegate.h"
#import "DualJoystickViewController.h"
#import "AccelerometerViewController.h"
#import "MainConfigurationViewController.h"
#import "SharedSettings.h"

#import "GHGLView.h"
#import "FFAVFrameQueue.h"
#import "FFGLDrawable.h"

@implementation SteerAppDelegate

@synthesize window=_window;

- (void)applicationDidFinishLaunching:(UIApplication *)application {    
  [[SharedSettings sharedManager] retrieveDefaults];
  
  _window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];

  // Hide the status bar
  [UIApplication sharedApplication].statusBarHidden = YES;
  
  //DualJoystickViewController *dualJoystickViewController = [[DualJoystickViewController alloc] init];
  //[_window addSubview:[dualJoystickViewController view]];


  
  GHGLView *GLView = [[GHGLView alloc] init];
  GLView.frame = CGRectMake(0, 0, 320, 480);

  NSString *URLString = @"http://bridgecam2.halton.gov.uk/mjpg/video.mjpg";  
  //NSString *URLString = @"http://wificar:carwifi@192.168.1.253/nphMotionJpeg?Resolution=320x240&Quality=Motion";
  NSString *format = @"mjpeg";
  NSURL *URL = [NSURL URLWithString:URLString];
  FFAVFrameQueue *frameQueue = [[FFAVFrameQueue alloc] initWithURL:URL format:format];  
  FFGLDrawable *drawable = [[FFGLDrawable alloc] initWithFrameQueue:frameQueue];
  [frameQueue release];
  GLView.drawable = drawable;
  [drawable release];
  [GLView setAnimationInterval:(1.0 / 10.0)];  
  [GLView startAnimation];   

  [_window addSubview:GLView];
  [_window sendSubviewToBack:GLView];

  MainConfigurationViewController *mainConfigurationViewController = [[MainConfigurationViewController alloc] init];
  mainConfigurationViewController.window = _window;
  [_window addSubview:[mainConfigurationViewController view]];
  
  //AccelerometerViewController *accelerometerViewController = [[AccelerometerViewController alloc] init];
  //[_window addSubview:[accelerometerViewController view]];

  //MainConfigurationViewController *mainConfigurationViewController = [[MainConfigurationViewController alloc] init];
  //[_window addSubview:[mainConfigurationViewController view]];

  //UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:mainConfigurationViewController];
  //[_window addSubview:[navigationController view]];  

  // Override point for customization after application launch
  [_window makeKeyAndVisible];
}

- (void)applicationWillTerminate:(UIApplication *)application {
  [[SharedSettings sharedManager] saveDefaults];
}

- (void)dealloc {
  [_window release];
  [super dealloc];
}


@end
