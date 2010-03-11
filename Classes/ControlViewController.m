//
//  ControlViewController.m
//  Steer
//
//  Created by John Boiles on 3/7/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "ControlViewController.h"
#import "SharedSettings.h"

@implementation ControlViewController

@synthesize delegate=_delegate;

 // The designated initializer.  Override if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
- (id)init {
  if (self = [super init]) {
    // Custom initialization
    _carControl = [[CarControl alloc] initWithIP:[[SharedSettings sharedManager] ipAddress]]; 
  }
  return self;
}

- (void)viewWillDisappear:(BOOL)animated {
  [super viewWillDisappear:animated];
  [_carControl stop];
}

- (void)close {
  [_carControl stop];
  [_delegate controlViewControllerShouldClose:self];
}

- (void)setSteering:(double)steering power:(double)power {
  [_carControl sendCommandToMotor:power andSteering:steering];
}

- (void)dealloc {
    [super dealloc];
}

@end
