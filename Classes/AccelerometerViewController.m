//
//  AccelerometerViewController.m
//  Steer
//
//  Created by John Boiles on 3/6/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "AccelerometerViewController.h"
#import "math.h"
#import "AccelerometerConfigurationViewController.h"
#import "SharedSettings.h"

@implementation AccelerometerViewController

@synthesize filterConstant=_filterConstant, accelerometerFrequency=_accelerometerFrequency, accelerometerActive=_accelerometerActive,
tiltAngleMax=_tiltAngleMax, rollAngleMax=_rollAngleMax;

 // The designated initializer.  Override if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
- (id)init {
  if (self = [super init]) {
    // Set some defaults that the user can override if necessary
    _filterConstant = 0.7;
    // Configure and start the accelerometer
    _firstAccelerometerSample = YES;
    _rollAngleMax = 1.1;
    _tiltAngleMax = 1.1;
    _accelerometerActive = NO;
    _accelerometerFrequency = [[SharedSettings sharedManager] accelerometerFrequency];
    [self setAccelerometerFrequency:_accelerometerFrequency];
    [[UIAccelerometer sharedAccelerometer] setDelegate:self];
  }
  return self;
}

- (void)dealloc {
  [_accelerometerView release];
  [super dealloc];
}

// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView {
  [super loadView];
  _accelerometerView = [[AccelerometerView alloc] initWithFrame:CGRectMake(0, 0, 480, 320)];
  _accelerometerView.delegate = self;
  self.view = _accelerometerView;

  UIButton *stopButton = [UIButton buttonWithType:UIButtonTypeCustom];
  [stopButton setBackgroundImage:[UIImage imageNamed:@"x.png"] forState:UIControlStateNormal];
  stopButton.frame = CGRectMake(440, 0, 40, 40);
  [stopButton addTarget:self action:@selector(close) forControlEvents:UIControlEventTouchUpInside];
  [self.view addSubview:stopButton];
}

- (void)viewWillAppear:(BOOL)animated {
  _powerSensitivity = [[SharedSettings sharedManager] accelerometerPowerSensitivity];
  _steeringSensitivity = [[SharedSettings sharedManager] accelerometerSteeringSensitivity];
  _powerDeadZone = [[SharedSettings sharedManager] accelerometerPowerDeadZone];
  _steeringDeadZone = [[SharedSettings sharedManager] accelerometerSteeringDeadZone];
}

- (void)setAccelerometerFrequency:(double)accelerometerFrequency {
  [[UIAccelerometer sharedAccelerometer] setUpdateInterval:(1.0 / accelerometerFrequency)];
  _accelerometerFrequency = accelerometerFrequency;
}

- (void)setAccelerometerActive:(BOOL)active {
  if (active && !_accelerometerActive) {
    _firstAccelerometerSample = YES;
    _accelerometerActive = YES;
  } else if (!active && _accelerometerActive) {
    _accelerometerActive = NO;
  }
}

// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationLandscapeRight);
}

- (void)setRollAngleMax:(double)rollAngleMax {
  if (rollAngleMax > 1.57) {
    Debug(@"WARNING: Setting rollAngleMax too large, defaulting to 1.57");
    _rollAngleMax = 1.57;
  } else {
    _rollAngleMax = rollAngleMax;
  }
}

- (void)setTiltAngleMax:(double)tiltAngleMax {
  if (tiltAngleMax > 1.57) {
    Debug(@"WARNING: Setting tiltAngleMax too large, defaulting to 1.57");
    _tiltAngleMax = 1.57;
  } else {
    _tiltAngleMax = tiltAngleMax;
  }
}

- (void)_setSteering:(double)steering power:(double)power animated:(BOOL)animated {
  // Apply dead zone properties
  if (fabs(steering) < _steeringDeadZone) steering = 0;
  if (fabs(power) < _powerDeadZone) power = 0;

  // Apply sensitivity properties
  power = power * _powerSensitivity;
  steering = steering * _steeringSensitivity;
  
  // Limit power and steering to -1 to 1
  if (power < -1) power = -1;
  else if (power > 1) power = 1;
  if (steering < -1) steering = -1;
  else if (steering > 1) steering = 1;
  
  [_accelerometerView setIndicatorsSteering:steering power:power animated:animated];
  [self setSteering:steering power:power];
}

- (void)viewDidUnload {
	// Release any retained subviews of the main view.
	// e.g. self.myOutlet = nil;
}

#pragma mark Delegates (UIAccelerometer)

- (void)accelerometer:(UIAccelerometer *)accelerometer didAccelerate:(UIAcceleration *)acceleration {
  static double xf;
  static double yf;
  static double zf;
  if (_accelerometerActive) {
    // simple moving average
    if (_firstAccelerometerSample) {
      xf = acceleration.x;
      yf = acceleration.y;
      zf = acceleration.z;
    } else {
      xf = _filterConstant * xf + (1.0 - _filterConstant) * acceleration.x;
      yf = _filterConstant * yf + (1.0 - _filterConstant) * acceleration.y;
      zf = _filterConstant * zf + (1.0 - _filterConstant) * acceleration.z;
    }
    // xzAngle is used to determine velocity
    // NOTE: second params are negative so the transition from pi to -pi happens when the device is upside down
    // yzAngle is useful for determining tilt when the device is parallel to the ground
    // xyAngle is useful for determining tilt when the device is perpendicular to the ground
    // yz and xy get larger when tilted clockwise
    double xzAngle = atan2(xf, -zf);
    double yzAngle = -atan2(yf, -zf);
    double xyAngle = -atan2(yf, -xf);
    // Adjust the roll angle for tilt
    // TODO: There's probably some best practice for how to do this
    double rollAngle;
    if (xzAngle < 0 && xzAngle > -1.57)
      rollAngle = -(xzAngle / 1.57) * xyAngle + ((xzAngle + 1.57) / 1.57) * yzAngle;
    else if (xzAngle > 0 && xzAngle < 1.57)
      rollAngle = yzAngle;
    else if (xzAngle < -1.57)
      rollAngle = xyAngle;

    // Set a correction so the angle is relative to the roll angle when the user first
    // started controlling
    if (_firstAccelerometerSample) {
      _firstAccelerometerSample = NO;
      _tiltAngleCorrection = xzAngle;
    }
    
    double tiltAngle = xzAngle - _tiltAngleCorrection;
    
    // Constrain tiltAngle and rollAngle
    if (tiltAngle > _tiltAngleMax) tiltAngle = _tiltAngleMax;
    if (tiltAngle < -_tiltAngleMax) tiltAngle = -_tiltAngleMax;
    if (rollAngle > _rollAngleMax) rollAngle = _rollAngleMax;
    if (rollAngle < -_rollAngleMax) rollAngle = -_rollAngleMax;
    
    Debug(@"Accelerometer angles are xy:%f zx:%f yz:%f", xyAngle, xzAngle, yzAngle);
    [self _setSteering:(rollAngle / _rollAngleMax) power:(tiltAngle / _tiltAngleMax) animated:NO];
  }
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
  NSArray *touchesArray = [touches allObjects];
  CGPoint point = [[touchesArray objectAtIndex:0] locationInView:self.view];
  Debug(@"Touches Began x:%f y:%f", point.x, point.y);
  self.accelerometerActive = YES;
}

- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event {
  Debug(@"Touches Cancelled");
  self.accelerometerActive = NO;
  [self _setSteering:0 power:0 animated:YES];
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
  Debug(@"Touches Ended");
  self.accelerometerActive = NO;
  [self _setSteering:0 power:0 animated:YES];
}


@end
