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

@implementation SteerAppDelegate

@synthesize window=_window;

- (void)applicationDidFinishLaunching:(UIApplication *)application {    
  [[SharedSettings sharedManager] retrieveDefaults];
  
  _window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];

  // Hide the status bar
  [UIApplication sharedApplication].statusBarHidden = YES;
  
  //DualJoystickViewController *dualJoystickViewController = [[DualJoystickViewController alloc] init];
  //[_window addSubview:[dualJoystickViewController view]];
    
  //AccelerometerViewController *accelerometerViewController = [[AccelerometerViewController alloc] init];
  //[_window addSubview:[accelerometerViewController view]];
  
  MainConfigurationViewController *mainConfigurationViewController = [[MainConfigurationViewController alloc] init];
  //[_window addSubview:[mainConfigurationViewController view]];
  
  UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:mainConfigurationViewController];
  [_window addSubview:[navigationController view]];  
  
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
