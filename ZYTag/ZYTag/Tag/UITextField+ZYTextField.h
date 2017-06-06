//
//  UITextField+ZYTextField.h
//  dajiaochong
//
//  Created by ZhouYong on 2017/4/23.
//  Copyright © 2017年 kidstone. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol ZYTextFieldDelegate <UITextFieldDelegate>

@optional
- (void)textFieldDidDeleteBackward:(UITextField *)textField;

@end


@interface UITextField (ZYTextField)

@property (nonatomic, weak) id<ZYTextFieldDelegate> delegate;

@end
/**
 *  监听删除按钮
 *  object:UITextField
 */
extern NSString * const ZYTextFieldDidDeleteBackwardNotification;



