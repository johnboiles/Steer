//
//  DualJoystickViewController.m
//  Steer
//
//  Created by John Boiles on 3/6/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "DualJoystickViewController.h"

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
  
  _powerJoystick = [[TouchJoystickView alloc] initWithFrame:CGRectMake(0, 0, 240, 320) delegate:self];
  _powerJoystick.verticalAxis = YES;
  [self.view addSubview:_powerJoystick];
  
  _steeringJoystick = [[TouchJoystickView alloc] initWithFrame:CGRectMake(240, 0, 240, 320) delegate:self];
  _steeringJoystick.horizontalAxis = YES;
  [self.view addSubview:_steeringJoystick];
  
  //UIButton *stopButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
  UIButton *stopButton = [UIButton buttonWithType:UIButtonTypeCustom];
  [stopButton setBackgroundImage:[UIImage imageNamed:@"x.png"] forState:UIControlStateNormal];
  stopButton.frame = CGRectMake(440, 0, 40, 40);
  [stopButton addTarget:self action:@selector(close) forControlEvents:UIControlEventTouchUpInside];
  [self.view addSubview:stopButton];
}

/*
// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
}
*/

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
    NSLog(@"Power joystick moved to position %f", verticalPosition);
    _powerValue = verticalPosition;
  } else if (TouchJoystickView == _steeringJoystick) {
    NSLog(@"Steering joystick moved to position %f", horizontalPosition);
    _steeringValue = horizontalPosition;
  }
  [self setSteering:_steeringValue power:_powerValue];
}

@end
