//
//  ConfigurationViewController.h
//  Steer
//
//  Created by John Boiles on 3/8/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

@interface ConfigurationViewController : UIViewController <UITextFieldDelegate> {
  UIScrollView *_scrollView;
  BOOL _keyboardShown;
}

// User can override to perform actions when the keyboard is shown
- (void)keyboardWasShown:(NSNotification*)aNotification;

@end
