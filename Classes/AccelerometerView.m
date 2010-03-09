//
//  AccelerometerView.m
//  Steer
//
//  Created by John Boiles on 3/7/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "AccelerometerView.h"


@implementation AccelerometerView

@synthesize delegate=_delegate;

- (id)initWithFrame:(CGRect)frame {
  if (self = [super initWithFrame:frame]) {
    // TODO: I should make these indicators their own class
    _steeringIndicatorView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 40, 20)];
    _steeringIndicatorView.center = CGPointMake(240, 10);
    _steeringIndicatorView.backgroundColor = [UIColor greenColor];
    [self addSubview:_steeringIndicatorView];

    _powerIndicatorView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 20, 40)];
    _powerIndicatorView.center = CGPointMake(10, 160);
    _powerIndicatorView.backgroundColor = [UIColor greenColor];
    [self addSubview:_powerIndicatorView];

  }
  return self;
}

- (void)drawRect:(CGRect)rect {
    // Drawing code
}

- (void)dealloc {
  [_steeringIndicatorView release];
  [_powerIndicatorView release];
  [super dealloc];
}

- (void)setIndicatorsSteering:(double)steering power:(double)power animated:(BOOL)animated{
  if (animated) {
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationCurve:UIViewAnimationCurveLinear];
    [UIView setAnimationDuration:0.1];
  }
  _steeringIndicatorView.center = CGPointMake(steering * 240 + 240, 10);
  _powerIndicatorView.center = CGPointMake(10, -power * 160 + 160); 
  if (animated) [UIView commitAnimations];
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
  [_delegate touchesBegan:touches withEvent:event];
}

- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event {
  [_delegate touchesCancelled:touches withEvent:event];
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
  [_delegate touchesEnded:touches withEvent:event];
}

@end
