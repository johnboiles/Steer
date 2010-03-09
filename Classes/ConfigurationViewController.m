//
//  ConfigurationViewController.m
//  Steer
//
//  Created by John Boiles on 3/8/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "ControlViewController.h"
#import "ConfigurationViewController.h"

@implementation ConfigurationViewController

 // The designated initializer.  Override if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
- (id)init {
  if (self = [super init]) {
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWasShown:)
                                                 name:UIKeyboardDidShowNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWasHidden:)
                                                 name:UIKeyboardDidHideNotification object:nil];
  }
  return self;
}

- (void)dealloc {
  //[_scrollView release];
  [super dealloc];
}

// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView {
  [super loadView];
  self.view.backgroundColor = [UIColor groupTableViewBackgroundColor];
  
  _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, 320, 480)];
  _scrollView.backgroundColor = [UIColor groupTableViewBackgroundColor];
  _scrollView.clipsToBounds = YES;
  _scrollView.scrollEnabled = YES;
  _scrollView.bounces = YES;
  
  [self.view addSubview:_scrollView];
  //[scrollView release];
}

// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark keyboard

- (void)keyboardWasShown:(NSNotification*)aNotification
{
  if (_keyboardShown)
    return;
  
  NSDictionary* info = [aNotification userInfo];
  
  // Get the size of the keyboard.
  NSValue* aValue = [info objectForKey:UIKeyboardBoundsUserInfoKey];
  CGSize keyboardSize = [aValue CGRectValue].size;
  
  // Resize the scroll view (which is the root view of the window)
  CGRect viewFrame = [_scrollView frame];
  viewFrame.size.height -= keyboardSize.height;
  _scrollView.frame = viewFrame;
 
  _keyboardShown = YES;
}


// Called when the UIKeyboardDidHideNotification is sent
- (void)keyboardWasHidden:(NSNotification*)aNotification
{
  NSDictionary* info = [aNotification userInfo];
  
  // Get the size of the keyboard.
  NSValue* aValue = [info objectForKey:UIKeyboardBoundsUserInfoKey];
  CGSize keyboardSize = [aValue CGRectValue].size;
  
  // Reset the height of the scroll view to its original value
  CGRect viewFrame = [_scrollView frame];
  viewFrame.size.height += keyboardSize.height;
  _scrollView.frame = viewFrame;
  
  _keyboardShown = NO;
}

@end
