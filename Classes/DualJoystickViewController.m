//
//  DualJoystickViewController.m
//  Steer
//
//  Created by John Boiles on 3/6/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "DualJoystickViewController.h"
#import "LookAndFeel.h"

@implementation DualJoystickViewController

 // The designated initializer.  Override if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
- (id)init {
  if (self = [super init]) {
    // Custom initialization
  }
  return self;
}

- (void)dealloc {
  [super dealloc];
}

- (void)loadView {
  [super loadView];
  
  self.view.frame = CGRectMake(0, 0, 480, 320);
  
  _powerJoystick = [[TouchJoystickView alloc] initWithFrame:CGRectMake(0, 0, 240, 320) delegate:self];
  _powerJoystick.verticalAxis = YES;
  [self.view addSubview:_powerJoystick];
  
  _steeringJoystick = [[TouchJoystickView alloc] initWithFrame:CGRectMake(240, 0, 240, 320) delegate:self];
  _steeringJoystick.horizontalAxis = YES;
  [self.view addSubview:_steeringJoystick];
  
  UIButton *stopButton = [LookAndFeel closeButtonWithCenter:CGPointMake(460,20) target:self action:@selector(close)];
  [self.view addSubview:stopButton];
}

// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationLandscapeRight);
}

- (void)didReceiveMemoryWarning {
	// Releases the view if it doesn't have a superview.
  [super didReceiveMemoryWarning];
  // Release any cached data, images, etc that aren't in use.
}


#pragma mark Delegates (TouchJoystickView)

- (void)touchJoystickView:(TouchJoystickView *)TouchJoystickView didMoveToHorizontalPosition:(double)horizontalPosition verticalPosition:(double)verticalPosition {
  if (TouchJoystickView == _powerJoystick) {
    Debug(@"Power joystick moved to position %f", verticalPosition);
    _powerValue = verticalPosition;
  } else if (TouchJoystickView == _steeringJoystick) {
    Debug(@"Steering joystick moved to position %f", horizontalPosition);
    _steeringValue = horizontalPosition;
  }
  [self setSteering:_steeringValue power:_powerValue];
}

@end
