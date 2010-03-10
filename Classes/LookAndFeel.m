//
//  LookAndFeel.m
//  Steer
//
//  Created by John Boiles on 3/8/10.
//  Copyright 2010 Yelp. All rights reserved.
//

#import "LookAndFeel.h"


@implementation LookAndFeel

+ (UIButton *)configButtonWithFrame:(CGRect)frame title:(NSString *)title target:(id)target action:(SEL)action {
  UIButton *button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
  button.frame = frame;
  [button setTitle:title forState:UIControlStateNormal];
  [button addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
  return button;
}

+ (UILabel *)configLabelWithFrame:(CGRect)frame text:(NSString *)text {
  UILabel *label = [[[UILabel alloc] initWithFrame:frame] autorelease];
  label.text = text;
  label.textColor = [UIColor blackColor];
  label.shadowColor = [UIColor whiteColor];
  label.shadowOffset = CGSizeMake(0, 1);
  label.backgroundColor = [UIColor clearColor];
  label.textAlignment = UITextAlignmentLeft;
  return label;
}

+ (UITextField *)configTextViewWithFrame:(CGRect)frame text:(NSString *)text delegate:(id<UITextFieldDelegate>)delegate {
  UITextField *textView = [[[UITextField alloc] initWithFrame:frame] autorelease];
  textView.text = text;
  textView.borderStyle = UITextBorderStyleRoundedRect;
  textView.enablesReturnKeyAutomatically = YES;
  textView.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
  textView.delegate = delegate;
  return textView;
}

+ (UISlider *)configSliderWithFrame:(CGRect)frame target:(id)target action:(SEL)action {
  UISlider *slider = [[[UISlider alloc ] initWithFrame:frame] autorelease];
  slider.continuous = YES;
  //[slider addTarget:target action:action forControlEvents:UIControlEventValueChanged];
  [slider addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
  return slider;
}

+ (UIButton *)closeButtonWithCenter:(CGPoint)center target:(id)target action:(SEL)action {
  UIButton *stopButton = [UIButton buttonWithType:UIButtonTypeCustom];
  [stopButton setBackgroundImage:[UIImage imageNamed:@"x.png"] forState:UIControlStateNormal];
  stopButton.frame = CGRectMake(center.x - 20, center.y - 20, 40, 40);
  [stopButton addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
  return stopButton; 
}
  
@end
