//
//  AccelerometerConfigurationViewController.h
//  Steer
//
//  Created by John Boiles on 3/8/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "ConfigurationViewController.h"

@interface AccelerometerConfigurationViewController : ConfigurationViewController {
  UISlider *_steeringSensitivitySlider;
  UISlider *_powerSensitivitySlider;
  UISlider *_steeringDeadZoneSlider;
  UISlider *_powerDeadZoneSlider;
  UISlider *_frequencySlider;
  UISlider *_filterSlider;
}

@end
