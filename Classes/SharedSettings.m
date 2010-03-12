//
//  SharedSettings.m
//  Steer
//
//  Created by John Boiles on 10/19/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "SharedSettings.h"

@implementation SharedSettings
@synthesize accelerometerSteeringDeadZone=_accelerometerSteeringDeadZone, accelerometerPowerDeadZone=_accelerometerPowerDeadZone, 
accelerometerSteeringSensitivity=_accelerometerSteeringSensitivity, accelerometerPowerSensitivity=_accelerometerPowerSensitivity,
accelerometerFrequency=_accelerometerFrequency, accelerometerFilter=_accelerometerFilter, dualJoystickDeadZone=_dualJoystickDeadZone, 
ipAddress=_ipAddress, cameraAddress=_cameraAddress;

static SharedSettings *_sharedSettingsManager;

-(id)init {
  if ((self = [super init])) {
    //Load previous values
    //TODO: save this between program openings
    [self retrieveDefaults];
  }
  return self;
}

- (void)dealloc {
  [_ipAddress release];
  [_cameraAddress release];
  [super dealloc];
}

-(void)saveDefaults {
  NSUserDefaults *standardUserDefaults = [NSUserDefaults standardUserDefaults];
  if (standardUserDefaults) {
    [standardUserDefaults setObject:[NSNumber numberWithDouble:_accelerometerSteeringDeadZone] forKey:@"accelerometerSteeringDeadZone"];
    [standardUserDefaults setObject:[NSNumber numberWithDouble:_accelerometerPowerDeadZone] forKey:@"accelerometerPowerDeadZone"];
    [standardUserDefaults setObject:[NSNumber numberWithDouble:_accelerometerSteeringSensitivity] forKey:@"accelerometerSteeringSensitivity"];
    [standardUserDefaults setObject:[NSNumber numberWithDouble:_accelerometerPowerSensitivity] forKey:@"accelerometerPowerSensitivity"];
    [standardUserDefaults setObject:[NSNumber numberWithDouble:_accelerometerFrequency] forKey:@"accelerometerFrequency"];
    [standardUserDefaults setObject:[NSNumber numberWithDouble:_accelerometerFilter] forKey:@"accelerometerFilter"];
    [standardUserDefaults setObject:[NSNumber numberWithDouble:_dualJoystickDeadZone] forKey:@"dualJoystickDeadZone"];
    [standardUserDefaults setObject:_ipAddress forKey:@"ipAddress"];
    [standardUserDefaults setObject:_cameraAddress forKey:@"cameraAddress"];
    [standardUserDefaults synchronize];
  }
}

-(void)retrieveDefaults {
  NSUserDefaults *standardUserDefaults = [NSUserDefaults standardUserDefaults];
  
  // TODO: set some default values maybe with registerDefaults, or using a test value
  // http://devworld.apple.com/iphone/library/samplecode/AppPrefs/listing2.html
  // http://www.cocos2d-iphone.org/forum/topic/925
  
  //Set up default values
  NSDictionary *applicationDefaults = [NSDictionary
                               dictionaryWithObjects:[NSArray arrayWithObjects:
                                                      [NSNumber numberWithDouble:0],
                                                      [NSNumber numberWithDouble:0],
                                                      [NSNumber numberWithDouble:1],
                                                      [NSNumber numberWithDouble:1],
                                                      [NSNumber numberWithDouble:40],
                                                      [NSNumber numberWithDouble:0.7],
                                                      [NSNumber numberWithDouble:.05],
                                                      @"192.168.1.100",
                                                      @"http://wificar:carwifi@192.168.1.253/nphMotionJpeg?Resolution=320x240&Quality=Standard",
                                                      nil]
                               forKeys:[NSArray arrayWithObjects:
                                        @"accelerometerSteeringDeadZone",
                                        @"accelerometerPowerDeadZone",
                                        @"accelerometerSteeringSensitivity",
                                        @"accelerometerPowerSensitivity",
                                        @"accelerometerFrequency",
                                        @"accelerometerFilter",
                                        @"dualJoystickDeadZone",
                                        @"ipAddress",
                                        @"cameraAddress",
                                        nil]];
  
  [standardUserDefaults registerDefaults:applicationDefaults];
  
  //Get the values from standardUserDefaults
  if (standardUserDefaults) {
    _accelerometerSteeringDeadZone = [[standardUserDefaults objectForKey:@"accelerometerSteeringDeadZone"] doubleValue];
    _accelerometerPowerDeadZone = [[standardUserDefaults objectForKey:@"accelerometerPowerDeadZone"] doubleValue];
    _accelerometerSteeringSensitivity = [[standardUserDefaults objectForKey:@"accelerometerSteeringSensitivity"] doubleValue];
    _accelerometerPowerSensitivity = [[standardUserDefaults objectForKey:@"accelerometerPowerSensitivity"] doubleValue];
    _accelerometerFrequency = [[standardUserDefaults objectForKey:@"accelerometerFrequency"] doubleValue];
    _accelerometerFilter = [[standardUserDefaults objectForKey:@"accelerometerFilter"] doubleValue];    
    _dualJoystickDeadZone = [[standardUserDefaults objectForKey:@"dualJoystickDeadZone"] doubleValue];
    _ipAddress = [NSString stringWithString:[standardUserDefaults stringForKey:@"ipAddress"]];
    _cameraAddress = [NSString stringWithString:[standardUserDefaults stringForKey:@"cameraAddress"]];
  }
}

+ (SharedSettings*)sharedManager {
  @synchronized(self) {
    if (_sharedSettingsManager == nil) {
      [[self alloc] init]; // assignment not done here
    }
  }
  return _sharedSettingsManager;
}

+ (id)allocWithZone:(NSZone *)zone {
  @synchronized(self) {
    if (_sharedSettingsManager == nil) {
        _sharedSettingsManager = [super allocWithZone:zone];
        return _sharedSettingsManager;  // assignment and return on first allocation
    }
  }
  return nil; //on subsequent allocation attempts return nil
}

@end