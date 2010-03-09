//
//  TouchJoystickView.m
//  Steer
//
//  Created by John Boiles on 3/6/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "TouchJoystickView.h"

@implementation TouchJoystickView

@synthesize horizontalAxis=_horizontalAxis, verticalAxis=_verticalAxis, delegate=_delegate;

- (id)initWithFrame:(CGRect)frame delegate:(id<TouchJoystickViewDelegate>)delegate {
    if (self = [super initWithFrame:frame]) {
      self.backgroundColor = [UIColor clearColor];
      self.opaque = NO;
      _delegate = delegate;
      // Initialization code
      
      _stick = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"FatSliderThumb.png"]];
      _stick.backgroundColor = [UIColor clearColor];
      
      //_stick = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 40, 40)];
      //_stick.backgroundColor = [[UIColor alloc] initWithRed:0 green:1 blue:0 alpha:0.5];
      
      _stick.alpha = 0.5;      
      _stick.center = CGPointMake(frame.size.width / 2, frame.size.height / 2);
      [self addSubview:_stick];
      self.clipsToBounds = NO;
    }
    return self;
}


- (void)drawRect:(CGRect)rect {
    // Drawing code
}


- (void)dealloc {
  [super dealloc];
}

- (CGPoint)_boundPointToViewSize:(CGPoint)point {
  if (!_horizontalAxis) {
    point.x = self.frame.size.width / 2;
  } else if (point.x < _stick.frame.size.width / 2) {
    point.x = _stick.frame.size.width / 2;
  } else if (point.x > self.frame.size.width - _stick.frame.size.width / 2) {
    point.x = self.frame.size.width - _stick.frame.size.width / 2;
  }
  if (!_verticalAxis) {
    point.y = self.frame.size.height / 2;
  } else if (point.y < _stick.frame.size.height / 2) {
    point.y = _stick.frame.size.height / 2;
  } else if (point.y > self.frame.size.height - _stick.frame.size.height / 2) {
    point.y = self.frame.size.height - _stick.frame.size.height / 2;
  }
  return point;
}

// NOTE: We expect that the user has already made sure the point is valid
- (void)_setJoystickCenter:(CGPoint)point {
  _stick.center = point;
}

// For vertical joysticks, up is positive
- (double)_verticalPostionFromPoint:(CGPoint)point {
  if (_verticalAxis)
    return ((self.frame.size.height / 2) - point.y) / ((self.frame.size.height / 2) - _stick.frame.size.height / 2);
  else
    return 0;
}

// For horizontal joysticks, right is positive
- (double)_horizontalPositionFromPoint:(CGPoint)point {
  if (_horizontalAxis)
    return (point.x - (self.frame.size.width / 2)) / ((self.frame.size.width / 2) - _stick.frame.size.width / 2);
  else
    return 0;
}

- (void)_animateStickToCenter {
  [UIView beginAnimations:nil context:nil];
	[UIView setAnimationCurve:UIViewAnimationCurveLinear];
	[UIView setAnimationDuration:0.1];
  [self _setJoystickCenter:CGPointMake(self.frame.size.width / 2, self.frame.size.height / 2)];
	[UIView commitAnimations];
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
  NSArray *touchesArray = [touches allObjects];
  CGPoint point = [[touchesArray objectAtIndex:0] locationInView:self];
  Debug(@"Touches Began x:%f y:%f", point.x, point.y);
  point = [self _boundPointToViewSize:point];
  double horizontalPosition = [self _horizontalPositionFromPoint:point];
  double verticalPosition = [self _verticalPostionFromPoint:point];
  [_delegate touchJoystickView:self didMoveToHorizontalPosition:horizontalPosition verticalPosition:verticalPosition];
  [self _setJoystickCenter:point];
}

- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event {
  Debug(@"Touches Cancelled");
  // Inform delegate that we're moving back to the center
  [_delegate touchJoystickView:self didMoveToHorizontalPosition:0 verticalPosition:0];
  // Animate sticks back to the center
  [self _animateStickToCenter];
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
  Debug(@"Touches Ended");
  // Inform delegate that we're moving back to the center
  [_delegate touchJoystickView:self didMoveToHorizontalPosition:0 verticalPosition:0];
  // Animate sticks back to the center
  [self _animateStickToCenter];
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
  NSArray *touchesArray = [touches allObjects];
  CGPoint point = [[touchesArray objectAtIndex:0] locationInView:self];
  Debug(@"Touches Moved x:%f y:%f", point.x, point.y);
  point = [self _boundPointToViewSize:point];
  double horizontalPosition = [self _horizontalPositionFromPoint:point];
  double verticalPosition = [self _verticalPostionFromPoint:point];
  // TODO(johnb): It would be efficient to find out if the position really did
  // change for the axis we are interested in (if we are only using one axis)
  [_delegate touchJoystickView:self didMoveToHorizontalPosition:horizontalPosition verticalPosition:verticalPosition];
  [self _setJoystickCenter:point];
}


@end
