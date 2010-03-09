//
//  CarControl.m
//  Acsend
//
//  Created by John Boiles on 7/7/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "CarControl.h"
#import "SendUDP.h"

@implementation CarControl

@synthesize noRepeatCommands=_noRepeatCommands;

- (id)initWithIP:(NSString *)ipAddressString {
	if ((self = [super init])) {
    // Initialize network communications
    // TODO: make this not hardcoded
    SUDP_Init([ipAddressString cStringUsingEncoding:NSASCIIStringEncoding]);	
    _noRepeatCommands = YES;
  }
  return self;
}

- (void)_copyCharArray:(char*)source toArray:(char*)destination withLength:(int)length {
  for(int i=0; i<length; i++){
    destination[i] = source[i];
  }
}

- (BOOL)_arrayIsEqual:(char*)arrayOne toArray:(char*)arrayTwo withLength:(int)length {
  for(int i=0; i<length; i++){
    if (arrayOne[i] != arrayTwo[i]){return false;}
  }
  return true;
}

// Send the a command to the car
// Protocol implementation details are handled here
- (void)sendCommandToMotor:(double)motor andSteering:(double)steering {
	char message[4];
	
	// When Steering via the servo, 128 ~ middle position, 0 ~ full right
	message[0] = 's';
  double calc = -(steering * 128) + 128;
	int value = (int) calc;
	if (value > 255) {value = 255;}
	if (value < 0) {value = 0;}
	message[1] = (unsigned char) value;
	
	// Figure out direction
	if(motor >= 0) {
		message[2] = 'a';
	} else {
		message[2] = 'A';
	}   
	value = motor * 255;
	value = abs(value);
	if (value > 255) {value = 255;}
  // It's not good for the motors to run them at a power too small to move them
  // TODO: this detail should be handled by the vehicle, not the controller
	if (value < 55) {value = 0;}
	message[3] = (unsigned char) value;   
  
  if(_noRepeatCommands){
    if(![self _arrayIsEqual:message toArray:_lastCommand withLength:4]) {
      SUDP_SendMsg(message, 4);
      [self _copyCharArray:message toArray:_lastCommand withLength:4];
    }
  } else {
    SUDP_SendMsg(message, 4);
  }
}

- (void)stop {
	[self sendCommandToMotor:0 andSteering:0];
}

- (void)dealloc {
	SUDP_Close();
	[super dealloc];
}
	
@end
