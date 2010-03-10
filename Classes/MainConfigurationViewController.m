//
//  ConfigurationViewController.m
//  Steer
//
//  Created by John Boiles on 3/7/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "ControlViewController.h"
#import "MainConfigurationViewController.h"
#import "AccelerometerViewController.h"
#import "DualJoystickViewController.h"
#import "AccelerometerConfigurationViewController.h"
#import "SharedSettings.h"
#import "LookAndFeel.h"

@implementation MainConfigurationViewController

@synthesize window=_window;

// The designated initializer.  Override if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
- (id)init {
  if (self = [super init]) {
    self.title = @"Steer";
  }
  return self;
}

- (void)dealloc {
  [super dealloc];
}

- (void)_openAccelerometerController {
  AccelerometerViewController *controller = [[AccelerometerViewController alloc] init];
  controller.delegate = self;
  // Rotate manually since the view controller doesnt seem to be correctly handling rotation
  controller.view.transform = CGAffineTransformMakeRotation(3.14159/2);
  controller.view.center = CGPointMake(160, 240);
  [_window addSubview:[controller view]];
  [self.view removeFromSuperview];
}

- (void)_openDualJoystickController {
  DualJoystickViewController *controller = [[DualJoystickViewController alloc] init];
  controller.delegate = self;
  // Rotate manually since the view controller doesnt seem to be correctly handling rotation
  controller.view.transform = CGAffineTransformMakeRotation(3.14159/2);
  controller.view.center = CGPointMake(160, 240);
  // Apparently this doesn't remain the view
  [_window addSubview:[controller view]];
  // Removing from superview for speed
  [self.view removeFromSuperview];
}

- (void)_openAccelerometerConfiguration {
  UIViewController *controller = [[AccelerometerConfigurationViewController alloc] init];
  controller.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
	[self presentModalViewController:controller animated:YES];
  //[[self navigationController] pushViewController:controller animated:YES];
}

// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView {
  [super loadView];
  
  CGFloat x = 10;
  CGFloat y = 10;
  
  UILabel *label = [LookAndFeel configLabelWithFrame:CGRectMake(x + 8, y, 292, 20) text:@"Dual Axis"];
  [_scrollView addSubview:label];
	y += 25;
  
  UIButton *dualJoystickButton = [LookAndFeel configButtonWithFrame:CGRectMake(x, y, 300, 45) title:@"Dual Joystick Controller" target:self action:@selector(_openDualJoystickController)];
  [_scrollView addSubview:dualJoystickButton];
  y += 55;
  
  UILabel *accelerometerLabel = [LookAndFeel configLabelWithFrame:CGRectMake(x + 8, y, 292, 20) text:@"Accelerometer Controller"];
  [_scrollView addSubview:accelerometerLabel];
	y += 25;
  
  UIButton *accelerometerButton = [LookAndFeel configButtonWithFrame:CGRectMake(x, y, 300, 45) title:@"Accelerometer Controller" target:self action:@selector(_openAccelerometerController)];
  [_scrollView addSubview:accelerometerButton];
  y += 55;  
  
  UIButton *accelerometerConfigurationButton = [LookAndFeel configButtonWithFrame:CGRectMake(x, y, 300, 45) title:@"Configuration" target:self action:@selector(_openAccelerometerConfiguration)];
  [_scrollView addSubview:accelerometerConfigurationButton];
  y += 55;  
  
  UILabel *iplabel = [LookAndFeel configLabelWithFrame:CGRectMake(x + 8, y, 292, 20) text:@"IP Address"];
  [_scrollView addSubview:iplabel];
	y += 25;
  
  _ipAddressTextView = [LookAndFeel configTextViewWithFrame:CGRectMake(x, y, 300, 45) text:[[SharedSettings sharedManager] ipAddress] delegate:self];
  [_scrollView addSubview:_ipAddressTextView];
  y += 55;
  
  
  UILabel *cameraiplabel = [LookAndFeel configLabelWithFrame:CGRectMake(x + 8, y, 292, 20) text:@"Camera Address"];
  [_scrollView addSubview:cameraiplabel];
	y += 25;
  
  _cameraAddressTextView = [LookAndFeel configTextViewWithFrame:CGRectMake(x, y, 300, 45) text:[[SharedSettings sharedManager] cameraAddress] delegate:self];
  [_scrollView addSubview:_cameraAddressTextView];
  y += 55;  
  
  // Padding here
  y += 45;
  [_scrollView setContentSize:CGSizeMake(320, y)];
}

- (void)didReceiveMemoryWarning {
	// Releases the view if it doesn't have a superview.
  [super didReceiveMemoryWarning];
	
	// Release any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
	// Release any retained subviews of the main view.
	// e.g. self.myOutlet = nil;
}

#pragma mark Keyboard

- (void)keyboardWasShown:(NSNotification*)aNotification {
  [super keyboardWasShown:aNotification];
  // Scroll the active text field into view.
  // TODO: this should be dynamic when there are more text views
  CGRect textFieldRect = [_cameraAddressTextView frame];
  [_scrollView scrollRectToVisible:textFieldRect animated:YES];
}

#pragma mark Delegates(UITextField)

- (void)textFieldDidEndEditing:(UITextField *)textField {
  if (textField == _ipAddressTextView) {
    // TODO: Check for valid IP Address here, or maybe in SharedSettings
    [[SharedSettings sharedManager] setIpAddress:_ipAddressTextView.text];
  } else if (textField == _cameraAddressTextView) {
    [[SharedSettings sharedManager] setCameraAddress:_ipAddressTextView.text];
  }
  [textField resignFirstResponder];
}

- (BOOL)textFieldShouldEndEditing:(UITextField *)textField {
	return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
	[textField resignFirstResponder];
	return NO;
}

#pragma mark Delegates(ControlViewController)

- (void)controlViewControllerWillClose:(ControlViewController *)controlViewController {
  [controlViewController.view removeFromSuperview];
  [_window addSubview:self.view];
}

@end
