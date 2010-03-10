//
//  AccelerometerConfigurationViewController.m
//  Steer
//
//  Created by John Boiles on 3/8/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "AccelerometerConfigurationViewController.h"
#import "LookAndFeel.h"
#import "SharedSettings.h"

@implementation AccelerometerConfigurationViewController

 // The designated initializer.  Override if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
- (id)init {
  if (self = [super init]) {
    self.title = @"Accelerometer Config";
  }
  return self;
}

- (void)_sliderValueDidChange:(UISlider*)sender {
  if (sender == _steeringSensitivitySlider) {
    [[SharedSettings sharedManager] setAccelerometerSteeringSensitivity:sender.value];
  }else if (sender == _powerSensitivitySlider) {
    [[SharedSettings sharedManager] setAccelerometerPowerSensitivity:sender.value];
  } else if (sender == _steeringDeadZoneSlider) {
    [[SharedSettings sharedManager] setAccelerometerSteeringDeadZone:sender.value];
  } else if (sender == _powerDeadZoneSlider) {
    [[SharedSettings sharedManager] setAccelerometerPowerDeadZone:sender.value];
  } else if (sender == _frequencySlider) {
    [[SharedSettings sharedManager] setAccelerometerFrequency:sender.value];
  } else if (sender == _filterSlider) {
    [[SharedSettings sharedManager] setAccelerometerFilter:sender.value];
  }
}

// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView {
  [super loadView];
  
  CGFloat x = 10;
  CGFloat y = 10;
  
  UILabel *steeringSensitivityLabel = [LookAndFeel configLabelWithFrame:CGRectMake(x + 8, y, 292, 20) text:@"Steering Sensitivity"];
  [_scrollView addSubview:steeringSensitivityLabel];
	y += 25;
  
  _steeringSensitivitySlider = [LookAndFeel configSliderWithFrame:CGRectMake(x, y, 300, 30) target:self action:@selector(_sliderValueDidChange:)];  
  _steeringSensitivitySlider.minimumValue = 0.5;
  _steeringSensitivitySlider.maximumValue = 3;
  _steeringSensitivitySlider.value = [[SharedSettings sharedManager] accelerometerSteeringSensitivity];
  [_scrollView addSubview:_steeringSensitivitySlider];
  y += 40;

  UILabel *powerSensitivityLabel = [LookAndFeel configLabelWithFrame:CGRectMake(x + 8, y, 292, 20) text:@"Power Sensitivity"];
  [_scrollView addSubview:powerSensitivityLabel];
	y += 25;
  
  _powerSensitivitySlider = [LookAndFeel configSliderWithFrame:CGRectMake(x, y, 300, 30) target:self action:@selector(_sliderValueDidChange:)];  
  _powerSensitivitySlider.minimumValue = 0.5;
  _powerSensitivitySlider.maximumValue = 3;
  _powerSensitivitySlider.value = [[SharedSettings sharedManager] accelerometerPowerSensitivity];
  [_scrollView addSubview:_powerSensitivitySlider];
  y += 40;  
  
  
  UILabel *steeringDeadZoneLabel = [LookAndFeel configLabelWithFrame:CGRectMake(x + 8, y, 292, 20) text:@"Steering Dead Zone"];
  [_scrollView addSubview:steeringDeadZoneLabel];
	y += 25;
  
  _steeringDeadZoneSlider = [LookAndFeel configSliderWithFrame:CGRectMake(x, y, 300, 30) target:self action:@selector(_sliderValueDidChange:)];  
  _steeringDeadZoneSlider.minimumValue = 0;
  _steeringDeadZoneSlider.maximumValue = 0.8;
  _steeringDeadZoneSlider.value = [[SharedSettings sharedManager] accelerometerSteeringDeadZone];
  [_scrollView addSubview:_steeringDeadZoneSlider];
  y += 40;

  UILabel *powerDeadZoneLabel = [LookAndFeel configLabelWithFrame:CGRectMake(x + 8, y, 292, 20) text:@"Power Dead Zone"];
  [_scrollView addSubview:powerDeadZoneLabel];
	y += 25;
  
  _powerDeadZoneSlider = [LookAndFeel configSliderWithFrame:CGRectMake(x, y, 300, 30) target:self action:@selector(_sliderValueDidChange:)];  
  _powerDeadZoneSlider.minimumValue = 0;
  _powerDeadZoneSlider.maximumValue = 0.8;
  _powerDeadZoneSlider.value = [[SharedSettings sharedManager] accelerometerPowerDeadZone];
  [_scrollView addSubview:_powerDeadZoneSlider];
  y += 40;  
  
  UILabel *frequencyLabel = [LookAndFeel configLabelWithFrame:CGRectMake(x + 8, y, 292, 20) text:@"Accelerometer Frequency (Hz)"];
  [_scrollView addSubview:frequencyLabel];
	y += 25;
  
  _frequencySlider = [LookAndFeel configSliderWithFrame:CGRectMake(x, y, 300, 30) target:self action:@selector(_sliderValueDidChange:)];  
  _frequencySlider.minimumValue = 10;
  _frequencySlider.maximumValue = 60;
  _frequencySlider.value = [[SharedSettings sharedManager] accelerometerFrequency];
  [_scrollView addSubview:_frequencySlider];
  y += 40;
  
  UILabel *filterLabel = [LookAndFeel configLabelWithFrame:CGRectMake(x + 8, y, 292, 20) text:@"Filter Constant (larger is slower)"];
  [_scrollView addSubview:filterLabel];
	y += 25;
  
  _filterSlider = [LookAndFeel configSliderWithFrame:CGRectMake(x, y, 300, 30) target:self action:@selector(_sliderValueDidChange:)];  
  _filterSlider.minimumValue = 0;
  _filterSlider.maximumValue = 1;
  _filterSlider.value = [[SharedSettings sharedManager] accelerometerFilter];
  [_scrollView addSubview:_filterSlider];
  y += 40;
  
  UIButton *closeButton = [LookAndFeel closeButtonWithCenter:CGPointMake(300, 460) target:self action:@selector(close)];
  [_scrollView addSubview:closeButton];
}

- (void)close {
  [self dismissModalViewControllerAnimated:YES];
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


- (void)dealloc {
    [super dealloc];
}


@end
