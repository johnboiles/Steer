//
//  AccelerometerView.h
//  Steer
//
//  Created by John Boiles on 3/7/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

// NOTE: this is because for some reason AccelerometerViewController wasn't intercepting
// touch events when created as a modal view controller ??
@protocol AccelerometerViewDelegate
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event;
- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event;
- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event;
@end

@interface AccelerometerView : UIView {
  id<AccelerometerViewDelegate> _delegate; // Weak
  UIView *_steeringIndicatorView;
  UIView *_powerIndicatorView;
}

@property (assign, nonatomic) id<AccelerometerViewDelegate> delegate;

- (void)setIndicatorsSteering:(double)steering power:(double)power animated:(BOOL)animated;

@end
