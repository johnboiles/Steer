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

#import "FFPlayerView.h"

@implementation SteerAppDelegate

- (void)applicationDidFinishLaunching:(UIApplication *)application {    
  [[SharedSettings sharedManager] retrieveDefaults];
  
  _window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];

  // Hide the status bar
  [UIApplication sharedApplication].statusBarHidden = YES;
  
  _playerView = [[FFPlayerView alloc] init];
  [_window addSubview:_playerView];
  
  MainConfigurationViewController *mainConfigurationViewController = [[MainConfigurationViewController alloc] init];
  mainConfigurationViewController.delegate = self;
  _navigationController = [[UINavigationController alloc] initWithRootViewController:mainConfigurationViewController];  
  [mainConfigurationViewController release];
  
  [self setWindowViewController:_navigationController];

  [_window makeKeyAndVisible];
  [self play];
}

- (void)applicationWillTerminate:(UIApplication *)application {
  [[SharedSettings sharedManager] saveDefaults];
}

- (void)dealloc {
  [_window release];
  [_navigationController release];
  [_windowViewController release];
  [_playerView release];
  [[NSNotificationCenter defaultCenter] removeObserver:self];
  [super dealloc];
}

- (void)setWindowViewController:(UIViewController *)viewController {  
  // Remove existing
  [_windowViewController.view removeFromSuperview]; 
  // Set current window view controller
  [viewController retain];
  [_windowViewController release];
  _windowViewController = viewController;
  [_window addSubview:_windowViewController.view];  
}

- (void)play {
  _playerView.URLString = [[NSUserDefaults standardUserDefaults] objectForKey:@"cameraAddress"];
  _playerView.format = @"mjpeg";
  [_playerView play];
}  

#pragma mark Delegates(MainConfigurationViewController)

- (void)mainConfigurationViewController:(MainConfigurationViewController *)mainConfigurationViewController 
        shouldOpenControlViewController:(ControlViewController *)controlViewController {  
  
  [self setWindowViewController:controlViewController];
}

- (void)mainConfigurationViewController:(MainConfigurationViewController *)mainConfigurationViewController 
       shouldCloseControlViewController:(ControlViewController *)controlViewController {

  [self setWindowViewController:_navigationController];
}

@end
