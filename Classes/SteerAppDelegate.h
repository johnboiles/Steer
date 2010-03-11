//
//  SteerAppDelegate.h
//  Steer
//
//  Created by John Boiles on 3/6/10.
//  Copyright __MyCompanyName__ 2010. All rights reserved.
//

#import "MainConfigurationViewController.h"
#import "FFPlayerView.h"

@interface SteerAppDelegate : NSObject <UIApplicationDelegate, MainConfigurationViewControllerDelegate> {
  
  UIWindow *_window;
  UINavigationController *_navigationController;
  
  UIViewController *_windowViewController;
  
  FFPlayerView *_playerView;
}

- (void)setWindowViewController:(UIViewController *)viewController;

- (void)play;

@end

