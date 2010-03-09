//
//  DualJoystickViewController.h
//  Steer
//
//  Created by John Boiles on 3/6/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#include "TouchJoystickView.h"
#include "ControlViewController.h"

@interface DualJoystickViewController : ControlViewController <TouchJoystickViewDelegate> {
  TouchJoystickView *_powerJoystick;
  TouchJoystickView *_steeringJoystick;
  double _steeringValue;
  double _powerValue;
}

@end
