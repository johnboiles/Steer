//
//  ConfigurationViewController.h
//  Steer
//
//  Created by John Boiles on 3/7/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "ConfigurationViewController.h"

@interface MainConfigurationViewController : ConfigurationViewController <UITextFieldDelegate, ControlViewControllerDelegate> {
  UITextField *_ipAddressTextView;
  UITextField *_cameraAddressTextView;
  UIWindow *_window;
}

@property (assign, nonatomic) UIWindow *window;

@end
