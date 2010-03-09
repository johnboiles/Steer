//
//  AccelerometerViewController.h
//  Steer
//
//  Created by John Boiles on 3/6/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "AccelerometerView.h"
#import "ControlViewController.h"

@interface AccelerometerViewController : ControlViewController <UIAccelerometerDelegate, AccelerometerViewDelegate> {
  double _filterConstant;
  double _accelerometerFrequency; // In Hz
  double _tiltAngleCorrection;
  double _rollAngleMax;
  double _tiltAngleMax;
  double _powerSensitivity;
  double _steeringSensitivity;
  double _powerDeadZone;
  double _steeringDeadZone;
  BOOL _accelerometerActive;
  BOOL _firstAccelerometerSample;
  AccelerometerView *_accelerometerView;
}

@property (assign, nonatomic) double filterConstant;
@property (assign, nonatomic) double accelerometerFrequency;
@property (assign, nonatomic) double rollAngleMax;
@property (assign, nonatomic) double tiltAngleMax;
@property (assign, nonatomic, getter=isAccelerometerActive) BOOL accelerometerActive;

@end
