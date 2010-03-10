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
    _steeringIndicatorView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"arrow.png"]];
    _steeringIndicatorView.center = CGPointMake(240, _steeringIndicatorView.frame.size.height / 2);
    _steeringIndicatorView.backgroundColor = [UIColor clearColor];
    [self addSubview:_steeringIndicatorView];

    _powerIndicatorView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"arrow.png"]];
    _powerIndicatorView.center = CGPointMake(_steeringIndicatorView.frame.size.height / 2, 160);
    _powerIndicatorView.transform = CGAffineTransformMakeRotation(-3.14159/2);
    _powerIndicatorView.backgroundColor = [UIColor clearColor];
    [self addSubview:_powerIndicatorView];
    
    self.backgroundColor = [UIColor clearColor];
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
  _steeringIndicatorView.center = CGPointMake(steering * 240 + 240, _steeringIndicatorView.frame.size.height / 2);
  _powerIndicatorView.center = CGPointMake(_steeringIndicatorView.frame.size.height / 2, -power * 160 + 160); 
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
