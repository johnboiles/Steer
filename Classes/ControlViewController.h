//
//  ControlViewController.h
//  Steer
//
//  Created by John Boiles on 3/7/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "CarControl.h"

@class ControlViewController;

@protocol ControlViewControllerDelegate <NSObject>
- (void)controlViewControllerShouldClose:(ControlViewController *)controlViewController;
@end

@interface ControlViewController : UIViewController {
  CarControl *_carControl;
  id<ControlViewControllerDelegate> _delegate;
}

@property (assign, nonatomic) id<ControlViewControllerDelegate> delegate;

- (void)setSteering:(double)steering power:(double)power;

@end
