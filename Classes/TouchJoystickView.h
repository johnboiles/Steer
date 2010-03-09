//
//  TouchJoystickView.h
//  Steer
//
//  Created by John Boiles on 3/6/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

@class TouchJoystickView;

@protocol TouchJoystickViewDelegate
- (void)touchJoystickView:(TouchJoystickView *)TouchJoystickView didMoveToHorizontalPosition:(double)horizontalPosition verticalPosition:(double)verticalPosition;
@end

@interface TouchJoystickView : UIView {
  id<TouchJoystickViewDelegate> _delegate; // Weak
  UIView *_stick;
  BOOL _horizontalAxis;
  BOOL _verticalAxis;  
}

@property (assign, nonatomic) id<TouchJoystickViewDelegate> delegate;
@property (assign, nonatomic) BOOL horizontalAxis;
@property (assign, nonatomic) BOOL verticalAxis;

- (id)initWithFrame:(CGRect)frame delegate:(id<TouchJoystickViewDelegate>)delegate;

@end
