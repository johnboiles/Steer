//
//  ConfigurationViewController.h
//  Steer
//
//  Created by John Boiles on 3/7/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "ConfigurationViewController.h"
#import "AccelerometerViewController.h"
#import "DualJoystickViewController.h"

@class MainConfigurationViewController;

@protocol MainConfigurationViewControllerDelegate <NSObject>
- (void)mainConfigurationViewController:(MainConfigurationViewController *)mainConfigurationViewController 
        shouldOpenControlViewController:(ControlViewController *)controlViewController;

- (void)mainConfigurationViewController:(MainConfigurationViewController *)mainConfigurationViewController 
        shouldCloseControlViewController:(ControlViewController *)controlViewController;

@end

@interface MainConfigurationViewController : ConfigurationViewController <UITextFieldDelegate, ControlViewControllerDelegate> {
  UITextField *_ipAddressTextView;
  UITextField *_cameraAddressTextView;
  
  id<MainConfigurationViewControllerDelegate> _delegate;
  
  AccelerometerViewController *_accelerometerViewController;
  DualJoystickViewController *_dualJoystickViewController;
}

@property (assign, nonatomic) id<MainConfigurationViewControllerDelegate> delegate;

@end
