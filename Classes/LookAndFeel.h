//
//  LookAndFeel.h
//  Steer
//
//  Created by John Boiles on 3/8/10.
//  Copyright 2010. All rights reserved.
//

@interface LookAndFeel : NSObject {
}

+ (UIButton *)configButtonWithFrame:(CGRect)frame title:(NSString *)title target:(id)target action:(SEL)action;

+ (UILabel *)configLabelWithFrame:(CGRect)frame text:(NSString *)text;

+ (UITextField *)configTextViewWithFrame:(CGRect)frame text:(NSString *)text delegate:(id<UITextFieldDelegate>)delegate;

+ (UISlider *)configSliderWithFrame:(CGRect)frame target:(id)target action:(SEL)action;

+ (UIButton *)closeButtonWithCenter:(CGPoint)center target:(id)target action:(SEL)action;

@end
